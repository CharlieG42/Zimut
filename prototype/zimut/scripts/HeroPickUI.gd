class_name HeroPickUI
extends Control
## HeroPickUI.gd — Choix des héros (V47).
## Mode « initial » : le joueur choisit HeroUnlock.START_PICKS héros (fin du tutoriel).
## Mode « unlock »  : le joueur choisit 1 héros à débloquer (niveau joueur atteint).
## Écran plein cadre : grille des héros (appui = voir la fiche), bouton ✓ pour cocher,
## fiche détaillée à droite (rôle, points forts/faibles, conseil), bouton de validation.

signal done(picked: Array)

const U = preload("res://scripts/UiKit.gd")
const GOLD := Color(1.0, 0.86, 0.4)

const CLASS_COLORS: Dictionary = {
	"Tank": Color(0.15, 0.45, 0.85), "Assassin": Color(0.85, 0.15, 0.15), "Chasseur": Color(0.15, 0.62, 0.15),
	"Mage": Color(0.60, 0.20, 0.82), "Druide": Color(0.95, 0.60, 0.10), "Heal": Color(0.10, 0.75, 0.75),
	"Invocateur": Color(0.55, 0.15, 0.60), "Sylvain": Color(0.35, 0.65, 0.25),
	"Géomancien": Color(0.85, 0.62, 0.25), "Artificier": Color(0.90, 0.45, 0.20),
}

var _data: Dictionary = {}
var _initial: bool = true
var _need: int = 3
var _candidates: Array[String] = []
var _picked: Array[String] = []
var _focus: String = ""
var _tiles: Dictionary = {}
var _title: Label
var _sub: Label
var _portrait: TextureRect
var _name: Label
var _text: RichTextLabel
var _toggle: Button
var _confirm: Button


## Ouvre l'écran sur `parent`. `data` = sauvegarde. Retourne l'instance.
static func open(parent: Node, data: Dictionary, initial: bool, on_done: Callable = Callable()) -> HeroPickUI:
	var ui := HeroPickUI.new()
	ui.name = "HeroPickUI"
	ui._data = data
	ui._initial = initial
	ui._need = HeroUnlock.START_PICKS if initial else 1
	if initial:
		for c in ClassRules.CLASSES.keys():
			ui._candidates.append(String(c))
		# ordre d'affichage voulu
		var order: Array[String] = ["Tank", "Assassin", "Chasseur", "Mage", "Druide", "Heal", "Invocateur", "Sylvain", "Géomancien", "Artificier"]
		ui._candidates.sort_custom(func(a: String, b: String) -> bool: return order.find(a) < order.find(b))
	else:
		ui._candidates = HeroUnlock.locked(data)
	if ui._candidates.is_empty():
		ui.queue_free()
		return null
	ui.set_anchors_preset(Control.PRESET_FULL_RECT)
	ui.mouse_filter = Control.MOUSE_FILTER_STOP
	if on_done.is_valid():
		ui.done.connect(on_done)
	parent.add_child(ui)
	return ui


func _ready() -> void:
	z_index = 50
	var bg := ColorRect.new()
	bg.color = Color(0.04, 0.05, 0.09, 0.97)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(bg)
	var root := Control.new()
	add_child(root)
	UiFit.apply(root, 1.0, Vector2(1300, 760))
	var margin := MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	for side in ["left", "right"]:
		margin.add_theme_constant_override("margin_" + side, 22)
	margin.add_theme_constant_override("margin_top", 14)
	margin.add_theme_constant_override("margin_bottom", 14)
	root.add_child(margin)
	var page := VBoxContainer.new()
	page.add_theme_constant_override("separation", 10)
	margin.add_child(page)

	_title = U.lbl("", 32, GOLD, true)
	_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	page.add_child(_title)
	_sub = U.lbl("", 20, U.C_DIM)
	_sub.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_sub.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	page.add_child(_sub)

	var body := HBoxContainer.new()
	body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body.add_theme_constant_override("separation", 16)
	page.add_child(body)

	# Grille des héros
	var grid := GridContainer.new()
	grid.columns = 2
	grid.add_theme_constant_override("h_separation", 10)
	grid.add_theme_constant_override("v_separation", 10)
	grid.custom_minimum_size = Vector2(430, 0)
	body.add_child(grid)
	for c: String in _candidates:
		var b := Button.new()
		b.name = "Tile_%s" % c
		b.custom_minimum_size = Vector2(205, 92)
		b.focus_mode = Control.FOCUS_NONE
		b.add_theme_font_size_override("font_size", 21)
		b.add_theme_color_override("font_color", Color.WHITE)
		b.pressed.connect(func() -> void: _set_focus(c))
		grid.add_child(b)
		_tiles[c] = b

	# Fiche
	var panel := PanelContainer.new()
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel.add_theme_stylebox_override("panel", U.box(Color(0.09, 0.11, 0.17), Color(0.72, 0.58, 0.28), 14, 3, 14))
	body.add_child(panel)
	var pv := VBoxContainer.new()
	pv.add_theme_constant_override("separation", 8)
	panel.add_child(pv)
	var head := HBoxContainer.new()
	head.add_theme_constant_override("separation", 14)
	pv.add_child(head)
	_portrait = TextureRect.new()
	_portrait.custom_minimum_size = Vector2(120, 140)
	_portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	head.add_child(_portrait)
	_name = U.lbl("", 34, GOLD, true)
	_name.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	head.add_child(_name)
	var sc := ScrollContainer.new()
	sc.size_flags_vertical = Control.SIZE_EXPAND_FILL
	sc.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	pv.add_child(sc)
	_text = RichTextLabel.new()
	_text.bbcode_enabled = true
	_text.fit_content = true
	_text.scroll_active = false
	_text.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_text.add_theme_font_size_override("normal_font_size", 19)
	_text.add_theme_font_size_override("bold_font_size", 19)
	_text.add_theme_color_override("default_color", Color(0.86, 0.88, 0.94))
	sc.add_child(_text)

	var foot := HBoxContainer.new()
	foot.add_theme_constant_override("separation", 14)
	page.add_child(foot)
	_toggle = U.btn("", Color(0.30, 0.62, 0.34), 24, Vector2(0, 62))
	_toggle.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_toggle.pressed.connect(_on_toggle)
	foot.add_child(_toggle)
	_confirm = U.btn("", GOLD, 24, Vector2(0, 62))
	_confirm.name = "ConfirmBtn"
	_confirm.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_confirm.pressed.connect(_on_confirm)
	foot.add_child(_confirm)

	_focus = _candidates[0]
	_refresh()


func _set_focus(c: String) -> void:
	_focus = c
	_refresh()


func _on_toggle() -> void:
	if _picked.has(_focus):
		_picked.erase(_focus)
	elif _picked.size() < _need:
		_picked.append(_focus)
	elif _need == 1:
		_picked = [_focus]
	_refresh()


func _on_confirm() -> void:
	if _picked.size() != _need:
		return
	var ok: bool
	if _initial:
		ok = HeroUnlock.pick_initial(_data, _picked)
	else:
		ok = HeroUnlock.unlock(_data, _picked[0])
	if not ok:
		return
	var out: Array = _picked.duplicate()
	done.emit(out)
	queue_free()


func _refresh() -> void:
	if _initial:
		_title.text = "Choisis tes %d premiers héros" % _need
		_sub.text = "Ils seront les seuls disponibles au début. D'autres se débloqueront en montant de niveau : tu pourras alors choisir celui que tu veux."
	else:
		_title.text = "Nouveau héros à débloquer !"
		_sub.text = "Ton niveau de joueur a progressé : choisis le héros qui rejoint ta compagnie."
	for c: String in _tiles.keys():
		var b: Button = _tiles[c]
		var col: Color = CLASS_COLORS.get(c, Color(0.5, 0.5, 0.5))
		var on: bool = _picked.has(c)
		b.text = "%s%s %s\n%s" % ["✓ " if on else "", ClassInfo.icon(c), c, ClassInfo.stars(c)]
		var st: StyleBoxFlat = U.box(col.darkened(0.45) if on else Color(0.12, 0.14, 0.21),
			GOLD if c == _focus else col.darkened(0.1), 14, 4 if c == _focus else 2, 8)
		for s in ["normal", "hover", "pressed"]:
			b.add_theme_stylebox_override(s, st)
	var tex_path := "res://assets/sprites/players/%s.png" % EntityView.sprite_key(_focus)
	_portrait.texture = load(tex_path) as Texture2D if ResourceLoader.exists(tex_path) else null
	_name.text = "%s  %s" % [ClassInfo.icon(_focus), _focus]
	_text.text = ClassInfo.full_text(_focus)
	_toggle.text = "✕  RETIRER" if _picked.has(_focus) else ("✓  CHOISIR %s" % _focus.to_upper())
	_confirm.text = "CONFIRMER  (%d/%d)" % [_picked.size(), _need]
	_confirm.disabled = _picked.size() != _need
