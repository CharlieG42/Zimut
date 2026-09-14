extends Node
## BattleBridge.gd - Pont entre le mode Empire et le combat tactique Zimut.
##
## ROLE: chaque conquete declenche une instance du combat Zimut existant
## (prototype/zimut/scripts/GameManager.gd) pour resoudre la bataille.
##
## POINT D'ANCRAGE: le combat Zimut supporte deja une equipe personnalisee via
##   GameManager.set_custom_team(team_data: Array)
## cf. prototype/zimut/scripts/GameManager.gd:130
## Le tableau attendu contient 3 dicts:
##   { "classe": "Tank", "max_pv": int, "force": int, "intelligence": int,
##     "agilite"/"agility": int, "sagesse"/"wisdom": int, "defense": int,
##     "pa": int, "pm": int, "color": Color (optionnel) }
## init_entities() (GameManager.gd:221) peuple alors players[] depuis custom_team
## et enemies[] depuis les types ennemis par defaut.
##
## POUR LA GARNISON PERSONNALISEE: GameManager peuple enemies[] en dur dans
## init_entities(). Une extension minimale (parallele a custom_team) est necessaire
## pour injecter une garnison reelle depuis la ville ciblee. Documentee en §7 du
#  DESIGN_EMPIRE.md (risque) et planifiee en etape 2.
##
## NOTE D'INTEGRATION: les modes Zimut et Empire sont des projets Godot separes
## (prototype/zimut/project.godot, prototype/empire/project.godot). Le pont de combat
#  reel (change_scene vers la scene de combat Zimut) suppose un partage de scripts
#  entre les deux projets. Deux options pour l'etape 2:
#   (a) deplacer les scripts de combat vers prototype/shared/scripts/ et les charger
#       depuis les deux projets via un chemin commun;
#   (b) fusionner les modes en un seul projet Godot avec selection de mode au lancement.
## La V1 (squelette) fournit une resolution simulee pour valider la boucle Empire,
#  plus l'API complete du pont pour l'integration reelle.

var empire_manager: Node
var army_manager: Node
var current_battle_context: Dictionary = {}

signal battle_ready(team: Array, enemy_garrison: Array)
signal battle_simulated(victory: bool)

func init(manager: Node) -> void:
	empire_manager = manager
	army_manager = empire_manager.army_manager

## Prepare et lance une bataille pour conquerir une ville cible.
## Constitue custom_team depuis l'armee attaquante du joueur.
func start_battle(target_city: Dictionary, attacking_army: Dictionary) -> void:
	var team: Array = _build_custom_team(attacking_army)
	var enemy_garrison: Array = _build_enemy_garrison(target_city)
	current_battle_context = {
		"target_city": target_city,
		"team": team,
		"enemy_garrison": enemy_garrison,
	}
	battle_ready.emit(team, enemy_garrison)
	# V1 squelette: resolution simulee (pont reel en etape 2, voir NOTE ci-dessus).
	_simulate_battle(team, enemy_garrison)

## Construit le custom_team au format exact attendu par GameManager.set_custom_team().
func _build_custom_team(attacking_army: Dictionary) -> Array:
	var team: Array = attacking_army.get("team", [])
	if team.size() == 3:
		return team
	# Fallback: equipe par defaut Tank/Assassin/Mage (cf ArmyManager)
	if army_manager != null:
		return army_manager.build_attacking_team()["team"]
	return [
		{"classe": "Tank", "max_pv": 120, "force": 20, "intelligence": 5,
		 "agilite": 10, "sagesse": 15, "defense": 25, "pa": 6, "pm": 4},
		{"classe": "Assassin", "max_pv": 80, "force": 18, "intelligence": 8,
		 "agilite": 18, "sagesse": 14, "defense": 10, "pa": 6, "pm": 5},
		{"classe": "Mage", "max_pv": 70, "force": 5, "intelligence": 22,
		 "agilite": 8, "sagesse": 16, "defense": 8, "pa": 5, "pm": 4},
	]

## Construit la garnison ennemie depuis la ville ciblee.
## V1: garnison composee d'unites de unites.csv / ennemis.csv basees sur le niveau de la ville.
func _build_enemy_garrison(target_city: Dictionary) -> Array:
	var garrison: Array = target_city.get("garrison", [])
	if garrison.is_empty():
		garrison = _default_enemy_garrison(int(target_city.get("level", 1)))
	return garrison

func _default_enemy_garrison(level: int) -> Array:
	var garrison: Array = []
	var count: int = 3 + level
	for i: int in range(count):
		garrison.append({
			"type": "Gobelin" if i % 2 == 0 else "Squelette",
			"level": level,
			"pv": 50, "force": 10, "defense": 5,
		})
	return garrison

## Resolution simulee de la bataille (V1 squelette).
## En etape 2, cette methode sera remplacee par le lancement reel de la scene de combat
## Zimut et l'ecoute du signal game_ended(victory) de GameManager.
func _simulate_battle(team: Array, enemy_garrison: Array) -> void:
	# Heuristique simple: somme des PV de l'equipe vs somme des PV de la garnison.
	var team_pv: int = 0
	for member: Dictionary in team:
		team_pv += int(member.get("max_pv", 80))
	var enemy_pv: int = 0
	for unit: Dictionary in enemy_garrison:
		enemy_pv += int(unit.get("pv", 50))
	var battle_victory: bool = team_pv >= enemy_pv
	battle_simulated.emit(battle_victory)
	empire_manager.resolve_battle(battle_victory)

## API publique pour l'integration reelle (etape 2).
## A appeler quand le combat Zimut se termine (signal game_ended(victory) de GameManager).
func on_zimut_battle_ended(zimut_victory: bool) -> void:
	empire_manager.resolve_battle(zimut_victory)

## API publique: donnees pretes a injecter dans GameManager.set_custom_team().
func get_custom_team_for_gamemanager() -> Array:
	return current_battle_context.get("team", [])
