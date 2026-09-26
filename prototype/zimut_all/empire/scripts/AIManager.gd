extends Node
## AIManager.gd - Comportement des seigneurs IA sur la carte monde (PvE).
## Profils: expansionniste (attaque villages neutres), defensif (renforce garnisons),
##          agressif (attaque les villes du joueur).
## Emprunt MillionLords: bonus/malus d'XP selon la taille du royaume (anti-ecrasement).

var empire_manager: Node

const PROFILE_EXPANSIONIST := "expansionniste"
const PROFILE_DEFENSIVE := "defensif"
const PROFILE_AGGRESSIVE := "agressif"

var ai_profiles: Dictionary = {}  # id ville IA -> profil

func init(manager: Node) -> void:
	empire_manager = manager
	_assign_profiles()

func _assign_profiles() -> void:
	var profiles: Array = [PROFILE_EXPANSIONIST, PROFILE_DEFENSIVE, PROFILE_AGGRESSIVE]
	var idx: int = 0
	for city: Dictionary in empire_manager.cities:
		if city["owner"] == empire_manager.OWNER_AI:
			ai_profiles[city["id"]] = profiles[idx % profiles.size()]
			idx += 1

## Traite le tour d'IA a chaque tick.
func process_tick() -> void:
	for city: Dictionary in empire_manager.cities:
		if city["owner"] != empire_manager.OWNER_AI:
			continue
		var profile: String = ai_profiles.get(city["id"], PROFILE_DEFENSIVE)
		match profile:
			PROFILE_EXPANSIONIST:
				_try_expand(city)
			PROFILE_AGGRESSIVE:
				_try_attack_player(city)
			PROFILE_DEFENSIVE:
				_reinforce(city)

## L'IA expansionniste tente de capturer un village neutre adjacent.
func _try_expand(ai_city: Dictionary) -> void:
	for target: Dictionary in empire_manager.cities:
		if target["owner"] != empire_manager.OWNER_NEUTRAL:
			continue
		if _is_adjacent(ai_city, target):
			# Resolution IA simplifiee (pas de combat tactique pour l'IA: conquete PvE auto)
			target["owner"] = empire_manager.OWNER_AI
			empire_manager.city_changed.emit(target)
			return

## L'IA agressive tente d'attaquer une ville du joueur adjacente.
func _try_attack_player(ai_city: Dictionary) -> void:
	for target: Dictionary in empire_manager.cities:
		if target["owner"] != empire_manager.OWNER_PLAYER:
			continue
		if _is_adjacent(ai_city, target):
			# PvE: l'attaque IA declencherait un combat defensif (etape 3).
			# V1: l'IA renforce sa garnison et attend.
			_reinforce(ai_city)
			return

## L'IA defensive renforce sa garnison.
func _reinforce(ai_city: Dictionary) -> void:
	var garrison: Array = ai_city["garrison"]
	garrison.append({
		"name": "Soldat",
		"level": 1,
		"pv": 80,
		"force": 12,
		"defense": 8,
	})

func _is_adjacent(a: Dictionary, b: Dictionary) -> bool:
	var dx: int = abs(int(a["x"]) - int(b["x"]))
	var dy: int = abs(int(a["y"]) - int(b["y"]))
	return (dx + dy) == 1

## Ajuste le niveau effectif d'une garnison IA selon le rapport de force
## (emprunt MillionLords: anti-ecrasement / rattrapage).
func adjusted_garrison_level(base_level: int, player_city_count: int, ai_city_count: int) -> int:
	if player_city_count <= 0:
		return base_level
	var ratio: float = float(ai_city_count) / float(player_city_count)
	# Si l'IA est a la traine, on booste legerement sa garnison.
	if ratio < 0.5:
		return base_level + 2
	return base_level
