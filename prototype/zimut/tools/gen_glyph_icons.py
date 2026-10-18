#!/usr/bin/env python3
"""V19 : icônes SVG des 6 sorts « glyphe » (même cadre que les autres icônes de sorts).
Usage : python3 tools/gen_glyph_icons.py   (depuis prototype/zimut)"""
import math, os

OUT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "assets", "icons", "spells")
ICONS = {
    # id: (nom, fond haut, fond bas, trait, symbole)
    "glyph_stone":  ("Glyphe de grès",     "#9a7a42", "#3a2a12", "#ffd58a", "shield"),
    "glyph_quake":  ("Glyphe sismique",    "#8a5a30", "#2a1608", "#ffb060", "crack"),
    "glyph_venom":  ("Glyphe de venin",    "#6a9a30", "#1c2a0c", "#c8f070", "drop"),
    "glyph_shadow": ("Glyphe d'ombre",     "#6a3a9a", "#180a2a", "#d0a0ff", "eye"),
    "glyph_snare":  ("Glyphe d'entrave",   "#4a8a4a", "#10260f", "#b8f0a0", "vines"),
    "glyph_flame":  ("Glyphe de flammes",  "#b85a20", "#3a1004", "#ffd070", "flame"),
}


def star(r, rot=0.0):
    pts = []
    for i in range(6):
        a = rot + i * 2 * math.pi / 5 * 2
        pts.append("%.1f,%.1f" % (math.cos(a) * r, math.sin(a) * r))
    pts.append(pts[0])
    return " ".join(pts)


def symbol(kind, col):
    st = 'stroke="#1a1020" stroke-width="2" stroke-linejoin="round" stroke-linecap="round"'
    if kind == "shield":
        return '<path d="M-7,-8 L7,-8 L7,1 Q7,9 0,12 Q-7,9 -7,1 Z" fill="%s" %s/>' % (col, st)
    if kind == "crack":
        return '<path d="M-3,-10 L2,-3 L-2,0 L4,10" fill="none" stroke="#1a1020" stroke-width="5" stroke-linecap="round" stroke-linejoin="round"/><path d="M-3,-10 L2,-3 L-2,0 L4,10" fill="none" stroke="%s" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"/>' % col
    if kind == "drop":
        return '<path d="M0,-10 Q9,2 0,10 Q-9,2 0,-10 Z" fill="%s" %s/>' % (col, st)
    if kind == "eye":
        return '<path d="M-11,0 Q0,-10 11,0 Q0,10 -11,0 Z" fill="%s" %s/><circle r="3.6" fill="#1a1020"/>' % (col, st)
    if kind == "vines":
        return '<path d="M-9,8 Q-9,-2 0,-2 Q9,-2 9,-10" fill="none" stroke="#1a1020" stroke-width="5" stroke-linecap="round"/><path d="M-9,8 Q-9,-2 0,-2 Q9,-2 9,-10" fill="none" stroke="%s" stroke-width="2.4" stroke-linecap="round"/>' % col
    if kind == "flame":
        return '<path d="M0,-11 Q8,-2 5,5 Q3,10 0,10 Q-6,10 -6,3 Q-6,-2 0,-11 Z" fill="%s" %s/>' % (col, st)
    return ""


def svg(iid, top, bot, line, kind):
    ring = ('<g transform="translate(32,32)"><circle r="21" fill="none" stroke="%s" stroke-width="2.2" opacity="0.95"/>'
            '<circle r="17" fill="none" stroke="%s" stroke-width="1.2" opacity="0.7"/>'
            '<polyline points="%s" fill="none" stroke="%s" stroke-width="1.6" opacity="0.85"/>'
            '<g transform="translate(0,0) scale(1.15)">%s</g></g>') % (line, line, star(18.5, -math.pi / 2), line, symbol(kind, line))
    return ('<?xml version="1.0" encoding="UTF-8"?>\n'
            '<svg xmlns="http://www.w3.org/2000/svg" width="64" height="64" viewBox="0 0 64 64"><defs>'
            '<linearGradient id="bg" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="%s"/><stop offset="1" stop-color="%s"/></linearGradient>'
            '<radialGradient id="gl" cx="0.5" cy="0.3" r="0.7"><stop offset="0" stop-color="#ffffff" stop-opacity="0.35"/><stop offset="1" stop-color="#ffffff" stop-opacity="0"/></radialGradient></defs>'
            '<rect x="2" y="2" width="60" height="60" rx="14" fill="#1a1020"/>'
            '<rect x="4" y="4" width="56" height="56" rx="12" fill="url(#bg)"/>'
            '<rect x="4" y="4" width="56" height="56" rx="12" fill="url(#gl)"/>'
            '<rect x="4.8" y="4.8" width="54.4" height="54.4" rx="11.4" fill="none" stroke="#e8c890" stroke-width="1.6" opacity="0.8"/>'
            '%s</svg>\n') % (top, bot, ring)


if __name__ == "__main__":
    lines = []
    for iid, (name, top, bot, line, kind) in ICONS.items():
        with open(os.path.join(OUT, iid + ".svg"), "w", encoding="utf-8") as fh:
            fh.write(svg(iid, top, bot, line, kind))
        lines.append("%s,%s" % (name, iid))
    path = os.path.join(OUT, "..", "..", "..", "data", "spell_icons.txt")
    with open(path, encoding="utf-8") as fh:
        cur = fh.read().splitlines()
    names = {l.rsplit(",", 1)[0] for l in cur}
    add = [l for l in lines if l.rsplit(",", 1)[0] not in names]
    if add:
        with open(path, "a", encoding="utf-8", newline="") as fh:
            fh.write("\n".join(add) + "\n")
    print("OK", len(ICONS), "icônes ;", len(add), "entrées ajoutées")
