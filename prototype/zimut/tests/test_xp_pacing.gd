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
	check(total_combats > 1800 and total_combats < 3200, "durée de vie : %d combats de 1 à 100" % total_combats)
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
