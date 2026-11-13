#!/usr/bin/env python3
"""Assemble les images brutes cuites par tools/bake_hero_seq.gd en deux planches (face / dos) + un JSON.

    python3 tools/pack_hero_seq.py <dossier_brut> <sprite_de_base>
    ex. : python3 tools/pack_hero_seq.py /tmp/syl assets/sprites/players/sylvain.png

Écrit à côté du sprite de base : <base>_seq_front.png, <base>_seq_back.png, <base>_seq.txt.
Chaque image brute (2× la cellule) reçoit un contour sombre, puis est réduite à la cellule finale.
Les planches sont compactes (V157) : chaque image est rognée à sa partie visible, les images identiques ne sont
stockées qu'une fois, et le JSON donne pour chaque image son rectangle dans la planche et son décalage dans la
cellule (x, y, l, h, dx, dy). Le jeu reconstitue la cellule avec les marges d'un AtlasTexture.
"""
import hashlib
import json
import sys
from pathlib import Path

import numpy as np
from PIL import Image
from scipy import ndimage

ORDER = ["idle", "walk", "attack", "cast", "hit"]
OUTLINE_PX = 1.6                       # épaisseur du contour, en pixels de la cellule finale
OUTLINE_RGB = np.array([0.06, 0.08, 0.15])
PAD = 4                                # marge transparente gardée autour de chaque image (contour du shader du jeu)
GAP = 2                                # écart entre deux images de la planche
MAX_W = 1024                           # largeur maximale d'une planche


def outline(img: Image.Image, width: float) -> Image.Image:
    """Ajoute un contour d'encre autour de la silhouette (largeur en pixels de [img])."""
    a = np.asarray(img, dtype=np.float32) / 255.0
    alpha = a[..., 3]
    dist = ndimage.distance_transform_edt(alpha < 0.5)
    ring = np.clip(width + 0.5 - dist, 0.0, 1.0) * (alpha < 0.999)
    ring_rgb = np.broadcast_to(OUTLINE_RGB, a[..., :3].shape)
    # personnage au-dessus du contour (alpha « droit »)
    out_a = alpha + ring * (1.0 - alpha)
    safe = np.maximum(out_a, 1e-6)[..., None]
    out_rgb = (a[..., :3] * alpha[..., None] + ring_rgb * (ring * (1.0 - alpha))[..., None]) / safe
    res = np.dstack([out_rgb, out_a])
    return Image.fromarray((np.clip(res, 0, 1) * 255.0 + 0.5).astype(np.uint8), "RGBA")


def crop(im: Image.Image):
    """Rogne l'image à sa partie visible (+ PAD pixels) : renvoie (image rognée, décalage x, décalage y)."""
    box = im.getchannel("A").point(lambda v: 255 if v > 0 else 0).getbbox()
    if box is None:
        return im.crop((0, 0, 1, 1)), 0, 0
    x0 = max(0, box[0] - PAD)
    y0 = max(0, box[1] - PAD)
    x1 = min(im.width, box[2] + PAD)
    y1 = min(im.height, box[3] + PAD)
    return im.crop((x0, y0, x1, y1)), x0, y0


def pack(items, max_w: int):
    """Range des rectangles (w, h) en étagères, du plus haut au plus bas. Renvoie (positions, largeur, hauteur)."""
    order = sorted(range(len(items)), key=lambda k: -items[k][1])
    pos = [None] * len(items)
    x = y = shelf = width = 0
    for k in order:
        w, h = items[k]
        if x > 0 and x + w > max_w:
            x = 0
            y += shelf + GAP
            shelf = 0
        pos[k] = (x, y)
        x += w + GAP
        width = max(width, x - GAP)
        shelf = max(shelf, h)
    return pos, width, y + shelf


def main() -> None:
    raw = Path(sys.argv[1])
    base = Path(sys.argv[2])
    meta = json.loads((raw / "meta.json").read_text())
    cell = int(meta["cell"])
    out_meta = {
        "cell": cell,
        "char_frac": meta["char_frac"],
        "feet_row": meta["feet_row"],
        "anims": {},
    }
    for an in ORDER:
        info = meta["anims"][an]
        out_meta["anims"][an] = {
            "n": info["n"],
            "loop": info["loop"],
            "key": info["key"],
            "dur": info["dur"],
            "tips": info["tips"],
            "frames": {},
        }
    total_before = 0
    total_after = 0
    for view in meta["views"]:
        # images rognées, dédoublonnées (la première image de chaque geste est souvent la pose de repos)
        uniq = {}
        crops = []
        refs = {}
        for an in ORDER:
            refs[an] = []
            for i in range(int(meta["anims"][an]["n"])):
                im = Image.open(raw / "raw" / view / f"{an}_{i:02d}.png").convert("RGBA")
                big = outline(im, OUTLINE_PX * (im.width / cell))
                small = big.convert("RGBa").resize((cell, cell), Image.LANCZOS).convert("RGBA")
                c, ox, oy = crop(small)
                key = (c.size, ox, oy, hashlib.sha1(c.tobytes()).hexdigest())
                if key not in uniq:
                    uniq[key] = len(crops)
                    crops.append((c, ox, oy))
                refs[an].append(uniq[key])
        pos, w, h = pack([c.size for c, _, _ in crops], MAX_W)
        sheet = Image.new("RGBA", (w, h), (0, 0, 0, 0))
        for k, (c, _, _) in enumerate(crops):
            sheet.paste(c, pos[k])
        for an in ORDER:
            out_meta["anims"][an]["frames"][view] = [
                [pos[k][0], pos[k][1], crops[k][0].width, crops[k][0].height, crops[k][1], crops[k][2]] for k in refs[an]
            ]
        path = base.with_name(f"{base.stem}_seq_{view}.png")
        sheet.save(path, optimize=True)
        n_frames = sum(len(v) for v in refs.values())
        total_before += n_frames * cell * cell
        total_after += w * h
        print("écrit", path, sheet.size, f"{len(crops)} images uniques sur {n_frames}")
    jpath = base.with_name(f"{base.stem}_seq.txt")
    jpath.write_text(json.dumps(out_meta, separators=(",", ":")))
    print("écrit", jpath)
    print(f"mémoire graphique : {total_after * 4 / 1e6:.1f} Mo (cellules pleines : {total_before * 4 / 1e6:.1f} Mo)")


if __name__ == "__main__":
    main()
