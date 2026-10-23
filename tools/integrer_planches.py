#!/usr/bin/env python3
"""Intègre des planches déjà découpées (couper_planche.py) selon une table JSON : case -> pose du jeu.

Usage : integrer_planches.py tools/mappings/<nation>.json <dossier_planches_découpées> <racine assets/sprites>

Table : {"chars": {"<id>": {"folder": "players", "height": 300,
          "poses": {"": ["v3", "r1c1", 348, false], "_attack": [...]}}}}
Chaque pose = [planche, case, hauteur de référence de la case (px), retourner ?].
- échelle = height / hauteur de référence : choisir la même hauteur de référence pour des cases dessinées à la même échelle ;
- retourner = true pour un sprite tourné vers la gauche (le jeu veut des sprites tournés vers la droite) ;
- doublons écartés (signature 32x32 < "dedupe", 0,05 par défaut) ; les anciennes poses du personnage sont remplacées."""
import json, os, sys, glob
import numpy as np
from PIL import Image, ImageOps

table, SRC, DST = json.load(open(sys.argv[1])), sys.argv[2], sys.argv[3]

def sig(im):
    a = np.array(im.resize((32, 32))).astype(float)
    return np.dstack([a[..., 3] / 255, a[..., :3].mean(-1) / 255 * (a[..., 3] > 0)])

for name, c in table["chars"].items():
    kept, sigs = {}, []
    for pose, (sheet, cell, ref, flip) in c["poses"].items():
        im = Image.open(os.path.join(SRC, sheet, f"{sheet}_{cell}.png")).convert("RGBA")
        s = c["height"] / float(ref)
        im = im.resize((max(1, round(im.width * s)), max(1, round(im.height * s))), Image.LANCZOS)
        if flip:
            im = ImageOps.mirror(im)
        sg = sig(im)
        if any(np.abs(sg - o).mean() < float(c.get("dedupe", 0.05)) for o in sigs):
            print(f"{name}{pose}: doublon écarté"); continue
        sigs.append(sg); kept[pose] = im
    folder = c["folder"]
    outs = [os.path.join(DST, folder)]
    if folder == "players":
        outs += [os.path.join(DST, "nations/heros"), os.path.join(DST, "nations/heros/poses")]
    for d in outs:
        for f in glob.glob(os.path.join(d, name + "*.png*")):
            b = os.path.basename(f)
            if b.startswith(name + "_") or b.startswith(name + ".png"):
                os.remove(f)
    for pose, im in kept.items():
        fn = name + pose + ".png"
        im.save(os.path.join(DST, folder, fn))
        if folder == "players":
            im.save(os.path.join(DST, "nations/heros" + ("" if pose == "" else "/poses"), fn))
    print(f"{name}: {len(kept)} poses ({', '.join(p or 'repos' for p in kept)})")
