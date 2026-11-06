extends SceneTree
## Onglet Caractéristiques compact : 9 cartes (6 caractéristiques + PA / PM / Portée) sur 3 colonnes, boutons + / −.
## Lancement : godot --headless --path . -s tests/test_fiche_stats.gd
var fails: int = 0
func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var pm: Node = root.get_node("ProgressionManager")
	var d: Dictionary = pm.new_game(4, "Stats")
	pm.rebuild_team(d, ["Mage", "Tank", "Heal"])
	d["heroes_unlocked"] = pm.class_names()
	var e: Dictionary = pm.roster_entry(d, "Mage")
	e["level"] = 30
	e["unspent"] = 12
	e["auto"] = false
	pm.write_save(4, d)
	var ui: CanvasLayer = (load("res://scripts/CharacterSheetUI.gd") as GDScript).new()
	ui.layer = 10
	root.add_child(ui)
	ui.open(d, 4, "Mage")
	await process_frame
	await process_frame
	var grid: GridContainer = ui.find_child("StatGrid", true, false)
	check(grid != null and grid.columns == 3, "grille à 3 colonnes")
	check(grid != null and grid.get_child_count() == 9, "9 cartes (6 caractéristiques + PA, PM, Portée)")
	for st: String in ["vita", "force", "intelligence", "agility", "wisdom", "defense", "pa", "pm", "po"]:
		if ui.find_child("StatCard_" + st, true, false) == null:
			check(false, "carte manquante : " + st)
	var before: int = int(e["invested"].get("force", 0))
	var plus: Button = ui.find_child("StatPlus_force", true, false)
	check(plus != null and not plus.disabled, "bouton + de Force actif (capital disponible)")
	plus.pressed.emit()
	await process_frame
	await process_frame
	check(int(e["invested"].get("force", 0)) == before + 1, "un point investi en Force")
	var minus: Button = ui.find_child("StatMinus_force", true, false)
	check(minus != null and not minus.disabled, "bouton − actif après investissement")
	minus.pressed.emit()
	await process_frame
	await process_frame
	check(int(e["invested"].get("force", 0)) == before, "point rendu")
	pm.delete_save(4)
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
