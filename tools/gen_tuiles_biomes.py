#!/usr/bin/env python3
"""Génère les tuiles de sol peintes des 9 autres biomes (V438) : PNG 256×128, losange 2:1, 6 variantes par biome.

Même principe que la Forêt (tools/gen_tuiles_foret.py) : un sol de base PÉRIODIQUE (même graine pour toutes les
variantes d'un biome) projeté sur le losange, donc raccord sans couture ; les détails restent à l'intérieur de la
tuile et changent d'une variante à l'autre. Matière, couleurs et détails de chaque biome : voir SPECS.

Usage : python3 tools/gen_tuiles_biomes.py [biome ...]   (sans argument : tous)
"""
import math, os, random, sys
import numpy as np
from PIL import Image, ImageDraw, ImageFilter

sys.path.insert(0, os.path.dirname(__file__))
import gen_tuiles_foret as F  # noqa: E402  (périodique, projection en losange, ombres, utilitaires)

W, H = F.W, F.H
OUT = F.OUT


def C(c, k=0, a=255):
    return (int(np.clip(c[0] + k, 0, 255)), int(np.clip(c[1] + k, 0, 255)), int(np.clip(c[2] + k, 0, 255)), a)


def base_ground(sp):
    S = F.S
    seed = sp["seed"]
    big = F.periodic_noise(seed, S, 30)
    mid = F.periodic_noise(seed + 1, S, 9)
    fine = F.periodic_noise(seed + 2, S, 1.6)
    warm = F.periodic_noise(seed + 3, S, 16)
    d, m, l = (np.array(sp[k], float) for k in ("dark", "mid", "lite"))
    t = np.clip(0.5 + sp.get("wbig", 0.10) * big + sp.get("wmid", 0.15) * mid, 0, 1)[..., None]
    col = np.where(t < 0.5, d + (m - d) * (t / 0.5), m + (l - m) * ((t - 0.5) / 0.5))
    col = col + fine[..., None] * sp.get("grain", 5.0) + warm[..., None] * np.array(sp.get("warm", (4, 1, -3)), float)
    col = np.clip(col, 0, 255)
    if sp.get("seams"):
        # joints de dalles périodiques : une croix au milieu (les bords de la tuile sont déjà marqués par le jeu)
        img = Image.fromarray(col.astype(np.uint8), "RGB")
        dr = ImageDraw.Draw(img)
        sc = tuple(int(v) for v in sp["seams"])
        for x in (S // 2,):
            dr.line([(x, 0), (x, S)], fill=sc, width=3)
            dr.line([(0, x), (S, x)], fill=sc, width=3)
        hl = tuple(min(255, int(v * 1.35)) for v in sc)
        dr.line([(S // 2 + 2, 0), (S // 2 + 2, S)], fill=hl, width=1)
        dr.line([(0, S // 2 + 2), (S, S // 2 + 2)], fill=hl, width=1)
        col = np.asarray(img, float)
    return col


# ── détails ───────────────────────────────────────────────────────────────

def glow(img, pts, color, radius, strength=1.0):
    """Halo additif (lave, cristaux, champignons phosphorescents)."""
    layer = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    d = ImageDraw.Draw(layer)
    for x, y in pts:
        d.ellipse([x - radius, y - radius * 0.55, x + radius, y + radius * 0.55], fill=color + (int(110 * strength),))
    layer = layer.filter(ImageFilter.GaussianBlur(radius * 0.55))
    img.alpha_composite(layer)


def pebbles(img, rnd, n, cols, size=(3, 8), shadow=True, moss=None):
    items = []
    for _ in range(n):
        x, y = F.center_pt(rnd, 74, 28)
        items.append((x, y, rnd.uniform(*size), rnd.choice(cols)))

    def fn(d, ox, oy, sh):
        for x, y, r, c in items:
            if sh:
                d.ellipse([x - r + ox, y - r * 0.4 + oy, x + r + ox, y + r * 0.6 + oy], fill=(10, 10, 20, 120))
                continue
            d.ellipse([x - r, y - r * 0.55, x + r, y + r * 0.55], fill=C(c, -34))
            d.ellipse([x - r + 0.7, y - r * 0.62, x + r - 1.1, y + r * 0.42], fill=C(c))
            d.ellipse([x - r * 0.5, y - r * 0.52, x + r * 0.1, y - r * 0.18], fill=C(c, 26))
            if moss:
                d.pieslice([x - r, y - r * 0.55, x + r, y + r * 0.55], 190, 280, fill=moss)
    F.shadowed(img, fn)


def arcs(img, rnd, n, color, width=2, length=(16, 40), curve=4.0, alpha=140, spread=(80, 30)):
    """Petits traits courbes (rides de sable, plumes, rubans, joints)."""
    d = ImageDraw.Draw(img)
    for _ in range(n):
        x, y = F.center_pt(rnd, *spread)
        ln = rnd.uniform(*length)
        sg = 1 if rnd.random() < 0.5 else -1
        pts = [(x - ln / 2 + ln * k / 8, y + math.sin(k / 8 * math.pi) * curve * sg * 0.5) for k in range(9)]
        d.line(pts, fill=color + (alpha,) if len(color) == 3 else color, width=width)


def cracks(img, rnd, n, color, glow_col=None, width=2, steps=(5, 9), step=(6, 12)):
    layer = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    d = ImageDraw.Draw(layer)
    starts = []
    for _ in range(n):
        x, y = F.center_pt(rnd, 70, 26)
        ang = rnd.uniform(0, math.tau)
        pts = [(x, y)]
        for _k in range(rnd.randint(*steps)):
            ang += rnd.uniform(-0.8, 0.8)
            x += math.cos(ang) * rnd.uniform(*step)
            y += math.sin(ang) * rnd.uniform(*step) * 0.5
            if not F.inside(x, y, 10):
                break
            pts.append((x, y))
        if len(pts) > 1:
            d.line(pts, fill=color, width=width)
            starts.extend(pts[::2])
    if glow_col is not None:
        glow(img, starts, glow_col, 7, 0.9)
    img.alpha_composite(layer)


def dots(img, rnd, n, cols, size=(1.2, 2.6), spread=(78, 30), glow_col=None):
    d = ImageDraw.Draw(img)
    pts = []
    for _ in range(n):
        x, y = F.center_pt(rnd, *spread)
        r = rnd.uniform(*size)
        d.ellipse([x - r, y - r * 0.7, x + r, y + r * 0.7], fill=rnd.choice(cols))
        pts.append((x, y))
    if glow_col is not None:
        glow(img, pts[:: max(1, n // 8)], glow_col, 6, 0.8)


def puddles(img, rnd, n, col, rim, size=(10, 22)):
    layer = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    d = ImageDraw.Draw(layer)
    for _ in range(n):
        x, y = F.center_pt(rnd, 56, 20)
        rx = rnd.uniform(*size)
        ry = rx * 0.42
        d.ellipse([x - rx - 1.5, y - ry - 1, x + rx + 1.5, y + ry + 1.5], fill=rim)
        d.ellipse([x - rx, y - ry, x + rx, y + ry], fill=col)
        d.ellipse([x - rx * 0.55, y - ry * 0.7, x - rx * 0.05, y - ry * 0.25], fill=(255, 255, 255, 60))
    img.alpha_composite(layer.filter(ImageFilter.GaussianBlur(0.8)))


def shards(img, rnd, n, cols, glow_col):
    items = []
    for _ in range(n):
        x, y = F.center_pt(rnd, 56, 20)
        items.append((x, y, rnd.uniform(5, 11), rnd.uniform(-0.25, 0.25), rnd.choice(cols)))
    glow(img, [(x, y - 4) for x, y, *_ in items], glow_col, 11, 1.0)

    def fn(d, ox, oy, sh):
        for x, y, h, tl, c in items:
            if sh:
                d.polygon([(x - 3 + ox, y + oy), (x + 3 + ox, y + oy), (x + 7 + ox, y + 2 + oy)], fill=(0, 0, 10, 120))
                continue
            d.polygon([(x - 3, y), (x + tl * h, y - h), (x + 3, y)], fill=C(c, -40))
            d.polygon([(x - 3, y), (x + tl * h, y - h), (x + 0.5, y)], fill=C(c, 10))
            d.polygon([(x - 1.5, y - 1), (x + tl * h, y - h), (x, y - h * 0.4)], fill=C(c, 70))
    F.shadowed(img, fn)


def glyphs(img, rnd, n, color):
    d = ImageDraw.Draw(img)
    for _ in range(n):
        x, y = F.center_pt(rnd, 50, 18)
        s = rnd.uniform(3.5, 6)
        k = rnd.randint(0, 3)
        segs = [[(-s, 0), (s, 0), (0, -s * 1.3), (0, s * 0.8)], [(-s, -s * 0.6), (s, s * 0.6), (-s, s * 0.6), (s, -s * 0.6)],
                [(0, -s), (s, 0), (0, s), (-s, 0), (0, -s)], [(-s, s * 0.5), (0, -s), (s, s * 0.5), (-s * 0.5, 0), (s * 0.5, 0)]][k]
        d.line([(x + a, y + b * 0.6) for a, b in segs], fill=color, width=1)
    glow(img, [F.center_pt(rnd, 50, 18) for _ in range(3)], color[:3], 8, 0.35)


def gear(img, rnd, color_dark, color_lite):
    x, y = F.center_pt(rnd, 30, 10)
    layer = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    d = ImageDraw.Draw(layer)
    r = 20
    for k in range(10):
        a0 = k * math.tau / 10
        pts = [(x + math.cos(a0 + da) * rr, y + math.sin(a0 + da) * rr * 0.5) for da, rr in ((-0.12, r), (-0.08, r + 5), (0.08, r + 5), (0.12, r))]
        d.polygon(pts, fill=color_dark)
    d.ellipse([x - r, y - r * 0.5, x + r, y + r * 0.5], fill=color_dark)
    d.ellipse([x - r + 3, y - r * 0.5 + 1.5, x + r - 3, y + r * 0.5 - 1.5], outline=color_lite, width=1)
    d.ellipse([x - 6, y - 3, x + 6, y + 3], fill=color_lite)
    d.ellipse([x - 2.5, y - 1.2, x + 2.5, y + 1.2], fill=color_dark)
    img.alpha_composite(layer)


def rivets(img, rnd, color):
    d = ImageDraw.Draw(img)
    for dx, dy in ((-60, 0), (60, 0), (0, -26), (0, 26), (-30, -13), (30, 13), (-30, 13), (30, -13)):
        x, y = W / 2 + dx * 0.72, H / 2 + dy * 0.72
        d.ellipse([x - 2.2, y - 1.5, x + 2.2, y + 1.5], fill=C(color, -45))
        d.ellipse([x - 1.8, y - 1.5, x + 1.5, y + 0.8], fill=C(color, 40))


def footprints(img, rnd):
    d = ImageDraw.Draw(img)
    x, y = F.center_pt(rnd, 50, 16)
    for k in range(4):
        px, py = x + k * 14 - 22, y + (k % 2) * 5 - 3
        d.ellipse([px - 3.5, py - 2, px + 3.5, py + 2], fill=(150, 165, 185, 170))
        d.ellipse([px - 2.5, py - 2, px + 2.5, py + 0.8], fill=(235, 242, 250, 200))


def tufts(img, rnd, n, cols, h=(4, 8)):
    d = ImageDraw.Draw(img)
    for _ in range(n):
        x, y = rnd.uniform(0, W), rnd.uniform(0, H)
        if not F.inside(x, y, 10):
            continue
        c = rnd.choice(cols)
        for k in range(3):
            d.line([(x + k * 1.5, y), (x + k * 1.5 + rnd.uniform(-2, 2), y - rnd.uniform(*h))], fill=c, width=1)


# ── spécifications des biomes ──────────────────────────────────────────────
# Chaque variante : seed, teinte (r,v,b), liste d'opérations (nom, paramètres).
def specs():
    snow_st = [(150, 158, 170), (176, 182, 190), (122, 128, 138)]
    return {
        "mountain_ground": dict(seed=201, dark=(150, 162, 180), mid=(206, 216, 228), lite=(244, 248, 252), grain=4.0, warm=(-2, 0, 4),
            variants=[
                dict(tint=(0, 0, 0), ops=[("arcs", dict(n=6, color=(255, 255, 255), width=2, alpha=110, curve=3)), ("dots", dict(n=40, cols=[(255, 255, 255, 230), (205, 220, 240, 220)]))]),
                dict(tint=(-4, -3, 0), ops=[("arcs", dict(n=7, color=(255, 255, 255), width=2, alpha=100)), ("pebbles", dict(n=2, cols=snow_st, size=(3, 6)))]),
                dict(tint=(3, 3, 3), ops=[("dots", dict(n=60, cols=[(255, 255, 255, 240), (190, 208, 232, 230)]))]),
                dict(tint=(0, 0, 0), ops=[("pebbles", dict(n=5, cols=snow_st, size=(4, 9))), ("arcs", dict(n=4, color=(255, 255, 255), width=2, alpha=100))]),
                dict(tint=(-6, -4, -1), ops=[("pebbles", dict(n=3, cols=[(110, 112, 120), (140, 140, 146)], size=(5, 11))), ("dots", dict(n=30, cols=[(255, 255, 255, 230)]))]),
                dict(tint=(0, 0, 0), ops=[("footprints", {}), ("dots", dict(n=40, cols=[(255, 255, 255, 230)]))]),
            ]),
        "desert_ground": dict(seed=211, dark=(188, 150, 90), mid=(222, 190, 126), lite=(242, 216, 156), grain=6.0, warm=(6, 2, -5),
            variants=[
                dict(tint=(0, 0, 0), ops=[("arcs", dict(n=10, color=(252, 230, 170), width=2, alpha=120, curve=5)), ("arcs", dict(n=8, color=(160, 124, 70), width=1, alpha=110, curve=5))]),
                dict(tint=(5, 3, -2), ops=[("arcs", dict(n=12, color=(252, 232, 176), width=2, alpha=110, curve=6))]),
                dict(tint=(-5, -4, -2), ops=[("arcs", dict(n=8, color=(150, 114, 66), width=2, alpha=90)), ("dots", dict(n=40, cols=[(170, 134, 80, 220), (250, 226, 170, 200)]))]),
                dict(tint=(0, 0, 0), ops=[("pebbles", dict(n=4, cols=[(198, 168, 120), (176, 146, 104)], size=(4, 9))), ("arcs", dict(n=6, color=(252, 230, 170), width=2, alpha=100))]),
                dict(tint=(-3, -3, -2), ops=[("cracks", dict(n=3, color=(120, 90, 52, 220), width=2)), ("arcs", dict(n=5, color=(252, 230, 170), width=2, alpha=90))]),
                dict(tint=(0, 0, 0), ops=[("tufts", dict(n=6, cols=[(150, 140, 70, 255), (190, 170, 90, 255)])), ("pebbles", dict(n=2, cols=[(190, 160, 112)], size=(4, 7))), ("arcs", dict(n=6, color=(252, 230, 170), width=2, alpha=100))]),
            ]),
        "cristaux_ground": dict(seed=221, dark=(46, 50, 72), mid=(70, 76, 104), lite=(102, 108, 142), grain=5.0, warm=(0, 1, 5),
            variants=[
                dict(tint=(0, 0, 0), ops=[("cracks", dict(n=3, color=(30, 32, 52, 230), width=1)), ("dots", dict(n=30, cols=[(180, 220, 255, 230), (220, 190, 255, 220)], glow_col=(120, 190, 255)))]),
                dict(tint=(4, 4, 6), ops=[("cracks", dict(n=4, color=(34, 36, 58, 230), width=1)), ("dots", dict(n=40, cols=[(200, 232, 255, 230)]))]),
                dict(tint=(-4, -4, -2), ops=[("dots", dict(n=50, cols=[(160, 210, 255, 220), (230, 200, 255, 200)], glow_col=(150, 120, 255)))]),
                dict(tint=(0, 0, 0), ops=[("shards", dict(n=3, cols=[(120, 200, 255), (170, 130, 255)], glow_col=(120, 180, 255)))]),
                dict(tint=(0, 0, 0), ops=[("shards", dict(n=5, cols=[(255, 140, 220), (130, 220, 255)], glow_col=(200, 130, 255))), ("dots", dict(n=20, cols=[(255, 255, 255, 220)]))]),
                dict(tint=(0, 0, 0), ops=[("shards", dict(n=2, cols=[(110, 255, 220)], glow_col=(90, 230, 200))), ("cracks", dict(n=3, color=(100, 220, 255, 200), width=1, glow_col=(80, 190, 255)))]),
            ]),
        "marees_ground": dict(seed=231, dark=(142, 132, 104), mid=(172, 162, 130), lite=(200, 190, 158), grain=5.0, warm=(3, 2, -1),
            variants=[
                dict(tint=(0, 0, 0), ops=[("arcs", dict(n=8, color=(120, 112, 88), width=1, alpha=120, curve=5)), ("dots", dict(n=40, cols=[(120, 112, 90, 220), (210, 200, 170, 200)]))]),
                dict(tint=(4, 3, 0), ops=[("puddles", dict(n=1, col=(96, 190, 200, 150), rim=(90, 80, 60, 120)))]),
                dict(tint=(-5, -4, -3), ops=[("arcs", dict(n=10, color=(120, 112, 88), width=1, alpha=120)), ("pebbles", dict(n=3, cols=[(140, 130, 110)], size=(3, 6)))]),
                dict(tint=(0, 0, 0), ops=[("puddles", dict(n=2, col=(88, 186, 198, 160), rim=(90, 80, 60, 120), size=(8, 16))), ("dots", dict(n=20, cols=[(255, 240, 230, 255), (240, 190, 190, 255)], size=(1.6, 3)))]),
                dict(tint=(0, 0, 0), ops=[("pebbles", dict(n=4, cols=[(248, 238, 226), (236, 200, 196), (210, 196, 180)], size=(2.5, 5), shadow=True))]),
                dict(tint=(-2, -1, 0), ops=[("cracks", dict(n=4, color=(50, 100, 60, 230), width=2, steps=(4, 7))), ("puddles", dict(n=1, col=(88, 186, 198, 150), rim=(90, 80, 60, 120), size=(8, 13)))]),
            ]),
        "vents_ground": dict(seed=241, dark=(142, 170, 108), mid=(176, 198, 130), lite=(208, 222, 158), grain=5.0, warm=(2, 2, -2),
            variants=[
                dict(tint=(0, 0, 0), ops=[("tufts", dict(n=40, cols=[(120, 160, 90, 255), (170, 200, 120, 255)])), ("arcs", dict(n=3, color=(255, 255, 240), width=1, alpha=120))]),
                dict(tint=(4, 3, 0), ops=[("tufts", dict(n=50, cols=[(130, 170, 96, 255), (190, 214, 130, 255)]))]),
                dict(tint=(-4, -3, -2), ops=[("tufts", dict(n=30, cols=[(110, 150, 84, 255)])), ("pebbles", dict(n=2, cols=[(206, 202, 190)], size=(4, 8)))]),
                dict(tint=(0, 0, 0), ops=[("pebbles", dict(n=2, cols=[(214, 210, 198), (194, 192, 184)], size=(8, 14))), ("cracks", dict(n=2, color=(120, 120, 112, 200), width=1)), ("tufts", dict(n=20, cols=[(130, 170, 96, 255)]))]),
                dict(tint=(0, 0, 0), ops=[("arcs", dict(n=3, color=(255, 255, 255), width=3, alpha=220, length=(14, 22), curve=6)), ("arcs", dict(n=2, color=(150, 205, 255), width=2, alpha=200, length=(30, 50), curve=8)), ("tufts", dict(n=25, cols=[(130, 170, 96, 255)]))]),
                dict(tint=(0, 0, 0), ops=[("pebbles", dict(n=1, cols=[(206, 202, 190)], size=(12, 18))), ("tufts", dict(n=30, cols=[(120, 160, 90, 255), (190, 214, 130, 255)]))]),
            ]),
        "brasier_ground": dict(seed=251, dark=(34, 30, 32), mid=(56, 50, 52), lite=(82, 74, 74), grain=5.0, warm=(5, 0, -2),
            variants=[
                dict(tint=(0, 0, 0), ops=[("cracks", dict(n=3, color=(255, 120, 30, 255), glow_col=(255, 100, 20), width=2)), ("dots", dict(n=14, cols=[(255, 180, 60, 255), (255, 120, 30, 255)], glow_col=(255, 110, 30)))]),
                dict(tint=(3, 2, 2), ops=[("cracks", dict(n=2, color=(255, 130, 40, 255), glow_col=(255, 100, 20), width=2))]),
                dict(tint=(-4, -4, -4), ops=[("dots", dict(n=50, cols=[(90, 80, 78, 220), (30, 28, 30, 220)]))]),
                dict(tint=(0, 0, 0), ops=[("cracks", dict(n=4, color=(255, 110, 25, 255), glow_col=(255, 90, 20), width=2, steps=(6, 11)))]),
                dict(tint=(0, 0, 0), ops=[("pebbles", dict(n=4, cols=[(70, 62, 62), (96, 86, 84)], size=(4, 9))), ("dots", dict(n=12, cols=[(255, 170, 50, 255)], glow_col=(255, 110, 30)))]),
                dict(tint=(0, 0, 0), ops=[("cracks", dict(n=5, color=(255, 90, 20, 255), glow_col=(255, 80, 10), width=3, steps=(7, 12))), ("dots", dict(n=22, cols=[(255, 200, 80, 255), (255, 120, 30, 255)], glow_col=(255, 120, 30)))]),
            ]),
        "brumes_ground": dict(seed=261, dark=(48, 66, 54), mid=(68, 90, 70), lite=(92, 116, 86), grain=5.0, warm=(0, 2, 2),
            variants=[
                dict(tint=(0, 0, 0), ops=[("arcs", dict(n=6, color=(36, 52, 40), width=2, alpha=150, curve=5)), ("tufts", dict(n=25, cols=[(70, 110, 80, 255), (100, 140, 96, 255)]))]),
                dict(tint=(4, 4, 2), ops=[("puddles", dict(n=2, col=(40, 62, 66, 200), rim=(30, 44, 36, 140), size=(8, 16))), ("tufts", dict(n=20, cols=[(80, 120, 86, 255)]))]),
                dict(tint=(-4, -3, -2), ops=[("arcs", dict(n=8, color=(34, 48, 38), width=2, alpha=150)), ("pebbles", dict(n=2, cols=[(78, 88, 80)], size=(4, 8), moss=(70, 120, 76, 230)))]),
                dict(tint=(0, 0, 0), ops=[("shards", dict(n=0, cols=[(90, 255, 200)], glow_col=(90, 230, 200))), ("dots", dict(n=14, cols=[(120, 255, 210, 255), (180, 140, 255, 255)], glow_col=(110, 230, 200)))]),
                dict(tint=(0, 0, 0), ops=[("puddles", dict(n=1, col=(38, 58, 62, 210), rim=(28, 40, 34, 150), size=(12, 20))), ("dots", dict(n=10, cols=[(130, 255, 220, 255)], glow_col=(110, 240, 210)))]),
                dict(tint=(0, 0, 0), ops=[("mushrooms_glow", {}), ("tufts", dict(n=15, cols=[(80, 120, 86, 255)]))]),
            ]),
        "ombres_ground": dict(seed=271, dark=(48, 42, 64), mid=(70, 60, 92), lite=(98, 86, 120), grain=5.0, warm=(3, 0, 5), seams=(30, 26, 42),
            variants=[
                dict(tint=(0, 0, 0), ops=[("glyphs", dict(n=2, color=(190, 170, 240, 190)))]),
                dict(tint=(4, 3, 6), ops=[("cracks", dict(n=2, color=(28, 24, 40, 230), width=1))]),
                dict(tint=(-4, -3, -3), ops=[("cracks", dict(n=3, color=(110, 60, 150, 255), width=2, steps=(5, 9), glow_col=(150, 80, 210))), ("dots", dict(n=20, cols=[(40, 36, 52, 220)]))]),
                dict(tint=(0, 0, 0), ops=[("glyphs", dict(n=3, color=(200, 180, 255, 210))), ("cracks", dict(n=2, color=(28, 24, 40, 230), width=1))]),
                dict(tint=(0, 0, 0), ops=[("cracks", dict(n=4, color=(120, 60, 160, 255), width=2, glow_col=(150, 80, 210))), ("pebbles", dict(n=2, cols=[(60, 54, 74)], size=(4, 7)))]),
                dict(tint=(0, 0, 0), ops=[("glyphs", dict(n=4, color=(210, 190, 255, 230))), ("dots", dict(n=14, cols=[(170, 140, 240, 255)], glow_col=(150, 110, 230)))]),
            ]),
        "rouages_ground": dict(seed=281, dark=(92, 100, 108), mid=(120, 128, 136), lite=(152, 160, 166), grain=4.0, warm=(-1, 1, 3), seams=(60, 66, 74),
            variants=[
                dict(tint=(0, 0, 0), ops=[("rivets", {}), ("arcs", dict(n=4, color=(200, 208, 214), width=1, alpha=70, curve=1))]),
                dict(tint=(4, 4, 4), ops=[("rivets", {}), ("dots", dict(n=40, cols=[(70, 76, 84, 200), (176, 182, 188, 200)], size=(0.8, 1.6)))]),
                dict(tint=(-4, -4, -3), ops=[("rivets", {}), ("cracks", dict(n=2, color=(50, 54, 60, 230), width=1, steps=(3, 6)))]),
                dict(tint=(0, 0, 0), ops=[("gear", dict(dark=(64, 70, 78, 255), lite=(168, 176, 184, 255)))]),
                dict(tint=(0, 0, 0), ops=[("rivets", {}), ("arcs", dict(n=3, color=(180, 100, 50), width=2, alpha=110, curve=2)), ("dots", dict(n=14, cols=[(150, 84, 44, 200)], size=(1.5, 3)))]),
                dict(tint=(0, 0, 0), ops=[("gear", dict(dark=(60, 66, 74, 255), lite=(190, 150, 70, 255))), ("rivets", {})]),
            ]),
    }


def run_ops(img, rnd, ops):
    for name, p in ops:
        p = dict(p)
        if name == "arcs":
            col = p.pop("color")
            arcs(img, rnd, p.pop("n"), col, **p)
        elif name == "dots":
            dots(img, rnd, p.pop("n"), p.pop("cols"), **p)
        elif name == "pebbles":
            if p.get("n", 1) > 0:
                pebbles(img, rnd, p.pop("n"), p.pop("cols"), **p)
        elif name == "cracks":
            cracks(img, rnd, p.pop("n"), p.pop("color"), **p)
        elif name == "puddles":
            puddles(img, rnd, p.pop("n"), p.pop("col"), p.pop("rim"), **p)
        elif name == "shards":
            if p.get("n", 1) > 0:
                shards(img, rnd, p.pop("n"), p.pop("cols"), p.pop("glow_col"))
        elif name == "glyphs":
            glyphs(img, rnd, p.pop("n"), p.pop("color"))
        elif name == "gear":
            gear(img, rnd, p["dark"], p["lite"])
        elif name == "rivets":
            rivets(img, rnd, (150, 158, 166))
        elif name == "footprints":
            footprints(img, rnd)
        elif name == "tufts":
            tufts(img, rnd, p.pop("n"), p.pop("cols"), **p)
        elif name == "mushrooms_glow":
            xs = [F.center_pt(rnd, 40, 14) for _ in range(4)]
            glow(img, [(x, y - 3) for x, y in xs], (110, 240, 220), 10, 1.0)
            d = ImageDraw.Draw(img)
            for x, y in xs:
                d.rectangle([x - 1, y - 2, x + 1, y + 2], fill=(210, 230, 220, 255))
                d.pieslice([x - 4, y - 6, x + 4, y + 2], 180, 360, fill=(120, 240, 215, 255))
                d.ellipse([x - 1.6, y - 5.2, x - 0.4, y - 4.0], fill=(255, 255, 255, 255))


def edge_lighting(img):
    ov = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    od = ImageDraw.Draw(ov)
    od.line([(128, 3), (3, 64)], fill=(255, 255, 235, 66), width=3)
    od.line([(128, 3), (253, 64)], fill=(255, 255, 235, 38), width=3)
    od.line([(3, 64), (128, 125)], fill=(10, 14, 24, 50), width=3)
    od.line([(253, 64), (128, 125)], fill=(10, 14, 24, 90), width=3)
    ov = ov.filter(ImageFilter.GaussianBlur(1.2))
    alpha = img.getchannel("A")
    merged = Image.alpha_composite(img, ov)
    merged.putalpha(alpha)
    return merged


def build(only=None):
    for prefix, sp in specs().items():
        if only and prefix not in only and prefix.split("_")[0] not in only:
            continue
        base = base_ground(sp)
        for i, v in enumerate(sp["variants"], 1):
            rnd = random.Random(sp["seed"] * 10 + i)
            img = F.to_diamond(base, v["tint"])
            run_ops(img, rnd, v["ops"])
            out = edge_lighting(img)
            os.makedirs(OUT, exist_ok=True)
            out.save(os.path.join(OUT, "%s_%02d.png" % (prefix, i)), optimize=True)
        print(prefix, "ok")


if __name__ == "__main__":
    build(sys.argv[1:] or None)
