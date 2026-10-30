#!/usr/bin/env python3
"""Masques d'animation de la carte de Conquête (V60).

Lit assets/ui/conquest/conquest_world_map.jpg et écrit conquest_world_fx.png (768×512) :
  R = eau (reflets, ondulation), G = lave (pulsation), B = cristaux (lueur).
Les zones de recherche (LAVA_BOX, CRYSTAL_BOX, exclusions de l'eau) suivent la carte actuelle :
à ajuster si une nouvelle carte place autrement le volcan ou les cristaux.
Usage : python3 tools/conquest_fx_masks.py [carte] [sortie]
"""
import sys
import numpy as np
from PIL import Image, ImageFilter

SRC = sys.argv[1] if len(sys.argv) > 1 else "assets/ui/conquest/conquest_world_map.jpg"
DST = sys.argv[2] if len(sys.argv) > 2 else "assets/ui/conquest/conquest_world_fx.png"
W, H = 768, 512
LAVA_BOX = (0.0, 0.45, 0.45, 1.0)        # x0, y0, x1, y1 (fractions)
CRYSTAL_BOX = (0.70, 0.62, 1.0, 1.0)
MOUNTAIN_BOX = (0.28, 0.0, 0.80, 0.42)   # ombres bleutées des montagnes : pas de l'eau
SKY_BOX = (0.0, 0.0, 0.40, 0.20)         # ciel des îles flottantes


def inside(nx, ny, box):
    return (nx >= box[0]) & (ny >= box[1]) & (nx < box[2]) & (ny < box[3])


def blur(a, r):
    img = Image.fromarray((np.clip(a, 0, 1) * 255).astype(np.uint8)).filter(ImageFilter.GaussianBlur(r))
    return np.asarray(img).astype(float) / 255.0


def main():
    sm = Image.open(SRC).convert("RGB").resize((W, H), Image.LANCZOS)
    hsv = np.asarray(sm.convert("HSV")).astype(float) / 255.0
    rgb = np.asarray(sm).astype(float) / 255.0
    h, s, v = hsv[..., 0] * 360.0, hsv[..., 1], hsv[..., 2]
    yy, xx = np.mgrid[0:H, 0:W]
    nx, ny = xx / W, yy / H
    water = (h > 165) & (h < 225) & (s > 0.35) & (v > 0.25)
    water &= ~(inside(nx, ny, MOUNTAIN_BOX) & ~((s > 0.7) & (v > 0.5)))
    water &= ~inside(nx, ny, SKY_BOX)
    water &= ~(ny < 0.04)
    w8 = Image.fromarray((water * 255).astype(np.uint8)).filter(ImageFilter.MinFilter(3)).filter(ImageFilter.MaxFilter(3))
    water = blur(np.asarray(w8) / 255.0, 1.2)
    lava = ((h < 38) & (s > 0.6) & (v > 0.55) & (rgb[..., 0] > 0.7) & inside(nx, ny, LAVA_BOX)).astype(float)
    crys = ((h > 195) & (h < 275) & (s > 0.35) & (v > 0.6) & inside(nx, ny, CRYSTAL_BOX)).astype(float)
    lava = np.clip(blur(lava, 1.5) * 1.6, 0, 1)
    crys = np.clip(blur(crys, 2.5) * 1.8, 0, 1)
    out = np.stack([water, lava, crys], -1)
    Image.fromarray((out * 255).astype(np.uint8)).save(DST)
    print("masques écrits :", DST)


if __name__ == "__main__":
    main()
