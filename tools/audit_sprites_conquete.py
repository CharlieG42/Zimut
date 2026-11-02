#!/usr/bin/env python3
"""Audit des sprites de bâtiments de Conquête (assets/ui/conquest/cities/batiments/<nation>/).
Signale : sprites manquants (10 nations × 9 bâtiments × 5 niveaux + merveille), sprites COUPÉS (pixels
opaques sur le bord de l'image), fragments isolés. Avec --fix : supprime les fragments isolés (< 1,5 % de
la plus grande composante, hors du cadre de celle-ci) — jamais le dessin principal.
Usage : audit_sprites_conquete.py [--fix] [--md fichier.md]"""
import sys, glob, os
import numpy as np
from PIL import Image
from scipy import ndimage

BASE = os.path.join(os.path.dirname(__file__), "..", "prototype", "zimut", "assets", "ui", "conquest", "cities", "batiments")
NATIONS = ["sylvestre", "brasier", "brumes", "cimes", "cristaux", "marees", "ombres", "rouages", "sables", "vents"]
BUILDINGS = ["hall", "caserne", "residence", "mine", "scierie", "tannerie", "cabane", "verger", "muraille"]


def analyse(path, fix=False):
    im = Image.open(path).convert("RGBA")
    a = np.array(im)
    solid = a[..., 3] > 128
    cut = int(solid[0].sum() + solid[-1].sum() + solid[:, 0].sum() + solid[:, -1].sum())
    lab, n = ndimage.label(a[..., 3] > 0, structure=np.ones((3, 3)))
    removed = 0
    removed_big = False
    if n > 1:
        sizes = ndimage.sum(a[..., 3] > 0, lab, range(1, n + 1))
        big = int(np.argmax(sizes)) + 1
        ys, xs = np.where(lab == big)
        x0, x1, y0, y1 = xs.min(), xs.max(), ys.min(), ys.max()
        todo = []
        for i in range(1, n + 1):
            if i == big or sizes[i - 1] >= 0.015 * sizes[big - 1]:
                continue
            m = lab == i
            yy, xx = np.where(m)
            inside = x0 <= xx.mean() <= x1 and y0 <= yy.mean() <= y1
            if not inside:
                removed += int(sizes[i - 1])
                todo.append(m)
        removed_big = removed >= 100      # on ne retouche que les fichiers où les fragments se voient
        if fix and removed_big:
            for m in todo:
                a[m, 3] = 0
        if fix and removed_big:
            Image.fromarray(a, "RGBA").save(path)
    return cut, removed


def main():
    fix = "--fix" in sys.argv
    md = sys.argv[sys.argv.index("--md") + 1] if "--md" in sys.argv else ""
    missing, cuts, frag = {}, [], []
    for nat in NATIONS:
        have = {os.path.basename(p)[:-4] for p in glob.glob(os.path.join(BASE, nat, "*.png"))}
        miss = []
        for b in BUILDINGS:
            lv = [i for i in range(1, 6) if f"{b}_{i}" in have]
            if not lv and b in have:
                lv = [0]
            if len(lv) < 5 and lv != [0]:
                miss.append("%s niveaux %s" % (b, ",".join(str(i) for i in range(1, 6) if i not in lv)))
            elif lv == [0]:
                miss.append("%s : ancien nom sans niveau (à découper en 5)" % b)
        if "merveille" not in have:
            miss.append("merveille")
        missing[nat] = miss
        for p in sorted(glob.glob(os.path.join(BASE, nat, "*.png"))):
            c, r = analyse(p, fix)
            nm = nat + "/" + os.path.basename(p)
            if c >= 40:
                cuts.append((nm, c))
            if r >= 100:
                frag.append((nm, r))
    lines = ["# Audit sprites Conquête", ""]
    lines.append("## Manquants")
    for nat in NATIONS:
        lines.append("- **%s** : %s" % (nat, "complet" if not missing[nat] else " ; ".join(missing[nat])))
    lines.append("")
    lines.append("## Coupés (pixels opaques au bord de l'image) — à régénérer avec une marge")
    for nm, c in cuts:
        lines.append("- %s (%d px au bord)" % (nm, c))
    lines.append("")
    lines.append("## Fragments isolés ≥ 100 px %s" % ("supprimés" if fix else "détectés (informatif : peut être un élément volontaire, ex. anneau flottant de la cabane Sylvestre 3 ; --fix les supprime)"))
    for nm, r in frag:
        lines.append("- %s (%d px)" % (nm, r))
    out = "\n".join(lines)
    print(out)
    if md:
        open(md, "w").write(out + "\n")


if __name__ == "__main__":
    main()
