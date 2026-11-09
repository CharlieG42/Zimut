extends SceneTree
## V126 — Forge : le héros qui porte l'équipement apparaît (liste Améliorer, détail Améliorer / Fortifier).
var _fails: int = 0
func ck(c: bool, m: String) -> void:
	if c:
		print("  ok  ", m)
	else:
		print("  ÉCHEC  ", m)
		_fails += 1
func _init() -> void:
	_run.call_deferred()
func _count(n: Node, nm: String) -> int:
	var c: int = 1 if n.name == nm else 0
	for ch in n.get_children():
		c += _count(ch, nm)
	return c
func _run() -> void:
	var pm: Node = root.get_node("ProgressionManager")
	var data: Dictionary = pm.new_game(4, "ForgePorteur")
	pm.rebuild_team(data, ["Tank", "Mage"])
	for it in pm._roll_loots(30, false):
		var sl: String = pm.slot_for_type(String(it.get("type", "")))
		if sl != "" and not data["team"][1]["equipment"].has(sl):
			data["team"][1]["equipment"][sl] = it
			break
	data["inventory"].append(pm._roll_loots(20, false)[0])
	var ui: CanvasLayer = (load("res://scripts/ForgeUI.gd") as GDScript).new()
	root.add_child(ui)
	ui.open(data, 4, 0)
	var mage_item: Dictionary = {}
	var bag_item: Dictionary = {}
	for e: Dictionary in pm.upgradable_items(data):
		if String(e["src"]) == "team" and int(e["member"]) == 1 and mage_item.is_empty():
			mage_item = e
		elif String(e["src"]) == "inv" and bag_item.is_empty():
			bag_item = e
	ck(ui._owner_class(mage_item) == "Mage", "équipement porté : le porteur est le Mage")
	ck(ui._owner_class(bag_item) == "", "objet du sac : pas de porteur")
	for mode: String in ["upgrade", "fortify"]:
		ui._mode = mode
		ui._up_key = ui._entry_key(mage_item)
		ui.refresh()
		await create_timer(0.3).timeout
		ck(_count(ui, "PorteurDetail") == 1, "%s : « Porté par Mage » dans le détail" % mode)
		ui._up_key = ui._entry_key(bag_item)
		ui.refresh()
		await create_timer(0.3).timeout
		ck(_count(ui, "PorteurDetail") == 0, "%s : rien pour un objet du sac" % mode)
	ui._mode = "upgrade"
	ui._up_key = ""
	ui.refresh()
	await create_timer(0.3).timeout
	ck(_count(ui, "Porteur") >= 1, "liste : portrait du porteur sur la ligne de l'équipement porté")
	pm.delete_save(4)
	print("OK : tous les tests passent." if _fails == 0 else "ÉCHEC : %d" % _fails)
	quit(1 if _fails > 0 else 0)
