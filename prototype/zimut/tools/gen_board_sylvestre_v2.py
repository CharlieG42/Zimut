#!/usr/bin/env python3
"""Planche Sylvestre v2 (illustration 4:3 « île flottante + village »).

Génère data/boards/foret_sylve_v2.json : masque 96×73 (cases de 16 px), départ, lieux.
Tout est défini en coordonnées de CASES sur l'image 1536×1168.
Usage : python3 tools/gen_board_sylvestre_v2.py [overlay.png]   (overlay : contrôle visuel)
"""
import json, sys, math
from pathlib import Path
from PIL import Image, ImageDraw

CELL, W, H = 16, 1536, 1168
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

# ── Chemins de terre ─────────────────────────────────────────────
stroke([(27, 15.5), (31, 16.5), (36, 17.5), (42, 17), (48, 17), (53, 18), (57, 20), (62, 22.5), (66, 24.5), (72, 25), (76, 24.5)], 3)
stroke([(76, 24.5), (74, 28), (73, 32), (75, 36), (77, 40), (76, 44), (72, 47), (68, 49), (60, 49), (52, 48)], 3)
stroke([(76, 24.5), (80, 23), (84, 22)], 3)                                  # vers la Crypte
stroke([(44, 48), (38, 50), (34, 53), (30, 55.5), (28, 58), (30, 61), (36, 64), (42, 67), (50, 68), (58, 67.5), (64, 65.5), (68, 63.5)], 3)
# ── Pont du village (diagonale) et pont nord-ouest ──────────────
stroke([(51, 54.5), (57, 57.5), (62, 60.5), (67, 63.5)], 3.6)
stroke([(16, 25), (17, 21), (17, 17), (18, 15.5), (22, 14), (26, 15), (28, 16.5)], 3)
# ── Parvis des cinq portes ──────────────────────────────────────
poly([(3, 24), (15, 24), (18, 26), (18, 29), (8, 28.5), (3, 26.5)])           # Grotte de la Feuille
poly([(44, 21.6), (50, 21.6), (50, 27), (44, 27)])                              # Grand Arbre (seuil + marches)
poly([(77, 19.3), (91, 19.3), (91, 21), (88, 23.4), (77, 23.4)])               # Crypte du Chêne Noir
poly([(73, 52.5), (82, 52.5), (84, 56.5), (73, 57.5)])                          # Sanctuaire de Cristal
poly([(21.5, 56.5), (30, 56.5), (32, 58.5), (32, 60), (22, 59.5)])             # Antre de la Patte
# ── Places et zones ouvertes ────────────────────────────────────
ellipse((47, 30.3), 10, 3.9)                                                   # place des runes
poly([(44, 33), (50, 33), (50, 38.5), (44, 38.5)])                              # marches sud
poly([(44, 38), (52, 38), (54, 41), (57, 44), (62, 45), (62, 47), (54, 49.5), (44, 49.5), (44, 42)])  # village
poly([(58, 27), (68, 27), (69, 33), (66, 36), (58, 34)])                        # prairie est de la place
poly([(80, 24), (92, 24), (93, 30), (84, 32), (78, 28)])                        # prairie nord-est
poly([(66, 50), (70, 50), (74, 54), (84, 57), (90, 56), (92, 60), (88, 63), (76, 62), (70, 60), (64, 56)])  # prairie du moulin
poly([(33, 56), (50, 54.5), (58, 61), (60, 66), (42, 66.5), (34, 62)])           # potager
# ── Obstacles ───────────────────────────────────────────────────
poly([(60.5, 27.5), (64, 27.5), (64, 31.5), (60.5, 31.5)], bd)                    # menhir est
ellipse((50.5, 47), 1.3, 1.1, bd)                                                # puits
poly([(77, 44), (88, 44), (88, 52.3), (77, 52.3)], bd)                           # tour du moulin
poly([(54, 54), (60, 52.2), (60, 52.8), (54, 54.6)], bd)

mask = [[(walk.getpixel((x*S + S//2, y*S + S//2)) > 0 and block.getpixel((x*S + S//2, y*S + S//2)) == 0)
         for x in range(COLS)] for y in range(ROWS)]
# ── Sentiers de terre repérés sur l'illustration et restés fermés par le masque (V101) ──
# (virage du moulin à l'est, chemin du potager au sud-ouest) : cases « couleur de chemin ».
EXTRA_PATH = [(27, 60), (31, 56), (31, 57), (31, 63), (32, 56), (33, 55), (33, 64), (34, 55), (35, 54), (35, 55), (36, 53), (36, 54), (37, 52), (37, 53), (37, 54), (38, 52), (38, 53), (39, 51), (39, 52), (40, 51), (40, 52), (58, 50), (59, 43), (60, 43), (61, 43), (61, 44), (61, 50), (62, 44), (62, 50), (63, 50), (64, 50), (68, 45), (68, 46), (69, 44), (69, 45), (69, 46), (70, 32), (70, 33), (70, 34), (70, 35), (70, 43), (70, 44), (71, 33), (71, 34), (71, 35), (71, 36), (71, 42), (71, 43), (72, 34), (72, 35), (72, 36), (72, 37), (72, 42), (73, 37), (73, 38), (73, 39), (73, 40), (73, 41), (74, 38), (74, 39), (74, 40)]
for _x, _y in EXTRA_PATH:
    mask[_y][_x] = True
# la porte reste franchissable
rows = ["".join("#" if c else "." for c in r) for r in mask]

def poi(kind, name, desc, **kw):
    return dict(kind=kind, name=name, desc=desc, **kw)

POIS = {
    "8,24":  poi("combat", "Grotte de la Feuille", "Un terrier moussu : quatre salles, la plus douce des entrées.", guardian="Forêt#1"),
    "25,57": poi("combat", "Antre de la Patte", "Le territoire d'une grande bête : quatre salles.", guardian="Forêt#2"),
    "79,53": poi("combat", "Sanctuaire de Cristal", "Des cristaux chantent dans l'ombre : quatre salles.", guardian="Forêt#3"),
    "84,19": poi("combat", "Crypte du Chêne Noir", "Une porte bleutée sous les racines : quatre salles, très dures.", guardian="Forêt#4"),
    "46,22": poi("combat", "Donjon de la Nation Sylvestre", "Le Grand Arbre : quatre salles ; le Gardien veille sur la Pierre de Sève.", guardian="Forêt"),
    "40,17": poi("combat", "Camp gobelin", "Des gobelins ont dressé leurs tentes.", level=1),
    "74,34": poi("combat", "Embuscade sous les pins", "Des brigands guettent le sentier.", level=3),
    "28,59": poi("combat", "Tanière du sanglier", "Un grand sanglier défend sa bauge.", level=2),
    "84,58": poi("combat", "Meute de loups gris", "Des hurlements montent des fourrés.", level=4),
    "38,65": poi("combat", "Patrouille de la Citadelle", "Des soldats des Ronces rôdent ici.", level=12),
    "6,27":  poi("chest", "Coffre moussu", "Un coffre à demi enseveli sous la mousse.", level=1),
    "88,27": poi("chest", "Souche creuse", "Quelque chose brille au fond de la souche.", level=2),
    "46,67": poi("chest", "Cache du bûcheron", "Un coffre dissimulé sous des fagots.", level=3),
    "33,54": poi("camp", "Source claire", "Un endroit sûr pour reprendre souffle.", level=1),
    "70,56": poi("camp", "Clairière des lucioles", "Des lucioles dansent autour d'un feu tranquille.", level=1),
    "40,30": poi("puzzle", "Cercle des pierres chantantes", "Des menhirs s'illuminent puis se taisent.", level=1),
    "54,30": poi("puzzle", "Sanctuaire des runes", "De vieilles runes attendent une réponse.", level=1),
    "66,25": poi("reveal", "Belvédère de la Sylve", "Du haut de l'arbre, la vallée se dévoile.", level=1),
}
START = [54, 45]

out = dict(image="res://assets/boards/Sylvestre_v2.png", image_size=[W, H], cell_px=CELL,
           cols=COLS, rows=ROWS, start=START, mask=rows, pois=POIS)
dst = Path(__file__).resolve().parent.parent / "data/boards/foret_sylve_v2.json"
dst.write_text(json.dumps(out, ensure_ascii=False, indent=0))
print("écrit", dst, "cases jouables :", sum(r.count("#") for r in rows))

# Contrôle : accessibilité depuis le départ
from collections import deque
seen, q = {tuple(START)}, deque([tuple(START)])
while q:
    x, y = q.popleft()
    for dx, dy in ((1,0),(-1,0),(0,1),(0,-1)):
        n = (x+dx, y+dy)
        if 0 <= n[0] < COLS and 0 <= n[1] < ROWS and rows[n[1]][n[0]] == "#" and n not in seen:
            seen.add(n); q.append(n)
bad = [k for k in POIS if tuple(map(int, k.split(","))) not in seen]
print("lieux inaccessibles :", bad, "| départ jouable :", tuple(START) in seen or rows[START[1]][START[0]] == "#")

if len(sys.argv) > 1:
    im = Image.open(Path("/tmp/claude-0/v2/v2_1536.png")).convert("RGBA")
    ov = Image.new("RGBA", im.size, (0, 0, 0, 0)); d = ImageDraw.Draw(ov)
    for y, r in enumerate(rows):
        for x, c in enumerate(r):
            if c == "#": d.rectangle([x*CELL, y*CELL, x*CELL+CELL-1, y*CELL+CELL-1], fill=(255, 40, 200, 90) if (x, y) in seen else (255, 255, 0, 140))
    for k, p in POIS.items():
        x, y = map(int, k.split(",")); col = (255, 0, 0, 255) if p.get("guardian") else (0, 0, 255, 255)
        d.ellipse([x*CELL-6, y*CELL-6, x*CELL+22, y*CELL+22], outline=col, width=4)
    d.ellipse([START[0]*CELL, START[1]*CELL, START[0]*CELL+16, START[1]*CELL+16], fill=(255, 255, 255, 255))
    Image.alpha_composite(im, ov).convert("RGB").save(sys.argv[1])
