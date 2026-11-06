#!/usr/bin/env python3
"""Planches TEMPORAIRES du Brasier (brasier_cendres) et des Brumes (brumes_marais).

Génère data/boards/brasier_cendres_v2.json et brumes_marais_v2.json : masque 96×72 (cases de 16 px),
départ, 5 donjons (paliers 1 à 4 + final), portail vers la Nation suivante, lieux.
Coordonnées en CASES sur l'image 1536×1152 (assets/boards/Brasier.png / Brumes.png).
Usage : python3 tools/gen_boards_brasier_brumes.py [dossier_overlays]
"""
import json, sys
from pathlib import Path
from collections import deque
from PIL import Image, ImageDraw

CELL, W, H = 16, 1536, 1152
COLS, ROWS = W // CELL, H // CELL
S = 4
ROOT = Path(__file__).resolve().parent.parent

class Board:
    def __init__(self):
        self.walk = Image.new("L", (COLS * S, ROWS * S), 0)
        self.block = Image.new("L", (COLS * S, ROWS * S), 0)
        self.wd, self.bd = ImageDraw.Draw(self.walk), ImageDraw.Draw(self.block)
    @staticmethod
    def px(p): return (p[0] * S, p[1] * S)
    def poly(self, pts, block=False): (self.bd if block else self.wd).polygon([self.px(p) for p in pts], fill=255)
    def ellipse(self, c, rx, ry, block=False):
        (self.bd if block else self.wd).ellipse([self.px((c[0]-rx, c[1]-ry)), self.px((c[0]+rx, c[1]+ry))], fill=255)
    def stroke(self, pts, w):
        self.wd.line([self.px(p) for p in pts], fill=255, width=int(w * S), joint="curve")
        for p in pts: self.ellipse(p, w / 2, w / 2)
    def rows(self):
        m = [[self.walk.getpixel((x*S + S//2, y*S + S//2)) > 0 and self.block.getpixel((x*S + S//2, y*S + S//2)) == 0
              for x in range(COLS)] for y in range(ROWS)]
        return ["".join("#" if c else "." for c in r) for r in m]

def poi(kind, name, desc, **kw): return dict(kind=kind, name=name, desc=desc, **kw)

# ══ BRASIER ═══════════════════════════════════════════════════════
b = Board()
b.poly([(28, 45), (40, 42), (52, 41), (62, 43), (70, 45), (72, 50), (68, 56), (58, 59), (46, 59), (36, 57), (30, 52)])   # prairie centrale
b.poly([(46, 35), (52, 35), (52, 41), (46, 41)])                                          # marches du grand arbre
b.stroke([(30, 46), (28, 43), (25, 41), (23, 39), (21, 37)], 2.8)                          # vers la maison de gauche
b.poly([(18, 36), (25, 36), (25, 40), (18, 40)])
b.stroke([(68, 46), (70, 44), (73, 43), (76, 42), (77, 41)], 2.8)                          # vers la maison de droite
b.poly([(72, 40), (80, 40), (80, 44), (72, 44)])
b.poly([(60, 54), (68, 54), (68, 58), (60, 58)])                                           # bâtiment sud-est
b.stroke([(52, 38), (58, 34), (62, 30), (65, 26), (68, 22), (69, 18)], 2.6)                # vers l'arbre-maison
b.poly([(65, 17), (73, 17), (73, 21), (65, 21)])
b.stroke([(46, 38), (40, 34), (34, 30), (30, 26), (28, 22), (29, 17), (30, 14)], 2.6)     # vers le manoir nord-ouest
b.poly([(26, 13), (34, 13), (34, 17), (26, 17)])
for c in [(35, 41), (42, 46.5), (58, 45)]: b.ellipse(c, 1.3, 1.3, True)                    # cabanes
BRASIER = dict(image="Brasier.png", start=[49, 43], rows=b.rows(), pois={
    "64,54": poi("combat", "Mine de Braise", "Une bâtisse noire dont la porte rougeoie : quatre salles, la plus douce des entrées.", guardian="Brasier#1"),
    "21,36": poi("combat", "Fosse Ardente", "Une maison au bord du fleuve de lave : quatre salles.", guardian="Brasier#2"),
    "77,41": poi("combat", "Chapelle des Cendres", "Une chapelle où brûle une flamme éternelle : quatre salles, plus dures.", guardian="Brasier#3"),
    "30,14": poi("combat", "Manoir de Lave", "Le manoir surplombe la cascade de feu : quatre salles, très dures.", guardian="Brasier#4"),
    "49,37": poi("combat", "Donjon de la Nation Brasier", "Le Grand Arbre ardent : quatre salles ; le Gardien veille sur la Pierre de Braise.", guardian="Brasier"),
    "69,18": poi("exit", "Portail des Brumes", "Un portail de braise s'ouvre sur la Nation suivante : les Marais des Brumes.", level=25, portal=True, requires="Brasier", to="brumes_marais"),
    "36,50": poi("combat", "Lieutenants de braise", "Des soldats de feu montent la garde.", level=19),
    "58,50": poi("combat", "Golem de lave", "Un colosse de roche en fusion.", level=21),
    "24,41": poi("combat", "Gardes du fleuve", "Ils surveillent le fleuve de lave.", level=22),
    "74,43": poi("combat", "Chevaliers cendrés", "Des chevaliers calcinés barrent la route.", level=23),
    "44,56": poi("chest", "Forge abandonnée", "Une forge oubliée, encore tiède.", level=20),
    "66,47": poi("chest", "Coffre de scories", "Un coffre noirci posé au bord de la lave.", level=22),
    "50,52": poi("camp", "Source chaude", "Une source bienfaisante.", level=18),
    "46,46": poi("puzzle", "Brasero oraculaire", "Les flammes posent une question.", level=20),
    "60,32": poi("reveal", "Cratère-belvédère", "Du bord du cratère on voit loin.", level=18),
})

# ══ BRUMES ════════════════════════════════════════════════════════
m = Board()
m.poly([(20, 42), (30, 41), (46, 41), (56, 43), (62, 46), (66, 52), (62, 58), (52, 62), (40, 64), (30, 62), (24, 56), (20, 48)])   # sol autour de la serre
m.stroke([(24, 44), (20, 41), (16, 39), (12, 37.5), (11, 36.5)], 2.8)                       # dôme de gauche
m.poly([(8, 34), (15, 34), (15, 39), (8, 39)])
m.stroke([(14, 34), (16, 30), (18, 26), (19, 22), (18.5, 19)], 2.6)                         # arche-portail
m.poly([(15, 17), (22, 17), (22, 21), (15, 21)])
m.poly([(34, 62), (42, 62), (42, 67), (34, 67)])                                            # rotonde sud
m.poly([(54, 57), (62, 57), (62, 63), (54, 63)])                                            # petit dôme sud-est
m.stroke([(64, 52), (67, 50), (69, 47), (70, 45)], 2.8)                                     # porte violette
m.poly([(66, 44), (75, 44), (75, 47), (66, 47)])
m.stroke([(56, 43), (58, 38), (60, 34), (62, 30), (63, 26), (64, 22), (65, 19)], 2.6)       # maison-champignon
m.poly([(60, 18), (70, 18), (70, 21), (60, 21)])
m.poly([(33, 40), (42, 40), (42, 43), (33, 43)])                                            # seuil de la serre
BRUMES = dict(image="Brumes.png", start=[40, 46], rows=m.rows(), pois={
    "57,60": poi("combat", "Grotte Moussue", "Un petit dôme moussu perdu dans la brume : quatre salles, l'entrée la plus douce.", guardian="Brumes#1"),
    "71,44": poi("combat", "Chapelle de Lune", "Un vitrail violet luit dans la brume : quatre salles.", guardian="Brumes#2"),
    "11,36": poi("combat", "Dôme des Brumes", "Une rotonde de verre embuée : quatre salles, plus dures.", guardian="Brumes#3"),
    "65,18": poi("combat", "Maison-Champignon", "Un champignon géant habité : quatre salles, très dures.", guardian="Brumes#4"),
    "37,41": poi("combat", "Donjon de la Nation Brumes", "La grande serre de verre : quatre salles ; le Gardien veille sur la Pierre de Lune-des-Marais.", guardian="Brumes"),
    "18,19": poi("exit", "Portail des Cimes", "Une arche couverte de lierre s'ouvre sur la Nation suivante : les Hauts Pics du Givre.", level=31, portal=True, requires="Brumes", to="montagne_pics"),
    "30,47": poi("combat", "Rôdeurs brumeux", "Des formes se glissent dans la brume.", level=27),
    "48,53": poi("combat", "Liche du marais", "Un mort-vivant garde le marais.", level=29),
    "60,30": poi("combat", "Spectres du sentier", "Des spectres hantent le sentier.", level=30),
    "16,30": poi("combat", "Goules des cascades", "Elles rôdent près des chutes.", level=28),
    "44,58": poi("chest", "Coffre englouti", "Un coffre à moitié enfoui dans la vase.", level=26),
    "37,64": poi("chest", "Rotonde oubliée", "Une rotonde dont la porte luit encore.", level=28),
    "62,23": poi("chest", "Trésor du champignon", "Quelque chose brille sous le chapeau.", level=29),
    "52,48": poi("camp", "Cabane sur pilotis", "Un refuge au-dessus de l'eau.", level=26),
    "34,48": poi("puzzle", "Champignon sage", "Un grand champignon pose une devinette.", level=27),
    "17,26": poi("reveal", "Arbre des esprits", "On voit loin depuis ses branches.", level=26),
})

def build(zone, name, d, outdir):
    rows = d["rows"]
    out = dict(image="res://assets/boards/" + d["image"], image_size=[W, H], cell_px=CELL, cols=COLS, rows=ROWS,
               start=d["start"], mask=rows, pois=d["pois"])
    (ROOT / "data/boards" / (zone + "_v2.json")).write_text(json.dumps(out, ensure_ascii=False, indent=0))
    start = tuple(d["start"]); seen, q = {start}, deque([start])
    while q:
        x, y = q.popleft()
        for dx, dy in ((1,0),(-1,0),(0,1),(0,-1)):
            n = (x+dx, y+dy)
            if 0 <= n[0] < COLS and 0 <= n[1] < ROWS and rows[n[1]][n[0]] == "#" and n not in seen:
                seen.add(n); q.append(n)
    bad = [k for k in d["pois"] if tuple(map(int, k.split(","))) not in seen]
    print(name, "cases jouables :", sum(r.count("#") for r in rows), "| départ jouable :", rows[start[1]][start[0]] == "#", "| inaccessibles :", bad)
    if outdir:
        im = Image.open(ROOT / "assets/boards" / d["image"]).convert("RGBA")
        ov = Image.new("RGBA", im.size, (0, 0, 0, 0)); g = ImageDraw.Draw(ov)
        for y, r in enumerate(rows):
            for x, c in enumerate(r):
                if c == "#": g.rectangle([x*CELL, y*CELL, x*CELL+CELL-1, y*CELL+CELL-1], fill=(255, 40, 200, 90) if (x, y) in seen else (255, 255, 0, 140))
        for k, p in d["pois"].items():
            x, y = map(int, k.split(",")); col = (255, 0, 0, 255) if p.get("guardian") else ((0, 255, 255, 255) if p.get("portal") else (0, 0, 255, 255))
            g.ellipse([x*CELL-6, y*CELL-6, x*CELL+22, y*CELL+22], outline=col, width=4)
        g.ellipse([start[0]*CELL, start[1]*CELL, start[0]*CELL+16, start[1]*CELL+16], fill=(255, 255, 255, 255))
        Image.alpha_composite(im, ov).convert("RGB").save(Path(outdir) / (zone + "_overlay.png"))

outdir = sys.argv[1] if len(sys.argv) > 1 else None
build("brasier_cendres", "Brasier", BRASIER, outdir)
build("brumes_marais", "Brumes", BRUMES, outdir)
