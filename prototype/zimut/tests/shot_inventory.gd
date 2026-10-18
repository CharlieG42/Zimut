extends SceneTree
## Captures : onglet Équipement (fiche Personnage) et fenêtre Inventaire.
## xvfb-run -a -s "-screen 0 1920x1080x24" godot --path . -s tests/shot_inventory.gd -- <dossier>
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var out: String = OS.get_cmdline_user_args()[0]
	var pm: Node = root.get_node("ProgressionManager")
	var data: Dictionary = pm.new_game(4, "Inventaire")
	pm.rebuild_team(data, ["Tank", "Mage", "Heal"])
	var inv: Array = []
	for lv in [1, 5, 10, 20, 30]:
		inv.append_array(pm._roll_loots(lv, lv >= 20))
		inv.append_array(pm._roll_loots(lv, false))
		inv.append_array(pm._roll_loots(lv, false))
	data["inventory"] = inv
	data["roster"]["Tank"]["level"] = 30
	data["roster"]["Assassin"]["level"] = 30
	for cl in ["Tank", "Mage", "Assassin"]:
		for i in range(mini(3, data["inventory"].size())):
			pm.equip_hero_item(data, cl, 0)
	print("objets : ", data["inventory"].size(), " + portés")
	# Fiche personnage, onglet Équipement
	var sheet: CanvasLayer = (load("res://scripts/CharacterSheetUI.gd") as GDScript).new()
	root.add_child(sheet)
	sheet.open(data, 4, "Tank")
	sheet._tab = "gear"
	sheet.refresh()
	await create_timer(0.8).timeout
	_shot(out + "/gear_tab.png")
	sheet._gear_pick = "casque"
	sheet.refresh()
	await create_timer(0.5).timeout
	_shot(out + "/gear_pick.png")
	sheet.queue_free()
	# Inventaire
	var ui: CanvasLayer = (load("res://scripts/InventoryUI.gd") as GDScript).new()
	root.add_child(ui)
	ui.open(data, 4)
	await create_timer(0.8).timeout
	_shot(out + "/inv_1.png")
	ui._f_rarity = "rare"
	ui._sort = "niveau"
	ui.refresh()
	for e in ui._shown.slice(0, 3):
		ui._toggle(String(e["key"]))
	await create_timer(0.5).timeout
	_shot(out + "/inv_2.png")
	ui._ask_confirm(true)
	await create_timer(0.5).timeout
	_shot(out + "/inv_3.png")
	pm.delete_save(4)
	quit()
func _shot(p: String) -> void:
	root.get_viewport().get_texture().get_image().save_png(p)
