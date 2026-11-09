"""Plan des Terres de Cendre (Nation du Brasier), monde 96x96 comme la Sylve.
Un bourg de forgerons au centre, des rivières de lave descendues du volcan (nord-est), des landes de cendre,
des bois calcinés, des champs d'obsidienne ; cinq donjons, chacun avec son bâtiment."""
S = 96.0
OFF = 24.0
C = 48.0
NATION = "brasier"
BOARD_STEM = "brasier_cendres_diorama"
ASSET_DIR = "brasier_diorama"
HMAX = 12.0                      # hauteur maximale (volcan) -> DIORAMA_AMP

# V122 : la forteresse de la Nation occupe le centre du bourg ; les routes partent de son pourtour
ROADS = [([(42.5, 47.5), (30, 50), (18, 49), (6, 52), (-0.5, 51)], 2.0, 1.5),             # ouest (Sentier de la Sylve)
         ([(56, 46), (66, 49), (78, 52), (90, 50), (96.5, 52)], 2.0, 1.5),               # est (Portail des Brumes)
         ([(47, 57), (44, 68), (40, 76), (34, 82), (26, 84.5), (19, 85.5)], 1.9, 1.4),    # sud-ouest (Galerie des Scories, coin gauche)
         ([(44, 43), (40, 36), (34, 30), (26, 24)], 1.6, 1.2),                            # nord-ouest (fosse, coin haut)
         ([(47, 57), (56, 66), (66, 74), (70, 82), (75, 87), (79.5, 89.5)], 1.4, 1.1),    # sud-est (mine de braise, coin bas)
         ([(66, 49), (72, 40), (76, 34), (80.5, 33.5)], 1.1, 1.0)]                        # belvédère du cratère puis antre (coin droit)
FIELDS = []
MEADOWS = [("pre", 22.0, 36.0, 12.0, 8.0, 15), ("pre", 76.0, 66.0, 10.0, 9.0, -10), ("pre", 52.0, 86.0, 12.0, 7.0, 0),
           ("pre", 10.0, 74.0, 8.0, 10.0, 0)]
WOODS = [(10.0, 10.0, 8.0), (10.0, 90.0, 7.0), (46.0, 92.0, 4.5), (92.0, 70.0, 4.0), (38.0, 8.0, 4.5)]
VOLCANO = (83.0, 13.0, 14.0, 11.0, 3.2)
LAVA = [([(80.5, 15.5), (74, 22), (70, 36), (64, 44), (61, 56), (63, 70), (58, 84), (56, 96.5)], 1.7),
        ([(70, 36), (60, 34), (52, 26), (44, 18), (40, 6), (41, -0.5)], 1.2),
        ([(63, 70), (74, 76), (84, 80), (96.5, 82)], 1.0)]
LAVA_POOLS = [(22.0, 20.0, 2.2)]          # fosse ardente (lac de lave rond, rendu par le bâtiment du donjon)
OBSIDIAN = [(20.0, 40.0, 3.0), (78.0, 62.0, 3.0), (92.0, 44.0, 2.5), (8.0, 30.0, 2.0)]

PAL = dict(grass_lo=[0.26, 0.22, 0.20], grass_hi=[0.46, 0.37, 0.30], warm=[0.12, 0.03, -0.03], cool=[-0.03, -0.02, 0.02],
           blade_dark=((40, 14), (36, 12), (34, 10)), blade_light=((110, 40), (88, 40), (60, 30)),
           soil_a=[0.30, 0.26, 0.25], soil_b=[0.42, 0.37, 0.34], plaza=[0.28, 0.25, 0.25], gravel=(0.62, 0.58, 0.56),
           wood_floor=[0.62, 0.56, 0.54], meadow_mul=[1.15, 1.02, 0.78], meadow_add=[0.06, 0.04, 0.0])

# bourg (coordonnées monde) : (bâtiment, x, z, rotation, échelle)
TOWN = [("forge", 40.0, 41.0, 0, 1.0), ("taverne", 56.0, 40.5, 0, 1.0), ("manoir", 41.0, 55.5, 90, 1.0),
        ("maison_haute", 50.0, 67.0, 270, 1.0), ("tour_hex", 36.0, 47.0, 0, 1.0), ("maison_pierre2", 49.0, 35.0, 0, 1.0),
        ("forge", 61.0, 46.0, 270, 1.0), ("maison_L", 33.0, 37.5, 0, 1.0), ("colombage", 54.0, 61.5, 180, 1.0),
        ("maison_pierre", 63.0, 38.5, 0, 1.0), ("tour_hex", 60.0, 51.5, 0, 1.0), ("chapelle", 47.5, 28.0, 0, 1.0)]
ROOF = {"forge": (0.22, 0.20, 0.21), "taverne": (0.50, 0.17, 0.12), "manoir": (0.20, 0.19, 0.22), "maison_haute": (0.44, 0.16, 0.12),
        "tour_hex": (0.42, 0.14, 0.10), "maison_pierre2": (0.30, 0.25, 0.25), "maison_L": (0.48, 0.20, 0.13), "colombage": (0.26, 0.22, 0.22),
        "maison_pierre": (0.52, 0.19, 0.12), "chapelle": (0.18, 0.17, 0.20)}
WALL_MUL = (0.82, 0.74, 0.70)

# V122 — même règle que la Sylve : un donjon par coin (haut, droite, bas, gauche), la forteresse de la Nation au centre.
# (le bâtiment de la forteresse s'étend derrière sa porte : on l'ancre à +2 pour qu'il soit centré sur la place)
DUNGEONS = [("Galerie des Scories", "grotte", 15.0, 82.0), ("Mine de Braise", "mine", 82.0, 88.0),
            ("Antre de la Salamandre", "antre", 83.0, 32.0), ("Fosse Ardente", "fosse", 22.0, 20.0),
            ("Donjon de la Nation Brasier", "forteresse", 50.0, 50.0)]
DUNGEON_RAD = {"grotte": 3.2, "mine": 3.2, "antre": 3.0, "sanctuaire": 3.8, "crypte": 3.0, "donjon_sylve": 2.6, "fosse": 3.6, "forteresse": 4.2}
START_W = (48.0, 57.0)
PLACES = [("Source chaude", 47.0, 61.5), ("Forge abandonnée", 38.0, 60.0), ("Lieutenants de braise", 34.0, 50.5),
          ("Embuscade dans la cendre", 24.0, 46.0), ("Coffre scellé", 20.0, 40.0), ("Bivouac des forgerons", 46.0, 72.0),
          ("Repaire des bêtes", 56.5, 78.0), ("Trésor enfoui", 52.0, 88.0), ("Camp de monstres", 78.0, 66.5),
          ("Refuge de basalte", 84.0, 46.5), ("Cache du mineur", 91.0, 36.0), ("Golem de lave", 76.0, 34.5),
          ("Cratère-belvédère", 73.5, 31.5), ("Repaire des salamandres", 34.0, 26.0),
          ("Portail vers les Brumes", 94.0, 51.5), ("Sentier de la Sylve", 1.6, 51.0), ("Bois calciné", 6.0, 74.0)]

def poi_defs(repo):
    d = {
        "Source chaude": {"kind": "camp", "level": 18, "desc": "Une source bienfaisante au cœur du bourg."},
        "Forge abandonnée": {"kind": "chest", "level": 18, "desc": "Une forge oubliée, encore tiède."},
        "Lieutenants de braise": {"kind": "combat", "level": 18, "desc": "Des soldats de feu montent la garde."},
        "Embuscade dans la cendre": {"kind": "combat", "level": 19, "desc": "Des pillards surgissent des congères de cendre."},
        "Coffre scellé": {"kind": "chest", "level": 19, "desc": "Un coffre pris dans l'obsidienne."},
        "Bivouac des forgerons": {"kind": "camp", "level": 19, "desc": "Un feu tranquille, des enclumes qui refroidissent."},
        "Repaire des bêtes": {"kind": "combat", "level": 20, "desc": "Des bêtes de braise rôdent près de la lave."},
        "Trésor enfoui": {"kind": "chest", "level": 21, "desc": "Quelque chose brille sous les scories."},
        "Camp de monstres": {"kind": "combat", "level": 22, "desc": "Des monstres ont dressé leur camp dans la lande."},
        "Refuge de basalte": {"kind": "camp", "level": 21, "desc": "Un abri de pierre noire, à l'écart des fumées."},
        "Cache du mineur": {"kind": "chest", "level": 22, "desc": "Un sac oublié au pied des rochers."},
        "Golem de lave": {"kind": "combat", "level": 25, "desc": "Un colosse de roche en fusion."},
        "Cratère-belvédère": {"kind": "reveal", "level": 18, "desc": "Du bord du cratère on voit loin."},
        "Repaire des salamandres": {"kind": "combat", "level": 21, "desc": "Des salamandres se chauffent sur les pierres."},
        "Bois calciné": {"kind": "combat", "level": 23, "desc": "Des esprits de cendre hantent les arbres morts."},
        "Sentier de la Sylve": {"kind": "exit", "level": 1, "back": True, "to": "foret_sylve",
                                "desc": "Le chemin du retour vers la Grande Forêt de la Sylve (toujours ouvert)."},
        "Portail vers les Brumes": {"kind": "exit", "level": 1, "portal": True, "requires": "Brasier", "to": "brumes_marais",
                                    "desc": "Un portail de lumière, scellé tant que le Gardien du Brasier règne."},
        "Galerie des Scories": {"kind": "combat", "guardian": "Brasier#1", "desc": "Des galeries de scories : quatre salles, la plus douce des entrées."},
        "Mine de Braise": {"kind": "combat", "guardian": "Brasier#2", "desc": "Une mine où la roche rougeoie : quatre salles."},
        "Antre de la Salamandre": {"kind": "combat", "guardian": "Brasier#3", "desc": "Le repaire d'une salamandre géante : quatre salles."},
        "Fosse Ardente": {"kind": "combat", "guardian": "Brasier#4", "desc": "Un puits de lave cerné de menhirs : quatre salles, très dures."},
        "Donjon de la Nation Brasier": {"kind": "combat", "guardian": "Brasier", "level": 25,
                                        "desc": "La forteresse au pied du volcan : quatre salles ; le Gardien veille sur la Pierre de Braise."},
    }
    for k, v in d.items():
        v["name"] = k
    return d
