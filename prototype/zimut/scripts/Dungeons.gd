class_name Dungeons
extends RefCounted
## Dungeons.gd — Les Donjons de Nation du mode Aventure (V43).
##
## Chaque Nation possède un donjon de 4 salles, de plus en plus dures ; la 4e est la salle du
## Gardien (le boss de la Nation). On y accède par le lieu « Donjon » de la carte de la Nation
## (ancien « Sanctuaire »). Un donjon se refait autant de fois qu'on veut.
##
## Une expédition = les 4 salles à la suite : la progression est mémorisée si l'on quitte la carte,
## mais une DÉFAITE renvoie à l'entrée (DEFEAT_RESETS).
##
## Pierre Élémentaire : le Gardien la laisse tomber avec 50 % de chances la 1re fois qu'on le bat,
## puis 5 % à chaque victoire suivante, tant que la Pierre n'est pas trouvée.
##
## État (dans save["adventure"]) :
##   "dungeon"  : { "biome": Nation, "room": 1..4 }            expédition en cours (absente sinon)
##   "dungeons" : { Nation: { "clears": n, "boss_kills": n } } bilan permanent

const ROOMS := 4
const STONE_FIRST := 0.50
const STONE_LATER := 0.05
## Une défaite ramène-t-elle à la salle 1 ?
const DEFEAT_RESETS := true

const ROOM_NAMES: Array[String] = ["Vestibule", "Galerie", "Sanctuaire intérieur", "Salle du Gardien"]
## Ennemis par salle (la salle 4 : le boss + 3 sbires).
const ROOM_COUNT: Array[int] = [3, 4, 4, 4]
## Bonus de dégâts des ennemis par salle (%) : la difficulté monte de salle en salle.
const ROOM_POWER: Array[float] = [0.0, 6.0, 12.0, 0.0]


static func is_dungeon(poi: Dictionary) -> bool:
	return String(poi.get("guardian", "")) != ""


## Niveau des ennemis d'une salle : les 4 derniers niveaux de la tranche de la Nation.
static func room_level(biome: String, room: int) -> int:
	var band: Vector2i = Nations.level_band(biome)
	return clampi(band.y - (ROOMS - clampi(room, 1, ROOMS)), band.x, band.y)


static func room_name(room: int) -> String:
	return ROOM_NAMES[clampi(room, 1, ROOMS) - 1]


## Salle à jouer : celle de l'expédition en cours dans cette Nation, sinon la 1re.
static func current_room(adv: Dictionary, biome: String) -> int:
	var d: Dictionary = adv.get("dungeon", {})
	if String(d.get("biome", "")) == biome:
		return clampi(int(d.get("room", 1)), 1, ROOMS)
	return 1


static func stats(adv: Dictionary, biome: String) -> Dictionary:
	return (adv.get("dungeons", {}) as Dictionary).get(biome, {"clears": 0, "boss_kills": 0})


static func clears(adv: Dictionary, biome: String) -> int:
	return int(stats(adv, biome).get("clears", 0))


## Chance de Pierre au prochain Gardien vaincu.
static func stone_chance(adv: Dictionary, biome: String) -> float:
	return STONE_FIRST if int(stats(adv, biome).get("boss_kills", 0)) == 0 else STONE_LATER


## Prépare le combat de la salle courante (niveau et nombre d'ennemis). Retourne le numéro de salle.
static func begin(adv: Dictionary, biome: String) -> int:
	var room: int = current_room(adv, biome)
	adv["dungeon"] = {"biome": biome, "room": room}
	adv["pending_level"] = room_level(biome, room)
	adv["pending_count"] = ROOM_COUNT[room - 1]
	return room


## Salle de l'expédition à laquelle appartient le défi en cours (0 si ce n'est pas un donjon).
static func pending_room(adv: Dictionary, guardian_biome: String) -> int:
	if guardian_biome == "":
		return 0
	return current_room(adv, guardian_biome)


## Victoire : avance d'une salle ou termine l'expédition. `roll` ∈ [0,1) tire la Pierre.
## Retourne { biome, room, rooms, cleared, first_clear, chance, stone_roll("" | "won" | "missed" | "owned") }.
static func win_room(adv: Dictionary, biome: String, roll: float, stone_owned: bool) -> Dictionary:
	var room: int = current_room(adv, biome)
	var out: Dictionary = {"biome": biome, "room": room, "rooms": ROOMS, "cleared": false,
		"first_clear": false, "chance": 0.0, "stone_roll": ""}
	if room < ROOMS:
		adv["dungeon"] = {"biome": biome, "room": room + 1}
		return out
	# Salle du Gardien vaincue : expédition terminée
	var all: Dictionary = adv.get("dungeons", {})
	var st: Dictionary = all.get(biome, {"clears": 0, "boss_kills": 0}).duplicate()
	out["cleared"] = true
	out["first_clear"] = int(st.get("clears", 0)) == 0
	out["chance"] = STONE_FIRST if int(st.get("boss_kills", 0)) == 0 else STONE_LATER
	if stone_owned:
		out["stone_roll"] = "owned"
	else:
		out["stone_roll"] = "won" if roll < float(out["chance"]) else "missed"
	st["clears"] = int(st.get("clears", 0)) + 1
	st["boss_kills"] = int(st.get("boss_kills", 0)) + 1
	all[biome] = st
	adv["dungeons"] = all
	adv.erase("dungeon")
	return out


## Défaite : retour à l'entrée (si DEFEAT_RESETS).
static func lose(adv: Dictionary) -> void:
	if DEFEAT_RESETS:
		adv.erase("dungeon")
