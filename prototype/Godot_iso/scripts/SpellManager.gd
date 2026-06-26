extends Node
class_name SpellManager
## SpellManager.gd - Gestion des sorts

var game_manager

signal spell_selected(spell: Dictionary)


func init(manager):
	game_manager = manager


## Helper function to get numeric value from spell with fallback
func _get_spell_damage(spell: Dictionary, damage_type: String) -> int:
	# Try new numeric columns first
	var column_name = ""
	match damage_type:
		"physical":
			column_name = "Degats_physiques"
		"magical":
			column_name = "Degats_magiques"
		"heal":
			column_name = "Soins"
		"resistance_physical":
			column_name = "Resistance_physique"
		"resistance_magical":
			column_name = "Resistance_magique"
		"debuff_physical":
			column_name = "Debuff_physique"
		"debuff_magical":
			column_name = "Debuff_magique"
		"buff_physical":
			column_name = "Buff_physique"
		"buff_magical":
			column_name = "Buff_magique"
		_:
			return 0
	
	# Check new column
	if spell.has(column_name) and spell[column_name] != "" and spell[column_name] != "0":
		return int(spell[column_name])
	
	return 0


func cast_spell(caster: Dictionary, spell: Dictionary, target: Dictionary) -> String:
	"""Cast a spell and return the result message"""
	var result: String = ""
	
	# Consume PA/PM
	caster["current_pa"] -= spell["cost_pa"]
	caster["current_pm"] -= spell["cost_pm"]
	
	# Utiliser les nouvelles colonnes numériques
	var physical_damage: int = _get_spell_damage(spell, "physical")
	var magical_damage: int = _get_spell_damage(spell, "magical")
	var heal_amount: int = _get_spell_damage(spell, "heal")
	var resistance_physical: int = _get_spell_damage(spell, "resistance_physical")
	var resistance_magical: int = _get_spell_damage(spell, "resistance_magical")
	
	match spell["spell_type"]:
		"CAC":
			var damage = physical_damage if physical_damage > 0 else (caster["force"] + ((randi() % 5) - 2))
			var actual_damage = max(1, damage - target["defense"] / 2.0)
			target["current_pv"] -= actual_damage
			result = "%s utilise %s sur %s : %d dégâts physiques !" % [caster["name"], spell["name"], target["name"], actual_damage]
			game_manager.entity_attacked.emit(caster, target, actual_damage)
		"Magie":
			if "Poison" in spell.get("effect", spell.get("Effet", "")):
				var damage = magical_damage if magical_damage > 0 else int(spell.get("effect", "").split(" ")[0])
				target["current_pv"] -= damage
				result = "%s utilise %s sur %s : %d dégâts + poison !" % [caster["name"], spell["name"], target["name"], damage]
				game_manager.entity_attacked.emit(caster, target, damage)
			else:
				var damage = magical_damage if magical_damage > 0 else (caster["intelligence"] + ((randi() % 5) - 2))
				var actual_damage = max(1, damage)
				target["current_pv"] -= actual_damage
				result = "%s utilise %s sur %s : %d dégâts magiques !" % [caster["name"], spell["name"], target["name"], actual_damage]
				game_manager.entity_attacked.emit(caster, target, actual_damage)
		"Défense":
			# Bouclier: réduit les dégâts de 50% pour 1 tour
			if resistance_physical > 0:
				caster["defense"] = int(caster["defense"] * (1 + resistance_physical / 100.0))
				result = "%s utilise %s : +%d%% défense !" % [caster["name"], spell["name"], resistance_physical]
			else:
				caster["defense"] = int(caster["defense"] * 1.5)
				result = "%s utilise %s : défense augmentée !" % [caster["name"], spell["name"]]
		"Soin":
			var heal = heal_amount if heal_amount > 0 else (caster["intelligence"] + ((randi() % 5) - 2))
			target["current_pv"] = min(target["max_pv"], target["current_pv"] + heal)
			result = "%s utilise %s sur %s : +%d PV !" % [caster["name"], spell["name"], target["name"], heal]
	
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
