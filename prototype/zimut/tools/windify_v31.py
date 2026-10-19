import sys
import numpy as np
from PIL import Image
def windify(src, dst):
    im = Image.open(src).convert('RGBA')
    hsv = np.array(im.convert('RGB').convert('HSV')).astype(np.float32)
    a = np.array(im)[:, :, 3]
    h, s, v = hsv[..., 0], hsv[..., 1], hsv[..., 2]
    purple = (h > 160) & (h < 235) & (s > 40)
    # violet -> bleu ciel / turquoise, un peu plus clair
    h[purple] = 124
    s[purple] = s[purple] * 0.75
    v[purple] = np.minimum(255, v[purple] * 1.25 + 20)
    # noirs du manteau -> gris ardoise bleuté (tenue plus aérienne)
    dark = (v < 110) & ~((h < 30) & (s > 60))
    h[dark] = 140
    s[dark] = np.clip(s[dark] * 0.5 + 25, 0, 90)
    v[dark] = v[dark] * 0.75 + 95
    out = Image.fromarray(np.dstack([h, s, v]).astype(np.uint8), 'HSV').convert('RGB')
    o = np.array(out)
    Image.fromarray(np.dstack([o, a]), 'RGBA').save(dst)
for s, d in zip(sys.argv[1::2], sys.argv[2::2]):
    windify(s, d)
