"""Garde des pics (Cimes) — golem de pierre articulé : face / dos × repos, marche, attaque, sort."""
import math
from types import SimpleNamespace as NS
from common import *
from rig import *

def mats(d):
    g = grad
    return NS(st=g(d, "#b9c6da", "#5a6a82"), stD=g(d, "#8c9bb4", "#3c485e"), stL=g(d, "#d8e2f0", "#8a9ab6"), fur=g(d, "#fbfbfd", "#bcc3d4"),
              gem=g(d, "#dffaff", "#2a98d8", 0, 0, 1, 1, mid="#5cd0ff"), glow=rgrad(d, "#ffffff", "#2ab4ff", .5, .5, .65))

def _leg(a, m, x0):
    a(p(f"M{x0} 306 L{x0+36} 306 L{x0+38} 350 L{x0-2} 350 Z", m.stD, 3.2), p(f"M{x0-8} 344 Q{x0-12} 376 {x0+8} 377 L{x0+46} 377 Q{x0+58} 372 {x0+48} 348 Z", m.st, 3.4),
      fillhl(f"M{x0-2} 350 Q{x0} 364 {x0+14} 368", "#fff", .38), hl(f"M{x0+10} 330 L{x0+16} 344", "#2a3446", .6, 1.5), hl(f"M{x0+4} 314 L{x0+30} 318", "#2a3446", .5, 1.4))

def _arm_back(a, m):      # bras « arrière » (côté image gauche), main au repos
    a(p("M120 206 Q84 222 80 262 L112 270 Q116 240 140 226 Z", m.stD, 3.4), p("M70 258 Q62 296 92 302 Q122 296 118 264 Q96 248 70 258 Z", m.st, 3.4),
      fillhl("M76 266 Q80 282 92 290 Q86 270 94 258 Z", "#fff", .4), hl("M84 270 L84 296 M98 268 L98 296 M110 270 L110 292", "#2a3446", .6, 1.4))

def _arm_front(a, m):     # bras avant (côté image droite)
    a(p("M226 204 Q262 220 264 262 L232 270 Q232 238 212 222 Z", m.stD, 3.4), p("M222 264 Q214 304 246 308 Q276 302 270 266 Q246 250 222 264 Z", m.st, 3.4),
      fillhl("M228 272 Q232 290 244 298 Q238 276 248 264 Z", "#fff", .4), hl("M236 276 L236 302 M250 274 L250 304 M262 276 L262 298", "#2a3446", .6, 1.4))

def _shoulders(a, d, m):
    a(p("M100 206 Q88 166 124 164 Q158 166 158 204 Q150 228 126 228 Q104 226 100 206 Z", m.fur, 3.2), p("M206 202 Q202 170 232 168 Q258 172 258 202 Q250 226 230 226 Q210 222 206 202 Z", m.fur, 3.2))
    for q in ("M110 178 Q118 198 116 216", "M126 172 Q134 198 130 222", "M142 176 Q148 198 142 218", "M216 178 Q222 198 220 214", "M232 174 Q238 198 234 218"): a(hl(q, "#a8b0c6", .85, 1.3))
    a(crystal(d, 112, 172, 52, 26, rot=-16), crystal(d, 138, 168, 36, 18, rot=10), crystal(d, 96, 190, 30, 16, rot=-44), crystal(d, 236, 170, 46, 24, rot=14), crystal(d, 214, 174, 32, 16, rot=-8))

# ============================================================== FACE
def front(pose=None, fx=None):
    d = []; m = mats(d); pz = pose or {}
    R = Rig(pose, body_pivot=(172, 330), pivots={"armB": (120, 206), "armF": (226, 204), "head": (178, 180), "legB": (160, 306), "legF": (208, 306)})
    a = R.add
    def rune(pth, w=1.8): return hl(pth, "#7be9ff", .95, w)
    if fx == "cast": R.raw(aura(d, 172, 230, 150))
    R.part("legB", parent=None); _leg(a, m, 142)
    R.part("legF", parent=None); _leg(a, m, 190)
    R.part("armB"); _arm_back(a, m)
    R.part("body")
    a(p("M112 190 L108 280 Q172 304 238 280 L234 190 Q172 172 112 190 Z", m.st, 4), shade("M184 184 L234 190 L238 280 Q212 292 188 296 Q206 236 184 184 Z", "#0c1630", .34),
      fillhl("M122 198 L118 262 Q134 242 140 202 Z", "#fff", .38), hl("M112 238 L150 244 L158 262", "#2a3446", .7, 1.8), hl("M208 220 L232 226", "#2a3446", .6, 1.6), hl("M130 276 L170 280", "#2a3446", .5, 1.6),
      hl("M232 200 Q240 240 236 278", "#8fe6ff", .6, 1.8),
      p("M110 268 Q172 292 236 268 L236 288 Q172 312 110 288 Z", m.stD, 3))
    for x in (126, 148, 200, 222): a(hl(f"M{x} 276 L{x} 296", "#2a3446", .5, 1.4))
    a(p("M138 206 Q172 218 206 206 L204 256 Q172 270 140 256 Z", m.stD, 2.6), hl("M146 216 Q172 228 198 216", "#e8f0fa", .5, 1.6),
      rune("M150 232 L158 240 L150 248"), rune("M194 232 L186 240 L194 248"), rune("M164 224 L172 232 L180 224"),
      f'<circle cx="172" cy="238" r="{36 if fx=="cast" else 26}" fill="#5cd0ff" fill-opacity="{.35 if fx=="cast" else .2}"/>',
      p("M156 232 L172 210 L188 232 L172 264 Z", m.gem, 3), fillhl("M162 232 L172 216 L172 252 Z", "#fff", .6))
    R.part("armF"); _arm_front(a, m)
    R.part("body"); _shoulders(a, d, m)
    R.part("head")
    a(p("M120 100 L124 170 Q172 188 232 170 L236 100 Q178 80 120 100 Z", m.st, 4), p("M120 100 L146 56 L214 52 L236 100 Q178 80 120 100 Z", m.stL, 3.6),
      shade("M200 92 L236 100 L232 170 Q218 176 200 178 Q212 130 200 92 Z", "#0c1630", .34), hl("M130 98 L150 62", "#ffffff", .85, 2.6), hl("M132 120 L134 160", "#fff", .4, 2),
      hl("M214 62 L222 90", "#2a3446", .6, 1.6), hl("M150 74 L176 70 L184 80", "#2a3446", .5, 1.5), hl("M236 100 Q242 140 232 170", "#8fe6ff", .55, 1.8))
    if pz.get("squint"):
        a(hl("M134 128 Q152 122 172 128", "#7be9ff", 1, 3), hl("M186 126 Q206 120 226 126", "#7be9ff", 1, 3))
    else:
        a(p("M134 124 Q150 114 172 124 Q166 138 150 138 Q136 136 134 124 Z", "#0a1626", 2), p("M186 122 Q206 112 226 122 Q220 138 204 138 Q190 136 186 122 Z", "#0a1626", 2),
          p("M138 126 Q152 118 168 126 Q162 134 150 134 Q140 132 138 126 Z", m.glow, 0), p("M190 124 Q206 116 222 124 Q216 134 204 134 Q194 132 190 124 Z", m.glow, 0),
          e(152, 127, 3.4, 5, "#fff", 0), e(206, 126, 3.4, 5, "#fff", 0))
    a(p("M128 112 Q150 104 174 118 L172 124 Q150 112 130 122 Z", m.stD, 2.4), p("M184 118 Q206 104 232 112 L230 122 Q208 112 186 124 Z", m.stD, 2.4),
      p("M168 146 Q180 140 190 148 Q188 160 178 160 Q168 158 168 146 Z", m.stD, 2.4), e(174, 152, 2, 2.6, "#0a1626", 0), e(184, 152, 2, 2.6, "#0a1626", 0), hl("M146 168 Q178 178 214 168", "#2a3446", .7, 2))
    if pz.get("shout"):
        a(p("M150 168 Q178 196 208 168 Q180 178 150 168 Z", "#0a1626", 2.4), p("M158 170 L164 178 L170 171 Z M176 172 L182 181 L188 172 Z M194 171 L200 178 L204 168 Z", "#e8f0fa", 1.2))
    a(p("M126 164 Q138 196 160 190 Q172 206 184 190 Q208 198 230 164 Q178 182 126 164 Z", m.fur, 3))
    for q in ("M142 172 L144 188", "M160 178 L162 196", "M182 178 L184 194", "M204 176 L206 190"): a(hl(q, "#a8b0c6", .85, 1.2))
    a(crystal(d, 150, 58, 36, 18, rot=-14), crystal(d, 182, 52, 50, 24, rot=4), crystal(d, 212, 60, 30, 15, rot=18))
    if fx == "slam":
        R.raw(burst(d, 304, 222, .9, 7, 150) + swoosh(232, 262, 296, 224, 36, 14))
    elif fx == "windup":
        R.raw(swoosh(70, 80, 120, 150, -26, 10, op=.5) + swoosh(280, 80, 240, 150, 26, 10, op=.5))
    elif fx == "cast":
        R.raw(snow([(70, 90, 4), (110, 60, 3), (300, 100, 4), (260, 50, 3), (50, 180, 3), (305, 220, 3)]) + crystal(d, 70, 120, 32, 18, rot=-20) + crystal(d, 292, 120, 30, 17, rot=20) + rune_ring(172, 372, 124, 24))
    return svg(340, 400, d, R.render(), sx=116)

# ============================================================== DOS
def back(pose=None, fx=None):
    d = []; m = mats(d); pz = pose or {}
    R = Rig(pose, body_pivot=(172, 330), pivots={"armB": (220, 206), "armF": (114, 204), "head": (178, 180), "legB": (160, 306), "legF": (208, 306)})
    a = R.add
    MIR = '<g transform="translate(344 0) scale(-1 1)">'
    if fx == "cast": R.raw(aura(d, 172, 230, 150))
    R.part("legB", parent=None); _leg(a, m, 138)
    R.part("legF", parent=None); _leg(a, m, 186)
    R.part("armB"); a(MIR); _arm_back(a, m); a("</g>")
    R.part("body")
    a(p("M112 190 L108 282 Q172 306 238 282 L234 190 Q172 172 112 190 Z", m.st, 4), shade("M184 184 L234 190 L238 282 Q212 294 188 298 Q206 236 184 184 Z", "#0c1630", .34), fillhl("M122 198 L118 262 Q134 242 140 202 Z", "#fff", .38),
      hl("M172 196 L170 280", "#2a3446", .7, 2), hl("M120 232 L160 240 L170 258", "#2a3446", .6, 1.8), hl("M224 228 L186 240", "#2a3446", .6, 1.6),
      p("M110 270 Q172 294 236 270 L236 290 Q172 314 110 290 Z", m.stD, 3))
    for x in (126, 148, 200, 222): a(hl(f"M{x} 278 L{x} 298", "#2a3446", .5, 1.4))
    for (x, y, h) in ((172, 214, 34), (172, 244, 26)): a(crystal(d, x, y, h, h * .5))     # cristaux dorsaux
    a(p("M132 206 Q172 214 212 206 L208 262 Q172 272 136 262 Z", m.stD, 2.6), hl("M140 214 Q172 222 204 214", "#e8f0fa", .5, 1.6))
    R.part("armF"); a(MIR); _arm_front(a, m); a("</g>")
    R.part("body"); _shoulders(a, d, m)
    R.part("head")
    a(p("M120 100 L124 170 Q172 190 232 170 L236 100 Q178 80 120 100 Z", m.st, 4), p("M120 100 L146 56 L214 52 L236 100 Q178 80 120 100 Z", m.stL, 3.6), shade("M196 92 L236 100 L232 170 Q216 178 196 180 Q210 130 196 92 Z", "#0c1630", .34),
      hl("M130 98 L150 62", "#fff", .85, 2.6), hl("M176 80 L176 176", "#2a3446", .6, 1.8), hl("M138 130 L170 138 M184 130 L226 124", "#2a3446", .5, 1.5), hl("M124 150 L172 158", "#2a3446", .5, 1.5),
      p("M130 160 Q172 186 230 160 Q226 184 176 190 Q134 184 130 160 Z", m.fur, 3))
    a(crystal(d, 150, 58, 36, 18, rot=-14), crystal(d, 182, 52, 50, 24, rot=4), crystal(d, 212, 60, 30, 15, rot=18))
    if fx == "slam": R.raw(burst(d, 36, 222, .9, 7, 150))
    elif fx == "cast":
        R.raw(snow([(70, 90, 4), (110, 60, 3), (300, 100, 4), (260, 50, 3)]) + crystal(d, 70, 120, 32, 18, rot=-20) + crystal(d, 292, 120, 30, 17, rot=20) + rune_ring(172, 372, 124, 24))
    return svg(340, 400, d, R.render(), sx=116)

FRONT = {
    "idle": {},
    "walk": {"body": (0, 0, -4), "legB": (16, 2, 0), "legF": (-20, 6, -6), "armB": (-16, 0, 0), "armF": (18, 0, 0), "head": (-2, 0, 0)},
    "attack": {"body": (5, 8, 2), "head": (6, 4, 0), "legB": (20, -4, 0), "legF": (-14, 8, 0), "armB": (28, 0, 0), "armF": (-62, -16, 6, 1.05), "squint": True},
    "attack_2": {"body": (-5, -4, 0), "head": (-5, 0, 0), "legB": (12, -2, 0), "legF": (-8, 2, 0), "armB": (150, -30, 0), "armF": (-150, 30, 0)},
    "cast": {"body": (-2, 0, -6), "head": (-8, 0, 0), "legB": (8, 0, 0), "legF": (-8, 0, 0), "armB": (118, 0, -4), "armF": (-118, 0, -4), "shout": True},
}
BACK = {
    "idle": {},
    "walk": {"body": (0, 0, -4), "legB": (-20, -2, -6), "legF": (16, 4, 0), "armB": (16, 0, 0), "armF": (-18, 0, 0)},
    "attack": {"body": (-4, 8, 0), "head": (-6, 0, 0), "legB": (-18, -4, 0), "legF": (14, 8, 0), "armB": (62, 16, 6, 1.05), "armF": (-28, 0, 0)},
    "attack_2": {"body": (5, -4, 0), "legB": (-10, 0, 0), "legF": (8, 0, 0), "armB": (-150, 30, 0), "armF": (150, -30, 0)},
    "cast": {"body": (2, 0, -6), "legB": (-8, 0, 0), "legF": (8, 0, 0), "armB": (-118, 0, -4), "armF": (118, 0, -4)},
}
FX = {"attack": "slam", "attack_2": "windup", "cast": "cast"}

def garde(view="front", pose="idle"):
    table = FRONT if view == "front" else BACK
    return (front if view == "front" else back)(table.get(pose, IDLE2), FX.get(pose))
