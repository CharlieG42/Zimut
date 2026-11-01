#!/usr/bin/env python3
"""clean_enclosed_white.py — retire le fond blanc resté enfermé dans la silhouette d'un sprite
(entre un bras et le torse, entre les jambes…) : le détourage par le bord ne l'atteignait pas.

Règle : composante connexe de pixels quasi blancs purs (min RVB >= 252, quasi gris pur), d'au moins
MIN_PX pixels (les yeux et reflets sont plus petits), rendue transparente ; le liseré clair de
1-2 px qui la borde est retiré aussi. Usage : python3 tools/clean_enclosed_white.py [--apply] dossier...
"""
import sys, glob, os
import numpy as np
from PIL import Image
from scipy import ndimage as ndi

MIN_PX = 260


def clean(path, apply):
    im = Image.open(path).convert("RGBA")
    a = np.array(im)
    op = a[..., 3] > 128
    mn = a[..., :3].min(axis=2).astype(int)
    mx = a[..., :3].max(axis=2).astype(int)
    white = op & (mn >= 252) & ((mx - mn) <= 3)
    lab, k = ndi.label(white)
    kill = np.zeros_like(white)
    sizes = ndi.sum(white, lab, range(1, k + 1)) if k else []
    for i, s in enumerate(sizes, start=1):
        if s >= MIN_PX:
            kill |= lab == i
    if not kill.any():
        return 0
    # liseré clair adjacent
    near = ndi.binary_dilation(kill, iterations=2)
    light = op & (mn >= 205) & ((mx - mn) <= 40)
    kill |= near & light
    n = int(kill.sum())
    if apply:
        a[kill, 3] = 0
        Image.fromarray(a).save(path)
    return n


if __name__ == "__main__":
    apply = "--apply" in sys.argv
    for d in [x for x in sys.argv[1:] if not x.startswith("--")]:
        for p in sorted(glob.glob(os.path.join(d, "*.png"))):
            n = clean(p, apply)
            if n:
                print(f"{p}: {n} px")
