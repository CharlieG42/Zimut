extends CanvasLayer
## CharacterSheetUI.gd — Fiche des personnages : niveau, XP, répartition des points de
## caractéristiques (coût selon l'affinité de la classe), paliers PA/PM, prochain sort.
## Ouverte depuis la sélection d'équipe. Toutes les modifications sont sauvegardées.

signal closed

const COL_PANEL := Color(0.94, 0.89, 0.78, 0.97)
const COL_BORDER := Color(0.72, 0.58, 0.28, 1.0)
const COL_TXT := Color(0.22, 0.15, 0.05)
const COL_SEL := Color(0.98, 0.86, 0.45)
const TIER_COLOR := {"A": Color(0.20, 0.55, 0.20), "B": Color(0.70, 0.50, 0.10), "C": Color(0.65, 0.22, 0.18)}

var _root: Control
var _save: Dictionary = {}
var _slot: int = -1
var _classe: String = "Tank"
var _list_box: VBoxContainer
var _detail_box: VBoxContainer


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


func _build() -> void:
	if _root != null and is_instance_valid(_root):
		_root.queue_free()
	_root = Control.new()
	_root.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(_root)
	var bg := ColorRect.new()
	bg.color = Color(0.06, 0.09, 0.14, 0.96)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	_root.add_child(bg)

	var title := Label.new()
	title.text = "PERSONNAGES — NIVEAUX ET CARACTÉRISTIQUES"
	title.add_theme_font_size_override("font_size", 34)
	title.add_theme_color_override("font_color", Color(1.0, 0.86, 0.4))
	title.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
	title.offset_top = 14.0
	title.offset_bottom = 70.0
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_root.add_child(title)

	var row := HBoxContainer.new()
	row.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	row.offset_left = 40.0
	row.offset_right = -40.0
	row.offset_top = 90.0
	row.offset_bottom = -120.0
	row.add_theme_constant_override("separation", 30)
	_root.add_child(row)

	var left := PanelContainer.new()
	left.custom_minimum_size = Vector2(520, 0)
	left.add_theme_stylebox_override("panel", _flat(COL_PANEL, COL_BORDER, 18, 4))
	row.add_child(left)
	var lscroll := ScrollContainer.new()
	left.add_child(lscroll)
	_list_box = VBoxContainer.new()
	_list_box.add_theme_constant_override("separation", 8)
	_list_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	lscroll.add_child(_list_box)

	var right := PanelContainer.new()
	right.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	right.add_theme_stylebox_override("panel", _flat(COL_PANEL, COL_BORDER, 18, 4))
	row.add_child(right)
	var rscroll := ScrollContainer.new()
	right.add_child(rscroll)
	_detail_box = VBoxContainer.new()
	_detail_box.add_theme_constant_override("separation", 8)
	_detail_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	rscroll.add_child(_detail_box)

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
	close.pressed.connect(func() -> void: closed.emit())
	_root.add_child(close)


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


func _persist() -> void:
	ProgressionManager.write_save(_slot, _save)


func refresh() -> void:
	_refresh_list()
	_refresh_detail()


func _label(text: String, size: int = 20, col: Color = COL_TXT) -> Label:
	var l := Label.new()
	l.text = text
	l.add_theme_font_size_override("font_size", size)
	l.add_theme_color_override("font_color", col)
	return l


func _refresh_list() -> void:
	for c in _list_box.get_children():
		c.queue_free()
	var team: Array[String] = _team_classes()
	for classe: String in ProgressionManager.class_names():
		var ent: Dictionary = ProgressionManager.roster_entry(_save, classe)
		var btn := Button.new()
		var mark: String = "★ " if team.has(classe) else "   "
		var pts: String = "   ✦ +%d" % int(ent.get("unspent", 0)) if int(ent.get("unspent", 0)) > 0 else ""
		btn.text = "%s%s — niv %d%s" % [mark, classe, int(ent.get("level", 1)), pts]
		btn.custom_minimum_size = Vector2(480, 64)
		btn.add_theme_font_size_override("font_size", 24)
		btn.add_theme_color_override("font_color", COL_TXT)
		var selected: bool = classe == _classe
		btn.add_theme_stylebox_override("normal", _flat(COL_SEL if selected else Color(0.97, 0.94, 0.86), COL_BORDER, 12, 3 if selected else 2))
		btn.pressed.connect(func() -> void:
			_classe = classe
			refresh())
		_list_box.add_child(btn)
	var note := _label("★ = dans l'équipe. Les autres classes gagnent %d %% de l'XP." % roundi(ClassRules.BENCH_XP_RATIO * 100.0), 16)
	note.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	note.custom_minimum_size = Vector2(470, 0)
	_list_box.add_child(note)


func _refresh_detail() -> void:
	for c in _detail_box.get_children():
		c.queue_free()
	var ent: Dictionary = ProgressionManager.roster_entry(_save, _classe)
	if ent.is_empty():
		return
	var level: int = int(ent["level"])
	var rules: Dictionary = ClassRules.rules(_classe)
	_detail_box.add_child(_label("%s — niveau %d" % [_classe, level], 34))
	_detail_box.add_child(_label(String(rules.get("role", "")), 18))

	# Barre d'XP
	var cur: int = ProgressionManager.xp_for_level(level)
	var nxt: int = ProgressionManager.xp_for_level(mini(ClassRules.MAX_LEVEL, level + 1))
	var bar := ProgressBar.new()
	bar.custom_minimum_size = Vector2(700, 26)
	bar.min_value = 0.0
	bar.max_value = float(maxi(1, nxt - cur))
	bar.value = float(int(ent["xp"]) - cur) if level < ClassRules.MAX_LEVEL else bar.max_value
	bar.show_percentage = false
	_detail_box.add_child(bar)
	var xp_txt: String = "XP %d / %d" % [int(ent["xp"]), nxt] if level < ClassRules.MAX_LEVEL else "Niveau maximum"
	var ms: Dictionary = ClassRules.milestone_bonus(_classe, level)
	xp_txt += "   ·   Rythme d'XP x%.2f   ·   Bonus : +%d PA, +%d PM" % [ClassRules.xp_mult(_classe), int(ms["pa"]), int(ms["pm"])]
	_detail_box.add_child(_label(xp_txt, 18))
	var ns: Dictionary = ProgressionManager.next_spell(_classe, level)
	if not ns.is_empty():
		_detail_box.add_child(_label("Prochain sort : %s (niveau %d)" % [ns["name"], int(ns["level"])], 18))

	_detail_box.add_child(_label("Capital à répartir : %d" % int(ent["unspent"]), 28,
		Color(0.15, 0.45, 0.15) if int(ent["unspent"]) > 0 else COL_TXT))

	# Tableau des caractéristiques
	var member: Dictionary = _member_for(_classe)
	var st: Dictionary = ProgressionManager.member_stats(_save, member)
	var base: Dictionary = ProgressionManager.class_row(_classe, level)
	var eq: Dictionary = ItemRules.aggregate(member.get("equipment", {}))["stats"]
	for stat: String in ClassRules.STATS:
		var inv_pts: int = int(ent["invested"].get(stat, 0))
		var gain: int = int(ClassRules.STAT_GAIN[stat])
		var base_val: int = int(base.get("vita" if stat == "vita" else stat, 0))
		var tier: String = ClassRules.affinity(_classe, stat)
		var cost: int = ClassRules.point_cost(_classe, stat, inv_pts)
		var line := HBoxContainer.new()
		line.add_theme_constant_override("separation", 12)
		var name_l := _label("%s" % ClassRules.STAT_LABEL[stat], 22)
		name_l.custom_minimum_size = Vector2(150, 0)
		line.add_child(name_l)
		var tier_l := _label("[%s]" % tier, 20, TIER_COLOR[tier])
		tier_l.custom_minimum_size = Vector2(44, 0)
		line.add_child(tier_l)
		var total: int = int(st.get("max_pv", 0)) if stat == "vita" else int(st.get(stat, 0))
		var detail: String = "%d  =  base %d + points %d + objets %d" % [total, base_val, inv_pts * gain, int(eq.get(stat, 0))]
		var val_l := _label(detail, 20)
		val_l.custom_minimum_size = Vector2(430, 0)
		line.add_child(val_l)
		var minus := _small_btn("−")
		minus.disabled = inv_pts <= 0
		minus.pressed.connect(func() -> void:
			ProgressionManager.refund_point(_save, _classe, stat)
			_persist()
			refresh())
		line.add_child(minus)
		var plus := _small_btn("+")
		plus.disabled = int(ent["unspent"]) < cost
		plus.pressed.connect(func() -> void:
			ProgressionManager.invest_point(_save, _classe, stat)
			_persist()
			refresh())
		line.add_child(plus)
		line.add_child(_label("coût %d" % cost, 18))
		_detail_box.add_child(line)
		var help := _label("      " + String(ClassRules.STAT_HELP[stat]), 15, Color(0.45, 0.36, 0.2))
		_detail_box.add_child(help)

	# PA / PM
	_detail_box.add_child(_label("PA %d  ·  PM %d  (palier de classe + objets)" % [int(st.get("pa", 0)), int(st.get("pm", 0))], 20))
	var sets: Array = st.get("sets", [])
	for sline in sets:
		_detail_box.add_child(_label("◈ " + String(sline), 18, Color(0.35, 0.25, 0.6)))
	for l: String in ItemRules.fx_lines(st.get("fx", {})):
		_detail_box.add_child(_label("✦ " + l, 17, Color(0.3, 0.3, 0.55)))

	# ── Sorts : niveaux 1..10 améliorables avec l'or et la Magie ─────────────
	var gold: int = ProgressionManager.gold(_save)
	var magie: int = int(ProgressionManager.resources(_save).get("Magie", 0))
	_detail_box.add_child(_label("SORTS  —  🪙 %d or  ·  Magie %d  (chaque niveau : +%d %% d'efficacité)" % [gold, magie,
		roundi(ProgressionManager.SPELL_LEVEL_BONUS_PCT)], 22, Color(0.5, 0.3, 0.1)))
	var spells: Array = ProgressionManager.spells_of(_classe)
	for s: Dictionary in spells:
		var sname: String = String(s["name"])
		var slvl: int = ProgressionManager.spell_level(_save, _classe, sname)
		var cost: Dictionary = ProgressionManager.spell_upgrade_cost(_save, _classe, sname)
		var line := HBoxContainer.new()
		line.add_theme_constant_override("separation", 12)
		var name_l := _label(sname, 21)
		name_l.custom_minimum_size = Vector2(300, 0)
		line.add_child(name_l)
		var lv_txt: String = "Nv %d / %d" % [slvl, ProgressionManager.SPELL_LEVEL_MAX]
		var lv_l := _label(lv_txt, 20, Color(0.7, 0.5, 0.1) if slvl > 1 else COL_TXT)
		lv_l.custom_minimum_size = Vector2(120, 0)
		line.add_child(lv_l)
		var bonus: int = roundi((ProgressionManager.spell_mult(_save, _classe, sname) - 1.0) * 100.0)
		var bonus_l := _label(("+%d %%" % bonus) if bonus > 0 else "—", 19, Color(0.2, 0.55, 0.2))
		bonus_l.custom_minimum_size = Vector2(80, 0)
		line.add_child(bonus_l)
		var up := _small_btn("AMÉLIORER")
		up.disabled = cost.is_empty() or gold < int(cost["gold"]) or magie < int(cost["magie"])
		if cost.is_empty():
			up.text = "MAX"
		else:
			up.tooltip_text = "Coût : %d or + %d Magie" % [int(cost["gold"]), int(cost["magie"])]
			up.pressed.connect(func() -> void:
				var err: String = ProgressionManager.upgrade_spell(_save, _classe, sname)
				if err == "":
					_persist()
				refresh())
		line.add_child(up)
		if not cost.is_empty():
			line.add_child(_label("🪙%d + Magie %d" % [int(cost["gold"]), int(cost["magie"])], 17, Color(0.45, 0.36, 0.2)))
		_detail_box.add_child(line)

	var btns := HBoxContainer.new()
	btns.add_theme_constant_override("separation", 20)
	var auto_b := Button.new()
	auto_b.text = "RÉPARTITION AUTO"
	auto_b.custom_minimum_size = Vector2(300, 60)
	auto_b.add_theme_font_size_override("font_size", 22)
	auto_b.add_theme_stylebox_override("normal", _flat(Color(0.62, 0.82, 0.55), Color(0.3, 0.5, 0.25), 12, 3))
	auto_b.add_theme_color_override("font_color", COL_TXT)
	auto_b.tooltip_text = "Dépense le capital selon la recette de la classe, y compris aux prochains niveaux."
	auto_b.pressed.connect(func() -> void:
		ProgressionManager.auto_points(_save, _classe)
		_persist()
		refresh())
	btns.add_child(auto_b)
	var reset_b := Button.new()
	reset_b.text = "RÉINITIALISER (gratuit)"
	reset_b.custom_minimum_size = Vector2(340, 60)
	reset_b.add_theme_font_size_override("font_size", 22)
	reset_b.add_theme_stylebox_override("normal", _flat(Color(0.93, 0.72, 0.60), Color(0.6, 0.3, 0.2), 12, 3))
	reset_b.add_theme_color_override("font_color", COL_TXT)
	reset_b.pressed.connect(func() -> void:
		ProgressionManager.reset_points(_save, _classe)
		_persist()
		refresh())
	btns.add_child(reset_b)
	_detail_box.add_child(btns)
	var mode: String = "automatique" if bool(ent.get("auto", true)) else "manuelle"
	_detail_box.add_child(_label("Répartition %s — les points gagnés plus tard sont %s." % [mode,
		"dépensés pour vous" if bool(ent.get("auto", true)) else "à répartir par vous"], 16))


func _small_btn(txt: String) -> Button:
	var b := Button.new()
	b.text = txt
	b.custom_minimum_size = Vector2(60, 48)
	b.add_theme_font_size_override("font_size", 28)
	b.add_theme_color_override("font_color", COL_TXT)
	b.add_theme_stylebox_override("normal", _flat(COL_SEL, COL_BORDER, 10, 2))
	return b


func _flat(bg: Color, border: Color, radius: int = 12, bw: int = 3) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = bg
	s.border_color = border
	s.set_border_width_all(bw)
	s.set_corner_radius_all(radius)
	s.content_margin_left = 10.0
	s.content_margin_right = 10.0
	s.content_margin_top = 6.0
	s.content_margin_bottom = 6.0
	return s
