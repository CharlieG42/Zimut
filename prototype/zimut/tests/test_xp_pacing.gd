extends SceneTree

## Tests du rythme de progression XP :
## - ~3 combats par niveau au début (V19, avant : ~2)
## - paliers de plus en plus longs, jusqu'à ~200 combats pour le dernier niveau
## Usage : godot --headless --path prototype/zimut -s tests/test_xp_pacing.gd

var pm: Node
var fails: int = 0

func _init() -> void:
	pm = load("res://scripts/ProgressionManager.gd").new()
	pm.name = "ProgressionManager"
	root.add_child.call_deferred(pm)
	_boot.call_deferred()

func check(cond: bool, msg: String) -> void:
	print(("  ok  " if cond else "  ÉCHEC  ") + msg)
	if not cond:
		fails += 1

func _boot() -> void:
	# Paliers XP : niveau 1 = 0 XP, ~2 combats par niveau au début, ~100 à la fin
	check(pm.xp_for_level(1) == 0, "niveau 1 : palier XP à 0 (départ)")
	var step1: int = pm.xp_for_level(2) - pm.xp_for_level(1)
	var c1: float = float(step1) / float(pm.combat_xp(1))
	check(absf(c1 - 3.0) < 0.35, "lv1 -> lv2 en ~3 combats (V19 : progression plus lente au début) (%.1f)" % c1)
	var step99: int = pm.xp_for_level(100) - pm.xp_for_level(99)
	var c99: float = float(step99) / float(pm.combat_xp(99))
	check(c99 > 60.0 and c99 < 140.0, "lv99 -> lv100 en ~100 combats (%.1f)" % c99)
	var total_combats: int = 0
	for lv: int in range(1, ClassRules.MAX_LEVEL):
		total_combats += pm.combats_for_level(lv)
	check(total_combats > 3000 and total_combats < 4500, "durée de vie : %d combats de 1 à 100 (gain d'XP -25 %%)" % total_combats)
	# V92 : gains d'XP -25 % (combats réels = combats des paliers / 0,75)
	check(absf(ClassRules.XP_GAIN_MULT - 0.75) < 0.0001, "gains d'XP réduits de 25 %")
	check(pm.combats_for_level(1) == 4, "lv1 -> lv2 : 4 combats réels (3 / 0,75) (%d)" % pm.combats_for_level(1))
	# V92 : courbe exponentielle — l'XP à gagner par niveau croît d'un facteur ~constant, et monter est
	# toujours plus long à haut niveau (même rapport entre niveaux voisins au début et à la fin).
	var ratios: Array[float] = []
	for lv: int in range(2, ClassRules.MAX_LEVEL - 1):
		var a: float = float(pm.xp_for_level(lv + 1) - pm.xp_for_level(lv))
		var b: float = float(pm.xp_for_level(lv + 2) - pm.xp_for_level(lv + 1))
		ratios.append(b / a)
	var min_r: float = ratios.min()
	var max_r: float = ratios.max()
	check(min_r >= 1.0 and max_r < 1.09, "chaque niveau demande plus d'XP que le précédent, sans à-coup (x%.3f à x%.3f)" % [min_r, max_r])
	var step10: float = float(pm.xp_for_level(11) - pm.xp_for_level(10))
	var step50: float = float(pm.xp_for_level(51) - pm.xp_for_level(50))
	var step90: float = float(pm.xp_for_level(91) - pm.xp_for_level(90))
	check(step50 / step10 > 5.0 and step90 / step50 > 5.0, "croissance exponentielle : x%.1f de 10 à 50, x%.1f de 50 à 90" % [step50 / step10, step90 / step50])
	check(pm.combats_for_level(90) > 15 * pm.combats_for_level(10), "à haut niveau, monter demande bien plus de combats (%d contre %d)" % [pm.combats_for_level(90), pm.combats_for_level(10)])
	# L'XP distribuée est réduite de 25 %
	var gdata: Dictionary = pm.new_game(4, "Gain")
	pm.rebuild_team(gdata, ["Tank", "Mage", "Heal"])
	var rep: Dictionary = pm.award_xp(gdata, 1000, 1.0, 0)
	var g_tank: int = int(rep["Tank"]["gain"])
	var expected: int = roundi(1000.0 * 0.75 * ClassRules.xp_mult("Tank"))
	check(abs(g_tank - expected) <= 1, "award_xp : 1000 XP brute -> %d (attendu %d)" % [g_tank, expected])
	# Ancienne sauvegarde : niveaux conservés, XP convertie vers les nouveaux paliers
	var old: Dictionary = pm.new_game(4, "Old")
	pm.rebuild_team(old, ["Tank", "Mage", "Heal"])
	old.erase("xp_curve_v")
	old["roster"]["Tank"]["level"] = 40
	old["roster"]["Tank"]["xp"] = (pm._legacy_xp_for_level(40) + pm._legacy_xp_for_level(41)) / 2
	old["player"] = {"level": 40, "xp": pm._legacy_xp_for_level(40)}
	pm.ensure_roster(old)
	var tank_xp: int = int(old["roster"]["Tank"]["xp"])
	var mid: int = (pm.xp_for_level(40) + pm.xp_for_level(41)) / 2
	check(int(old["roster"]["Tank"]["level"]) == 40 and absi(tank_xp - mid) <= 2, "ancienne sauvegarde : niveau 40 et mi-barre conservés (%d / %d)" % [tank_xp, mid])
	check(int(old["xp_curve_v"]) == 2, "la conversion de courbe n'est faite qu'une fois")
	var monotone: bool = true
	var prev: int = -1
	for lv: int in range(1, ClassRules.MAX_LEVEL + 1):
		var xp: int = pm.xp_for_level(lv)
		if xp <= prev:
			monotone = false
		prev = xp
	check(monotone, "paliers XP strictement croissants")
	# Les combats rapportent de plus en plus d'XP (progression évolutive)
	check(pm.combat_xp(100) > pm.combat_xp(60) and pm.combat_xp(60) > pm.combat_xp(30),
		"XP par combat croissante avec le niveau")
	# Simulé : victoires répétées, le roster monte bien les niveaux
	var data: Dictionary = pm.new_game(4, "Pacing")
	pm.rebuild_team(data, ["Tank", "Mage", "Heal"])
	for i: int in range(9):
		var el: int = pm.enemy_level_for(data)
		pm.register_victory(data, {"enemies": [
			{"type": "Gobelin", "level": el, "boss": false},
			{"type": "Loup", "level": el, "boss": false},
			{"type": "Gobelin", "level": el, "boss": false},
			{"type": "Loup", "level": el, "boss": false}]})
	var lvl: int = pm.member_level(data, "Tank")
	check(lvl >= 2 and lvl <= 6, "9 victoires au départ : équipe niveau 2-6 (obtenu %d)" % lvl)
	check(pm.enemy_level_for(data) >= 1 and pm.enemy_level_for(data) <= ClassRules.ENEMY_MAX_LEVEL, "niveau d'ennemis dans 1..150")
	check(pm.frontier_level({"team": [], "victories": 100000}) == ClassRules.ENEMY_MAX_LEVEL, "niveau d'ennemis plafonné à 150")
	# Boss : kit avec attaque à distance ET CaC
	var boss_spells: Array = Combat.boss_spells("Gobelin", 30)
	var has_melee: bool = false
	var has_ranged: bool = false
	for s: Dictionary in boss_spells:
		if int(s["range"]) <= 1:
			has_melee = true
		if int(s["range"]) >= 5:
			has_ranged = true
	check(has_melee, "boss Gobelin : garde une attaque de CaC")
	check(has_ranged, "boss Gobelin : attaque puissante à distance")
	# Ennemis : tous les types ont au moins un sort, le Loup tire à distance
	var wolf: Array = Combat.enemy_spells("Loup", 20)
	check(wolf.size() >= 2, "Loup : CaC + distance")
	var gob: Array = Combat.enemy_spells("Gobelin", 20)
	check(gob.size() >= 2, "Gobelin : CaC + distance")
	print("== TOUS OK ==" if fails == 0 else "== %d ÉCHECS ==" % fails)
	quit(0 if fails == 0 else 1)
