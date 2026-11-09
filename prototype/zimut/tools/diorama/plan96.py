"""Plan du monde de la Sylve 96x96 : le village (plan 48x48, décalé de +24) au centre, des plaines sauvages autour."""
import sys, os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
S = 96.0
OFF = 24.0          # décalage du village
C = 48.0            # centre (place du village)
V_ROADS = [([(-0.5, 29), (8, 28.5), (14, 22), (24, 24)], 1.6, 2.1),
           ([(24, 24), (32, 22.5), (40, 22), (48.5, 19)], 2.1, 1.6),
           ([(24, 24), (23, 17), (26, 13), (24, 9.6)], 1.9, 1.5),
           ([(24, 24), (23, 31), (18, 38), (15, 48.5)], 2.0, 1.5),
           ([(23.2, 30.5), (28, 35), (32, 36.5), (36.5, 37.0)], 1.4, 1.2),
           ([(33, 22.5), (36, 17), (40, 15.5), (42.4, 14.2)], 1.4, 1.1),
           ([(14, 22.5), (11, 19), (9.5, 14), (7, 8.5)], 1.4, 1.1)]
V_FIELDS = [("ble", 41.6, 34.0, 8.6, 4.8, 0), ("ble", 37.0, 5.4, 6.8, 4.6, -4),
            ("labour", 6.6, 44.0, 8.4, 4.2, 3), ("potager", 5.2, 38.8, 5.6, 3.0, 0),
            ("ble", 15.0, 3.6, 5.6, 3.6, 2)]
V_MEADOWS = [("pre", 8.0, 9.5, 9.5, 7.0, 0), ("pre", 44.2, 17.0, 6.0, 5.0, 0),
             ("pre", 27.0, 45.0, 7.0, 4.0, 0), ("pre", 44.0, 45.0, 5.2, 4.8, 0),
             ("pre", 4.5, 26.0, 5.5, 4.0, 0)]
V_ORCHARD = (21.4, 44.3, 4.4, 4.4)

def sh(pts):
    return [(x + OFF, z + OFF) for x, z in pts]
# routes : celles du village (décalées) + prolongements vers les plaines et les bords du monde
ROADS = [(sh(p), a, b) for p, a, b in V_ROADS] + [
    ([(23.5, 53.0), (14, 55.5), (6, 60), (-0.5, 62)], 1.6, 1.5),            # ouest
    ([(72.5, 43.0), (80, 40.5), (88, 44), (96.5, 41)], 1.6, 1.5),           # est
    ([(39.0, 72.5), (38, 80), (44, 88), (42, 96.5)], 1.5, 1.4),             # sud
    ([(31.0, 32.5), (26, 26), (21, 20), (15.5, 15.5)], 1.1, 1.0),           # vers les ruines (nord-ouest)
    ([(80.5, 41.0), (82, 34), (83.5, 25.5)], 1.2, 1.0),                     # vers le lac
    ([(70.5, 80.5), (76, 84), (82, 87), (86.5, 90.0)], 1.2, 1.1),            # du hameau à l'Antre de la Patte (coin sud)
    ([(38.6, 82.0), (50, 85.5), (62, 84), (70.5, 80.5)], 1.2, 1.1),          # vers le hameau (sud-est)
    ([(66.4, 38.2), (70, 30), (68, 18), (62, 10)], 1.0, 0.9),               # sentier du nord-est (moulin -> collines)
]
FIELDS = [(k, x + OFF, z + OFF, w, h, a) for k, x, z, w, h, a in V_FIELDS] + [
    ("ble", 77.0, 85.0, 8.0, 4.6, 8), ("labour", 64.0, 90.0, 7.0, 3.8, -5), ("ble", 84.5, 76.0, 6.0, 4.0, 0)]
MEADOWS = [(k, x + OFF, z + OFF, w, h, a) for k, x, z, w, h, a in V_MEADOWS] + [
    ("pre", 13.0, 40.0, 13.0, 11.0, 10), ("pre", 85.0, 62.0, 11.0, 13.0, -8), ("pre", 52.0, 10.0, 13.0, 8.0, 0),
    ("pre", 22.0, 82.0, 12.0, 10.0, 15), ("pre", 60.0, 78.0, 8.0, 6.0, 0)]
ORCHARD = (V_ORCHARD[0] + OFF, V_ORCHARD[1] + OFF, V_ORCHARD[2], V_ORCHARD[3])
LAKE = (84.0, 15.0, 8.5, 5.8, 15.0)          # centre x, z, demi-axes, angle
WOODS = [(10.0, 10.0, 8.5), (11.0, 88.0, 8.0), (5.0, 66.0, 5.0), (64.0, 4.0, 5.5), (92.0, 52.0, 4.5), (30.0, 92.0, 4.0), (93.0, 72.0, 4.0)]
RUINS = (16.0, 15.0)                         # ruines du fort (nord-ouest)
STONES = (90.0, 30.0)                        # cercle de pierres levées (plaine de l est)
HAMLET = [("chaumiere", 72.0, 77.5, 180, 1.0), ("grange", 81.0, 80.5, 270, 1.0), ("maison_bois2", 66.0, 75.0, 90, 1.0)]

# ── Donjons (V118) : bâtiment 3D propre à chaque donjon ; le lieu est posé devant l'entrée
NATION = "sylve"
BOARD_STEM = "foret_sylve_diorama"
ASSET_DIR = "sylve_diorama"
# V122 — règle de placement (valable pour toutes les Nations) : un donjon dans chacun des 4 coins du monde (pointes du
# losange à l'écran : haut, droite, bas, gauche), le donjon de la Nation au centre ; rien de haut ne se dresse devant
# l'entrée (cône de vue dégagé dans wild96.py / layout_brasier.py).
DUNGEONS = [("Grotte de la Feuille", "grotte", 17.0, 83.0), ("Antre de la Patte", "antre", 85.0, 87.5),
            ("Sanctuaire de Cristal", "sanctuaire", 74.5, 21.5), ("Crypte du Chêne Noir", "crypte", 16.0, 14.0),
            ("Donjon de la Nation Sylvestre", "donjon_sylve", 48.0, 48.0)]
DUNGEON_RAD = {"grotte": 3.2, "mine": 3.2, "antre": 3.0, "sanctuaire": 3.8, "crypte": 3.0, "donjon_sylve": 2.6, "fosse": 3.6, "forteresse": 4.2}

START_W = (48.0, 54.2)
PLACES = [("Source claire", 44.0, 59.2), ("Coffre moussu", 50.6, 69.6), ("Camp gobelin", 55.2, 57.4),
          ("Tanière du sanglier", 35.6, 55.4), ("Meute de loups gris", 58.0, 88.5),
          ("Clairière des lucioles", 84.5, 62.0), ("Embuscade sous les pins", 88.0, 50.0),
          ("Souche creuse", 13.0, 40.0), ("Poste de la Citadelle", 86.5, 34.0),
          ("Refuge des hauteurs", 52.0, 11.0), ("Cache du bûcheron", 60.5, 7.0),
          ("Garde des cimes", 34.0, 8.0), ("Antre du prédateur", 26.0, 4.5),
          ("Belvédère de la Sylve", 70.0, 4.0), ("Portail vers les Cendres", 4.0, 24.0)]

def poi_defs(repo):
    """Lieux de la Sylve : ceux de la planche iso (mêmes textes, niveaux, gardiens)."""
    import json
    iso = json.load(open(repo + "/data/boards/foret_sylve_iso.json"))
    return {v["name"]: v for v in iso["pois"].values()}
