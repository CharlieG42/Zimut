#!/usr/bin/env python3
"""Post-traitement des cuissons Kenney : rogne, réduit et écrit les sprites + data/batiments_kenney.json.
Usage : python3 tools/bake_kenney_post.py <dossier_cuisson> <noms,séparés,par,virgules>"""
import json, sys, os
from PIL import Image
src, names = sys.argv[1], sys.argv[2].split(",")
# Les toits turquoise du kit jurent avec la forêt : on décale leur teinte (HSV, pixels saturés à dominante cyan/vert).
TOIT = {"chaumiere": (0.10, 0.85), "maison_pierre": (0.02, 1.0), "moulin": (0.62, 0.85)}   # (teinte cible 0-1, facteur de saturation)
PPU = 70.0                      # pixels par unité-monde dans le sprite final
root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
out_dir = os.path.join(root, "prototype/zimut/assets/sprites/decor/kenney/batiments")
os.makedirs(out_dir, exist_ok=True)
table = {}
for n in names:
    meta = json.load(open(f"{src}/{n}.json"))
    im = Image.open(f"{src}/{n}.png").convert("RGBA")
    k = PPU / meta["ppu"]
    im = im.resize((round(im.width * k), round(im.height * k)), Image.LANCZOS)
    fx, fy = meta["fx"] * k, meta["fy"] * k
    bb = im.getbbox()
    im = im.crop(bb)
    if n in TOIT:
        import numpy as np
        a = np.array(im)
        hsv = np.array(Image.fromarray(a[:, :, :3]).convert("HSV")).astype(float)
        m = (hsv[:, :, 0] > 80) & (hsv[:, :, 0] < 140) & (hsv[:, :, 1] > 75) & (a[:, :, 3] > 0)
        hsv[m, 0] = TOIT[n][0] * 255.0
        hsv[m, 1] = np.clip(hsv[m, 1] * TOIT[n][1], 0, 255)
        rgb = np.array(Image.fromarray(hsv.astype("uint8"), "HSV").convert("RGB"))
        a[m, :3] = rgb[m]
        im = Image.fromarray(a, "RGBA")
    im.save(f"{out_dir}/{n}.png", optimize=True)
    table[n] = {"ref": round((meta["nx"] + meta["nz"]) * 0.70710678 * PPU, 2),
                "ax": round(fx - bb[0], 1), "ay": round(fy - bb[1], 1), "w": im.width, "h": im.height}
json.dump(table, open(os.path.join(root, "prototype/zimut/data/batiments_kenney.json"), "w"), indent=1, sort_keys=True)
print(table)
