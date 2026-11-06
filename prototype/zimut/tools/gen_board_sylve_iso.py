#!/usr/bin/env python3
"""Plateau isométrique à étages de la Nation Sylvestre (V106, option « Iso »).

Génère data/boards/foret_sylve_iso.json : grille COLS×ROWS de petites cases (80×40 px à l'écran),
hauteurs par case (en quarts d'étage, 4 = un étage), masque jouable, sentiers, obstacles, décors,
départ et lieux : 4 donjons de champ + 1 donjon final (de plus en plus haut) et le portail du sommet.
Usage : python3 tools/gen_board_sylve_iso.py [overlay.png]
"""
import json, sys, math, random
from collections import deque
from pathlib import Path

COLS, ROWS = 76, 54
UNIT = 4                      # quarts d'étage par étage ; marche permise si |Δh| <= 1
SUMMIT = (19.0, 13.0)
rng = random.Random(1062)

# ── Île et étages : anneaux de hauteur autour du sommet (nord-ouest), bruités ──────────────
def noise(x, y):
    return (3.2 * math.sin(x * 0.21 + 1.3) + 3.0 * math.sin(y * 0.27 + 0.4) + 2.2 * math.sin((x + y) * 0.15 + 2.0)
            + 1.6 * math.sin((x - y) * 0.23 + 0.7))

def inside(x, y):
    e = ((x - 38.0) / 36.5) ** 2 + ((y - 27.0) / 25.0) ** 2
    e += 0.045 * math.sin(x * 0.55 + y * 0.31) + 0.035 * math.sin(y * 0.8 - x * 0.2)
    return e < 1.0 and 2 <= x < COLS - 2 and 2 <= y < ROWS - 2

land = [[inside(x, y) for x in range(COLS)] for y in range(ROWS)]
LV = [[0] * COLS for _ in range(ROWS)]
for y in range(ROWS):
    for x in range(COLS):
        d = math.hypot((x - SUMMIT[0]) * 0.95, (y - SUMMIT[1]) * 1.25) + noise(x, y)
        LV[y][x] = 3 if d < 10 else 2 if d < 21 else 1 if d < 33 else 0

def nb(x, y):
    for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
        if 0 <= x + dx < COLS and 0 <= y + dy < ROWS:
            yield x + dx, y + dy

# lisse : aucune case isolée à un autre étage que ses voisins
for _ in range(4):
    for y in range(ROWS):
        for x in range(COLS):
            ns = [LV[b][a] for a, b in nb(x, y)]
            if ns and sum(1 for v in ns if v != LV[y][x]) >= 3:
                LV[y][x] = max(set(ns), key=ns.count)
# jamais plus d'un étage d'écart entre voisins
for _ in range(6):
    for y in range(ROWS):
        for x in range(COLS):
            for a, b in nb(x, y):
                if LV[b][a] - LV[y][x] > 1:
                    LV[b][a] = LV[y][x] + 1

H = [[LV[y][x] * UNIT for x in range(COLS)] for y in range(ROWS)]

# ── Rampes : 2 par étage, 3 cases de large, 3 cases de long (pente d'un quart d'étage par case) ──
ramps = []
def try_ramp(lv, cx, cy, d):
    """Rampe qui monte depuis la case basse (cx, cy) dans la direction d (dx, dy)."""
    dx, dy = d
    px, py = (-dy, dx)  # perpendiculaire
    cells = []
    for k in range(1, 5):
        for s in (-1, 0, 1):
            x, y = cx + dx * k + px * s, cy + dy * k + py * s
            if not (0 <= x < COLS and 0 <= y < ROWS) or not land[y][x]:
                return None
            if LV[y][x] != lv + 1:
                return None
            cells.append((k, x, y))
    for s in (-1, 0, 1):
        x, y = cx + px * s, cy + py * s
        if not (0 <= x < COLS and 0 <= y < ROWS) or not land[y][x] or LV[y][x] != lv:
            return None
    return cells

def carve(lv, cells):
    for k, x, y in cells:
        if k <= 3:
            H[y][x] = lv * UNIT + k
    ramps.append((lv, cells))

wanted = {0: [(0.30, 0.45)], 1: [(0.30, 0.75)], 2: [(0.40, 0.85)]}  # inutilisé : tri par angle ci-dessous
for lv in (0, 1, 2):
    cands = []
    for y in range(ROWS):
        for x in range(COLS):
            if LV[y][x] != lv or not land[y][x]:
                continue
            for d in ((-1, 0), (0, -1)):
                c = try_ramp(lv, x, y, d)
                if c:
                    ang = math.atan2(y - SUMMIT[1], x - SUMMIT[0])
                    cands.append((ang, x, y, d, c))
    cands.sort()
    picks = []
    # une rampe côté « sud-est » (face au joueur) et une côté opposé de l'anneau
    for target in ((0.55, 0.9), (1.25, 1.6)) if lv != 1 else ((0.1, 0.45), (1.0, 1.5)):
        sel = [c for c in cands if target[0] <= c[0] <= target[1]]
        if not sel:
            sel = sorted(cands, key=lambda c: abs(c[0] - sum(target) / 2))[:1]
        picks.append(sel[len(sel) // 2])
    for _a, x, y, d, c in picks:
        if all(H[yy][xx] == lv * UNIT + UNIT for k, xx, yy in c if k <= 3) or True:
            carve(lv, c)

# ── Masque jouable : l'île entière ; les rampes sont franchissables ──
walk = [[land[y][x] for x in range(COLS)] for y in range(ROWS)]

def step_ok(a, b):
    return abs(H[b[1]][b[0]] - H[a[1]][a[0]]) <= 1

def bfs(start, blocked=frozenset()):
    seen = {start: None}
    q = deque([start])
    while q:
        cur = q.popleft()
        for n in nb(*cur):
            if n in seen or not walk[n[1]][n[0]] or n in blocked or not step_ok(cur, n):
                continue
            seen[n] = cur
            q.append(n)
    return seen

# ── Lieux (positions visées, recalées sur une case plate libre de l'étage voulu) ──
def snap(tx, ty, lv, radius=2):
    best = None
    for y in range(ROWS):
        for x in range(COLS):
            if not walk[y][x] or LV[y][x] != lv:
                continue
            if any(not (0 <= x + i < COLS and 0 <= y + j < ROWS) or not walk[y + j][x + i] or H[y + j][x + i] != lv * UNIT
                   for i in range(-radius, radius + 1) for j in range(-radius, radius + 1)):
                continue
            dd = (x - tx) ** 2 + (y - ty) ** 2
            if best is None or dd < best[0]:
                best = (dd, x, y)
    return best[1:] if best else None

def poi(kind, name, desc, **kw):
    return dict(kind=kind, name=name, desc=desc, **kw)

PLAN = [
    # (cible x, y, étage, clé, poi)
    (50, 40, 0, poi("combat", "Grotte de la Feuille", "Un terrier moussu : quatre salles, la plus douce des entrées.", guardian="Forêt#1")),
    (22, 44, 0, poi("camp", "Source claire", "Un endroit sûr pour reprendre souffle.", level=1)),
    (62, 33, 0, poi("combat", "Camp gobelin", "Des gobelins ont dressé leurs tentes.", level=2)),
    (60, 46, 0, poi("chest", "Coffre moussu", "Un coffre à demi enseveli sous la mousse.", level=1)),
    (36, 47, 0, poi("combat", "Tanière du sanglier", "Un grand sanglier défend sa bauge.", level=4)),
    (68, 40, 0, poi("combat", "Meute de loups gris", "Des hurlements montent des fourrés.", level=5)),
    (30, 36, 1, poi("combat", "Antre de la Patte", "Le territoire d'une grande bête : quatre salles.", guardian="Forêt#2")),
    (46, 30, 1, poi("camp", "Clairière des lucioles", "Des lucioles dansent autour d'un feu tranquille.", level=1)),
    (56, 24, 1, poi("combat", "Embuscade sous les pins", "Des brigands guettent le sentier.", level=7)),
    (40, 38, 1, poi("chest", "Souche creuse", "Quelque chose brille au fond de la souche.", level=2)),
    (22, 30, 1, poi("combat", "Poste de la Citadelle", "Des soldats des Ronces rôdent ici.", level=9)),
    (44, 20, 2, poi("combat", "Sanctuaire de Cristal", "Des cristaux chantent dans l'ombre : quatre salles.", guardian="Forêt#3")),
    (32, 22, 2, poi("combat", "Crypte du Chêne Noir", "Une porte bleutée sous les racines : quatre salles, très dures.", guardian="Forêt#4")),
    (36, 26, 2, poi("camp", "Refuge des hauteurs", "Un abri de pierre à flanc de falaise.", level=1)),
    (50, 14, 2, poi("chest", "Cache du bûcheron", "Un coffre dissimulé sous des fagots.", level=3)),
    (26, 18, 2, poi("combat", "Garde des cimes", "Des soldats montent la garde sur la terrasse.", level=13)),
    (38, 12, 2, poi("combat", "Antre du prédateur", "Un prédateur guette depuis les rochers.", level=15)),
    (16, 12, 3, poi("combat", "Donjon de la Nation Sylvestre", "Le Grand Arbre : quatre salles ; le Gardien veille sur la Pierre de Sève.", guardian="Forêt")),
    (24, 8, 3, poi("reveal", "Belvédère de la Sylve", "Du haut de l'arbre, toute l'île se dévoile.", level=1)),
    (12, 17, 3, poi("exit", "Portail vers les Cendres", "Un portail de lumière, scellé tant que le Gardien règne.", level=1,
                    portal=True, requires="Forêt", to="brasier_cendres")),
]
POIS = {}
used = []
for tx, ty, lv, p in PLAN:
    s = snap(tx, ty, lv)
    if s is None:
        s = snap(tx, ty, lv, radius=1)
    if s is None:
        print("PAS DE PLACE :", p["name"]); sys.exit(1)
    # distance minimale entre lieux
    while any(abs(s[0] - u[0]) + abs(s[1] - u[1]) < 4 for u in used):
        tx += 1
        s2 = snap(tx, ty, lv)
        if s2 is None: break
        s = s2
    used.append(s)
    POIS["%d,%d" % s] = p
# départ : devant, près de la première entrée, à l'étage 0
START = snap(56, 43, 0)
if START is None: START = snap(50, 44, 0)
START = list(START)

# ── Contrôle : tout est atteignable (avec pente), sans traverser une cliff ──
reach = bfs(tuple(START))
bad = [k for k in POIS if tuple(map(int, k.split(","))) not in reach]
print("lieux inaccessibles :", bad)
if bad: sys.exit(2)

# ── Sentiers : chemins du départ vers chaque lieu ──
trail = set()
order = sorted(POIS, key=lambda k: H[int(k.split(",")[1])][int(k.split(",")[0])])
hubs = [tuple(START)]
for k in order:
    t = tuple(map(int, k.split(",")))
    seen = bfs(hubs[-1] if False else tuple(START))
    # chemin depuis le sentier existant le plus proche (réseau en arbre)
    best = None
    seen_all = None
    # BFS multi-source depuis le réseau déjà tracé
    srcs = list(trail) or [tuple(START)]
    prev = {s: None for s in srcs}
    q = deque(srcs)
    while q:
        cur = q.popleft()
        if cur == t: break
        for n in nb(*cur):
            if n in prev or not walk[n[1]][n[0]] or not step_ok(cur, n):
                continue
            prev[n] = cur
            q.append(n)
    cur = t
    while cur is not None and cur in prev:
        trail.add(cur)
        cur = prev[cur]
trail.add(tuple(START))

# ── Obstacles (arbres, rochers…) et décors de sol ──
protected = set(trail) | {tuple(START)}
for k in POIS:
    px, py = map(int, k.split(","))
    for i in range(-2, 3):
        for j in range(-2, 3):
            protected.add((px + i, py + j))
for lv, cells in ramps:
    for k, x, y in cells:
        for i in (-1, 0, 1):
            for j in (-1, 0, 1):
                protected.add((x + i, y + j))
OBST = ["tree"] * 5 + ["pine"] * 3 + ["big_tree"] * 2 + ["rock"] * 2 + ["bush", "stump", "log"]
GROUND = ["flowers", "grass", "grass", "mushrooms", "flowers", "grass", "grass"]
obstacles, decor = {}, {}
ratio = {0: 0.15, 1: 0.17, 2: 0.15, 3: 0.11}
for y in range(ROWS):
    for x in range(COLS):
        if not walk[y][x] or (x, y) in protected:
            continue
        lv = LV[y][x]
        if rng.random() < ratio[lv] * 1.0:
            obstacles["%d,%d" % (x, y)] = rng.choice(OBST)
        elif rng.random() < 0.20:
            decor["%d,%d" % (x, y)] = rng.choice(GROUND)
# bosquets : voisin de temps en temps
for k in list(obstacles):
    x, y = map(int, k.split(","))
    if rng.random() < 0.35:
        n = (x + rng.choice((-1, 1, 0, 0)), y + rng.choice((-1, 1, 0, 0)))
        if walk[n[1]][n[0]] and n not in protected and "%d,%d" % n not in obstacles and 0 <= n[0] < COLS and 0 <= n[1] < ROWS:
            obstacles["%d,%d" % n] = rng.choice(OBST)
# ── Bâtiments (V106) : emprises plates et libres, nom, taille en cases ──
BUILDINGS = []
SIZES = {"maison": (3, 3), "chaumiere": (3, 2), "grange": (4, 3), "moulin": (3, 3), "tour": (3, 3), "chapelle": (3, 3)}
BPLAN = [  # (type, cible x, y, étage)
    ("maison", 55, 35, 0), ("chaumiere", 60, 39, 0), ("maison", 52, 33, 0), ("grange", 65, 36, 0), ("moulin", 42, 44, 0),
    ("chaumiere", 28, 44, 0),
    ("chaumiere", 42, 34, 1), ("tour", 52, 27, 1), ("maison", 24, 34, 1),
    ("chapelle", 42, 24, 2), ("tour", 30, 16, 2),
    ("chapelle", 22, 13, 3),
]
occupied = set()
def free_rect(x0, y0, w, h, lv):
    for yy in range(y0 - 1, y0 + h + 1):
        for xx in range(x0 - 1, x0 + w + 1):
            if not (0 <= xx < COLS and 0 <= yy < ROWS) or not walk[yy][xx] or (xx, yy) in occupied:
                return False
            inner = x0 <= xx < x0 + w and y0 <= yy < y0 + h
            if H[yy][xx] != lv * UNIT or (inner and (xx, yy) in protected_core) or (xx, yy) in ramp_cells:
                return False
    return True
protected_core = set(trail) | {tuple(START)}
for k in POIS:
    px, py = map(int, k.split(","))
    for i in range(-2, 3):
        for j in range(-2, 3):
            protected_core.add((px + i, py + j))
ramp_cells = {(x, y) for lv, cells in ramps for k, x, y in cells}
for typ, tx, ty, lv in BPLAN:
    w, h = SIZES[typ]
    best = None
    for y0 in range(ROWS):
        for x0 in range(COLS):
            if LV[y0][x0] == lv and free_rect(x0, y0, w, h, lv):
                dd = (x0 - tx) ** 2 + (y0 - ty) ** 2
                if best is None or dd < best[0]:
                    best = (dd, x0, y0)
    if best is None:
        print("bâtiment sans place :", typ, tx, ty); continue
    _, x0, y0 = best
    BUILDINGS.append(dict(k=typ, x=x0, y=y0, w=w, h=h))
    for yy in range(y0 - 1, y0 + h + 1):
        for xx in range(x0 - 1, x0 + w + 1):
            occupied.add((xx, yy))
            obstacles.pop("%d,%d" % (xx, yy), None); decor.pop("%d,%d" % (xx, yy), None)
    for yy in range(y0, y0 + h):
        for xx in range(x0, x0 + w):
            obstacles["%d,%d" % (xx, yy)] = "building"
# sécurité : tout reste atteignable
blocked = {tuple(map(int, k.split(","))) for k in obstacles}
reach2 = bfs(tuple(START), frozenset(blocked))
for k in POIS:
    t = tuple(map(int, k.split(",")))
    guard = 0
    while t not in bfs(tuple(START), frozenset(blocked)) and guard < 400:
        guard += 1
        cands_rm = [o for o in blocked if obstacles.get("%d,%d" % o) != "building"]
        if not cands_rm: break
        near = min(cands_rm, key=lambda o: abs(o[0] - t[0]) + abs(o[1] - t[1]))
        blocked.discard(near); obstacles.pop("%d,%d" % near, None)
for k in list(decor):
    if k in obstacles: del decor[k]

mask = ["".join("#" if walk[y][x] else "." for x in range(COLS)) for y in range(ROWS)]
heights = ["".join(chr(ord("0") + H[y][x] // 1) if H[y][x] < 10 else chr(ord("a") + H[y][x] - 10) for x in range(COLS)) for y in range(ROWS)]
out = dict(iso=True, cols=COLS, rows=ROWS, unit=UNIT, cell_scale=0.625, start=START, mask=mask, heights=heights,
           trail=["%d,%d" % c for c in sorted(trail)], buildings=BUILDINGS, obstacles=obstacles, decor=decor, pois=POIS)
dst = Path(__file__).resolve().parent.parent / "data/boards/foret_sylve_iso.json"
dst.write_text(json.dumps(out, ensure_ascii=False, indent=0))
bad2 = [k for k in POIS if tuple(map(int, k.split(","))) not in bfs(tuple(START), frozenset(blocked))]
print("lieux inaccessibles (après bâtiments) :", bad2, "| bâtiments :", [(b["k"], b["x"], b["y"]) for b in BUILDINGS])
print("écrit", dst, "| cases", sum(r.count("#") for r in mask), "| obstacles", len(obstacles), "| décors", len(decor), "| départ", START)
for k, p in sorted(POIS.items(), key=lambda kv: kv[1].get("guardian", "z")):
    x, y = map(int, k.split(","))
    print(" ", k, "étage", LV[y][x], p["name"], p.get("guardian", ""))

if len(sys.argv) > 1:
    from PIL import Image, ImageDraw
    S = 12
    im = Image.new("RGB", (COLS * S, ROWS * S), (20, 30, 40))
    d = ImageDraw.Draw(im)
    shade = {0: (88, 150, 70), 1: (110, 168, 80), 2: (150, 182, 96), 3: (200, 205, 120)}
    for y in range(ROWS):
        for x in range(COLS):
            if walk[y][x]:
                base = shade[LV[y][x]]
                f = 1.0 + (H[y][x] - LV[y][x] * UNIT) * 0.04
                d.rectangle([x * S, y * S, x * S + S - 1, y * S + S - 1], fill=tuple(min(255, int(c * f)) for c in base))
    for (x, y) in trail:
        d.rectangle([x * S + 3, y * S + 3, x * S + S - 4, y * S + S - 4], fill=(205, 170, 110))
    for k in obstacles:
        x, y = map(int, k.split(",")); d.ellipse([x * S + 2, y * S + 2, x * S + S - 3, y * S + S - 3], fill=(30, 90, 40))
    for k, p in POIS.items():
        x, y = map(int, k.split(","))
        col = (255, 0, 0) if p.get("guardian") else (255, 255, 255) if p["kind"] != "exit" else (0, 200, 255)
        d.ellipse([x * S - 4, y * S - 4, x * S + S + 4, y * S + S + 4], outline=col, width=3)
    d.ellipse([START[0] * S, START[1] * S, START[0] * S + S, START[1] * S + S], fill=(255, 255, 0))
    im.save(sys.argv[1])
