extends CanvasLayer
## TalentTreeUI.gd — Écran de l'arbre de talents account-wide (V42).
##
## 4 branches (Offense, Défense, Utilitaire, Économie) avec des talents
## débloquables contre des "points de gloire" gagnés en débloquant des succès.
## Les bonus s'appliquent à TOUTES les parties.

signal closed

const C_BG := Color(0.05, 0.07, 0.12, 1.0)
const C_PANEL := Color(0.09, 0.11, 0.17, 0.98)
const C_CARD := Color(0.12, 0.15, 0.23, 1.0)
const C_CARD_ON := Color(0.18, 0.24, 0.16, 1.0)
const C_BORDER := Color(0.30, 0.36, 0.50, 1.0)
const C_GOLD := Color(1.00, 0.82, 0.35)
const C_TXT := Color(0.95, 0.94, 0.90)
const C_DIM := Color(0.62, 0.66, 0.76)
const C_GOOD := Color(0.45, 0.88, 0.50)

const U = preload("res://scripts/UiKit.gd")

var _root: Control


func _ready() -> void:
	_build()
	_refresh()


func _build() -> void:
	_root = Control.new()
	add_child(_root)
	UiFit.apply(_root, 1.1, Vector2(1400, 900))
	var bg := ColorRect.new()
	bg.color = C_BG
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	_root.add_child(bg)

	var margin := MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	for side in ["left", "right"]:
		margin.add_theme_constant_override("margin_" + side, 30)
	margin.add_theme_constant_override("margin_top", 16)
	margin.add_theme_constant_override("margin_bottom", 18)
	_root.add_child(margin)

	var page := VBoxContainer.new()
	page.add_theme_constant_override("separation", 12)
	margin.add_child(page)

	# En-tête
	var top := HBoxContainer.new()
	top.add_theme_constant_override("separation", 20)
	page.add_child(top)
	top.add_child(U.lbl("ARBRE DE TALENTS", 34, C_GOLD, true))
	var pts_lbl := U.lbl("", 22, C_GOOD)
	pts_lbl.name = "PointsLabel"
	pts_lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	top.add_child(pts_lbl)
	top.add_child(U.spacer())
	var close := U.btn("✕  FERMER", Color(0.95, 0.75, 0.30), 22, Vector2(190, 52))
	close.pressed.connect(func() -> void: closed.emit())
	top.add_child(close)

	# Info
	var info := U.lbl("Débloquez des succès pour gagner des points de gloire.\nLes talents s'appliquent à toutes vos parties.", 18, C_DIM)
	info.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	page.add_child(info)

	# Branches en grille 2x2
	var grid := GridContainer.new()
	grid.columns = 2
	grid.add_theme_constant_override("h_separation", 16)
	grid.add_theme_constant_override("v_separation", 16)
	grid.size_flags_vertical = Control.SIZE_EXPAND_FILL
	page.add_child(grid)

	for branch: String in ["offense", "defense", "utility", "economy"]:
		grid.add_child(_build_branch(branch))


func _build_branch(branch: String) -> PanelContainer:
	var info: Dictionary = TalentTree.BRANCHES[branch]
	var panel := PanelContainer.new()
	panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	panel.add_theme_stylebox_override("panel", U.box(C_PANEL, info["color"], 16, 3, 14))

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 8)
	panel.add_child(box)

	var title := U.lbl("%s %s" % [info["icon"], info["label"]], 24, info["color"], true)
	box.add_child(title)

	var talents: Array = TalentTree.branch_talents(branch)
	for t: Array in talents:
		box.add_child(_build_talent_node(String(t[0]), String(t[1]), String(t[2]), int(t[3]), info["color"]))

	return panel


func _build_talent_node(id: String, name: String, desc: String, cost: int, branch_color: Color) -> Control:
	var unlocked: bool = TalentTree.is_unlocked(id)
	var affordable: bool = TalentTree.points() >= cost and not unlocked

	var btn := Button.new()
	btn.custom_minimum_size = Vector2(0, 64)
	btn.focus_mode = Control.FOCUS_NONE
	btn.disabled = unlocked or not affordable
	btn.mouse_filter = Control.MOUSE_FILTER_STOP

	var bg_col: Color = C_CARD_ON if unlocked else (C_CARD if affordable else Color(0.08, 0.10, 0.14))
	var border_col: Color = C_GOOD if unlocked else (branch_color if affordable else Color(0.20, 0.22, 0.30))
	btn.add_theme_stylebox_override("normal", U.box(bg_col, border_col, 10, 2, 10))
	btn.add_theme_stylebox_override("hover", U.box(bg_col.lightened(0.08), border_col.lightened(0.2), 10, 3, 10))
	btn.add_theme_stylebox_override("disabled", U.box(bg_col, border_col, 10, 2, 10))

	var hbox := HBoxContainer.new()
	hbox.add_theme_constant_override("separation", 10)
	hbox.mouse_filter = Control.MOUSE_FILTER_IGNORE
	btn.add_child(hbox)

	var status := U.lbl("✓" if unlocked else ("★" if affordable else "🔒"), 22,
		C_GOOD if unlocked else (branch_color if affordable else C_DIM))
	hbox.add_child(status)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 2)
	vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	vbox.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hbox.add_child(vbox)

	var name_lbl := U.lbl(name, 19, C_TXT if unlocked or affordable else C_DIM)
	vbox.add_child(name_lbl)
	var desc_lbl := U.lbl(desc, 15, C_DIM)
	vbox.add_child(desc_lbl)

	var cost_lbl := U.lbl("★ %d" % cost, 18, C_GOLD if affordable else C_DIM)
	cost_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	hbox.add_child(cost_lbl)

	if not unlocked and affordable:
		btn.pressed.connect(func() -> void:
			if TalentTree.spend_point(id):
				_refresh())

	btn.tooltip_text = desc
	return btn


func _refresh() -> void:
	var pts: int = TalentTree.points()
	var pts_lbl: Label = _root.find_child("PointsLabel", true, false)
	if pts_lbl != null:
		pts_lbl.text = "★ %d point%s de gloire" % [pts, "s" if pts > 1 else ""]
	# Reconstruit l'arbre pour refléter l'état
	for c in _root.get_children():
		if c is MarginContainer:
			c.queue_free()
	# Rebuild complet simplifié : on reconstruit toute la page
	_build_page()


func _build_page() -> void:
	# On enlève tout sauf le fond et on reconstruit
	for c in _root.get_children():
		if c is ColorRect:
			continue
		c.queue_free()

	var margin := MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	for side in ["left", "right"]:
		margin.add_theme_constant_override("margin_" + side, 30)
	margin.add_theme_constant_override("margin_top", 16)
	margin.add_theme_constant_override("margin_bottom", 18)
	_root.add_child(margin)

	var page := VBoxContainer.new()
	page.add_theme_constant_override("separation", 12)
	margin.add_child(page)

	var top := HBoxContainer.new()
	top.add_theme_constant_override("separation", 20)
	page.add_child(top)
	top.add_child(U.lbl("ARBRE DE TALENTS", 34, C_GOLD, true))
	var pts_lbl := U.lbl("★ %d point%s de gloire" % [TalentTree.points(), "s" if TalentTree.points() > 1 else ""], 22, C_GOOD)
	pts_lbl.name = "PointsLabel"
	pts_lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	top.add_child(pts_lbl)
	top.add_child(U.spacer())
	var close := U.btn("✕  FERMER", Color(0.95, 0.75, 0.30), 22, Vector2(190, 52))
	close.pressed.connect(func() -> void: closed.emit())
	top.add_child(close)

	var info := U.lbl("Débloquez des succès pour gagner des points de gloire.\nLes talents s'appliquent à toutes vos parties.", 18, C_DIM)
	info.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	page.add_child(info)

	var grid := GridContainer.new()
	grid.columns = 2
	grid.add_theme_constant_override("h_separation", 16)
	grid.add_theme_constant_override("v_separation", 16)
	grid.size_flags_vertical = Control.SIZE_EXPAND_FILL
	page.add_child(grid)

	for branch: String in ["offense", "defense", "utility", "economy"]:
		grid.add_child(_build_branch(branch))
