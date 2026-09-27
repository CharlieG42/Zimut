extends Node

## BattleBridge.gd - Pont entre le mode Empire et le combat tactique Zimut.
##
## ROLE: chaque conquete declenche une instance du combat tactique Zimut
## (portage integre dans prototype/empire/scripts/battle/, Etape 2).
##
## POINT D'ANCRAGE: le combat supporte une equipe personnalisee via
##   BattleGameManager.set_custom_team(team_data: Array)
## et, depuis l'Etape 2, une garnison personnalisee via
##   BattleGameManager.set_custom_enemy_team(garrison: Array)
## (parallele a custom_team, cf DESIGN_EMPIRE.md §7 - point d'attention resolu).
##
## FLUX DE COMBAT (Etape 2):
##   1. EmpireManager.attack_city() -> start_battle()
##   2. start_battle() construit custom_team (armee attaquante recrutee via
##      ArmyManager) et la garnison ennemie (unites reelles de la ville),
##      puis change de scene vers res://scenes/Battle.tscn.
##   3. BattleMain.gd recupere le contexte via get_custom_team_for_gamemanager()
##      / get_enemy_garrison_for_gamemanager() et peuple le combat.
##   4. A la fin du combat, BattleMain appelle on_zimut_battle_ended(victory),
##      qui remonte l'issue au EmpireManager (conquete ou echec).

var empire_manager: Node
var army_manager: Node
var current_battle_context: Dictionary = {}

signal battle_ready(team: Array, enemy_garrison: Array)

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
	# Etape 2: lancement reel de la scene de combat tactique.
	get_tree().change_scene_to_file("res://scenes/Battle.tscn")

## Construit le custom_team au format attendu par BattleGameManager.
## L'armee attaquante peut contenir des heros (classes Zimut) et des unites
## (unites.csv) ; les 3 premiers membres forment l'equipe de combat.
func _build_custom_team(attacking_army: Dictionary) -> Array:
	var team: Array = attacking_army.get("team", [])
	if team.size() == 3:
		return team
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
## La garnison est composee d'unites reelles (unites.csv / ennemis.csv).
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

## API publique pour l'integration reelle (appele par BattleMain.gd).
## Remonte l'issue du combat Zimut au EmpireManager.
func on_zimut_battle_ended(zimut_victory: bool) -> void:
	empire_manager.resolve_battle(zimut_victory)

## API publique: donnees pretes a injecter dans BattleGameManager.
func get_custom_team_for_gamemanager() -> Array:
	return current_battle_context.get("team", [])

## API publique: garnison prete a injecter dans BattleGameManager.
func get_enemy_garrison_for_gamemanager() -> Array:
	return current_battle_context.get("enemy_garrison", [])
