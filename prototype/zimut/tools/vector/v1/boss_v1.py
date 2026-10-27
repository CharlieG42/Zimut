import math
from common import *

def vorkann():
    d = []; b = []
    gIron = grad(d, "#59657a", "#161b26"); gIron2 = grad(d, "#3c4658", "#0e121a"); gIce = grad(d, "#eaffff", "#2aa0e8", 0, 0, 1, 1, mid="#8fe0ff")
    gFur = grad(d, "#ffffff", "#bfd0e6"); gTower = grad(d, "#3a4458", "#10141d", 0, 0, 1, 1); gHam = grad(d, "#78889e", "#2a3446", 0, 0, 1, 1)
    gHandle = grad(d, "#7a5a3c", "#3a2412", 0, 0, 1, 0); gGlow = rgrad(d, "#d9ffff", "#1fa0e8", .5, .5, .6)
    # marteau (derrière, à droite)
    b.append(p("M276 330 L296 322 L308 170 L286 164 Z", gHandle, 4))
    b.append(p("M232 104 Q232 88 250 86 L316 94 Q334 96 334 114 L332 160 Q330 176 312 178 L250 172 Q232 170 232 152 Z", gHam, 5.4))
    b.append(fillhl("M244 98 L318 104 L318 118 L244 112 Z", "#fff", .3)); b.append(hl("M262 128 L272 144 L284 128 L296 144 L308 128", "#9fefff", .95, 2.8))
    for x, y, r in ((338, 130, 30), (232, 130, -30)):
        b.append(crystal(d, x, y, 34, 18, rot=r))
    b.append(crystal(d, 284, 92, 40, 20))
    # jambes
    for x in (116, 172):
        b.append(p(f"M{x} 296 L{x+42} 296 L{x+46} 346 L{x-4} 346 Z", gIron2, 4.4))
        b.append(p(f"M{x-10} 340 Q{x-14} 368 {x+8} 368 L{x+50} 368 Q{x+64} 364 {x+54} 342 Z", gIron, 5))
        b.append(fillhl(f"M{x-4} 346 Q{x} 358 {x+14} 360", "#fff", .25)); b.append(crystal(d, x + 22, 338, 18, 10))
    # fourrure basse
    b.append(p("M80 290 Q66 320 90 332 Q130 340 150 322 Q176 340 214 332 Q240 320 224 290 Z", gFur, 4.6))
    b.append(hl("M96 306 Q130 320 150 308 Q176 320 210 306", "#a9bad4", .9, 2.4))
    # torse
    b.append(p("M82 210 Q68 262 84 298 Q152 322 220 298 Q236 262 222 210 Q152 188 82 210 Z", gIron, 5.4))
    b.append(shade("M184 212 Q226 236 220 296 Q196 306 174 310 Q196 258 184 212 Z", "#000", .3))
    b.append(fillhl("M94 222 Q86 252 92 280 Q104 250 108 226 Z", "#fff", .22))
    b.append(p("M112 232 Q152 248 192 232 L188 276 Q152 292 116 276 Z", gIron2, 3.4)); b.append(hl("M122 244 Q152 258 182 244", "#8aa4c8", .7, 2.4))
    b.append(p("M138 252 L152 234 L168 252 L152 278 Z", gGlow, 3.4)); b.append(fillhl("M142 252 L152 240 L152 266 Z", "#fff", .7))
    b.append(p("M80 290 Q152 314 224 290 L224 306 Q152 330 80 306 Z", "#4a3022", 4))
    # bouclier tour (à gauche)
    b.append(p("M18 190 Q16 160 50 154 Q92 156 96 190 L98 290 Q92 336 56 346 Q20 336 16 290 Z", gTower, 5.8))
    b.append(p("M30 198 Q32 176 54 172 Q80 176 82 198 L84 284 Q80 322 56 330 Q30 322 28 284 Z", "none", 2.6, "#7fb0d8"))
    b.append(hl("M24 176 Q20 230 26 290", "#fff", .38, 4)); b.append(shade("M70 160 Q96 170 98 200 L98 290 Q92 330 72 342 Q86 280 70 160 Z", "#000", .28))
    b.append(hl("M56 190 L56 300 M42 236 L70 236 M46 262 L66 262", "#9fefff", .9, 2.8))
    b.append(p("M56 216 L68 236 L56 258 L44 236 Z", gGlow, 3))
    for (x, y, r) in ((26, 156, -14), (56, 144, 0), (86, 156, 14)):
        b.append(crystal(d, x, y, 34, 18, rot=r))
    b.append(crystal(d, 20, 250, 26, 14, rot=-70)); b.append(crystal(d, 92, 260, 26, 14, rot=70))
    # bras droit + gantelet sur le marteau
    b.append(p("M220 214 Q256 224 262 262 L238 276 Q232 248 208 242 Z", gIron, 5))
    b.append(p("M244 252 Q232 292 262 300 Q298 296 300 262 Q290 238 266 242 Z", gIron2, 5)); b.append(hl("M250 262 Q260 280 276 284", "#8aa4c8", .7, 2.4))
    for k in (262, 274, 286): b.append(hl(f"M260 {k} L296 {k-6}", "#0a0d14", .8, 2))
    # épaulières fourrure + cristaux
    for x, y, s in ((84, 206, 1), (222, 206, -1)):
        b.append(p(f"M{x} {y} Q{x-s*46} {y-12} {x-s*40} {y+30} Q{x-s*14} {y+46} {x+s*18} {y+28} Q{x+s*24} {y+6} {x} {y} Z", gFur, 5))
        b.append(hl(f"M{x-s*30} {y+8} Q{x-s*30} {y+24} {x-s*14} {y+32}", "#a9bad4", .9, 2.6))
        b.append(p(f"M{x-s*8} {y-6} Q{x-s*40} {y-24} {x-s*26} {y+6} Q{x-s*10} {y+8} {x-s*8} {y-6} Z", gIron, 4.4))
        b.append(crystal(d, x - s * 26, y - 8, 46, 24, rot=-s * 24)); b.append(crystal(d, x - s * 6, y - 16, 34, 18, rot=s * 12))
    # heaume
    b.append(p("M84 140 Q80 206 116 214 Q152 220 190 212 Q224 200 220 138 Q216 70 152 66 Q88 70 84 140 Z", gIron, 6))
    b.append(shade("M180 82 Q224 112 218 168 Q210 202 188 212 Q208 154 180 82 Z", "#000", .34))
    b.append(fillhl("M98 100 Q108 78 134 72 Q112 100 106 140 Z", "#fff", .3))
    b.append(p("M92 134 Q152 106 212 134 L212 168 Q152 148 92 168 Z", "#0a0f18", 4.4))
    b.append(hl("M96 128 Q152 100 208 128", "#8aa4c8", .6, 2.2))
    # yeux de glace
    for x in (120, 184):
        b.append(p(f"M{x-22} 146 Q{x} 130 {x+22} 146 Q{x+16} 162 {x-2} 162 Q{x-18} 160 {x-22} 146 Z", gGlow, 3))
        b.append(e(x - 2, 150, 7, 9, "#fff", 0))
    b.append(p("M112 176 Q152 192 192 176 L190 200 Q152 214 114 200 Z", "#10151f", 3.4))
    for i in range(7):
        x = 122 + i * 11; b.append(hl(f"M{x} 182 L{x} 202", "#7a8ca8", .8, 2))
    b.append(p("M148 106 L156 106 L158 168 L146 168 Z", gIron2, 3))
    # couronne de pointes de glace
    for (x, y, h, w, r) in ((98, 100, 54, 26, -34), (118, 80, 66, 30, -16), (152, 64, 82, 36, 0), (186, 80, 66, 30, 16), (206, 100, 54, 26, 34)):
        b.append(crystal(d, x, y + 6, h, w, rot=r))
    b.append(p("M86 112 Q152 76 218 112 L216 126 Q152 92 88 128 Z", gIron2, 4))
    return svg(360, 388, d, "".join(b), sx=128)
