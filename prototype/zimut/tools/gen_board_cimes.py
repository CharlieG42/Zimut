#!/usr/bin/env python3
"""Planche des Cimes (Nation Montagne, zone « montagne_pics ») : village de montagne, 5 donjons.

Génère data/boards/montagne_pics_v2.json : masque 96×72 (cases de 16 px), départ, lieux.
Tout est défini en coordonnées de CASES sur l'image 1536×1152 (assets/boards/Cimes.png).
Usage : python3 tools/gen_board_cimes.py [overlay.png]   (overlay : contrôle visuel)
"""
import json, sys
from pathlib import Path
from collections import deque
from PIL import Image, ImageDraw

CELL, W, H = 16, 1536, 1152
COLS, ROWS = W // CELL, H // CELL
S = 4  # sur-échantillonnage du masque

def canvas(): return Image.new("L", (COLS * S, ROWS * S), 0)
def px(p): return (p[0] * S, p[1] * S)

walk, block = canvas(), canvas()
wd, bd = ImageDraw.Draw(walk), ImageDraw.Draw(block)

def poly(pts, d=wd): d.polygon([px(p) for p in pts], fill=255)
def ellipse(c, rx, ry, d=wd): d.ellipse([px((c[0]-rx, c[1]-ry)), px((c[0]+rx, c[1]+ry))], fill=255)
def stroke(pts, w, d=wd):
    d.line([px(p) for p in pts], fill=255, width=int(w * S), joint="curve")
    for p in pts: ellipse(p, w / 2, w / 2, d)

# ── Place du village (pavés) ────────────────────────────────────
poly([(35, 41), (40, 37.5), (54, 37.5), (56, 39.5), (62, 39.5), (63, 44), (60, 47), (54, 49), (47, 49), (40, 47.5), (36, 45)])
# ── Sentier ouest : de la place à la Caverne du Givre ───────────
stroke([(36, 43), (30, 43), (25, 41.5), (21, 39.5), (17, 37.5), (14, 35), (12, 32.5), (12, 30), (13, 27.5), (12, 25.5)], 2.8)
poly([(8, 22), (18, 22), (19, 26), (14, 28.5), (8, 27)])                           # parvis de la caverne bleue
# ── Pont est, terrasse nord-est et Mine d'Or Gelée ──────────────
stroke([(61, 38.5), (64, 36), (67, 34.5), (70, 33), (74, 32), (76, 30.5)], 2.8)
stroke([(76, 30.5), (75, 27.5), (74, 24.5), (76, 22.5), (79, 21), (81, 19)], 3)
poly([(66, 22.5), (74, 20), (83, 20.5), (84, 24), (78, 27), (70, 28), (66, 25)])  # terrasse nord-est
poly([(76, 17), (86, 17), (88, 21), (80, 23.5), (75, 22)])                          # parvis de la porte dorée
# ── Pont nord : terrasse nord-est ↔ plateau du château ──────────
stroke([(56, 24.5), (60, 24.5), (64.5, 24.5), (67, 24)], 2.8)
poly([(31, 16.5), (42, 14.5), (56, 14.5), (62, 18), (63, 21.5), (57, 22.5), (40, 21), (32, 20)])  # plateau
stroke([(57.5, 21), (57.5, 24.5)], 2.6)
stroke([(50, 13), (48, 15), (46, 17), (44, 18.5)], 3.4)                                 # escalier du château
poly([(46, 12.2), (52.5, 12.2), (52.5, 15), (46, 15)])
# ── Sud : ledge, pont et chaumière-forge ────────────────────────
stroke([(44, 48), (43, 51), (45, 53), (48, 54.3)], 3)
stroke([(49, 54.3), (53, 56), (57.5, 58)], 3.4)
stroke([(59, 59.5), (63, 60.5), (66, 61), (70, 62), (74, 61.5), (76, 60.5)], 3)
poly([(62, 59), (80, 59.5), (80, 64), (66, 66), (62, 63)])                          # terrasse de la chaumière
# ── Sud-ouest : tour aux runes violettes ────────────────────────
stroke([(38, 47), (34, 50), (31, 53), (30, 56), (30.5, 59), (30, 62)], 3)
stroke([(22, 62), (18, 61)], 3)
poly([(2, 61), (26, 61), (30, 63), (30, 70), (2, 70)])                              # parvis des menhirs
poly([(49, 31), (55, 31), (55, 38), (49, 38)])                                      # ruelle nord du village
# ── Obstacles ───────────────────────────────────────────────────
ellipse((50, 42), 2.6, 1.9, bd)                                                      # fontaine
ellipse((41.5, 43.2), 0.9, 0.9, bd)                                                  # brasero
for c in [(4, 64), (10.6, 62.5), (21, 65), (27.5, 58.5)]:
    ellipse(c, 1.4, 1.5, bd)                                                         # menhirs runiques
poly([(42, 33), (50, 33), (50, 37.4), (42, 37.4)], bd)                               # étal rayé ouest
poly([(54, 33.5), (61.5, 33.5), (61.5, 38), (54, 38)], bd)                           # étal rayé est

mask = [[(walk.getpixel((x*S + S//2, y*S + S//2)) > 0 and block.getpixel((x*S + S//2, y*S + S//2)) == 0)
         for x in range(COLS)] for y in range(ROWS)]
rows = ["".join("#" if c else "." for c in r) for r in mask]

def poi(kind, name, desc, **kw):
    return dict(kind=kind, name=name, desc=desc, **kw)

POIS = {
    # 5 donjons : paliers 1 à 4 (à la suite) puis le château de glace (Gardien + Pierre de Givre)
    "76,60": poi("combat", "Forge Givrée", "Une chaumière creusée dans la roche, la forge fume encore : quatre salles, l'entrée la plus douce.", guardian="Montagne#1"),
    "12,24": poi("combat", "Caverne du Givre", "Une arche de glace bleutée : quatre salles.", guardian="Montagne#2"),
    "17,60": poi("combat", "Tour des Runes Violettes", "Des menhirs chantent autour d'une porte violette : quatre salles, plus dures.", guardian="Montagne#3"),
    "81,18": poi("combat", "Mine d'Or Gelée", "Une porte dorée sous la roche : quatre salles, très dures.", guardian="Montagne#4"),
    "50,13": poi("combat", "Donjon de la Nation Cimes", "Le château de glace : quatre salles ; le Gardien veille sur la Pierre de Givre.", guardian="Montagne"),
    "23,41": poi("combat", "Sentinelles de glace", "Des silhouettes figées bougent quand on approche.", level=34),
    "60,60": poi("combat", "Pillards du piémont", "Des pillards rançonnent les voyageurs du pont.", level=36),
    "30,54": poi("combat", "Yétis de la corniche", "Une famille de yétis défend sa corniche.", level=38),
    "75,26": poi("combat", "Troll des crêtes", "Un troll énorme réclame un droit de passage.", level=40),
    "36,19": poi("combat", "Garde du glacier", "Des gardes de givre patrouillent sur le plateau.", level=42),
    "24,67": poi("chest", "Grotte au cristal", "Un éclat de cristal brille au fond.", level=34),
    "64,62": poi("chest", "Sacoche du muletier", "Une sacoche tombée d'un bât.", level=36),
    "82,21": poi("chest", "Cache du contrebandier", "Un coffre arrimé sous un surplomb.", level=40),
    "38,46": poi("camp", "Refuge du berger", "Un poêle, du thé chaud et un banc près de la fontaine.", level=32),
    "12,31": poi("camp", "Grotte tiède", "Une source chaude fume au bord du sentier.", level=34),
    "56,45": poi("puzzle", "Miroirs de givre", "Seize miroirs de glace, la plupart ternis.", level=38),
    "52,20": poi("puzzle", "Orgue de glace", "Des stalactites résonnent au gré du vent.", level=40),
    "20,67": poi("puzzle", "Stèle des caravaniers", "Une stèle gravée d'une question.", level=36),
    "58,20": poi("reveal", "Aiguille des Crêtes", "Du haut du plateau, tout le massif s'étale sous vos yeux.", level=36),
}
START = [44, 45]

out = dict(image="res://assets/boards/Cimes.png", image_size=[W, H], cell_px=CELL,
           cols=COLS, rows=ROWS, start=START, mask=rows, pois=POIS)
dst = Path(__file__).resolve().parent.parent / "data/boards/montagne_pics_v2.json"
dst.write_text(json.dumps(out, ensure_ascii=False, indent=0))
print("écrit", dst, "cases jouables :", sum(r.count("#") for r in rows))

seen, q = {tuple(START)}, deque([tuple(START)])
while q:
    x, y = q.popleft()
    for dx, dy in ((1,0),(-1,0),(0,1),(0,-1)):
        n = (x+dx, y+dy)
        if 0 <= n[0] < COLS and 0 <= n[1] < ROWS and rows[n[1]][n[0]] == "#" and n not in seen:
            seen.add(n); q.append(n)
bad = [k for k in POIS if tuple(map(int, k.split(","))) not in seen]
print("lieux inaccessibles :", bad, "| départ jouable :", rows[START[1]][START[0]] == "#")

if len(sys.argv) > 1:
    im = Image.open(Path(__file__).resolve().parent.parent / "assets/boards/Cimes.png").convert("RGBA")
    ov = Image.new("RGBA", im.size, (0, 0, 0, 0)); d = ImageDraw.Draw(ov)
    for y, r in enumerate(rows):
        for x, c in enumerate(r):
            if c == "#": d.rectangle([x*CELL, y*CELL, x*CELL+CELL-1, y*CELL+CELL-1], fill=(255, 40, 200, 90) if (x, y) in seen else (255, 255, 0, 140))
    for k, p in POIS.items():
        x, y = map(int, k.split(",")); col = (255, 0, 0, 255) if p.get("guardian") else (0, 0, 255, 255)
        d.ellipse([x*CELL-6, y*CELL-6, x*CELL+22, y*CELL+22], outline=col, width=4)
    d.ellipse([START[0]*CELL, START[1]*CELL, START[0]*CELL+16, START[1]*CELL+16], fill=(255, 255, 255, 255))
    Image.alpha_composite(im, ov).convert("RGB").save(sys.argv[1])
