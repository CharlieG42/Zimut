#!/usr/bin/env python3
"""gen_nation_tiles.py — Tuiles de sol (SVG 128x64, losange isométrique) des nations.

Six biomes : cristaux, marees, vents, brasier, brumes, ombres — 6 variantes chacun (déterministes).
Chaque nation a sa particularité visuelle : éclats lumineux, sable mouillé, traînées de vent,
fissures de lave, mousse et brume, runes sombres. Les trois premiers biomes (forêt, montagne,
désert) gardent leurs tuiles d'origine.
Usage : python3 tools/gen_nation_tiles.py
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

def svg(base_a, base_b, body, edge, glow=None):
    g = f'<radialGradient id="gl" cx="0.5" cy="0.5" r="0.5"><stop stop-color="{glow}" stop-opacity=".35"/><stop offset="1" stop-color="{glow}" stop-opacity="0"/></radialGradient>' if glow else ""
    return (f'<svg xmlns="http://www.w3.org/2000/svg" width="128" height="64" viewBox="0 0 128 64"><defs>'
            f'<clipPath id="d"><path d="{DIAMOND}"/></clipPath><linearGradient id="g" x1="0" y1="0" x2="0" y2="1"><stop stop-color="{base_a}"/><stop offset="1" stop-color="{base_b}"/></linearGradient>'
            f'<linearGradient id="lit" x1="0" y1="0" x2="0" y2="1"><stop stop-color="#ffffff" stop-opacity=".16"/><stop offset="1" stop-color="#ffffff" stop-opacity="0"/></linearGradient>{g}</defs>'
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

def brasier(i, r):
    b = ""
    for (x, y) in pts(r, 6):          # blocs de basalte
        b += f'<path d="M{x-8:.1f} {y:.1f} l8 -3.5 8 3.5 -8 3.5Z" fill="#000" opacity=".22"/>'
    for k in range(3 + i % 2):        # fissures de lave
        x, y = pts(r, 1, 16)[0]
        p = [(x, y)]
        for s in range(5):
            x += r.uniform(-9, 11); y += r.uniform(-4, 5)
            p.append((x, y))
        d = "M" + " L".join(f"{a:.1f} {c:.1f}" for a, c in p)
        b += (f'<path d="{d}" stroke="#ff6a1a" stroke-width="3.2" fill="none" opacity=".35" stroke-linecap="round"/>'
              f'<path d="{d}" stroke="#ffb347" stroke-width="1.5" fill="none" stroke-linecap="round" stroke-linejoin="round"/>'
              f'<path d="{d}" stroke="#fff3b0" stroke-width=".6" fill="none" opacity=".9"/>')
    for (x, y) in pts(r, 7, 8):
        b += f'<circle cx="{x:.1f}" cy="{y:.1f}" r="{r.uniform(.5,1.1):.1f}" fill="#ff9a3c" opacity=".8"/>'
    return svg("#4a3532", "#241818", b, "#c25a2a", "#ff7a2a")

def brumes(i, r):
    b = ""
    for (x, y) in pts(r, 5):          # plaques de mousse
        b += f'<ellipse cx="{x:.1f}" cy="{y:.1f}" rx="{r.uniform(6,12):.1f}" ry="{r.uniform(2.5,5):.1f}" fill="#8fbf7a" opacity=".5"/>'
    for (x, y) in pts(r, 3, 14):      # champignons pâles lumineux
        c = r.choice(["#d9f2ff", "#f3d9ff", "#e8ffd9"])
        b += (f'<rect x="{x-.8:.1f}" y="{y-3:.1f}" width="1.6" height="3.4" fill="#e9e4d2"/>'
              f'<ellipse cx="{x:.1f}" cy="{y-3.2:.1f}" rx="3.6" ry="2.2" fill="{c}" stroke="#6a8a8a" stroke-width=".5"/>'
              f'<ellipse cx="{x:.1f}" cy="{y+1:.1f}" rx="6" ry="2" fill="{c}" opacity=".18"/>')
    for k in range(4):                # volutes de brume
        x, y = pts(r, 1, 8)[0]
        b += f'<ellipse cx="{x:.1f}" cy="{y:.1f}" rx="{r.uniform(14,26):.1f}" ry="{r.uniform(3,6):.1f}" fill="#ffffff" opacity=".22"/>'
    return svg("#6f958a", "#48675f", b, "#9fc6b8", "#d8f5ea")

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

GEN = {"cristaux": cristaux, "marees": marees, "vents": vents, "brasier": brasier, "brumes": brumes, "ombres": ombres}

if __name__ == "__main__":
    os.makedirs(OUT, exist_ok=True)
    for name, fn in GEN.items():
        for i in range(6):
            r = random.Random(hash(name) % 1000 * 0 + sum(map(ord, name)) * 31 + i * 977)
            with open(os.path.join(OUT, f"{name}_ground_{i+1:02d}.svg"), "w", encoding="utf-8") as f:
                f.write(fn(i, r))
        print("tuiles", name)
