#!/usr/bin/env python3
"""Étend une planche illustrée (V114) : monde plus vaste, défilement en jeu.

La zone existante est conservée à l'identique (mêmes coordonnées de cases, mêmes
POI, même départ — on étend à droite et en bas) ; le masque gagne des cases là où
l'art généré est de la terre ferme, en suivant la côte (croissance organique de
2 couches dans la marge). L'art est ensuite « calé » sur le masque : eau peinte sur
une case jouable -> herbe ; cases non jouables -> mer profonde.

3 nouveaux lieux sont ajoutés dans la marge (butin, camp, combat).

Usage : python3 tools/extend_planche.py <zone_json> <art_extension.jpg> <+cols> <+rows>
        ex. python3 tools/extend_planche.py data/boards/foret_sylve_v2.json /tmp/ext.jpg 32 23
"""
import json
import sys
from pathlib import Path

import numpy as np
from PIL import Image
from scipy import ndimage as ndi

ROOT = Path(__file__).resolve().parent.parent
C = 16
SEED = 114


def cell_is_water(A, cols, rows):
    r, g, b = A[..., 0], A[..., 1], A[..., 2]
    w = (b > r + 15) & (b > g + 5) & (b > 60)
    return w.reshape(rows, C, cols, C).mean(axis=(1, 3)) > 0.5


def main() -> None:
    json_rel, art_path, add_cols, add_rows = sys.argv[1], sys.argv[2], int(sys.argv[3]), int(sys.argv[4])
    jp = ROOT / json_rel
    d = json.loads(jp.read_text(encoding="utf-8"))
    img_rel = str(d["image"])
    old = Image.open(ROOT / img_rel.replace("res://", "")).convert("RGB")
    cols, rows = int(d["cols"]), int(d["rows"])
    W0, H0 = cols * C, rows * C
    assert old.size == (W0, H0), "taille image %s != grille %dx%d" % (old.size, W0, H0)
    cols2, rows2 = cols + add_cols, rows + add_rows
    W2, H2 = cols2 * C, rows2 * C

    # canevas : nouvelle art en fond, ancienne planche par-dessus (couture fondue sur 3 cases)
    art = np.asarray(Image.open(art_path).convert("RGB").resize((W2, H2), Image.LANCZOS)).astype(float)
    old_a = np.asarray(old).astype(float)
    alpha = np.zeros((H2, W2), dtype=float)
    alpha[:H0, :W0] = 1.0
    # dégradé de 3 cases sur les bords droit/bas de l'ancienne zone
    f = 3 * C
    for x in range(W0, min(W2, W0 + f)):
        alpha[:H0, x] = 1.0 - (x - W0) / float(f)
    for y in range(H0, min(H2, H0 + f)):
        alpha[y, :W0] = 1.0 - (y - H0) / float(f)
    a3 = ndi.gaussian_filter(alpha, 6.0)[..., None]
    pad = np.zeros((H2, W2, 3))
    pad[:H0, :W0] = old_a
    comp = pad * a3 + art * (1.0 - a3)

    # masque étendu : '.' partout, copie de l'ancien bloc, croissance dans la marge
    mask = [["."] * cols2 for _ in range(rows2)]
    old_mask = d["mask"]
    for y in range(rows):
        for x in range(cols):
            mask[y][x] = old_mask[y][x]
    water_cell = cell_is_water(comp, cols2, rows2)
    rng = np.random.default_rng(SEED)
    # croissance dans la marge : distance <= 3 cases d'une case jouable existante
    old_walk = np.zeros((rows2, cols2), dtype=bool)
    for y in range(rows):
        for x in range(cols):
            old_walk[y, x] = old_mask[y][x] == "#"
    # croissance chaînée par dilation (adjacence 4) dans la marge, en suivant la côte :
    # on autorise une case si l'art n'y est pas de l'eau ; bord de sécurité de 3 cases.
    margin = np.zeros((rows2, cols2), dtype=bool)
    margin[:, cols:] = True
    margin[rows:, :] = True
    edge = np.zeros((rows2, cols2), dtype=bool)
    edge[:, cols2 - 3:] = True
    edge[rows2 - 3:, :] = True
    frontier = old_walk.copy()
    new_land = np.zeros((rows2, cols2), dtype=bool)
    for _ in range(10):
        frontier = ndi.binary_dilation(frontier)
        new_land |= frontier & margin & ~edge
    # côte irrégulière : on retire ~15% des cases ajoutées au hasard
    new_land &= ~(rng.random((rows2, cols2)) < 0.10)
    # isthme : relie la nouvelle terre à l'île par la ligne la plus courte (Bresenham)
    if new_land.any():
        oy, ox = np.where(old_walk)
        ny, nx = np.where(new_land)
        d2 = (ox[None, :] - nx[:, None]) ** 2 + (oy[None, :] - ny[:, None]) ** 2
        j = int(d2.argmin())
        sy, sx = int(ny[j // len(ox)]), int(nx[j // len(ox)])
        ty, tx = int(oy[j % len(ox)]), int(ox[j % len(ox)])
        x0, y0, x1, y1 = sx, sy, tx, ty
        dx, dy = abs(x1 - x0), -abs(y1 - y0)
        sx_, sy_ = (1 if x0 < x1 else -1), (1 if y0 < y1 else -1)
        err = dx + dy
        while True:
            new_land[y0, x0] = True
            if x0 == x1 and y0 == y1:
                break
            e2 = 2 * err
            if e2 >= dy:
                err += dy
                x0 += sx_
            if e2 <= dx:
                err += dx
                y0 += sy_
    grown = old_walk | new_land
    m2 = np.where(grown, 1.0, 0.0)
    for y in range(rows2):
        for x in range(cols2):
            if m2[y, x] > 0.5:
                mask[y][x] = "#"          # île + isthme + nouvelle terre
            elif margin[y, x]:
                mask[y][x] = "."          # marge non retenue = mer

    # garde uniquement la composante connexe de l'île d'origine (pas d'îlots isolés)
    from collections import deque
    seen = set()
    q = deque()
    for y in range(rows):
        for x in range(cols):
            if old_mask[y][x] == "#":
                seen.add((x, y))
                q.append((x, y))
    while q:
        x, y = q.popleft()
        for xx, yy in [(x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)]:
            if 0 <= xx < cols2 and 0 <= yy < rows2 and mask[yy][xx] == "#" and (xx, yy) not in seen:
                seen.add((xx, yy))
                q.append((xx, yy))
    for y in range(rows2):
        for x in range(cols2):
            if (x >= cols or y >= rows) and mask[y][x] == "#" and (x, y) not in seen:
                mask[y][x] = "."

    # art calé sur le masque : eau sur case jouable -> herbe ; non jouable -> mer
    m = np.zeros((rows2, cols2), dtype=float)
    for y in range(rows2):
        for x in range(cols2):
            m[y, x] = 1.0 if mask[y][x] == "#" else 0.0
    m_img = np.asarray(Image.fromarray((ndi.gaussian_filter(m, 1.2) * 255).astype(np.uint8)).resize((W2, H2), Image.BILINEAR)).astype(float) / 255.0
    m3 = m_img[..., None]
    land = (m > 0.5) & ~water_cell
    land_px = np.repeat(np.repeat(land, C, 0), C, 1)
    water_px = np.repeat(np.repeat(water_cell, C, 0), C, 1)
    grass_ref = np.median(comp[land_px & ~water_px], axis=0) if (land_px & ~water_px).sum() > 50 else np.array([90.0, 150.0, 70.0])
    noise = rng.normal(0, 6, (H2, W2, 1))
    blur = np.stack([ndi.gaussian_filter(comp[..., i], 2.5) for i in range(3)], axis=2)
    lum = blur.mean(axis=2, keepdims=True) / 128.0
    fix = (m3[..., 0] > 0.5) & np.repeat(np.repeat(water_cell, C, 0), C, 1)
    fixed = np.where(fix[..., None], np.clip(grass_ref * lum * 1.15 + noise * 1.5, 0, 255), comp)
    sea = np.array([24.0, 74.0, 110.0])
    sea_full = np.clip(sea + noise + np.sin(np.arange(H2)[:, None, None] * 0.11) * 6.0, 0, 255)
    sea_full = 0.72 * sea_full + 0.28 * comp
    out = fixed * m3 + sea_full * (1.0 - m3)
    out_img = Image.fromarray(np.clip(out, 0, 255).astype(np.uint8), "RGB")
    out_img.save(ROOT / img_rel.replace("res://", ""))

    # 3 nouveaux lieux dans la marge, sur des cases jouables loin du bord
    pois = dict(d["pois"])
    margin_land = [(x, y) for y in range(rows2) for x in range(cols2)
                   if mask[y][x] == "#" and (x >= cols or y >= rows)
                   and 2 <= x < cols2 - 2 and 2 <= y < rows2 - 2
                   and not any(abs(x - int(k.split(",")[0])) + abs(y - int(k.split(",")[1])) < 4 for k in pois)]
    rng2 = np.random.default_rng(SEED + 1)
    picked = []
    if margin_land:
        rng2.shuffle(margin_land)
        picked = margin_land[:3]
    new_pois = [
        ("combat", "Camp de brigands", "Des pillards ont dressé leurs tentes dans la clairière.", 12),
        ("chest", "Cache de la falaise", "Un coffre oublié au pied des rochers.", 13),
        ("camp", "Feu de bivouac", "Un endroit sûr pour reprendre souffle.", 1),
    ]
    for (x, y), (kind, name, desc, lvl) in zip(picked, new_pois):
        pois["%d,%d" % (x, y)] = {"kind": kind, "name": name, "desc": desc, "level": lvl}

    d["cols"], d["rows"] = cols2, rows2
    d["image_size"] = [W2, H2]
    d["mask"] = ["".join(row) for row in mask]
    d["pois"] = pois
    for k in ("decor", "over"):
        d.pop(k, None)  # recalculés ensuite par gen_sylve_v2_decor.py
    jp.write_text(json.dumps(d, ensure_ascii=False, indent="") + "\n", encoding="utf-8")

    walk = sum(r.count("#") for r in d["mask"])
    print("%s : %dx%d -> %dx%d cases (%d jouables), %d lieux, nouveaux: %s"
          % (json_rel, cols, rows, cols2, rows2, walk, len(pois), ["%d,%d" % p for p in picked]))


if __name__ == "__main__":
    main()
