class_name CardFusionUI
extends Control
## CardFusionUI.gd — Atelier de fusion du mode Cartes : 2 exemplaires du même niveau -> 1 exemplaire de niveau +1 (max 5).
## Niveau 2+ : créatures +1 ATQ/+1 PV par niveau, sorts +1 à l'effet par niveau, coût en mana −1 au niveau 3 puis au niveau 5.

signal closed(changed: bool)

const CARD_W: float = 170.0
const CARD_H: float = 245.0

var save: Dictionary = {}
var _selected: String = ""
var _changed: bool = false
var _grid: GridContainer
var _scroll: ScrollContainer
var _detail: Control
var _msg: Label
var _drag_sc: ScrollContainer = null
var _drag_start: Vector2 = Vector2.ZERO
var _drag_moved: bool = false


func open(save_ref: Dictionary) -> void:
	save = save_ref
	JccCollection.ensure(save)
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
	var title: Label = UiKit.lbl("⚗  Atelier de fusion", 40, UiKit.C_GOLD, true)
	title.position = Vector2(40, 18)
	add_child(title)
	var sub: Label = UiKit.lbl("2 cartes identiques de même niveau → 1 carte de niveau supérieur (max 5 ★).", 22, UiKit.C_DIM)
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


## Clés possédées triées : rareté, nom, niveau.
func owned_keys() -> Array:
	var keys: Array = []
	for k: Variant in (JccCollection.ensure(save)["collection"] as Dictionary):
		var ks: String = String(k)
		if JccCollection.owned(save, ks) > 0 and not JccCards.get_card(ks).is_empty():
			keys.append(ks)
	keys.sort_custom(func(a: String, b: String) -> bool:
		var ca: Dictionary = JccCards.get_card(a)
		var cb: Dictionary = JccCards.get_card(b)
		if String(ca["rarity"]) != String(cb["rarity"]):
			return "CRE L".find(String(ca["rarity"])) < "CRE L".find(String(cb["rarity"]))
		if String(ca["name"]) != String(cb["name"]):
			return String(ca["name"]) < String(cb["name"])
		return int(ca["lvl"]) < int(cb["lvl"]))
	return keys


func _refresh() -> void:
	for c: Node in _grid.get_children():
		c.queue_free()
	for key: String in owned_keys():
		var holder := Control.new()
		holder.custom_minimum_size = Vector2(CARD_W + 4, CARD_H + 4)
		_grid.add_child(holder)
		var v := JccCardView.new()
		v.position = Vector2(2, 2)
		v.size = Vector2(CARD_W, CARD_H)
		v.set_card(JccCards.get_card(key))
		v.count_badge = JccCollection.owned(save, key)
		v.selected = key == _selected
		v.release_tap = true
		v.owned_dim = not JccCollection.can_fuse(save, key)
		v.tapped.connect(func(_vw: JccCardView) -> void:
			_selected = key
			_refresh())
		holder.add_child(v)
	_refresh_detail()


func _refresh_detail() -> void:
	for c: Node in _detail.get_children():
		c.queue_free()
	if _selected == "" or JccCollection.owned(save, _selected) <= 0:
		_selected = ""
		var hint: Label = UiKit.lbl("Touchez une carte pour la fusionner.", 24, UiKit.C_DIM)
		hint.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		hint.custom_minimum_size = Vector2(500, 0)
		_detail.add_child(hint)
		_add_close()
		return
	var lvl: int = JccCards.level_of(_selected)
	var cur := JccCardView.new()
	cur.position = Vector2(10, 10)
	cur.size = Vector2(270, 390)
	cur.set_card(JccCards.get_card(_selected))
	cur.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_detail.add_child(cur)
	if lvl < JccCards.MAX_LEVEL:
		var arrow: Label = UiKit.lbl("→", 60, UiKit.C_GOLD, true)
		arrow.position = Vector2(290, 160)
		_detail.add_child(arrow)
		var nxt := JccCardView.new()
		nxt.position = Vector2(340, 10)
		nxt.size = Vector2(270, 390)
		nxt.set_card(JccCards.get_card(JccCards.key_of(JccCards.base_of(_selected), lvl + 1)))
		nxt.mouse_filter = Control.MOUSE_FILTER_IGNORE
		_detail.add_child(nxt)
	var own: int = JccCollection.owned(save, _selected)
	var info: Label = UiKit.lbl("Possédées : %d · Niveau %d/%d" % [own, lvl, JccCards.MAX_LEVEL], 24, UiKit.C_TXT)
	info.position = Vector2(10, 420)
	_detail.add_child(info)
	var rule: Label = UiKit.lbl(_bonus_text(lvl), 20, UiKit.C_DIM)
	rule.position = Vector2(10, 460)
	rule.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	rule.custom_minimum_size = Vector2(590, 0)
	_detail.add_child(rule)
	var b: Button = UiKit.btn("⚗  Fusionner (2 → 1)", Color(0.75, 0.5, 0.95), 30, Vector2(590, 80))
	b.position = Vector2(10, 640)
	b.disabled = not JccCollection.can_fuse(save, _selected)
	b.pressed.connect(_do_fuse)
	_detail.add_child(b)
	_msg = UiKit.lbl("", 22, UiKit.C_GOOD)
	_msg.position = Vector2(10, 735)
	_msg.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_msg.custom_minimum_size = Vector2(590, 0)
	_detail.add_child(_msg)
	if lvl >= JccCards.MAX_LEVEL:
		_msg.text = "Niveau maximum atteint."
	elif own < JccCollection.FUSE_COST:
		_msg.text = "Il faut 2 exemplaires du même niveau."
		_msg.add_theme_color_override("font_color", UiKit.C_DIM)
	_add_close()


func _bonus_text(lvl: int) -> String:
	var n: int = lvl + 1
	var parts: Array = ["Niveau %d : créatures +1 ATQ / +1 PV, sorts +1 à l'effet" % n]
	if n == 3 or n == 5:
		parts.append("coût en mana −1")
	return " · ".join(parts) + "."


func _add_close() -> void:
	var back: Button = UiKit.btn("Retour", Color(0.7, 0.45, 0.4), 26, Vector2(590, 70))
	back.position = Vector2(10, 840)
	back.pressed.connect(func() -> void: closed.emit(_changed))
	_detail.add_child(back)


func _do_fuse() -> void:
	var res: String = JccCollection.fuse(save, _selected)
	if res == "":
		return
	_changed = true
	_selected = res
	_refresh()
	if _msg != null and is_instance_valid(_msg):
		_msg.text = "Fusion réussie : niveau %d !" % JccCards.level_of(res)


func _input(event: InputEvent) -> void:
	if event is InputEventScreenDrag:
		if Rect2(_scroll.global_position, _scroll.size).has_point((event as InputEventScreenDrag).position):
			get_viewport().set_input_as_handled()
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			_drag_sc = null
			_drag_moved = false
			var mp: Vector2 = (event as InputEventMouseButton).global_position
			if Rect2(_scroll.global_position, _scroll.size).has_point(mp):
				_drag_sc = _scroll
				_drag_start = mp
		else:
			_drag_sc = null
			if _drag_moved:
				get_tree().create_timer(0.05).timeout.connect(func() -> void: JccCardView.drag_active = false)
			_drag_moved = false
	elif event is InputEventMouseMotion and _drag_sc != null \
			and ((event as InputEventMouseMotion).button_mask & MOUSE_BUTTON_MASK_LEFT) != 0:
		var mm: InputEventMouseMotion = event
		if not _drag_moved and (mm.global_position - _drag_start).length() > 14.0:
			_drag_moved = true
			JccCardView.drag_active = true
		if _drag_moved:
			var bar: VScrollBar = _drag_sc.get_v_scroll_bar()
			_drag_sc.scroll_vertical = clampi(_drag_sc.scroll_vertical - int(mm.relative.y), 0, int(bar.max_value))
			get_viewport().set_input_as_handled()
