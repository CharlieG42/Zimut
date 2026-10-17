#!/usr/bin/env python3
"""Génère les données d'équilibrage V15 : niveaux héros 1..100, ennemis 1..150,
10 sorts par héros (3 au niveau 1, le reste débloqué jusqu'au niveau 100).

Principe : « étirement ×2 » de l'axe des niveaux. Un héros de niveau L vaut
l'ancien héros de niveau 1 + (L-1)*49/99 (interpolation linéaire) ; le capital
de points reste identique (2 points/niveau x 99 niveaux ≈ 4 x 49).
Usage : python3 tools/gen_balance_v15.py   (depuis prototype/zimut)
Idempotent : les sources d'origine sont lues dans data/_src_v14/ (créé au 1er run).
"""
import csv, os, shutil, math, re

ROOT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..")
DATA = os.path.join(ROOT, "data")
SRC = os.path.join(DATA, "_src_v14")
FILES = ["classes.txt", "sorts.txt", "progression_sorts.txt", "ennemis.txt", "stuff.txt", "craft.txt"]

if not os.path.isdir(SRC):
    os.makedirs(SRC)
    for f in FILES:
        shutil.copy(os.path.join(DATA, f), os.path.join(SRC, f))


def read(name):
    with open(os.path.join(SRC, name), encoding="utf-8", newline="") as fh:
        return list(csv.reader(fh))


def write(name, rows):
    with open(os.path.join(DATA, name), "w", encoding="utf-8", newline="") as fh:
        w = csv.writer(fh, lineterminator="\n")
        w.writerows(rows)


MAX_HERO = 100
MAX_ENEMY = 150


def old_level(L):
    """Niveau de l'ancienne échelle (1..50) équivalent au nouveau niveau L."""
    return 1.0 + (L - 1) * 49.0 / 99.0


def lerp_table(tbl, x):
    """tbl : {niveau: valeur} ; interpolation / extrapolation linéaire."""
    ks = sorted(tbl)
    if x <= ks[0]:
        if len(ks) > 1 and x < ks[0]:
            k0, k1 = ks[0], ks[1]
            return tbl[k0] + (tbl[k1] - tbl[k0]) * (x - k0) / (k1 - k0)
        return tbl[ks[0]]
    for a, b in zip(ks, ks[1:]):
        if a <= x <= b:
            return tbl[a] + (tbl[b] - tbl[a]) * (x - a) / (b - a)
    k0, k1 = ks[-2], ks[-1]
    return tbl[k1] + (tbl[k1] - tbl[k0]) * (x - k1) / (k1 - k0)


# ── 1. classes.txt ─────────────────────────────────────────────────────────
# Identité des classes (multiplicateurs appliqués aux stats d'origine).
IDENT = {
    "Tank": {"vita": 1.30, "defense": 1.25, "force": 1.00},
    "Assassin": {"vita": 0.95, "agility": 1.05},
    "Chasseur": {"defense": 0.95},
    "Mage": {"vita": 0.95, "defense": 0.90},
    "Heal": {"defense": 0.95},
    "Géomancien": {"defense": 0.88, "vita": 0.97},
}
COLS = {4: "vita", 5: "force", 6: "intelligence", 7: "agility", 8: "wisdom", 9: "defense"}

rows = read("classes.txt")
head = rows[0]
by = {}
for r in rows[1:]:
    by.setdefault(r[0], {})[int(r[1])] = r
out = [head]
for classe, tbl in by.items():
    for L in range(1, MAX_HERO + 1):
        ol = old_level(L)
        row = [classe, str(L)]
        for ci in range(2, 10):  # PA PM Vita Force Int Agi Sag Def
            v = lerp_table({k: float(t[ci]) for k, t in tbl.items()}, ol)
            if ci in (2, 3):
                v = float(tbl[1][ci])  # PA/PM : paliers gérés par ClassRules
            else:
                mult = IDENT.get(classe, {}).get(COLS[ci], 1.0)
                v *= mult
            row.append(str(int(round(v))))
        row.append("0")
        out.append(row)
write("classes.txt", out)

# ── 2. sorts.txt (kits de 10 sorts) ────────────────────────────────────────
UNLOCK = [1, 1, 1, 10, 20, 35, 50, 65, 80, 100]
KITS = {
    "Tank": ["Coup de bouclier", "Protection", "Soin de combat", "Frappe puissante", "Provocation",
             "Mur de pierre", "Tremblement de terre", "Colère", "Coup écrasant", "Bouclier légendaire"],
    "Assassin": ["Lame fatale", "Poison", "Soin rapide", "Coup bas", "Ombre", "Marque de la mort",
                 "Éviscération", "Invisibilité", "Lame de l'ombre", "Coup final"],
    "Chasseur": ["Tir précis", "Piège", "Soin de chasseur", "Balise de chasse", "Tir explosif",
                 "Rappel de balise", "Fleche enflammée", "Tir de recul", "Tir légendaire", "Tir perçant ultime"],
    "Mage": ["Boule de feu", "Éclair", "Bouclier magique", "Explosion", "Téléportation", "Météore",
             "Gel", "Chaîne de foudre", "Désintégration", "Apocalypse"],
    "Druide": ["Bénédiction", "Soin", "Attaque sacrée", "Barrière", "Inspiration", "Soin de groupe",
               "Renaissance", "Attaque divine", "Résurrection", "Jugement"],
    "Heal": ["Toucher guérisseur", "Éclair sacré", "Bénédiction de vie", "Bouclier de lumière",
             "Mot de restauration", "Éclat de lumière", "Soin supérieur", "Soin de groupe supérieur",
             "Protection vitale", "Soin ultime"],
    "Invocateur": ["Frappe spectrale", "Symbiose", "Invoquer Golem de Pierre", "Invoquer Loup Spectral", "Attaque de l'invocation",
                   "Invoquer Requin des Marées", "Buff de l'invocation", "Invoquer Élémentaire de Cristal", "Invoquer Ombre",
                   "Invoquer Esprit de la Forêt"],
    "Sylvain": ["Ronce", "Sève vitale", "Invoquer Archer Sylvestre", "Poison de ronce", "Invoquer Arbre",
                "Racine", "Soin de sève", "Invoquer Ent de Combat", "Pluie de graines", "Tempête de pétales"],
    "Géomancien": ["Éclat de grès", "Invoquer Pilier", "Armure de grès", "Lance de cristal", "Invoquer Muraille",
                   "Éboulement", "Invoquer Faille", "Tempête de sable", "Séisme ambré", "Cataclysme minéral"],
}
HEAL_SRC = {"Toucher guérisseur", "Éclair sacré", "Bénédiction de vie", "Bouclier de lumière",
            "Mot de restauration", "Éclat de lumière", "Soin supérieur", "Soin de groupe supérieur",
            "Protection vitale", "Soin ultime"}

srows = read("sorts.txt")
shead = srows[0]
pool = {}  # (classe_kit, nom) -> row
for r in srows[1:]:
    if not r or not r[0]:
        continue
    pool.setdefault((r[0], r[1]), r)


CUSTOM = {
    ("Chasseur", "Rappel de balise"): ["Chasseur", "Rappel de balise", "1", "0", "8",
        "Rappelle une de vos balises (elle disparaît du terrain)", "1", "Invocation",
        "0", "0", "0", "0", "0", "0", "0", "0", "0"],
}


# V15g : invocations renommées (nouveaux sprites) ; les sources gardent les anciens noms.
RENAMED = {
    "Invoquer Golem de Pierre": ("Invoquer Tortue", "Invoque un Golem de Pierre"),
    "Invoquer Loup Spectral": ("Invoquer Loup", "Invoque un Loup Spectral"),
    "Invoquer Requin des Marées": ("Invoquer Sirène", "Invoque un Requin des Marées"),
    "Invoquer Élémentaire de Cristal": ("Invoquer Ange", "Invoque un Élémentaire de Cristal"),
    "Invoquer Ombre": ("Invoquer Homme-Faucon", "Invoque une Ombre"),
    "Invoquer Esprit de la Forêt": ("Invoquer Centaure", "Invoque un Esprit de la Forêt"),
    "Invoquer Archer Sylvestre": ("Invoquer Buisson", "Invoque un Archer Sylvestre"),
    "Invoquer Ent de Combat": ("Invoquer Champignon", "Invoque un Ent de Combat"),
}


def find(classe, name):
    if (classe, name) in CUSTOM:
        return CUSTOM[(classe, name)]
    if name in RENAMED:
        old, label = RENAMED[name]
        r = list(find(classe, old))
        r[1] = name
        r[5] = re.sub(r"^Invoquer? (une?|un) [^(]+", label + " ", r[5]).replace("  ", " ")
        return r
    for key in ((classe, name), ("Druide", name), ("Heal", name)):
        if key in pool and not (classe == "Druide" and key[0] == "Heal" and False):
            return pool[key]
    raise KeyError((classe, name))


# V16 : sorts des héros trop forts en début de partie -> dégâts et soins / 1,5
HERO_SPELL_DIV = 1.5


def _div(n):
    return str(max(1, int(round(int(n) / HERO_SPELL_DIV))))


def hero_nerf(r):
    e = r[5]
    e = re.sub(r"(\d+)(?= dégâts)", lambda m: _div(m.group(1)), e)
    e = re.sub(r"(dégâts = )(\d+)", lambda m: m.group(1) + _div(m.group(2)), e)
    e = re.sub(r"(?i)((?:restaure|soigne)(?: de)? )(\d+)(?=%? pv)", lambda m: m.group(1) + _div(m.group(2)), e)
    r[5] = e
    for ci in (8, 9, 10):
        if r[ci].strip().isdigit() and int(r[ci]) > 0:
            r[ci] = _div(r[ci])


sout = [shead]
prog = [["Classe", "Niveau", "Sorts débloqués (séparés par \";\")"]]
order = ["Tank", "Assassin", "Chasseur", "Mage", "Druide", "Heal", "Invocateur", "Sylvain", "Géomancien"]
for classe in order:
    byl = {}
    for name, lvl in zip(KITS[classe], UNLOCK):
        r = list(find(classe, name))
        r[0] = classe
        r[6] = str(lvl)
        # pas de virgule dans les effets (parseur naïf)
        r[5] = r[5].replace(",", ";")
        r += ["0"] * (17 - len(r))
        if name == "Éclair":  # nerf : trop puissant
            r[4] = "5"
            r[5] = "52 dégâts magiques (2 cibles)"
            r[8] = "52"
        if name == "Invoquer Pilier":
            r[5] = "Fait surgir un pilier de grès : bloque le passage et la vue; attaque l'ennemi le plus proche dans un rayon de 4 cases (4 tours; 8 cases de terrain max)"
        if name == "Balise de chasse":
            r[5] = "Plante une balise (3 max; la plus ancienne disparaît) : un sort de zone du Chasseur qui touche une balise se réplique autour de toutes les autres"
        # Cristal ambré mal formé dans l'ancien fichier : jamais retenu ici
        hero_nerf(r)
        sout.append(r)
        byl.setdefault(lvl, []).append(name)
    for lvl in sorted(byl):
        prog.append([classe, str(lvl), ";".join(byl[lvl])])
write("sorts.txt", sout)
write("progression_sorts.txt", prog)

# ── 3. ennemis.txt (1..150, lscale cuit) ───────────────────────────────────
erows = read("ennemis.txt")
ehead = erows[0]
types = {}
bosses = {}
for r in erows[1:]:
    if not r or not r[0]:
        continue
    (bosses if r[0].startswith("Boss ") else types).setdefault(r[0], []).append(r)
LEVELS = [1] + list(range(5, MAX_ENEMY + 1, 5))


def lscale(ol):
    return 1.0 + max(0.0, ol - 10.0) * 0.008


def ramp(L):
    """Début de partie adouci : niveaux 1..20 -> x0.85 .. x1."""
    return 0.85 + 0.15 * min(1.0, (L - 1) / 19.0)


def stat_at(rows_, col, ol):
    return lerp_table({int(r[1]): float(r[col]) for r in rows_}, ol)


enemy_out = [ehead]
base_ref = None
for tname, trs in types.items():
    first = int(trs[0][1])
    meta = trs[0]
    for L in LEVELS:
        ol = old_level(L) if L <= MAX_HERO else 50.0 + (L - MAX_HERO) * 0.49
        if tname in ("Troll", "Dragonnet") and ol < first:
            # ces types existent dès le niveau 1 : on prolonge leur courbe vers le bas
            pass
        f = lscale(ol) * ramp(L)
        pv = stat_at(trs, 2, ol) * f
        atk = stat_at(trs, 3, ol) * f
        dfn = stat_at(trs, 4, ol) * (0.6 + 0.4 * ramp(L)) * (1.0 + max(0.0, ol - 10) * 0.004)
        pa = max(2, int(round(stat_at(trs, 5, ol))))
        pm = max(2, int(round(stat_at(trs, 6, ol))))
        xp = max(10, int(round(stat_at(trs, 7, ol))))
        enemy_out.append([tname, str(L), str(int(round(pv))), str(max(1, int(round(atk)))),
                          str(max(1, int(round(dfn)))), str(min(pa, 7)), str(min(pm, 5)), str(xp),
                          meta[8], meta[9]])
    enemy_out.append([])
# Boss : ratio au Gobelin (au niveau natif) appliqué à la courbe du Gobelin.
gob = types["Gobelin"]
for bname, brs in bosses.items():
    b = brs[0]
    nat = int(b[1])
    rpv = float(b[2]) / stat_at(gob, 2, nat)
    ratk = float(b[3]) / stat_at(gob, 3, nat)
    rdef = float(b[4]) / stat_at(gob, 4, nat)
    for L in LEVELS:
        ol = old_level(L) if L <= MAX_HERO else 50.0 + (L - MAX_HERO) * 0.49
        f = lscale(ol) * ramp(L)
        # le boss garde au moins l'allure de ses valeurs d'origine à son niveau natif
        pv = stat_at(gob, 2, ol) * rpv * f
        atk = stat_at(gob, 3, ol) * ratk * f
        dfn = stat_at(gob, 4, ol) * rdef * (0.6 + 0.4 * ramp(L)) * (1.0 + max(0.0, ol - 10) * 0.004)
        xp = int(round(float(b[7]) * (0.3 + 0.7 * min(1.0, ol / max(1, nat)))))
        enemy_out.append([bname, str(L), str(int(round(pv))), str(max(1, int(round(atk)))),
                          str(max(1, int(round(dfn)))), b[5], b[6], str(max(20, xp)), b[8], b[9]])
write("ennemis.txt", [r for r in enemy_out])

# ── 4. stuff.txt / craft.txt : niveaux requis étirés ───────────────────────────
for fname in ("stuff.txt", "craft.txt"):
    rs = read(fname)
    res = [rs[0]]
    for r in rs[1:]:
        if len(r) > 2 and r[2].strip().isdigit():
            # anciens niveaux 5..50 -> 1..100 (le premier équipement est disponible dès le niveau 1)
            r[2] = str(max(1, int(round(1 + (int(r[2]) - 5) * 99.0 / 45.0))))
        res.append(r)
    write(fname, res)

print("OK : classes", len(out) - 1, "sorts", len(sout) - 1, "ennemis", len(enemy_out))
