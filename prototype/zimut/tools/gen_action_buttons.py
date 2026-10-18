#!/usr/bin/env python3
"""gen_action_buttons.py — Boutons illustrés « Forge » et « Gouverneurs » (assets/ui/actions/).

Part des plaques existantes (Loots = plaque brune, Équiper auto = plaque violette) : efface le texte
(inpainting), remplace l'icône de gauche par un dessin vectoriel (enclume / couronne) et réécrit le
libellé. Usage : python3 tools/gen_action_buttons.py
"""
import io, os
import cairosvg
import cv2
import numpy as np
from PIL import Image, ImageDraw, ImageFont

HERE = os.path.dirname(os.path.abspath(__file__))
DIR = os.path.join(HERE, "..", "assets", "ui", "actions")
FONT = "/usr/share/fonts/truetype/google-fonts/Poppins-Bold.ttf"
PLAQUE_X0 = 196          # début de la zone de texte sur la plaque

ANVIL = """<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 160 160'>
<defs><linearGradient id='m' x1='0' y1='0' x2='0' y2='1'><stop offset='0' stop-color='#9aa3b2'/><stop offset='1' stop-color='#4a5160'/></linearGradient>
<linearGradient id='h' x1='0' y1='0' x2='1' y2='1'><stop offset='0' stop-color='#b5733a'/><stop offset='1' stop-color='#6b3f1d'/></linearGradient>
<radialGradient id='g' cx='.5' cy='.5' r='.5'><stop offset='0' stop-color='#ffd06a' stop-opacity='.95'/><stop offset='1' stop-color='#ff7a1a' stop-opacity='0'/></radialGradient></defs>
<circle cx='80' cy='78' r='70' fill='#2c3140' stroke='#d9b36a' stroke-width='6'/>
<circle cx='80' cy='78' r='58' fill='#3a4152'/>
<ellipse cx='80' cy='70' rx='40' ry='26' fill='url(#g)'/>
<path d='M30 74 H118 Q128 74 134 66 L142 66 Q140 84 118 88 H108 L102 100 H112 V114 H48 V100 H58 L52 88 H44 Q30 86 30 74 Z' fill='url(#m)' stroke='#1c2029' stroke-width='4' stroke-linejoin='round'/>
<path d='M36 76 H116' stroke='#d7dce6' stroke-width='3' stroke-linecap='round' opacity='.7'/>
<g transform='rotate(-38 110 46)'><rect x='103' y='16' width='9' height='54' rx='3' fill='url(#h)' stroke='#2b1608' stroke-width='3'/>
<rect x='88' y='8' width='38' height='20' rx='4' fill='url(#m)' stroke='#1c2029' stroke-width='3'/></g>
<g fill='#ffd06a'><circle cx='62' cy='56' r='3'/><circle cx='74' cy='48' r='2.2'/><circle cx='52' cy='64' r='2'/><circle cx='86' cy='56' r='2'/></g>
</svg>"""

CROWN = """<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 160 160'>
<defs><linearGradient id='c' x1='0' y1='0' x2='0' y2='1'><stop offset='0' stop-color='#ffe08a'/><stop offset='1' stop-color='#c98a1e'/></linearGradient></defs>
<circle cx='80' cy='80' r='70' fill='#3a2f63' stroke='#d9b36a' stroke-width='6'/>
<circle cx='80' cy='80' r='58' fill='#4a3d7c'/>
<path d='M34 108 L26 56 L56 78 L80 40 L104 78 L134 56 L126 108 Z' fill='url(#c)' stroke='#5a3a08' stroke-width='5' stroke-linejoin='round'/>
<rect x='34' y='108' width='92' height='14' rx='4' fill='#e0a838' stroke='#5a3a08' stroke-width='5'/>
<circle cx='26' cy='54' r='7' fill='#ff6b6b' stroke='#5a3a08' stroke-width='3'/><circle cx='80' cy='38' r='8' fill='#6bd0ff' stroke='#5a3a08' stroke-width='3'/><circle cx='134' cy='54' r='7' fill='#7dff9b' stroke='#5a3a08' stroke-width='3'/>
<circle cx='80' cy='92' r='7' fill='#ff6b6b' stroke='#5a3a08' stroke-width='3'/>
</svg>"""


def render(svg, size):
    png = cairosvg.svg2png(bytestring=svg.encode(), output_width=size, output_height=size)
    return Image.open(io.BytesIO(png)).convert("RGBA")


def make(src, svg, label, out):
    im = Image.open(os.path.join(DIR, src)).convert("RGBA")
    a = np.array(im)
    # 1) efface le texte de la plaque (pixels très clairs dans la zone de texte)
    rgb = a[:, :, :3].astype(np.int32)
    light = (rgb.min(axis=2) > 205) & (a[:, :, 3] > 200)
    zone = np.zeros_like(light)
    zone[50:150, PLAQUE_X0:495] = True
    mask = (light & zone).astype(np.uint8) * 255
    mask = cv2.dilate(mask, np.ones((5, 5), np.uint8), iterations=2)
    bgr = cv2.cvtColor(a[:, :, :3], cv2.COLOR_RGB2BGR)
    bgr = cv2.inpaint(bgr, mask, 5, cv2.INPAINT_TELEA)
    a[:, :, :3] = cv2.cvtColor(bgr, cv2.COLOR_BGR2RGB)
    im = Image.fromarray(a, "RGBA")
    # 2) efface l'ancienne icône (partie gauche) : transparent à gauche de la plaque
    px = np.array(im)
    px[:, :PLAQUE_X0 - 28, :] = 0
    # fondu du bord gauche de la plaque
    for x in range(PLAQUE_X0 - 28, PLAQUE_X0):
        px[:, x, 3] = (px[:, x, 3] * ((x - (PLAQUE_X0 - 28)) / 28.0)).astype(np.uint8)
    im = Image.fromarray(px, "RGBA")
    # 3) nouvelle icône
    icon = render(svg, 170)
    im.alpha_composite(icon, (10, 11))
    # 4) libellé : crème, contour brun foncé
    d = ImageDraw.Draw(im)
    size = 54
    font = ImageFont.truetype(FONT, size)
    while d.textlength(label, font=font) > 285 and size > 24:
        size -= 2
        font = ImageFont.truetype(FONT, size)
    cx = (PLAQUE_X0 + 20 + 495) // 2
    d.text((cx, 98), label, font=font, fill=(255, 245, 222, 255), anchor="mm",
           stroke_width=5, stroke_fill=(52, 34, 20, 255))
    im.save(os.path.join(DIR, out))
    print(out, im.size)


def erase_text(im, x0=190):
    """Efface le libellé de la plaque (pixels très clairs) par inpainting."""
    a = np.array(im.convert("RGBA"))
    rgb = a[:, :, :3].astype(np.int32)
    light = (rgb.min(axis=2) > 190) & (a[:, :, 3] > 200)
    zone = np.zeros_like(light)
    zone[40:160, x0:500] = True
    mask = (light & zone).astype(np.uint8) * 255
    mask = cv2.dilate(mask, np.ones((5, 5), np.uint8), iterations=2)
    bgr = cv2.cvtColor(a[:, :, :3], cv2.COLOR_RGB2BGR)
    bgr = cv2.inpaint(bgr, mask, 6, cv2.INPAINT_TELEA)
    a[:, :, :3] = cv2.cvtColor(bgr, cv2.COLOR_BGR2RGB)
    return Image.fromarray(a, "RGBA")


def make_plain(src, out, svg=None):
    """Version SANS texte (le libellé est écrit par Godot, donc traduisible)."""
    im = Image.open(os.path.join(DIR, src)).convert("RGBA")
    if svg is not None:      # Forge / Gouverneurs : nouvelle icône à gauche
        px = np.array(erase_text(im, PLAQUE_X0))
        px[:, :PLAQUE_X0 - 28, :] = 0
        for x in range(PLAQUE_X0 - 28, PLAQUE_X0):
            px[:, x, 3] = (px[:, x, 3] * ((x - (PLAQUE_X0 - 28)) / 28.0)).astype(np.uint8)
        im = Image.fromarray(px, "RGBA")
        im.alpha_composite(render(svg, 170), (10, 11))
    else:
        im = erase_text(im)
    im.save(os.path.join(DIR, out))
    print(out, im.size)


if __name__ == "__main__":
    make("action_inventory.png", ANVIL, "Forge", "action_forge.png")
    make("action_autoequip.png", CROWN, "Gouverneurs", "action_governors.png")
    # V20 : plaques sans texte pour les libellés traduisibles
    make_plain("action_inventory.png", "plain_forge.png", ANVIL)
    make_plain("action_autoequip.png", "plain_governors.png", CROWN)
    for k in ("team", "chars", "rename", "delete"):
        make_plain("action_%s.png" % k, "plain_%s.png" % k)
