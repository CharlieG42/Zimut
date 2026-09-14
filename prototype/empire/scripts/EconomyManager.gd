extends Node
## EconomyManager.gd - Production passive de ressources par les villes du joueur.
## Emprunt MillionLords: pas de farming/timer lourd, production automatique reguliere.
## Les batiments construits (cf batiments.csv) augmentent la production de chaque ville.

var empire_manager: Node

func init(manager: Node) -> void:
	empire_manager = manager
	empire_manager.city_changed.connect(_on_city_changed)

## Production passive appelee a chaque tick de EmpireManager.
func produce_tick() -> void:
	var player_cities: Array = empire_manager.get_player_cities()
	for city: Dictionary in player_cities:
		_produce_for_city(city)
	empire_manager.resources_changed.emit(empire_manager.resources)

func _produce_for_city(city: Dictionary) -> void:
	# Production de base par ville
	empire_manager.resources["or"] += 5
	empire_manager.resources["fer"] += 2
	empire_manager.resources["bois"] += 2
	empire_manager.resources["magie"] += 1
	# Bonus selon les batiments construits (cf batiments.csv)
	for building: Dictionary in city.get("buildings", []):
		var data: Dictionary = _building_data(building["name"])
		if data.is_empty():
			continue
		empire_manager.resources["or"] += int(data.get("Production or", "0"))
		empire_manager.resources["fer"] += int(data.get("Production fer", "0"))
		empire_manager.resources["bois"] += int(data.get("Production bois", "0"))

func _building_data(building_name: String) -> Dictionary:
	var loader: Node = _data_loader()
	if loader == null:
		return {}
	return loader.get_building_data(building_name)

func _data_loader() -> Node:
	return get_node_or_null("/root/EmpireDataLoader")

## Tente de construire un batiment dans une ville du joueur si les ressources sont suffisantes.
func try_build(city: Dictionary, building_name: String) -> bool:
	var data: Dictionary = _building_data(building_name)
	if data.is_empty():
		return false
	var cost_or: int = int(data.get("Coût or", "0"))
	var cost_fer: int = int(data.get("Coût fer", "0"))
	var cost_bois: int = int(data.get("Coût bois", "0"))
	var cost_magie: int = int(data.get("Coût magie", "0"))
	if empire_manager.resources["or"] < cost_or \
		or empire_manager.resources["fer"] < cost_fer \
		or empire_manager.resources["bois"] < cost_bois \
		or empire_manager.resources["magie"] < cost_magie:
		empire_manager.message_requested.emit("Ressources insuffisantes pour %s." % building_name)
		return false
	empire_manager.resources["or"] -= cost_or
	empire_manager.resources["fer"] -= cost_fer
	empire_manager.resources["bois"] -= cost_bois
	empire_manager.resources["magie"] -= cost_magie
	city["buildings"].append({"name": building_name, "level": 1})
	empire_manager.resources_changed.emit(empire_manager.resources)
	empire_manager.city_changed.emit(city)
	empire_manager.message_requested.emit("%s construit a %s." % [building_name, city["name"]])
	return true

func _on_city_changed(_city: Dictionary) -> void:
	# Hook pour rafraichir l'UI economique si necessaire
	pass
