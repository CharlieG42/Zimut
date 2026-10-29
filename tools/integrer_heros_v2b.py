#!/usr/bin/env python3
"""Intègre les planches héros V2 (2×2 composées) de Mistral : vues + actions + actions_dos.
Actions 2×2 -> attaque, attaque_2, sort, sort_2 (face et dos). Cases vides ignorées (listées).
Usage : integrer_heros_v2b.py <racine assets/sprites> [heros,...]   (SOMBRE=assassin pour --sombre)"""
import os, sys, shutil, subprocess, tempfile
HERE = os.path.dirname(os.path.abspath(__file__))
CUT = os.path.join(HERE, "couper_composite.py")
HEROES = {"sylvestre": "druide", "cimes": "tank", "sables": "geomancien", "cristaux": "mage", "marees": "soigneur",
          "vents": "sylvain", "brasier": "chasseur", "brumes": "invocateur", "ombres": "assassin", "rouages": "artificier"}
GAME = {"soigneur": "heal"}
SOMBRE = set(os.environ.get("SOMBRE", "").split(","))
BLANC = set(os.environ.get("BLANC", "").split(","))
VUES = ["", "_idle_2", "_back", "_back_idle_2"]
ACT = ["_attack", "_attack_2", "_cast", "_cast_2"]
root = sys.argv[1]; only = set(sys.argv[2].split(",")) if len(sys.argv) > 2 else None
for nat, h in HEROES.items():
    if only and h not in only: continue
    gid = GAME.get(h, h); src = f"{root}/nations/newAssets/{nat}"; players = f"{root}/players"
    for kind, names in (("vues", [gid + s for s in VUES]), ("actions", [gid + s for s in ACT]),
                        ("actions_dos", [gid + "_back" + s for s in ACT])):
        sheet = f"{src}/{h}_{kind}.png"
        if not os.path.exists(sheet): print("absent", sheet); continue
        d = tempfile.mkdtemp()
        subprocess.run([sys.executable, CUT, sheet, d, "x"] + (["--sombre"] if h in SOMBRE else []) + (["--blanc"] if h in BLANC else []), check=True, capture_output=True)
        for suf, name in zip(VUES, names):
            if not os.path.exists(f"{d}/x{suf}.png"):
                print("  CASE VIDE, ignorée :", name); 
                for q in (f"{players}/{name}.png", f"{players}/{name}.png.import"):
                    if os.path.exists(q): os.remove(q)
                continue
            shutil.copy(f"{d}/x{suf}.png", f"{players}/{name}.png")
        shutil.rmtree(d)
    for old in ("_attack_3", "_walk", "_back_attack_3", "_back_walk"):
        for q in (f"{players}/{gid}{old}.png", f"{players}/{gid}{old}.png.import"):
            if os.path.exists(q): os.remove(q)
    shutil.copy(f"{players}/{gid}.png", f"{root}/nations/heros/{gid}.png")
    print("ok", h)
