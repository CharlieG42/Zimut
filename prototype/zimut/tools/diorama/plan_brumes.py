"""Plan du Marais des Brumes (Nation des Brumes), monde 96x96 comme la Sylve et le Brasier.
Donjon de la Nation (tour) au centre, un donjon dans chaque coin, des mares, des bois noyés, des cabanes de tourbiers."""
S = 96.0
OFF = 24.0
C = 48.0
NATION = "brumes"
BOARD_STEM = "brumes_marais_diorama"
ASSET_DIR = "brumes_diorama"
HMAX = 2.6

# routes : du pourtour du donjon central vers chaque coin, plus le sentier de l'ouest (retour) et le portail de l'est
ROADS = [([(42.5, 48.0), (30, 50), (18, 52), (6, 52), (-0.5, 51)], 2.0, 1.5),                    # ouest (Sentier des Cendres)
         ([(54.0, 47.0), (66, 50), (78, 53), (90, 51), (96.5, 52)], 2.0, 1.5),                   # est (Portail vers les Cimes)
         ([(44, 42), (36, 34), (30, 27), (24, 22), (21, 20)], 1.6, 1.2),                          # coin haut (crypte)
         ([(52, 43), (60, 36), (70, 31), (79, 30.5)], 1.6, 1.2),                                  # coin droit (souche)
         ([(52, 53), (60, 60), (68, 70), (76, 80), (79, 84.5)], 1.6, 1.2),                        # coin bas (cabane)
         ([(44, 54), (36, 64), (26, 74), (19, 80.5)], 1.6, 1.2)]                                  # coin gauche (ruines)
FIELDS = []
MEADOWS = [("pre", 20.0, 52.0, 9.0, 7.0, 10), ("pre", 70.0, 62.0, 10.0, 8.0, -10), ("pre", 54.0, 18.0, 12.0, 7.0, 0),
           ("pre", 40.0, 78.0, 9.0, 6.0, 0)]
WOODS = [(8.0, 30.0, 7.0), (88.0, 76.0, 6.0), (60.0, 8.0, 6.5), (30.0, 94.0, 4.5), (92.0, 12.0, 5.0), (6.0, 66.0, 5.0)]
# plans d'eau : (x, z, demi-axe a, demi-axe b, angle)
LAKES = [(50.0, 74.0, 9.0, 6.0, -20.0), (26.0, 42.0, 6.0, 4.0, 40.0), (78.0, 40.0, 5.0, 3.5, 10.0), (36.0, 90.0, 6.0, 3.5, 0.0), (66.0, 20.0, 5.5, 3.5, -15.0)]
LAKE = LAKES[0]

PAL = dict(grass_lo=[0.16, 0.26, 0.16], grass_hi=[0.30, 0.42, 0.25], warm=[0.03, 0.02, -0.03], cool=[-0.04, 0.04, 0.04],
           blade_dark=((24, 12), (60, 30), (22, 10)), blade_light=((50, 30), (110, 50), (60, 40)),
           soil_a=[0.28, 0.25, 0.19], soil_b=[0.38, 0.34, 0.26], plaza=[0.33, 0.33, 0.29], gravel=(0.55, 0.55, 0.50),
           wood_floor=[0.60, 0.72, 0.58], meadow_mul=[1.05, 1.0, 0.85], meadow_add=[0.03, 0.03, 0.0],
           shore=[0.40, 0.38, 0.26], mud=[0.18, 0.22, 0.15])

# cabanes de tourbiers (coordonnées monde) : (bâtiment, x, z, rotation, échelle)
TOWN = [("chaumiere", 35.5, 44.0, 0, 1.0), ("maison_bois", 60.5, 42.5, 270, 1.0), ("longere", 38.5, 59.0, 90, 1.0),
        ("chaumiere2", 59.0, 57.5, 180, 1.0), ("maison_bois2", 46.0, 32.5, 0, 1.0), ("chaumiere", 31.0, 58.5, 90, 1.0)]
ROOF = {"chaumiere": (0.34, 0.38, 0.22), "chaumiere2": (0.32, 0.36, 0.24), "maison_bois": (0.26, 0.30, 0.24), "maison_bois2": (0.28, 0.26, 0.20),
        "longere": (0.30, 0.34, 0.22)}
WALL_MUL = (0.70, 0.76, 0.72)

DUNGEONS = [("Crypte du Marais Noir", "crypte", 18.0, 16.0), ("Souche du Vieux Saule", "souche", 80.0, 28.0),
            ("Cabane des Noyés", "pilotis", 80.0, 84.0), ("Ruines englouties", "ruine", 16.0, 80.0),
            ("Donjon de la Nation Brumes", "tour_brume", 48.0, 48.0)]
DUNGEON_RAD = {"grotte": 3.2, "mine": 3.2, "antre": 3.0, "sanctuaire": 3.8, "crypte": 3.0, "donjon_sylve": 2.6, "fosse": 3.6, "forteresse": 4.2,
               "tour_brume": 3.2, "souche": 3.2, "pilotis": 3.6, "ruine": 3.6}
START_W = (48.0, 56.5)
PLACES = [("Cabane sur pilotis", 44.0, 62.0), ("Rôdeurs brumeux", 30.0, 52.0), ("Coffre englouti", 56.0, 82.0),
          ("Spectres du ponton", 66.0, 68.0), ("Crapauds géants", 22.0, 62.0), ("Cache du passeur", 12.0, 44.0),
          ("Feu des tourbiers", 72.0, 56.0), ("Meute de loups blêmes", 86.0, 62.0), ("Hantise de la tourbière", 58.0, 28.0),
          ("Épave au trésor", 46.0, 90.0), ("Liche du marais", 74.0, 12.0), ("Arbre des esprits", 36.0, 16.0),
          ("Portail vers les Cimes", 94.0, 51.5), ("Sentier des Cendres", 1.6, 51.0)]

def poi_defs(repo):
    d = {
        "Cabane sur pilotis": {"kind": "camp", "level": 26, "desc": "Un refuge au-dessus de l'eau."},
        "Rôdeurs brumeux": {"kind": "combat", "level": 26, "desc": "Des formes se glissent dans la brume."},
        "Coffre englouti": {"kind": "chest", "level": 26, "desc": "Un coffre à moitié enfoui dans la vase."},
        "Spectres du ponton": {"kind": "combat", "level": 27, "desc": "Des spectres hantent le vieux ponton."},
        "Crapauds géants": {"kind": "combat", "level": 27, "desc": "Des crapauds énormes guettent dans les joncs."},
        "Cache du passeur": {"kind": "chest", "level": 28, "desc": "Le butin oublié d'un passeur de marais."},
        "Feu des tourbiers": {"kind": "camp", "level": 28, "desc": "Un feu discret, la seule chaleur du marais."},
        "Meute de loups blêmes": {"kind": "combat", "level": 28, "desc": "Des loups pâles aux yeux phosphorescents."},
        "Hantise de la tourbière": {"kind": "combat", "level": 29, "desc": "Une présence glaciale monte de la tourbe."},
        "Épave au trésor": {"kind": "chest", "level": 29, "desc": "Une épave engloutie dont la cale brille encore."},
        "Liche du marais": {"kind": "combat", "level": 31, "desc": "Un mort-vivant garde le marais."},
        "Arbre des esprits": {"kind": "reveal", "level": 26, "desc": "On voit loin depuis ses branches."},
        "Sentier des Cendres": {"kind": "exit", "level": 1, "back": True, "to": "brasier_cendres",
                                "desc": "Le chemin du retour vers les Terres de Cendre (toujours ouvert)."},
        "Portail vers les Cimes": {"kind": "exit", "level": 1, "portal": True, "requires": "Brumes", "to": "montagne_pics",
                                   "desc": "Un portail de lumière, scellé tant que le Gardien des Brumes règne."},
        "Crypte du Marais Noir": {"kind": "combat", "guardian": "Brumes#1", "desc": "Une crypte envahie par la vase : quatre salles, la plus douce des entrées."},
        "Ruines englouties": {"kind": "combat", "guardian": "Brumes#2", "desc": "Des ruines à demi noyées : quatre salles."},
        "Cabane des Noyés": {"kind": "combat", "guardian": "Brumes#3", "desc": "Une cabane sur pilotis où l'on n'est jamais seul : quatre salles."},
        "Souche du Vieux Saule": {"kind": "combat", "guardian": "Brumes#4", "desc": "Une souche creuse où brillent des champignons : quatre salles, très dures."},
        "Donjon de la Nation Brumes": {"kind": "combat", "guardian": "Brumes", "level": 31,
                                       "desc": "La tour du marais : quatre salles ; le Gardien veille sur la Pierre de Lune-des-Marais."},
    }
    for k, v in d.items():
        v["name"] = k
    return d
