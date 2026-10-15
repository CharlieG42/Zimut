extends CanvasLayer
## CharacterSheetUI.gd — Fiche des personnages (refonte V4).
##
## Colonne de gauche : les 8 classes (portrait, niveau, XP, points à dépenser).
## Panneau principal : en-tête (portrait, rôle, XP, PV/PA/PM) puis deux onglets :
##   • CARACTÉRISTIQUES : 6 cartes avec barre de composition (base / points / objets),
##     coût du prochain point, boutons − / +, répartition auto, réinitialisation.
##   • SORTS : une carte par sort (pastilles PA / PM / Portée, description, valeur
##     actuelle → prochain niveau, 10 crans de niveau, coût d'amélioration).
## API inchangée : open(save, slot, classe) et signal closed.

signal closed

const C_BG := Color(0.05, 0.07, 0.12, 1.0)
const C_PANEL := Color(0.09, 0.11, 0.17, 0.98)
const C_CARD := Color(0.12, 0.15, 0.23, 1.0)
const C_CARD_HI := Color(0.17, 0.21, 0.31, 1.0)
const C_BORDER := Color(0.30, 0.36, 0.50, 1.0)
const C_GOLD := Color(1.00, 0.82, 0.35)
const C_TXT := Color(0.95, 0.94, 0.90)
const C_DIM := Color(0.62, 0.66, 0.76)
const C_GOOD := Color(0.45, 0.88, 0.50)
const C_BAD := Color(1.00, 0.45, 0.40)
const TIER_COLOR := {"A": Color(0.45, 0.88, 0.50), "B": Color(0.98, 0.78, 0.30), "C": Color(1.00, 0.50, 0.42)}
const STAT_COLOR := {
	"vita": Color(0.35, 0.85, 0.45), "force": Color(0.95, 0.50, 0.35), "intelligence": Color(0.45, 0.65, 1.00),
	"agility": Color(0.95, 0.85, 0.35), "wisdom": Color(0.75, 0.55, 0.95), "defense": Color(0.60, 0.75, 0.85),
}
const STAT_ICON := {"vita": "❤", "force": "⚔", "intelligence": "✦", "agility": "➶", "wisdom": "☯", "defense": "⛨"}
const KIND_COLOR := {"attack": Color(0.95, 0.42, 0.38), "heal": Color(0.40, 0.82, 0.48), "buff": Color(0.42, 0.62, 0.98),
	"debuff": Color(0.98, 0.82, 0.30), "summon": Color(0.78, 0.55, 0.95), "trap": Color(0.9, 0.6, 0.3)}

var _root: Control
var _save: Dictionary = {}
var _slot: int = -1
var _classe: String = "Tank"
var _tab: String = "stats"
var _list_box: VBoxContainer
var _head_box: HBoxContainer
var _tabs_row: HBoxContainer
var _content: VBoxContainer
var _res_label: Label


## Barre de composition d'une caractéristique : base | points investis | objets.
class StatBar extends Control:
	var base: float = 0.0
	var pts: float = 0.0
	var eq: float = 0.0
	var cap: float = 100.0
	var col: Color = Color.WHITE
	func _draw() -> void:
		var w: float = size.x
		var h: float = size.y
		draw_rect(Rect2(0, 0, w, h), Color(0.03, 0.04, 0.08, 1.0))
		var x: float = 0.0
		for seg in [[base, col.darkened(0.45)], [pts, col], [eq, Color(0.55, 0.95, 0.60)]]:
			var sw: float = clampf(float(seg[0]) / cap, 0.0, 1.0) * w
			sw = minf(sw, w - x)
			if sw > 0.5:
				draw_rect(Rect2(x, 0, sw, h), seg[1])
				draw_rect(Rect2(x, 0, sw, h * 0.4), Color(1, 1, 1, 0.12))
			x += sw
		draw_rect(Rect2(0, 0, w, h), C_BORDER, false, 2.0)


func open(save_data: Dictionary, slot: int, start_class: String = "") -> void:
	_save = save_data
	_slot = slot
	var names: Array[String] = ProgressionManager.class_names()
	if start_class != "" and names.has(start_class):
		_classe = start_class
	elif not names.is_empty():
		_classe = names[0]
	_build()
	refresh()


# ═══════════════════════════════════════════════════════════════════════════
#  Helpers de construction
# ═══════════════════════════════════════════════════════════════════════════

static func _box(bg: Color, border: Color, radius: int = 14, bw: int = 2, margin: int = 12) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = bg
	s.border_color = border
	s.set_border_width_all(bw)
	s.set_corner_radius_all(radius)
	s.content_margin_left = margin
	s.content_margin_right = margin
	s.content_margin_top = margin * 0.7
	s.content_margin_bottom = margin * 0.7
	return s


func _lbl(text: String, size: int = 20, col: Color = C_TXT, outline: bool = false) -> Label:
	var l := Label.new()
	l.text = text
	l.add_theme_font_size_override("font_size", size)
	l.add_theme_color_override("font_color", col)
	if outline:
		l.add_theme_constant_override("outline_size", 5)
		l.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.85))
	return l


func _chip(text: String, col: Color, size: int = 17) -> PanelContainer:
	var p := PanelContainer.new()
	p.add_theme_stylebox_override("panel", _box(col.darkened(0.55), col, 10, 2, 8))
	var l := _lbl(text, size, col.lightened(0.45))
	p.add_child(l)
	return p


## Pastille ronde (PA / PM / Portée) : valeur en gros + légende dessous.
func _orb(val: String, caption: String, col: Color, d: float = 46.0) -> Control:
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 0)
	var c := PanelContainer.new()
	c.custom_minimum_size = Vector2(d, d)
	var sb := _box(col, col.lightened(0.45), int(d * 0.5), 3, 0)
	sb.content_margin_top = 0
	sb.content_margin_bottom = 0
	c.add_theme_stylebox_override("panel", sb)
	var l := _lbl(val, int(d * 0.5), Color.WHITE, true)
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	c.add_child(l)
	box.add_child(c)
	var cap := _lbl(caption, 12, col.lightened(0.5))
	cap.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	box.add_child(cap)
	return box


func _btn(text: String, col: Color, size: int = 22, min_size: Vector2 = Vector2(0, 56)) -> Button:
	var b := Button.new()
	b.text = text
	b.custom_minimum_size = min_size
	b.add_theme_font_size_override("font_size", size)
	b.add_theme_color_override("font_color", C_TXT)
	b.add_theme_color_override("font_hover_color", Color.WHITE)
	b.add_theme_color_override("font_disabled_color", Color(0.45, 0.48, 0.56))
	b.add_theme_stylebox_override("normal", _box(col.darkened(0.35), col, 12, 2, 12))
	b.add_theme_stylebox_override("hover", _box(col.darkened(0.15), col.lightened(0.3), 12, 3, 12))
	b.add_theme_stylebox_override("pressed", _box(col.darkened(0.5), col.lightened(0.3), 12, 3, 12))
	b.add_theme_stylebox_override("disabled", _box(Color(0.13, 0.15, 0.2), Color(0.25, 0.28, 0.36), 12, 2, 12))
	b.focus_mode = Control.FOCUS_NONE
	return b


func _portrait(classe: String, px: float) -> Control:
	var tr := TextureRect.new()
	tr.custom_minimum_size = Vector2(px, px)
	tr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	tr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	var tex: Texture2D = Portraits.get_texture({"classe": classe, "team": "player", "entity_type": "Player"})
	if tex != null:
		var at := AtlasTexture.new()
		at.atlas = tex
		at.region = Portraits.head_region(tex)
		tr.texture = at
	return tr


static func _style_bar(bar: ProgressBar, fill: Color) -> void:
	var bg := StyleBoxFlat.new()
	bg.bg_color = Color(0.03, 0.04, 0.08)
	bg.set_corner_radius_all(6)
	bg.border_color = C_BORDER
	bg.set_border_width_all(1)
	var fl := StyleBoxFlat.new()
	fl.bg_color = fill
	fl.set_corner_radius_all(6)
	bar.add_theme_stylebox_override("background", bg)
	bar.add_theme_stylebox_override("fill", fl)


func _persist() -> void:
	ProgressionManager.write_save(_slot, _save)


func _team_classes() -> Array[String]:
	var out: Array[String] = []
	for m: Dictionary in _save.get("team", []):
		out.append(String(m.get("classe", "")))
	return out


func _member_for(classe: String) -> Dictionary:
	for m: Dictionary in _save.get("team", []):
		if String(m.get("classe", "")) == classe:
			return m
	return {"classe": classe, "equipment": {}}


# ═══════════════════════════════════════════════════════════════════════════
#  Structure
# ═══════════════════════════════════════════════════════════════════════════

func _build() -> void:
	if _root != null and is_instance_valid(_root):
		_root.queue_free()
	_root = Control.new()
	_root.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(_root)
	var bg := ColorRect.new()
	bg.color = C_BG
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	_root.add_child(bg)
	var glow := ColorRect.new()
	glow.color = Color(0.20, 0.28, 0.48, 0.18)
	glow.set_anchors_preset(Control.PRESET_TOP_WIDE)
	glow.offset_bottom = 120
	_root.add_child(glow)

	var margin := MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	for side in ["left", "right"]:
		margin.add_theme_constant_override("margin_" + side, 36)
	margin.add_theme_constant_override("margin_top", 22)
	margin.add_theme_constant_override("margin_bottom", 26)
	_root.add_child(margin)
	var page := VBoxContainer.new()
	page.add_theme_constant_override("separation", 16)
	margin.add_child(page)

	# Barre du haut : titre, ressources, fermer
	var top := HBoxContainer.new()
	top.add_theme_constant_override("separation", 20)
	page.add_child(top)
	top.add_child(_lbl("PERSONNAGES", 38, C_GOLD, true))
	var sp := Control.new()
	sp.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top.add_child(sp)
	_res_label = _lbl("", 24, C_TXT)
	top.add_child(_res_label)
	var close := _btn("✕  FERMER", Color(0.95, 0.75, 0.30), 24, Vector2(200, 56))
	close.pressed.connect(func() -> void: closed.emit())
	top.add_child(close)

	var body := HBoxContainer.new()
	body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body.add_theme_constant_override("separation", 22)
	page.add_child(body)

	# Colonne des classes
	var left := PanelContainer.new()
	left.custom_minimum_size = Vector2(360, 0)
	left.add_theme_stylebox_override("panel", _box(C_PANEL, C_BORDER, 18, 2, 12))
	body.add_child(left)
	var lscroll := ScrollContainer.new()
	lscroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	left.add_child(lscroll)
	_list_box = VBoxContainer.new()
	_list_box.add_theme_constant_override("separation", 8)
	_list_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	lscroll.add_child(_list_box)

	# Panneau principal
	var right := PanelContainer.new()
	right.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	right.add_theme_stylebox_override("panel", _box(C_PANEL, C_BORDER, 18, 2, 18))
	body.add_child(right)
	var rbox := VBoxContainer.new()
	rbox.add_theme_constant_override("separation", 12)
	right.add_child(rbox)
	_head_box = HBoxContainer.new()
	_head_box.add_theme_constant_override("separation", 18)
	rbox.add_child(_head_box)
	_tabs_row = HBoxContainer.new()
	_tabs_row.add_theme_constant_override("separation", 10)
	rbox.add_child(_tabs_row)
	var cscroll := ScrollContainer.new()
	cscroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	cscroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	rbox.add_child(cscroll)
	_content = VBoxContainer.new()
	_content.add_theme_constant_override("separation", 10)
	_content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	cscroll.add_child(_content)


func refresh() -> void:
	_refresh_resources()
	_refresh_list()
	_refresh_head()
	_refresh_tabs()
	for c in _content.get_children():
		c.queue_free()
	if _tab == "stats":
		_build_stats()
	else:
		_build_spells()


func _refresh_resources() -> void:
	var res: Dictionary = ProgressionManager.resources(_save)
	_res_label.text = "🪙 %d    ✦ Magie %d" % [ProgressionManager.gold(_save), int(res.get("Magie", 0))]


func _refresh_list() -> void:
	for c in _list_box.get_children():
		c.queue_free()
	var team: Array[String] = _team_classes()
	for classe: String in ProgressionManager.class_names():
		var ent: Dictionary = ProgressionManager.roster_entry(_save, classe)
		var level: int = int(ent.get("level", 1))
		var selected: bool = classe == _classe
		var accent: Color = GameManager.COLORS.get(classe, C_GOLD)
		var btn := Button.new()
		btn.custom_minimum_size = Vector2(0, 84)
		btn.focus_mode = Control.FOCUS_NONE
		btn.add_theme_stylebox_override("normal", _box(C_CARD_HI if selected else C_CARD, accent if selected else C_BORDER, 14, 3 if selected else 2, 10))
		btn.add_theme_stylebox_override("hover", _box(C_CARD_HI, accent.lightened(0.2), 14, 3, 10))
		btn.add_theme_stylebox_override("pressed", _box(C_CARD_HI, accent, 14, 3, 10))
		btn.pressed.connect(func() -> void:
			_classe = classe
			refresh())
		_list_box.add_child(btn)
		var row := HBoxContainer.new()
		row.mouse_filter = Control.MOUSE_FILTER_IGNORE
		row.add_theme_constant_override("separation", 12)
		row.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		row.offset_left = 10
		row.offset_right = -10
		row.offset_top = 6
		row.offset_bottom = -6
		btn.add_child(row)
		var pic := _portrait(classe, 64.0)
		pic.mouse_filter = Control.MOUSE_FILTER_IGNORE
		row.add_child(pic)
		var col := VBoxContainer.new()
		col.mouse_filter = Control.MOUSE_FILTER_IGNORE
		col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		col.alignment = BoxContainer.ALIGNMENT_CENTER
		row.add_child(col)
		var name_l := _lbl(("★ " if team.has(classe) else "") + classe, 24, C_GOLD if team.has(classe) else C_TXT)
		name_l.mouse_filter = Control.MOUSE_FILTER_IGNORE
		col.add_child(name_l)
		var cur: int = ProgressionManager.xp_for_level(level)
		var nxt: int = ProgressionManager.xp_for_level(mini(ClassRules.MAX_LEVEL, level + 1))
		var xb := ProgressBar.new()
		xb.custom_minimum_size = Vector2(0, 10)
		xb.show_percentage = false
		xb.max_value = float(maxi(1, nxt - cur))
		xb.value = float(int(ent.get("xp", 0)) - cur) if level < ClassRules.MAX_LEVEL else xb.max_value
		xb.mouse_filter = Control.MOUSE_FILTER_IGNORE
		_style_bar(xb, accent)
		col.add_child(xb)
		var right_col := VBoxContainer.new()
		right_col.mouse_filter = Control.MOUSE_FILTER_IGNORE
		right_col.alignment = BoxContainer.ALIGNMENT_CENTER
		row.add_child(right_col)
		var lv := _lbl("Niv %d" % level, 24, C_TXT)
		lv.mouse_filter = Control.MOUSE_FILTER_IGNORE
		lv.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		right_col.add_child(lv)
		if int(ent.get("unspent", 0)) > 0:
			var pts := _lbl("✦ +%d" % int(ent["unspent"]), 18, C_GOOD)
			pts.mouse_filter = Control.MOUSE_FILTER_IGNORE
			pts.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
			right_col.add_child(pts)
	var note := _lbl("★ = dans l'équipe · les autres classes gagnent %d %% de l'XP" % roundi(ClassRules.BENCH_XP_RATIO * 100.0), 15, C_DIM)
	note.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	note.custom_minimum_size = Vector2(320, 0)
	_list_box.add_child(note)


func _refresh_head() -> void:
	for c in _head_box.get_children():
		c.queue_free()
	var ent: Dictionary = ProgressionManager.roster_entry(_save, _classe)
	if ent.is_empty():
		return
	var level: int = int(ent["level"])
	var accent: Color = GameManager.COLORS.get(_classe, C_GOLD)
	var member: Dictionary = _member_for(_classe)
	var st: Dictionary = ProgressionManager.member_stats(_save, member)
	var pic_panel := PanelContainer.new()
	pic_panel.add_theme_stylebox_override("panel", _box(accent.darkened(0.6), accent, 16, 3, 6))
	pic_panel.add_child(_portrait(_classe, 110.0))
	_head_box.add_child(pic_panel)
	var mid := VBoxContainer.new()
	mid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	mid.add_theme_constant_override("separation", 4)
	_head_box.add_child(mid)
	var title := HBoxContainer.new()
	title.add_theme_constant_override("separation", 14)
	mid.add_child(title)
	title.add_child(_lbl(_classe, 40, C_TXT, true))
	title.add_child(_chip("NIVEAU %d" % level, accent, 22))
	if _team_classes().has(_classe):
		title.add_child(_chip("★ DANS L'ÉQUIPE", C_GOLD, 16))
	mid.add_child(_lbl(String(ClassRules.rules(_classe).get("role", "")), 18, C_DIM))
	var cur: int = ProgressionManager.xp_for_level(level)
	var nxt: int = ProgressionManager.xp_for_level(mini(ClassRules.MAX_LEVEL, level + 1))
	var bar := ProgressBar.new()
	bar.custom_minimum_size = Vector2(0, 22)
	bar.show_percentage = false
	bar.max_value = float(maxi(1, nxt - cur))
	bar.value = float(int(ent["xp"]) - cur) if level < ClassRules.MAX_LEVEL else bar.max_value
	_style_bar(bar, accent.lightened(0.15))
	mid.add_child(bar)
	var xp_txt: String = "XP %d / %d" % [int(ent["xp"]), nxt] if level < ClassRules.MAX_LEVEL else "Niveau maximum"
	var ns: Dictionary = ProgressionManager.next_spell(_classe, level)
	if not ns.is_empty():
		xp_txt += "   ·   prochain sort : %s (niv. %d)" % [ns["name"], int(ns["level"])]
	mid.add_child(_lbl(xp_txt, 17, C_DIM))
	# Pastilles PV / PA / PM
	var orbs := HBoxContainer.new()
	orbs.add_theme_constant_override("separation", 12)
	_head_box.add_child(orbs)
	if not st.is_empty():
		orbs.add_child(_orb(str(int(st["max_pv"])), "PV", Color(0.30, 0.72, 0.38), 62.0))
		orbs.add_child(_orb(str(int(st["pa"])), "PA", Color(0.16, 0.50, 0.95), 62.0))
		orbs.add_child(_orb(str(int(st["pm"])), "PM", Color(0.14, 0.64, 0.32), 62.0))


func _refresh_tabs() -> void:
	for c in _tabs_row.get_children():
		c.queue_free()
	var ent: Dictionary = ProgressionManager.roster_entry(_save, _classe)
	var pts: int = int(ent.get("unspent", 0))
	var b1 := _btn("CARACTÉRISTIQUES" + ("  ✦%d" % pts if pts > 0 else ""), C_GOLD if _tab == "stats" else C_BORDER, 22, Vector2(300, 54))
	b1.pressed.connect(func() -> void:
		_tab = "stats"
		refresh())
	_tabs_row.add_child(b1)
	var b2 := _btn("SORTS", C_GOLD if _tab == "spells" else C_BORDER, 22, Vector2(200, 54))
	b2.pressed.connect(func() -> void:
		_tab = "spells"
		refresh())
	_tabs_row.add_child(b2)


# ═══════════════════════════════════════════════════════════════════════════
#  Onglet CARACTÉRISTIQUES
# ═══════════════════════════════════════════════════════════════════════════

func _build_stats() -> void:
	var ent: Dictionary = ProgressionManager.roster_entry(_save, _classe)
	var level: int = int(ent["level"])
	var member: Dictionary = _member_for(_classe)
	var st: Dictionary = ProgressionManager.member_stats(_save, member)
	var base: Dictionary = ProgressionManager.class_row(_classe, level)
	var eq: Dictionary = ItemRules.aggregate(member.get("equipment", {}))["stats"]

	# Bandeau capital + actions
	var bar := HBoxContainer.new()
	bar.add_theme_constant_override("separation", 14)
	_content.add_child(bar)
	var unspent: int = int(ent["unspent"])
	bar.add_child(_chip("✦ %d point(s) à répartir" % unspent if unspent > 0 else "Aucun point à répartir",
		C_GOOD if unspent > 0 else C_DIM, 24))
	var sp := Control.new()
	sp.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	bar.add_child(sp)
	var auto_b := _btn("RÉPARTITION AUTO", Color(0.45, 0.80, 0.50), 20, Vector2(270, 52))
	auto_b.tooltip_text = "Dépense le capital selon la recette de la classe, y compris aux prochains niveaux."
	auto_b.pressed.connect(func() -> void:
		ProgressionManager.auto_points(_save, _classe)
		_persist()
		refresh())
	bar.add_child(auto_b)
	var reset_b := _btn("RÉINITIALISER", Color(0.95, 0.60, 0.40), 20, Vector2(230, 52))
	reset_b.tooltip_text = "Rend tous les points investis (gratuit). Les prochains points seront à répartir à la main."
	reset_b.pressed.connect(func() -> void:
		ProgressionManager.reset_points(_save, _classe)
		_persist()
		refresh())
	bar.add_child(reset_b)
	var mode: String = "automatique" if bool(ent.get("auto", true)) else "manuelle"
	_content.add_child(_lbl("Répartition %s — les points gagnés plus tard sont %s." % [mode,
		"dépensés pour vous" if bool(ent.get("auto", true)) else "à répartir par vous"], 16, C_DIM))

	# Cartes de caractéristiques (2 colonnes)
	var grid := GridContainer.new()
	grid.columns = 2
	grid.add_theme_constant_override("h_separation", 12)
	grid.add_theme_constant_override("v_separation", 12)
	grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_content.add_child(grid)
	for stat: String in ClassRules.STATS:
		var inv_pts: int = int(ent["invested"].get(stat, 0))
		var gain: int = int(ClassRules.STAT_GAIN[stat])
		var base_val: int = int(base.get("vita" if stat == "vita" else stat, 0))
		var eq_val: int = int(eq.get(stat, 0))
		var tier: String = ClassRules.affinity(_classe, stat)
		var cost: int = ClassRules.point_cost(_classe, stat, inv_pts)
		var col: Color = STAT_COLOR[stat]
		var total: int = int(st.get("max_pv", 0)) if stat == "vita" else int(st.get(stat, 0))

		var card := PanelContainer.new()
		card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		card.add_theme_stylebox_override("panel", _box(C_CARD, col.darkened(0.3), 14, 2, 14))
		grid.add_child(card)
		var v := VBoxContainer.new()
		v.add_theme_constant_override("separation", 6)
		card.add_child(v)
		var h1 := HBoxContainer.new()
		h1.add_theme_constant_override("separation", 10)
		v.add_child(h1)
		h1.add_child(_lbl("%s %s" % [STAT_ICON[stat], ClassRules.STAT_LABEL[stat]], 26, col, true))
		var tier_chip := _chip("Affinité %s" % tier, TIER_COLOR[tier], 15)
		tier_chip.tooltip_text = "A : 1 point de capital par point (jusqu'à 40), puis 2, puis 3.\nB : 2 puis 3.   C : 3."
		h1.add_child(tier_chip)
		var sp1 := Control.new()
		sp1.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		h1.add_child(sp1)
		h1.add_child(_lbl(str(total), 36, C_GOLD, true))
		var sbar := StatBar.new()
		sbar.custom_minimum_size = Vector2(0, 16)
		sbar.col = col
		sbar.cap = 320.0 if stat == "vita" else 140.0
		sbar.base = float(base_val)
		sbar.pts = float(inv_pts * gain)
		sbar.eq = float(eq_val)
		v.add_child(sbar)
		var h2 := HBoxContainer.new()
		h2.add_theme_constant_override("separation", 8)
		v.add_child(h2)
		var det := _lbl("base %d  +  points %d  +  objets %d" % [base_val, inv_pts * gain, eq_val], 17, C_DIM)
		det.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		h2.add_child(det)
		var minus := _btn("−", Color(0.85, 0.5, 0.4), 30, Vector2(54, 48))
		minus.disabled = inv_pts <= 0
		minus.pressed.connect(func() -> void:
			ProgressionManager.refund_point(_save, _classe, stat)
			_persist()
			refresh())
		h2.add_child(minus)
		var plus := _btn("+", Color(0.45, 0.80, 0.50), 30, Vector2(54, 48))
		plus.disabled = unspent < cost
		plus.pressed.connect(func() -> void:
			ProgressionManager.invest_point(_save, _classe, stat)
			_persist()
			refresh())
		h2.add_child(plus)
		var cost_l := _lbl("coût %d" % cost, 17, C_GOOD if unspent >= cost else C_BAD)
		cost_l.custom_minimum_size = Vector2(66, 0)
		h2.add_child(cost_l)
		v.add_child(_lbl(String(ClassRules.STAT_HELP[stat]), 15, C_DIM))

	# Cartes bonus PA / PM / Portée : 3 niveaux max, 4 points par niveau
	for stat: String in ClassRules.BONUS_STATS:
		var inv_pts: int = int(ent["invested"].get(stat, 0))
		var cost: int = ClassRules.BONUS_POINT_COST
		var col: Color = Color(0.45, 0.80, 0.92)
		var fx_val: int = int(ItemRules.aggregate(member.get("equipment", {}))["fx"].get(stat, 0))
		var eq_val: int = int(fx_val)
		var base_val: int = 0 if stat == "po" else int(base.get(stat, 0))
		var pts_val: int = inv_pts
		var total: int = base_val + pts_val + eq_val
		if stat == "pa":
			total = int(st.get("pa", 0))
		elif stat == "pm":
			total = int(st.get("pm", 0))
		elif stat == "po":
			total = int(st.get("po", 0))

		var card := PanelContainer.new()
		card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		card.add_theme_stylebox_override("panel", _box(C_CARD, col.darkened(0.3), 14, 2, 14))
		grid.add_child(card)
		var v := VBoxContainer.new()
		v.add_theme_constant_override("separation", 6)
		card.add_child(v)
		var h1 := HBoxContainer.new()
		h1.add_theme_constant_override("separation", 10)
		v.add_child(h1)
		h1.add_child(_lbl("%s %s" % ["\u2794" if stat == "po" else ("\u26a1" if stat == "pa" else "\u27b6"), ClassRules.BONUS_STAT_LABEL[stat]], 26, col, true))
		var tier_chip := _chip("Max %d niveaux" % ClassRules.BONUS_MAX_LEVELS, Color(0.55, 0.75, 0.95), 15)
		tier_chip.tooltip_text = "Chaque niveau coûte %d points de capital." % ClassRules.BONUS_POINT_COST
		h1.add_child(tier_chip)
		var sp1 := Control.new()
		sp1.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		h1.add_child(sp1)
		var cap: int = ClassRules.PA_CAP if stat == "pa" else (ClassRules.PM_CAP if stat == "pm" else ClassRules.PO_CAP)
		h1.add_child(_lbl("%d / %d" % [total, cap], 26, C_GOLD, true))
		var sbar := StatBar.new()
		sbar.custom_minimum_size = Vector2(0, 16)
		sbar.col = col
		sbar.cap = float(cap)
		sbar.base = float(base_val)
		sbar.pts = float(pts_val)
		sbar.eq = float(eq_val)
		v.add_child(sbar)
		var h2 := HBoxContainer.new()
		h2.add_theme_constant_override("separation", 8)
		v.add_child(h2)
		var det := _lbl("base %d  +  niveaux %d/%d  +  objets %d" % [base_val, inv_pts, ClassRules.BONUS_MAX_LEVELS, eq_val], 17, C_DIM)
		det.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		h2.add_child(det)
		var minus := _btn("\u2212", Color(0.85, 0.5, 0.4), 30, Vector2(54, 48))
		minus.disabled = inv_pts <= 0
		minus.pressed.connect(func() -> void:
			ProgressionManager.refund_point(_save, _classe, stat)
			_persist()
			refresh())
		h2.add_child(minus)
		var plus := _btn("+", Color(0.45, 0.80, 0.50), 30, Vector2(54, 48))
		plus.disabled = unspent < cost or inv_pts >= ClassRules.BONUS_MAX_LEVELS or (stat != "po" and total >= cap)
		plus.pressed.connect(func() -> void:
			ProgressionManager.invest_point(_save, _classe, stat)
			_persist()
			refresh())
		h2.add_child(plus)
		var cost_l := _lbl("coût %d" % cost, 17, C_GOOD if unspent >= cost else C_BAD)
		cost_l.custom_minimum_size = Vector2(66, 0)
		h2.add_child(cost_l)
		v.add_child(_lbl(String(ClassRules.BONUS_STAT_HELP[stat]), 15, C_DIM))

	var legend := HBoxContainer.new()
	legend.add_theme_constant_override("separation", 18)
	legend.add_child(_lbl("■ base de classe", 15, STAT_COLOR["vita"].darkened(0.45).lightened(0.2)))
	legend.add_child(_lbl("■ points investis", 15, STAT_COLOR["vita"]))
	legend.add_child(_lbl("■ objets et panoplies", 15, Color(0.55, 0.95, 0.60)))
	_content.add_child(legend)
	var extras: Array[String] = []
	for sline in st.get("sets", []):
		extras.append("◈ " + String(sline))
	for l: String in ItemRules.fx_lines(st.get("fx", {})):
		extras.append("✦ " + l)
	if not extras.is_empty():
		var fl := HFlowContainer.new()
		fl.add_theme_constant_override("h_separation", 8)
		fl.add_theme_constant_override("v_separation", 8)
		for e in extras:
			fl.add_child(_chip(e, Color(0.65, 0.55, 0.95), 16))
		_content.add_child(fl)


# ═══════════════════════════════════════════════════════════════════════════
#  Onglet SORTS
# ═══════════════════════════════════════════════════════════════════════════

func _build_spells() -> void:
	var ent: Dictionary = ProgressionManager.roster_entry(_save, _classe)
	var char_level: int = int(ent["level"])
	var gold: int = ProgressionManager.gold(_save)
	var magie: int = int(ProgressionManager.resources(_save).get("Magie", 0))
	var info := HBoxContainer.new()
	info.add_theme_constant_override("separation", 14)
	_content.add_child(info)
	var intro := _lbl("Chaque niveau de sort apporte +%d %% d'efficacité (niveau 1 à %d). Coût : or + Magie, de plus en plus élevé." % [
		roundi(ProgressionManager.SPELL_LEVEL_BONUS_PCT), ProgressionManager.SPELL_LEVEL_MAX], 17, C_DIM)
	intro.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	intro.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	info.add_child(intro)
	info.add_child(_chip("🪙 %d" % gold, C_GOLD, 22))
	info.add_child(_chip("✦ Magie %d" % magie, Color(0.65, 0.55, 0.95), 22))

	var grid := GridContainer.new()
	grid.columns = 2
	grid.add_theme_constant_override("h_separation", 12)
	grid.add_theme_constant_override("v_separation", 12)
	grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_content.add_child(grid)
	for s: Dictionary in ProgressionManager.spells_of(_classe):
		_spell_card(grid, s, char_level, gold, magie)


func _spell_card(parent: Control, s: Dictionary, char_level: int, gold: int, magie: int) -> void:
	var sname: String = String(s["name"])
	var slvl: int = ProgressionManager.spell_level(_save, _classe, sname)
	var locked: bool = int(s["level"]) > char_level
	var pv: Dictionary = ProgressionManager.spell_preview(_classe, sname, slvl)
	var nxt: Dictionary = ProgressionManager.spell_preview(_classe, sname, mini(slvl + 1, ProgressionManager.SPELL_LEVEL_MAX))
	var kind: String = String(pv.get("kind", "attack"))
	if String(pv.get("type", "")) == "Debuff":
		kind = "debuff"
	var col: Color = KIND_COLOR.get(kind, KIND_COLOR["attack"])
	if locked:
		col = Color(0.4, 0.43, 0.5)
	var card := PanelContainer.new()
	card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	card.add_theme_stylebox_override("panel", _box(C_CARD if not locked else Color(0.09, 0.10, 0.14), col.darkened(0.2), 14, 2, 14))
	parent.add_child(card)
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 8)
	card.add_child(v)

	# Ligne 1 : nom + pastilles PA / PM / Portée
	var h := HBoxContainer.new()
	h.add_theme_constant_override("separation", 10)
	v.add_child(h)
	var ico_tex: Texture2D = SpellIcons.texture_for(sname)
	if ico_tex != null:
		var ico := TextureRect.new()
		ico.texture = ico_tex
		ico.custom_minimum_size = Vector2(60, 60)
		ico.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		ico.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		ico.tooltip_text = sname
		if locked:
			ico.modulate = Color(0.5, 0.5, 0.56)
		h.add_child(ico)
	var name_box := VBoxContainer.new()
	name_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	h.add_child(name_box)
	name_box.add_child(_lbl(sname, 24, C_TXT if not locked else C_DIM, true))
	var sub: String = String(pv.get("type", ""))
	if String(pv.get("aoe", "")) == "zone":
		sub += "  ·  zone %d" % int(pv["zone"])
	elif String(pv.get("aoe", "")) == "team":
		sub += "  ·  toute l'équipe"
	elif String(pv.get("aoe", "")) == "adjacent_enemies":
		sub += "  ·  ennemis adjacents"
	if bool(pv.get("los", false)):
		sub += "  ·  ligne de vue"
	name_box.add_child(_lbl(sub, 15, col.lightened(0.35)))
	h.add_child(_orb(str(int(pv.get("pa", 1))), "PA", Color(0.16, 0.50, 0.95), 44.0))
	if int(pv.get("pm", 0)) > 0:
		h.add_child(_orb(str(int(pv["pm"])), "PM", Color(0.14, 0.64, 0.32), 44.0))
	var rng_txt: String = "Soi" if String(pv.get("target", "")) == "self" else (str(int(pv.get("range", 1))) if int(pv.get("range", 1)) < 99 else "∞")
	h.add_child(_orb(rng_txt, "Portée", Color(0.86, 0.66, 0.16), 44.0))

	# Description
	var desc := _lbl(String(pv.get("desc", "")), 17, C_TXT if not locked else C_DIM)
	desc.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	desc.custom_minimum_size = Vector2(0, 44)
	v.add_child(desc)

	if locked:
		v.add_child(_chip("🔒 Débloqué au niveau %d" % int(s["level"]), Color(0.6, 0.62, 0.7), 18))
		return

	# Valeur actuelle -> prochain niveau
	if int(pv.get("base_value", 0)) > 0:
		var txt: String = "%s : %d" % [pv["label"], int(pv["value"])]
		var maxed: bool = slvl >= ProgressionManager.SPELL_LEVEL_MAX
		if not maxed:
			txt += "   →   %d au niveau %d" % [int(nxt["value"]), slvl + 1]
		v.add_child(_lbl(txt, 19, C_GOOD))
	elif slvl > 1:
		v.add_child(_lbl("Efficacité : +%d %%" % roundi((float(pv["mult"]) - 1.0) * 100.0), 19, C_GOOD))

	# 10 crans de niveau
	var pips := HBoxContainer.new()
	pips.add_theme_constant_override("separation", 4)
	v.add_child(pips)
	for i: int in range(ProgressionManager.SPELL_LEVEL_MAX):
		var pip := ColorRect.new()
		pip.custom_minimum_size = Vector2(26, 12)
		pip.color = col if i < slvl else Color(0.18, 0.2, 0.28)
		pips.add_child(pip)
	var lvl_l := _lbl("  Niv %d / %d" % [slvl, ProgressionManager.SPELL_LEVEL_MAX], 18, C_GOLD if slvl > 1 else C_TXT)
	pips.add_child(lvl_l)

	# Coût + bouton
	var cost: Dictionary = ProgressionManager.spell_upgrade_cost(_save, _classe, sname)
	var foot := HBoxContainer.new()
	foot.add_theme_constant_override("separation", 10)
	v.add_child(foot)
	if cost.is_empty():
		var mx := _chip("★ NIVEAU MAXIMUM", C_GOLD, 18)
		foot.add_child(mx)
		return
	var ok_gold: bool = gold >= int(cost["gold"])
	var ok_mag: bool = magie >= int(cost["magie"])
	foot.add_child(_chip("🪙 %d" % int(cost["gold"]), C_GOOD if ok_gold else C_BAD, 18))
	foot.add_child(_chip("✦ Magie %d" % int(cost["magie"]), C_GOOD if ok_mag else C_BAD, 18))
	var sp := Control.new()
	sp.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	foot.add_child(sp)
	var up := _btn("AMÉLIORER", Color(0.45, 0.80, 0.50), 20, Vector2(190, 48))
	up.disabled = not (ok_gold and ok_mag)
	if not ok_gold or not ok_mag:
		up.tooltip_text = "Il manque %s" % ("de l'or" if not ok_gold else "de la Magie")
	up.pressed.connect(func() -> void:
		var err: String = ProgressionManager.upgrade_spell(_save, _classe, sname)
		if err == "":
			_persist()
		refresh())
	foot.add_child(up)
