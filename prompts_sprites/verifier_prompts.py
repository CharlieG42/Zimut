#!/usr/bin/env python3
"""Contrôle qualité des prompts générés (V44). Usage : python3 prompts_sprites/verifier_prompts.py"""
import re, sys
from pathlib import Path
sys.path.insert(0, str(Path(__file__).resolve().parent))
import generer_prompts as G

bad = []
def chk(c, m):
    if not c:
        bad.append(m)

GAME_SUFFIXES = {"", "_idle_2", "_back", "_back_idle_2", "_attack", "_attack_2", "_attack_3", "_cast", "_cast_2",
                 "_walk", "_back_attack", "_back_attack_2", "_back_attack_3", "_back_cast", "_back_cast_2", "_back_walk"}
chk({s for s, _, _ in G.VIEWS4} | {s for s, _, _ in G.ACTIONS_FACE} | {s for s, _, _ in G.ACTIONS_BACK} == GAME_SUFFIXES,
    "noms de fichiers différents de la convention EntityView")
ents = []
for n in G.NATIONS:
    ents += [(n["hero"], "hero"), (n["boss"], "boss")] + [(e, "enemy") for e in n["enemies"]]
ents += [(f, "familier") for f in G.FAMILIERS]
for e, kind in ents:
    key = e["id"]
    if kind == "familier" and ("familier:" + key) in G.IDENT:
        key = "familier:" + key
    w = G.weapon_of(key)
    who = e["nom"].split(" (")[0]
    for name, p in [("vues", G.prompt_vues(who, "x", "n", e["desc"], "fx", "rim", "pal", False, key)),
                    ("face", G.prompt_actions(who, "x", "n", e["desc"], e["arch"], "fx", "rim", "pal", False, key, "face")),
                    ("dos", G.prompt_actions(who, "x", "n", e["desc"], e["arch"], "fx", "rim", "pal", False, key, "dos")),
                    ("fix", G.prompt_vues_fix(who, "x", "n", e["desc"], "fx", "rim", "pal", False, key))]:
        first = p.split("\n")[0]
        if w:
            chk(w in first, f"{key}/{name}: arme absente de la première phrase")
            chk("UNARMED" not in p, f"{key}/{name}: UNARMED sur un personnage armé")
            if name in ("face", "dos"):
                chk("WEAPON CHECK" in p, f"{key}/{name}: pas de WEAPON CHECK")
        else:
            chk("UNARMED" in first, f"{key}/{name}: créature sans mention UNARMED")
            chk("hands are NEVER empty" not in p and "HOLDS its weapon" not in p, f"{key}/{name}: ordre d'arme sur une créature")
        chk("facing left" not in p.replace("never facing left", "").replace("never left", ""), f"{key}/{name}: orientation gauche demandée")
        if name == "dos":
            chk("no face" in p, f"{key}/{name}: dos sans « no face »")
    # chaque case d'action distincte
    texts = [G.cell_text(c, e["arch"], "fx") for _, c, _ in G.ACTION_POSES]
    chk(len(set(texts)) == 6, f"{key}: poses d'action identiques")
for f in list((Path(__file__).parent / "nations").glob("*.md")):
    t = f.read_text(encoding="utf-8")
    chk("_attack_back" not in t and "_back_left" not in t and "_face_left" not in t, f"{f.name}: anciens noms de fichiers")
print("QC prompts :", "OK" if not bad else f"{len(bad)} problème(s)")
for b in bad[:20]:
    print("  -", b)
sys.exit(1 if bad else 0)
