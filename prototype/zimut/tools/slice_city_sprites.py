#!/usr/bin/env python3
"""Détoure et découpe les planches de bâtiments (Mistral) en PNG transparents pour la vue de ville.

Usage : python3 tools/slice_city_sprites.py <dossier p01.jpg…> [--only sylvestre|cimes]
       python3 tools/slice_city_sprites.py <dossier> --v65 [--only sables]   # mode V65 : planches/<nation>/<batiment>.png, 5 niveaux en ligne

Sortie : assets/ui/conquest/cities/batiments/<nation>/<bâtiment>[_<niveau>].png
(convention : assets/ui/conquest/cities/batiments/README.md).

Chaque planche est repérée par un numéro (p01 … p16, ordre d'envoi). MANIFEST dit quelle partie
de quelle planche devient quel bâtiment : changer une ligne puis relancer suffit pour réaffecter
un sprite. Les niveaux d'un même bâtiment partagent une toile commune (pied centré en bas), ce qui
conserve leur taille relative : le jeu fixe la largeur de la toile, pas celle du dessin.
"""
import argparse
import os
import sys

import numpy as np
from PIL import Image
from scipy import ndimage as ndi

OUT_ROOT = os.path.join(os.path.dirname(__file__), "..", "assets", "ui", "conquest", "cities", "batiments")
# Largeur (px) de la toile de chaque bâtiment : même poids visuel d'une nation à l'autre, et assez
# petit pour l'APK. Le jeu fixe la largeur affichée (ConquestCityView.SPRITE_WIDTH ≈ 0,4 × ces valeurs).
TARGET_W = {"hall": 520, "caserne": 440, "residence": 420, "merveille": 480, "scierie": 420,
            "mine": 400, "tannerie": 360, "cabane": 300, "verger": 400, "muraille": 560}

# (planche, nation, fichier, découpe) — découpe : ("g", n) = n-ième ensemble détecté (de gauche à droite,
# 0 = premier) ; ("box", x0, y0, x1, y1) = rectangle dans la planche (après suppression des barres noires) ;
# ("c", k, (x1, x2…)) = k-ième bande verticale, coupures placées au plus vide près des indications ;
# ("all",) = tout ce qui est détouré.
MANIFEST = [
    # ── Forêt (nation « sylvestre », planches estivales) ──
    ("p09", "sylvestre", "hall_1", ("all",)),
    ("p01", "sylvestre", "caserne", ("g", 0)),
    ("p01", "sylvestre", "residence", ("g", 1)),
    ("p02", "sylvestre", "scierie_1", ("all",)),
    ("p03", "sylvestre", "mine_1", ("all",)),
    ("p04", "sylvestre", "tannerie_1", ("g", 0)),
    ("p04", "sylvestre", "tannerie_2", ("g", 1)),
    ("p04", "sylvestre", "tannerie_3", ("g", 2)),
    ("p05", "sylvestre", "cabane_1", ("c", 0, (430, 695))),
    ("p05", "sylvestre", "cabane_2", ("c", 1, (430, 695))),
    ("p05", "sylvestre", "cabane_3", ("c", 2, (430, 695))),
    ("p06", "sylvestre", "verger_1", ("box", 0, 430, 350, 725)),
    ("p06", "sylvestre", "verger_2", ("box", 350, 430, 760, 725)),
    ("p06", "sylvestre", "verger_3", ("box", 0, 40, 1024, 445)),
    ("p07", "sylvestre", "muraille_1", ("box", 0, 0, 1024, 250)),
    ("p07", "sylvestre", "muraille_3", ("box", 0, 268, 1024, 502)),
    ("p08", "sylvestre", "merveille", ("all",)),
    # ── Montagne (nation « cimes », planches hivernales) ──
    ("p10", "cimes", "hall_1", ("c", 0, (235, 430, 640))),
    ("p10", "cimes", "hall_2", ("c", 1, (235, 430, 640))),
    ("p10", "cimes", "hall_3", ("c", 2, (235, 430, 640))),
    ("p10", "cimes", "hall_4", ("c", 3, (235, 430, 640))),
    ("p11", "cimes", "hall_5", ("g", 0)),
    ("p13", "cimes", "caserne", ("all",)),
    ("p11", "cimes", "residence", ("g", 1)),
    ("p12", "cimes", "scierie_1", ("g", 0)),
    ("p12", "cimes", "mine_1", ("g", 2)),
    ("p14", "cimes", "tannerie_1", ("c", 0, (340, 660))),
    ("p14", "cimes", "tannerie_2", ("c", 1, (340, 660))),
    ("p14", "cimes", "tannerie_3", ("c", 2, (340, 660))),
    ("p15", "cimes", "cabane_1", ("g", 0)),
    ("p15", "cimes", "cabane_2", ("g", 1)),
    ("p15", "cimes", "cabane_3", ("g", 2)),
    ("p16", "cimes", "verger_1", ("all",)),
]

# Planches estivales : les îlots blancs entre deux pièces (ombres lessivées) sont supprimés.
SUMMER = {"p%02d" % i for i in range(1, 10)}
# Largeur relative (fraction de la toile) imposée aux niveaux d'un bâtiment dont les dessins de
# départ n'ont pas la même échelle (l'hôtel de ville des Cimes passe du hameau à la forteresse).
GROW = {("cimes", "hall"): {1: 0.50, 2: 0.60, 3: 0.72, 4: 0.86, 5: 1.0}}

# Fichiers dont la toile est partagée avec leurs « frères » (même bâtiment, niveaux différents).
def set_of(name):
    return name.rsplit("_", 1)[0] if name.rsplit("_", 1)[-1].isdigit() else name


def load(path):
    a = np.array(Image.open(path).convert("RGB")).astype(np.int16)
    light = a.mean(axis=2) > 30                      # barres noires de la planche p14
    rows = np.where(light.mean(axis=1) > 0.25)[0]
    cols = np.where(light.mean(axis=0) > 0.25)[0]
    return a[rows[0]:rows[-1] + 1, cols[0]:cols[-1] + 1]


def background(a):
    """Fond blanc ou gris à dégradé relié au bord de l'image."""
    border = np.concatenate([a[0], a[-1], a[:, 0], a[:, -1]])
    med = np.median(border, axis=0)
    sat = a.max(axis=2) - a.min(axis=2)
    # chroma vert V65 (#00B140) : très saturé, canal G dominant
    if med[1] > 120 and med[1] > med[0] * 1.4 and med[1] > med[2] * 1.2:
        cand = (np.abs(a[:, :, 1].astype(int) - int(med[1])) < 45) & \
               (np.abs(a[:, :, 0].astype(int) - int(med[0])) < 60) & \
               (np.abs(a[:, :, 2].astype(int) - int(med[2])) < 60)
        lab, _ = ndi.label(cand)
        edge = set(np.unique(np.concatenate([lab[0], lab[-1], lab[:, 0], lab[:, -1]]))) - {0}
        return np.isin(lab, list(edge))
    if med.min() > 235:
        cand = (np.abs(a - med).max(axis=2) < 34) & (sat < 26)
    else:
        cand = (np.abs(a.mean(axis=2) - med.mean()) < 38) & (sat < 22)
    lab, _ = ndi.label(cand)
    edge = set(np.unique(np.concatenate([lab[0], lab[-1], lab[:, 0], lab[:, -1]]))) - {0}
    return np.isin(lab, list(edge))


def strip_chroma(rgba):
    """Supprime le fond chroma vert #00B140 résiduel (pixels très verts, canal G dominant)."""
    r = rgba[..., 0].astype(np.int16); g = rgba[..., 1].astype(np.int16); b = rgba[..., 2].astype(np.int16)
    green = (g > 100) & (g > r + 30) & (g > b + 20) & (rgba[..., 3] > 8)
    out = rgba.copy()
    out[..., 3] = np.where(green, 0, out[..., 3])
    return out


def strip_ground_shadow(rgba, fg):
    """Supprime l'ombre portée au sol sous un bâtiment : pixels grisâtres sombres, peu saturés,
    dans la partie basse de la case et reliés au pied du bâtiment."""
    a = rgba[..., :3].astype(np.float32)
    alpha = rgba[..., 3]
    lum = a.mean(axis=2)
    sat = (a.max(axis=2) - a.min(axis=2)) / np.maximum(a.max(axis=2), 1)
    shadowish = (lum > 60) & (lum < 200) & (sat < 0.18) & (alpha > 40)
    # seulement dans le tiers inférieur de l'image
    h = rgba.shape[0]
    mask = np.zeros_like(shadowish)
    mask[int(h * 0.62):, :] = shadowish[int(h * 0.62):, :]
    # ne garder que les composantes reliées au bas (l'ombre touche le bas de la case)
    lab, n = ndi.label(mask)
    if n == 0:
        return rgba
    bottom = set(np.unique(lab[-1, :])) - {0}
    keep = np.isin(lab, list(bottom))
    out = rgba.copy()
    out[..., 3] = np.where(keep, 0, out[..., 3])
    return out


def cut_out(a, summer=False, min_blob=100):
    bg = background(a)
    forced = np.zeros_like(bg)
    if summer:      # îlots blancs : très clairs, sans teinte, entourés de fond
        lum = a.mean(axis=2)
        white = (lum > 222) & ((a.max(axis=2) - a.min(axis=2)) < 22)
        lab, n = ndi.label(white)
        big = [i + 1 for i, sz in enumerate(ndi.sum(white, lab, range(1, n + 1))) if sz > min_blob]
        forced = np.isin(lab, big)
        bg = bg | forced
    fg = ndi.binary_opening(~bg, iterations=1)
    lab, n = ndi.label(fg)
    sizes = ndi.sum(fg, lab, range(1, n + 1))
    fg = ndi.binary_fill_holes(np.isin(lab, [i + 1 for i, s in enumerate(sizes) if s > 400])) & ~forced
    alpha = np.clip((ndi.gaussian_filter(fg.astype(np.float32), 0.8) - 0.25) / 0.6, 0, 1)
    rgba = np.dstack([a.clip(0, 255).astype(np.uint8), (alpha * 255).astype(np.uint8)])
    return rgba, fg


def groups(fg):
    lab, _ = ndi.label(ndi.binary_dilation(fg, iterations=5))
    res = []
    for i, sl in enumerate(ndi.find_objects(lab)):
        if (fg[sl] & (lab[sl] == i + 1)).sum() >= 4000:
            res.append((sl[1].start, sl[0].start, sl[1].stop, sl[0].stop))
    return sorted(res)


def main_part(fg, keep_ratio=0.12):
    """Garde les ensembles de pixels assez gros par rapport au plus gros (supprime les débris)."""
    lab, n = ndi.label(ndi.binary_dilation(fg, iterations=4))
    sizes = ndi.sum(fg, lab, range(1, n + 1))
    good = [i + 1 for i, sz in enumerate(sizes) if sz >= keep_ratio * max(sizes)]
    return fg & np.isin(lab, good)


def snap_cuts(fg, hints, window=45):
    """Place chaque coupure verticale là où l'image est la plus vide, près de l'indication."""
    cover = fg.sum(axis=0)
    cuts = []
    for h in hints:
        lo, hi = max(h - window, 1), min(h + window, fg.shape[1] - 1)
        cuts.append(lo + int(np.argmin(cover[lo:hi])))
    return cuts


def crop(rgba, fg, how):
    if how[0] == "c":
        xs = [0] + snap_cuts(fg, how[2]) + [rgba.shape[1]]
        box = (xs[how[1]], 0, xs[how[1] + 1], rgba.shape[0])
    elif how[0] == "all":
        box = (0, 0, rgba.shape[1], rgba.shape[0])
    elif how[0] == "box":
        box = how[1:]
    else:
        box = groups(fg)[how[1]]
    x0, y0, x1, y1 = box
    sub = rgba[y0:y1, x0:x1].copy()
    keep = main_part(sub[..., 3] > 8)
    sub[..., 3] = np.where(keep, sub[..., 3], 0)
    ys, xs = np.where(sub[..., 3] > 8)
    return Image.fromarray(sub[ys.min():ys.max() + 1, xs.min():xs.max() + 1], "RGBA")



# ── Mode V65 : 1 bâtiment par image, 5 niveaux en ligne ─────────
# MANIFEST_V65 : (planche, nation, bâtiment, emprise) — la planche est découpée en 5 cases
# horizontales égales (niveau 1 à gauche → 5 à droite) ; merveille = 1 case entière.
MANIFEST_V65 = [
    # nation, bâtiment, emprise (3x3 ou 2x2) — la planche se découpe seule en 5 cases égales
]
V65_BUILDINGS_5 = ["hall", "caserne", "residence", "scierie", "mine", "tannerie", "cabane", "verger", "muraille"]
V65_EMPRISE = {"hall": 3, "caserne": 2, "residence": 2, "scierie": 2, "mine": 3, "tannerie": 2,
               "cabane": 2, "verger": 3, "muraille": 3, "merveille": 3}


def crop_v65(rgba, fg, building, cells=5, inset=0.06):
    """Découpe V65 : coupe verticale au point le plus vide de chaque cinquième de la planche,
    puis ne garde que la composante du bas-centre de chaque tranche (le bâtiment et son socle).
    Robuste aux bâtiments qui se touchent. `inset` : marge de sécurité sur les bords de coupe."""
    w = rgba.shape[1]
    prof = fg.sum(axis=0)
    bounds = [0]
    for i in range(1, cells):
        lo = max(bounds[-1] + 4, w * i // cells - int(w * 0.10))
        hi = min(w - 4, w * i // cells + int(w * 0.10))
        bounds.append(lo + int(np.argmin(prof[lo:hi])))
    bounds.append(w)
    out = []
    for i in range(cells):
        a, b = bounds[i], bounds[i + 1] - 1
        m = max(2, int((b - a + 1) * inset))
        x0, x1 = a + m, b - m + 1
        sub = rgba[:, x0:x1].copy()
        subfg = fg[:, x0:x1]
        # labellise SANS dilation : on veut les vraies composantes séparées
        lab, n = ndi.label(subfg)
        if n:
            sizes = ndi.sum(subfg, lab, range(1, n + 1))
            objs = ndi.find_objects(lab)
            h0 = subfg.shape[0]
            cx = subfg.shape[1] / 2.0
            # best = composante qui touche le bas de la tranche (pied), la plus grosse, la plus centrée
            def score(j):
                sl = objs[j]
                touches_bottom = sl[0].stop >= h0 * 0.55
                return (sizes[j] if touches_bottom else 0) - abs((sl[1].start + sl[1].stop) / 2.0 - cx) * 3.0
            best = max(range(n), key=score)
            bs = objs[best]
            bw = bs[1].stop - bs[1].start
            ok = [best + 1]
            for j in range(n):
                if j == best:
                    continue
                sl = objs[j]
                # socle/pied légitime : touche best ET chevauche best horizontalement sur >50%
                overlap = min(sl[1].stop, bs[1].stop) - max(sl[1].start, bs[1].start)
                near = ndi.binary_dilation(lab == best + 1, iterations=12)
                if overlap > bw * 0.5 and lab[near & (lab == j + 1)].any():
                    ok.append(j + 1)
            keep = np.isin(lab, ok)
        else:
            keep = subfg
        sub[..., 3] = np.where(keep, sub[..., 3], 0)
        ys, xs = np.where(sub[..., 3] > 8)
        if len(ys) == 0:
            out.append(Image.new("RGBA", (8, 8), (0, 0, 0, 0)))
            continue
        out.append(Image.fromarray(sub[:, xs.min():xs.max() + 1], "RGBA"))
    return out


def run_v65(sheets_dir, only=None):
    """Découpe les planches V65 (planches/<nation>/<batiment>.png) en sprites <batiment>_<n>.png."""
    nations = [d for d in os.listdir(os.path.join(sheets_dir, "planches")) if os.path.isdir(os.path.join(sheets_dir, "planches", d))]
    for nation in nations:
        if only and nation != only:
            continue
        pdir = os.path.join(sheets_dir, "planches", nation)
        for fname in sorted(os.listdir(pdir)):
            if not fname.endswith((".png", ".jpg")):
                continue
            building = fname.rsplit(".", 1)[0]
            if building.startswith(nation + "_"):
                building = building[len(nation) + 1:]
            a = load(os.path.join(pdir, fname))
            rgba, fg = cut_out(a, summer=False)
            rgba = strip_ground_shadow(rgba, fg)
            rgba = strip_chroma(rgba)
            fg = rgba[..., 3] > 8
            cells = 1 if building == "merveille" else 5
            pieces = crop_v65(rgba, fg, building, cells)
            # recadre chaque case sur son contenu visible (enlève le halo résiduel)
            trimmed = []
            for im in pieces:
                bb = im.getbbox()
                trimmed.append(im.crop(bb) if bb else im)
            pieces = trimmed
            # repli de niveau vide : case quasi vide (<3000 px) -> copie du niveau le plus proche non vide
            if cells > 1:
                sizes = [int((np.array(im)[..., 3] > 8).sum()) for im in pieces]
                for i, s in enumerate(sizes):
                    if s < 3000:
                        cand = [j for j in range(cells) if sizes[j] >= 3000]
                        if cand:
                            j = min(cand, key=lambda jj: abs(jj - i))
                            pieces[i] = pieces[j].copy()
                            print("  repli niveau %d <- %d (%s)" % (i + 1, j + 1, building))
            # le pied (bas du contenu) doit rester le même dans toutes les cases : on ancre tout en bas de la toile commune
            k = min(1.25, TARGET_W.get(building, 480) / max(max(im.width for im in pieces), 1))
            w = max(1, round(max(im.width for im in pieces) * k))
            h = max(1, round(max(im.height for im in pieces) * k))
            # borne la hauteur : un artefact vertical isolé ne doit pas gonfler la toile
            med_h = sorted(im.height for im in pieces)[len(pieces) // 2]
            if h > med_h * k * 1.6:
                h = max(1, round(med_h * k * 1.6))
            d = os.path.join(OUT_ROOT, nation)
            os.makedirs(d, exist_ok=True)
            for i, im in enumerate(pieces):
                canvas = Image.new("RGBA", (w, h), (0, 0, 0, 0))
                sim = im.resize((max(1, round(im.width * k)), max(1, round(im.height * k))), Image.LANCZOS) if abs(k - 1.0) > 0.01 else im
                canvas.alpha_composite(sim, ((w - sim.width) // 2, h - sim.height))
                if cells == 1:
                    out_name = building + ".png"
                else:
                    out_name = "%s_%d.png" % (building, i + 1)
                if out_name.startswith(nation + "_"):
                    out_name = out_name[len(nation) + 1:]
                canvas.save(os.path.join(d, out_name), optimize=True)
                print("%-10s %-14s %dx%d" % (nation, out_name, canvas.width, canvas.height))


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("sheets", nargs="?", default=None)
    ap.add_argument("--only")
    ap.add_argument("--v65", action="store_true", help="mode V65 : planches/<nation>/<batiment>.png (5 niveaux en ligne)")
    args = ap.parse_args()
    if args.v65:
        run_v65(args.sheets or ".", only=args.only)
        return
    cache = {}
    pieces = {}      # (nation, fichier) -> image
    for sheet, nation, name, how in MANIFEST:
        if args.only and nation != args.only:
            continue
        if sheet not in cache:
            a = load(os.path.join(args.sheets, sheet + ".jpg"))
            cache[sheet] = cut_out(a, sheet in SUMMER, 12 if sheet == "p07" else 100)
        rgba, fg = cache[sheet]
        pieces[(nation, name)] = crop(rgba, fg, how)
    # Toile commune par (nation, bâtiment) ; hall_x et caserne/résidence restent indépendants.
    sets = {}
    for (nation, name), im in pieces.items():
        sets.setdefault((nation, set_of(name)), []).append((name, im))
    for (nation, base), items in sets.items():
        grow = GROW.get((nation, base))
        if grow:
            wmax = max(im.width for _, im in items)
            items = [(nm, im.resize((round(wmax * grow[int(nm.rsplit("_", 1)[1])]),
                                     round(im.height * wmax * grow[int(nm.rsplit("_", 1)[1])] / im.width)), Image.LANCZOS))
                     for nm, im in items]
        w = max(im.width for _, im in items)
        h = max(im.height for _, im in items)
        k = min(1.25, TARGET_W.get(base, 480) / w)
        for name, im in items:
            canvas = Image.new("RGBA", (w, h), (0, 0, 0, 0))
            canvas.alpha_composite(im, ((w - im.width) // 2, h - im.height))
            if abs(k - 1.0) > 0.01:
                canvas = canvas.resize((round(w * k), round(h * k)), Image.LANCZOS)
            d = os.path.join(OUT_ROOT, nation)
            os.makedirs(d, exist_ok=True)
            canvas.save(os.path.join(d, name + ".png"), optimize=True)
            print("%-10s %-14s %dx%d" % (nation, name, canvas.width, canvas.height))


if __name__ == "__main__":
    sys.exit(main())
