extends Node
class_name SpellManager
## SpellManager.gd - Gestion des sorts

var game_manager

signal spell_selected(spell: Dictionary)


func init(manager):
	game_manager = manager


## Helper function to extract damage value from spell effect string
func _extract_damage_from_effect(effect: String) -> int:
	var damage_patterns = [
		"dégâts",
		"dégâts magiques",
		"dégâts en zone",
		"dégâts/tour"
	]
	for pattern in damage_patterns:
		if pattern in effect:
			var parts = effect.split(pattern)[0].split(" ")
			for part in parts:
				if part.is_valid_int():
					return int(part)
	return 0


## Helper function to extract heal value from spell effect string
func _extract_heal_from_effect(effect: String) -> int:
	if "Restaure" in effect:
		var parts = effect.split("Restaure")[1].split("PV")[0].split(" ")
		for part in parts:
			if part.is_valid_int():
				return int(part)
	return 0


func cast_spell(caster: Dictionary, spell: Dictionary, target: Dictionary) -> String:
	"""Cast a spell and return the result message"""
	var result: String = ""
	
	# Consume PA/PM
	caster["current_pa"] -= spell["cost_pa"]
	caster["current_pm"] -= spell["cost_pm"]
	
	var effect: String = spell.get("effect", spell.get("Effet", ""))
	var base_damage: int = _extract_damage_from_effect(effect)
	var base_heal: int = _extract_heal_from_effect(effect)
	
	match spell["spell_type"]:
		"CAC":
			var damage
			if base_damage > 0:
				damage = base_damage
			else:
				damage = caster["force"] + ((randi() % 5) - 2)
			var actual_damage = max(1, damage - target["defense"] / 2.0)
			target["current_pv"] -= actual_damage
			result = "%s utilise %s sur %s : %d dégâts !" % [caster["name"], spell["name"], target["name"], actual_damage]
			game_manager.entity_attacked.emit(caster, target, actual_damage)
		"Magie":
			if "Poison" in spell["effect"]:
				var damage
				if base_damage > 0:
					damage = base_damage
				else:
					damage = int(spell["effect"].split(" ")[0])
				target["current_pv"] -= damage
				result = "%s utilise %s sur %s : %d dégâts + poison !" % [caster["name"], spell["name"], target["name"], damage]
				game_manager.entity_attacked.emit(caster, target, damage)
			else:
				var damage
				if base_damage > 0:
					damage = base_damage
				else:
					damage = caster["intelligence"] + ((randi() % 5) - 2)
				var actual_damage = max(1, damage)
				target["current_pv"] -= actual_damage
				result = "%s utilise %s sur %s : %d dégâts magiques !" % [caster["name"], spell["name"], target["name"], actual_damage]
				game_manager.entity_attacked.emit(caster, target, actual_damage)
		"Défense":
			# Bouclier: réduit les dégâts de 50% pour 1 tour
			caster["defense"] = int(caster["defense"] * 1.5)
			result = "%s utilise %s : défense augmentée !" % [caster["name"], spell["name"]]
		"Soin":
			var heal_amount
			if base_heal > 0:
				heal_amount = base_heal
			else:
				heal_amount = caster["intelligence"] + ((randi() % 5) - 2)
			target["current_pv"] = min(target["max_pv"], target["current_pv"] + heal_amount)
			result = "%s utilise %s sur %s : +%d PV !" % [caster["name"], spell["name"], target["name"], heal_amount]
	
	return result


func can_cast_spell(entity: Dictionary, spell: Dictionary) -> bool:
	"""Check if an entity can cast a spell"""
	return entity["current_pa"] >= spell["cost_pa"] and entity["current_pm"] >= spell["cost_pm"]


func get_spells_for_entity(entity: Dictionary) -> Array:
	"""Return all spells available for an entity"""
	return entity.get("spells", [])


func _on_spell_button_selected(spell: Dictionary):
	"""Emit spell_selected signal when a spell button is clicked"""
	spell_selected.emit(spell)
