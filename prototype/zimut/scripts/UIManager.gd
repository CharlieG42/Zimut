extends CanvasLayer
## UIManager.gd — Interface de combat façon Waven / Dofus.
##   • Timeline d'initiative en portraits (haut)
##   • Panneau du personnage actif : PV, orbes PA / PM (bas-gauche)
##   • Barre de sorts défilante avec coûts, raccourcis 1-9 et infobulle (bas-centre)
##   • Gros bouton « FIN DU TOUR », Auto, Son, changement d'équipe (bas-droite)
##   • Journal de combat, bannières de tour, fiche de survol, écran de fin
## Toute l'interface est construite par code (les anciens nœuds de la scène sont masqués).

signal end_turn_requested
signal restart_requested
signal spell_selected(spell)

const COL_PANEL := Color(0.94, 0.89, 0.78, 0.94)
const COL_BORDER := Color(0.72, 0.58, 0.28, 1.0)
const COL_PLAYER := Color(0.22, 0.45, 0.85)
const COL_ENEMY := Color(0.80, 0.22, 0.20)
const COL_SUMMON := Color(0.25, 0.70, 0.45)

var game_manager: Node
var _grid: Node

var _root: Control
var _timeline: Control
var _stats: Control
var _spell_scroll: ScrollContainer
var _spell_box: VBoxContainer
var _tip_panel: PanelContainer
var _tip_label: Label
var _end_btn: Button
var _auto_btn: Button
var _sound_btn: Button
var _log_box: VBoxContainer
var _banner: Label
var _info_panel: PanelContainer
var _info_label: Label
var _over: ColorRect
var _over_title: Label
var _over_sub: Label
var _cards: Array = []
var _cards_owner: int = -1


# ═══════════════════════════════════════════════════════════════════════════
#  Cartes de sorts
# ═══════════════════════════════════════════════════════════════════════════

class SpellCard extends Button:
	var spell: Dictionary = {}
	var gm: Node = null
	var hotkey: int = 0
	var base_col: Color = Color(0.5, 0.2, 0.2)
	var selected: bool = false
	var usable: bool = true

	func _draw() -> void:
		var font: Font = ThemeDB.fallback_font
		var cost: int = int(spell.get("cost_pa", 0))
		var orb_c := Vector2(24, 24)
		draw_circle(orb_c, 21.0, Color(0.02, 0.04, 0.1))
		draw_circle(orb_c, 18.0, Color(0.15, 0.55, 0.95) if usable else Color(0.3, 0.33, 0.4))
		draw_circle(orb_c + Vector2(-3, -5), 9.0, Color(1, 1, 1, 0.2))
		draw_string(font, orb_c + Vector2(-18, 8), str(cost), HORIZONTAL_ALIGNMENT_CENTER, 36, 24, Color.WHITE)
		if int(spell.get("cost_pm", 0)) > 0:
			var pc := Vector2(size.x - 22, 22)
			draw_circle(pc, 15.0, Color(0.1, 0.55, 0.25))
			draw_string(font, pc + Vector2(-15, 7), str(int(spell["cost_pm"])), HORIZONTAL_ALIGNMENT_CENTER, 30, 20, Color.WHITE)
		var rng: int = int(spell.get("range", 1))
		draw_string_outline(font, Vector2(size.x - 56, size.y - 8), "Port. %d" % rng, HORIZONTAL_ALIGNMENT_RIGHT, 50, 14, 4, Color(0, 0, 0, 0.8))
		draw_string(font, Vector2(size.x - 56, size.y - 8), "Port. %d" % rng, HORIZONTAL_ALIGNMENT_RIGHT, 50, 14, Color(0.9, 0.95, 1.0))
		if hotkey > 0:
			draw_string_outline(font, Vector2(8, size.y - 8), str(hotkey % 10), HORIZONTAL_ALIGNMENT_LEFT, 20, 16, 4, Color(0, 0, 0, 0.8))
			draw_string(font, Vector2(8, size.y - 8), str(hotkey % 10), HORIZONTAL_ALIGNMENT_LEFT, 20, 16, Color(1, 0.95, 0.6))
		if gm != null and gm.active_entity.size() > 0:
			var left: int = gm.casts_left(gm.active_entity, spell)
			if left < Combat.max_casts(spell) and left >= 0:
				draw_string_outline(font, Vector2(size.x * 0.5 - 20, size.y - 24), "x%d" % left, HORIZONTAL_ALIGNMENT_CENTER, 40, 14, 4, Color(0, 0, 0, 0.8))
				draw_string(font, Vector2(size.x * 0.5 - 20, size.y - 24), "x%d" % left, HORIZONTAL_ALIGNMENT_CENTER, 40, 14, Color(1, 0.9, 0.5))


func _flat(bg: Color, border: Color, radius: int = 14, bw: int = 3) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = bg
	s.border_color = border
	s.set_border_width_all(bw)
	s.set_corner_radius_all(radius)
	s.shadow_color = Color(0, 0, 0, 0.45)
	s.shadow_size = 6
	return s


func _kind_color(spell: Dictionary) -> Color:
	var p: Dictionary = Combat.parse(spell)
	match String(p["kind"]):
		"heal":
			return Color(0.45, 0.75, 0.50)
		"buff":
			return Color(0.90, 0.80, 0.40)
		"summon", "teleport", "revive":
			return Color(0.70, 0.55, 0.85)
		"trap":
			return Color(0.90, 0.65, 0.35)
	return Color(0.55, 0.65, 0.95) if String(p["dtype"]) == "mag" else Color(0.95, 0.50, 0.42)


# ═══════════════════════════════════════════════════════════════════════════
#  Vues dessinées (timeline, panneau de personnage)
# ═══════════════════════════════════════════════════════════════════════════

class TimelineView extends Control:
	var gm: Node = null

	func _process(_d: float) -> void:
		queue_redraw()

	func _draw() -> void:
		if gm == null or gm.turn_order.is_empty():
			return
		var font: Font = ThemeDB.fallback_font
		# Ordre à partir de l'entité active
		var order: Array = []
		var start: int = 0
		for i: int in range(gm.turn_order.size()):
			if int(gm.turn_order[i]["uid"]) == int(gm.active_entity.get("uid", -1)):
				start = i
				break
		for k: int in range(gm.turn_order.size()):
			var e: Dictionary = gm.turn_order[(start + k) % gm.turn_order.size()]
			if gm.is_alive(e):
				order.append(e)
		var total_w: float = 0.0
		for k: int in range(order.size()):
			total_w += (96.0 if k == 0 else 74.0) + 8.0
		var x: float = (size.x - total_w) * 0.5
		for k: int in range(order.size()):
			var e2: Dictionary = order[k]
			var big: bool = (k == 0)
			var w: float = 96.0 if big else 74.0
			var y: float = 6.0
			var team_col: Color = Color(0.22, 0.45, 0.85)
			if e2["entity_type"] == "Summon":
				team_col = Color(0.25, 0.70, 0.45)
			elif e2["team"] == "enemy":
				team_col = Color(0.80, 0.22, 0.20)
			var bg := StyleBoxFlat.new()
			bg.bg_color = team_col.darkened(0.55)
			bg.border_color = Color(1.0, 0.85, 0.25) if big else team_col.lightened(0.15)
			bg.set_border_width_all(4 if big else 3)
			bg.set_corner_radius_all(14)
			bg.shadow_color = Color(0, 0, 0, 0.5)
			bg.shadow_size = 5
			var rect := Rect2(x, y, w, w)
			draw_style_box(bg, rect)
			var tex: Texture2D = Portraits.get_texture(e2)
			if tex != null:
				draw_texture_rect_region(tex, rect.grow(-6.0), Portraits.head_region(tex))
			else:
				var col: Color = e2.get("color", Color(0.6, 0.6, 0.6))
				draw_circle(rect.get_center(), w * 0.32, col)
				draw_string(font, rect.position + Vector2(0, w * 0.6), String(e2["classe"]).substr(0, 3), HORIZONTAL_ALIGNMENT_CENTER, w, 20, Color.WHITE)
			# Barre de vie
			var ratio: float = clampf(float(e2["current_pv"]) / maxf(1.0, float(e2["max_pv"])), 0.0, 1.0)
			var hb := Rect2(x + 4.0, y + w - 10.0, w - 8.0, 7.0)
			draw_rect(hb, Color(0, 0, 0, 0.8))
			draw_rect(Rect2(hb.position, Vector2(hb.size.x * ratio, hb.size.y)), Color(0.35, 0.9, 0.4) if e2["team"] == "player" else Color(0.95, 0.3, 0.25))
			if big:
				draw_string_outline(font, Vector2(x, y + w + 20.0), String(e2["classe"]), HORIZONTAL_ALIGNMENT_CENTER, w, 16, 5, Color(0, 0, 0, 0.9))
				draw_string(font, Vector2(x, y + w + 20.0), String(e2["classe"]), HORIZONTAL_ALIGNMENT_CENTER, w, 16, Color(1, 0.95, 0.75))
			x += w + 8.0


class StatsView extends Control:
	var gm: Node = null

	func _process(_d: float) -> void:
		queue_redraw()

	func _orb(c: Vector2, r: float, dark: Color, light: Color, text: String, label: String) -> void:
		var font: Font = ThemeDB.fallback_font
		draw_circle(c, r + 5.0, Color(1, 1, 1, 0.85))
		draw_circle(c, r + 2.0, Color(0.02, 0.04, 0.1))
		draw_circle(c, r, dark)
		draw_circle(c + Vector2(0, -r * 0.18), r * 0.8, light)
		draw_circle(c + Vector2(-r * 0.3, -r * 0.45), r * 0.28, Color(1, 1, 1, 0.3))
		draw_string_outline(font, c + Vector2(-r, 14.0), text, HORIZONTAL_ALIGNMENT_CENTER, r * 2.0, 40, 8, Color(0, 0, 0, 0.8))
		draw_string(font, c + Vector2(-r, 14.0), text, HORIZONTAL_ALIGNMENT_CENTER, r * 2.0, 40, Color.WHITE)
		draw_string_outline(font, c + Vector2(-r, r + 24.0), label, HORIZONTAL_ALIGNMENT_CENTER, r * 2.0, 16, 5, Color(0, 0, 0, 0.9))
		draw_string(font, c + Vector2(-r, r + 24.0), label, HORIZONTAL_ALIGNMENT_CENTER, r * 2.0, 16, Color(0.85, 0.92, 1.0))

	func _draw() -> void:
		if gm == null or gm.active_entity.is_empty():
			return
		var e: Dictionary = gm.active_entity
		var font: Font = ThemeDB.fallback_font
		var team_col: Color = Color(0.36, 0.52, 0.85) if e["team"] == "player" else Color(0.85, 0.3, 0.28)
		var bg := StyleBoxFlat.new()
		bg.bg_color = Color(0.07, 0.09, 0.15, 0.90)
		bg.border_color = team_col
		bg.set_border_width_all(3)
		bg.set_corner_radius_all(20)
		bg.shadow_color = Color(0, 0, 0, 0.5)
		bg.shadow_size = 8
		draw_style_box(bg, Rect2(Vector2.ZERO, size))
		var pr := Rect2(16, 18, 140, 140)
		var pbg := StyleBoxFlat.new()
		pbg.bg_color = team_col.darkened(0.6)
		pbg.border_color = Color(1, 0.85, 0.3)
		pbg.set_border_width_all(4)
		pbg.set_corner_radius_all(16)
		draw_style_box(pbg, pr)
		var tex: Texture2D = Portraits.get_texture(e)
		if tex != null:
			draw_texture_rect_region(tex, pr.grow(-6.0), Portraits.head_region(tex))
		else:
			draw_circle(pr.get_center(), 46.0, e.get("color", Color(0.6, 0.6, 0.6)))
		draw_string(font, Vector2(172, 40), String(e["name"]), HORIZONTAL_ALIGNMENT_LEFT, 360, 26, Color(1, 0.95, 0.8))
		var hb := Rect2(172, 52, 350, 24)
		draw_rect(hb.grow(2.0), Color(0, 0, 0, 0.85))
		var ratio: float = clampf(float(e["current_pv"]) / maxf(1.0, float(e["max_pv"])), 0.0, 1.0)
		draw_rect(Rect2(hb.position, Vector2(hb.size.x * ratio, hb.size.y)), Color(0.3, 0.85, 0.35) if e["team"] == "player" else Color(0.9, 0.28, 0.25))
		draw_rect(Rect2(hb.position, Vector2(hb.size.x * ratio, hb.size.y * 0.4)), Color(1, 1, 1, 0.2))
		draw_string_outline(font, hb.position + Vector2(0, 19), "%d / %d" % [int(e["current_pv"]), int(e["max_pv"])], HORIZONTAL_ALIGNMENT_CENTER, hb.size.x, 18, 5, Color(0, 0, 0, 0.9))
		draw_string(font, hb.position + Vector2(0, 19), "%d / %d" % [int(e["current_pv"]), int(e["max_pv"])], HORIZONTAL_ALIGNMENT_CENTER, hb.size.x, 18, Color.WHITE)
		_orb(Vector2(232, 118), 36.0, Color(0.05, 0.25, 0.65), Color(0.2, 0.62, 1.0), "%d" % int(e["current_pa"]), "PA")
		_orb(Vector2(328, 118), 36.0, Color(0.05, 0.4, 0.15), Color(0.25, 0.8, 0.35), "%d" % int(e["current_pm"]), "PM")
		draw_string(font, Vector2(400, 112), "Tour %d" % int(gm.turn_count), HORIZONTAL_ALIGNMENT_LEFT, 130, 22, Color(0.8, 0.88, 1.0))
		var rest: String = "Votre tour" if gm.current_turn == 0 else ("Auto…" if gm.auto_mode else "Tour adverse")
		draw_string(font, Vector2(400, 140), rest, HORIZONTAL_ALIGNMENT_LEFT, 130, 16, Color(1, 0.85, 0.4) if gm.current_turn == 0 else Color(1, 0.55, 0.5))


# ═══════════════════════════════════════════════════════════════════════════
#  Construction
# ═══════════════════════════════════════════════════════════════════════════

func init(manager: Node) -> void:
	game_manager = manager
	_grid = get_node_or_null("../GridManager")
	# Masque l'ancienne interface de la scène
	for c: Node in get_children():
		if c is CanvasItem:
			(c as CanvasItem).visible = false
	_build_ui()
	_connect_signals()


func _connect_signals() -> void:
	game_manager.turn_started.connect(_on_turn_started)
	game_manager.state_changed.connect(_refresh)
	game_manager.spell_selected.connect(_on_spell_state)
	game_manager.message_requested.connect(_on_message)
	game_manager.game_ended.connect(_on_game_ended)
	game_manager.fx.connect(_on_fx)
	if _grid != null and _grid.has_signal("hover_changed"):
		_grid.hover_changed.connect(_on_hover)


func _build_ui() -> void:
	_root = Control.new()
	_root.name = "HUD"
	_root.set_anchors_preset(Control.PRESET_FULL_RECT)
	_root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_root)

	# Timeline
	var tl := TimelineView.new()
	tl.gm = game_manager
	tl.mouse_filter = Control.MOUSE_FILTER_IGNORE
	tl.anchor_left = 0.5
	tl.anchor_right = 0.5
	tl.offset_left = -800.0
	tl.offset_right = 800.0
	tl.offset_top = 6.0
	tl.offset_bottom = 140.0
	_root.add_child(tl)
	_timeline = tl

	# Panneau du personnage actif
	var st := StatsView.new()
	st.gm = game_manager
	st.mouse_filter = Control.MOUSE_FILTER_IGNORE
	st.anchor_top = 1.0
	st.anchor_bottom = 1.0
	st.offset_left = 18.0
	st.offset_right = 568.0
	st.offset_top = -214.0
	st.offset_bottom = -18.0
	_root.add_child(st)
	_stats = st

	# Barre de sorts
	_spell_scroll = ScrollContainer.new()
	_spell_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	_spell_scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	_spell_scroll.anchor_left = 0.0
	_spell_scroll.anchor_right = 0.0
	_spell_scroll.anchor_top = 0.0
	_spell_scroll.anchor_bottom = 1.0
	_spell_scroll.offset_left = 12.0
	_spell_scroll.offset_right = 200.0
	_spell_scroll.offset_top = 12.0
	_spell_scroll.offset_bottom = -12.0
	_root.add_child(_spell_scroll)
	_spell_box = VBoxContainer.new()
	_spell_box.add_theme_constant_override("separation", 12)
	_spell_scroll.add_child(_spell_box)

	# Infobulle de sort
	_tip_panel = PanelContainer.new()
	_tip_panel.add_theme_stylebox_override("panel", _flat(Color(0.06, 0.08, 0.14, 0.95), Color(1, 0.85, 0.35), 14, 2))
	_tip_panel.anchor_left = 0.5
	_tip_panel.anchor_right = 0.5
	_tip_panel.anchor_top = 1.0
	_tip_panel.anchor_bottom = 1.0
	_tip_panel.offset_left = -360.0
	_tip_panel.offset_right = 100.0
	_tip_panel.offset_top = -330.0
	_tip_panel.offset_bottom = -194.0
	_tip_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_tip_panel.visible = false
	_tip_label = Label.new()
	_tip_label.add_theme_font_size_override("font_size", 22)
	_tip_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_tip_label.custom_minimum_size = Vector2(420, 0)
	_tip_panel.add_child(_tip_label)
	_root.add_child(_tip_panel)

	# Bouton fin de tour
	_end_btn = Button.new()
	_end_btn.text = "FIN DU\nTOUR"
	_end_btn.add_theme_font_size_override("font_size", 30)
	_end_btn.add_theme_color_override("font_color", Color(0.25, 0.18, 0.08))
	_end_btn.add_theme_color_override("font_hover_color", Color(0.15, 0.1, 0.02))
	_end_btn.add_theme_stylebox_override("normal", _flat(Color(0.98, 0.86, 0.45), Color(0.72, 0.58, 0.28), 40, 5))
	_end_btn.add_theme_stylebox_override("hover", _flat(Color(1.0, 0.92, 0.6), Color(0.85, 0.68, 0.3), 40, 5))
	_end_btn.add_theme_stylebox_override("pressed", _flat(Color(0.9, 0.76, 0.35), Color(0.6, 0.48, 0.2), 40, 5))
	_end_btn.add_theme_stylebox_override("disabled", _flat(Color(0.12, 0.14, 0.2), Color(0.3, 0.35, 0.45), 40, 5))
	_end_btn.anchor_left = 1.0
	_end_btn.anchor_right = 1.0
	_end_btn.anchor_top = 1.0
	_end_btn.anchor_bottom = 1.0
	_end_btn.offset_left = -330.0
	_end_btn.offset_right = -22.0
	_end_btn.offset_top = -170.0
	_end_btn.offset_bottom = -24.0
	_end_btn.pressed.connect(func() -> void:
		Sfx.play("click")
		end_turn_requested.emit())
	_root.add_child(_end_btn)

	# Boutons secondaires
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 8)
	row.anchor_left = 1.0
	row.anchor_right = 1.0
	row.anchor_top = 1.0
	row.anchor_bottom = 1.0
	row.offset_left = -330.0
	row.offset_right = -22.0
	row.offset_top = -236.0
	row.offset_bottom = -182.0
	_root.add_child(row)
	_auto_btn = _small_button("Auto", true)
	_auto_btn.toggled.connect(func(on: bool) -> void:
		Sfx.play("click")
		game_manager.set_auto(on))
	row.add_child(_auto_btn)
	_sound_btn = _small_button("Son : oui", true)
	_sound_btn.button_pressed = Sfx.enabled
	_sound_btn.toggled.connect(func(on: bool) -> void:
		Sfx.enabled = on
		_sound_btn.text = "Son : oui" if on else "Son : non"
		Sfx.play("click"))
	row.add_child(_sound_btn)
	var team_btn: Button = _small_button("Équipe", false)
	team_btn.pressed.connect(_on_team_selection_pressed)
	row.add_child(team_btn)

	# Journal de combat
	_log_box = VBoxContainer.new()
	_log_box.add_theme_constant_override("separation", 2)
	_log_box.position = Vector2(20, 160)
	_log_box.size = Vector2(560, 300)
	_log_box.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_root.add_child(_log_box)

	# Bannière
	_banner = Label.new()
	_banner.add_theme_font_size_override("font_size", 64)
	_banner.add_theme_color_override("font_color", Color(1, 0.93, 0.6))
	_banner.add_theme_color_override("font_outline_color", Color(0.1, 0.05, 0.0, 0.95))
	_banner.add_theme_constant_override("outline_size", 14)
	_banner.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_banner.set_anchors_preset(Control.PRESET_CENTER_TOP)
	_banner.anchor_left = 0.0
	_banner.anchor_right = 1.0
	_banner.offset_top = 190.0
	_banner.offset_bottom = 290.0
	_banner.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_banner.modulate.a = 0.0
	_root.add_child(_banner)

	# Fiche de survol
	_info_panel = PanelContainer.new()
	_info_panel.add_theme_stylebox_override("panel", _flat(COL_PANEL, COL_BORDER, 14, 2))
	_info_panel.anchor_left = 1.0
	_info_panel.anchor_right = 1.0
	_info_panel.offset_left = -330.0
	_info_panel.offset_right = -20.0
	_info_panel.offset_top = 160.0
	_info_panel.offset_bottom = 330.0
	_info_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_info_panel.visible = false
	_info_label = Label.new()
	_info_label.add_theme_font_size_override("font_size", 18)
	_info_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_info_label.custom_minimum_size = Vector2(280, 0)
	_info_panel.add_child(_info_label)
	_root.add_child(_info_panel)

	# Écran de fin
	_over = ColorRect.new()
	_over.color = Color(0, 0, 0, 0.7)
	_over.set_anchors_preset(Control.PRESET_FULL_RECT)
	_over.visible = false
	_root.add_child(_over)
	var box := VBoxContainer.new()
	box.set_anchors_preset(Control.PRESET_CENTER)
	box.anchor_left = 0.5
	box.anchor_right = 0.5
	box.anchor_top = 0.5
	box.anchor_bottom = 0.5
	box.offset_left = -300.0
	box.offset_right = 300.0
	box.offset_top = -200.0
	box.offset_bottom = 200.0
	box.alignment = BoxContainer.ALIGNMENT_CENTER
	box.add_theme_constant_override("separation", 22)
	_over.add_child(box)
	_over_title = Label.new()
	_over_title.add_theme_font_size_override("font_size", 96)
	_over_title.add_theme_constant_override("outline_size", 16)
	_over_title.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.95))
	_over_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	box.add_child(_over_title)
	_over_sub = Label.new()
	_over_sub.add_theme_font_size_override("font_size", 28)
	_over_sub.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	box.add_child(_over_sub)
	var again: Button = _big_button("Rejouer")
	again.pressed.connect(func() -> void:
		Sfx.play("click")
		restart_requested.emit())
	box.add_child(again)
	var other: Button = _big_button("Changer d'équipe")
	other.pressed.connect(_on_team_selection_pressed)
	box.add_child(other)


func _small_button(text: String, toggle: bool) -> Button:
	var b := Button.new()
	b.text = text
	b.toggle_mode = toggle
	b.custom_minimum_size = Vector2(96, 54)
	b.add_theme_font_size_override("font_size", 18)
	b.add_theme_stylebox_override("normal", _flat(Color(0.1, 0.13, 0.22, 0.92), Color(0.4, 0.5, 0.75), 12, 2))
	b.add_theme_stylebox_override("hover", _flat(Color(0.16, 0.2, 0.32, 0.95), Color(0.6, 0.75, 1.0), 12, 2))
	b.add_theme_stylebox_override("pressed", _flat(Color(0.5, 0.35, 0.08, 0.95), Color(1.0, 0.85, 0.3), 12, 2))
	return b


func _big_button(text: String) -> Button:
	var b := _small_button(text, false)
	b.custom_minimum_size = Vector2(380, 80)
	b.add_theme_font_size_override("font_size", 32)
	b.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	return b


# ═══════════════════════════════════════════════════════════════════════════
#  Mise à jour
# ═══════════════════════════════════════════════════════════════════════════

func _on_turn_started(e: Dictionary) -> void:
	_rebuild_spell_bar(e)
	var txt: String
	var col := Color(1, 0.93, 0.6)
	if e["entity_type"] == "Player" and not game_manager.auto_mode:
		txt = "À vous de jouer !"
		col = Color(0.65, 0.9, 1.0)
	else:
		txt = "Tour : %s" % e["name"]
		col = Color(1.0, 0.65, 0.55) if e["team"] == "enemy" else Color(0.7, 1.0, 0.75)
	_show_banner(txt, col)
	_refresh()


func _show_banner(text: String, col: Color) -> void:
	_banner.text = text
	_banner.add_theme_color_override("font_color", col)
	_banner.pivot_offset = Vector2(_banner.size.x * 0.5, 50.0)
	_banner.scale = Vector2(0.8, 0.8)
	_banner.modulate.a = 0.0
	var tw: Tween = create_tween()
	tw.tween_property(_banner, "modulate:a", 1.0, 0.15)
	tw.parallel().tween_property(_banner, "scale", Vector2.ONE, 0.2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tw.tween_interval(0.7)
	tw.tween_property(_banner, "modulate:a", 0.0, 0.35)


func _rebuild_spell_bar(e: Dictionary) -> void:
	for c: Node in _spell_box.get_children():
		c.queue_free()
	_cards = []
	_cards_owner = int(e["uid"])
	var idx: int = 0
	for spell: Dictionary in e["spells"]:
		idx += 1
		var card := SpellCard.new()
		card.spell = spell
		card.gm = game_manager
		card.hotkey = idx if idx <= 10 else 0
		card.base_col = _kind_color(spell)
		card.custom_minimum_size = Vector2(180, 84)
		card.text = String(spell["name"])
		card.add_theme_font_size_override("font_size", 21)
		card.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		card.add_theme_color_override("font_color", Color(0.22, 0.15, 0.05))
		card.add_theme_color_override("font_hover_color", Color(0.1, 0.07, 0.02))
		card.add_theme_color_override("font_pressed_color", Color(0.1, 0.07, 0.02))
		card.add_theme_constant_override("outline_size", 0)
		card.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0))
		card.focus_mode = Control.FOCUS_NONE
		_style_card(card, false)
		card.pressed.connect(func() -> void: spell_selected.emit(spell))
		card.mouse_entered.connect(func() -> void: _show_tip(spell))
		card.mouse_exited.connect(func() -> void: _show_tip(game_manager.selected_spell))
		_spell_box.add_child(card)
		_cards.append(card)
	_spell_scroll.scroll_horizontal = 0


func _style_card(card: SpellCard, selected: bool) -> void:
	var col: Color = card.base_col if card.usable else card.base_col.lerp(Color(0.75, 0.73, 0.70), 0.65).darkened(0.12)
	var border: Color = Color(1.0, 0.9, 0.3) if selected else col.lightened(0.45)
	card.add_theme_stylebox_override("normal", _flat(col.darkened(0.15), border, 16, 5 if selected else 3))
	card.add_theme_stylebox_override("hover", _flat(col.lightened(0.1), Color(1, 1, 1, 0.9), 16, 4))
	card.add_theme_stylebox_override("pressed", _flat(col.darkened(0.3), Color(1, 0.9, 0.3), 16, 5))
	card.add_theme_stylebox_override("focus", _flat(col, border, 16, 3))
	card.add_theme_stylebox_override("disabled", _flat(col.darkened(0.5), border, 16, 3))


func _refresh() -> void:
	if game_manager == null or _root == null:
		return
	var e: Dictionary = game_manager.active_entity
	if not e.is_empty() and int(e["uid"]) != _cards_owner:
		_rebuild_spell_bar(e)
	var my_turn: bool = game_manager.current_turn == 0 and not game_manager.game_over
	for card: SpellCard in _cards:
		var usable: bool = false
		if not e.is_empty():
			usable = game_manager.can_afford(e, card.spell) and game_manager.casts_left(e, card.spell) > 0
		var sel: bool = game_manager.selected_spell != null and game_manager.selected_spell["name"] == card.spell["name"]
		if usable != card.usable or sel != card.selected:
			card.usable = usable
			card.selected = sel
			_style_card(card, sel)
		card.modulate = Color(1, 1, 1, 1.0 if my_turn else 0.5)
		card.queue_redraw()
	_end_btn.disabled = not my_turn
	_auto_btn.set_pressed_no_signal(game_manager.auto_mode)
	if _grid != null and _info_panel.visible and "hover_cell" in _grid:
		_on_hover(_grid.hover_cell)
	_spell_scroll.modulate = Color(1, 1, 1, 1.0)


func _on_spell_state(spell) -> void:
	_show_tip(spell)
	_refresh()


func _show_tip(spell) -> void:
	if spell == null:
		_tip_panel.visible = false
		return
	var p: Dictionary = Combat.parse(spell)
	var lines: Array[String] = []
	lines.append("%s" % spell["name"])
	var rng_txt: String = "Portée %d" % int(spell["range"]) if p["target"] != "self" else "Sur soi"
	var costs: String = "%d PA" % int(spell["cost_pa"])
	if int(spell.get("cost_pm", 0)) > 0:
		costs += " + %d PM" % int(spell["cost_pm"])
	lines.append("%s  ·  %s  ·  %d/tour" % [costs, rng_txt, Combat.max_casts(spell)])
	lines.append(Combat.describe(spell))
	if p["aoe"] == "zone":
		lines.append("Zone d'effet")
	if p["needs_los"]:
		lines.append("Ligne de vue requise")
	_tip_label.text = "\n".join(lines)
	_tip_panel.visible = true
	_tip_panel.reset_size()


func _on_message(text: String) -> void:
	if text == "" or _log_box == null:
		return
	var l := Label.new()
	l.text = text
	l.add_theme_font_size_override("font_size", 22)
	l.add_theme_color_override("font_color", Color(1, 1, 0.92))
	l.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.95))
	l.add_theme_constant_override("outline_size", 6)
	l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	l.custom_minimum_size = Vector2(540, 0)
	l.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_log_box.add_child(l)
	while _log_box.get_child_count() > 6:
		var old: Node = _log_box.get_child(0)
		_log_box.remove_child(old)
		old.queue_free()
	var tw: Tween = create_tween()
	tw.tween_interval(5.0)
	tw.tween_property(l, "modulate:a", 0.0, 1.2)
	tw.tween_callback(l.queue_free)


func _on_fx(kind: String, _d: Dictionary) -> void:
	if kind == "banner":
		_show_banner(String(_d.get("text", "")), Color(1, 0.9, 0.5))


func _on_hover(cell: Vector2i) -> void:
	if game_manager == null:
		return
	var e: Dictionary = game_manager.entity_at(cell)
	if e.is_empty():
		_info_panel.visible = false
		return
	var lines: Array[String] = [String(e["name"])]
	lines.append("PV %d / %d" % [int(e["current_pv"]), int(e["max_pv"])])
	lines.append("PA %d · PM %d · Déf %d" % [int(e["max_pa"]), int(e["max_pm"]), int(e["defense"])])
	for s: Dictionary in e["statuses"]:
		var info: Dictionary = Combat.status_info(String(s["id"]))
		var t: String = "" if int(s["turns"]) > 90 else " (%d t.)" % int(s["turns"])
		lines.append("• %s%s" % [info["label"], t])
	_info_label.text = "\n".join(lines)
	_info_panel.visible = true
	_info_panel.reset_size()


func _on_game_ended(victory: bool) -> void:
	await get_tree().create_timer(1.4).timeout
	if game_manager == null or not game_manager.game_over:
		return
	Sfx.play("win" if victory else "lose")
	_over_title.text = "VICTOIRE !" if victory else "DÉFAITE"
	_over_title.add_theme_color_override("font_color", Color(1, 0.9, 0.35) if victory else Color(1, 0.35, 0.3))
	_over_sub.text = "Combat terminé en %d tours" % int(game_manager.turn_count)
	_over.visible = true
	_over.modulate.a = 0.0
	create_tween().tween_property(_over, "modulate:a", 1.0, 0.5)


func hide_game_over_panel() -> void:
	if _over != null:
		_over.visible = false


func _on_spell_button_selected(spell: Dictionary) -> void:
	spell_selected.emit(spell)


func _on_team_selection_pressed() -> void:
	var gm: Node = get_node_or_null("/root/GameManager")
	if gm and gm.has_method("clear_custom_team"):
		gm.clear_custom_team()
	get_tree().change_scene_to_file("res://scenes/TeamSelection.tscn")


func _unhandled_key_input(event: InputEvent) -> void:
	if game_manager == null or not (event is InputEventKey) or not event.pressed or event.echo:
		return
	var k: int = (event as InputEventKey).keycode
	if k == KEY_SPACE or k == KEY_ENTER or k == KEY_KP_ENTER:
		end_turn_requested.emit()
	elif k == KEY_ESCAPE:
		if game_manager.selected_spell != null:
			game_manager.selected_spell = null
			game_manager.spell_selected.emit(null)
	elif k >= KEY_1 and k <= KEY_9 or k == KEY_0:
		var i: int = (k - KEY_1) if k != KEY_0 else 9
		if i >= 0 and i < _cards.size():
			spell_selected.emit(_cards[i].spell)
