"""Tank (Cimes) v2 — vue 3/4 vers la droite, proportions moins « bonhomme », contours fins tonals."""
from common import *

def tank():
    d = []; b = []
    # --- matières ---
    gNavy   = grad(d, "#40558a", "#1d2a4a"); gNavyD = grad(d, "#2e3f6a", "#141d36"); gNavyL = grad(d, "#5a74ac", "#2f4274")
    gTrim   = grad(d, "#aab6d0", "#6c7a9a")
    gSkin   = grad(d, "#ffae5a", "#e0782c"); gSkinD = grad(d, "#f0933e", "#c25f1c")
    gWhite  = grad(d, "#ffffff", "#d3d8e6"); gFur = grad(d, "#fbfbfd", "#bcc3d4")
    gCape   = grad(d, "#c9cedd", "#7d86a2")
    gBoot   = grad(d, "#3b4156", "#171a26"); gPant = grad(d, "#2b3250", "#141828")
    gLeath  = grad(d, "#54382c", "#26160f"); gWood = grad(d, "#8a5a34", "#3e2412", 0, 0, 1, 0)
    gSteel  = grad(d, "#74839f", "#2a3248", 0, 0, 1, 1); gSteelD = grad(d, "#4c5a78", "#1c2336")
    gGem    = grad(d, "#b6fbff", "#1e8fb0", 0, 0, 1, 1, mid="#43d0dc")
    gShield = rgrad(d, "#68739a", "#262c46", .38, .3, .9); gRim = grad(d, "#a7b2cc", "#5b6788")

    # ---------- cape en lambeaux (derrière) ----------
    b.append(p("M126 192 Q98 250 104 322 L114 312 L122 336 L136 316 L146 338 L160 318 L174 330 L190 300 L206 214 Z", gCape, 3.6))
    b.append(shade("M150 230 L206 214 L190 300 L174 330 L160 318 L146 338 Q150 290 150 230 Z", "#1c2440", .26))
    b.append(hl("M112 230 Q106 270 110 308", "#ffffff", .5, 2.4))
    b.append(hl("M122 240 Q118 280 124 322", "#7d86a2", .6, 1.6))

    # ---------- longs cheveux arrière ----------
    b.append(p("M150 96 Q112 118 116 184 Q118 222 128 236 Q140 206 148 160 Q154 126 158 106 Z", gWhite, 3.2))
    b.append(hl("M132 130 Q124 170 128 214", "#aab4cc", .9, 1.8)); b.append(hl("M142 120 Q136 160 138 196", "#aab4cc", .8, 1.6))

    # ---------- bouclier (côté gauche du personnage = droite de l'image) ----------
    b.append(e(256, 296, 58, 58, gRim, 4.2))
    b.append(e(256, 296, 49, 49, gShield, 2.4))
    b.append(shade("M256 247 A49 49 0 0 1 256 345 A30 49 0 0 0 256 247 Z", "#000", .22))
    b.append(fillhl("M214 280 Q222 258 246 250 Q228 268 224 296 Z", "#fff", .22))
    for k in range(12):
        import math
        a = math.radians(k * 30 + 8)
        b.append(e(256 + 53.5 * math.cos(a), 296 + 53.5 * math.sin(a), 2.3, 2.3, "#d5dcee", 0.8))
    b.append(p("M222 330 L246 276 L256 292 L268 268 L292 330 Z", "#7c8cb4", 2.2))
    b.append(p("M246 276 L240 288 L248 286 L254 296 L256 292 Z", "#dfe8fa", 0)); b.append(p("M268 268 L262 280 L270 278 L276 290 Z", "#dfe8fa", 0))
    b.append(hl("M226 322 L246 282", "#ffffff", .35, 1.6))

    # ---------- jambes + bottes ----------
    b.append(p("M150 312 L178 312 L176 352 L146 352 Z", gPant, 3))
    b.append(p("M184 312 L212 312 L214 352 L182 352 Z", gPant, 3))
    b.append(p("M138 346 Q132 376 152 377 L190 377 Q198 372 190 352 Z", gBoot, 3.4))
    b.append(p("M176 346 Q170 376 190 377 L230 377 Q240 372 232 352 Z", gBoot, 3.4))
    b.append(p("M142 346 L184 346 L186 356 L142 356 Z", gNavyD, 2)); b.append(p("M180 346 L226 346 L228 356 L180 356 Z", gNavyD, 2))
    b.append(fillhl("M142 360 Q146 370 158 372", "#fff", .22)); b.append(fillhl("M182 360 Q186 370 198 372", "#fff", .22))

    # ---------- jupe de plates (usée) ----------
    edge = "M122 262 L226 262 Q236 296 220 334 L208 322 L198 340 L184 324 L172 342 L160 324 L148 340 L138 324 L126 336 Q110 296 122 262 Z"
    b.append(p(edge, gNavy, 3.6))
    b.append(shade("M176 262 L226 262 Q236 296 220 334 L208 322 L198 340 L184 324 L176 330 Q184 296 176 262 Z", "#0c1226", .32))
    for x in (146, 172, 198):
        b.append(hl(f"M{x} 270 L{x-4} 322", "#0c1226", .45, 1.6))
    b.append(hl("M126 336 L138 324 L148 340 L160 324 L172 342 L184 324 L198 340 L208 322 L220 334", "#9aa7c6", .9, 1.8))
    b.append(hl("M130 272 Q122 296 128 322", "#7f93c4", .55, 2))

    # ---------- torse ----------
    torso = "M122 194 Q112 236 122 272 Q174 286 226 272 Q236 236 222 194 Q174 180 122 194 Z"
    b.append(p(torso, gNavy, 4))
    b.append(shade("M180 188 Q228 208 226 270 Q204 278 182 280 Q198 232 180 188 Z", "#0c1226", .34))
    b.append(fillhl("M130 204 Q122 234 128 258 Q140 232 146 206 Z", "#9fb6ee", .22))
    # plastron : plaques & rivets
    b.append(p("M138 206 Q174 218 210 206 L206 252 Q174 264 142 252 Z", gNavyL, 2.4))
    b.append(hl("M144 214 Q174 226 204 214", "#a9bcea", .6, 1.8)); b.append(hl("M174 220 L174 258", "#0c1226", .5, 1.6))
    for (x, y) in ((150, 224), (198, 224), (152, 244), (196, 244)):
        b.append(e(x, y, 2.6, 2.6, "#c7d3f0", 0.9))
    b.append(hl("M156 232 L166 240 L176 230 L186 240 L196 232", "#6fe0ee", .55, 1.6))
    # ceinture, boucle, gemme
    b.append(p("M120 266 Q174 284 228 266 L228 282 Q174 300 120 282 Z", gLeath, 3))
    for x in (136, 150, 198, 212): b.append(e(x, 277 + (0 if 150 <= x <= 198 else 0), 2.2, 2.2, "#b9c0d4", 0.8))
    b.append(p("M156 272 L194 272 L194 292 L156 292 Z", gTrim, 2.6).replace("L194 272 L194 292 L156 292 Z", "L194 272 L194 292 L156 292 Z"))
    b.append(p("M175 270 L191 281 L175 296 L159 281 Z", gGem, 2.6)); b.append(fillhl("M175 274 L186 282 L175 282 Z", "#fff", .6)); b.append(hl("M164 281 L175 274", "#fff", .9, 1.2))
    b.append(p("M128 282 L148 286 L146 304 L128 300 Z", gLeath, 2.6)); b.append(hl("M132 288 L144 291", "#8b6a58", .7, 1.4))   # sacoche

    # ---------- bras gauche du perso (image droite), poing fermé ----------
    b.append(p("M214 196 Q242 208 246 246 L226 254 Q224 226 206 216 Z", gNavy, 3.2))
    b.append(shade("M232 214 Q246 232 246 246 L236 250 Q238 232 232 214 Z", "#0c1226", .3))
    b.append(p("M222 246 L248 242 L250 260 L224 264 Z", gTrim, 2.6)); b.append(hl("M226 252 L246 249", "#fff", .5, 1.4))
    b.append(p("M222 262 Q216 288 238 292 Q258 288 254 264 Q240 252 222 262 Z", gSkin, 3.2))
    for k in (270, 279, 288): b.append(hl(f"M226 {k} Q238 {k-4} 252 {k-2}", "#9a4a12", .7, 1.4))
    b.append(shade("M242 262 Q256 270 254 280 Q250 290 238 292 Q248 280 242 262 Z", "#7a3208", .28))
    # épaulière droite (image)
    b.append(p("M204 196 Q200 168 228 168 Q250 172 250 200 Q244 222 222 222 Q206 218 204 196 Z", gFur, 3.4))
    b.append(p("M214 192 Q226 178 242 190 Q238 206 224 208 Q212 204 214 192 Z", gNavyL, 2.4)); b.append(hl("M220 194 L228 200 L236 190", "#aebfe8", .8, 1.6))
    b.append(hl("M208 180 Q216 170 230 170", "#fff", .9, 2.4)); b.append(hl("M212 214 Q222 224 238 220", "#a8b0c6", .8, 1.6))

    # ---------- marteau + bras levé (côté droit du perso = gauche de l'image) ----------
    b.append(p("M104 236 L112 234 L90 146 L80 150 Z", gWood, 2.6)); b.append(hl("M106 230 L88 156", "#d8a870", .6, 1.4))
    for y in (198, 214): b.append(p(f"M{104 - (y-198)*-0.0 - (230-y)*0.25:.0f} {y} l8 -2 l1 5 l-8 2 Z", gLeath, 1.2))
    b.append(f'<g transform="translate(72 132) rotate(-20) scale(.8)">' +
             p("M-40 -24 Q-40 -32 -30 -32 L30 -32 Q40 -32 40 -24 L40 24 Q40 32 30 32 L-30 32 Q-40 32 -40 24 Z", gSteel, 3.6) +
             p("M-44 -26 L-34 -28 L-34 28 L-44 26 Z", gSteelD, 2.2) + p("M34 -28 L44 -26 L44 26 L34 28 Z", gSteelD, 2.2) +
             fillhl("M-30 -27 L28 -27 L28 -17 L-30 -17 Z", "#fff", .32) + shade("M-30 18 L30 18 L30 28 L-30 28 Z", "#000", .3) +
             hl("M-14 -2 L-6 10 L2 -2 L10 10 L18 -2", "#7be9f0", .9, 2) + e(-39, 0, 3, 3, "#c9d3ea", 1) + '</g>')
    # bras
    b.append(p("M136 196 Q110 204 98 240 L122 254 Q128 226 150 214 Z", gNavy, 3.2))
    b.append(p("M92 232 L118 244 L112 262 L88 250 Z", gTrim, 2.6)); b.append(hl("M96 238 L114 247", "#fff", .5, 1.4))
    b.append(p("M84 214 Q72 234 90 248 Q110 252 114 232 Q108 210 84 214 Z", gSkin, 3.2))
    for k in (222, 231, 240): b.append(hl(f"M88 {k} Q98 {k-3} 110 {k+1}", "#9a4a12", .7, 1.4))
    # épaulière gauche (image)
    b.append(p("M100 206 Q92 170 128 168 Q158 170 158 204 Q150 226 126 226 Q104 224 100 206 Z", gFur, 3.4))
    b.append(p("M112 198 Q128 180 148 194 Q142 212 126 214 Q112 210 112 198 Z", gNavyL, 2.4)); b.append(hl("M120 200 L130 206 L140 194", "#aebfe8", .8, 1.6))
    b.append(hl("M106 190 Q112 176 130 172", "#fff", .9, 2.4)); b.append(hl("M106 214 Q116 226 134 224", "#a8b0c6", .8, 1.6))

    # ---------- tête ----------
    b.append(p("M142 96 Q138 142 166 152 Q192 158 216 148 Q240 134 238 102 Q234 66 190 62 Q146 64 142 96 Z", gSkin, 3.6))
    b.append(shade("M214 70 Q240 92 236 120 Q230 140 214 148 Q226 112 214 70 Z", "#8a3a0c", .22))
    b.append(p("M138 104 Q130 112 134 126 Q142 132 148 124 L148 108 Z", gSkinD, 2.4)); b.append(hl("M139 110 Q137 118 141 124", "#8a3a0c", .6, 1.2))   # oreille
    b.append(p("M222 112 Q244 108 246 126 Q242 140 228 138 Q216 134 222 112 Z", gSkinD, 2.8)); b.append(fillhl("M230 114 Q238 112 241 118", "#fff", .45))   # nez
    b.append(e(238, 134, 3, 2, "#7a2e08", 0))
    # yeux
    b.append(p("M170 110 Q186 100 204 108 Q198 122 184 123 Q172 120 170 110 Z", "#fdf9f2", 1.8))
    b.append(e(190, 112, 6.4, 7.2, "#2a3a62", 0)); b.append(e(190, 112, 3, 4, "#0b0f1e", 0)); b.append(e(188, 109, 1.8, 1.8, "#fff", 0))
    b.append(p("M212 106 Q224 100 236 106 Q232 116 222 117 Q213 114 212 106 Z", "#fdf9f2", 1.6))
    b.append(e(226, 109, 4.6, 5.4, "#2a3a62", 0)); b.append(e(226, 109, 2.2, 3, "#0b0f1e", 0)); b.append(e(225, 107, 1.3, 1.3, "#fff", 0))
    # sourcils broussailleux (froncés)
    b.append(p("M162 94 Q184 86 208 104 L206 111 Q186 100 166 106 Q158 102 162 94 Z", gWhite, 2.8))
    b.append(hl("M168 96 Q184 92 200 102", "#fff", .9, 1.6)); b.append(hl("M170 104 Q186 98 202 108", "#9aa5c0", .8, 1.2))
    b.append(p("M210 104 Q226 92 244 94 Q244 102 240 104 Q226 100 211 110 Z", gWhite, 2.6))
    # barbe (mèches)
    beard = "M146 126 Q140 178 162 222 Q174 246 190 256 Q206 238 218 208 Q238 170 232 124 Q190 152 146 126 Z"
    b.append(p(beard, gWhite, 3.4))
    b.append(shade("M200 148 Q236 150 232 124 Q238 170 218 208 Q206 238 190 256 Q198 200 200 148 Z", "#6f7ea8", .3))
    b.append(fillhl("M152 140 Q148 176 164 212 Q164 176 168 148 Z", "#ffffff", .55))
    for pth, w in (("M162 150 Q164 196 184 246", 1.6), ("M180 152 Q184 200 190 250", 1.4), ("M200 150 Q204 198 194 244", 1.6), ("M216 148 Q224 186 206 226", 1.4), ("M156 160 Q158 192 172 226", 1.2)):
        b.append(hl(pth, "#9ba7c4", .9, w))
    # moustache
    b.append(p("M168 138 Q186 124 206 138 Q218 130 234 136 Q226 156 204 152 Q188 158 172 152 Q162 148 168 138 Z", gWhite, 2.8))
    b.append(hl("M174 144 Q190 138 204 146", "#9ba7c4", .9, 1.4)); b.append(hl("M210 142 Q222 138 230 140", "#9ba7c4", .8, 1.2))
    # cheveux dessus : coiffés en arrière
    b.append(p("M134 108 Q124 64 166 52 Q204 42 232 62 Q246 80 240 102 Q230 80 212 74 Q186 70 162 80 Q146 90 142 110 Z", gWhite, 3.4))
    b.append(shade("M200 50 Q236 62 240 102 Q230 80 212 74 Q198 70 190 72 Q204 62 200 50 Z", "#6f7ea8", .28))
    for pth in ("M150 90 Q164 66 196 56", "M146 100 Q158 76 186 66", "M158 84 Q180 68 214 64"):
        b.append(hl(pth, "#9ba7c4", .85, 1.4))
    b.append(hl("M156 70 Q176 54 206 52", "#ffffff", .95, 2.6))
    return svg(340, 400, d, "".join(b), sx=108)

if __name__ == "__main__":
    save("tank", tank(), "/home/claude/zimut/prototype/zimut/assets/sprites/vector/cimes")
