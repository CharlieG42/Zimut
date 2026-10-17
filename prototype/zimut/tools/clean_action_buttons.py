#!/usr/bin/env python3
"""clean_action_buttons.py — Nettoie les boutons illustrés du menu (assets/ui/actions/*.png).

Les PNG d'origine contenaient des fragments parasites (haut / gauche) et un décor coupé. On garde
la plus grande forme, on retire le liseré semi-transparent des fragments et on recadre au contenu
sur un canevas commun 512x192 (centré), pour que tous les boutons aient la même emprise.
Usage : python3 tools/clean_action_buttons.py
"""
import glob, os
import numpy as np
from PIL import Image
from scipy import ndimage

HERE = os.path.dirname(os.path.abspath(__file__))
SRC = os.path.join(HERE, "..", "assets", "ui", "actions")
CW, CH = 512, 192

def clean(path):
    im = Image.open(path).convert("RGBA")
    a = np.array(im)
    solid = a[:, :, 3] > 24
    lab, n = ndimage.label(solid, structure=np.ones((3, 3)))
    if n == 0:
        return
    sizes = ndimage.sum(solid, lab, range(1, n + 1))
    keep = int(np.argmax(sizes)) + 1
    mask = ndimage.binary_dilation(lab == keep, iterations=2)
    a[:, :, 3] = np.where(mask, a[:, :, 3], 0)
    # arrondit les arêtes coupées sur le bord droit du canevas d'origine
    ys, xs = np.where(a[:, :, 3] > 0)
    box = (xs.min(), ys.min(), xs.max() + 1, ys.max() + 1)
    crop = Image.fromarray(a).crop(box)
    w, h = crop.size
    sc = min((CW - 8) / w, (CH - 8) / h)
    crop = crop.resize((max(1, round(w * sc)), max(1, round(h * sc))), Image.LANCZOS)
    out = Image.new("RGBA", (CW, CH), (0, 0, 0, 0))
    out.alpha_composite(crop, ((CW - crop.width) // 2, (CH - crop.height) // 2))
    out.save(path)

if __name__ == "__main__":
    for p in sorted(glob.glob(os.path.join(SRC, "action_*.png"))):
        clean(p)
        print("nettoyé", os.path.basename(p))
