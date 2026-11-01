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
V65_EMPRISE = {"hall": 3, "caserne": 2, "residence": 2, "scierie": 2, "mine": 3, "tannerie": 2,
               "cabane": 2, "verger": 3, "muraille": 3, "merveille": 3}
V65_BUILDINGS = ["hall", "caserne", "residence", "scierie", "mine", "tannerie", "cabane", "verger", "muraille", "merveille"]

# Planches V65 à découper : (nation, bâtiment) -> mise en page. "row5" = 5 niveaux en rangée (de gauche à
# droite), "single" = un seul dessin. Tout ce qui n'est pas listé (grilles, 3-4 niveaux, ensemble unique,
# texte dans l'image…) est À REPRENDRE par Mistral : voir RETOUR_MISTRAL_V65.md.
LAYOUT_V65 = {
    ("brasier", "hall"): "row5",
    ("brasier", "scierie"): "row5", ("brasier", "cabane"): "row5", ("brasier", "merveille"): "single",
    ("brumes", "caserne"): "row5", ("brumes", "merveille"): "single",
    ("cristaux", "hall"): "row5", ("cristaux", "residence"): "row5", ("cristaux", "scierie"): "row5",
    ("cristaux", "muraille"): "row5", ("cristaux", "merveille"): "single",
    ("marees", "merveille"): "single",
    ("ombres", "hall"): "row5", ("ombres", "merveille"): "single",
    ("rouages", "residence"): "row5", ("rouages", "mine"): "row5", ("rouages", "muraille"): "row5",
    ("rouages", "merveille"): "single",
    ("sables", "merveille"): "single",
    ("vents", "merveille"): "single",
}
# Planches rangées sur 5 niveaux MAIS dont les socles (losanges au sol) se touchent ou se chevauchent :
# toute coupure verticale entame le sol d'un bâtiment voisin. Non livrées → à espacer chez Mistral.
SOCLES_COLLES = [("brasier", "caserne"), ("brasier", "tannerie"), ("brumes", "tannerie"), ("brumes", "verger"),
                 ("cristaux", "tannerie"), ("ombres", "caserne"), ("ombres", "tannerie"), ("rouages", "caserne"),
                 ("vents", "caserne"), ("vents", "cabane"), ("sables", "verger"), ("vents", "scierie")]
# Fond vert de même teinte que le dessin (feuillage, herbe) : détourage impossible sans abîmer le sprite.
FOND_CONFONDU = [("vents", "verger"), ("vents", "residence")]


def load_v65(path):
    """Ouvre une planche : retire bandeaux noirs et marges de texte en haut/bas."""
    a = np.array(Image.open(path).convert("RGB")).astype(np.int16)
    dark = a.mean(axis=2) < 40
    rows = np.where(dark.mean(axis=1) < 0.55)[0]       # une ligne presque toute noire = bandeau
    cols = np.where(dark.mean(axis=0) < 0.55)[0]
    a = a[rows[0]:rows[-1] + 1, cols[0]:cols[-1] + 1]
    # bandeau noir en haut contenant du texte clair : on coupe jusqu'à la dernière ligne sombre du bandeau
    top = a[: a.shape[0] // 4]
    band = np.where((top.mean(axis=2) < 40).mean(axis=1) > 0.6)[0]
    if len(band):
        a = a[band.max() + 1:]
    return a


def background_v65(a, grad_max=9.0):
    """Fond = pixels reliés au bord, de couleur proche de celle du bord ET sans arête franche
    (fond uni, dégradé ou ombre douce) ; un contour de bâtiment arrête toujours l'extension."""
    h, w, _ = a.shape
    sm = np.stack([ndi.gaussian_filter(a[..., c].astype(np.float32), 1.0) for c in range(3)], axis=2)
    band = np.concatenate([a[:6].reshape(-1, 3), a[-6:].reshape(-1, 3), a[:, :6].reshape(-1, 3), a[:, -6:].reshape(-1, 3)])
    med = np.median(band, axis=0)
    dist = np.abs(sm - med).max(axis=2)
    grad = np.zeros((h, w), np.float32)
    for c in range(3):
        grad = np.maximum(grad, np.hypot(ndi.sobel(sm[..., c], 0), ndi.sobel(sm[..., c], 1)) / 8.0)
    cand = (grad < grad_max) & (dist < 85)
    lab, _ = ndi.label(cand)
    edge = set(np.unique(np.concatenate([lab[0], lab[-1], lab[:, 0], lab[:, -1]]))) - {0}
    return np.isin(lab, list(edge))


# Réglages propres à une planche : seuil d'arête du fond (plus bas = le fond ne mange pas les surfaces
# claires), suppression des résidus du fond chroma vert.
TUNE_V65 = {("sables", "merveille"): {"grad": 3.5}, ("vents", "merveille"): {"grad": 5.0, "chroma": True},
            ("vents", "residence"): {"chroma": True},
            ("vents", "scierie"): {"chroma": True}}


def cutout_v65(a, tune=None):
    tune = tune or {}
    fg = ~background_v65(a, tune.get("grad", 9.0))
    if tune.get("chroma"):      # résidus du vert de fond : vert clair vif, jamais présent dans les dessins
        r, g, b = a[..., 0], a[..., 1], a[..., 2]
        fg &= ~((g > 170) & (g > r + 35) & (g > b + 35))
    fg = ndi.binary_opening(fg, iterations=1)
    lab, n = ndi.label(fg)
    sizes = ndi.sum(fg, lab, range(1, n + 1))
    fg = np.isin(lab, [i + 1 for i, sz in enumerate(sizes) if sz > 600])       # texte, poussières
    fg = ndi.binary_fill_holes(fg)
    alpha = np.clip((ndi.gaussian_filter(fg.astype(np.float32), 0.8) - 0.25) / 0.6, 0, 1)
    rgba = np.dstack([a.clip(0, 255).astype(np.uint8), (alpha * 255).astype(np.uint8)])
    return rgba, fg


def split_row(fg, n=5):
    """Sépare n bâtiments alignés de gauche à droite. Renvoie (masques, qualité) :
    ensembles distincts s'ils le sont, sinon coupures verticales placées aux creux de la silhouette."""
    lab, m = ndi.label(ndi.binary_dilation(fg, iterations=3))
    sizes = np.array(ndi.sum(fg, lab, range(1, m + 1)))
    big = [i + 1 for i, sz in enumerate(sizes) if sz > 0.03 * fg.sum()]
    if len(big) == n:
        cx = [ndi.center_of_mass(lab == i)[1] for i in big]
        order = [big[i] for i in np.argsort(cx)]
        return [fg & (lab == i) for i in order], "séparés"
    cover = ndi.uniform_filter1d(fg.sum(axis=0).astype(np.float32), 9)
    xs = np.where(fg.any(axis=0))[0]
    x0, x1 = xs.min(), xs.max()
    cuts = [x0 + (x1 - x0) * k / n for k in range(1, n)]
    for _ in range(12):                       # k-means 1D pondéré par la silhouette
        bounds = [x0] + cuts + [x1]
        cent = []
        for i in range(n):
            seg = cover[int(bounds[i]):int(bounds[i + 1]) + 1]
            idx = np.arange(int(bounds[i]), int(bounds[i]) + len(seg))
            cent.append((seg * idx).sum() / max(seg.sum(), 1))
        cuts = [(cent[i] + cent[i + 1]) / 2 for i in range(n - 1)]
    snapped, worst = [], 0.0
    win = int((x1 - x0) * 0.05)
    peak = cover.max()
    for c in cuts:
        lo, hi = max(int(c) - win, x0 + 1), min(int(c) + win, x1 - 1)
        j = lo + int(np.argmin(cover[lo:hi]))
        snapped.append(j)
        worst = max(worst, cover[j] / peak)
    bounds = [x0] + snapped + [x1 + 1]
    masks = []
    for i in range(n):
        m_i = np.zeros_like(fg)
        m_i[:, bounds[i]:bounds[i + 1]] = fg[:, bounds[i]:bounds[i + 1]]
        masks.append(m_i)
    return masks, ("coupures (creux à %d %%)" % round(100 * worst))


def defringe(rgba, keep):
    """Retire le liseré de bord : contour blanc d'autocollant et frange verte du fond chroma."""
    inner = ndi.binary_erosion(keep, iterations=3)
    band = keep & ~inner
    r = rgba[..., 0].astype(np.int16); g = rgba[..., 1].astype(np.int16); b = rgba[..., 2].astype(np.int16)
    sat = np.maximum(np.maximum(r, g), b) - np.minimum(np.minimum(r, g), b)
    green = (g > r + 18) & (g > b + 18)
    white = ((r + g + b) / 3 > 232) & (sat < 24)
    out = keep & ~(band & (green | white))
    return ndi.binary_erosion(out, iterations=1) | (out & inner)


def piece_from_mask(rgba, mask):
    mask = defringe(rgba, mask)
    keep = main_part(mask, 0.15)
    sub = rgba.copy()
    soft = ndi.gaussian_filter(keep.astype(np.float32), 0.8)
    sub[..., 3] = (np.clip((soft - 0.25) / 0.6, 0, 1) * 255).astype(np.uint8)
    ys, xs = np.where(keep)
    return Image.fromarray(sub[ys.min():ys.max() + 1, xs.min():xs.max() + 1], "RGBA")


def run_v65(sheets_dir, only=None, report=None):
    """Découpe les planches V65 (planches/<nation>/<batiment>.jpg) en <bâtiment>_<niveau>.png (toile commune)."""
    log = []
    # toute planche présente dans planches/<nation>/ est traitée : row5 par défaut, single pour merveille
    pdir_root = os.path.join(sheets_dir, "planches")
    if os.path.isdir(pdir_root):
        for nation in sorted(os.listdir(pdir_root)):
            if only and nation != only:
                continue
            nd = os.path.join(pdir_root, nation)
            if not os.path.isdir(nd):
                continue
            for f in sorted(os.listdir(nd)):
                if not f.endswith((".png", ".jpg")):
                    continue
                b = f.rsplit(".", 1)[0]
                if b.startswith(nation + "_"):
                    b = b[len(nation) + 1:]
                LAYOUT_V65.setdefault((nation, b), "single" if b == "merveille" else "row5")
    for (nation, building), layout in sorted(LAYOUT_V65.items()):
        if only and nation != only:
            continue
        pdir = os.path.join(sheets_dir, "planches", nation)
        src = next((os.path.join(pdir, f) for f in os.listdir(pdir) if f.rsplit(".", 1)[0] in (building, "%s_%s" % (nation, building))), None)
        if src is None:
            log.append((nation, building, "planche absente"))
            continue
        a = load_v65(src)
        rgba, fg = cutout_v65(a, TUNE_V65.get((nation, building)))
        if layout == "single":
            pieces, how = [piece_from_mask(rgba, fg)], "unique"
        else:
            masks, how = split_row(fg, 5)
            pieces = [piece_from_mask(rgba, m) for m in masks]
        k = min(1.25, TARGET_W.get(building, 480) / max(max(im.width for im in pieces), 1))
        w = max(1, round(max(im.width for im in pieces) * k))
        h = max(1, round(max(im.height for im in pieces) * k))
        d = os.path.join(OUT_ROOT, nation)
        os.makedirs(d, exist_ok=True)
        for i, im in enumerate(pieces):
            canvas = Image.new("RGBA", (w, h), (0, 0, 0, 0))
            sim = im.resize((max(1, round(im.width * k)), max(1, round(im.height * k))), Image.LANCZOS)
            canvas.alpha_composite(sim, ((w - sim.width) // 2, h - sim.height))
            name = building + ".png" if layout == "single" else "%s_%d.png" % (building, i + 1)
            canvas.save(os.path.join(d, name), optimize=True)
        log.append((nation, building, how))
        print("%-10s %-10s %s  %dx%d" % (nation, building, how, w, h))
    return log


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
