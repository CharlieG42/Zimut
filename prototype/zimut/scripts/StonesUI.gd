extends CanvasLayer
## StonesUI.gd — Vitrine des Pierres Élémentaires (V27), ouverte depuis « Mes Parties ».
## Chaque Pierre : où la trouver, son bonus, son porteur (2 Pierres max par héros) et son éveil (niv 1 à 5).

signal closed

const U = preload("res://scripts/UiKit.gd")

var _save: Dictionary = {}
var _slot: int = -1
var _root: Control
var _grid: GridContainer
var _title: Label
var _msg: Label


## Gemme facettée dessinée (grisée tant que la Pierre n'est pas retrouvée).
class GemIcon extends Control:
	var col: Color = Color.WHITE
	var found: bool = false
	var lv: int = 0
	var _t: float = 0.0

	func _process(delta: float) -> void:
		if found:
			_t += delta
			queue_redraw()

	func _draw() -> void:
		var c: Vector2 = size * 0.5
		var r: float = minf(size.x, size.y) * 0.42
		var base: Color = col if found else Color(0.30, 0.32, 0.38)
		if found:
			draw_circle(c, r * (1.15 + 0.05 * sin(_t * 2.0)), Color(col.r, col.g, col.b, 0.18))
		var top := PackedVector2Array()
		var pts: Array[Vector2] = []
		for i: int in range(6):
			var a: float = -PI / 2.0 + float(i) * TAU / 6.0
			pts.append(c + Vector2(cos(a), sin(a)) * r)
		for p: Vector2 in pts:
			top.append(p)
		draw_colored_polygon(top, base.darkened(0.25))
		# facettes
		for i: int in range(6):
			var p1: Vector2 = pts[i]
			var p2: Vector2 = pts[(i + 1) % 6]
			var shade: float = 0.10 + 0.12 * float(i % 3)
			draw_colored_polygon(PackedVector2Array([c, p1, p2]), base.lightened(shade) if i < 3 else base.darkened(shade))
		draw_polyline(top + PackedVector2Array([top[0]]), base.darkened(0.6), 2.0, true)
		if found:
			draw_circle(c + Vector2(-r * 0.3, -r * 0.35), r * 0.12, Color(1, 1, 1, 0.7))
		else:
			var f: Font = ThemeDB.fallback_font
			draw_string(f, c + Vector2(-r * 0.25, r * 0.25), "?", HORIZONTAL_ALIGNMENT_LEFT, -1, int(r * 0.9), Color(0.75, 0.78, 0.85))


func open(save_data: Dictionary, slot: int) -> void:
	_save = save_data
	_slot = slot
	_build()
	refresh()


func _build() -> void:
	var bg := ColorRect.new()
	bg.color = Color(0.04, 0.05, 0.09, 0.98)
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
	page.add_theme_constant_override("separation", 10)
	margin.add_child(page)
	var top := HBoxContainer.new()
	top.add_theme_constant_override("separation", 14)
	page.add_child(top)
	_title = U.lbl("PIERRES ÉLÉMENTAIRES", 34, Color(0.75, 0.90, 1.0), true)
	_title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top.add_child(_title)
	var close := U.btn("✕  FERMER", Color(0.95, 0.75, 0.30), 22, Vector2(170, 54))
	close.pressed.connect(func() -> void: closed.emit())
	top.add_child(close)
	var intro := U.lbl("Une Pierre par Nation : battez le boss de la Nation (Tactique, sanctuaire en Aventure ou siège en Conquête). Chaque héros porte 2 Pierres au plus ; éveillez-les avec de l'or et la ressource de leur Nation.", 17, U.C_DIM)
	intro.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	page.add_child(intro)
	_msg = U.lbl("", 18, U.C_GOLD)
	page.add_child(_msg)
	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	TouchScroll.install(scroll)
	page.add_child(scroll)
	_grid = GridContainer.new()
	_grid.columns = 2
	_grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_grid.add_theme_constant_override("h_separation", 12)
	_grid.add_theme_constant_override("v_separation", 12)
	scroll.add_child(_grid)


## Où trouver la Pierre : boss de la Nation + sanctuaire d'Aventure.
func _hint(biome: String) -> String:
	var boss: String = Nations.boss_title(biome)
	var where: String = ""
	var pm: Node = get_node_or_null("/root/ProgressionManager")
	if pm != null:
		for z: String in pm.ADVENTURE_POIS.keys():
			for k: String in pm.ADVENTURE_POIS[z].keys():
				if String(pm.ADVENTURE_POIS[z][k].get("guardian", "")) == biome:
					where = "Aventure : %s (niv %d)" % [String(pm.ADVENTURE_ZONES.get(z, {}).get("name", z)), int(pm.ADVENTURE_POIS[z][k].get("level", 1))]
	return "À retrouver : vaincre %s.%s" % [boss if boss != "" else "le boss de la Nation", ("\n" + where) if where != "" else ""]


func _classes() -> Array[String]:
	var out: Array[String] = []
	for m in _save.get("team", []):
		var c: String = String(m.get("classe", ""))
		if c != "" and not out.has(c):
			out.append(c)
	for c2 in (_save.get("roster", {}) as Dictionary).keys():
		if not out.has(String(c2)):
			out.append(String(c2))
	return out


func _persist() -> void:
	var pm: Node = get_node_or_null("/root/ProgressionManager")
	if pm != null and _slot >= 0:
		pm.write_save(_slot, _save)


func refresh() -> void:
	for c in _grid.get_children():
		c.queue_free()
	_title.text = "PIERRES ÉLÉMENTAIRES   %d / %d" % [Stones.count(_save), Stones.ORDER.size()]
	for b: String in Stones.ORDER:
		_grid.add_child(_card(b))


func _card(biome: String) -> Control:
	var inf: Dictionary = Stones.info(biome)
	var col: Color = inf.get("color", Color.WHITE)
	var found: bool = Stones.has(_save, biome)
	var lv: int = Stones.level(_save, biome)
	var card := PanelContainer.new()
	card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	card.add_theme_stylebox_override("panel", U.box(Color(0.10, 0.12, 0.19, 0.98) if found else Color(0.08, 0.09, 0.12, 0.95),
		col if found else U.C_BORDER, 14, 3 if found else 1, 12))
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 12)
	card.add_child(row)
	var gem := GemIcon.new()
	gem.col = col
	gem.found = found
	gem.lv = lv
	gem.custom_minimum_size = Vector2(96, 96)
	gem.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	row.add_child(gem)
	var col_box := VBoxContainer.new()
	col_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col_box.add_theme_constant_override("separation", 4)
	row.add_child(col_box)
	var name_txt: String = String(inf.get("name", biome))
	var head := U.lbl(name_txt + ("   " + "★".repeat(lv) + "☆".repeat(Stones.MAX_LEVEL - lv) if found else ""), 22, col if found else U.C_DIM, true)
	col_box.add_child(head)
	col_box.add_child(U.lbl("Nation : %s" % Nations.nation_name(biome), 16, U.C_DIM))
	if not found:
		var h := U.lbl(_hint(biome), 16, U.C_DIM)
		h.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		col_box.add_child(h)
		var bl := U.lbl("Bonus : " + ", ".join(Stones.bonus_lines(biome, 1)), 16, Color(0.70, 0.74, 0.82))
		bl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		col_box.add_child(bl)
		return card
	var lore := U.lbl("« %s »" % String(inf.get("lore", "")), 15, Color(0.80, 0.82, 0.90))
	lore.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	col_box.add_child(lore)
	var cur := U.lbl("Bonus : " + ", ".join(Stones.bonus_lines(biome, lv)), 17, U.C_GOOD)
	cur.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	col_box.add_child(cur)
	if lv < Stones.MAX_LEVEL:
		var nx := U.lbl("Éveil %d : " % (lv + 1) + ", ".join(Stones.bonus_lines(biome, lv + 1)), 15, U.C_DIM)
		nx.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		col_box.add_child(nx)
	var actions := HBoxContainer.new()
	actions.add_theme_constant_override("separation", 8)
	col_box.add_child(actions)
	var owner_btn := OptionButton.new()
	owner_btn.custom_minimum_size = Vector2(230, 50)
	owner_btn.add_theme_font_size_override("font_size", 18)
	owner_btn.add_item("— Aucun porteur —")
	var classes: Array[String] = _classes()
	var owner: String = Stones.owner_of(_save, biome)
	for i: int in range(classes.size()):
		var n_worn: int = Stones.stones_of(_save, classes[i]).size()
		owner_btn.add_item("%s  (%d/%d)" % [classes[i], n_worn, Stones.MAX_PER_HERO])
		if classes[i] == owner:
			owner_btn.select(i + 1)
	if owner == "":
		owner_btn.select(0)
	owner_btn.item_selected.connect(func(idx: int) -> void:
		if idx == 0:
			Stones.unequip(_save, biome)
			_msg.text = "%s n'a plus de porteur." % name_txt
		else:
			var err: String = Stones.equip(_save, biome, classes[idx - 1])
			_msg.text = err if err != "" else "%s confiée à %s." % [name_txt, classes[idx - 1]]
		_persist()
		refresh.call_deferred())
	actions.add_child(owner_btn)
	if lv < Stones.MAX_LEVEL:
		var cost: Dictionary = Stones.awaken_cost(_save, biome)
		var ok: bool = Stones.can_awaken(_save, biome) == ""
		var aw := U.btn("✦ Éveiller  %d or + %d %s" % [int(cost["gold"]), int(cost["qty"]), String(cost["res"])],
			col if ok else U.C_BORDER, 17, Vector2(0, 50))
		aw.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		aw.pressed.connect(func() -> void:
			var err2: String = Stones.awaken(_save, biome)
			_msg.text = err2 if err2 != "" else "%s s'éveille (niveau %d) !" % [name_txt, Stones.level(_save, biome)]
			if err2 == "":
				_persist()
			refresh.call_deferred())
		actions.add_child(aw)
	return card
