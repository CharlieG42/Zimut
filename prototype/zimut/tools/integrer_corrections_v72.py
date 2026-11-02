#!/usr/bin/env python3
"""integrer_corrections_v72.py — intègre les poses corrigées par Mistral (dossiers
assets/sprites/nations/newAssets/*/corrections/*_v2.png, fond blanc) à la place des poses défectueuses.

Pour chaque fichier : fond retiré par le bord (le contour fermé du personnage protège ses blancs),
pièces détachées notables conservées (armes, éclats), blanc pur résiduel sous/entre les pieds retiré,
recadrage, mise à l'échelle à la hauteur du fichier remplacé, alpha prémultiplié (aucun liseré).
Usage : python3 tools/integrer_corrections_v72.py [--apply]
"""
import os, sys
import numpy as np
from PIL import Image
from scipy import ndimage as ndi

HERE = os.path.dirname(os.path.abspath(__file__))
SPR = os.path.join(HERE, "..", "assets", "sprites")
NEW = os.path.join(SPR, "nations", "newAssets")
ENN = os.path.join(SPR, "nations", "ennemis")
PL = os.path.join(SPR, "players")

# (source newAssets, fichier remplacé, mode blanc résiduel : "all" = poches fermées + bas, "bottom" = bas seulement)
MAP = []
for p in ["back_attack", "back_attack_2", "back_cast"]:
    MAP.append((f"cimes/corrections/tank_{p}_v2.png", f"{PL}/tank_{p}.png", "bottom"))
for p in ["cast", "cast_2"]:
    MAP.append((f"brasier/corrections/chasseur_{p}_v2.png", f"{PL}/chasseur_{p}.png", "all"))
for p in ["back_attack", "back_attack_2", "back_cast", "back_cast_2"]:
    MAP.append((f"sables/corrections/geomancien_{p}_v2.png", f"{PL}/geomancien_{p}.png", "all"))
for p in ["back_attack", "back_cast_2"]:
    MAP.append((f"cristaux/corrections/araignee_cristal_{p}_v2.png", f"{ENN}/cristaux/araignee_de_cristal_{p}.png", "all"))
for p in ["back_attack", "back_attack_2", "back_cast", "back_cast_2"]:
    MAP.append((f"rouages/corrections/araignee_meca_{p}_v2.png", f"{ENN}/rouages/araignee_mecanique_{p}.png", "all"))
for p in ["back", "back_attack", "back_cast", "back_idle_2"]:
    MAP.append((f"ombres/corrections/assassin_{p}_v2.png", f"{ENN}/ombres/assassin_des_ombres_{p}.png", "all"))
for p in ["back_attack", "back_cast_2"]:
    MAP.append((f"ombres/corrections/spectre_{p}_v2.png", f"{ENN}/ombres/spectre_{p}.png", "all"))


def process(src, dst, mode):
    a = np.array(Image.open(os.path.join(NEW, src)).convert("RGB")).astype(int)
    mn, mx = a.min(axis=2), a.max(axis=2)
    lab, _ = ndi.label((mn >= 238) & ((mx - mn) <= 12))
    e = set(np.unique(np.concatenate([lab[0], lab[-1], lab[:, 0], lab[:, -1]]))) - {0}
    fg = ~np.isin(lab, list(e))
    l2, k = ndi.label(fg)
    sz = ndi.sum(fg, l2, range(1, k + 1))
    keep = np.zeros_like(fg)
    for i, s in enumerate(sz, 1):
        if s >= 0.015 * sz.max():
            keep |= l2 == i
    fg = keep
    ys, xs = np.where(fg)
    y0, y1, x0, x1 = ys.min(), ys.max() + 1, xs.min(), xs.max() + 1
    # blanc pur résiduel (ombre au sol, poches entre les pieds)
    white = fg & (mn >= 250) & ((mx - mn) <= 5)
    wl, wk = ndi.label(white)
    kill = np.zeros_like(fg)
    hh = y1 - y0
    for i in range(1, wk + 1):
        m = wl == i
        n = int(m.sum())
        if n < 120:
            continue
        low = np.where(m)[0].mean() > y0 + 0.6 * hh
        touch = np.where(m)[0].max() >= y1 - 3
        if (low and touch) or (mode == "all" and n >= 400 and low):
            kill |= m
    if kill.any():
        near = ndi.binary_dilation(kill, iterations=2)
        kill |= near & fg & (mn >= 205) & ((mx - mn) <= 40)
        fg &= ~kill
    fg = ndi.binary_erosion(fg, iterations=1)
    ys, xs = np.where(fg)
    y0, y1, x0, x1 = ys.min(), ys.max() + 1, xs.min(), xs.max() + 1
    rgb = a.astype(np.uint8)[y0:y1, x0:x1]
    alpha = (fg * 255).astype(np.uint8)[y0:y1, x0:x1]
    H = Image.open(dst).size[1]
    s = H / rgb.shape[0]
    size = (max(1, int(rgb.shape[1] * s)), H)
    pre = rgb.astype(float) * (alpha[..., None] / 255.0)
    al = np.array(Image.fromarray(alpha).resize(size, Image.LANCZOS)).astype(float)
    out = np.zeros((size[1], size[0], 4), dtype=np.uint8)
    for c in range(3):
        ch = np.array(Image.fromarray(pre[..., c].astype(np.float32), mode="F").resize(size, Image.LANCZOS))
        out[..., c] = np.clip(np.where(al > 0, ch / np.maximum(al / 255.0, 1e-3), 0), 0, 255).astype(np.uint8)
    out[..., 3] = al.astype(np.uint8)
    return Image.fromarray(out)


if __name__ == "__main__":
    apply = "--apply" in sys.argv
    for src, dst, mode in MAP:
        im = process(src, dst, mode)
        print(os.path.basename(dst), im.size, "(avant", Image.open(dst).size, ")")
        if apply:
            im.save(dst)
