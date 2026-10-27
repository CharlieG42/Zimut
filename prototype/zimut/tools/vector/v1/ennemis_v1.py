import math
from common import *

def guerrier():
    d = []; b = []
    gSkin = grad(d, "#c98a5a", "#8a5232"); gFur = grad(d, "#fff", "#c6d3e4"); gBeard = grad(d, "#8a5a38", "#3e2412")
    gPant = grad(d, "#6b4a30", "#33200f"); gStone = grad(d, "#9aa3b0", "#4a525e"); gLeath = grad(d, "#8a5a36", "#4a2c14")
    gBoot = grad(d, "#7a5a3c", "#3a2412")
    # jambes
    for x in (84, 132):
        b.append(p(f"M{x} 250 L{x+34} 250 L{x+36} 296 L{x-2} 296 Z", gPant, 3.6))
        b.append(p(f"M{x-6} 292 Q{x-10} 318 {x+8} 318 L{x+38} 318 Q{x+50} 314 {x+42} 296 Z", gBoot, 4.4))
        b.append(p(f"M{x-4} 288 Q{x+18} 296 {x+40} 288 L{x+42} 298 Q{x+18} 306 {x-6} 298 Z", gFur, 3))
    # bras gauche (arrière)
    b.append(p("M70 176 Q40 192 38 226 L62 232 Q70 210 84 196 Z", gSkin, 4))
    b.append(p("M30 218 Q24 248 44 252 L70 246 Q74 224 62 214 Z", gStone, 4.4))
    b.append(hl("M36 226 Q40 238 46 244", "#fff", .5, 2.4))
    for k in (230, 240): b.append(hl(f"M34 {k} L66 {k+2}", "#2a2f38", .6, 1.6))
    # torse
    b.append(p("M72 170 Q60 216 76 252 Q130 268 184 252 Q200 216 188 170 Q130 150 72 170 Z", gSkin, 5))
    b.append(shade("M150 176 Q186 200 184 250 Q166 258 146 260 Q162 214 150 176 Z", "#000", .25))
    # abdos
    b.append(hl("M108 214 Q130 222 152 214", "#5a2e16", .55, 2.4)); b.append(hl("M130 196 L130 236", "#5a2e16", .5, 2))
    # fourrure en bandoulière + ceinture
    b.append(p("M70 166 Q96 158 124 176 Q150 196 176 232 L156 246 Q130 206 90 192 Q66 188 70 166 Z", gFur, 4))
    b.append(hl("M82 172 Q104 176 124 190", "#b9c9de", .9, 2.4))
    b.append(p("M74 242 Q130 262 186 242 L188 258 Q130 278 72 258 Z", gLeath, 4)); b.append(p("M118 252 L142 252 L142 270 L118 270 Z", "#b8b8c8", 3))
    b.append(p("M70 168 L186 232 L172 244 L60 188 Z", gLeath, 3.4).replace('stroke-width="3.4"','stroke-width="3.4" opacity=".92"'))
    # bras droit : poing levé
    b.append(p("M186 176 Q220 186 226 222 L204 230 Q198 208 180 198 Z", gSkin, 4))
    b.append(p("M198 214 Q192 246 214 252 L240 244 Q246 220 230 208 Z", gStone, 4.4))
    b.append(hl("M206 222 Q212 232 218 238", "#fff", .5, 2.4))
    # épaules fourrure
    for x, s in ((68, 1), (190, -1)):
        b.append(p(f"M{x} 168 Q{x-s*32} 160 {x-s*28} 192 Q{x-s*10} 206 {x+s*16} 190 Q{x+s*20} 172 {x} 168 Z", gFur, 4.4))
        b.append(hl(f"M{x-s*20} 176 Q{x-s*18} 188 {x-s*8} 194", "#b9c9de", .9, 2.4))
    # barbe
    b.append(p("M72 118 Q60 170 96 200 Q116 214 130 226 Q146 214 164 200 Q198 170 186 118 Q130 150 72 118 Z", gBeard, 5))
    for pth in ("M96 160 Q106 190 124 210", "M130 162 L130 214", "M162 158 Q154 188 136 210"):
        b.append(hl(pth, "#b58052", .55, 2.2))
    b.append(hl("M80 134 Q82 158 96 178", "#c48a58", .5, 3))
    # tête
    b.append(p("M64 92 Q60 136 100 142 Q130 146 160 140 Q196 130 194 92 Q192 40 128 38 Q68 40 64 92 Z", gSkin, 5.4))
    b.append(shade("M168 66 Q198 88 190 118 Q182 134 160 140 Q178 108 168 66 Z", "#4a1e08", .25))
    b.append(fillhl("M80 60 Q100 44 124 44", "#ffd2a0", .45))
    # crâne luisant
    b.append(hl("M86 56 Q104 44 130 44", "#fff", .65, 3.4))
    # sourcils
    b.append(p("M72 80 Q96 70 120 90 L118 98 Q96 86 76 96 Z", gBeard, 3.4)); b.append(p("M136 90 Q160 70 184 80 L180 96 Q160 86 138 98 Z", gBeard, 3.4))
    b.append(eye(98, 106, 13, 11, "#a86a1a", (0.2, 0.1))); b.append(eye(156, 106, 13, 11, "#a86a1a", (0.2, 0.1)))
    # moustache & nez
    b.append(p("M124 112 Q140 106 146 122 Q144 134 132 134 Q118 132 124 112 Z", "#b8703e", 3))
    b.append(p("M86 134 Q110 124 130 140 Q150 124 172 134 Q166 158 130 152 Q92 158 86 134 Z", gBeard, 3.6))
    b.append(p("M112 150 Q130 160 148 150", "none", 0))
    # oreilles
    b.append(e(62, 112, 8, 12, gSkin, 3.4)); b.append(e(194, 112, 8, 12, gSkin, 3.4))
    return svg(260, 340, d, '<g transform="translate(0 0)">' + "".join(b) + "</g>", sx=82)

def griffon():
    d = []; b = []
    gWhite = grad(d, "#ffffff", "#ccd8ea"); gWing = grad(d, "#a9bad4", "#5c6f92"); gWing2 = grad(d, "#d9e4f4", "#8da2c4")
    gBody = grad(d, "#e6c28a", "#b88a4c"); gBeak = grad(d, "#ffe27a", "#e09a1c"); gClaw = grad(d, "#ffe9a8", "#d0942a")
    # queue
    b.append(p("M58 258 Q8 262 14 224 Q22 196 52 214 Q38 232 62 238 Z", gBody, 4.4))
    b.append(p("M14 224 Q4 200 26 190 Q46 188 52 214 Q30 208 22 222 Z", gWhite, 4))
    # aile arrière
    b.append(p("M92 168 Q40 150 14 100 Q40 116 52 106 Q60 132 84 130 Q82 148 100 150 Z", gWing, 4.4))
    for i, (x, y) in enumerate(((26, 108), (42, 126), (58, 140))):
        b.append(hl(f"M{x} {y} L{x+30} {y+26}", "#e4edf9", .8, 2.6))
    # arrière-train / pattes
    b.append(p("M70 232 Q60 280 74 296 L112 296 Q116 270 112 238 Z", gBody, 4.4))
    b.append(p("M62 292 Q58 312 80 312 L116 312 Q124 304 112 292 Z", gClaw, 4.4))
    for x in (74, 90, 106): b.append(hl(f"M{x} 300 L{x} 308", "#8a5a10", .8, 2))
    # corps de lion
    b.append(p("M62 188 Q54 252 98 268 Q150 276 186 250 Q206 224 188 188 Q124 160 62 188 Z", gBody, 5))
    b.append(shade("M140 196 Q196 214 188 250 Q166 270 130 272 Q156 234 140 196 Z", "#6a3a08", .28))
    b.append(fillhl("M74 200 Q82 188 112 186", "#fff", .5))
    b.append(hl("M80 214 Q92 240 108 252", "#fff3d6", .6, 3))
    # pattes avant
    for x in (118, 156):
        b.append(p(f"M{x} 244 Q{x-6} 280 {x+2} 298 L{x+36} 298 Q{x+42} 276 {x+34} 246 Z", gBody, 4.4))
        b.append(p(f"M{x-6} 294 Q{x-10} 314 {x+10} 314 L{x+44} 314 Q{x+54} 306 {x+42} 294 Z", gClaw, 4.4))
        for dx in (6, 20, 34): b.append(hl(f"M{x+dx} 302 L{x+dx} 310", "#8a5a10", .8, 2))
    # collerette blanche
    b.append(p("M92 160 Q74 190 104 214 Q130 232 160 214 Q196 190 170 156 Q130 140 92 160 Z", gWhite, 4.6))
    for pts in ("M106 176 Q112 198 128 212", "M130 168 Q134 196 140 214", "M154 176 Q150 198 144 212"):
        b.append(hl(pts, "#a9bad4", .85, 2.2))
    # aile avant
    b.append(p("M156 176 Q214 156 240 96 Q252 130 232 166 Q246 164 250 148 Q252 188 214 214 Q190 226 168 216 Z", gWing2, 4.6))
    b.append(p("M168 190 Q206 180 234 132 Q232 168 210 200 Q190 214 170 206 Z", gWing, 3))
    for (x1, y1, x2, y2) in ((190, 190, 232, 150), (180, 202, 224, 176), (172, 210, 212, 198)):
        b.append(hl(f"M{x1} {y1} L{x2} {y2}", "#fff", .7, 2.6))
    # tête
    b.append(p("M70 108 Q58 164 112 176 Q150 180 174 150 Q196 108 168 74 Q124 36 86 66 Q70 82 70 108 Z", gWhite, 5.4))
    b.append(shade("M156 80 Q192 106 172 150 Q162 170 138 178 Q168 136 156 80 Z", "#6f86b0", .25))
    # plumes de crête
    b.append(p("M92 62 Q84 26 108 40 Q112 20 126 46 Q140 28 144 56 Q130 56 92 62 Z", gWhite, 4))
    b.append(hl("M100 50 Q108 40 114 44", "#a9bad4", .9, 2))
    # bec
    b.append(p("M148 108 Q196 100 214 126 Q206 150 176 148 Q150 144 142 126 Z", gBeak, 4.8))
    b.append(p("M150 124 Q182 120 210 128 Q198 148 176 148 Q154 144 150 124 Z", "#e0a020", 0))
    b.append(hl("M158 112 Q182 108 200 120", "#fff6b8", .9, 3))
    b.append(p("M150 124 Q180 132 208 128", "none", 2.4)); b.append(e(160, 118, 2.4, 3.4, "#7a4a08", 0))
    # œil immense
    b.append(eye(122, 112, 21, 23, "#c88a10", (0.35, 0.1)))
    b.append(p("M98 92 Q122 82 146 96", "none", 3.2))
    b.append(e(100, 140, 9, 5, "#ff9a7a", 0).replace('/>', ' fill-opacity=".45"/>'))
    return svg(260, 340, d, "".join(b), sx=92)

def garde():
    d = []; b = []
    gStone = grad(d, "#a9b6c9", "#566478"); gStone2 = grad(d, "#8997ad", "#3c485a"); gTop = grad(d, "#cfd8e6", "#8997ad")
    gGem = grad(d, "#dff9ff", "#2f9ad6", 0, 0, 1, 1); gFur = grad(d, "#fff", "#c6d3e4")
    # jambes
    for x in (88, 138):
        b.append(p(f"M{x} 256 L{x+36} 256 L{x+40} 306 L{x-4} 306 Z", gStone2, 4.4))
        b.append(p(f"M{x-8} 300 Q{x-12} 324 {x+8} 324 L{x+42} 324 Q{x+54} 322 {x+46} 302 Z", gStone, 4.6))
        b.append(fillhl(f"M{x-2} 308 Q{x} 316 {x+12} 318", "#fff", .4))
    # bras arrière + main
    b.append(p("M62 186 Q22 206 26 248 L58 252 Q62 224 84 208 Z", gStone2, 4.6))
    b.append(p("M18 238 Q12 272 42 274 Q68 270 66 242 Q50 226 18 238 Z", gStone, 4.6))
    b.append(hl("M26 246 Q34 262 48 266", "#fff", .5, 2.4))
    # torse cubique
    b.append(p("M62 170 L66 262 Q130 282 194 262 L198 170 Q130 150 62 170 Z", gStone, 5.4))
    b.append(shade("M150 168 L198 170 L194 262 Q170 270 148 272 Q164 220 150 168 Z", "#000", .26))
    b.append(fillhl("M72 178 Q70 218 76 246 Q88 214 92 180 Z", "#fff", .32))
    b.append(hl("M70 200 L96 204 M168 214 L192 210 M84 240 L112 246", "#2e3947", .6, 2))
    # fissures
    b.append(hl("M112 196 L120 214 L108 226 L118 244", "#34404f", .75, 2.4))
    # gemme poitrine
    b.append(p("M110 214 L130 192 L150 214 L130 244 Z", gGem, 3.8)); b.append(fillhl("M116 214 L130 198 L130 230 Z", "#fff", .55))
    # fourrure
    b.append(p("M62 168 Q130 148 198 168 L196 190 Q130 168 64 190 Z", gFur, 4.4))
    b.append(hl("M80 174 Q130 160 180 174", "#b9c9de", .9, 2.4))
    # bras avant + poing
    b.append(p("M196 186 Q234 204 232 244 L202 250 Q200 224 180 208 Z", gStone2, 4.6))
    b.append(p("M196 238 Q190 274 220 278 Q250 272 244 240 Q226 224 196 238 Z", gStone, 4.6))
    b.append(hl("M206 246 Q214 262 228 266", "#fff", .5, 2.4))
    # épaulières cristal
    for x, y, s in ((62, 172, 1), (198, 172, -1)):
        b.append(p(f"M{x} {y} Q{x-s*44} {y-12} {x-s*40} {y+24} Q{x-s*14} {y+38} {x+s*14} {y+22} Z", gStone2, 4.6))
        b.append(fillhl(f"M{x-s*34} {y+2} Q{x-s*38} {y+16} {x-s*26} {y+26}", "#fff", .35))
        b.append(crystal(d, x - s * 24, y + 6, 40, 24, rot=-s * 12))
        b.append(crystal(d, x - s * 4, y - 6, 26, 15, rot=s * 22))
    # tête cube
    b.append(p("M56 96 L60 164 Q130 184 200 164 L204 96 Q130 70 56 96 Z", gStone, 5.4))
    b.append(p("M56 96 L90 52 L170 52 L204 96 Q130 70 56 96 Z", gTop, 5))
    b.append(shade("M160 96 L204 96 L200 164 Q182 170 160 172 Z", "#000", .22))
    b.append(hl("M72 90 L98 60", "#fff", .8, 3.2))
    # grand visage
    b.append(eye(98, 128, 21, 22, "#5cd0ff", (0.2, 0.1)))
    b.append(eye(164, 128, 21, 22, "#5cd0ff", (0.2, 0.1)))
    b.append(e(130, 152, 15, 10, "#6b7a90", 3)); b.append(e(124, 152, 2.4, 3, "#2a3340", 0)); b.append(e(136, 152, 2.4, 3, "#2a3340", 0))
    b.append(hl("M112 170 Q130 178 148 170", "#2e3947", .9, 2.6))
    # barbe de fourrure sous la tête
    b.append(p("M84 164 Q92 190 112 184 Q130 200 148 184 Q170 190 176 164 Q130 180 84 164 Z", gFur, 3.6))
    # cristaux sur le crâne
    b.append(crystal(d, 112, 56, 26, 14, rot=-10)); b.append(crystal(d, 140, 54, 34, 18, rot=8))
    return svg(260, 340, d, "".join(b), sx=92)

def rochebrute():
    d = []; b = []
    gRock = rgrad(d, "#e8b890", "#9a5e3a", .35, .28, .95); gRock2 = grad(d, "#c98a5c", "#6e3c22"); gMoss = grad(d, "#a8d070", "#4c7a2a")
    gEye = rgrad(d, "#fff3a0", "#ff6a10", .5, .5, .7)
    # pieds
    for x in (62, 148):
        b.append(e(x + 24, 304, 40, 22, gRock2, 4.8)); b.append(fillhl(f"M{x} 296 Q{x+22} 284 {x+46} 292", "#fff", .3))
    # bras/poings énormes
    for x, s in ((40, 1), (220, -1)):
        b.append(p(f"M{x} 170 Q{x-s*34} 214 {x-s*18} 254 Q{x+s*18} 276 {x+s*36} 244 Q{x+s*40} 200 {x} 170 Z", gRock2, 5))
        b.append(e(x - s * 4, 262, 38, 36, gRock, 5)); b.append(fillhl(f"M{x-s*30} 244 Q{x-s*24} 232 {x-s*8} 232", "#fff", .45))
        for k in (-14, 4, 22): b.append(hl(f"M{x+k-s*4} 276 Q{x+k-s*4} 286 {x+k-s*4} 290", "#5a2e16", .6, 2.4))
        b.append(hl(f"M{x-s*22} 258 Q{x-s*16} 246 {x-s*4} 244", "#5a2e16", .5, 2))
    # corps rocher
    b.append(p("M50 160 Q36 260 92 284 Q130 292 168 284 Q224 260 210 160 Q210 74 130 64 Q50 74 50 160 Z", gRock, 5.6))
    b.append(shade("M168 78 Q214 112 210 166 Q220 250 168 284 Q196 214 168 78 Z", "#4a1e08", .28))
    b.append(fillhl("M70 110 Q82 80 116 70 Q92 100 84 140 Z", "#fff", .45))
    # fissures et mousse
    b.append(hl("M96 82 L106 108 L94 124 L108 146", "#5a2e16", .8, 3)); b.append(hl("M176 214 L160 236 L172 256", "#5a2e16", .7, 2.6))
    b.append(p("M76 134 Q92 124 100 138 Q92 148 78 146 Z", gMoss, 3)); b.append(p("M156 80 Q176 76 182 92 Q168 98 156 92 Z", gMoss, 3))
    # glaçons / neige sur le dessus
    b.append(p("M76 96 Q130 40 184 96 Q168 80 150 90 Q130 70 110 90 Q92 78 76 96 Z", "#fff", 4.4))
    b.append(hl("M96 88 Q128 60 164 86", "#b9c9de", .9, 2.4))
    b.append(crystal(d, 190, 82, 26, 15, rot=26)); b.append(crystal(d, 70, 88, 22, 13, rot=-24))
    # grands yeux incandescents
    for x in (100, 160):
        b.append(e(x, 160, 24, 21, "#2a1208", 3.4))
        b.append(e(x, 160, 17, 15, gEye, 0)); b.append(e(x + 2, 160, 5, 11, "#3a0c00", 0)); b.append(e(x - 6, 152, 5, 4, "#fff", 0))
    b.append(p("M70 134 Q100 120 122 148 L120 156 Q100 140 74 150 Z", "#4a2412", 3.4)); b.append(p("M138 148 Q160 120 190 134 L186 150 Q160 140 140 156 Z", "#4a2412", 3.4))
    # bouche
    b.append(p("M104 214 Q130 232 156 214 Q150 240 130 240 Q110 240 104 214 Z", "#3a1408", 3.4)); b.append(p("M112 218 L118 228 L124 218 Z M136 218 L142 228 L148 218 Z", "#fff", 1.8))
    return svg(280, 340, d, '<g transform="translate(10 0)">' + "".join(b) + "</g>", sx=100)
