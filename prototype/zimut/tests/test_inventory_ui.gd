extends SceneTree
## Fenêtre Inventaire : entrées (libres + portées), filtres, tri, sélection, briseur, fusion.
## godot --headless --path . -s tests/test_inventory_ui.gd
var _fails: int = 0
func _ok(cond: bool, msg: String) -> void:
	if cond:
		print("  ok   ", msg)
	else:
		print("  ÉCHEC ", msg)
		_fails += 1
func _init() -> void:
	_run.call_deferred()
func _run() -> void:
	var pm: Node = root.get_node("ProgressionManager")
	var data: Dictionary = pm.new_game(4, "InvUI")
	pm.rebuild_team(data, ["Tank", "Mage", "Heal"])
	data["inventory"] = [
		{"type": "Épée (1 main)", "name": "Épée A", "level": 3, "rarity": "commun", "force": 4},
		{"type": "Épée (1 main)", "name": "Épée B", "level": 9, "rarity": "rare", "force": 9},
		{"type": "Casque", "name": "Casque C", "level": 5, "rarity": "epique", "defense": 7},
		{"type": "Bottes", "name": "Bottes D", "level": 2, "rarity": "commun", "agility": 3},
		{"type": "Cape", "name": "Cape E", "level": 7, "rarity": "legendaire", "wisdom": 8},
	]
	data["roster"]["Tank"]["level"] = 20
	data["roster"]["Assassin"]["level"] = 20
	pm.equip_hero_item(data, "Tank", 1)          # Épée B portée par le Tank (équipe)
	pm.equip_hero_item(data, "Assassin", 3)       # Cape E portée par l'Assassin (hors équipe)
	var ui: CanvasLayer = (load("res://scripts/InventoryUI.gd") as GDScript).new()
	root.add_child(ui)
	ui.open(data, 4)
	await process_frame
	_ok(ui._entries.size() == 5, "5 objets au total, portés compris (%d)" % ui._entries.size())
	_ok(ui._entries.filter(func(e: Dictionary) -> bool: return String(e["owner"]) != "").size() == 2, "2 objets portés")
	ui._f_status = "libres"
	ui.refresh()
	_ok(ui._shown.size() == 3, "filtre Libres : 3")
	ui._f_status = "portes"
	ui.refresh()
	_ok(ui._shown.size() == 2, "filtre Portés : 2")
	ui._f_status = "tous"
	ui._f_type = "arme"
	ui.refresh()
	_ok(ui._shown.size() == 2, "filtre type Arme : 2 (une portée, une libre)")
	ui._f_type = "all"
	ui._f_rarity = "legendaire"
	ui.refresh()
	_ok(ui._shown.size() == 1 and String(ui._shown[0]["it"]["name"]) == "Cape E", "filtre rareté Légendaire : la cape portée")
	ui._f_rarity = "all"
	ui._sort = "niveau"
	ui._desc = true
	ui.refresh()
	_ok(String(ui._shown[0]["it"]["name"]) == "Épée B", "tri niveau décroissant : Épée B d'abord")
	ui._desc = false
	ui.refresh()
	_ok(String(ui._shown[0]["it"]["name"]) == "Bottes D", "tri niveau croissant : Bottes D d'abord")
	ui._sort = "rarete"
	ui._desc = true
	ui.refresh()
	_ok(String(ui._shown[0]["it"]["name"]) == "Cape E", "tri rareté décroissant : légendaire d'abord")
	ui._sort = "nom"
	ui._desc = false
	ui.refresh()
	_ok(String(ui._shown[0]["it"]["name"]) == "Bottes D", "tri par nom croissant")
	# Sélection multiple (un libre + un porté)
	ui._sort = "rarete"
	ui._desc = true
	ui.refresh()
	for e in ui._shown:
		if String(e["it"]["name"]) in ["Casque C", "Épée B"]:
			ui._toggle(String(e["key"]))
	_ok(ui._sel.size() == 2, "2 objets sélectionnés")
	var fused: Array = [false]
	ui.fusion_requested.connect(func() -> void: fused[0] = true)
	var res_before: int = (data["resources"] as Dictionary).size()
	ui._do_salvage(true)
	_ok(fused[0], "« Briser puis Fusion » demande l'ouverture de la Forge en Fusion")
	_ok(data["inventory"].size() == 2, "libres restants : Épée A, Bottes D (%d)" % data["inventory"].size())
	_ok(not pm.hero_equipment(data, "Tank").has("arme"), "l'épée portée a été retirée puis brisée")
	_ok((data["resources"] as Dictionary).size() >= res_before and not (data["resources"] as Dictionary).is_empty(), "ressources créditées")
	ui.refresh()
	_ok(ui._entries.size() == 3, "3 objets restants dans la liste (%d)" % ui._entries.size())
	_ok(ui._sel.is_empty(), "sélection vidée")
	# Forge : show_mode
	var forge: CanvasLayer = (load("res://scripts/ForgeUI.gd") as GDScript).new()
	root.add_child(forge)
	forge.open(data, 4, 0)
	forge.show_mode("fusion")
	_ok(forge._mode == "fusion", "la Forge s'ouvre sur Fusion")
	pm.delete_save(4)
	print("RÉSULTAT : ", "OK" if _fails == 0 else "%d échec(s)" % _fails)
	quit(1 if _fails > 0 else 0)
