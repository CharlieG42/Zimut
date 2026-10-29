#!/usr/bin/env python3
"""Découpe et détoure les planches du joueur et de son compagnon (Gligli) pour le monde 3D.

Usage : python3 tools/extraire_sprites_3d.py <planche_joueur_6_vues.png> <planche_compagnon.png>
Sortie : prototype/zimut/assets/adventure3d/{hero,gligli}/*.png (fond transparent, pieds en bas).
"""
import sys, os
import numpy as np
from PIL import Image, ImageFilter
from scipy import ndimage as ndi

OUT = os.path.join(os.path.dirname(__file__), "..", "prototype", "zimut", "assets", "adventure3d")


def fond(a):
    """Masque du fond : gris/blanc neutre (damier compris) relié au bord de l'image."""
    mx = a.max(axis=2).astype(int)
    mn = a.min(axis=2).astype(int)
    cand = (mn >= 205) & (mx - mn <= 14)
    lab, _ = ndi.label(cand)
    edge = set(np.unique(np.concatenate([lab[0], lab[-1], lab[:, 0], lab[:, -1]]))) - {0}
    return np.isin(lab, list(edge))


def detourer(im, box, nom, hauteur, sortie):
    """Découpe `box` (x0,y0,x1,y1), supprime le fond, garde l'élément principal, recadre, redimensionne."""
    crop = im.crop(box).convert("RGB")
    a = np.array(crop)
    bg = fond(a)
    fg = ~bg
    # on retire le liseré clair : une érosion d'un pixel
    fg = ndi.binary_erosion(fg, iterations=1)
    # on garde la composante la plus grande + celles qui la touchent presque (feuille, mèches)
    lab, n = ndi.label(ndi.binary_dilation(fg, iterations=6))
    if n == 0:
        raise SystemExit("rien trouvé dans " + nom)
    tailles = ndi.sum(fg, lab, range(1, n + 1))
    garde = lab == (1 + int(np.argmax(tailles)))
    fg = fg & garde
    # trous internes (entre les jambes, etc.) : fond déjà exclu s'il touchait le bord, sinon on comble
    fg = ndi.binary_fill_holes(fg) | fg
    alpha = Image.fromarray((fg * 255).astype(np.uint8)).filter(ImageFilter.GaussianBlur(0.8))
    rgba = crop.copy()
    rgba.putalpha(alpha)
    bb = rgba.getchannel("A").point(lambda v: 255 if v > 40 else 0).getbbox()
    rgba = rgba.crop(bb)
    w = round(rgba.width * hauteur / rgba.height)
    rgba = rgba.resize((w, hauteur), Image.LANCZOS)
    os.makedirs(sortie, exist_ok=True)
    chemin = os.path.join(sortie, nom + ".png")
    rgba.save(chemin, optimize=True)
    print(nom, rgba.size)


def main():
    planche_h, planche_c = sys.argv[1], sys.argv[2]
    h = Image.open(planche_h)
    # joueur : 5 vues uniques (les autres en miroir dans le jeu) — colonnes lues sur la planche 1536×1024
    cols = [("face", 0, 255), ("quart_face", 255, 505), ("cote", 505, 765), ("quart_dos", 745, 1035), ("dos", 1010, 1285)]
    for nom, x0, x1 in cols:
        detourer(h, (x0, 120, x1, 892), nom, 440, os.path.join(OUT, "hero"))
    c = Image.open(planche_c)
    # compagnon : rangée du haut (face, quart droit, côté droit, dos) + « assis » et « en action », bulles d'émotion
    haut = [("face", 10, 250), ("quart_face", 250, 500), ("cote", 500, 760), ("dos", 760, 1010)]
    for nom, x0, x1 in haut:
        detourer(c, (x0, 150, x1, 520), nom, 260, os.path.join(OUT, "gligli"))
    detourer(c, (850, 650, 1060, 910), "assis", 260, os.path.join(OUT, "gligli"))
    detourer(c, (1060, 610, 1310, 900), "action", 260, os.path.join(OUT, "gligli"))
    for nom, x0, x1 in [("emote_neutre", 20, 230), ("emote_heureux", 235, 440), ("emote_surpris", 440, 640), ("emote_colere", 640, 840)]:
        detourer(c, (x0, 665, x1, 905), nom, 160, os.path.join(OUT, "gligli"))


if __name__ == "__main__":
    main()
