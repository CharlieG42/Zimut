#!/usr/bin/env python3
"""Génère les illustrations des modes « 3D » et « Cartes » de Mes Parties (V400).

Illustrations vectorielles ORIGINALES (aucun asset externe) : un îlot de cubes en
perspective isométrique pour le monde 3D, un éventail de cartes sur un tapis pour
le mode Cartes. Sortie : assets/ui/modes/mode_monde3d.{svg,png} et mode_cartes.{svg,png}
(PNG 960x540 via rsvg-convert). Usage : python3 tools/gen_mode_art.py
"""
import math
import random
import subprocess
from pathlib import Path

OUT = Path(__file__).resolve().parent.parent / "assets" / "ui" / "modes"
W, H = 480, 270


def shade(hexcol, f):
    h = hexcol.lstrip("#")
    r, g, b = (int(h[i:i + 2], 16) for i in (0, 2, 4))
    f = max(0.0, f)
    return "#%02x%02x%02x" % tuple(min(255, int(c * f)) for c in (r, g, b))


def poly(pts, fill, stroke=None, sw=1):
    p = " ".join("%.1f,%.1f" % q for q in pts)
    s = ' stroke="%s" stroke-width="%s" stroke-linejoin="round"' % (stroke, sw) if stroke else ""
    return '<polygon points="%s" fill="%s"%s/>' % (p, fill, s)


# ───────────────────────── Monde 3D : îlot de cubes ─────────────────────────
def art_3d():
    rnd = random.Random(7)
    tw, th, tz = 22.0, 11.0, 10.0   # demi-largeur, demi-hauteur du losange, hauteur d'un cube
    ox, oy = 250.0, 96.0
    n = 9

    def proj(x, y, z):
        return (ox + (x - y) * tw, oy + (x + y) * th - z * tz)

    def cube(x, y, z, top, side_f=1.0):
        a = proj(x, y, z + 1)
        b = proj(x + 1, y, z + 1)
        c = proj(x + 1, y + 1, z + 1)
        d = proj(x, y + 1, z + 1)
        b0 = proj(x + 1, y, z)
        c0 = proj(x + 1, y + 1, z)
        d0 = proj(x, y + 1, z)
        out = []
        out.append(poly([d, c, c0, d0], shade(top, 0.62 * side_f), shade(top, 0.45), 0.6))   # face gauche
        out.append(poly([c, b, b0, c0], shade(top, 0.46 * side_f), shade(top, 0.34), 0.6))   # face droite
        out.append(poly([a, b, c, d], top, shade(top, 0.78), 0.6))                           # dessus
        return "".join(out)

    heights = {}
    kinds = {}
    for x in range(n):
        for y in range(n):
            cx, cy = x - (n - 1) / 2, y - (n - 1) / 2
            r = math.hypot(cx, cy)
            if r > 4.2:
                continue
            h = 1 + (1 if math.sin(x * 0.9) + math.cos(y * 1.1) > 0.9 else 0) + (1 if r < 1.7 and (x + y) % 2 == 0 else 0)
            heights[(x, y)] = h
            kinds[(x, y)] = "grass"
    # rivière en diagonale
    for k in range(n):
        for (x, y) in ((k, n // 2 + (k % 2) - 1), (k, n // 2 + (k % 2))):
            if (x, y) in heights:
                heights[(x, y)] = 1
                kinds[(x, y)] = "water"
    # chemin
    for (x, y) in ((2, 1), (2, 2), (3, 2), (3, 3), (4, 3), (5, 3)):
        if (x, y) in heights and kinds[(x, y)] == "grass":
            kinds[(x, y)] = "path"

    body = []
    body.append('<defs><linearGradient id="sky" x2="0" y2="1"><stop stop-color="#5fb6e8"/><stop offset=".62" stop-color="#bfe6f2"/><stop offset="1" stop-color="#f6efc6"/></linearGradient>'
                '<radialGradient id="sun"><stop stop-color="#fffbd0"/><stop offset=".45" stop-color="#ffe98a" stop-opacity=".9"/><stop offset="1" stop-color="#ffe98a" stop-opacity="0"/></radialGradient></defs>')
    body.append('<rect width="%d" height="%d" fill="url(#sky)"/>' % (W, H))
    body.append('<circle cx="396" cy="52" r="46" fill="url(#sun)"/>')
    for cx, cy, s in ((70, 48, 1.0), (330, 30, 0.7), (150, 92, 0.6)):
        body.append('<g fill="#ffffff" opacity=".9"><ellipse cx="%d" cy="%d" rx="%d" ry="%d"/><ellipse cx="%d" cy="%d" rx="%d" ry="%d"/><ellipse cx="%d" cy="%d" rx="%d" ry="%d"/></g>' % (
            cx, cy, 34 * s, 10 * s, cx + 22 * s, cy - 7 * s, 22 * s, 11 * s, cx - 20 * s, cy - 4 * s, 18 * s, 8 * s))
    # ombre portée de l'îlot
    body.append('<ellipse cx="250" cy="248" rx="130" ry="12" fill="#1b3a4d" opacity=".25"/>')
    # cubes de terre sous l'îlot (colonnes jusqu'à z = -2)
    order = sorted(heights, key=lambda p: (p[0] + p[1], p[0]))
    for (x, y) in order:
        for z in range(-1, heights[(x, y)] - 1):
            body.append(cube(x, y, z, "#8a5a3a"))
        top = {"grass": "#7fcf4e", "water": "#3fa9e6", "path": "#d9bd7a"}[kinds[(x, y)]]
        if kinds[(x, y)] == "grass" and (x * 3 + y) % 5 == 0:
            top = "#98dd58"
        body.append(cube(x, y, heights[(x, y)] - 1, top))
    # arbres low-poly (cônes à facettes)
    def tree(x, y, s=1.0):
        px, py = proj(x + 0.5, y + 0.5, heights[(x, y)])
        g = []
        g.append('<rect x="%.1f" y="%.1f" width="%.1f" height="%.1f" fill="#6b4226"/>' % (px - 2 * s, py - 8 * s, 4 * s, 9 * s))
        for i, (wd, hh, col) in enumerate(((17, 15, "#2f8f46"), (14, 14, "#37a352"), (10, 13, "#44b85e"))):
            y0 = py - 7 * s - i * 9 * s
            g.append(poly([(px - wd * s, y0), (px, y0 - hh * s), (px, y0 + 1)], shade(col, 0.78)))
            g.append(poly([(px + wd * s, y0), (px, y0 - hh * s), (px, y0 + 1)], col))
        return "".join(g)
    for (x, y) in order:
        if kinds[(x, y)] == "grass" and (x * 7 + y * 3) % 6 == 0 and (x, y) not in ((4, 4),):
            body.append(tree(x, y, 0.95 + rnd.random() * 0.25))
    # bâtisse (ruine) : tour de blocs
    bx, by = 6, 2
    if (bx, by) in heights:
        for i in range(3):
            body.append(cube(bx, by, heights[(bx, by)] + i, "#b9b2a5"))
        body.append(cube(bx, by, heights[(bx, by)] + 3, "#c96a4b"))
    # le joueur (petit personnage 3D) au premier plan sur le chemin
    px, py = proj(4.5, 4.0, heights.get((4, 4), 1))
    body.append('<ellipse cx="%.1f" cy="%.1f" rx="9" ry="4" fill="#000" opacity=".28"/>' % (px, py))
    body.append('<path d="M%.1f %.1f l-9 -22 h18 z" fill="#2e8b57" stroke="#1d5c39" stroke-width="1.2"/>' % (px, py - 2))   # cape
    body.append('<rect x="%.1f" y="%.1f" width="10" height="14" rx="3" fill="#e8c28a" stroke="#8a6a3a" stroke-width="1"/>' % (px - 5, py - 28))
    body.append('<circle cx="%.1f" cy="%.1f" r="8" fill="#f1d3a2" stroke="#8a6a3a" stroke-width="1.2"/>' % (px, py - 33))
    body.append('<path d="M%.1f %.1f q-2 -9 -8 -8 q2 7 8 8z" fill="#5fcf5f" stroke="#2a7a2a" stroke-width="1"/>' % (px, py - 40))   # pousse de feuille
    body.append('<circle cx="%.1f" cy="%.1f" r="1.3" fill="#222"/><circle cx="%.1f" cy="%.1f" r="1.3" fill="#222"/>' % (px - 3, py - 33, px + 3, py - 33))
    # repère « 3D » : trièdre d'axes en bas à gauche
    body.append('<g stroke-width="3" stroke-linecap="round" fill="none" opacity=".95">'
                '<path d="M40 238 L40 206" stroke="#7cdf5a"/><path d="M40 238 L70 252" stroke="#ff6b5a"/><path d="M40 238 L12 252" stroke="#5aa8ff"/></g>'
                '<circle cx="40" cy="238" r="3.5" fill="#fff"/>')
    return "".join(body)


# ───────────────────────── Cartes : éventail sur un tapis ─────────────────────────
def art_cards():
    b = []
    b.append('<defs>'
             '<radialGradient id="bg" cx=".5" cy=".42" r=".8"><stop stop-color="#5a3a8a"/><stop offset=".6" stop-color="#2a1a4e"/><stop offset="1" stop-color="#120a26"/></radialGradient>'
             '<linearGradient id="gold" x2="1" y2="1"><stop stop-color="#fff0a8"/><stop offset=".5" stop-color="#e0a93a"/><stop offset="1" stop-color="#8a5a12"/></linearGradient>'
             '<radialGradient id="aura"><stop stop-color="#ffe9a0" stop-opacity=".85"/><stop offset="1" stop-color="#ffe9a0" stop-opacity="0"/></radialGradient>'
             '<linearGradient id="felt" x2="0" y2="1"><stop stop-color="#3a8a6a"/><stop offset="1" stop-color="#1c4a3a"/></linearGradient>'
             '</defs>')
    b.append('<rect width="%d" height="%d" fill="url(#bg)"/>' % (W, H))
    # étoiles
    rnd = random.Random(11)
    for _ in range(46):
        x, y, r = rnd.uniform(0, W), rnd.uniform(0, 150), rnd.uniform(0.6, 1.8)
        b.append('<circle cx="%.1f" cy="%.1f" r="%.1f" fill="#fff" opacity="%.2f"/>' % (x, y, r, rnd.uniform(0.3, 0.9)))
    # tapis de jeu en perspective
    b.append('<path d="M-20 270 L80 168 H400 L500 270Z" fill="url(#felt)"/>')
    b.append('<path d="M80 168 H400" stroke="#d8b25a" stroke-width="2.5" opacity=".8"/>')
    b.append('<g stroke="#2a7a5a" stroke-width="1.2" opacity=".5"><path d="M240 168 V270 M160 168 L100 270 M320 168 L380 270 M20 220 H460"/></g>')
    # grille tactique sur le tapis (rappel du combat)
    for i in range(5):
        for j in range(3):
            cx = 240 + (i - 2) * 38 - (j - 1) * 4
            cy = 186 + j * 22
            b.append(poly([(cx, cy - 7), (cx + 17, cy), (cx, cy + 7), (cx - 17, cy)], "none", "#9fe3c4", 1))
    # halo derrière la carte centrale
    b.append('<ellipse cx="240" cy="112" rx="120" ry="95" fill="url(#aura)"/>')
    # cartes en éventail
    cards = [(-34, "#e2574c", "⚔"), (-17, "#4b8fe0", "✦"), (0, "#e5b93a", "♛"), (17, "#58b86a", "❦"), (34, "#9a5bd6", "☽")]
    for ang, col, sym in cards:
        lift = 0 if ang != 0 else -16
        g = ['<g transform="translate(240 236) rotate(%d) translate(0 %d)">' % (ang, -128 + lift)]
        g.append('<rect x="-37" y="-52" width="74" height="104" rx="8" fill="#000" opacity=".35" transform="translate(3 5)"/>')
        g.append('<rect x="-37" y="-52" width="74" height="104" rx="8" fill="#f6ecd2" stroke="url(#gold)" stroke-width="3"/>')
        g.append('<rect x="-31" y="-46" width="62" height="60" rx="5" fill="%s"/>' % col)
        g.append('<rect x="-31" y="-46" width="62" height="60" rx="5" fill="#fff" opacity=".18"/>')
        g.append('<circle cx="0" cy="-16" r="19" fill="#fff" opacity=".28"/>')
        g.append('<text x="0" y="-5" font-size="30" text-anchor="middle" fill="#fff" stroke="#00000055" stroke-width="1" font-family="DejaVu Sans, sans-serif">%s</text>' % sym)
        g.append('<rect x="-31" y="18" width="62" height="6" rx="3" fill="#cdb98a"/>')
        g.append('<rect x="-31" y="28" width="46" height="4" rx="2" fill="#d9c9a0"/><rect x="-31" y="36" width="54" height="4" rx="2" fill="#d9c9a0"/>')
        g.append('<circle cx="-30" cy="-45" r="11" fill="#2b6fd6" stroke="url(#gold)" stroke-width="2"/>')
        g.append('<text x="-30" y="-40" font-size="14" font-weight="bold" text-anchor="middle" fill="#fff" font-family="DejaVu Sans, sans-serif">%d</text>' % (abs(ang) // 17 + 1))
        g.append('</g>')
        b.append("".join(g))
    # cristaux de mana (ressource) au premier plan
    for k in range(5):
        x = 150 + k * 45
        col = "#59b6ff" if k < 4 else "#25456e"
        b.append(poly([(x, 242), (x + 9, 252), (x, 266), (x - 9, 252)], col, "#d9f1ff" if k < 4 else "#3a5a86", 1.2))
        if k < 4:
            b.append(poly([(x, 242), (x + 4, 251), (x - 2, 250)], "#ffffff"))
    # étincelles
    for (x, y, r) in ((80, 70, 3), (410, 56, 4), (355, 128, 2.5), (120, 140, 2.5), (440, 150, 3)):
        b.append('<path d="M%d %d l%.1f %.1f l%.1f %.1f l%.1f %.1f l%.1f %.1f z" fill="#fff6bf" opacity=".9"/>' % (
            x, y - r * 2, r * 0.5, r * 1.5, r * 1.5, r * 0.5, -r * 1.5, r * 0.5, -r * 0.5, r * 1.5))
    return "".join(b)


def write(name, body):
    svg = '<svg xmlns="http://www.w3.org/2000/svg" width="%d" height="%d" viewBox="0 0 %d %d">%s</svg>' % (W, H, W, H, body)
    sp = OUT / (name + ".svg")
    sp.write_text(svg, encoding="utf-8")
    pp = OUT / (name + ".png")
    subprocess.run(["rsvg-convert", "-w", str(W * 2), "-h", str(H * 2), "-o", str(pp), str(sp)], check=True)
    print("écrit", sp.name, pp.name, pp.stat().st_size // 1024, "Ko")


if __name__ == "__main__":
    write("mode_monde3d", art_3d())
    write("mode_cartes", art_cards())
