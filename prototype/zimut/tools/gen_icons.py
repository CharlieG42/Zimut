#!/usr/bin/env python3
"""gen_icons.py — Génère les icônes de sorts (SVG 64x64) et data/spell_icons.txt.

Chaque icône = pastille arrondie dégradée (couleur de la famille du sort) + motif vectoriel
(épée, bouclier, flamme, feuille...) + 0 à 3 étoiles de rang (sorts « supérieur », « ultime »...).
Les sorts de même nom ou de même nature partagent la même icône d'une classe à l'autre.
Usage : python3 tools/gen_icons.py [--sheet apercu.png]
"""
import os, sys, re, csv, unicodedata

OL = "#1a1020"
HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.join(HERE, "..")
OUT = os.path.join(ROOT, "assets", "icons", "spells")

BG = {  # famille -> (haut, bas, liseré)
    "phys": ("#9a3a32", "#3a1216", "#ff9a7a"), "fire": ("#c85a22", "#4a1a0a", "#ffc070"),
    "ice": ("#3a8ac0", "#10304a", "#a8e6ff"), "bolt": ("#7a6ae0", "#262060", "#c8c0ff"),
    "poison": ("#5aa02a", "#1c3a0e", "#b8f070"), "shadow": ("#6a34a0", "#22103a", "#c8a0ff"),
    "heal": ("#38aa5e", "#103a20", "#a8ffc0"), "holy": ("#d0a834", "#4a3610", "#fff0a0"),
    "buff": ("#3a6ac8", "#10224a", "#a0c8ff"), "debuff": ("#b8962a", "#443008", "#ffe890"),
    "nature": ("#42983e", "#14381a", "#b0f080"), "earth": ("#9a7a42", "#3a2a12", "#e8c890"),
    "water": ("#2a8ab8", "#0e3050", "#a0e0ff"), "arcane": ("#8a54d0", "#2a1a4a", "#e0c8ff"),
    "summon": ("#6a4a9a", "#241848", "#d8c0ff"),
}

# ── primitives (repère centré 0,0, ~ ±24) ──────────────────────────────────
def P(d, fill, sw=2.4, stroke=OL, extra=""):
    return f'<path d="{d}" fill="{fill}" stroke="{stroke}" stroke-width="{sw}" stroke-linejoin="round" stroke-linecap="round" {extra}/>'
def C(cx, cy, r, fill, sw=2.2, stroke=OL):
    return f'<circle cx="{cx}" cy="{cy}" r="{r}" fill="{fill}" stroke="{stroke}" stroke-width="{sw}"/>' if sw else f'<circle cx="{cx}" cy="{cy}" r="{r}" fill="{fill}"/>'
def E(cx, cy, rx, ry, fill, sw=2.2, rot=0, stroke=OL):
    s = f' stroke="{stroke}" stroke-width="{sw}"' if sw else ""
    return f'<ellipse cx="{cx}" cy="{cy}" rx="{rx}" ry="{ry}" fill="{fill}"{s} transform="rotate({rot} {cx} {cy})"/>'
def L(x1, y1, x2, y2, col, w=3, outline=True):
    o = f'<line x1="{x1}" y1="{y1}" x2="{x2}" y2="{y2}" stroke="{OL}" stroke-width="{w + 2.4}" stroke-linecap="round"/>' if outline else ""
    return o + f'<line x1="{x1}" y1="{y1}" x2="{x2}" y2="{y2}" stroke="{col}" stroke-width="{w}" stroke-linecap="round"/>'
def PL(pts, col, w=3, outline=True, fill="none"):
    d = "M" + " L".join(f"{x},{y}" for x, y in pts)
    o = f'<path d="{d}" fill="none" stroke="{OL}" stroke-width="{w + 2.4}" stroke-linecap="round" stroke-linejoin="round"/>' if outline else ""
    return o + f'<path d="{d}" fill="{fill}" stroke="{col}" stroke-width="{w}" stroke-linecap="round" stroke-linejoin="round"/>'
def G(inner, tx=0, ty=0, rot=0, s=1.0):
    return f'<g transform="translate({tx},{ty}) rotate({rot}) scale({s})">{inner}</g>'

STEEL = "#e4eaf4"; STEEL2 = "#9aa6bc"; GOLD = "#ffd24a"; RED = "#e0463a"; WOOD = "#9a6a3a"; WHITE = "#ffffff"
GREEN = "#7adc4a"; PINK = "#ff7aa8"; BLUE = "#6ab4ff"; PURPLE = "#b07aff"; ORANGE = "#ff9a2a"

def sword(col=STEEL):
    return (P("M0,-24 L4.5,-8 L4.5,10 L-4.5,10 L-4.5,-8 Z", col) + L(0, -20, 0, 7, WHITE, 1.4, False)
            + P("M-10,10 L10,10 L10,14 L-10,14 Z", GOLD) + P("M-3,14 L3,14 L3,22 L-3,22 Z", WOOD))
def dagger(col=STEEL):
    return P("M0,-20 L4,-6 L4,6 L-4,6 L-4,-6 Z", col) + P("M-8,6 L8,6 L8,9 L-8,9 Z", GOLD) + P("M-2.5,9 L2.5,9 L2.5,17 L-2.5,17 Z", WOOD)
def shield(col="#5a8ae0", rim=GOLD):
    return (P("M-16,-16 L16,-16 L16,2 Q16,18 0,24 Q-16,18 -16,2 Z", rim) + P("M-12,-12 L12,-12 L12,2 Q12,14 0,19 Q-12,14 -12,2 Z", col)
            + P("M-12,-12 L0,-12 L0,19 Q-12,14 -12,2 Z", "#ffffff", 0, extra='opacity="0.18"'))
def heart(col=RED, s=1.0):
    return G(P("M0,16 C-26,-2 -12,-18 0,-6 C12,-18 26,-2 0,16 Z", col) + P("M-9,-8 C-14,-6 -14,0 -10,3", WHITE, 2, "none", 'opacity="0.55"'), s=s)
def cross(col="#f4fff0", w=8):
    return P(f"M{-w/2},-18 L{w/2},-18 L{w/2},{-w/2} L18,{-w/2} L18,{w/2} L{w/2},{w/2} L{w/2},18 L{-w/2},18 L{-w/2},{w/2} L-18,{w/2} L-18,{-w/2} L{-w/2},{-w/2} Z", col)
def drop(col=BLUE, s=1.0):
    return G(P("M0,-20 C12,-4 16,4 0,18 C-16,4 -12,-4 0,-20 Z", col) + C(-4, 4, 3, WHITE, 0), s=s)
def leaf(col=GREEN, s=1.0, rot=0):
    return G(P("M-14,14 C-18,-6 0,-20 16,-16 C16,2 4,16 -14,14 Z", col) + L(-12, 12, 8, -10, "#2a6a22", 2, False), rot=rot, s=s)
def flame(col=ORANGE, s=1.0):
    return G(P("M0,-24 C6,-12 16,-6 13,7 C10,20 -10,20 -13,7 C-15,-4 -4,-8 0,-24 Z", col) + P("M0,-4 C6,2 7,10 0,15 C-7,10 -6,2 0,-4 Z", "#fff0a0", 1.6), s=s)
def bolt(col="#ffe85a", s=1.0):
    return G(P("M7,-24 L-11,3 L-1,3 L-7,24 L13,-6 L3,-6 Z", col), s=s)
def star4(col=GOLD, s=1.0):
    return G(P("M0,-20 L4.5,-5 L20,0 L4.5,5 L0,20 L-4.5,5 L-20,0 L-4.5,-5 Z", col), s=s)
def crystal(col="#bfeaff", s=1.0):
    return G(P("M0,-24 L9,-8 L7,14 L0,22 L-7,14 L-9,-8 Z", col) + P("M0,-24 L9,-8 L0,0 L-9,-8 Z", WHITE, 1.4) + L(0, 0, 0, 20, "#7ac0e8", 1.6, False), s=s)
def skull(col="#f4f0e0", s=1.0):
    return G(P("M-14,2 C-18,-20 18,-20 14,2 C14,8 8,10 8,14 L-8,14 C-8,10 -14,8 -14,2 Z", col) + C(-6, -3, 4, OL, 0) + C(6, -3, 4, OL, 0)
             + P("M0,2 L-2,7 L2,7 Z", OL, 1) + L(-4, 14, -4, 19, col, 2.4) + L(0, 14, 0, 20, col, 2.4) + L(4, 14, 4, 19, col, 2.4), s=s)
def eye(col="#f4f0ff", iris=PURPLE, s=1.0):
    return G(P("M-22,0 Q0,-20 22,0 Q0,20 -22,0 Z", col) + C(0, 0, 8, iris) + C(0, 0, 3.4, OL, 0) + C(-2.4, -2.4, 1.6, WHITE, 0), s=s)
def wing(col=WHITE, s=1.0, flip=1):
    return G(P("M0,16 C-8,-4 -20,-14 -26,-20 C-12,-20 -6,-12 -2,-6 C-12,-10 -22,-6 -28,-2 C-14,0 -6,6 0,16 Z", col), s=s, rot=0) if flip == 1 else G(wing(col), s=s)
def arrow_v(col=STEEL):
    return (L(-16, 14, 12, -14, WOOD, 3) + P("M16,-18 L6,-14 L12,-8 Z", col) + P("M-16,14 L-22,12 L-14,8 Z", RED, 1.6) + P("M-16,14 L-12,20 L-10,12 Z", RED, 1.6))
def bow():
    return P("M-6,-22 C16,-14 16,14 -6,22", "none", 3.4, WOOD) + L(-6, -22, -6, 22, "#f4e8c8", 1.4, False)
def fang(col="#f4f0e0"):
    return P("M-14,-10 L-6,-10 L-10,14 Z", col) + P("M14,-10 L6,-10 L10,14 Z", col) + P("M-4,-6 L4,-6 L0,8 Z", col, 1.8)
def claw(col=RED):
    return PL([(-14, -18), (-8, 0), (-14, 18)], col, 4) + PL([(0, -20), (6, 0), (0, 20)], col, 4) + PL([(14, -18), (20, 0), (14, 18)], col, 4)
def swirl(col=PURPLE, w=4):
    pts = []
    import math
    for i in range(0, 30):
        a = i * 0.45
        r = 3 + i * 0.7
        pts.append((round(math.cos(a) * r, 1), round(math.sin(a) * r, 1)))
    return PL(pts, col, w)
def sun(col=GOLD, s=1.0):
    import math
    rays = "".join(L(round(math.cos(i * math.pi / 4) * 13, 1), round(math.sin(i * math.pi / 4) * 13, 1), round(math.cos(i * math.pi / 4) * 21, 1), round(math.sin(i * math.pi / 4) * 21, 1), col, 3.2) for i in range(8))
    return G(rays + C(0, 0, 10, col) + C(-3, -3, 3, WHITE, 0), s=s)
def moon(col="#e8d8ff", s=1.0):
    return G(P("M6,-22 C-14,-18 -20,6 -6,18 C2,24 14,22 18,16 C0,14 -4,-8 6,-22 Z", col), s=s)
def cloud(col="#dcdce8", s=1.0):
    return G(C(-10, 4, 9, col) + C(2, -4, 11, col) + C(12, 6, 8, col) + P("M-18,12 L18,12 L18,14 L-18,14 Z", col, 1.6), s=s)
def rock(col="#a8a6a0", s=1.0):
    return G(P("M-18,14 L-14,-6 L-4,-18 L10,-14 L18,2 L16,14 Z", col) + P("M-14,-6 L-4,-18 L0,0 L-6,14 L-18,14 Z", "#d0cec8", 1.6), s=s)
def roots(col="#8a5a2a"):
    return PL([(0, -20), (0, 0), (-10, 12), (-16, 22)], col, 4) + PL([(0, 0), (10, 12), (16, 22)], col, 4) + PL([(0, 4), (0, 22)], col, 3.4) + PL([(-4, -8), (-14, -14)], col, 3)
def hammer():
    return L(0, -2, 0, 22, WOOD, 5) + P("M-16,-16 L16,-16 L16,-2 L-16,-2 Z", STEEL2) + P("M-16,-16 L16,-16 L16,-12 L-16,-12 Z", WHITE, 0, extra='opacity="0.4"')
def fist(col="#f0c8a0"):
    return P("M-12,-4 L-12,-14 C-12,-18 -6,-18 -6,-14 C-6,-20 2,-20 2,-14 C2,-19 9,-19 9,-13 C9,-17 15,-16 15,-10 L15,6 C15,16 8,20 -2,20 C-10,20 -14,14 -14,6 Z", col)
def crown():
    return P("M-18,12 L-20,-10 L-9,0 L0,-16 L9,0 L20,-10 L18,12 Z", GOLD) + C(0, -16, 2.6, RED, 1.4) + C(-20, -10, 2.4, BLUE, 1.2) + C(20, -10, 2.4, BLUE, 1.2)
def boot():
    return P("M-10,-18 L4,-18 L4,2 L16,8 C20,10 20,18 14,18 L-12,18 Z", "#c88a4a") + P("M-10,12 L14,12", "none", 2, "#6a4220")
def chain_link(col="#aab4c8"):
    return E(-8, 0, 10, 6, "none", 3.6, -30, col) + E(8, 0, 10, 6, "none", 3.6, 30, col)
def trap_jaw(col="#9aa6bc"):
    return (P("M-22,4 L-14,-16 L-6,2 L2,-16 L10,2 L18,-16 L22,4 Z", col) + P("M-22,4 L-14,18 L-6,4 L2,18 L10,4 L18,18 L22,4 Z", STEEL2) + L(-22, 4, 22, 4, OL, 2.4, False))
def target():
    return C(0, 0, 18, "none", 3.4, RED) + C(0, 0, 10, "none", 3.2, RED) + C(0, 0, 3.6, RED, 0) + L(-24, 0, -14, 0, RED, 3) + L(14, 0, 24, 0, RED, 3) + L(0, -24, 0, -14, RED, 3) + L(0, 14, 0, 24, RED, 3)
def note(col="#ffe8a0"):
    return P("M-6,16 C-14,16 -14,6 -6,6 C-2,6 0,8 0,12 L0,-16 L14,-12 L14,-6 L6,-8 L6,16 Z", col)
def banner_pole():
    return L(-10, 22, -10, -22, WOOD, 4) + P("M-8,-20 L18,-14 L-8,-4 Z", ORANGE) + C(-10, -22, 3, GOLD, 1.4)
def up_arrow(col=GREEN):
    return P("M0,-22 L16,-2 L6,-2 L6,20 L-6,20 L-6,-2 L-16,-2 Z", col)
def down_arrow(col=RED):
    return P("M0,22 L16,2 L6,2 L6,-20 L-6,-20 L-6,2 L-16,2 Z", col)
def bubble(col="#a8d8ff"):
    return C(0, 0, 20, col, 2.6) + P("M-12,-8 C-10,-14 -4,-16 0,-16", "none", 2.6, WHITE, 'opacity="0.8"') + C(-7, -9, 2.4, WHITE, 0)
def portal():
    return E(0, 0, 14, 22, "#2a1a5a", 2.6) + E(0, 0, 9, 16, "#7a5ae0", 0) + E(0, 0, 4, 9, "#e0d0ff", 0)
def meteor_g():
    return rock("#b87a4a", 0.7) .replace('<g transform="translate(0,0)', '<g transform="translate(6,6)') + PL([(-24, -24), (-10, -10)], ORANGE, 5) + PL([(-24, -12), (-14, -4)], "#ffd070", 3) + PL([(-12, -24), (-4, -16)], "#ffd070", 3)
def burst(col=ORANGE):
    import math
    pts = []
    for i in range(16):
        r = 22 if i % 2 == 0 else 11
        a = i * math.pi / 8
        pts.append((round(math.cos(a) * r, 1), round(math.sin(a) * r, 1)))
    d = "M" + " L".join(f"{x},{y}" for x, y in pts) + " Z"
    return P(d, col) + C(0, 0, 7, "#fff0a0", 0)
def web_lines():
    return L(-18, -18, 18, 18, "#d8c8f0", 2.4, False) + L(18, -18, -18, 18, "#d8c8f0", 2.4, False)
def feather(col=WHITE):
    return P("M-14,18 C-16,-4 -4,-18 16,-20 C14,0 6,14 -14,18 Z", col) + L(-14, 18, 8, -12, "#c8d0e0", 1.6, False)
def petals(col="#ffb0d0"):
    import math
    return "".join(G(P("M0,0 C-8,-8 -4,-20 0,-22 C4,-20 8,-8 0,0 Z", col, 2), rot=i * 72) for i in range(5)) + C(0, 0, 4, GOLD, 1.6)
def thorn(col=GREEN):
    return PL([(-22, 14), (-8, 6), (4, 10), (18, -2)], col, 4) + P("M-8,6 L-10,-6 L-3,2 Z", "#e8f0c0", 1.4) + P("M4,10 L4,-2 L10,6 Z", "#e8f0c0", 1.4) + P("M12,2 L14,-10 L19,-2 Z", "#e8f0c0", 1.4)
def seed(col="#c89a52"):
    return E(0, 0, 8, 13, col, 2.4, 25) + L(-2, -8, 3, 8, "#7a5a2a", 1.6, False)
def mushroom():
    return P("M-6,0 L6,0 L5,16 L-5,16 Z", "#f4ecd8") + P("M-20,2 C-20,-18 20,-18 20,2 Z", RED) + C(-7, -7, 3, WHITE, 0) + C(6, -9, 2.6, WHITE, 0) + C(1, -3, 2, WHITE, 0)
def stump():
    return P("M-14,-4 L-14,18 L14,18 L14,-4 Z", "#9a6a3a") + E(0, -4, 14, 6, "#d8b078", 2.4) + E(0, -4, 7, 3, "none", 1.4, 0, "#9a6a3a")
def whip(col=GREEN):
    return PL([(-22, 18), (-10, 4), (0, 10), (10, -6), (20, -16)], col, 4) + C(20, -16, 3.4, PINK, 1.6)

# ── Icônes : id -> (famille, svg, [overlay]) ───────────────────────────────
ICONS = {}
def icon(i, fam, glyph): ICONS[i] = (fam, glyph)

icon("slash", "phys", G(sword(), rot=45) + L(-20, 14, -6, 4, WHITE, 2, False))
icon("shield_bash", "phys", shield("#c85a4a") + star4("#fff0a0", 0.55) .replace("<g ", '<g ') + L(14, -14, 22, -22, "#ffd070", 3) + L(16, -4, 24, -6, "#ffd070", 3))
icon("power_strike", "phys", G(sword(), rot=-30) + burst(ORANGE).replace("<path", "<path opacity='0.0'") + G(burst("#ffb040"), 8, 10, 0, 0.6))
icon("crushing", "phys", hammer() + G(burst("#ffb040"), 0, 14, 0, 0.55))
icon("final_blow", "phys", G(sword(), 0, 0, 180, 1.0) + L(-18, 20, 18, 20, "#ffd070", 3))
icon("hammer", "earth", hammer() + L(-22, 20, 22, 20, "#e8c890", 3))
icon("shield", "buff", shield())
icon("shield_holy", "buff", shield("#e8f0ff") + cross("#ffd24a", 5).replace("<path", "<path transform='scale(0.7) translate(0,-2)'"))
icon("shield_group", "buff", G(shield("#5a8ae0"), -10, 2, 0, 0.7) + G(shield("#5a8ae0"), 10, 2, 0, 0.7) + G(shield("#8ab4ff"), 0, -2, 0, 0.8))
icon("wall", "earth", P("M-22,-14 L22,-14 L22,18 L-22,18 Z", "#c8a070") + L(-22, -2, 22, -2, "#6a4a2a", 2, False) + L(-22, 8, 22, 8, "#6a4a2a", 2, False) + L(-6, -14, -6, -2, "#6a4a2a", 2, False) + L(8, -2, 8, 8, "#6a4a2a", 2, False) + L(-10, 8, -10, 18, "#6a4a2a", 2, False))
icon("roar", "debuff", P("M-20,-10 L20,-18 L20,18 L-20,10 Z", "#f0c850") + P("M-14,-4 L12,-8 L12,8 L-14,4 Z", "#7a1a1a", 1.6) + fang("#fff8e8").replace("<path", "<path transform='scale(0.5) translate(0,0)'") + L(-24, -4, -24, 4, ORANGE, 3))
icon("taunt", "debuff", target() + P("M-2,-8 L2,-8 L1,2 L-1,2 Z", WHITE, 1) + C(0, 6, 1.6, WHITE, 0))
icon("earthquake", "earth", P("M-24,2 L-8,-4 L0,4 L10,-6 L24,2", "none", 4, "#e8c890") + L(-4, 4, 6, 22, "#3a2a12", 3) + rock("#b0a090", 0.55).replace('<g transform="translate(0,0)', '<g transform="translate(-14,-14)') + rock("#b0a090", 0.45).replace('<g transform="translate(0,0)', '<g transform="translate(16,-14)'))
icon("regen", "heal", heart(GREEN, 0.9) + swirl("#e8ffe8", 2).replace("<path", "<path opacity='0.0'") + PL([(-20, -6), (-16, -16), (-6, -20)], "#e8ffe8", 3) + PL([(20, 6), (16, 16), (6, 20)], "#e8ffe8", 3))
icon("heal_heart", "heal", heart(RED) )
icon("heal_cross", "heal", cross())
icon("heal_hand", "heal", heart("#ff8a9a", 0.8) + star4(WHITE, 0.45).replace('<g transform="translate(0,0)', '<g transform="translate(14,-14)'))
icon("heal_group", "heal", G(heart(RED), -11, 4, 0, 0.62) + G(heart(RED), 11, 4, 0, 0.62) + G(heart("#ff8a9a"), 0, -8, 0, 0.78))
icon("heal_leaf", "heal", heart(GREEN, 1.0) + leaf("#e8ffc0", 0.55, 20).replace('<g transform="translate(0,0)', '<g transform="translate(0,-2)'))
icon("heal_shadow", "shadow", heart("#c890ff", 1.0) + moon("#fff", 0.5).replace('<g transform="translate(0,0)', '<g transform="translate(12,-14)'))
icon("heal_poison", "poison", heart(GREEN) + drop("#c890ff", 0.5).replace('<g transform="translate(0,0)', '<g transform="translate(13,-13)'))
icon("heal_deadly", "shadow", heart("#c890ff") + skull("#f4f0e0", 0.5).replace('<g transform="translate(0,0)', '<g transform="translate(12,-13)'))
icon("divine", "holy", sun() + cross("#fffbe0", 6).replace("<path", "<path transform='scale(0.5)'"))
icon("rebirth", "holy", feather("#fff0c0") + heart(RED, 0.5).replace('<g transform="translate(0,0)', '<g transform="translate(0,6)') + wing("#fff0c0", 0.7).replace('<g transform="translate(0,0)', '<g transform="translate(-6,-4)'))
icon("resurrection", "holy", wing(WHITE, 0.9) + G(wing(WHITE, 0.9), 0, 0, 0, 1).replace("scale(1.0)", "scale(-1,1)") + heart(RED, 0.55))
icon("armor", "buff", P("M-14,-18 L-6,-22 L6,-22 L14,-18 L20,-8 L12,-2 L12,20 L-12,20 L-12,-2 L-20,-8 Z", "#b8c4d8") + L(0, -18, 0, 18, STEEL2, 2, False) + P("M-6,-22 L0,-14 L6,-22", "none", 2.4))
icon("fury", "phys", fist("#ff9a6a") + flame(ORANGE, 0.5).replace('<g transform="translate(0,0)', '<g transform="translate(0,-20)'))
icon("tank_heal", "heal", shield("#4aaa6a") + cross("#ffffff", 5).replace("<path", "<path transform='scale(0.6) translate(0,0)'"))
# assassin
icon("dagger_fatal", "shadow", G(dagger(), rot=30) + skull("#f4f0e0", 0.45).replace('<g transform="translate(0,0)', '<g transform="translate(-12,12)'))
icon("poison_drop", "poison", drop("#8ae04a") + skull("#e8ffd0", 0.4).replace('<g transform="translate(0,0)', '<g transform="translate(0,4)'))
icon("shadow_step", "shadow", moon() + L(-18, 20, -6, 20, "#e8d8ff", 3) + L(2, 14, 14, 14, "#e8d8ff", 3))
icon("low_blow", "phys", G(dagger(), rot=-60) + burst("#ffb040").replace("<path", "<path opacity='0.0'") + G(burst("#ffb040"), 10, 12, 0, 0.5))
icon("blink", "arcane", portal() + L(-22, -2, -14, -2, "#e0d0ff", 3) + L(14, 2, 22, 2, "#e0d0ff", 3))
icon("death_mark", "shadow", target() + skull("#f4f0e0", 0.45))
icon("trap_poison", "poison", trap_jaw() + drop("#8ae04a", 0.5).replace('<g transform="translate(0,0)', '<g transform="translate(0,-16)'))
icon("assassinate", "shadow", G(dagger(), rot=0, s=1.1) + moon("#c890ff", 0.55).replace('<g transform="translate(0,0)', '<g transform="translate(-14,-14)') + L(-18, 20, 18, 20, RED, 3))
icon("invisible", "shadow", eye("#e8e0ff", PURPLE, 0.9) + L(-22, 16, 22, -16, RED, 4))
icon("eviscerate", "phys", claw(RED) + drop(RED, 0.5).replace('<g transform="translate(0,0)', '<g transform="translate(0,22)'))
icon("curse", "shadow", eye("#d8b8ff", "#6a1a8a", 0.9) + P("M-22,-14 L-14,-22", "none", 3, "#c890ff"))
icon("poison_mass", "poison", cloud("#9ae05a", 1.1) + skull("#e8ffd0", 0.45).replace('<g transform="translate(0,0)', '<g transform="translate(0,4)'))
icon("blade_shadow", "shadow", G(sword("#c8a8ff"), rot=45) + moon("#e8d8ff", 0.5).replace('<g transform="translate(0,0)', '<g transform="translate(-14,-14)'))
icon("invis_total", "shadow", eye("#e8e0ff", PURPLE, 0.8) + L(-22, 16, 22, -16, RED, 4) + shield("#8a5ac8").replace("<g", "<g opacity='0.0'<g") if False else eye("#e8e0ff", PURPLE, 0.8) + L(-22, 16, 22, -16, RED, 4) + G(shield("#8a5ac8"), 12, 12, 0, 0.45))
# chasseur
icon("arrow", "phys", arrow_v())
icon("arrow_fire", "fire", arrow_v() + flame(ORANGE, 0.5).replace('<g transform="translate(0,0)', '<g transform="translate(-14,10)'))
icon("arrow_pierce", "phys", arrow_v() + shield("#5a8ae0").replace("<g", "<g") if False else G(arrow_v(), 0, 0, 0, 1) + C(2, -2, 5, "none", 2.4, "#ffd24a"))
icon("arrow_explosive", "fire", arrow_v() + burst(ORANGE).replace("<path", "<path opacity='0.0'") + G(burst(ORANGE), -12, 12, 0, 0.5))
icon("camouflage", "nature", leaf(GREEN, 1.0, 10) + eye("#e8ffd0", "#3a8a2a", 0.55).replace('<g transform="translate(0,0)', '<g transform="translate(0,0)'))
icon("arrow_poison", "poison", arrow_v() + drop("#8ae04a", 0.5).replace('<g transform="translate(0,0)', '<g transform="translate(-14,10)'))
icon("arrow_ice", "ice", arrow_v() + crystal("#bfeaff", 0.5).replace('<g transform="translate(0,0)', '<g transform="translate(-14,10)'))
icon("arrow_holy", "holy", arrow_v() + sun(GOLD, 0.5).replace('<g transform="translate(0,0)', '<g transform="translate(-14,10)'))
icon("trap", "debuff", trap_jaw())
icon("trap_para", "debuff", trap_jaw() + bolt("#ffe85a", 0.55).replace('<g transform="translate(0,0)', '<g transform="translate(0,-16)'))
icon("trap_thorn", "nature", trap_jaw("#6aaa4a") + thorn(GREEN))
icon("wolf_call", "summon", fang() + P("M-16,-14 L-10,-24 L-4,-14 Z", "#aab0bc") + P("M16,-14 L10,-24 L4,-14 Z", "#aab0bc"))
icon("recoil", "phys", arrow_v() + P("M16,8 L22,14 L16,20", "none", 3.4, "#ffd070") + L(4, 14, 22, 14, "#ffd070", 3))
icon("beacon", "debuff", banner_pole())
icon("heal_nature", "nature", heart(GREEN) + leaf("#e8ffc0", 0.5, 20).replace('<g transform="translate(0,0)', '<g transform="translate(0,-2)'))
# mage
icon("fireball", "fire", flame(ORANGE, 1.1))
icon("lightning", "bolt", bolt(), )
icon("lightning2", "bolt", G(bolt(), -8, 0, 0, 0.8) + G(bolt("#c0b8ff"), 10, 2, 0, 0.8))
icon("arcane_shield", "arcane", bubble("#c8b0ff") + star4(WHITE, 0.35))
icon("explosion", "fire", burst(ORANGE))
icon("teleport", "arcane", portal())
icon("teleport_group", "arcane", G(portal(), -9, 0, 0, 0.7) + G(portal(), 9, 0, 0, 0.7))
icon("meteor", "fire", meteor_g())
icon("freeze", "ice", crystal())
icon("invis_magic", "arcane", eye("#e8e0ff", "#8a5ac8", 0.9) + L(-22, 16, 22, -16, "#c8b0ff", 4))
icon("chain_lightning", "bolt", bolt("#ffe85a", 0.7) + L(-20, 18, -2, 10, "#c0b8ff", 3) + C(-20, 18, 3, "#ffe85a", 1.4) + C(20, -6, 3, "#ffe85a", 1.4))
icon("barrier_magic", "arcane", P("M-20,-16 L20,-16 L20,16 L-20,16 Z", "none", 3.4, "#c8b0ff") + star4("#e0d0ff", 0.6))
icon("disintegrate", "arcane", L(-22, 18, 14, -14, "#e0d0ff", 6) + L(-22, 18, 14, -14, WHITE, 2.4, False) + burst("#c8a0ff").replace("<path", "<path opacity='0.0'") + G(burst("#c8a0ff"), 14, -14, 0, 0.5))
icon("meteor_rain", "fire", G(meteor_g(), -8, -4, 0, 0.7) + G(meteor_g(), 12, 8, 0, 0.6))
icon("apocalypse", "fire", skull("#f4f0e0", 0.8) + flame(ORANGE, 0.7).replace('<g transform="translate(0,0)', '<g transform="translate(0,-14)'))
# druide / heal
icon("bless", "holy", star4(GOLD, 0.9) + cross("#ffffff", 4).replace("<path", "<path transform='scale(0.4)'"))
icon("inspire", "buff", star4(GOLD, 1.0) + up_arrow(GREEN).replace("<path", "<path transform='scale(0.4) translate(0,26)'"))
icon("purify", "holy", drop("#d8f4ff", 1.0) + star4(GOLD, 0.5).replace('<g transform="translate(0,0)', '<g transform="translate(10,-12)'))
icon("haste", "buff", boot() + wing(WHITE, 0.55).replace('<g transform="translate(0,0)', '<g transform="translate(-6,-2)'))
icon("holy_attack", "holy", sun(GOLD, 0.9))
icon("holy_attack2", "holy", sun(GOLD, 0.8) + star4(WHITE, 0.35))
icon("supreme_bless", "holy", crown() + star4(WHITE, 0.4).replace('<g transform="translate(0,0)', '<g transform="translate(0,-20)'))
icon("judgment", "holy", bolt("#fff0a0", 1.1) + cloud("#e8e8f4", 0.8).replace('<g transform="translate(0,0)', '<g transform="translate(0,-16)'))
icon("light_burst", "holy", burst("#ffe070") + heart(WHITE, 0.4))
icon("barrier_life", "heal", shield("#4aaa6a") + heart(RED, 0.5).replace('<g transform="translate(0,0)', '<g transform="translate(0,2)'))
icon("protect_vital", "buff", shield("#5ab0a0") + leaf("#e8ffd0", 0.5).replace('<g transform="translate(0,0)', '<g transform="translate(0,2)'))
icon("heal_touch", "heal", heart("#ff8a9a", 0.9) + star4(WHITE, 0.4).replace('<g transform="translate(0,0)', '<g transform="translate(12,-12)'))
icon("light_shield", "buff", shield("#fff0b0", GOLD) + sun(GOLD, 0.45))
icon("word_restore", "heal", note("#ffe8a0") + heart(RED, 0.4).replace('<g transform="translate(0,0)', '<g transform="translate(10,-12)'))
# invocateur
icon("summon_atk", "summon", claw("#ffd0a0") + star4("#d8c0ff", 0.4).replace('<g transform="translate(0,0)', '<g transform="translate(14,-14)'))
icon("summon_atk2", "summon", claw("#ffb070") + burst("#d8c0ff").replace("<path", "<path opacity='0.0'") + G(burst("#d8c0ff"), 14, -14, 0, 0.4))
icon("summon_buff", "buff", up_arrow(GREEN) + chain_link().replace("<ellipse", "<ellipse opacity='0.0'") if False else up_arrow(GREEN))
icon("summon_debuff", "debuff", down_arrow(RED))
icon("summon_heal", "heal", heart(RED, 0.9) + chain_link("#d8c0ff").replace('<g', '<g') if False else heart(RED, 0.9) + star4("#d8c0ff", 0.4).replace('<g transform="translate(0,0)', '<g transform="translate(14,-14)'))
icon("summon_speed", "buff", boot())
icon("summon_aoe", "summon", claw("#ffd0a0") + C(0, 0, 22, "none", 2.4, "#d8c0ff"))
icon("summon_precision", "debuff", target())
icon("spectral", "arcane", star4("#c8b0ff", 0.9) + bolt("#e8e0ff", 0.4))
icon("symbiosis", "heal", heart(GREEN, 0.8) + chain_link("#e8ffd0"))
# sylvain
icon("thorn", "nature", thorn())
icon("sap", "nature", drop(GREEN, 1.0) + leaf("#e8ffc0", 0.5, 20).replace('<g transform="translate(0,0)', '<g transform="translate(0,2)'))
icon("root", "nature", roots())
icon("ivy", "nature", shield("#4aaa4a") + leaf("#e8ffc0", 0.6, 20).replace('<g transform="translate(0,0)', '<g transform="translate(0,2)'))
icon("thorn_multi", "nature", thorn() + G(thorn(), 0, 12, 0, 0.8))
icon("thorn_trap", "nature", trap_jaw("#6aaa4a") + thorn(GREEN))
icon("leaf_wind", "nature", swirl("#c8f090", 3.4) + leaf(GREEN, 0.6, 30).replace('<g transform="translate(0,0)', '<g transform="translate(8,-8)'))
icon("forest_roar", "nature", P("M-20,-10 L20,-18 L20,18 L-20,10 Z", "#7acc5a") + leaf("#e8ffc0", 0.6).replace('<g transform="translate(0,0)', '<g transform="translate(0,0)'))
icon("seed_rain", "nature", G(seed(), -10, -8, 0, 0.9) + G(seed(), 10, -2, 0, 0.9) + G(seed(), -2, 14, 0, 0.9))
icon("nature_wrath", "nature", leaf(GREEN, 1.0) + bolt("#ffe85a", 0.6).replace('<g transform="translate(0,0)', '<g transform="translate(0,-14)'))
icon("petal_storm", "nature", petals("#ffb0d0") + swirl("#ffd0e8", 2.4).replace("<path", "<path opacity='0.0'"))
icon("roots_block", "earth", roots("#8a5a2a") + L(-22, 0, 22, 0, "#6a4220", 3))
icon("regression", "heal", heart(GREEN, 1.0) + sun(GOLD, 0.5).replace('<g transform="translate(0,0)', '<g transform="translate(0,-18)'))
icon("heal_leaf2", "heal", leaf(GREEN, 1.2, 10) + heart(RED, 0.4).replace('<g transform="translate(0,0)', '<g transform="translate(0,4)'))
icon("shield_roots", "buff", shield("#4a8a3a") + roots("#c89a52").replace("<path", "<path transform='scale(0.5) translate(0,0)'"))
icon("summon_arbre", "nature", cloud("#5ab04a", 1.0) + L(0, 2, 0, 22, WOOD, 6))
# ennemis / invocations (sorts de monstres)
icon("bite", "phys", fang())
icon("club", "phys", G(hammer(), rot=0) + L(-4, 6, 4, 6, WOOD, 3))
icon("howl", "debuff", moon("#e8e8f4", 0.9) + P("M-22,10 L-14,4 L-8,12", "none", 3, "#e8e8f4"))
icon("dagger_throw", "phys", G(dagger(), rot=45))
icon("dagger_rain", "phys", G(dagger(), -10, -6, 20, 0.7) + G(dagger(), 10, -2, 20, 0.7) + G(dagger(), 0, 10, 20, 0.7))
icon("stone_fist", "earth", fist("#c8c0b0") + rock("#b0a090", 0.4).replace('<g transform="translate(0,0)', '<g transform="translate(14,-14)'))
icon("fire_breath", "fire", flame(ORANGE, 1.0) + L(-22, 10, -8, 4, "#ffd070", 3))
icon("bone", "phys", L(-14, 14, 14, -14, "#f4f0e0", 7) + C(-16, 16, 5, "#f4f0e0", 2) + C(-10, 18, 5, "#f4f0e0", 2) + C(16, -16, 5, "#f4f0e0", 2) + C(10, -18, 5, "#f4f0e0", 2))
icon("bone_arrow", "phys", arrow_v("#f4f0e0"))
icon("spectral_bolt", "arcane", bolt("#a0f0ff", 1.0))
icon("claw", "phys", claw(RED))
icon("wood_arm", "nature", PL([(-20, 18), (-4, 4), (6, -4), (18, -18)], WOOD, 6) + leaf(GREEN, 0.5).replace('<g transform="translate(0,0)', '<g transform="translate(14,-14)'))
icon("shell", "earth", E(0, 2, 20, 14, "#7ab05a", 2.6) + L(-12, -4, 12, -4, "#3a6a2a", 2, False) + L(0, -10, 0, 14, "#3a6a2a", 2, False) + L(-14, 6, 14, 6, "#3a6a2a", 2, False))
icon("sirene_song", "water", note("#a0e0ff") + P("M-22,16 Q-14,10 -6,16 T10,16", "none", 3, "#a0e0ff"))
icon("light", "holy", sun(GOLD, 0.8))
icon("dive", "phys", wing(WHITE, 0.8) + L(8, -20, 18, 8, STEEL, 4))
icon("spores", "poison", cloud("#9ae05a", 0.9) + C(-8, 16, 2.6, "#e8ffd0", 0) + C(4, 18, 2.2, "#e8ffd0", 0) + C(14, 14, 2.6, "#e8ffd0", 0) + mushroom().replace("<path", "<path opacity='0.0'"))
icon("whip", "nature", whip())
icon("summon", "summon", star4("#d8c0ff", 1.0))

# ── Mapping nom de sort -> icône (règles ordonnées) + rang d'étoiles ───────
def norm(s):
    s = unicodedata.normalize("NFD", s.lower())
    return "".join(c for c in s if unicodedata.category(c) != "Mn")

TIER_WORDS = {"superieur": 2, "supreme": 3, "ultime": 3, "legendaire": 3, "final": 2, "finale": 2, "divin": 2, "divine": 2,
              "total": 2, "totale": 2, "massif": 2, "critique": 2, "mortel": 2, "vital": 1, "vitale": 1, "puissant": 1, "puissante": 1}

RULES = [  # (mot-clé normalisé, icône)
    ("coup de bouclier", "shield_bash"), ("coup ecrasant", "crushing"), ("coup final", "final_blow"), ("coup bas", "low_blow"),
    ("frappe puissante", "power_strike"), ("rugissement de la foret", "forest_roar"), ("rugissement", "roar"), ("provocation", "taunt"),
    ("mur de pierre", "wall"), ("tremblement", "earthquake"), ("bouclier sacre", "shield_holy"), ("bouclier legendaire", "shield_holy"),
    ("bouclier groupe", "shield_group"), ("bouclier magique", "arcane_shield"), ("bouclier de lumiere", "light_shield"),
    ("regeneration", "regen"), ("armure renforcee", "armor"), ("colere de la nature", "nature_wrath"), ("colere", "fury"),
    ("intervention divine", "divine"), ("protection divine", "shield_holy"), ("protection vitale", "protect_vital"),
    ("protection ultime", "shield_holy"), ("protection", "shield_group"), ("barriere de vie", "barrier_life"),
    ("barriere magique", "barrier_magic"), ("barriere", "wall"), ("renaissance", "rebirth"), ("resurrection", "resurrection"),
    ("lame fatale", "dagger_fatal"), ("lame de l'ombre", "blade_shadow"), ("soin empoisonne", "heal_poison"), ("soin mortel", "heal_deadly"),
    ("soin de l'ombre", "heal_shadow"), ("soin rapide", "heal_hand"), ("soin critique", "heal_hand"), ("poison de ronce", "thorn"),
    ("empoisonnement massif", "poison_mass"), ("piege empoisonne", "trap_poison"), ("piege paralysant", "trap_para"),
    ("pose un piege de ronces", "thorn_trap"), ("piege", "trap"), ("poison", "poison_drop"), ("ombre", "shadow_step"),
    ("clignotement", "blink"), ("marque de la mort", "death_mark"), ("assassinat", "assassinate"), ("invisibilite totale", "invis_total"),
    ("invisibilite magique", "invis_magic"), ("invisibilite", "invisible"), ("eviscer", "eviscerate"), ("malediction", "curse"),
    ("soin ultime", "heal_hand"), ("tir de recul", "recoil"), ("balise", "beacon"), ("tir explosif", "arrow_explosive"),
    ("fleche enflammee", "arrow_fire"), ("fleche empoisonnee", "arrow_poison"), ("fleche sacree", "arrow_holy"), ("tir de glace", "arrow_ice"),
    ("tir transperçant", "arrow_pierce"), ("tir transpercant", "arrow_pierce"), ("tir perçant", "arrow_pierce"), ("tir percant", "arrow_pierce"),
    ("tir", "arrow"), ("camouflage", "camouflage"), ("appel de la meute", "wolf_call"), ("soin de la nature", "heal_nature"),
    ("soin de la foret", "heal_leaf"), ("soin de la vie", "heal_leaf2"), ("soin vital", "heal_heart"), ("soin de chasseur", "heal_nature"),
    ("boule de feu", "fireball"), ("eclair sacre", "holy_attack2"), ("chaine de foudre", "chain_lightning"), ("eclair", "lightning2"),
    ("pluie de meteores", "meteor_rain"), ("pluie de metores", "meteor_rain"), ("meteore", "meteor"), ("explosion", "explosion"),
    ("teleportation de groupe", "teleport_group"), ("teleportation", "teleport"), ("gel", "freeze"), ("desintegration", "disintegrate"),
    ("apocalypse", "apocalypse"), ("benediction de vie", "regen"), ("benediction supreme", "supreme_bless"), ("benediction", "bless"),
    ("inspiration", "inspire"), ("purification", "purify"), ("acceleration", "haste"), ("jugement", "judgment"), ("eclat de lumiere", "light_burst"),
    ("attaque sacree", "holy_attack"), ("attaque divine", "holy_attack"), ("attaque benie", "holy_attack"), ("attaque celeste", "holy_attack"),
    ("attaque finale", "holy_attack2"), ("toucher guerisseur", "heal_touch"), ("mot de restauration", "word_restore"),
    ("soin de groupe", "heal_group"), ("soin de zone", "heal_group"), ("soin de sev", "sap"), ("soin de combat", "tank_heal"), ("soin de guerre", "tank_heal"),
    ("soin de l'invocation", "summon_heal"), ("soin", "heal_cross"), ("symbiose", "symbiosis"),
    ("invoquer racines", "roots_block"), ("invoquer arbre", "summon_arbre"), ("invoquer", "SUMMON"),
    ("attaque de zone", "summon_aoe"), ("attaque puissante", "summon_atk2"), ("attaque ultime", "summon_atk2"), ("attaque de l'invocation", "summon_atk"),
    ("debuff de l'invocation", "summon_debuff"), ("debuff ultime", "summon_debuff"),
    ("buff de vitesse", "summon_speed"), ("buff de l'invocation", "summon_buff"), ("buff de defense", "shield"), ("buff ultime", "summon_buff"),
    ("debuff de precision", "summon_precision"), ("debuff de mouvement", "summon_debuff"), ("debuff", "summon_debuff"),
    ("frappe spectrale", "spectral"), ("ronce multiple", "thorn_multi"), ("ronce", "thorn"), ("seve vitale", "sap"), ("seve regeneratrice", "regen"),
    ("racines profondes", "shield_roots"), ("racine", "root"), ("lierre", "ivy"), ("vent de feuilles", "leaf_wind"), ("pluie de graines", "seed_rain"),
    ("tempete de petales", "petal_storm"), ("regression", "regression"), ("morsure", "bite"), ("coup de massue", "club"), ("hurlement", "howl"),
    ("jet de dague", "dagger_throw"), ("pluie de dagues", "dagger_rain"), ("poing de pierre", "stone_fist"), ("souffle de feu", "fire_breath"),
    ("tir d'os", "bone_arrow"), ("coup d'os", "bone"), ("trait spectral", "spectral_bolt"), ("bras de bois", "wood_arm"), ("carapace", "shell"),
    ("chant marin", "sirene_song"), ("fleche de centaure", "arrow"), ("fouet de ronce", "whip"), ("fouet de sarriette", "whip"),
    ("lumiere", "light"), ("pique", "dive"), ("spores", "spores"), ("seve fertilisante", "sap"), ("attaque", "claw"),
]

def tier_of(name):
    n = norm(name)
    t = 0
    for w, v in TIER_WORDS.items():
        if re.search(r"\b" + w + r"\b", n):
            t = max(t, v)
    return t

def icon_for(name):
    n = norm(name)
    for kw, ic in RULES:
        if norm(kw) in n:
            return ic
    return "slash"

def render(icon_id, tier=0, head_href=None):
    fam, glyph = ICONS[icon_id]
    top, bot, rim = BG[fam]
    stars = ""
    for i in range(tier):
        x = 32 + (i - (tier - 1) / 2) * 11
        stars += f'<path d="M{x},50 l1.8,3.8 4.2,.6 -3,3 .7,4.2 -3.7,-2 -3.7,2 .7,-4.2 -3,-3 4.2,-.6 Z" fill="{GOLD}" stroke="{OL}" stroke-width="1"/>'
    body = f'<g transform="translate(32,{29 if tier else 32}) scale({0.86 if tier else 1.0})">{glyph}</g>'
    return (f'<?xml version="1.0" encoding="UTF-8"?>\n<svg xmlns="http://www.w3.org/2000/svg" width="64" height="64" viewBox="0 0 64 64">'
            f'<defs><linearGradient id="bg" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="{top}"/><stop offset="1" stop-color="{bot}"/></linearGradient>'
            f'<radialGradient id="gl" cx="0.5" cy="0.3" r="0.7"><stop offset="0" stop-color="#ffffff" stop-opacity="0.35"/><stop offset="1" stop-color="#ffffff" stop-opacity="0"/></radialGradient></defs>'
            f'<rect x="2" y="2" width="60" height="60" rx="14" fill="{OL}"/><rect x="4" y="4" width="56" height="56" rx="12" fill="url(#bg)"/>'
            f'<rect x="4" y="4" width="56" height="56" rx="12" fill="url(#gl)"/>'
            f'<rect x="4.8" y="4.8" width="54.4" height="54.4" rx="11.4" fill="none" stroke="{rim}" stroke-width="1.6" opacity="0.8"/>'
            f'{body}{stars}</svg>\n')


def main():
    os.makedirs(OUT, exist_ok=True)
    names = []
    seen = set()
    for fn in ("data/sorts.txt",):
        with open(os.path.join(ROOT, fn), encoding="utf-8", newline="") as f:
            for r in csv.reader(f):
                if len(r) > 1 and r[0] != "Classe" and r[1] not in seen:
                    seen.add(r[1]); names.append(r[1])
    extra = ["Morsure", "Coup d'os", "Coup de massue", "Hurlement", "Jet de dague", "Pluie de dagues", "Poing de pierre", "Souffle de feu",
             "Tir d'os", "Trait spectral", "Attaque", "Bras de bois", "Carapace", "Chant marin", "Flèche de centaure", "Fouet de ronce",
             "Fouet de sarriette", "Lumière", "Piqué", "Spores toxiques", "Sève fertilisante"]
    for n in extra:
        if n not in seen:
            seen.add(n); names.append(n)
    lines = []
    used = {}
    summons = {}
    for n in names:
        ic = icon_for(n)
        if ic == "SUMMON":
            lines.append(f"{n},summon_{norm(n.replace('Invoquer ', '')).replace('-', '_').replace(' ', '_')}")
            summons[n] = lines[-1].split(",")[1]
            continue
        t = tier_of(n)
        key = f"{ic}_t{t}" if t else ic
        used[key] = (ic, t)
        lines.append(f"{n},{key}")
    for key, (ic, t) in used.items():
        with open(os.path.join(OUT, key + ".svg"), "w", encoding="utf-8") as f:
            f.write(render(ic, t))
    with open(os.path.join(ROOT, "data", "spell_icons.txt"), "w", encoding="utf-8", newline="") as f:
        f.write("Nom,Icone\n" + "\n".join(lines) + "\n")
    print(len(names), "sorts,", len(used), "icônes génériques,", len(summons), "icônes d'invocation (à générer par head_icons)")
    if "--sheet" in sys.argv:
        import cairosvg
        from PIL import Image
        files = sorted(os.listdir(OUT))
        cols = 14
        rows = (len(files) + cols - 1) // cols
        sheet = Image.new("RGBA", (cols * 76, rows * 76), (40, 44, 56, 255))
        for i, fn in enumerate(files):
            if not fn.endswith(".svg"):
                continue
            cairosvg.svg2png(url=os.path.join(OUT, fn), write_to="/tmp/_ic.png", output_width=64, output_height=64)
            im = Image.open("/tmp/_ic.png").convert("RGBA")
            sheet.paste(im, ((i % cols) * 76 + 6, (i // cols) * 76 + 6), im)
        sheet.save(sys.argv[sys.argv.index("--sheet") + 1])

if __name__ == "__main__":
    main()
