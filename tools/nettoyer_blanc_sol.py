#!/usr/bin/env python3
"""Retire les plaques blanches résiduelles AU SOL (restes du rectangle de fond collé par Mistral) d'un sprite :
composantes quasi blanches (>= 245) de >= 120 px qui touchent le bord de l'image et se trouvent à >= 80 % dans le tiers inférieur.
Usage : nettoyer_blanc_sol.py fichier.png [...]"""
import sys
import numpy as np
from PIL import Image
from scipy import ndimage

def clean(path, enclosed=False):
    im = Image.open(path).convert("RGBA")
    a = np.array(im)
    h, w, _ = a.shape
    white = (a[..., 3] > 0) & (a[..., :3].min(axis=2) >= 245)
    lab, n = ndimage.label(white)
    removed = 0
    for i in range(1, n + 1):
        m = lab == i
        sz = int(m.sum())
        if sz < 120:
            continue
        ys, xs = np.where(m)
        touches = ys.max() >= h - 2 or xs.min() <= 1 or xs.max() >= w - 2
        low = float((ys >= h * 0.65).mean())
        if (touches or enclosed) and low >= 0.8:
            a[m, 3] = 0
            removed += sz
    if removed:
        Image.fromarray(a, "RGBA").save(path)
    return removed

if __name__ == "__main__":
    for p in sys.argv[1:]:
        r = clean(p)
        if r:
            print(p.split("/")[-1], r)
