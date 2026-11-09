#!/usr/bin/env python3
"""Terrain de la Sylve 96x96, en 2x2 morceaux de 4096 px (bruits continus d'un morceau à l'autre)
-> ground_<i>_<j>.png, height.npy (hauteurs en unités), mask_path.npy, lake.npy"""
import numpy as np, cv2, sys, os
from scipy.ndimage import gaussian_filter
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from plan96 import S, C, OFF, ROADS, FIELDS, MEADOWS, LAKE, WOODS
CH = 2                 # morceaux par côté
T = 4096               # px par morceau
PPU = T * CH / S       # px par unité (85,3 comme le village 48)
M = 96                 # marge de calcul autour d'un morceau
LR = 2048              # bruits basse fréquence : globaux
PPU_LO = LR / S
HR = 4096              # relief
SEEDS = {}

def fbm_lo(scales, weights, seed):
    r = np.random.default_rng(seed)
    out = np.zeros((LR, LR), np.float32)
    for s, w in zip(scales, weights):
        n = r.standard_normal((LR, LR)).astype(np.float32)
        n = gaussian_filter(n, s * 0.024 * PPU_LO, mode="wrap")
        out += w * n / (n.std() + 1e-6)
    return out

def hnoise(gx0, gy0, w, h, seed):
    """bruit blanc déterministe par pixel global (variance 1)"""
    ix = (np.arange(gx0, gx0 + w, dtype=np.int64) & 0xFFFFFFFF).astype(np.uint64)[None, :]
    iy = (np.arange(gy0, gy0 + h, dtype=np.int64) & 0xFFFFFFFF).astype(np.uint64)[:, None]
    v = (ix * np.uint64(0x9E3779B1) ^ iy * np.uint64(0x85EBCA77) ^ np.uint64(seed * 0xC2B2AE3D)) & np.uint64(0xFFFFFFFF)
    v ^= v >> np.uint64(15); v = (v * np.uint64(0x2C1B3C6D)) & np.uint64(0xFFFFFFFF)
    v ^= v >> np.uint64(12); v = (v * np.uint64(0x297A2D39)) & np.uint64(0xFFFFFFFF)
    v ^= v >> np.uint64(15)
    return ((v.astype(np.float64) / 4294967296.0 - 0.5) * 3.4641).astype(np.float32)

LOW = {}
def field(name, scales, weights, seed, gx0, gy0, w, h):
    """fbm continu : composantes larges depuis la grille globale, fines par bruit haché"""
    out = np.zeros((h, w), np.float32)
    for k, (s, wt) in enumerate(zip(scales, weights)):
        sig_w = s * 0.024
        if sig_w >= 0.3:
            key = (name, k)
            if key not in LOW:
                LOW[key] = fbm_lo([s], [1.0], seed * 31 + k)
            lo = LOW[key]
            xs = (np.arange(gx0, gx0 + w, dtype=np.float32) + 0.5) / PPU * PPU_LO - 0.5
            ys = (np.arange(gy0, gy0 + h, dtype=np.float32) + 0.5) / PPU * PPU_LO - 0.5
            mx, my = np.meshgrid(xs, ys)
            out += wt * cv2.remap(lo, mx, my, cv2.INTER_CUBIC, borderMode=cv2.BORDER_WRAP)
        else:
            sp = sig_w * PPU
            mg = int(4 * sp) + 2
            n = hnoise(gx0 - mg, gy0 - mg, w + 2 * mg, h + 2 * mg, seed * 131 + k)
            n = cv2.GaussianBlur(n, (0, 0), sp)[mg:mg + h, mg:mg + w]
            out += wt * n * (2 * np.sqrt(np.pi) * sp)
    return out

def bez(pts, n=500):
    pts = np.array(pts, float); out = []
    for t in np.linspace(0, 1, n):
        p = pts.copy()
        while len(p) > 1: p = p[:-1] * (1 - t) + p[1:] * t
        out.append(p[0])
    return np.array(out)
PATHS = [bez(p) for p, a, b in ROADS]

def lerp(a, b, t):
    a = np.asarray(a, np.float32); b = np.asarray(b, np.float32)
    return np.ascontiguousarray(a + (b - a) * t[..., None], dtype=np.float32)

def path_mask(gx0, gy0, w, h, ppu):
    m = np.zeros((h, w), np.uint8)
    for pp, (q, a, b) in zip(PATHS, ROADS):
        for i in range(len(pp) - 1):
            t = i / len(pp)
            wd = max(1, int((a + (b - a) * t) * ppu))
            p0 = (int(pp[i][0] * ppu - gx0), int(pp[i][1] * ppu - gy0)); p1 = (int(pp[i + 1][0] * ppu - gx0), int(pp[i + 1][1] * ppu - gy0))
            cv2.line(m, p0, p1, 255, wd, cv2.LINE_AA)
    return m.astype(np.float32) / 255.0

def lake_sdf(wx, wz):
    lx, lz, ra, rb, ang = LAKE
    a = np.radians(ang); u = (wx - lx) * np.cos(a) + (wz - lz) * np.sin(a); v = -(wx - lx) * np.sin(a) + (wz - lz) * np.cos(a)
    return (np.sqrt((u / ra) ** 2 + (v / rb) ** 2) - 1.0) * min(ra, rb)    # <0 dans le lac (≈ unités)

def chunk(ci, cj):
    gx0, gy0 = ci * T - M, cj * T - M
    w = h = T + 2 * M
    yy, xx = np.mgrid[0:h, 0:w].astype(np.float32)
    wx, wz = (xx + gx0 + 0.5) / PPU, (yy + gy0 + 0.5) / PPU
    warp = field("warp", [14, 40], [0.6, 0.4], 3, gx0, gy0, w, h)
    mp = path_mask(gx0, gy0, w, h, PPU)
    d_pl = np.hypot(wx - C, wz - C)
    plaza = np.clip((5.3 + 0.18 * warp - d_pl) * 5.0, 0, 1)
    mp = np.maximum(mp, plaza)
    edge_noise = field("edge", [5, 14], [0.7, 0.3], 8, gx0, gy0, w, h)
    mp = np.clip((mp - 0.5 + 0.12 * edge_noise) * 8.0 + 0.5, 0, 1)
    mp = cv2.GaussianBlur(mp, (0, 0), 1.3)
    # herbe : plus sèche et dorée dans les plaines sauvages, plus verte au village
    wild = np.clip((np.maximum(np.abs(wx - C), np.abs(wz - C)) - 22.0) / 8.0, 0, 1)
    base_lo = np.array([0.215, 0.440, 0.150], np.float32); base_hi = np.array([0.420, 0.640, 0.200], np.float32)
    large = field("large", [180, 60], [0.65, 0.35], 11, gx0, gy0, w, h)
    mid = field("mid", [22, 8], [0.6, 0.4], 12, gx0, gy0, w, h)
    t = np.clip(0.5 + 0.22 * large + 0.12 * mid, 0, 1)
    grass = lerp(np.broadcast_to(base_lo, (h, w, 3)), np.broadcast_to(base_hi, (h, w, 3)), t)
    warm = np.clip(field("warm", [130], [1.0], 14, gx0, gy0, w, h) - 0.6 + 0.35 * wild, 0, 1)
    grass = grass + warm[..., None] * np.array([0.10, 0.045, -0.04], np.float32) * 1.6
    cool = np.clip(field("cool", [150], [1.0], 15, gx0, gy0, w, h) - 0.7, 0, 1)
    grass = grass + cool[..., None] * np.array([-0.04, 0.01, 0.05], np.float32) * 1.6
    img = (np.clip(grass, 0, 1) * 255).astype(np.uint8)
    layer = img.copy()
    rs = np.random.default_rng(1000 + ci * 7 + cj)
    N = int(640000 * (w * h) / (T * T))
    px = rs.uniform(0, w, N); py = rs.uniform(0, h, N)
    an = rs.normal(-np.pi / 2, 0.45, N); ln = rs.uniform(5, 15, N) * 0.5
    tone = rs.random(N)
    for i in range(N):
        x0, y0 = px[i], py[i]
        x1, y1 = x0 + np.cos(an[i]) * ln[i], y0 + np.sin(an[i]) * ln[i]
        if tone[i] < 0.5:
            c = (int(30 + 20 * tone[i]), int(95 + 50 * tone[i]), int(28 + 14 * tone[i]))
        else:
            c = (int(55 + 35 * tone[i]), int(150 + 70 * (tone[i] - 0.5)), int(85 + 60 * (tone[i] - 0.5)))
        cv2.line(layer, (int(x0), int(y0)), (int(x1), int(y1)), c, 1, cv2.LINE_AA)
    grass_img = cv2.addWeighted(img, 0.66, layer, 0.34, 0).astype(np.float32) / 255.0
    del img, layer, grass
    soil_a = np.array([0.560, 0.430, 0.285], np.float32); soil_b = np.array([0.700, 0.570, 0.390], np.float32)
    sn = np.clip(0.5 + 0.2 * field("sn", [20, 6], [0.6, 0.4], 21, gx0, gy0, w, h), 0, 1)
    soil = lerp(np.broadcast_to(soil_a, (h, w, 3)), np.broadcast_to(soil_b, (h, w, 3)), sn)
    for k in range(int(360000 * (w * h) / (T * T))):
        x, y = int(rs.uniform(0, w)), int(rs.uniform(0, h))
        v = rs.uniform(0.55, 0.9)
        cv2.circle(soil, (x, y), 1, (v * 0.95, v * 0.88, v * 0.74), -1, cv2.LINE_AA)
    mask_st = cv2.GaussianBlur(np.clip((plaza - 0.35) * 4.0, 0, 1), (0, 0), 6.0)
    plaza_col = np.array([0.52, 0.47, 0.40], np.float32) * (0.92 + 0.08 * sn[..., None])
    ground = lerp(soil, plaza_col, mask_st)
    rim = np.clip((cv2.GaussianBlur(mp, (0, 0), 9) - mp) * 2.0, 0, 1)
    out = lerp(grass_img, ground, mp)
    out = out * (1 - 0.22 * rim[..., None])
    del ground, soil, grass_img
    # sous-bois : terre plus sombre et mousse sous les bois
    wood_m = np.zeros((h, w), np.float32)
    for bx, bz, br in WOODS:
        wood_m = np.maximum(wood_m, np.clip((br + 1.0 + 0.8 * warp - np.hypot(wx - bx, wz - bz)) / 2.5, 0, 1))
    moss = out * np.array([0.72, 0.80, 0.70], np.float32)
    out = lerp(out, moss, wood_m * 0.6)
    # lac : berge de sable puis vase
    sd = lake_sdf(wx, wz) + 0.25 * warp
    sand = np.clip(1 - np.abs(sd - 0.2) / 1.1, 0, 1)
    sand_col = np.array([0.80, 0.72, 0.52], np.float32) * (0.9 + 0.1 * sn[..., None])
    out = lerp(out, sand_col, sand * 0.85)
    mud = np.clip(-sd / 0.8, 0, 1)
    out = lerp(out, np.array([0.30, 0.30, 0.22], np.float32), mud)
    fine = field("fine", [6, 2], [0.6, 0.4], 77, gx0, gy0, w, h)
    def zone(cx, cz, zw, zh, ang, soft):
        a = np.radians(ang); ca, sa = np.cos(a), np.sin(a)
        u = (wx - cx) * ca + (wz - cz) * sa
        v = -(wx - cx) * sa + (wz - cz) * ca
        n = 0.18 * edge_noise
        m = np.clip((zw / 2 - np.abs(u) + n) / soft, 0, 1) * np.clip((zh / 2 - np.abs(v) + n) / soft, 0, 1)
        return m.astype(np.float32), u.astype(np.float32), v.astype(np.float32)
    for kind, cx, cz, zw, zh, ang in MEADOWS:
        if abs(cx - (gx0 + w / 2) / PPU) > (w / 2 / PPU + zw) or abs(cz - (gy0 + h / 2) / PPU) > (h / 2 / PPU + zh): continue
        m, u, v = zone(cx, cz, zw, zh, ang, 1.4)
        mead = out * np.array([1.08, 1.04, 0.78], np.float32) + np.array([0.035, 0.03, 0.0], np.float32)
        out = lerp(out, mead, m * 0.75)
    for kind, cx, cz, zw, zh, ang in FIELDS:
        if abs(cx - (gx0 + w / 2) / PPU) > (w / 2 / PPU + zw) or abs(cz - (gy0 + h / 2) / PPU) > (h / 2 / PPU + zh): continue
        m, u, v = zone(cx, cz, zw, zh, ang, 0.22)
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
    out = np.clip(out[M:M + T, M:M + T], 0, 1)
    cv2.imwrite("ground_%d_%d.png" % (ci, cj), cv2.cvtColor((out * 255).astype(np.uint8), cv2.COLOR_RGB2BGR))
    print("morceau", ci, cj, flush=True)

if __name__ == "__main__":
    which = sys.argv[1] if len(sys.argv) > 1 else "all"
    if which in ("all", "relief"):
        # ── relief (unités) : village doux, plaines vallonnées, lac creusé, bord du monde en dôme
        r = np.random.default_rng(40)
        def fh(scales, weights):
            o = np.zeros((HR, HR), np.float32)
            for s, wt in zip(scales, weights):
                n = gaussian_filter(r.standard_normal((HR, HR)).astype(np.float32), s * 0.024 * HR / 48.0, mode="wrap")
                o += wt * n / n.std()
            return o
        hh = fh([120, 50, 18], [0.6, 0.3, 0.1])
        hh = (hh - hh.min()) / (hh.max() - hh.min())
        hills = fh([260], [1.0]); hills = (hills - hills.min()) / (hills.max() - hills.min())
        y2, x2 = (np.mgrid[0:HR, 0:HR].astype(np.float32) + 0.5) / HR * S
        cheb = np.maximum(np.abs(x2 - C), np.abs(y2 - C))
        wild = np.clip((cheb - 21.0) / 9.0, 0, 1)
        H = hh * (0.75 + 0.55 * wild) + hills * 1.3 * wild
        mp = path_mask(0, 0, HR, HR, HR / S)
        pl = np.clip((5.3 - np.hypot(x2 - C, y2 - C)) * 5.0, 0, 1)
        flat = cv2.GaussianBlur(np.clip(mp * 0.85 + pl, 0, 1), (0, 0), 6)
        Hs = cv2.GaussianBlur(H, (0, 0), 40)
        H = H * (1 - flat) + Hs * flat
        H = H * np.clip((S / 2 - cheb) / 4.0 + 0.4, 0.2, 1)
        sd = lake_sdf(x2, y2)
        lx, lz = LAKE[0], LAKE[1]
        WL = float(Hs[int(lz / S * HR), int(lx / S * HR)]) - 0.05
        bowl = np.clip(-sd / 3.0, 0, 1)
        shore = np.clip(1 - np.abs(sd) / 2.5, 0, 1)
        H = np.where(sd < 0, np.minimum(H, WL - 0.12 - 0.5 * bowl), H)
        H = H * (1 - shore * 0.6) + (WL + 0.08 + np.clip(sd, 0, None) * 0.25) * shore * 0.6
        np.save("height.npy", H.astype(np.float32))
        np.save("mask_path.npy", cv2.resize(mp, (2048, 2048), interpolation=cv2.INTER_AREA))
        np.save("lake.npy", np.array([WL]))
        print("relief", float(H.min()), float(H.max()), "eau", WL, flush=True)
    if which in ("all", "sol"):
        for cj in range(CH):
            for ci in range(CH):
                chunk(ci, cj)
