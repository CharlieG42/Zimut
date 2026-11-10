"""Bâtiments de donjon (diorama) : chaque donjon a une silhouette propre, éclairée, qui se voit de loin.
build(kind, ax, az, gy, KT, NAT) -> liste d'objets (coordonnées monde) ; l'entrée regarde la caméra (diagonale +x +z).
Le lieu (POI) se pose devant l'entrée : entrance(ax, az, rad)."""
import math

TH = 45.0                      # rotation : l'avant (+z local) regarde la caméra
DOOR = (0.7071, 0.7071)

def entrance(ax, az, rad):
    return ax + DOOR[0] * (rad + 0.9), az + DOOR[1] * (rad + 0.9)

def _w(ax, az, lx, lz):
    a = math.radians(TH)
    return ax + lx * math.cos(a) + lz * math.sin(a), az - lx * math.sin(a) + lz * math.cos(a)

def build(kind, ax, az, gy, KT, NAT, seed=0):
    out = []
    def put(f, lx, lz, s=1.0, r=0.0, yoff=0.0, **kw):
        x, z = _w(ax, az, lx, lz)
        o = {"type": "glb", "f": f, "p": [x, gy(x, z) + yoff, z], "r": TH + r, "s": s, "tag": "dungeon", "mm": False}
        o.update(kw)
        out.append(o)
    def light(lx, lz, h, c, e=3.0, rng=5.0):
        x, z = _w(ax, az, lx, lz)
        out.append({"type": "light", "p": [x, gy(x, z) + h, z], "c": c, "e": e, "range": rng})
    NA, GY, CA, MD, TD, PI, SV = KT + "nature/", KT + "graveyard/", KT + "castle/", KT + "mini-dungeon/", KT + "tower-defense/", KT + "pirate/", KT + "survival/"
    warm = [1.0, 0.72, 0.38]
    if kind in ("grotte", "mine"):
        stone = [0.55, 0.52, 0.50] if kind == "mine" else [0.62, 0.66, 0.58]
        # colline de rochers + porche en pierre (bouche sombre) au centre
        put(MD + "wall-opening.glb", 0, 0.4, 2.6, mul=[0.5, 0.48, 0.47])
        for k, (lx, lz, s_, yo) in enumerate([(-2.2, 0.2, 3.0, 0), (2.2, 0.1, 3.0, 0), (-1.3, -1.6, 3.4, 0), (1.4, -1.5, 3.3, 0),
                                              (0.0, -1.0, 3.4, 1.1), (-2.6, -1.9, 2.6, 0), (2.7, -1.8, 2.6, 0), (0.0, -2.8, 3.2, 0.4)]):
            put(CA + "rocks-large.glb", lx, lz, s_, k * 53.0, yoff=yo, mul=stone)
        if kind == "grotte":
            put(GY + "lightpost-single.glb", -1.5, 2.0, 1.7)
            put(GY + "lightpost-single.glb", 1.5, 2.0, 1.7)
            put(NAT + "Bush_Common.gltf", -2.6, 1.4, 0.6, tint=[0.34, 0.54, 0.19], mm=True, tag="bush")
            put(NAT + "Bush_Common.gltf", 2.8, 1.2, 0.55, tint=[0.34, 0.54, 0.19], mm=True, tag="bush")
            put(NAT + "Fern_1.gltf", -0.9, -1.4, 0.6, yoff=1.6, mm=True, tag="fern")
            light(0, 1.6, 1.3, [0.75, 1.0, 0.55], 1.1, 4.5)
        else:
            put(MD + "wood-support.glb", 0, 1.9, 2.9)
            put(SV + "barrel.glb", -1.9, 2.1, 1.8)
            put(SV + "box-large.glb", 2.0, 2.3, 1.8, 30)
            put(SV + "tool-pickaxe.glb", 1.3, 2.9, 1.8, 70)
            put(GY + "fire-basket.glb", -1.3, 2.7, 2.2, emit=[1.0, 0.45, 0.1], emit_e=1.2)
            put(GY + "fire-basket.glb", 1.3, 2.7, 2.2, emit=[1.0, 0.45, 0.1], emit_e=1.2)
            light(0, 1.8, 1.0, [1.0, 0.55, 0.2], 1.4, 4.5)
    elif kind == "antre":
        put(NA + "cliff_cave_stone.glb", 0, 0, 3.0, mul=[0.6, 0.55, 0.5])
        for k, (lx, lz, s) in enumerate([(-2.4, 0.3, 2.6), (2.5, 0.2, 2.4), (-1.6, -1.8, 2.8), (1.8, -1.9, 2.5), (0.2, -2.4, 3.0)]):
            put(GY + "rocks-tall.glb", lx, lz, s, k * 47.0, mul=[0.62, 0.58, 0.54])
        put(GY + "trunk-long.glb", 2.2, 2.2, 2.0, 60)
        put(NAT + "DeadTree_3.gltf", -2.8, -1.0, 0.65, tag="tree")
        light(0, 1.4, 1.0, [1.0, 0.45, 0.3], 1.7, 4.5)
    elif kind == "sanctuaire":
        put(GY + "altar-stone.glb", 0, 0, 2.2, mul=[0.7, 0.72, 0.8])
        for k in range(6):
            a = k * math.tau / 6 + 0.3
            put(TD + "detail-crystal-large.glb", math.cos(a) * 2.6, math.sin(a) * 2.6, 2.6 + 0.6 * (k % 2), k * 37.0,
                mul=[0.55, 0.85, 1.15], emit=[0.20, 0.55, 1.0], emit_e=0.9)
        for k in range(4):
            a = k * math.tau / 4 + 0.78
            put(GY + "pillar-obelisk.glb", math.cos(a) * 3.5, math.sin(a) * 3.5, 2.3, mul=[0.7, 0.72, 0.8])
        light(0, 0, 1.6, [0.45, 0.8, 1.0], 2.8, 7.5)
    elif kind == "crypte":
        put(GY + "crypt-large.glb", 0, 0, 2.3, mul=[0.6, 0.62, 0.7])
        put(GY + "crypt-large-roof.glb", 0, 0, 2.3, yoff=2.3, mul=[0.42, 0.44, 0.55])
        put(GY + "crypt-large-door.glb", -0.32 * 2.3, 1.22 * 2.3, 2.3)
        for k, (lx, lz) in enumerate([(-2.8, 1.2), (-2.9, -0.6), (2.8, 1.0), (2.9, -0.8), (-1.8, 3.4), (1.9, 3.3)]):
            put(GY + ["gravestone-cross", "gravestone-round", "gravestone-broken", "gravestone-decorative"][k % 4] + ".glb", lx, lz, 1.8, k * 13.0)
        put(GY + "lightpost-double.glb", 0, 3.6, 1.6)
        put(GY + "pine-crooked.glb", -2.5, -2.6, 2.6, tag="tree")
        light(0, 3.2, 1.6, [0.55, 0.7, 1.0], 2.2, 6.0)
    elif kind == "donjon_sylve":
        put(PI + "castle-gate.glb", 0, 0, 0.95, mul=[0.72, 0.72, 0.68])
        put(NAT + "CommonTree_3.gltf", 0, -3.8, 1.25, tag="tree")
        put(GY + "fire-basket.glb", -2.6, 1.6, 2.4, emit=[1.0, 0.5, 0.15], emit_e=1.3)
        put(GY + "fire-basket.glb", 2.6, 1.6, 2.4, emit=[1.0, 0.5, 0.15], emit_e=1.3)
        put(KT + "fantasy-town/banner-green.glb", -1.6, 1.9, 2.4)
        put(KT + "fantasy-town/banner-green.glb", 1.6, 1.9, 2.4)
        light(-2.6, 1.6, 1.0, [1.0, 0.6, 0.25], 1.9, 5.0)
        light(2.6, 1.6, 1.0, [1.0, 0.6, 0.25], 1.9, 5.0)
        light(0, 2.4, 2.6, [0.7, 1.0, 0.6], 1.7, 6.0)
    elif kind == "fosse":
        x, z = _w(ax, az, 0, 0)
        out.append({"type": "lava", "c": [x, z], "r": [2.3, 2.3], "ang": 0.0, "y": gy(x, z) + 0.06})
        for k in range(8):
            a = k * math.tau / 8
            put(CA + "rocks-large.glb", math.cos(a) * 2.9, math.sin(a) * 2.9, 1.4 + 0.3 * (k % 2), k * 41.0, mul=[0.42, 0.38, 0.38])
        for k in range(3):
            a = k * math.tau / 3 + 0.5
            put(GY + "pillar-obelisk.glb", math.cos(a) * 3.8, math.sin(a) * 3.8, 2.6, mul=[0.45, 0.4, 0.4])
        light(0, 0, 1.2, [1.0, 0.45, 0.12], 3.9, 8.0)
    elif kind == "forteresse":
        dark = [0.46, 0.42, 0.44]
        for tx, tz in ((-3.6, -0.6), (3.6, -0.6), (-3.6, -5.6), (3.6, -5.6)):
            put(CA + "tower-square-base.glb", tx, tz, 1.9, mul=dark)
            put(CA + "tower-square-mid.glb", tx, tz, 1.9, yoff=1.9, mul=dark)
            put(CA + "tower-square-mid.glb", tx, tz, 1.9, yoff=3.8, mul=dark)
            put(CA + "tower-square-top.glb", tx, tz, 1.9, yoff=5.7, mul=dark)
            put(CA + "flag.glb", tx, tz, 1.9, yoff=6.3, mul=[1.2, 0.35, 0.25])
        for lx in (-2.1, 2.1):
            put(CA + "wall.glb", lx, -0.6, 1.9, 90, mul=dark)
        for lz in (-2.3, -4.1):
            put(CA + "wall.glb", -3.6, lz, 1.9, 0, mul=dark)
            put(CA + "wall.glb", 3.6, lz, 1.9, 0, mul=dark)
        put(CA + "wall.glb", -1.8, -5.6, 1.9, 90, mul=dark)
        put(CA + "wall.glb", 1.8, -5.6, 1.9, 90, mul=dark)
        put(PI + "castle-gate.glb", 0, 0.2, 0.75, mul=dark)
        for lx in (-2.0, 2.0):
            put(GY + "fire-basket.glb", lx, 1.9, 2.4, emit=[1.0, 0.45, 0.1], emit_e=1.6)
            light(lx, 1.9, 0.9, [1.0, 0.5, 0.15], 2.2, 5.5)
        light(0, -3.0, 3.0, [1.0, 0.35, 0.1], 2.8, 8.0)
    elif kind == "tour_brume":
        # V124 : tour hexagonale à demi noyée, lumières de feux follets (donjon de la Nation des Brumes)
        stone = [0.52, 0.60, 0.56]
        put(CA + "tower-hexagon-base.glb", 0, 0, 2.4, mul=stone)
        put(CA + "tower-hexagon-mid.glb", 0, 0, 2.4, yoff=2.4, mul=stone)
        put(CA + "tower-hexagon-mid.glb", 0, 0, 2.4, yoff=4.8, mul=stone)
        put(CA + "tower-hexagon-top.glb", 0, 0, 2.4, yoff=7.2, mul=stone)
        put(CA + "tower-hexagon-roof.glb", 0, 0, 2.4, yoff=7.2, mul=[0.22, 0.36, 0.34])
        put(MD + "wall-opening.glb", 0, 1.9, 1.5, mul=[0.4, 0.46, 0.44])
        for k, (lx, lz) in enumerate([(-2.6, 1.8), (2.6, 1.8), (-3.2, -0.8), (3.2, -0.6)]):
            put(GY + ["gravestone-cross", "gravestone-round", "gravestone-broken", "gravestone-decorative"][k % 4] + ".glb", lx, lz, 1.8, k * 17.0)
        put(GY + "lightpost-double.glb", -1.7, 3.0, 1.7)
        put(GY + "lightpost-double.glb", 1.7, 3.0, 1.7)
        put(NAT + "DeadTree_3.gltf", -3.4, -2.6, 1.3, tag="tree")
        put(NAT + "TwistedTree_2.gltf", 3.6, -2.4, 1.1, tag="tree")
        light(0, 2.8, 1.8, [0.45, 1.0, 0.78], 2.6, 7.0)
        light(0, 0.0, 5.5, [0.45, 0.95, 0.80], 2.0, 8.0)
    elif kind == "souche":
        # V124 : souche géante creuse (le Vieux Saule), champignons luisants
        put(NAT + "DeadTree_2.gltf", 0, -0.6, 3.2, tag="tree")
        put(NAT + "DeadTree_4.gltf", -2.8, -1.8, 1.6, tag="tree")
        put(MD + "wall-opening.glb", 0, 1.0, 1.7, mul=[0.34, 0.28, 0.22])
        for k, (lx, lz, s_) in enumerate([(-2.0, 1.6, 1.4), (2.1, 1.2, 1.6), (-3.0, 0.2, 1.2), (3.0, -0.4, 1.3), (1.0, 2.6, 1.0)]):
            put(NAT + "Mushroom_Laetiporus.gltf" if k % 2 == 0 else NAT + "Mushroom_Common.gltf", lx, lz, s_, k * 41.0, tag="mush", mm=True)
        for k, (lx, lz) in enumerate([(-1.6, 2.4), (1.8, 2.5)]):
            put(CA + "rocks-small.glb", lx, lz, 1.6, k * 70.0, mul=[0.36, 0.40, 0.36])
        light(0, 1.8, 1.4, [0.50, 1.0, 0.70], 2.4, 6.0)
        light(-2.0, 1.6, 0.8, [0.55, 0.9, 1.0], 1.4, 4.0)
    elif kind == "pilotis":
        # V124 : cabane sur pilotis, ponton et barque (Cabane des Noyés)
        put(PI + "structure-platform-dock.glb", 0, 0, 2.0)
        put(PI + "structure.glb", 0, -0.8, 1.7, yoff=0.5)
        put(PI + "structure-roof.glb", 0, -0.8, 1.7, yoff=2.6)
        put(PI + "boat-row-small.glb", 3.0, 1.8, 1.6, 30.0)
        put(PI + "barrel.glb", -1.8, 1.4, 1.5)
        put(PI + "crate.glb", -2.3, 0.6, 1.5)
        put(GY + "lightpost-single.glb", 1.6, 2.6, 1.6)
        put(GY + "lightpost-single.glb", -1.6, 2.6, 1.6)
        light(0, 2.4, 1.6, [0.55, 0.95, 0.8], 2.2, 6.0)
    elif kind == "ruine":
        # V124 : ruines englouties (arche, murs éboulés, colonnes)
        stone = [0.55, 0.60, 0.56]
        put(CA + "wall-doorway.glb", 0, 0, 2.4, 90.0, mul=stone)
        put(CA + "wall-half.glb", -2.4, -0.1, 2.4, mul=stone)
        put(CA + "wall-half.glb", 2.4, -0.1, 2.4, 180.0, mul=stone)
        put(CA + "tower-base.glb", -4.2, -1.4, 1.8, mul=stone)
        put(CA + "tower-base.glb", 4.2, -1.4, 1.8, mul=stone)
        put(MD + "wall-opening.glb", 0, 0.5, 1.5, mul=[0.36, 0.42, 0.40])
        for k, (lx, lz) in enumerate([(-1.8, 2.3), (1.8, 2.4), (-3.0, 1.4), (3.2, 1.2)]):
            put(GY + "column-large.glb", lx, lz, 1.8, k * 23.0, mul=stone)
        put(CA + "rocks-small.glb", 0.8, 3.0, 1.7, 40.0, mul=[0.38, 0.42, 0.38])
        light(0, 2.2, 1.6, [0.5, 0.95, 0.85], 2.4, 6.5)
    elif kind == "portail":
        # V131 : portail entre Nations — arche de pierre dressée face à la caméra, obélisques et cristaux lumineux.
        # Le tourbillon lui-même est dessiné par le jeu dans l'ouverture (ouvert / scellé).
        stone = [0.66, 0.68, 0.72]
        put(CA + "wall-doorway.glb", 0, 0, 2.6, 90.0, mul=stone)
        put(GY + "pillar-obelisk.glb", -2.1, 0.5, 2.1, mul=[0.60, 0.64, 0.74])
        put(GY + "pillar-obelisk.glb", 2.1, 0.5, 2.1, mul=[0.60, 0.64, 0.74])
        for k, (lx, lz, s_) in enumerate([(-1.5, 1.5, 1.5), (1.5, 1.5, 1.5), (-2.9, -0.3, 1.9), (2.9, -0.3, 1.9)]):
            put(TD + "detail-crystal-large.glb", lx, lz, s_, k * 41.0, mul=[0.55, 0.95, 1.15], emit=[0.20, 0.70, 1.0], emit_e=1.1)
        put(CA + "rocks-small.glb", -2.6, -1.2, 1.6, 20.0, mul=[0.52, 0.54, 0.56])
        put(CA + "rocks-small.glb", 2.7, -1.3, 1.6, 140.0, mul=[0.52, 0.54, 0.56])
        light(0, 0.8, 1.5, [0.40, 0.90, 1.0], 3.0, 6.5)
        light(-1.5, 1.5, 0.8, [0.35, 0.85, 1.0], 1.6, 3.5)
        light(1.5, 1.5, 0.8, [0.35, 0.85, 1.0], 1.6, 3.5)
    return out
