extends CanvasLayer
## ForgeUI.gd — La Forge (refonte V4) : fenêtre dédiée, lisible et pratique.
##
##  • Filtres par catégorie (avec nombre d'objets fabricables) + « fabricables seulement »
##  • Liste triée : fabricables d'abord ; ressources manquantes en rouge, possédées en vert
##  • Panneau de détail : stats de l'objet forgé comparées à ce que porte le personnage choisi,
##    ressources nécessaires avec barres, boutons FABRIQUER et FABRIQUER ET ÉQUIPER
##  • Les objets forgés sont de qualité RARE (+15 % de stats)

signal closed
signal crafted

const U = preload("res://scripts/UiKit.gd")
const CATEGORIES: Array = [
	["all", "Tout", "✦"], ["arme", "Armes", "⚔"], ["bouclier", "Boucliers", "⛨"], ["casque", "Casques", "⛑"],
	["armure", "Armures", "👕"], ["bottes", "Bottes", "🥾"], ["bague", "Accessoires", "💍"],
]

var _root: Control
var _save: Dictionary = {}
var _slot: int = -1
var _filter: String = "all"
var _only_craftable: bool = false
var _salvage_mode: bool = false
var _selected: String = ""
var _member: int = 0
var _message: String = ""
var _message_ok: bool = true
var _res_row: HBoxContainer
var _filters_box: VBoxContainer
var _list_box: VBoxContainer
var _detail_box: VBoxContainer


func open(save_data: Dictionary, slot: int, member_index: int = 0) -> void:
	_save = save_data
	_slot = slot
	_member = clampi(member_index, 0, maxi(0, _save.get("team", []).size() - 1))
	_build()
	refresh()


func _category_of(recipe: Dictionary) -> String:
	var s: String = ProgressionManager.slot_for_type(String(recipe["type"]))
	return s if s != "" else "bague"


func _team_member() -> Dictionary:
	var team: Array = _save.get("team", [])
	return team[_member] if _member < team.size() else {}


func _build() -> void:
	if _root != null and is_instance_valid(_root):
		_root.queue_free()
	_root = Control.new()
	_root.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(_root)
	var bg := ColorRect.new()
	bg.color = Color(0.07, 0.05, 0.05, 1.0)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	_root.add_child(bg)
	var glow := ColorRect.new()
	glow.color = Color(0.85, 0.40, 0.12, 0.16)
	glow.set_anchors_preset(Control.PRESET_TOP_WIDE)
	glow.offset_bottom = 130
	_root.add_child(glow)
	var margin := MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	for side in ["left", "right"]:
		margin.add_theme_constant_override("margin_" + side, 36)
	margin.add_theme_constant_override("margin_top", 22)
	margin.add_theme_constant_override("margin_bottom", 26)
	_root.add_child(margin)
	var page := VBoxContainer.new()
	page.add_theme_constant_override("separation", 14)
	margin.add_child(page)

	var top := HBoxContainer.new()
	top.add_theme_constant_override("separation", 20)
	page.add_child(top)
	top.add_child(U.lbl("⚒  FORGE", 40, Color(1.0, 0.72, 0.35), true))
	top.add_child(U.spacer())
	var close := U.btn("✕  FERMER", Color(0.95, 0.75, 0.30), 24, Vector2(200, 56))
	close.pressed.connect(func() -> void: closed.emit())
	top.add_child(close)

	# Stock de ressources : toujours visible
	var stock := PanelContainer.new()
	stock.add_theme_stylebox_override("panel", U.box(Color(0.12, 0.09, 0.08), Color(0.55, 0.38, 0.22), 14, 2, 10))
	page.add_child(stock)
	_res_row = HBoxContainer.new()
	_res_row.add_theme_constant_override("separation", 14)
	stock.add_child(_res_row)

	var body := HBoxContainer.new()
	body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body.add_theme_constant_override("separation", 18)
	page.add_child(body)

	var left := PanelContainer.new()
	left.custom_minimum_size = Vector2(270, 0)
	left.add_theme_stylebox_override("panel", U.box(Color(0.10, 0.08, 0.08), Color(0.45, 0.32, 0.20), 18, 2, 12))
	body.add_child(left)
	_filters_box = VBoxContainer.new()
	_filters_box.add_theme_constant_override("separation", 8)
	left.add_child(_filters_box)

	var mid := PanelContainer.new()
	mid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	mid.add_theme_stylebox_override("panel", U.box(Color(0.10, 0.08, 0.08), Color(0.45, 0.32, 0.20), 18, 2, 12))
	body.add_child(mid)
	var mscroll := ScrollContainer.new()
	mscroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	mid.add_child(mscroll)
	_list_box = VBoxContainer.new()
	_list_box.add_theme_constant_override("separation", 8)
	_list_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	mscroll.add_child(_list_box)

	var right := PanelContainer.new()
	right.custom_minimum_size = Vector2(560, 0)
	right.add_theme_stylebox_override("panel", U.box(Color(0.12, 0.09, 0.08), Color(0.85, 0.55, 0.25), 18, 3, 16))
	body.add_child(right)
	var rscroll := ScrollContainer.new()
	rscroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	right.add_child(rscroll)
	_detail_box = VBoxContainer.new()
	_detail_box.add_theme_constant_override("separation", 10)
	_detail_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	rscroll.add_child(_detail_box)


func refresh() -> void:
	_refresh_stock()
	_refresh_filters()
	_refresh_list()
	_refresh_detail()


# ── Stock ───────────────────────────────────────────────────────────────────
func _refresh_stock() -> void:
	for c in _res_row.get_children():
		c.queue_free()
	_res_row.add_child(U.lbl("Votre stock :", 20, U.C_DIM))
	var res: Dictionary = ProgressionManager.resources(_save)
	for k: String in ["Fer", "Bois", "Cuir", "Magie", "Venin"]:
		var col: Color = U.RES_COLOR.get(k, U.C_TXT)
		_res_row.add_child(U.chip("%s %s  %d" % [U.RES_ICON.get(k, ""), k, int(res.get(k, 0))], col, 21))
	_res_row.add_child(U.spacer())
	_res_row.add_child(U.chip("🪙  %d or" % ProgressionManager.gold(_save), U.C_GOLD, 24))


# ── Filtres ─────────────────────────────────────────────────────────────────
func _counts() -> Dictionary:
	var out: Dictionary = {}
	for r: Dictionary in ProgressionManager.craft_recipes():
		var cat: String = _category_of(r)
		var ok: bool = bool(ProgressionManager.craft_status(_save, r)["craftable"])
		for key: String in [cat, "all"]:
			if not out.has(key):
				out[key] = [0, 0]
			out[key][1] += 1
			if ok:
				out[key][0] += 1
	return out


func _refresh_filters() -> void:
	for c in _filters_box.get_children():
		c.queue_free()
	_filters_box.add_child(U.lbl("CATÉGORIES", 17, U.C_DIM))
	var counts: Dictionary = _counts()
	for cat: Array in CATEGORIES:
		var key: String = String(cat[0])
		var cnt: Array = counts.get(key, [0, 0])
		if key != "all" and int(cnt[1]) == 0:
			continue
		var b := U.btn("%s  %s   %d/%d" % [cat[2], cat[1], int(cnt[0]), int(cnt[1])],
			Color(0.95, 0.65, 0.30) if _filter == key else U.C_BORDER, 21, Vector2(0, 52))
		b.alignment = HORIZONTAL_ALIGNMENT_LEFT
		b.tooltip_text = "Fabricables / total"
		b.pressed.connect(func() -> void:
			_filter = key
			refresh())
		_filters_box.add_child(b)
	_filters_box.add_child(Control.new())
	var t := U.btn("✓  Fabricables seulement" if _only_craftable else "☐  Fabricables seulement",
		Color(0.45, 0.80, 0.50) if _only_craftable else U.C_BORDER, 19, Vector2(0, 52))
	t.pressed.connect(func() -> void:
		_only_craftable = not _only_craftable
		refresh())
	_filters_box.add_child(t)
	var s := U.btn("⚒  BRISAGE D’ÉQUIPEMENT" if not _salvage_mode else "←  RETOUR À LA FORGE",
		Color(0.85, 0.45, 0.35) if _salvage_mode else U.C_BORDER, 19, Vector2(0, 52))
	s.pressed.connect(func() -> void:
		_salvage_mode = not _salvage_mode
		_selected = ""
		refresh())
	_filters_box.add_child(s)
	var help := U.lbl("Les ennemis lâchent des ressources à chaque victoire. Un objet forgé est de qualité RARE (+15 % de stats).", 15, U.C_DIM)
	help.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	help.custom_minimum_size = Vector2(240, 0)
	_filters_box.add_child(help)


# ── Liste des recettes ──────────────────────────────────────────────────────
func _visible_recipes() -> Array:
	var out: Array = []
	for r: Dictionary in ProgressionManager.craft_recipes():
		if _filter != "all" and _category_of(r) != _filter:
			continue
		var st: Dictionary = ProgressionManager.craft_status(_save, r)
		if _only_craftable and not bool(st["craftable"]):
			continue
		out.append({"r": r, "st": st})
	out.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
		if bool(a["st"]["craftable"]) != bool(b["st"]["craftable"]):
			return bool(a["st"]["craftable"])
		if int(a["r"]["level"]) != int(b["r"]["level"]):
			return int(a["r"]["level"]) < int(b["r"]["level"])
		return String(a["r"]["name"]) < String(b["r"]["name"]))
	return out


func _refresh_list() -> void:
	for c in _list_box.get_children():
		c.queue_free()
	if _salvage_mode:
		_refresh_salvage_list()
		return
	var rows: Array = _visible_recipes()
	if rows.is_empty():
		_list_box.add_child(U.lbl("Aucune recette ne correspond.", 22, U.C_DIM))
		return
	if _selected == "" or not rows.any(func(x: Dictionary) -> bool: return String(x["r"]["name"]) == _selected):
		_selected = String(rows[0]["r"]["name"])
	for row: Dictionary in rows:
		_list_box.add_child(_recipe_row(row["r"], row["st"]))


func _recipe_row(r: Dictionary, st: Dictionary) -> Control:
	var ok: bool = bool(st["craftable"])
	var sel: bool = String(r["name"]) == _selected
	var item: Dictionary = ProgressionManager.forged_item(r)
	var b := Button.new()
	b.custom_minimum_size = Vector2(0, 92)
	b.focus_mode = Control.FOCUS_NONE
	var edge: Color = Color(0.45, 0.88, 0.50) if ok else Color(0.40, 0.30, 0.25)
	b.add_theme_stylebox_override("normal", U.box(Color(0.17, 0.13, 0.11) if sel else Color(0.13, 0.10, 0.09), Color(1.0, 0.75, 0.35) if sel else edge, 14, 3 if sel else 2, 10))
	b.add_theme_stylebox_override("hover", U.box(Color(0.20, 0.15, 0.12), Color(1.0, 0.85, 0.5), 14, 3, 10))
	b.add_theme_stylebox_override("pressed", U.box(Color(0.20, 0.15, 0.12), Color(1.0, 0.75, 0.35), 14, 3, 10))
	b.pressed.connect(func() -> void:
		_selected = String(r["name"])
		_message = ""
		refresh())
	var h := HBoxContainer.new()
	h.mouse_filter = Control.MOUSE_FILTER_IGNORE
	h.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	h.offset_left = 12
	h.offset_right = -12
	h.offset_top = 6
	h.offset_bottom = -6
	h.add_theme_constant_override("separation", 14)
	b.add_child(h)
	var icon := U.lbl(String(U.SLOT_ICON.get(_category_of(r), "✦")), 38, U.C_TXT)
	icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	icon.custom_minimum_size = Vector2(52, 0)
	icon.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	h.add_child(icon)
	var info := VBoxContainer.new()
	info.mouse_filter = Control.MOUSE_FILTER_IGNORE
	info.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	info.alignment = BoxContainer.ALIGNMENT_CENTER
	info.add_theme_constant_override("separation", 2)
	h.add_child(info)
	var nm := U.lbl(String(r["name"]), 23, U.C_TXT)
	nm.mouse_filter = Control.MOUSE_FILTER_IGNORE
	info.add_child(nm)
	var sub := U.lbl("%s · niv. %d · %s" % [r["type"], int(r["level"]), ItemRules.stat_line(item)], 15, U.C_DIM)
	sub.mouse_filter = Control.MOUSE_FILTER_IGNORE
	info.add_child(sub)
	# Coûts
	var costs := VBoxContainer.new()
	costs.mouse_filter = Control.MOUSE_FILTER_IGNORE
	costs.alignment = BoxContainer.ALIGNMENT_CENTER
	costs.add_theme_constant_override("separation", 2)
	h.add_child(costs)
	var res: Dictionary = ProgressionManager.resources(_save)
	var line1 := HBoxContainer.new()
	line1.mouse_filter = Control.MOUSE_FILTER_IGNORE
	line1.add_theme_constant_override("separation", 10)
	line1.alignment = BoxContainer.ALIGNMENT_END
	costs.add_child(line1)
	for k: String in r["cost"].keys():
		var have: int = int(res.get(k, 0))
		var need: int = int(r["cost"][k])
		var l := U.lbl("%s %d/%d" % [U.RES_ICON.get(k, ""), have, need], 19, U.C_GOOD if have >= need else U.C_BAD)
		l.mouse_filter = Control.MOUSE_FILTER_IGNORE
		l.tooltip_text = k
		line1.add_child(l)
	if int(r["gold"]) > 0:
		var g := U.lbl("🪙 %d" % int(r["gold"]), 19, U.C_GOOD if int(st["gold_missing"]) == 0 else U.C_BAD)
		g.mouse_filter = Control.MOUSE_FILTER_IGNORE
		line1.add_child(g)
	var state := U.lbl("✓ Fabricable" if ok else "✗ Manque des ressources", 16, U.C_GOOD if ok else U.C_BAD)
	state.mouse_filter = Control.MOUSE_FILTER_IGNORE
	state.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	costs.add_child(state)
	return b


# ── Détail ──────────────────────────────────────────────────────────────────
# ── Brisage d’équipement ──────────────────────────────────────

## Objets de l’inventaire cassables, triés par rareté puis niveau.
func _salvage_rows() -> Array:
	var out: Array = []
	var inv: Array = _save.get("inventory", [])
	for i: int in range(inv.size()):
		out.append({"i": i, "it": inv[i]})
	out.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
		var ra: int = ItemRules.RARITY_ORDER.find(String(a["it"].get("rarity", "commun")))
		var rb: int = ItemRules.RARITY_ORDER.find(String(b["it"].get("rarity", "commun")))
		if ra != rb:
			return ra > rb
		return int(a["it"].get("level", 0)) > int(b["it"].get("level", 0)))
	return out

func _refresh_salvage_list() -> void:
	var rows: Array = _salvage_rows()
	if rows.is_empty():
		_list_box.add_child(U.lbl("Aucun objet à briser : gagnez des combats pour looter de l’équipement.", 20, U.C_DIM))
		return
	for row: Dictionary in rows:
		var it: Dictionary = row["it"]
		var b := Button.new()
		b.custom_minimum_size = Vector2(0, 60)
		b.focus_mode = Control.FOCUS_NONE
		b.alignment = HORIZONTAL_ALIGNMENT_LEFT
		b.text = "  ⚒ [%s] %s (nv%d) — %s" % [ItemRules.rarity_label(it), String(it.get("name", "?")),
			int(it.get("level", 0)), ItemRules.stat_line(it)]
		b.tooltip_text = "Briser cet objet : détruit et rend des ressources selon la rareté (ici %s)." % ItemRules.rarity_label(it)
		b.add_theme_font_size_override("font_size", 17)
		b.add_theme_color_override("font_color", ItemRules.rarity_color(it).lightened(0.25))
		b.add_theme_stylebox_override("normal", U.box(Color(0.13, 0.09, 0.08), Color(0.85, 0.45, 0.35), 12, 2, 10))
		b.add_theme_stylebox_override("hover", U.box(Color(0.20, 0.12, 0.10), Color(1.0, 0.6, 0.45), 12, 3, 10))
		b.pressed.connect(_on_salvage_pressed.bind(it))
		_list_box.add_child(b)

func _on_salvage_pressed(it: Dictionary) -> void:
	## Les index bougent après chaque brisage : retrouver l’objet à l’instant du clic.
	var inv_now: Array = _save.get("inventory", [])
	var live_idx: int = -1
	for k: int in range(inv_now.size()):
		if String(inv_now[k].get("name", "")) == String(it.get("name", "")) and int(inv_now[k].get("level", -1)) == int(it.get("level", -1)) and String(inv_now[k].get("rarity", "")) == String(it.get("rarity", "")):
			live_idx = k
			break
	if live_idx < 0:
		return
	var result: Dictionary = ProgressionManager.salvage_item(_save, live_idx)
	if not bool(result.get("ok", false)):
		return
	ProgressionManager.write_save(_slot, _save)
	var gains: Dictionary = result.get("gains", {})
	var parts: Array = []
	for r: String in gains.keys():
		parts.append("%s +%d" % [r, int(gains[r])])
	crafted.emit()
	refresh()
	_detail_box.add_child(U.lbl("⚒ Brié : %s%sGains : %s" % [String(it.get("name", "?")), chr(10), " · ".join(PackedStringArray(parts))], 18, Color(0.9, 0.75, 0.4)))

func _refresh_detail() -> void:
	if _salvage_mode:
		for c in _detail_box.get_children():
			c.queue_free()
		_detail_box.add_child(U.lbl("Sélectionnez un objet à briser dans la liste :%s il sera détruit et rendra des ressources selon sa rareté et son niveau." % chr(10), 18, U.C_DIM))
		return
	for c in _detail_box.get_children():
		c.queue_free()
	var r: Dictionary = ProgressionManager.craft_recipe(_selected)
	if r.is_empty():
		_detail_box.add_child(U.lbl("Sélectionnez une recette.", 22, U.C_DIM))
		return
	var st: Dictionary = ProgressionManager.craft_status(_save, r)
	var item: Dictionary = ProgressionManager.forged_item(r)
	var rc: Color = ItemRules.rarity_color(item)
	var head := HBoxContainer.new()
	head.add_theme_constant_override("separation", 12)
	_detail_box.add_child(head)
	head.add_child(U.lbl(String(U.SLOT_ICON.get(_category_of(r), "✦")), 54, U.C_TXT))
	var hv := VBoxContainer.new()
	hv.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	head.add_child(hv)
	var nm := U.lbl(String(r["name"]), 30, rc.lightened(0.2), true)
	nm.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	hv.add_child(nm)
	hv.add_child(U.lbl("%s · niveau %d · %s" % [r["type"], int(r["level"]), ItemRules.rarity_label(item)], 17, U.C_DIM))

	# Choix du personnage : comparaison + équipement direct
	_detail_box.add_child(U.lbl("POUR QUI ?", 15, U.C_DIM))
	var who := HBoxContainer.new()
	who.add_theme_constant_override("separation", 8)
	_detail_box.add_child(who)
	var team: Array = _save.get("team", [])
	for i: int in range(team.size()):
		var classe: String = String(team[i].get("classe", ""))
		var lvl: int = ProgressionManager.member_level(_save, classe)
		var b := U.btn("", Color(0.95, 0.65, 0.30) if i == _member else U.C_BORDER, 18, Vector2(0, 74))
		b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		var v := VBoxContainer.new()
		v.mouse_filter = Control.MOUSE_FILTER_IGNORE
		v.alignment = BoxContainer.ALIGNMENT_CENTER
		v.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		b.add_child(v)
		var pic := U.portrait(classe, 38.0)
		pic.mouse_filter = Control.MOUSE_FILTER_IGNORE
		pic.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		v.add_child(pic)
		var cl := U.lbl("%s niv %d" % [classe, lvl], 14, U.C_TXT)
		cl.mouse_filter = Control.MOUSE_FILTER_IGNORE
		cl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		v.add_child(cl)
		b.pressed.connect(func() -> void:
			_member = i
			_message = ""
			refresh())
		who.add_child(b)

	var member: Dictionary = _team_member()
	var slot: String = ProgressionManager.slot_for_type(String(r["type"]))
	var cur: Dictionary = member.get("equipment", {}).get(slot, {})
	var mlevel: int = ProgressionManager.member_level(_save, String(member.get("classe", "")))
	var can_wear: bool = int(item.get("level", 1)) <= mlevel
	_detail_box.add_child(U.lbl("Porte actuellement : %s" % (String(cur.get("name", "")) if not cur.is_empty() else "rien"), 16, U.C_DIM))

	# Stats avec écarts
	var stats := GridContainer.new()
	stats.columns = 2
	stats.add_theme_constant_override("h_separation", 12)
	stats.add_theme_constant_override("v_separation", 6)
	_detail_box.add_child(stats)
	for k: String in ItemRules.STAT_KEYS:
		var nv: int = int(item.get(k, 0))
		var cv: int = int(cur.get(k, 0))
		if nv == 0 and cv == 0:
			continue
		var d: int = nv - cv
		var txt: String = "%s  %d" % [ItemRules.STAT_NAME[k], nv]
		var line := HBoxContainer.new()
		line.add_theme_constant_override("separation", 8)
		line.add_child(U.lbl(txt, 20, U.C_TXT))
		if not cur.is_empty() or d != 0:
			var dl := U.lbl("(%+d)" % d if d != 0 else "(=)", 18, U.C_GOOD if d > 0 else (U.C_BAD if d < 0 else U.C_DIM))
			line.add_child(dl)
		stats.add_child(line)
	for l: String in ItemRules.fx_lines(ItemRules.parse_effect(String(item.get("effect", "")))):
		_detail_box.add_child(U.lbl("✦ " + l, 18, Color(0.75, 0.65, 1.0)))
	var sk: String = ItemRules.set_key(String(item.get("name", "")))
	if sk != "":
		_detail_box.add_child(U.lbl("◈ " + String(ItemRules.SETS[sk]["label"]), 17, Color(0.75, 0.65, 1.0)))

	# Ressources nécessaires
	_detail_box.add_child(U.lbl("RESSOURCES", 15, U.C_DIM))
	var res: Dictionary = ProgressionManager.resources(_save)
	for k: String in r["cost"].keys():
		var have: int = int(res.get(k, 0))
		var need: int = int(r["cost"][k])
		var row := HBoxContainer.new()
		row.add_theme_constant_override("separation", 10)
		_detail_box.add_child(row)
		var name_l := U.lbl("%s %s" % [U.RES_ICON.get(k, ""), k], 20, U.RES_COLOR.get(k, U.C_TXT))
		name_l.custom_minimum_size = Vector2(120, 0)
		row.add_child(name_l)
		var pb := ProgressBar.new()
		pb.custom_minimum_size = Vector2(190, 18)
		pb.show_percentage = false
		pb.max_value = float(need)
		pb.value = float(mini(have, need))
		pb.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		U.style_bar(pb, U.C_GOOD if have >= need else U.C_BAD)
		row.add_child(pb)
		row.add_child(U.lbl("%d / %d" % [have, need], 20, U.C_GOOD if have >= need else U.C_BAD))
	if int(r["gold"]) > 0:
		var gr := HBoxContainer.new()
		gr.add_theme_constant_override("separation", 10)
		_detail_box.add_child(gr)
		var gl := U.lbl("🪙 Or", 20, U.C_GOLD)
		gl.custom_minimum_size = Vector2(120, 0)
		gr.add_child(gl)
		var have_g: int = ProgressionManager.gold(_save)
		gr.add_child(U.lbl("%d / %d" % [have_g, int(r["gold"])], 20, U.C_GOOD if have_g >= int(r["gold"]) else U.C_BAD))

	# Message d'état
	var craftable: bool = bool(st["craftable"])
	var status_txt: String = ""
	var status_col: Color = U.C_GOOD
	if not craftable:
		var parts: Array[String] = []
		for k: String in st["missing"].keys():
			parts.append("%d %s" % [int(st["missing"][k]), k])
		if int(st["gold_missing"]) > 0:
			parts.append("%d or" % int(st["gold_missing"]))
		status_txt = "Il manque : " + ", ".join(PackedStringArray(parts))
		status_col = U.C_BAD
	elif not can_wear:
		status_txt = "%s est niveau %d : niveau %d requis pour porter cet objet." % [member.get("classe", "?"), mlevel, int(item.get("level", 1))]
		status_col = Color(1.0, 0.8, 0.4)
	else:
		status_txt = "Prêt à forger !"
	var sl := U.lbl(status_txt, 19, status_col)
	sl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	sl.custom_minimum_size = Vector2(500, 0)
	_detail_box.add_child(sl)

	var b1 := U.btn("⚒  FABRIQUER", Color(0.95, 0.65, 0.30), 24, Vector2(0, 60))
	b1.disabled = not craftable
	b1.pressed.connect(func() -> void:
		var err: String = ProgressionManager.craft_item(_save, _selected)
		_after_craft(err, "%s fabriqué (dans l'inventaire)." % _selected))
	_detail_box.add_child(b1)
	var cname: String = String(member.get("classe", "?"))
	var b2 := U.btn("⚒  FABRIQUER ET ÉQUIPER (%s)" % cname, Color(0.45, 0.80, 0.50), 22, Vector2(0, 60))
	b2.disabled = not craftable or not can_wear
	b2.pressed.connect(func() -> void:
		var err: String = ProgressionManager.craft_and_equip(_save, _selected, _member)
		_after_craft(err, "%s fabriqué et équipé sur %s !" % [_selected, cname]))
	_detail_box.add_child(b2)
	if _message != "":
		var ml := U.lbl(_message, 20, U.C_GOOD if _message_ok else U.C_BAD)
		ml.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		ml.custom_minimum_size = Vector2(500, 0)
		_detail_box.add_child(ml)


func _after_craft(err: String, ok_msg: String) -> void:
	_message_ok = err == "" or err.begins_with("Objet fabriqué")
	_message = ok_msg if err == "" else err
	if _message_ok:
		ProgressionManager.write_save(_slot, _save)
		crafted.emit()
	refresh()
