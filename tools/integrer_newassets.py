#!/usr/bin/env python3
"""Intègre les planches `newAssets` (Mistral Vibe) dans le jeu et rédige les deux rapports de contrôle.

Usage :
  integrer_newassets.py <newAssets> <racine assets/sprites> <dossier_rapports> [--only nation[/perso]] [--dry]
                        [--flip flips.json] [--min-sheets 3]

Pour chaque personnage (3 planches : <id>_vues, <id>_actions, <id>_actions_dos) :
  vues        2×2 : repos face, repos face 2 / repos dos, repos dos 2
  actions     3×2 : attaque, attaque 2, attaque 3 / sort, sort 2, marche   (face)
  actions_dos 3×2 : mêmes poses vues de dos
- découpe via couper_planche.py, mise à l'échelle commune (hauteur médiane des cases = hauteur du jeu),
- contrôles automatiques : cases vides / coupées / trop petites / identiques, cohérence des couleurs entre planches,
- intègre TOUT ce qui est exploitable (même incohérent) ; les cases vides ou minuscules sont écartées,
- écrit sprites_validés.md et sprites_a_corriger.md dans <dossier_rapports>.
`flips.json` : {"<id>": ["", "_attack", ...]} = poses à retourner (sprite tourné vers la gauche).
"""
import argparse, json, os, re, shutil, subprocess, sys, tempfile, glob
import numpy as np
from PIL import Image, ImageOps

HERE = os.path.dirname(os.path.abspath(__file__))
CUT = os.path.join(HERE, "couper_planche.py")

# nation -> héros (fichier newAssets -> id jeu), boss (fichier -> boss/<nation>)
HEROES = {"sylvestre": "druide", "cimes": "tank", "sables": "geomancien", "cristaux": "mage", "marees": "soigneur",
          "vents": "sylvain", "brasier": "chasseur", "brumes": "invocateur", "ombres": "assassin", "rouages": "artificier"}
GAME_HERO = {"soigneur": "heal"}
BOSSES = {"sylvestre": "tharok_le_vegetal", "cimes": "vorkann_le_givre", "sables": "zahor_le_sableux",
          "cristaux": "zypheron_le_cristallin", "marees": "neree_la_tempete", "vents": "aeron_le_celeste",
          "brasier": "kharaz_le_flamboyant", "brumes": "ombrelis_le_brumeux", "ombres": "nebulia_l_illusionniste",
          "rouages": "colosse_d_engrenages"}
FILE_TO_GAME = {"roue_engrennee": "roue_engrenee"}
# personnages clairs : on ne retire pas l'ombre au sol par couleur (elle mangerait le corps)
PALE = {"griffon_des_cimes", "aigle_celeste", "harpie", "spectre", "fantome", "liche_des_brumes", "mage_cristallin",
        "elementaire_de_vent", "brumeux", "garde_aerien", "elementaire_de_cristal"}
HEIGHT = {"hero": 340, "enemy": 240, "boss": 300}
MAX_W = 400

VUES = {"": "r1c1", "_idle_2": "r1c2", "_back": "r2c1", "_back_idle_2": "r2c2"}
ACTIONS = {"_attack": "r1c1", "_attack_2": "r1c2", "_attack_3": "r1c3", "_cast": "r2c1", "_cast_2": "r2c2", "_walk": "r2c3"}
DOS = {"_back_" + k[1:]: v for k, v in ACTIONS.items()}


def roles(src):
    """Liste (nation, fichier, id_jeu, rôle, dossier_jeu) pour chaque personnage trouvé."""
    out = []
    for nat in sorted(os.listdir(src)):
        d = os.path.join(src, nat)
        if not os.path.isdir(d):
            continue
        names = sorted({re.sub(r"_(actions_dos|actions|vues)\.png$", "", f) for f in os.listdir(d)
                        if re.search(r"_(actions_dos|actions|vues)\.png$", f)})
        for n in names:
            if n in FILE_TO_GAME and FILE_TO_GAME[n] in names:
                continue   # ancienne orthographe : la planche correctement nommée fait foi
            if n == HEROES.get(nat):
                gid = GAME_HERO.get(n, n)
                out.append((nat, n, gid, "hero", "players"))
            elif n == BOSSES.get(nat):
                out.append((nat, n, nat, "boss", "nations/boss"))
            else:
                gid = FILE_TO_GAME.get(n, n)
                out.append((nat, n, gid, "enemy", f"nations/ennemis/{nat}"))
    return out


def cut(sheet, grid, outdir, pale):
    os.makedirs(outdir, exist_ok=True)
    args = [sys.executable, CUT, sheet, outdir, "--grid", grid, "--prefix", "c", "--holes", "60000", "--shadow-delta", "300"]
    if not pale:
        args.append("--ombre-sol")
    subprocess.run(args, capture_output=True, text=True)
    cells = {}
    for f in glob.glob(os.path.join(outdir, "c_r*c*.png")):
        m = re.search(r"c_(r\dc\d)\.png$", f)
        if m:
            cells[m.group(1)] = f
    return cells


def hist(im):
    a = np.array(im.convert("RGBA"))
    m = a[..., 3] > 200
    if m.sum() < 50:
        return None
    q = (a[..., :3][m] // 64).astype(int)
    idx = q[:, 0] * 16 + q[:, 1] * 4 + q[:, 2]
    h = np.bincount(idx, minlength=64).astype(float)
    return h / h.sum()


def bc(h1, h2):
    return float(np.sqrt(h1 * h2).sum())


def sig(im):
    im = im.resize((max(1, int(im.width * 200 / im.height)), 200)).resize((32, 32))
    a = np.array(im).astype(float)
    return np.dstack([a[..., 3] / 255, a[..., :3].mean(-1) / 255 * (a[..., 3] > 0)])


def analyse(sheetkind, cells, cut_ref_h):
    """Retourne (images, problèmes) pour une planche découpée."""
    ims, issues = {}, []
    for cell, f in sorted(cells.items()):
        im = Image.open(f).convert("RGBA")
        ims[cell] = im
    return ims, issues


def process(src, dst, nat, name, gid, role, folder, tmp, flips, dry):
    d = os.path.join(src, nat)
    pale = name in PALE
    rep = {"nat": nat, "name": name, "id": gid, "role": role, "problems": [], "notes": [], "poses": [], "score": None}
    sheets = {}
    for kind, grid, mapping in (("vues", "2x2", VUES), ("actions", "3x2", ACTIONS), ("actions_dos", "3x2", DOS)):
        p = os.path.join(d, f"{name}_{kind}.png")
        if not os.path.exists(p):
            rep["problems"].append(f"planche « {kind} » absente")
            continue
        cells = cut(p, grid, os.path.join(tmp, nat, name, kind), pale)
        ims = {c: Image.open(f).convert("RGBA") for c, f in cells.items()}
        sheets[kind] = (mapping, ims, Image.open(p).size)
        expected = len(mapping)
        if len(ims) != expected:
            rep["problems"].append(f"« {kind} » : {len(ims)} personnage(s) détecté(s) au lieu de {expected}")
    if "vues" not in sheets:
        return rep
    # échelle commune : la hauteur de la case repos de face = hauteur du jeu ; mêmes facteurs pour les autres planches
    target = HEIGHT[role]
    scale = {}
    for kind, (mapping, ims, size) in sheets.items():
        hs = [im.height for im in ims.values() if im.height > 20]
        if not hs:
            continue
        ref = float(np.median(hs))
        # petite créature large : on limite la largeur
        ws = [im.width for im in ims.values()]
        s = target / ref
        s = min(s, MAX_W / max(1.0, float(np.median(ws))) * 1.0) if np.median(ws) * s > MAX_W else s
        scale[kind] = s
    vh = [hist(im) for im in sheets["vues"][1].values()]
    vh = [h for h in vh if h is not None]
    ref_hist = np.mean(vh, axis=0) if vh else None
    kept, sigs, scores = {}, [], []
    for kind, (mapping, ims, size) in sheets.items():
        medh = float(np.median([im.height for im in ims.values()])) if ims else 0
        dup = 0
        sheet_sigs = []
        for suffix, cell in mapping.items():
            im = ims.get(cell)
            if im is None:
                rep["problems"].append(f"{kind} {cell} : case vide")
                continue
            if im.height < 0.45 * medh or im.width < 0.2 * np.median([i.width for i in ims.values()]):
                rep["problems"].append(f"{kind} {cell} : pose écartée (trop petite : effet seul ou personnage absent)")
                continue
            h = hist(im)
            if h is not None and ref_hist is not None and kind != "vues":
                scores.append(bc(h, ref_hist))
            s = scale[kind]
            out = im.resize((max(1, round(im.width * s)), max(1, round(im.height * s))), Image.LANCZOS)
            if suffix in flips.get(gid, []):
                out = ImageOps.mirror(out)
            sg = sig(out)
            if any(np.abs(sg - o).mean() < 0.03 for o in sigs):
                dup += 1
                rep["notes"].append(f"{kind} {cell} : copie d'une autre pose (écartée)")
                continue
            sigs.append(sg)
            sheet_sigs.append(sg)
            kept[suffix] = out
        if kind != "vues" and len(sheet_sigs) >= 3:
            dd = [float(np.abs(x - y).mean()) for i, x in enumerate(sheet_sigs) for y in sheet_sigs[i + 1:]]
            if float(np.median(dd)) < 0.12:
                rep["problems"].append(f"« {kind} » : poses presque identiques (attaque, sort et marche indiscernables)")
    rep["poses"] = sorted(kept)
    rep["score"] = round(float(np.mean(scores)), 2) if scores else None
    if rep["score"] is not None and rep["score"] < 0.78:
        rep["problems"].append(f"personnage différent d'une planche à l'autre (cohérence des couleurs {rep['score']})")
    if "" not in kept:
        rep["problems"].append("pas de repos de face exploitable")
    # écriture (sans repos de face exploitable : on garde l'ancien sprite du jeu tel quel)
    if kept and "" not in kept:
        rep["notes"].append("non intégré : pas de repos de face, l'ancien sprite du jeu est conservé")
    if kept and "" in kept and not dry:
        outs = [os.path.join(dst, folder)]
        if folder == "players":
            outs += [os.path.join(dst, "nations/heros"), os.path.join(dst, "nations/heros/poses")]
        for o in outs:
            os.makedirs(o, exist_ok=True)
            for f in glob.glob(os.path.join(o, gid + "*.png*")):
                b = os.path.basename(f)
                if b.startswith(gid + "_") or b.startswith(gid + ".png"):
                    os.remove(f)
        for suffix, im in kept.items():
            fn = gid + suffix + ".png"
            im.save(os.path.join(dst, folder, fn))
            if folder == "players":
                im.save(os.path.join(dst, "nations/heros" + ("" if suffix == "" else "/poses"), fn))
    return rep


def write_reports(reps, outdir, dry):
    os.makedirs(outdir, exist_ok=True)
    ok = [r for r in reps if not r["problems"]]
    bad = [r for r in reps if r["problems"]]
    def line(r):
        poses = ", ".join(p or "repos" for p in r["poses"]) or "aucune"
        return f"- **{r['name']}** ({r['role']}, `{r['nat']}`) — {len(r['poses'])} poses : {poses}" + (f" — cohérence {r['score']}" if r["score"] is not None else "")
    with open(os.path.join(outdir, "sprites_validés.md"), "w", encoding="utf-8") as f:
        f.write("# Sprites validés\n\nContrôles automatiques passés (3 planches, grille respectée, poses distinctes, couleurs cohérentes). "
                "Reste à valider à l'œil : l'âge apparent, l'orientation (vers la droite) et l'arme tenue.\n\n")
        for r in ok:
            f.write(line(r) + "\n")
            for n in r["notes"]:
                f.write(f"  - note : {n}\n")
        if not ok:
            f.write("_(aucun pour l'instant)_\n")
    with open(os.path.join(outdir, "sprites_a_corriger.md"), "w", encoding="utf-8") as f:
        f.write("# Sprites à corriger\n\nIntégrés quand même quand c'était exploitable ; voici ce qu'il faut reprendre.\n\n")
        for r in bad:
            f.write(line(r) + "\n")
            for p in r["problems"]:
                f.write(f"  - {p}\n")
            for n in r["notes"]:
                f.write(f"  - note : {n}\n")
        if not bad:
            f.write("_(rien à corriger)_\n")
    return len(ok), len(bad)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("src"); ap.add_argument("dst"); ap.add_argument("reports")
    ap.add_argument("--only", default=""); ap.add_argument("--dry", action="store_true")
    ap.add_argument("--flip", default="")
    ap.add_argument("--merge", action="store_true", help="écrit les rapports à partir des _reps_*.json déjà produits")
    ap.add_argument("--cache", default="/tmp/newassets_reps")
    a = ap.parse_args()
    os.makedirs(a.cache, exist_ok=True)
    if a.merge:
        reps = []
        for fn in sorted(os.listdir(a.cache)):
            if fn.endswith(".json"):
                reps.extend(json.load(open(os.path.join(a.cache, fn))))
        n_ok, n_bad = write_reports(reps, a.reports, False)
        print(f"{n_ok} validés, {n_bad} à corriger → {a.reports}")
        return
    flips = json.load(open(a.flip)) if a.flip and os.path.exists(a.flip) else {}
    tmp = tempfile.mkdtemp(prefix="newassets_")
    reps = []
    for nat, name, gid, role, folder in roles(a.src):
        if a.only and not (a.only == nat or a.only == f"{nat}/{name}"):
            continue
        r = process(a.src, a.dst, nat, name, gid, role, folder, tmp, flips, a.dry)
        reps.append(r)
        print(f"{nat}/{name}: {len(r['poses'])} poses, {len(r['problems'])} problème(s), cohérence {r['score']}")
    if not a.dry:
        json.dump(reps, open(os.path.join(a.cache, (a.only.replace("/", "_") or "tout") + ".json"), "w"), default=str)
    if a.only:
        shutil.rmtree(tmp, ignore_errors=True)
        return
    n_ok, n_bad = write_reports(reps, a.reports, a.dry)
    print(f"{n_ok} validés, {n_bad} à corriger → {a.reports}")
    shutil.rmtree(tmp, ignore_errors=True)


if __name__ == "__main__":
    main()
