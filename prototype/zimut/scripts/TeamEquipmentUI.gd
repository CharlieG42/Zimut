extends CanvasLayer
## TeamEquipmentUI.gd — Panneau d'équipement de l'équipe pendant la sélection.
## Sélection d'un personnage de l'équipe, puis équipement item par item
## depuis l'inventaire de la partie active.

signal closed

const COL_PANEL := Color(0.94, 0.89, 0.78, 0.97)
const COL_BORDER := Color(0.72, 0.58, 0.28, 1.0)
const COL_TXT := Color(0.22, 0.15, 0.05)
const COL_SEL := Color(0.98, 0.86, 0.45)

var _root: Control
var _member_list: ItemList
var _slots_list: ItemList
var _inv_list: ItemList
var _stats_label: Label
var _save: Dictionary = {}
var _slot: int = -1
var _member_idx: int = -1

func open(save_data: Dictionary, slot: int) -> void:
	_save = save_data
	_slot = slot
	_build()
	refresh()

func _build() -> void:
	if _root != null and is_instance_valid(_root):
		_root.queue_free()
	_root = Control.new()
	_root.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(_root)
	var bg := ColorRect.new()
	bg.color = Color(0.06, 0.09, 0.14, 0.92)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	_root.add_child(bg)

	var title := Label.new()
	title.text = "ÉQUIPEMENT DE L'ÉQUIPE"
	title.add_theme_font_size_override("font_size", 34)
	title.add_theme_color_override("font_color", COL_TXT)
	title.position = Vector2(60, 20)
	_root.add_child(title)

	# Colonne 1 : membres de l'équipe
	var l1 := Label.new()
	l1.text = "Personnages :"
	l1.position = Vector2(60, 90)
	l1.add_theme_font_size_override("font_size", 22)
	l1.add_theme_color_override("font_color", COL_TXT)
	_root.add_child(l1)
	_member_list = ItemList.new()
	_member_list.position = Vector2(60, 130)
	_member_list.custom_minimum_size = Vector2(300, 380)
	_member_list.item_selected.connect(_on_member_selected)
	_root.add_child(_member_list)

	# Colonne 2 : emplacements du membre sélectionné
	var l2 := Label.new()
	l2.text = "Emplacements :"
	l2.position = Vector2(400, 90)
	l2.add_theme_font_size_override("font_size", 22)
	l2.add_theme_color_override("font_color", COL_TXT)
	_root.add_child(l2)
	_slots_list = ItemList.new()
	_slots_list.position = Vector2(400, 130)
	_slots_list.custom_minimum_size = Vector2(340, 380)
	_slots_list.item_selected.connect(_on_slot_selected)
	_root.add_child(_slots_list)

	# Colonne 3 : inventaire (items compatibles avec l'emplacement choisi)
	var l3 := Label.new()
	l3.text = "Inventaire :"
	l3.position = Vector2(780, 90)
	l3.add_theme_font_size_override("font_size", 22)
	l3.add_theme_color_override("font_color", COL_TXT)
	_root.add_child(l3)
	_inv_list = ItemList.new()
	_inv_list.position = Vector2(780, 130)
	_inv_list.custom_minimum_size = Vector2(480, 380)
	_inv_list.item_selected.connect(_on_inv_selected)
	_root.add_child(_inv_list)

	# Stats du membre avec bonus d'équipement
	_stats_label = Label.new()
	_stats_label.position = Vector2(400, 530)
	_stats_label.add_theme_font_size_override("font_size", 19)
	_stats_label.add_theme_color_override("font_color", COL_TXT)
	_root.add_child(_stats_label)

	var close := Button.new()
	close.text = "FERMER"
	close.position = Vector2(1160, 530)
	close.custom_minimum_size = Vector2(180, 64)
	close.add_theme_font_size_override("font_size", 22)
	close.add_theme_color_override("font_color", COL_TXT)
	close.add_theme_stylebox_override("normal", _flat(COL_SEL, COL_BORDER, 12, 3))
	close.pressed.connect(func() -> void:
		_root.queue_free()
		closed.emit())
	_root.add_child(close)

func refresh() -> void:
	_member_list.clear()
	_slots_list.clear()
	_inv_list.clear()
	var team: Array = _save.get("team", [])
	for i: int in range(team.size()):
		var m: Dictionary = team[i]
		var eq: Dictionary = m.get("equipment", {})
		_member_list.add_item("%s (%d objets)" % [m.get("classe", "?"), eq.size()])
	if _member_idx >= 0 and _member_idx < team.size():
		_member_list.select(_member_idx)
		_fill_slots()

func _on_member_selected(idx: int) -> void:
	_member_idx = idx
	_fill_slots()

func _fill_slots() -> void:
	_slots_list.clear()
	_inv_list.clear()
	if _member_idx < 0:
		return
	var m: Dictionary = _save["team"][_member_idx]
	var eq: Dictionary = m.get("equipment", {})
	var slot_names: Array = ProgressionManager.EQUIP_SLOTS.keys()
	for s: String in slot_names:
		if eq.has(s):
			var it: Dictionary = eq[s]
			_slots_list.add_item("%s : %s" % [s, it.get("name", "?")])
		else:
			_slots_list.add_item("%s : (vide)" % s)
	_update_stats()

func _on_slot_selected(idx: int) -> void:
	_inv_list.clear()
	if _member_idx < 0:
		return
	var slot_names: Array = ProgressionManager.EQUIP_SLOTS.keys()
	if idx >= slot_names.size():
		return
	var slot_name: String = slot_names[idx]
	var accepted: Array = ProgressionManager.EQUIP_SLOTS[slot_name]
	var m: Dictionary = _save["team"][_member_idx]
	# Option déséquiper si l'emplacement est occupé
	var eq: Dictionary = m.get("equipment", {})
	if eq.has(slot_name):
		_inv_list.add_item("(déséquiper)")
	var inv: Array = _save.get("inventory", [])
	for j: int in range(inv.size()):
		var it: Dictionary = inv[j]
		if accepted.has(String(it.get("type", ""))):
			_inv_list.add_item("%s — %s (nv%d) F%d I%d A%d S%d V%d D%d" % [
				it.get("name", "?"), it.get("type", "?"), int(it.get("level", 0)),
				int(it.get("force", 0)), int(it.get("intelligence", 0)), int(it.get("agility", 0)),
				int(it.get("wisdom", 0)), int(it.get("vita", 0)), int(it.get("defense", 0))])
			_inv_list.set_item_metadata(_inv_list.item_count - 1, j)

func _on_inv_selected(idx: int) -> void:
	if _member_idx < 0 or _slot < 0:
		return
	var slot_names: Array = ProgressionManager.EQUIP_SLOTS.keys()
	# L'emplacement choisi = le dernier surligné de _slots_list ; on garde
	# le mapping par index : _on_slot_selected a déjà rempli _inv_list selon
	# l'emplacement. On récupère l'index d'inventaire via les métadonnées.
	var meta = _inv_list.get_item_metadata(idx)
	var m: Dictionary = _save["team"][_member_idx]
	var eq: Dictionary = m.get("equipment", {})
	var sel_slots: PackedInt32Array = _slots_list.get_selected_items()
	if sel_slots.is_empty():
		return
	var slot_name: String = slot_names[sel_slots[0]]
	if meta == null:
		# Première entrée = déséquiper
		if eq.has(slot_name):
			ProgressionManager.unequip_item(_save, _member_idx, slot_name)
	else:
		var inv_idx: int = int(meta)
		# equip_item déplace l'ancien item vers l'inventaire automatiquement
		var err: String = ProgressionManager.equip_item(_save, _member_idx, inv_idx)
		if err != "":
			print("equip error: ", err)
			return
	ProgressionManager.write_save(_slot, _save)
	refresh()
	# resélectionner le membre
	_member_list.select(_member_idx)
	_fill_slots()

func _update_stats() -> void:
	if _member_idx < 0:
		_stats_label.text = ""
		return
	var m: Dictionary = _save["team"][_member_idx]
	var eq: Dictionary = m.get("equipment", {})
	var names: Array = []
	for s: String in eq.keys():
		names.append("%s: %s" % [s, eq[s].get("name", "?")])
	_stats_label.text = "Équipé : %s" % ("; ".join(names) if names.size() > 0 else "rien")

func _flat(bg: Color, border: Color, radius: int = 12, bw: int = 3) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = bg
	s.border_color = border
	s.set_border_width_all(bw)
	s.set_corner_radius_all(radius)
	return s
