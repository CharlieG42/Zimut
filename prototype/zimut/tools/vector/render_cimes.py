#!/usr/bin/env python3
"""Rend tous les sprites vectoriels de la Nation des Cimes (6 personnages × face/dos × poses).

Usage : python3 render_cimes.py [dossier_de_sortie]      (pip install cairosvg pillow)
Sortie : <out>/heros/tank*.png · <out>/ennemis/<nom>*.png · <out>/boss/cimes*.png (mêmes noms que le jeu, sans ombre)
         <out>/svg/*.svg (sources) · <out>/apercu/*.png (planches de contrôle, avec ombre)"""
import io, os, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import cairosvg
from PIL import Image
import common
from tank import tank
from guerrier import guerrier
from griffon import griffon
from garde import garde
from rochebrute import rochebrute
from vorkann import vorkann

OUT = sys.argv[1] if len(sys.argv) > 1 else os.path.join(os.path.dirname(os.path.abspath(__file__)), "../../assets/sprites/vector/cimes")
CHARS = [("tank", tank, "heros", "tank"), ("guerrier", guerrier, "ennemis", "guerrier_des_monts"), ("griffon", griffon, "ennemis", "griffon_des_cimes"),
         ("garde", garde, "ennemis", "garde_des_pics"), ("rochebrute", rochebrute, "ennemis", "rochebrute"), ("vorkann", vorkann, "boss", "cimes")]
POSES = [("idle", ""), ("idle_2", "_idle_2"), ("walk", "_walk"), ("attack", "_attack"), ("attack_2", "_attack_2"), ("cast", "_cast")]
SCALE = 1.5

for sub in ("heros", "ennemis", "boss", "svg", "apercu"):
    os.makedirs(os.path.join(OUT, sub), exist_ok=True)

def png(svg, scale=SCALE):
    return Image.open(io.BytesIO(cairosvg.svg2png(bytestring=svg.encode(), scale=scale))).convert("RGBA")

def sheet(rows, bg=(214, 216, 222, 255), cell_scale=.6):
    ims = [[png(s, cell_scale) for s in r] for r in rows]
    cw = max(i.width for r in ims for i in r); ch = max(i.height for r in ims for i in r)
    S = Image.new("RGBA", (max(len(r) for r in ims) * cw, len(ims) * ch), bg)
    for ri, r in enumerate(ims):
        for ci, i in enumerate(r):
            S.alpha_composite(i, (ci * cw + (cw - i.width) // 2, ri * ch + (ch - i.height)))
    return S.convert("RGB")

import re
CX = {"tank": 170, "guerrier": 170, "griffon": 170, "garde": 172, "rochebrute": 176, "vorkann": 172}   # axe du personnage (unités du canevas d'origine)
PAD = 8       # marge autour de l'emprise (unités du canevas)
BIG = 220     # extension temporaire du canevas pour mesurer l'emprise réelle (rien n'est rogné)

HDR = re.compile(r'viewBox="0 0 (\d+) (\d+)" width="(\d+)" height="(\d+)"')
def with_view(svg, x0, y0, w, h):
    W, H, pw, ph = map(int, HDR.search(svg).groups()); k = pw / W
    return HDR.sub(f'viewBox="{x0:g} {y0:g} {w:g} {h:g}" width="{w*k:g}" height="{h*k:g}"', svg, 1)

def union_box(cid, fn):
    xs0, ys0, xs1, ys1 = 1e9, 1e9, -1e9, -1e9
    common.SHADOW = False
    for view in ("front", "back"):
        for pose, _ in POSES:
            svg = fn(view, pose); W, H, pw, ph = map(int, HDR.search(svg).groups()); k = pw / W
            im = png(with_view(svg, -BIG, -BIG, W + 2 * BIG, H + 2 * BIG), 1.0)
            bb = im.split()[3].point(lambda v: 255 if v > 8 else 0).getbbox()
            xs0, ys0 = min(xs0, bb[0] / k - BIG), min(ys0, bb[1] / k - BIG); xs1, ys1 = max(xs1, bb[2] / k - BIG), max(ys1, bb[3] / k - BIG)
    cx = CX[cid]; half = max(cx - xs0, xs1 - cx) + PAD
    return cx - half, ys0 - PAD, 2 * half, (ys1 + PAD) - (ys0 - PAD)

n = 0
for cid, fn, folder, base in CHARS:
    x0, y0, w, h = union_box(cid, fn)
    for view in ("front", "back"):
        for pose, suf in POSES:
            name = base + ("_back" if view == "back" else "") + suf
            common.SHADOW = False
            svg = with_view(fn(view, pose), x0, y0, w, h)
            open(os.path.join(OUT, "svg", name + ".svg"), "w").write(svg)
            png(svg).save(os.path.join(OUT, folder, name + ".png")); n += 1
    common.SHADOW = True
    rows = [[with_view(fn(v, p), x0, y0, w, h + 18) for p, _ in POSES] for v in ("front", "back")]
    sheet(rows).save(os.path.join(OUT, "apercu", f"{base}.png"))
    print(f"{base}: cadre {w:.0f}x{h:.0f}")
common.SHADOW = True
sheet([[f(v, "idle") for _, f, _, _ in CHARS] for v in ("front", "back")], cell_scale=.55).save(os.path.join(OUT, "apercu", "_nation_des_cimes.png"))
print(n, "sprites ->", os.path.abspath(OUT))
