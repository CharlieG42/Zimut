#!/usr/bin/env python3
"""gen_skins.py — Génère les skins SVG des ennemis et des invocations de Zimut.

Style : personnages « chibi » (grosse tête), contour sombre épais, dégradés doux et
reflets, tournés vers la DROITE (EntityView les retourne selon la cible).
Usage : python3 tools/gen_skins.py   (écrit dans assets/sprites/enemies et /summons)
Aperçu : python3 tools/gen_skins.py --sheet apercu.png   (nécessite cairosvg + Pillow)
"""
import os, sys

OL = "#2b1722"          # couleur de contour
HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, "..", "assets", "sprites")


# ── Helpers SVG ─────────────────────────────────────────────────────────────
def lg(i, c1, c2, x1=0, y1=0, x2=0, y2=1):
    return (f'<linearGradient id="{i}" x1="{x1}" y1="{y1}" x2="{x2}" y2="{y2}">'
            f'<stop offset="0" stop-color="{c1}"/><stop offset="1" stop-color="{c2}"/></linearGradient>')


def rg(i, c1, c2, cx=.35, cy=.3, r=.85):
    return (f'<radialGradient id="{i}" cx="{cx}" cy="{cy}" r="{r}">'
            f'<stop offset="0" stop-color="{c1}"/><stop offset="1" stop-color="{c2}"/></radialGradient>')


def svg(w, h, defs, body):
    return (f'<?xml version="1.0" encoding="UTF-8"?>\n<svg xmlns="http://www.w3.org/2000/svg" '
            f'width="{w}" height="{h}" viewBox="0 0 {w} {h}"><defs>{defs}</defs>{body}</svg>\n')


def ell(cx, cy, rx, ry, fill, sw=3, op=1.0, stroke=OL):
    s = f' stroke="{stroke}" stroke-width="{sw}"' if sw else ""
    return f'<ellipse cx="{cx}" cy="{cy}" rx="{rx}" ry="{ry}" fill="{fill}"{s} opacity="{op}"/>'


def path(d, fill="none", sw=3, stroke=OL, cap="round", op=1.0):
    s = f' stroke="{stroke}" stroke-width="{sw}" stroke-linecap="{cap}" stroke-linejoin="round"' if sw else ""
    return f'<path d="{d}" fill="{fill}"{s} opacity="{op}"/>'


def poly(pts, fill, sw=3, stroke=OL):
    p = " ".join(f"{x},{y}" for x, y in pts)
    s = f' stroke="{stroke}" stroke-width="{sw}" stroke-linejoin="round"' if sw else ""
    return f'<polygon points="{p}" fill="{fill}"{s}/>'


def rect(x, y, w, h, fill, r=4, sw=3):
    s = f' stroke="{OL}" stroke-width="{sw}"' if sw else ""
    return f'<rect x="{x}" y="{y}" width="{w}" height="{h}" rx="{r}" fill="{fill}"{s}/>'


def shine(cx, cy, rx, ry, op=0.30):
    return ell(cx, cy, rx, ry, "#ffffff", 0, op)


def eye(cx, cy, r=7, pupil="#1a1020", look=1.5, glow=None):
    out = ell(cx, cy, r, r * 1.15, "#fffdf5", 2.2)
    if glow:
        out += ell(cx + look, cy + 1, r * 0.62, r * 0.75, glow, 0)
    out += ell(cx + look, cy + 1, r * 0.46, r * 0.58, pupil, 0)
    out += ell(cx + look - r * 0.2, cy - r * 0.25, r * 0.17, r * 0.17, "#ffffff", 0)
    return out


def shadow(cx, cy, rx):
    return ell(cx, cy, rx, rx * 0.22, "#000000", 0, 0.18)


# ── ENNEMIS ─────────────────────────────────────────────────────────────────
def gobelin():
    d = (lg("sk", "#b5e25a", "#5f9b2c") + lg("tn", "#a8703a", "#6b4220") + lg("bl", "#cfd6de", "#7d8794", 0, 0, 1, 0))
    b = shadow(80, 190, 44)
    b += rect(52, 156, 22, 30, "#4a2f1a", 7) + rect(86, 156, 22, 30, "#4a2f1a", 7)
    # bras gauche + dague
    b += path("M52,112 Q30,120 26,142", sw=11, stroke=OL) + path("M52,112 Q30,120 26,142", sw=6, stroke="#7fb83a")
    b += poly([(18, 128), (26, 100), (34, 128)], "url(#bl)", 2.5) + rect(21, 126, 10, 18, "#5b3a1c", 3, 2.5)
    # corps
    b += ell(80, 134, 30, 32, "url(#tn)") + path("M52,140 Q80,152 108,140", sw=6, stroke="#3b2414")
    b += rect(74, 136, 12, 12, "#e2b84a", 3, 2) + shine(68, 124, 10, 14, .18)
    # bras droit levé
    b += path("M108,112 Q130,108 134,86", sw=11, stroke=OL) + path("M108,112 Q130,108 134,86", sw=6, stroke="#7fb83a")
    b += ell(135, 82, 8, 8, "#7fb83a", 2.5)
    # oreilles
    b += path("M52,76 Q14,62 8,50 Q24,84 54,92 Z", "url(#sk)") + path("M108,76 Q146,62 152,50 Q136,84 106,92 Z", "url(#sk)")
    b += path("M48,76 Q26,66 20,58 Q30,78 48,84", "#e88aa0", 0, op=0.8) + path("M112,76 Q134,66 140,58 Q130,78 112,84", "#e88aa0", 0, op=0.8)
    # tête
    b += ell(80, 80, 36, 33, "url(#sk)") + shine(66, 62, 15, 9, .35)
    b += path("M52,64 L72,72", sw=4.5) + path("M108,64 L88,72", sw=4.5)
    b += eye(66, 80, 8, "#c01818", 1, "#ff6a3a") + eye(94, 80, 8, "#c01818", -1, "#ff6a3a")
    b += ell(80, 92, 7, 5, "#3d7a1c", 2.5)
    b += path("M62,102 Q80,116 98,102", "#5a1010", 3)
    b += poly([(68, 104), (72, 112), (76, 105)], "#fffdf0", 1.8) + poly([(84, 105), (88, 112), (92, 104)], "#fffdf0", 1.8)
    return svg(160, 200, d, b)


def squelette():
    d = lg("bn", "#fffbe8", "#cfc6a0") + rg("gl", "#9ff3ff", "#2aa8d8", .5, .5, .6)
    b = shadow(80, 190, 40)
    # jambes
    for x in (64, 96):
        b += path(f"M{x},140 L{x},178", sw=11, stroke=OL) + path(f"M{x},140 L{x},178", sw=6, stroke="url(#bn)")
        b += ell(x, 178, 9, 5, "#e9e1bd", 2.5) + ell(x, 143, 7, 6, "#fffbe8", 2.5)
    # bassin / côtes
    b += path("M62,136 Q80,150 98,136 L96,124 L64,124 Z", "url(#bn)")
    b += path("M80,92 L80,130", sw=7, stroke=OL) + path("M80,92 L80,130", sw=3.5, stroke="#e9e1bd")
    for i, y in enumerate((100, 110, 120)):
        w = 28 - i * 3
        b += path(f"M{80 - w},{y - 4} Q80,{y + 6} {80 + w},{y - 4}", sw=7.5, stroke=OL) + \
             path(f"M{80 - w},{y - 4} Q80,{y + 6} {80 + w},{y - 4}", sw=4, stroke="url(#bn)")
    # bras : gauche (tient l'épée) droit levé
    b += path("M56,98 Q36,112 34,138", sw=10, stroke=OL) + path("M56,98 Q36,112 34,138", sw=5.5, stroke="url(#bn)")
    b += path("M104,98 Q126,96 132,76", sw=10, stroke=OL) + path("M104,98 Q126,96 132,76", sw=5.5, stroke="url(#bn)")
    b += ell(34, 140, 7, 7, "#fffbe8", 2.5) + ell(133, 73, 7, 7, "#fffbe8", 2.5)
    # épée rouillée
    b += rect(30, 100, 7, 42, "#9a7b55", 2, 2.5) + poly([(28, 100), (39, 100), (34, 60)], "#b9b4a8", 2.5)
    b += rect(24, 138, 20, 6, "#6b4a2a", 3, 2.5)
    # lambeau de tissu
    b += path("M62,134 L56,160 L70,152 L76,164 L84,140 Z", "#5b3a64", 2.5)
    # crâne
    b += ell(80, 70, 33, 30, "url(#bn)") + shine(66, 52, 14, 8, .45)
    b += path("M62,92 L62,102 L98,102 L98,92", "#efe8c8", 3) + path("M70,94 L70,102 M80,94 L80,102 M90,94 L90,102", sw=2.2)
    b += ell(66, 70, 11, 13, "#1c1426", 2.5) + ell(94, 70, 11, 13, "#1c1426", 2.5)
    b += ell(67, 72, 5, 6, "url(#gl)", 0) + ell(93, 72, 5, 6, "url(#gl)", 0)
    b += poly([(80, 80), (74, 90), (86, 90)], "#1c1426", 2)
    b += path("M52,52 L58,60 M108,52 L102,60", sw=2.4, op=0.6)
    return svg(160, 200, d, b)


def loup(body_a="#9aa1ae", body_b="#515968", belly="#e4e6ea", eyes="#ffd23a", aura=None, runes=False):
    d = lg("fur", body_a, body_b) + lg("bel", belly, "#b9bec8")
    b = shadow(80, 154, 56)
    if aura:
        b += ell(80, 100, 66, 54, aura, 0, 0.18) + ell(80, 100, 52, 42, aura, 0, 0.18)
    # queue
    b += path("M34,104 Q8,100 12,66 Q26,86 44,92", "url(#fur)", 3.5)
    b += path("M16,74 Q18,84 30,92", sw=2.4, stroke="#ffffff", op=0.4)
    # pattes arrière/avant
    for x, o in ((46, 0.0), (104, 0.0)):
        b += path(f"M{x},118 L{x - 2},148", sw=15, stroke=OL) + path(f"M{x},118 L{x - 2},148", sw=10, stroke="url(#fur)")
        b += ell(x - 1, 150, 10, 6, "#464d5b", 2.5)
    # corps
    b += ell(76, 112, 46, 28, "url(#fur)") + ell(84, 126, 28, 13, "url(#bel)", 0, 0.9)
    b += shine(64, 98, 20, 7, .25)
    for x, o in ((64, 0.0), (120, 0.0)):
        b += path(f"M{x},124 L{x + 2},150", sw=15, stroke=OL) + path(f"M{x},124 L{x + 2},150", sw=10, stroke="url(#fur)")
        b += ell(x + 3, 152, 10, 6, "#5d6573", 2.5)
    # crinière
    b += path("M96,92 Q104,74 120,76 L124,100 Q108,106 96,104 Z", "url(#fur)", 3)
    # tête
    b += path("M104,78 Q112,58 134,60 Q158,66 156,86 Q150,102 130,102 Q108,104 104,78 Z", "url(#fur)")
    b += path("M134,80 Q152,78 158,90 Q152,100 134,98 Z", "url(#bel)")
    b += ell(157, 88, 5, 4, "#1a1520", 1.5)
    b += path("M126,98 Q140,106 154,98", "#7a1a2a", 2.5) + poly([(136, 100), (139, 108), (142, 100)], "#ffffff", 1.6)
    b += poly([(110, 66), (112, 40), (124, 60)], "url(#fur)", 3) + poly([(126, 60), (136, 38), (142, 62)], "url(#fur)", 3)
    b += poly([(114, 60), (114, 48), (120, 58)], "#e88aa0", 0)
    b += ell(130, 76, 8, 6.5, "#fffdf5", 2.2) + ell(132, 76, 5, 5.5, eyes, 0) + ell(133, 76, 1.8, 5, "#1a1020", 0)
    b += path("M120,66 L142,72", sw=3.5)
    if runes:
        b += path("M70,100 L78,108 L70,116 M88,98 L96,106 L88,114", sw=2.6, stroke="#bff6ff")
    return svg(170, 165, d, b)


def troll():
    d = lg("sk", "#9fc07a", "#5b7f47") + lg("be", "#c6d9a5", "#8aa86d") + lg("wd", "#9a6a3a", "#5f3d20")
    b = shadow(80, 192, 58)
    # jambes
    b += rect(42, 148, 30, 40, "url(#sk)", 12) + rect(88, 148, 30, 40, "url(#sk)", 12)
    b += ell(57, 188, 19, 7, "#6a8a52", 2.5) + ell(103, 188, 19, 7, "#6a8a52", 2.5)
    # massue (derrière)
    b += path("M138,100 L150,176", sw=17, stroke=OL) + path("M138,100 L150,176", sw=11, stroke="url(#wd)")
    b += ell(133, 84, 22, 28, "url(#wd)") + poly([(116, 78), (106, 72), (116, 88)], "#d9d4c4", 2) + poly([(150, 80), (160, 76), (150, 92)], "#d9d4c4", 2)
    b += poly([(128, 58), (133, 46), (138, 58)], "#d9d4c4", 2)
    # corps massif
    b += ell(80, 118, 50, 46, "url(#sk)") + ell(80, 126, 32, 30, "url(#be)", 2.5, 0.95) + shine(56, 94, 18, 12, .25)
    b += path("M44,150 Q80,174 116,150 L112,140 Q80,158 48,140 Z", "#7a5230", 3)
    # bras
    b += path("M34,100 Q14,124 24,152", sw=24, stroke=OL) + path("M34,100 Q14,124 24,152", sw=17, stroke="url(#sk)")
    b += ell(24, 154, 13, 12, "url(#sk)", 3)
    b += path("M126,98 Q140,106 138,116", sw=24, stroke=OL) + path("M126,98 Q140,106 138,116", sw=17, stroke="url(#sk)")
    b += ell(137, 118, 13, 12, "url(#sk)", 3)
    # mousse
    b += ell(52, 90, 7, 4, "#5f9b3a", 0, 0.9) + ell(106, 150, 8, 4, "#5f9b3a", 0, 0.9)
    # tête
    b += ell(80, 64, 29, 25, "url(#sk)") + shine(70, 50, 12, 7, .3)
    b += path("M56,56 L74,64 M104,56 L86,64", sw=5)
    b += eye(68, 66, 6, "#2a1a10", 1, "#f0c040") + eye(92, 66, 6, "#2a1a10", -1, "#f0c040")
    b += ell(80, 76, 7, 5, "#6a8a52", 2.2)
    b += path("M62,82 Q80,90 98,82", "#4a2a20", 3)
    b += poly([(66, 82), (62, 66), (72, 82)], "#fffdf0", 2) + poly([(94, 82), (98, 66), (88, 82)], "#fffdf0", 2)
    b += path("M48,60 Q38,52 40,44 Q52,50 56,56", "url(#sk)", 2.5) + path("M112,60 Q122,52 120,44 Q108,50 104,56", "url(#sk)", 2.5)
    return svg(170, 200, d, b)


def dragonnet(main="#f2813a", dark="#a8381e", belly="#ffd9a0", wing="#c9442a", eyes="#fff06a",
              horns="#f6ecd2", boss=False):
    d = lg("bd", main, dark) + lg("bl", belly, "#e9b878") + lg("wg", wing, dark)
    b = shadow(80, 190, 40)
    if boss:
        b += ell(80, 100, 74, 62, "#ff3a1a", 0, 0.10) + ell(80, 100, 58, 48, "#ff6a2a", 0, 0.10)
    # ailes
    b += path("M62,92 Q16,44 6,22 Q24,40 34,36 Q30,52 46,56 Q42,70 66,82 Z", "url(#wg)", 3.5)
    b += path("M98,92 Q144,44 154,22 Q136,40 126,36 Q130,52 114,56 Q118,70 94,82 Z", "url(#wg)", 3.5)
    b += path("M62,88 Q36,56 20,34 M64,84 Q50,66 38,52", sw=2, stroke=OL, op=0.55)
    b += path("M98,88 Q124,56 140,34 M96,84 Q110,66 122,52", sw=2, stroke=OL, op=0.55)
    # queue
    b += path("M104,150 Q148,158 150,126 Q132,142 118,134", "url(#bd)", 3.5)
    b += poly([(148, 120), (160, 110), (156, 134)], dark, 2.5)
    # corps
    b += ell(80, 122, 34, 38, "url(#bd)") + ell(80, 130, 22, 28, "url(#bl)", 0, 0.95)
    for y in (116, 126, 136, 146):
        b += path(f"M66,{y} Q80,{y + 5} 94,{y}", sw=2, stroke="#b57a45", op=0.8)
    b += shine(64, 106, 12, 18, .22)
    if boss:
        for i, (x, y) in enumerate(((80, 84), (72, 90), (88, 90), (66, 102), (94, 102))):
            b += poly([(x - 5, y), (x, y - 14), (x + 5, y)], "#3a0e10", 2)
    # pattes
    b += rect(56, 152, 20, 30, "url(#bd)", 9) + rect(84, 152, 20, 30, "url(#bd)", 9)
    b += poly([(56, 182), (60, 190), (64, 182), (68, 190), (76, 182)], horns, 2) + poly([(84, 182), (88, 190), (92, 182), (96, 190), (104, 182)], horns, 2)
    # bras
    b += path("M52,112 Q38,124 42,138", sw=9, stroke=OL) + path("M52,112 Q38,124 42,138", sw=5, stroke="url(#bd)")
    b += path("M108,112 Q122,124 118,138", sw=9, stroke=OL) + path("M108,112 Q122,124 118,138", sw=5, stroke="url(#bd)")
    # cornes + tête
    hs = 1.4 if boss else 1.0
    b += path(f"M58,60 Q{44 - 6 * hs:.0f},{30 - 12 * hs:.0f} {36 - 4 * hs:.0f},{20 - 8 * hs:.0f} Q{60:.0f},{40:.0f} 70,52 Z", horns, 3)
    b += path(f"M102,60 Q{116 + 6 * hs:.0f},{30 - 12 * hs:.0f} {124 + 4 * hs:.0f},{20 - 8 * hs:.0f} Q{100:.0f},{40:.0f} 90,52 Z", horns, 3)
    if boss:
        b += poly([(76, 46), (80, 24), (84, 46)], horns, 2.5)
    b += ell(80, 76, 31, 27, "url(#bd)") + shine(68, 60, 12, 7, .35)
    b += path("M64,80 Q80,100 104,86 Q112,76 100,70 Q80,64 64,80 Z", "url(#bl)", 2.5)
    b += ell(94, 80, 2.4, 3.2, "#3a1a10", 0) + ell(100, 79, 2.4, 3.2, "#3a1a10", 0)
    b += eye(66, 68, 7, "#2a1010", 1.5, eyes) + eye(88, 66, 6.5, "#2a1010", 1.5, eyes)
    b += path("M56,58 L74,64 M96,56 L82,63", sw=4)
    b += path("M70,92 Q82,98 98,90", sw=2.4, stroke="#7a1a1a") + poly([(78, 93), (80, 98), (83, 94)], "#ffffff", 1.4)
    return svg(160, 200, d, b)


# ── INVOCATIONS ─────────────────────────────────────────────────────────────
def tortue():
    d = lg("sh", "#8bd16a", "#3f7a3a") + lg("sk", "#c9e08a", "#86ad52") + rg("hx", "#6fb558", "#2f6b34", .4, .3, .9)
    b = shadow(84, 124, 62)
    for x in (42, 112):
        b += rect(x, 98, 24, 28, "url(#sk)", 10)
    b += path("M118,92 Q150,86 156,60 Q164,86 150,100 Q134,106 120,100 Z", "url(#sk)", 3)
    b += ell(150, 78, 20, 17, "url(#sk)") + shine(144, 70, 8, 5, .4)
    b += eye(156, 72, 6, "#1a1020", 1.2) + path("M143,86 Q152,92 160,84", sw=2.6)
    b += path("M18,102 Q16,40 84,36 Q150,40 144,102 Q84,118 18,102 Z", "url(#sh)", 3.5)
    b += path("M30,98 Q84,112 134,98", sw=4, stroke="#d8c88a") + shine(60, 56, 22, 10, .35)
    for (x, y) in ((84, 62), (52, 72), (116, 72), (66, 92), (102, 92)):
        b += poly([(x - 14, y), (x - 7, y - 11), (x + 7, y - 11), (x + 14, y), (x + 7, y + 11), (x - 7, y + 11)], "url(#hx)", 2.6)
    return svg(170, 130, d, b)


def sirene():
    d = lg("tl", "#6ee6d8", "#1f8fb5") + lg("hr", "#4fd0e8", "#2670c8") + lg("sk", "#ffe7d2", "#f0bf9c")
    b = shadow(80, 188, 34)
    b += ell(80, 100, 62, 56, "#6ee6ff", 0, 0.12)
    # queue de poisson
    b += path("M64,118 Q40,150 62,178 Q70,168 80,170 Q90,168 98,178 Q120,150 96,118 Z", "url(#tl)", 3.5)
    b += path("M52,178 Q36,184 26,196 Q50,196 62,184 Z", "url(#tl)", 3) + path("M108,178 Q124,184 134,196 Q110,196 98,184 Z", "url(#tl)", 3)
    for y in (132, 146, 160):
        b += path(f"M68,{y} Q80,{y + 8} 92,{y}", sw=2.2, stroke="#17728f", op=0.8)
    # cheveux (arrière)
    b += path("M52,60 Q30,110 44,150 Q58,120 60,90 Z", "url(#hr)", 3) + path("M108,60 Q130,110 116,150 Q102,120 100,90 Z", "url(#hr)", 3)
    # buste
    b += path("M64,84 Q80,92 96,84 L98,118 Q80,126 62,118 Z", "url(#sk)", 3)
    b += path("M64,100 Q72,92 80,102 Q88,92 96,100 L96,112 Q80,120 64,112 Z", "#f5a0c0", 3) + shine(70, 98, 4, 3, .6)
    b += path("M64,88 Q52,100 56,116", sw=9, stroke=OL) + path("M64,88 Q52,100 56,116", sw=5, stroke="url(#sk)")
    b += path("M96,88 Q112,92 118,76", sw=9, stroke=OL) + path("M96,88 Q112,92 118,76", sw=5, stroke="url(#sk)")
    b += ell(119, 72, 6, 6, "url(#sk)", 2.5) + ell(124, 56, 4, 4, "#bff6ff", 1.5) + ell(114, 48, 3, 3, "#bff6ff", 1.5)
    # tête
    b += ell(80, 60, 25, 24, "url(#sk)") + path("M54,58 Q56,30 80,28 Q106,30 106,58 Q96,42 80,44 Q64,42 54,58 Z", "url(#hr)", 3)
    b += ell(66, 62, 5.5, 6.5, "#fffdf5", 2) + ell(94, 62, 5.5, 6.5, "#fffdf5", 2)
    b += ell(67, 63, 3.4, 4.4, "#2a6ac8", 0) + ell(95, 63, 3.4, 4.4, "#2a6ac8", 0) + ell(68, 61, 1.2, 1.2, "#ffffff", 0) + ell(96, 61, 1.2, 1.2, "#ffffff", 0)
    b += path("M74,74 Q80,79 86,74", sw=2.4, stroke="#b04060")
    b += ell(60, 70, 4, 2.4, "#ff9ab0", 0, 0.7) + ell(100, 70, 4, 2.4, "#ff9ab0", 0, 0.7)
    b += path("M104,56 Q116,40 106,30", "#ffd6e6", 2.5) + ell(106, 32, 6, 5, "#ffd6e6", 2)
    return svg(160, 200, d, b)


def ange():
    d = lg("rb", "#ffffff", "#e8e0c0") + lg("wg", "#ffffff", "#d6e6ff") + lg("sk", "#ffe9d6", "#f2c8a4") + rg("gl", "#fff6b0", "#ffd24a", .5, .5, .6)
    b = shadow(80, 190, 34)
    b += ell(80, 90, 70, 64, "#fff3a0", 0, 0.16) + ell(80, 90, 52, 48, "#fff3a0", 0, 0.16)
    # ailes
    b += path("M62,90 Q14,70 6,28 Q30,40 38,34 Q38,56 54,60 Q46,76 66,84 Z", "url(#wg)", 3.5)
    b += path("M98,90 Q146,70 154,28 Q130,40 122,34 Q122,56 106,60 Q114,76 94,84 Z", "url(#wg)", 3.5)
    b += path("M60,84 Q34,64 20,38 M62,80 Q46,68 40,50", sw=2, stroke="#9fb4d8", op=0.9) + path("M100,84 Q126,64 140,38 M98,80 Q114,68 120,50", sw=2, stroke="#9fb4d8", op=0.9)
    # robe
    b += path("M60,96 Q80,88 100,96 L112,176 Q80,190 48,176 Z", "url(#rb)", 3.5)
    b += path("M62,120 Q80,128 98,120", sw=5, stroke="#e8c04a") + shine(66, 120, 6, 24, .5)
    b += path("M68,176 Q80,184 92,176", sw=2.2, stroke="#c9c0a0")
    # bras / mains jointes
    b += path("M62,102 Q50,122 74,130", sw=11, stroke=OL) + path("M62,102 Q50,122 74,130", sw=6, stroke="url(#rb)")
    b += path("M98,102 Q110,122 86,130", sw=11, stroke=OL) + path("M98,102 Q110,122 86,130", sw=6, stroke="url(#rb)")
    b += ell(80, 130, 9, 8, "url(#sk)", 2.5)
    # tête
    b += ell(80, 66, 25, 24, "url(#sk)") + path("M55,64 Q54,38 80,36 Q106,38 105,64 Q96,50 80,52 Q64,50 55,64 Z", "#ffe27a", 3)
    b += ell(80, 30, 24, 7, "none", 4.5, 1, "#f0b820") + ell(80, 30, 24, 7, "none", 2, 1, "#fff6a0")
    b += eye(69, 68, 5, "#3a6ad0", 0.8) + eye(91, 68, 5, "#3a6ad0", 0.8)
    b += path("M75,80 Q80,84 85,80", sw=2.4, stroke="#b04060") + ell(62, 76, 4, 2.4, "#ff9ab0", 0, 0.6) + ell(98, 76, 4, 2.4, "#ff9ab0", 0, 0.6)
    return svg(160, 200, d, b)


def homme_faucon():
    d = lg("fe", "#c98a4a", "#6b4020") + lg("wg", "#a8703a", "#4a2c16") + lg("tn", "#4a7ac0", "#274a86") + lg("sk", "#ffd0a0", "#d99c68")
    b = shadow(80, 190, 40)
    # ailes déployées
    b += path("M60,92 Q10,66 2,26 L22,40 L26,24 L40,44 L48,34 L56,56 Q50,76 66,86 Z", "url(#wg)", 3.5)
    b += path("M100,92 Q150,66 158,26 L138,40 L134,24 L120,44 L112,34 L104,56 Q110,76 94,86 Z", "url(#wg)", 3.5)
    b += path("M52,76 Q24,58 14,38 M110,76 Q136,58 146,38", sw=2.2, stroke="#f0c890", op=0.7)
    # jambes + serres
    for x in (68, 92):
        b += path(f"M{x},150 L{x},176", sw=10, stroke=OL) + path(f"M{x},150 L{x},176", sw=5.5, stroke="#e0b030")
        b += path(f"M{x - 8},186 Q{x},170 {x + 8},186", sw=3.5, stroke=OL, cap="round") + path(f"M{x - 6},184 L{x - 10},190 M{x},182 L{x},190 M{x + 6},184 L{x + 10},190", sw=3, stroke="#e0b030")
    # tunique
    b += path("M60,96 Q80,88 100,96 L104,152 Q80,162 56,152 Z", "url(#tn)", 3.5) + path("M56,134 Q80,146 104,134", sw=4, stroke="#e8d070") + shine(66, 112, 6, 14, .3)
    b += path("M62,104 Q50,126 60,144", sw=11, stroke=OL) + path("M62,104 Q50,126 60,144", sw=6, stroke="url(#fe)")
    b += path("M98,104 Q112,114 108,132", sw=11, stroke=OL) + path("M98,104 Q112,114 108,132", sw=6, stroke="url(#fe)")
    # tête de faucon
    b += ell(80, 66, 26, 25, "url(#fe)") + shine(70, 52, 10, 6, .3)
    b += path("M60,52 L52,40 L68,48 M100,52 L108,40 L92,48", "url(#fe)", 2.5)
    b += ell(80, 76, 15, 11, "#fff2d8", 2.5)
    b += path("M74,70 Q80,66 86,70 L80,92 Z", "#f2c030", 3)
    b += eye(66, 62, 7, "#1a1020", 1.5, "#ffd23a") + eye(94, 62, 7, "#1a1020", -1.5, "#ffd23a")
    b += path("M56,50 L72,58 M104,50 L88,58", sw=4)
    return svg(160, 200, d, b)


def centaure():
    d = lg("hr", "#b7774a", "#6a3d22") + lg("sk", "#ffd9b0", "#d9a070") + lg("hl", "#5a3a22", "#2d1a0e") + lg("tn", "#7ab05a", "#3d6a32")
    b = shadow(80, 160, 62)
    # queue
    b += path("M30,92 Q6,108 14,140 Q26,118 36,108", "url(#hl)", 3)
    # pattes
    for x, dx in ((42, -3), (62, 2), (104, -2), (124, 3)):
        b += path(f"M{x},124 L{x + dx},152", sw=14, stroke=OL) + path(f"M{x},124 L{x + dx},152", sw=9, stroke="url(#hr)")
        b += rect(x + dx - 7, 148, 14, 10, "#2d1a0e", 4, 2.5)
    # corps de cheval
    b += ell(82, 108, 52, 30, "url(#hr)") + shine(66, 94, 26, 8, .25)
    b += path("M120,92 Q132,70 128,62 L142,66 Q144,90 134,112 Z", "url(#hr)", 3)
    b += path("M126,64 Q118,86 124,100", sw=5, stroke="#2d1a0e")
    # torse humain
    b += path("M122,70 Q134,64 146,70 L148,100 Q134,106 120,100 Z", "url(#tn)", 3.5)
    b += path("M146,76 Q160,84 164,70", sw=10, stroke=OL) + path("M146,76 Q160,84 164,70", sw=5.5, stroke="url(#sk)")
    # arc
    b += path("M150,52 Q172,76 150,104", sw=4.5, stroke="#5b3a1c") + path("M150,52 L150,104", sw=1.6, stroke="#f0e8d0")
    b += path("M120,80 Q108,92 112,104", sw=10, stroke=OL) + path("M120,80 Q108,92 112,104", sw=5.5, stroke="url(#sk)")
    # tête
    b += ell(134, 46, 20, 19, "url(#sk)") + path("M114,44 Q112,22 134,22 Q158,24 154,46 Q144,32 134,34 Q124,32 114,44 Z", "url(#hl)", 3)
    b += eye(128, 48, 5, "#2a5a2a", 1) + eye(144, 48, 5, "#2a5a2a", 1)
    b += path("M130,58 Q136,62 142,58", sw=2.4, stroke="#a04050")
    return svg(176, 168, d, b)


def buisson():
    d = rg("bu", "#8fd05a", "#2f6b2a", .4, .3, .9)
    b = shadow(80, 150, 52)
    b += path("M16,120 Q4,92 28,78 Q22,52 52,52 Q60,24 90,36 Q116,22 128,50 Q156,56 146,84 Q162,106 138,122 Q120,150 80,148 Q40,150 16,120 Z", "url(#bu)", 3.5)
    for (x, y) in ((34, 84), (60, 64), (100, 58), (130, 78), (46, 112), (118, 112)):
        b += path(f"M{x - 6},{y + 6} Q{x},{y - 6} {x + 6},{y + 6}", sw=2.4, stroke="#1f4a1c", op=0.7)
    for (x, y, c) in ((40, 70, "#ff8ab0"), (112, 62, "#ffd24a"), (136, 100, "#ff8ab0"), (26, 106, "#ffd24a")):
        b += ell(x, y, 6, 6, c, 2) + ell(x, y, 2.4, 2.4, "#fff6c0", 0)
    b += shine(58, 70, 22, 12, .25)
    b += eye(62, 100, 8, "#1a1020", 1.5) + eye(96, 100, 8, "#1a1020", 1.5)
    b += path("M70,120 Q80,128 92,120", sw=3, stroke="#2a1410")
    for (x, y, a) in ((22, 98, 0), (140, 94, 0), (82, 36, 0)):
        b += poly([(x - 4, y + 8), (x, y - 8), (x + 4, y + 8)], "#d9e8a0", 2)
    return svg(166, 156, d, b)


def champignon():
    d = rg("cp", "#ff7a5a", "#b02a2a", .4, .25, .9) + lg("st", "#fff4dc", "#d9c49a")
    b = shadow(80, 176, 40)
    b += rect(60, 112, 44, 56, "url(#st)", 18) + shine(70, 130, 6, 18, .45)
    b += rect(56, 162, 20, 14, "#e8d4aa", 6) + rect(88, 162, 20, 14, "#e8d4aa", 6)
    b += path("M82,106 Q46,106 28,84 Q10,56 36,34 Q82,6 128,34 Q154,56 136,84 Q118,106 82,106 Z", "url(#cp)", 3.5)
    b += ell(54, 60, 11, 8, "#fff4dc", 2.5) + ell(104, 50, 9, 7, "#fff4dc", 2.5) + ell(82, 78, 8, 6, "#fff4dc", 2.5) + ell(122, 78, 7, 5, "#fff4dc", 2.5) + ell(36, 88, 6, 4, "#fff4dc", 2.5)
    b += shine(60, 40, 20, 8, .35)
    b += eye(70, 128, 7, "#1a1020", 1) + eye(94, 128, 7, "#1a1020", 1)
    b += path("M74,146 Q82,152 90,146", sw=2.8, stroke="#8a3a2a") + ell(62, 140, 4, 2.4, "#ff9a8a", 0, 0.7) + ell(102, 140, 4, 2.4, "#ff9a8a", 0, 0.7)
    for (x, y) in ((22, 120), (140, 116), (146, 96)):
        b += ell(x, y, 3, 3, "#e8ffb0", 0, 0.9)
    return svg(166, 184, d, b)


def tronc():
    d = lg("wd", "#a8764a", "#5a3a20", 0, 0, 1, 0) + lg("lf", "#7fc85a", "#2f6b2a")
    b = shadow(80, 192, 52)
    for (x, dx) in ((34, -8), (126, 8)):
        b += path(f"M{x},168 Q{x + dx},184 {x + dx * 2},192", sw=14, stroke=OL) + path(f"M{x},168 Q{x + dx},184 {x + dx * 2},192", sw=8.5, stroke="url(#wd)")
    b += path("M44,170 Q34,110 46,64 L114,64 Q126,110 116,170 Q80,182 44,170 Z", "url(#wd)", 3.5)
    for x in (58, 76, 98):
        b += path(f"M{x},84 Q{x - 4},120 {x + 2},160", sw=2.6, stroke="#3a2412", op=0.7)
    # bras-branches
    b += path("M46,96 Q18,84 10,56 M24,76 L8,78", sw=13, stroke=OL) + path("M46,96 Q18,84 10,56 M24,76 L8,78", sw=8, stroke="url(#wd)")
    b += path("M114,96 Q142,84 150,56 M136,76 L152,78", sw=13, stroke=OL) + path("M114,96 Q142,84 150,56 M136,76 L152,78", sw=8, stroke="url(#wd)")
    for (x, y) in ((10, 50), (152, 50), (8, 80), (154, 80)):
        b += ell(x, y, 11, 8, "url(#lf)", 2.5)
    # cime
    b += ell(80, 40, 44, 28, "url(#lf)", 3.5) + ell(52, 30, 26, 20, "url(#lf)", 3) + ell(110, 30, 26, 20, "url(#lf)", 3) + ell(80, 18, 24, 16, "url(#lf)", 3)
    b += shine(62, 22, 16, 6, .3)
    b += ell(80, 64, 40, 8, "#5a3a20", 0, 0.5)
    # visage
    b += path("M60,92 L76,98 M100,92 L84,98", sw=5) + ell(68, 104, 8, 9, "#fff6d0", 2.2) + ell(92, 104, 8, 9, "#fff6d0", 2.2)
    b += ell(69, 105, 3.6, 5, "#1a1020", 0) + ell(93, 105, 3.6, 5, "#1a1020", 0) + ell(68, 102, 1.4, 1.4, "#fff", 0)
    b += ell(80, 124, 10, 8, "#3a2012", 2.5) + ell(80, 126, 6, 4, "#8a2a2a", 0)
    return svg(160, 200, d, b)


def sarriette():
    d = lg("lf", "#a8e66a", "#3f8a3a") + lg("sk", "#ffe9c8", "#e8bd8a") + lg("hr", "#7ad06a", "#2f7a3a")
    b = shadow(80, 188, 30)
    # fouet de liane
    b += path("M114,118 Q150,100 140,70 Q132,50 150,34", sw=7, stroke=OL) + path("M114,118 Q150,100 140,70 Q132,50 150,34", sw=3.5, stroke="#4da040")
    b += ell(152, 30, 8, 6, "url(#lf)", 2.5)
    # jambes
    b += path("M70,150 L68,180", sw=9, stroke=OL) + path("M70,150 L68,180", sw=5, stroke="url(#sk)") + path("M90,150 L92,180", sw=9, stroke=OL) + path("M90,150 L92,180", sw=5, stroke="url(#sk)")
    b += ell(66, 183, 9, 5, "#4a8a3a", 2.5) + ell(94, 183, 9, 5, "#4a8a3a", 2.5)
    # robe en feuilles
    b += path("M58,100 Q80,92 102,100 L112,156 L100,146 L92,162 L80,148 L68,162 L60,146 L48,156 Z", "url(#lf)", 3.5)
    b += path("M80,106 L80,150 M66,112 L72,144 M94,112 L88,144", sw=2.2, stroke="#2f6b2a", op=0.7) + shine(66, 116, 5, 14, .3)
    b += path("M60,108 Q46,122 56,138", sw=9, stroke=OL) + path("M60,108 Q46,122 56,138", sw=5, stroke="url(#sk)")
    b += path("M102,108 Q114,116 116,122", sw=9, stroke=OL) + path("M102,108 Q114,116 116,122", sw=5, stroke="url(#sk)")
    # tête + cheveux-feuillage
    b += ell(80, 76, 22, 21, "url(#sk)")
    b += path("M56,76 Q50,40 72,34 Q80,18 96,32 Q114,42 104,76 Q96,56 80,56 Q64,56 56,76 Z", "url(#hr)", 3)
    b += poly([(70, 36), (62, 18), (80, 30)], "url(#lf)", 2.5) + poly([(92, 32), (102, 14), (104, 36)], "url(#lf)", 2.5)
    b += eye(70, 78, 5.5, "#2a6a2a", 1) + eye(90, 78, 5.5, "#2a6a2a", 1)
    b += path("M75,88 Q80,92 85,88", sw=2.4, stroke="#b04060") + ell(63, 85, 3.6, 2.2, "#ff9ab0", 0, 0.7) + ell(97, 85, 3.6, 2.2, "#ff9ab0", 0, 0.7)
    b += path("M60,66 L74,72 M100,66 L86,72", sw=3)
    return svg(160, 200, d, b)


SPRITES = {
    "enemies": {
        "gobelin": gobelin, "squelette": squelette, "loup": lambda: loup(),
        "troll": troll, "dragonnet": lambda: dragonnet(),
        "dragonnet_boss": lambda: dragonnet("#7a1426", "#2a0a14", "#d98a4a", "#4a0e22", "#ff4a2a", "#e8c860", True),
    },
    "summons": {
        "tortue": tortue, "loup": lambda: loup("#cfe8ff", "#6a8ad0", "#ffffff", "#7affff", "#8ad8ff", True),
        "sirene": sirene, "ange": ange, "homme_faucon": homme_faucon, "centaure": centaure,
        "buisson": buisson, "champignon": champignon, "tronc": tronc, "sarriette": sarriette,
    },
}


def main():
    sheet = None
    if "--sheet" in sys.argv:
        sheet = sys.argv[sys.argv.index("--sheet") + 1]
    written = []
    for folder, items in SPRITES.items():
        os.makedirs(os.path.join(OUT, folder), exist_ok=True)
        for name, fn in items.items():
            path_ = os.path.join(OUT, folder, name + ".svg")
            with open(path_, "w", encoding="utf-8") as f:
                f.write(fn())
            written.append((folder, name, path_))
    print(f"{len(written)} skins écrits")
    if sheet:
        import cairosvg
        from PIL import Image
        ims = []
        for folder, name, p in written:
            png = f"/tmp/_skin_{folder}_{name}.png"
            cairosvg.svg2png(url=p, write_to=png, output_height=230)
            ims.append(Image.open(png).convert("RGBA"))
        cols = 6
        rows = (len(ims) + cols - 1) // cols
        cw, ch = 250, 250
        img = Image.new("RGBA", (cols * cw, rows * ch), (96, 124, 80, 255))
        for i, im in enumerate(ims):
            img.paste(im, ((i % cols) * cw + (cw - im.width) // 2, (i // cols) * ch + 10), im)
        img.save(sheet)


if __name__ == "__main__":
    main()
