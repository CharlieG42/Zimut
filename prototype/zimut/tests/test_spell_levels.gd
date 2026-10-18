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

	# Amélioration refusée sans point de sort (niveau 1 : 0 point)
	var err: String = pm.upgrade_spell(data, "Tank", "Coup de bouclier")
	check(err != "", "refus sans points de sort : %s" % err)
	check(pm.spell_points_total(100) == 297 and pm.spell_points_total(1) == 0, "3 points de sort par niveau (297 au niveau 100)")

	# Amélioration avec points : niveau 30 -> 87 points
	pm.roster_entry(data, "Tank")["level"] = 30
	check(pm.spell_points_free(data, "Tank") == 87, "87 points libres au niveau 30")
	err = pm.upgrade_spell(data, "Tank", "Coup de bouclier")
	check(err == "", "première amélioration acceptée")
	check(pm.spell_level(data, "Tank", "Coup de bouclier") == 2, "niveau 2 atteint")
	check(absf(pm.spell_mult(data, "Tank", "Coup de bouclier") - 1.06) < 0.001, "multiplicateur 1.06 au niveau 2")
	check(pm.spell_points_free(data, "Tank") == 86, "1 point consommé")

	# Coût croissant : niveau 2 -> 3 coûte 2 points
	var cost: Dictionary = pm.spell_upgrade_cost(data, "Tank", "Coup de bouclier")
	check(int(cost["points"]) == 2, "coût niveau 2 -> 3 : 2 points")

	# Sort pas encore débloqué : refusé
	pm.roster_entry(data, "Tank")["level"] = 50
	check(pm.upgrade_spell(data, "Tank", "Colère") != "", "sort verrouillé (niveau 65) : amélioration refusée")

	# Montée jusqu'au maximum : 45 points au total pour 1 -> 10
	for i: int in range(8):
		err = pm.upgrade_spell(data, "Tank", "Coup de bouclier")
	check(err == "", "neuvième amélioration acceptée")
	check(pm.spell_level(data, "Tank", "Coup de bouclier") == 10, "niveau maximum 10 atteint")
	check(pm.spell_upgrade_cost(data, "Tank", "Coup de bouclier").is_empty(), "plus de coût au niveau max")
	check(pm.spell_points_spent(data, "Tank") == 45, "45 points pour 1 -> 10")
	check(absf(pm.spell_mult(data, "Tank", "Coup de bouclier") - 1.54) < 0.001, "multiplicateur 1.54 au niveau 10")
	check(5 * 45 <= pm.spell_points_total(ClassRules.MAX_LEVEL) and 10 * 45 > pm.spell_points_total(ClassRules.MAX_LEVEL), "niveau 100 : 5 sorts au maximum possibles, pas les 10 (225 <= 297 < 450)")

	# Retrait d'un niveau et remise à zéro gratuite
	check(pm.downgrade_spell(data, "Tank", "Coup de bouclier") == "" and pm.spell_level(data, "Tank", "Coup de bouclier") == 9, "retrait d'un niveau")
	pm.reset_spells(data, "Tank")
	check(pm.spell_points_spent(data, "Tank") == 0 and pm.spell_points_free(data, "Tank") == 147, "remise à zéro gratuite : tous les points rendus")
	for i: int in range(9):
		pm.upgrade_spell(data, "Tank", "Coup de bouclier")
	pm.roster_entry(data, "Tank")["level"] = 80

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

	# Répartition automatique des points de sort
	pm.roster_entry(data, "Mage")["level"] = 20
	var n: int = pm.auto_spells(data, "Mage")
	check(n > 0 and pm.spell_points_free(data, "Mage") <= 2, "auto : points dépensés (%d niveaux, %d restants)" % [n, pm.spell_points_free(data, "Mage")])
	check(pm.spell_level(data, "Mage", "Boule de feu") > 1, "auto : un sort de dégâts monté")
	check(bool(pm.roster_entry(data, "Mage").get("spell_auto", false)), "auto : mode mémorisé")
	pm.downgrade_spell(data, "Mage", "Boule de feu")
	check(not bool(pm.roster_entry(data, "Mage").get("spell_auto", true)), "un réglage manuel repasse en manuel")

	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
