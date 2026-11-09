#!/usr/bin/env python3
"""Cuit la Sylve « diorama » (monde 96x96, finition B) en planche iso jouable pour la carte 2D.

Entrées (dossier courant) : fin_<tx>_<ty>.webp/.png (post96), render/id_<tx>_<ty>.png (passe d'identifiants 4x4),
objects.json, occluders.json, plan.json, height2.npy, mask_path.npy.
Sorties : <repo>/assets/boards/sylve_diorama/*.webp + <repo>/data/boards/foret_sylve_diorama.json
"""
import json, math, sys, os, numpy as np, cv2
from collections import deque
from PIL import Image
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import plan96 as W
from plan96 import FIELDS, ORCHARD, LAKE, OFF
Image.MAX_IMAGE_PIXELS = None

REPO = sys.argv[1] if len(sys.argv) > 1 else os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), "../.."))
OUT_DIR = REPO + "/assets/boards/sylve_diorama/"
RES_DIR = "res://assets/boards/sylve_diorama/"
os.makedirs(OUT_DIR, exist_ok=True)

S = 96.0                  # monde (unités)
N = 144                   # cases par côté
CW = S / N                # taille d'une case (unités)
NT = 4                    # tuiles de rendu par côté
TILE_W, TILE_H = 2560, 1440
IMG_W, IMG_H = TILE_W * NT, TILE_H * NT
K = IMG_H / 99.2          # pixels d'image par unité (caméra orthographique, hauteur 49.6)
CAM_C = np.array([48.0, 1.6, 48.0])
TW, TH, CS = 128.0, 64.0, 0.625
SCALE = (TW * CS * 0.5) / (0.70710678 * K * CW)      # pixels du monde du jeu par pixel d'image
UNIT = 8                  # huitièmes d'étage -> 64/8 = 8 px du monde par cran de hauteur
UNIT_PX = 64.0 / UNIT

def img_px(wx, h, wz):
    dx, dh, dz = wx - CAM_C[0], h - CAM_C[1], wz - CAM_C[2]
    return (IMG_W / 2 + 0.70710678 * K * (dx - dz), IMG_H / 2 + K * (0.35355339 * (dx + dz) - 0.8660254 * dh))

# ── relief par case
H = np.load("height2.npy")
hr = H.shape[0]
def ground_h(x, z):
    i = min(hr - 1, max(0, int(z / S * hr))); j = min(hr - 1, max(0, int(x / S * hr)))
    return float(H[i, j])
hpx_per_unit = 0.8660254 * K * SCALE                   # pixels du monde par unité de hauteur
heights = np.zeros((N, N), int)
for cy in range(N):
    for cx in range(N):
        heights[cy, cx] = int(round(ground_h((cx + 0.5) * CW, (cy + 0.5) * CW) * hpx_per_unit / UNIT_PX))
maxh = int(heights.max())
origin = (N * TW * CS * 0.5 + 100.0, 220.0 + maxh * UNIT_PX)
# position (monde du jeu) du pixel (0,0) de l'image : la case (0,0) au sol (h=0) tombe sur iso_pos
px00 = img_px(0.5 * CW, 0.0, 0.5 * CW)
offset = (origin[0] - px00[0] * SCALE, origin[1] - px00[1] * SCALE)

# ── cases jouables
objs = json.load(open("objects.json"))
plan = json.load(open("plan.json"))
block = np.zeros((N, N), bool)
cxs = (np.arange(N) + 0.5) * CW
X, Z = np.meshgrid(cxs, cxs)
def block_disc(x, z, r):
    block[(X - x) ** 2 + (Z - z) ** 2 < r * r] = True
def block_rect(cx, cz, w, h, ang, m=0.0):
    a = math.radians(ang)
    u = (X - cx) * math.cos(a) + (Z - cz) * math.sin(a)
    v = -(X - cx) * math.sin(a) + (Z - cz) * math.cos(a)
    block[(np.abs(u) < w / 2 + m) & (np.abs(v) < h / 2 + m)] = True
bi = 0
RAD = {"ruin": 1.0, "stone": 0.55, "tree": 0.55, "stall": 1.15, "cart": 0.9, "fountain": 2.75, "lantern": 0.3, "banner": 0.35, "prop": 0.45,
       "hay": 0.5, "grave": 0.45, "rock": 0.45, "bush": 0.4, "hedge": 0.45, "bench": 0.6}
for o in objs:
    if o["type"] == "water":
        continue
    if o["type"] == "asm":
        job, cx, cz, r, s = plan["B"][bi]; bi += 1
        fp = None
        gs = o["s"]
        # emprise : on la retrouve via les pièces (min/max des positions locales)
        xs = [p["p"][0] for p in o["parts"]]; zs = [p["p"][2] for p in o["parts"]]
        w = (max(xs) - min(xs) + 1.0) * gs; h = (max(zs) - min(zs) + 1.0) * gs
        block_rect(cx, cz, w, h, -r, 0.25)   # rotation Godot (sens direct vu de dessus) = -angle dans (x,z)
        continue
    tag = o.get("tag", "")
    x, z = o["p"][0], o["p"][2]
    if tag == "fence":
        block_disc(x, z, 0.4)
        a = math.radians(o["r"]); dx, dz = math.cos(a) * 0.5 * o["s"], -math.sin(a) * 0.5 * o["s"]
        block_disc(x + dx, z + dz, 0.35); block_disc(x - dx, z - dz, 0.35)
    elif tag in RAD:
        block_disc(x, z, RAD[tag] * (1.0 if tag in ("fountain", "stall") else 1.0))
for kind, cx, cz, w, h, ang in FIELDS:
    block_rect(cx, cz, w, h, ang, 0.1)
# lac
_a = math.radians(LAKE[4])
_u = (X - LAKE[0]) * math.cos(_a) + (Z - LAKE[1]) * math.sin(_a); _v = -(X - LAKE[0]) * math.sin(_a) + (Z - LAKE[1]) * math.cos(_a)
block[np.sqrt((_u / (LAKE[2] + 0.3)) ** 2 + (_v / (LAKE[3] + 0.3)) ** 2) < 1.0] = True
block_rect(ORCHARD[0], ORCHARD[1], ORCHARD[2], ORCHARD[3], 0, 0.0)
block[0, :] = block[-1, :] = True
block[:, 0] = block[:, -1] = True
walk = ~block
# Départ du catalogue (ADVENTURE_ZONES « start » = 3,6) fermé : une partie neuve y est posée par défaut ;
# case non jouable -> AdventureManager la replace au départ de la planche (comme pour les planches v2 / iso).
walk[6, 3] = False

# ── lieux (positions monde -> case jouable la plus proche) ; jeu de lieux de la planche iso
iso = json.load(open(REPO + "/data/boards/foret_sylve_iso.json"))
by_name = {}
for k, v in iso["pois"].items():
    by_name.setdefault(v["name"], []).append(v)
PLACES = [("Source claire", 44.0, 59.2), ("Coffre moussu", 50.6, 69.6), ("Camp gobelin", 55.2, 57.4),
          ("Tanière du sanglier", 35.6, 55.4), ("Grotte de la Feuille", 19.5, 86.0), ("Meute de loups gris", 58.0, 88.5),
          ("Antre de la Patte", 82.0, 92.0), ("Clairière des lucioles", 84.5, 62.0), ("Embuscade sous les pins", 88.0, 50.0),
          ("Souche creuse", 13.0, 40.0), ("Poste de la Citadelle", 86.5, 34.0), ("Sanctuaire de Cristal", 77.5, 22.0),
          ("Crypte du Chêne Noir", 9.0, 66.0), ("Refuge des hauteurs", 52.0, 11.0), ("Cache du bûcheron", 60.5, 7.0),
          ("Garde des cimes", 34.0, 8.0), ("Antre du prédateur", 26.0, 4.5), ("Donjon de la Nation Sylvestre", 16.0, 16.0),
          ("Belvédère de la Sylve", 70.0, 4.0), ("Portail vers les Cendres", 4.0, 24.0)]
START_W = (48.0, 54.2)

def cell_of(x, z):
    return (min(N - 1, int(x / CW)), min(N - 1, int(z / CW)))

def reach(start):
    seen = np.zeros((N, N), bool); q = deque([start]); seen[start[1], start[0]] = True
    while q:
        cx, cy = q.popleft()
        for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
            nx, ny = cx + dx, cy + dy
            if 0 <= nx < N and 0 <= ny < N and walk[ny, nx] and not seen[ny, nx]:
                seen[ny, nx] = True; q.append((nx, ny))
    return seen

def nearest(c, ok):
    best, bd = None, 1e9
    for cy in range(N):
        for cx in range(N):
            if ok[cy, cx]:
                d = (cx - c[0]) ** 2 + (cy - c[1]) ** 2
                if d < bd: best, bd = (cx, cy), d
    return best

start = nearest(cell_of(*START_W), walk)
R = reach(start)
walk &= R                                  # poches isolées fermées
pois = {}
taken = set()
for name, x, z in PLACES:
    ok = R.copy()
    for (tx, ty) in taken:
        ok[max(0, ty - 2):ty + 3, max(0, tx - 2):tx + 3] = False
    c = nearest(cell_of(x, z), ok)
    taken.add(c)
    pois["%d,%d" % c] = by_name[name][0]
assert len(pois) == len(iso["pois"]), (len(pois), len(iso["pois"]))

# ── sentiers (cases de chemin)
MP = np.load("mask_path.npy"); pr = MP.shape[0]
trail = []
for cy in range(N):
    for cx in range(N):
        if walk[cy, cx] and MP[min(pr - 1, int((cy + 0.5) * CW / S * pr)), min(pr - 1, int((cx + 0.5) * CW / S * pr))] > 0.3:
            trail.append("%d,%d" % (cx, cy))

# ── image de fond : tuiles de post96
import shutil
tiles = []
for ty in range(NT):
    for tx in range(NT):
        fn = "sol_%d_%d.webp" % (tx, ty)
        shutil.copy("fin_%d_%d.webp" % (tx, ty), OUT_DIR + fn)
        tiles.append({"path": RES_DIR + fn, "px": [tx * TILE_W, ty * TILE_H], "size": [TILE_W, TILE_H]})
final = np.zeros((IMG_H, IMG_W, 3), np.uint8)
for ty in range(NT):
    for tx in range(NT):
        final[ty * TILE_H:(ty + 1) * TILE_H, tx * TILE_W:(tx + 1) * TILE_W] = np.array(Image.open("fin_%d_%d.png" % (tx, ty)).convert("RGB"))
# fond basse définition (1/4) toujours chargé sous les tuiles : jamais de trou pendant un chargement
Image.open("apercu.png").convert("RGB").save(OUT_DIR + "fond_bas.webp", "WEBP", quality=90, method=6)

# ── occultants : découpes (couverture de la passe d'identifiants, 2x plus fine) rangées en atlas
idf = np.zeros((IMG_H * 2, IMG_W * 2), np.int16)
RT_W, RT_H = TILE_W * 2, TILE_H * 2
for ty in range(NT):
    for tx in range(NT):
        a = np.array(Image.open("render/id_%d_%d.png" % (tx, ty)).convert("RGBA")).astype(np.int16)
        m = (a[..., 3] > 0) & (a[..., 0] > 30)
        k = (np.round((a[..., 0] - 56) / 15.0) + 13 * np.round((a[..., 1] - 56) / 15.0) + 169 * np.round((np.maximum(a[..., 2], 56) - 56) / 15.0)).astype(np.int16)
        idf[ty * RT_H:(ty + 1) * RT_H, tx * RT_W:(tx + 1) * RT_W] = np.where(m, k, 0)
        del a, m, k
fin = final
occ = json.load(open("occluders.json"))
cuts = []
# boîtes englobantes de tous les identifiants en un passage
from scipy import ndimage
objs_sl = ndimage.find_objects(idf.astype(np.int32))
for o in occ:
    sl = objs_sl[o["oid"] - 1] if o["oid"] - 1 < len(objs_sl) else None
    if sl is None:
        continue
    sub_ = idf[sl] == o["oid"]
    ys, xs = np.nonzero(sub_)
    ys = ys + sl[0].start; xs = xs + sl[1].start
    if len(xs) < 40:
        continue
    x0, x1 = (xs.min() // 2) - 1, (xs.max() // 2) + 2
    y0, y1 = (ys.min() // 2) - 1, (ys.max() // 2) + 2
    x0, y0 = max(0, x0), max(0, y0)
    sub = (idf[y0 * 2:y1 * 2, x0 * 2:x1 * 2] == o["oid"]).astype(np.float32)
    cov = cv2.resize(sub, (x1 - x0, y1 - y0), interpolation=cv2.INTER_AREA)
    rgba = np.dstack([fin[y0:y1, x0:x1], (np.clip(cov, 0, 1) * 255).astype(np.uint8)])
    cx, cz = o["c"]
    cell = cell_of(cx, cz)
    cuts.append({"img": rgba, "px": [int(x0), int(y0)], "cell": [int(cell[0]), int(cell[1])], "kind": o["kind"]})
# rangement en étagères : une page d'atlas par tuile de fond (chargées avec elles, à la demande)
occl = []
page_paths = []
for ty in range(NT):
    for tx in range(NT):
        group = [c for c in cuts if c["px"][0] // TILE_W == tx and c["px"][1] // TILE_H == ty]
        if not group:
            continue
        group.sort(key=lambda c: -c["img"].shape[0])
        PW = 2048
        sx = sy = row_h = 0
        place = []
        for c in group:
            h, w = c["img"].shape[:2]
            if sx + w > PW:
                sx, sy, row_h = 0, sy + row_h + 2, 0
            place.append((c, sx, sy)); sx += w + 2; row_h = max(row_h, h)
        ph = int(math.ceil((sy + row_h + 2) / 4) * 4)
        pg = np.zeros((ph, PW, 4), np.uint8)
        for c, x_, y_ in place:
            h, w = c["img"].shape[:2]
            pg[y_:y_ + h, x_:x_ + w] = c["img"]
            occl.append({"page": len(page_paths), "r": [x_, y_, w, h], "px": c["px"], "cell": c["cell"], "k": c["kind"]})
        fn = "occ_%d_%d.webp" % (tx, ty)
        Image.fromarray(pg).save(OUT_DIR + fn, "WEBP", quality=92, method=6)
        page_paths.append(RES_DIR + fn)

def enc(v):
    return chr(48 + v) if v < 10 else chr(97 + v - 10)
board = {
    "iso": True, "diorama": True, "cols": N, "rows": N, "unit": UNIT, "cell_scale": CS,
    "start": list(start),
    "mask": ["".join("#" if walk[y, x] else "." for x in range(N)) for y in range(N)],
    "heights": ["".join(enc(int(heights[y, x])) for x in range(N)) for y in range(N)],
    "trail": trail, "buildings": [], "obstacles": {}, "decor": {},
    "pois": pois,
    "image_size": [IMG_W, IMG_H], "image_scale": SCALE, "image_offset": [round(offset[0], 2), round(offset[1], 2)],
    "image_tiles": tiles,
    "image_low": {"path": RES_DIR + "fond_bas.webp", "factor": 4},
    "occluder_pages": page_paths,
    "occluders": occl,
}
json.dump(board, open(REPO + "/data/boards/foret_sylve_diorama.json", "w"), ensure_ascii=False, separators=(",", ":"))
print("échelle", round(SCALE, 4), "maxh", maxh, "jouables", int(walk.sum()), "occultants", len(occl), "pages", len(page_paths), "départ", start)
# aperçu de contrôle : cases jouables + lieux sur l'image
dbg = Image.fromarray(final).resize((1280, 720))
d = np.array(dbg)
for cy in range(N):
    for cx in range(N):
        px, py = img_px((cx + 0.5) * CW, heights[cy, cx] * UNIT_PX / hpx_per_unit, (cy + 0.5) * CW)
        col = (60, 255, 60) if walk[cy, cx] else (255, 40, 40)
        if "%d,%d" % (cx, cy) in pois: col = (255, 255, 0)
        if (cx, cy) == start: col = (0, 200, 255)
        cv2.circle(d, (int(px / 8), int(py / 8)), 2 if col[1] in (255, 40) and col[0] != 255 or col == (255, 40, 40) else 5, col, -1)
Image.fromarray(d).save("board_debug.png")
