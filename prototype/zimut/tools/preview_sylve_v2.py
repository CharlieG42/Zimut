#!/usr/bin/env python3
"""Prévisualisation (PIL) de la planche Sylve « v2 enrichie » (V114).

Compose la vraie illustration + les vrais sprites de décor (assets/sprites/decor/sylve/)
+ le héros + les médaillons de POI, en respectant l'échelle monde du jeu
(cell_px × IMAGE_SCALE = 32 px, pied du sprite à +22×sc sous le centre de case).
Ce n'est PAS le rendu Godot (les props vectoriels et icônes SVG y sont esquissés),
c'est un contrôle de composition : placement des décors, occlusion du héros, lisibilité.

Usage : python3 tools/preview_sylve_v2.py [foret_sylve_v2] [dossier_sortie]
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
OUT = Path(sys.argv[2]) if len(sys.argv) > 2 else REPO / "Examples" / "sylve_v2_decor_preview"

IMAGE_SCALE = 2.0
CELL_PX = 16
CW = CELL_PX * IMAGE_SCALE          # 32 px monde par case
DECOR_SC = 0.7                       # échelle des petits décors (cf. _add_decor v2)
OVER_SC = 1.05                       # échelle des arbres de premier plan

POI_COLOR = {
    "combat": (255, 107, 92), "chest": (255, 209, 89), "puzzle": (184, 148, 255),
    "camp": (255, 158, 77), "reveal": (115, 217, 255), "exit": (140, 255, 140),
}
DUNGEON_COLOR = (184, 92, 255)
MEDAL_SIDES = {"combat": 6, "chest": 4, "puzzle": 4, "reveal": 8, "camp": 0}


def load_sprites_table() -> dict:
    """kind -> [(fichier, largeur monde px)] lu directement dans SpriteDecor.gd."""
    src = (ROOT / "scripts" / "SpriteDecor.gd").read_text(encoding="utf-8")
    m = re.search(r"const SPRITES := \{(.*?)\n\}", src, re.S)
    table = {}
    for km in re.finditer(r'"(\w+)": \[\[(.*?)\]\]', m.group(1)):
        kind, body = km.group(1), km.group(2)
        variants = []
        for vm in re.finditer(r'\["(\w+)",\s*([\d.]+)\]', body):
            variants.append((vm.group(1), float(vm.group(2))))
        table[kind] = variants
    return table


def cell_center(c):
    return ((c[0] + 0.5) * CW, (c[1] + 0.5) * CW)


def paste_decor(base: Image.Image, sprites: dict, kind: str, c, sc: float, rng: random.Random) -> None:
    variants = sprites.get(kind)
    if not variants:
        return
    name, w = variants[rng.randrange(len(variants))]
    tex = Image.open(DECOR_DIR / (name + ".png")).convert("RGBA")
    w = w * rng.uniform(0.94, 1.06) * sc
    h = w * tex.height / tex.width
    cx, cy = cell_center(c)
    foot_y = cy + 22.0 * sc
    # ombre douce (BattleScenery.soft_shadow)
    sh = Image.new("RGBA", base.size, (0, 0, 0, 0))
    ImageDraw.Draw(sh).ellipse([cx - w * 0.30, foot_y - 5 * sc, cx + w * 0.30, foot_y + 3 * sc],
                               fill=(8, 20, 12, 60))
    base.alpha_composite(sh)
    sprite = tex.resize((max(1, int(w)), max(1, int(h))), Image.LANCZOS)
    if rng.random() < 0.5:
        sprite = sprite.transpose(Image.FLIP_LEFT_RIGHT)
    base.alpha_composite(sprite, (int(cx - w / 2), int(foot_y - h)))


def draw_poi(dr: ImageDraw.ImageDraw, c, kind: str, is_dungeon: bool) -> None:
    cx, cy = cell_center(c)
    r = 34.0 if is_dungeon else 26.0
    top = cy - (100.0 if is_dungeon else 80.0)
    col = DUNGEON_COLOR if is_dungeon else POI_COLOR.get(kind, (255, 255, 255))
    # assise au sol
    dr.ellipse([cx - 40, cy - 4, cx + 40, cy + 16], fill=(4, 6, 9, 46))
    dr.ellipse([cx - r, top - r, cx + r, top + r], outline=col + (255,), width=5, fill=(20, 24, 30, 220))
    sides = MEDAL_SIDES.get(kind, 0)
    if sides >= 3:
        pts = []
        rot = math.pi / 6 if kind == "combat" else (math.pi / 4 if sides == 4 else math.pi / 8)
        for i in range(sides):
            a = rot + 2 * math.pi * i / sides
            pts.append((cx + math.cos(a) * r * 0.62, top + math.sin(a) * r * 0.62))
        dr.polygon(pts, fill=col + (255,))
    else:
        dr.ellipse([cx - r * 0.62, top - r * 0.62, cx + r * 0.62, top + r * 0.62], fill=col + (255,))


def paste_hero(base: Image.Image, c) -> None:
    tex = Image.open(ROOT / "assets" / "sprites" / "players" / "chasseur.png").convert("RGBA")
    depth = c[1] / 72.0
    factor = 0.94 + (1.18 - 0.94) * depth
    h = 118.0 * factor
    w = h * tex.width / tex.height
    cx, cy = cell_center(c)
    foot_y = cy + 6.0
    sh = Image.new("RGBA", base.size, (0, 0, 0, 0))
    sdr = ImageDraw.Draw(sh)
    sdr.ellipse([cx - 38, foot_y - 8, cx + 38, foot_y + 8], fill=(0, 0, 0, 70))
    sdr.ellipse([cx - 40, foot_y - 10, cx + 40, foot_y + 10], fill=(70, 122, 46, 30))
    base.alpha_composite(sh)
    sprite = tex.resize((max(1, int(w)), max(1, int(h))), Image.LANCZOS)
    base.alpha_composite(sprite, (int(cx - w / 2), int(foot_y - h)))
    dr = ImageDraw.Draw(base)
    dr.ellipse([cx - 40, foot_y - 12, cx + 40, foot_y + 12], outline=(184, 232, 122, 200), width=3)


def main() -> None:
    name = sys.argv[1] if len(sys.argv) > 1 else "foret_sylve_v2"
    d = json.loads((BOARDS / (name + ".json")).read_text(encoding="utf-8"))
    img = Image.open(ROOT / str(d["image"]).replace("res://", "")).convert("RGBA")
    base = img.resize((int(img.width * IMAGE_SCALE), int(img.height * IMAGE_SCALE)), Image.LANCZOS)
    # V114 : couche de détails peints (clé "detail", fond transparent) au-dessus de la planche
    if d.get("detail"):
        det = Image.open(ROOT / str(d["detail"]).replace("res://", "")).convert("RGBA")
        det = det.resize(base.size, Image.LANCZOS)
        base.alpha_composite(det)
    sprites = load_sprites_table()
    decor = {tuple(int(v) for v in k.split(",")): v for k, v in d.get("decor", {}).items()}
    over = {tuple(int(v) for v in k.split(",")): v for k, v in d.get("over", {}).items()}
    pois = {tuple(int(v) for v in k.split(",")): v for k, v in d.get("pois", {}).items()}
    start = tuple(int(v) for v in d["start"])

    # petits décors de sol, triés par profondeur
    for c in sorted(decor, key=lambda c: (c[1], c[0])):
        paste_decor(base, sprites, decor[c], c, DECOR_SC, random.Random(c[0] * 131 + c[1] * 17))

    dr = ImageDraw.Draw(base)
    for c, p in pois.items():
        draw_poi(dr, c, str(p.get("kind", "combat")), str(p.get("guardian", "")) != "")

    paste_hero(base, start)

    # arbres de premier plan dessinés en dernier (occlusion du héros)
    for c in sorted(over, key=lambda c: (c[1], c[0])):
        paste_decor(base, sprites, over[c], c, OVER_SC, random.Random(c[0] * 57 + c[1] * 31))

    # deuxième héros fictif juste au nord d'un arbre "over" pour montrer l'occlusion
    over_cell = max(over, key=lambda c: sum(1 for o in over if abs(o[0] - c[0]) + abs(o[1] - c[1]) <= 2))
    ghost = (over_cell[0], over_cell[1] - 1)
    if (BOARDS / (name + ".json")).exists() and d["mask"][ghost[1]][ghost[0]] == "#":
        paste_hero(base, ghost)
        for c in sorted(over, key=lambda c: (c[1], c[0])):
            if abs(c[0] - over_cell[0]) + abs(c[1] - over_cell[1]) <= 2:
                paste_decor(base, sprites, over[c], c, OVER_SC, random.Random(c[0] * 57 + c[1] * 31))

    OUT.mkdir(parents=True, exist_ok=True)
    full = base.convert("RGB")
    full.resize((full.width // 2, full.height // 2), Image.LANCZOS).save(OUT / "carte_complete.png")

    def crop(center_cell, w=980, h=660, fname="zoom.png"):
        cx, cy = cell_center(center_cell)
        box = (int(cx - w / 2), int(cy - h / 2), int(cx + w / 2), int(cy + h / 2))
        full.crop(box).save(OUT / fname)

    crop(start, fname="zoom_depart.png")
    dun = next(c for c, p in pois.items() if str(p.get("guardian", "")) != "")
    crop(dun, fname="zoom_donjon.png")
    crop(over_cell, fname="zoom_occlusion.png")
    print("prévisualisations dans", OUT)


if __name__ == "__main__":
    main()
