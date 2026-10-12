extends SceneTree

## Tests : montée de niveau des sorts (1..10), coûts, application du bonus.

var fails: int = 0

func check(cond: bool, msg: String) -> void:
	print(("  ok  " if cond else "  ÉCHEC  ") + msg)
	if not cond:
		fails += 1

func _init() -> void:
	_boot.call_deferred()

func _boot() -> void:
	var pm: Node = root.get_node("ProgressionManager")
	var data: Dictionary = pm.new_game(3, "T-spells")

	# Niveau par défaut : 1 pour tous les sorts
	check(pm.spell_level(data, "Tank", "Coup de bouclier") == 1, "niveau de départ 1")
	check(pm.spell_mult(data, "Tank", "Coup de bouclier") == 1.0, "multiplicateur 1.0 au niveau 1")

	# Amélioration refusée sans ressources
	var err: String = pm.upgrade_spell(data, "Tank", "Coup de bouclier")
	check(err != "", "refus sans ressources : %s" % err)

	# Amélioration avec ressources
	data["gold"] = 1000
	pm.add_resources(data, {"Magie": 50})
	err = pm.upgrade_spell(data, "Tank", "Coup de bouclier")
	check(err == "", "première amélioration acceptée")
	check(pm.spell_level(data, "Tank", "Coup de bouclier") == 2, "niveau 2 atteint")
	check(absf(pm.spell_mult(data, "Tank", "Coup de bouclier") - 1.06) < 0.001, "multiplicateur 1.06 au niveau 2")
	check(pm.gold(data) == 950, "50 or consommés")
	check(int(pm.resources(data).get("Magie", 0)) == 48, "2 Magie consommées")

	# Coût croissant : niveau 2 coûte 100 or + 4 Magie
	var cost: Dictionary = pm.spell_upgrade_cost(data, "Tank", "Coup de bouclier")
	check(int(cost["gold"]) == 100 and int(cost["magie"]) == 4, "coût niveau 2 -> 3 : 100 or + 4 Magie")

	# Montée jusqu'au maximum
	for i: int in range(8):
		data["gold"] = 10000
		pm.add_resources(data, {"Magie": 200})
		err = pm.upgrade_spell(data, "Tank", "Coup de bouclier")
	check(err == "", "neuvième amélioration acceptée")
	check(pm.spell_level(data, "Tank", "Coup de bouclier") == 10, "niveau maximum 10 atteint")
	check(pm.spell_upgrade_cost(data, "Tank", "Coup de bouclier").is_empty(), "plus de coût au niveau max")
	check(absf(pm.spell_mult(data, "Tank", "Coup de bouclier") - 1.54) < 0.001, "multiplicateur 1.54 au niveau 10")

	# Le bonus s'applique au parse du sort (dégâts augmentés)
	var spell: Dictionary = {
		"name": "Test", "classe": "Tank", "cost_pa": 2, "cost_pm": 0, "range": 1,
		"effect": "30 dégâts", "spell_type": "Attaque",
		"Degats_physiques": 30, "Degats_magiques": 0, "Soins": 0,
	}
	var p_base: Dictionary = Combat.parse(spell.duplicate())
	check(int(p_base["dmg"]) == 30, "dégâts de base 30")
	var up_spell: Dictionary = spell.duplicate()
	up_spell["spell_level"] = 10
	up_spell["mult"] = pm.spell_mult(data, "Tank", "Coup de bouclier")
	var p_up: Dictionary = Combat.parse(up_spell)
	check(int(p_up["dmg"]) == 46, "dégâts au niveau 10 : 46 (obtenu %d)" % int(p_up["dmg"]))

	# Persistance dans la sauvegarde
	pm.write_save(3, data)
	var loaded: Dictionary = pm.load_save(3)
	check(pm.spell_level(loaded, "Tank", "Coup de bouclier") == 10, "niveau conservé après sauvegarde/chargement")

	# Les sorts des autres classes ne sont pas affectés
	check(pm.spell_level(data, "Mage", "Coup de bouclier") == 1, "les autres classes restent niveau 1")

	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
