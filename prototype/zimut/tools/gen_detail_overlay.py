#!/usr/bin/env python3
"""Génère l'overlay de détails d'une planche (clé "detail") en composant les VRAIS
sprites de décor du jeu (assets/sprites/decor/sylve/) à petite échelle, dispersés
au hasard sur fond transparent. Taille garantie : chaque touffe ~6-28 px (moins d'une
à deux cases de 16 px), style identique aux décors posés en jeu.

Usage : python3 tools/gen_detail_overlay.py <sortie.png> <largeur> <hauteur> [densité 0-1]
"""
import random
import sys
from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parent.parent
DECOR = ROOT / "assets" / "sprites" / "decor" / "sylve"

# sprites de sol adaptés à un overlay de planche (pas les grands arbres)
KINDS = {
    "grass": ["grass1", "grass2", "grass3", "grass4", "grass5", "grass6"],
    "flowers": ["flower_red", "flower_white", "flower_blue", "flower_purple", "flower_yellow", "flower_orange"],
    "mushrooms": ["mushroom1", "mushroom2"],
    "rocks": ["rock3", "rock4", "rock5"],
}
WEIGHTS = {"grass": 5, "flowers": 3, "mushrooms": 2, "rocks": 2}


def main() -> None:
    out, W, H = sys.argv[1], int(sys.argv[2]), int(sys.argv[3])
    density = float(sys.argv[4]) if len(sys.argv) > 4 else 0.10
    rng = random.Random(114)
    canvas = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    # nombre de touffes : densité * surface / taille moyenne d'une touffe (~14x14)
    count = int(density * W * H / (14 * 14))
    kinds = []
    for k, w in WEIGHTS.items():
        kinds += [k] * w
    for _ in range(count):
        kind = rng.choice(kinds)
        name = rng.choice(KINDS[kind])
        tex = Image.open(DECOR / (name + ".png")).convert("RGBA")
        w = rng.uniform(6.0, 26.0)          # px : ~0.4 à 1.6 case de 16 px
        h = w * tex.height / tex.width
        sprite = tex.resize((max(2, int(w)), max(2, int(h))), Image.LANCZOS)
        if rng.random() < 0.5:
            sprite = sprite.transpose(Image.FLIP_LEFT_RIGHT)
        x = rng.randrange(0, max(1, W - sprite.width))
        y = rng.randrange(0, max(1, H - sprite.height))
        canvas.alpha_composite(sprite, (x, y))
    canvas.save(ROOT / out if not out.startswith("/") else out)
    import numpy as np
    a = np.asarray(canvas)[..., 3]
    print("%s : %d touffes, couverture %.1f%%, alpha>128 %.1f%%" % (out, count, 100 * (a > 10).mean(), 100 * (a > 128).mean()))


if __name__ == "__main__":
    main()
