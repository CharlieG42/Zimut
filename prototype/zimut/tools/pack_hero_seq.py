#!/usr/bin/env python3
"""Assemble les images brutes cuites par tools/bake_hero_seq.gd en deux planches (face / dos) + un JSON.

    python3 tools/pack_hero_seq.py <dossier_brut> <sprite_de_base>
    ex. : python3 tools/pack_hero_seq.py /tmp/syl assets/sprites/players/sylvain.png

Écrit à côté du sprite de base : <base>_seq_front.png, <base>_seq_back.png, <base>_seq.txt.
Chaque image brute (2× la cellule) reçoit un contour sombre, puis est réduite à la cellule finale.
Une planche = une ligne par animation, une colonne par image (alpha prémultiplié pour la réduction).
"""
import json
import sys
from pathlib import Path

import numpy as np
from PIL import Image
from scipy import ndimage

ORDER = ["idle", "walk", "attack", "cast", "hit"]
OUTLINE_PX = 1.6                       # épaisseur du contour, en pixels de la cellule finale
OUTLINE_RGB = np.array([0.06, 0.08, 0.15])


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


def main() -> None:
    raw = Path(sys.argv[1])
    base = Path(sys.argv[2])
    meta = json.loads((raw / "meta.json").read_text())
    cell = int(meta["cell"])
    cols = max(int(meta["anims"][a]["n"]) for a in ORDER)
    out_meta = {
        "cell": cell,
        "char_frac": meta["char_frac"],
        "feet_row": meta["feet_row"],
        "anims": {},
    }
    for row, an in enumerate(ORDER):
        info = meta["anims"][an]
        out_meta["anims"][an] = {
            "row": row,
            "n": info["n"],
            "loop": info["loop"],
            "key": info["key"],
            "dur": info["dur"],
            "tips": info["tips"],
        }
    for view in meta["views"]:
        sheet = Image.new("RGBA", (cols * cell, len(ORDER) * cell), (0, 0, 0, 0))
        for row, an in enumerate(ORDER):
            for i in range(int(meta["anims"][an]["n"])):
                im = Image.open(raw / "raw" / view / f"{an}_{i:02d}.png").convert("RGBA")
                big = outline(im, OUTLINE_PX * (im.width / cell))
                small = big.convert("RGBa").resize((cell, cell), Image.LANCZOS).convert("RGBA")
                sheet.paste(small, (i * cell, row * cell))
        path = base.with_name(f"{base.stem}_seq_{view}.png")
        sheet.save(path, optimize=True)
        print("écrit", path, sheet.size)
    jpath = base.with_name(f"{base.stem}_seq.txt")
    jpath.write_text(json.dumps(out_meta, indent=1))
    print("écrit", jpath)


if __name__ == "__main__":
    main()
