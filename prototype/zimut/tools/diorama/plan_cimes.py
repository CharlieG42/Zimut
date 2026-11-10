"""Plan des Hauts Pics du Givre (Nation des Cimes), monde 96x96 comme les trois autres planches Diorama.
Donjon de la Nation au centre, un donjon dans chaque coin, un lac gelé, des pinèdes enneigées, un hameau de montagne."""
S = 96.0
OFF = 24.0
C = 48.0
NATION = "cimes"
BOARD_STEM = "montagne_pics_diorama"
ASSET_DIR = "cimes_diorama"
HMAX = 3.0

ROADS = [([(42.5, 48.0), (30, 50), (18, 52), (6, 52), (-0.5, 51)], 2.0, 1.5),                    # ouest (Sentier des Brumes)
         ([(54.0, 47.0), (66, 50), (78, 53), (90, 51), (96.5, 52)], 2.0, 1.5),                   # est (Portail vers les Vents)
         ([(44, 42), (36, 34), (30, 27), (24, 22), (21, 20)], 1.6, 1.2),                          # coin haut (caverne)
         ([(52, 43), (60, 36), (70, 31), (79, 30.5)], 1.6, 1.2),                                  # coin droit (mine)
         ([(52, 53), (60, 60), (68, 70), (76, 80), (79, 84.5)], 1.6, 1.2),                        # coin bas (forge)
         ([(44, 54), (36, 64), (26, 74), (19, 80.5)], 1.6, 1.2)]                                  # coin gauche (tour)
FIELDS = []
MEADOWS = [("pre", 22.0, 40.0, 9.0, 7.0, 10), ("pre", 70.0, 62.0, 10.0, 8.0, -10), ("pre", 58.0, 18.0, 11.0, 7.0, 0)]
WOODS = [(8.0, 30.0, 7.5), (88.0, 72.0, 6.5), (60.0, 8.0, 6.5), (30.0, 93.0, 5.0), (92.0, 12.0, 5.5), (6.0, 66.0, 5.5), (36.0, 70.0, 4.5), (66.0, 40.0, 4.0)]
LAKES = [(50.0, 76.0, 8.5, 5.5, -15.0)]
LAKE = LAKES[0]

# neige : « herbe » blanche bleutée, terre gelée gris-brun sur les sentiers
PAL = dict(grass_lo=[0.52, 0.60, 0.75], grass_hi=[0.70, 0.77, 0.88], warm=[0.02, 0.01, -0.01], cool=[-0.05, -0.02, 0.03],
           blade_dark=((170, 30), (185, 30), (215, 25)), blade_light=((225, 25), (232, 20), (245, 10)),
           soil_a=[0.30, 0.27, 0.28], soil_b=[0.40, 0.37, 0.38], plaza=[0.55, 0.56, 0.60], gravel=(0.70, 0.72, 0.78),
           wood_floor=[0.80, 0.88, 0.94], meadow_mul=[0.97, 0.98, 1.0], meadow_add=[0.0, 0.0, 0.01],
           shore=[0.80, 0.88, 0.96], mud=[0.62, 0.70, 0.82])

TOWN = [("chaumiere", 35.5, 44.0, 0, 1.0), ("maison_bois", 60.5, 42.5, 270, 1.0), ("longere", 38.5, 59.0, 90, 1.0),
        ("chaumiere2", 59.0, 57.5, 180, 1.0), ("maison_bois2", 46.0, 32.5, 0, 1.0), ("maison_bois", 31.0, 58.5, 90, 1.0)]
ROOF = {"chaumiere": (0.86, 0.90, 0.96), "chaumiere2": (0.82, 0.88, 0.95), "maison_bois": (0.88, 0.92, 0.97), "maison_bois2": (0.84, 0.89, 0.95),
        "longere": (0.86, 0.90, 0.96)}
WALL_MUL = (0.82, 0.80, 0.80)

DUNGEONS = [("Caverne du Givre", "grotte", 18.0, 16.0), ("Mine d'Or Gelée", "mine", 80.0, 28.0),
            ("Forge Givrée", "sanctuaire", 80.0, 84.0), ("Tour des Runes Violettes", "tour_brume", 16.0, 80.0),
            ("Donjon de la Nation Cimes", "forteresse", 48.0, 48.0)]
DUNGEON_RAD = {"grotte": 3.2, "mine": 3.2, "antre": 3.0, "sanctuaire": 3.8, "crypte": 3.0, "donjon_sylve": 2.6, "fosse": 3.6, "forteresse": 4.2,
               "tour_brume": 3.2, "souche": 3.2, "pilotis": 3.6, "ruine": 3.6}
START_W = (48.0, 57.0)
PLACES = [("Refuge du col", 44.0, 63.0), ("Loups des neiges", 30.0, 52.0), ("Coffre sous la glace", 56.0, 84.0),
          ("Trolls du lac gelé", 64.0, 70.0), ("Yétis", 22.0, 62.0), ("Cache du guide", 12.0, 44.0),
          ("Feu des bergers", 72.0, 56.0), ("Harpies des crêtes", 86.0, 62.0), ("Élémentaires de givre", 58.0, 28.0),
          ("Trésor de l'avalanche", 40.0, 90.0), ("Géant de glace", 74.0, 12.0), ("Belvédère des Cimes", 36.0, 16.0),
          ("Portail vers les Vents", 94.0, 51.5), ("Sentier des Brumes", 1.6, 51.0)]

def poi_defs(repo):
    d = {
        "Refuge du col": {"kind": "camp", "level": 32, "desc": "Un refuge de pierre, à l'abri du vent."},
        "Loups des neiges": {"kind": "combat", "level": 32, "desc": "Une meute blanche rôde autour du hameau."},
        "Coffre sous la glace": {"kind": "chest", "level": 33, "desc": "Un coffre pris dans la glace du lac."},
        "Trolls du lac gelé": {"kind": "combat", "level": 34, "desc": "Des trolls pêchent à travers la glace."},
        "Yétis": {"kind": "combat", "level": 35, "desc": "De grandes silhouettes velues dans la poudreuse."},
        "Cache du guide": {"kind": "chest", "level": 36, "desc": "Les réserves d'un guide de haute montagne."},
        "Feu des bergers": {"kind": "camp", "level": 36, "desc": "Un feu entretenu par les bergers des alpages."},
        "Harpies des crêtes": {"kind": "combat", "level": 38, "desc": "Elles plongent depuis les crêtes."},
        "Élémentaires de givre": {"kind": "combat", "level": 40, "desc": "Le froid lui-même prend forme."},
        "Trésor de l'avalanche": {"kind": "chest", "level": 40, "desc": "Ce qu'une avalanche a emporté, puis rendu."},
        "Géant de glace": {"kind": "combat", "level": 43, "desc": "Un géant garde les hauteurs."},
        "Belvédère des Cimes": {"kind": "reveal", "level": 32, "desc": "Toute la chaîne se découvre d'ici."},
        "Sentier des Brumes": {"kind": "exit", "level": 1, "back": True, "to": "brumes_marais",
                               "desc": "Le chemin du retour vers le Marais des Brumes (toujours ouvert)."},
        "Portail vers les Vents": {"kind": "exit", "level": 1, "portal": True, "requires": "Montagne", "to": "vents_plateau",
                                   "desc": "Un portail de lumière, scellé tant que le Gardien des Cimes règne."},
        "Forge Givrée": {"kind": "combat", "guardian": "Montagne#1", "desc": "Une forge éteinte sous le givre : quatre salles, la plus douce des entrées."},
        "Caverne du Givre": {"kind": "combat", "guardian": "Montagne#2", "desc": "Une caverne tapissée de glace : quatre salles."},
        "Tour des Runes Violettes": {"kind": "combat", "guardian": "Montagne#3", "desc": "Une tour gravée de runes : quatre salles, plus dures."},
        "Mine d'Or Gelée": {"kind": "combat", "guardian": "Montagne#4", "desc": "Une mine d'or prise par le gel : quatre salles, très dures."},
        "Donjon de la Nation Cimes": {"kind": "combat", "guardian": "Montagne", "level": 45,
                                      "desc": "La forteresse des sommets : quatre salles ; le Gardien veille sur la Pierre des Cimes."},
    }
    for k, v in d.items():
        v["name"] = k
    return d
