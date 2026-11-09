#!/usr/bin/env python3
"""V130 — Carte de lumière du diorama : l'image finie réduite à 320 × 180 et adoucie.

Le jeu y lit la couleur ambiante sous chaque personnage (sous-bois sombre et vert, lueur de la lave…)
pour teinter héros et monstres : ils ne paraissent plus « posés » sur le décor.
Entrée : apercu.png (dossier de travail). Sortie : assets/boards/lumieres/<dossier des tuiles>.png (trouvée par convention de nom ;
import sans perte : le jeu lit les pixels).
Usage : DIORAMA_PLAN=plan96 python3 light_map.py [repo]
"""
import os, sys, importlib, numpy as np, cv2
from PIL import Image
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
W = importlib.import_module(os.environ.get("DIORAMA_PLAN", "plan96"))
REPO = sys.argv[1] if len(sys.argv) > 1 else "/home/claude/zimut/prototype/zimut"
os.makedirs(REPO + "/assets/boards/lumieres", exist_ok=True)
OUT = REPO + "/assets/boards/lumieres/%s.png" % W.ASSET_DIR
im = np.asarray(Image.open("apercu.png").convert("RGB"), np.float32) / 255.0
small = cv2.resize(im, (320, 180), interpolation=cv2.INTER_AREA)
small = cv2.GaussianBlur(small, (0, 0), 1.6)
Image.fromarray((np.clip(small, 0, 1) * 255 + 0.5).astype(np.uint8)).save(OUT, optimize=True)
print(OUT.split("/")[-1], os.path.getsize(OUT) // 1024, "Ko")
