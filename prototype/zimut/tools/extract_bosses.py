#!/usr/bin/env python3
"""extract_bosses.py — découpe la planche « Boss des Nations » (assets/sprites/_sheets/planche_boss.png)
en 9 sprites détourés : assets/sprites/nations/boss/<nation>.png.

Chaque carte contient un décor, une étiquette « Nation … » en haut à gauche et une plaque avec le nom en
bas : ces deux zones sont masquées avant détourage (rembg, modèle isnet-general-use), puis on ne garde
que le plus gros morceau et on recadre.
Usage : python3 tools/extract_bosses.py [--preview apercu.png] [--model isnet-general-use]
"""
import os, sys
import numpy as np
from PIL import Image

HERE = os.path.dirname(os.path.abspath(__file__))
SPRITES = os.path.join(HERE, "..", "assets", "sprites")
SHEET = os.path.join(SPRITES, "_sheets", "planche_boss.png")
OUT = os.path.join(SPRITES, "nations", "boss")

# nation -> (x0, y0, x1, y1) de la carte dans la planche 1536x1024
CARDS = {
    "cimes": (18, 64, 504, 352), "ombres": (522, 64, 1012, 352), "brasier": (1030, 64, 1518, 352),
    "cristaux": (18, 370, 504, 664), "sylvestre": (522, 370, 1012, 664), "marees": (1030, 370, 1518, 664),
    "brumes": (18, 684, 504, 992), "sables": (522, 684, 1012, 992), "vents": (1030, 684, 1518, 992),
}
TAG_H = 38        # hauteur de l'étiquette « Nation … » (haut de la carte)
TAG_W = 330       # largeur de l'étiquette
PLATE_H = 40      # hauteur de la plaque du nom (bas de la carte)
PLATE_X = (130, 370)   # étendue horizontale de la plaque (relative à la carte)
HARD_LO, HARD_HI = 70.0, 170.0
# Cartes détourées par GrabCut (fond trop proche du personnage pour rembg) : rect du personnage
# dans la carte (x0, y0, x1, y1).
GRABCUT = {"cristaux": (88, 22, 392, 262)}


def grabcut(card, rect, k):
    import cv2
    big = card.resize((card.width * k, card.height * k), Image.LANCZOS)
    img = cv2.cvtColor(np.array(big), cv2.COLOR_RGB2BGR)
    mask = np.full(img.shape[:2], cv2.GC_BGD, np.uint8)
    x0, y0, x1, y1 = [v * k for v in rect]
    mask[y0:y1, x0:x1] = cv2.GC_PR_FGD
    # coeur sûr : le torse
    cx, cy = (x0 + x1) // 2, (y0 + y1) // 2
    mask[cy - 30 * k: cy + 40 * k, cx - 22 * k: cx + 22 * k] = cv2.GC_FGD
    cv2.grabCut(img, mask, None, np.zeros((1, 65)), np.zeros((1, 65)), 10, cv2.GC_INIT_WITH_MASK)
    fg = ((mask == cv2.GC_FGD) | (mask == cv2.GC_PR_FGD)).astype(np.uint8)
    fg = cv2.morphologyEx(fg, cv2.MORPH_OPEN, np.ones((3, 3), np.uint8))
    fg = cv2.GaussianBlur(fg.astype(np.float32) * 255.0, (3, 3), 0)
    return Image.fromarray(np.dstack([np.array(big), fg.astype(np.uint8)]), "RGBA")   # durcissement de l'alpha (sous LO : transparent, au-dessus de HI : opaque)


def tighten(img):
    a = np.array(img)
    al = a[:, :, 3]
    import cv2
    n, lab, st, _ = cv2.connectedComponentsWithStats((al > 40).astype(np.uint8), connectivity=8)
    if n <= 1:
        return img
    keep = 1 + int(np.argmax(st[1:, cv2.CC_STAT_AREA]))
    # garde aussi les morceaux importants (arme détachée, aile...) : >= 3 % du plus gros
    big = st[keep, cv2.CC_STAT_AREA]
    mask = np.zeros_like(al, bool)
    for i in range(1, n):
        if st[i, cv2.CC_STAT_AREA] >= big * 0.03:
            mask |= lab == i
    a[:, :, 3] = np.where(mask, al, 0)
    ys, xs = np.where(mask)
    pad = 3
    return Image.fromarray(a[max(0, ys.min() - pad):ys.max() + pad + 1, max(0, xs.min() - pad):xs.max() + pad + 1], "RGBA")


def main():
    model = sys.argv[sys.argv.index("--model") + 1] if "--model" in sys.argv else "isnet-general-use"
    preview = sys.argv[sys.argv.index("--preview") + 1] if "--preview" in sys.argv else ""
    from rembg import new_session, remove
    sess = new_session(model)
    sheet = Image.open(SHEET).convert("RGB")
    os.makedirs(OUT, exist_ok=True)
    results = {}
    for nation, box in CARDS.items():
        card = sheet.crop(box)
        w, h = card.size
        k = int(os.environ.get("BOSS_K", 2))
        big = card.resize((w * k, h * k), Image.LANCZOS)
        out = grabcut(card, GRABCUT[nation], k) if nation in GRABCUT else remove(big, session=sess)
        a = np.array(out)
        # efface l'étiquette et la plaque (graphismes de l'interface de la planche)
        a[: TAG_H * k, : TAG_W * k, 3] = 0
        a[: 70 * k, : 64 * k, 3] = 0           # pastille ronde de la nation
        a[(h - PLATE_H) * k:, PLATE_X[0] * k: PLATE_X[1] * k, 3] = 0
        # alpha durci : supprime les zones fantômes semi-transparentes laissées par le modèle
        al = a[:, :, 3].astype(np.float32)
        al = np.clip((al - HARD_LO) / (HARD_HI - HARD_LO), 0.0, 1.0) * 255.0
        # fondu doux au-dessus de la plaque (le bas du corps y est caché sur la planche)
        y_cut = (h - PLATE_H) * k
        ramp = 16 * k
        for i in range(ramp):
            y = y_cut - ramp + i
            if 0 <= y < al.shape[0]:
                al[y, PLATE_X[0] * k: PLATE_X[1] * k] *= 1.0 - (i + 1) / (ramp + 1)
        a[:, :, 3] = al.astype(np.uint8)
        sp = tighten(Image.fromarray(a, "RGBA"))
        # taille de travail : hauteur max 360 px (netteté suffisante, poids raisonnable)
        if sp.height > 360:
            f = 360.0 / sp.height
            sp = sp.resize((round(sp.width * f), 360), Image.LANCZOS)
        sp.save(os.path.join(OUT, nation + ".png"))
        results[nation] = sp
        print(nation, sp.size)
    if preview:
        W = 3 * 330
        sheet_out = Image.new("RGBA", (W, 3 * 380), (60, 70, 90, 255))
        for i, (n, sp) in enumerate(results.items()):
            tile = Image.new("RGBA", (330, 380), (60, 70, 90, 255))
            t = sp.copy()
            t.thumbnail((320, 370))
            tile.alpha_composite(t, ((330 - t.width) // 2, 380 - t.height - 5))
            sheet_out.alpha_composite(tile, ((i % 3) * 330, (i // 3) * 380))
        sheet_out.save(preview)


if __name__ == "__main__":
    main()
