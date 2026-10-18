#!/usr/bin/env python3
"""gen_forge_art.py — Visuels de la Forge (assets/ui/forge/) : fond de forge en pierre, emblème,
icônes de catégories d'équipement (tuiles) et de ressources. Usage : python3 tools/gen_forge_art.py"""
import io, os, random
import cairosvg
import numpy as np
from PIL import Image, ImageFilter

HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, "..", "assets", "ui", "forge")
os.makedirs(OUT, exist_ok=True)

def svg_png(body, size, name, vb=100):
    svg = "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 %d %d'>%s</svg>" % (vb, vb, body)
    png = cairosvg.svg2png(bytestring=svg.encode(), output_width=size, output_height=size)
    im = Image.open(io.BytesIO(png)).convert("RGBA")
    im.save(os.path.join(OUT, name))
    return im

DEFS = """<defs>
<linearGradient id='steel' x1='0' y1='0' x2='0' y2='1'><stop offset='0' stop-color='#d5dae4'/><stop offset='1' stop-color='#6b7384'/></linearGradient>
<linearGradient id='gold' x1='0' y1='0' x2='0' y2='1'><stop offset='0' stop-color='#ffe08a'/><stop offset='1' stop-color='#b9791a'/></linearGradient>
<linearGradient id='wood' x1='0' y1='0' x2='1' y2='1'><stop offset='0' stop-color='#c58a4e'/><stop offset='1' stop-color='#6b3f1d'/></linearGradient>
<linearGradient id='leather' x1='0' y1='0' x2='1' y2='1'><stop offset='0' stop-color='#d79a68'/><stop offset='1' stop-color='#7d4a28'/></linearGradient>
<linearGradient id='blue' x1='0' y1='0' x2='0' y2='1'><stop offset='0' stop-color='#6fb3ff'/><stop offset='1' stop-color='#2a5fb0'/></linearGradient>
</defs>"""
ST = "stroke='#1c1410' stroke-width='3.5' stroke-linejoin='round' stroke-linecap='round'"

ICONS = {
 "arme": "<g transform='rotate(40 50 50)'><path d='M47 6 L53 6 L55 62 L45 62 Z' fill='url(#steel)' %s/><rect x='32' y='62' width='36' height='8' rx='3' fill='url(#gold)' %s/><rect x='46' y='70' width='8' height='18' rx='3' fill='url(#wood)' %s/><circle cx='50' cy='91' r='5' fill='url(#gold)' %s/></g>" % (ST,ST,ST,ST),
 "bouclier": "<path d='M50 8 L86 20 Q86 62 50 92 Q14 62 14 20 Z' fill='url(#blue)' %s/><path d='M50 8 L86 20 Q86 62 50 92 Z' fill='#000' opacity='.18'/><path d='M50 22 L50 78 M28 42 H72' stroke='url(#gold)' stroke-width='8' stroke-linecap='round'/>" % ST,
 "casque": "<path d='M18 62 Q16 24 50 20 Q84 24 82 62 L82 72 L66 72 L66 60 L34 60 L34 72 L18 72 Z' fill='url(#steel)' %s/><rect x='40' y='38' width='20' height='8' rx='3' fill='#1c1410'/><path d='M50 8 Q58 14 50 24 Q42 14 50 8Z' fill='#d94b3a' %s/>" % (ST,ST),
 "armure": "<path d='M30 14 L12 28 L22 48 L32 42 L32 88 L68 88 L68 42 L78 48 L88 28 L70 14 Q50 30 30 14Z' fill='url(#leather)' %s/><path d='M30 14 Q50 30 70 14 L64 22 Q50 34 36 22Z' fill='#1c1410' opacity='.35'/><path d='M50 36 V86' stroke='#1c1410' stroke-width='3' opacity='.5'/><circle cx='50' cy='52' r='5' fill='url(#gold)' %s/>" % (ST,ST),
 "bottes": "<path d='M30 10 H58 V54 Q82 56 90 70 V86 H24 Q20 86 20 80 L24 52 Z' fill='url(#leather)' %s/><path d='M24 74 H90' stroke='#1c1410' stroke-width='5'/><rect x='30' y='10' width='28' height='10' fill='url(#gold)' %s/>" % (ST,ST),
 "bague": "<circle cx='50' cy='62' r='26' fill='none' stroke='url(#gold)' stroke-width='12'/><circle cx='50' cy='62' r='26' fill='none' stroke='#1c1410' stroke-width='2' opacity='.5'/><path d='M38 30 L50 12 L62 30 L50 42 Z' fill='#7fe3ff' %s/><path d='M38 30 L62 30' stroke='#fff' stroke-width='2' opacity='.7'/>" % ST,
 "collier": "<path d='M18 18 Q50 70 82 18' fill='none' stroke='url(#gold)' stroke-width='7' stroke-linecap='round'/><path d='M18 18 Q50 70 82 18' fill='none' stroke='#1c1410' stroke-width='2' opacity='.5'/><path d='M50 52 L64 68 L50 90 L36 68 Z' fill='#ff6b8a' %s/><path d='M50 52 L64 68 L50 68Z' fill='#fff' opacity='.45'/>" % ST,
 "gants": "<path d='M28 92 V52 L20 34 Q18 26 26 26 L34 42 V16 Q34 10 40 10 Q46 10 46 16 V40 V12 Q46 6 52 6 Q58 6 58 12 V40 V16 Q58 10 64 10 Q70 10 70 16 V44 V26 Q70 20 76 20 Q82 20 82 26 V60 Q82 76 72 82 V92 Z' fill='url(#leather)' %s/><rect x='26' y='80' width='48' height='12' rx='3' fill='url(#gold)' %s/>" % (ST,ST),
 "boucle_oreille": "<circle cx='50' cy='22' r='10' fill='none' stroke='url(#gold)' stroke-width='6'/><path d='M50 32 V44' stroke='url(#gold)' stroke-width='5'/><path d='M50 44 L68 66 L50 92 L32 66 Z' fill='#5fd3ff' %s/><path d='M50 44 L68 66 L50 66Z' fill='#fff' opacity='.5'/>" % ST,
 "cape": "<path d='M30 10 H70 L74 22 Q88 60 90 90 Q70 82 50 90 Q30 82 10 90 Q12 60 26 22 Z' fill='#b8333a' %s/><path d='M50 22 Q46 60 50 90' stroke='#000' stroke-width='3' opacity='.25' fill='none'/><rect x='28' y='8' width='44' height='12' rx='5' fill='url(#gold)' %s/>" % (ST,ST),
 "all": "<path d='M50 8 L58 38 L90 40 L64 58 L74 90 L50 70 L26 90 L36 58 L10 40 L42 38 Z' fill='url(#gold)' %s/>" % ST,
}
TILE = {"arme": "#7a2e2a", "bouclier": "#2c4a7a", "casque": "#55606f", "armure": "#6a4a2a", "bottes": "#5a3d28",
        "bague": "#4a3a7a", "all": "#6a5424", "collier": "#6a2a4a", "gants": "#5a3d28",
        "boucle_oreille": "#2a5a6a", "cape": "#6a2626"}

def tile(key, size=128):
    base = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    r = int(size * 0.2)
    col = TILE[key]
    body = "<defs><linearGradient id='t' x1='0' y1='0' x2='0' y2='1'><stop offset='0' stop-color='%s'/><stop offset='1' stop-color='#14100e'/></linearGradient></defs>" % col
    body += "<rect x='3' y='3' width='94' height='94' rx='20' fill='url(#t)' stroke='#d9b36a' stroke-width='4'/>"
    body += "<rect x='9' y='9' width='82' height='82' rx='15' fill='none' stroke='#000' stroke-opacity='.35' stroke-width='2'/>"
    body += "<g transform='translate(14 14) scale(.72)'>" + DEFS + ICONS[key] + "</g>"
    svg_png(body, size, "cat_%s.png" % key)

RES = {
 "Fer": "<path d='M14 62 L30 34 H78 L90 62 Z' fill='url(#steel)' %s/><path d='M30 34 H78 L72 44 H36Z' fill='#fff' opacity='.45'/><path d='M14 62 H90 L84 80 H20Z' fill='#4a5160' %s/>" % (ST,ST),
 "Bois": "<rect x='14' y='30' width='72' height='40' rx='10' fill='url(#wood)' %s/><ellipse cx='84' cy='50' rx='10' ry='20' fill='#e1b26f' %s/><ellipse cx='84' cy='50' rx='5' ry='10' fill='none' stroke='#8a5a2a' stroke-width='3'/><path d='M24 40 H70 M24 52 H62' stroke='#3b2210' stroke-width='3' opacity='.5'/>" % (ST,ST),
 "Cuir": "<path d='M20 24 Q50 14 80 24 L90 50 L76 56 L78 84 Q50 92 22 84 L24 56 L10 50 Z' fill='url(#leather)' %s/><path d='M28 40 Q50 34 72 40' stroke='#3b2210' stroke-width='3' fill='none' opacity='.6'/>" % ST,
 "Magie": "<path d='M50 6 L72 40 L50 92 L28 40 Z' fill='#a98bff' %s/><path d='M50 6 L72 40 L50 40Z' fill='#fff' opacity='.5'/><path d='M50 40 L72 40 L50 92Z' fill='#000' opacity='.2'/>" % ST,
 "Venin": "<path d='M40 8 H60 V30 L82 70 Q88 90 66 90 H34 Q12 90 18 70 L40 30 Z' fill='#bfe9ff' fill-opacity='.55' %s/><path d='M24 66 Q50 56 76 66 L80 76 Q82 88 66 88 H34 Q18 88 20 76Z' fill='#6fd84a'/><circle cx='42' cy='72' r='4' fill='#d6ffb8'/><rect x='38' y='4' width='24' height='10' rx='3' fill='url(#wood)' %s/>" % (ST,ST),
}
def res(key, size=64):
    svg_png(DEFS + RES[key], size, "res_%s.png" % key)

def emblem(size=256):
    body = DEFS + """<circle cx='50' cy='50' r='46' fill='#2a2230' stroke='#d9b36a' stroke-width='4'/><circle cx='50' cy='50' r='38' fill='#3a2c34'/>
<ellipse cx='50' cy='46' rx='26' ry='16' fill='#ff9a2a' opacity='.55'/>
<path d='M20 46 H72 Q80 46 84 40 L90 40 Q88 52 72 55 H66 L62 63 H70 V74 H30 V63 H36 L32 55 H28 Q20 54 20 46 Z' fill='url(#steel)' stroke='#1c1410' stroke-width='3' stroke-linejoin='round'/>
<g transform='rotate(-38 66 30)'><rect x='62' y='10' width='6' height='34' rx='2' fill='url(#wood)' stroke='#2b1608' stroke-width='2.5'/><rect x='52' y='5' width='24' height='13' rx='3' fill='url(#steel)' stroke='#1c1410' stroke-width='2.5'/></g>
<g fill='#ffd06a'><circle cx='38' cy='34' r='2'/><circle cx='46' cy='28' r='1.6'/><circle cx='32' cy='40' r='1.4'/><circle cx='54' cy='34' r='1.4'/></g>"""
    svg_png(body, size, "emblem.png")

def background(w=1920, h=1080):
    rng = np.random.default_rng(7)
    img = np.zeros((h, w, 3), np.float32)
    bh, bw = 54, 120
    for row in range(h // bh + 1):
        off = (bw // 2) if row % 2 else 0
        for col in range(-1, w // bw + 2):
            x0 = col * bw + off; y0 = row * bh
            tone = rng.uniform(0.75, 1.15)
            c = np.array([0.20, 0.17, 0.17]) * tone
            x1, y1 = min(w, x0 + bw - 4), min(h, y0 + bh - 4)
            if x1 > max(0, x0) and y1 > y0:
                img[y0:y1, max(0, x0):x1] = c
    img += rng.normal(0, 0.02, img.shape)
    yy, xx = np.mgrid[0:h, 0:w].astype(np.float32)
    # lueur de braise en bas au centre + vignette
    d = np.sqrt(((xx - w * 0.5) / (w * 0.6)) ** 2 + ((yy - h * 1.05) / (h * 0.7)) ** 2)
    glow = np.clip(1.0 - d, 0, 1) ** 1.6
    img[:, :, 0] += glow * 0.55; img[:, :, 1] += glow * 0.22; img[:, :, 2] += glow * 0.04
    v = np.sqrt(((xx - w / 2) / (w * 0.75)) ** 2 + ((yy - h / 2) / (h * 0.8)) ** 2)
    img *= np.clip(1.15 - v * 0.9, 0.18, 1)[:, :, None]
    img *= 0.62
    im = Image.fromarray(np.clip(img * 255, 0, 255).astype(np.uint8)).filter(ImageFilter.GaussianBlur(0.8))
    im.save(os.path.join(OUT, "bg.jpg"), quality=88)

if __name__ == "__main__":
    for k in ICONS:
        tile(k)
    for k in RES:
        res(k)
    emblem()
    background()
    print(sorted(os.listdir(OUT)))
