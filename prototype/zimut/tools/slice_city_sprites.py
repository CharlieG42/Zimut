#!/usr/bin/env python3
"""Détoure et découpe les planches de bâtiments (Mistral) en PNG transparents pour la vue de ville.

Usage : python3 tools/slice_city_sprites.py <dossier des planches p01.jpg … p16.jpg> [--only sylvestre|cimes]

Sortie : assets/ui/conquest/cities/batiments/<nation>/<bâtiment>[_<niveau>].png
(convention : assets/ui/conquest/cities/batiments/README.md).

Chaque planche est repérée par un numéro (p01 … p16, ordre d'envoi). MANIFEST dit quelle partie
de quelle planche devient quel bâtiment : changer une ligne puis relancer suffit pour réaffecter
un sprite. Les niveaux d'un même bâtiment partagent une toile commune (pied centré en bas), ce qui
conserve leur taille relative : le jeu fixe la largeur de la toile, pas celle du dessin.
"""
import argparse
import os
import sys

import numpy as np
from PIL import Image
from scipy import ndimage as ndi

OUT_ROOT = os.path.join(os.path.dirname(__file__), "..", "assets", "ui", "conquest", "cities", "batiments")
# Largeur (px) de la toile de chaque bâtiment : même poids visuel d'une nation à l'autre, et assez
# petit pour l'APK. Le jeu fixe la largeur affichée (ConquestCityView.SPRITE_WIDTH ≈ 0,4 × ces valeurs).
TARGET_W = {"hall": 520, "caserne": 440, "residence": 420, "merveille": 480, "scierie": 420,
            "mine": 400, "tannerie": 360, "cabane": 300, "verger": 400, "muraille": 560}

# (planche, nation, fichier, découpe) — découpe : ("g", n) = n-ième ensemble détecté (de gauche à droite,
# 0 = premier) ; ("box", x0, y0, x1, y1) = rectangle dans la planche (après suppression des barres noires) ;
# ("c", k, (x1, x2…)) = k-ième bande verticale, coupures placées au plus vide près des indications ;
# ("all",) = tout ce qui est détouré.
MANIFEST = [
    # ── Forêt (nation « sylvestre », planches estivales) ──
    ("p09", "sylvestre", "hall_1", ("all",)),
    ("p01", "sylvestre", "caserne", ("g", 0)),
    ("p01", "sylvestre", "residence", ("g", 1)),
    ("p02", "sylvestre", "scierie_1", ("all",)),
    ("p03", "sylvestre", "mine_1", ("all",)),
    ("p04", "sylvestre", "tannerie_1", ("g", 0)),
    ("p04", "sylvestre", "tannerie_2", ("g", 1)),
    ("p04", "sylvestre", "tannerie_3", ("g", 2)),
    ("p05", "sylvestre", "cabane_1", ("c", 0, (430, 695))),
    ("p05", "sylvestre", "cabane_2", ("c", 1, (430, 695))),
    ("p05", "sylvestre", "cabane_3", ("c", 2, (430, 695))),
    ("p06", "sylvestre", "verger_1", ("box", 0, 430, 350, 725)),
    ("p06", "sylvestre", "verger_2", ("box", 350, 430, 760, 725)),
    ("p06", "sylvestre", "verger_3", ("box", 0, 40, 1024, 445)),
    ("p07", "sylvestre", "muraille_1", ("box", 0, 0, 1024, 250)),
    ("p07", "sylvestre", "muraille_3", ("box", 0, 268, 1024, 502)),
    ("p08", "sylvestre", "merveille", ("all",)),
    # ── Montagne (nation « cimes », planches hivernales) ──
    ("p10", "cimes", "hall_1", ("c", 0, (235, 430, 640))),
    ("p10", "cimes", "hall_2", ("c", 1, (235, 430, 640))),
    ("p10", "cimes", "hall_3", ("c", 2, (235, 430, 640))),
    ("p10", "cimes", "hall_4", ("c", 3, (235, 430, 640))),
    ("p11", "cimes", "hall_5", ("g", 0)),
    ("p13", "cimes", "caserne", ("all",)),
    ("p11", "cimes", "residence", ("g", 1)),
    ("p12", "cimes", "scierie_1", ("g", 0)),
    ("p12", "cimes", "mine_1", ("g", 2)),
    ("p14", "cimes", "tannerie_1", ("c", 0, (340, 660))),
    ("p14", "cimes", "tannerie_2", ("c", 1, (340, 660))),
    ("p14", "cimes", "tannerie_3", ("c", 2, (340, 660))),
    ("p15", "cimes", "cabane_1", ("g", 0)),
    ("p15", "cimes", "cabane_2", ("g", 1)),
    ("p15", "cimes", "cabane_3", ("g", 2)),
    ("p16", "cimes", "verger_1", ("all",)),
]

# Planches estivales : les îlots blancs entre deux pièces (ombres lessivées) sont supprimés.
SUMMER = {"p%02d" % i for i in range(1, 10)}
# Largeur relative (fraction de la toile) imposée aux niveaux d'un bâtiment dont les dessins de
# départ n'ont pas la même échelle (l'hôtel de ville des Cimes passe du hameau à la forteresse).
GROW = {("cimes", "hall"): {1: 0.50, 2: 0.60, 3: 0.72, 4: 0.86, 5: 1.0}}

# Fichiers dont la toile est partagée avec leurs « frères » (même bâtiment, niveaux différents).
def set_of(name):
    return name.rsplit("_", 1)[0] if name.rsplit("_", 1)[-1].isdigit() else name


def load(path):
    a = np.array(Image.open(path).convert("RGB")).astype(np.int16)
    light = a.mean(axis=2) > 30                      # barres noires de la planche p14
    rows = np.where(light.mean(axis=1) > 0.25)[0]
    cols = np.where(light.mean(axis=0) > 0.25)[0]
    return a[rows[0]:rows[-1] + 1, cols[0]:cols[-1] + 1]


def background(a):
    """Fond blanc ou gris à dégradé relié au bord de l'image."""
    border = np.concatenate([a[0], a[-1], a[:, 0], a[:, -1]])
    med = np.median(border, axis=0)
    sat = a.max(axis=2) - a.min(axis=2)
    if med.min() > 235:
        cand = (np.abs(a - med).max(axis=2) < 26) & (sat < 22)
    else:
        cand = (np.abs(a.mean(axis=2) - med.mean()) < 38) & (sat < 22)
    lab, _ = ndi.label(cand)
    edge = set(np.unique(np.concatenate([lab[0], lab[-1], lab[:, 0], lab[:, -1]]))) - {0}
    return np.isin(lab, list(edge))


def cut_out(a, summer=False, min_blob=100):
    bg = background(a)
    forced = np.zeros_like(bg)
    if summer:      # îlots blancs : très clairs, sans teinte, entourés de fond
        lum = a.mean(axis=2)
        white = (lum > 222) & ((a.max(axis=2) - a.min(axis=2)) < 22)
        lab, n = ndi.label(white)
        big = [i + 1 for i, sz in enumerate(ndi.sum(white, lab, range(1, n + 1))) if sz > min_blob]
        forced = np.isin(lab, big)
        bg = bg | forced
    fg = ndi.binary_opening(~bg, iterations=1)
    lab, n = ndi.label(fg)
    sizes = ndi.sum(fg, lab, range(1, n + 1))
    fg = ndi.binary_fill_holes(np.isin(lab, [i + 1 for i, s in enumerate(sizes) if s > 400])) & ~forced
    alpha = np.clip((ndi.gaussian_filter(fg.astype(np.float32), 0.8) - 0.25) / 0.6, 0, 1)
    rgba = np.dstack([a.clip(0, 255).astype(np.uint8), (alpha * 255).astype(np.uint8)])
    return rgba, fg


def groups(fg):
    lab, _ = ndi.label(ndi.binary_dilation(fg, iterations=5))
    res = []
    for i, sl in enumerate(ndi.find_objects(lab)):
        if (fg[sl] & (lab[sl] == i + 1)).sum() >= 4000:
            res.append((sl[1].start, sl[0].start, sl[1].stop, sl[0].stop))
    return sorted(res)


def main_part(fg, keep_ratio=0.12):
    """Garde les ensembles de pixels assez gros par rapport au plus gros (supprime les débris)."""
    lab, n = ndi.label(ndi.binary_dilation(fg, iterations=4))
    sizes = ndi.sum(fg, lab, range(1, n + 1))
    good = [i + 1 for i, sz in enumerate(sizes) if sz >= keep_ratio * max(sizes)]
    return fg & np.isin(lab, good)


def snap_cuts(fg, hints, window=45):
    """Place chaque coupure verticale là où l'image est la plus vide, près de l'indication."""
    cover = fg.sum(axis=0)
    cuts = []
    for h in hints:
        lo, hi = max(h - window, 1), min(h + window, fg.shape[1] - 1)
        cuts.append(lo + int(np.argmin(cover[lo:hi])))
    return cuts


def crop(rgba, fg, how):
    if how[0] == "c":
        xs = [0] + snap_cuts(fg, how[2]) + [rgba.shape[1]]
        box = (xs[how[1]], 0, xs[how[1] + 1], rgba.shape[0])
    elif how[0] == "all":
        box = (0, 0, rgba.shape[1], rgba.shape[0])
    elif how[0] == "box":
        box = how[1:]
    else:
        box = groups(fg)[how[1]]
    x0, y0, x1, y1 = box
    sub = rgba[y0:y1, x0:x1].copy()
    keep = main_part(sub[..., 3] > 8)
    sub[..., 3] = np.where(keep, sub[..., 3], 0)
    ys, xs = np.where(sub[..., 3] > 8)
    return Image.fromarray(sub[ys.min():ys.max() + 1, xs.min():xs.max() + 1], "RGBA")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("sheets")
    ap.add_argument("--only")
    args = ap.parse_args()
    cache = {}
    pieces = {}      # (nation, fichier) -> image
    for sheet, nation, name, how in MANIFEST:
        if args.only and nation != args.only:
            continue
        if sheet not in cache:
            a = load(os.path.join(args.sheets, sheet + ".jpg"))
            cache[sheet] = cut_out(a, sheet in SUMMER, 12 if sheet == "p07" else 100)
        rgba, fg = cache[sheet]
        pieces[(nation, name)] = crop(rgba, fg, how)
    # Toile commune par (nation, bâtiment) ; hall_x et caserne/résidence restent indépendants.
    sets = {}
    for (nation, name), im in pieces.items():
        sets.setdefault((nation, set_of(name)), []).append((name, im))
    for (nation, base), items in sets.items():
        grow = GROW.get((nation, base))
        if grow:
            wmax = max(im.width for _, im in items)
            items = [(nm, im.resize((round(wmax * grow[int(nm.rsplit("_", 1)[1])]),
                                     round(im.height * wmax * grow[int(nm.rsplit("_", 1)[1])] / im.width)), Image.LANCZOS))
                     for nm, im in items]
        w = max(im.width for _, im in items)
        h = max(im.height for _, im in items)
        k = min(1.25, TARGET_W.get(base, 480) / w)
        for name, im in items:
            canvas = Image.new("RGBA", (w, h), (0, 0, 0, 0))
            canvas.alpha_composite(im, ((w - im.width) // 2, h - im.height))
            if abs(k - 1.0) > 0.01:
                canvas = canvas.resize((round(w * k), round(h * k)), Image.LANCZOS)
            d = os.path.join(OUT_ROOT, nation)
            os.makedirs(d, exist_ok=True)
            canvas.save(os.path.join(d, name + ".png"), optimize=True)
            print("%-10s %-14s %dx%d" % (nation, name, canvas.width, canvas.height))


if __name__ == "__main__":
    sys.exit(main())
