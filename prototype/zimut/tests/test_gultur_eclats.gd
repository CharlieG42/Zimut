extends SceneTree
## V366 : conseils de Gultur (équipement, forge, donjon, éclats, caractéristiques), stock d'éclats, bouton Fortifier.
var fails: int = 0
func ck(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1
func _init() -> void:
	_run.call_deferred()
func _run() -> void:
	await process_frame
	var pm: Node = root.get_node("ProgressionManager")
	root.get_node("GameSettings").tutorial_enabled = false
	var consts: Dictionary = (Gultur as GDScript).get_script_constant_map()
	for c: String in ["EQUIP_DETAIL", "FORGE_FORTIFIER", "ECLATS_BUTIN", "DONJON_ECLATS", "STATS_RESULTATS"]:
		ck(consts.has(c) and (consts[c] as Array).size() >= 1, "textes Gultur : " + c)
		ck(not str(consts.get(c, "")).to_lower().contains("balise"), c + " : aucune spécificité de héros")
	var d: Dictionary = pm.new_game(4, "Gul")
	pm.rebuild_team(d, ["Mage", "Tank", "Heal"])
	d["heroes_unlocked"] = pm.class_names()
	Shards.stat_add(d, "force", 1, 3)
	pm.hero_equipment(d, "Mage")["arme"] = {"name": "Dague", "type": "Bâton (1 main)", "level": 1, "rarity": "rare", "force": 3}
	pm.write_save(4, d)
	var ui: CanvasLayer = (load("res://scripts/CharacterSheetUI.gd") as GDScript).new()
	ui.layer = 10
	root.add_child(ui)
	ui.open(d, 4, "Mage")
	ui._tab = "gear"
	ui.refresh()
	await process_frame
	await process_frame
	var sb: Button = ui.find_child("GearShards", true, false) as Button
	ck(sb != null and sb.text.contains("3"), "stock d'éclats affiché sur l'onglet Équipement")
	(ui.find_child("GearPick_arme", true, false) as Button).pressed.emit()
	await process_frame
	await process_frame
	var fb: Button = ui.find_child("GearDetailFortify", true, false) as Button
	ck(fb != null, "bouton Fortifier dans le détail de l'objet")
	if fb != null:
		fb.pressed.emit()
		await process_frame
		await process_frame
		var forge: Node = null
		for ch: Node in ui.get_children():
			if ch.get_script() != null and String(ch.get_script().resource_path).contains("ForgeUI"):
				forge = ch
		ck(forge != null, "la Forge s'ouvre")
		if forge != null:
			ck(forge._mode == "fortify", "sur l'onglet Fortifier")
			var e: Dictionary = forge._find_entry(forge._up_key)
			ck(not e.is_empty() and String(e["item"]["name"]) == "Dague", "objet sélectionné = l'objet porté")
			var stock: Button = forge.find_child("StatShardStock", true, false) as Button
			ck(stock != null and stock.text.contains("3"), "stock d'éclats dans la barre de la Forge")
			stock.pressed.emit()
			await process_frame
			ck(forge._up_key == "atelier|", "le stock ouvre l'Atelier d'éclats")
			forge.queue_free()
	ui.set("_tab", "stats")
	ui.refresh()
	await process_frame
	ck(ui.find_child("StatResults", true, false) != null, "onglet Caractéristiques intact")
	pm.delete_save(4)
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
