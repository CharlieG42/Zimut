#!/usr/bin/env python3
"""Re-peinture d'une planche illustrée (V114) guidée par le masque existant.

Le masque (cases jouables) ne change JAMAIS — seul le rendu change :
  - cases jouables : on garde l'art généré, sauf si l'IA y a peint de l'eau
    (remplacée par de l'herbe) pour que le héros ne marche jamais sur l'eau ;
  - cases non jouables (la mer autour de l'île) : l'art est ramené vers une
    teinte d'eau profonde avec un léger bruit de vagues, pour que la silhouette
    de l'île corresponde exactement au masque.

Usage : python3 tools/repaint_planche.py <art_générée.jpg> <planche_cible.png> <zone_json>
        ex. python3 tools/repaint_planche.py /tmp/sylve_new.jpg assets/boards/Sylvestre_v2.png data/boards/foret_sylve_v2.json
"""
import json
import sys
from pathlib import Path

import numpy as np
from PIL import Image, ImageFilter
from scipy import ndimage as ndi

ROOT = Path(__file__).resolve().parent.parent


def main() -> None:
    art_path, out_path, json_path = sys.argv[1], ROOT / sys.argv[2], ROOT / sys.argv[3]
    d = json.loads(json_path.read_text(encoding="utf-8"))
    C = int(d["cell_px"])
    cols, rows = int(d["cols"]), int(d["rows"])
    W, H = cols * C, rows * C
    mask = d["mask"]

    art = Image.open(art_path).convert("RGB").resize((W, H), Image.LANCZOS)
    A = np.asarray(art).astype(float)

    # masque flouté (bord en dégradé sur ~1 case)
    m = np.zeros((rows, cols), dtype=float)
    for y in range(rows):
        for x in range(cols):
            m[y, x] = 1.0 if mask[y][x] == "#" else 0.0
    m_blur = ndi.gaussian_filter(m, sigma=1.2)
    m_img = np.asarray(Image.fromarray((m_blur * 255).astype(np.uint8)).resize((W, H), Image.BILINEAR)).astype(float) / 255.0
    m3 = m_img[..., None]

    # classification eau de l'art généré, par case (moyenne sur la case 16x16)
    r, g, b = A[..., 0], A[..., 1], A[..., 2]
    water_px = (b > r + 15) & (b > g + 5) & (b > 60)
    water_cell = water_px.reshape(rows, C, cols, C).mean(axis=(1, 3)) > 0.5
    water_cell_img = np.asarray(Image.fromarray((water_cell.astype(np.uint8) * 255)).resize((W, H), Image.NEAREST)) > 0

    # couleur "prairie" de référence = médiane de l'art sur les cases jouables non-eau
    land = (m > 0.5) & ~water_cell
    if land.sum() > 50:
        land_px = np.repeat(np.repeat(land, C, 0), C, 1) & ~water_cell_img
        grass_ref = np.median(A[land_px], axis=0)
    else:
        grass_ref = np.array([90.0, 150.0, 70.0])

    # sur les cases jouables, l'eau peinte par l'IA devient de l'herbe :
    # on lisse localement (flou) pour éviter tout effet de cases carrées
    rng = np.random.default_rng(114)
    noise = rng.normal(0, 6, (H, W, 1))
    fixed = A.copy()
    fix = (m3[..., 0] > 0.5) & water_cell_img
    fixed_blur = np.stack([ndi.gaussian_filter(A[..., i], 2.5) for i in range(3)], axis=2)
    lum = fixed_blur.mean(axis=2, keepdims=True) / 128.0   # texture de luminance locale
    fixed = np.where(fix[..., None], np.clip(grass_ref * lum * 1.15 + noise * 1.5, 0, 255), fixed)

    # mer autour de l'île : ramenée vers bleu profond + vagues
    sea = np.array([24.0, 74.0, 110.0])
    waves = rng.normal(0, 7, (H, W, 1)) + np.sin(np.arange(H)[:, None, None] * 0.11) * 6.0
    sea_full = np.clip(sea + waves, 0, 255)
    # reflets : on garde un peu de la texture de l'art sous l'eau
    sea_full = 0.72 * sea_full + 0.28 * A

    out = fixed * m3 + sea_full * (1.0 - m3)
    Image.fromarray(np.clip(out, 0, 255).astype(np.uint8), "RGB").save(out_path)

    # QC :aucune case jouable classée eau dans le résultat
    O = np.asarray(Image.open(out_path).convert("RGB")).astype(float)
    rr, gg, bb = O[..., 0], O[..., 1], O[..., 2]
    wc = (bb > rr + 15) & (bb > gg + 5) & (bb > 60)
    bad = sum(1 for y in range(rows) for x in range(cols) if mask[y][x] == "#" and wc[y * C + 4, x * C + 4])
    print("%s repeinte : %dx%d, cases jouables peintes en eau: %d" % (out_path, W, H, bad))


if __name__ == "__main__":
    main()
