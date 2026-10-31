#!/usr/bin/env python3
"""Génère les illustrations SVG de la ville de Conquête (V62) + city_layout.json.

Usage : python3 tools/gen_city_art.py [--out prototype/zimut/assets/ui/conquest/city]
Produit, par biome (11) et par bâtiment :
  <biome>/<batiment>_<niveau>.svg   (niveau 0 = parcelle vide / chantier)
  <biome>/sky_<jour|soir|nuit>.svg  (fond de ciel)
  <biome>/deco_<type>.svg           (arbre, rocher, fontaine, étal, feu de camp...)
  <biome>/wonder_<forme>.svg        (11 formes de Merveille)
  city_layout.json                  (ancres de placement lues par ConquestCityView)
Chaque SVG a un viewBox fixe et expose des groupes nommés (id="...") :
  "lit" = fenêtres allumées la nuit, "glow" = halos (lanternes), "smoke" = fumée.
"""
import argparse, hashlib, json, os, random, xml.dom.minidom

BIOMES = ["Forêt", "Montagne", "Désert", "Cristaux", "Marées", "Vents", "Brasier", "Brumes", "Ombres", "Rouages", "Donjon"]
BIOME_KEYS = ["foret", "montagne", "desert", "cristaux", "marees", "vents", "brasier", "brumes", "ombres", "rouages", "donjon"]
BUILDINGS = ["hall", "barracks", "residence", "scierie", "mine", "tannerie", "cabane", "verger", "muraille"]
WONDER_SHAPES = ["tree", "forge", "pyramid", "crystal", "tower", "mill", "crypt"]
DECOS = ["tree", "rock", "well", "stall", "lamp", "cart", "fire"]

# Palette par biome : [mur, toit, ornement, sol, ciel_jour, ciel_soir, ciel_nuit, accent_lum]
PAL = {
 "Forêt":    ["#8a6a44", "#3f7a44", "#e8c86a", "#4a6b33", "#a8d8f0", "#f0a860", "#1c2440", "#ffd76a"],
 "Montagne": ["#b8bcc4", "#40608c", "#e8f0ff", "#6a7280", "#b8d8e8", "#c88a70", "#232838", "#ffe8a0"],
 "Désert":   ["#e0c088", "#c87838", "#f8dc78", "#d8b070", "#a8d0e8", "#f0b050", "#2c2438", "#ffdf80"],
 "Cristaux": ["#8a86b8", "#5a80c8", "#c8b8f8", "#4a4468", "#a8b8e8", "#b080d8", "#241f3c", "#d8c8ff"],
 "Marées":   ["#e0ddd0", "#3080b0", "#f0d888", "#c0b090", "#a0d0e8", "#e8a060", "#1c2c44", "#ffd880"],
 "Vents":    ["#d8dce2", "#58a0c8", "#f0f0f8", "#788a70", "#b8e0f0", "#e8b080", "#28303c", "#fff0b0"],
 "Brasier":  ["#584840", "#b8482a", "#ff9040", "#3c302a", "#e8a070", "#e86a40", "#2a1c1c", "#ffb060"],
 "Brumes":   ["#848c80", "#428078", "#b8f0dc", "#42564c", "#a8c0b8", "#b89078", "#202c28", "#d0f0e0"],
 "Ombres":   ["#605878", "#7040a0", "#c090f8", "#38304a", "#6858a0", "#9060b0", "#181428", "#e0b8ff"],
 "Rouages":  ["#a08868", "#c07838", "#f0c060", "#584a40", "#c8b8a0", "#d89860", "#2c2420", "#ffd080"],
 "Donjon":   ["#525058", "#3c3448", "#b090f0", "#322e38", "#505068", "#7858a0", "#141018", "#c8a0ff"],
}

def hx(c):
    return c

def esc(s):
    return s.replace("&", "&amp;").replace("<", "&lt;").replace('"', "&quot;")

class S:
    """Petit constructeur SVG."""
    def __init__(self, w, h):
        self.w, self.h = w, h
        self.parts = []
    def add(self, s):
        self.parts.append(s)
    def poly(self, pts, fill, stroke=None, sw=2, opacity=None, extra=""):
        p = " ".join("%.1f,%.1f" % (x, y) for x, y in pts)
        a = ' fill="%s"' % fill
        if stroke: a += ' stroke="%s" stroke-width="%g" stroke-linejoin="round"' % (stroke, sw)
        if opacity is not None: a += ' opacity="%g"' % opacity
        self.add('<polygon points="%s"%s%s/>' % (p, a, extra))
    def rect(self, x, y, w, h, fill, stroke=None, sw=2, rx=0, opacity=None, extra=""):
        a = ' fill="%s"' % fill
        if rx: a += ' rx="%g"' % rx
        if stroke: a += ' stroke="%s" stroke-width="%g"' % (stroke, sw)
        if opacity is not None: a += ' opacity="%g"' % opacity
        self.add('<rect x="%.1f" y="%.1f" width="%.1f" height="%.1f"%s%s/>' % (x, y, w, h, a, extra))
    def circle(self, cx, cy, r, fill, stroke=None, sw=2, opacity=None, extra=""):
        a = ' fill="%s"' % fill
        if stroke: a += ' stroke="%s" stroke-width="%g"' % (stroke, sw)
        if opacity is not None: a += ' opacity="%g"' % opacity
        self.add('<circle cx="%.1f" cy="%.1f" r="%.1f"%s%s/>' % (cx, cy, r, a, extra))
    def ellipse(self, cx, cy, rx, ry, fill, opacity=None, extra=""):
        a = ' fill="%s"' % fill + (' opacity="%g"' % opacity if opacity is not None else "")
        self.add('<ellipse cx="%.1f" cy="%.1f" rx="%.1f" ry="%.1f"%s%s/>' % (cx, cy, rx, ry, a, extra))
    def line(self, x1, y1, x2, y2, stroke, sw=2, opacity=None, cap="round"):
        a = ' stroke="%s" stroke-width="%g" stroke-linecap="%s"' % (stroke, sw, cap)
        if opacity is not None: a += ' opacity="%g"' % opacity
        self.add('<line x1="%.1f" y1="%.1f" x2="%.1f" y2="%.1f"%s/>' % (x1, y1, x2, y2, a))
    def path(self, d, fill=None, stroke=None, sw=2, opacity=None, extra=""):
        a = ""
        if fill: a += ' fill="%s"' % fill
        if stroke: a += ' stroke="%s" stroke-width="%g" stroke-linejoin="round" stroke-linecap="round"' % (stroke, sw)
        if opacity is not None: a += ' opacity="%g"' % opacity
        self.add('<path d="%s"%s%s/>' % (d, a, extra))
    def group(self, gid, inner):
        self.add('<g id="%s">%s</g>' % (gid, inner))
    def defs_gradient(self, gid, c0, c1, vertical=True):
        d = 'x1="0" y1="0" x2="%d" y2="%d"' % (0, 1) if vertical else 'x1="0" y1="0" x2="1" y2="0"'
        self.add('<defs><linearGradient id="%s" %s><stop offset="0" stop-color="%s"/><stop offset="1" stop-color="%s"/></linearGradient></defs>' % (gid, d, c0, c1))
    def defs_pattern_stone(self, gid, base, joint):
        self.add('<defs><pattern id="%s" width="0.14" height="0.12" patternUnits="objectBoundingBox">'
                 '<rect width="0.14" height="0.12" fill="none"/>'
                 '<path d="M0 0.5h0.14M0.5 0v0.5M0.25 0.5v0.5M0.75 0.5v0.5" stroke="%s" stroke-width="0.045" opacity="0.9" fill="none" vector-effect="non-scaling-stroke"/></pattern></defs>' % (gid, joint))
    def defs_pattern_planks(self, gid, base, joint):
        self.add('<defs><pattern id="%s" width="0.1" height="0.35" patternUnits="objectBoundingBox">'
                 '<rect width="0.1" height="0.35" fill="none"/>'
                 '<path d="M0 0v0.35M0.5 0v0.35" stroke="%s" stroke-width="0.06" opacity="0.8" fill="none" vector-effect="non-scaling-stroke"/></pattern></defs>' % (gid, joint))
    def defs_pattern_tiles(self, gid, c0, joint):
        self.add('<defs><pattern id="%s" width="0.09" height="0.16" patternUnits="objectBoundingBox">'
                 '<path d="M0 0.5h1M0.5 0v0.5" stroke="%s" stroke-width="0.05" opacity="0.9" fill="none" vector-effect="non-scaling-stroke"/>'
                 '<path d="M0 0.93h1" stroke="%s" stroke-width="0.07" opacity="0.5" fill="none" vector-effect="non-scaling-stroke"/></pattern></defs>'
                 % (gid, joint, shade(joint, -0.25)))
    def raw(self, s):
        self.add(s)
    def out(self):
        return ('<svg xmlns="http://www.w3.org/2000/svg" width="%d" height="%d" viewBox="0 0 %d %d">\n%s\n</svg>\n'
                % (self.w, self.h, self.w, self.h, "\n".join(self.parts)))

def shade(hexcol, f):
    """Assombrit (f<0) ou éclaircit (f>0) une couleur #rrggbb."""
    r = int(hexcol[1:3], 16); g = int(hexcol[3:5], 16); b = int(hexcol[5:7], 16)
    if f < 0:
        r = int(r * (1 + f)); g = int(g * (1 + f)); b = int(b * (1 + f))
    else:
        r = min(255, int(r + (255 - r) * f)); g = min(255, int(g + (255 - g) * f)); b = min(255, int(b + (255 - b) * f))
    return "#%02x%02x%02x" % (r, g, b)

# ── Bâtiments ─────────────────────────────────────────────
# Chaque bâtiment: viewBox 260x220, ancre au sol (130, 200) — centre bas.
# Groupes: id="body", id="lit" (fenêtres), id="glow" (halos), id="anim" (fumée/scie...)


def _wall_texture(s, x, y, w, h, wall, wood):
    """Hachures de matière dessinées dans l'espace du mur (planches verticales ou joints de pierre)."""
    c = shade(wall, -0.38)
    if wood:
        n = max(2, int(w / 13))
        for i in range(1, n):
            lx = x + w * float(i) / n
            s.line(lx, y, lx, y + h, c, 1.3, opacity=0.75)
        s.line(x, y + h * 0.33, x + w, y + h * 0.33, c, 1.0, opacity=0.4)
        s.line(x, y + h * 0.66, x + w, y + h * 0.66, c, 1.0, opacity=0.4)
    else:
        rows = max(2, int(h / 11))
        cols = max(2, int(w / 22))
        for r in range(1, rows):
            ly = y + h * float(r) / rows
            s.line(x, ly, x + w, ly, c, 1.2, opacity=0.8)
        for r in range(rows):
            off = (w / cols) * 0.5 if r % 2 else 0.0
            for cix in range(cols + 1):
                lx = x + off + w * float(cix) / cols
                if x <= lx <= x + w:
                    s.line(lx, y + h * float(r) / rows, lx, y + h * float(r + 1) / rows, c, 1.1, opacity=0.7)

def _roof_tiles(s, xa, ya, xt, yt, xb, yb, roof, opacity):
    """Lignes de tuiles dans le pan de toit (horizontales entre les arêtes + courtes verticales depuis le faîte)."""
    c = shade(roof, -0.55)
    for i in range(1, 6):
        f = float(i) / 6.0
        s.line(xa + (xt - xa) * f, ya + (yt - ya) * f, xb + (xt - xb) * f, yb + (yt - yb) * f, c, 1.5, opacity=opacity)
    for i in range(1, 8):
        f = float(i) / 8.0
        px = xa + (xb - xa) * f; py = ya + (yb - ya) * f
        s.line(px, py, xt, yt, c, 0.0, opacity=0.0)  # pas de verticales depuis le faîte (lisible sinon)

_gid = [0]
def _uid(prefix):
    _gid[0] += 1
    return "%s%d" % (prefix, _gid[0])

def house(s, cx, base, w, h, roof_h, wall, roof, trim, lit_windows=()):
    x0 = cx - w / 2; y0 = base - h
    # murs : base + matière (planches de bois ou joints de pierre) + ombre à droite + lumière de bord gauche
    s.rect(x0, y0, w, h, wall, stroke=shade(wall, -0.45), sw=2.5)
    _wall_texture(s, x0 + 2, y0 + 2, w - 4, h - 4, wall,
                  wood=wall in ("#8a6a44", "#9e7042", "#e0c088", "#a08868", "#c89a68", "#d8dce2", "#e0ddd0"))
    s.rect(x0 + w * 0.55, y0, w * 0.45, h, shade(wall, -0.15), opacity=0.85)
    s.rect(x0 + 1.5, y0 + 2, 6, h - 4, shade(wall, 0.55), opacity=0.95)   # lumière de bord (clé haut-gauche)
    s.rect(x0 + 8, y0 + 2, 3, h - 4, shade(wall, 0.28), opacity=0.6)
    # toit à deux pans avec débord
    over = w * 0.10
    groof = _uid("gr")
    s.defs_gradient(groof, shade(roof, 0.18), shade(roof, -0.12))
    s.poly([(x0 - over, y0), (cx, y0 - roof_h), (x0 + w + over, y0)], "url(#%s)" % groof, stroke=shade(roof, -0.4), sw=2.5)
    _roof_tiles(s, x0 - over, y0, cx, y0 - roof_h, x0 + w + over, y0, roof, 0.85)
    s.poly([(cx, y0 - roof_h), (x0 + w + over, y0), (cx + w * 0.12, y0)], shade(roof, -0.22))
    _roof_tiles(s, cx, y0 - roof_h, x0 + w + over, y0, cx + w * 0.12, y0, shade(roof, -0.22), 0.6)
    # porte
    dw = min(w * 0.2, 26)
    s.path("M%.1f %.1f v-%.1f q%.1f -%.1f %.1f 0 v%.1f z" % (cx - dw/2, base, h*0.42, dw/2, h*0.16, dw, h*0.42),
           fill="#3a2a1a", stroke="#1e140c", sw=2)
    # fenêtres (groupe lit)
    lit = ""
    for (wx, wy) in lit_windows:
        x = cx + wx - 5.5; y = base - h + wy
        lit += ('<rect x="%.1f" y="%.1f" width="11" height="13" rx="2" fill="#ffdf8a" stroke="#5a4020" stroke-width="1.5"/>'
                '<line x1="%.1f" y1="%.1f" x2="%.1f" y2="%.1f" stroke="#5a4020" stroke-width="1.2"/>') % (x, y, x + 5.5, y, x + 5.5, y + 13)
    return y0 - roof_h, lit

def tower(s, cx, base, w, h, wall, roof, trim):
    s.rect(cx - w/2, base - h, w, h, shade(wall, -0.06), stroke=shade(wall, -0.45), sw=2.5)
    _wall_texture(s, cx - w/2 + 2, base - h + 2, w - 4, h - 4, shade(wall, -0.06), wood=False)
    s.rect(cx, base - h, w/2, h, shade(wall, -0.2), opacity=0.8)
    s.rect(cx - w/2 + 1.5, base - h, 3, h, shade(wall, 0.3), opacity=0.7)
    top = (cx, base - h - w * 1.15)
    s.poly([(cx - w*0.68, base - h), top, (cx + w*0.68, base - h)], roof, stroke=shade(roof, -0.4), sw=2.5)
    s.poly([top, (cx + w*0.68, base - h), (cx + w*0.1, base - h)], shade(roof, -0.22))
    return top

def flag(s, top, col, t=1.0):
    px, py = top[0], top[1] - 26 * t
    s.line(top[0], top[1], px, py, "#4a3018", 2.5)
    s.path("M%.1f %.1f l%.1f 4 l-%.1f 9 l%.1f 0 z" % (px, py, 20*t, 20*t, 20*t),
           fill=col, stroke=shade(col, -0.4), sw=1.5)

def b_hall(s, pal, lv):
    wall, roof, trim, ground = pal[0], pal[1], pal[2], pal[3]
    cx, base = 130, 200
    w = 96 + 16 * lv
    s.ellipse(cx, base + 4, w * 0.85, 14, "#000000", opacity=0.28)
    if lv >= 2:
        for sx in (-1, 1):
            house(s, cx + sx * w * 0.72, base, w * 0.52, 52, 30, shade(wall, -0.06), shade(roof, -0.08), trim, [(-8, 22), (8, 22)])
    if lv >= 4:
        for sx in (-1, 1):
            t = tower(s, cx + sx * w * 1.02, base + 6, 26, 120, wall, roof, trim)
            flag(s, t, trim, 0.8)
    topy, lit = house(s, cx, base, w, 58 + 9 * lv, 42 + 5 * lv, wall, roof, trim, [(-w*0.3, 20), (0, 20), (w*0.3, 20)])
    top = (cx, topy)
    s.rect(cx - w/2, base - (58 + 9*lv), w, 7, trim)
    if lv >= 3:
        ct = (cx, top[1] + 24)
        s.rect(ct[0] - 17, ct[1] - 38, 34, 38, shade(wall, 0.06), stroke=shade(wall, -0.45), sw=2.5)
        s.circle(ct[0], ct[1] - 20, 7, "#f8ecb0", stroke="#5a4020", sw=1.5)  # horloge
        s.group("lit", '<circle cx="%.1f" cy="%.1f" r="4" fill="#ffe9a0"/>' % (ct[0], ct[1] - 20))
        if lv >= 5:
            s.circle(ct[0], ct[1] - 40, 21, trim, stroke=shade(trim, -0.35), sw=2)
            spire = (ct[0], ct[1] - 88)
            s.poly([(ct[0]-5, ct[1]-56), spire, (ct[0]+5, ct[1]-56)], "#ffd24a", stroke="#a87818", sw=2)
            flag(s, spire, "#3fae62", 1.15)
        else:
            cone = (ct[0], ct[1] - 74)
            s.poly([(ct[0]-23, ct[1]-38), cone, (ct[0]+23, ct[1]-38)], shade(roof, 0.1), stroke=shade(roof, -0.4), sw=2.5)
            flag(s, cone, "#3fae62", 1.0)
    else:
        flag(s, top, "#3fae62", 0.9)
    return lit

def b_barracks(s, pal, lv):
    wall, roof, trim = shade(pal[0], -0.08), pal[1], pal[2]
    cx, base = 130, 200
    w, h = 118, 46
    s.ellipse(cx, base + 4, w * 0.8, 13, "#000", opacity=0.28)
    s.rect(cx - w/2, base - h, w, h, wall, stroke=shade(wall, -0.45), sw=2.5)
    for i in range(7):
        if i % 2 == 0:
            s.rect(cx - w/2 + i * w/7, base - h - 9, w/7, 9, shade(wall, 0.06))
    s.rect(cx - 13, base - 30, 26, 30, "#241812", stroke="#120b06", sw=2)
    lit = '<rect x="%.1f" y="%.1f" width="10" height="12" rx="2" fill="#ffdf8a" stroke="#5a4020" stroke-width="1.5"/>' % (cx - w/2 + w*0.25 - 5, base - h + 12)
    t = tower(s, cx + w*0.38, base, 30, 72, wall, roof, trim)
    flag(s, t, "#8aa8e8", 0.9)
    # soldats
    for i in range(min(4 + lv * 2, 10)):
        sx = cx - 52 + (i % 5) * 22
        sy = base + 12 + (i / 5) * 14
        s.circle(sx, sy + 2, 4.5, "#000", opacity=0.25)
        s.rect(sx - 3.5, sy - 12, 7, 10, "#5a74b0", stroke="#2c3a5c", sw=1.2)
        s.circle(sx, sy - 15, 3.4, "#f2cc9e")
        s.line(sx + 5, sy - 2, sx + 5, sy - 22, "#c8c8d0", 1.5)
    return lit

def b_residence(s, pal, lv):
    wall, roof, trim = shade(pal[0], 0.1), shade(pal[1], -0.05), pal[2]
    cx, base = 130, 200
    s.ellipse(cx, base + 4, 95, 13, "#000", opacity=0.28)
    topy, lit = house(s, cx, base, 100, 56, 34, wall, roof, trim, [(-28, 22), (28, 22)])
    top = (cx, topy)
    for i in range(4):
        x = cx - 38 + i * 25.3
        s.rect(x - 3, base - 30, 6, 30, shade(trim, 0.2), stroke=shade(trim, -0.3), sw=1.5)
    s.rect(cx - 48, base - 34, 96, 5, trim)
    flag(s, top, "#d89ce0", 0.9)
    return lit

def b_scierie(s, pal, lv):
    wall, roof, trim = pal[0], pal[1], pal[2]
    cx, base = 130, 200
    s.ellipse(cx, base + 4, 90, 13, "#000", opacity=0.28)
    topy, lit = house(s, cx - 16, base, 62 + 10*lv, 38, 26, "#9e7042", roof, trim, [(-10, 16)])
    top = (cx - 16, topy)
    # pile de rondins
    for i in range(lv * 2 + 1):
        lx = cx + 34 + (i % 3) * 11
        ly = base - 6 - (i // 3) * 10
        s.circle(lx, ly, 6, "#7a4a22", stroke="#4a2c12", sw=1.5)
        s.circle(lx, ly, 3.2, "#c8a068")
    # scie circulaire
    sc = (cx - 52, base - 26)
    r = 13 + 2 * lv
    s.circle(sc[0], sc[1], r, "#c4c8d0", stroke="#6a6e78", sw=2)
    for j in range(10):
        s.line(sc[0], sc[1], sc[0] + r*0.9, sc[1] + (j % 3 - 1) * 2, "#6a6e78", 1.2)
    s.circle(sc[0], sc[1], 3, "#3a3a40")
    return lit

def b_mine(s, pal, lv):
    trim = pal[2]
    cx, base = 130, 200
    rock = "#7a7880"
    mh = 52 + 10 * lv
    s.ellipse(cx, base + 4, 95, 13, "#000", opacity=0.3)
    g1 = _uid("grock1"); s.defs_gradient(g1, shade(rock, 0.15), shade(rock, -0.1))
    g2 = _uid("grock2"); s.defs_gradient(g2, shade(rock, -0.05), shade(rock, -0.3))
    s.poly([(cx-62, base), (cx-34, base - mh*0.8), (cx-6, base - mh), (cx+30, base - mh*0.7), (cx+62, base)], "url(#%s)" % g1, stroke=shade(rock, -0.4), sw=2.5)
    s.poly([(cx-6, base - mh), (cx+30, base - mh*0.7), (cx+62, base), (cx+10, base)], "url(#%s)" % g2)
    # facettes de roche (arêtes internes)
    s.line(cx-34, base - mh*0.8, cx-10, base - mh*0.35, shade(rock, -0.5), 2.2, opacity=0.8)
    s.line(cx-6, base - mh, cx+8, base - mh*0.4, shade(rock, 0.35), 2.0, opacity=0.7)
    s.line(cx+30, base - mh*0.7, cx+18, base - mh*0.3, shade(rock, -0.45), 2.2, opacity=0.8)
    s.line(cx-62, base, cx-34, base - mh*0.8, shade(rock, 0.25), 1.6, opacity=0.6)
    # éclats de minerai (points clairs)
    for (mx, my) in [(-30, -mh*0.6), (12, -mh*0.5), (34, -mh*0.4)]:
        s.circle(cx + mx, base + my, 2.2, shade(rock, 0.45), opacity=0.9)
    s.circle(cx - 4, base - 18, 17, "#141010")
    s.rect(cx - 24, base - 38, 4, 38, "#6a4a28")
    s.rect(cx + 12, base - 38, 4, 38, "#6a4a28")
    s.rect(cx - 26, base - 40, 44, 5, "#6a4a28")
    glow = '<circle cx="%.1f" cy="%.1f" r="9" fill="#ffc050" opacity="0.85"/><circle cx="%.1f" cy="%.1f" r="3" fill="#ffe9a0"/>' % (cx + 14, base - 30, cx + 14, base - 30)
    if lv >= 2:
        hx = cx - 40
        s.line(hx - 12, base - mh*0.6, hx, base - mh*0.6 - 48, "#6a4a28", 3)
        s.line(hx + 12, base - mh*0.6, hx, base - mh*0.6 - 48, "#6a4a28", 3)
        s.circle(hx, base - mh*0.6 - 48, 7, "#55504a")
    return glow

def b_tannerie(s, pal, lv):
    trim = pal[2]
    cx, base = 130, 200
    tent = "#c89a68"
    s.ellipse(cx, base + 4, 95, 13, "#000", opacity=0.28)
    s.poly([(cx-44, base), (cx-8, base - 56), (cx+28, base)], tent, stroke=shade(tent, -0.4), sw=2.5)
    s.poly([(cx-8, base - 56), (cx+28, base), (cx-2, base)], shade(tent, -0.2))
    s.poly([(cx-16, base), (cx-8, base - 22), (cx, base)], "#332010")
    for i in range(lv + 1):
        rx = cx + 30 + i * 14
        s.line(rx, base, rx, base - 40, "#6a4a28", 2)
        s.rect(rx - 6, base - 38, 12, 20, shade("#c8956a", -0.15 * (i % 2)), stroke="#5a3c20", sw=1.2)
    if lv >= 2:
        house(s, cx - 58, base, 36, 30, 18, pal[0], pal[1], trim, [(-6, 12)])
    return ""

def b_cabane(s, pal, lv):
    wall, roof, trim = shade(pal[0], 0).replace("#", "#"), pal[1], pal[2]
    cx, base = 130, 200
    w = 30 + 4 * lv; h = 58 + 16 * lv
    s.ellipse(cx, base + 4, 70, 12, "#000", opacity=0.28)
    t = tower(s, cx, base, w, h, "#7a70a0", "#5c4480", trim)
    # orbe flottant (glow)
    orb = (cx, t[1] - 14)
    glow = '<circle cx="%.1f" cy="%.1f" r="14" fill="#b89aff" opacity="0.4"/><circle cx="%.1f" cy="%.1f" r="7" fill="#d8ccff" stroke="#6a4ac8" stroke-width="1.5"/>' % (orb[0], orb[1], orb[0], orb[1])
    lit = '<rect x="%.1f" y="%.1f" width="9" height="11" rx="2" fill="#e8d8ff" stroke="#4a3a80" stroke-width="1.5"/>' % (cx - 4.5, base - h * 0.6)
    if lv >= 2:
        house(s, cx + 36, base, 38, 28, 18, pal[0], "#5c4480", trim, [(8, 10)])
    return glow + lit

def b_verger(s, pal, lv):
    cx, base = 130, 200
    s.ellipse(cx, base + 4, 100, 14, "#000", opacity=0.25)
    n = 1 + lv * 2
    for i in range(n):
        tx = cx - 48 + i * 96 / max(1, n - 1)
        ty = base - (i % 2) * 10
        s.rect(tx - 3, ty - 22, 6, 22, "#6a4526", stroke="#402a14", sw=1.5)
        s.circle(tx, ty - 32, 15, shade("#4a8a3a", 0.05 * (i % 2)), stroke="#2c5a24", sw=2)
        for j in range(3):
            s.circle(tx + ((j * 2 + i) % 5 - 2) * 4, ty - 32 + ((j * 3 + i) % 5 - 2) * 4, 2.5, "#e84838")
    if lv >= 2:
        s.circle(cx, base + 8, 9, "#8a8a90", stroke="#4a4a50", sw=2)
        s.circle(cx, base + 8, 5.5, "#3060a0")
    return ""

def b_muraille(s, pal, lv):
    stone = "#8a8a90"
    cx, base = 130, 200
    h = 30 + 10 * lv
    s.ellipse(cx, base + 4, 95, 13, "#000", opacity=0.3)
    s.rect(cx - 50, base - h, 100, h, stone, stroke=shade(stone, -0.45), sw=2.5)
    for i in range(5):
        if i % 2 == 0:
            s.rect(cx - 50 + i * 20, base - h - 9, 20, 9, shade(stone, 0.08))
    lit = ""
    for sx in (-1, 1):
        t = tower(s, cx + sx * 50, base, 24, h + 22, stone, pal[1], pal[2])
        if lv >= 3:
            flag(s, t, pal[2], 0.6)
        lit += '<rect x="%.1f" y="%.1f" width="8" height="10" rx="2" fill="#ffdf8a" stroke="#5a4020" stroke-width="1.4"/>' % (cx + sx * 50 - 4, base - h - 12)
    return lit

def b_wonder(s, pal, shape):
    wall, roof, trim = pal[0], pal[1], pal[2]
    cx, base = 130, 200
    s.ellipse(cx, base + 4, 85, 14, shade(trim, 0), opacity=0.3)
    s.ellipse(cx, base + 4, 80, 13, "#000", opacity=0.28)
    lit = ""
    if shape == "tree":
        gtr = _uid("gwtrunk")
        s.defs_gradient(gtr, "#7a5230", "#452c14", vertical=False)
        s.rect(cx - 10, base - 70, 20, 70, "url(#%s)" % gtr, stroke="#33200f", sw=2.5)
        # houppes en dégradé radial (volume), du fond vers le devant
        blobs = [(-16, -88, 22), (16, -90, 20), (0, -108, 30), (-10, -118, 18), (12, -116, 17)]
        for (ox, oy, r) in blobs:
            gg = _uid("gwfol")
            s.add('<defs><radialGradient id="%s" cx="0.38" cy="0.3" r="0.95"><stop offset="0" stop-color="%s"/><stop offset="0.6" stop-color="%s"/><stop offset="1" stop-color="%s"/></radialGradient></defs>'
                  % (gg, shade(roof, 0.30), shade(roof, 0.06), shade(roof, -0.30)))
            s.circle(cx + ox, base + oy, r, "url(#%s)" % gg, stroke=shade(roof, -0.45), sw=2)
            s.circle(cx + ox - r*0.32, base + oy - r*0.34, r*0.3, shade(roof, 0.6), opacity=0.8)
        lit = '<circle cx="%.1f" cy="%.1f" r="5" fill="#fff0a0"/>' % (cx, base - 108)
    elif shape == "crystal":
        for k in range(3):
            off = (k - 1) * 26
            hgt = (120 if k == 1 else 70)
            s.poly([(cx + off - 16, base), (cx + off, base - hgt), (cx + off + 16, base)], shade(trim, 0.08), stroke=shade(trim, -0.4), sw=2.5)
            s.line(cx + off, base, cx + off, base - hgt, "#ffffff", 1.5, opacity=0.6)
        lit = '<circle cx="%.1f" cy="%.1f" r="20" fill="%s" opacity="0.45"/>' % (cx, base - 90, trim)
    elif shape == "pyramid":
        s.poly([(cx - 70, base), (cx, base - 95), (cx + 70, base)], wall, stroke=shade(wall, -0.45), sw=2.5)
        s.poly([(cx, base - 95), (cx + 70, base), (cx + 10, base)], shade(wall, -0.2))
        s.poly([(cx - 10, base - 82), (cx, base - 95), (cx + 10, base - 82)], "#ffd24a", stroke="#a87818", sw=2)
        flag(s, (cx, base - 95), roof, 1.0)
    elif shape == "forge":
        house(s, cx, base, 110, 54, 20, shade(wall, -0.2), roof, trim, [(-30, 18), (10, 18)])
        s.rect(cx + 26, base - 120, 18, 70, shade(wall, -0.3), stroke=shade(wall, -0.5), sw=2)
        lit = '<rect x="%.1f" y="%.1f" width="26" height="22" rx="3" fill="#ff8020" stroke="#a04010" stroke-width="2"/>' % (cx - 30, base - 30)
    elif shape == "crypt":
        s.rect(cx - 55, base - 50, 110, 50, shade(wall, -0.1), stroke=shade(wall, -0.45), sw=2.5)
        s.circle(cx, base - 50, 40, wall, stroke=shade(wall, -0.45), sw=2.5)
        s.rect(cx - 55, base - 50, 110, 6, trim)
        s.rect(cx - 14, base - 36, 28, 36, "#100a14", stroke="#000", sw=2)
        lit = '<circle cx="%.1f" cy="%.1f" r="6" fill="%s" opacity="0.8"/>' % (cx, base - 20, trim)
    elif shape == "mill":
        t = tower(s, cx, base, 40, 80, wall, roof, trim)
        hub = (cx, base - 70)
        for k in range(4):
            import math
            a = k * math.pi / 2
            tip = (hub[0] + (46 if k % 2 == 0 else 58) * math.cos(a), hub[1] + (46 if k % 2 == 0 else 58) * math.sin(a))
            s.line(hub[0], hub[1], tip[0], tip[1], "#6a4a28", 3)
            s.poly([(hub[0] + (tip[0]-hub[0])*0.3, hub[1] + (tip[1]-hub[1])*0.3), tip, (tip[0] + 8, tip[1] + 4), (hub[0] + (tip[0]-hub[0])*0.3 + 8, hub[1] + (tip[1]-hub[1])*0.3 + 4)], "#f0eee2", stroke="#8a8878", sw=1.5)
        s.circle(hub[0], hub[1], 5, "#4a3820")
        flag(s, t, trim, 0.8)
        lit = '<rect x="%.1f" y="%.1f" width="9" height="11" rx="2" fill="#ffdf8a" stroke="#5a4020" stroke-width="1.5"/>' % (cx - 4.5, base - 50)
    else:  # tower (phare/horloge)
        t = tower(s, cx, base, 44, 120, wall, roof, trim)
        lit = '<circle cx="%.1f" cy="%.1f" r="12" fill="#ffecb0" stroke="#a87818" stroke-width="2"/>' % (cx, base - 118)
        s.circle(cx, base - 118, 12, "#ffecb0", stroke="#a87818", sw=2)
        flag(s, t, trim, 0.8)
    return lit

def b_empty(s, pal, lv):
    cx, base = 130, 200
    s.ellipse(cx, base, 52, 16, "#000", opacity=0.25)
    s.group("plot", '<ellipse cx="130" cy="200" rx="50" ry="15" fill="none" stroke="#f0e0a0" stroke-width="2" stroke-dasharray="6 5" opacity="0.7"/>')
    for sx in (-1, 1):
        s.line(cx + sx * 40, base, cx + sx * 40, base - 18, "#7a5a30", 3)
    return ""

BUILD_FN = {"hall": b_hall, "barracks": b_barracks, "residence": b_residence, "scierie": b_scierie,
            "mine": b_mine, "tannerie": b_tannerie, "cabane": b_cabane, "verger": b_verger, "muraille": b_muraille}

# ── Décors ─────────────────────────────────────────────
def d_tree(s, pal, rng):
    cx, base = 60, 100
    s.ellipse(cx, base + 2, 34, 9, "#000", opacity=0.25)
    # tronc avec dégradé (éclairé à gauche)
    gtr = _uid("gtrunk")
    s.defs_gradient(gtr, "#6a4a2c", "#3c2812", vertical=False)
    s.path("M%.1f %.1f q-6 -30 4 -52 l6 -2 q-8 22 -2 54 z" % (cx, base), "url(#%s)" % gtr, stroke="#2c1c0c", sw=1.5)
    # 5 houppes : cœur sombre d'abord, puis dégradés radiaux du plus sombre au plus clair
    blobs = [(0, -50, 22, "#2c5a24"), (-14, -62, 17, None), (14, -60, 16, None), (-6, -74, 15, None), (8, -72, 14, None)]
    for i, (ox, oy, r, forced) in enumerate(blobs):
        gx, gy = cx + ox, base + oy
        if forced:
            s.circle(gx, gy, r, forced, opacity=0.9)
        else:
            gg = _uid("gfol")
            s.add('<defs><radialGradient id="%s" cx="0.38" cy="0.32" r="0.95"><stop offset="0" stop-color="%s"/><stop offset="0.55" stop-color="%s"/><stop offset="1" stop-color="%s"/></radialGradient></defs>'
                  % (gg, shade("#6ab054", 0.12), shade("#4a8a42", 0.02), shade("#2c5a24", -0.02)))
            s.circle(gx, gy, r, "url(#%s)" % gg, stroke="#26522a", sw=2)
            # reflet de clé sur chaque houppe
            s.circle(gx - r*0.34, gy - r*0.36, r*0.34, "#a4e088", opacity=0.85)
    return ""

def d_rock(s, pal, rng):
    cx, base = 60, 100
    s.ellipse(cx, base + 2, 30, 8, "#000", opacity=0.25)
    s.poly([(cx-28, base), (cx-16, base-26), (cx+2, base-34), (cx+22, base-22), (cx+28, base)], "#8a8a92", stroke="#55555e", sw=2)
    return ""

def d_well(s, pal, rng):
    cx, base = 60, 100
    s.ellipse(cx, base + 2, 26, 8, "#000", opacity=0.25)
    s.circle(cx, base - 8, 16, "#8a8a90", stroke="#4a4a52", sw=2.5)
    s.circle(cx, base - 8, 11, "#2a4a80")
    s.line(cx - 14, base - 10, cx - 14, base - 34, "#6a4a28", 3)
    s.line(cx + 14, base - 10, cx + 14, base - 34, "#6a4a28", 3)
    s.line(cx - 14, base - 34, cx + 14, base - 34, "#6a4a28", 3)
    s.line(cx, base - 34, cx, base - 18, "#3a2a18", 1.5)
    return ""

def d_stall(s, pal, rng):  # étal de marché
    cx, base = 60, 100
    s.ellipse(cx, base + 2, 34, 9, "#000", opacity=0.25)
    for sx in (-1, 1):
        s.line(cx + sx * 22, base, cx + sx * 22, base - 44, "#6a4a28", 3)
    s.poly([(cx - 30, base - 44), (cx, base - 62), (cx + 30, base - 44)], pal[1] if len(pal) > 1 else "#c84838", stroke=shade(pal[1] if len(pal)>1 else "#c84838", -0.4), sw=2)
    s.rect(cx - 24, base - 44, 48, 6, "#8a6238", stroke="#4a3018", sw=1.5)
    for i, c in enumerate(["#e84838", "#f0c040", "#58a058"]):
        s.circle(cx - 12 + i * 12, base - 46, 4, c)
    return ""

def d_lamp(s, pal, rng):  # lanterne
    cx, base = 30, 100
    s.ellipse(cx, base + 2, 12, 4, "#000", opacity=0.3)
    s.line(cx, base, cx, base - 44, "#2c241c", 3)
    glow = '<circle cx="%.1f" cy="%.1f" r="16" fill="%s" opacity="0.35"/><circle cx="%.1f" cy="%.1f" r="6" fill="#ffe9a0" stroke="#a87818" stroke-width="1.5"/>' % (cx, base - 48, pal[7], cx, base - 48)
    s.rect(cx - 5, base - 56, 10, 12, "#3a3026", stroke="#1c1610", sw=1.5)
    return glow

def d_cart(s, pal, rng):
    cx, base = 60, 100
    s.ellipse(cx, base + 2, 34, 8, "#000", opacity=0.25)
    s.rect(cx - 26, base - 22, 46, 18, "#8a6238", stroke="#4a3018", sw=2)
    s.circle(cx - 14, base - 2, 8, "#4a3018", stroke="#241808", sw=2)
    s.circle(cx + 12, base - 2, 8, "#4a3018", stroke="#241808", sw=2)
    s.line(cx + 20, base - 14, cx + 34, base - 22, "#6a4a28", 3)
    return ""

def d_fire(s, pal, rng):  # feu de camp / brasero
    cx, base = 40, 100
    s.ellipse(cx, base + 2, 22, 7, "#000", opacity=0.3)
    glow = '<circle cx="%.1f" cy="%.1f" r="22" fill="#ff9040" opacity="0.4"/><circle cx="%.1f" cy="%.1f" r="9" fill="#ffd060"/>' % (cx, base - 14, cx, base - 14)
    s.line(cx - 10, base, cx + 10, base - 8, "#5a3a20", 3.5)
    s.line(cx + 10, base, cx - 10, base - 8, "#5a3a20", 3.5)
    s.poly([(cx - 6, base - 10), (cx, base - 30), (cx + 6, base - 10)], "#ff8028", stroke="#c04010", sw=1.5)
    s.poly([(cx - 3, base - 12), (cx, base - 22), (cx + 3, base - 12)], "#ffd870")
    return glow

DECO_FN = {"tree": d_tree, "rock": d_rock, "well": d_well, "stall": d_stall, "lamp": d_lamp, "cart": d_cart, "fire": d_fire}

# ── Ciels ─────────────────────────────────────────────
def sky(kind, pal):
    w, h = 1000, 400
    s = S(w, h)
    if kind == "jour":
        top, bot = "#7ec0ee", "#c8e8f8"
        s.raw('<defs><linearGradient id="g" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="%s"/><stop offset="1" stop-color="%s"/></linearGradient></defs>' % (top, bot))
        s.rect(0, 0, w, h, "url(#g)", extra=' stroke="none"')
        s.circle(880, 70, 34, "#fff8d0", stroke="#f0e0a0", sw=2)
        s.circle(880, 70, 44, "#fff8d0", opacity=0.3)
        s.circle(880, 70, 58, "#ffefd0", opacity=0.12)
        for (x, y, sc) in [(180, 80, 1.0), (420, 50, 0.7), (640, 110, 0.85)]:
            s.ellipse(x, y, 46 * sc, 16 * sc, "#ffffff", opacity=0.9)
            s.ellipse(x + 30 * sc, y + 4 * sc, 34 * sc, 13 * sc, "#ffffff", opacity=0.9)
    elif kind == "soir":
        s.raw('<defs><linearGradient id="g" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#4a5aa8"/><stop offset="0.6" stop-color="#e88a50"/><stop offset="1" stop-color="#f8c060"/></linearGradient></defs>')
        s.rect(0, 0, w, h, "url(#g)")
        s.circle(500, 330, 40, "#ffd070", stroke="#e8a040", sw=2)
        s.circle(500, 330, 54, "#ffd070", opacity=0.25)
        s.ellipse(200, 120, 60, 14, "#c8a0c8", opacity=0.5)
        s.ellipse(760, 90, 70, 16, "#d8b0d0", opacity=0.45)
    else:  # nuit
        s.raw('<defs><linearGradient id="g" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#0c1030"/><stop offset="1" stop-color="#2c3468"/></linearGradient></defs>')
        s.rect(0, 0, w, h, "url(#g)")
        rng = random.Random(42)
        for i in range(60):
            s.circle(rng.randint(0, int(w)), rng.randint(0, int(h * 0.8)), rng.uniform(0.8, 2.2), "#ffffff", opacity=rng.uniform(0.4, 1.0))
        s.circle(850, 70, 26, "#f0f0e8", stroke="#c8c8b8", sw=2)
        s.circle(840, 64, 22, "#0c1030", opacity=0.85)  # croissant
        s.ellipse(300, 140, 70, 12, "#8890c0", opacity=0.25)
        s.ellipse(650, 100, 80, 14, "#8890c0", opacity=0.2)
    return s.out()

# ── Génération ─────────────────────────────────────────
def write(outdir, rel, content):
    p = os.path.join(outdir, rel)
    os.makedirs(os.path.dirname(p), exist_ok=True)
    with open(p, "w", encoding="utf-8") as f:
        f.write(content)
    # .import pour SVG (hash md5 du chemin res://)
    # outdir = prototype/zimut/assets/ui/conquest/city -> res://assets/ui/conquest/city/...
    res_path = "res://" + os.path.relpath(p, PROJECT_ROOT).replace(os.sep, "/")
    h = hashlib.md5(res_path.encode()).hexdigest()
    uid = "uid://" + "".join(random.choice("0123456789abcdefghijklmnopqrstuvwxyz") for _ in range(13))
    with open(p + ".import", "w", encoding="utf-8") as f:
        f.write('[remap]\n\nimporter="texture"\ntype="CompressedTexture2D"\nuid="%s"\npath="res://.godot/imported/%s-%s.ctex"\nmetadata={\n"vram_texture": false\n}\n\n[deps]\n\nsource_file="%s"\ndest_files=["res://.godot/imported/%s-%s.ctex"]\n\n[params]\n\ncompress/mode=0\nsvg/scale=1.0\n' % (uid, os.path.basename(p), h, res_path, os.path.basename(p), h))
    return p

PROJECT_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "prototype", "zimut"))

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--out", default=os.path.join(PROJECT_ROOT, "assets", "ui", "conquest", "city"))
    args = ap.parse_args()
    outdir = os.path.abspath(args.out)
    os.makedirs(outdir, exist_ok=True)
    layout = {"version": 1, "buildings": {}, "deco_slots": [], "sky": {}}
    count = 0
    for biome, key in zip(BIOMES, BIOME_KEYS):
        pal = PAL[biome]
        bdir = os.path.join(outdir, key)
        os.makedirs(bdir, exist_ok=True)
        rng = random.Random(hash(biome) & 0xffff)
        # bâtiments
        for b in BUILDINGS:
            maxlv = 5 if b == "hall" else 3
            layout["buildings"][b] = {"max_level": maxlv, "anchor": [130, 200], "size": [260, 220]}
            for lv in range(0, maxlv + 1):
                s3 = S(260, 220)
                if lv == 0:
                    b_empty(s3, pal, 0)
                else:
                    BUILD_FN[b](s3, pal, lv)
                write(outdir, "%s/%s_%d.svg" % (key, b, lv), s3.out())
                count += 1
        # merveilles
        for shape in WONDER_SHAPES:
            s = S(260, 220)
            b_wonder(s, pal, shape)
            write(outdir, "%s/wonder_%s.svg" % (key, shape), s.out())
            count += 1
        # décors
        for d in DECOS:
            s = S(120, 110)
            DECO_FN[d](s, pal, rng)
            write(outdir, "%s/deco_%s.svg" % (key, d), s.out())
            count += 1
        # ciels
        for kind in ["jour", "soir", "nuit"]:
            write(outdir, "%s/sky_%s.svg" % (key, kind), sky(kind, pal))
            layout["sky"][kind] = "%s/sky_%s.svg" % (key, kind)
            count += 1
    # layout global (positions des parcelles en fractions, identiques à ConquestCityView.PLOTS)
    layout["plots"] = {
        "hall": [0.50, 0.50], "barracks": [0.19, 0.58], "residence": [0.81, 0.58], "wonder": [0.50, 0.79],
        "scierie": [0.10, 0.83], "mine": [0.22, 0.91], "tannerie": [0.35, 0.84],
        "cabane": [0.65, 0.84], "verger": [0.80, 0.91], "muraille": [0.92, 0.83],
    }
    layout["deco_slots"] = [[0.30, 0.62], [0.70, 0.62], [0.05, 0.70], [0.95, 0.70], [0.42, 0.93], [0.58, 0.93]]
    with open(os.path.join(outdir, "city_layout.json"), "w", encoding="utf-8") as f:
        json.dump(layout, f, ensure_ascii=False, indent=1)
    with open(os.path.join(outdir, "city_layout.json.import"), "w") as f:
        pass  # json n'a pas besoin d'import Godot dédié
    # validation XML
    import glob
    bad = 0
    for p in glob.glob(os.path.join(outdir, "**", "*.svg"), recursive=True):
        try:
            xml.dom.minidom.parse(p)
        except Exception as e:
            bad += 1
            print("XML INVALIDE:", p, e)
    print("OK: %d fichiers SVG générés dans %s (%d invalides)" % (count, outdir, bad))

if __name__ == "__main__":
    main()
