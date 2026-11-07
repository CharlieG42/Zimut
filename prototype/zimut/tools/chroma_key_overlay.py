#!/usr/bin/env python3
"""Détourage d'un overlay de détails généré par IA (fond blanc uni / voile clair)
en PNG transparent, par saturation : le fond peu saturé devient alpha 0.

Usage : python3 tools/chroma_key_overlay.py <entree.jpg> <sortie.png> <largeur> <hauteur>
"""
import sys

import numpy as np
from PIL import Image
from scipy import ndimage as ndi

src, dst, W, H = sys.argv[1], sys.argv[2], int(sys.argv[3]), int(sys.argv[4])
im = Image.open(src).convert("RGB").resize((W, H), Image.LANCZOS)
arr = np.asarray(im).astype(float)
mx = arr.max(axis=2)
mn = arr.min(axis=2)
sat = np.where(mx > 0, (mx - mn) / np.maximum(mx, 1.0), 0.0)
alpha = np.clip((sat - 0.045) / 0.07, 0.0, 1.0)
alpha[alpha < 0.2] = 0.0
alpha *= alpha
out = np.dstack([arr, (alpha * 255).astype(np.uint8)]).astype(np.uint8)
Image.fromarray(out, "RGBA").save(dst)
a = np.asarray(Image.open(dst))[..., 3]
lab, n = ndi.label(a > 128)
big = float(ndi.sum(a > 128, lab, range(1, n + 1)).max()) / a.size if n else 0.0
print("%s : couverture %.1f%%, composantes %d, plus grosse %.2f%%" % (dst, 100 * (a > 10).mean(), n, 100 * big))
