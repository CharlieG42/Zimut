extends SceneTree
## Test de la nouvelle UI d'équipement : cases autour du perso, clic, équipement.

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
	var data = pm.new_game(0, "TestV2")
	data["team"] = [
		{"classe": "Tank", "equipment": {}},
		{"classe": "Mage", "equipment": {}},
		{"classe": "Sylvain", "equipment": {}},
	]
	data["inventory"] = [
		{"type": "Casque", "name": "Casque de fer", "level": 3, "force": 2, "intelligence": 0, "agility": 0, "wisdom": 1, "vita": 5, "defense": 3},
		{"type": "Bague", "name": "Anneau de sagesse", "level": 5, "force": 0, "intelligence": 2, "agility": 0, "wisdom": 2, "vita": 0, "defense": 0},
	]
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
	print("1. bouton:", eq_btn.text if eq_btn else "ABSENT", "| disabled:", eq_btn.disabled if eq_btn else "-")

	eq_btn.pressed.emit()
	await process_frame
	await process_frame

	# UI d'équipement présente ?
	var equip: CanvasLayer = null
	for child in sc.get_children():
		if child is CanvasLayer and child.get_script() != null:
			if String(child.get_script().resource_path).contains("TeamEquipmentUI"):
				equip = child
	print("2. UI équipement ouverte:", equip != null)
	assert(equip != null)
	print("   frames:", equip._member_frames.size(), "(attendu 3)")

	# Cliquer sur la case "casque" du Tank
	var frame0: PanelContainer = equip._member_frames[0]
	var holder: Control = frame0.get_child(0)
	var casque_btn: Button = holder.get_node_or_null("slot_casque") as Button
	print("3. case casque trouvée:", casque_btn != null, "| texte:", casque_btn.text if casque_btn else "-")
	casque_btn.pressed.emit()
	await process_frame
	# pop-up ouvert ?
	print("   popup ouvert:", not equip._popup.is_empty())
	# trouver le bouton du casque de fer dans le pop-up
	var popup_panel: PanelContainer = equip._popup.get("panel")
	var item_btn := _find_btn(popup_panel, "Casque de fer")
	print("4. item trouvé dans le popup:", item_btn != null)
	item_btn.pressed.emit()
	await process_frame
	# vérifier la sauvegarde
	var reloaded: Dictionary = pm.load_save(0)
	var t: Array = reloaded.get("team", [])
	print("5. Tank equipment:", t[0].get("equipment", {}).keys(), "| inventaire:", reloaded.get("inventory", []).size())
	assert(t[0].get("equipment", {}).has("casque"))
	assert(reloaded.get("inventory", []).size() == 1)

	# déséquiper via popup
	casque_btn.pressed.emit()
	await process_frame
	var unequip_btn := _find_btn(equip._popup.get("panel"), "Déséquiper")
	print("6. déséquiper trouvé:", unequip_btn != null)
	unequip_btn.pressed.emit()
	await process_frame
	var reloaded2: Dictionary = pm.load_save(0)
	print("   après déséquip:", reloaded2["team"][0].get("equipment", {}).keys(), "| inv:", reloaded2.get("inventory", []).size())
	assert(not reloaded2["team"][0].get("equipment", {}).has("casque"))
	assert(reloaded2.get("inventory", []).size() == 2)
	print("EQUIP V2 OK")

	gm.active_slot = -1
	gm.active_save = {}
	pm.delete_save(0)
	quit(0)
