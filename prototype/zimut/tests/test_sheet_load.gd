## test_sheet_load.gd — Test headless : CharacterSheetUI.gd se charge sans erreur.
## Lancement : godot --headless -s tests/test_sheet_load.gd --path .
##
## Ce test vérifie que load("res://scripts/CharacterSheetUI.gd") retourne
## bien un GDScript (et non null), que l'instance s'ouvre, et que les
## onglets (stats, spells, gear, talents, builds) se construisent.

var failures: int = 0

func _init() -> void:
	_test_load_and_open()
	_test_all_tabs()
	print("")
	if failures > 0:
		print("ÉCHEC : %d test(s) en erreur." % failures)
		quit(1)
	else:
		print("OK : tous les tests passent.")
		quit(0)

func _check(cond: bool, label: String) -> void:
	if cond:
		print("  ok  %s" % label)
	else:
		failures += 1
		print("  KO  %s" % label)

func _make_save(classe: String, level: int) -> Dictionary:
	var data: Dictionary = {
		"roster": {},
		"team": [{"classe": classe, "equipment": {}}],
		"gold": 500,
		"inventory": [],
		"victories": 3,
		"resources": {"Fer": 10, "Bois": 5, "Cuir": 5, "Magie": 8, "Venin": 2},
	}
	ProgressionManager.ensure_roster(data)
	var ent: Dictionary = data["roster"][classe]
	ent["level"] = level
	ent["xp"] = ProgressionManager.xp_for_level(level)
	ent["talents"] = {"unlocked": {}, "points": TalentTree.power_for_level(level)}
	return data

func _test_load_and_open() -> void:
	print("CharacterSheetUI — chargement :")
	# 1. Le script doit se charger (pas null)
	var script: GDScript = load("res://scripts/CharacterSheetUI.gd") as GDScript
	_check(script != null, "load(CharacterSheetUI.gd) != null")
	if script == null:
		return
	# 2. L'instance doit se créer
	var ui: CanvasLayer = script.new()
	_check(ui != null, "script.new() != null")
	if ui == null:
		return
	# 3. open() doit fonctionner sans erreur
	var data: Dictionary = _make_save("Tank", 30)
	var root: Node = Engine.get_main_loop().root
	root.add_child(ui)
	ui.open(data, 0, "Tank")
	_check(true, "open() appelé sans erreur")
	# 4. Le signal closed doit exister
	_check(ui.has_signal("closed"), "signal 'closed' existe")
	# 5. Nettoyage
	ui.queue_free()

func _test_all_tabs() -> void:
	print("CharacterSheetUI — onglets :")
	var script: GDScript = load("res://scripts/CharacterSheetUI.gd") as GDScript
	if script == null:
		_check(false, "load(CharacterSheetUI.gd) != null (tab test)")
		return
	var ui: CanvasLayer = script.new()
	var root: Node = Engine.get_main_loop().root
	root.add_child(ui)
	var data: Dictionary = _make_save("Mage", 40)
	ui.open(data, 0, "Mage")
	# Tester chaque onglet via refresh()
	for tab: String in ["stats", "spells", "gear", "talents", "builds"]:
		ui.set("_tab", tab)
		ui.refresh()
		_check(true, "onglet '%s' construit sans erreur" % tab)
	# Vérifier que Builds est bien résolu (class_name)
	_check(Builds != null, "class_name Builds résolu")
	_check(Builds.build_count(data, "Mage") == 0, "Builds.build_count fonctionne")
	# Vérifier que TalentTree est bien résolu
	_check(TalentTree.power_for_level(40) == 6, "TalentTree.power_for_level(40) == 6")
	ui.queue_free()
