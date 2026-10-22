extends CanvasLayer
## TrophyUI.gd — Succès et Bestiaire d'une partie (V18), ouverts depuis « Mes Parties ».

signal closed

const U = preload("res://scripts/UiKit.gd")

var _save: Dictionary = {}
var _tab: String = "succes"
var _root: Control
var _body: VBoxContainer
var _tabs: HBoxContainer


func open(save_data: Dictionary, tab: String = "succes") -> void:
	_save = save_data
	_tab = tab
	_build()
	refresh()


func _build() -> void:
	var bg := ColorRect.new()
	bg.color = Color(0.05, 0.06, 0.10, 0.98)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	bg.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(bg)
	_root = Control.new()
	add_child(_root)
	UiFit.apply(_root, 1.1, Vector2(1300, 760))
	var margin := MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	for side in ["left", "right"]:
		margin.add_theme_constant_override("margin_" + side, 24)
	margin.add_theme_constant_override("margin_top", 16)
	margin.add_theme_constant_override("margin_bottom", 16)
	_root.add_child(margin)
	var page := VBoxContainer.new()
	page.add_theme_constant_override("separation", 12)
	margin.add_child(page)
	var top := HBoxContainer.new()
	top.add_theme_constant_override("separation", 14)
	page.add_child(top)
	var title := U.lbl("TROPHÉES", 36, Color(1.0, 0.80, 0.38), true)
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top.add_child(title)
	var close := U.btn("✕  FERMER", Color(0.95, 0.75, 0.30), 22, Vector2(170, 54))
	close.pressed.connect(func() -> void: closed.emit())
	top.add_child(close)
	_tabs = HBoxContainer.new()
	_tabs.add_theme_constant_override("separation", 10)
	page.add_child(_tabs)
	var panel := PanelContainer.new()
	panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	panel.add_theme_stylebox_override("panel", U.box(Color(0.08, 0.10, 0.16, 0.95), Color(0.62, 0.50, 0.26), 16, 3, 12))
	page.add_child(panel)
	var scroll := ScrollContainer.new()
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	TouchScroll.install(scroll)
	panel.add_child(scroll)
	_body = VBoxContainer.new()
	_body.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_body.add_theme_constant_override("separation", 10)
	scroll.add_child(_body)


func refresh() -> void:
	for c in _tabs.get_children():
		c.queue_free()
	for c in _body.get_children():
		c.queue_free()
	var n_ach: int = (_save.get("achievements", {}) as Dictionary).size()
	var n_best: int = (_save.get("bestiary", {}) as Dictionary).size()
	for t: Array in [["succes", "🏆  Succès  %d / %d" % [n_ach, Achievements.LIST.size()]], ["bestiaire", "📖  Bestiaire  (%d)" % n_best]]:
		var key: String = String(t[0])
		var b := U.btn(String(t[1]), Color(0.95, 0.65, 0.30) if _tab == key else U.C_BORDER, 22, Vector2(0, 56))
		b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		b.pressed.connect(func() -> void:
			_tab = key
			refresh())
		_tabs.add_child(b)
	if _tab == "succes":
		_build_achievements()
	else:
		_build_bestiary()


func _build_achievements() -> void:
	var grid := GridContainer.new()
	grid.columns = 2
	grid.add_theme_constant_override("h_separation", 10)
	grid.add_theme_constant_override("v_separation", 10)
	grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_body.add_child(grid)
	for a: Array in Achievements.LIST:
		var id: String = String(a[0])
		var done: bool = Achievements.is_unlocked(_save, id)
		var cur: int = mini(Achievements.stat(_save, String(a[3])), int(a[4]))
		var card := PanelContainer.new()
		card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		card.add_theme_stylebox_override("panel", U.box(Color(0.20, 0.15, 0.06) if done else Color(0.11, 0.13, 0.20),
			Color(1.0, 0.82, 0.35) if done else U.C_BORDER, 14, 3 if done else 2, 12))
		grid.add_child(card)
		var h := HBoxContainer.new()
		h.add_theme_constant_override("separation", 12)
		card.add_child(h)
		var ic := U.lbl("🏆" if done else "🔒", 38, Color(1.0, 0.85, 0.4) if done else U.C_DIM)
		ic.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		h.add_child(ic)
		var v := VBoxContainer.new()
		v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		v.add_theme_constant_override("separation", 3)
		h.add_child(v)
		v.add_child(U.lbl(String(a[1]), 22, Color(1.0, 0.88, 0.5) if done else U.C_TXT, true))
		var d := U.lbl(String(a[2]), 17, U.C_DIM)
		d.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		v.add_child(d)
		var bar := ProgressBar.new()
		bar.custom_minimum_size = Vector2(0, 12)
		bar.show_percentage = false
		bar.max_value = float(a[4])
		bar.value = float(cur)
		U.style_bar(bar, Color(1.0, 0.78, 0.30) if done else Color(0.45, 0.70, 1.0))
		v.add_child(bar)
		v.add_child(U.lbl(("✓ Obtenu le %s — " % String(_save["achievements"][id]) if done else "%d / %d — " % [cur, int(a[4])]) + "Récompense : " + Achievements.reward_text(a[5]), 16,
			U.C_GOOD if done else U.C_DIM))

	# V42 : records de vitesse (contre-la-montre sous forme de succès)
	var best_t: int = Achievements.stat(_save, "best_turns")
	var best_b: int = Achievements.stat(_save, "boss_turns")
	if best_t > 0 or best_b > 0:
		var rec := U.lbl("⏱ Records : %s · Boss : %s" % [
			("%d tours" % best_t) if best_t > 0 else "—",
			("%d tours" % best_b) if best_b > 0 else "—"], 18, Color(1.0, 0.85, 0.45))
		_body.add_child(rec)


func _build_bestiary() -> void:


func _build_bestiary() -> void:
	var b: Dictionary = _save.get("bestiary", {})
	if b.is_empty():
		var e := U.lbl("Aucun ennemi rencontré pour l'instant : lancez un combat !", 22, U.C_DIM)
		_body.add_child(e)
		return
	_body.add_child(U.lbl("Ennemis rencontrés dans cette partie. Appui long sur un ennemi en combat : sa zone de menace.", 17, U.C_DIM))
	var grid := GridContainer.new()
	grid.columns = 3
	grid.add_theme_constant_override("h_separation", 10)
	grid.add_theme_constant_override("v_separation", 10)
	grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_body.add_child(grid)
	var names: Array = b.keys()
	names.sort_custom(func(x: String, y: String) -> bool:
		if String(b[x].get("nation", "")) != String(b[y].get("nation", "")):
			return String(b[x].get("nation", "")) < String(b[y].get("nation", ""))
		return x < y)
	for nm: String in names:
		var f: Dictionary = b[nm]
		var card := PanelContainer.new()
		card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		var boss: bool = bool(f.get("boss", false))
		card.add_theme_stylebox_override("panel", U.box(Color(0.11, 0.13, 0.20), Color(0.95, 0.40, 0.35) if boss else U.C_BORDER, 14, 2, 10))
		grid.add_child(card)
		var h := HBoxContainer.new()
		h.add_theme_constant_override("separation", 10)
		card.add_child(h)
		var pic := TextureRect.new()
		var sp: String = String(f.get("sprite", ""))
		pic.texture = load(sp) as Texture2D if sp != "" and ResourceLoader.exists(sp) else null
		pic.custom_minimum_size = Vector2(96, 96)
		pic.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		pic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		h.add_child(pic)
		var v := VBoxContainer.new()
		v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		v.add_theme_constant_override("separation", 2)
		h.add_child(v)
		v.add_child(U.lbl(("☠ " if boss else "") + nm, 21, Color(1.0, 0.6, 0.5) if boss else U.C_TXT, true))
		v.add_child(U.lbl("%s · niveau max %d" % [ProgressionManager.biome_label(String(f.get("nation", ""))), int(f.get("level", 0))], 15, U.C_DIM))
		v.add_child(U.lbl("PV %d · Attaque %d · Déf %d · PM %d" % [int(f.get("pv", 0)), int(f.get("atk", 0)), int(f.get("defense", 0)), int(f.get("pm", 0))], 15, U.C_TXT))
		var spl := U.lbl("Sorts : %s" % String(f.get("spells", "")), 14, Color(0.80, 0.70, 1.0))
		spl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		v.add_child(spl)
		v.add_child(U.lbl("Rencontré %d fois · vaincu %d fois" % [int(f.get("seen", 0)), int(f.get("killed", 0))], 14, U.C_GOOD))
