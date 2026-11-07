#!/usr/bin/env python3
"""Génère les décors superposés de la planche v2 « enrichie » de la Sylve (V114).

Ajoute deux clés au JSON d'une planche illustrée (sans jamais toucher au masque,
au départ ni aux POI — la logique de jeu est inchangée) :

  "decor" : { "x,y": kind }   petits décors non bloquants sur cases jouables
                              (grass / flowers / mushrooms, sprites SpriteDecor)
  "over"  : { "x,y": kind }   grands arbres de premier plan sur cases NON jouables,
                              directement au sud d'une case jouable : le y-sort les
                              dessine au-dessus du héros quand il passe au nord
                              (zones d'occlusion testées, cf. SYLVESTRE_VISUEL.md)

Le type de sol de chaque case est lu dans l'illustration elle-même (moyenne RGB
de l'intérieur de la case), pour ne poser des fleurs que sur l'herbe, rien sur
l'eau, etc. Les surfaces PEINTES (bâtiments, toits, murs, zones plates : écart-type
faible) sont exclues : aucun décor ni arbre ne se pose jamais sur un bâtiment.

Usage : python3 tools/gen_sylve_v2_decor.py [foret_sylve_v2]
"""
import json
import random
import sys
from pathlib import Path

import numpy as np
from PIL import Image

ROOT = Path(__file__).resolve().parent.parent
BOARDS = ROOT / "data" / "boards"
SEED = 114

# kind -> poids relatif (petits décors de sol, cf. SpriteDecor.GROUND)
GROUND_KINDS = [("grass", 3), ("flowers", 2), ("mushrooms", 1)]
# grands arbres de premier plan (cf. SpriteDecor.OBSTACLES / SPRITES)
OVER_KINDS = [("big_tree", 4), ("pine", 4), ("tree", 2)]

DECOR_DENSITY = {"grass": 0.30, "shade": 0.38, "other": 0.10, "sand": 0.05,
                 "rock": 0.0, "water": 0.0, "snow": 0.0}
OVER_DENSITY = 0.30
POI_CLEAR_OVER = 3   # distance de Chebyshev minimale entre un arbre "over" et un POI
POI_CLEAR_DECOR = 2  # idem pour les petits décors
START_CLEAR = 2
MIN_STD = 10.0       # en dessous : surface peinte (bâtiment/toit/mur/plat) -> interdit


def classify(px: np.ndarray) -> str:
    r, g, b = px[..., 0].mean(), px[..., 1].mean(), px[..., 2].mean()
    br = (r + g + b) / 3.0
    if b > r + 15 and b > g + 5 and b > 60:
        return "water"
    if r >= g > b and r - b > 35 and r > 120:
        return "sand"
    if abs(r - g) < 18 and abs(g - b) < 18 and 70 < br < 190:
        return "rock"
    if r > 180 and g > 180 and b > 180:
        return "snow"
    if g >= r and g >= b:
        return "grass"
    if br < 70:
        return "shade"
    return "other"


def pick_weighted(rng: random.Random, kinds) -> str:
    total = sum(w for _, w in kinds)
    x = rng.uniform(0, total)
    for k, w in kinds:
        x -= w
        if x <= 0:
            return k
    return kinds[-1][0]


def chebyshev(a, b) -> int:
    return max(abs(a[0] - b[0]), abs(a[1] - b[1]))


def main() -> None:
    name = sys.argv[1] if len(sys.argv) > 1 else "foret_sylve_v2"
    path = BOARDS / (name + ".json")
    d = json.loads(path.read_text(encoding="utf-8"))
    img_path = ROOT / str(d["image"]).replace("res://", "")
    im = np.asarray(Image.open(img_path).convert("RGB")).astype(int)
    C = int(d["cell_px"])
    cols, rows = int(d["cols"]), int(d["rows"])
    mask = d["mask"]
    start = tuple(int(v) for v in d["start"])
    pois = [tuple(int(v) for v in k.split(",")) for k in d.get("pois", {}).keys()]

    rng = random.Random(SEED)
    cls = {}
    std = {}
    for y in range(rows):
        for x in range(cols):
            cell = im[y * C:(y + 1) * C, x * C:(x + 1) * C]
            inner = cell[4:-4, 4:-4]
            cls[(x, y)] = classify(inner)
            std[(x, y)] = float(cell.reshape(-1, 3).std(axis=0).mean())

    def walkable(x, y) -> bool:
        return 0 <= y < rows and 0 <= x < len(mask[y]) and mask[y][x] == "#"

    def near_poi(c, dist) -> bool:
        return any(chebyshev(c, p) <= dist for p in pois)

    decor, over = {}, {}
    for y in range(rows):
        for x in range(cols):
            c = (x, y)
            t = cls[c]
            if std[c] < MIN_STD:
                continue  # surface peinte (bâtiment, toit, mur, plat) : jamais de décor
            if walkable(x, y):
                if near_poi(c, POI_CLEAR_DECOR) or chebyshev(c, start) <= START_CLEAR:
                    continue
                if rng.random() < DECOR_DENSITY.get(t, 0.0):
                    kinds = GROUND_KINDS
                    if t == "shade":  # sous les arbres : plus de champignons
                        kinds = [("grass", 2), ("flowers", 1), ("mushrooms", 3)]
                    decor["%d,%d" % c] = pick_weighted(rng, kinds)
            else:
                # premier plan : case non jouable avec une case jouable juste au nord,
                # et uniquement sur la forêt texturée (jamais sur un bâtiment peint)
                if not walkable(x, y - 1):
                    continue
                if t in ("water", "rock", "snow"):
                    continue  # hors eau/roche/neige ; le garde-fou std ci-dessus exclut les bâtiments peints
                if near_poi(c, POI_CLEAR_OVER) or chebyshev(c, start) <= START_CLEAR:
                    continue
                if rng.random() < OVER_DENSITY:
                    over["%d,%d" % c] = pick_weighted(rng, OVER_KINDS)

    d["decor"] = {k: decor[k] for k in sorted(decor, key=lambda s: tuple(int(v) for v in s.split(",")))}
    d["over"] = {k: over[k] for k in sorted(over, key=lambda s: tuple(int(v) for v in s.split(",")))}
    path.write_text(json.dumps(d, ensure_ascii=False, indent="") + "\n", encoding="utf-8")
    print("%s : %d décors de sol, %d arbres de premier plan (masque et POI inchangés)"
          % (path.name, len(decor), len(over)))


if __name__ == "__main__":
    main()
