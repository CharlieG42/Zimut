#!/usr/bin/env python3
"""Intègre les planches ennemis / boss V2 (2×2 composées sur fond blanc) de Mistral.
vues : repos face, repos face 2, repos dos, repos dos 2 ; actions / actions_dos : attaque, attaque 2, sort, sort 2.
Usage : integrer_ennemis_v2b.py <racine assets/sprites> nation/nom [nation/nom ...]
Les anciennes poses du même personnage sont retirées (autre dessin) ; les cases vides sont ignorées et listées."""
import os, sys, shutil
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from PIL import Image
import numpy as np
import couper_composite as cc

BOSSES = {"sylvestre": "tharok_le_vegetal", "cimes": "vorkann_le_givre", "sables": "zahor_le_sableux",
          "cristaux": "zypheron_le_cristallin", "marees": "neree_la_tempete", "vents": "aeron_le_celeste",
          "brasier": "kharaz_le_flamboyant", "brumes": "ombrelis_le_brumeux", "ombres": "nebulia_l_illusionniste",
          "rouages": "colosse_d_engrenages"}
FILE_TO_GAME = {"roue_engrennee": "roue_engrenee"}
PALE = {"griffon_des_cimes", "aigle_celeste", "harpie", "spectre", "fantome", "liche_des_brumes", "mage_cristallin",
        "elementaire_de_vent", "brumeux", "garde_aerien", "elementaire_de_cristal"}
HEIGHT = {"enemy": 240, "boss": 300}
MAX_W = 400
VUES = ["", "_idle_2", "_back", "_back_idle_2"]
ACT = ["_attack", "_attack_2", "_cast", "_cast_2"]
ALL_SUFFIX = ["", "_idle_2", "_back", "_back_idle_2", "_attack", "_attack_2", "_attack_3", "_cast", "_cast_2", "_walk",
              "_back_attack", "_back_attack_2", "_back_attack_3", "_back_cast", "_back_cast_2", "_back_walk"]

root = sys.argv[1]
report = []
for spec in sys.argv[2:]:
    nat, name = spec.split("/")
    role = "boss" if BOSSES.get(nat) == name else "enemy"
    gid = nat if role == "boss" else FILE_TO_GAME.get(name, name)
    folder = f"{root}/nations/boss" if role == "boss" else f"{root}/nations/ennemis/{nat}"
    src = f"{root}/nations/newAssets/{nat}"
    sombre = False
    # 1) découpe brute de chaque planche (sans mise à l'échelle) ; échelle commune = hauteur médiane de la planche vues
    raw = {}
    for kind, names in (("vues", VUES), ("actions", ACT), ("actions_dos", ["_back" + s for s in ACT])):
        sheet = f"{src}/{name}_{kind}.png"
        if not os.path.exists(sheet):
            report.append(f"{spec}: planche {kind} absente"); continue
        im = Image.open(sheet).convert("RGB"); W, H = im.size
        cells = [im.crop((c * W // 2, r * H // 2, (c + 1) * W // 2, (r + 1) * H // 2)) for r in range(2) for c in range(2)]
        raw[kind] = (names, [cc.cut_cell(c, sombre=sombre) for c in cells])
    if "vues" not in raw or raw["vues"][1][0] is None:
        report.append(f"{spec}: PAS de repos de face, non intégré"); continue
    hs = [s.height for s in raw["vues"][1] if s is not None]
    sc = HEIGHT[role] / float(np.median(hs))
    ws = [s.width for s in raw["vues"][1] if s is not None]
    if np.median(ws) * sc > MAX_W:
        sc = MAX_W / float(np.median(ws))
    # 2) retire les anciennes poses de ce personnage (exactement ce nom + suffixe connu)
    for suf in ALL_SUFFIX:
        for ext in (".png", ".png.import"):
            p = f"{folder}/{gid}{suf}{ext}"
            if os.path.exists(p): os.remove(p)
    # 3) écrit les nouvelles
    n = 0
    for kind, (names, sprites) in raw.items():
        for suf, s in zip(names, sprites):
            if s is None:
                report.append(f"{spec}: case vide {kind} {suf or 'repos'}"); continue
            s = s.resize((max(1, round(s.width * sc)), max(1, round(s.height * sc))), Image.LANCZOS)
            s.save(f"{folder}/{gid}{suf}.png"); n += 1
    print(f"ok {spec} -> {gid} ({role}) {n} poses")
print("\n".join(report))
