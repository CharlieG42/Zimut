extends Node
## AdventureManager.gd — Logique du mode Aventure (aucun rendu).
##
## État, déplacement, brouillard de guerre, interactions des POI et ponts
## inter-modes (révélation de villes pour la Conquête). Le rendu vit dans
## AdventureMapUI.gd ; le catalogue officiel (zones, POI, énigmes) est dans
## ProgressionManager (ADVENTURE_ZONES / ADVENTURE_POIS / ADVENTURE_PUZZLES).
##
## La progression reste dans la sauvegarde commune partagée avec le mode
## Tactique et le mode Conquête (roster, XP, inventaire, forge).

signal message(text: String)
signal poi_completed(key: String)
signal zone_changed(zone_id: String)
signal cities_revealed(city_ids: Array)

const KIND_COMBAT := "combat"
const KIND_CHEST := "chest"
const KIND_PUZZLE := "puzzle"
const KIND_CAMP := "camp"
const KIND_REVEAL := "reveal"
const KIND_EXIT := "exit"

var save: Dictionary = {}
var slot: int = -1
var state: Dictionary = {}

func _ready() -> void:
	load_state(GameManager.active_save, GameManager.active_slot)

## Charge l'état Aventure depuis une sauvegarde (ou l'initialise).
func load_state(data: Dictionary, slot_no: int) -> void:
	save = data
	slot = slot_no
	if save.is_empty() or slot < 0:
		state = {}
		return
	state = ProgressionManager.adventure_state(save)
	save["campaign_mode"] = "adventure"
	persist()

## Zone courante du héros.
func zone_id() -> String:
	return String(state.get("zone", "foret_sylve"))

## Métadonnées de la zone courante.
func zone_meta() -> Dictionary:
	return ProgressionManager.adventure_zone_meta(zone_id())

## Nom affichable de la zone courante.
func zone_name() -> String:
	return ProgressionManager.adventure_zone_name(zone_id())

## Biome de la zone courante (rendu + combats).
func zone_biome() -> String:
	return ProgressionManager.adventure_zone_biome(zone_id())

## Dimensions de la grille de la zone courante.
func zone_size() -> Vector2i:
	var s: Array = zone_meta().get("size", [10, 7])
	return Vector2i(int(s[0]), int(s[1]))

## Position du héros sur la grille.
func hero_pos() -> Vector2i:
	var p: Array = state.get("hero_pos", [1, 3])
	return Vector2i(int(p[0]), int(p[1]))

## Nombre de pas parcourus (zone et mode confondus).
func moves() -> int:
	return int(state.get("moves", 0))

## POI à une position de la zone courante ({} si aucun).
func poi_at(pos: Vector2i) -> Dictionary:
	return ProgressionManager.adventure_poi(zone_id(), pos)

## Clé de sauvegarde d'un POI : "zone,x,y".
func poi_key(pos: Vector2i) -> String:
	return ProgressionManager.adventure_poi_key(zone_id(), pos)

## Le POI à cette position est-il déjà complété ?
func poi_done(pos: Vector2i) -> bool:
	return ProgressionManager.adventure_poi_completed(state, poi_key(pos))

## Déplacement possible : case adjacente (4 directions), dans la grille.
func can_move_to(pos: Vector2i) -> bool:
	var h := hero_pos()
	var size := zone_size()
	if pos.x < 0 or pos.y < 0 or pos.x >= size.x or pos.y >= size.y:
		return false
	return absi(pos.x - h.x) + absi(pos.y - h.y) == 1

## Déplace le héros d'une case : pas + brouillard de guerre révélé autour
## de la nouvelle position. Retourne les clés fraîchement découvertes.
func move_hero(pos: Vector2i) -> Array:
	if not can_move_to(pos):
		return []
	var fresh: Array = ProgressionManager.adventure_move(state, pos)
	persist()
	return fresh

## Une case est-elle hors brouillard dans la zone courante ?
func cell_discovered(pos: Vector2i) -> bool:
	return ProgressionManager.adventure_cell_discovered(state, pos)

## Interaction avec le POI sous le héros. Retourne une commande décrivant
## ce que l'UI doit faire : { "action": ... } — la logique de récompense
## est ici, le rendu reste dans l'UI.
func interact() -> Dictionary:
	var pos := hero_pos()
	var poi := poi_at(pos)
	if poi.is_empty() or poi_done(pos):
		return {"action": "nothing"}
	var key := poi_key(pos)
	match String(poi.get("kind", "")):
		KIND_PUZZLE:
			var puzzle: Dictionary = ProgressionManager.ADVENTURE_PUZZLES.get(key, {})
			if puzzle.is_empty():
				return {"action": "nothing"}
			return {"action": "puzzle", "key": key, "puzzle": puzzle.duplicate(true)}
		KIND_CHEST:
			var looted: Array = open_chest(key, int(poi.get("level", 10)))
			return {"action": "chest", "loots": looted}
		KIND_CAMP:
			rest_at_camp(key)
			return {"action": "camp"}
		KIND_REVEAL:
			var cities: Array = complete_poi(key, KIND_REVEAL)
			var names: Array = []
			for c: String in cities:
				names.append(ProgressionManager.conquest_city_name(c))
			return {"action": "reveal", "cities": cities, "names": names}
		KIND_COMBAT:
			state["pending_challenge"] = key
			persist()
			return {"action": "combat", "key": key, "poi": poi.duplicate(true)}
		KIND_EXIT:
			return {"action": "exit", "key": key}
		_:
			return {"action": "nothing"}

## Valide la réponse d'une énigme : récompense et complétion si correcte.
func solve_puzzle(key: String, answer: String) -> bool:
	var puzzle: Dictionary = ProgressionManager.ADVENTURE_PUZZLES.get(key, {})
	if puzzle.is_empty():
		return false
	if answer.strip_edges().to_lower() != String(puzzle.get("answer", "")).strip_edges().to_lower():
		return false
	award_exploration_xp(int(ProgressionManager.ADVENTURE_BASE_XP * 2))
	complete_poi(key, KIND_PUZZLE)
	return true

## Coffre : XP d'exploration + un objet de l'inventaire commun.
func open_chest(key: String, level: int) -> Array:
	var drops: Array = ProgressionManager._roll_loots(maxi(1, level), false)
	var looted: Array = []
	if not drops.is_empty():
		save["inventory"].append(drops[0])
		looted.append(drops[0])
	award_exploration_xp(ProgressionManager.ADVENTURE_BASE_XP)
	complete_poi(key, KIND_CHEST)
	persist()
	return looted

## Camp (source claire) : petit boost d'XP d'exploration, réutilisable.
func rest_at_camp(_key: String) -> void:
	award_exploration_xp(int(ProgressionManager.ADVENTURE_BASE_XP * 0.5))
	persist()

## Sortie : débloque la/les zone(s) suivante(s) et affiche le sélecteur.
func take_exit(key: String) -> Array:
	var revealed: Array = complete_poi(key, KIND_EXIT)
	persist()
	return revealed

## Change de zone (si débloquée). Le héros repart du départ de la zone.
func enter_zone(next_zone: String) -> bool:
	if not ProgressionManager.adventure_enter_zone(state, next_zone):
		return false
	persist()
	zone_changed.emit(next_zone)
	return true

## Zones accessibles depuis l'UI (sélecteur de la carte).
func available_zones() -> Array:
	return ProgressionManager.adventure_available_zones(state)

## Niveau d'un défi de combat : celui du POI, sinon le niveau de l'équipe.
func challenge_level(poi: Dictionary = {}) -> int:
	return ProgressionManager.adventure_challenge_level(save, poi)

## Complète un POI et traite ses effets inter-modes (zones, villes Conquête).
func complete_poi(key: String, kind: String) -> Array:
	var revealed: Array = ProgressionManager.adventure_complete_poi(state, key, kind)
	persist()
	poi_completed.emit(key)
	var city_ids: Array = []
	for r: String in revealed:
		if not String(r).begins_with("zone:"):
			city_ids.append(r)
	if not city_ids.is_empty():
		cities_revealed.emit(city_ids)
	return revealed

## XP d'exploration : même moteur que le reste du jeu (roster complet).
func award_exploration_xp(xp: int) -> void:
	ProgressionManager.award_xp(save, xp)
	persist()

## Le combat Aventure est résolu par ProgressionManager après la victoire
## tactique (pending_challenge) ; on expose ici le niveau/biome du défi.
func pending_challenge() -> String:
	return String(state.get("pending_challenge", ""))

func persist() -> void:
	if save.is_empty() or slot < 0:
		return
	save["adventure"] = state
	save["campaign_mode"] = "adventure"
	ProgressionManager.write_save(slot, save)
	GameManager.active_save = save
	GameManager.active_slot = slot
