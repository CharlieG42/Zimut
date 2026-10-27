"""Rochebrute (Cimes) — brute de rochers articulée : face / dos × repos, marche, attaque, sort."""
import math
from types import SimpleNamespace as NS
from common import *
from rig import *

def mats(d):
    g = grad
    return NS(r=rgrad(d, "#f0c096", "#9a5e3a", .34, .28, .95), rD=g(d, "#d29868", "#6a3820"), rL=g(d, "#f6d2aa", "#b47a50"),
              eye=rgrad(d, "#fffbb0", "#ff6a10", .5, .5, .7), moss=g(d, "#b4dc78", "#4a7a28"), snow=g(d, "#ffffff", "#c4d2e6"))

def crack(a, pth, w=1.8): a(hl(pth, "#4a2410", .8, w))

def _legL(a, m):
    a(p("M128 322 Q116 348 130 366 Q156 380 188 372 Q196 346 184 322 Z", m.rD, 3.4), fillhl("M136 334 Q132 350 142 362 Q146 346 156 336 Z", "#fff", .3)); crack(a, "M148 346 L156 362")
def _legR(a, m):
    a(p("M196 322 Q190 350 206 370 Q238 380 262 366 Q268 342 252 322 Z", m.rD, 3.4), fillhl("M204 334 Q200 352 212 364 Q214 346 226 338 Z", "#fff", .3)); crack(a, "M222 344 L232 360")

def _arm_down(a, m):
    a(p("M110 196 Q64 214 60 262 Q80 290 112 276 Q126 240 140 214 Z", m.rD, 3.6), p("M42 262 Q30 304 66 320 Q106 322 118 288 Q112 252 78 246 Z", m.r, 3.8), fillhl("M52 272 Q50 296 66 308 Q62 286 78 262 Z", "#fff", .4))
    for q in ("M70 306 Q72 316 70 322", "M88 308 Q90 318 88 322", "M104 300 Q108 310 108 316"): crack(a, q, 2)
    crack(a, "M60 284 L74 280")

def _arm_up(a, d, m):
    a(p("M240 198 Q290 206 304 250 Q284 280 252 266 Q244 232 232 214 Z", m.rD, 3.6), p("M262 240 Q250 196 284 184 Q324 184 326 224 Q324 262 288 268 Q268 262 262 240 Z", m.r, 3.8),
      fillhl("M274 196 Q290 186 312 194 Q290 198 278 214 Z", "#fff", .42), shade("M306 200 Q326 220 322 248 Q310 266 290 268 Q310 236 306 200 Z", "#3a1606", .3))
    for q in ("M280 252 Q290 256 300 250", "M276 238 Q290 242 306 236", "M278 224 Q292 226 308 220"): crack(a, q, 1.8)
    a(crystal(d, 312, 190, 34, 18, rot=22))

def _rocks(d, m, pts):
    out = []
    for (x, y, s, r) in pts:
        out.append(f'<g transform="translate({x} {y}) rotate({r}) scale({s})">' + p("M-14 -6 L-4 -16 L12 -10 L16 4 L4 14 L-12 10 Z", m.rD, 3) + fillhl("M-10 -6 L-3 -13 L6 -9 L-4 -2 Z", "#fff", .4) + '</g>')
    return "".join(out)

# ============================================================== FACE
def front(pose=None, fx=None):
    d = []; m = mats(d); pz = pose or {}
    R = Rig(pose, body_pivot=(176, 336), pivots={"armL": (112, 198), "armR": (240, 200), "head": (178, 232), "legL": (156, 322), "legR": (224, 322)})
    a = R.add
    if fx == "cast": R.raw(aura(d, 176, 232, 156))
    R.part("legL", parent=None); _legL(a, m)
    R.part("legR", parent=None); _legR(a, m)
    R.part("armL"); _arm_down(a, m)
    R.part("body")
    a(p("M92 200 Q70 270 110 312 Q176 336 244 312 Q284 270 256 200 Q248 130 176 126 Q104 130 92 200 Z", m.r, 4.4), shade("M214 146 Q270 180 258 236 Q268 290 238 312 Q250 262 232 224 Q236 180 214 146 Z", "#3a1606", .3),
      fillhl("M112 190 Q116 156 156 138 Q128 170 124 224 Z", "#fff", .42), p("M120 214 Q150 204 180 216 L176 250 Q146 262 122 250 Z", m.rL, 2.6), p("M190 224 Q222 216 246 232 L240 266 Q212 274 190 262 Z", m.rD, 2.6))
    for q in ("M130 224 L150 236 L140 248", "M204 236 L224 248 L214 262", "M150 276 L170 296 L158 308", "M236 290 L222 300"): crack(a, q)
    a(p("M110 250 Q128 240 140 254 Q132 270 114 268 Z", m.moss, 2.6), p("M214 290 Q236 282 248 296 Q238 310 218 306 Z", m.moss, 2.6), hl("M114 252 Q126 246 136 254", "#e0ffc0", .8, 1.4),
      p("M110 176 Q128 132 176 128 Q226 132 246 178 Q226 160 208 168 Q192 148 176 164 Q158 148 142 166 Q126 158 110 176 Z", m.snow, 3.4), hl("M130 162 Q150 140 180 138", "#fff", .95, 2.4),
      hl("M150 168 L152 176 M176 170 L178 180 M202 168 L204 176", "#9aaac4", .9, 1.4), hl("M252 206 Q262 252 242 304", "#8fe6ff", .5, 1.8))
    R.part("armR"); _arm_up(a, d, m)
    R.part("head")
    a(p("M138 196 Q132 240 176 246 Q222 244 220 196 Q214 160 176 158 Q142 160 138 196 Z", m.rD, 3.6), fillhl("M148 178 Q156 166 176 164 Q158 178 154 198 Z", "#fff", .4), shade("M200 170 Q222 190 218 220 Q210 238 192 244 Q208 206 200 170 Z", "#3a1606", .3))
    if pz.get("squint"):
        a(hl("M146 204 Q158 198 172 204", "#ffd34a", 1, 4), hl("M186 204 Q200 198 212 204", "#ffd34a", 1, 4))
    else:
        for (x, y, rr) in ((158, 206, 11), (200, 206, 10)):
            a(e(x, y, rr + 4, rr + 2, "#1a0a04", 2.4), e(x, y, rr, rr - 2, m.eye, 0), e(x + 1, y, 3, rr - 3, "#3a0c00", 0), e(x - 4, y - 4, 2.6, 2.2, "#fff", 0))
    a(p("M138 190 Q158 184 174 204 L172 210 Q158 196 140 202 Z", "#4a2412", 2.4), p("M184 204 Q200 184 222 190 L220 202 Q202 196 186 210 Z", "#4a2412", 2.4))
    if pz.get("shout"):
        a(p("M150 224 Q178 262 208 224 Q180 238 150 224 Z", "#2a1008", 2.6), p("M158 226 L164 236 L170 227 Z M176 230 L182 241 L188 230 Z M194 228 L200 236 L204 224 Z", "#fff", 1.3))
    else:
        a(p("M156 230 Q178 242 200 230 Q196 250 178 250 Q160 250 156 230 Z", "#2a1008", 2.6), p("M162 233 L168 242 L174 234 Z M182 234 L188 242 L194 233 Z", "#fff", 1.4))
    crack(a, "M170 164 L176 182 L168 192", 1.6)
    a(crystal(d, 106, 142, 30, 16, rot=-24), crystal(d, 240, 138, 40, 20, rot=18))
    if fx == "slam":
        R.raw(burst(d, 296, 354, 1.15, 8, 170) + _rocks(d, m, [(236, 340, 1.1, 20), (330, 330, .9, -30), (270, 300, .8, 40)]))
    elif fx == "windup":
        R.raw(swoosh(300, 90, 250, 160, 26, 10, op=.5) + swoosh(60, 90, 110, 160, -26, 10, op=.5))
    elif fx == "cast":
        R.raw(_rocks(d, m, [(60, 120, 1.4, 10), (290, 90, 1.2, -20), (110, 60, 1, 30), (240, 60, 1.1, -10), (40, 200, 1, 15)]) + snow([(80, 50, 3), (270, 50, 4), (310, 160, 3)]) + rune_ring(176, 372, 124, 24))
    return svg(340, 400, d, R.render(), sx=126)

# ============================================================== DOS
def back(pose=None, fx=None):
    d = []; m = mats(d); pz = pose or {}
    R = Rig(pose, body_pivot=(164, 336), pivots={"armL": (228, 198), "armR": (100, 200), "head": (164, 232), "legL": (130, 322), "legR": (204, 322)})
    a = R.add
    MIR = '<g transform="translate(340 0) scale(-1 1)">'
    if fx == "cast": R.raw(aura(d, 170, 232, 156))
    R.part("legL", parent=None); a('<g transform="translate(-10 0)">'); _legL(a, m); a("</g>")
    R.part("legR", parent=None); a('<g transform="translate(-10 0)">'); _legR(a, m); a("</g>")
    R.part("armL"); a(MIR); _arm_down(a, m); a("</g>")
    R.part("body")
    a(p("M88 204 Q66 274 108 314 Q172 340 240 314 Q280 274 252 204 Q244 134 170 130 Q100 134 88 204 Z", m.r, 4.4), shade("M212 150 Q268 184 254 240 Q264 294 234 314 Q246 266 228 228 Q232 184 212 150 Z", "#3a1606", .3),
      fillhl("M108 194 Q112 160 152 142 Q124 174 120 228 Z", "#fff", .42))
    for pts in ("M110 224 L148 214 L174 228 L168 262 L128 270 Z", "M184 236 L232 228 L240 268 L198 280 Z", "M120 282 L168 290 L156 316 L126 306 Z"): a(p(pts, m.rD, 2.6))
    for q in ("M120 240 L140 232 L132 252", "M200 250 L220 244", "M150 296 L168 310", "M232 296 L214 304", "M170 150 L176 176 L166 196 L180 222"): crack(a, q)
    a(p("M104 252 Q122 242 134 256 Q126 272 108 270 Z", m.moss, 2.6), p("M206 296 Q228 288 240 302 Q230 316 210 312 Z", m.moss, 2.6),
      p("M106 180 Q124 134 170 130 Q220 134 242 182 Q222 164 204 172 Q188 152 170 168 Q152 152 136 170 Q120 162 106 180 Z", m.snow, 3.4), hl("M126 166 Q146 144 176 142", "#fff", .95, 2.4),
      p("M130 190 Q138 168 170 166 Q202 168 208 192 Q196 182 170 182 Q142 182 130 190 Z", m.rD, 3), hl("M246 206 Q258 254 238 306", "#8fe6ff", .5, 1.8))
    a(crystal(d, 100, 146, 34, 18, rot=-24), crystal(d, 232, 140, 46, 22, rot=18), crystal(d, 168, 134, 28, 15, rot=2))
    R.part("armR"); a(MIR); _arm_up(a, d, m); a("</g>")
    if fx == "slam": R.raw(burst(d, 44, 354, 1.15, 8, 170) + _rocks(d, m, [(104, 340, 1.1, -20), (12, 330, .9, 30)]))
    elif fx == "cast": R.raw(_rocks(d, m, [(60, 120, 1.4, 10), (290, 90, 1.2, -20), (240, 60, 1.1, -10)]) + rune_ring(170, 372, 124, 24))
    return svg(340, 400, d, R.render(), sx=126)

FRONT = {
    "idle": {},
    "walk": {"body": (-3, 0, -5), "legL": (-16, 4, -6), "legR": (18, 0, 0), "armL": (-14, 0, 0), "armR": (10, 0, 0), "head": (3, 0, 0)},
    "attack": {"body": (6, 8, 2), "head": (8, 4, 0), "legL": (16, -6, 0), "legR": (-10, 10, 0), "armL": (30, 0, 0), "armR": (50, 22, 52, 1.12), "squint": True},
    "attack_2": {"body": (-4, -4, 0), "head": (-6, 0, 0), "legL": (10, 0, 0), "legR": (-8, 0, 0), "armL": (150, -20, 0), "armR": (-36, 0, -44)},
    "cast": {"body": (-2, 0, -6), "head": (-8, 0, 0), "legL": (8, 0, 0), "legR": (-8, 0, 0), "armL": (150, -20, 0), "armR": (-36, 0, -44), "shout": True},
}
BACK = {
    "idle": {},
    "walk": {"body": (3, 0, -5), "legL": (16, 0, -6), "legR": (-18, 0, 0), "armL": (14, 0, 0), "armR": (-10, 0, 0)},
    "attack": {"body": (-6, 8, 0), "legL": (-16, -6, 0), "legR": (10, 8, 0), "armL": (-30, 0, 0), "armR": (-50, -22, 52, 1.12)},
    "attack_2": {"body": (4, -4, 0), "legL": (-10, 0, 0), "legR": (8, 0, 0), "armL": (-150, 20, 0), "armR": (36, 0, -44)},
    "cast": {"body": (2, 0, -6), "legL": (-8, 0, 0), "legR": (8, 0, 0), "armL": (-150, 20, 0), "armR": (36, 0, -44)},
}
FX = {"attack": "slam", "attack_2": "windup", "cast": "cast"}

def rochebrute(view="front", pose="idle"):
    table = FRONT if view == "front" else BACK
    return (front if view == "front" else back)(table.get(pose, IDLE2), FX.get(pose))
