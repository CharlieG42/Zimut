#!/usr/bin/env python3
"""Terres de Cendre (Brasier) 96x96 -> objects.json, plan.json, height2.npy/png (coordonnées monde).
Bourg de forgerons au centre, landes de cendre, bois calcinés, champs d'obsidienne, rivières de lave, volcan, 5 donjons."""
import json, math, sys, os, numpy as np, cv2
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import plan_brasier as W
import batiments as BT
import dungeons3d as DG
rng = np.random.default_rng(31)
S, C = W.S, W.C
NAT = os.environ.get("QUATERNIUS_NATURE", "/tmp/kits/nature/Stylized Nature MegaKit[Standard]/glTF/")
KT = BT.KT
H = np.load("height.npy")
PATH = np.load("mask_path.npy"); PR = PATH.shape[0]
LAVA = np.load("lava.npy"); LR = LAVA.shape[0]
FORBID = np.load("forbid.npy"); FR = FORBID.shape[0]
res = H.shape[0]
jobs = BT.jobs

def foot(job, s):
    fp = jobs[job]["fp"]; gs = jobs[job].get("gs", 1.0) * BT.GS * s
    return fp[0] * gs, fp[1] * gs

# ── aplanir sous les bâtiments
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
def on_lava(x, z, thr=0.05):
    return LAVA[min(LR - 1, max(0, int(z / S * LR))), min(LR - 1, max(0, int(x / S * LR)))] > thr
def forbid(x, z):
    return FORBID[min(FR - 1, max(0, int(z / S * FR))), min(FR - 1, max(0, int(x / S * FR)))] > 0.5
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

# ── bourg
for job, cx, cz, r, s in W.TOWN:
    j = jobs[job]; fx, fz = j["fp"]
    gs = j.get("gs", 1.0) * BT.GS * s
    ox, oz = rot(fx * 0.5 * gs, fz * 0.5 * gs, r)
    objs.append({"type": "asm", "job": job, "parts": j["parts"], "p": [cx - ox, gy(cx, cz), cz - oz], "r": r, "s": gs,
                 "roof": W.ROOF.get(job, (0.3, 0.2, 0.2)), "wood": job in BT.WOOD, "wall_mul": list(W.WALL_MUL)})
GY_, SV, CA, TD, FT = KT + "graveyard/", KT + "survival/", KT + "castle/", KT + "tower-defense/", KT + "fantasy-town/"
FIRE = dict(emit=[1.0, 0.45, 0.1], emit_e=1.4)
# V122 : la forteresse de la Nation occupe le centre de la place (posée par la boucle des donjons) ; plus de grand brasier
for f, x, z, r in (("stall", 41.6, 51.0, 20),):
    add(FT + f + ".glb", x, z, r, 2.2, "stall", keep=1.4, mul=[0.8, 0.6, 0.55])
# forges : enclumes, tonneaux, bois, braises
for fx_, fz_ in ((40.0, 44.5), (58.0, 46.5)):
    for f, dx, dz, r in (("workbench-anvil", 0.0, 0.0, 30), ("barrel", 1.2, 0.6, 0), ("resource-wood", -1.3, 0.4, 70), ("campfire-pit", 0.6, -1.1, 0)):
        add(SV + f + ".glb", fx_ + dx, fz_ + dz, r, 2.0, "prop", keep=0.4, **(FIRE if "campfire" in f else {}))
    objs.append({"type": "light", "p": [fx_ + 0.6, gy(fx_, fz_) + 0.8, fz_ - 1.1], "c": [1.0, 0.5, 0.15], "e": 1.6, "range": 4.0})
for x, z, r in ((42.6, 54.0, 10),):
    add(SV + "barrel.glb", x, z, r, 2.0, "prop", keep=0.4)
add(SV + "signpost.glb", 30.6, 48.0, 30, 2.0, "prop", keep=0.4)
add(SV + "signpost.glb", 66.5, 51.2, 200, 2.0, "prop", keep=0.4)

# ── paves : place et routes du bourg (basalte)
PAV = [NAT + "RockPath_Square_Small_%d.gltf" % i for i in (1, 2, 3)] + [NAT + "RockPath_Round_Small_%d.gltf" % i for i in (1, 2)]
BASALT = [0.42, 0.38, 0.38]
for gx in np.arange(49.0, 57.5, 0.78):
    for gz in np.arange(49.0, 57.5, 0.78):
        x = gx + rng.uniform(-0.25, 0.25); z = gz + rng.uniform(-0.25, 0.25)
        d = math.hypot(x - C, z - C)
        if math.hypot(x - 53.0, z - 53.0) < 3.4 - rng.uniform(0, 0.6) and free(x, z, 0.15):    # parvis devant la porte de la forteresse
            add(PAV[rng.integers(0, len(PAV))], x, z, float(rng.uniform(0, 360)), float(rng.uniform(0.5, 0.64)), "pave", mm=True, tint=BASALT)

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
        town = max(abs(x - C), abs(z - C)) < 22
        if rng.random() < (0.75 if town else 0.25):
            add(PAV[rng.integers(0, len(PAV))], x + rng.uniform(-0.3, 0.3), z + rng.uniform(-0.3, 0.3), float(rng.uniform(0, 360)), float(rng.uniform(0.38, 0.55)), "pave", mm=True, tint=BASALT)
        # vasques le long des routes, toutes les ~10 unités hors du bourg
        if not town and k % 18 == 9:
            hx, hz = pa[min(k + 1, len(pa) - 1)] - pa[k]
            nrm = np.array([-hz, hx]); nrm /= (np.linalg.norm(nrm) + 1e-6)
            px, pz = x + nrm[0] * 1.6, z + nrm[1] * 1.6
            if not on_lava(px, pz) and free(px, pz, 0.6):
                add(GY_ + "pillar-small.glb", px, pz, 0, 1.3, "lantern", keep=0.5, mul=[0.5, 0.45, 0.45])
                add(GY_ + "fire-basket.glb", px, pz, 0, 1.4, "lantern", yoff=1.3 * 0.62, **FIRE)
                objs.append({"type": "light", "p": [px, gy(px, pz) + 1.3, pz], "c": [1.0, 0.5, 0.18], "e": 1.2, "range": 3.5})

# ── donjons
for gi, (dname, dkind, dx, dz) in enumerate(W.DUNGEONS):
    for o_ in DG.build(dkind, dx, dz, gy, KT, NAT):
        o_["group"] = "donjon%d" % gi
        o_["gc"] = [dx, dz]
        if dkind in ("grotte", "antre") and "mul" in o_:
            o_["mul"] = [0.42, 0.38, 0.38]          # roche de basalte
        if o_.get("tag") == "bush":
            o_.pop("tint", None)                    # buissons rouges : de saison au Brasier
        objs.append(o_)
    occupied.append((dx, dz, W.DUNGEON_RAD[dkind] + 0.8))
    for k_ in (4.8, 7.4, 10.0):                      # V122 : cône de vue dégagé devant l'entrée (rien ne cache le donjon)
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
# volcan : lueur du cratère
vx, vz, vr, vh, cr = W.VOLCANO
objs.append({"type": "light", "p": [vx, gy(vx, vz) + 1.0, vz], "c": [1.0, 0.45, 0.12], "e": 6.0, "range": 10.0})

# ── arbres : bois calcinés et arbres morts isolés
DEAD = [NAT + "DeadTree_%d.gltf" % i for i in (1, 2, 3, 4, 5)]
TWIST = [NAT + "TwistedTree_%d.gltf" % i for i in (1, 2, 3, 4, 5)]
placed = []
def spot(x, z, mind):
    if not (0.5 < x < S - 0.5 and 0.5 < z < S - 0.5): return False
    if on_path(x, z, 0.02) or on_lava(x, z) or forbid(x, z) or near_plaza(x, z, 7) or in_pad(x, z, 1.2) or not free(x, z, 1.0): return False
    return all(math.hypot(x - a_, z - b_) > mind for a_, b_ in placed)
for bx, bz, br in W.WOODS:
    want = int(br * br * 0.9); k = 0; tries = 0
    while k < want and tries < want * 60:
        tries += 1
        a = rng.uniform(0, 2 * math.pi); d = br * math.sqrt(rng.random()) * 1.05
        x, z = bx + math.cos(a) * d, bz + math.sin(a) * d
        if not spot(x, z, 1.7): continue
        f = DEAD[rng.integers(0, 5)] if rng.random() < 0.8 else TWIST[rng.integers(0, 5)]
        add(f, x, z, float(rng.uniform(0, 360)), float(rng.uniform(0.5, 0.75)) * (0.75 if "Twisted" in f else 1.0), "tree",
            **({"mul": [0.55, 0.36, 0.30]} if "Twisted" in f else {}))
        placed.append((x, z)); k += 1
k = 0; tries = 0
while k < 40 and tries < 20000:
    tries += 1
    x, z = rng.uniform(0, S, 2)
    if max(abs(x - C), abs(z - C)) < 17 or not spot(x, z, 5.0): continue
    f = DEAD[rng.integers(0, 5)] if rng.random() < 0.85 else TWIST[rng.integers(0, 5)]
    add(f, x, z, float(rng.uniform(0, 360)), float(rng.uniform(0.55, 0.8)) * (0.75 if "Twisted" in f else 1.0), "tree",
        **({"mul": [0.55, 0.36, 0.30]} if "Twisted" in f else {}))
    placed.append((x, z)); k += 1

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
        if on_path(x, z, 0.05) or on_lava(x, z, 0.02) or near_plaza(x, z, 5.8) or in_pad(x, z, 0.5) or not free(x, z, 0.2): continue
        if mind > 0 and any(math.hypot(x - a_, z - b_) < mind for a_, b_ in placed): continue
        add(files[rng.integers(0, len(files))], x, z, float(rng.uniform(0, 360)), float(rng.uniform(*scale)), tag, mm=mm, **kw)
        k += 1
BAS = [0.40, 0.36, 0.36]
scatter([CA + "rocks-large.glb", CA + "rocks-small.glb"], 70, (1.0, 2.0), "rock", 1.4, mm=False, mul=BAS)
scatter([NAT + "Rock_Medium_%d.gltf" % i for i in (1, 2, 3)], 60, (0.3, 0.6), "rock", 1.2, mm=True, tint=[0.36, 0.33, 0.33])
# rochers sur les flancs du volcan
def flank(x, z):
    d = math.hypot(x - vx, z - vz); return vr * 0.55 < d < vr * 1.05
scatter([CA + "rocks-large.glb"], 40, (1.4, 2.4), "rock", 1.2, mm=False, mul=BAS, where=flank)
# obsidienne : cristaux rouges luisants
OBS = dict(mul=[0.45, 0.18, 0.16], emit=[1.0, 0.25, 0.08], emit_e=0.7)
scatter([TD + "detail-crystal-large.glb", TD + "detail-crystal.glb"], 70, (1.6, 2.8), "crystal", 0.8, mm=False, cluster=[(x, z, r) for x, z, r in W.OBSIDIAN], **OBS)
for x, z, r in W.OBSIDIAN:
    objs.append({"type": "light", "p": [x, gy(x, z) + 1.0, z], "c": [1.0, 0.35, 0.15], "e": 1.6, "range": 5.0})
scatter([NAT + "Pebble_Round_%d.gltf" % i for i in (1, 2, 3, 4, 5)] + [NAT + "Pebble_Square_%d.gltf" % i for i in (1, 3, 4)], 900, (0.5, 0.9), "pebble", tint=[0.32, 0.30, 0.30])
# herbes sèches, buissons roux (feuillage naturel rouge du kit)
DRY = [0.66, 0.50, 0.28]
inwood = lambda x, z: any(math.hypot(x - a_, z - b_) < r_ + 0.5 for a_, b_, r_ in W.WOODS)
def mead(x, z):
    for _, cx, cz, w_, h_, ang in W.MEADOWS:
        a_ = math.radians(ang); u = (x - cx) * math.cos(a_) + (z - cz) * math.sin(a_); v = -(x - cx) * math.sin(a_) + (z - cz) * math.cos(a_)
        if abs(u) < w_ / 2 and abs(v) < h_ / 2: return True
    return False
scatter([NAT + "Bush_Common.gltf"], 90, (0.4, 0.6), "bush", 1.2, mm=True, tint=[0.62, 0.30, 0.18])
tufts = [(rng.uniform(0, 96), rng.uniform(0, 96), rng.uniform(1.5, 3.0)) for _ in range(110)]
scatter([NAT + "Grass_Wispy_Tall.gltf", NAT + "Grass_Common_Tall.gltf"], 6000, (0.3, 0.5), "grass", cluster=tufts, tint=DRY, where=lambda x, z: not forbid(x, z))
scatter([NAT + "Grass_Wispy_Short.gltf", NAT + "Grass_Common_Short.gltf"], 4000, (0.28, 0.45), "grass", tint=[0.58, 0.46, 0.30], where=lambda x, z: not forbid(x, z))
scatter([NAT + "Flower_3_Single.gltf", NAT + "Flower_4_Single.gltf"], 600, (0.22, 0.34), "flower", where=mead)
scatter([NAT + "Grass_Wispy_Tall.gltf"], 2200, (0.3, 0.5), "grass", where=mead, tint=[0.78, 0.56, 0.26])
# bords de lave : blocs de basalte
def lava_edge(x, z):
    return on_lava(x, z, 0.0001) is False and any(on_lava(x + dx, z + dz, 0.3) for dx, dz in ((1.2, 0), (-1.2, 0), (0, 1.2), (0, -1.2)))
scatter([CA + "rocks-small.glb"], 90, (0.7, 1.2), "rock", mm=False, mul=BAS, where=lava_edge)
from thin_paths import thin
objs = thin(objs, PATH if "PATH" in globals() else np.load("mask_path.npy"), 96.0)

json.dump(objs, open("objects.json", "w"))
json.dump({"pads": pads, "B": [list(b) for b in W.TOWN]}, open("plan.json", "w"))
from collections import Counter
print(Counter(o.get("tag", o["type"]) for o in objs))
