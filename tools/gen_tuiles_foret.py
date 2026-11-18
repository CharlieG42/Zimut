#!/usr/bin/env python3
"""Génère les tuiles de sol peintes de la Forêt (V393) : PNG 256×128, losange 2:1, 6 variantes.

Le sol de base est une texture PÉRIODIQUE (même graine pour toutes les variantes) projetée sur le losange :
deux tuiles voisines se raccordent donc sans couture. Les détails (brins, fleurs, pierres, champignons) restent
à l'intérieur du losange et diffèrent d'une variante à l'autre.

Usage : python3 tools/gen_tuiles_foret.py  (écrit prototype/zimut/assets/sprites/tiles/forest_ground_NN.png)
"""
import os, random
import numpy as np
from PIL import Image, ImageDraw, ImageFilter

W, H = 256, 128
S = 256  # côté de la texture périodique (plan du sol)
OUT = os.path.join(os.path.dirname(__file__), "..", "prototype", "zimut", "assets", "sprites", "tiles")


def periodic_noise(seed, size, sigma):
    rng = np.random.default_rng(seed)
    n = rng.standard_normal((size, size))
    f = np.fft.fft2(n)
    fy = np.fft.fftfreq(size)[:, None]
    fx = np.fft.fftfreq(size)[None, :]
    g = np.exp(-(fx ** 2 + fy ** 2) * (2 * np.pi * sigma) ** 2 / 2)
    out = np.real(np.fft.ifft2(f * g))
    return (out - out.mean()) / (out.std() + 1e-9)


def base_ground():
    """Texture du sol (S×S×3, périodique) : herbe moussue à grandes taches + grain fin."""
    big = periodic_noise(11, S, 28)
    mid = periodic_noise(12, S, 9)
    fine = periodic_noise(13, S, 1.6)
    dry = periodic_noise(14, S, 18)
    c_dark = np.array([84, 128, 58], float)
    c_mid = np.array([112, 158, 74], float)
    c_lite = np.array([150, 190, 92], float)
    t = np.clip(0.5 + 0.10 * big + 0.15 * mid, 0, 1)[..., None]
    col = np.where(t < 0.5, c_dark + (c_mid - c_dark) * (t / 0.5), c_mid + (c_lite - c_mid) * ((t - 0.5) / 0.5))
    col = col + (fine[..., None] * 5.0) + (dry[..., None] * np.array([5.0, 1.0, -4.0]))
    return np.clip(col, 0, 255)


def to_diamond(base, shade=(0, 0, 0)):
    ys, xs = np.mgrid[0:H, 0:W]
    u = (xs + 0.5 - W / 2) / (W / 2)
    v = (ys + 0.5 - H / 2) / (H / 2)
    s = ((u + v + 1) / 2) % 1.0 * S
    t = ((v - u + 1) / 2) % 1.0 * S
    s0 = np.floor(s).astype(int) % S; t0 = np.floor(t).astype(int) % S
    s1 = (s0 + 1) % S; t1 = (t0 + 1) % S
    fs = (s - np.floor(s))[..., None]; ft = (t - np.floor(t))[..., None]
    out = (base[t0, s0] * (1 - fs) * (1 - ft) + base[t0, s1] * fs * (1 - ft) +
           base[t1, s0] * (1 - fs) * ft + base[t1, s1] * fs * ft)
    # lumière haut-gauche : dégradé doux (éclaire le sommet haut et le côté gauche)
    light = 1.0 + 0.07 * (-u * 0.55 - v * 0.9)
    out = out * light[..., None] + np.array(shade)
    alpha = np.clip((1.0 - (np.abs(u) + np.abs(v))) * (W / 2) * 0.9 + 0.5, 0, 1)  # bord lissé (1 px)
    rgba = np.dstack([np.clip(out, 0, 255), alpha * 255]).astype(np.uint8)
    return Image.fromarray(rgba, "RGBA")


def inside(x, y, margin):
    return abs(x - W / 2) / (W / 2 - margin * 2) + abs(y - H / 2) / (H / 2 - margin) < 1.0


def blades(img, rnd, n, margin=7):
    d = ImageDraw.Draw(img)
    for _ in range(n):
        x, y = rnd.uniform(0, W), rnd.uniform(0, H)
        if not inside(x, y, margin + 3):
            continue
        h = rnd.uniform(4, 9); sw = rnd.uniform(-2.5, 2.5)
        k = rnd.choice([-34, -18, 16, 30, 44])
        c = (int(np.clip(98 + k, 0, 255)), int(np.clip(148 + k, 0, 255)), int(np.clip(64 + k * 0.6, 0, 255)), 255)
        d.line([(x, y), (x + sw, y - h)], fill=c, width=2)
        d.line([(x + 1, y), (x + 1 + sw * 0.6, y - h * 0.7)], fill=(c[0] + 14 if c[0] < 240 else 255, c[1] + 12 if c[1] < 240 else 255, c[2], 190), width=1)


def center_pt(rnd, rx=70, ry=26):
    while True:
        x = W / 2 + rnd.uniform(-rx, rx); y = H / 2 + rnd.uniform(-ry, ry)
        if inside(x, y, 16):
            return x, y


def shadowed(img, draw_fn):
    """Dessine un détail avec une ombre portée douce vers le bas à droite."""
    layer = Image.new("RGBA", (W, H), (0, 0, 0, 0)); draw_fn(ImageDraw.Draw(layer), 0, 0, False)
    sh = Image.new("RGBA", (W, H), (0, 0, 0, 0)); draw_fn(ImageDraw.Draw(sh), 3, 2, True)
    sh = sh.filter(ImageFilter.GaussianBlur(2))
    img.alpha_composite(sh); img.alpha_composite(layer)


def flowers(img, rnd, n):
    cols = [(244, 236, 214), (246, 205, 70), (232, 150, 190), (160, 190, 250)]
    pts = [center_pt(rnd) for _ in range(n)]
    cs = [rnd.choice(cols) for _ in range(n)]
    def fn(d, ox, oy, sh):
        for (x, y), c in zip(pts, cs):
            if sh:
                d.ellipse([x - 3 + ox, y - 1 + oy, x + 4 + ox, y + 3 + oy], fill=(20, 40, 10, 110)); continue
            d.line([(x, y + 3), (x, y - 1)], fill=(70, 120, 50, 255), width=1)
            for a in range(5):
                import math
                px = x + math.cos(a * 1.2566) * 2.6; py = y - 2 + math.sin(a * 1.2566) * 1.7
                d.ellipse([px - 1.6, py - 1.4, px + 1.6, py + 1.4], fill=c + (255,))
            d.ellipse([x - 1, y - 3, x + 1, y - 1], fill=(240, 180, 40, 255))
    shadowed(img, fn)


def stones(img, rnd, n, moss=True):
    items = []
    for _ in range(n):
        x, y = center_pt(rnd, 60, 22)
        items.append((x, y, rnd.uniform(5, 11), rnd.choice([(150, 150, 142), (128, 130, 124), (168, 164, 150)])))
    def fn(d, ox, oy, sh):
        for x, y, r, c in items:
            if sh:
                d.ellipse([x - r + ox, y - r * 0.4 + oy, x + r + ox, y + r * 0.6 + oy], fill=(20, 40, 10, 130)); continue
            d.ellipse([x - r, y - r * 0.55, x + r, y + r * 0.55], fill=tuple(int(v * 0.72) for v in c) + (255,))
            d.ellipse([x - r + 0.8, y - r * 0.62, x + r - 1.2, y + r * 0.40], fill=c + (255,))
            d.ellipse([x - r * 0.5, y - r * 0.5, x + r * 0.1, y - r * 0.15], fill=tuple(min(255, int(v * 1.15)) for v in c) + (255,))
            if moss:
                d.pieslice([x - r, y - r * 0.55, x + r, y + r * 0.55], 190, 280, fill=(96, 150, 66, 235))
    shadowed(img, fn)


def clover(img, rnd, n):
    d = ImageDraw.Draw(img)
    for _ in range(n):
        x, y = center_pt(rnd, 74, 28)
        for a in range(3):
            import math
            ang = a * 2.094 - 1.57
            d.ellipse([x + math.cos(ang) * 2.4 - 2, y + math.sin(ang) * 1.5 - 1.4, x + math.cos(ang) * 2.4 + 2, y + math.sin(ang) * 1.5 + 1.4], fill=(70, 138, 62, 255))


def mushrooms(img, rnd):
    x0, y0 = center_pt(rnd, 40, 14)
    items = [(x0 + rnd.uniform(-14, 14), y0 + rnd.uniform(-5, 5), rnd.uniform(4, 6)) for _ in range(4)]
    def fn(d, ox, oy, sh):
        for x, y, r in items:
            if sh:
                d.ellipse([x - r + ox, y - 1 + oy, x + r + ox, y + 3 + oy], fill=(20, 40, 10, 120)); continue
            d.rectangle([x - 1.2, y - 2, x + 1.2, y + 2], fill=(236, 228, 206, 255))
            d.pieslice([x - r, y - r - 2, x + r, y + r - 2], 180, 360, fill=(214, 96, 70, 255))
            d.ellipse([x - 1.5, y - r - 0.5, x - 0.2, y - r + 0.8], fill=(255, 245, 230, 255))
            d.ellipse([x + 1.6, y - r + 1.5, x + 2.8, y - r + 2.7], fill=(255, 245, 230, 255))
    shadowed(img, fn)


def dirt(img, rnd):
    x, y = center_pt(rnd, 30, 10)
    d = ImageDraw.Draw(img)
    layer = Image.new("RGBA", (W, H), (0, 0, 0, 0)); ld = ImageDraw.Draw(layer)
    ld.ellipse([x - 26, y - 9, x + 26, y + 9], fill=(122, 96, 62, 210))
    ld.ellipse([x - 18, y - 6, x + 18, y + 6], fill=(140, 112, 74, 220))
    layer = layer.filter(ImageFilter.GaussianBlur(2.2))
    img.alpha_composite(layer)
    for _ in range(16):
        px, py = x + rnd.uniform(-22, 22), y + rnd.uniform(-7, 7)
        d.ellipse([px - 1.3, py - 0.8, px + 1.3, py + 0.8], fill=(98, 76, 50, 255))


def build():
    base = base_ground()
    specs = [
        dict(seed=101, tint=(0, 0, 0), bl=170, extra=None),
        dict(seed=102, tint=(5, 4, 0), bl=200, extra=None),
        dict(seed=103, tint=(-5, -4, -2), bl=150, extra=None),
        dict(seed=104, tint=(2, 2, 0), bl=150, extra="flowers"),
        dict(seed=105, tint=(-3, -2, -1), bl=130, extra="stones"),
        dict(seed=106, tint=(0, 0, 0), bl=120, extra="special"),
    ]
    for i, sp in enumerate(specs, 1):
        rnd = random.Random(sp["seed"])
        img = to_diamond(base, sp["tint"])
        clover(img, rnd, 5)
        blades(img, rnd, sp["bl"])
        if sp["extra"] == "flowers":
            flowers(img, rnd, 5)
        elif sp["extra"] == "stones":
            stones(img, rnd, 3)
        elif sp["extra"] == "special":
            dirt(img, rnd); mushrooms(img, rnd)
        # liseré clair en haut, ombre fine en bas (dalle épaisse)
        ov = Image.new("RGBA", (W, H), (0, 0, 0, 0)); od = ImageDraw.Draw(ov)
        od.line([(128, 3), (3, 64)], fill=(255, 255, 220, 70), width=3)
        od.line([(128, 3), (253, 64)], fill=(255, 255, 220, 40), width=3)
        od.line([(3, 64), (128, 125)], fill=(20, 40, 10, 50), width=3)
        od.line([(253, 64), (128, 125)], fill=(20, 40, 10, 90), width=3)
        ov = ov.filter(ImageFilter.GaussianBlur(1.2))
        alpha = img.getchannel("A")
        merged = Image.alpha_composite(img, ov)
        merged.putalpha(alpha)
        os.makedirs(OUT, exist_ok=True)
        merged.save(os.path.join(OUT, "forest_ground_%02d.png" % i), optimize=True)
        print("forest_ground_%02d.png" % i)


if __name__ == "__main__":
    build()
