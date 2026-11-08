#!/usr/bin/env python3
"""Terrain de la Sylve : texture d'herbe/chemin/pavés peinte en haute résolution + carte de relief."""
import numpy as np, cv2, sys
from scipy.ndimage import gaussian_filter, distance_transform_edt
from scipy.spatial import cKDTree
S = 48.0
T = 4096
C = 24.0   # centre (place)
HR = 2048  # résolution du relief
rng = np.random.default_rng(42)
PPU = T / S

def fbm(res, scales, weights, seed):
    r = np.random.default_rng(seed)
    out = np.zeros((res, res), np.float32)
    for s, w in zip(scales, weights):
        n = r.standard_normal((res, res)).astype(np.float32)
        n = gaussian_filter(n, s * 0.024 * res / S, mode="wrap")
        n /= (n.std() + 1e-6)
        out += w * n
    return out

def lerp(a, b, t):
    a = np.asarray(a, np.float32); b = np.asarray(b, np.float32)
    return np.ascontiguousarray(a + (b - a) * t[..., None], dtype=np.float32)

# ── Chemin : courbe lissée de la plaza (12,12) vers le bord sud-est et nord-ouest
def bez(pts, n=400):
    pts = np.array(pts, float)
    out = []
    for t in np.linspace(0, 1, n):
        p = pts.copy()
        while len(p) > 1:
            p = p[:-1] * (1 - t) + p[1:] * t
        out.append(p[0])
    return np.array(out)
import sys; sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from plan_v2 import ROADS, FIELDS, MEADOWS, ORCHARD
PATHS = [bez(p) for p, a, b in ROADS]
R = T
yy, xx = np.mgrid[0:R, 0:R].astype(np.float32)
wx, wz = xx / PPU, yy / PPU          # coordonnées monde

def dist_to_polyline(poly, width_fn):
    m = np.zeros((R, R), np.uint8)
    for i in range(len(poly) - 1):
        p0 = (int(poly[i][0] * PPU), int(poly[i][1] * PPU)); p1 = (int(poly[i + 1][0] * PPU), int(poly[i + 1][1] * PPU))
        w = int(width_fn(i / len(poly)) * PPU)
        cv2.line(m, p0, p1, 255, w, cv2.LINE_AA)
    return m.astype(np.float32) / 255.0

warp = fbm(R, [14, 40], [0.6, 0.4], 3)
mask_path = np.maximum.reduce([dist_to_polyline(pp, (lambda a, b: (lambda t: a + (b - a) * t))(a, b)) for pp, (q, a, b) in zip(PATHS, ROADS)])
# plaza
d_pl = np.hypot(wx - C, wz - C)
plaza = np.clip((5.3 + 0.18 * warp - d_pl) * 5.0, 0, 1)
mask_stone = np.clip(np.maximum(plaza, 0), 0, 1)
mask_path = np.maximum(mask_path, plaza)
# bords irréguliers du chemin
edge_noise = fbm(R, [5, 14], [0.7, 0.3], 8)
mp = np.clip((mask_path - 0.5 + 0.12 * edge_noise) * 8.0 + 0.5, 0, 1)
mp = cv2.GaussianBlur(mp, (0, 0), 1.3)

# ── Herbe : base bruitée + patchs + brins
base_lo = np.array([0.215, 0.440, 0.150]); base_hi = np.array([0.420, 0.640, 0.200])
large = fbm(R, [180, 60], [0.65, 0.35], 11)
mid = fbm(R, [22, 8], [0.6, 0.4], 12)
t = np.clip(0.5 + 0.22 * large + 0.12 * mid, 0, 1)
grass = lerp(np.broadcast_to(base_lo, (R, R, 3)), np.broadcast_to(base_hi, (R, R, 3)), t)
# taches chaudes (herbe sèche) et froides
warm = np.clip(fbm(R, [130], [1.0], 14) - 0.6, 0, 1)
grass = grass + warm[..., None] * np.array([0.10, 0.045, -0.04]) * 1.6
cool = np.clip(fbm(R, [150], [1.0], 15) - 0.7, 0, 1)
grass = grass + cool[..., None] * np.array([-0.04, 0.01, 0.05]) * 1.6
# brins d'herbe : petits traits clairs/foncés orientés vers le haut
img = (np.clip(grass, 0, 1) * 255).astype(np.uint8)
layer = img.copy()
rs = np.random.default_rng(5)
N = 640000
LS = 0.5
px = rs.uniform(0, R, N); py = rs.uniform(0, R, N)
ang = rs.normal(-np.pi / 2, 0.45, N); ln = rs.uniform(5, 15, N) * LS
tone = rs.random(N)
for i in range(N):
    x0, y0 = px[i], py[i]
    x1, y1 = x0 + np.cos(ang[i]) * ln[i], y0 + np.sin(ang[i]) * ln[i]
    if tone[i] < 0.5:
        c = (int(30 + 20 * tone[i]), int(95 + 50 * tone[i]), int(28 + 14 * tone[i]))      # BGR foncé
    else:
        c = (int(55 + 35 * tone[i]), int(150 + 70 * (tone[i] - 0.5)), int(85 + 60 * (tone[i] - 0.5)))  # clair
    cv2.line(layer, (int(x0), int(y0)), (int(x1), int(y1)), c[::-1][::-1], 1, cv2.LINE_AA)
# (cv2 est BGR : on travaille en RGB donc on inverse proprement)
layer = layer
grass_img = cv2.addWeighted(img, 0.66, layer, 0.34, 0).astype(np.float32) / 255.0

# ── Chemin de terre + pavés de la plaza
soil_a = np.array([0.560, 0.430, 0.285]); soil_b = np.array([0.700, 0.570, 0.390])
sn = np.clip(0.5 + 0.2 * fbm(R, [20, 6], [0.6, 0.4], 21), 0, 1)
soil = lerp(np.broadcast_to(soil_a, (R, R, 3)), np.broadcast_to(soil_b, (R, R, 3)), sn)
# graviers
for k in range(360000):
    x, y = int(rs.uniform(0, R)), int(rs.uniform(0, R))
    v = rs.uniform(0.55, 0.9)
    cv2.circle(soil, (x, y), 1, (v * 0.95, v * 0.88, v * 0.74), -1, cv2.LINE_AA)
# plaza : terre battue plus claire et grise sous les pavés 3D
mask_st = cv2.GaussianBlur(np.clip((plaza - 0.35) * 4.0, 0, 1), (0, 0), 6.0)
plaza_col = np.array([0.52, 0.47, 0.40]) * (0.92 + 0.08 * sn[..., None])
ground = lerp(soil.astype(np.float32), np.broadcast_to(plaza_col, soil.shape).astype(np.float32), mask_st)

# ── Composition herbe / sol
# lisière : petite bande plus sombre/humide + herbes qui débordent
rim = cv2.GaussianBlur(mp, (0, 0), 9) - mp
rim = np.clip(rim * 2.0, 0, 1)
out = lerp(grass_img, ground, mp)
out = out * (1 - 0.22 * rim[..., None])
out = np.clip(out, 0, 1)

# ── champs et prairies (peints dans la texture)
def zone(cx, cz, w, h, ang, soft=0.25):
    a = np.radians(ang); ca, sa = np.cos(a), np.sin(a)
    u = (wx - cx) * ca + (wz - cz) * sa
    v = -(wx - cx) * sa + (wz - cz) * ca
    n = 0.18 * edge_noise
    m = np.clip((w / 2 - np.abs(u) + n) / soft, 0, 1) * np.clip((h / 2 - np.abs(v) + n) / soft, 0, 1)
    return m.astype(np.float32), u.astype(np.float32), v.astype(np.float32)
fine = fbm(R, [6, 2], [0.6, 0.4], 77)
for kind, cx, cz, w, h, ang in MEADOWS:
    m, u, v = zone(cx, cz, w, h, ang, 1.4)
    mead = out * np.array([1.08, 1.04, 0.78], np.float32) + np.array([0.035, 0.03, 0.0], np.float32)
    out = lerp(out, mead, m * 0.75)
for kind, cx, cz, w, h, ang in FIELDS:
    m, u, v = zone(cx, cz, w, h, ang, 0.22)
    if kind == "ble":
        rows = 0.5 + 0.5 * np.cos(2 * np.pi * v / 0.42)
        dark = np.array([0.60, 0.46, 0.20], np.float32); light = np.array([0.88, 0.74, 0.37], np.float32)
        col = lerp(np.broadcast_to(dark, out.shape), np.broadcast_to(light, out.shape), np.clip(rows * 0.7 + 0.15 * fine + 0.15, 0, 1))
    else:
        sp = 0.36 if kind == "labour" else 0.6
        rows = 0.5 + 0.5 * np.cos(2 * np.pi * v / sp)
        dark = np.array([0.27, 0.19, 0.12], np.float32); light = np.array([0.50, 0.37, 0.24], np.float32)
        col = lerp(np.broadcast_to(dark, out.shape), np.broadcast_to(light, out.shape), np.clip(rows * 0.75 + 0.12 * fine + 0.1, 0, 1))
    rimf = np.clip(cv2.GaussianBlur(m, (0, 0), 0.25 * PPU) - m, 0, 1)
    out = lerp(out, col, m)
    out = out * (1 - 0.35 * rimf[..., None])
out = np.clip(out, 0, 1)
g8 = (out * 255).astype(np.uint8)
cv2.imwrite("ground4k.png", cv2.cvtColor(g8, cv2.COLOR_RGB2BGR))
del out, g8, grass_img, soil, ground, layer, img

# ── Relief (0..1), aplati sur le chemin et la plaza
h = fbm(HR, [120, 50, 18], [0.6, 0.3, 0.1], 40)
h = (h - h.min()) / (h.max() - h.min())
mp_s = cv2.resize(mp, (HR, HR), interpolation=cv2.INTER_AREA)
pl_s = cv2.resize(plaza, (HR, HR), interpolation=cv2.INTER_AREA)
flat = np.clip(mp_s * 0.8 + pl_s, 0, 1)
h = h * (1 - flat) + 0.45 * flat
# bords en dôme doux
y2, x2 = np.mgrid[0:HR, 0:HR].astype(np.float32) / HR * S
cheb = np.maximum(np.abs(x2 - C), np.abs(y2 - C))
h *= np.clip((C - cheb) / 3.0 + 0.4, 0.15, 1)
cv2.imwrite("height.png", (np.clip(h, 0, 1) * 65535).astype(np.uint16))
np.save("mask_path.npy", cv2.resize(mp, (HR, HR), interpolation=cv2.INTER_AREA))
print("ok")
