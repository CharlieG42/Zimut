class_name CardDeckBuilder
extends Control
## CardDeckBuilder.gd — Constructeur de deck du mode Cartes : collection à gauche/centre, deck de 20 cartes à droite.
## Touchez une carte pour la voir en grand, puis « Ajouter » / « Retirer ».

signal closed(saved: bool)

const CARD_W: float = 170.0
const CARD_H: float = 245.0
const FILTERS: Array = [["all", "Toutes"], ["Creature", "Créatures"], ["Sort", "Sorts"], ["boss", "Boss"]]

var save: Dictionary = {}
var _deck: Array = []
var _filter: String = "all"
var _selected: String = ""
var _grid: GridContainer
var _scroll: ScrollContainer       # zone de la collection (toute la zone doit scroller)
var _dscroll: ScrollContainer      # zone du deck courant
var _deck_box: VBoxContainer
var _detail_holder: Control
var _detail_btns: HBoxContainer
var _count_lbl: Label
var _err_lbl: Label
var _save_btn: Button
var _tabs: HBoxContainer


func open(save_ref: Dictionary) -> void:
	save = save_ref
	var j: Dictionary = JccCollection.ensure(save)
	_deck = (j["deck"] as Array).duplicate()
	_build()
	_refresh_all()


func _build() -> void:
	position = Vector2.ZERO
	size = Vector2(1920, 1080)
	var bg := ColorRect.new()
	bg.color = Color(0.05, 0.07, 0.12, 1.0)
	bg.size = Vector2(1920, 1080)
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(bg)
	var title: Label = UiKit.lbl("Mon deck", 40, UiKit.C_GOLD, true)
	title.position = Vector2(40, 18)
	add_child(title)
	# colonne gauche : détail
	var left := PanelContainer.new()
	left.position = Vector2(30, 90)
	left.size = Vector2(350, 960)
	left.add_theme_stylebox_override("panel", UiKit.box(UiKit.C_PANEL, UiKit.C_BORDER, 14, 2, 14))
	add_child(left)
	_detail_holder = Control.new()
	_detail_holder.position = Vector2(30 + 25, 90 + 20)
	_detail_holder.size = Vector2(300, 430)
	add_child(_detail_holder)
	_detail_btns = HBoxContainer.new()
	_detail_btns.position = Vector2(45, 630)
	_detail_btns.size = Vector2(320, 60)
	_detail_btns.add_theme_constant_override("separation", 12)
	add_child(_detail_btns)
	# onglets de filtre
	_tabs = HBoxContainer.new()
	_tabs.position = Vector2(410, 28)
	_tabs.add_theme_constant_override("separation", 10)
	add_child(_tabs)
	# grille de la collection
	var scroll := ScrollContainer.new()
	scroll.position = Vector2(400, 90)
	scroll.size = Vector2(950, 960)
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	add_child(scroll)
	_scroll = scroll
	_grid = GridContainer.new()
	_grid.columns = 5
	_grid.add_theme_constant_override("h_separation", 10)
	_grid.add_theme_constant_override("v_separation", 14)
	scroll.add_child(_grid)
	# colonne droite : deck
	var right := PanelContainer.new()
	right.position = Vector2(1370, 90)
	right.size = Vector2(520, 960)
	right.add_theme_stylebox_override("panel", UiKit.box(UiKit.C_PANEL, UiKit.C_BORDER, 14, 2, 14))
	add_child(right)
	var rbox := VBoxContainer.new()
	rbox.position = Vector2(1385, 100)
	rbox.size = Vector2(490, 940)
	rbox.add_theme_constant_override("separation", 6)
	add_child(rbox)
	_count_lbl = UiKit.lbl("", 30, UiKit.C_TXT, true)
	rbox.add_child(_count_lbl)
	_err_lbl = UiKit.lbl("", 18, UiKit.C_BAD)
	_err_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_err_lbl.custom_minimum_size = Vector2(480, 26)
	rbox.add_child(_err_lbl)
	var dscroll := ScrollContainer.new()
	dscroll.custom_minimum_size = Vector2(490, 640)
	dscroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	rbox.add_child(dscroll)
	_dscroll = dscroll
	_deck_box = VBoxContainer.new()
	_deck_box.custom_minimum_size = Vector2(480, 0)
	_deck_box.add_theme_constant_override("separation", 4)
	dscroll.add_child(_deck_box)
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 10)
	rbox.add_child(row)
	var reset: Button = UiKit.btn("Deck de départ", Color(0.55, 0.6, 0.75), 20, Vector2(0, 54))
	reset.pressed.connect(func() -> void:
		_deck = JccCollection.starter_deck()
		_refresh_all())
	row.add_child(reset)
	var back: Button = UiKit.btn("Retour", Color(0.7, 0.45, 0.4), 20, Vector2(120, 54))
	back.pressed.connect(func() -> void: closed.emit(false))
	row.add_child(back)
	_save_btn = UiKit.btn("Enregistrer", Color(0.35, 0.8, 0.45), 22, Vector2(0, 62))
	_save_btn.pressed.connect(_save_deck)
	rbox.add_child(_save_btn)


## Molette : toute la zone des cartes (pas seulement la scrollbar) fait défiler
## la liste sous la souris. _input n'est appelé que si le GUI n'a pas consommé
## l'événement, donc pas de double défilement.
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed \
			and (event.button_index == MOUSE_BUTTON_WHEEL_UP or event.button_index == MOUSE_BUTTON_WHEEL_DOWN):
		var mp: Vector2 = get_viewport().get_mouse_position()
		var delta: int = -110 if event.button_index == MOUSE_BUTTON_WHEEL_UP else 110
		for sc: ScrollContainer in [_scroll, _dscroll]:
			if sc != null and is_instance_valid(sc) and Rect2(sc.global_position, sc.size).has_point(mp):
				var bar: VScrollBar = sc.get_v_scroll_bar()
				sc.scroll_vertical = clampi(sc.scroll_vertical + delta, 0, int(bar.max_value))
				get_viewport().set_input_as_handled()


func _save_deck() -> void:
	if JccCollection.deck_error(save, _deck) != "":
		return
	var j: Dictionary = JccCollection.ensure(save)
	j["deck"] = _deck.duplicate()
	closed.emit(true)


func _refresh_all() -> void:
	_refresh_tabs()
	_refresh_grid()
	_refresh_deck()
	_refresh_detail()


func _refresh_tabs() -> void:
	for c: Node in _tabs.get_children():
		c.queue_free()
	for f: Variant in FILTERS:
		var fa: Array = f
		var b: Button = UiKit.btn(String(fa[1]), UiKit.C_GOLD if _filter == String(fa[0]) else Color(0.5, 0.55, 0.7), 22, Vector2(150, 50))
		b.pressed.connect(func() -> void:
			_filter = String(fa[0])
			_refresh_tabs()
			_refresh_grid())
		_tabs.add_child(b)


func _passes(id: String) -> bool:
	var c: Dictionary = JccCards.get_card(id)
	match _filter:
		"Creature":
			return String(c["type"]) == "Creature" and String(c["rarity"]) != "L"
		"Sort":
			return String(c["type"]) == "Sort"
		"boss":
			return String(c["rarity"]) == "L"
	return true


func _count_in_deck(id: String) -> int:
	var n: int = 0
	for d: Variant in _deck:
		if String(d) == id:
			n += 1
	return n


func _refresh_grid() -> void:
	for c: Node in _grid.get_children():
		c.queue_free()
	var ids: Array = JccCards.collectible_ids()
	ids.sort_custom(func(a: String, b: String) -> bool:
		var ca: Dictionary = JccCards.get_card(a)
		var cb: Dictionary = JccCards.get_card(b)
		if String(ca["rarity"]) != String(cb["rarity"]):
			return "CRE L".find(String(ca["rarity"])) < "CRE L".find(String(cb["rarity"]))
		if int(ca["cost"]) != int(cb["cost"]):
			return int(ca["cost"]) < int(cb["cost"])
		return String(ca["name"]) < String(cb["name"]))
	for id: String in ids:
		if not _passes(id):
			continue
		var holder := Control.new()
		holder.custom_minimum_size = Vector2(CARD_W + 4, CARD_H + 4)
		_grid.add_child(holder)
		var v := JccCardView.new()
		v.position = Vector2(2, 2)
		v.size = Vector2(CARD_W, CARD_H)
		v.set_card(JccCards.get_card(id))
		var own: int = JccCollection.owned(save, id)
		v.owned_dim = own <= 0
		v.count_badge = own
		v.selected = id == _selected
		v.tapped.connect(func(_vw: JccCardView) -> void:
			_selected = id
			_refresh_grid()
			_refresh_detail())
		holder.add_child(v)
		var inn: int = _count_in_deck(id)
		if inn > 0:
			var lb: Label = UiKit.lbl("Deck ×%d" % inn, 17, UiKit.C_GOOD, true)
			lb.position = Vector2(CARD_W * 0.5 - 38.0, 3)
			lb.mouse_filter = Control.MOUSE_FILTER_IGNORE
			holder.add_child(lb)


func _refresh_deck() -> void:
	for c: Node in _deck_box.get_children():
		c.queue_free()
	var counts: Dictionary = {}
	for d: Variant in _deck:
		counts[String(d)] = int(counts.get(String(d), 0)) + 1
	var ids: Array = counts.keys()
	ids.sort_custom(func(a: String, b: String) -> bool:
		var ca: Dictionary = JccCards.get_card(a)
		var cb: Dictionary = JccCards.get_card(b)
		if int(ca["cost"]) != int(cb["cost"]):
			return int(ca["cost"]) < int(cb["cost"])
		return String(ca["name"]) < String(cb["name"]))
	for id: String in ids:
		var c: Dictionary = JccCards.get_card(id)
		var col: Color = JccCardView.RARITY_COL.get(String(c["rarity"]), Color.WHITE)
		var kind: String = "✦" if String(c["type"]) == "Sort" else "▲"
		var b: Button = UiKit.btn("%d  %s %s%s" % [int(c["cost"]), kind, String(c["name"]), ("  ×%d" % int(counts[id])) if int(counts[id]) > 1 else ""], col, 20, Vector2(0, 44))
		b.alignment = HORIZONTAL_ALIGNMENT_LEFT
		b.pressed.connect(func() -> void:
			_selected = id
			_refresh_grid()
			_refresh_detail())
		_deck_box.add_child(b)
	var err: String = JccCollection.deck_error(save, _deck)
	_count_lbl.text = "Deck : %d / %d" % [_deck.size(), JccCollection.DECK_SIZE]
	_count_lbl.add_theme_color_override("font_color", UiKit.C_GOOD if err == "" else UiKit.C_BAD)
	_err_lbl.text = err
	_save_btn.disabled = err != ""


func _refresh_detail() -> void:
	for c: Node in _detail_holder.get_children():
		c.queue_free()
	for c: Node in _detail_btns.get_children():
		c.queue_free()
	if _selected == "":
		var hint: Label = UiKit.lbl("Touchez une carte pour la voir en grand.", 22, UiKit.C_DIM)
		hint.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		hint.custom_minimum_size = Vector2(280, 0)
		_detail_holder.add_child(hint)
		return
	var v := JccCardView.new()
	v.size = Vector2(300, 430)
	v.set_card(JccCards.get_card(_selected))
	v.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_detail_holder.add_child(v)
	var own: int = JccCollection.owned(save, _selected)
	var inn: int = _count_in_deck(_selected)
	var lim: int = mini(JccCollection.max_copies(_selected), own)
	var info: Label = UiKit.lbl("Possédée : %d · Dans le deck : %d (max %d)" % [own, inn, JccCollection.max_copies(_selected)], 18, UiKit.C_DIM)
	info.position = Vector2(0, 440)
	info.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	info.custom_minimum_size = Vector2(300, 0)
	_detail_holder.add_child(info)
	var add: Button = UiKit.btn("Ajouter", Color(0.35, 0.8, 0.45), 22, Vector2(150, 60))
	add.disabled = inn >= lim or _deck.size() >= JccCollection.DECK_SIZE + 5
	add.pressed.connect(func() -> void:
		_deck.append(_selected)
		_refresh_all())
	_detail_btns.add_child(add)
	var rem: Button = UiKit.btn("Retirer", Color(0.85, 0.45, 0.4), 22, Vector2(150, 60))
	rem.disabled = inn <= 0
	rem.pressed.connect(func() -> void:
		_deck.erase(_selected)
		_refresh_all())
	_detail_btns.add_child(rem)
