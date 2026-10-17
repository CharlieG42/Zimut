#!/usr/bin/env python3
"""extract_sheet_sprites.py — Découpe la planche « Héros / Familiers / Ennemis par Nation »
(assets/sprites/_sheets/planche_nations.png) en sprites PNG détourés (fond transparent).

Usage : python3 tools/extract_sheet_sprites.py [--only heros|familiers|ennemis] [--model isnet-general-use]
                                              [--preview apercu.png]

Dépendances : pip install "rembg[cpu]" opencv-python-headless pillow numpy
  (rembg télécharge une fois les modèles isnet-general-use / isnet-anime, ~180 Mo chacun)

Détourage : par défaut le modèle `isnet-general-use` ; le Mage, le Sylvain, la Heal, le Druide et
le Géomancien, dont le fond ressemble trop au personnage, passent par GrabCut (voir GRABCUT).
Les familiers sont nettoyés des halos gris semi-transparents laissés par le modèle (HALO).

Sorties (sous assets/sprites/) :
  nations/heros/<classe>.png        9 héros (Tank … Géomancien)
  familiers/<nom>.png               9 familiers (ex-« invocations »)
  nations/ennemis/<nation>/<nom>.png 36 ennemis par nation
Les cadres ci-dessous sont des zones larges autour de chaque sprite (sans les étiquettes
de texte) ; le détourage et le recadrage serré sont automatiques. Pour une nouvelle
planche, ajuster uniquement les listes de cadres.
"""
import os
import sys

import numpy as np
from PIL import Image

HERE = os.path.dirname(os.path.abspath(__file__))
SPRITES = os.path.join(HERE, "..", "assets", "sprites")
SHEET = os.path.join(SPRITES, "_sheets", "planche_nations.png")

# (nom de fichier, x0, y0, x1, y1) dans la planche 1536×1024
HEROS = [
    ("tank", 12, 98, 194, 390), ("assassin", 204, 98, 387, 390), ("chasseur", 396, 98, 567, 390),
    ("mage", 577, 98, 753, 390), ("druide", 763, 98, 926, 390), ("heal", 937, 98, 1113, 390),
    ("invocateur", 1124, 98, 1278, 390), ("sylvain", 1286, 98, 1402, 390), ("geomancien", 1410, 98, 1528, 390),
]
FAMILIERS = [
    ("golem_de_pierre", 14, 418, 196, 562), ("loup_spectral", 204, 418, 386, 562),
    ("archer_sylvestre", 395, 418, 551, 562), ("elementaire_de_cristal", 561, 418, 741, 562),
    ("esprit_de_la_foret", 750, 418, 916, 562), ("requin_des_marees", 924, 418, 1099, 562),
    ("ombre_invoquee", 1108, 418, 1231, 562), ("ent_de_combat", 1243, 418, 1369, 562),
    ("sentinelle_de_gres", 1378, 418, 1524, 562),
]
# nation -> liste (nom, x0, y0, x1, y1)
ENNEMIS = {
    "cimes": [("rochebrute", 20, 668, 150, 752), ("guerrier_des_monts", 160, 668, 305, 752),
              ("griffon_des_cimes", 20, 764, 160, 842), ("garde_des_pics", 165, 764, 305, 842)],
    "ombres": [("assassin_des_ombres", 338, 668, 462, 754), ("spectre", 468, 668, 612, 754),
               ("liche", 338, 764, 462, 842), ("ombre_infernale", 468, 764, 612, 842)],
    "sylvestre": [("loup_forestier", 640, 668, 765, 754), ("araknea", 772, 668, 900, 754),
                  ("dryade", 640, 764, 765, 842), ("treant", 772, 764, 900, 842)],
    "cristaux": [("golem_de_cristal", 925, 668, 1065, 754), ("mage_cristallin", 1070, 668, 1210, 754),
                 ("elementaire_de_cristal", 925, 764, 1065, 842), ("araignee_de_cristal", 1070, 764, 1210, 842)],
    "sables": [("scarabee_geant", 1236, 668, 1372, 754), ("bandit_des_dunes", 1378, 668, 1518, 754),
               ("genie_du_desert", 1236, 764, 1372, 842), ("sphinx", 1378, 764, 1518, 842)],
    "vents": [("harpie", 18, 896, 118, 982), ("aigle_celeste", 120, 896, 200, 982),
              ("garde_aerien", 202, 896, 272, 982), ("elementaire_de_vent", 274, 896, 360, 982)],
    "marees": [("crabe_geant", 392, 896, 492, 982), ("nereide", 494, 896, 566, 982),
               ("requin", 566, 896, 660, 982), ("pirate_des_mers", 662, 896, 750, 982)],
    "brasier": [("salamandre", 780, 896, 878, 982), ("devoreur_de_flammes", 880, 896, 966, 982),
                ("golem_de_lave", 970, 896, 1062, 982), ("lieutenant", 1066, 896, 1150, 982)],
    "brumes": [("brumeux", 1176, 896, 1258, 982), ("liche_des_brumes", 1260, 896, 1340, 982),
               ("fantome", 1360, 896, 1432, 982), ("gargouille", 1430, 896, 1512, 982)],
}


# Modèle rembg propre à certains sprites (le défaut convient aux autres).
MODEL_OVERRIDE = {}

# Sprites détourés par GrabCut (cv2) : nom -> (rect du personnage, zone de premier plan sûr, coupe)
# coordonnées relatives au cadre. `cut` = (x, y) : efface la zone à droite de x et au-dessus de y
# (cristal flottant voisin du personnage).
GRABCUT = {
    "druide": {"rect": (5, 8, 158, 284), "seed": None, "cut": None},
    "mage": {"rect": (6, 6, 170, 284), "seed": None, "cut": None},
    "sylvain": {"rect": (8, 6, 110, 284), "seed": None, "cut": None},
    "heal": {"rect": (6, 6, 170, 284), "seed": None, "cut": None},
    "geomancien": {"rect": (8, 8, 112, 284), "seed": (42, 30, 92, 60), "cut": (84, 50)},
}


def components(mask: np.ndarray):
    """Composantes connexes (8-voisins) d'un masque booléen — sans scipy."""
    h, w = mask.shape
    lab = np.zeros((h, w), dtype=np.int32)
    n = 0
    for y in range(h):
        for x in range(w):
            if mask[y, x] and lab[y, x] == 0:
                n += 1
                stack = [(y, x)]
                lab[y, x] = n
                while stack:
                    cy, cx = stack.pop()
                    for dy in (-1, 0, 1):
                        for dx in (-1, 0, 1):
                            ny, nx = cy + dy, cx + dx
                            if 0 <= ny < h and 0 <= nx < w and mask[ny, nx] and lab[ny, nx] == 0:
                                lab[ny, nx] = n
                                stack.append((ny, nx))
    return lab, n


def grabcut(crop: Image.Image, cfg: dict) -> Image.Image:
    import cv2
    k = 3
    big = crop.resize((crop.width * k, crop.height * k), Image.LANCZOS)
    a = cv2.cvtColor(np.array(big), cv2.COLOR_RGB2BGR)
    h, w = a.shape[:2]
    mask = np.full((h, w), cv2.GC_PR_BGD, np.uint8)
    x0, y0, x1, y1 = [int(v * k) for v in cfg["rect"]]
    mask[y0:y1, x0:x1] = cv2.GC_PR_FGD
    if cfg.get("seed"):
        sx0, sy0, sx1, sy1 = [int(v * k) for v in cfg["seed"]]
        mask[sy0:sy1, sx0:sx1] = cv2.GC_FGD
    m = 6 * k
    mask[:m, :] = cv2.GC_BGD
    mask[:, :m] = cv2.GC_BGD
    mask[:, w - m:] = cv2.GC_BGD
    cv2.grabCut(a, mask, None, np.zeros((1, 65)), np.zeros((1, 65)), 8, cv2.GC_INIT_WITH_MASK)
    fg = ((mask == cv2.GC_FGD) | (mask == cv2.GC_PR_FGD)).astype(np.uint8)
    if cfg.get("cut"):
        cx, cy = cfg["cut"]
        fg[: int(cy * k), int(cx * k):] = 0
    n, lab, st, _ = cv2.connectedComponentsWithStats(fg)
    keep = 1 + int(np.argmax(st[1:, cv2.CC_STAT_AREA]))
    fg = (lab == keep).astype(np.uint8)
    fg = cv2.morphologyEx(fg, cv2.MORPH_CLOSE, np.ones((5, 5), np.uint8))
    rgba = np.dstack([np.array(big), fg * 255]).astype(np.uint8)
    return Image.fromarray(rgba, "RGBA").resize(crop.size, Image.LANCZOS)


def cut(sheet: Image.Image, session, box, min_part: float = 0.04, name: str = "") -> Image.Image:
    from rembg import remove
    crop = sheet.crop(box)
    if name in GRABCUT:
        out = grabcut(crop, GRABCUT[name])
        return tighten(out)
    # Petit agrandissement : le modèle détoure mieux les sprites minuscules.
    scale = 3 if crop.width < 160 else 1
    big = crop.resize((crop.width * scale, crop.height * scale), Image.LANCZOS) if scale > 1 else crop
    out = remove(big, session=session)
    if scale > 1:
        out = out.resize(crop.size, Image.LANCZOS)
    return tighten(out, min_part)


def defringe(out: Image.Image) -> Image.Image:
    """Retire les halos gris/ternes semi-transparents (restes d'ombre du fond d'origine)."""
    a = np.array(out).astype(np.int32)
    r, g, b, al = a[:, :, 0], a[:, :, 1], a[:, :, 2], a[:, :, 3]
    sat = a[:, :, :3].max(axis=2) - a[:, :, :3].min(axis=2)
    ghost = (al < 200) & (sat < 38)
    a[:, :, 3] = np.where(ghost, 0, al)
    # les pixels semi-transparents restants deviennent plus nets
    a[:, :, 3] = np.where(a[:, :, 3] < 90, 0, a[:, :, 3])
    return Image.fromarray(a.astype(np.uint8), "RGBA")


def tighten(out: Image.Image, min_part: float = 0.04) -> Image.Image:
    """Ne garde que les morceaux significatifs (retire poussières et étiquettes) et recadre."""
    a = np.array(out)
    alpha = a[:, :, 3]
    lab, n = components(alpha > 40)
    if n == 0:
        return out
    areas = np.bincount(lab.ravel())[1:]
    keep = [i + 1 for i, ar in enumerate(areas) if ar >= areas.max() * min_part]
    mask = np.isin(lab, keep)
    a[:, :, 3] = np.where(mask, alpha, 0)
    ys, xs = np.where(mask)
    pad = 3
    x0, x1 = max(0, xs.min() - pad), min(a.shape[1], xs.max() + pad + 1)
    y0, y1 = max(0, ys.min() - pad), min(a.shape[0], ys.max() + pad + 1)
    return Image.fromarray(a[y0:y1, x0:x1], "RGBA")


def main() -> None:
    model = sys.argv[sys.argv.index("--model") + 1] if "--model" in sys.argv else "isnet-general-use"
    only = sys.argv[sys.argv.index("--only") + 1] if "--only" in sys.argv else ""
    preview = sys.argv[sys.argv.index("--preview") + 1] if "--preview" in sys.argv else ""
    from rembg import new_session
    sessions = {model: new_session(model)}
    sheet = Image.open(SHEET).convert("RGB")
    done = []
    jobs = []
    if only in ("", "heros"):
        jobs += [(os.path.join("nations", "heros"), n, b) for n, *b in HEROS]
    if only in ("", "familiers"):
        jobs += [("familiers", n, b) for n, *b in FAMILIERS]
    if only in ("", "ennemis"):
        for nation, lst in ENNEMIS.items():
            jobs += [(os.path.join("nations", "ennemis", nation), n, b) for n, *b in lst]
    for folder, name, box in jobs:
        d = os.path.join(SPRITES, folder)
        os.makedirs(d, exist_ok=True)
        use = MODEL_OVERRIDE.get(name, model) if "--model" not in sys.argv else model
        if use not in sessions:
            sessions[use] = new_session(use)
        img = cut(sheet, sessions[use], tuple(box), name=name)
        if folder == "familiers":
            img = tighten(defringe(img))
        img.save(os.path.join(d, name + ".png"))
        done.append((folder, name, img))
        print("  %s/%s  %dx%d" % (folder, name, img.width, img.height))
    if preview:
        cell = 170
        cols = 10
        rows = (len(done) + cols - 1) // cols
        sheet_out = Image.new("RGBA", (cols * cell, rows * cell), (96, 110, 120, 255))
        for i, (_, _, im) in enumerate(done):
            t = im.copy()
            t.thumbnail((cell - 10, cell - 10))
            sheet_out.alpha_composite(t, ((i % cols) * cell + 5, (i // cols) * cell + 5))
        sheet_out.save(preview)
    print("%d sprites" % len(done))


if __name__ == "__main__":
    main()
