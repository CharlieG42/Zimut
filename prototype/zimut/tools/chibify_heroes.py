#!/usr/bin/env python3
"""chibify_heroes.py — Proportions « Dofus / Waven » pour les héros de la planche.

Les héros extraits de la planche (assets/sprites/nations/heros/<classe>.png) ont des proportions
réalistes (≈ 7 têtes). Ce script écrit assets/sprites/players/<classe>.png avec :
  - une tête agrandie et un corps raccourci (déformation continue, sans couture) ;
  - un corps un peu élargi ;
  - un contour sombre épais, typique du style cartoon.
Étape suivante de tools/extract_sheet_sprites.py. Usage : python3 tools/chibify_heroes.py [classe ...]
"""
import os, sys
import numpy as np
from PIL import Image, ImageFilter
from scipy import ndimage

HERE = os.path.dirname(os.path.abspath(__file__))
SRC = os.path.join(HERE, "..", "assets", "sprites", "nations", "heros")
DST = os.path.join(HERE, "..", "assets", "sprites", "players")

# chin : fraction de la hauteur où finit la tête ; ramp : fraction de transition cou/épaules.
# head_s : agrandissement de la tête ; body_v : écrasement vertical du corps ; body_h : élargissement.
DEFAULT = {"chin": 0.19, "ramp": 0.07, "head_s": 1.55, "body_v": 0.60, "body_h": 1.12}
PARAMS = {
    "tank":       {"chin": 0.20, "head_s": 1.45, "body_v": 0.64, "body_h": 1.05},
    "assassin":   {"chin": 0.18},
    "chasseur":   {"chin": 0.18},
    "mage":       {"chin": 0.17},
    "druide":     {"chin": 0.24, "head_s": 1.35, "body_v": 0.66, "body_h": 1.02},
    "heal":       {"chin": 0.17},
    "invocateur": {"chin": 0.18},
    "sylvain":    {"chin": 0.18},
    "geomancien": {"chin": 0.19, "body_h": 1.20},
    "artificier": {"chin": 0.19},
}
OUTLINE = (26, 16, 32)
OUT_W = 4

def warp(im, p):
    a = np.array(im.convert("RGBA")).astype(np.float32)
    H, W = a.shape[:2]
    ys, xs = np.where(a[:, :, 3] > 20)
    cx = (xs.min() + xs.max()) / 2.0
    chin = p["chin"] * H
    ramp = p["ramp"] * H
    # échelle verticale par zone : tête (head_s) puis corps (body_v), jonction lissée
    # on construit la correspondance y_out -> y_in par intégration de 1/échelle
    sy = np.empty(H, np.float32)
    for y in range(H):
        t = np.clip((y - chin) / max(1.0, ramp), 0, 1)
        t = t * t * (3 - 2 * t)
        sy[y] = p["head_s"] * (1 - t) + p["body_v"] * t
    out_pos = np.concatenate([[0.0], np.cumsum(sy)])   # position de sortie du haut de chaque ligne source
    out_h = int(np.ceil(out_pos[-1]))
    src_rows = np.interp(np.arange(out_h) + 0.5, out_pos, np.arange(H + 1)) - 0.5
    src_rows = np.clip(src_rows, 0, H - 1)
    # échelle horizontale selon la ligne source (tête large -> corps un peu élargi)
    sx_src = np.empty(H, np.float32)
    for y in range(H):
        t = np.clip((y - chin) / max(1.0, ramp), 0, 1)
        t = t * t * (3 - 2 * t)
        sx_src[y] = p["head_s"] * (1 - t) + p["body_h"] * t
    sx_out = np.interp(src_rows, np.arange(H), sx_src)
    out_w = int(W * max(p["head_s"], p["body_h"]) + 8)
    ocx = out_w / 2.0
    res = np.zeros((out_h, out_w, 4), np.float32)
    xo = np.arange(out_w, dtype=np.float32)
    for r in range(out_h):
        y0 = int(np.floor(src_rows[r])); y1 = min(H - 1, y0 + 1); fy = src_rows[r] - y0
        row = a[y0] * (1 - fy) + a[y1] * fy
        xin = (xo - ocx) / sx_out[r] + cx
        valid = (xin >= 0) & (xin <= W - 1)
        xi = np.clip(xin, 0, W - 1)
        x0 = np.floor(xi).astype(int); x1 = np.minimum(W - 1, x0 + 1); fx = (xi - x0)[:, None]
        # interpolation sur couleurs prémultipliées
        pm = row.copy(); pm[:, :3] *= pm[:, 3:4] / 255.0
        v = pm[x0] * (1 - fx) + pm[x1] * fx
        al = v[:, 3:4]
        col = np.where(al > 0.5, v[:, :3] / np.maximum(al, 1) * 255.0, 0)
        res[r, :, :3] = col
        res[r, :, 3] = np.where(valid, al[:, 0], 0)
    return Image.fromarray(np.clip(res, 0, 255).astype(np.uint8), "RGBA")

def outline(im, width=OUT_W):
    a = np.array(im)
    alpha = a[:, :, 3] > 40
    grown = ndimage.binary_dilation(alpha, structure=ndimage.generate_binary_structure(2, 2), iterations=width)
    pad = width + 2
    canvas = Image.new("RGBA", (im.width + 2 * pad, im.height + 2 * pad), (0, 0, 0, 0))
    border = np.zeros((canvas.height, canvas.width, 4), np.uint8)
    border[pad:pad + im.height, pad:pad + im.width, :3] = OUTLINE
    border[pad:pad + im.height, pad:pad + im.width, 3] = (grown * 255).astype(np.uint8)
    base = Image.fromarray(border, "RGBA").filter(ImageFilter.GaussianBlur(0.7))
    base.alpha_composite(im, (pad, pad)) if False else None
    canvas = base
    canvas.alpha_composite(im, (pad, pad))
    bbox = canvas.getchannel("A").point(lambda v: 255 if v > 8 else 0).getbbox()
    return canvas.crop(bbox)

def process(name):
    p = dict(DEFAULT); p.update(PARAMS.get(name, {}))
    im = Image.open(os.path.join(SRC, name + ".png")).convert("RGBA")
    # suréchantillonnage x2 pour garder la finesse après déformation
    big = im.resize((im.width * 2, im.height * 2), Image.LANCZOS)
    w = warp(big, p)
    w = w.resize((max(1, w.width // 2), max(1, w.height // 2)), Image.LANCZOS)
    # saturation légère et contraste pour un rendu plus « illustré »
    from PIL import ImageEnhance
    rgb = w.convert("RGB"); a = w.getchannel("A")
    rgb = ImageEnhance.Color(rgb).enhance(1.12); rgb = ImageEnhance.Contrast(rgb).enhance(1.06)
    w = Image.merge("RGBA", (*rgb.split(), a))
    w = outline(w)
    w.save(os.path.join(DST, name + ".png"))
    print("%-11s %dx%d -> %dx%d" % (name, im.width, im.height, w.width, w.height))

if __name__ == "__main__":
    names = sys.argv[1:] or sorted(PARAMS)
    for n in names:
        process(n)
