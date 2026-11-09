#!/usr/bin/env python3
"""Sylve 48x48 v2 : bâtiments plus grands et variés, champs, prairies, forêt allégée -> objects.json."""
import json, math, io, contextlib, runpy, sys, os, numpy as np, cv2
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from plan96 import V_ROADS as ROADS, V_FIELDS as FIELDS, V_MEADOWS as MEADOWS, V_ORCHARD as ORCHARD, OFF
import plan96 as W
rng = np.random.default_rng(23)
S = 48.0
C = 24.0
NAT = os.environ.get("QUATERNIUS_NATURE", "/tmp/kits/nature/Stylized Nature MegaKit[Standard]/glTF/")
KT = os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), "../../../..")) + "/atelier_3d/kenney/"
H = np.load("height.npy")          # monde 96, en unités
PATH = np.load("mask_path.npy")    # monde 96
PR = PATH.shape[0]
SW = W.S
GS = 1.3   # agrandissement des bâtiments

with contextlib.redirect_stdout(io.StringIO()):
    ns = runpy.run_path(KT + "../../tools/kenney_batiments_jobs.py")
jobs = {j["name"]: j for j in ns["jobs"]}

def P(f, x, y, z, r=0, sc=None):
    d = {"f": f, "p": [x, y, z], "r": r}
    if sc: d["sc"] = sc
    return d

def bat(name, nx, nz, floors, roof_kind, door_i, chimney=True, overhang=False, gable=None):
    """floors : liste de (préfixe, [motifs de fenêtres], motif plein). Fenêtres sur les 4 faces."""
    parts = []
    for fl, (pre, win, plain) in enumerate(floors):
        base = "fantasy-town/" + pre
        def k(i):
            w = win[i % len(win)]
            return w if w else plain
        for i in range(nx):
            kind = "-door" if fl == 0 and i == door_i else k(i + fl)
            parts.append(P(base + kind + ".glb", i + 0.5, fl, nz - 0.5, -90))
            parts.append(P(base + k(i + fl + 1) + ".glb", i + 0.5, fl, 0.5, 90))
        for j in range(nz):
            parts.append(P(base + k(j + fl) + ".glb", nx - 0.5, fl, j + 0.5, 0))
            parts.append(P(base + (plain if (j + fl) % 2 else k(j)) + ".glb", 0.5, fl, j + 0.5, 180))
    nf = len(floors)
    if overhang:
        parts.append(P("fantasy-town/overhang.glb", door_i + 0.5, 0, nz + 0.5, 90))
    if roof_kind in ("roof-point", "roof-high-point"):
        parts.append(P("fantasy-town/%s.glb" % roof_kind, nx / 2.0, nf, nz / 2.0, 0, [nx, 1.0, nz]))
        return {"name": name, "fp": [nx, nz], "parts": parts}
    for i in range(nx):
        parts.append(P("fantasy-town/%s.glb" % roof_kind, i + 0.5, nf, nz / 2.0, 0, [1, 1, float(nz)]))
    h = 1.0 if "high" in roof_kind else 0.6
    wood = "wood" in floors[-1][0]
    col = gable or ([0.62, 0.38, 0.25] if wood else [0.86, 0.80, 0.68])
    for ex in (nx - 0.06, 0.06):
        parts.append({"f": "", "prism": [float(nz), h, 0.12], "col": col, "p": [ex, nf + h / 2, nz / 2.0], "r": 90})
    if chimney:
        parts.append(P("fantasy-town/chimney.glb", nx - 0.9, nf + 0.2, nz / 2.0 + 0.1))
    return {"name": name, "fp": [nx, nz], "parts": parts}

def shift(parts, dx, dz):
    out = []
    for p in parts:
        q = dict(p); q["p"] = [p["p"][0] + dx, p["p"][1], p["p"][2] + dz]; out.append(q)
    return out

ST = ("wall", ["-window-shutters", "", "-window-small"], "")
ST2 = ("wall", ["-window-glass", "-window-shutters"], "")
STR = ("wall", ["-window-round", ""], "-detail-cross")
WD = ("wall-wood", ["-window-shutters", "", "-window-small"], "")
WX = ("wall-wood", ["-window-shutters", "-detail-cross", "-window-small", "-detail-cross"], "-detail-cross")
WDG = ("wall-wood", ["-window-small", "-detail-diagonal"], "-detail-diagonal")
WH = ("wall-wood", ["-window-shutters", "-detail-horizontal"], "-detail-horizontal")
new = [
    bat("taverne", 5, 3, [ST2, WX], "roof-gable", 2, overhang=True),
    bat("colombage", 3, 3, [ST, WX], "roof-high-gable", 1),
    bat("manoir", 4, 3, [STR, STR], "roof-high-gable", 1),
    bat("forge", 3, 2, [("wall", ["-window-stone", ""], "")], "roof-gable", 0, overhang=True),
    bat("longere", 5, 2, [WH], "roof-gable", 2),
    bat("chaumiere", 3, 2, [WD], "roof-gable", 1, chimney=False),
    bat("chaumiere2", 2, 2, [WDG], "roof-gable", 0, chimney=False),
    bat("maison_bois2", 2, 3, [WD, WDG], "roof-high-gable", 0),
    bat("maison_pierre2", 4, 2, [ST2], "roof-gable", 1),
    bat("maison_haute", 2, 2, [ST, ST, WX], "roof-high-point", 0),
]
for j in new:
    jobs[j["name"]] = j
# maison en L : corps en pierre + aile en bois
a = bat("_a", 4, 2, [ST, ST], "roof-gable", 1)
b = bat("_b", 2, 3, [WX], "roof-gable", 0, chimney=False)
jobs["maison_L"] = {"name": "maison_L", "fp": [4, 5], "parts": shift(a["parts"], 0, 3) + shift(b["parts"], 2, 0)}
# tour hexagonale (kit Castle)
hx = [P("castle/tower-hexagon-base.glb", 0.5, 0, 0.5)]
y = 1.31
for _ in range(3):
    hx.append(P("castle/tower-hexagon-mid.glb", 0.5, y, 0.5)); y += 0.46
hx.append(P("castle/tower-hexagon-top.glb", 0.5, y, 0.5)); y += 0.13
hx.append(P("castle/tower-hexagon-roof.glb", 0.5, y, 0.5))
hx.append(P("castle/flag.glb", 0.5, y + 0.8, 0.5))
jobs["tour_hex"] = {"name": "tour_hex", "fp": [1, 1], "gs": 1.8 / GS, "parts": hx}

WOOD = {"maison_bois", "chaumiere", "grange", "maison_bois2", "longere", "chaumiere2", "colombage", "taverne", "maison_L"}
ROOF = {"chapelle": (0.26, 0.29, 0.36), "moulin": (0.36, 0.25, 0.20), "maison_pierre": (0.55, 0.25, 0.17),
        "maison_bois": (0.50, 0.24, 0.17), "grange": (0.42, 0.27, 0.20), "chaumiere": (0.74, 0.58, 0.30),
        "taverne": (0.30, 0.33, 0.40), "forge": (0.33, 0.30, 0.30), "maison_bois2": (0.58, 0.29, 0.18),
        "maison_pierre2": (0.47, 0.22, 0.16), "longere": (0.70, 0.55, 0.29), "chaumiere2": (0.76, 0.60, 0.32),
        "colombage": (0.40, 0.22, 0.16), "manoir": (0.24, 0.27, 0.33), "maison_haute": (0.52, 0.30, 0.20),
        "maison_L": (0.62, 0.32, 0.20), "tour_hex": (0.3, 0.33, 0.4)}

def bez(pts, n=120):
    pts = np.array(pts, float); out = []
    for t in np.linspace(0, 1, n):
        p = pts.copy()
        while len(p) > 1: p = p[:-1] * (1 - t) + p[1:] * t
        out.append(p[0])
    return np.array(out)
paths = [bez(p) for p, a_, b_ in ROADS]

# (job, x, z, rotation, échelle locale)  façade (+z) : 0 sud, 90 est, 180 nord, 270 ouest
B = [("chapelle", 24.0, 6.6, 0, 1.0), ("tour_hex", 7.0, 5.0, 0, 1.0), ("colombage", 16.5, 9.2, 90, 1.0),
     ("manoir", 16.4, 16.4, 0, 1.0), ("maison_haute", 4.0, 15.2, 90, 1.0), ("taverne", 31.6, 15.0, 0, 1.0),
     ("moulin", 43.0, 10.4, 0, 1.0), ("maison_pierre2", 5.6, 21.0, 90, 1.0), ("maison_bois", 15.6, 28.9, 90, 1.0),
     ("longere", 6.4, 33.2, 0, 1.0), ("chaumiere", 13.2, 38.2, 90, 1.0), ("maison_bois2", 27.4, 39.6, 180, 1.0),
     ("chaumiere2", 32.4, 42.8, 0, 1.0), ("grange", 40.0, 41.6, 180, 1.0), ("forge", 34.2, 28.0, 270, 1.0),
     ("maison_L", 41.4, 26.6, 270, 1.0)]
pads = []
objs = []
def foot(job, s):
    fp = jobs[job]["fp"]; gs = jobs[job].get("gs", 1.0) * GS * s
    return fp[0] * gs, fp[1] * gs

B = B + [(j, x - OFF, z - OFF, r, s) for j, x, z, r, s in W.HAMLET]   # hameau des plaines (coordonnées village)
Hh = H.copy()
res = Hh.shape[0]
yy, xx = np.mgrid[0:res, 0:res].astype(np.float32) * (SW / res) - OFF     # coordonnées village
for job, cx, cz, r, s in B:
    fx, fz = foot(job, s)
    rad = max(fx, fz) * 0.6 + 0.7
    d = np.hypot(xx - cx, yy - cz)
    w = np.clip((rad + 1.6 - d) / 1.6, 0, 1); w = w * w * (3 - 2 * w)
    tgt = float(Hh[int((cz + OFF) / SW * res), int((cx + OFF) / SW * res)])
    Hh = Hh * (1 - w) + tgt * w
    pads.append((cx, cz, rad))
np.save("height2.npy", Hh.astype(np.float32))

def gy(x, z):
    i = min(res - 1, max(0, int((z + OFF) / SW * res))); j = min(res - 1, max(0, int((x + OFF) / SW * res)))
    return float(Hh[i, j])
def on_path(x, z, thr=0.12):
    i = min(PR - 1, max(0, int((z + OFF) / SW * PR))); j = min(PR - 1, max(0, int((x + OFF) / SW * PR)))
    return PATH[i, j] > thr
def in_pad(x, z, extra=0.0):
    return any(math.hypot(x - cx, z - cz) < rad + extra for cx, cz, rad in pads)
def near_plaza(x, z, r=6.0):
    return math.hypot(x - C, z - C) < r
def in_zone(x, z, zones, m=0.0):
    for zz in zones:
        _, cx, cz, w, h, ang = zz
        a_ = math.radians(ang); u = (x - cx) * math.cos(a_) + (z - cz) * math.sin(a_); v = -(x - cx) * math.sin(a_) + (z - cz) * math.cos(a_)
        if abs(u) < w / 2 + m and abs(v) < h / 2 + m: return True
    return False
OR = [("v", ORCHARD[0], ORCHARD[1], ORCHARD[2], ORCHARD[3], 0)]
def in_field(x, z, m=0.0): return in_zone(x, z, FIELDS, m) or in_zone(x, z, OR, m)
def in_meadow(x, z, m=0.0): return in_zone(x, z, MEADOWS, m)
def rot(vx, vz, deg):
    a_ = math.radians(deg); c, s = math.cos(a_), math.sin(a_)
    return vx * c + vz * s, -vx * s + vz * c

for job, cx, cz, r, s in B:
    j = jobs[job]; fx, fz = j["fp"][0], j["fp"][1]
    gs = j.get("gs", 1.0) * GS * s
    ox, oz = rot(fx * 0.5 * gs, fz * 0.5 * gs, r)
    objs.append({"type": "asm", "job": job, "parts": j["parts"], "p": [cx - ox + OFF, gy(cx, cz), cz - oz + OFF], "r": r, "s": gs,
                 "roof": ROOF.get(job, (0.5, 0.25, 0.18)), "wood": job in WOOD})

occupied = []
def add(f, x, z, r=0, s=1.0, tag="", yoff=0.0, mm=False, keep=0.0, tint=None, sc=None):
    o = {"type": "glb", "f": f, "p": [x + OFF, gy(x, z) + yoff, z + OFF], "r": r, "s": s, "tag": tag, "mm": mm}
    if tint: o["tint"] = tint
    if sc: o["sc"] = sc
    objs.append(o)
    if keep > 0: occupied.append((x, z, keep))
def free(x, z, r):
    return all(math.hypot(x - a_, z - b_) > r + k for a_, b_, k in occupied)

# ── place
# V122 : le donjon de la Nation occupe le centre de la place (posé par wild96.py) ; plus de fontaine
for k in range(8):
    an = k * math.pi / 4 + 0.39
    add(KT + "fantasy-town/lantern.glb", C + 5.0 * math.cos(an), C + 5.0 * math.sin(an), 0, 1.3, "lantern", keep=0.4)
for f, x, z, r in (("stall-red", 27.6, 19.6, 200), ("stall-green", 19.4, 21.0, 110), ("stall", 28.4, 27.4, 300), ("stall-red", 20.2, 28.0, 20)):
    add(KT + "fantasy-town/%s.glb" % f, x, z, r, 2.2, "stall", keep=1.4)
add(KT + "fantasy-town/cart.glb", 26.5, 30.0, 35, 1.8, "cart", keep=1.2)
add(KT + "fantasy-town/banner-red.glb", 22.6, 9.8, 0, 2.3, "banner", keep=0.5)
add(KT + "fantasy-town/banner-green.glb", 25.4, 9.8, 0, 2.3, "banner", keep=0.5)
SV = KT + "survival/"
GY = KT + "graveyard/"
for f, x, z, r in (("barrel", 28.4, 18.1, 0), ("barrel", 29.0, 18.6, 40), ("box-large", 35.0, 18.2, 20), ("box", 35.6, 18.9, 60)):
    add(SV + f + ".glb", x, z, r, 2.0, "prop", keep=0.4)
for f, x, z, r in (("workbench-anvil", 31.4, 27.0, 90), ("workbench", 31.4, 29.4, 90), ("resource-wood", 35.4, 25.0, 0), ("barrel-open", 31.2, 28.2, 0)):
    add(SV + f + ".glb", x, z, r, 2.0, "prop", keep=0.5)
add(SV + "signpost.glb", 13.0, 25.0, 30, 2.0, "prop", keep=0.4)
add(SV + "signpost-single.glb", 34.0, 21.0, 200, 2.0, "prop", keep=0.4)
add(SV + "signpost-single.glb", 36.8, 37.6, 0, 2.0, "prop", keep=0.4)
# ferme : meules, enclos, brouette
for x, z, r in ((35.0, 44.6, 10), (36.4, 45.2, 70), (44.6, 44.6, 0), (45.4, 43.2, 45), (43.2, 46.0, 80)):
    add(GY + "hay-bale.glb", x, z, r, 1.8, "hay", keep=0.6)
for x, z, r in ((38.0, 37.6, 20), (45.0, 37.5, 60)):
    add(GY + "hay-bale-bundled.glb", x, z, r, 1.8, "hay", keep=0.6)
for i in range(8):
    add(KT + "fantasy-town/fence.glb", 41.8 + i * 0.75 if False else 34.4 + i * 1.2, 47.0, 0, 1.2, "fence")
for i in range(7):
    add(KT + "fantasy-town/fence.glb", 46.8, 39.2 + i * 1.2, 90, 1.2, "fence")
add(KT + "fantasy-town/cart-high.glb", 37.0, 31.0, 300, 1.8, "cart", keep=1.0)
# clôtures autour des champs de blé
for kind, cx, cz, w, h, ang in FIELDS:
    if kind in ("ble", "potager"):
        n = int(w / 1.2)
        for i in range(n):
            x = cx - w / 2 + 0.6 + i * 1.2
            add(KT + "fantasy-town/fence.glb", x, cz + h / 2 + 0.35, 0, 1.2, "fence")
# jardin du manoir, haies
for i in range(5):
    add(KT + "fantasy-town/fence.glb", 20.4, 13.6 + i * 1.2, 90, 1.2, "fence")
for i in range(5):
    add(KT + "fantasy-town/hedge.glb", 2.4 + i * 1.0, 30.4, 0, 1.0, "hedge")
for i in range(4):
    add(KT + "fantasy-town/hedge.glb", 12.0 + i * 1.0, 12.4, 0, 1.0, "hedge")
# cimetière
for gx in range(3):
    for gz in range(2):
        f = ["gravestone-round", "gravestone-cross", "gravestone-bevel", "gravestone-decorative", "gravestone-wide", "gravestone-roof"][(gx + gz * 3) % 6]
        add(GY + f + ".glb", 28.8 + gx * 1.3, 4.6 + gz * 1.7, float(rng.uniform(-8, 8)), 1.7, "grave", keep=0.5)
for i in range(4):
    add(GY + "iron-fence.glb", 28.3 + i * 1.0, 8.3, 0, 1.0, "fence")
add(GY + "lightpost-single.glb", 21.6, 10.2, 0, 1.6, "prop", keep=0.4)
add(GY + "pumpkin.glb", 3.4, 40.8, 0, 1.6, "prop", keep=0.3)
add(GY + "pumpkin-tall.glb", 4.2, 41.0, 40, 1.6, "prop", keep=0.3)

# ── cultures en 3D
WHEAT = (0.80, 0.58, 0.20)
for kind, cx, cz, w, h, ang in FIELDS:
    a_ = math.radians(ang); ca, sa = math.cos(a_), math.sin(a_)
    if kind == "ble":
        v = -h / 2 + 0.25
        while v < h / 2 - 0.15:
            u = -w / 2 + 0.15
            while u < w / 2 - 0.1:
                uu = u + rng.uniform(-0.06, 0.06); vv = v + rng.uniform(-0.05, 0.05)
                x = cx + uu * ca - vv * sa; z = cz + uu * sa + vv * ca
                f = NAT + ["Grass_Wispy_Tall.gltf", "Grass_Common_Tall.gltf"][rng.integers(0, 2)]
                t = tuple(c * rng.uniform(0.9, 1.05) for c in WHEAT)
                add(f, x, z, float(rng.uniform(0, 360)), float(rng.uniform(0.32, 0.44)), "ble", mm=True, tint=[round(c, 2) for c in WHEAT])
                u += 0.2
            v += 0.42
    elif kind == "potager":
        v = -h / 2 + 0.3
        row = 0
        while v < h / 2 - 0.2:
            u = -w / 2 + 0.3
            while u < w / 2 - 0.2:
                x = cx + u * ca - v * sa; z = cz + u * sa + v * ca
                f = NAT + (["Plant_7.gltf", "Clover_2.gltf", "Plant_1.gltf"][row % 3])
                add(f, x, z, float(rng.uniform(0, 360)), [0.22, 0.55, 0.22][row % 3], "legume", mm=True)
                u += 0.42
            v += 0.6; row += 1
# verger en rangées
TREES = [NAT + "CommonTree_%d.gltf" % i for i in range(1, 6)]
PINES = [NAT + "Pine_%d.gltf" % i for i in range(1, 6)]
placed = []
ox, oz, ow, oh = ORCHARD
for i in range(3):
    for k in range(3):
        x, z = ox - ow / 2 + 0.7 + i * (ow - 1.4) / 2, oz - oh / 2 + 0.7 + k * (oh - 1.4) / 2
        add(TREES[(i + 2 * k) % 5], x + rng.uniform(-0.15, 0.15), z, float(rng.uniform(0, 360)), 0.34, "tree")
        placed.append((x, z, 1.5))

# ── pavés
PAV = [NAT + "RockPath_Square_Small_%d.gltf" % i for i in (1, 2, 3)] + [NAT + "RockPath_Round_Small_%d.gltf" % i for i in (1, 2)] + [NAT + "RockPath_Square_Thin.gltf", NAT + "RockPath_Round_Thin.gltf"]
step = 0.78
for gx in np.arange(C - 5.6, C + 5.6, step):
    for gz in np.arange(C - 5.6, C + 5.6, step):
        x = gx + rng.uniform(-0.25, 0.25); z = gz + rng.uniform(-0.25, 0.25)
        d = math.hypot(x - C, z - C)
        if 3.2 < d < 5.5 - rng.uniform(0, 0.6) and free(x, z, 0.15):
            add(PAV[rng.integers(0, len(PAV))], x, z, float(rng.uniform(0, 360)), float(rng.uniform(0.5, 0.64)), "pave", mm=True)
for pa, (pts, w0, w1) in zip(paths, ROADS):
    for k in range(len(pa)):
        x, z = pa[k]
        if near_plaza(x, z, 5.4) or not (0 < x < S and 0 < z < S): continue
        hw = (w0 + (w1 - w0) * k / len(pa)) * 0.5
        for side in (-1, 1):
            if rng.random() < 0.5:
                nx = x + side * rng.uniform(0.2, hw * 0.95); nz = z + rng.uniform(-0.2, 0.2)
                if 0.3 < nx < S - 0.3 and 0.3 < nz < S - 0.3 and free(nx, nz, 0.1):
                    add(PAV[rng.integers(0, len(PAV))], nx, nz, float(rng.uniform(0, 360)), float(rng.uniform(0.34, 0.5)), "pave", mm=True)
        if rng.random() < 0.7:
            add(PAV[rng.integers(0, len(PAV))], x + rng.uniform(-0.25, 0.25), z + rng.uniform(-0.25, 0.25), float(rng.uniform(0, 360)), float(rng.uniform(0.40, 0.55)), "pave", mm=True)

# ── arbres : forêt allégée (lisière + quelques bosquets)
def free_spot(x, z, mind):
    if not (0.4 < x < S - 0.4 and 0.4 < z < S - 0.4): return False
    if on_path(x, z, 0.02) or near_plaza(x, z, 7.0) or in_pad(x, z, 1.2) or not free(x, z, 1.0): return False
    if in_field(x, z, 1.0) or in_meadow(x, z, 0.3): return False
    return all(math.hypot(x - a_, z - b_) > max(mind, m) for a_, b_, m in placed)
groves = [(10, 46, 2.4), (45.5, 31, 1.8), (20, 5.5, 1.8), (2.5, 9, 1.6), (46, 3, 2.0), (30, 33, 1.2)]
tries = 0
n_tree = 0
while n_tree < 60 and tries < 40000:
    tries += 1
    x, z = rng.uniform(0, S, 2)
    cheb = max(abs(x - C), abs(z - C))
    ing = any(math.hypot(x - a_, z - b_) < r for a_, b_, r in groves)
    pr = 0.25 if cheb > 21.8 else (0.8 if ing else 0.015)
    if rng.random() > pr: continue
    m = 2.2 if (cheb > 21.8 or ing) else 4.0
    if not free_spot(x, z, m): continue
    f = TREES[rng.integers(0, 5)] if rng.random() < 0.55 else PINES[rng.integers(0, 5)]
    add(f, x, z, float(rng.uniform(0, 360)), float(rng.uniform(0.46, 0.64)), "tree")
    placed.append((x, z, m)); n_tree += 1

def scatter(files, n, scale, tag, mind=0.9, cluster=None, mm=False, avoid_path=True, where=None):
    k = 0; tries = 0
    while k < n and tries < n * 80:
        tries += 1
        if cluster:
            cx, cz, cr = cluster[rng.integers(0, len(cluster))]
            x = cx + rng.normal(0, cr); z = cz + rng.normal(0, cr)
        else:
            x, z = rng.uniform(0.3, S - 0.3, 2)
        if not (0.3 < x < S - 0.3 and 0.3 < z < S - 0.3): continue
        if where is not None and not where(x, z): continue
        if avoid_path and (on_path(x, z, 0.05) or near_plaza(x, z, 5.8)): continue
        if in_pad(x, z, 0.5) or not free(x, z, 0.2) or in_field(x, z, 0.15): continue
        if any(math.hypot(x - a_, z - b_) < min(mind, m * 0.5) for a_, b_, m in placed): continue
        add(files[rng.integers(0, len(files))], x, z, float(rng.uniform(0, 360)), float(rng.uniform(*scale)), tag, 0.0, mm)
        k += 1
notmead = lambda x, z: not in_meadow(x, z)
scatter([NAT + "Bush_Common.gltf", NAT + "Plant_1_Big.gltf"], 110, (0.42, 0.62), "bush", 1.4, where=notmead)
scatter([NAT + "Rock_Medium_%d.gltf" % i for i in (1, 2, 3)], 26, (0.22, 0.42), "rock", 1.6)
scatter([NAT + "Pebble_Round_%d.gltf" % i for i in (1, 2, 3, 4, 5)] + [NAT + "Pebble_Square_%d.gltf" % i for i in (1, 3, 4)], 300, (0.5, 0.9), "pebble", 0.5, mm=True)
scatter([NAT + "Fern_1.gltf"], 110, (0.28, 0.42), "fern", 1.0, mm=True, where=notmead)
scatter([NAT + "Mushroom_Common.gltf"], 40, (0.2, 0.3), "mush", 0.6, mm=True, where=notmead)
beds = [(rng.uniform(2, 46), rng.uniform(2, 46), rng.uniform(0.6, 1.3)) for _ in range(40)]
scatter([NAT + "Flower_4_Group.gltf", NAT + "Flower_3_Single.gltf", NAT + "Flower_4_Single.gltf", NAT + "Flower_3_Group.gltf"], 450, (0.24, 0.42), "flower", 0.34, cluster=beds, mm=True)
# prairies : fleurs + herbe courte, pas d'herbes hautes
inm = lambda x, z: in_meadow(x, z, -0.4)
scatter([NAT + "Flower_3_Single.gltf", NAT + "Flower_4_Single.gltf", NAT + "Flower_3_Group.gltf", NAT + "Flower_4_Group.gltf"], 900, (0.22, 0.36), "flower", 0.0, mm=True, where=inm)
scatter([NAT + "Grass_Common_Short.gltf", NAT + "Grass_Wispy_Short.gltf"], 1400, (0.3, 0.45), "grass", 0.0, mm=True, where=inm)
scatter([NAT + "Clover_1.gltf", NAT + "Clover_2.gltf"], 900, (0.30, 0.5), "clover", 0.5, mm=True)
scatter([NAT + "Grass_Common_Tall.gltf", NAT + "Grass_Wispy_Tall.gltf", NAT + "Grass_Wispy_Short.gltf"], 5200, (0.26, 0.46), "grass", 0.0, mm=True, where=notmead)
for pa in paths:
    for k in range(0, len(pa), 2):
        x, z = pa[k]
        for side in (-1, 1):
            nx = x + side * rng.uniform(1.1, 1.7) + rng.normal(0, 0.15); nz = z + rng.normal(0, 0.3)
            if 0.2 < nx < S - 0.2 and 0.2 < nz < S - 0.2 and not on_path(nx, nz, 0.4) and not near_plaza(nx, nz, 5.8) and not in_pad(nx, nz, 0.3) and not in_field(nx, nz, 0.2):
                add(NAT + ["Grass_Common_Tall.gltf", "Grass_Wispy_Tall.gltf"][rng.integers(0, 2)], nx, nz, float(rng.uniform(0, 360)), float(rng.uniform(0.28, 0.45)), "grass", 0.0, True)
exec(open(os.path.join(os.path.dirname(os.path.abspath(__file__)), "wild96.py")).read())
json.dump(objs, open("objects.json", "w"))
json.dump({"pads": [(x + OFF, z + OFF, r) for x, z, r in pads], "B": [(j, x + OFF, z + OFF, r, s_) for j, x, z, r, s_ in B]}, open("plan.json", "w"))
from collections import Counter
print(Counter(o.get("tag", o["type"]) for o in objs))
HMAX = 2.6
cv2.imwrite("height2.png", (np.clip(Hh / HMAX, 0, 1) * 65535).astype(np.uint16))
