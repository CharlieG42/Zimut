extends SceneTree

## Tests du rythme de progression XP :
## - passage du niveau 10 au 11 en ~3 combats de la frontière
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
	# Paliers XP monotones croissants et calibrés
	check(pm.xp_for_level(10) == 0, "niveau 10 : palier XP à 0 (départ)")
	check(pm.xp_for_level(11) == 495, "niveau 11 : 495 XP requis")
	var step10: int = pm.xp_for_level(11) - pm.xp_for_level(10)
	var c10: float = float(step10) / float(pm.combat_xp(10))
	check(absf(c10 - 3.0) < 0.35, "lv10 -> lv11 en ~3 combats (%.1f)" % c10)
	var step49: int = pm.xp_for_level(50) - pm.xp_for_level(49)
	var c49: float = float(step49) / float(pm.combat_xp(49))
	check(absf(c49 - 200.0) < 30.0, "lv49 -> lv50 en ~200 combats (%.1f)" % c49)
	var monotone: bool = true
	var prev: int = 0
	for lv: int in range(11, ClassRules.MAX_LEVEL + 1):
		var xp: int = pm.xp_for_level(lv)
		if xp <= prev:
			monotone = false
		prev = xp
	check(monotone, "paliers XP strictement croissants")
	# Les combats rapportent de plus en plus d'XP (progression évolutive)
	check(pm.combat_xp(50) > pm.combat_xp(30) and pm.combat_xp(30) > pm.combat_xp(10),
		"XP par combat croissante avec le niveau")
	# Simulated : victoires répétées, le roster monte bien les niveaux
	var data: Dictionary = pm.new_game(4, "Pacing")
	pm.rebuild_team(data, ["Tank", "Mage", "Heal"])
	for i: int in range(9):
		pm.register_victory(data, {"enemies": [
			{"type": "Gobelin", "level": 10, "boss": false},
			{"type": "Loup", "level": 10, "boss": false},
			{"type": "Gobelin", "level": 10, "boss": false},
			{"type": "Loup", "level": 10, "boss": false}]})
	var lvl: int = pm.member_level(data, "Tank")
	check(lvl >= 12 and lvl <= 13, "9 victoires au combat nv10 : équipe aux niveaux 12-13 (~3 combats/palier, pas 1 niveau/combat)")
	# Le niveau de la frontière suit toujours l'équipe
	check(pm.enemy_level_for(data) >= 10, "niveau d'ennemis >= départ")
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
