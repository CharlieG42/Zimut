extends Node

## ArmyManager.gd - Gestion des heros, armees et garnisons du mode Empire.
## Les heros sont des classes Zimut (classes.csv) qui menent les armees en combat.
## Les unites proviennent de unites.csv (humaines) et invocations.csv (mythiques, Grepolis).
## L'equipement provient de craft.csv / stuff.csv.
## Etape 2: l'armee recrutee (heros + unites) constitue l'equipe attaquante
## envoyee dans le combat tactique Zimut via BattleBridge.

var empire_manager: Node

var army_units: Array = []  # unites d'armee recrutees (unites.csv)

func init(manager: Node) -> void:
	empire_manager = manager

## Recrute un hero (classe Zimut) pour mener les armees.
func recruit_hero(hero_class: String, level: int) -> Dictionary:
	var loader: Node = _data_loader()
	if loader == null:
		return {}
	var class_data: Dictionary = loader.get_class_data(hero_class, level)
	if class_data.is_empty():
		empire_manager.message_requested.emit("Classe %s introuvable." % hero_class)
		return {}
	var hero: Dictionary = {
		"id": empire_manager.heroes.size(),
		"classe": hero_class,
		"level": level,
		"max_pv": int(class_data.get("Vita (PV)", "60")),
		"force": int(class_data.get("Force (CAC)", "10")),
		"intelligence": int(class_data.get("Intelligence (Magie)", "10")),
		"agilite": int(class_data.get("Agilité (Vit. Atk)", "10")),
		"sagesse": int(class_data.get("Sagesse (Précision)", "10")),
		"defense": int(class_data.get("Défense", "10")),
		"pa": int(class_data.get("PA", "5")),
		"pm": int(class_data.get("PM", "3")),
		"equipment": [],
		"current_pv": int(class_data.get("Vita (PV)", "60")),
	}
	empire_manager.heroes.append(hero)
	empire_manager.message_requested.emit("Hero %s (Lv%d) recrute." % [hero_class, level])
	return hero

## Recrute une unite d'armee (humaine ou mythique) si les ressources sont suffisantes.
## Etape 2: l'unite rejoint l'armee du joueur (army_units) et pourra participer
## a l'assaut si le joueur a moins de 3 heros.
func recruit_unit(unit_name: String) -> Dictionary:
	var loader: Node = _data_loader()
	if loader == null:
		return {}
	var unit_data: Dictionary = loader.get_unit_data(unit_name)
	if unit_data.is_empty():
		empire_manager.message_requested.emit("Unite %s introuvable." % unit_name)
		return {}
	var cost_or: int = int(unit_data.get("Coût or", "0"))
	var cost_fer: int = int(unit_data.get("Coût fer", "0"))
	var cost_bois: int = int(unit_data.get("Coût bois", "0"))
	if empire_manager.resources["or"] < cost_or \
	or empire_manager.resources["fer"] < cost_fer \
	or empire_manager.resources["bois"] < cost_bois:
		empire_manager.message_requested.emit("Ressources insuffisantes pour %s." % unit_name)
		return {}
	empire_manager.resources["or"] -= cost_or
	empire_manager.resources["fer"] -= cost_fer
	empire_manager.resources["bois"] -= cost_bois
	empire_manager.resources_changed.emit(empire_manager.resources)
	var unit: Dictionary = {
		"name": unit_name,
		"level": int(unit_data.get("Niveau requis", "1")),
		"pv": int(unit_data.get("PV", "80")),
		"force": int(unit_data.get("Attaque", "10")),
		"defense": int(unit_data.get("Défense", "5")),
		"pa": int(unit_data.get("PA", "3")),
		"pm": int(unit_data.get("PM", "2")),
		"type": unit_data.get("Type", "Humain"),
	}
	army_units.append(unit)
	empire_manager.message_requested.emit("Unite %s recrutee." % unit_name)
	return unit

## Construit l'equipe attaquante (3 membres menant l'assaut) au format attendu
## par BattleGameManager (prototype/empire/scripts/battle/).
## Les 3 premiers heros recrutes forment l'equipe; a defaut, les unites d'armee
## les plus fortes complètent, puis des heros par defaut.
func build_attacking_team() -> Dictionary:
	var team: Array = []
	for hero: Dictionary in empire_manager.heroes.slice(0, 3):
		team.append({
			"classe": hero["classe"],
			"max_pv": hero["max_pv"],
			"force": hero["force"],
			"intelligence": hero["intelligence"],
			"agilite": hero["agilite"],
			"sagesse": hero["sagesse"],
			"defense": hero["defense"],
			"pa": hero["pa"],
			"pm": hero["pm"],
		})
	if team.size() < 3:
		for unit: Dictionary in _strongest_units(3 - team.size()):
			team.append({
				"classe": unit["name"],
				"max_pv": unit["pv"],
				"force": unit["force"],
				"intelligence": 5,
				"agilite": 10,
				"sagesse": 10,
				"defense": unit["defense"],
				"pa": unit["pa"],
				"pm": unit["pm"],
			})
	if team.size() < 3:
		for hero: Dictionary in _default_heroes().slice(0, 3 - team.size()):
			team.append(hero)
	return {
		"team": team,
		"units": army_units,
	}

## Unites d'armee les plus fortes (somme pv + force + defense), pour completer l'assaut.
func _strongest_units(count: int) -> Array:
	var sorted: Array = army_units.duplicate()
	sorted.sort_custom(func(a, b): return _unit_power(a) > _unit_power(b))
	return sorted.slice(0, count)

func _unit_power(unit: Dictionary) -> int:
	return int(unit.get("pv", 0)) + int(unit.get("force", 0)) + int(unit.get("defense", 0))

func _default_heroes() -> Array:
	var loader: Node = _data_loader()
	var defaults: Array = ["Tank", "Assassin", "Mage"]
	var result: Array = []
	for classe: String in defaults:
		var cd: Dictionary = loader.get_class_data(classe, 10) if loader != null else {}
		if cd.is_empty():
			cd = _fallback_class(classe)
		result.append({
			"classe": classe,
			"max_pv": int(cd.get("Vita (PV)", "80")),
			"force": int(cd.get("Force (CAC)", "12")),
			"intelligence": int(cd.get("Intelligence (Magie)", "10")),
			"agilite": int(cd.get("Agilité (Vit. Atk)", "12")),
			"sagesse": int(cd.get("Sagesse (Précision)", "10")),
			"defense": int(cd.get("Défense", "12")),
			"pa": int(cd.get("PA", "5")),
			"pm": int(cd.get("PM", "3")),
		})
	return result

func _fallback_class(classe: String) -> Dictionary:
	return {
		"Vita (PV)": "80", "Force (CAC)": "12", "Intelligence (Magie)": "10",
		"Agilité (Vit. Atk)": "12", "Sagesse (Précision)": "10", "Défense": "12",
		"PA": "5", "PM": "3", "Classe": classe,
	}

## Pertes retenues sur l'armee attaquante apres un echec de conquete
## (la garnison de la ville decime les unites engagees : 1 unite perdue).
func apply_battle_losses() -> void:
	if army_units.size() > 0:
		var lost: Dictionary = army_units.pop_back()
		if empire_manager:
			empire_manager.message_requested.emit("%s perdue au combat." % lost.get("name", "Unite"))
	elif empire_manager and empire_manager.heroes.size() > 3:
		empire_manager.heroes.pop_back()

func _data_loader() -> Node:
	return get_node_or_null("/root/EmpireDataLoader")
