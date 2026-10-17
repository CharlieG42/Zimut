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

## Déplacement possible : case adjacente (4 directions), dans la grille, sans obstacle.
func can_move_to(pos: Vector2i) -> bool:
	var h := hero_pos()
	var size := zone_size()
	if pos.x < 0 or pos.y < 0 or pos.x >= size.x or pos.y >= size.y:
		return false
	if not AdventureTerrain.walkable(zone_id(), pos):
		return false
	return absi(pos.x - h.x) + absi(pos.y - h.y) == 1

## Chemin jusqu'à une case découverte (déplacement par appui) : [] si impossible.
## On ne traverse ni le brouillard ni un camp ennemi non vaincu (sauf s'il est la destination).
func path_to(target: Vector2i) -> Array[Vector2i]:
	if not cell_discovered(target):
		return []
	var blocked: Dictionary = {}
	var size := zone_size()
	for y: int in range(size.y):
		for x: int in range(size.x):
			var c := Vector2i(x, y)
			if not cell_discovered(c):
				blocked[c] = true
	for k: String in ProgressionManager.adventure_zone_pois(zone_id()).keys():
		var pos := AdventureTerrain.parse(k)
		var poi: Dictionary = ProgressionManager.adventure_zone_pois(zone_id())[k]
		if String(poi.get("kind", "")) == KIND_COMBAT and not poi_done(pos):
			blocked[pos] = true
	# On ne franchit une porte que si c'est la destination choisie.
	for g: Vector2i in gates().keys():
		blocked[g] = true
	return AdventureTerrain.find_path(zone_id(), hero_pos(), target, blocked)


## ── Portes vers les cartes voisines (monde en grille façon Dofus Touch) ──
## { Vector2i case : {"dir", "to"} } pour la carte courante.
func gates() -> Dictionary:
	return ProgressionManager.adventure_gates(zone_id())

## Porte sur cette case ({} sinon), enrichie de open / reason / name / level / biome / visited.
func gate_at(pos: Vector2i) -> Dictionary:
	var g: Dictionary = gates().get(pos, {})
	if g.is_empty():
		return {}
	var out: Dictionary = g.duplicate()
	var to: String = String(g["to"])
	out["open"] = ProgressionManager.adventure_gate_open(state, zone_id(), to)
	out["reason"] = ProgressionManager.adventure_gate_lock_reason(state, zone_id(), to)
	out["name"] = ProgressionManager.adventure_zone_name(to)
	out["level"] = ProgressionManager.adventure_zone_level(to)
	out["biome"] = ProgressionManager.adventure_zone_biome(to)
	out["visited"] = (state.get("zones_unlocked", []) as Array).has(to)
	return out

## Franchit la porte de cette case : true si le héros a changé de carte.
func cross_gate(pos: Vector2i) -> bool:
	var g: Dictionary = gates().get(pos, {})
	if g.is_empty() or hero_pos() != pos:
		return false
	if not ProgressionManager.adventure_cross(state, String(g["dir"])):
		return false
	state["steps_since_event"] = 0
	persist()
	zone_changed.emit(zone_id())
	return true

## Cartes visitées (voyage rapide depuis la mini-carte).
func visited_zones() -> Array:
	return (state.get("zones_unlocked", ["foret_sylve"]) as Array).duplicate()

## Classe qui incarne l'explorateur (une classe de l'équipe).
func hero_class() -> String:
	var team: Array[String] = []
	for m: Dictionary in save.get("team", []):
		team.append(String(m.get("classe", "")))
	var c: String = String(state.get("hero_class", ""))
	if c == "" or (not team.is_empty() and not team.has(c)):
		c = team[0] if not team.is_empty() else "Chasseur"
		state["hero_class"] = c
	return c

func set_hero_class(classe: String) -> void:
	state["hero_class"] = classe
	persist()

## Avancement de la zone courante : { done, total, fog (0-1 révélé) }.
func zone_progress() -> Dictionary:
	var pois: Dictionary = ProgressionManager.adventure_zone_pois(zone_id())
	var done: int = 0
	var total: int = 0
	for k: String in pois.keys():
		if String(pois[k].get("kind", "")) == KIND_CAMP:
			continue
		total += 1
		if poi_done(AdventureTerrain.parse(k)):
			done += 1
	var size := zone_size()
	var seen: int = 0
	for y: int in range(size.y):
		for x: int in range(size.x):
			if cell_discovered(Vector2i(x, y)):
				seen += 1
	return {"done": done, "total": total, "fog": float(seen) / float(maxi(1, size.x * size.y))}

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
			state["pending_name"] = String(poi.get("name", "Défi"))
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
	if not ProgressionManager.adventure_answer_matches(puzzle, answer):
		return false
	award_exploration_xp(int(ProgressionManager.ADVENTURE_BASE_XP * 2))
	complete_poi(key, KIND_PUZZLE)
	return true

## Énigmes de réflexion (runes, dalles) : l'interface fait jouer la partie et
## confirme la réussite ici. Même récompense qu'une énigme + une ressource bonus.
func complete_puzzle(key: String) -> Dictionary:
	var puzzle: Dictionary = ProgressionManager.ADVENTURE_PUZZLES.get(key, {})
	if puzzle.is_empty() or ProgressionManager.adventure_poi_completed(state, key):
		return {}
	var xp: int = int(ProgressionManager.ADVENTURE_BASE_XP * 2)
	award_exploration_xp(xp)
	var res: Dictionary = {String(ProgressionManager.CONQUEST_BIOME_RESOURCE.get(zone_biome(), "Magie")): 3}
	ProgressionManager.add_resources(save, res)
	complete_poi(key, KIND_PUZZLE)
	return {"xp": xp, "resources": res}

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

# ── Événements de route ─────────────────────────────────────────────────
## En se déplaçant sur une case sans lieu, le héros peut vivre un petit événement
## (au plus un toutes les EVENT_COOLDOWN cases) : cueillette, cachette, sage
## voyageur ou embuscade (combat facultatif au niveau de la zone).
const EVENT_CHANCE := 0.16
const EVENT_COOLDOWN := 3
const SAGE_LINES: Array = [
	"« Les belvédères ne mentent jamais : ce que vous y voyez, vos armées pourront le prendre. »",
	"« Le Roi Squelette dort sous le Donjon. Il ne se réveille que pour ceux qui tiennent tout Zimut. »",
	"« Une source claire guérit l'âme plus vite que la meilleure potion. »",
	"« Les Sylvains plantent un arbre à chaque soin. Les blessés guérissent à l'ombre de leurs branches. »",
	"« Les gobelins chassent la nuit, les loups au crépuscule, les squelettes… quand bon leur semble. »",
	"« Dans le désert, suivez les cairns : chaque pierre posée est une promesse de retour. »",
]

func roll_event(rng: RandomNumberGenerator = null) -> Dictionary:
	if rng == null:
		rng = RandomNumberGenerator.new()
		rng.randomize()
	var since: int = int(state.get("steps_since_event", 99)) + 1
	state["steps_since_event"] = since
	if not poi_at(hero_pos()).is_empty() or since < EVENT_COOLDOWN or rng.randf() > EVENT_CHANCE:
		return {}
	state["steps_since_event"] = 0
	state["events_seen"] = int(state.get("events_seen", 0)) + 1
	var lvl: int = ProgressionManager.adventure_zone_level(zone_id())
	var r: float = rng.randf()
	var ev: Dictionary = {}
	if r < 0.32:
		var res_name: String = String(ProgressionManager.CONQUEST_BIOME_RESOURCE.get(zone_biome(), "Bois"))
		var res: Dictionary = {res_name: rng.randi_range(2, 4), "Cuir": rng.randi_range(0, 2)}
		ProgressionManager.add_resources(save, res)
		ev = {"kind": "forage", "title": "Cueillette", "text": "Au détour du sentier, vous récoltez de quoi nourrir la forge.", "resources": res}
	elif r < 0.55:
		var gold: int = 15 + 2 * lvl
		save["gold"] = int(save.get("gold", 0)) + gold
		ev = {"kind": "cache", "title": "Cachette", "text": "Une bourse oubliée sous une pierre plate.", "gold": gold}
	elif r < 0.72:
		var xp: int = int(ProgressionManager.ADVENTURE_BASE_XP * 0.5)
		award_exploration_xp(xp)
		ev = {"kind": "sage", "title": "Sage voyageur", "text": String(SAGE_LINES[rng.randi_range(0, SAGE_LINES.size() - 1)]), "xp": xp}
	else:
		var names: Dictionary = {"Forêt": "Embuscade de gobelins", "Montagne": "Trolls en maraude", "Désert": "Pillards des dunes", "Donjon": "Ronde de squelettes"}
		ev = {"kind": "ambush", "title": String(names.get(zone_biome(), "Embuscade")),
			"text": "Des ennemis surgissent des fourrés ! Les affronter rapporte XP et butin ; vous pouvez aussi les contourner.",
			"level": lvl + 1}
	persist()
	return ev

## Accepte une embuscade : combat Tactique au niveau indiqué, dans le biome de la zone.
func start_event_combat(ev: Dictionary) -> void:
	var p := hero_pos()
	state["pending_challenge"] = poi_key(p)
	state["pending_level"] = int(ev.get("level", ProgressionManager.adventure_zone_level(zone_id())))
	state["pending_name"] = String(ev.get("title", "Embuscade"))
	persist()

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
