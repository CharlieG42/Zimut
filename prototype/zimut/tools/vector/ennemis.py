"""Ennemis des Cimes v2 — vue 3/4 vers la droite, contours tonals fins, matières détaillées."""
import math
from common import *

CW, CH = 340, 400

def _strands(b, pts, color, op=.8, w=1.3):
    for q in pts: b.append(hl(q, color, op, w))

# ============================================================== GUERRIER DES MONTS
def guerrier():
    d = []; b = []
    gSkin = grad(d, "#d9985f", "#9a5a33"); gSkinD = grad(d, "#b8774a", "#7a4526")
    gBeard = grad(d, "#a8744a", "#4a2c16"); gFur = grad(d, "#fbfbfd", "#bcc3d4")
    gLeath = grad(d, "#7a5236", "#3a2214"); gPant = grad(d, "#66503c", "#2e2218"); gBoot = grad(d, "#6a4a30", "#2a180c")
    gStone = grad(d, "#b4bcc8", "#555e6c"); gStoneD = grad(d, "#8a94a4", "#3c4452"); gSteel = grad(d, "#c9d2de", "#6d7a8c")
    # jambes + bottes à revers de fourrure
    for x0, bx in ((146, 136), (186, 178)):
        b.append(p(f"M{x0} 308 L{x0+32} 308 L{x0+30} 348 L{x0-2} 348 Z", gPant, 3))
        b.append(p(f"M{bx} 344 Q{bx-6} 376 {bx+14} 377 L{bx+54} 377 Q{bx+62} 372 {bx+54} 352 Z", gBoot, 3.4))
        b.append(p(f"M{bx+2} 336 Q{bx+26} 350 {bx+52} 338 L{bx+56} 352 Q{bx+26} 364 {bx+2} 352 Z", gFur, 2.8))
        _strands(b, [f"M{bx+10} 340 L{bx+8} 352", f"M{bx+22} 344 L{bx+20} 358", f"M{bx+36} 343 L{bx+36} 357"], "#a8b0c6", .9, 1.2)
        b.append(fillhl(f"M{bx+8} 362 Q{bx+14} 372 {bx+28} 374", "#fff", .18))
    # jupe de peaux
    b.append(p("M124 262 L228 262 Q236 300 224 328 L208 308 L196 332 L182 308 L168 334 L154 308 L140 330 L126 304 Q116 284 124 262 Z", gLeath, 3.4))
    b.append(shade("M180 262 L228 262 Q236 300 224 328 L208 308 L196 332 L182 308 Q190 288 180 262 Z", "#000", .3))
    _strands(b, ["M146 270 L142 318", "M170 272 L168 322", "M196 270 L196 322"], "#2a180c", .5, 1.4)
    # torse nu
    b.append(p("M118 190 Q104 236 120 272 Q174 288 230 272 Q244 236 228 190 Q174 176 118 190 Z", gSkin, 4))
    b.append(shade("M184 184 Q232 206 230 270 Q208 280 186 282 Q202 232 184 184 Z", "#3a1608", .34))
    b.append(fillhl("M126 202 Q116 238 124 262 Q138 236 144 206 Z", "#ffd3a0", .3))
    b.append(hl("M140 214 Q160 232 176 218", "#6a3418", .55, 1.8)); b.append(hl("M180 218 Q198 232 214 214", "#6a3418", .55, 1.8))
    b.append(hl("M176 226 L176 262 M158 244 Q176 252 196 244", "#6a3418", .45, 1.6))
    # bandoulière + boucle
    b.append(p("M128 186 L152 184 L232 260 L210 274 Z", gLeath, 3)); b.append(hl("M136 188 L216 266", "#a8805c", .5, 1.4))
    for t in (.22, .42, .62, .82): b.append(e(140 + 80 * t, 190 + 76 * t, 2.4, 2.4, "#c9d2de", .8))
    # ceinture + boucle de pierre
    b.append(p("M118 266 Q174 286 232 266 L232 284 Q174 304 118 284 Z", gLeath, 3))
    b.append(p("M158 272 L196 274 L196 296 L158 294 Z", gStoneD, 2.6)); b.append(hl("M162 278 L192 280", "#d5dbe6", .6, 1.4)); b.append(hl("M166 288 L184 290", "#2c3340", .6, 1.4))
    # bras gauche (image) : épaule, gantelet de pierre
    b.append(p("M124 196 Q92 206 86 246 L112 258 Q116 230 142 216 Z", gSkinD, 3.2))
    b.append(p("M80 240 L116 252 L114 294 Q98 312 80 296 Q70 270 80 240 Z", gStone, 3.4))
    b.append(shade("M104 246 L116 252 L114 294 Q108 304 100 306 Q108 276 104 246 Z", "#0c1020", .3))
    b.append(hl("M88 252 L96 270 L88 286", "#2c3340", .8, 1.8)); b.append(hl("M84 248 L108 256", "#e8edf6", .6, 1.6)); b.append(hl("M86 286 L110 292", "#2c3340", .7, 1.6))
    b.append(p("M76 290 Q70 316 92 320 Q114 316 112 294 Q94 284 76 290 Z", gStoneD, 3)); b.append(hl("M84 300 L84 314 M96 302 L96 316", "#2c3340", .7, 1.5))
    # bras droit (image) : poing de pierre levé
    b.append(p("M216 198 Q250 206 262 244 L238 258 Q230 230 208 220 Z", gSkinD, 3.2))
    b.append(p("M236 256 L270 248 L282 198 L250 190 Z", gStone, 3.4))
    b.append(shade("M262 196 L282 198 L270 248 L256 252 Q268 226 262 196 Z", "#0c1020", .3))
    b.append(hl("M246 232 L262 226 L258 210", "#2c3340", .8, 1.8)); b.append(hl("M254 198 L276 202", "#e8edf6", .6, 1.6))
    b.append(p("M242 196 Q238 168 266 164 Q296 168 288 200 Q268 208 242 196 Z", gStoneD, 3.4))
    b.append(hl("M254 182 Q266 176 280 182", "#e8edf6", .6, 1.6)); b.append(hl("M256 186 L258 198 M268 184 L270 198 M280 188 L282 200", "#2c3340", .7, 1.5))
    # fourrure aux épaules
    b.append(p("M104 204 Q94 168 128 166 Q160 168 160 204 Q152 228 128 228 Q106 226 104 204 Z", gFur, 3.2))
    _strands(b, ["M112 176 Q120 196 118 214", "M126 172 Q134 196 130 220", "M142 176 Q148 198 142 218"], "#a8b0c6", .85, 1.3)
    b.append(p("M208 198 Q204 170 230 168 Q252 172 252 200 Q246 222 226 222 Q210 218 208 198 Z", gFur, 3.2))
    _strands(b, ["M216 178 Q222 196 220 212", "M230 174 Q236 196 232 214"], "#a8b0c6", .85, 1.3)
    # tête chauve
    b.append(p("M142 96 Q138 142 166 152 Q192 158 216 148 Q240 134 238 102 Q234 66 190 62 Q146 64 142 96 Z", gSkin, 3.6))
    b.append(shade("M214 70 Q240 92 236 120 Q230 140 214 148 Q226 112 214 70 Z", "#3a1608", .26))
    b.append(fillhl("M156 78 Q172 62 198 62 Q176 70 164 92 Z", "#ffe0b8", .5))
    # peinture de guerre glaciale + cicatrice
    b.append(hl("M164 78 L186 70", "#59d0ff", .95, 3)); b.append(hl("M168 88 L194 80", "#59d0ff", .95, 3))
    b.append(hl("M176 92 L186 124", "#5a2410", .8, 2.2)); b.append(hl("M172 104 L182 100 M174 112 L184 108", "#5a2410", .8, 1.2))
    # oreille avec anneau
    b.append(p("M138 106 Q128 114 134 130 Q144 134 150 124 L148 108 Z", gSkinD, 2.4)); b.append(hl("M139 112 Q137 120 141 126", "#6a3418", .7, 1.2))
    b.append(f'<circle cx="136" cy="132" r="5" fill="none" stroke="#c9d2de" stroke-width="2"/>')
    # nez + yeux petits et durs
    b.append(p("M222 112 Q246 108 248 128 Q244 144 228 142 Q214 138 222 112 Z", gSkinD, 2.8)); b.append(fillhl("M230 114 Q238 112 242 120", "#ffd3a0", .5)); b.append(e(240, 138, 3, 2, "#4a1c08", 0))
    b.append(p("M172 112 Q186 106 202 112 Q196 122 184 122 Q174 120 172 112 Z", "#f6efe2", 1.6)); b.append(e(191, 114, 5, 6, "#6a3a10", 0)); b.append(e(191, 114, 2.4, 3.2, "#120a04", 0)); b.append(e(189.5, 112, 1.3, 1.3, "#fff", 0))
    b.append(p("M212 108 Q224 104 236 110 Q232 118 222 119 Q214 116 212 108 Z", "#f6efe2", 1.5)); b.append(e(227, 111, 4, 5, "#6a3a10", 0)); b.append(e(227, 111, 2, 2.8, "#120a04", 0))
    b.append(p("M164 98 Q186 90 210 108 L208 115 Q188 104 168 110 Q160 106 164 98 Z", gBeard, 2.6))
    b.append(p("M212 106 Q228 96 246 98 Q246 106 242 108 Q228 104 213 113 Z", gBeard, 2.4))
    # barbe tressée
    b.append(p("M148 128 Q142 168 164 198 Q176 214 190 218 Q208 206 220 184 Q238 160 234 126 Q190 150 148 128 Z", gBeard, 3.2))
    b.append(shade("M204 146 Q236 150 234 126 Q238 160 220 184 Q208 206 190 218 Q202 184 204 146 Z", "#1c0e04", .3))
    _strands(b, ["M162 150 Q164 182 180 208", "M184 152 Q188 184 192 214", "M206 150 Q210 180 198 206"], "#c08c5c", .55, 1.4)
    for (x, y) in ((176, 220), (194, 224)):
        for k in range(4):
            b.append(e(x + k * .5, y + k * 11, 7, 6, gBeard, 2.2))
            b.append(hl(f"M{x-4} {y+k*11-1} Q{x} {y+k*11+3} {x+4} {y+k*11-1}", "#d6a070", .6, 1.1))
        b.append(p(f"M{x-4} {y+43} L{x+4} {y+43} L{x+2} {y+52} L{x-2} {y+52} Z", "#c9d2de", 1.6))
    # moustache
    b.append(p("M170 140 Q188 128 208 140 Q222 132 236 138 Q228 156 206 152 Q190 158 174 152 Q164 148 170 140 Z", gBeard, 2.8))
    b.append(hl("M176 146 Q192 140 206 148", "#c08c5c", .6, 1.3))
    return svg(CW, CH, d, "".join(b), sx=110)

# ============================================================== GRIFFON DES CIMES
def griffon():
    d = []; b = []
    gWhite = grad(d, "#ffffff", "#cfd8e8"); gWingD = grad(d, "#8a9cc0", "#3e4f78"); gWingL = grad(d, "#dde6f6", "#8fa3c6")
    gBody = grad(d, "#efcf98", "#b98a4a"); gBodyD = grad(d, "#d8b070", "#8a5a28"); gBeak = grad(d, "#ffe98a", "#e49a14"); gClaw = grad(d, "#fff0b8", "#d8982c")
    # queue de lion
    b.append(p("M92 300 Q40 300 36 262 Q36 236 62 238 Q54 258 74 266 Q84 274 100 276 Z", gBody, 3.4))
    b.append(p("M36 262 Q20 244 38 226 Q60 220 66 242 Q50 244 48 258 Z", gWhite, 3))
    _strands(b, ["M44 240 Q52 232 62 238"], "#a8b4cc", .9, 1.3)
    # aile arrière
    wing_back = "M150 232 Q96 214 62 156 Q54 138 62 120 Q76 138 92 140 Q92 118 108 104 Q116 128 130 134 Q134 116 150 106 Q154 150 176 190 Z"
    b.append(p(wing_back, gWingD, 3.2))
    for (x1, y1, x2, y2) in ((70, 130, 110, 186), (96, 124, 128, 192), (120, 120, 146, 196), (142, 126, 164, 204)):
        b.append(hl(f"M{x1} {y1} L{x2} {y2}", "#b4c4e2", .8, 1.8))
    # pattes arrière
    b.append(p("M112 286 Q96 316 112 340 L116 352 L156 352 Q162 326 150 288 Z", gBodyD, 3.2))
    b.append(p("M104 346 Q98 372 122 374 L164 374 Q172 366 160 346 Z", gClaw, 3.2))
    for x in (116, 134, 152): b.append(hl(f"M{x} 358 L{x} 370", "#8a5a10", .9, 1.6))
    # corps de lion (3/4)
    b.append(p("M92 246 Q86 304 142 322 Q200 332 252 304 Q276 276 258 236 Q176 204 92 246 Z", gBody, 4))
    b.append(shade("M180 232 Q272 244 260 288 Q248 312 218 324 Q238 280 180 232 Z", "#5a3408", .3))
    b.append(fillhl("M104 252 Q116 238 150 232 Q120 252 114 280 Z", "#fff", .5))
    _strands(b, ["M112 268 Q120 292 140 308", "M150 252 Q156 284 176 306"], "#fff3d6", .6, 2)
    # aile repliée sur le flanc
    b.append(p("M204 242 Q176 220 138 230 Q98 248 72 298 Q104 292 124 276 Q122 292 138 300 Q152 286 160 274 Q166 288 182 292 Q194 272 214 264 Z", gWingL, 3.4))
    b.append(p("M186 246 Q150 234 116 262 Q132 262 148 254 Q164 250 186 246 Z", gWingD, 2.2))
    b.append(p("M136 262 Q112 276 94 298 Q118 288 134 276 Z", gWingD, 2))
    for q in ("M190 248 Q158 252 134 280", "M200 256 Q176 266 154 292", "M170 244 Q132 250 108 286"):
        b.append(hl(q, "#ffffff", .7, 1.5))
    b.append(shade("M190 262 Q206 262 214 264 Q194 272 182 292 Q184 276 190 262 Z", "#1c2c58", .3))
    # pattes avant
    for x in (176, 218):
        b.append(p(f"M{x} 282 Q{x-6} 322 {x+2} 344 L{x+38} 344 Q{x+44} 318 {x+36} 284 Z", gBody, 3.2))
        b.append(p(f"M{x-6} 340 Q{x-12} 372 {x+10} 374 L{x+52} 374 Q{x+62} 366 {x+48} 340 Z", gClaw, 3.2))
        for dx in (8, 22, 36): b.append(hl(f"M{x+dx} 358 L{x+dx} 370", "#8a5a10", .9, 1.6))
    # collerette de plumes blanches
    b.append(p("M168 190 Q156 232 190 262 Q220 276 252 252 Q278 226 258 186 Q214 168 168 190 Z", gWhite, 3.4))
    b.append(shade("M226 190 Q280 214 258 252 Q232 272 204 270 Q232 232 226 190 Z", "#5f72a0", .28))
    for q in ("M186 206 Q192 236 210 258", "M206 200 Q214 236 228 262", "M228 204 Q236 232 238 254", "M176 214 Q178 238 192 254"):
        b.append(hl(q, "#a8b4cc", .95, 1.6))
    # tête d'aigle
    b.append(p("M170 150 Q158 204 206 214 Q244 218 262 184 Q280 144 252 106 Q212 70 180 106 Q168 122 170 150 Z", gWhite, 3.6))
    b.append(shade("M236 112 Q276 144 258 188 Q246 206 220 216 Q252 172 236 112 Z", "#6f82ac", .26))
    # crête de plumes
    b.append(p("M182 102 Q170 62 196 80 Q196 56 214 84 Q226 62 234 94 Q212 98 182 102 Z", gWhite, 3))
    b.append(hl("M192 90 Q198 78 206 84", "#a8b4cc", .9, 1.4))
    # plumes de joue
    _strands(b, ["M190 150 Q194 176 206 196", "M206 150 Q210 178 222 200"], "#a8b4cc", .85, 1.4)
    # bec crochu
    b.append(p("M236 142 Q286 130 306 164 Q300 196 262 192 Q238 186 232 164 Z", gBeak, 3.6))
    b.append(p("M240 166 Q276 160 302 168 Q290 194 262 192 Q244 188 240 166 Z", "#e49a14", 0)); b.append(p("M240 166 Q272 174 302 168", "none", 1.8, "#8a5a10"))
    b.append(hl("M248 148 Q274 142 294 156", "#fff7c0", .9, 2.6)); b.append(e(250, 156, 2, 3, "#7a4a08", 0))
    # œil féroce
    b.append(p("M196 128 Q214 118 234 130 Q228 146 212 148 Q198 144 196 128 Z", "#fff8e8", 2))
    b.append(e(220, 134, 8.5, 10, "#d89a10", 0)); b.append(e(221, 134, 4, 7, "#1a0e02", 0)); b.append(e(218, 130, 2.4, 2.4, "#fff", 0))
    b.append(p("M190 120 Q214 108 242 128 L240 134 Q216 120 194 130 Q188 126 190 120 Z", gWingD, 2.4))
    return svg(CW, CH, d, "".join(b), sx=130)

# ============================================================== GARDE DES PICS
def garde():
    d = []; b = []
    gSt = grad(d, "#b9c6da", "#5a6a82"); gStD = grad(d, "#8c9bb4", "#3c485e"); gStL = grad(d, "#d8e2f0", "#8a9ab6"); gFur = grad(d, "#fbfbfd", "#bcc3d4")
    gGem = grad(d, "#dffaff", "#2a98d8", 0, 0, 1, 1, mid="#5cd0ff"); gGlow = rgrad(d, "#ffffff", "#2ab4ff", .5, .5, .65)
    def rune(pth, w=1.8): b.append(hl(pth, "#7be9ff", .95, w))
    # jambes de pierre
    for x0 in (142, 190):
        b.append(p(f"M{x0} 306 L{x0+36} 306 L{x0+38} 350 L{x0-2} 350 Z", gStD, 3.2))
        b.append(p(f"M{x0-8} 344 Q{x0-12} 376 {x0+8} 377 L{x0+46} 377 Q{x0+58} 372 {x0+48} 348 Z", gSt, 3.4))
        b.append(fillhl(f"M{x0-2} 350 Q{x0} 364 {x0+14} 368", "#fff", .38)); b.append(hl(f"M{x0+10} 330 L{x0+16} 344", "#2a3446", .6, 1.5))
        b.append(hl(f"M{x0+4} 314 L{x0+30} 318", "#2a3446", .5, 1.4))
    # bras arrière (image gauche), poing
    b.append(p("M120 206 Q84 222 80 262 L112 270 Q116 240 140 226 Z", gStD, 3.4))
    b.append(p("M70 258 Q62 296 92 302 Q122 296 118 264 Q96 248 70 258 Z", gSt, 3.4))
    b.append(fillhl("M76 266 Q80 282 92 290 Q86 270 94 258 Z", "#fff", .4)); b.append(hl("M84 270 L84 296 M98 268 L98 296 M110 270 L110 292", "#2a3446", .6, 1.4))
    # torse massif en blocs
    b.append(p("M112 190 L108 280 Q172 304 238 280 L234 190 Q172 172 112 190 Z", gSt, 4))
    b.append(shade("M184 184 L234 190 L238 280 Q212 292 188 296 Q206 236 184 184 Z", "#0c1630", .34))
    b.append(fillhl("M122 198 L118 262 Q134 242 140 202 Z", "#fff", .38))
    # blocs / fissures
    b.append(hl("M112 238 L150 244 L158 262", "#2a3446", .7, 1.8)); b.append(hl("M208 220 L232 226", "#2a3446", .6, 1.6)); b.append(hl("M130 276 L170 280", "#2a3446", .5, 1.6))
    # ceinture de pierre + gemme
    b.append(p("M110 268 Q172 292 236 268 L236 288 Q172 312 110 288 Z", gStD, 3))
    for x in (126, 148, 200, 222): b.append(hl(f"M{x} 276 L{x} 296", "#2a3446", .5, 1.4))
    # plastron runique + gemme
    b.append(p("M138 206 Q172 218 206 206 L204 256 Q172 270 140 256 Z", gStD, 2.6))
    b.append(hl("M146 216 Q172 228 198 216", "#e8f0fa", .5, 1.6))
    rune("M150 232 L158 240 L150 248"); rune("M194 232 L186 240 L194 248"); rune("M164 224 L172 232 L180 224")
    b.append(p("M156 232 L172 210 L188 232 L172 264 Z", gGem, 3)); b.append(fillhl("M162 232 L172 216 L172 252 Z", "#fff", .6))
    b.append(f'<circle cx="172" cy="238" r="26" fill="url(#{gGlow[5:-1]})" opacity=".22"/>')
    # bras avant (image droite)
    b.append(p("M226 204 Q262 220 264 262 L232 270 Q232 238 212 222 Z", gStD, 3.4))
    b.append(p("M222 264 Q214 304 246 308 Q276 302 270 266 Q246 250 222 264 Z", gSt, 3.4))
    b.append(fillhl("M228 272 Q232 290 244 298 Q238 276 248 264 Z", "#fff", .4)); b.append(hl("M236 276 L236 302 M250 274 L250 304 M262 276 L262 298", "#2a3446", .6, 1.4))
    # épaules : fourrure + cristaux
    b.append(p("M100 206 Q88 166 124 164 Q158 166 158 204 Q150 228 126 228 Q104 226 100 206 Z", gFur, 3.2))
    b.append(p("M206 202 Q202 170 232 168 Q258 172 258 202 Q250 226 230 226 Q210 222 206 202 Z", gFur, 3.2))
    for q in ("M110 178 Q118 198 116 216", "M126 172 Q134 198 130 222", "M142 176 Q148 198 142 218", "M216 178 Q222 198 220 214", "M232 174 Q238 198 234 218"):
        b.append(hl(q, "#a8b0c6", .85, 1.3))
    b.append(crystal(d, 112, 172, 52, 26, rot=-16)); b.append(crystal(d, 138, 168, 36, 18, rot=10)); b.append(crystal(d, 96, 190, 30, 16, rot=-44))
    b.append(crystal(d, 236, 170, 46, 24, rot=14)); b.append(crystal(d, 214, 174, 32, 16, rot=-8))
    # tête de bloc, 3/4
    b.append(p("M120 100 L124 170 Q172 188 232 170 L236 100 Q178 80 120 100 Z", gSt, 4))
    b.append(p("M120 100 L146 56 L214 52 L236 100 Q178 80 120 100 Z", gStL, 3.6))
    b.append(shade("M200 92 L236 100 L232 170 Q218 176 200 178 Q212 130 200 92 Z", "#0c1630", .34))
    b.append(hl("M130 98 L150 62", "#ffffff", .85, 2.6)); b.append(hl("M132 120 L134 160", "#fff", .4, 2))
    b.append(hl("M214 62 L222 90", "#2a3446", .6, 1.6)); b.append(hl("M150 74 L176 70 L184 80", "#2a3446", .5, 1.5))
    # visage : yeux de glace plissés, narines
    b.append(p("M134 124 Q150 114 172 124 Q166 138 150 138 Q136 136 134 124 Z", "#0a1626", 2))
    b.append(p("M186 122 Q206 112 226 122 Q220 138 204 138 Q190 136 186 122 Z", "#0a1626", 2))
    b.append(p("M138 126 Q152 118 168 126 Q162 134 150 134 Q140 132 138 126 Z", gGlow, 0)); b.append(p("M190 124 Q206 116 222 124 Q216 134 204 134 Q194 132 190 124 Z", gGlow, 0))
    b.append(e(152, 127, 3.4, 5, "#fff", 0)); b.append(e(206, 126, 3.4, 5, "#fff", 0))
    b.append(p("M128 112 Q150 104 174 118 L172 124 Q150 112 130 122 Z", gStD, 2.4)); b.append(p("M184 118 Q206 104 232 112 L230 122 Q208 112 186 124 Z", gStD, 2.4))
    b.append(p("M168 146 Q180 140 190 148 Q188 160 178 160 Q168 158 168 146 Z", gStD, 2.4)); b.append(e(174, 152, 2, 2.6, "#0a1626", 0)); b.append(e(184, 152, 2, 2.6, "#0a1626", 0))
    b.append(hl("M146 168 Q178 178 214 168", "#2a3446", .7, 2))
    # barbe de neige
    b.append(p("M126 164 Q138 196 160 190 Q172 206 184 190 Q208 198 230 164 Q178 182 126 164 Z", gFur, 3))
    for q in ("M142 172 L144 188", "M160 178 L162 196", "M182 178 L184 194", "M204 176 L206 190"): b.append(hl(q, "#a8b0c6", .85, 1.2))
    # glaces sur le crâne
    b.append(crystal(d, 150, 58, 36, 18, rot=-14)); b.append(crystal(d, 182, 52, 50, 24, rot=4)); b.append(crystal(d, 212, 60, 30, 15, rot=18))
    return svg(CW, CH, d, "".join(b), sx=116)

# ============================================================== ROCHEBRUTE
def rochebrute():
    d = []; b = []
    gR = rgrad(d, "#f0c096", "#9a5e3a", .34, .28, .95); gRD = grad(d, "#d29868", "#6a3820"); gRL = grad(d, "#f6d2aa", "#b47a50")
    gEye = rgrad(d, "#fffbb0", "#ff6a10", .5, .5, .7); gMoss = grad(d, "#b4dc78", "#4a7a28"); gSnow = grad(d, "#ffffff", "#c4d2e6")
    def crack(pth, w=1.8): b.append(hl(pth, "#4a2410", .8, w))
    # pieds / jambes de rocher
    b.append(p("M128 322 Q116 348 130 366 Q156 380 188 372 Q196 346 184 322 Z", gRD, 3.4)); b.append(fillhl("M136 334 Q132 350 142 362 Q146 346 156 336 Z", "#fff", .3))
    b.append(p("M196 322 Q190 350 206 370 Q238 380 262 366 Q268 342 252 322 Z", gRD, 3.4)); b.append(fillhl("M204 334 Q200 352 212 364 Q214 346 226 338 Z", "#fff", .3))
    crack("M148 346 L156 362"); crack("M222 344 L232 360")
    # bras arrière + poing énorme (image gauche), posé
    b.append(p("M110 196 Q64 214 60 262 Q80 290 112 276 Q126 240 140 214 Z", gRD, 3.6))
    b.append(p("M42 262 Q30 304 66 320 Q106 322 118 288 Q112 252 78 246 Z", gR, 3.8))
    b.append(fillhl("M52 272 Q50 296 66 308 Q62 286 78 262 Z", "#fff", .4))
    for q in ("M70 306 Q72 316 70 322", "M88 308 Q90 318 88 322", "M104 300 Q108 310 108 316"): crack(q, 2)
    crack("M60 284 L74 280")
    # torse : gros rocher
    b.append(p("M92 200 Q70 270 110 312 Q176 336 244 312 Q284 270 256 200 Q248 130 176 126 Q104 130 92 200 Z", gR, 4.4))
    b.append(shade("M214 146 Q270 180 258 236 Q268 290 238 312 Q250 262 232 224 Q236 180 214 146 Z", "#3a1606", .3))
    b.append(fillhl("M112 190 Q116 156 156 138 Q128 170 124 224 Z", "#fff", .42))
    # plaques de roche superposées
    b.append(p("M120 214 Q150 204 180 216 L176 250 Q146 262 122 250 Z", gRL, 2.6)); b.append(p("M190 224 Q222 216 246 232 L240 266 Q212 274 190 262 Z", gRD, 2.6))
    crack("M130 224 L150 236 L140 248"); crack("M204 236 L224 248 L214 262"); crack("M150 276 L170 296 L158 308"); crack("M236 290 L222 300")
    # mousse + neige
    b.append(p("M110 250 Q128 240 140 254 Q132 270 114 268 Z", gMoss, 2.6)); b.append(p("M214 290 Q236 282 248 296 Q238 310 218 306 Z", gMoss, 2.6))
    b.append(hl("M114 252 Q126 246 136 254", "#e0ffc0", .8, 1.4))
    b.append(p("M110 176 Q128 132 176 128 Q226 132 246 178 Q226 160 208 168 Q192 148 176 164 Q158 148 142 166 Q126 158 110 176 Z", gSnow, 3.4))
    b.append(hl("M130 162 Q150 140 180 138", "#fff", .95, 2.4)); b.append(hl("M150 168 L152 176 M176 170 L178 180 M202 168 L204 176", "#9aaac4", .9, 1.4))
    # tête enfouie : petit rocher avec yeux braises
    b.append(p("M138 196 Q132 240 176 246 Q222 244 220 196 Q214 160 176 158 Q142 160 138 196 Z", gRD, 3.6))
    b.append(fillhl("M148 178 Q156 166 176 164 Q158 178 154 198 Z", "#fff", .4)); b.append(shade("M200 170 Q222 190 218 220 Q210 238 192 244 Q208 206 200 170 Z", "#3a1606", .3))
    for (x, y, rr) in ((158, 206, 11), (200, 206, 10)):
        b.append(e(x, y, rr + 4, rr + 2, "#1a0a04", 2.4)); b.append(e(x, y, rr, rr - 2, gEye, 0)); b.append(e(x + 1, y, 3, rr - 3, "#3a0c00", 0)); b.append(e(x - 4, y - 4, 2.6, 2.2, "#fff", 0))
    b.append(p("M138 190 Q158 184 174 204 L172 210 Q158 196 140 202 Z", "#4a2412", 2.4)); b.append(p("M184 204 Q200 184 222 190 L220 202 Q202 196 186 210 Z", "#4a2412", 2.4))
    b.append(p("M156 230 Q178 242 200 230 Q196 250 178 250 Q160 250 156 230 Z", "#2a1008", 2.6)); b.append(p("M162 233 L168 242 L174 234 Z M182 234 L188 242 L194 233 Z", "#fff", 1.4))
    crack("M170 164 L176 182 L168 192", 1.6)
    # bras avant levé (image droite) : poing en l'air
    b.append(p("M240 198 Q290 206 304 250 Q284 280 252 266 Q244 232 232 214 Z", gRD, 3.6))
    b.append(p("M262 240 Q250 196 284 184 Q324 184 326 224 Q324 262 288 268 Q268 262 262 240 Z", gR, 3.8))
    b.append(fillhl("M274 196 Q290 186 312 194 Q290 198 278 214 Z", "#fff", .42)); b.append(shade("M306 200 Q326 220 322 248 Q310 266 290 268 Q310 236 306 200 Z", "#3a1606", .3))
    for q in ("M280 252 Q290 256 300 250", "M276 238 Q290 242 306 236", "M278 224 Q292 226 308 220"): crack(q, 1.8)
    b.append(crystal(d, 312, 190, 34, 18, rot=22)); b.append(crystal(d, 106, 142, 30, 16, rot=-24)); b.append(crystal(d, 240, 138, 40, 20, rot=18))
    return svg(CW, CH, d, "".join(b), sx=126)
