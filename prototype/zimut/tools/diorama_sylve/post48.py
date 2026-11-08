"""Finition B (HD-2D sans flou de bord) pour la Sylve 48x48, par fenêtres (mémoire limitée)."""
import sys, os, numpy as np, cv2
from PIL import Image
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import post_lib as P
Image.MAX_IMAGE_PIXELS = None
cv2.setNumThreads(2)
L = os.environ.get('DIORAMA_WORK', os.getcwd()) + '/'
NT = int(sys.argv[1]) if len(sys.argv) > 1 else 2
DMAX = 220.0
OUT = (5120, 2880)

def stitch(mode):
    rows = []
    for ty in range(NT):
        rows.append(np.concatenate([np.array(Image.open(L + f'{mode}_{tx}_{ty}.png').convert('RGBA')) for tx in range(NT)], 1))
    return np.concatenate(rows, 0)

Bu, Du, Nu = stitch('beauty'), stitch('depth'), stitch('normal')
Hf, Wf = Bu.shape[:2]
print('plein', Wf, Hf)
f16 = np.zeros((Hf, Wf, 3), np.float16)
M = 200
WIN = 1280
for y0 in range(0, Hf, WIN):
    for x0 in range(0, Wf, WIN):
        ya, yb = max(0, y0 - M), min(Hf, y0 + WIN + M)
        xa, xb = max(0, x0 - M), min(Wf, x0 + WIN + M)
        b = Bu[ya:yb, xa:xb].astype(np.float32) / 255
        d = Du[ya:yb, xa:xb].astype(np.float32)
        n = Nu[ya:yb, xa:xb].astype(np.float32) / 255
        a = b[..., 3]
        if a.max() == 0:
            continue
        D = (d[..., 0] + d[..., 1] / 255.0) / 255.0 * DMAX
        N = n[..., :3] * 2 - 1
        N /= np.maximum(np.linalg.norm(N, axis=2, keepdims=True), 1e-4)
        P.CLS = d[..., 2] / 255.0
        img, ao = P.base_grade(b[..., :3], a, D, N, 0.66)
        img = P.hsv_grade(img, 1.0, 1.0, 0, 1.12)
        ed, en = P.edges(D, N, a)
        img = P.draw_lines(img, np.maximum(ed, en * 0.5), 2, 0.38, dark=0.55)
        img = P.tone(img, 0.22, (1.08, 1.0, 0.88), (0.03, 0.035, 0.09))
        # brume légère, coordonnées globales (haut = loin)
        ys = (np.arange(ya, yb, dtype=np.float32) / Hf)[:, None, None]
        depth_n = np.clip((D - 75) / 110.0, 0, 1)[..., None]
        fog = np.clip(0.34 * (1 - ys) ** 2.6 + 0.14 * depth_n, 0, 0.32) * 0.65
        img = img * (1 - fog) + np.array([0.80, 0.84, 0.95], np.float32) * fog
        oy, ox = y0 - ya, x0 - xa
        h = min(WIN, Hf - y0); w = min(WIN, Wf - x0)
        f16[y0:y0 + h, x0:x0 + w] = img[oy:oy + h, ox:ox + w]
    print('rangée', y0)

img = cv2.resize(f16.astype(np.float32), OUT, interpolation=cv2.INTER_AREA)
del f16
a = cv2.resize(Bu[..., 3].astype(np.float32) / 255, OUT, interpolation=cv2.INTER_AREA)
del Bu, Du, Nu
k = OUT[0] / Wf          # rayons ramenés à la résolution de sortie
lum = (img * np.array([0.3, 0.59, 0.11], np.float32)).sum(2)
bright = np.clip(img - 0.8, 0, 1) * np.clip((lum[..., None] - 0.72) * 3, 0, 1)
bloom = P.blur(bright, 18 * k) * 0.7 + P.blur(bright, 70 * k) * 0.9 + P.blur(bright, 180 * k) * 0.6
img = img + bloom * np.array([1.0, 0.9, 0.72], np.float32)
h, w = a.shape
bgc = P.bg_gradient(h, w, (0.13, 0.15, 0.27), (0.38, 0.27, 0.30))
yy, xx = np.mgrid[0:h, 0:w].astype(np.float32)
r = np.sqrt(((xx - w / 2) / (w * 0.62)) ** 2 + ((yy - h * 0.5) / (h * 0.62)) ** 2)
vig = 1 - np.clip(r - 0.5, 0, 1) ** 1.6 * 0.6
out = P.composite(img, a, bgc, 0.55) * vig[..., None]
out = out + np.random.default_rng(1).normal(0, 0.006, out.shape[:2])[..., None].astype(np.float32)
Image.fromarray((np.clip(out, 0, 1) * 255 + 0.5).astype(np.uint8)).save(L + 'sylve48_B.png')
Image.fromarray((np.dstack([np.clip(img, 0, 1), a]) * 255 + 0.5).astype(np.uint8)).save(L + 'sylve48_B_alpha.png')
print('ok')
