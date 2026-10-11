extends CanvasLayer
## TeamEquipmentUI.gd — Panneau d'équipement de l'équipe pendant la sélection.
## Pour chaque personnage : portrait entouré de cases d'équipement (arme, bouclier,
## casque, armure, bottes, bague, collier, gants, boucle, cape). Cliquer sur une
## case ouvre la liste des items compatibles de l'inventaire ; cliquer sur un item
## l'équipe. La case cliquée affiche l'objet porté.

signal closed

const COL_PANEL := Color(0.94, 0.89, 0.78, 0.97)
const COL_BORDER := Color(0.72, 0.58, 0.28, 1.0)
const COL_TXT := Color(0.22, 0.15, 0.05)
const COL_SEL := Color(0.98, 0.86, 0.45)
const COL_SLOT_EMPTY := Color(0.10, 0.13, 0.20, 0.9)
const COL_SLOT_FILLED := Color(0.30, 0.45, 0.25, 0.95)
const SLOT_SIZE := Vector2(64, 64)

## Position de chaque case autour du portrait (offsets relatifs au centre).
## Ordre : même que EQUIP_SLOTS du ProgressionManager.
const SLOT_LAYOUT := {
	"arme":           Vector2(-170, -60),
	"bouclier":       Vector2(170, -60),
	"casque":         Vector2(-170, 30),
	"armure":         Vector2(0, 110),
	"bottes":         Vector2(170, 30),
	"bague":          Vector2(-170, 120),
	"collier":        Vector2(-85, 150),
	"gants":          Vector2(85, 150),
	"boucle_oreille": Vector2(170, 120),
	"cape":           Vector2(0, -140),
}

## Icône (emoji) par emplacement.
const SLOT_ICON := {
	"arme": "⚔️", "bouclier": "🛡️", "casque": "⛑️", "armure": "👕",
	"bottes": "🥾", "bague": "💍", "collier": "📿", "gants": "🧤",
	"boucle_oreille": "👂", "cape": "🧣",
}

var _root: Control
var _save: Dictionary = {}
var _slot: int = -1
var _member_idx: int = -1

## Nœuds par personnage : [Panel(portrait), Dictionary slot_name -> Button]
var _member_frames: Array = []
## Pop-up de choix d'item : { "member": int, "slot": String, "panel": PanelContainer }
var _popup: Dictionary = {}

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
	bg.color = Color(0.06, 0.09, 0.14, 0.95)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	_root.add_child(bg)

	var title := Label.new()
	title.text = "ÉQUIPEMENT DE L'ÉQUIPE"
	title.add_theme_font_size_override("font_size", 34)
	title.add_theme_color_override("font_color", Color(1.0, 0.86, 0.4))
	title.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
	title.offset_top = 14.0
	title.offset_bottom = 70.0
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_root.add_child(title)

	var hint := Label.new()
	hint.text = "Cliquez sur une case autour d'un personnage pour l'équiper."
	hint.add_theme_font_size_override("font_size", 20)
	hint.add_theme_color_override("font_color", COL_TXT)
	hint.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
	hint.offset_top = 64.0
	hint.offset_bottom = 104.0
	hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_root.add_child(hint)

	# Rangée des personnages
	var row := HBoxContainer.new()
	row.anchor_left = 0.5
	row.anchor_right = 0.5
	row.anchor_top = 0.5
	row.anchor_bottom = 0.5
	row.offset_left = -700.0
	row.offset_right = 700.0
	row.offset_top = -200.0
	row.offset_bottom = 220.0
	row.add_theme_constant_override("separation", 60)
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	_root.add_child(row)

	var team: Array = _save.get("team", [])
	for i: int in range(team.size()):
		var frame := _build_member_frame(i)
		row.add_child(frame)
		_member_frames.append(frame)

	# Compteur d'inventaire
	var inv_lbl := Label.new()
	inv_lbl.name = "InvCount"
	inv_lbl.add_theme_font_size_override("font_size", 22)
	inv_lbl.add_theme_color_override("font_color", COL_TXT)
	inv_lbl.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
	inv_lbl.offset_top = -70.0
	inv_lbl.offset_bottom = -30.0
	inv_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_root.add_child(inv_lbl)

	var close := Button.new()
	close.text = "FERMER"
	close.custom_minimum_size = Vector2(200, 64)
	close.add_theme_font_size_override("font_size", 24)
	close.add_theme_color_override("font_color", COL_TXT)
	close.add_theme_stylebox_override("normal", _flat(COL_SEL, COL_BORDER, 12, 3))
	close.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_RIGHT)
	close.offset_left = -260.0
	close.offset_right = -40.0
	close.offset_top = -100.0
	close.offset_bottom = -30.0
	close.pressed.connect(func() -> void:
		closed.emit())
	_root.add_child(close)

## Panneau d'un personnage : portrait + cases d'équipement autour.
func _build_member_frame(member_idx: int) -> PanelContainer:
	var m: Dictionary = _save["team"][member_idx]
	var classe: String = String(m.get("classe", "?"))
	var frame := PanelContainer.new()
	frame.custom_minimum_size = Vector2(440, 400)
	frame.add_theme_stylebox_override("panel", _flat(COL_PANEL, COL_BORDER, 18, 4))
	_root_of_frame_setup(frame, classe, member_idx)
	return frame

func _root_of_frame_setup(frame: PanelContainer, classe: String, member_idx: int) -> void:
	var holder := Control.new()
	holder.custom_minimum_size = Vector2(420, 370)
	frame.add_child(holder)

	var name_lbl := Label.new()
	name_lbl.text = "%s" % classe
	name_lbl.add_theme_font_size_override("font_size", 26)
	name_lbl.add_theme_color_override("font_color", COL_TXT)
	name_lbl.position = Vector2(140, 14)
	holder.add_child(name_lbl)

	# Portrait (sprite du personnage)
	var portrait := TextureRect.new()
	var tex_path := "res://assets/sprites/players/%s.png" % classe.to_lower()
	if not ResourceLoader.exists(tex_path):
		tex_path = "res://assets/sprites/players/%s.svg" % classe.to_lower()
	if ResourceLoader.exists(tex_path):
		portrait.texture = load(tex_path)
	portrait.custom_minimum_size = Vector2(140, 170)
	portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	portrait.position = Vector2(140, 90)
	holder.add_child(portrait)

	# Cases d'équipement autour du portrait
	for slot_name: String in SLOT_LAYOUT:
		var eq: Dictionary = _save["team"][member_idx].get("equipment", {})
		var btn := Button.new()
		btn.custom_minimum_size = SLOT_SIZE
		btn.position = Vector2(210, 250) + SLOT_LAYOUT[slot_name] - SLOT_SIZE * 0.5
		btn.add_theme_font_size_override("font_size", 30)
		btn.add_theme_color_override("font_color", COL_TXT)
		btn.tooltip_text = slot_name.capitalize()
		btn.pressed.connect(_on_slot_pressed.bind(member_idx, slot_name))
		btn.name = "slot_%s" % slot_name
		holder.add_child(btn)

func refresh() -> void:
	var team: Array = _save.get("team", [])
	for i: int in range(team.size()):
		if i >= _member_frames.size():
			continue
		var frame: PanelContainer = _member_frames[i]
		var m: Dictionary = team[i]
		var eq: Dictionary = m.get("equipment", {})
		var holder: Control = frame.get_child(0)
		for slot_name: String in SLOT_LAYOUT:
			var btn: Button = holder.get_node_or_null("slot_%s" % slot_name) as Button
			if btn == null:
				continue
			if eq.has(slot_name):
				var it: Dictionary = eq[slot_name]
				btn.text = SLOT_ICON.get(slot_name, "❔")
				btn.tooltip_text = "%s\n%s (nv%d)\nF%d I%d A%d S%d V%d D%d" % [
					slot_name.capitalize(), it.get("name", "?"), int(it.get("level", 0)),
					int(it.get("force", 0)), int(it.get("intelligence", 0)), int(it.get("agility", 0)),
					int(it.get("wisdom", 0)), int(it.get("vita", 0)), int(it.get("defense", 0))]
				btn.add_theme_stylebox_override("normal", _flat(COL_SLOT_FILLED, Color(0.4, 0.6, 0.3), 10, 3))
			else:
				btn.text = SLOT_ICON.get(slot_name, "❔")
				btn.tooltip_text = "%s (vide)" % slot_name.capitalize()
				btn.add_theme_stylebox_override("normal", _flat(COL_SLOT_EMPTY, Color(0.3, 0.35, 0.45), 10, 2))
	var inv_lbl: Label = _root.get_node_or_null("InvCount") as Label
	if inv_lbl:
		var inv: Array = _save.get("inventory", [])
		if inv.is_empty():
			inv_lbl.text = "Inventaire vide — gagnez des combats pour looter des objets !"
		else:
			inv_lbl.text = "Inventaire : %d objet(s) disponible(s)" % inv.size()

## Clic sur une case : ouvrir le pop-up de choix d'item.
func _on_slot_pressed(member_idx: int, slot_name: String) -> void:
	_close_popup()
	var accepted: Array = ProgressionManager.EQUIP_SLOTS.get(slot_name, [])
	var m: Dictionary = _save["team"][member_idx]
	var eq: Dictionary = m.get("equipment", {})
	var inv: Array = _save.get("inventory", [])

	var panel := PanelContainer.new()
	panel.add_theme_stylebox_override("panel", _flat(Color(0.98, 0.95, 0.85, 0.99), COL_BORDER, 14, 4))
	_root.add_child(panel)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 8)
	panel.add_child(box)

	var title := Label.new()
	title.text = "%s — %s" % [String(m.get("classe", "?")), slot_name.capitalize()]
	title.add_theme_font_size_override("font_size", 22)
	title.add_theme_color_override("font_color", COL_TXT)
	box.add_child(title)

	if eq.has(slot_name):
		var unequip := Button.new()
		unequip.text = "✖  Déséquiper (%s)" % String(eq[slot_name].get("name", "?"))
		unequip.add_theme_font_size_override("font_size", 18)
		unequip.pressed.connect(func() -> void:
			ProgressionManager.unequip_item(_save, member_idx, slot_name)
			ProgressionManager.write_save(_slot, _save)
			_close_popup()
			refresh())
		box.add_child(unequip)

	var shown: int = 0
	for j: int in range(inv.size()):
		var it: Dictionary = inv[j]
		if not accepted.has(String(it.get("type", ""))):
			continue
		shown += 1
		var item_btn := Button.new()
		item_btn.text = "%s (nv%d) — F%d I%d A%d S%d V%d D%d" % [
			String(it.get("name", "?")), int(it.get("level", 0)),
			int(it.get("force", 0)), int(it.get("intelligence", 0)), int(it.get("agility", 0)),
			int(it.get("wisdom", 0)), int(it.get("vita", 0)), int(it.get("defense", 0))]
		item_btn.add_theme_font_size_override("font_size", 17)
		item_btn.pressed.connect(func() -> void:
			var err: String = ProgressionManager.equip_item(_save, member_idx, j)
			if err != "":
				print("equip error: ", err)
				return
			ProgressionManager.write_save(_slot, _save)
			_close_popup()
			refresh())
		box.add_child(item_btn)
	if shown == 0 and not eq.has(slot_name):
		var none := Label.new()
		none.text = "Aucun objet compatible dans l'inventaire."
		none.add_theme_font_size_override("font_size", 17)
		none.add_theme_color_override("font_color", COL_TXT)
		box.add_child(none)

	var cancel := Button.new()
	cancel.text = "Annuler"
	cancel.add_theme_font_size_override("font_size", 18)
	cancel.pressed.connect(_close_popup)
	box.add_child(cancel)

	# Position : près du personnage, borné à l'écran
	panel.reset_size()
	var dim: Vector2 = panel.get_combined_minimum_size()
	var frame: PanelContainer = _member_frames[member_idx]
	var origin: Vector2 = frame.global_position + Vector2(220, 380)
	origin.x = clampf(origin.x, 10.0, 1920.0 - dim.x - 10.0)
	origin.y = clampf(origin.y, 10.0, 1080.0 - dim.y - 10.0)
	panel.position = origin
	_popup = {"member": member_idx, "slot": slot_name, "panel": panel}

func _close_popup() -> void:
	if not _popup.is_empty():
		var panel: PanelContainer = _popup.get("panel")
		if panel != null and is_instance_valid(panel):
			panel.queue_free()
		_popup = {}

func _flat(bg: Color, border: Color, radius: int = 12, bw: int = 3) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = bg
	s.border_color = border
	s.set_border_width_all(bw)
	s.set_corner_radius_all(radius)
	return s

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and not _popup.is_empty():
		var panel: PanelContainer = _popup.get("panel")
		var rect: Rect2 = panel.get_global_rect() if panel else Rect2()
		if not rect.has_point((event as InputEventMouseButton).position):
			_close_popup()
