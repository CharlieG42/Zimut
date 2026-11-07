#!/usr/bin/env python3
"""Prévisualisation (PIL) de la planche iso « test » de la Sylve (V114).

Approximation fidèle de la composition : sol en losanges avec hauteurs, falaises,
sentier, rivage, eau autour de l'île, bâtiments (sprites Kenney quand ils existent,
formes simples pour puits/feu/étal), décors sprites, POI, héros.
Hors moteur Godot — contrôle de composition uniquement.

Usage : python3 tools/preview_sylve_iso.py [foret_sylve_iso] [dossier_sortie]
"""
import json
import math
import random
import re
import sys
from pathlib import Path

from PIL import Image, ImageDraw

ROOT = Path(__file__).resolve().parent.parent
REPO = ROOT.parent.parent
BOARDS = ROOT / "data" / "boards"
DECOR_DIR = ROOT / "assets" / "sprites" / "decor" / "sylve"
KENNEY_DIR = ROOT / "assets" / "sprites" / "decor" / "kenney" / "batiments"
OUT = Path(sys.argv[2]) if len(sys.argv) > 2 else REPO / "Examples" / "sylve_iso_preview"

ISO_TW, ISO_TH, ISO_LEVEL_PX = 128.0, 64.0, 64.0
POI_COLOR = {"combat": (255, 107, 92), "chest": (255, 209, 89), "puzzle": (184, 148, 255),
             "camp": (255, 158, 77), "reveal": (115, 217, 255), "exit": (140, 255, 140)}
KENNEY_KINDS = {"maison": ["maison_bois", "maison_pierre"], "chaumiere": ["chaumiere"], "grange": ["grange"],
                "moulin": ["moulin"], "tour": ["tour"], "chapelle": ["chapelle"]}


def load_json_table():
    return json.loads((ROOT / "data" / "batiments_kenney.json").read_text(encoding="utf-8"))


def load_sprites_table() -> dict:
    src = (ROOT / "scripts" / "SpriteDecor.gd").read_text(encoding="utf-8")
    m = re.search(r"const SPRITES := \{(.*?)\n\}", src, re.S)
    table = {}
    for km in re.finditer(r'"(\w+)": \[\[(.*?)\]\]', m.group(1)):
        table[km.group(1)] = [(vm.group(1), float(vm.group(2)))
                              for vm in re.finditer(r'\["(\w+)",\s*([\d.]+)\]', km.group(2))]
    return table


def main() -> None:
    name = sys.argv[1] if len(sys.argv) > 1 else "foret_sylve_iso"
    d = json.loads((BOARDS / (name + ".json")).read_text(encoding="utf-8"))
    cols, rows = int(d["cols"]), int(d["rows"])
    cs = float(d["cell_scale"])
    unit = int(d["unit"])
    hw, hh = ISO_TW * cs * 0.5, ISO_TH * cs * 0.5
    up = ISO_LEVEL_PX / unit
    hs = {}
    for y, row in enumerate(d["heights"]):
        for x, ch in enumerate(row):
            hs[(x, y)] = ord(ch) - 48 if ord(ch) < 97 else 10 + ord(ch) - 97
    max_h = max(hs.values())
    ox, oy = rows * ISO_TW * cs * 0.5 + 100.0, 220.0 + max_h * up
    span = cols + rows
    W, H = int(span * ISO_TW * cs * 0.5 + 200.0), int(span * ISO_TH * cs * 0.5 + oy + 330.0)
    img = Image.new("RGBA", (W, H), (110, 150, 190, 255))
    dr = ImageDraw.Draw(img)

    def pos(c):
        h = hs.get(c, 0) * up
        return (ox + (c[0] - c[1]) * hw, oy + (c[0] + c[1]) * hh - h)

    mask = d["mask"]
    def walkable(c):
        return 0 <= c[1] < rows and 0 <= c[0] < len(mask[c[1]]) and mask[c[1]][c[0]] == "#"

    # eau + ombre
    bot = (ox + (cols - rows) * hw * 0.5, oy + (cols + rows) * hh * 0.5)
    wr = span * hw * 0.62
    dr.ellipse([bot[0] - wr, bot[1] + 170 - wr * 0.24, bot[0] + wr, bot[1] + 170 + wr * 0.24], fill=(23, 61, 82, 255))
    dr.ellipse([bot[0] - wr * 0.94, bot[1] + 170 - wr * 0.94 * 0.24, bot[0] + wr * 0.94, bot[1] + 170 + wr * 0.94 * 0.24], fill=(38, 97, 115, 255))
    dr.ellipse([bot[0] - wr * 0.5, bot[1] + 250 - wr * 0.11, bot[0] + wr * 0.5, bot[1] + 250 + wr * 0.11], fill=(8, 15, 26, 40))

    trail = {tuple(int(v) for v in k.split(",")) for k in d.get("trail", [])}
    grass = (84, 140, 64)
    # sol + falaises (ordre des sommes)
    for s in range(cols + rows - 1):
        for x in range(max(0, s - rows + 1), min(cols, s + 1)):
            y = s - x
            c = (x, y)
            if not walkable(c):
                continue
            ctr = pos(c)
            h = hs.get(c, 0)
            for side, n in [(0, (x, y + 1)), (1, (x + 1, y))]:
                nh = hs.get(n, -99) if walkable(n) else -99
                drop = (2.6 * ISO_LEVEL_PX if nh == -99 else (h - nh) * up)
                if drop <= 0.5:
                    continue
                a = (ctr[0] - hw, ctr[1]) if side == 0 else (ctr[0], ctr[1] + hh)
                b = (ctr[0], ctr[1] + hh) if side == 0 else (ctr[0] + hw, ctr[1])
                dr.polygon([a, b, (b[0], b[1] + drop), (a[0], a[1] + drop)], fill=(110, 90, 70) if side == 0 else (90, 72, 58))
            top = tuple(min(255, int(v * (1 + h * 0.045 / unit))) for v in grass)
            if c in trail:
                top = (204, 171, 115)
            if h <= unit and any(not walkable((c[0] + dx, c[1] + dy)) for dx, dy in [(1, 0), (-1, 0), (0, 1), (0, -1)]) and c not in trail:
                top = tuple(int(a * 0.55 + b * 0.45) for a, b in zip(top, (184, 158, 102)))
            dr.polygon([(ctr[0], ctr[1] - hh), (ctr[0] + hw, ctr[1]), (ctr[0], ctr[1] + hh), (ctr[0] - hw, ctr[1])], fill=top)

    sprites = load_sprites_table()
    ktable = load_json_table()
    rng = random.Random(7)
    # décors
    for k, kind in d.get("decor", {}).items():
        c = tuple(int(v) for v in k.split(","))
        if not walkable(c):
            continue
        variants = sprites.get(kind, [])
        if not variants:
            continue
        nm, w = variants[rng.randrange(len(variants))]
        tex = Image.open(DECOR_DIR / (nm + ".png")).convert("RGBA")
        w = w * 0.7
        hpx = w * tex.height / tex.width
        ctr = pos(c)
        sprite = tex.resize((max(1, int(w)), max(1, int(hpx))), Image.LANCZOS)
        shade = max(0.0, 1.0 - hs.get(c, 0) / 12.0) * 0.22
        if shade > 0:
            sprite = Image.blend(sprite, Image.new("RGBA", sprite.size, (0, 0, 0, 255)), shade)
        img.alpha_composite(sprite, (int(ctr[0] - w / 2), int(ctr[1] + 6 - hpx)))
    # obstacles (arbres)
    for k, kind in d.get("obstacles", {}).items():
        if kind == "building":
            continue
        c = tuple(int(v) for v in k.split(","))
        variants = sprites.get(kind, [])
        if not variants:
            continue
        nm, w = variants[rng.randrange(len(variants))]
        tex = Image.open(DECOR_DIR / (nm + ".png")).convert("RGBA")
        w = w * 0.8
        hpx = w * tex.height / tex.width
        ctr = pos(c)
        sprite = tex.resize((max(1, int(w)), max(1, int(hpx))), Image.LANCZOS)
        img.alpha_composite(sprite, (int(ctr[0] - w / 2), int(ctr[1] + 6 - hpx)))
    # bâtiments
    for b in d.get("buildings", []):
        c = (int(b["x"]) + int(b["w"]) - 1, int(b["y"]) + int(b["h"]) - 1)
        p = pos(c)
        p = (p[0], p[1] + ISO_TH * cs * 0.5)
        kind = b["k"]
        if kind in KENNEY_KINDS and KENNEY_KINDS[kind][0] in ktable:
            nm = KENNEY_KINDS[kind][0]
            tex = Image.open(KENNEY_DIR / (nm + ".png")).convert("RGBA")
            m = ktable[nm]
            sc = (int(b["w"]) + int(b["h"])) * hw / float(m["ref"])
            sprite = tex.resize((int(tex.width * sc), int(tex.height * sc)), Image.LANCZOS)
            img.alpha_composite(sprite, (int(p[0] - float(m["ax"]) * sc), int(p[1] - float(m["ay"]) * sc)))
        else:
            col = {"puits": (140, 140, 148), "feu": (255, 140, 40), "etal": (216, 76, 64)}.get(kind, (150, 120, 90))
            wpx = (int(b["w"]) + int(b["h"])) * hw * 0.8
            dr.ellipse([p[0] - wpx * 0.4, p[1] - 10, p[0] + wpx * 0.4, p[1] + 10], fill=col)
            if kind == "feu":
                dr.polygon([(p[0] - 8, p[1]), (p[0], p[1] - 30), (p[0] + 8, p[1])], fill=(255, 200, 60))
    # POI
    for k, p in d.get("pois", {}).items():
        c = tuple(int(v) for v in k.split(","))
        ctr = pos(c)
        col = POI_COLOR.get(str(p.get("kind", "combat")), (255, 255, 255))
        if str(p.get("guardian", "")) != "":
            col = (184, 92, 255)
        dr.ellipse([ctr[0] - 24, ctr[1] - 104, ctr[0] + 24, ctr[1] - 56], outline=col, width=5, fill=(20, 24, 30, 220))
    # héros au départ
    start = tuple(int(v) for v in d["start"])
    ctr = pos(start)
    tex = Image.open(ROOT / "assets" / "sprites" / "players" / "chasseur.png").convert("RGBA")
    hpx = 118 * 0.72
    wpx = hpx * tex.width / tex.height
    dr.ellipse([ctr[0] - 30, ctr[1] - 6, ctr[0] + 30, ctr[1] + 10], fill=(0, 0, 0, 70))
    sprite = tex.resize((int(wpx), int(hpx)), Image.LANCZOS)
    img.alpha_composite(sprite, (int(ctr[0] - wpx / 2), int(ctr[1] + 4 - hpx)))

    OUT.mkdir(parents=True, exist_ok=True)
    img.convert("RGB").resize((W // 4, H // 4), Image.LANCZOS).save(OUT / "iso_complete.png")
    # zoom village (cases 40-70, 20-50)
    box = (int(pos((40, 50))[0] - 500), int(pos((55, 30))[1] - 350), int(pos((70, 20))[0] + 300), int(pos((70, 50))[1] + 250))
    img.crop(box).resize(((box[2] - box[0]) // 2, (box[3] - box[1]) // 2), Image.LANCZOS).save(OUT / "iso_village.png")
    # zoom départ + puits
    s = pos(start)
    img.crop((int(s[0] - 420), int(s[1] - 320), int(s[0] + 420), int(s[1] + 220))).save(OUT / "iso_depart.png")
    print("prévisualisations iso dans", OUT)


if __name__ == "__main__":
    main()
