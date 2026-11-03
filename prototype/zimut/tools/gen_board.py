#!/usr/bin/env python3
"""Génère la définition d'une planche 2D (masque de cases jouables + lieux) à partir de l'illustration.
Usage : python3 tools/gen_board.py <image.png> foret_sylve
Le masque est détecté par couleur (sentiers et clairières claires), puis corrigé à la main
(blocs = couronnes d'arbres ; traits = passages vers les entrées de donjon)."""
import sys, json
import numpy as np
from PIL import Image, ImageDraw
from scipy import ndimage as ndi

CELL = 24                                   # pixels d'image par case
src, name = sys.argv[1], sys.argv[2]
im = Image.open(src).convert("RGB")
W, H = im.size
COLS, ROWS = W // CELL, -(-H // CELL)
hsv = np.asarray(im.convert("HSV")).astype(float)
h, s, v = hsv[..., 0] / 255 * 360, hsv[..., 1] / 255, hsv[..., 2] / 255
m = (h > 38) & (h < 90) & (s > 0.38) & (v > 0.55)
m = ndi.binary_opening(m, iterations=2)
m = ndi.binary_closing(m, iterations=3)
m = ndi.binary_erosion(m, iterations=1)

BLOCKS = {  # polygones (px image) à rendre infranchissables
    "foret_sylve": [
        [(650, 100), (990, 100), (1000, 270), (930, 335), (700, 335), (650, 240)],   # couronne du grand arbre
        [(95, 430), (255, 430), (255, 615), (95, 615)],                               # arbres dorés
        [(1090, 350), (1190, 350), (1190, 420), (1090, 420)],
        [(480, 925), (1080, 925), (1080, 1024), (480, 1024)],                         # bord de falaise
    ]}
STROKES = {  # traits (px image, épaisseur) à rendre franchissables
    "foret_sylve": [
        ([(500, 300), (450, 265), (420, 235), (400, 190), (365, 140)], 46),          # pont + entrée feuille
        ([(300, 630), (340, 665), (430, 690), (520, 690)], 46),                       # entrée patte
        ([(1120, 745), (1235, 705)], 46),                                             # entrée cristal
        ([(1010, 420), (1050, 350), (1130, 325), (1200, 300), (1260, 255), (1295, 225)], 44),  # entrée violette
        ([(790, 520), (790, 440)], 46),                                               # pied du grand arbre
        ([(540, 700), (600, 765), (700, 815), (800, 845), (900, 870)], 46),           # sentier du sud
        ([(1290, 760), (1400, 790)], 40),
    ]}
img = Image.fromarray((m * 255).astype("uint8"))
d = ImageDraw.Draw(img)
for poly in BLOCKS.get(name, []):
    d.polygon(poly, fill=0)
for pts, w in STROKES.get(name, []):
    d.line(pts, fill=255, width=w)
    for p in pts:
        d.ellipse([p[0] - w // 2, p[1] - w // 2, p[0] + w // 2, p[1] + w // 2], fill=255)
m = np.asarray(img) > 127
grid = np.zeros((ROWS, COLS), bool)
for gy in range(ROWS):
    for gx in range(COLS):
        blk = m[gy * CELL:(gy + 1) * CELL, gx * CELL:(gx + 1) * CELL]
        grid[gy, gx] = blk.size > 0 and blk.mean() >= 0.4

def near(px, py):
    cx, cy = px // CELL, py // CELL
    best, bd = None, 1e9
    for y in range(ROWS):
        for x in range(COLS):
            if grid[y, x]:
                dd = (x - cx) ** 2 + (y - cy) ** 2
                if dd < bd:
                    best, bd = (x, y), dd
    return best

start = near(860, 560)
lab, n = ndi.label(grid)
keep = lab == lab[start[1], start[0]]
grid = keep

POIS = [  # (pixel x, y, définition)
    (360, 150, {"kind": "combat", "guardian": "Forêt#1", "name": "Grotte de la Feuille", "desc": "Un terrier moussu : quatre salles, la plus douce des entrées."}),
    (310, 640, {"kind": "combat", "guardian": "Forêt#2", "name": "Antre de la Patte", "desc": "Le territoire d'une grande bête : quatre salles."}),
    (1235, 715, {"kind": "combat", "guardian": "Forêt#3", "name": "Sanctuaire de Cristal", "desc": "Des cristaux chantent dans l'ombre : quatre salles."}),
    (1295, 235, {"kind": "combat", "guardian": "Forêt#4", "name": "Crypte du Chêne Noir", "desc": "Une porte violette sous les racines : quatre salles, très dures."}),
    (790, 450, {"kind": "combat", "guardian": "Forêt", "name": "Donjon de la Nation Sylvestre", "desc": "Le Grand Arbre : quatre salles ; le Gardien veille sur la Pierre de Sève."}),
    (620, 300, {"kind": "combat", "name": "Camp gobelin", "level": 1, "desc": "Des gobelins ont dressé leurs tentes."}),
    (1000, 440, {"kind": "combat", "name": "Embuscade sous les pins", "level": 3, "desc": "Des brigands guettent le sentier."}),
    (500, 570, {"kind": "combat", "name": "Tanière du sanglier", "level": 2, "desc": "Un grand sanglier défend sa bauge."}),
    (1100, 800, {"kind": "combat", "name": "Meute de loups gris", "level": 4, "desc": "Des hurlements montent des fourrés."}),
    (900, 880, {"kind": "combat", "name": "Patrouille de la Citadelle", "level": 12, "desc": "Des soldats des Ronces rôdent ici."}),
    (240, 380, {"kind": "chest", "name": "Coffre moussu", "level": 1, "desc": "Un coffre à demi enseveli sous la mousse."}),
    (1180, 420, {"kind": "chest", "name": "Souche creuse", "level": 2, "desc": "Quelque chose brille au fond de la souche."}),
    (700, 800, {"kind": "chest", "name": "Cache du bûcheron", "level": 3, "desc": "Un coffre dissimulé sous des fagots."}),
    (560, 480, {"kind": "camp", "name": "Source claire", "level": 1, "desc": "Un endroit sûr pour reprendre souffle."}),
    (1000, 640, {"kind": "camp", "name": "Clairière des lucioles", "level": 1, "desc": "Des lucioles dansent autour d'un feu tranquille."}),
    (700, 540, {"kind": "puzzle", "name": "Cercle des pierres chantantes", "level": 1, "desc": "Des menhirs s'illuminent puis se taisent."}),
    (930, 520, {"kind": "puzzle", "name": "Sanctuaire des runes", "level": 1, "desc": "De vieilles runes attendent une réponse."}),
    (1010, 330, {"kind": "reveal", "name": "Belvédère de la Sylve", "level": 1, "desc": "Du haut de l'arbre, la vallée se dévoile."}),
]
pois = {}
for px, py, dfn in POIS:
    c = near(px, py)
    if c is None or c in [tuple(map(int, k.split(","))) for k in pois]:
        continue
    if abs(c[0] - px // CELL) + abs(c[1] - py // CELL) > 4:
        print("AVERTISSEMENT lieu éloigné de sa place :", dfn["name"], c, (px // CELL, py // CELL))
    pois["%d,%d" % c] = dfn

out = {"image": "res://assets/boards/%s.jpg" % name, "image_size": [W, H], "cell_px": CELL,
       "cols": COLS, "rows": ROWS, "start": list(start),
       "mask": ["".join("#" if grid[y, x] else "." for x in range(COLS)) for y in range(ROWS)],
       "pois": pois}
json.dump(out, open("data/boards/%s.json" % name, "w"), ensure_ascii=False, indent=0)
im.save("assets/boards/%s.jpg" % name, quality=92)
ov = np.asarray(im).copy()
for y in range(ROWS):
    for x in range(COLS):
        if grid[y, x]:
            ov[y * CELL:(y + 1) * CELL, x * CELL:(x + 1) * CELL] = (0.55 * ov[y * CELL:(y + 1) * CELL, x * CELL:(x + 1) * CELL] + 0.45 * np.array([255, 0, 255])).astype("uint8")
img2 = Image.fromarray(ov)
dr = ImageDraw.Draw(img2)
for k, dfn in pois.items():
    x, y = map(int, k.split(","))
    dr.ellipse([x * CELL - 6, y * CELL - 6, x * CELL + 30, y * CELL + 30], outline=(255, 255, 0), width=4)
img2.save("/tmp/claude-0/pl/board_overlay.png")
print("grille", COLS, ROWS, "cases jouables", int(grid.sum()), "lieux", len(pois), "départ", start)
