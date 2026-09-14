extends Node
## ArmyManager.gd - Gestion des heros, armees et garnisons du mode Empire.
## Les heros sont des classes Zimut (classes.csv) qui menent les armees en combat.
## Les unites proviennent de unites.csv (humaines) et invocations.csv (mythiques, Grepolis).
## L'equipement provient de craft.csv / stuff.csv.

var empire_manager: Node

func init(manager: Node) -> void:
	empire_manager = manager

## Recrute un hero (classe Zimut) pour mener les armees.
func recruit_hero(class_name: String, level: int) -> Dictionary:
	var loader: Node = _data_loader()
	if loader == null:
		return {}
	var class_data: Dictionary = loader.get_class_data(class_name, level)
	if class_data.is_empty():
		empire_manager.message_requested.emit("Classe %s introuvable." % class_name)
		return {}
	var hero: Dictionary = {
		"id": empire_manager.heroes.size(),
		"classe": class_name,
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
	empire_manager.message_requested.emit("Hero %s (Lv%d) recrute." % [class_name, level])
	return hero

## Recrute une unite d'armee (humaine ou mythique) si les ressources sont suffisantes.
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
		"type": unit_data.get("Type", "Humain"),
	}
	empire_manager.message_requested.emit("Unite %s recrutee." % unit_name)
	return unit

## Construit l'equipe attaquante (3 heros menant l'assaut) au format attendu par
## GameManager.set_custom_team() du mode Zimut (cf GameManager.gd:130).
## Les 3 premiers heros recrutes forment l'equipe; sinon on prend des heros par defaut.
func build_attacking_team() -> Dictionary:
	var team: Array = []
	var chosen: Array = empire_manager.heroes.slice(0, 3)
	if chosen.size() < 3:
		# Heros par defaut (Tank, Assassin, Mage) si pas assez de recrues
		chosen = _default_heroes()
	for hero: Dictionary in chosen:
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
	return {
		"team": team,
		"units": [],  # unites d'armee accompagnant (etape 2)
	}

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

func _data_loader() -> Node:
	return get_node_or_null("/root/EmpireDataLoader")
