#!/usr/bin/env python3
"""integrer_soigneur_cast2.py — intègre la correction de Mistral (soigneur_cast2_v2.png, fond blanc)
comme pose assets/sprites/players/heal_cast_2.png : retrait du fond par le bord (le contour fermé du
personnage protège le blanc des cheveux et de la robe), recadrage, mise à l'échelle à 340 px de haut
(comme les autres poses du Soigneur), alpha prémultiplié pour éviter tout liseré blanc.
Usage : python3 tools/integrer_soigneur_cast2.py
"""
import os
import numpy as np
from PIL import Image
from scipy import ndimage as ndi

HERE = os.path.dirname(os.path.abspath(__file__))
SRC = os.path.join(HERE, "..", "assets", "sprites", "nations", "newAssets", "marees", "corrections", "soigneur_cast2_v2.png")
DST = os.path.join(HERE, "..", "assets", "sprites", "players", "heal_cast_2.png")
H = 340

a = np.array(Image.open(SRC).convert("RGB")).astype(int)
mn, mx = a.min(axis=2), a.max(axis=2)
lab, _ = ndi.label((mn >= 238) & ((mx - mn) <= 12))
edge = set(np.unique(np.concatenate([lab[0], lab[-1], lab[:, 0], lab[:, -1]]))) - {0}
fg = ~np.isin(lab, list(edge))
l2, k2 = ndi.label(fg)
sizes = ndi.sum(fg, l2, range(1, k2 + 1))
fg = l2 == (1 + int(np.argmax(sizes)))          # le personnage seul (sans particules isolées)
fg = ndi.binary_erosion(fg, iterations=1)       # retire le liseré clair du bord
ys, xs = np.where(fg)
box = (xs.min(), ys.min(), xs.max() + 1, ys.max() + 1)
alpha = (fg * 255).astype(np.uint8)
rgb = a.astype(np.uint8)
x0, y0, x1, y1 = box
rgb, alpha = rgb[y0:y1, x0:x1], alpha[y0:y1, x0:x1]
s = H / rgb.shape[0]
size = (max(1, int(rgb.shape[1] * s)), H)
pre = (rgb.astype(float) * (alpha[..., None] / 255.0))
pre_img = [Image.fromarray(pre[..., c].astype(np.float32), mode="F").resize(size, Image.LANCZOS) for c in range(3)]
al = Image.fromarray(alpha).resize(size, Image.LANCZOS)
al_n = np.array(al).astype(float)
out = np.zeros((size[1], size[0], 4), dtype=np.uint8)
for c in range(3):
    ch = np.array(pre_img[c])
    out[..., c] = np.clip(np.where(al_n > 0, ch / np.maximum(al_n / 255.0, 1e-3), 0), 0, 255).astype(np.uint8)
out[..., 3] = al_n.astype(np.uint8)
Image.fromarray(out).save(DST)
print("écrit", os.path.normpath(DST), out.shape[1], "x", out.shape[0])
