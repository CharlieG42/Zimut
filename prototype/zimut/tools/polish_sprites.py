#!/usr/bin/env python3
"""polish_sprites.py — Passe de finition « peinture » sur les skins SVG (ennemis, invocations, Sylvain).

Rend chaque SVG en PNG 2x puis ajoute : volume (éclairage en haut à gauche calculé sur la
silhouette), lumière de bord chaude / ombre froide, dégradé ambiant vertical, légère matière.
Génère aussi des VARIANTES PAR BIOME (loup blanc en montagne, gobelin sable dans le désert...).
Les PNG sont prioritaires sur les SVG dans EntityView/Portraits.
Usage : python3 tools/polish_sprites.py [--sheet apercu.png]
"""
import os, sys, colorsys
import numpy as np
import cairosvg
from PIL import Image, ImageFilter

HERE = os.path.dirname(os.path.abspath(__file__))
SPR = os.path.join(HERE, "..", "assets", "sprites")
FOLDERS = ["enemies", "summons"]
PLAYER_SVGS = ["sylvain"]

# Variantes par biome : (dossier, nom, biome, (rotation de teinte en degrés, saturation, luminosité))
VARIANTS = [
    ("enemies", "loup", "montagne", (10, 0.25, 1.38)), ("enemies", "loup", "desert", (22, 0.9, 1.12)),
    ("enemies", "gobelin", "montagne", (60, 0.7, 1.05)), ("enemies", "gobelin", "desert", (-34, 0.8, 1.1)),
    ("enemies", "squelette", "desert", (18, 0.8, 1.0)), ("enemies", "squelette", "montagne", (0, 0.55, 1.12)),
    ("enemies", "troll", "montagne", (70, 0.55, 1.1)), ("enemies", "troll", "desert", (-62, 0.7, 1.08)),
    ("enemies", "dragonnet", "montagne", (165, 0.85, 1.1)), ("enemies", "dragonnet", "desert", (24, 0.8, 1.14)),
]


def render(path, scale=2.0):
    tmp = "/tmp/_pol.png"
    cairosvg.svg2png(url=path, write_to=tmp, scale=scale)
    return Image.open(tmp).convert("RGBA")


def polish(im):
    arr = np.asarray(im).astype(np.float32) / 255.0
    rgb = arr[..., :3]
    a = arr[..., 3]
    h, w = a.shape
    # champ de hauteur = silhouette floutée
    hf = np.asarray(Image.fromarray((a * 255).astype(np.uint8)).filter(ImageFilter.GaussianBlur(7))).astype(np.float32) / 255.0
    gy, gx = np.gradient(hf)
    # lumière venant du haut à gauche : face tournée vers (-1,-1) éclairée
    lit = np.clip(-(gx * 0.75 + gy * 0.95) * 9.0, -1.0, 1.0)
    shade = 1.0 + lit * 0.22
    # dégradé ambiant vertical (haut un peu plus clair, bas plus sombre)
    yy = np.linspace(0, 1, h)[:, None]
    amb = 1.06 - 0.20 * yy
    out = rgb * (shade * amb)[..., None]
    # lumière de bord chaude (haut-gauche) sur la couche interne de la silhouette
    er = np.asarray(Image.fromarray((a * 255).astype(np.uint8)).filter(ImageFilter.MinFilter(9))).astype(np.float32) / 255.0
    rim = np.clip(a - er, 0, 1)
    rim_l = np.clip(-(gx + gy) * 14.0, 0, 1) * rim
    rim_d = np.clip((gx + gy) * 14.0, 0, 1) * rim
    out = out + (rim_l * 0.16)[..., None] * np.array([1.0, 0.96, 0.82])
    out = out * (1.0 - rim_d * 0.22)[..., None]
    # matière légère
    rng = np.random.default_rng(7)
    noise = rng.normal(0, 1, (h, w)).astype(np.float32)
    noise = np.asarray(Image.fromarray(((noise * 40 + 128).clip(0, 255)).astype(np.uint8)).filter(ImageFilter.GaussianBlur(1.6))).astype(np.float32) / 255.0 - 0.5
    out = out * (1.0 + noise[..., None] * 0.10)
    # saturation légère
    mean = out.mean(axis=2, keepdims=True)
    out = mean + (out - mean) * 1.07
    out = np.clip(out, 0, 1)
    res = np.dstack([out, a])
    return Image.fromarray((res * 255).astype(np.uint8), "RGBA")


def tint(im, hue_deg, sat, val):
    arr = np.asarray(im).astype(np.float32) / 255.0
    rgb = arr[..., :3]
    a = arr[..., 3:]
    # conversion HSV vectorisée
    mx = rgb.max(axis=2)
    mn = rgb.min(axis=2)
    d = mx - mn
    hch = np.zeros_like(mx)
    r, g, b = rgb[..., 0], rgb[..., 1], rgb[..., 2]
    m = d > 1e-6
    hch[m & (mx == r)] = (((g - b)[m & (mx == r)] / d[m & (mx == r)]) % 6) / 6.0
    hch[m & (mx == g)] = (((b - r)[m & (mx == g)] / d[m & (mx == g)]) + 2) / 6.0
    hch[m & (mx == b)] = (((r - g)[m & (mx == b)] / d[m & (mx == b)]) + 4) / 6.0
    s = np.where(mx > 1e-6, d / np.maximum(mx, 1e-6), 0)
    hch = (hch + hue_deg / 360.0) % 1.0
    s = np.clip(s * sat, 0, 1)
    v = np.clip(mx * val, 0, 1)
    i = (hch * 6).astype(int) % 6
    f = hch * 6 - np.floor(hch * 6)
    p = v * (1 - s)
    q = v * (1 - f * s)
    t = v * (1 - (1 - f) * s)
    choices = [np.stack(c, axis=-1) for c in [(v, t, p), (q, v, p), (p, v, t), (p, q, v), (t, p, v), (v, p, q)]]
    out = np.zeros_like(rgb)
    for k in range(6):
        out = np.where((i == k)[..., None], choices[k], out)
    res = np.dstack([out, a[..., 0]])
    return Image.fromarray((res * 255).astype(np.uint8), "RGBA")


def main():
    made = []
    sources = []
    for folder in FOLDERS:
        d = os.path.join(SPR, folder)
        for fn in sorted(os.listdir(d)):
            if fn.endswith(".svg"):
                sources.append((folder, fn[:-4], os.path.join(d, fn)))
    for name in PLAYER_SVGS:
        sources.append(("players", name, os.path.join(SPR, "players", name + ".svg")))
    cache = {}
    for folder, name, path in sources:
        if not os.path.exists(path):
            continue
        im = polish(render(path))
        im.save(os.path.join(SPR, folder, name + ".png"))
        cache[(folder, name)] = im
        made.append((folder, name))
    for folder, name, biome, (hue, sat, val) in VARIANTS:
        base = cache.get((folder, name))
        if base is None:
            continue
        tint(base, hue, sat, val).save(os.path.join(SPR, folder, f"{name}_{biome}.png"))
        made.append((folder, f"{name}_{biome}"))
    print(len(made), "PNG générés")
    if "--sheet" in sys.argv:
        ims = [Image.open(os.path.join(SPR, f, n + ".png")) for f, n in made]
        cols = 9
        cw, ch = 190, 230
        rows = (len(ims) + cols - 1) // cols
        sheet = Image.new("RGBA", (cols * cw, rows * ch), (104, 132, 92, 255))
        for i, im in enumerate(ims):
            t = im.copy()
            t.thumbnail((cw - 10, ch - 10))
            sheet.paste(t, ((i % cols) * cw + 5, (i // cols) * ch + 5), t)
        sheet.save(sys.argv[sys.argv.index("--sheet") + 1])


if __name__ == "__main__":
    main()
