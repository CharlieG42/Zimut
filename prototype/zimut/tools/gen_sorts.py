#!/usr/bin/env python3
"""Génère les 20 sorts supplémentaires par classe (V43) et réécrit data/sorts.txt + data/progression_sorts.txt.

Usage : python3 tools/gen_sorts.py     (depuis prototype/zimut)
Le script conserve les 100 sorts d'origine (data/sorts_base.txt, créé au premier lancement)
et y ajoute le catalogue ci-dessous : 30 sorts par classe, certains PARTAGÉS entre classes.

Grammaire d'effet reconnue par Combat.parse (voir Combat.gd) + clauses de synergie V43 :
  [Combo poison : bonus 40%]            +40 % de dégâts si la cible subit le poison
  [Enchaînement après Poison : bonus 30%] +30 % si ce sort a été lancé plus tôt dans le tour
"""
import csv, os, re, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
DATA = os.path.join(ROOT, "data")
BASE = os.path.join(HERE, "sorts_base.txt")
OUT = os.path.join(DATA, "sorts.txt")
PROG = os.path.join(DATA, "progression_sorts.txt")

if not os.path.exists(BASE):
    with open(OUT, encoding="utf-8") as f, open(BASE, "w", encoding="utf-8") as g:
        g.write(f.read())

HEADER = ["Classe", "Nom", "Cout_PA", "Cout_PM", "Portee", "Effet", "Niveau_requis", "Type",
          "Degats_physiques", "Degats_magiques", "Soins", "Resistance_physique", "Resistance_magique",
          "Debuff_physique", "Debuff_magique", "Buff_physique", "Buff_magique"]
MAGIC = {"Mage", "Druide", "Invocateur", "Heal", "Géomancien"}
CLASSES = ["Tank", "Assassin", "Chasseur", "Mage", "Druide", "Heal", "Invocateur", "Sylvain", "Géomancien", "Artificier"]

PAM = {1: 0.30, 2: 0.55, 3: 0.78, 4: 1.0}
HAM = {1: 0.30, 2: 0.55, 3: 0.80, 4: 1.0}


def dmg(pa, L, m=1.0):
    return max(5, round((45 + 0.88 * L) * PAM[pa] * m))


def dot(L, m=1.0):
    return max(4, round((45 + 0.88 * L) * 0.22 * m))


def heal(pa, L, m=1.0):
    return max(8, round((35 + 0.95 * L) * HAM[pa] * m))


def combo(state, pct):
    return f" [Combo {state} : bonus {pct}%]"


def chain(spell, pct):
    return f" [Enchaînement après {spell} : bonus {pct}%]"


# Un sort = (niveau, nom, pa, pm, portée, type, fonction(classe, L) -> effet)
def S(L, name, pa, pm, rng, typ, eff):
    return (L, name, pa, pm, rng, typ, eff)


def mg(c):  # suffixe « magiques » pour les classes qui n'ont pas de dtype magique par défaut
    return " magiques" if c == "Sylvain" else ""


# ── Sorts PARTAGÉS : même nom dans plusieurs classes (niveau propre à chaque classe) ──
SHARED = {
    "Cri de guerre": (2, 0, 0, "Buff", lambda c, L: "+15% dégâts pour l'équipe (2 tours)",
                      {"Tank": 12, "Chasseur": 28, "Assassin": 40, "Artificier": 24}),
    "Second souffle": (3, 0, 1, "Soin", lambda c, L: f"Restaure {heal(3, L)} PV",
                       {"Tank": 24, "Druide": 12, "Sylvain": 18, "Heal": 8, "Invocateur": 28}),
    "Purification": (2, 0, 3, "Buff", lambda c, L: "Supprime les effets négatifs (allié)",
                     {"Druide": 18, "Heal": 15, "Mage": 32, "Invocateur": 15, "Sylvain": 40}),
    "Pas de côté": (1, 0, 0, "Buff", lambda c, L: "+30% esquive (2 tours)",
                    {"Assassin": 5, "Chasseur": 8, "Artificier": 12, "Sylvain": 22}),
    "Entrave": (2, 0, 4, "Debuff", lambda c, L: "Immobilise l'ennemi (1 tour)",
                {"Géomancien": 8, "Chasseur": 15, "Assassin": 28, "Artificier": 18}),
    "Trait de lumière": (3, 0, 4, "Attaque", lambda c, L: f"{dmg(3, L)} dégâts magiques",
                         {"Heal": 3, "Druide": 5, "Invocateur": 8}),
    "Marque du prédateur": (1, 0, 0, "Buff", lambda c, L: "Critique garanti (prochaine attaque)",
                            {"Chasseur": 18, "Assassin": 12, "Artificier": 35}),
    "Régénération": (2, 0, 3, "Soin", lambda c, L: f"Soigne {round(heal(2, L) / 3.5)} PV/tour pendant 3 tours",
                     {"Druide": 8, "Sylvain": 12, "Géomancien": 28}),
    "Intimidation": (2, 0, 3, "Debuff", lambda c, L: "-20% dégâts (2 tours)",
                     {"Tank": 36, "Assassin": 22, "Géomancien": 36}),
    "Invoquer Ent de Combat": (2, 0, 1, "Invocation",
                               lambda c, L: "Invoque un Ent de Combat (contrôlable; 3PM/4PA)",
                               {"Invocateur": 62}),
    "Invoquer Archer Sylvestre": (2, 0, 1, "Invocation",
                                  lambda c, L: "Invoque un Archer Sylvestre (contrôlable; 3PM/4PA)",
                                  {"Invocateur": 5}),
    "Invoquer Loup Spectral": (2, 0, 1, "Invocation",
                               lambda c, L: "Invoque un Loup Spectral (contrôlable; 3PM/4PA)",
                               {"Sylvain": 32}),
}


def shared(name):
    return ("shared", name)


# ── Catalogue par classe : 20 sorts supplémentaires chacune (partagés compris) ──
NEW = {}

NEW["Tank"] = [
    S(3, "Garde haute", 1, 0, 0, "Buff", lambda c, L: "+12% défense (2 tours)"),
    S(5, "Charge", 2, 1, 3, "Attaque", lambda c, L: f"{dmg(2, L)} dégâts + ralentit 1 pm (1 tour)"),
    S(8, "Revers de bouclier", 2, 0, 1, "Attaque", lambda c, L: f"{dmg(2, L)} dégâts" + combo("étourdissement", 50)),
    shared("Cri de guerre"),
    S(15, "Entaille lourde", 3, 0, 1, "Attaque", lambda c, L: f"{dmg(3, L)} dégâts + saignement ({dot(L)} dégâts/tour; 2 tours)"),
    S(18, "Rempart", 2, 0, 1, "Buff", lambda c, L: "+20% défense (2 tours; allié)"),
    shared("Second souffle"),
    S(28, "Balayage", 3, 0, 2, "Attaque", lambda c, L: f"{dmg(3, L, 0.8)} dégâts à tous les ennemis adjacents"),
    S(32, "Coup de tête", 3, 0, 1, "Attaque", lambda c, L: f"{dmg(3, L)} dégâts + étourdit 1 tour (40%)" + chain("Provocation", 40)),
    shared("Intimidation"),
    S(44, "Brise-garde", 3, 0, 1, "Attaque", lambda c, L: f"{dmg(3, L)} dégâts (ignore 40% défense)" + chain("Frappe puissante", 35)),
    S(48, "Mêlée furieuse", 4, 0, 2, "Attaque", lambda c, L: f"{dmg(4, L, 0.75)} dégâts à tous les ennemis adjacents"),
    S(55, "Égide", 3, 0, 0, "Buff", lambda c, L: "+30% défense pour l'équipe (2 tours)"),
    S(58, "Marteau du colosse", 4, 0, 1, "Attaque", lambda c, L: f"{dmg(4, L, 1.05)} dégâts"),
    S(62, "Volonté de fer", 2, 0, 0, "Buff", lambda c, L: "Immunité aux effets négatifs (1 tour)"),
    S(70, "Sentence", 4, 0, 1, "Attaque", lambda c, L: f"{dmg(4, L, 1.5)} dégâts (<30% pv)"),
    S(75, "Ruée dévastatrice", 4, 1, 4, "Attaque", lambda c, L: f"{dmg(4, L, 0.95)} dégâts + étourdit 1 tour (50%)"),
    S(85, "Bastion vivant", 4, 0, 0, "Soin", lambda c, L: f"Restaure {heal(4, L, 0.5)} PV à tous les alliés"),
    S(90, "Écrasement tellurique", 4, 0, 3, "Attaque", lambda c, L: f"{dmg(4, L, 0.85)} dégâts en zone (3x3) + immobilise (1 tour)"),
    S(95, "Fureur du titan", 3, 0, 0, "Buff", lambda c, L: "+40% dégâts (2 tours)"),
]

NEW["Assassin"] = [
    shared("Pas de côté"),
    S(3, "Estoc rapide", 1, 0, 1, "Attaque", lambda c, L: f"{dmg(1, L)} dégâts" + chain("Lame fatale", 30)),
    S(8, "Lame empoisonnée", 2, 0, 1, "Attaque", lambda c, L: f"{dmg(2, L, 0.8)} dégâts + ({dot(L, 0.8)} dégâts/tour; 2 tours)"),
    shared("Marque du prédateur"),
    S(15, "Fente", 2, 1, 2, "Attaque", lambda c, L: f"{dmg(2, L)} dégâts" + combo("saignement", 40)),
    S(18, "Croche-pied", 2, 0, 1, "Attaque", lambda c, L: f"{dmg(2, L, 0.8)} dégâts + ralentit 1 pm (2 tours)"),
    shared("Intimidation"),
    S(24, "Disparition", 2, 0, 0, "Buff", lambda c, L: "Invisible (2 tours)"),
    shared("Entrave"),
    S(32, "Hémorragie", 3, 0, 1, "Attaque", lambda c, L: f"{dmg(3, L, 0.9)} dégâts + saignement ({dot(L)} dégâts/tour; 3 tours)"),
    S(38, "Lame jumelle", 3, 0, 1, "Attaque", lambda c, L: f"{dmg(3, L, 0.8)} dégâts (2 cibles)"),
    shared("Cri de guerre"),
    S(44, "Frappe sournoise", 3, 0, 1, "Attaque", lambda c, L: f"{dmg(3, L)} dégâts (critique si dos tourné)" + combo("poison", 50)),
    S(48, "Danse des lames", 4, 0, 2, "Attaque", lambda c, L: f"{dmg(4, L, 0.75)} dégâts à tous les ennemis adjacents"),
    S(55, "Exécution", 3, 0, 1, "Attaque", lambda c, L: f"{dmg(3, L, 1.6)} dégâts (<30% pv)"),
    S(62, "Voile mortel", 3, 0, 3, "Attaque", lambda c, L: f"{dmg(3, L, 0.8)} dégâts + -1 PA (1 tour)"),
    S(70, "Rafale de lames", 4, 0, 1, "Attaque", lambda c, L: f"{dmg(4, L, 1.1)} dégâts" + combo("saignement", 60)),
    S(75, "Venin foudroyant", 3, 0, 3, "Debuff", lambda c, L: f"{dot(L, 1.6)} dégâts/tour (3 tours)"),
    S(90, "Ombre mortelle", 4, 1, 3, "Attaque", lambda c, L: f"{dmg(4, L, 1.05)} dégâts (ignore 40% défense)"),
    S(95, "Danse macabre", 4, 0, 2, "Attaque", lambda c, L: f"{dmg(4, L, 0.9)} dégâts à tous les ennemis adjacents" + combo("saignement", 50)),
]

NEW["Chasseur"] = [
    S(3, "Tir rapide", 1, 0, 4, "Attaque", lambda c, L: f"{dmg(1, L)} dégâts"),
    shared("Pas de côté"),
    S(12, "Flèche empoisonnée", 2, 0, 5, "Attaque", lambda c, L: f"{dmg(2, L, 0.8)} dégâts + ({dot(L, 0.8)} dégâts/tour; 2 tours)"),
    shared("Entrave"),
    shared("Marque du prédateur"),
    S(22, "Tir en rafale", 3, 0, 5, "Attaque", lambda c, L: f"{dmg(3, L, 0.8)} dégâts (2 cibles)"),
    S(25, "Piège à loup", 2, 0, 5, "Attaque", lambda c, L: f"Pose un piège : {dmg(2, L, 1.2)} dégâts"),
    shared("Cri de guerre"),
    S(30, "Flèche de feu", 3, 0, 5, "Attaque", lambda c, L: f"{dmg(3, L, 0.9)} dégâts + brûle {dot(L, 0.8)} dégâts/tour (2 tours)"),
    S(38, "Tir du chasseur", 3, 0, 6, "Attaque", lambda c, L: f"{dmg(3, L)} dégâts" + combo("ralentissement", 40)),
    S(42, "Pluie de flèches", 4, 0, 6, "Attaque", lambda c, L: f"{dmg(4, L, 0.8)} dégâts en zone (3x3)"),
    S(45, "Tir ciblé", 3, 0, 6, "Attaque", lambda c, L: f"{dmg(3, L, 1.05)} dégâts" + combo("immobilisation", 50)),
    S(55, "Tir d'estoc", 3, 0, 5, "Attaque", lambda c, L: f"{dmg(3, L, 0.9)} dégâts + repousse de 1 case"),
    S(58, "Œil de faucon", 2, 0, 0, "Buff", lambda c, L: "+30% dégâts (2 tours)"),
    S(62, "Flèche de glace", 3, 0, 5, "Attaque", lambda c, L: f"{dmg(3, L, 0.9)} dégâts + immobilise (1 tour)"),
    S(70, "Tir mortel", 4, 0, 7, "Attaque", lambda c, L: f"{dmg(4, L, 1.15)} dégâts" + chain("Tir précis", 40)),
    S(75, "Salve", 4, 0, 6, "Attaque", lambda c, L: f"{dmg(4, L, 0.65)} dégâts à tous les ennemis"),
    S(85, "Tir de grâce", 4, 0, 7, "Attaque", lambda c, L: f"{dmg(4, L, 1.4)} dégâts (<30% pv)"),
    S(90, "Flèche du destin", 4, 0, 8, "Attaque", lambda c, L: f"{dmg(4, L, 1.1)} dégâts (ignore 40% défense)"),
    S(95, "Déluge de plomb", 4, 0, 6, "Attaque", lambda c, L: f"{dmg(4, L, 1.0)} dégâts en zone (4x4)"),
]

NEW["Mage"] = [
    S(3, "Étincelle", 1, 0, 5, "Attaque", lambda c, L: f"{dmg(1, L)} dégâts magiques"),
    S(5, "Armure de givre", 2, 0, 0, "Buff", lambda c, L: "+20% défense (3 tours)"),
    S(8, "Trait de glace", 2, 0, 5, "Attaque", lambda c, L: f"{dmg(2, L)} dégâts magiques + ralentit 1 pm (2 tours)"),
    S(12, "Brûlure", 2, 0, 5, "Debuff", lambda c, L: f"brûle {dot(L, 1.1)} dégâts/tour (3 tours)"),
    S(15, "Foudre", 3, 0, 5, "Attaque", lambda c, L: f"{dmg(3, L)} dégâts magiques" + combo("ralentissement", 40)),
    S(18, "Mur de flammes", 3, 0, 5, "Attaque", lambda c, L: f"{dmg(3, L, 0.9)} dégâts en zone (2x2) + brûle {dot(L, 0.6)} dégâts/tour (2 tours)"),
    S(24, "Concentration", 1, 0, 0, "Buff", lambda c, L: "+25% dégâts (2 tours)"),
    S(28, "Nova de givre", 4, 0, 3, "Attaque", lambda c, L: f"{dmg(4, L, 0.7)} dégâts à tous les ennemis adjacents + immobilise (1 tour)"),
    shared("Purification"),
    S(38, "Rayon ardent", 3, 0, 6, "Attaque", lambda c, L: f"{dmg(3, L, 1.05)} dégâts magiques" + combo("brûlure", 50)),
    S(42, "Lance de glace", 3, 0, 6, "Attaque", lambda c, L: f"{dmg(3, L, 1.0)} dégâts magiques" + combo("immobilisation", 60)),
    S(45, "Maléfice", 2, 0, 5, "Debuff", lambda c, L: "-1 PA (1 tour) + -20% dégâts (2 tours)"),
    S(55, "Tempête de feu", 4, 0, 5, "Attaque", lambda c, L: f"{dmg(4, L, 0.8)} dégâts en zone (3x3)" + combo("brûlure", 40)),
    S(58, "Éclair en chaîne", 3, 0, 6, "Attaque", lambda c, L: f"{dmg(3, L, 0.8)} dégâts (saute sur 2 ennemis)"),
    S(62, "Brise-esprit", 4, 0, 6, "Attaque", lambda c, L: f"{dmg(4, L, 1.1)} dégâts magiques (ignore 40% défense)"),
    S(70, "Blizzard", 4, 0, 6, "Attaque", lambda c, L: f"{dmg(4, L, 0.6)} dégâts à tous les ennemis + ralentit 1 pm (1 tour)"),
    S(75, "Colère des éléments", 4, 0, 7, "Attaque", lambda c, L: f"{dmg(4, L, 1.15)} dégâts magiques" + chain("Boule de feu", 40)),
    S(85, "Foudroiement", 4, 0, 7, "Attaque", lambda c, L: f"{dmg(4, L, 1.45)} dégâts (<30% pv)"),
    S(90, "Sphère d'annihilation", 4, 0, 7, "Attaque", lambda c, L: f"{dmg(4, L, 1.0)} dégâts en zone (3x3) + -1 PA (1 tour)"),
    S(95, "Maîtrise arcanique", 3, 0, 0, "Buff", lambda c, L: "+40% dégâts (2 tours)"),
]

NEW["Druide"] = [
    shared("Trait de lumière"),
    S(3, "Lueur apaisante", 1, 0, 3, "Soin", lambda c, L: f"Restaure {heal(1, L)} PV"),
    shared("Régénération"),
    shared("Second souffle"),
    S(15, "Écorce protectrice", 2, 0, 3, "Buff", lambda c, L: "+20% défense (2 tours; allié)"),
    shared("Purification"),
    S(22, "Fureur de la nature", 3, 0, 3, "Attaque", lambda c, L: f"{dmg(3, L)} dégâts magiques" + combo("poison", 40)),
    S(25, "Épines", 2, 0, 3, "Debuff", lambda c, L: f"{dot(L)} dégâts/tour (3 tours)"),
    S(30, "Chant de vie", 3, 0, 0, "Soin", lambda c, L: f"Restaure {heal(3, L, 0.5)} PV à tous les alliés"),
    S(38, "Sceau de lumière", 3, 0, 3, "Attaque", lambda c, L: f"{dmg(3, L, 0.9)} dégâts magiques + -20% dégâts (2 tours)"),
    S(42, "Harmonie", 2, 0, 0, "Buff", lambda c, L: "+1 PA pour 2 tours (allié)"),
    S(45, "Frappe de l'aube", 3, 0, 3, "Attaque", lambda c, L: f"{dmg(3, L, 1.0)} dégâts magiques" + chain("Attaque sacrée", 40)),
    S(55, "Rayon solaire", 4, 0, 4, "Attaque", lambda c, L: f"{dmg(4, L, 0.7)} dégâts à tous les ennemis"),
    S(58, "Étreinte de vie", 3, 0, 2, "Soin", lambda c, L: f"Restaure {heal(3, L, 1.1)} PV + supprime les effets négatifs"),
    S(62, "Bénédiction des anciens", 3, 0, 0, "Buff", lambda c, L: "+25% défense pour l'équipe (2 tours)"),
    S(70, "Colère divine", 4, 0, 4, "Attaque", lambda c, L: f"{dmg(4, L, 1.15)} dégâts magiques" + combo("malédiction", 50)),
    S(75, "Éveil de la forêt", 4, 0, 0, "Soin", lambda c, L: f"Soigne {round(heal(4, L) / 3)} PV/tour pendant 3 tours à tous les alliés"),
    S(85, "Foudre céleste", 4, 0, 5, "Attaque", lambda c, L: f"{dmg(4, L, 1.4)} dégâts (<30% pv)"),
    S(90, "Grâce suprême", 4, 0, 3, "Soin", lambda c, L: f"Restaure {heal(4, L, 1.2)} PV"),
    S(95, "Bénédiction ultime", 3, 0, 0, "Buff", lambda c, L: "+30% dégâts pour l'équipe (2 tours)"),
]

NEW["Heal"] = [
    shared("Trait de lumière"),
    S(5, "Gouttes de rosée", 1, 0, 3, "Soin", lambda c, L: f"Restaure {heal(1, L)} PV"),
    shared("Second souffle"),
    S(12, "Onde apaisante", 3, 0, 0, "Soin", lambda c, L: f"Restaure {heal(3, L, 0.5)} PV à tous les alliés"),
    shared("Purification"),
    S(18, "Lumière bénie", 2, 0, 3, "Soin", lambda c, L: f"Soigne {round(heal(2, L) / 3)} PV/tour pendant 4 tours"),
    S(22, "Aura de courage", 2, 0, 0, "Buff", lambda c, L: "+15% dégâts pour l'équipe (2 tours)"),
    S(25, "Châtiment sacré", 3, 0, 4, "Attaque", lambda c, L: f"{dmg(3, L)} dégâts magiques" + combo("malédiction", 40)),
    S(28, "Prière rapide", 1, 0, 3, "Soin", lambda c, L: f"Restaure {heal(1, L, 1.4)} PV"),
    S(32, "Voile de lumière", 2, 0, 3, "Buff", lambda c, L: "+30% résistance magie (2 tours; allié)"),
    S(38, "Sceau d'espoir", 3, 0, 3, "Soin", lambda c, L: f"Restaure {heal(3, L, 1.1)} PV + supprime les effets négatifs"),
    S(42, "Rayon purificateur", 3, 0, 5, "Attaque", lambda c, L: f"{dmg(3, L, 0.9)} dégâts magiques" + chain("Éclair sacré", 40)),
    S(45, "Sanctuaire", 3, 0, 0, "Buff", lambda c, L: "+25% défense pour l'équipe (2 tours)"),
    S(55, "Intervention divine", 3, 0, 3, "Buff", lambda c, L: "Immunité à tous les dégâts (1 tour)"),
    S(58, "Pluie de lumière", 4, 0, 0, "Soin", lambda c, L: f"Soigne {round(heal(4, L) / 3.2)} PV/tour pendant 3 tours à tous les alliés"),
    S(62, "Renaissance sacrée", 4, 0, 2, "Soin", lambda c, L: f"Restaure {heal(4, L, 1.25)} PV + supprime les effets négatifs"),
    S(70, "Colère céleste", 4, 0, 5, "Attaque", lambda c, L: f"{dmg(4, L, 1.1)} dégâts magiques" + combo("affaiblissement", 40)),
    S(85, "Étreinte éternelle", 4, 0, 0, "Soin", lambda c, L: f"Restaure {heal(4, L, 0.75)} PV à tous les alliés"),
    S(90, "Nova sacrée", 4, 0, 3, "Soin", lambda c, L: f"Restaure {heal(4, L, 0.9)} PV + {dmg(4, L, 0.3)} dégâts aux ennemis adjacents"),
    S(95, "Miracle", 4, 0, 3, "Soin", lambda c, L: f"Restaure {heal(4, L, 1.3)} PV"),
]

NEW["Invocateur"] = [
    shared("Invoquer Archer Sylvestre"),
    S(3, "Lien d'âme", 1, 0, 1, "Buff", lambda c, L: "L'invocation gagne +15% dégâts (2 tours)"),
    shared("Trait de lumière"),
    S(12, "Rayon spectral", 2, 0, 5, "Attaque", lambda c, L: f"{dmg(2, L)} dégâts magiques"),
    shared("Purification"),
    S(18, "Frénésie du familier", 2, 0, 1, "Buff", lambda c, L: "L'invocation gagne +25% dégâts (2 tours)"),
    S(22, "Éclat d'âme", 2, 0, 5, "Attaque", lambda c, L: f"{dmg(2, L, 1.1)} dégâts magiques" + chain("Frappe spectrale", 35)),
    S(25, "Offrande", 2, 0, 1, "Soin", lambda c, L: f"L'invocation restaure {heal(2, L, 0.45)} PV à tous les alliés"),
    shared("Second souffle"),
    S(32, "Tempête spectrale", 3, 0, 5, "Attaque", lambda c, L: f"{dmg(3, L, 0.85)} dégâts en zone (3x3)"),
    S(38, "Coup de l'invocation", 2, 0, 5, "Attaque", lambda c, L: f"L'invocation attaque (dégâts = {round(dmg(2, L, 0.35))} + niveau/2)"),
    S(42, "Pacte de sang", 2, 0, 1, "Buff", lambda c, L: "L'invocation gagne +35% dégâts (2 tours)"),
    S(45, "Chaîne d'âmes", 3, 0, 6, "Attaque", lambda c, L: f"{dmg(3, L, 0.85)} dégâts (saute sur 2 ennemis)"),
    S(55, "Appel du néant", 3, 0, 5, "Debuff", lambda c, L: "-1 PA (1 tour) + -20% dégâts (2 tours)"),
    S(58, "Explosion d'âme", 4, 0, 5, "Attaque", lambda c, L: f"{dmg(4, L, 0.9)} dégâts en zone (3x3)" + combo("affaiblissement", 40)),
    shared("Invoquer Ent de Combat"),
    S(70, "Bénédiction du lien", 3, 0, 0, "Soin", lambda c, L: f"L'invocation restaure {heal(3, L, 0.5)} PV à tous les alliés"),
    S(75, "Déferlement spectral", 4, 0, 6, "Attaque", lambda c, L: f"{dmg(4, L, 0.65)} dégâts à tous les ennemis"),
    S(90, "Fusion d'âmes", 4, 0, 6, "Attaque", lambda c, L: f"{dmg(4, L, 1.15)} dégâts magiques" + combo("malédiction", 50)),
    S(95, "Légion des ombres", 3, 0, 0, "Buff", lambda c, L: "L'invocation gagne +50% dégâts (2 tours)"),
]

NEW["Sylvain"] = [
    S(3, "Épine", 1, 0, 3, "Attaque", lambda c, L: f"{dmg(1, L)} dégâts magiques"),
    S(5, "Écorce", 2, 0, 0, "Buff", lambda c, L: "+15% défense (2 tours)"),
    S(8, "Lierre", 2, 0, 4, "Attaque", lambda c, L: f"{dmg(2, L, 0.8)} dégâts magiques + ralentit 1 pm (2 tours)"),
    shared("Régénération"),
    S(15, "Fouet épineux", 2, 0, 3, "Attaque", lambda c, L: f"{dmg(2, L)} dégâts magiques" + combo("poison", 40)),
    shared("Second souffle"),
    shared("Pas de côté"),
    S(26, "Nuée de spores", 3, 0, 4, "Attaque", lambda c, L: f"{dmg(3, L, 0.8)} dégâts en zone (3x3) + ({dot(L, 0.5)} dégâts/tour; 2 tours)"),
    S(30, "Étreinte végétale", 3, 0, 3, "Attaque", lambda c, L: f"{dmg(3, L, 0.9)} dégâts magiques + immobilise (1 tour)"),
    shared("Invoquer Loup Spectral"),
    S(36, "Sève bienfaitrice", 3, 0, 0, "Soin", lambda c, L: f"Restaure {heal(3, L, 0.5)} PV à tous les alliés"),
    shared("Purification"),
    S(45, "Racines étrangleuses", 3, 0, 4, "Attaque", lambda c, L: f"{dmg(3, L)} dégâts magiques" + combo("immobilisation", 60)),
    S(48, "Invoquer Sarriette", 3, 0, 1, "Invocation", lambda c, L: "Invoque une Sarriette (contrôlable; 3PM/4PA)"),
    S(55, "Floraison", 3, 0, 3, "Soin", lambda c, L: f"Restaure {heal(3, L, 1.1)} PV + supprime les effets négatifs"),
    S(60, "Rage de la forêt", 2, 0, 0, "Buff", lambda c, L: "+30% dégâts (2 tours)"),
    S(70, "Ronces mortelles", 4, 0, 5, "Attaque", lambda c, L: f"{dmg(4, L, 1.1)} dégâts magiques" + chain("Ronce", 40)),
    S(75, "Tempête de feuilles", 4, 0, 5, "Attaque", lambda c, L: f"{dmg(4, L, 0.6)} dégâts à tous les ennemis"),
    S(88, "Invoquer Tronc", 3, 0, 1, "Invocation", lambda c, L: "Invoque un Tronc (contrôlable; 3PM/4PA)"),
    S(95, "Souffle de vie", 4, 0, 0, "Soin", lambda c, L: f"Restaure {heal(4, L, 0.7)} PV à tous les alliés"),
]

NEW["Géomancien"] = [
    S(3, "Caillou", 1, 0, 4, "Attaque", lambda c, L: f"{dmg(1, L)} dégâts magiques"),
    shared("Entrave"),
    S(12, "Armure de pierre", 2, 0, 0, "Buff", lambda c, L: "+20% défense (3 tours)"),
    S(15, "Pointe de roc", 2, 0, 4, "Attaque", lambda c, L: f"{dmg(2, L)} dégâts magiques" + combo("immobilisation", 50)),
    S(18, "Poussière aveuglante", 2, 0, 4, "Debuff", lambda c, L: "-20% dégâts (2 tours) + ralentit 1 pm (1 tour)"),
    S(22, "Glyphe de roche", 3, 0, 4, "Buff", lambda c, L: "Trace un glyphe (3x3; 3 tours) : alliés +20% défense"),
    S(25, "Lame de grès", 3, 0, 5, "Attaque", lambda c, L: f"{dmg(3, L, 0.9)} dégâts magiques + saignement ({dot(L, 0.6)} dégâts/tour; 2 tours)"),
    shared("Régénération"),
    S(30, "Avalanche", 3, 0, 5, "Attaque", lambda c, L: f"{dmg(3, L, 0.85)} dégâts en zone (2x2)"),
    S(32, "Rempart de pierre", 2, 0, 3, "Buff", lambda c, L: "+30% défense (2 tours; allié)"),
    shared("Intimidation"),
    S(42, "Entrave sismique", 3, 0, 5, "Attaque", lambda c, L: f"{dmg(3, L, 0.9)} dégâts magiques + immobilise (1 tour)"),
    S(45, "Fracture", 3, 0, 5, "Attaque", lambda c, L: f"{dmg(3, L, 1.05)} dégâts magiques (ignore 40% défense)"),
    S(55, "Colonne d'ambre", 4, 0, 5, "Attaque", lambda c, L: f"{dmg(4, L, 1.0)} dégâts magiques" + combo("ralentissement", 50)),
    S(58, "Glyphe de fer", 3, 0, 4, "Buff", lambda c, L: "Trace un glyphe (croix; 3 tours) : alliés +25% dégâts"),
    S(62, "Éruption", 4, 0, 5, "Attaque", lambda c, L: f"{dmg(4, L, 0.8)} dégâts en zone (3x3)" + combo("immobilisation", 40)),
    S(70, "Grondement", 4, 0, 5, "Attaque", lambda c, L: f"{dmg(4, L, 0.6)} dégâts à tous les ennemis + ralentit 1 pm (1 tour)"),
    S(75, "Écrasement", 4, 0, 6, "Attaque", lambda c, L: f"{dmg(4, L, 1.15)} dégâts magiques" + chain("Lance de cristal", 40)),
    S(88, "Pierre vivante", 3, 0, 0, "Buff", lambda c, L: "Immunité aux dégâts physiques (1 tour)"),
    S(95, "Fracas des montagnes", 4, 0, 7, "Attaque", lambda c, L: f"{dmg(4, L, 1.0)} dégâts en zone (4x4) + immobilise (1 tour)"),
]

NEW["Artificier"] = [
    S(3, "Pétard", 1, 0, 4, "Attaque", lambda c, L: f"{dmg(1, L)} dégâts"),
    S(5, "Fumigène", 2, 0, 0, "Buff", lambda c, L: "Invisible (2 tours)"),
    S(8, "Tir de barrage", 2, 0, 5, "Attaque", lambda c, L: f"{dmg(2, L)} dégâts" + chain("Pistolet à ressort", 35)),
    shared("Pas de côté"),
    shared("Entrave"),
    S(15, "Piège à ressort", 2, 0, 4, "Attaque", lambda c, L: f"Pose un piège : {dmg(2, L, 1.1)} dégâts"),
    S(20, "Pistolet à silex", 2, 0, 5, "Attaque", lambda c, L: f"{dmg(2, L, 1.1)} dégâts + ralentit 1 pm (1 tour)"),
    shared("Cri de guerre"),
    S(26, "Balle incendiaire", 3, 0, 5, "Attaque", lambda c, L: f"{dmg(3, L, 0.9)} dégâts + brûle {dot(L, 0.8)} dégâts/tour (2 tours)"),
    S(30, "Grenade assourdissante", 3, 0, 5, "Attaque", lambda c, L: f"{dmg(3, L, 0.7)} dégâts en zone (3x3) + étourdit 1 tour (30%)"),
    shared("Marque du prédateur"),
    S(40, "Tir de précision", 3, 0, 6, "Attaque", lambda c, L: f"{dmg(3, L, 1.05)} dégâts" + combo("brûlure", 50)),
    S(44, "Mine à fragmentation", 3, 0, 4, "Attaque", lambda c, L: f"Pose un piège (mine) : {dmg(3, L, 1.0)} dégâts; explose en croix si on la déclenche"),
    S(48, "Surcharge", 2, 0, 0, "Buff", lambda c, L: "+30% dégâts (2 tours)"),
    S(55, "Fusil à lunette", 4, 0, 7, "Attaque", lambda c, L: f"{dmg(4, L, 1.1)} dégâts"),
    S(60, "Roquette", 4, 0, 6, "Attaque", lambda c, L: f"{dmg(4, L, 0.85)} dégâts en zone (3x3)" + combo("étourdissement", 40)),
    S(70, "Rafale de mitraillette", 4, 0, 5, "Attaque", lambda c, L: f"{dmg(4, L, 0.65)} dégâts à tous les ennemis"),
    S(75, "Canon à main", 4, 0, 4, "Attaque", lambda c, L: f"{dmg(4, L, 1.2)} dégâts" + chain("Fusil à pompe", 40)),
    S(88, "Bombe à fragmentation", 4, 0, 6, "Attaque", lambda c, L: f"{dmg(4, L, 1.0)} dégâts en zone (4x4)"),
    S(95, "Tir d'artillerie", 4, 0, 8, "Attaque", lambda c, L: f"{dmg(4, L, 1.4)} dégâts (<30% pv)"),
]


def resolve(classe, entry):
    """Retourne (niveau, nom, pa, pm, portée, type, effet)."""
    if isinstance(entry, tuple) and entry[0] == "shared":
        name = entry[1]
        pa, pm, rng, typ, fn, levels = SHARED[name]
        L = levels[classe]
        return (L, name, pa, pm, rng, typ, fn(classe, L))
    L, name, pa, pm, rng, typ, fn = entry
    return (L, name, pa, pm, rng, typ, fn(classe, L))


def cols(classe, typ, effect):
    phys = mag = soins = 0
    m = re.search(r"(\d+) dégâts(?!/)", effect)
    if typ == "Attaque" and m:
        v = int(m.group(1))
        if classe in MAGIC or "magique" in effect.lower():
            mag = v
        else:
            phys = v
    mh = re.search(r"Restaure (\d+) PV", effect)
    if typ == "Soin" and mh:
        soins = int(mh.group(1))
    return phys, mag, soins


def main():
    with open(BASE, encoding="utf-8") as f:
        base = list(csv.DictReader(f))
    rows = [[r[h] for h in HEADER] for r in base]
    names_by_class = {c: {r["Nom"] for r in base if r["Classe"] == c} for c in CLASSES}
    for c in CLASSES:
        entries = NEW[c]
        assert len(entries) == 20, f"{c} : {len(entries)} sorts supplémentaires au lieu de 20"
        for e in entries:
            L, name, pa, pm, rng, typ, eff = resolve(c, e)
            assert "," not in eff and "," not in name, (c, name)
            assert name not in names_by_class[c], f"doublon {c} / {name}"
            names_by_class[c].add(name)
            ph, mg_, so = cols(c, typ, eff)
            rows.append([c, name, pa, pm, rng, eff, L, typ, ph, mg_, so, 0, 0, 0, 0, 0, 0])
    order = {c: i for i, c in enumerate(CLASSES)}
    rows.sort(key=lambda r: (order[r[0]], int(r[6]), r[1]))
    with open(OUT, "w", encoding="utf-8", newline="") as f:
        w = csv.writer(f, lineterminator="\n")
        w.writerow(HEADER)
        w.writerows(rows)
    # progression_sorts.txt : sorts débloqués par niveau
    prog = {}
    for r in rows:
        prog.setdefault((r[0], int(r[6])), []).append(r[1])
    with open(PROG, "w", encoding="utf-8", newline="") as f:
        w = csv.writer(f, lineterminator="\n")
        w.writerow(["Classe", "Niveau", "Sorts débloqués (séparés par \";\")"])
        for (c, L) in sorted(prog, key=lambda k: (order[k[0]], k[1])):
            w.writerow([c, L, ";".join(prog[(c, L)])])
    per = {c: sum(1 for r in rows if r[0] == c) for c in CLASSES}
    print("sorts par classe :", per, "total", len(rows))
    sh = {}
    for r in rows:
        sh.setdefault(r[1], set()).add(r[0])
    print("sorts partagés :", sum(1 for v in sh.values() if len(v) > 1))


if __name__ == "__main__":
    main()
