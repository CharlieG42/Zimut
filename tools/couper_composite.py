#!/usr/bin/env python3
"""Découpe une planche « vues » 2x2 COMPOSÉE (chaque sprite collé dans son propre rectangle de fond,
blanc ou gris, sur un fond de planche d'une autre teinte) — format des planches V2 de Mistral Vibe.

Usage : couper_composite.py planche.png sortie_dir prefixe [--hauteur 340]
Sorties : <prefixe>.png, <prefixe>_idle_2.png, <prefixe>_back.png, <prefixe>_back_idle_2.png
"""
import argparse, os
import numpy as np
from PIL import Image
from scipy import ndimage

SUFFIX = ["", "_idle_2", "_back", "_back_idle_2"]


def flood_bg(rgb, seeds, tol):
    """Masque des pixels de fond connectés aux germes, chacun comparé à la couleur de son germe."""
    h, w, _ = rgb.shape
    bg = np.zeros((h, w), bool)
    for (y, x) in seeds:
        c = rgb[y, x].astype(int)
        near = np.abs(rgb.astype(int) - c).max(axis=2) <= tol
        lab, _ = ndimage.label(near)
        if lab[y, x]:
            bg |= lab == lab[y, x]
    return bg


def cut_cell(cell, tol=26, sombre=False, blanc=False):
    rgb = np.asarray(cell.convert("RGB"))
    h, w, _ = rgb.shape
    # 1) fond de la planche, depuis les bords de la case
    border = [(0, 0), (0, w - 1), (h - 1, 0), (h - 1, w - 1), (0, w // 2), (h - 1, w // 2), (h // 2, 0), (h // 2, w - 1)]
    sheet_bg = flood_bg(rgb, border, 10)
    fg = ~sheet_bg
    lab, n = ndimage.label(fg)
    if n == 0:
        return None
    sizes = ndimage.sum(fg, lab, range(1, n + 1))
    k = int(np.argmax(sizes)) + 1
    ys, xs = np.where(lab == k)
    y0, y1, x0, x1 = ys.min(), ys.max(), xs.min(), xs.max()
    box = rgb[y0:y1 + 1, x0:x1 + 1]
    bh, bw, _ = box.shape
    # 2) fond du rectangle collé (s'il y en a un), depuis ses coins/bords
    seeds = [(0, 0), (0, bw - 1), (bh - 1, 0), (bh - 1, bw - 1), (0, bw // 2), (bh // 2, 0), (bh // 2, bw - 1)]
    inner_bg = flood_bg(box, seeds, tol)
    alpha = (~inner_bg).astype(np.uint8) * 255
    # ombre au sol claire : pixels gris peu saturés sous les pieds, reliés au fond
    a = ndimage.binary_opening(alpha > 0, iterations=1)
    lab2, n2 = ndimage.label(a)
    if n2 == 0:
        return None
    sizes2 = ndimage.sum(a, lab2, range(1, n2 + 1))
    keep = np.zeros_like(a)
    big = sizes2.max()
    for i, s in enumerate(sizes2, 1):
        if s >= 0.02 * big:
            keep |= lab2 == i
    alpha = (keep * 255).astype(np.uint8)
    # ombres / dégradés gris restés autour du sprite : zones claires peu saturées en contact
    # avec la transparence (le blanc du costume, lui, est fermé par le contour noir)
    b = box.astype(int)
    light = (b.min(axis=2) > 120) & (b.max(axis=2) < (256 if sombre else 238)) & ((b.max(axis=2) - b.min(axis=2)) < 24) & (alpha > 0)
    if not sombre:
        light[: int(light.shape[0] * 0.58)] = False   # seulement le bas (ombre au sol), jamais les cheveux
    labl, nl = ndimage.label(light)
    if nl:
        transp = ndimage.binary_dilation(alpha == 0, iterations=1)
        touch = set(np.unique(labl[transp & light]).tolist())
        if sombre:   # zones claires enfermées (entre le bâton et le corps) : grandes plaques uniquement
            sz = ndimage.sum(light, labl, range(1, nl + 1))
            touch |= {i + 1 for i, v in enumerate(sz) if v > 150}
        for i in touch:
            if i:
                alpha[labl == i] = 0
    if blanc:   # plages blanches enfermées (intérieur d'un arc…) : le personnage n'a aucun vêtement blanc
        white = (b.min(axis=2) >= 240) & (alpha > 0)
        lw, nw = ndimage.label(white)
        if nw:
            for i, v in enumerate(ndimage.sum(white, lw, range(1, nw + 1)), 1):
                if v > 300:
                    alpha[lw == i] = 0
    out = np.dstack([box, alpha])
    im = Image.fromarray(out, "RGBA")
    bb = im.getbbox()
    return im.crop(bb) if bb else None


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("sheet"); ap.add_argument("out"); ap.add_argument("prefix")
    ap.add_argument("--hauteur", type=int, default=340)
    ap.add_argument("--sombre", action="store_true", help="personnage sans blanc ni gris clair : retire tout halo clair")
    ap.add_argument("--blanc", action="store_true", help="retire les grandes plages blanches enfermées (intérieur d'un arc)")
    a = ap.parse_args()
    im = Image.open(a.sheet).convert("RGB")
    W, H = im.size
    os.makedirs(a.out, exist_ok=True)
    cells = [im.crop((c * W // 2, r * H // 2, (c + 1) * W // 2, (r + 1) * H // 2)) for r in range(2) for c in range(2)]
    sprites = [cut_cell(c, sombre=a.sombre, blanc=a.blanc) for c in cells]
    ref = max(s.height for s in sprites if s is not None)
    sc = a.hauteur / ref
    for suf, s in zip(SUFFIX, sprites):
        if s is None:
            print("case vide", suf)
            continue
        s = s.resize((max(1, round(s.width * sc)), max(1, round(s.height * sc))), Image.LANCZOS)
        s.save(os.path.join(a.out, a.prefix + suf + ".png"))
        print(a.prefix + suf, s.size)


if __name__ == "__main__":
    main()
