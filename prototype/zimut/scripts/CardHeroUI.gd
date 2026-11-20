class_name CardHeroUI
extends Control
## CardHeroUI.gd — Choix du héros du mode Cartes : toute carte de héros possédée (classes et boss) est jouable.
## Commun/Rare : bonus de début de duel ; Épique/Légendaire : bonus à chaque tour (voir JccDuel.HERO_BONUS).

signal closed(changed: bool)

const CARD_W: float = 170.0
const CARD_H: float = 245.0

var save: Dictionary = {}
var _selected: String = ""
var _changed: bool = false
var _grid: GridContainer
var _scroll: ScrollContainer
var _detail: Control
var _drag_start: Vector2 = Vector2.ZERO
var _dragging: bool = false
var _drag_moved: bool = false


func open(save_ref: Dictionary) -> void:
	save = save_ref
	JccCollection.ensure(save)
	_selected = JccCollection.active_hero(save)
	_build()
	_refresh()


func _build() -> void:
	position = Vector2.ZERO
	size = Vector2(1920, 1080)
	var bg := ColorRect.new()
	bg.color = Color(0.07, 0.05, 0.12, 1.0)
	bg.size = size
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(bg)
	var title: Label = UiKit.lbl("🦸  Choix du héros", 40, UiKit.C_GOLD, true)
	title.position = Vector2(40, 18)
	add_child(title)
	var sub: Label = UiKit.lbl("Héros de classe : bonus au début du duel · Héros épiques et boss : bonus à chaque tour.", 22, UiKit.C_DIM)
	sub.position = Vector2(480, 30)
	add_child(sub)
	var left := PanelContainer.new()
	left.position = Vector2(1250, 90)
	left.size = Vector2(640, 960)
	left.add_theme_stylebox_override("panel", UiKit.box(UiKit.C_PANEL, UiKit.C_BORDER, 14, 2, 14))
	add_child(left)
	_detail = Control.new()
	_detail.position = Vector2(1265, 105)
	_detail.size = Vector2(610, 930)
	add_child(_detail)
	_scroll = ScrollContainer.new()
	_scroll.position = Vector2(30, 90)
	_scroll.size = Vector2(1200, 960)
	_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	add_child(_scroll)
	_grid = GridContainer.new()
	_grid.columns = 6
	_grid.add_theme_constant_override("h_separation", 10)
	_grid.add_theme_constant_override("v_separation", 14)
	_scroll.add_child(_grid)


func _refresh() -> void:
	for c: Node in _grid.get_children():
		c.queue_free()
	var active: String = JccCollection.active_hero(save)
	for id: String in JccCollection.hero_candidates(save):
		var holder := Control.new()
		holder.custom_minimum_size = Vector2(CARD_W + 4, CARD_H + 4)
		_grid.add_child(holder)
		var v := JccCardView.new()
		v.position = Vector2(2, 2)
		v.size = Vector2(CARD_W, CARD_H)
		v.set_card(JccCards.get_card(id))
		v.selected = id == _selected
		v.release_tap = true
		v.tapped.connect(func(_vw: JccCardView) -> void:
			_selected = id
			_refresh())
		holder.add_child(v)
		if id == active:
			var tag: Label = UiKit.lbl("✔ Actif", 22, UiKit.C_GOOD, true)
			tag.position = Vector2(CARD_W - 86.0, 2.0)
			tag.mouse_filter = Control.MOUSE_FILTER_IGNORE
			holder.add_child(tag)
	_refresh_detail()


func _refresh_detail() -> void:
	for c: Node in _detail.get_children():
		c.queue_free()
	if _selected != "" and JccCollection.owns_any_level(save, _selected):
		var card: Dictionary = JccCards.get_card(_selected)
		var v := JccCardView.new()
		v.position = Vector2(150, 10)
		v.size = Vector2(300, 430)
		v.set_card(card)
		v.mouse_filter = Control.MOUSE_FILTER_IGNORE
		_detail.add_child(v)
		var rar: String = {"C": "Commun", "R": "Rare", "E": "Épique", "L": "Légendaire"}.get(String(card["rarity"]), "")
		var nm: Label = UiKit.lbl("%s · %s" % [String(card["name"]), rar], 30, UiKit.C_GOLD, true)
		nm.position = Vector2(10, 460)
		_detail.add_child(nm)
		var pw: Dictionary = JccDuel.power_for(JccCollection.hero_power_key(_selected))
		var pwl: Label = UiKit.lbl("⚡ Pouvoir : %s" % String(pw["name"]), 24, UiKit.C_TXT)
		pwl.position = Vector2(10, 520)
		_detail.add_child(pwl)
		var bn: Label = UiKit.lbl("✦ %s — %s" % [String(JccDuel.HERO_BONUS[_selected]["name"]), JccDuel.hero_bonus_text(_selected)], 24, Color(0.75, 0.9, 1.0))
		bn.position = Vector2(10, 575)
		bn.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		bn.custom_minimum_size = Vector2(590, 0)
		_detail.add_child(bn)
		var is_active: bool = _selected == JccCollection.active_hero(save)
		var b: Button = UiKit.btn("✔  Héros actif" if is_active else "Choisir ce héros", Color(0.95, 0.55, 0.4), 30, Vector2(590, 80))
		b.position = Vector2(10, 700)
		b.disabled = is_active
		b.pressed.connect(func() -> void:
			if JccCollection.set_hero(save, _selected):
				_changed = true
			_refresh())
		_detail.add_child(b)
	else:
		var hint: Label = UiKit.lbl("Touchez une carte de héros.", 24, UiKit.C_DIM)
		hint.position = Vector2(10, 10)
		_detail.add_child(hint)
	var hint2: Label = UiKit.lbl("Obtenez des cartes de boss (butin, chapitres) pour débloquer d'autres héros.", 20, UiKit.C_DIM)
	hint2.position = Vector2(10, 790)
	hint2.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	hint2.custom_minimum_size = Vector2(590, 0)
	_detail.add_child(hint2)
	var back: Button = UiKit.btn("Retour", Color(0.7, 0.45, 0.4), 26, Vector2(590, 70))
	back.position = Vector2(10, 850)
	back.pressed.connect(func() -> void: closed.emit(_changed))
	_detail.add_child(back)


func _input(event: InputEvent) -> void:
	if event is InputEventScreenDrag:
		if Rect2(_scroll.global_position, _scroll.size).has_point((event as InputEventScreenDrag).position):
			get_viewport().set_input_as_handled()
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			_drag_moved = false
			_dragging = Rect2(_scroll.global_position, _scroll.size).has_point((event as InputEventMouseButton).global_position)
			_drag_start = (event as InputEventMouseButton).global_position
		else:
			_dragging = false
			if _drag_moved:
				get_tree().create_timer(0.05).timeout.connect(func() -> void: JccCardView.drag_active = false)
			_drag_moved = false
	elif event is InputEventMouseMotion and _dragging \
			and ((event as InputEventMouseMotion).button_mask & MOUSE_BUTTON_MASK_LEFT) != 0:
		var mm: InputEventMouseMotion = event
		if not _drag_moved and (mm.global_position - _drag_start).length() > 14.0:
			_drag_moved = true
			JccCardView.drag_active = true
		if _drag_moved:
			var bar: VScrollBar = _scroll.get_v_scroll_bar()
			_scroll.scroll_vertical = clampi(_scroll.scroll_vertical - int(mm.relative.y), 0, int(bar.max_value))
			get_viewport().set_input_as_handled()
