from common import *

def tank():
    d = []
    # matières
    steel_hi, steel, steel_lo = "#5f7fb0", "#3a4e6e", "#232f48"
    gS = grad(d, "#6d8fc0", "#2c3d5c", 0, 0, 0, 1)
    gS2 = grad(d, "#4d6a98", "#1f2c45", 0, 0, 1, 1)
    gSkin = grad(d, "#ffc58a", "#e08a45")
    gHair = grad(d, "#ffffff", "#c9d6e6")
    gBrow = grad(d, "#e8f0fa", "#9db4d4")
    gBeard = grad(d, "#ffffff", "#bccbe0")
    gFur = grad(d, "#ffffff", "#c4d2e4")
    gLeather = grad(d, "#7a5236", "#3f2616")
    gBoot = grad(d, "#4a5668", "#1d2430")
    gShield = rgrad(d, "#8fb0d8", "#2d4468", .35, .3, .9)
    gHam = grad(d, "#8a9bb4", "#3b475c", 0, 0, 1, 1)
    gHandle = grad(d, "#a6733f", "#5a3a1c", 0, 0, 1, 0)
    b = []
    # ---- marteau (derrière le corps, côté droit) ----
    b.append(p("M196 262 L213 252 L226 138 L209 132 Z", gHandle, 3.4))
    b.append(shade("M209 132 L226 138 L224 160 L211 156 Z", "#000", .25))
    for y in (180, 205, 230):
        b.append(p(f"M203 {y} L222 {y-6} L222 {y+3} L203 {y+9} Z", "#2e2018", 1.4))
    # tête du marteau
    b.append(p("M168 96 Q168 82 182 80 L248 88 Q262 90 262 104 L260 138 Q260 150 246 152 L184 146 Q168 144 168 130 Z", gHam, 4.6))
    b.append(fillhl("M178 90 L246 96 L246 108 L178 102 Z", "#fff", .35))
    b.append(shade("M176 128 L258 140 L254 150 L184 146 Q170 144 170 130 Z", "#000", .3))
    b.append(p("M168 96 L168 130", steel_lo, 0))
    # runes
    b.append(hl("M196 112 L204 124 L212 112 L220 124 L228 112", "#9fe3ff", .95, 2.6))
    b.append(p("M160 100 L172 98 L172 134 L160 132 Z", "#566480", 3))   # frette gauche
    b.append(p("M258 106 L266 106 L266 138 L258 138 Z", "#566480", 3))
    # ---- jambes ----
    for x, f in ((86, 1), (140, 1)):
        b.append(p(f"M{x} 262 L{x+36} 262 L{x+38} 304 L{x-2} 304 Z", "#39414f", 3.4))
        b.append(p(f"M{x-8} 300 Q{x-12} 326 {x+6} 326 L{x+40} 326 Q{x+52} 324 {x+44} 304 Z", gBoot, 4.4))
        b.append(fillhl(f"M{x-2} 306 Q{x} 318 {x+10} 318", "#fff", .25))
        b.append(p(f"M{x-4} 296 L{x+42} 296 L{x+42} 306 L{x-4} 306 Z", steel, 2.6))
    # ---- cape-fourrure basse / tassets ----
    b.append(p("M70 236 Q62 262 74 278 L114 284 L128 262 L146 284 L186 278 Q198 262 190 236 Z", gS2, 4.6))
    b.append(p("M74 256 L112 262 L110 282 L76 276 Z", gS, 2.6))
    b.append(p("M148 262 L186 256 L184 276 L150 282 Z", gS, 2.6))
    b.append(fillhl("M80 262 L106 266", "#fff", .4))
    # ---- torse ----
    b.append(p("M72 176 Q62 214 70 244 Q130 262 190 244 Q198 214 188 176 Q130 160 72 176 Z", gS, 5))
    b.append(shade("M150 180 Q186 200 188 244 Q170 250 150 252 Q164 214 150 180 Z", "#000", .25))
    b.append(fillhl("M84 186 Q76 212 80 232 Q90 214 96 190 Z", "#fff", .25))
    # plastron : plaques
    b.append(p("M92 196 Q130 210 168 196 L164 232 Q130 244 96 232 Z", gS2, 3))
    b.append(hl("M100 204 Q130 216 160 204", "#9fb8de", .7, 2.4))
    # ceinture + boucle
    b.append(p("M70 238 Q130 256 190 238 L190 252 Q130 270 70 252 Z", gLeather, 4))
    b.append(p("M118 244 L142 244 L142 262 L118 262 Z", "#c9a84a", 3))
    b.append(hl("M122 248 L138 248", "#fff3b0", .9, 2))
    # joyau central (cristal)
    b += [crystal(d, 130, 222, 20, 20)]
    # ---- bras gauche (viewer) + bouclier ----
    b.append(p("M70 190 Q46 204 44 234 Q60 244 76 226 Z", gS, 4.4))
    b.append(e(48, 238, 15, 14, gSkin, 3.4))
    # bouclier rond
    b.append(e(52, 232, 46, 50, gShield, 5.4))
    b.append(e(52, 232, 38, 42, "none", 2.4, "#1e2d4a"))
    b.append(shade("M52 190 A38 42 0 0 1 52 274 A60 42 0 0 0 52 190 Z", "#000", .18))
    # rivets
    for ang in range(0, 360, 45):
        import math
        rx = 52 + 38 * math.cos(math.radians(ang)); ry = 232 + 42 * math.sin(math.radians(ang))
        b.append(e(rx, ry, 3.2, 3.2, "#cfe0f5", 1.6))
    # emblème : montagne + nuage
    b.append(p("M26 252 L46 214 L56 232 L64 222 L80 252 Z", "#eaf4ff", 3))
    b.append(p("M46 214 L40 226 L47 224 L52 230 Z", "#9fe3ff", 0))
    b.append(p("M30 218 Q26 208 38 208 Q42 198 54 204 Q66 200 66 212 Q76 214 70 222 L32 222 Z", "#fff", 2.6))
    b.append(hl("M24 214 Q32 190 52 188", "#fff", .55, 3.6))
    # ---- bras droit tenant le marteau ----
    b.append(p("M186 188 Q212 206 208 238 Q194 244 184 228 Z", gS, 4.4))
    b.append(p("M203 226 Q222 220 226 238 Q222 256 206 254 Q194 246 203 226 Z", gSkin, 4))   # poing
    for k in (232, 241, 250):
        b.append(hl(f"M206 {k} L222 {k-4}", "#a65a22", .6, 1.6))
    b.append(p("M196 206 Q214 214 214 228 L196 232 Z", gLeather, 3))
    # ---- épaulières fourrure ----
    for x, y, s in ((70, 172, 1), (190, 172, -1)):
        b.append(p(f"M{x} {y} Q{x-s*34} {y-8} {x-s*30} {y+24} Q{x-s*12} {y+36} {x+s*16} {y+22} Q{x+s*22} {y+4} {x} {y} Z", gFur, 4.4))
        b.append(p(f"M{x-s*6} {y-6} Q{x-s*26} {y+2} {x-s*24} {y+20}", "none", 0))
        b.append(hl(f"M{x-s*22} {y+6} Q{x-s*20} {y+18} {x-s*10} {y+24}", "#b5c7de", .8, 2.4))
        b.append(crystal(d, x - s * 14, y + 10, 18, 11, rot=s * 18))
    # ---- barbe ----
    b.append(p("M70 120 Q60 176 92 218 Q112 240 128 258 Q146 240 168 218 Q198 176 188 120 Q130 160 70 120 Z", gBeard, 5))
    b.append(shade("M150 150 Q186 176 168 218 Q150 236 130 256 Q142 214 150 150 Z", "#6f86b0", .28))
    for pts in ("M102 168 Q108 200 128 236", "M130 176 Q132 208 130 248", "M158 166 Q154 198 138 234"):
        b.append(hl(pts, "#8ea4c8", .8, 2.2))
    b.append(hl("M82 140 Q84 166 98 190", "#fff", .9, 3))
    # ---- tête ----
    b.append(p("M62 96 Q58 140 100 146 Q130 150 160 144 Q196 134 196 94 Q196 40 130 36 Q66 38 62 96 Z", gSkin, 5.4))
    b.append(shade("M168 70 Q198 90 190 120 Q182 138 160 144 Q178 112 168 70 Z", "#a64a14", .22))
    # nez
    b.append(p("M126 108 Q142 100 150 114 Q148 128 134 128 Q120 126 126 108 Z", "#f0a062", 3))
    b.append(fillhl("M130 108 Q138 104 142 108", "#fff", .5))
    # moustache
    b.append(p("M94 132 Q112 120 130 136 Q148 120 168 132 Q164 156 130 152 Q98 156 94 132 Z", gBeard, 3.6))
    # yeux (froncés)
    b.append(eye(98, 98, 15, 14, "#4a8fd0", (0.2, 0.1)))
    b.append(eye(152, 98, 15, 14, "#4a8fd0", (0.2, 0.1)))
    b.append(p("M78 82 Q100 70 118 86 L118 92 Q100 82 80 92 Z", gBrow, 3.4))
    b.append(p("M132 86 Q152 68 176 82 L174 92 Q154 80 132 92 Z", gBrow, 3.4))
    b.append(p("M70 120 Q62 124 66 134", "none", 0))
    # joues
    b.append(e(86, 120, 9, 5, "#ff7a50", 0).replace('/>', ' fill-opacity=".35"/>'))
    b.append(e(166, 120, 9, 5, "#ff7a50", 0).replace('/>', ' fill-opacity=".35"/>'))
    # ---- cheveux : arrière + mèches haut ----
    b.append(p("M56 108 Q38 60 78 34 Q96 14 128 18 Q170 12 190 38 Q222 62 200 112 Q206 80 182 58 Q130 36 80 58 Q56 76 64 110 Z", gHair, 5))
    b.append(p("M70 66 Q96 30 134 34 Q166 30 184 58 Q150 44 120 54 Q90 60 70 66 Z", gHair, 3))
    b.append(hl("M80 46 Q104 28 138 30", "#fff", .9, 3.6))
    b.append(hl("M72 76 Q70 94 66 104", "#9fb2d0", .8, 2))
    # mèche tressée à droite
    b.append(p("M196 82 Q226 96 214 140 Q206 160 196 150 Q206 120 196 82 Z", gHair, 4))
    b.append(p("M204 122 L212 126 M200 134 L210 140", "none", 1.8))
    # serre-tête cristal
    b.append(p("M70 66 Q130 40 188 62 L186 72 Q130 52 72 76 Z", steel, 3.4))
    b.append(crystal(d, 130, 58, 20, 12))
    body = '<g transform="translate(8 0)">' + "".join(b) + "</g>"
    return svg(280, 340, d, body, sx=92)

if __name__ == "__main__":
    save("tank", tank(), "/home/claude/zimut/prototype/zimut/assets/sprites/vector/cimes")
