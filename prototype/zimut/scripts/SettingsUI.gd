extends CanvasLayer

## SettingsUI.gd — Réglages des combats et de la progression XP.
## Les choix sont persistés par l'autoload GameSettings.

const COL_PANEL := Color(0.94, 0.89, 0.78, 0.97)
const COL_BORDER := Color(0.72, 0.58, 0.28, 1.0)
const COL_TXT := Color(0.22, 0.15, 0.05)

func _ready() -> void:
	var root := Control.new()
	add_child(root)
	UiFit.apply(root, 1.0, Vector2(1300, 980))

	var bg := ColorRect.new()
	bg.color = Color(0.06, 0.09, 0.14, 0.95)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	root.add_child(bg)

	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root.add_child(center)

	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(1240, 0)
	panel.add_theme_stylebox_override("panel", _flat(COL_PANEL, COL_BORDER, 18, 5))
	center.add_child(panel)

	var pad := MarginContainer.new()
	for side in ["left", "right", "top", "bottom"]:
		pad.add_theme_constant_override("margin_" + side, 34 if side in ["left", "right"] else 26)
	panel.add_child(pad)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 14)
	pad.add_child(box)

	var title := Label.new()
	title.text = "RÉGLAGES"
	title.add_theme_font_size_override("font_size", 42)
	title.add_theme_color_override("font_color", COL_TXT)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	box.add_child(title)

	box.add_child(_setting_row("Langue", Loc.LANG_NAMES,
		maxi(0, Loc.LANGS.find(GameSettings.language)), func(idx: int) -> void: GameSettings.set_language(Loc.LANGS[idx])))

	box.add_child(_setting_row("Rapidité de progression XP", GameSettings.XP_SPEEDS,
		GameSettings.xp_speed, func(idx: int) -> void: GameSettings.set_xp_speed(idx)))

	box.add_child(_setting_row("Vitesse des tours ennemis", GameSettings.COMBAT_SPEEDS,
		GameSettings.combat_speed, func(idx: int) -> void: GameSettings.set_combat_speed(idx)))

	box.add_child(_setting_row("Vitesse des animations", GameSettings.ANIM_SPEEDS,
		GameSettings.anim_speed, func(idx: int) -> void: GameSettings.set_anim_speed(idx)))

	# V42 : mode contre-la-montre
	box.add_child(_setting_row("Contre-la-montre", GameSettings.SPEEDRUN_MODES,
		GameSettings.speedrun_mode, func(idx: int) -> void: GameSettings.set_speedrun_mode(idx)))

	# V42 : timer de tour (fin automatique du tour à l'expiration)
	box.add_child(_setting_row("Timer de tour", GameSettings.TURN_TIMER_MODES,
		GameSettings.turn_timer_mode, func(idx: int) -> void: GameSettings.set_turn_timer_mode(idx)))

	box.add_child(_setting_row("Sons et vibrations", ["Sons + vibr.", "Sons seuls", "Silence"] as Array[String],
		0 if (GameSettings.sfx_on and GameSettings.haptics_on) else (1 if GameSettings.sfx_on else 2),
		func(idx: int) -> void:
			GameSettings.set_sfx(idx < 2)
			GameSettings.set_haptics(idx == 0)))

	box.add_child(_setting_row("Taille du texte des menus", GameSettings.TEXT_SIZES,
		GameSettings.text_size, func(idx: int) -> void: GameSettings.set_text_size(idx)))

	var tuto := Button.new()
	tuto.name = "TutoRestart"
	tuto.text = "🎓  Relancer le tutoriel de Gultur"
	tuto.custom_minimum_size = Vector2(0, 58)
	tuto.add_theme_font_size_override("font_size", 21)
	tuto.add_theme_color_override("font_color", COL_TXT)
	tuto.add_theme_stylebox_override("normal", _flat(Color(0.86, 0.80, 0.64), COL_BORDER, 12, 2))
	tuto.add_theme_stylebox_override("hover", _flat(Color(0.99, 0.95, 0.83), COL_BORDER, 12, 3))
	tuto.pressed.connect(func() -> void:
		GameSettings.restart_tutorial()
		tuto.text = "✓  Tutoriel relancé : retrouve Gultur dans Mes Parties")
	box.add_child(tuto)

	var hint := Label.new()
	hint.text = "La rapidité XP règle le gain d'expérience de chaque combat. La taille du texte agrandit les menus (utile sur téléphone).\nLa difficulté des ennemis se règle pour chaque partie, dans « Mes Parties »."
	hint.add_theme_font_size_override("font_size", 19)
	hint.add_theme_color_override("font_color", Color(0.35, 0.28, 0.12))
	hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hint.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	box.add_child(hint)

	# Informations de build : le numéro final correspond au numéro de PR.
	var info_panel := PanelContainer.new()
	info_panel.custom_minimum_size = Vector2(0, 90)
	info_panel.add_theme_stylebox_override("panel", _flat(Color(0.86, 0.81, 0.68, 0.96), COL_BORDER, 12, 2))
	box.add_child(info_panel)

	var info_box := VBoxContainer.new()
	info_box.add_theme_constant_override("separation", 6)
	info_panel.add_child(info_box)

	var info_title := Label.new()
	info_title.text = "INFO"
	info_title.add_theme_font_size_override("font_size", 22)
	info_title.add_theme_color_override("font_color", COL_TXT)
	info_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	info_box.add_child(info_title)

	var version_label := Label.new()
	var game_version: String = str(ProjectSettings.get_setting("application/config/version", "0.0.01.0.0"))
	version_label.text = "Version du jeu : %s" % game_version
	version_label.add_theme_font_size_override("font_size", 25)
	version_label.add_theme_color_override("font_color", COL_TXT)
	version_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	info_box.add_child(version_label)
	var back := Button.new()
	back.text = "← MENU"
	back.custom_minimum_size = Vector2(0, 76)
	back.add_theme_font_size_override("font_size", 26)
	back.add_theme_color_override("font_color", COL_TXT)
	back.add_theme_stylebox_override("normal", _flat(Color(0.88, 0.82, 0.66), COL_BORDER, 12, 3))
	back.add_theme_stylebox_override("hover", _flat(Color(0.99, 0.95, 0.83), COL_BORDER, 12, 3))
	back.pressed.connect(func() -> void:
		get_tree().change_scene_to_file("res://scenes/SaveSlots.tscn"))
	box.add_child(back)

## Une ligne de réglage : libellé à gauche, groupe d'options à droite.
func _setting_row(label_txt: String, options: Array[String], current: int, on_pick: Callable) -> Control:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 16)

	var lbl := Label.new()
	lbl.text = label_txt
	lbl.add_theme_font_size_override("font_size", 25)
	lbl.add_theme_color_override("font_color", COL_TXT)
	lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(lbl)

	var group := HBoxContainer.new()
	group.add_theme_constant_override("separation", 8)
	row.add_child(group)

	var option_width: float = 104.0 if options.size() >= 4 else 120.0
	for i: int in range(options.size()):
		var opt := Button.new()
		opt.text = options[i]
		opt.custom_minimum_size = Vector2(option_width + 32.0, 58)
		opt.add_theme_font_size_override("font_size", 21 if options.size() >= 4 else 22)
		opt.focus_mode = Control.FOCUS_NONE
		_refresh_opt(opt, i == current)
		var idx_ref: int = i
		opt.pressed.connect(func() -> void:
			on_pick.call(idx_ref)
			for j: int in range(group.get_child_count()):
				_refresh_opt(group.get_child(j) as Button, j == idx_ref))
		group.add_child(opt)
	return row

func _refresh_opt(btn: Button, selected: bool) -> void:
	btn.add_theme_color_override("font_color", COL_TXT)
	btn.add_theme_stylebox_override("normal", _flat(
		Color(0.99, 0.95, 0.83) if selected else Color(0.80, 0.75, 0.62),
		Color(0.85, 0.68, 0.3) if selected else COL_BORDER, 12, 4 if selected else 2))
	btn.add_theme_stylebox_override("hover", _flat(Color(0.99, 0.95, 0.83), COL_BORDER, 12, 3))
	btn.add_theme_stylebox_override("pressed", _flat(Color(0.88, 0.82, 0.66), COL_BORDER, 12, 3))

func _flat(bg: Color, border: Color, radius: int = 12, bw: int = 3) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = bg
	s.border_color = border
	s.set_border_width_all(bw)
	s.set_corner_radius_all(radius)
	return s
