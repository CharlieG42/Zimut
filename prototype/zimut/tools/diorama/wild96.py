# Plaines sauvages autour du village (exécuté dans layout96.py : add/gy/on_path… travaillent en coordonnées village).
# Ici tout est en coordonnées monde (0..96) ; on convertit avec -OFF à l'appel.
SW_ = W.S
CW_ = W.C
WL = float(np.load("lake.npy")[0])
wrng = np.random.default_rng(97)
wplaced = [(x + OFF, z + OFF, m) for x, z, m in placed]      # arbres déjà posés (monde)

def wgy(x, z): return gy(x - OFF, z - OFF)
def won_path(x, z, thr=0.05): return on_path(x - OFF, z - OFF, thr)
def win_pad(x, z, e=0.0): return in_pad(x - OFF, z - OFF, e)
STONE_MUL = [0.58, 0.60, 0.64]
def wadd(f, x, z, r=0, s=1.0, tag="", mm=False, keep=0.0, tint=None, sc=None, yoff=0.0, mul=None):
    add(f, x - OFF, z - OFF, r, s, tag, yoff, mm, keep, tint, sc)
    if mul: objs[-1]["mul"] = mul
def wfree(x, z, r): return free(x - OFF, z - OFF, r)
def lake_sd(x, z):
    lx, lz, ra, rb, ang = W.LAKE
    a_ = math.radians(ang); u = (x - lx) * math.cos(a_) + (z - lz) * math.sin(a_); v = -(x - lx) * math.sin(a_) + (z - lz) * math.cos(a_)
    return (math.sqrt((u / ra) ** 2 + (v / rb) ** 2) - 1.0) * min(ra, rb)
def win_zone(x, z, zones, m=0.0):
    for zz in zones:
        _, cx, cz, w_, h_, ang = zz
        a_ = math.radians(ang); u = (x - cx) * math.cos(a_) + (z - cz) * math.sin(a_); v = -(x - cx) * math.sin(a_) + (z - cz) * math.cos(a_)
        if abs(u) < w_ / 2 + m and abs(v) < h_ / 2 + m: return True
    return False
WOR = [("v", W.ORCHARD[0], W.ORCHARD[1], W.ORCHARD[2], W.ORCHARD[3], 0)]
def win_field(x, z, m=0.0): return win_zone(x, z, W.FIELDS, m) or win_zone(x, z, WOR, m)
def win_meadow(x, z, m=0.0): return win_zone(x, z, W.MEADOWS, m)
def village(x, z, m=0.0): return max(abs(x - CW_), abs(z - CW_)) < 23.6 + m
RX, RZ = W.RUINS
SX, SZ = W.STONES
def special(x, z, m=0.0):
    return math.hypot(x - RX, z - RZ) < 7.5 + m or math.hypot(x - SX, z - SZ) < 5.0 + m

# ── lac
objs.append({"type": "water", "c": [W.LAKE[0], W.LAKE[1]], "r": [W.LAKE[2] + 0.6, W.LAKE[3] + 0.6], "ang": W.LAKE[4], "y": WL})

# ── bâtiments de donjon (V118) : un groupe d'objets par donjon (un seul occultant en jeu)
import dungeons3d as DG
for gi, (dname, dkind, dx, dz) in enumerate(W.DUNGEONS):
    for o_ in DG.build(dkind, dx, dz, wgy, KT, NAT):
        o_["group"] = "donjon%d" % gi
        o_["gc"] = [dx, dz]
        objs.append(o_)
    occupied.append((dx - OFF, dz - OFF, W.DUNGEON_RAD[dkind] + 0.8))
    for k_ in (4.8, 7.4, 10.0):                      # V122 : cône de vue dégagé devant l'entrée (rien ne cache le donjon)
        occupied.append((dx - OFF + 0.7071 * k_, dz - OFF + 0.7071 * k_, 3.0))


# ── ruines du fort (nord-ouest) : enceinte éboulée, tours, engins de siège démolis
CA = KT + "castle/"
ruin = [("tower-base", -4, -4, 0), ("wall-half", -2, -4, 0), ("wall", 0, -4, 0), ("wall-half", 4, -4, 180), ("tower-base", 4, -4, 0),
        ("wall-half", -4, -2, 90), ("wall", -4, 2, 90), ("wall-corner", -4, 4, 0)]   # V118 : façade ouverte sur le donjon
for nm, dx, dz, r in ruin:
    wadd(CA + nm + ".glb", RX + dx * 0.8, RZ + dz * 0.8, r, 1.6, "ruin", keep=1.1, mul=STONE_MUL)
wadd(CA + "siege-catapult-demolished.glb", RX + 6.5, RZ + 4.5, 200, 1.6, "ruin", keep=1.4)
for k in range(10):
    a_ = wrng.uniform(0, 2 * math.pi); d_ = wrng.uniform(2.5, 7.0)
    x, z = RX + math.cos(a_) * d_, RZ + math.sin(a_) * d_
    if wfree(x, z, 0.6) and not won_path(x, z, 0.1):
        wadd(CA + ["rocks-small", "rocks-large"][k % 2] + ".glb", x, z, float(wrng.uniform(0, 360)), float(wrng.uniform(0.9, 1.5)), "rock", keep=0.8, mul=STONE_MUL)
# ── pierres levées (plaine de l'est)
for k in range(9):
    a_ = k * 2 * math.pi / 9 + 0.2
    wadd(NAT + "Rock_Medium_%d.gltf" % (k % 3 + 1), SX + math.cos(a_) * 3.2, SZ + math.sin(a_) * 3.2, float(wrng.uniform(0, 360)), 0.4, "stone",
         keep=0.7, sc=[0.55, 1.9 + 0.4 * (k % 3), 0.55])
wadd(NAT + "Rock_Medium_2.gltf", SX, SZ, 15, 0.4, "stone", keep=1.0, sc=[1.2, 0.45, 0.9])

# ── hameau (sud-est) : meules, clôtures, cultures
for x, z in ((79.0, 77.5), (80.2, 78.4), (85.5, 82.5), (69.5, 81.0)):
    wadd(KT + "graveyard/hay-bale.glb", x, z, float(wrng.uniform(0, 360)), 1.8, "hay", keep=0.6)
wadd(KT + "fantasy-town/cart-high.glb", 74.5, 80.5, 120, 1.8, "cart", keep=1.0)
WHEAT_ = (0.80, 0.58, 0.20)
for kind, cx, cz, w_, h_, ang in W.FIELDS[len(FIELDS):]:
    a_ = math.radians(ang); ca, sa = math.cos(a_), math.sin(a_)
    for i in range(int(w_ / 1.2)):
        x = cx - w_ / 2 + 0.6 + i * 1.2
        wadd(KT + "fantasy-town/fence.glb", x, cz + h_ / 2 + 0.35, 0, 1.2, "fence")
    if kind != "ble":
        continue
    v = -h_ / 2 + 0.25
    while v < h_ / 2 - 0.15:
        u = -w_ / 2 + 0.15
        while u < w_ / 2 - 0.1:
            uu = u + wrng.uniform(-0.06, 0.06); vv = v + wrng.uniform(-0.05, 0.05)
            x = cx + uu * ca - vv * sa; z = cz + uu * sa + vv * ca
            wadd(NAT + ["Grass_Wispy_Tall.gltf", "Grass_Common_Tall.gltf"][wrng.integers(0, 2)], x, z, float(wrng.uniform(0, 360)), float(wrng.uniform(0.32, 0.44)), "ble", mm=True, tint=list(WHEAT_))
            u += 0.2
        v += 0.42
# panneaux aux carrefours des plaines
for x, z, r in ((22.6, 54.6, 20), (73.6, 44.6, 200), (40.6, 73.4, 90), (81.8, 42.6, 160), (37.2, 83.4, 30)):
    if not won_path(x, z, 0.3):
        wadd(KT + "survival/signpost.glb", x, z, r, 2.0, "prop", keep=0.4)

# ── arbres : bois denses + arbres isolés des plaines
def wspot(x, z, mind):
    if not (0.5 < x < SW_ - 0.5 and 0.5 < z < SW_ - 0.5): return False
    if village(x, z, -0.6) or won_path(x, z, 0.02) or win_pad(x, z, 1.2) or not wfree(x, z, 1.0): return False
    if win_field(x, z, 1.0) or lake_sd(x, z) < 1.4 or special(x, z): return False
    return all(math.hypot(x - a_, z - b_) > max(mind, m) for a_, b_, m in wplaced)
DEAD = [NAT + "DeadTree_%d.gltf" % i for i in (1, 2, 3, 4, 5)]
n_w = 0
for bx, bz, br in W.WOODS:
    want = int(br * br * 1.05)
    k = 0; tries = 0
    while k < want and tries < want * 60:
        tries += 1
        a_ = wrng.uniform(0, 2 * math.pi); d_ = br * math.sqrt(wrng.random()) * 1.05
        x, z = bx + math.cos(a_) * d_, bz + math.sin(a_) * d_
        if not wspot(x, z, 1.65): continue
        rr = wrng.random()
        f = PINES[wrng.integers(0, 5)] if rr < 0.6 else (TREES[wrng.integers(0, 5)] if rr < 0.95 else DEAD[wrng.integers(0, 5)])
        wadd(f, x, z, float(wrng.uniform(0, 360)), float(wrng.uniform(0.5, 0.72)), "tree")
        wplaced.append((x, z, 1.65)); k += 1; n_w += 1
k = 0; tries = 0
while k < 24 and tries < 20000:
    tries += 1
    x, z = wrng.uniform(0, SW_, 2)
    if win_meadow(x, z, 0.3) or not wspot(x, z, 6.0): continue
    f = TREES[wrng.integers(0, 5)] if wrng.random() < 0.8 else DEAD[wrng.integers(0, 5)]
    wadd(f, x, z, float(wrng.uniform(0, 360)), float(wrng.uniform(0.55, 0.8)), "tree")
    wplaced.append((x, z, 6.0)); k += 1

def wscatter(files, n, scale, tag, mind=0.0, mm=True, where=None, cluster=None, tint=None, avoid=True):
    k = 0; tries = 0
    while k < n and tries < n * 60:
        tries += 1
        if cluster:
            cx, cz, cr = cluster[wrng.integers(0, len(cluster))]
            x = cx + wrng.normal(0, cr); z = cz + wrng.normal(0, cr)
        else:
            x, z = wrng.uniform(0.3, SW_ - 0.3, 2)
        if not (0.3 < x < SW_ - 0.3 and 0.3 < z < SW_ - 0.3) or village(x, z, -0.3): continue
        if where is not None and not where(x, z): continue
        if avoid and (won_path(x, z, 0.05) or win_pad(x, z, 0.5) or win_field(x, z, 0.15) or lake_sd(x, z) < 0.3): continue
        if not wfree(x, z, 0.2): continue
        if mind > 0 and any(math.hypot(x - a_, z - b_) < min(mind, m * 0.5) for a_, b_, m in wplaced): continue
        wadd(files[wrng.integers(0, len(files))], x, z, float(wrng.uniform(0, 360)), float(wrng.uniform(*scale)), tag, mm=mm, tint=tint)
        k += 1
inwood = lambda x, z: any(math.hypot(x - a_, z - b_) < r_ + 0.5 for a_, b_, r_ in W.WOODS)
outwood = lambda x, z: not inwood(x, z)
wscatter([NAT + "Bush_Common.gltf", NAT + "Plant_1_Big.gltf"], 230, (0.42, 0.66), "bush", 1.3, mm=False)
wscatter([NAT + "Rock_Medium_%d.gltf" % i for i in (1, 2, 3)], 55, (0.25, 0.5), "rock", 1.6, mm=False)
outcrops = [(wrng.uniform(4, 92), wrng.uniform(4, 92), 1.2) for _ in range(30)]
for _i in range(22):
    pass
wscatter([CA + "rocks-large.glb", CA + "rocks-small.glb"], 22, (1.0, 1.8), "rock", 1.8, mm=False, cluster=outcrops)
for o_ in objs:
    if o_.get("f", "").endswith(("rocks-large.glb", "rocks-small.glb")): o_["mul"] = STONE_MUL
wscatter([NAT + "Pebble_Round_%d.gltf" % i for i in (1, 2, 3, 4, 5)] + [NAT + "Pebble_Square_%d.gltf" % i for i in (1, 3, 4)], 650, (0.5, 0.9), "pebble")
wscatter([NAT + "Fern_1.gltf"], 420, (0.3, 0.46), "fern", where=inwood)
wscatter([NAT + "Mushroom_Common.gltf", NAT + "Mushroom_Laetiporus.gltf"], 90, (0.2, 0.32), "mush", where=inwood)
wbeds = [(wrng.uniform(2, 94), wrng.uniform(2, 94), wrng.uniform(0.8, 1.8)) for _ in range(70)]
wscatter([NAT + "Flower_3_Single.gltf", NAT + "Flower_4_Single.gltf"], 550, (0.24, 0.42), "flower", cluster=wbeds, where=outwood)
wscatter([NAT + "Flower_3_Single.gltf", NAT + "Flower_4_Single.gltf"], 1500, (0.22, 0.36), "flower", where=lambda x, z: win_meadow(x, z, -0.4))
wscatter([NAT + "Clover_1.gltf", NAT + "Clover_2.gltf"], 2200, (0.30, 0.5), "clover")
# hautes herbes : grandes nappes ondulées des plaines (plus denses hors des bois)
tufts = [(wrng.uniform(0, 96), wrng.uniform(0, 96), wrng.uniform(1.5, 3.5)) for _ in range(160)]
wscatter([NAT + "Grass_Wispy_Tall.gltf", NAT + "Grass_Common_Tall.gltf"], 9000, (0.32, 0.52), "grass", cluster=tufts, where=outwood)
wscatter([NAT + "Grass_Common_Tall.gltf", NAT + "Grass_Wispy_Tall.gltf", NAT + "Grass_Wispy_Short.gltf", NAT + "Grass_Common_Short.gltf"], 9000, (0.26, 0.46), "grass")
# roseaux autour du lac
REED = (0.42, 0.55, 0.24)
wscatter([NAT + "Grass_Wispy_Tall.gltf", NAT + "Grass_Common_Tall.gltf"], 650, (0.45, 0.7), "reed", tint=list(REED),
         where=lambda x, z: -0.5 < lake_sd(x, z) < 0.9, avoid=False)
wscatter([NAT + "Rock_Medium_%d.gltf" % i for i in (1, 2, 3)], 14, (0.2, 0.4), "rock", mm=False,
         where=lambda x, z: 0.0 < lake_sd(x, z) < 1.2, avoid=False)
# bord des routes des plaines
for (pts, a0, b0) in W.ROADS[len(ROADS):]:
    pa = bez(pts)
    for k in range(0, len(pa), 2):
        x, z = pa[k]
        for side in (-1, 1):
            nx = x + side * wrng.uniform(1.0, 1.6) + wrng.normal(0, 0.15); nz = z + wrng.normal(0, 0.3)
            if 0.2 < nx < SW_ - 0.2 and 0.2 < nz < SW_ - 0.2 and not won_path(nx, nz, 0.4) and not village(nx, nz) and not win_field(nx, nz, 0.2):
                wadd(NAT + ["Grass_Common_Tall.gltf", "Grass_Wispy_Tall.gltf"][wrng.integers(0, 2)], nx, nz, float(wrng.uniform(0, 360)), float(wrng.uniform(0.28, 0.45)), "grass", mm=True)
print("plaines : arbres des bois", n_w)
# buissons « Bush_Common » : texture de feuilles d'automne (rouge) -> reteintés en vert
for o_ in objs:
    if o_.get("f", "").endswith("Bush_Common.gltf"):
        o_["mm"] = True
        o_["tint"] = [0.34, 0.54, 0.19]
