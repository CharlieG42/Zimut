#!/usr/bin/env python3
"""Génère les textures « peintes » du rendu 3D (V86) : assets/textures3d/paint.png (aplats / coups de pinceau,
niveaux de gris tuilables) et leaf.png (amas de feuilles RGBA pour les cartes de feuillage).
Usage : python3 tools/gen_textures3d.py"""
import numpy as np
from PIL import Image, ImageDraw, ImageFilter
import os, math

OUT = os.path.join(os.path.dirname(__file__), "..", "assets", "textures3d")
os.makedirs(OUT, exist_ok=True)
rng = np.random.default_rng(7)


def tile_noise(n, cutoff_lo, cutoff_hi, aniso=1.0, angle=0.0):
    """Bruit tuilable par FFT : bande de fréquences [lo, hi], étiré selon `angle` (coups de pinceau)."""
    w = rng.normal(size=(n, n))
    f = np.fft.fft2(w)
    fy, fx = np.meshgrid(np.fft.fftfreq(n) * n, np.fft.fftfreq(n) * n, indexing="ij")
    ca, sa = math.cos(angle), math.sin(angle)
    u = fx * ca + fy * sa
    v = (-fx * sa + fy * ca) * aniso
    r = np.sqrt(u * u + v * v)
    band = np.exp(-(r / cutoff_hi) ** 2) * (1 - np.exp(-(r / max(cutoff_lo, 0.01)) ** 2))
    out = np.real(np.fft.ifft2(f * band))
    out -= out.mean()
    return out / (out.std() + 1e-9)


def paint(n=256):
    a = tile_noise(n, 1.0, 5.0)                       # grands aplats
    b = tile_noise(n, 4.0, 18.0, aniso=0.5, angle=0.6)   # coups de pinceau allongés
    c = tile_noise(n, 12.0, 48.0)                     # grain fin
    img = 0.5 + 0.12 * a + 0.045 * b + 0.025 * c
    # contraste « gouache » : les valeurs se resserrent par plages
    img = np.clip(img, 0, 1)
    img = np.clip(img, 0, 1)
    Image.fromarray((img * 255).astype(np.uint8), "L").save(os.path.join(OUT, "paint.png"))


def leaf(n=128):
    S = 4  # sur-échantillonnage
    im = Image.new("RGBA", (n * S, n * S), (0, 0, 0, 0))
    d = ImageDraw.Draw(im)
    cx, cy = n * S * 0.5, n * S * 0.93
    R = n * S * 0.64
    for i in range(11):
        ang = math.radians(-90 + (i - 5) * 17 + rng.normal(0, 4))
        ln = R * rng.uniform(0.75, 1.0)
        wd = R * rng.uniform(0.22, 0.30)
        pts = []
        for t in np.linspace(0, 1, 18):
            ww = wd * math.sin(math.pi * t ** 0.8) * (1 - 0.25 * t)
            pts.append((t * ln, ww))
        side2 = [(x, -w) for x, w in reversed(pts)]
        poly = []
        for x, w in pts + side2:
            px = cx + x * math.cos(ang) - w * math.sin(ang)
            py = cy + x * math.sin(ang) + w * math.cos(ang)
            poly.append((px, py))
        shade = int(rng.uniform(165, 255))
        d.polygon(poly, fill=(shade, shade, shade, 255))
        # nervure centrale plus claire
        tip = (cx + ln * math.cos(ang), cy + ln * math.sin(ang))
        d.line([(cx, cy), tip], fill=(255, 255, 255, 255), width=int(S * 1.2))
    im = im.resize((n, n), Image.LANCZOS)
    # dégradé de lumière : le haut de la carte est plus clair
    arr = np.array(im).astype(np.float32)
    g = np.linspace(1.0, 0.72, n)[:, None]
    arr[..., :3] *= g[..., None]
    Image.fromarray(arr.clip(0, 255).astype(np.uint8), "RGBA").save(os.path.join(OUT, "leaf.png"))


paint()
leaf()
print("ok")
