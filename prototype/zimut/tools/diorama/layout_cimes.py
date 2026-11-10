#!/usr/bin/env python3
"""Hauts Pics du Givre (Cimes) 96x96 -> objects.json, plan.json, height2.npy/png (coordonnées monde).
Forteresse de la Nation au centre, un donjon par coin, lac gelé, pinèdes enneigées, rochers, cristaux de glace, hameau de montagne."""
import json, math, sys, os, numpy as np, cv2
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import plan_cimes as W
import batiments as BT
import dungeons3d as DG
rng = np.random.default_rng(71)
S, C = W.S, W.C
NAT = os.environ.get("QUATERNIUS_NATURE", "/tmp/kits/nature/Stylized Nature MegaKit[Standard]/glTF/")
KT = BT.KT
H = np.load("height.npy")
PATH = np.load("mask_path.npy"); PR = PATH.shape[0]
WL = float(np.load("lake.npy")[0])
res = H.shape[0]
jobs = BT.jobs

def foot(job, s):
    fp = jobs[job]["fp"]; gs = jobs[job].get("gs", 1.0) * BT.GS * s
    return fp[0] * gs, fp[1] * gs

def lake_sd(x, z):
    best = 99.0
    for lx, lz, ra, rb, ang in W.LAKES:
        a_ = math.radians(ang); u = (x - lx) * math.cos(a_) + (z - lz) * math.sin(a_); v = -(x - lx) * math.sin(a_) + (z - lz) * math.cos(a_)
        best = min(best, (math.sqrt((u / ra) ** 2 + (v / rb) ** 2) - 1.0) * min(ra, rb))
    return best

# ── aplanir sous les bâtiments et les donjons
Hh = H.copy()
yy, xx = np.mgrid[0:res, 0:res].astype(np.float32) * (S / res)
pads = []
for job, cx, cz, r, s in W.TOWN:
    fx, fz = foot(job, s)
    rad = max(fx, fz) * 0.6 + 0.7
    d = np.hypot(xx - cx, yy - cz)
    w = np.clip((rad + 1.6 - d) / 1.6, 0, 1); w = w * w * (3 - 2 * w)
    tgt = float(Hh[int(cz / S * res), int(cx / S * res)])
    Hh = Hh * (1 - w) + tgt * w
    pads.append((cx, cz, rad))
for dname, dkind, dx, dz in W.DUNGEONS:
    rad = W.DUNGEON_RAD[dkind]
    d = np.hypot(xx - dx, yy - dz)
    w = np.clip((rad + 2.0 - d) / 2.0, 0, 1); w = w * w * (3 - 2 * w)
    tgt = float(Hh[int(dz / S * res), int(dx / S * res)])
    Hh = Hh * (1 - w) + tgt * w
np.save("height2.npy", Hh.astype(np.float32))
cv2.imwrite("height2.png", (np.clip(Hh / W.HMAX, 0, 1) * 65535).astype(np.uint16))

def gy(x, z):
    i = min(res - 1, max(0, int(z / S * res))); j = min(res - 1, max(0, int(x / S * res)))
    return float(Hh[i, j])
def on_path(x, z, thr=0.12):
    return PATH[min(PR - 1, max(0, int(z / S * PR))), min(PR - 1, max(0, int(x / S * PR)))] > thr
def in_water(x, z, m=0.0):
    return lake_sd(x, z) < m
def in_pad(x, z, extra=0.0):
    return any(math.hypot(x - cx, z - cz) < rad + extra for cx, cz, rad in pads)
def near_plaza(x, z, r=6.0):
    return math.hypot(x - C, z - C) < r
def rot(vx, vz, deg):
    a_ = math.radians(deg); c, s = math.cos(a_), math.sin(a_)
    return vx * c + vz * s, -vx * s + vz * c

objs = []
occupied = []
def add(f, x, z, r=0, s=1.0, tag="", mm=False, keep=0.0, **kw):
    o = {"type": "glb", "f": f, "p": [x, gy(x, z) + kw.pop("yoff", 0.0), z], "r": r, "s": s, "tag": tag, "mm": mm}
    o.update(kw)
    objs.append(o)
    if keep > 0: occupied.append((x, z, keep))
def free(x, z, r):
    return all(math.hypot(x - a_, z - b_) > r + k for a_, b_, k in occupied)

# ── eau : une surface par mare
for lx, lz, ra, rb, ang in W.LAKES:
    objs.append({"type": "water", "c": [lx, lz], "r": [ra + 0.6, rb + 0.6], "ang": ang, "y": WL})

# ── cabanes de tourbiers
for job, cx, cz, r, s in W.TOWN:
    j = jobs[job]; fx, fz = j["fp"]
    gs = j.get("gs", 1.0) * BT.GS * s
    ox, oz = rot(fx * 0.5 * gs, fz * 0.5 * gs, r)
    objs.append({"type": "asm", "job": job, "parts": j["parts"], "p": [cx - ox, gy(cx, cz), cz - oz], "r": r, "s": gs,
                 "roof": W.ROOF.get(job, (0.3, 0.3, 0.22)), "wood": job in BT.WOOD, "wall_mul": list(W.WALL_MUL)})
GY_, SV, CA, TD, FT, PI = KT + "graveyard/", KT + "survival/", KT + "castle/", KT + "tower-defense/", KT + "fantasy-town/", KT + "pirate/"
GLOW = dict(emit=[0.45, 1.0, 0.78], emit_e=1.2)

# ── routes : planches de bois posées dans la vase
PLK = [PI + "platform-planks.glb"]
def bez(pts, n=160):
    pts = np.array(pts, float); out = []
    for t in np.linspace(0, 1, n):
        p = pts.copy()
        while len(p) > 1: p = p[:-1] * (1 - t) + p[1:] * t
        out.append(p[0])
    return np.array(out)
for pts, w0, w1 in W.ROADS:
    pa = bez(pts)
    for k in range(len(pa)):
        x, z = pa[k]
        if near_plaza(x, z, 5.4) or not (0 < x < S and 0 < z < S): continue
        # feux follets le long des routes, toutes les ~11 unités
        if k % 20 == 10:
            hx, hz = pa[min(k + 1, len(pa) - 1)] - pa[k]
            nrm = np.array([-hz, hx]); nrm /= (np.linalg.norm(nrm) + 1e-6)
            px, pz = x + nrm[0] * 1.7, z + nrm[1] * 1.7
            if not in_water(px, pz, 0.8) and free(px, pz, 0.6):
                add(GY_ + "lightpost-single.glb", px, pz, 0, 1.3, "lantern", keep=0.5)
                objs.append({"type": "light", "p": [px, gy(px, pz) + 1.8, pz], "c": [1.0, 0.80, 0.50], "e": 1.3, "range": 3.8})

# ── donjons
for gi, (dname, dkind, dx, dz) in enumerate(W.DUNGEONS):
    for o_ in DG.build(dkind, dx, dz, gy, KT, NAT):
        if o_.get("type") == "glb":            # pierre claire prise par le givre
            m_ = o_.get("mul", [1.0, 1.0, 1.0])
            o_["mul"] = [m_[0] * 0.45 + 0.50, m_[1] * 0.45 + 0.54, m_[2] * 0.45 + 0.62]
            if "emit" in o_: o_["emit"] = [0.55, 0.45, 1.0]
        elif o_.get("type") == "light":
            o_["c"] = [0.65, 0.60, 1.0]
        o_["group"] = "donjon%d" % gi
        o_["gc"] = [dx, dz]
        objs.append(o_)
    occupied.append((dx, dz, W.DUNGEON_RAD[dkind] + 0.8))
    for k_ in (4.8, 7.4, 10.0, 12.8):                      # V122 : cône de vue dégagé devant l'entrée (rien ne cache le donjon)
        occupied.append((dx + 0.7071 * k_, dz + 0.7071 * k_, 3.0))

# ── portail vers la Nation suivante (V131) : arche dans le décor, vue dégagée devant (comme les donjons)
for pi_, (pn_, ppx, ppz) in enumerate([q for q in W.PLACES if q[0].startswith("Portail")]):
    pax, paz = ppx - 0.7071 * 0.6, ppz - 0.7071 * 0.6
    for o_ in DG.build("portail", pax, paz, gy, KT, NAT):
        o_["group"] = "portail%d" % pi_
        o_["gc"] = [pax, paz]
        objs.append(o_)
    occupied.append((pax, paz, 3.4))
    for k_ in (2.6, 4.8, 7.0):
        occupied.append((pax + 0.7071 * k_, paz + 0.7071 * k_, 2.6))

# ── arbres : pins enneigés, quelques arbres morts
DEAD = [NAT + "DeadTree_%d.gltf" % i for i in (1, 2, 3, 4, 5)]
PINE = [NAT + "Pine_%d.gltf" % i for i in (1, 2, 3, 4, 5)]
placed = []
def spot(x, z, mind):
    if not (0.5 < x < S - 0.5 and 0.5 < z < S - 0.5): return False
    if on_path(x, z, 0.02) or in_water(x, z, 1.0) or near_plaza(x, z, 7) or in_pad(x, z, 1.2) or not free(x, z, 1.0): return False
    return all(math.hypot(x - a_, z - b_) > mind for a_, b_ in placed)
def tree_at(x, z, big=1.0):
    if rng.random() < 0.88:      # pins chargés de neige (feuillage éclairci et bleuté)
        add(PINE[rng.integers(0, 5)], x, z, float(rng.uniform(0, 360)), float(rng.uniform(0.50, 0.78)) * big, "tree", mul=[0.42, 0.60, 0.62])
    else:
        add(DEAD[rng.integers(0, 5)], x, z, float(rng.uniform(0, 360)), float(rng.uniform(0.20, 0.30)) * big, "tree", mul=[0.80, 0.84, 0.92])
    placed.append((x, z))
for bx, bz, br in W.WOODS:
    want = int(br * br * 0.95); k = 0; tries = 0
    while k < want and tries < want * 60:
        tries += 1
        a = rng.uniform(0, 2 * math.pi); d = br * math.sqrt(rng.random()) * 1.05
        x, z = bx + math.cos(a) * d, bz + math.sin(a) * d
        if not spot(x, z, 1.7): continue
        tree_at(x, z); k += 1
k = 0; tries = 0
while k < 70 and tries < 30000:
    tries += 1
    x, z = rng.uniform(0, S, 2)
    if max(abs(x - C), abs(z - C)) < 15 or not spot(x, z, 4.5): continue
    tree_at(x, z); k += 1
def scatter(files, n, scale, tag, mind=0.0, mm=True, where=None, cluster=None, **kw):
    k = 0; tries = 0
    while k < n and tries < n * 60:
        tries += 1
        if cluster:
            cx, cz, cr_ = cluster[rng.integers(0, len(cluster))]
            x = cx + rng.normal(0, cr_); z = cz + rng.normal(0, cr_)
        else:
            x, z = rng.uniform(0.3, S - 0.3, 2)
        if not (0.3 < x < S - 0.3 and 0.3 < z < S - 0.3): continue
        if where is not None and not where(x, z): continue
        if on_path(x, z, 0.05) or in_water(x, z, 0.1) or near_plaza(x, z, 5.8) or in_pad(x, z, 0.5) or not free(x, z, 0.2): continue
        if mind > 0 and any(math.hypot(x - a_, z - b_) < mind for a_, b_ in placed): continue
        add(files[rng.integers(0, len(files))], x, z, float(rng.uniform(0, 360)), float(rng.uniform(*scale)), tag, mm=mm, **kw)
        k += 1
ICE = [0.78, 0.86, 0.98]
# rochers (gros blocs en grappes), cailloux, cristaux de glace lumineux, herbes givrées qui percent la neige
rock_c = [(rng.uniform(4, 92), rng.uniform(4, 92), rng.uniform(1.5, 3.0)) for _ in range(34)]
scatter([NAT + "Rock_Medium_%d.gltf" % i for i in (1, 2, 3)], 150, (0.45, 1.25), "rock", 1.4, mm=True, cluster=rock_c, tint=ICE)
scatter([NAT + "Pebble_Round_%d.gltf" % i for i in (1, 2, 3, 4, 5)], 700, (0.5, 1.0), "pebble", tint=[0.70, 0.76, 0.86])
k = 0; tries = 0
while k < 46 and tries < 20000:
    tries += 1
    x, z = rng.uniform(2, S - 2, 2)
    if max(abs(x - C), abs(z - C)) < 12 or not spot(x, z, 2.2): continue
    add(TD + "detail-crystal-large.glb", x, z, float(rng.uniform(0, 360)), float(rng.uniform(1.1, 2.0)), "crystal", mul=[0.60, 0.90, 1.25], emit=[0.30, 0.65, 1.0], emit_e=0.9)
    placed.append((x, z))
    if k % 3 == 0:
        objs.append({"type": "light", "p": [x, gy(x, z) + 0.9, z], "c": [0.45, 0.75, 1.0], "e": 1.2, "range": 3.6})
    k += 1
tufts = [(rng.uniform(0, 96), rng.uniform(0, 96), rng.uniform(1.5, 3.2)) for _ in range(90)]
scatter([NAT + "Grass_Wispy_Tall.gltf", NAT + "Grass_Common_Tall.gltf"], 1500, (0.28, 0.45), "grass", cluster=tufts, tint=[0.72, 0.80, 0.78])
scatter([NAT + "Grass_Wispy_Short.gltf", NAT + "Grass_Common_Short.gltf"], 1200, (0.26, 0.40), "grass", tint=[0.76, 0.84, 0.86])
scatter([NAT + "Bush_Common.gltf"], 90, (0.4, 0.65), "bush", 1.2, tint=[0.70, 0.84, 0.88])

from thin_paths import thin
objs = thin(objs, PATH, 96.0)
json.dump(objs, open("objects.json", "w"))
json.dump({"pads": pads, "B": [list(b) for b in W.TOWN]}, open("plan.json", "w"))
from collections import Counter
print(Counter(o.get("tag", o["type"]) for o in objs))
