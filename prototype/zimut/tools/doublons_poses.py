#!/usr/bin/env python3
"""doublons_poses.py — repère les poses en double sur une planche de sprites (V36).

Usage :  python3 tools/doublons_poses.py planche1.jpg [planche2.png ...]
         python3 tools/doublons_poses.py dossier_de_poses/        (PNG déjà découpés)

Chaque pose (découpée ici sur fond uni, ou PNG transparent) est réduite à une signature 32 × 32 :
silhouette + luminance, recadrée sur le sprite et centrée dans un carré. Distance < 0,05 : pose identique ;
< 0,08 : très proche. Même algorithme que SpriteBuilder (atelier_sprites/lib/core/doublons.dart).
Calibrage sur les planches Mistral d'octobre 2026 : copies 0,002 à 0,03 ; poses distinctes > 0,08.
"""
import os
import sys

import numpy as np
from PIL import Image
from scipy import ndimage as ndi

N = 32
SEUIL_DOUBLON = 0.05
SEUIL_PROCHE = 0.08


def signature(rgba):
    a = rgba[:, :, 3] > 128
    ys, xs = np.where(a)
    if len(xs) == 0:
        return None
    c = rgba[ys.min():ys.max() + 1, xs.min():xs.max() + 1]
    h, w = c.shape[:2]
    s = max(h, w)
    sq = np.zeros((s, s, 4), np.uint8)
    sq[(s - h) // 2:(s - h) // 2 + h, (s - w) // 2:(s - w) // 2 + w] = c
    arr = np.asarray(Image.fromarray(sq, "RGBA").resize((N, N), Image.BILINEAR)).astype(np.float32) / 255.0
    alpha = arr[:, :, 3]
    lum = (arr[:, :, 0] * 0.3 + arr[:, :, 1] * 0.59 + arr[:, :, 2] * 0.11) * alpha
    return alpha, lum, w / h


def distance(s1, s2):
    return float(np.abs(s1[0] - s2[0]).mean() + np.abs(s1[1] - s2[1]).mean() + abs(np.log(s1[2] / s2[2])) * 0.2)


def poses_planche(path, min_area=4000):
    """Découpe une planche sur fond uni clair (blanc, gris, damier) en poses RGBA, ordre de lecture."""
    im = np.array(Image.open(path).convert("RGB")).astype(np.int16)
    mx, mn = im.max(2), im.min(2)
    fond = ((mx - mn) <= 26) & (mn >= 120)
    lab, _ = ndi.label(fond)
    bord = set(np.unique(np.concatenate([lab[0], lab[-1], lab[:, 0], lab[:, -1]]))) - {0}
    fg = ~np.isin(lab, list(bord))
    fg = ndi.binary_opening(fg, iterations=1)
    lab2, n = ndi.label(fg, structure=np.ones((3, 3)))
    out = []
    for i, sl in enumerate(ndi.find_objects(lab2)):
        m = lab2[sl] == i + 1
        if m.sum() < min_area:
            continue
        rgba = np.dstack([im[sl].astype(np.uint8), (m * 255).astype(np.uint8)])
        out.append(((sl[0].start + sl[0].stop) / 2, (sl[1].start + sl[1].stop) / 2, rgba))
    out.sort(key=lambda t: (round(t[0] / 150), t[1]))
    return [r for _, _, r in out]


def rapport(nom, poses):
    sigs = [signature(p) for p in poses]
    paires = []
    for i in range(len(sigs)):
        for j in range(i + 1, len(sigs)):
            if sigs[i] is not None and sigs[j] is not None:
                d = distance(sigs[i], sigs[j])
                if d < SEUIL_PROCHE:
                    paires.append((d, i + 1, j + 1))
    paires.sort()
    ident = sum(1 for d, _, _ in paires if d < SEUIL_DOUBLON)
    print(f"{nom} : {len(poses)} poses, {ident} paires identiques, {len(paires) - ident} très proches")
    for d, a, b in paires[:12]:
        print(f"   poses {a} et {b} : {'identiques' if d < SEUIL_DOUBLON else 'très proches'} (écart {d * 100:.1f} %)")
    return ident


def main(args):
    total = 0
    for a in args:
        if os.path.isdir(a):
            fichiers = sorted(f for f in os.listdir(a) if f.lower().endswith(".png"))
            poses = [np.array(Image.open(os.path.join(a, f)).convert("RGBA")) for f in fichiers]
            total += rapport(a, poses)
        else:
            total += rapport(os.path.basename(a), poses_planche(a))
    return 1 if total else 0


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print(__doc__)
        sys.exit(2)
    sys.exit(main(sys.argv[1:]))
