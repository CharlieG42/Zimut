#!/usr/bin/env python3
"""Génère la grille jouable et les POI d'une planche illustrée.

Pour foret_sylve, les limites du plateau, les bassins et les empreintes des
grands monuments sont définis explicitement en pixels de l'illustration.
Le script refuse les POI trop éloignés de leur ancrage visuel.
Usage : python3 tools/gen_board.py <image.png> foret_sylve
"""
import sys
import json
from pathlib import Path

import numpy as np
from PIL import Image, ImageDraw
from scipy import ndimage as ndi

CELL = 16
MAX_POI_SNAP_CELLS = 4
src, name = sys.argv[1], sys.argv[2]
im = Image.open(src).convert("RGB")
W, H = im.size

if name != "foret_sylve":
    raise SystemExit("Planche non configurée : " + name)
if (W, H) != (1536, 864):
    raise SystemExit("Dimensions inattendues pour Sylvestre : %s×%s (attendu 1536×864)." % (W, H))
if W % CELL or H % CELL:
    raise SystemExit("L'image doit être divisible par la taille de case (%d px)." % CELL)

COLS, ROWS = W // CELL, H // CELL

# Contour du plateau supérieur de l'île (coordonnées source).
terrain = Image.new("L", (W, H), 0)
ImageDraw.Draw(terrain).polygon([
    (35, 220), (80, 170), (180, 140), (300, 120), (460, 105),
    (620, 115), (760, 120), (900, 130), (1040, 110), (1190, 120),
    (1340, 145), (1460, 200), (1510, 300), (1500, 440), (1470, 540),
    (1380, 620), (1240, 690), (1080, 735), (900, 770), (700, 770),
    (520, 740), (350, 700), (200, 640), (90, 560), (35, 450), (20, 330)
], fill=255)
walk = np.asarray(terrain) > 0

# Bassins et cours d'eau : exclus du déplacement.
water_shapes = [
    [(75, 500), (170, 480), (270, 500), (350, 550), (430, 600), (510, 620),
     (560, 680), (480, 700), (350, 670), (220, 620), (120, 570)],
    [(1000, 250), (1080, 215), (1180, 210), (1280, 230), (1350, 270),
     (1320, 320), (1230, 330), (1120, 315), (1040, 300)],
    [(520, 330), (570, 320), (620, 340), (670, 370), (700, 420),
     (650, 450), (600, 430), (560, 390)],
    [(760, 620), (830, 640), (900, 680), (940, 730), (880, 740), (810, 700)]
]
water_mask = Image.new("L", (W, H), 0)
wd = ImageDraw.Draw(water_mask)
for polygon in water_shapes:
    wd.polygon(polygon, fill=255)
walk &= np.asarray(water_mask) == 0

# Détection complémentaire des surfaces d'eau bleues à l'intérieur du plateau.
hsv = np.asarray(im.convert("HSV")).astype(float)
hue = hsv[:, :, 0] * 360.0 / 255.0
sat = hsv[:, :, 1] / 255.0
val = hsv[:, :, 2] / 255.0
blue_water = (hue > 175) & (hue < 245) & (sat > 0.32) & (val > 0.35)
walk &= ~blue_water

# Empreintes infranchissables des monuments et bâtiments principaux.
obstacles = Image.new("L", (W, H), 0)
od = ImageDraw.Draw(obstacles)
for polygon in [
    [(205, 30), (380, 30), (390, 170), (190, 170)],       # donjon feuille
    [(1120, 0), (1370, 0), (1380, 190), (1110, 190)],     # crypte violette
    [(80, 340), (250, 340), (260, 490), (70, 490)],       # donjon de la patte
    [(1110, 400), (1390, 390), (1410, 600), (1100, 610)], # sanctuaire de cristal
    [(650, 100), (930, 100), (950, 360), (640, 360)],     # grand arbre central
    [(350, 130), (480, 130), (490, 220), (340, 220)],    # maison
    [(560, 200), (700, 200), (710, 270), (550, 270)],    # campement nord
    [(780, 400), (900, 400), (910, 480), (770, 480)]     # ruines centrales
]:
    od.polygon(polygon, fill=255)
walk &= np.asarray(obstacles) == 0

# Une case est praticable si au moins 35 % de sa surface l'est.
grid = np.zeros((ROWS, COLS), dtype=bool)
for gy in range(ROWS):
    for gx in range(COLS):
        cell = walk[gy * CELL:(gy + 1) * CELL, gx * CELL:(gx + 1) * CELL]
        grid[gy, gx] = cell.mean() >= 0.35

def nearest(px, py):
    cx, cy = int(px // CELL), int(py // CELL)
    candidates = np.argwhere(grid)
    if len(candidates) == 0:
        return None
    distances = (candidates[:, 1] - cx) ** 2 + (candidates[:, 0] - cy) ** 2
    y, x = candidates[int(np.argmin(distances))]
    return int(x), int(y)

start = nearest(780, 560)
if start is None:
    raise SystemExit("Aucune case praticable détectée.")
labels, _ = ndi.label(grid)
grid &= labels == labels[start[1], start[0]]

POIS = [
    (310, 180, {"kind": "combat", "guardian": "Forêt#1", "name": "Grotte de la Feuille", "desc": "Un terrier moussu : quatre salles, la plus douce des entrées."}),
    (270, 540, {"kind": "combat", "guardian": "Forêt#2", "name": "Antre de la Patte", "desc": "Le territoire d'une grande bête : quatre salles."}),
    (1230, 650, {"kind": "combat", "guardian": "Forêt#3", "name": "Sanctuaire de Cristal", "desc": "Des cristaux chantent dans l'ombre : quatre salles."}),
    (1230, 200, {"kind": "combat", "guardian": "Forêt#4", "name": "Crypte du Chêne Noir", "desc": "Une porte violette sous les racines : quatre salles, très dures."}),
    (800, 390, {"kind": "combat", "guardian": "Forêt", "name": "Donjon de la Nation Sylvestre", "desc": "Le Grand Arbre : quatre salles ; le Gardien veille sur la Pierre de Sève."}),
    (620, 220, {"kind": "combat", "name": "Camp gobelin", "level": 1, "desc": "Des gobelins ont dressé leurs tentes."}),
    (1000, 430, {"kind": "combat", "name": "Embuscade sous les pins", "level": 3, "desc": "Des brigands guettent le sentier."}),
    (500, 550, {"kind": "combat", "name": "Tanière du sanglier", "level": 2, "desc": "Un grand sanglier défend sa bauge."}),
    (1100, 690, {"kind": "combat", "name": "Meute de loups gris", "level": 4, "desc": "Des hurlements montent des fourrés."}),
    (900, 730, {"kind": "combat", "name": "Patrouille de la Citadelle", "level": 12, "desc": "Des soldats des Ronces rôdent ici."}),
    (260, 340, {"kind": "chest", "name": "Coffre moussu", "level": 1, "desc": "Un coffre à demi enseveli sous la mousse."}),
    (1180, 390, {"kind": "chest", "name": "Souche creuse", "level": 2, "desc": "Quelque chose brille au fond de la souche."}),
    (700, 690, {"kind": "chest", "name": "Cache du bûcheron", "level": 3, "desc": "Un coffre dissimulé sous des fagots."}),
    (560, 450, {"kind": "camp", "name": "Source claire", "level": 1, "desc": "Un endroit sûr pour reprendre souffle."}),
    (1000, 620, {"kind": "camp", "name": "Clairière des lucioles", "level": 1, "desc": "Des lucioles dansent autour d'un feu tranquille."}),
    (700, 500, {"kind": "puzzle", "name": "Cercle des pierres chantantes", "level": 1, "desc": "Des menhirs s'illuminent puis se taisent."}),
    (930, 500, {"kind": "puzzle", "name": "Sanctuaire des runes", "level": 1, "desc": "De vieilles runes attendent une réponse."}),
    (1010, 300, {"kind": "reveal", "name": "Belvédère de la Sylve", "level": 1, "desc": "Du haut de l'arbre, la vallée se dévoile."})
]
pois = {}
for px, py, definition in POIS:
    cell = nearest(px, py)
    if cell is None:
        raise SystemExit("Aucune case accessible pour " + definition["name"])
    x, y = cell
    distance = abs(x - px // CELL) + abs(y - py // CELL)
    if distance > MAX_POI_SNAP_CELLS:
        raise SystemExit("POI trop éloigné : %s (écart Manhattan %d cases)." % (definition["name"], distance))
    key = "%d,%d" % (x, y)
    if key in pois:
        raise SystemExit("Deux POI se superposent sur la case " + key)
    if not grid[y, x]:
        raise SystemExit("POI non connecté au départ : " + definition["name"])
    pois[key] = definition

out = {
    "image": "res://assets/boards/" + Path(src).name,
    "image_size": [W, H],
    "cell_px": CELL,
    "cols": COLS,
    "rows": ROWS,
    "start": list(start),
    "mask": ["".join("#" if grid[y, x] else "." for x in range(COLS)) for y in range(ROWS)],
    "pois": pois
}
Path("data/boards").mkdir(parents=True, exist_ok=True)
Path("data/boards/%s.json" % name).write_text(json.dumps(out, ensure_ascii=False, indent=2), encoding="utf-8")
Path("assets/boards").mkdir(parents=True, exist_ok=True)
im.save(Path("assets/boards") / Path(src).name)

# Aperçu de contrôle : cases praticables teintées en magenta et POI numérotés.
preview = im.copy().convert("RGBA")
overlay = Image.new("RGBA", (W, H), (0, 0, 0, 0))
odraw = ImageDraw.Draw(overlay)
for y in range(ROWS):
    for x in range(COLS):
        if grid[y, x]:
            odraw.rectangle((x * CELL, y * CELL, (x + 1) * CELL - 1, (y + 1) * CELL - 1), fill=(255, 0, 220, 65))
preview = Image.alpha_composite(preview, overlay)
pd = ImageDraw.Draw(preview)
for index, (key, definition) in enumerate(pois.items(), 1):
    x, y = map(int, key.split(","))
    px, py = int((x + 0.5) * CELL), int((y + 0.5) * CELL)
    pd.ellipse((px - 9, py - 9, px + 9, py + 9), fill=(220, 20, 30, 230), outline=(255, 255, 255, 255), width=2)
    pd.text((px + 10, py - 8), str(index), fill=(255, 255, 255, 255), stroke_width=2, stroke_fill=(0, 0, 0, 255))
preview.convert("RGB").save("/tmp/board_overlay.png")
print("grille", COLS, ROWS, "cases jouables", int(grid.sum()), "lieux", len(pois), "départ", start)
