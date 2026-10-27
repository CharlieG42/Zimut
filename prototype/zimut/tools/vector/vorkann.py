"""Vorkann le Givre (boss des Cimes) — sprite articulé : face / dos × repos, marche, attaque, sort."""
import math
from types import SimpleNamespace as NS
from common import *
from rig import *

CW, CH = 400, 396
def mats(d):
    g = grad
    return NS(iron=g(d, "#59657a", "#161b26"), iron2=g(d, "#3c4658", "#0e121a"), fur=g(d, "#ffffff", "#bfd0e6"), tower=g(d, "#3a4458", "#10141d", 0, 0, 1, 1),
              ham=g(d, "#78889e", "#2a3446", 0, 0, 1, 1), handle=g(d, "#7a5a3c", "#3a2412", 0, 0, 1, 0), glow=rgrad(d, "#d9ffff", "#1fa0e8", .5, .5, .6),
              cape=g(d, "#59657c", "#171c2a"), trim=g(d, "#b4c2dc", "#6a7a9a"))

def _hammer(a, d, m, cast=False):
    a(p("M276 330 L296 322 L308 170 L286 164 Z", m.handle, 4))
    if cast: a('<circle cx="284" cy="130" r="70" fill="#5cd0ff" fill-opacity=".28"/>')
    a(p("M232 104 Q232 88 250 86 L316 94 Q334 96 334 114 L332 160 Q330 176 312 178 L250 172 Q232 170 232 152 Z", m.ham, 5.4), fillhl("M244 98 L318 104 L318 118 L244 112 Z", "#fff", .3),
      hl("M262 128 L272 144 L284 128 L296 144 L308 128", "#9fefff", .95, 2.8))
    for x, y, r in ((338, 130, 30), (232, 130, -30)): a(crystal(d, x, y, 34, 18, rot=r))
    a(crystal(d, 284, 92, 40, 20))

def _arm_r(a, m):
    a(p("M220 214 Q256 224 262 262 L238 276 Q232 248 208 242 Z", m.iron, 5), p("M244 252 Q232 292 262 300 Q298 296 300 262 Q290 238 266 242 Z", m.iron2, 5), hl("M250 262 Q260 280 276 284", "#8aa4c8", .7, 2.4))
    for k in (262, 274, 286): a(hl(f"M260 {k} L296 {k-6}", "#0a0d14", .8, 2))

def _shield(a, d, m):
    a(p("M18 190 Q16 160 50 154 Q92 156 96 190 L98 290 Q92 336 56 346 Q20 336 16 290 Z", m.tower, 5.8), p("M30 198 Q32 176 54 172 Q80 176 82 198 L84 284 Q80 322 56 330 Q30 322 28 284 Z", "none", 2.6, "#7fb0d8"),
      hl("M24 176 Q20 230 26 290", "#fff", .38, 4), shade("M70 160 Q96 170 98 200 L98 290 Q92 330 72 342 Q86 280 70 160 Z", "#000", .28), hl("M56 190 L56 300 M42 236 L70 236 M46 262 L66 262", "#9fefff", .9, 2.8),
      p("M56 216 L68 236 L56 258 L44 236 Z", m.glow, 3))
    for (x, y, r) in ((26, 156, -14), (56, 144, 0), (86, 156, 14)): a(crystal(d, x, y, 34, 18, rot=r))
    a(crystal(d, 20, 250, 26, 14, rot=-70), crystal(d, 92, 260, 26, 14, rot=70))

def _pauld(a, d, m, x, y, s):
    a(p(f"M{x} {y} Q{x-s*46} {y-12} {x-s*40} {y+30} Q{x-s*14} {y+46} {x+s*18} {y+28} Q{x+s*24} {y+6} {x} {y} Z", m.fur, 5),
      hl(f"M{x-s*30} {y+8} Q{x-s*30} {y+24} {x-s*14} {y+32}", "#a9bad4", .9, 2.2), hl(f"M{x-s*18} {y+2} Q{x-s*18} {y+20} {x-s*6} {y+28}", "#a9bad4", .8, 1.6), hl(f"M{x-s*38} {y+14} Q{x-s*36} {y+26} {x-s*26} {y+34}", "#a9bad4", .8, 1.6),
      p(f"M{x-s*8} {y-6} Q{x-s*40} {y-24} {x-s*26} {y+6} Q{x-s*10} {y+8} {x-s*8} {y-6} Z", m.iron, 4.4),
      crystal(d, x - s * 26, y - 8, 46, 24, rot=-s * 24), crystal(d, x - s * 6, y - 16, 34, 18, rot=s * 12))

def _crown(a, d):
    for (x, y, h, w, r) in ((98, 100, 54, 26, -34), (118, 80, 66, 30, -16), (152, 64, 82, 36, 0), (186, 80, 66, 30, 16), (206, 100, 54, 26, 34)): a(crystal(d, x, y + 6, h, w, rot=r))

def _legs(R, a, m, d, flip=False):
    for key, x in (("legB", 116), ("legF", 172)):
        R.part(key, parent=None)
        a(p(f"M{x} 296 L{x+42} 296 L{x+46} 346 L{x-4} 346 Z", m.iron2, 4.4), p(f"M{x-10} 340 Q{x-14} 368 {x+8} 368 L{x+50} 368 Q{x+64} 364 {x+54} 342 Z", m.iron, 5),
          fillhl(f"M{x-4} 346 Q{x} 358 {x+14} 360", "#fff", .25), crystal(d, x + 22, 338, 18, 10))

# ============================================================== FACE
def front(pose=None, fx=None):
    d = []; m = mats(d); pz = pose or {}
    R = Rig(pose, body_pivot=(152, 330), pivots={"armL": (84, 206), "armR": (222, 206), "head": (152, 200), "legB": (140, 296), "legF": (194, 296), "cape": (160, 206)})
    a = R.add
    if fx == "cast": R.raw(aura(d, 170, 220, 190))
    R.part("cape")
    a(p("M92 206 Q60 290 70 372 L86 358 L98 384 L118 362 L132 388 L150 364 L170 384 L190 360 L214 386 L236 358 L254 380 L262 340 Q272 270 228 206 Z", m.cape, 4),
      shade("M170 220 L228 206 Q272 270 262 340 L254 380 L236 358 L214 386 L190 360 L170 384 Q182 300 170 220 Z", "#000", .3), hl("M82 240 Q74 300 80 350", "#9fb0cf", .55, 2.4))
    R.part("armR"); _hammer(a, d, m, fx == "cast")
    _legs(R, a, m, d)
    R.part("body")
    a(p("M80 290 Q66 320 90 332 Q130 340 150 322 Q176 340 214 332 Q240 320 224 290 Z", m.fur, 4.6), hl("M96 306 Q130 320 150 308 Q176 320 210 306", "#a9bad4", .9, 2.4), hl("M80 306 Q152 330 224 306", "#b4c2dc", .8, 2.2),
      p("M82 210 Q68 262 84 298 Q152 322 220 298 Q236 262 222 210 Q152 188 82 210 Z", m.iron, 5.4), shade("M184 212 Q226 236 220 296 Q196 306 174 310 Q196 258 184 212 Z", "#000", .3),
      fillhl("M94 222 Q86 252 92 280 Q104 250 108 226 Z", "#fff", .22), hl("M222 214 Q236 262 222 298", "#8fe6ff", .6, 2),
      p("M112 232 Q152 248 192 232 L188 276 Q152 292 116 276 Z", m.iron2, 3.4), hl("M122 244 Q152 258 182 244", "#8aa4c8", .7, 2.4))
    for (x, y) in ((126, 244), (178, 244), (130, 268), (174, 268)): a(e(x, y, 2.8, 2.8, "#d2deef", 1))
    a(hl("M118 238 Q152 252 186 238", "#cfe0f6", .55, 1.8), p("M138 252 L152 234 L168 252 L152 278 Z", m.glow, 3.4), fillhl("M142 252 L152 240 L152 266 Z", "#fff", .7), p("M80 290 Q152 314 224 290 L224 306 Q152 330 80 306 Z", "#4a3022", 4))
    R.part("armL"); _shield(a, d, m)
    R.part("armR"); _arm_r(a, m)
    R.part("body"); _pauld(a, d, m, 84, 206, 1)
    R.part("body"); _pauld(a, d, m, 222, 206, -1)
    R.part("head")
    a(p("M84 140 Q80 206 116 214 Q152 220 190 212 Q224 200 220 138 Q216 70 152 66 Q88 70 84 140 Z", m.iron, 6), shade("M180 82 Q224 112 218 168 Q210 202 188 212 Q208 154 180 82 Z", "#000", .34), fillhl("M98 100 Q108 78 134 72 Q112 100 106 140 Z", "#fff", .3),
      hl("M218 120 Q226 170 190 210", "#8fe6ff", .55, 2), p("M92 134 Q152 106 212 134 L212 168 Q152 148 92 168 Z", "#0a0f18", 4.4), hl("M96 128 Q152 100 208 128", "#8aa4c8", .6, 2.2))
    for x in (120, 184):
        if pz.get("squint"):
            a(hl(f"M{x-20} 150 Q{x} 140 {x+20} 150", "#7be9ff", 1, 4))
        else:
            a(p(f"M{x-22} 142 Q{x} 134 {x+22} 148 Q{x+14} 160 {x-2} 160 Q{x-18} 158 {x-22} 142 Z", m.glow, 2.6), e(x - 1, 151, 5.5, 7, "#fff", 0), hl(f"M{x-22} 140 Q{x} 130 {x+24} 144", "#06101e", 1, 4))
    a(p("M112 176 Q152 192 192 176 L190 200 Q152 214 114 200 Z", "#10151f", 3.4))
    for i in range(7): a(hl(f"M{122+i*11} 182 L{122+i*11} 202", "#7a8ca8", .8, 2))
    a(p("M148 106 L156 106 L158 168 L146 168 Z", m.iron2, 3)); _crown(a, d)
    a(p("M86 112 Q152 76 218 112 L216 126 Q152 92 88 128 Z", m.iron2, 4))
    if fx == "slam": R.raw(burst(d, 306, 352, 1.35, 8, 170) + swoosh(180, 130, 300, 330, 70, 20))
    elif fx == "windup": R.raw(swoosh(260, 20, 330, 120, -40, 12, op=.55))
    elif fx == "cast":
        R.raw(snow([(40, 60, 4), (90, 30, 3), (330, 40, 4), (360, 150, 3), (20, 200, 3), (370, 250, 4)]) + crystal(d, 36, 110, 34, 19, rot=-18) + crystal(d, 360, 120, 32, 18, rot=22) + rune_ring(160, 372, 150, 28))
    body = '<g transform="translate(20 12)">' + R.render() + "</g>"
    return svg(CW, CH, d, body, sx=140).replace(f'width="{CW}" height="{CH}"', 'width="500" height="495"')

# ============================================================== DOS
def back(pose=None, fx=None):
    d = []; m = mats(d); pz = pose or {}
    R = Rig(pose, body_pivot=(152, 330), pivots={"armR": (82, 206), "armL": (220, 206), "head": (152, 200), "legB": (140, 296), "legF": (194, 296), "cape": (150, 206)})
    a = R.add
    MIR = '<g transform="translate(304 0) scale(-1 1)">'
    if fx == "cast": R.raw(aura(d, 152, 220, 190))
    R.part("armR"); a(MIR); _hammer(a, d, m, fx == "cast"); a("</g>")
    _legs(R, a, m, d)
    R.part("body")
    a(p("M82 210 Q68 262 84 298 Q152 322 220 298 Q236 262 222 210 Q152 188 82 210 Z", m.iron, 5.4), shade("M176 206 Q226 232 220 296 Q196 308 172 312 Q196 258 176 206 Z", "#000", .3),
      p("M104 226 Q152 240 200 226 L196 284 Q152 298 108 284 Z", m.iron2, 3.4), hl("M152 232 L152 292", "#8aa4c8", .6, 2), hl("M112 238 Q152 252 192 238", "#cfe0f6", .55, 1.8))
    for (x, y) in ((124, 246), (180, 246), (128, 272), (176, 272)): a(e(x, y, 2.8, 2.8, "#d2deef", 1))
    a(crystal(d, 152, 252, 40, 20), p("M80 290 Q152 314 224 290 L224 306 Q152 330 80 306 Z", "#4a3022", 4))
    R.part("armL"); a(MIR); _shield(a, d, m); a("</g>")
    R.part("armR"); a(MIR); _arm_r(a, m); a("</g>")
    R.part("body"); _pauld(a, d, m, 84, 206, 1)
    R.part("body"); _pauld(a, d, m, 222, 206, -1)
    R.part("cape")
    a(p("M96 202 Q56 290 66 376 L84 360 L98 388 L120 364 L134 390 L152 366 L172 388 L192 362 L216 388 L238 360 L256 382 L266 340 Q276 266 232 202 Q152 184 96 202 Z", m.cape, 4),
      shade("M158 196 Q232 202 232 202 Q276 266 266 340 L256 382 L238 360 L216 388 L192 362 L172 388 Q190 290 158 196 Z", "#000", .32), fillhl("M104 214 Q70 290 78 360 Q100 290 112 218 Z", "#fff", .18))
    for x in (110, 136, 166, 194, 224): a(hl(f"M{x} 214 Q{x-4} 300 {x-2} 366", "#9fb0cf", .5, 1.8))
    a(hl("M70 376 L84 360 L98 388", "#b4c2dc", .7, 1.8), p("M118 200 L190 200 L186 218 L122 218 Z", m.trim, 2.6), crystal(d, 154, 210, 28, 14))
    R.part("head")
    a(p("M84 140 Q80 206 116 214 Q152 220 190 212 Q224 200 220 138 Q216 70 152 66 Q88 70 84 140 Z", m.iron, 6), shade("M176 80 Q226 112 220 168 Q212 204 188 214 Q208 154 176 80 Z", "#000", .34),
      fillhl("M98 100 Q108 78 134 72 Q112 100 106 140 Z", "#fff", .3), hl("M152 70 L152 214", "#8aa4c8", .6, 2.2), hl("M94 150 Q152 164 214 150", "#0a0f18", .8, 2.4), hl("M92 176 Q152 192 212 176", "#0a0f18", .8, 2.4))
    for (x, y) in ((106, 120), (196, 120), (106, 180), (196, 180)): a(e(x, y, 3, 3, "#d2deef", 1))
    _crown(a, d)
    a(p("M86 112 Q152 76 218 112 L216 126 Q152 92 88 128 Z", m.iron2, 4))
    if fx == "slam": R.raw(burst(d, 62, 352, 1.35, 8, 170))
    elif fx == "cast": R.raw(snow([(40, 60, 4), (330, 40, 4), (360, 150, 3)]) + crystal(d, 36, 110, 34, 19, rot=-18) + rune_ring(160, 372, 150, 28))
    body = '<g transform="translate(20 12)">' + R.render() + "</g>"
    return svg(CW, CH, d, body, sx=140).replace(f'width="{CW}" height="{CH}"', 'width="500" height="495"')

FRONT = {
    "idle": {},
    "walk": {"body": (0, 0, -5), "legB": (14, 4, 0), "legF": (-18, 8, -8), "armL": (-8, 0, 0), "armR": (4, 0, 0), "head": (-2, 0, 0), "cape": (-3, 0, 0)},
    "attack": {"body": (5, 8, 2), "head": (6, 0, 0), "legB": (20, -8, 0), "legF": (-14, 12, 0), "armL": (22, 0, 0), "armR": (100, 10, 0), "cape": (6, -4, 0), "squint": True},
    "attack_2": {"body": (-4, -4, 0), "head": (-5, 0, 0), "legB": (10, -4, 0), "legF": (-8, 4, 0), "armL": (-10, 0, 0), "armR": (-35, 0, -30), "cape": (-5, 0, 0)},
    "cast": {"body": (-2, 0, -6), "head": (-8, 0, 0), "legB": (8, 0, 0), "legF": (-8, 0, 0), "armR": (-12, 0, -44), "armL": (-14, 0, 0)},
}
BACK = {
    "idle": {},
    "walk": {"body": (0, 0, -5), "legB": (-18, -4, -8), "legF": (14, 6, 0), "armL": (8, 0, 0), "armR": (-4, 0, 0), "cape": (3, 0, 0)},
    "attack": {"body": (-5, 8, 0), "head": (-6, 0, 0), "legB": (-20, -6, 0), "legF": (14, 10, 0), "armL": (-22, 0, 0), "armR": (-100, -10, 0), "cape": (-6, 0, 0)},
    "attack_2": {"body": (4, -4, 0), "legB": (-10, 0, 0), "legF": (8, 0, 0), "armR": (35, 0, -30), "cape": (5, 0, 0)},
    "cast": {"body": (2, 0, -6), "legB": (-8, 0, 0), "legF": (8, 0, 0), "armR": (12, 0, -44), "armL": (14, 0, 0)},
}
FX = {"attack": "slam", "attack_2": "windup", "cast": "cast"}

def vorkann(view="front", pose="idle"):
    table = FRONT if view == "front" else BACK
    return (front if view == "front" else back)(table.get(pose, IDLE2), FX.get(pose))
