#!/usr/bin/env python3
"""Palette Fantasy Town réchauffée -> colormap_warm.png (dossier courant)."""
import os, numpy as np, cv2
from PIL import Image
ROOT = os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), "../../../.."))
im = np.array(Image.open(ROOT + "/atelier_3d/kenney/fantasy-town/Textures/colormap.png").convert("RGBA")).astype(np.float32) / 255
hsv = cv2.cvtColor(im[..., :3], cv2.COLOR_RGB2HSV); h, s, v = hsv[..., 0], hsv[..., 1], hsv[..., 2]
m = (h > 200) & (h < 255) & (s < 0.42); h = np.where(m, 38, h); s = np.where(m, s * 0.55, s); v = np.where(m, v * 0.97, v)   # pierre lavande -> pierre chaude
m2 = (h > 150) & (h < 205); s = np.where(m2, s * 0.4, s); v = np.where(m2, v * 0.85, v)                                     # turquoise éteint
m3 = (h > 285) & (h < 357); h = np.where(m3, 8, h); s = np.where(m3, s * 0.7, s); v = np.where(m3, v * 0.78, v)            # roses -> terre cuite
m4 = (h >= 357) | (h < 12); s = np.where(m4 & (s > 0.4), s * 0.8, s)
out = cv2.cvtColor(np.stack([h, s, v], 2).astype(np.float32), cv2.COLOR_HSV2RGB)
Image.fromarray((np.dstack([out, im[..., 3]]) * 255 + .5).astype(np.uint8)).save("colormap_warm.png")
