#!/usr/bin/env python3
"""Contrôle qualité d'une planche V65 : 5 composantes séparées, 0 pixel au bord.
Usage : python3 tools/check_planche_v65.py <image.jpg>
Sortie : OK (exit 0) ou REJET (exit 1)."""
import sys
from PIL import Image
import numpy as np
from scipy import ndimage as ndi
f = sys.argv[1]
a = np.array(Image.open(f).convert("RGB"))
h, w, _ = a.shape
nonbg = a.mean(axis=2) < 235
prof = nonbg.sum(axis=0)
colmin = ndi.minimum_filter1d(prof, size=max(3, int(w * 0.02)))
gap = colmin <= max(2, int(h * 0.02))
runs, x = [], 0
while x < w:
    if not gap[x]:
        s = x
        while x < w and not gap[x]:
            x += 1
        runs.append((s, x - 1))
    else:
        x += 1
bords = (int(nonbg[:, 0].sum()), int(nonbg[:, -1].sum()), int(nonbg[0, :].sum()), int(nonbg[-1, :].sum()))
ys, xs = np.where(nonbg)
mg = (int(xs.min()), int(w - 1 - xs.max()), int(ys.min()), int(h - 1 - ys.max()))
ok = len(runs) == 5 and max(bords) == 0 and min(mg[0], mg[1]) >= w * 0.08
print(f"{f}: composantes={len(runs)} bords(g,d,h,b)={bords} marges={mg} -> {'OK' if ok else 'REJET'}")
sys.exit(0 if ok else 1)
