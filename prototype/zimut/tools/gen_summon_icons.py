#!/usr/bin/env python3
"""gen_summon_icons.py — Icônes des sorts « Invoquer X » : portrait de la créature dans une
pastille violette (rendu à partir des skins SVG/PNG de assets/sprites/summons)."""
import os, csv, sys, unicodedata
import cairosvg
from PIL import Image, ImageDraw, ImageFilter
HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.join(HERE, "..")
SPR = os.path.join(ROOT, "assets", "sprites", "summons")
OUT = os.path.join(ROOT, "assets", "icons", "spells")

def norm(s):
    s = unicodedata.normalize("NFD", s.lower())
    return "".join(c for c in s if unicodedata.category(c) != "Mn")

def sprite_img(key):
    for ext in ("png", "svg"):
        p = os.path.join(SPR, f"{key}.{ext}")
        if os.path.exists(p):
            if ext == "svg":
                cairosvg.svg2png(url=p, write_to="/tmp/_sm.png", output_height=256)
                return Image.open("/tmp/_sm.png").convert("RGBA")
            return Image.open(p).convert("RGBA")
    return None

def badge(head):
    S = 128
    img = Image.new("RGBA", (S, S), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    d.rounded_rectangle((4, 4, S - 4, S - 4), 28, fill=(26, 16, 32, 255))
    # dégradé violet
    grad = Image.new("RGBA", (S - 16, S - 16))
    gd = ImageDraw.Draw(grad)
    for y in range(S - 16):
        t = y / (S - 17)
        gd.line((0, y, S, y), fill=(int(106 + (36 - 106) * t), int(74 + (24 - 74) * t), int(154 + (72 - 154) * t), 255))
    mask = Image.new("L", (S - 16, S - 16), 0)
    ImageDraw.Draw(mask).rounded_rectangle((0, 0, S - 17, S - 17), 24, fill=255)
    img.paste(grad, (8, 8), mask)
    d.rounded_rectangle((9, 9, S - 9, S - 9), 23, outline=(216, 192, 255, 200), width=3)
    if head is not None:
        bb = head.getbbox()
        if bb:
            head = head.crop(bb)
        w, h = head.size
        # on garde la moitié haute du sprite (tête et buste), carrée
        side = min(w, int(h * 0.72)) if h > w * 0.9 else min(w, h)
        left = (w - side) if w > h * 1.05 else (w - side) // 2   # sprites larges : la tête est à droite
        top = head.crop((max(0, left), 0, max(0, left) + side, side))
        top = top.resize((92, 92), Image.LANCZOS)
        sh = Image.new("RGBA", (S, S), (0, 0, 0, 0))
        sh.paste(top, (18, 20), top)
        shadow = sh.filter(ImageFilter.GaussianBlur(3))
        a = shadow.split()[3].point(lambda v: int(v * 0.45))
        dark = Image.new("RGBA", (S, S), (0, 0, 0, 255))
        img.paste(dark, (0, 2), a)
        img.alpha_composite(sh)
    # petite étoile « invocation »
    d.polygon([(100, 14), (104, 26), (116, 28), (106, 36), (110, 48), (100, 41), (90, 48), (94, 36), (84, 28), (96, 26)], fill=(255, 210, 74, 255), outline=(26, 16, 32, 255))
    return img.resize((64, 64), Image.LANCZOS)

def main():
    os.makedirs(OUT, exist_ok=True)
    n = 0
    with open(os.path.join(ROOT, "data", "spell_icons.txt"), encoding="utf-8") as f:
        for r in csv.reader(f):
            if len(r) == 2 and r[1].startswith("summon_") and r[1] not in ("summon_arbre",) and r[0].startswith("Invoquer"):
                key = r[1][len("summon_"):]
                img = badge(sprite_img(key))
                img.save(os.path.join(OUT, r[1] + ".png"))
                n += 1
    print(n, "icônes d'invocation")

if __name__ == "__main__":
    main()
