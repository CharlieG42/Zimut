#!/usr/bin/env python3
"""check_assets.py — vérifie que chaque ressource importée par Godot est bien suivie par git.

Un fichier *.png.import présent sans son *.png (ignoré par .gitignore) donne un sprite
invisible dans l'APK construit par la CI. Usage : python3 tools/check_assets.py (depuis prototype/zimut).
Code de sortie 1 si des fichiers manquent.
"""
import os, subprocess, sys

ROOT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..")
os.chdir(ROOT)
tracked = set(subprocess.run(["git", "ls-files"], capture_output=True, text=True, check=True).stdout.split("\n"))
missing = []
for f in sorted(tracked):
    if f.endswith(".import"):
        src = f[: -len(".import")]
        if src not in tracked:
            missing.append(src)
if missing:
    print("Ressources importées mais absentes du dépôt (.gitignore ?) :")
    for m in missing:
        print("  -", m, "(sur le disque)" if os.path.exists(m) else "(fichier .import orphelin)")
    sys.exit(1)
print("OK : %d ressources importées, toutes suivies par git." % sum(1 for f in tracked if f.endswith(".import")))
