#!/usr/bin/env python3
"""clean_white_bottom.py — retire le fond blanc resté sous/entre les jambes des sprites de héros
(composante de blanc pur touchant le bas de l'image, dans sa partie basse), et, avec --enclosed,
les poches blanches fermées (classes sans vêtement blanc : Chasseur, Assassin).
Usage : python3 tools/clean_white_bottom.py [--enclosed] [--apply] fichier.png...
Ne pas utiliser --enclosed sur Soigneur/Mage/Tank/Sylvain (robes, barbes et cheveux blancs).
"""
import sys
import numpy as np
from PIL import Image
from scipy import ndimage as ndi


def clean(path, enclosed, apply):
    a = np.array(Image.open(path).convert("RGBA"))
    ai = a.astype(int)
    op = ai[..., 3] > 128
    h = op.shape[0]
    mn = ai[..., :3].min(axis=2)
    mx = ai[..., :3].max(axis=2)
    white = op & (mn >= 250) & ((mx - mn) <= 5)
    lab, k = ndi.label(white)
    kill = np.zeros_like(white)
    for i in range(1, k + 1):
        m = lab == i
        s = int(m.sum())
        if enclosed and s >= 60:
            kill |= m
        elif s >= 120 and m[-2:].any() and np.where(m)[0].mean() > 0.6 * h:
            kill |= m
    if not kill.any():
        return 0
    near = ndi.binary_dilation(kill, iterations=2)
    kill |= near & op & (mn >= 205) & ((mx - mn) <= 40)
    if apply:
        a[kill, 3] = 0
        Image.fromarray(a).save(path)
    return int(kill.sum())


if __name__ == "__main__":
    enc = "--enclosed" in sys.argv
    app = "--apply" in sys.argv
    for p in [x for x in sys.argv[1:] if not x.startswith("--")]:
        n = clean(p, enc, app)
        if n:
            print(f"{p}: {n} px")
