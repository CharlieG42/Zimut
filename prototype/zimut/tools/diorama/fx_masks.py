#!/usr/bin/env python3
"""V127 — Masques d'effets animés du diorama (eau, lave / lumières, terre ferme).

Lit le rendu fini (fin_<tx>_<ty>.png), la passe d'identifiants (render/id_*.png), l'alpha de scène
(p1_*.npy), le relief (height2.npy) et objects.json ; écrit <assets>/fx.png (1/8 de l'image) :
  R = eau visible (0,35 au bord → 1 au large)      G = lave et lumières (pixels chauds)
  B = terre ferme (île, hors ciel)                  A = 255
Le jeu anime ces zones avec un shader (scripts/DioramaFx.gd), sans retoucher les tuiles.
Met aussi à jour la clé "image_fx" du JSON de la planche (à lancer après bake96.py).
Usage : DIORAMA_PLAN=plan96 python3 fx_masks.py [repo]
"""
import json, os, sys, importlib, numpy as np, cv2
from PIL import Image
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
W = importlib.import_module(os.environ.get("DIORAMA_PLAN", "plan96"))
Image.MAX_IMAGE_PIXELS = None
REPO = sys.argv[1] if len(sys.argv) > 1 else "/home/claude/zimut/prototype/zimut"
OUT = REPO + "/assets/boards/%s/fx.png" % W.ASSET_DIR
S, NT, TILE_W, TILE_H, F = 96.0, 4, 2560, 1440, 8
IMG_W, IMG_H = TILE_W * NT, TILE_H * NT
K = IMG_H / 99.2
CAM = (48.0, 1.6, 48.0)
MW, MH = IMG_W // F, IMG_H // F
tw, th = TILE_W // F, TILE_H // F
HOT_EVERYWHERE = bool(getattr(W, "VOLCANO", None) or getattr(W, "LAVA", None))

objs = json.load(open("objects.json"))
H = np.load("height2.npy")
hr = H.shape[0]

def img_px(wx, h, wz):
    dx, dh, dz = wx - CAM[0], h - CAM[1], wz - CAM[2]
    return (IMG_W / 2 + 0.70710678 * K * (dx - dz), IMG_H / 2 + K * (0.35355339 * (dx + dz) - 0.8660254 * dh))

# coordonnées image (pleine résolution) du centre de chaque pixel du masque
py, px = np.mgrid[0:MH, 0:MW].astype(np.float32)
px = (px + 0.5) * F; py = (py + 0.5) * F
rgb = np.zeros((MH, MW, 3), np.float32)
occ = np.zeros((MH, MW), np.float32)
land = np.zeros((MH, MW), np.float32)
for ty in range(NT):
    for tx in range(NT):
        sl = (slice(ty * th, (ty + 1) * th), slice(tx * tw, (tx + 1) * tw))
        fin = np.asarray(Image.open("fin_%d_%d.png" % (tx, ty)).convert("RGB"), np.float32) / 255.0
        rgb[sl] = cv2.resize(fin, (tw, th), interpolation=cv2.INTER_AREA)
        idp = np.asarray(Image.open("render/id_%d_%d.png" % (tx, ty)).convert("RGB"))
        occ[sl] = cv2.resize((idp.max(axis=2) > 8).astype(np.float32), (tw, th), interpolation=cv2.INTER_AREA)
        land[sl] = cv2.resize(np.load("p1_%d_%d.npy" % (tx, ty))[..., 3].astype(np.float32), (tw, th), interpolation=cv2.INTER_AREA)
        del fin, idp

# ── eau : pixels dont le point du plan d'eau est sous l'eau (relief < niveau), non masqués par un objet haut
water = np.zeros((MH, MW), np.float32)
for o in objs:
    if o["type"] != "water":
        continue
    wl = float(o["y"])
    u = (px - IMG_W / 2) / (0.70710678 * K)                                   # dx - dz
    v = (py - IMG_H / 2 + 0.8660254 * K * (wl - CAM[1])) / (0.35355339 * K)     # dx + dz
    wx = CAM[0] + (u + v) / 2; wz = CAM[2] + (v - u) / 2
    inside = (wx > 0) & (wx < S) & (wz > 0) & (wz < S)
    hi = np.clip((wz / S * hr).astype(int), 0, hr - 1); hj = np.clip((wx / S * hr).astype(int), 0, hr - 1)
    depth = wl - H[hi, hj]
    c, r = o["c"], o["r"]
    a = np.radians(float(o["ang"]))
    eu = (wx - c[0]) * np.cos(a) + (wz - c[1]) * np.sin(a); ev = -(wx - c[0]) * np.sin(a) + (wz - c[1]) * np.cos(a)
    disc = (eu / r[0]) ** 2 + (ev / r[1]) ** 2 < 1.0
    m = inside & disc & (depth > 0.02)
    water = np.maximum(water, np.where(m, 0.35 + 0.65 * np.clip(depth / 0.45, 0, 1), 0.0))
water *= np.clip(1.0 - occ * 1.6, 0, 1)
water = cv2.GaussianBlur(water, (0, 0), 0.8)

# ── pixels chauds : lave (couleur) ; ailleurs, seulement autour des lumières posées (lanternes, cristaux)
R, G, B = rgb[..., 0], rgb[..., 1], rgb[..., 2]
hotc = np.clip((R - 0.86) * 9, 0, 1) * np.clip((G - 0.50) * 6, 0, 1) * np.clip((R - B - 0.38) * 6, 0, 1)
if not HOT_EVERYWHERE:
    near = np.zeros((MH, MW), np.float32)
    for o in objs:
        if o["type"] == "light":
            p = o.get("p", o.get("c"))
            x, y = img_px(float(p[0]), float(p[1]) if len(p) > 2 else 0.0, float(p[-1]))
            cv2.circle(near, (int(x / F), int(y / F)), 5, 1.0, -1)
    lum = np.clip((rgb.max(axis=2) - 0.80) * 6, 0, 1)
    hotc = lum * cv2.GaussianBlur(near, (0, 0), 1.5)
hot = cv2.GaussianBlur(hotc * np.clip(land * 4, 0, 1), (0, 0), 1.0)
hot = np.clip(hot * 1.4, 0, 1)

out = np.dstack([water, hot, np.clip(land, 0, 1), np.ones_like(land)])
Image.fromarray((np.clip(out, 0, 1) * 255 + 0.5).astype(np.uint8), "RGBA").save(OUT, optimize=True)
# zone utile du calque « sol » (eau + lave), en pixels du masque : le jeu ne dessine que ce rectangle
ys, xs = np.nonzero(np.maximum(water, hot) > 0.03)
rect = [int(xs.min()) - 2, int(ys.min()) - 2, int(xs.max() - xs.min()) + 5, int(ys.max() - ys.min()) + 5] if len(xs) else [0, 0, 0, 0]
jp = REPO + "/data/boards/%s.json" % W.BOARD_STEM
if os.path.exists(jp):
    d = json.load(open(jp))
    d["image_fx"] = {"path": "res://assets/boards/%s/fx.png" % W.ASSET_DIR, "factor": F, "ground_rect": rect}
    json.dump(d, open(jp, "w"), ensure_ascii=False, separators=(",", ":"))
print("zone sol", rect)
print("fx.png", MW, MH, "eau %.2f %%" % (100 * (water > 0.1).mean()), "chaud %.2f %%" % (100 * (hot > 0.1).mean()), "terre %.1f %%" % (100 * (land > 0.5).mean()), os.path.getsize(OUT) // 1024, "Ko")
