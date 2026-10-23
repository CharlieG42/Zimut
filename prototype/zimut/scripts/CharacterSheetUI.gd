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
var _gear_pick: String = ""     # emplacement dont on choisit l'objet ("" = vue d'ensemble)
var _gear_msg: String = ""


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


## Libellé multi-lignes : ne force jamais la largeur du panneau.
func _note(text: String, size: int = 16, col: Color = C_DIM) -> Label:
	var l := _lbl(text, size, col)
	l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	l.custom_minimum_size = Vector2(60, 0)
	l.size_flags_horizontal = Control.SIZE_EXPAND_FILL
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
	add_child(_root)
	UiFit.apply(_root, 1.2, Vector2(1600, 900))   # lisible sur smartphone
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
	left.custom_minimum_size = Vector2(340, 0)
	left.add_theme_stylebox_override("panel", _box(C_PANEL, C_BORDER, 18, 2, 12))
	body.add_child(left)
	var lscroll := ScrollContainer.new()
	TouchScroll.install(lscroll)
	lscroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	left.add_child(lscroll)
	_list_box = VBoxContainer.new()
	_list_box.add_theme_constant_override("separation", 8)
	_list_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	lscroll.add_child(_list_box)

	# Panneau principal
	var right := PanelContainer.new()
	right.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	right.custom_minimum_size = Vector2(0, 0)
	right.clip_contents = true
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
	TouchScroll.install(cscroll)
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
	elif _tab == "gear":
		_build_gear()
	elif _tab == "talents":
		_build_talents()
	elif _tab == "builds":
		_build_builds()
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
	var rec_n: int = _gear_total_rec()
	var tpts: int = TalentTree.points(_save, _classe)
	var n_b: int = Builds.build_count(_save, _classe)
	# id, libellé, nom du nœud (tests / tutoriel), poids de largeur
	var defs: Array = [
		["stats", "CARACTÉRISTIQUES" + ("  ✦%d" % pts if pts > 0 else ""), "StatsTab", 3.0],
		["spells", "SORTS", "SpellsTab", 1.6],
		["gear", "ÉQUIPEMENT" + ("  ▲%d" % rec_n if rec_n > 0 else ""), "GearTab", 2.2],
		["talents", "TALENTS" + ("  ★%d" % tpts if tpts > 0 else ""), "TalentsTab", 2.0],
		["builds", "BUILDS" + ("  ×%d" % n_b if n_b > 0 else ""), "BuildsTab", 1.8],
	]
	for d: Array in defs:
		var tab_id: String = String(d[0])
		var b := _btn(String(d[1]), C_GOLD if _tab == tab_id else C_BORDER, 20, Vector2(0, 54))
		b.name = String(d[2])
		b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		b.size_flags_stretch_ratio = float(d[3])
		b.clip_text = true
		b.pressed.connect(func() -> void:
			_tab = tab_id
			if tab_id == "gear":
				_gear_pick = ""
				_gear_msg = ""
			refresh())
		_tabs_row.add_child(b)


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


# ══════════════════════════════════════════════════════════════════════════
#  Onglet TALENTS (V42 : arbre propre au héros, débloqué au niveau 15)
# ══════════════════════════════════════════════════════════════════════════

func _build_talents() -> void:
	var ent: Dictionary = ProgressionManager.roster_entry(_save, _classe)
	var level: int = int(ent.get("level", 1))
	# Verrouillé avant le niveau 15
	if level < TalentTree.UNLOCK_LEVEL:
		var lock := PanelContainer.new()
		lock.add_theme_stylebox_override("panel", _box(C_CARD, C_BORDER, 14, 2, 20))
		_content.add_child(lock)
		var lb := VBoxContainer.new()
		lb.add_theme_constant_override("separation", 10)
		lock.add_child(lb)
		lb.add_child(_lbl("🔒  ARBRE DE TALENTS VERROUILLÉ", 26, C_DIM, true))
		lb.add_child(_lbl("L'arbre de talents de %s se débloque au niveau %d.\nContinuez à faire progresser ce héros !" % [_classe, TalentTree.UNLOCK_LEVEL], 19, C_DIM))
		return
	var pts: int = TalentTree.points(_save, _classe)
	var unlocked_n: int = TalentTree.unlocked_count(_save, _classe)
	# Bandeau points de pouvoir
	var bar := HBoxContainer.new()
	bar.add_theme_constant_override("separation", 14)
	_content.add_child(bar)
	bar.add_child(_chip("★ %d point%s de pouvoir" % [pts, "s" if pts > 1 else ""], C_GOOD if pts > 0 else C_DIM, 24))
	var sp := Control.new()
	sp.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	bar.add_child(sp)
	bar.add_child(_lbl("%d talent%s débloqué%s" % [unlocked_n, "s" if unlocked_n > 1 else "", "s" if unlocked_n > 1 else ""], 18, C_DIM))
	_content.add_child(_note("1 point de pouvoir tous les %d niveaux à partir du niveau %d. Les bonus ne s'appliquent qu'à ce héros." % [TalentTree.POWER_PER_LEVEL, TalentTree.UNLOCK_LEVEL]))
	# Grille 2x2 des branches
	var grid := GridContainer.new()
	grid.columns = 2
	grid.add_theme_constant_override("h_separation", 12)
	grid.add_theme_constant_override("v_separation", 12)
	grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_content.add_child(grid)
	for branch: String in ["offense", "defense", "utility", "power"]:
		grid.add_child(_build_talent_branch(branch, pts))


func _build_talent_branch(branch: String, pts: int) -> PanelContainer:
	var info: Dictionary = TalentTree.BRANCHES[branch]
	var panel := PanelContainer.new()
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	panel.add_theme_stylebox_override("panel", _box(C_PANEL, info["color"], 14, 3, 14))
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 8)
	panel.add_child(box)
	box.add_child(_lbl("%s %s" % [info["icon"], info["label"]], 22, info["color"], true))
	for t: Array in TalentTree.branch_talents(branch):
		box.add_child(_build_talent_node(String(t[0]), String(t[1]), String(t[2]), int(t[3]), info["color"], pts))
	return panel


func _build_talent_node(id: String, name: String, desc: String, cost: int, branch_color: Color, pts: int) -> Control:
	var unlocked: bool = TalentTree.is_unlocked(_save, _classe, id)
	var affordable: bool = pts >= cost and not unlocked
	var card := PanelContainer.new()
	card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	card.custom_minimum_size = Vector2(0, 62)
	var bg_col: Color = C_CARD_HI if unlocked else (C_CARD if affordable else Color(0.08, 0.10, 0.14))
	var border_col: Color = C_GOOD if unlocked else (branch_color if affordable else Color(0.20, 0.22, 0.30))
	card.add_theme_stylebox_override("panel", _box(bg_col, border_col, 10, 2, 10))
	var hbox := HBoxContainer.new()
	hbox.add_theme_constant_override("separation", 10)
	card.add_child(hbox)
	var mark := _lbl("✓" if unlocked else ("★" if affordable else "🔒"), 20,
		C_GOOD if unlocked else (branch_color if affordable else C_DIM))
	mark.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	hbox.add_child(mark)
	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 2)
	vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hbox.add_child(vbox)
	var nl := _lbl(name, 18, C_TXT if unlocked or affordable else C_DIM)
	nl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	nl.custom_minimum_size = Vector2(60, 0)
	vbox.add_child(nl)
	var dl := _lbl(desc, 14, C_DIM)
	dl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	dl.custom_minimum_size = Vector2(60, 0)
	vbox.add_child(dl)
	var cost_lbl := _lbl("★ %d" % cost, 17, C_GOLD if affordable else C_DIM)
	cost_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	cost_lbl.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	hbox.add_child(cost_lbl)
	var btn := Button.new()
	btn.flat = true
	btn.focus_mode = Control.FOCUS_NONE
	btn.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	btn.tooltip_text = desc
	btn.disabled = unlocked or not affordable
	if not unlocked and affordable:
		btn.pressed.connect(func() -> void:
			if TalentTree.spend_point(_save, _classe, id):
				_persist()
				refresh())
	card.add_child(btn)
	return card


# ═══════════════════════════════════════════════════════════════════════════
#  Onglet SORTS
# ═══════════════════════════════════════════════════════════════════════════

func _build_spells() -> void:
	var ent: Dictionary = ProgressionManager.roster_entry(_save, _classe)
	var char_level: int = int(ent["level"])
	var free_pts: int = ProgressionManager.spell_points_free(_save, _classe)
	var total_pts: int = ProgressionManager.spell_points_total(char_level)
	var info := HBoxContainer.new()
	info.add_theme_constant_override("separation", 14)
	_content.add_child(info)
	var intro := _lbl("%d points de sort par niveau. Monter un sort du niveau n au niveau n+1 coûte n points (+%d %% d'efficacité par niveau, maximum %d). Impossible de tout maximiser : choisis tes sorts ! Remise à zéro gratuite." % [
		ClassRules.SPELL_POINTS_PER_LEVEL, roundi(ProgressionManager.SPELL_LEVEL_BONUS_PCT), ProgressionManager.SPELL_LEVEL_MAX], 17, C_DIM)
	intro.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	intro.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	info.add_child(intro)
	info.add_child(_chip("✦ Points de sort %d / %d" % [free_pts, total_pts], Color(0.65, 0.55, 0.95) if free_pts > 0 else C_DIM, 22))
	var auto_b := _btn("RÉPARTITION AUTO", Color(0.40, 0.75, 0.45), 18, Vector2(210, 48))
	auto_b.tooltip_text = "Monte automatiquement les sorts de dégâts et de soin ; les points gagnés plus tard seront aussi répartis."
	auto_b.pressed.connect(func() -> void:
		ProgressionManager.auto_spells(_save, _classe)
		_persist()
		refresh())
	info.add_child(auto_b)
	var rst := _btn("RÉINITIALISER", Color(0.85, 0.55, 0.35), 18, Vector2(190, 48))
	rst.disabled = ProgressionManager.spell_points_spent(_save, _classe) == 0
	rst.pressed.connect(func() -> void:
		ProgressionManager.reset_spells(_save, _classe)
		_persist()
		refresh())
	info.add_child(rst)

	var act_row := HBoxContainer.new()
	act_row.add_theme_constant_override("separation", 12)
	_content.add_child(act_row)
	var act_b := _btn("⚔ CHOISIR LES SORTS ACTIFS  %d/%d" % [Builds.active_spell_count(_save, _classe), Builds.MAX_ACTIVE_SPELLS], Color(0.95, 0.50, 0.40), 18, Vector2(0, 48))
	act_b.tooltip_text = "Choisis les %d sorts emportés en combat (un jeu de sorts par build)." % Builds.MAX_ACTIVE_SPELLS
	act_b.pressed.connect(func() -> void: _open_spell_picker())
	act_row.add_child(act_b)
	var act_hint := _lbl("Tu as %d sorts mais seulement %d places : les ✔ ACTIF partent au combat." % [Builds.unlocked_spell_names(_save, _classe).size(), Builds.MAX_ACTIVE_SPELLS], 16, C_DIM)
	act_hint.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	act_hint.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	act_row.add_child(act_hint)
	_content.add_child(_lbl("Répartition %s — %s" % [
		"automatique" if bool(ent.get("spell_auto", false)) else "manuelle",
		"les points de sort gagnés plus tard sont dépensés pour vous" if bool(ent.get("spell_auto", false)) else "améliorez vous-même vos sorts (ou RÉPARTITION AUTO)"], 16, C_DIM))
	var grid := GridContainer.new()
	grid.columns = 2
	grid.add_theme_constant_override("h_separation", 12)
	grid.add_theme_constant_override("v_separation", 12)
	grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_content.add_child(grid)
	var spells: Array = ProgressionManager.spells_of(_classe).duplicate()
	spells.sort_custom(func(a: Dictionary, b: Dictionary) -> bool: return int(a["level"]) < int(b["level"]))
	for s: Dictionary in spells:
		_spell_card(grid, s, char_level, free_pts)


func _spell_card(parent: Control, s: Dictionary, char_level: int, free_pts: int) -> void:
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
	if not locked and Builds.active_spells(_save, _classe).has(sname):
		sub = "✔ ACTIF  ·  " + sub
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
	var need: int = int(cost["points"])
	var ok_pts: bool = free_pts >= need
	foot.add_child(_chip("✦ %d point%s" % [need, "s" if need > 1 else ""], C_GOOD if ok_pts else C_BAD, 18))
	var sp := Control.new()
	sp.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	foot.add_child(sp)
	if slvl > 1:
		var dn := _btn("−", Color(0.85, 0.55, 0.35), 22, Vector2(56, 48))
		dn.tooltip_text = "Retirer un niveau (points rendus)"
		dn.pressed.connect(func() -> void:
			ProgressionManager.downgrade_spell(_save, _classe, sname)
			_persist()
			refresh())
		foot.add_child(dn)
	var up := _btn("AMÉLIORER", Color(0.45, 0.80, 0.50), 20, Vector2(190, 48))
	up.disabled = not ok_pts
	if not ok_pts:
		up.tooltip_text = "Il manque des points de sort"
	up.pressed.connect(func() -> void:
		var err: String = ProgressionManager.upgrade_spell(_save, _classe, sname)
		if err == "":
			_persist()
		refresh())
	foot.add_child(up)


# ═══════════════════════════════════════════════════════════════════════════
#  Onglet ÉQUIPEMENT
# ═══════════════════════════════════════════════════════════════════════════

func _gear_governor_line() -> String:
	var conq: Dictionary = _save.get("conquest", {})
	var id: String = ConquestSystem.hero_city(conq, _classe)
	if id != "" and (conq.get("owned", []) as Array).has(id):
		return "♞ Gouverneur de %s : son équipement donne +%d défense et +%d or par victoire à la ville." % [
			ProgressionManager.conquest_city_name(id),
			ConquestSystem.governor_gear_defense(_save, _classe), ConquestSystem.governor_gear_gold(_save, _classe)]
	return ""


func _build_gear() -> void:
	if _gear_pick != "":
		_build_gear_picker(_gear_pick)
		return
	var eq: Dictionary = ProgressionManager.hero_equipment(_save, _classe)
	var agg: Dictionary = ItemRules.aggregate(eq)
	var sum_parts: PackedStringArray = []
	for k: String in ItemRules.STAT_KEYS:
		var v: int = int(agg["stats"].get(k, 0))
		if v != 0:
			sum_parts.append("%s %+d" % [String(ItemRules.STAT_SHORT[k]), v])
	var info := _lbl("Bonus d'équipement : %s" % (" · ".join(sum_parts) if not sum_parts.is_empty() else "aucun"), 19, C_GOOD if not sum_parts.is_empty() else C_DIM)
	info.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_content.add_child(info)
	for line: String in agg["sets"]:
		_content.add_child(_lbl("◈ " + line, 16, C_GOLD))
	var gov: String = _gear_governor_line()
	if gov != "":
		var gl := _lbl(gov, 17, Color(0.78, 0.62, 1.0))
		gl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		_content.add_child(gl)
	elif not _team_classes().has(_classe):
		var nl := _lbl("Ce héros n'est pas dans l'équipe : son équipement est conservé et compte s'il devient gouverneur.", 16, C_DIM)
		nl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		_content.add_child(nl)
	if _gear_msg != "":
		_content.add_child(_lbl(_gear_msg, 18, C_BAD))
	var grid := GridContainer.new()
	grid.columns = 2
	grid.add_theme_constant_override("h_separation", 10)
	grid.add_theme_constant_override("v_separation", 10)
	grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_content.add_child(grid)
	for slot: String in GearUi.SLOT_ORDER:
		grid.add_child(_gear_slot_card(slot, eq))


## Objets libres de l'inventaire pour un emplacement : "rec" = conseillés (niveau
## suffisant et plus puissants que le porté), "other" = les autres.
func _gear_options(slot: String) -> Dictionary:
	var level: int = ProgressionManager.member_level(_save, _classe)
	var cur: Dictionary = ProgressionManager.hero_equipment(_save, _classe).get(slot, {})
	var cur_power: int = ItemRules.power(cur) if not cur.is_empty() else 0
	var rec: int = 0
	var other: int = 0
	for it: Variant in _save.get("inventory", []):
		if it is Dictionary and GearUi.slot_of(it) == slot:
			if int(it.get("level", 1)) <= level and ItemRules.power(it) > cur_power:
				rec += 1
			else:
				other += 1
	return {"rec": rec, "other": other}


func _gear_total_rec() -> int:
	var n: int = 0
	for slot: String in GearUi.SLOT_ORDER:
		n += int(_gear_options(slot)["rec"])
	return n


func _gear_slot_card(slot: String, eq: Dictionary) -> Control:
	var it: Dictionary = eq.get(slot, {})
	var card := PanelContainer.new()
	card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var edge: Color = ItemRules.rarity_color(it) if not it.is_empty() else C_BORDER
	card.add_theme_stylebox_override("panel", _box(C_CARD, edge, 14, 2, 10))
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 10)
	card.add_child(row)
	row.add_child(GearUi.tile(slot, 60.0))
	var mid := VBoxContainer.new()
	mid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	mid.add_theme_constant_override("separation", 2)
	row.add_child(mid)
	mid.add_child(_lbl(GearUi.slot_label(slot).to_upper(), 14, C_DIM))
	if it.is_empty():
		mid.add_child(_lbl("— vide —", 19, C_DIM))
	else:
		var nm := _lbl(ItemRules.display_name(it), 19, ItemRules.rarity_color(it).lightened(0.3))
		nm.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		mid.add_child(nm)
		mid.add_child(_lbl("niv. %d · %s" % [int(it.get("level", 0)), ItemRules.stat_line(it)], 15, C_TXT))
	var opt: Dictionary = _gear_options(slot)
	if int(opt["rec"]) > 0 or int(opt["other"]) > 0:
		var parts: PackedStringArray = []
		if int(opt["rec"]) > 0:
			parts.append("▲ %d conseillé%s" % [int(opt["rec"]), "s" if int(opt["rec"]) > 1 else ""])
		if int(opt["other"]) > 0:
			parts.append("%d autre%s" % [int(opt["other"]), "s" if int(opt["other"]) > 1 else ""])
		var bl := _lbl(" · ".join(parts), 15, C_GOOD if int(opt["rec"]) > 0 else C_DIM, int(opt["rec"]) > 0)
		bl.name = "GearAvail_" + slot
		mid.add_child(bl)
	var btns := VBoxContainer.new()
	btns.add_theme_constant_override("separation", 6)
	row.add_child(btns)
	var b := _btn("CHANGER" if not it.is_empty() else "ÉQUIPER", C_GOLD, 17, Vector2(120, 44))
	b.name = "GearPick_" + slot
	b.pressed.connect(func() -> void:
		_gear_pick = slot
		_gear_msg = ""
		refresh())
	btns.add_child(b)
	if not it.is_empty():
		var r := _btn("RETIRER", C_BAD, 15, Vector2(120, 38))
		r.name = "GearRemove_" + slot
		r.pressed.connect(func() -> void:
			_gear_msg = ProgressionManager.unequip_hero_item(_save, _classe, slot)
			_persist()
			refresh())
		btns.add_child(r)
	return card


## Liste des objets libres de l'inventaire compatibles avec un emplacement.
func _build_gear_picker(slot: String) -> void:
	var back := _btn("←  RETOUR À L'ÉQUIPEMENT", C_BORDER, 19, Vector2(0, 48))
	back.pressed.connect(func() -> void:
		_gear_pick = ""
		refresh())
	_content.add_child(back)
	_content.add_child(_lbl("Choisir : %s" % GearUi.slot_label(slot), 24, C_GOLD, true))
	if _gear_msg != "":
		_content.add_child(_lbl(_gear_msg, 18, C_BAD))
	var level: int = ProgressionManager.member_level(_save, _classe)
	var cur: Dictionary = ProgressionManager.hero_equipment(_save, _classe).get(slot, {})
	var cur_power: int = ItemRules.power(cur) if not cur.is_empty() else 0
	var rows: Array = []
	var inv: Array = _save.get("inventory", [])
	for i: int in range(inv.size()):
		if GearUi.slot_of(inv[i]) == slot:
			rows.append({"i": i, "it": inv[i]})
	rows.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
		var ra: bool = int(a["it"].get("level", 1)) <= level and ItemRules.power(a["it"]) > cur_power
		var rb: bool = int(b["it"].get("level", 1)) <= level and ItemRules.power(b["it"]) > cur_power
		if ra != rb:
			return ra
		return ItemRules.power(a["it"]) > ItemRules.power(b["it"]))
	if rows.is_empty():
		var e := _lbl("Aucun objet libre de ce type dans l'inventaire.", 19, C_DIM)
		_content.add_child(e)
		return
	var last_sec: String = ""
	for row: Dictionary in rows:
		var it: Dictionary = row["it"]
		var too_low: bool = int(it.get("level", 1)) > level
		var delta: int = ItemRules.power(it) - cur_power
		var sec: String = "rec" if (not too_low and delta > 0) else "other"
		if sec != last_sec:
			last_sec = sec
			_content.add_child(_lbl("▲ CONSEILLÉS" if sec == "rec" else "AUTRES OBJETS", 17, C_GOOD if sec == "rec" else C_DIM, true))
		var b := Button.new()
		b.custom_minimum_size = Vector2(0, 84)
		b.focus_mode = Control.FOCUS_NONE
		b.alignment = HORIZONTAL_ALIGNMENT_LEFT
		b.text = "%s\n%s" % [GearUi.item_text(it).split("\n")[0], ("Niveau %d requis" % int(it.get("level", 1))) if too_low else GearUi.item_text(it).split("\n")[1]]
		b.add_theme_font_size_override("font_size", 19)
		var col: Color = ItemRules.rarity_color(it).lightened(0.3)
		for st_name in ["font_color", "font_hover_color", "font_pressed_color"]:
			b.add_theme_color_override(st_name, C_BAD if too_low else col)
		var sbx: StyleBoxFlat = _box(C_CARD, ItemRules.rarity_color(it).darkened(0.2), 12, 2, 10)
		sbx.content_margin_right = 130
		b.add_theme_stylebox_override("normal", sbx)
		b.add_theme_stylebox_override("hover", _box(C_CARD_HI, ItemRules.rarity_color(it), 12, 3, 10))
		b.add_theme_stylebox_override("pressed", sbx)
		var dl := _lbl(("%+d" % delta) if not too_low else "—", 24, C_GOOD if delta > 0 else (C_BAD if delta < 0 else C_DIM), true)
		dl.set_anchors_and_offsets_preset(Control.PRESET_CENTER_RIGHT)
		dl.offset_left = -100
		dl.offset_right = -14
		dl.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		dl.mouse_filter = Control.MOUSE_FILTER_IGNORE
		b.add_child(dl)
		var idx: int = int(row["i"])
		b.pressed.connect(func() -> void:
			var err: String = ProgressionManager.equip_hero_item(_save, _classe, idx)
			if err != "":
				_gear_msg = err
			else:
				_gear_msg = ""
				_gear_pick = ""
				_persist()
			refresh())
		_content.add_child(b)


# ═══════════════════════════════════════════════════════════════════════════
#  Onglet BUILDS (V42) — 3 builds par personnage : équipement + sorts + talents
# ═══════════════════════════════════════════════════════════════════════════

func _build_builds() -> void:
	var ent: Dictionary = ProgressionManager.roster_entry(_save, _classe)
	var level: int = int(ent.get("level", 1))
	var ai: int = Builds.active_index(_save, _classe)
	# Bandeau : build actif + bouton créer
	var bar := HBoxContainer.new()
	bar.add_theme_constant_override("separation", 14)
	_content.add_child(bar)
	var active_txt: String = "Équipement libre"
	if ai >= 0:
		active_txt = "⭐ %s" % Builds.display_name(_save, _classe, ai)
	bar.add_child(_chip("Build actif : %s" % active_txt, C_GOLD if ai >= 0 else C_DIM, 20))
	var sp := Control.new()
	sp.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	bar.add_child(sp)
	var n_builds: int = Builds.build_count(_save, _classe)
	if n_builds < Builds.MAX_BUILDS:
		var mk := _btn("+ NOUVEAU BUILD", Color(0.45, 0.80, 0.50), 19, Vector2(210, 48))
		mk.tooltip_text = "Crée un build vide (équipement, sorts et talents à définir)"
		mk.pressed.connect(func() -> void:
			var idx: int = Builds.create_build(_save, _classe)
			if idx >= 0:
				_persist()
			refresh())
		bar.add_child(mk)
	_content.add_child(_note("%d build%s — chaque build regroupe un équipement complet, %d sorts actifs maximum et son propre arbre de talents. Les niveaux de sorts restent ceux du héros." % [
		n_builds, "s" if n_builds > 1 else "", Builds.MAX_ACTIVE_SPELLS]))
	# Liste des builds + état libre
	var list := VBoxContainer.new()
	list.add_theme_constant_override("separation", 10)
	_content.add_child(list)
	# Carte « équipement libre » (index -1)
	list.add_child(_build_slot_card(-1, ai == -1, level))
	for i: int in range(n_builds):
		list.add_child(_build_slot_card(i, ai == i, level))


func _build_slot_card(index: int, is_active: bool, level: int) -> PanelContainer:
	var card := PanelContainer.new()
	card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var edge: Color = C_GOLD if is_active else C_BORDER
	card.add_theme_stylebox_override("panel", _box(C_CARD_HI if is_active else C_CARD, edge, 14, 3 if is_active else 2, 12))
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 6)
	card.add_child(v)
	# Ligne 1 : nom + badge actif + boutons
	var h := HBoxContainer.new()
	h.add_theme_constant_override("separation", 10)
	v.add_child(h)
	var name: String = Builds.display_name(_save, _classe, index)
	if index >= 0:
		h.add_child(_lbl(name, 22, C_GOLD if is_active else C_TXT, true))
	else:
		h.add_child(_lbl("✦ %s" % name, 22, C_TXT, true))
	if is_active:
		h.add_child(_chip("ACTIF", C_GOOD, 16))
	var sp := Control.new()
	sp.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	h.add_child(sp)
	# Boutons d'action
	var btns := HBoxContainer.new()
	btns.add_theme_constant_override("separation", 8)
	h.add_child(btns)
	if index >= 0:
		var ren := _btn("✎", C_BORDER, 18, Vector2(48, 44))
		ren.tooltip_text = "Renommer ce build"
		ren.pressed.connect(func() -> void: _prompt_rename(index))
		btns.add_child(ren)
	if not is_active:
		var act := _btn("ACTIVER", Color(0.45, 0.80, 0.50), 17, Vector2(140, 44))
		act.pressed.connect(func() -> void:
			Builds.activate(_save, _classe, index, Builds.active_index(_save, _classe))
			_persist()
			refresh())
		btns.add_child(act)
	else:
		var des := _btn("DÉSACTIVER", Color(0.85, 0.55, 0.35), 17, Vector2(150, 44))
		des.tooltip_text = "Quitte le build actif (l'équipement reste en place)"
		des.pressed.connect(func() -> void:
			Builds.deactivate(_save, _classe)
			_persist()
			refresh())
		btns.add_child(des)
	if index >= 0:
		var del := _btn("✕", C_BAD, 18, Vector2(48, 44))
		del.tooltip_text = "Supprimer ce build"
		del.pressed.connect(func() -> void:
			Builds.delete_build(_save, _classe, index)
			_persist()
			refresh())
		btns.add_child(del)
	# Ligne 2 : résumé du contenu
	if index < 0:
		var eq: Dictionary = ProgressionManager.hero_equipment(_save, _classe)
		var spells: Array = Builds.active_spells(_save, _classe)
		var tpts: int = TalentTree.points(_save, _classe)
		var tn: int = TalentTree.unlocked_count(_save, _classe)
		v.add_child(_note("%d objet%s · %d/%d sorts · %d talent%s (%d pts)" % [
			Builds.build_gear_count(eq), "s" if Builds.build_gear_count(eq) > 1 else "",
			spells.size(), Builds.MAX_ACTIVE_SPELLS,
			tn, "s" if tn > 1 else "", tpts]))
		var free_b := _btn("⚔ SORTS ACTIFS", Color(0.95, 0.50, 0.40), 16, Vector2(190, 42))
		free_b.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
		free_b.pressed.connect(func() -> void: _open_spell_picker())
		v.add_child(free_b)
		return card
	var b: Dictionary = Builds.build_at(_save, _classe, index)
	var eq2: Dictionary = b.get("equipment", {})
	var spells2: Array = b.get("spells", [])
	var tal2: Dictionary = b.get("talents", {"unlocked": {}, "points": 0})
	v.add_child(_note("%d objet%s · %d/%d sorts · %d talent%s (%d pts)" % [
		Builds.build_gear_count(eq2), "s" if Builds.build_gear_count(eq2) > 1 else "",
		spells2.size(), Builds.MAX_ACTIVE_SPELLS,
		Builds.build_talent_count(tal2), "s" if Builds.build_talent_count(tal2) > 1 else "", int(tal2.get("points", 0))]))
	# Ligne 3 : édition (équipement / sorts / talents) — uniquement build actif
	if is_active:
		var edit := HBoxContainer.new()
		edit.add_theme_constant_override("separation", 8)
		v.add_child(edit)
		var e1 := _btn("🛡 ÉQUIPEMENT", Color(0.55, 0.65, 0.95), 16, Vector2(190, 42))
		e1.pressed.connect(func() -> void:
			_tab = "gear"
			_gear_pick = ""
			_gear_msg = ""
			refresh())
		edit.add_child(e1)
		var e2 := _btn("⚔ SORTS ACTIFS", Color(0.95, 0.50, 0.40), 16, Vector2(190, 42))
		e2.pressed.connect(func() -> void: _open_spell_picker())
		edit.add_child(e2)
		var e3 := _btn("★ TALENTS", Color(0.85, 0.45, 0.95), 16, Vector2(170, 42))
		e3.pressed.connect(func() -> void:
			_tab = "talents"
			refresh())
		edit.add_child(e3)
		if level >= TalentTree.UNLOCK_LEVEL:
			var save := _btn("💾 ENREGISTRER DANS CE BUILD", Color(0.45, 0.80, 0.50), 16, Vector2(300, 42))
			save.tooltip_text = "Copie l'équipement, les sorts actifs et les talents actuels DANS ce build"
			save.pressed.connect(func() -> void:
				Builds.set_build_equipment(_save, _classe, index, ProgressionManager.hero_equipment(_save, _classe))
				Builds.set_active_spells_in_build(_save, _classe, index, Builds.active_spells(_save, _classe))
				Builds.set_build_talents(_save, _classe, index, _roster_talents())
				_persist()
				refresh())
			edit.add_child(save)
	return card


## Boîte de dialogue de renommage (simple : ligne éditable + OK).
func _prompt_rename(index: int) -> void:
	var dlg := AcceptDialog.new()
	dlg.title = "Renommer le build"
	dlg.initial_position = Window.WINDOW_INITIAL_POSITION_CENTER_MAIN_WINDOW_SCREEN
	var le := LineEdit.new()
	le.text = Builds.display_name(_save, _classe, index)
	le.custom_minimum_size = Vector2(420, 0)
	le.select_all()
	dlg.add_child(le)
	dlg.confirmed.connect(func() -> void:
		Builds.rename_build(_save, _classe, index, le.text)
		_persist()
		refresh())
	add_child(dlg)
	dlg.popup_centered()
	le.grab_focus()


## Talents actuels du roster (référence persistée).
func _roster_talents() -> Dictionary:
	var ent: Dictionary = ProgressionManager.roster_entry(_save, _classe)
	if not ent.has("talents"):
		ent["talents"] = {"unlocked": {}, "points": TalentTree.power_for_level(int(ent.get("level", 1)))}
	return ent["talents"]


## ── Sélecteur de sorts actifs (popup) ──

func _open_spell_picker() -> void:
	var dlg := Window.new()
	dlg.title = "Sorts actifs — %s" % _classe
	dlg.initial_position = Window.WINDOW_INITIAL_POSITION_CENTER_MAIN_WINDOW_SCREEN
	dlg.size = Vector2i(900, 700)
	dlg.close_requested.connect(func() -> void:
		dlg.queue_free()
		refresh())
	add_child(dlg)
	var pad := MarginContainer.new()
	pad.set_anchors_preset(Control.PRESET_FULL_RECT)
	for side in ["left", "right"]:
		pad.add_theme_constant_override("margin_" + side, 24)
	pad.add_theme_constant_override("margin_top", 18)
	pad.add_theme_constant_override("margin_bottom", 18)
	dlg.add_child(pad)
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 10)
	pad.add_child(v)
	v.add_child(_lbl("Choisis jusqu'à %d sorts actifs. Les niveaux de sort sont ceux du héros (onglet SORTS)." % Builds.MAX_ACTIVE_SPELLS, 17, C_DIM))
	var counter := _lbl("", 20, C_GOLD)
	v.add_child(counter)
	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	TouchScroll.install(scroll)
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	v.add_child(scroll)
	var grid := GridContainer.new()
	grid.columns = 2
	grid.add_theme_constant_override("h_separation", 10)
	grid.add_theme_constant_override("v_separation", 10)
	grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(grid)
	var rebuild: Callable
	rebuild = func() -> void:
		counter.text = "%d / %d sorts actifs" % [Builds.active_spell_count(_save, _classe), Builds.MAX_ACTIVE_SPELLS]
		for c in grid.get_children():
			c.queue_free()
		var cur: Array = Builds.active_spells(_save, _classe)
		for sname: String in Builds.unlocked_spell_names(_save, _classe):
			grid.add_child(_spell_pick_card(sname, cur.has(sname), rebuild))
	rebuild.call()
	dlg.popup_centered()


## Carte d'un sort dans le sélecteur de sorts actifs (clic = toggle).
func _spell_pick_card(sname: String, on: bool, rebuild: Callable) -> PanelContainer:
	var pv: Dictionary = ProgressionManager.spell_preview(_classe, sname, ProgressionManager.spell_level(_save, _classe, sname))
	var card := PanelContainer.new()
	card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var kcol: Color = KIND_COLOR.get(String(pv.get("kind", "attack")), KIND_COLOR["attack"])
	card.add_theme_stylebox_override("panel", _box(C_CARD_HI if on else C_CARD, C_GOOD if on else kcol.darkened(0.2), 12, 2, 10))
	var cv := VBoxContainer.new()
	cv.add_theme_constant_override("separation", 2)
	card.add_child(cv)
	var ch := HBoxContainer.new()
	ch.add_theme_constant_override("separation", 8)
	cv.add_child(ch)
	ch.add_child(_lbl("✓" if on else "○", 20, C_GOOD if on else C_DIM))
	var pname := _lbl(sname, 19, C_TXT)
	pname.clip_text = true
	pname.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	ch.add_child(pname)
	var sp2 := Control.new()
	sp2.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	ch.add_child(sp2)
	ch.add_child(_lbl("PA %d" % int(pv.get("pa", 1)), 15, C_DIM))
	if int(pv.get("pm", 0)) > 0:
		ch.add_child(_lbl("PM %d" % int(pv["pm"]), 15, C_DIM))
	var pdesc := _lbl(String(pv.get("desc", "")), 14, C_DIM)
	pdesc.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	pdesc.custom_minimum_size = Vector2(0, 0)
	pdesc.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	cv.add_child(pdesc)
	var btn := Button.new()
	btn.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	btn.focus_mode = Control.FOCUS_NONE
	btn.mouse_filter = Control.MOUSE_FILTER_STOP
	btn.pressed.connect(func() -> void:
		Builds.toggle_spell(_save, _classe, sname)
		_persist()
		rebuild.call())
	card.add_child(btn)
	return card
