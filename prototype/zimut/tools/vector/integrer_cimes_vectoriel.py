#!/usr/bin/env python3
"""Branche (ou retire) les sprites vectoriels des Cimes dans le jeu. Rien n'est modifié tant qu'on ne lance pas --apply.

  python3 integrer_cimes_vectoriel.py --apply     # sauvegarde les PNG actuels (si pas déjà fait) puis copie les vectoriels
  python3 integrer_cimes_vectoriel.py --restore   # remet les PNG d'origine archivés
Options : --root <assets/sprites> (défaut : ../../assets/sprites)"""
import os, shutil, sys, glob
ROOT = sys.argv[sys.argv.index("--root") + 1] if "--root" in sys.argv else os.path.join(os.path.dirname(os.path.abspath(__file__)), "../../assets/sprites")
ARC = os.path.join(ROOT, "_archive/cimes_png_v57")
VEC = os.path.join(ROOT, "vector/cimes")
ENN = ["guerrier_des_monts", "griffon_des_cimes", "garde_des_pics", "rochebrute"]

def targets():
    """(source relative à vector/cimes, destination relative à sprites)"""
    out = []
    for f in sorted(glob.glob(os.path.join(VEC, "heros", "tank*.png"))):
        b = os.path.basename(f)
        out += [(f"heros/{b}", f"players/{b}"), (f"heros/{b}", "nations/heros/" + ("" if b == "tank.png" else "poses/") + b)]
    for n in ENN:
        for f in sorted(glob.glob(os.path.join(VEC, "ennemis", n + "*.png"))):
            b = os.path.basename(f); out.append((f"ennemis/{b}", f"nations/ennemis/cimes/{b}"))
    for f in sorted(glob.glob(os.path.join(VEC, "boss", "cimes*.png"))):
        b = os.path.basename(f); out.append((f"boss/{b}", f"nations/boss/{b}"))
    return out

def apply():
    n = 0
    for src, dst in targets():
        d = os.path.join(ROOT, dst); bak = os.path.join(ARC, "avant_integration", dst)
        if os.path.exists(d) and not os.path.exists(bak):
            os.makedirs(os.path.dirname(bak), exist_ok=True); shutil.copy2(d, bak)
        os.makedirs(os.path.dirname(d), exist_ok=True); shutil.copy2(os.path.join(VEC, src), d); n += 1
    print(n, "fichiers copiés (sauvegarde dans", ARC + "/avant_integration )")

def restore():
    base = os.path.join(ARC, "avant_integration"); n = 0
    for f in glob.glob(os.path.join(base, "**", "*.png"), recursive=True):
        shutil.copy2(f, os.path.join(ROOT, os.path.relpath(f, base))); n += 1
    print(n, "fichiers restaurés")

if "--apply" in sys.argv: apply()
elif "--restore" in sys.argv: restore()
else: print(__doc__)
