extends CanvasLayer

## SettingsUI.gd — Réglages des combats et de la progression XP.
## Les choix sont persistés par l'autoload GameSettings.

const COL_PANEL := Color(0.94, 0.89, 0.78, 0.97)
const COL_BORDER := Color(0.72, 0.58, 0.28, 1.0)
const COL_TXT := Color(0.22, 0.15, 0.05)

const TABS := [["general", "⚙  Général"], ["combat", "⚔  Combat"], ["graphismes", "🎨  Graphismes"], ["sauvegarde", "☁  Sauvegarde"]]
const BOARD_VARIANTS: Array[String] = ["v2", "classic", "iso", "diorama"]
## Onglet ouvert (conservé pendant la session).
static var _tab: int = 0


func _grid(parent: Control) -> GridContainer:
	var grid := GridContainer.new()
	grid.columns = 2
	grid.add_theme_constant_override("h_separation", 28)
	grid.add_theme_constant_override("v_separation", 14)
	parent.add_child(grid)
	return grid


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
	box.add_theme_constant_override("separation", 12)
	pad.add_child(box)

	var title := Label.new()
	title.text = "RÉGLAGES"
	title.add_theme_font_size_override("font_size", 38)
	title.add_theme_color_override("font_color", COL_TXT)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	box.add_child(title)

	# V115 : réglages rangés en onglets (Général / Combat / Graphismes / Sauvegarde) : une page courte à la fois.
	var tabs := HBoxContainer.new()
	tabs.name = "Tabs"
	tabs.add_theme_constant_override("separation", 8)
	box.add_child(tabs)
	var pages := PanelContainer.new()
	pages.name = "Pages"
	pages.custom_minimum_size = Vector2(0, 380)
	pages.add_theme_stylebox_override("panel", _flat(Color(0.97, 0.93, 0.84, 0.9), Color(0.80, 0.68, 0.40), 14, 2))
	box.add_child(pages)
	var page_list: Array[Control] = []
	for t: Array in TABS:
		var pg := MarginContainer.new()
		pg.name = "Page_" + String(t[0])
		for side in ["left", "right", "top", "bottom"]:
			pg.add_theme_constant_override("margin_" + side, 22 if side in ["left", "right"] else 18)
		var v := VBoxContainer.new()
		v.add_theme_constant_override("separation", 14)
		pg.add_child(v)
		pages.add_child(pg)
		page_list.append(pg)
		var tb := Button.new()
		tb.name = "Tab_" + String(t[0])
		tb.text = String(t[1])
		tb.custom_minimum_size = Vector2(0, 60)
		tb.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		tb.add_theme_font_size_override("font_size", 23)
		tb.focus_mode = Control.FOCUS_NONE
		tabs.add_child(tb)
	var show_tab := func(idx: int) -> void:
		_tab = idx
		for i: int in range(page_list.size()):
			page_list[i].visible = i == idx
			_refresh_opt(tabs.get_child(i) as Button, i == idx)
	for i: int in range(tabs.get_child_count()):
		var idx_ref: int = i
		(tabs.get_child(i) as Button).pressed.connect(func() -> void: show_tab.call(idx_ref))

	# — Général
	var gen: VBoxContainer = page_list[0].get_child(0)
	var g1 := _grid(gen)
	g1.add_child(_setting_cell("Langue", Loc.LANG_NAMES,
		maxi(0, Loc.LANGS.find(GameSettings.language)), func(idx: int) -> void: GameSettings.set_language(Loc.LANGS[idx])))
	g1.add_child(_setting_cell("Taille du texte des menus", GameSettings.TEXT_SIZES,
		GameSettings.text_size, func(idx: int) -> void: GameSettings.set_text_size(idx)))
	g1.add_child(_setting_cell("Sons et vibrations", ["Sons + vibr.", "Sons seuls", "Silence"] as Array[String],
		0 if (GameSettings.sfx_on and GameSettings.haptics_on) else (1 if GameSettings.sfx_on else 2),
		func(idx: int) -> void:
			GameSettings.set_sfx(idx < 2)
			GameSettings.set_haptics(idx == 0)))
	g1.add_child(_setting_cell("Rappels de Conquête (Android)", ["Activés", "Désactivés"] as Array[String],
		0 if GameSettings.notifications_on else 1, func(idx: int) -> void: GameSettings.set_notifications(idx == 0)))
	var tuto := Button.new()
	tuto.name = "TutoRestart"
	tuto.text = "🎓  Relancer le tutoriel de Gultur"
	tuto.custom_minimum_size = Vector2(0, 62)
	tuto.add_theme_font_size_override("font_size", 21)
	tuto.add_theme_color_override("font_color", COL_TXT)
	tuto.add_theme_stylebox_override("normal", _flat(Color(0.86, 0.80, 0.64), COL_BORDER, 12, 2))
	tuto.add_theme_stylebox_override("hover", _flat(Color(0.99, 0.95, 0.83), COL_BORDER, 12, 3))
	tuto.pressed.connect(func() -> void:
		GameSettings.restart_tutorial()
		tuto.text = "✓  Tutoriel relancé")
	gen.add_child(tuto)

	# — Combat & progression
	var cmb: VBoxContainer = page_list[1].get_child(0)
	var g2 := _grid(cmb)
	g2.add_child(_setting_cell("Rapidité de progression XP", GameSettings.XP_SPEEDS,
		GameSettings.xp_speed, func(idx: int) -> void: GameSettings.set_xp_speed(idx)))
	# V42 : timer de tour (fin automatique du tour à l'expiration)
	g2.add_child(_setting_cell("Timer de tour", GameSettings.TURN_TIMER_MODES,
		GameSettings.turn_timer_mode, func(idx: int) -> void: GameSettings.set_turn_timer_mode(idx)))
	g2.add_child(_setting_cell("Vitesse des tours ennemis", GameSettings.COMBAT_SPEEDS,
		GameSettings.combat_speed, func(idx: int) -> void: GameSettings.set_combat_speed(idx)))
	g2.add_child(_setting_cell("Vitesse des animations", GameSettings.ANIM_SPEEDS,
		GameSettings.anim_speed, func(idx: int) -> void: GameSettings.set_anim_speed(idx)))
	var hint := Label.new()
	hint.text = "La difficulté des ennemis se règle pour chaque partie, dans « Mes Parties »."
	hint.add_theme_font_size_override("font_size", 18)
	hint.add_theme_color_override("font_color", Color(0.35, 0.28, 0.12))
	hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hint.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	cmb.add_child(hint)

	# — Graphismes
	var gfx: VBoxContainer = page_list[2].get_child(0)
	var g3 := _grid(gfx)
	g3.add_child(_setting_cell("Qualité graphique", GfxQuality.LABELS,
		GameSettings.graphics_quality, func(idx: int) -> void: GameSettings.set_graphics_quality(idx)))
	g3.add_child(_setting_cell("Personnages du monde 3D", ["Illustrés", "Modèles 3D"] as Array[String],
		1 if GameSettings.adventure_models_3d else 0, func(idx: int) -> void: GameSettings.set_adventure_models_3d(idx == 1)))
	g3.add_child(_setting_cell("Héros de la carte 2D", ["Modèles 3D animés", "Illustrés"] as Array[String],
		0 if GameSettings.adventure_walk_sprites else 1, func(idx: int) -> void: GameSettings.set_adventure_walk_sprites(idx == 0)))
	gfx.add_child(_setting_cell("Cartes 2D (Sylve et Cimes)", ["Nouvelle", "Ancienne", "Iso (test)", "Diorama"] as Array[String],
		BOARD_VARIANTS.find(GameSettings.sylvestre_board) if BOARD_VARIANTS.has(GameSettings.sylvestre_board) else 0,
		func(idx: int) -> void: GameSettings.set_sylvestre_board(BOARD_VARIANTS[idx])))
	gfx.add_child(_setting_cell("Grille des cases (carte d'aventure 2D)", ["Masquée", "Affichée"] as Array[String],
		1 if GameSettings.show_grid else 0, func(idx: int) -> void: GameSettings.set_show_grid(idx == 1)))
	gfx.add_child(_setting_cell("Compteur d'images (carte d'aventure)", ["Masqué", "Affiché"] as Array[String],
		1 if GameSettings.show_perf else 0, func(idx: int) -> void: GameSettings.set_show_perf(idx == 1)))
	var gfx_hint := Label.new()
	gfx_hint.text = "« Diorama » : la Sylve et le Brasier en scènes 3D pré-rendues (lumière, brume, maisons et arbres qui masquent le héros). Les autres Nations gardent leur carte."
	gfx_hint.add_theme_font_size_override("font_size", 17)
	gfx_hint.add_theme_color_override("font_color", Color(0.35, 0.28, 0.12))
	gfx_hint.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	gfx.add_child(gfx_hint)

	# — Sauvegarde (Cloud)
	_build_cloud(page_list[3].get_child(0) as VBoxContainer)

	show_tab.call(clampi(_tab, 0, TABS.size() - 1))

	# Informations de build : le numéro final correspond au numéro de PR.
	var info_panel := PanelContainer.new()
	info_panel.custom_minimum_size = Vector2(0, 46)
	info_panel.add_theme_stylebox_override("panel", _flat(Color(0.86, 0.81, 0.68, 0.96), COL_BORDER, 12, 2))
	box.add_child(info_panel)

	var version_label := Label.new()
	var game_version: String = str(ProjectSettings.get_setting("application/config/version", "0.0.01.0.0"))
	version_label.text = "INFO  ·  Version du jeu : %s" % game_version
	version_label.add_theme_font_size_override("font_size", 22)
	version_label.add_theme_color_override("font_color", COL_TXT)
	version_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	info_panel.add_child(version_label)
	var back := Button.new()
	back.text = "← MENU"
	back.custom_minimum_size = Vector2(0, 66)
	back.add_theme_font_size_override("font_size", 26)
	back.add_theme_color_override("font_color", COL_TXT)
	back.add_theme_stylebox_override("normal", _flat(Color(0.88, 0.82, 0.66), COL_BORDER, 12, 3))
	back.add_theme_stylebox_override("hover", _flat(Color(0.99, 0.95, 0.83), COL_BORDER, 12, 3))
	back.pressed.connect(func() -> void:
		PlayTimer.flush()
		get_tree().change_scene_to_file("res://scenes/SaveSlots.tscn"))
	box.add_child(back)

# ═══════════════════════════════════════════════════════════════════════════
#  V49 : sauvegarde Cloud (Google Drive)
# ═══════════════════════════════════════════════════════════════════════════

var _cloud: CloudSave
var _cloud_status: Label
var _cloud_btns: Array[Button] = []
var _code_panel: PanelContainer
var _code_label: Label
var _code_url: String = ""


func _build_cloud(box: VBoxContainer) -> void:
	_cloud = CloudSave.new()
	_cloud.name = "CloudSave"
	add_child(_cloud)
	_cloud.status.connect(func(t: String) -> void: _cloud_status.text = t)
	_cloud.user_code.connect(_show_code)
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 14)
	box.add_child(row)
	var up := _cloud_button("☁  Sauvegarde sur Cloud", Color(0.70, 0.84, 0.98))
	up.name = "CloudBackup"
	up.pressed.connect(_on_cloud_backup)
	row.add_child(up)
	var down := _cloud_button("☁  Restauration depuis Cloud", Color(0.80, 0.92, 0.78))
	down.name = "CloudRestore"
	down.pressed.connect(_on_cloud_restore)
	row.add_child(down)
	var auto := _cloud_button("", Color(0.86, 0.80, 0.64))
	auto.name = "CloudAuto"
	auto.size_flags_horizontal = Control.SIZE_FILL
	auto.custom_minimum_size = Vector2(190, 64)
	auto.tooltip_text = "Sauvegarde Cloud automatique après chaque combat (compte Google relié)."
	var paint_auto := func() -> void:
		auto.text = "⟳ Auto : %s" % ("Oui" if GameSettings.cloud_auto else "Non")
	paint_auto.call()
	auto.pressed.connect(func() -> void:
		GameSettings.set_cloud_auto(not GameSettings.cloud_auto)
		paint_auto.call()
		if GameSettings.cloud_auto and not CloudSave.is_linked():
			_cloud_status.text = "Auto activé : il démarrera après ta première « Sauvegarde sur Cloud » (pour relier ton compte).")
	_cloud_btns.erase(auto)
	row.add_child(auto)
	_cloud_status = Label.new()
	_cloud_status.name = "CloudStatus"
	_cloud_status.add_theme_font_size_override("font_size", 19)
	_cloud_status.add_theme_color_override("font_color", Color(0.20, 0.30, 0.45))
	_cloud_status.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_cloud_status.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	if not CloudSave.is_configured():
		_cloud_status.text = "Google Drive n'est pas encore configuré dans cette version du jeu."
	elif CloudSave.is_linked():
		_cloud_status.text = "Compte Google relié · tes parties sont dans « zimut_backup.json » sur ton Drive (toucher ici pour changer de compte)."
	else:
		_cloud_status.text = "Google Drive : à la première sauvegarde, tu relieras ton compte avec un code."
	box.add_child(_cloud_status)
	# Toucher la ligne d'état (compte relié) : proposer de délier le compte Google.
	_cloud_status.mouse_filter = Control.MOUSE_FILTER_STOP
	_cloud_status.gui_input.connect(func(ev: InputEvent) -> void:
		var tap: bool = (ev is InputEventMouseButton and (ev as InputEventMouseButton).pressed) or (ev is InputEventScreenTouch and (ev as InputEventScreenTouch).pressed)
		if tap and CloudSave.is_linked():
			_confirm("Changer de compte Google ?", "Le jeu oubliera le compte Google relié sur cet appareil. Tes sauvegardes restent sur ton Drive ; la prochaine sauvegarde te demandera un nouveau code.",
				"DÉLIER LE COMPTE", func() -> void:
					CloudSave.unlink()
					_cloud_status.text = "Compte Google délié : la prochaine sauvegarde te demandera un code."))


func _cloud_button(txt: String, col: Color) -> Button:
	var b := Button.new()
	b.text = txt
	b.custom_minimum_size = Vector2(0, 64)
	b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	b.add_theme_font_size_override("font_size", 20)
	b.add_theme_color_override("font_color", COL_TXT)
	b.add_theme_stylebox_override("normal", _flat(col, COL_BORDER, 12, 2))
	b.add_theme_stylebox_override("hover", _flat(col.lightened(0.2), COL_BORDER, 12, 3))
	b.add_theme_stylebox_override("disabled", _flat(col.darkened(0.25), COL_BORDER, 12, 2))
	_cloud_btns.append(b)
	return b


func _cloud_busy(on: bool) -> void:
	for b: Button in _cloud_btns:
		b.disabled = on


func _on_cloud_backup(force: bool = false) -> void:
	PlayTimer.flush()
	_cloud_busy(true)
	var res: String = await _cloud.backup(force)
	_hide_code()
	_cloud_busy(false)
	if res == "conflict":
		var c: Dictionary = _cloud.last_conflict
		_confirm("⚠ Sauvegarde Cloud plus récente",
			"La sauvegarde Cloud a été faite le %s sur %s.\nTes parties sur cet appareil datent du %s.\n\nSi tu envoies maintenant, la progression faite sur l'autre appareil sera perdue. Pour la récupérer ici, utilise plutôt « Restauration depuis Cloud »." % [
				CloudSave.fmt_unix(int(c.get("unix", 0))), String(c.get("device", "un autre appareil")), CloudSave.fmt_unix(CloudSave.local_newest_unix())],
			"ÉCRASER QUAND MÊME", func() -> void: _on_cloud_backup(true))


func _on_cloud_restore() -> void:
	_cloud_busy(true)
	var bundle: Dictionary = await _cloud.fetch()
	_hide_code()
	_cloud_busy(false)
	if bundle.is_empty():
		return
	var local_unix: int = CloudSave.local_newest_unix()
	var older: bool = int(bundle.get("unix", 0)) > 0 and int(bundle.get("unix", 0)) < local_unix - 60
	var msg: String = CloudSave.describe(bundle) + "\n\nLes parties de cet appareil seront remplacées par celles de la sauvegarde."
	if older:
		msg = "⚠ Attention : cette sauvegarde est PLUS ANCIENNE que tes parties sur cet appareil (dernière partie enregistrée le %s). Restaurer effacerait ta progression récente.\n\n" % CloudSave.fmt_unix(local_unix) + msg
	_confirm("⚠ Sauvegarde Cloud plus ancienne" if older else "Restaurer depuis le Cloud ?", msg,
		"RESTAURER QUAND MÊME" if older else "RESTAURER", func() -> void:
			var n: int = CloudSave.apply_bundle(bundle)
			GameManager.active_save = {}
			GameManager.active_slot = -1
			_cloud_status.text = ("✓ %d partie(s) restaurée(s) depuis Google Drive." % n) if n >= 0 else "Sauvegarde Cloud illisible.")


## Fenêtre du code Google (premier branchement).
func _show_code(code: String, url: String) -> void:
	_code_url = url
	DisplayServer.clipboard_set(code)
	if _code_panel != null and is_instance_valid(_code_panel):
		_code_label.text = code
		_code_panel.visible = true
		return
	var overlay := ColorRect.new()
	overlay.color = Color(0, 0, 0, 0.6)
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	get_child(0).add_child(overlay)
	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay.add_child(center)
	_code_panel = PanelContainer.new()
	_code_panel.add_theme_stylebox_override("panel", _flat(COL_PANEL, COL_BORDER, 18, 4))
	center.add_child(_code_panel)
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 16)
	v.custom_minimum_size = Vector2(820, 0)
	_code_panel.add_child(_pad(v))
	var t := Label.new()
	t.text = "Relier ton compte Google"
	t.add_theme_font_size_override("font_size", 32)
	t.add_theme_color_override("font_color", COL_TXT)
	v.add_child(t)
	var info := Label.new()
	info.text = "1. Touche « Ouvrir Google » (le code est déjà copié).\n2. Saisis ce code, choisis ton compte et accepte.\n3. Reviens dans le jeu : la sauvegarde continue toute seule."
	info.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	info.add_theme_font_size_override("font_size", 22)
	info.add_theme_color_override("font_color", COL_TXT)
	v.add_child(info)
	_code_label = Label.new()
	_code_label.name = "CloudCode"
	_code_label.text = code
	_code_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_code_label.add_theme_font_size_override("font_size", 54)
	_code_label.add_theme_color_override("font_color", Color(0.10, 0.25, 0.55))
	v.add_child(_code_label)
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 14)
	v.add_child(row)
	var cancel := _cloud_button("Annuler", Color(0.86, 0.80, 0.64))
	cancel.pressed.connect(func() -> void:
		_cloud.cancel()
		_hide_code())
	row.add_child(cancel)
	var copy := _cloud_button("Copier le code", Color(0.86, 0.80, 0.64))
	copy.pressed.connect(func() -> void: DisplayServer.clipboard_set(_code_label.text))
	row.add_child(copy)
	var open := _cloud_button("Ouvrir Google", Color(0.70, 0.84, 0.98))
	open.pressed.connect(func() -> void: OS.shell_open(_code_url))
	row.add_child(open)
	# ces trois boutons ne doivent pas être désactivés pendant l'attente
	for b: Button in [cancel, copy, open]:
		_cloud_btns.erase(b)


func _pad(c: Control) -> MarginContainer:
	var m := MarginContainer.new()
	for side in ["left", "right", "top", "bottom"]:
		m.add_theme_constant_override("margin_" + side, 28 if side in ["left", "right"] else 22)
	m.add_child(c)
	return m


func _hide_code() -> void:
	if _code_panel != null and is_instance_valid(_code_panel):
		_code_panel.get_parent().get_parent().queue_free()   # overlay
		_code_panel = null


func _confirm(title: String, text: String, ok_txt: String, on_ok: Callable) -> void:
	var overlay := ColorRect.new()
	overlay.color = Color(0, 0, 0, 0.6)
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	get_child(0).add_child(overlay)
	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay.add_child(center)
	var panel := PanelContainer.new()
	panel.add_theme_stylebox_override("panel", _flat(COL_PANEL, COL_BORDER, 18, 4))
	center.add_child(panel)
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 16)
	v.custom_minimum_size = Vector2(820, 0)
	panel.add_child(_pad(v))
	var t := Label.new()
	t.text = title
	t.add_theme_font_size_override("font_size", 32)
	t.add_theme_color_override("font_color", COL_TXT)
	v.add_child(t)
	var l := Label.new()
	l.text = text
	l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	l.add_theme_font_size_override("font_size", 23)
	l.add_theme_color_override("font_color", COL_TXT)
	v.add_child(l)
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 14)
	v.add_child(row)
	var no := _cloud_button("Annuler", Color(0.86, 0.80, 0.64))
	_cloud_btns.erase(no)
	no.pressed.connect(func() -> void: overlay.queue_free())
	row.add_child(no)
	var yes := _cloud_button(ok_txt, Color(0.95, 0.70, 0.55))
	_cloud_btns.erase(yes)
	yes.pressed.connect(func() -> void:
		overlay.queue_free()
		on_ok.call())
	row.add_child(yes)


## Une ligne de réglage : libellé à gauche, groupe d'options à droite.
## Réglage en « cellule » : libellé au-dessus, boutons d'options répartis sur la largeur.
func _setting_cell(label_txt: String, options: Array[String], current: int, on_pick: Callable) -> Control:
	var cell := VBoxContainer.new()
	cell.add_theme_constant_override("separation", 4)
	cell.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	var lbl := Label.new()
	lbl.text = label_txt
	lbl.add_theme_font_size_override("font_size", 22)
	lbl.add_theme_color_override("font_color", COL_TXT)
	cell.add_child(lbl)

	var group := HBoxContainer.new()
	group.add_theme_constant_override("separation", 6)
	cell.add_child(group)
	for i: int in range(options.size()):
		var opt := Button.new()
		opt.text = options[i]
		opt.custom_minimum_size = Vector2(0, 52)
		opt.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		opt.add_theme_font_size_override("font_size", 20)
		opt.focus_mode = Control.FOCUS_NONE
		_refresh_opt(opt, i == current)
		var idx_ref: int = i
		opt.pressed.connect(func() -> void:
			on_pick.call(idx_ref)
			for j: int in range(group.get_child_count()):
				_refresh_opt(group.get_child(j) as Button, j == idx_ref))
		group.add_child(opt)
	return cell

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
