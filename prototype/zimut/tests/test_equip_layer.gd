extends SceneTree
## Vérifie que l'UI d'équipement passe AU-DESSUS de la sélection (layer > 0).

var pm: Node

func _init() -> void:
	pm = load("res://scripts/ProgressionManager.gd").new()
	pm.name = "ProgressionManagerTest"
	root.add_child.call_deferred(pm)
	_boot.call_deferred()

func _find_btn(node: Node, txt: String) -> Button:
	if node is Button and (node as Button).text.contains(txt):
		return node
	for c in node.get_children():
		var b := _find_btn(c, txt)
		if b != null:
			return b
	return null

func _boot() -> void:
	var data = pm.new_game(0, "Layer")
	data["team"] = [{"classe": "Tank", "equipment": {}}, {"classe": "Mage", "equipment": {}}, {"classe": "Heal", "equipment": {}}]
	data["inventory"] = [{"type": "Casque", "name": "Casque de fer", "level": 1}]
	pm.write_save(0, data)

	var sc = (load("res://scenes/TeamSelection.tscn") as PackedScene).instantiate()
	root.add_child(sc)
	await process_frame
	await process_frame

	var gm = root.get_node("/root/GameManager")
	gm.active_slot = 0
	gm.active_save = pm.load_save(0)
	sc.refresh()

	var eq_btn := _find_btn(sc, "ÉQUIPEMENT")
	eq_btn.pressed.emit()
	await process_frame
	await process_frame

	var equip: CanvasLayer = null
	for child in sc.get_children():
		if child is CanvasLayer and child.get_script() != null:
			if String(child.get_script().resource_path).contains("TeamEquipmentUI"):
				equip = child
	assert(equip != null)
	print("1. layer de la sélection (parent):", sc.layer if sc is CanvasLayer else sc.get_class())
	print("   layer de l'UI équipement:", equip.layer)
	assert(equip.layer > (sc.layer if sc is CanvasLayer else 0))

	# L'UI d'équipement doit être au-dessus : le pop-up d'item doit être cliquable
	var frame0: PanelContainer = equip._member_frames[0]
	var holder: Control = frame0.get_child(0)
	var casque_btn: Button = holder.get_node_or_null("slot_casque") as Button
	casque_btn.pressed.emit()
	await process_frame
	assert(not equip._popup.is_empty())
	var item_btn := _find_btn(equip._popup.get("panel"), "Casque de fer")
	assert(item_btn != null)
	item_btn.pressed.emit()
	await process_frame
	var reloaded: Dictionary = pm.load_save(0)
	assert(reloaded["team"][0].get("equipment", {}).has("casque"))
	print("2. équipement via le pop-up OK (au-dessus de la sélection)")

	gm.active_slot = -1
	gm.active_save = {}
	pm.delete_save(0)
	quit(0)
