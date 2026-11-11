#!/usr/bin/env python3
"""gen_nation_tiles.py — Tuiles de sol (SVG 128x64, losange isométrique) des nations.

Huit biomes : cristaux, marees, vents, brasier, brumes, ombres, montagne (Cimes, V144), forêt (Sylve, V150) — 6 variantes chacun
(déterministes). Brasier, Brumes, Cimes et Sylve ont 3 niveaux de détail (voir `tier`).
Chaque nation a sa particularité visuelle : éclats lumineux, sable mouillé, traînées de vent,
fissures de lave, mousse et brume, runes sombres. Les trois premiers biomes (forêt, montagne,
désert) gardent leurs tuiles d'origine, sauf la montagne (V144) et la forêt (V150).
Usage : python3 tools/gen_nation_tiles.py [nation…]
"""
import os, math, random

HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, "..", "assets", "sprites", "tiles")

DIAMOND = "M64 1 127 32 64 63 1 32Z"

def inside(x, y, m=0.0):
    return abs(x - 64) / (63 - m) + abs(y - 32) / (31 - m) < 1.0

def pts(r, n, margin=10):
    out = []
    tries = 0
    while len(out) < n and tries < 400:
        tries += 1
        x, y = r.uniform(8, 120), r.uniform(5, 59)
        if inside(x, y, margin):
            out.append((x, y))
    return out

def svg(base_a, base_b, body, edge, glow=None, lit=.16):
    g = f'<radialGradient id="gl" cx="0.5" cy="0.5" r="0.5"><stop stop-color="{glow}" stop-opacity=".35"/><stop offset="1" stop-color="{glow}" stop-opacity="0"/></radialGradient>' if glow else ""
    lit_s = ("%.2f" % lit).lstrip("0")
    return (f'<svg xmlns="http://www.w3.org/2000/svg" width="128" height="64" viewBox="0 0 128 64"><defs>'
            f'<clipPath id="d"><path d="{DIAMOND}"/></clipPath><linearGradient id="g" x1="0" y1="0" x2="0" y2="1"><stop stop-color="{base_a}"/><stop offset="1" stop-color="{base_b}"/></linearGradient>'
            f'<linearGradient id="lit" x1="0" y1="0" x2="0" y2="1"><stop stop-color="#ffffff" stop-opacity="{lit_s}"/><stop offset="1" stop-color="#ffffff" stop-opacity="0"/></linearGradient>{g}</defs>'
            f'<g clip-path="url(#d)"><rect width="128" height="64" fill="url(#g)"/><path d="M0 32 64 1 128 32 64 63Z" fill="url(#lit)"/>{body}'
            f'<path d="{DIAMOND}" fill="none" stroke="{edge}" stroke-opacity=".7" stroke-width="1.2"/><path d="M64 2 123 32 64 61 5 32Z" fill="none" stroke="#ffffff" stroke-opacity=".12"/></g></svg>')

def cristaux(i, r):
    b = ""
    for (x, y) in pts(r, 7):          # dalles d'ardoise
        b += f'<path d="M{x-9:.1f} {y:.1f} l9 -4 9 4 -9 4Z" fill="#000" opacity=".10"/>'
    for (x, y) in pts(r, 4 + i % 3, 14):   # éclats lumineux
        h = r.uniform(5, 11)
        col = r.choice(["#8be9ff", "#c9a2ff", "#7a9bff", "#ff9be6"])
        b += (f'<ellipse cx="{x:.1f}" cy="{y+1:.1f}" rx="{h*0.9:.1f}" ry="{h*0.35:.1f}" fill="{col}" opacity=".22"/>'
              f'<path d="M{x:.1f} {y-h:.1f} L{x+h*0.38:.1f} {y-h*0.2:.1f} L{x+h*0.22:.1f} {y+1:.1f} L{x-h*0.22:.1f} {y+1:.1f} L{x-h*0.38:.1f} {y-h*0.2:.1f}Z" fill="{col}" stroke="#ffffff" stroke-opacity=".7" stroke-width=".7"/>'
              f'<path d="M{x:.1f} {y-h:.1f} L{x+h*0.1:.1f} {y-h*0.1:.1f}" stroke="#fff" stroke-opacity=".8" stroke-width=".8"/>')
    for (x, y) in pts(r, 9, 6):
        b += f'<circle cx="{x:.1f}" cy="{y:.1f}" r="{r.uniform(.5,1.2):.1f}" fill="#fff" opacity=".7"/>'
    return svg("#4b4390", "#2c2760", b, "#8f86e0", "#a58bff")

def marees(i, r):
    b = ""
    for k in range(3 + i % 3):        # nappes d'eau peu profonde
        x, y = pts(r, 1, 18)[0]
        rx, ry = r.uniform(12, 26), r.uniform(4, 8)
        b += (f'<ellipse cx="{x:.1f}" cy="{y:.1f}" rx="{rx:.1f}" ry="{ry:.1f}" fill="#58c7d6" opacity=".55"/>'
              f'<ellipse cx="{x-2:.1f}" cy="{y-1:.1f}" rx="{rx*0.7:.1f}" ry="{ry*0.6:.1f}" fill="#9aeaf0" opacity=".5"/>'
              f'<path d="M{x-rx*0.6:.1f} {y:.1f} q{rx*0.3:.1f} -{ry*0.6:.1f} {rx*0.6:.1f} 0" stroke="#fff" stroke-opacity=".7" stroke-width="1" fill="none"/>')
    for (x, y) in pts(r, 7):          # rides de sable
        b += f'<path d="M{x-8:.1f} {y:.1f} q8 3 16 0" stroke="#b9a673" stroke-width="1.1" fill="none" opacity=".55"/>'
    for (x, y) in pts(r, 3, 14):      # coquillages / étoile de mer
        c = r.choice(["#f4cfc0", "#f0e6d0", "#f08a7a"])
        b += f'<path d="M{x:.1f} {y-2.5:.1f} q4 1 3 4 q-3 1 -6 0 q-1 -3 3 -4Z" fill="{c}" stroke="#9a7f5a" stroke-width=".6"/>'
    return svg("#eadfb2", "#cdbf8c", b, "#a89868", None)

def vents(i, r):
    b = ""
    for k in range(5 + i % 3):        # traînées de vent
        x, y = pts(r, 1, 12)[0]
        L = r.uniform(18, 36)
        b += (f'<path d="M{x-L/2:.1f} {y:.1f} q{L*0.35:.1f} -5 {L*0.7:.1f} -1 q4 2 0 5" stroke="#ffffff" stroke-width="1.6" fill="none" opacity=".75" stroke-linecap="round"/>')
    for (x, y) in pts(r, 6):          # herbe rase pâle
        b += f'<path d="M{x:.1f} {y:.1f} l-1.5 -4 M{x:.1f} {y:.1f} l1.5 -4" stroke="#7fa88f" stroke-width="1.1" opacity=".8"/>'
    for (x, y) in pts(r, 2, 16):      # plumes
        b += f'<path d="M{x:.1f} {y:.1f} q6 -6 12 -2 q-6 5 -12 2Z" fill="#fff" opacity=".7" stroke="#b9cfd2" stroke-width=".6"/>'
    return svg("#bcd6cc", "#8fb3ae", b, "#6f9aa0", None)

def tier(i):
    """V144 : 3 niveaux de détail par nation. Variantes 1-3 = sol CALME (le fond du plateau), 4-5 = un
    détail, 6 = case « accident » (fissure de lave, flaque, plaque de glace). Cell.gd tire les calmes le
    plus souvent : le motif de la nation ne se répète plus sur toutes les cases."""
    return 0 if i < 3 else (1 if i < 5 else 2)

def crack(r, x, y, n, sx=10.0, sy=4.5):
    p = [(x, y)]
    for s in range(n):
        x += r.uniform(-sx * 0.8, sx); y += r.uniform(-sy, sy)
        p.append((x, y))
    return "M" + " L".join(f"{a:.1f} {c:.1f}" for a, c in p)

def brasier(i, r):
    t = tier(i)
    b = ""
    for (x, y) in pts(r, 5):          # blocs de basalte
        b += f'<path d="M{x-8:.1f} {y:.1f} l8 -3.5 8 3.5 -8 3.5Z" fill="#000" opacity=".15"/>'
    for (x, y) in pts(r, 9, 6):       # flocons de cendre
        b += f'<ellipse cx="{x:.1f}" cy="{y:.1f}" rx="{r.uniform(1.0,2.4):.1f}" ry="{r.uniform(.5,1.0):.1f}" fill="#9a8a82" opacity=".30"/>'
    if t == 1:                        # une fissure fine, à peine rougeoyante
        d = crack(r, *pts(r, 1, 18)[0], 3, 8.0, 3.5)
        b += (f'<path d="{d}" stroke="#1a0f0e" stroke-width="2.0" fill="none" opacity=".7" stroke-linecap="round" stroke-linejoin="round"/>'
              f'<path d="{d}" stroke="#ff7a2a" stroke-width=".8" fill="none" opacity=".75" stroke-linecap="round" stroke-linejoin="round"/>')
    if t == 2:                        # case accident : lave à vif
        b += '<ellipse cx="64" cy="32" rx="44" ry="20" fill="url(#gl)"/>'
        for k in range(3):
            d = crack(r, *pts(r, 1, 20)[0], 5)
            b += (f'<path d="{d}" stroke="#ff6a1a" stroke-width="3.4" fill="none" opacity=".40" stroke-linecap="round" stroke-linejoin="round"/>'
                  f'<path d="{d}" stroke="#ffb347" stroke-width="1.6" fill="none" stroke-linecap="round" stroke-linejoin="round"/>'
                  f'<path d="{d}" stroke="#fff3b0" stroke-width=".6" fill="none" opacity=".9"/>')
    for (x, y) in pts(r, 2 + t * 3, 8):   # braises
        b += f'<circle cx="{x:.1f}" cy="{y:.1f}" r="{r.uniform(.5,1.1):.1f}" fill="#ff9a3c" opacity=".8"/>'
    base = [("#4b3d3a", "#3a2e2c"), ("#51423e", "#3e3230"), ("#463835", "#352a29")][i % 3]
    return svg(base[0], base[1], b, "#8a5a44", "#ff7a2a", lit=.08)

def brumes(i, r):
    t = tier(i)
    b = ""
    for (x, y) in pts(r, 3 + t):      # plaques de mousse
        b += f'<ellipse cx="{x:.1f}" cy="{y:.1f}" rx="{r.uniform(6,12):.1f}" ry="{r.uniform(2.5,5):.1f}" fill="#8fbf7a" opacity=".32"/>'
    for k in range(2):                # volutes de brume
        x, y = pts(r, 1, 8)[0]
        b += f'<ellipse cx="{x:.1f}" cy="{y:.1f}" rx="{r.uniform(14,26):.1f}" ry="{r.uniform(3,6):.1f}" fill="#ffffff" opacity=".13"/>'
    if t == 2:                        # case accident : flaque sombre
        x, y = 64 + r.uniform(-10, 10), 33 + r.uniform(-4, 4)
        b += (f'<ellipse cx="{x:.1f}" cy="{y:.1f}" rx="26" ry="10" fill="#2f4f52" opacity=".85"/>'
              f'<ellipse cx="{x-3:.1f}" cy="{y-1.5:.1f}" rx="19" ry="6.5" fill="#4f8088" opacity=".8"/>'
              f'<path d="M{x-14:.1f} {y-2:.1f} q8 -4 17 -1" stroke="#d8f5ea" stroke-opacity=".7" stroke-width="1" fill="none" stroke-linecap="round"/>')
    for (x, y) in pts(r, [0, 1, 3][t], 14):      # champignons pâles lumineux
        c = r.choice(["#d9f2ff", "#f3d9ff", "#e8ffd9"])
        b += (f'<rect x="{x-.8:.1f}" y="{y-3:.1f}" width="1.6" height="3.4" fill="#e9e4d2"/>'
              f'<ellipse cx="{x:.1f}" cy="{y-3.2:.1f}" rx="3.6" ry="2.2" fill="{c}" stroke="#6a8a8a" stroke-width=".5"/>'
              f'<ellipse cx="{x:.1f}" cy="{y+1:.1f}" rx="6" ry="2" fill="{c}" opacity=".18"/>')
    base = [("#648b81", "#557a70"), ("#6a9186", "#597e74"), ("#5f857b", "#50736a")][i % 3]
    return svg(base[0], base[1], b, "#9fc6b8", "#d8f5ea", lit=.10)

def montagne(i, r):
    """Cimes : neige (V144). Avant : roche grise avec la même congère sur chaque case."""
    t = tier(i)
    b = ""
    for (x, y) in pts(r, 3):          # creux d'ombre bleutée dans la neige
        b += f'<ellipse cx="{x:.1f}" cy="{y:.1f}" rx="{r.uniform(10,20):.1f}" ry="{r.uniform(3,6):.1f}" fill="#8fa8c8" opacity=".20"/>'
    for (x, y) in pts(r, 2, 10):      # bosses claires
        b += f'<ellipse cx="{x:.1f}" cy="{y:.1f}" rx="{r.uniform(8,15):.1f}" ry="{r.uniform(2.5,4.5):.1f}" fill="#ffffff" opacity=".55"/>'
    if t == 1:                        # roche qui affleure
        for (x, y) in pts(r, 2, 16):
            w = r.uniform(5, 8)
            b += (f'<path d="M{x-w:.1f} {y:.1f} l{w:.1f} -{w*0.42:.1f} {w:.1f} {w*0.42:.1f} -{w:.1f} {w*0.42:.1f}Z" fill="#7d8794"/>'
                  f'<path d="M{x-w:.1f} {y:.1f} l{w:.1f} -{w*0.42:.1f} {w*0.6:.1f} {w*0.25:.1f}" stroke="#ffffff" stroke-width="1.6" fill="none" opacity=".9" stroke-linecap="round"/>')
    if t == 2:                        # case accident : plaque de glace vive
        x, y = 64 + r.uniform(-8, 8), 33 + r.uniform(-3, 3)
        b += (f'<ellipse cx="{x:.1f}" cy="{y:.1f}" rx="27" ry="10.5" fill="#7fc4e6" opacity=".85"/>'
              f'<ellipse cx="{x-3:.1f}" cy="{y-1.5:.1f}" rx="20" ry="7" fill="#b9e6f7" opacity=".85"/>'
              f'<path d="M{x-15:.1f} {y-3:.1f} q9 -4 19 -1" stroke="#ffffff" stroke-width="1.4" fill="none" stroke-linecap="round"/>'
              f'<path d="{crack(r, x - 8, y + 1, 3, 7.0, 2.5)}" stroke="#4a8fb8" stroke-width=".8" fill="none" opacity=".8" stroke-linejoin="round"/>')
    for (x, y) in pts(r, 6, 6):       # scintillements
        b += f'<circle cx="{x:.1f}" cy="{y:.1f}" r="{r.uniform(.4,.9):.1f}" fill="#fff" opacity=".9"/>'
    base = [("#e9f0f8", "#d6e1ee"), ("#eef4fa", "#dbe5f0"), ("#e3ecf6", "#d0dcea")][i % 3]
    return svg(base[0], base[1], b, "#9fb2c8", None, lit=.10)

def ombres(i, r):
    b = ""
    for (x, y) in pts(r, 7):          # pavés sombres
        b += f'<path d="M{x-9:.1f} {y:.1f} l9 -4 9 4 -9 4Z" fill="#000" opacity=".2" stroke="#8a6ac0" stroke-opacity=".25" stroke-width=".7"/>'
    for (x, y) in pts(r, 2 + i % 2, 20):   # runes violettes
        s = r.uniform(4, 6)
        b += (f'<path d="M{x:.1f} {y-s:.1f} L{x:.1f} {y+s:.1f} M{x-s*.7:.1f} {y-s*.2:.1f} L{x+s*.7:.1f} {y+s*.2:.1f} M{x-s*.7:.1f} {y+s*.6:.1f} L{x:.1f} {y-s*.4:.1f}" stroke="#c39bff" stroke-width="1.2" fill="none" opacity=".85" stroke-linecap="round"/>'
              f'<circle cx="{x:.1f}" cy="{y:.1f}" r="{s*1.4:.1f}" fill="none" stroke="#a070ff" stroke-opacity=".35" stroke-width=".8"/>')
    for k in range(2):                # fissures
        x, y = pts(r, 1, 14)[0]
        b += f'<path d="M{x:.1f} {y:.1f} l{r.uniform(-12,12):.1f} {r.uniform(-4,4):.1f} l{r.uniform(-9,9):.1f} {r.uniform(-3,3):.1f}" stroke="#12081f" stroke-width="1.4" fill="none" opacity=".7"/>'
    return svg("#4d3d6b", "#2b2042", b, "#8c6cd0", "#9a6aff")

def foret(i, r):
    """Sylve (V150) : herbe en 3 niveaux comme les autres nations. Calme : herbe aux plaques douces et quelques
    brins ; détail : fleurs des prés ou trèfles et un caillou ; accident : clairière de mousse et terre nue
    avec une racine et un cercle de champignons."""
    t = tier(i)
    b = ""
    for (x, y) in pts(r, 3):          # plaques d'herbe plus sombres
        b += f'<ellipse cx="{x:.1f}" cy="{y:.1f}" rx="{r.uniform(9,18):.1f}" ry="{r.uniform(3,6):.1f}" fill="#3f6b32" opacity=".22"/>'
    for (x, y) in pts(r, 2, 10):      # reflets clairs
        b += f'<ellipse cx="{x:.1f}" cy="{y:.1f}" rx="{r.uniform(7,13):.1f}" ry="{r.uniform(2,4):.1f}" fill="#b6d47a" opacity=".38"/>'
    for (x, y) in pts(r, 4 + t * 2, 8):   # brins d'herbe
        b += f'<path d="M{x:.1f} {y:.1f} l-1.6 -4.2 M{x:.1f} {y:.1f} l.4 -5 M{x:.1f} {y:.1f} l2.2 -3.6" stroke="#36622f" stroke-width="1.1" fill="none" stroke-linecap="round" opacity=".85"/>'
    if t == 1:
        if i % 2:                     # fleurs des prés
            for (x, y) in pts(r, 5, 14):
                c = r.choice(["#fff4a8", "#ffffff", "#f3b2c4"])
                b += f'<circle cx="{x:.1f}" cy="{y:.1f}" r="1.5" fill="{c}"/><circle cx="{x:.1f}" cy="{y:.1f}" r=".6" fill="#e0a83a"/>'
        else:                         # trèfles et un caillou
            for (x, y) in pts(r, 3, 14):
                b += "".join(f'<circle cx="{x+dx:.1f}" cy="{y+dy:.1f}" r="1.6" fill="#4f8a3c"/>' for dx, dy in [(-1.4, 0), (1.4, 0), (0, -1.2)])
            x, y = pts(r, 1, 18)[0]
            b += (f'<ellipse cx="{x:.1f}" cy="{y+1:.1f}" rx="5" ry="2" fill="#000" opacity=".18"/>'
                  f'<ellipse cx="{x:.1f}" cy="{y:.1f}" rx="4.4" ry="2.6" fill="#9a9a8e"/><ellipse cx="{x-1:.1f}" cy="{y-.8:.1f}" rx="2.2" ry="1" fill="#c9c9bc"/>')
    if t == 2:                        # case accident : clairière de mousse, terre nue, racine, champignons
        x, y = 64 + r.uniform(-8, 8), 33 + r.uniform(-3, 3)
        b += (f'<ellipse cx="{x:.1f}" cy="{y:.1f}" rx="26" ry="10" fill="#6b5233" opacity=".85"/>'
              f'<ellipse cx="{x+3:.1f}" cy="{y-1:.1f}" rx="17" ry="6" fill="#80653f" opacity=".85"/>'
              f'<path d="M{x-20:.1f} {y+2:.1f} q10 -6 20 -2 t18 -3" stroke="#4a3420" stroke-width="2.6" fill="none" stroke-linecap="round"/>'
              f'<path d="M{x-20:.1f} {y+2:.1f} q10 -6 20 -2 t18 -3" stroke="#8a6a44" stroke-width="1" fill="none" stroke-linecap="round" opacity=".8"/>')
        for k in range(5):            # cercle de champignons
            a = k / 5 * math.tau + .4
            mx, my = x + math.cos(a) * 15, y + math.sin(a) * 5.5
            b += (f'<rect x="{mx-.7:.1f}" y="{my-2.6:.1f}" width="1.4" height="2.8" fill="#efe6cf"/>'
                  f'<ellipse cx="{mx:.1f}" cy="{my-2.8:.1f}" rx="2.6" ry="1.6" fill="#d8503a"/><circle cx="{mx-.7:.1f}" cy="{my-3.1:.1f}" r=".45" fill="#fff"/>')
    base = [("#86b45a", "#6c9a47"), ("#8cb95f", "#71a04b"), ("#81ae56", "#679443")][i % 3]
    return svg(base[0], base[1], b, "#3d6634", None, lit=.14)

GEN = {"cristaux": cristaux, "marees": marees, "vents": vents, "brasier": brasier, "brumes": brumes, "ombres": ombres, "mountain": montagne, "forest": foret}

if __name__ == "__main__":
    os.makedirs(OUT, exist_ok=True)
    import sys
    only = sys.argv[1:]              # ex. : python3 tools/gen_nation_tiles.py brasier brumes mountain
    for name, fn in GEN.items():
        if only and name not in only:
            continue
        for i in range(6):
            r = random.Random(hash(name) % 1000 * 0 + sum(map(ord, name)) * 31 + i * 977)
            with open(os.path.join(OUT, f"{name}_ground_{i+1:02d}.svg"), "w", encoding="utf-8") as f:
                f.write(fn(i, r))
        print("tuiles", name)
