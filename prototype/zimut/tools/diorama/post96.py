"""Finition B (HD-2D, sans flou de bord) de la Sylve 96x96 rendue en NTxNT tuiles de 5120x2880.
Phase 1 : chaque tuile (avec une marge prise chez ses voisines) -> image étalonnée réduite 2x (2560x1440).
Phase 2 : halo, ombre portée, fond, vignette calculés sur une vue globale réduite, puis tuiles finales WebP.
Sortie : fin_<tx>_<ty>.webp (2560x1440) + apercu.png"""
import sys, os, numpy as np, cv2
from functools import lru_cache
from PIL import Image
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import post_lib as P
Image.MAX_IMAGE_PIXELS = None
cv2.setNumThreads(2)
L = os.environ.get("DIORAMA_WORK", os.getcwd()) + "/"
R = L + "render/"
NT = int(sys.argv[1]) if len(sys.argv) > 1 else 4
DMAX = 220.0
TW, TH = 5120, 2880
OW, OH = TW // 2, TH // 2
Wf, Hf = TW * NT, TH * NT
BR = os.environ.get("DIORAMA_MOOD") == "brasier"
MOOD = dict(sat=(0.88, 0.96, -5, 1.02), tone=(0.22, (1.08, 1.0, 0.88), (0.03, 0.035, 0.09)), fog=(0.80, 0.84, 0.95),
            bloom_thr=(0.86, 0.78), bloom_k=(0.45, 0.5, 0.35), top=(0.13, 0.15, 0.27), bot=(0.38, 0.27, 0.30))
if BR:   # Brasier : ombres pourpres, lumières orangées, brume de cendre chaude, la lave rayonne
    MOOD.update(sat=(1.0, 1.0, 0, 1.05), tone=(0.24, (1.10, 0.98, 0.86), (0.06, 0.02, 0.05)), fog=(0.78, 0.62, 0.55),
                bloom_thr=(0.70, 0.55), bloom_k=(0.8, 0.9, 0.6), top=(0.12, 0.06, 0.09), bot=(0.36, 0.14, 0.10))
M = 200

@lru_cache(maxsize=12)
def tile(mode, tx, ty):
    if not (0 <= tx < NT and 0 <= ty < NT):
        return None
    return np.array(Image.open(R + f"{mode}_{tx}_{ty}.png").convert("RGBA"))

def region(mode, x0, y0, x1, y1):
    out = np.zeros((y1 - y0, x1 - x0, 4), np.uint8)
    for ty in range(max(0, y0 // TH), min(NT, (y1 - 1) // TH + 1)):
        for tx in range(max(0, x0 // TW), min(NT, (x1 - 1) // TW + 1)):
            t = tile(mode, tx, ty)
            ax0, ay0 = max(x0, tx * TW), max(y0, ty * TH)
            ax1, ay1 = min(x1, (tx + 1) * TW), min(y1, (ty + 1) * TH)
            out[ay0 - y0:ay1 - y0, ax0 - x0:ax1 - x0] = t[ay0 - ty * TH:ay1 - ty * TH, ax0 - tx * TW:ax1 - tx * TW]
    return out

if "phase2" not in sys.argv:
    for ty in range(NT):
        for tx in range(NT):
            x0, y0 = tx * TW - M, ty * TH - M
            x1, y1 = x0 + TW + 2 * M, y0 + TH + 2 * M
            b = region("beauty", x0, y0, x1, y1).astype(np.float32) / 255
            d = region("depth", x0, y0, x1, y1).astype(np.float32)
            n = region("normal", x0, y0, x1, y1).astype(np.float32) / 255
            a = b[..., 3]
            D = (d[..., 0] + d[..., 1] / 255.0) / 255.0 * DMAX
            N = n[..., :3] * 2 - 1
            N /= np.maximum(np.linalg.norm(N, axis=2, keepdims=True), 1e-4)
            P.CLS = d[..., 2] / 255.0
            del d, n
            img, ao = P.base_grade(b[..., :3], a, D, N, 0.66)
            img = P.hsv_grade(img, *MOOD["sat"])
            ed, en = P.edges(D, N, a)
            img = P.draw_lines(img, np.maximum(ed, en * 0.5), 2, 0.38, dark=0.55)
            img = P.tone(img, *MOOD["tone"])
            ys = (np.arange(y0, y1, dtype=np.float32) / Hf)[:, None, None]
            depth_n = np.clip((D - 95) / 110.0, 0, 1)[..., None]
            fog = np.clip(0.30 * np.clip(1 - ys, 0, 1) ** 2.8 + 0.12 * depth_n, 0, 0.28) * 0.6
            img = img * (1 - fog) + np.array(MOOD["fog"], np.float32) * fog
            img = img[M:M + TH, M:M + TW]
            a = a[M:M + TH, M:M + TW]
            small = cv2.resize(img, (OW, OH), interpolation=cv2.INTER_AREA)
            sa = cv2.resize(a, (OW, OH), interpolation=cv2.INTER_AREA)
            np.save(L + f"p1_{tx}_{ty}.npy", np.dstack([small, sa]).astype(np.float16))
            print("phase 1", tx, ty, flush=True)
    tile.cache_clear()

# ── phase 2
Q = 4
qw, qh = OW // Q, OH // Q
glob = np.zeros((qh * NT, qw * NT, 4), np.float32)
for ty in range(NT):
    for tx in range(NT):
        t = np.load(L + f"p1_{tx}_{ty}.npy").astype(np.float32)
        glob[ty * qh:(ty + 1) * qh, tx * qw:(tx + 1) * qw] = cv2.resize(t, (qw, qh), interpolation=cv2.INTER_AREA)
gi, ga = glob[..., :3], glob[..., 3]
lum = (gi * np.array([0.3, 0.59, 0.11], np.float32)).sum(2)
bright = np.clip(gi - MOOD["bloom_thr"][0], 0, 1) * np.clip((lum[..., None] - MOOD["bloom_thr"][1]) * 3, 0, 1)
k = 0.5 / Q            # rayons (pixels de la vue globale réduite)
bk = MOOD["bloom_k"]
bloom = P.blur(bright, max(0.8, 18 * k)) * bk[0] + P.blur(bright, 70 * k) * bk[1] + P.blur(bright, 180 * k) * bk[2]
GW, GH = OW * NT, OH * NT
sh = P.blur(ga, GW * 0.012 / Q)
sh = cv2.warpAffine(sh, np.float32([[1, 0, 0], [0, 1, 0.035 * GH / Q]]), (sh.shape[1], sh.shape[0])) * 0.55
rng = np.random.default_rng(1)
prev = np.zeros((qh * NT, qw * NT, 3), np.uint8)
for ty in range(NT):
    for tx in range(NT):
        t = np.load(L + f"p1_{tx}_{ty}.npy").astype(np.float32)
        img, a = t[..., :3], t[..., 3]
        # morceaux globaux (avec 1 px de bord) remis à l'échelle de la tuile
        def up(gl):
            x0, y0 = tx * qw, ty * qh
            pad = cv2.copyMakeBorder(gl, 1, 1, 1, 1, cv2.BORDER_REPLICATE)
            sub = pad[y0:y0 + qh + 2, x0:x0 + qw + 2]
            mx = (np.arange(OW, dtype=np.float32) + 0.5) / Q - 0.5 + 1
            my = (np.arange(OH, dtype=np.float32) + 0.5) / Q - 0.5 + 1
            gx, gy_ = np.meshgrid(mx, my)
            return cv2.remap(sub, gx, gy_, cv2.INTER_LINEAR)
        img = img + up(bloom) * np.array([1.0, 0.9, 0.72], np.float32)
        s = up(sh)
        yy = (np.arange(ty * OH, (ty + 1) * OH, dtype=np.float32) / GH)[:, None, None]
        top = np.array(MOOD["top"], np.float32); bot = np.array(MOOD["bot"], np.float32)
        bg = np.repeat(top * (1 - yy) + bot * yy, OW, axis=1)
        out = bg * (1 - s[..., None]) * (1 - a[..., None]) + img * a[..., None]
        gx_ = (np.arange(tx * OW, (tx + 1) * OW, dtype=np.float32))[None, :]
        gy2 = (np.arange(ty * OH, (ty + 1) * OH, dtype=np.float32))[:, None]
        r = np.sqrt(((gx_ - GW / 2) / (GW * 0.62)) ** 2 + ((gy2 - GH * 0.5) / (GH * 0.62)) ** 2)
        vig = 1 - np.clip(r - 0.55, 0, 1) ** 1.6 * 0.6
        out = out * vig[..., None] + rng.normal(0, 0.006, (OH, OW))[..., None].astype(np.float32)
        out8 = (np.clip(out, 0, 1) * 255 + 0.5).astype(np.uint8)
        Image.fromarray(out8).save(L + f"fin_{tx}_{ty}.webp", "WEBP", quality=90, method=6)
        Image.fromarray(out8).save(L + f"fin_{tx}_{ty}.png")
        prev[ty * qh:(ty + 1) * qh, tx * qw:(tx + 1) * qw] = cv2.resize(out8, (qw, qh), interpolation=cv2.INTER_AREA)
        print("phase 2", tx, ty, flush=True)
Image.fromarray(prev).save(L + "apercu.png")
print("ok")
