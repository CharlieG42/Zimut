class_name Dungeons
extends RefCounted
## Dungeons.gd — Les Donjons de Nation du mode Aventure (V43).
##
## Chaque Nation possède un donjon de 4 salles, de plus en plus dures ; la 4e est la salle du
## Gardien (le boss de la Nation). On y accède par le lieu « Donjon » de la carte de la Nation
## (ancien « Sanctuaire »). Un donjon se refait autant de fois qu'on veut.
##
## Une expédition = les 4 salles à la suite. V124 : la dernière salle terminée est mémorisée (par donjon,
## dans la sauvegarde) : défaite, combat abandonné ou arrêt du jeu ne font rien perdre, on reprend à la
## salle suivante. Le joueur peut aussi RECOMMENCER le donjon depuis la salle 1 (`restart`).
##
## Pierre Élémentaire : le Gardien la laisse tomber avec 50 % de chances la 1re fois qu'on le bat,
## puis 5 % à chaque victoire suivante, tant que la Pierre n'est pas trouvée.
##
## État (dans save["adventure"]) :
##   "dungeon_rooms" : { donjon: 2..4 }                        prochaine salle des expéditions commencées
##   "dungeon"  : { "biome": Nation, "room": 1..4 }            ancien format (lu pour les anciennes sauvegardes)
##   "dungeons" : { Nation: { "clears": n, "boss_kills": n } } bilan permanent

const ROOMS := 4
const STONE_FIRST := 0.50
const STONE_LATER := 0.05
## Une défaite ramène-t-elle à la salle 1 ? (V124 : non, la progression est gardée)
const DEFEAT_RESETS := false


const ROOM_NAMES: Array[String] = ["Vestibule", "Galerie", "Sanctuaire intérieur", "Salle du Gardien"]
## Ennemis par salle (la salle 4 : le boss + 3 sbires).
const ROOM_COUNT: Array[int] = [3, 4, 4, 4]
## Bonus de dégâts des ennemis par salle (%) : la difficulté monte de salle en salle.
const ROOM_POWER: Array[float] = [0.0, 6.0, 12.0, 0.0]


static func is_dungeon(poi: Dictionary) -> bool:
	return String(poi.get("guardian", "")) != ""


## V82 : une Nation compte plusieurs donjons de difficulté croissante (monde ouvert). La clé « guardian »
## d'un POI est la Nation (« Forêt » = donjon principal, palier 5, avec Gardien et Pierre) ou
## « Forêt#1 » … « Forêt#4 » (mêmes 4 salles, ennemis plus faibles, pas de Pierre).
const TIERS := 5
const TIER_SEP := "#"


## Nation d'une clé de donjon (« Forêt#2 » → « Forêt »).
static func base(key: String) -> String:
	return key.split(TIER_SEP)[0]


## Palier d'une clé de donjon (1..TIERS ; la clé nue = palier le plus haut).
static func tier(key: String) -> int:
	var parts: PackedStringArray = key.split(TIER_SEP)
	if parts.size() < 2:
		return TIERS
	return clampi(int(parts[1]), 1, TIERS)


static func tier_key(biome: String, t: int) -> String:
	return biome if t >= TIERS else "%s%s%d" % [biome, TIER_SEP, t]


## Écart minimal (en niveaux) entre la salle 4 du palier 4 et la 1re salle du donjon final.
const FINAL_GAP := 3


## Niveau de la dernière salle d'un palier. Le donjon final (palier 5) culmine en haut de la tranche de
## la Nation ; les paliers 1 à 4 se répartissent régulièrement en dessous, avec FINAL_GAP niveaux
## d'écart avec la 1re salle du final : le final est donc réellement plus dur que les quatre autres.
static func tier_top(key: String) -> int:
	var band: Vector2i = Nations.level_band(base(key))
	var t: int = tier(key)
	if t >= TIERS:
		return band.y
	var final_first: int = maxi(band.x, band.y - (ROOMS - 1))
	var top4: int = maxi(band.x, final_first - FINAL_GAP)
	var top1: int = mini(top4, band.x + ROOMS - 1)
	return roundi(lerpf(float(top1), float(top4), float(t - 1) / float(TIERS - 2)))


## Niveau des ennemis d'une salle : les 4 derniers niveaux sous le sommet du palier.
static func room_level(key: String, room: int) -> int:
	var band: Vector2i = Nations.level_band(base(key))
	return clampi(tier_top(key) - (ROOMS - clampi(room, 1, ROOMS)), band.x, band.y)


## Déblocage séquentiel : un donjon ne s'ouvre qu'une fois terminé celui du palier juste en dessous
## (le plus haut donjon de même Nation, de palier inférieur, présent dans `pois`). Le palier le plus
## bas est toujours ouvert, et un donjon déjà terminé le reste (anciennes sauvegardes).
## Retourne le lieu à terminer d'abord ({} si le donjon est ouvert).
static func locked_by(adv: Dictionary, pois: Dictionary, key: String) -> Dictionary:
	if clears(adv, key) > 0:
		return {}
	var best: Dictionary = {}
	var best_tier: int = 0
	for k: String in pois.keys():
		var g: String = String((pois[k] as Dictionary).get("guardian", ""))
		if g == "" or base(g) != base(key):
			continue
		var t: int = tier(g)
		if t < tier(key) and t > best_tier:
			best_tier = t
			best = pois[k]
	if best.is_empty() or clears(adv, String(best["guardian"])) > 0:
		return {}
	return best


static func room_name(room: int) -> String:
	return ROOM_NAMES[clampi(room, 1, ROOMS) - 1]


## Salle à jouer : la première non terminée de ce donjon (1 si l'expédition n'est pas commencée).
static func current_room(adv: Dictionary, biome: String) -> int:
	var rooms: Dictionary = adv.get("dungeon_rooms", {})
	if rooms.has(biome):
		return clampi(int(rooms[biome]), 1, ROOMS)
	var d: Dictionary = adv.get("dungeon", {})        # ancien format
	if String(d.get("biome", "")) == biome:
		return clampi(int(d.get("room", 1)), 1, ROOMS)
	return 1


## Expédition commencée (au moins une salle terminée, donjon pas encore bouclé) ?
static func in_progress(adv: Dictionary, biome: String) -> bool:
	return current_room(adv, biome) > 1


## Recommencer : efface la progression de ce donjon (retour à la salle 1).
static func restart(adv: Dictionary, biome: String) -> void:
	_set_room(adv, biome, 1)


static func _set_room(adv: Dictionary, biome: String, room: int) -> void:
	var rooms: Dictionary = adv.get("dungeon_rooms", {})
	if room > 1:
		rooms[biome] = room
	else:
		rooms.erase(biome)
	if rooms.is_empty():
		adv.erase("dungeon_rooms")
	else:
		adv["dungeon_rooms"] = rooms
	if String((adv.get("dungeon", {}) as Dictionary).get("biome", "")) == biome:
		adv.erase("dungeon")


static func stats(adv: Dictionary, biome: String) -> Dictionary:
	return (adv.get("dungeons", {}) as Dictionary).get(biome, {"clears": 0, "boss_kills": 0})


static func clears(adv: Dictionary, biome: String) -> int:
	return int(stats(adv, biome).get("clears", 0))


## Chance de Pierre au prochain Gardien vaincu.
static func stone_chance(adv: Dictionary, biome: String) -> float:
	if tier(biome) < TIERS:
		return 0.0
	return STONE_FIRST if int(stats(adv, biome).get("boss_kills", 0)) == 0 else STONE_LATER


## Prépare le combat de la salle courante (niveau et nombre d'ennemis). Retourne le numéro de salle.
static func begin(adv: Dictionary, biome: String) -> int:
	var room: int = current_room(adv, biome)
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
		_set_room(adv, biome, room + 1)
		return out
	# Salle du Gardien vaincue : expédition terminée
	var all: Dictionary = adv.get("dungeons", {})
	var st: Dictionary = all.get(biome, {"clears": 0, "boss_kills": 0}).duplicate()
	out["cleared"] = true
	out["first_clear"] = int(st.get("clears", 0)) == 0
	out["chance"] = STONE_FIRST if int(st.get("boss_kills", 0)) == 0 else STONE_LATER
	if tier(biome) < TIERS:
		out["chance"] = 0.0           # paliers 1-2 : pas de Pierre (le Gardien de la Nation la garde)
	elif stone_owned:
		out["stone_roll"] = "owned"
	else:
		out["stone_roll"] = "won" if roll < float(out["chance"]) else "missed"
	st["clears"] = int(st.get("clears", 0)) + 1
	st["boss_kills"] = int(st.get("boss_kills", 0)) + 1
	all[biome] = st
	adv["dungeons"] = all
	_set_room(adv, biome, 1)
	return out


## Défaite : la progression du donjon est gardée (DEFEAT_RESETS = false) ; sinon retour à l'entrée.
static func lose(adv: Dictionary, biome: String = "") -> void:
	if DEFEAT_RESETS and biome != "":
		restart(adv, biome)
