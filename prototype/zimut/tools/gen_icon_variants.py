#!/usr/bin/env python3
"""Icônes distinctes au sein d'une classe (V63).

Plusieurs sorts d'une même classe partageaient la même icône : impossible de les distinguer dans la
colonne de sorts du combat (qui n'affiche que les icônes). Ce script donne à chaque sort d'une classe
une icône unique : le premier sort (par niveau de déblocage) garde l'icône de base, les suivants
reçoivent une variante <base>_v2, <base>_v3… : teinte du fond décalée, motif retourné et pastille
à 2 ou 3 barres dans le coin. Met à jour data/spell_icons.txt.
Usage : python3 tools/gen_icon_variants.py   (idempotent ; à relancer après l'ajout de sorts)"""
import csv, collections, colorsys, os, re
from PIL import Image, ImageDraw

ICON_DIR = "assets/icons/spells"
ICONS_TXT = "data/spell_icons.txt"
SPELLS_TXT = "data/sorts.txt"
HUE_STEP = 0.30


def shift_hex(h, dh):
    r, g, b = (int(h[i:i + 2], 16) / 255 for i in (1, 3, 5))
    hh, s, v = colorsys.rgb_to_hsv(r, g, b)
    if s < 0.12:            # gris : on lui donne un peu de couleur
        s = 0.35
    r, g, b = colorsys.hsv_to_rgb((hh + dh) % 1.0, s, v)
    return "#%02x%02x%02x" % (round(r * 255), round(g * 255), round(b * 255))


def badge_svg(k):
    bars = "".join('<rect x="%.1f" y="45" width="2.6" height="9" rx="1" fill="#ffffff"/>' % (49.0 + (i - (k - 1) / 2) * 4.2) for i in range(k))
    return '<circle cx="50" cy="49.5" r="9" fill="#1a1020" stroke="#ffe890" stroke-width="1.4"/>' + bars


def make_svg(base, out, k):
    s = open(base, encoding="utf-8").read()
    dh = HUE_STEP * (k - 1)
    m = re.search(r'(<linearGradient id="bg"[^>]*>)(.*?)(</linearGradient>)', s, re.S)
    if m:
        stops = re.sub(r'stop-color="(#[0-9a-fA-F]{6})"', lambda mm: 'stop-color="%s"' % shift_hex(mm.group(1), dh), m.group(2))
        s = s[:m.start(2)] + stops + s[m.end(2):]
    if k == 2:
        s = s.replace('transform="translate(32,32)', 'transform="translate(32,32) scale(-1,1)', 1)
    s = s.replace("</svg>", badge_svg(k) + "</svg>")
    open(out, "w", encoding="utf-8").write(s)


def make_png(base, out, k):
    im = Image.open(base).convert("RGBA")
    dh = HUE_STEP * (k - 1)
    px = im.load()
    for y in range(im.height):
        for x in range(im.width):
            r, g, b, a = px[x, y]
            hh, s, v = colorsys.rgb_to_hsv(r / 255, g / 255, b / 255)
            r2, g2, b2 = colorsys.hsv_to_rgb((hh + dh) % 1.0, s, v)
            px[x, y] = (round(r2 * 255), round(g2 * 255), round(b2 * 255), a)
    if k == 2:
        im = im.transpose(Image.FLIP_LEFT_RIGHT)
    sc = im.width / 64.0
    d = ImageDraw.Draw(im)
    d.ellipse([(41 * sc), (40.5 * sc), (59 * sc), (58.5 * sc)], fill=(26, 16, 32, 255), outline=(255, 232, 144, 255), width=max(1, round(1.4 * sc)))
    for i in range(k):
        x = (49.0 + (i - (k - 1) / 2) * 4.2) * sc
        d.rounded_rectangle([x, 45 * sc, x + 2.6 * sc, 54 * sc], radius=sc, fill=(255, 255, 255, 255))
    im.save(out)


def main():
    lines = open(ICONS_TXT, encoding="utf-8").read().split("\n")
    icons = {}
    for l in lines[1:]:
        if "," in l:
            n, i = l.rsplit(",", 1)
            icons[n] = re.sub(r"_v\d+$", "", i)      # on repart toujours de l'icône de base
    rows = [r for r in csv.reader(open(SPELLS_TXT, encoding="utf-8"))][1:]
    by = collections.defaultdict(lambda: collections.defaultdict(list))
    for r in rows:
        if len(r) > 6 and r[1] in icons:
            by[r[0]][icons[r[1]]].append((int(r[6] or 1), r[1]))
    new_map = dict(icons)
    made = 0
    for classe, groups in by.items():
        for base, spells in groups.items():
            spells.sort()
            for k, (_lvl, name) in enumerate(spells, start=1):
                if k == 1:
                    continue
                vid = "%s_v%d" % (base, k)
                new_map[name] = vid
                for ext, fn in (("svg", make_svg), ("png", make_png)):
                    src = os.path.join(ICON_DIR, "%s.%s" % (base, ext))
                    if os.path.exists(src):
                        fn(src, os.path.join(ICON_DIR, "%s.%s" % (vid, ext)), k)
                        made += 1
    out = [lines[0]]
    for l in lines[1:]:
        if "," in l:
            n = l.rsplit(",", 1)[0]
            out.append("%s,%s" % (n, new_map.get(n, l.rsplit(",", 1)[1])))
        else:
            out.append(l)
    open(ICONS_TXT, "w", encoding="utf-8").write("\n".join(out))
    print("variantes écrites :", made)


if __name__ == "__main__":
    main()
