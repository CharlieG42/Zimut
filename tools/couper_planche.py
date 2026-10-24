#!/usr/bin/env python3
"""Découpe d'une planche de sprites (Mistral) en poses PNG transparentes.

Usage : couper_planche.py planche.jpg dossier_sortie --grid COLSxROWS [--prefix p] [--min-area N]
- fond retiré par remplissage depuis les bords (bloqué par les contours sombres) ;
- ombres au sol (gris ou rose clair) retirées par un second remplissage ;
- chaque composant est rattaché à la case de grille de son centre (les flammes détachées suivent leur personnage) ;
- une pose par case, recadrée ; sortie : <prefix>_<ligne><colonne>.png (r1c1, r1c2…) + contact.png.
"""
import argparse, os, sys
import numpy as np
from PIL import Image, ImageDraw
from scipy import ndimage as ndi

def bg_mask(rgb: np.ndarray, tol: float = 26.0) -> np.ndarray:
    h, w, _ = rgb.shape
    border = np.concatenate([rgb[0], rgb[-1], rgb[:, 0], rgb[:, -1]]).astype(float)
    bg = np.median(border, axis=0)
    dist = np.sqrt(((rgb.astype(float) - bg) ** 2).sum(-1))
    cand = dist < tol
    lab, _ = ndi.label(cand)
    edge = set(np.unique(np.concatenate([lab[0], lab[-1], lab[:, 0], lab[:, -1]]))) - {0}
    return np.isin(lab, list(edge))

def shadow_like(rgb: np.ndarray, bg_lum: float, delta: float = 6.0) -> np.ndarray:
    f = rgb.astype(float) / 255.0
    mx, mn = f.max(-1), f.min(-1)
    sat = np.where(mx > 0, (mx - mn) / np.maximum(mx, 1e-6), 0)
    lum = (0.299 * f[..., 0] + 0.587 * f[..., 1] + 0.114 * f[..., 2]) * 255
    r, g, b = f[..., 0], f[..., 1], f[..., 2]
    # teinte approchée : rose/mauve = r et b > g
    pinkish = (r > g + 0.03) & (b > g + 0.03)
    neutral = sat < 0.13
    return (lum > 105) & (lum < bg_lum - delta) & ((neutral) | (pinkish & (sat < 0.35) & (lum > 150)))

def cut(path: str, outdir: str, cols: int, rows: int, prefix: str, min_area: int, holes: int = 120, delta: float = 6.0):
    im = Image.open(path).convert("RGB")
    rgb = np.array(im)
    h, w, _ = rgb.shape
    bg = bg_mask(rgb)
    bg_lum = float(np.median(rgb[bg].mean(-1))) if bg.any() else 255.0
    sh = shadow_like(rgb, bg_lum, delta)
    # remplissage des ombres depuis le fond, à travers les pixels « ombre » uniquement
    grow = ndi.binary_dilation(bg, iterations=1) & sh & ~bg
    cur = bg | grow
    for _ in range(400):
        nxt = (ndi.binary_dilation(cur, iterations=2) & sh) | cur
        if nxt.sum() == cur.sum():
            break
        cur = nxt
    fg = ~cur
    # zones « fond » enfermées (entre l'arc et le corps, sous un bras…) : transparentes aussi
    bgc = np.median(rgb[bg], axis=0) if bg.any() else np.array([255.0, 255.0, 255.0])
    near = np.sqrt(((rgb.astype(float) - bgc) ** 2).sum(-1)) < 30.0
    hl, hn = ndi.label(near & fg)
    for i in range(1, hn + 1):
        if (hl == i).sum() >= holes:
            fg[hl == i] = False
    fg = ndi.binary_opening(fg, iterations=1)
    lab, n = ndi.label(fg, structure=np.ones((3, 3)))
    cw, ch = w / cols, h / rows
    cells = {}
    for i in range(1, n + 1):
        ys, xs = np.nonzero(lab == i)
        if len(ys) < min_area:
            continue
        cx, cy = xs.mean(), ys.mean()
        c, r = min(cols - 1, int(cx // cw)), min(rows - 1, int(cy // ch))
        cells.setdefault((r, c), []).append(i)
    # alpha doux : contour anti-aliasé
    os.makedirs(outdir, exist_ok=True)
    outs = {}
    for (r, c), ids in sorted(cells.items()):
        m = np.isin(lab, ids)
        ys, xs = np.nonzero(m)
        y0, y1, x0, x1 = ys.min(), ys.max() + 1, xs.min(), xs.max() + 1
        rgba = np.dstack([rgb, (m * 255).astype(np.uint8)])[y0:y1, x0:x1]
        img = Image.fromarray(rgba, "RGBA")
        name = f"{prefix}_r{r+1}c{c+1}.png"
        img.save(os.path.join(outdir, name))
        outs[(r, c)] = img
    # planche de contrôle
    tw = 230
    sheet = Image.new("RGB", (cols * tw, rows * tw), (60, 60, 70))
    d = ImageDraw.Draw(sheet)
    for (r, c), img in outs.items():
        t = img.copy(); t.thumbnail((tw - 10, tw - 24))
        sheet.paste(t, (c * tw + 5, r * tw + 20), t)
        d.text((c * tw + 6, r * tw + 4), f"r{r+1}c{c+1} {img.size[0]}x{img.size[1]}", fill=(255, 255, 0))
    sheet.save(os.path.join(outdir, f"{prefix}_contact.png"))
    return outs

if __name__ == "__main__":
    ap = argparse.ArgumentParser()
    ap.add_argument("planche"); ap.add_argument("sortie")
    ap.add_argument("--grid", default="3x2"); ap.add_argument("--prefix", default="p")
    ap.add_argument("--min-area", type=int, default=400); ap.add_argument("--holes", type=int, default=120); ap.add_argument("--shadow-delta", type=float, default=6.0)
    a = ap.parse_args()
    cols, rows = (int(x) for x in a.grid.lower().split("x"))
    cut(a.planche, a.sortie, cols, rows, a.prefix, a.min_area, a.holes, a.shadow_delta)
