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

const ART := "res://assets/ui/forge/"
## Agrandissement global de la Forge : l'écran de référence fait 1920x1080 et il est
## réduit sur smartphone ; on construit l'interface sur une surface plus petite
## (≈1370x770) puis on l'agrandit, ce qui grossit textes, icônes et zones tactiles.
const UI_SCALE := 1.4

var _root: Control
var _save: Dictionary = {}
var _slot: int = -1
var _filter: String = "all"
var _only_craftable: bool = false
var _mode: String = "craft"      # craft | upgrade | fusion | salvage
var _tier: int = 1                # rang de fabrication (1..10)
var _up_key: String = ""
var _fuse_max: bool = false        # Fusion : ×1 ou « tout fusionner »
var _salv_sel: Dictionary = {}
var _ach_seen: Dictionary = {}      # succès déjà connus à l'ouverture (pour annoncer les nouveaux)     # objet sélectionné au Briseur          # objet sélectionné en mode amélioration
var _tabs_row: HBoxContainer
var _selected: String = ""
var _member: int = 0
var _message: String = ""
var _message_ok: bool = true
var _title_lbl: Label
var _sub_lbl: Label
var _res_row: HBoxContainer
var _filters_box: VBoxContainer   # barre de filtres (au-dessus de la liste)
var _list_box: VBoxContainer
var _detail_box: VBoxContainer
var _actions: VBoxContainer       # boutons d'action, toujours visibles en bas du panneau


func open(save_data: Dictionary, slot: int, member_index: int = 0) -> void:
	_save = save_data
	_slot = slot
	_ach_seen = (_save.get("achievements", {}) as Dictionary).duplicate()
	_member = clampi(member_index, 0, maxi(0, _save.get("team", []).size() - 1))
	_build()
	refresh()


## Ouvre la Forge directement sur un onglet (craft | upgrade | fusion | salvage).
func show_mode(mode: String) -> void:
	if not ["craft", "upgrade", "fusion", "salvage"].has(mode):
		return
	_mode = mode
	_message = ""
	refresh()


func _tex(path: String) -> Texture2D:
	return load(path) as Texture2D if ResourceLoader.exists(path) else null


## Tuile d'icône d'une catégorie d'équipement (arme, bouclier, casque, armure, bottes, bague, all).
func _tile(cat: String, px: float) -> TextureRect:
	var t := TextureRect.new()
	t.texture = _tex(ART + "cat_%s.png" % (cat if ["arme", "bouclier", "casque", "armure", "bottes", "bague", "all"].has(cat) else "bague"))
	t.custom_minimum_size = Vector2(px, px)
	t.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	t.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	t.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return t


## Icône de ressource (lingot, bûche, cuir, cristal, fiole).
func _res_icon(k: String, px: float) -> TextureRect:
	var t := TextureRect.new()
	t.texture = _tex(ART + "res_%s.png" % k)
	t.custom_minimum_size = Vector2(px, px)
	t.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	t.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	t.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return t


## « [icône] texte » dans une ligne.
func _res_label(k: String, text: String, col: Color, size: int, icon_px: float = 26.0) -> HBoxContainer:
	var h := HBoxContainer.new()
	h.mouse_filter = Control.MOUSE_FILTER_IGNORE
	h.add_theme_constant_override("separation", 5)
	h.add_child(_res_icon(_res_name(k), icon_px))
	var l := U.lbl(text, size, col)
	l.mouse_filter = Control.MOUSE_FILTER_IGNORE
	l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	h.add_child(l)
	return h


## « Fer@3 » → « Fer » ; rang d'une clé de ressource.
func _res_name(k: String) -> String:
	return k.split("@")[0]


func _res_tier(k: String) -> int:
	var parts: PackedStringArray = k.split("@")
	return int(parts[1]) if parts.size() > 1 else 1


## Libellé d'une ressource avec son rang : « Fer R3 ».
func _res_text(k: String) -> String:
	var t: int = _res_tier(k)
	return "%s R%d" % [_res_name(k), t] if t > 1 else _res_name(k)


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
	add_child(_root)
	UiFit.apply(_root, 1.25, Vector2(1370, 770))
	var bg := TextureRect.new()
	bg.texture = _tex(ART + "bg.jpg")
	bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	bg.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	_root.add_child(bg)
	if bg.texture == null:
		var flat := ColorRect.new()
		flat.color = Color(0.07, 0.05, 0.05, 1.0)
		flat.set_anchors_preset(Control.PRESET_FULL_RECT)
		_root.add_child(flat)
	var margin := MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	for side in ["left", "right"]:
		margin.add_theme_constant_override("margin_" + side, 18)
	margin.add_theme_constant_override("margin_top", 10)
	margin.add_theme_constant_override("margin_bottom", 12)
	_root.add_child(margin)
	var page := VBoxContainer.new()
	page.add_theme_constant_override("separation", 8)
	margin.add_child(page)

	var top := HBoxContainer.new()
	top.add_theme_constant_override("separation", 20)
	page.add_child(top)
	var emblem := TextureRect.new()
	emblem.texture = _tex(ART + "emblem.png")
	emblem.custom_minimum_size = Vector2(60, 60)
	emblem.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	emblem.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	top.add_child(emblem)
	var titles := VBoxContainer.new()
	titles.alignment = BoxContainer.ALIGNMENT_CENTER
	titles.add_theme_constant_override("separation", 0)
	top.add_child(titles)
	_title_lbl = U.lbl("FORGE", 34, Color(1.0, 0.76, 0.38), true)
	titles.add_child(_title_lbl)
	_sub_lbl = U.lbl("Fabriquer de l'équipement", 17, Color(0.85, 0.72, 0.55))
	titles.add_child(_sub_lbl)
	top.add_child(U.spacer())
	var close := U.btn("✕  FERMER", Color(0.95, 0.75, 0.30), 22, Vector2(160, 52))
	close.pressed.connect(func() -> void: closed.emit())
	top.add_child(close)

	# Stock de ressources : toujours visible
	var stock := PanelContainer.new()
	stock.add_theme_stylebox_override("panel", U.box(Color(0.12, 0.09, 0.08, 0.90), Color(0.78, 0.55, 0.28), 14, 3, 6))
	page.add_child(stock)
	_res_row = HBoxContainer.new()
	_res_row.add_theme_constant_override("separation", 14)
	stock.add_child(_res_row)

	_tabs_row = HBoxContainer.new()
	_tabs_row.add_theme_constant_override("separation", 10)
	page.add_child(_tabs_row)

	var body := HBoxContainer.new()
	body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body.add_theme_constant_override("separation", 18)
	page.add_child(body)

	var mid := PanelContainer.new()
	mid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	mid.add_theme_stylebox_override("panel", U.box(Color(0.09, 0.07, 0.07, 0.88), Color(0.62, 0.43, 0.24), 18, 3, 10))
	body.add_child(mid)
	var midv := VBoxContainer.new()
	midv.add_theme_constant_override("separation", 8)
	mid.add_child(midv)
	_filters_box = VBoxContainer.new()
	_filters_box.add_theme_constant_override("separation", 6)
	midv.add_child(_filters_box)
	var mscroll := ScrollContainer.new()
	TouchScroll.install(mscroll)
	mscroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	mscroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	midv.add_child(mscroll)
	_list_box = VBoxContainer.new()
	_list_box.add_theme_constant_override("separation", 8)
	_list_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	mscroll.add_child(_list_box)

	var right := PanelContainer.new()
	right.custom_minimum_size = Vector2(530, 0)
	right.add_theme_stylebox_override("panel", U.box(Color(0.11, 0.08, 0.07, 0.92), Color(0.95, 0.62, 0.28), 18, 4, 12))
	body.add_child(right)
	var rightv := VBoxContainer.new()
	rightv.add_theme_constant_override("separation", 8)
	right.add_child(rightv)
	var rscroll := ScrollContainer.new()
	TouchScroll.install(rscroll)
	rscroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	rscroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	rightv.add_child(rscroll)
	_actions = VBoxContainer.new()
	_actions.add_theme_constant_override("separation", 6)
	rightv.add_child(_actions)
	_detail_box = VBoxContainer.new()
	_detail_box.add_theme_constant_override("separation", 10)
	_detail_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	rscroll.add_child(_detail_box)


const MODES: Array = [
	["craft", "Fabriquer", "arme"], ["upgrade", "Améliorer", "casque"],
	["fusion", "Fusion", "bague"], ["salvage", "Briseur", "bottes"],
]
const MODE_SUB := {
	"craft": "Fabriquer de l'équipement (rang 1 à 10)",
	"upgrade": "Monter un équipement d'un rang avec des ressources de rang supérieur",
	"fusion": "Fondre 2 ressources identiques en 1 ressource de rang supérieur",
	"salvage": "Briser de l'équipement pour récupérer des ressources",
}


func refresh() -> void:
	# Succès débloqués par la dernière action (fabrication, fusion, amélioration)
	var ach: Dictionary = _save.get("achievements", {})
	var new_names: PackedStringArray = []
	for id: String in ach.keys():
		if not _ach_seen.has(id):
			_ach_seen[id] = true
			for a: Array in Achievements.LIST:
				if String(a[0]) == id:
					new_names.append("%s (%s)" % [a[1], Achievements.reward_text(a[5])])
	if not new_names.is_empty():
		_message = (_message + "\n" if _message != "" else "") + "🏆 Succès : " + ", ".join(new_names)
		_message_ok = true
		Sfx.play("achievement")
		Sfx.buzz(60)
	if _title_lbl != null:
		_title_lbl.text = "FORGE" if _mode == "craft" else "FORGE · %s" % String(MODES[MODES.map(func(m: Array) -> String: return String(m[0])).find(_mode)][1]).to_upper()
		_sub_lbl.text = String(MODE_SUB[_mode])
	_refresh_stock()
	_refresh_tabs()
	_refresh_filters()
	_refresh_list()
	_refresh_detail()


func _refresh_tabs() -> void:
	for c in _tabs_row.get_children():
		c.queue_free()
	for m: Array in MODES:
		var key: String = String(m[0])
		var b := U.btn("  %s" % m[1], Color(0.95, 0.65, 0.30) if _mode == key else U.C_BORDER, 22, Vector2(0, 54))
		b.icon = _tex(ART + "cat_%s.png" % m[2])
		b.expand_icon = true
		b.add_theme_constant_override("icon_max_width", 40)
		b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		b.pressed.connect(func() -> void:
			_mode = key
			_selected = ""
			_up_key = ""
			_salv_sel = {}
			_message = ""
			refresh())
		_tabs_row.add_child(b)


# ── Stock ───────────────────────────────────────────────────────────────────
func _refresh_stock() -> void:
	for c in _res_row.get_children():
		c.queue_free()
	var res: Dictionary = ProgressionManager.resources(_save)
	for k: String in ["Fer", "Bois", "Cuir", "Magie", "Venin"]:
		var col: Color = U.RES_COLOR.get(k, U.C_TXT)
		var chip := PanelContainer.new()
		chip.add_theme_stylebox_override("panel", U.box(Color(0.16, 0.12, 0.10), col.darkened(0.2), 12, 2, 6))
		chip.tooltip_text = k
		var hi: int = 0
		for t: int in range(2, ProgressionManager.MAX_RANK + 1):
			hi += int(res.get(ProgressionManager.res_key(k, t), 0))
		var txt: String = "%d" % int(res.get(k, 0))
		if hi > 0:
			txt += "  +%d★" % hi
			chip.tooltip_text = "%s : %d (rang 1) + %d de rang supérieur" % [k, int(res.get(k, 0)), hi]
		chip.add_child(_res_label(k, txt, col.lightened(0.15), 24, 34.0))
		_res_row.add_child(chip)
	_res_row.add_child(U.spacer())
	_res_row.add_child(U.chip("🪙  %d" % ProgressionManager.gold(_save), U.C_GOLD, 24))


# ── Filtres ─────────────────────────────────────────────────────────────────
func _counts() -> Dictionary:
	var out: Dictionary = {}
	for r: Dictionary in ProgressionManager.craft_recipes():
		var cat: String = _category_of(r)
		var ok: bool = bool(ProgressionManager.craft_status(_save, r, _tier)["craftable"])
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
	_filters_box.visible = _mode == "craft"
	if _mode != "craft":
		return
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 6)
	_filters_box.add_child(row)
	var counts: Dictionary = _counts()
	for cat: Array in CATEGORIES:
		var key: String = String(cat[0])
		var cnt: Array = counts.get(key, [0, 0])
		if key != "all" and int(cnt[1]) == 0:
			continue
		var b := U.btn("%d" % int(cnt[0]), Color(0.95, 0.65, 0.30) if _filter == key else U.C_BORDER, 20, Vector2(0, 56))
		b.icon = _tex(ART + "cat_%s.png" % key)
		b.expand_icon = true
		b.add_theme_constant_override("icon_max_width", 38)
		b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		b.tooltip_text = "%s : %d fabricables sur %d" % [cat[1], int(cnt[0]), int(cnt[1])]
		b.pressed.connect(func() -> void:
			_filter = key
			refresh())
		row.add_child(b)
	var row2 := HBoxContainer.new()
	row2.add_theme_constant_override("separation", 10)
	_filters_box.add_child(row2)
	var cat_name: String = "Tout"
	for cat: Array in CATEGORIES:
		if String(cat[0]) == _filter:
			cat_name = String(cat[1])
	var cnt_all: Array = counts.get(_filter, [0, 0])
	var info := U.lbl("%s : %d fabricable(s) sur %d · rang %d" % [cat_name, int(cnt_all[0]), int(cnt_all[1]), _tier], 18, U.C_DIM)
	info.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	info.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	row2.add_child(info)
	var t := U.btn("✓ Fabricables" if _only_craftable else "☐ Fabricables",
		Color(0.45, 0.80, 0.50) if _only_craftable else U.C_BORDER, 18, Vector2(190, 46))
	t.pressed.connect(func() -> void:
		_only_craftable = not _only_craftable
		refresh())
	row2.add_child(t)


# ── Liste des recettes ──────────────────────────────────────────────────────
func _visible_recipes() -> Array:
	var out: Array = []
	for r: Dictionary in ProgressionManager.craft_recipes():
		if _filter != "all" and _category_of(r) != _filter:
			continue
		var st: Dictionary = ProgressionManager.craft_status(_save, r, _tier)
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
	match _mode:
		"salvage":
			_refresh_salvage_list()
			return
		"upgrade":
			_refresh_upgrade_list()
			return
		"fusion":
			_refresh_fusion_list()
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
	var item: Dictionary = ProgressionManager.forged_item_ranked(r, _tier)
	var b := Button.new()
	b.custom_minimum_size = Vector2(0, 98)
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
	var icon := _tile(_category_of(r), 68.0)
	icon.size_flags_vertical = Control.SIZE_SHRINK_CENTER
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
	var sub := U.lbl("%s · niv. %d · %s" % [r["type"], int(r["level"]), ItemRules.stat_line(item)], 17, U.C_DIM)
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
	for k: String in st["cost"].keys():
		var have: int = int(res.get(k, 0))
		var need: int = int(st["cost"][k])
		var l: HBoxContainer = _res_label(k, "%d/%d" % [have, need], U.C_GOOD if have >= need else U.C_BAD, 19, 24.0)
		l.tooltip_text = _res_text(k)
		line1.add_child(l)
	if int(st["gold"]) > 0:
		var g := U.lbl("🪙 %d" % int(st["gold"]), 19, U.C_GOOD if int(st["gold_missing"]) == 0 else U.C_BAD)
		g.mouse_filter = Control.MOUSE_FILTER_IGNORE
		line1.add_child(g)
	var state := U.lbl("✓ Fabricable" if ok else "✗ Manque des ressources", 17, U.C_GOOD if ok else U.C_BAD)
	state.mouse_filter = Control.MOUSE_FILTER_IGNORE
	state.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	costs.add_child(state)
	return b


# ── Détail ──────────────────────────────────────────────────────────────────
# ── Briseur d’équipement ──────────────────────────────────────

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
		var e := U.lbl("Aucun objet à briser : gagnez des combats pour looter de l’équipement.", 20, U.C_DIM)
		e.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		_list_box.add_child(e)
		_salv_sel = {}
		return
	if _salv_sel.is_empty() or not rows.any(func(x: Dictionary) -> bool: return x["it"] == _salv_sel):
		_salv_sel = rows[0]["it"]
	for row: Dictionary in rows:
		var it: Dictionary = row["it"]
		var sel: bool = it == _salv_sel
		var b := Button.new()
		b.custom_minimum_size = Vector2(0, 84)
		b.focus_mode = Control.FOCUS_NONE
		b.alignment = HORIZONTAL_ALIGNMENT_LEFT
		b.text = "%s\n%s · niv. %d · %s" % [ItemRules.display_name(it), ItemRules.rarity_label(it),
			int(it.get("level", 0)), ItemRules.stat_line(it)]
		b.add_theme_font_size_override("font_size", 19)
		for st_name in ["font_color", "font_hover_color", "font_pressed_color"]:
			b.add_theme_color_override(st_name, ItemRules.rarity_color(it).lightened(0.3))
		var st_n: StyleBoxFlat = U.box(Color(0.20, 0.12, 0.10, 0.95) if sel else Color(0.13, 0.09, 0.08, 0.92),
			Color(1.0, 0.6, 0.45) if sel else Color(0.70, 0.40, 0.32), 12, 3 if sel else 2, 10)
		st_n.content_margin_left = 84
		b.add_theme_stylebox_override("normal", st_n)
		b.add_theme_stylebox_override("hover", st_n)
		b.add_theme_stylebox_override("pressed", st_n)
		b.pressed.connect(func() -> void:
			_salv_sel = it
			_message = ""
			refresh())
		var sl: String = ProgressionManager.slot_for_type(String(it.get("type", "")))
		var tile: TextureRect = _tile(sl if sl != "" else "bague", 64.0)
		tile.set_anchors_and_offsets_preset(Control.PRESET_CENTER_LEFT)
		tile.offset_left = 10
		tile.offset_right = 74
		tile.offset_top = -32
		tile.offset_bottom = 32
		b.add_child(tile)
		_list_box.add_child(b)


func _refresh_salvage_detail() -> void:
	if _salv_sel.is_empty():
		var e := U.lbl("Briseur : sélectionnez un objet de l'inventaire pour voir ce qu'il rapporte.", 19, U.C_DIM)
		e.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		e.custom_minimum_size = Vector2(460, 0)
		_detail_box.add_child(e)
		_salvage_message()
		return
	var it: Dictionary = _salv_sel
	var sl: String = ProgressionManager.slot_for_type(String(it.get("type", "")))
	var head := HBoxContainer.new()
	head.add_theme_constant_override("separation", 12)
	_detail_box.add_child(head)
	head.add_child(_tile(sl if sl != "" else "bague", 92.0))
	var hv := VBoxContainer.new()
	hv.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	head.add_child(hv)
	var nm := U.lbl(ItemRules.display_name(it), 28, ItemRules.rarity_color(it).lightened(0.2), true)
	nm.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	hv.add_child(nm)
	hv.add_child(U.lbl("%s · %s · niveau %d" % [it.get("type", ""), ItemRules.rarity_label(it), int(it.get("level", 1))], 17, U.C_DIM))
	_detail_box.add_child(U.lbl(ItemRules.stat_line(it), 20, U.C_TXT))
	var pv: Dictionary = ProgressionManager.salvage_preview(it)
	_detail_box.add_child(U.lbl("RENDEMENT", 17, U.C_DIM))
	var names: Array[String] = []
	for r in pv["pool"]:
		if not names.has(String(r)):
			names.append(String(r))
	var g := HBoxContainer.new()
	g.add_theme_constant_override("separation", 10)
	_detail_box.add_child(g)
	g.add_child(U.lbl("≈ %d ressources parmi :" % int(pv["total"]), 20, U.C_TXT))
	for r: String in names:
		g.add_child(_res_icon(r, 30.0))
	if String(pv["bonus"]) != "":
		_detail_box.add_child(_res_label(String(pv["bonus"]), "+1 %s (rang de l'objet)" % _res_text(String(pv["bonus"])), U.C_GOOD, 20, 30.0))
	var warn := U.lbl("L'objet sera détruit définitivement.", 17, Color(1.0, 0.65, 0.45))
	_detail_box.add_child(warn)
	var bb := U.btn("🔨  BRISER", Color(0.90, 0.40, 0.30), 24, Vector2(0, 62))
	bb.pressed.connect(func() -> void: _on_salvage_pressed(it))
	_actions.add_child(bb)
	_salvage_message()


func _salvage_message() -> void:
	if _message != "":
		var ml := U.lbl(_message, 19, Color(0.95, 0.80, 0.45) if _message_ok else U.C_BAD)
		ml.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		ml.custom_minimum_size = Vector2(460, 0)
		_actions.add_child(ml)
		_actions.move_child(ml, 0)


func _on_salvage_pressed(it: Dictionary) -> void:
	var inv_now: Array = _save.get("inventory", [])
	var live_idx: int = inv_now.find(it)
	if live_idx < 0:
		return
	var result: Dictionary = ProgressionManager.salvage_item(_save, live_idx)
	if not bool(result.get("ok", false)):
		return
	ProgressionManager.write_save(_slot, _save)
	var gains: Dictionary = result.get("gains", {})
	var parts: Array = []
	for r: String in gains.keys():
		parts.append("%s +%d" % [_res_text(r), int(gains[r])])
	_message_ok = true
	_message = "⚒ %s brisé : %s" % [String(it.get("name", "?")), " · ".join(PackedStringArray(parts))]
	_salv_sel = {}
	crafted.emit()
	refresh()

func _refresh_detail() -> void:
	for c in _detail_box.get_children():
		c.queue_free()
	for c in _actions.get_children():
		c.queue_free()
	match _mode:
		"salvage":
			_refresh_salvage_detail()
			return
		"upgrade":
			_refresh_upgrade_detail()
			return
		"fusion":
			_refresh_fusion_detail()
			return
	var r: Dictionary = ProgressionManager.craft_recipe(_selected)
	if r.is_empty():
		_detail_box.add_child(U.lbl("Sélectionnez une recette.", 22, U.C_DIM))
		return
	var st: Dictionary = ProgressionManager.craft_status(_save, r, _tier)
	var item: Dictionary = ProgressionManager.forged_item_ranked(r, _tier)
	var rc: Color = ItemRules.rarity_color(item)
	var head := HBoxContainer.new()
	head.add_theme_constant_override("separation", 12)
	_detail_box.add_child(head)
	head.add_child(_tile(_category_of(r), 92.0))
	var hv := VBoxContainer.new()
	hv.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	head.add_child(hv)
	var nm := U.lbl(String(r["name"]), 30, rc.lightened(0.2), true)
	nm.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	hv.add_child(nm)
	hv.add_child(U.lbl("%s · niveau %d · %s · rang %d" % [r["type"], int(r["level"]), ItemRules.rarity_label(item), _tier], 17, U.C_DIM))

	# Rang de fabrication : 1..10 (ressources de ce rang)
	_detail_box.add_child(U.lbl("RANG DE FABRICATION", 17, U.C_DIM))
	var tiers := HBoxContainer.new()
	tiers.add_theme_constant_override("separation", 4)
	_detail_box.add_child(tiers)
	for t: int in range(1, ProgressionManager.MAX_RANK + 1):
		var ok_t: bool = bool(ProgressionManager.craft_status(_save, r, t)["craftable"])
		var tb := U.btn(str(t), Color(0.95, 0.65, 0.30) if t == _tier else (Color(0.45, 0.80, 0.50) if ok_t else U.C_BORDER), 18, Vector2(0, 44))
		tb.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		tb.tooltip_text = "Rang %d : stats x%.2f" % [t, ProgressionManager.rank_mult(t)]
		tb.pressed.connect(func() -> void:
			_tier = t
			_message = ""
			refresh())
		tiers.add_child(tb)

	var tier_end: int = _detail_box.get_child_count()
	# Choix du personnage : comparaison + équipement direct
	_detail_box.add_child(U.lbl("POUR QUI ?", 17, U.C_DIM))
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
		var cl := U.lbl("%s niv %d" % [classe, lvl], 17, U.C_TXT)
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
	_detail_box.add_child(U.lbl("Porte actuellement : %s" % (String(cur.get("name", "")) if not cur.is_empty() else "rien"), 17, U.C_DIM))

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

	var res_start: int = _detail_box.get_child_count()
	# Ressources nécessaires
	_detail_box.add_child(U.lbl("RESSOURCES", 17, U.C_DIM))
	var res: Dictionary = ProgressionManager.resources(_save)
	for k: String in st["cost"].keys():
		var have: int = int(res.get(k, 0))
		var need: int = int(st["cost"][k])
		var row := HBoxContainer.new()
		row.add_theme_constant_override("separation", 10)
		_detail_box.add_child(row)
		var name_l: HBoxContainer = _res_label(k, _res_text(k), U.RES_COLOR.get(_res_name(k), U.C_TXT), 20, 30.0)
		name_l.custom_minimum_size = Vector2(150, 0)
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
	if int(st["gold"]) > 0:
		var gr := HBoxContainer.new()
		gr.add_theme_constant_override("separation", 10)
		_detail_box.add_child(gr)
		var gl := U.lbl("🪙 Or", 20, U.C_GOLD)
		gl.custom_minimum_size = Vector2(120, 0)
		gr.add_child(gl)
		var have_g: int = ProgressionManager.gold(_save)
		gr.add_child(U.lbl("%d / %d" % [have_g, int(st["gold"])], 20, U.C_GOOD if have_g >= int(st["gold"]) else U.C_BAD))

	# Message d'état
	var craftable: bool = bool(st["craftable"])
	var status_txt: String = ""
	var status_col: Color = U.C_GOOD
	if not craftable:
		var parts: Array[String] = []
		for k: String in st["missing"].keys():
			parts.append("%d %s" % [int(st["missing"][k]), _res_text(k)])
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
	sl.custom_minimum_size = Vector2(460, 0)
	_detail_box.add_child(sl)
	# Sur téléphone : coût et état juste sous le rang, visibles sans défiler
	var moved: Array = []
	for i: int in range(res_start, _detail_box.get_child_count()):
		moved.append(_detail_box.get_child(i))
	for k: int in range(moved.size()):
		_detail_box.move_child(moved[k], tier_end + k)

	var brow := HBoxContainer.new()
	brow.add_theme_constant_override("separation", 8)
	_actions.add_child(brow)
	var b1 := U.btn("⚒  FABRIQUER", Color(0.95, 0.65, 0.30), 22, Vector2(0, 62))
	b1.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	b1.disabled = not craftable
	b1.pressed.connect(func() -> void:
		var err: String = ProgressionManager.craft_item(_save, _selected, _tier)
		_after_craft(err, "%s fabriqué (dans l'inventaire)." % _selected))
	brow.add_child(b1)
	var cname: String = String(member.get("classe", "?"))
	var b2 := U.btn("⚒ + ÉQUIPER (%s)" % cname, Color(0.45, 0.80, 0.50), 22, Vector2(0, 62))
	b2.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	b2.disabled = not craftable or not can_wear
	b2.pressed.connect(func() -> void:
		var err: String = ProgressionManager.craft_and_equip(_save, _selected, _member, _tier)
		_after_craft(err, "%s fabriqué et équipé sur %s !" % [_selected, cname]))
	brow.add_child(b2)
	if _message != "":
		var ml := U.lbl(_message, 20, U.C_GOOD if _message_ok else U.C_BAD)
		ml.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		ml.custom_minimum_size = Vector2(500, 0)
		_actions.add_child(ml)
		_actions.move_child(ml, 0)


# ── Mode AMÉLIORER ───────────────────────────────────────────────────────────
func _entry_key(e: Dictionary) -> String:
	return "%s|%d|%s|%d" % [e["src"], int(e["member"]), String(e["slot"]), int(e["index"])]


func _find_entry(key: String) -> Dictionary:
	for e: Dictionary in ProgressionManager.upgradable_items(_save):
		if _entry_key(e) == key:
			return e
	return {}


func _refresh_upgrade_list() -> void:
	var entries: Array = ProgressionManager.upgradable_items(_save)
	if entries.is_empty():
		_list_box.add_child(U.lbl("Aucun équipement : fabriquez-en ou looter-en en combat.", 20, U.C_DIM))
		return
	if _up_key == "" or _find_entry(_up_key).is_empty():
		_up_key = _entry_key(entries[0])
	var team: Array = _save.get("team", [])
	for e: Dictionary in entries:
		var it: Dictionary = e["item"]
		var key: String = _entry_key(e)
		var sel: bool = key == _up_key
		var rank: int = int(it.get("rank", 1))
		var b := Button.new()
		b.custom_minimum_size = Vector2(0, 84)
		b.focus_mode = Control.FOCUS_NONE
		var edge: Color = ItemRules.rarity_color(it)
		var st_n: StyleBoxFlat = U.box(Color(0.17, 0.13, 0.11, 0.95) if sel else Color(0.13, 0.10, 0.09, 0.92), Color(1.0, 0.75, 0.35) if sel else edge.darkened(0.3), 14, 3 if sel else 2, 10)
		st_n.content_margin_left = 84
		b.add_theme_stylebox_override("normal", st_n)
		b.add_theme_stylebox_override("hover", st_n)
		b.add_theme_stylebox_override("pressed", st_n)
		b.alignment = HORIZONTAL_ALIGNMENT_LEFT
		var who: String = ""
		if String(e["src"]) == "team":
			who = "  · porté par %s" % String(team[int(e["member"])].get("classe", "?"))
		elif String(e["src"]) == "hero":
			who = "  · porté par %s" % String(e.get("classe", "?"))
		b.text = "%s%s\n%s · rang %d/%d%s" % [ItemRules.display_name(it), "", ItemRules.stat_line(it), rank, ProgressionManager.MAX_RANK, who]
		b.add_theme_font_size_override("font_size", 19)
		b.add_theme_color_override("font_color", ItemRules.rarity_color(it).lightened(0.3))
		b.add_theme_color_override("font_hover_color", ItemRules.rarity_color(it).lightened(0.45))
		b.add_theme_color_override("font_pressed_color", ItemRules.rarity_color(it).lightened(0.45))
		b.pressed.connect(func() -> void:
			_up_key = key
			_message = ""
			refresh())
		var sl: String = ProgressionManager.slot_for_type(String(it.get("type", "")))
		var tile: TextureRect = _tile(sl if sl != "" else "bague", 64.0)
		tile.set_anchors_and_offsets_preset(Control.PRESET_CENTER_LEFT)
		tile.offset_left = 10
		tile.offset_right = 74
		tile.offset_top = -32
		tile.offset_bottom = 32
		b.add_child(tile)
		_list_box.add_child(b)


func _refresh_upgrade_detail() -> void:
	var e: Dictionary = _find_entry(_up_key)
	if e.is_empty():
		_detail_box.add_child(U.lbl("Sélectionnez un équipement.", 22, U.C_DIM))
		return
	var it: Dictionary = e["item"]
	var c: Dictionary = ProgressionManager.upgrade_cost(it)
	var rank: int = int(c["rank"])
	var sl: String = ProgressionManager.slot_for_type(String(it.get("type", "")))
	var head := HBoxContainer.new()
	head.add_theme_constant_override("separation", 12)
	_detail_box.add_child(head)
	head.add_child(_tile(sl if sl != "" else "bague", 92.0))
	var hv := VBoxContainer.new()
	hv.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	head.add_child(hv)
	var nm := U.lbl(String(it.get("name", "?")), 28, ItemRules.rarity_color(it).lightened(0.2), true)
	nm.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	hv.add_child(nm)
	hv.add_child(U.lbl("%s · %s · rang %d / %d" % [it.get("type", ""), ItemRules.rarity_label(it), rank, ProgressionManager.MAX_RANK], 17, U.C_DIM))
	if rank >= ProgressionManager.MAX_RANK:
		_detail_box.add_child(U.lbl("Rang maximum atteint !", 22, U.C_GOOD))
		return
	# Aperçu des stats
	var preview: Dictionary = it.duplicate(true)
	ProgressionManager.apply_rank(preview, int(c["next"]))
	_detail_box.add_child(U.lbl("APRÈS AMÉLIORATION (rang %d)" % int(c["next"]), 17, U.C_DIM))
	var stats := GridContainer.new()
	stats.columns = 2
	stats.add_theme_constant_override("h_separation", 14)
	stats.add_theme_constant_override("v_separation", 6)
	_detail_box.add_child(stats)
	for k: String in ItemRules.STAT_KEYS:
		var ov: int = int(it.get(k, 0))
		var nv: int = int(preview.get(k, 0))
		if ov == 0 and nv == 0:
			continue
		var line := HBoxContainer.new()
		line.add_theme_constant_override("separation", 8)
		line.add_child(U.lbl("%s  %d → %d" % [ItemRules.STAT_NAME[k], ov, nv], 20, U.C_TXT))
		line.add_child(U.lbl("(%+d)" % (nv - ov), 18, U.C_GOOD))
		stats.add_child(line)
	# Coût
	_detail_box.add_child(U.lbl("COÛT", 17, U.C_DIM))
	var res: Dictionary = ProgressionManager.resources(_save)
	var have: int = int(res.get(String(c["res"]), 0))
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 10)
	_detail_box.add_child(row)
	var name_l: HBoxContainer = _res_label(String(c["res"]), _res_text(String(c["res"])), U.RES_COLOR.get(String(c["res_name"]), U.C_TXT), 20, 30.0)
	name_l.custom_minimum_size = Vector2(170, 0)
	row.add_child(name_l)
	row.add_child(U.lbl("%d / %d" % [have, int(c["qty"])], 20, U.C_GOOD if have >= int(c["qty"]) else U.C_BAD))
	var gr := HBoxContainer.new()
	gr.add_theme_constant_override("separation", 10)
	_detail_box.add_child(gr)
	var gl := U.lbl("🪙 Or", 20, U.C_GOLD)
	gl.custom_minimum_size = Vector2(170, 0)
	gr.add_child(gl)
	var have_g: int = ProgressionManager.gold(_save)
	gr.add_child(U.lbl("%d / %d" % [have_g, int(c["gold"])], 20, U.C_GOOD if have_g >= int(c["gold"]) else U.C_BAD))
	var can: bool = have >= int(c["qty"]) and have_g >= int(c["gold"])
	if have < int(c["qty"]):
		var hint := U.lbl("Il vous faut %d × %s : fondez des ressources dans l'onglet Fusion." % [int(c["qty"]), _res_text(String(c["res"]))], 17, U.C_BAD)
		hint.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		hint.custom_minimum_size = Vector2(500, 0)
		_detail_box.add_child(hint)
	var tip := U.lbl("Chaque rang ajoute +12 %% de stats. Coût : 1 ressource de rang %d + or." % int(c["next"]), 17, U.C_DIM)
	tip.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	tip.custom_minimum_size = Vector2(460, 0)
	_detail_box.add_child(tip)
	var ub := U.btn("⚒  AMÉLIORER  (rang %d → %d)" % [rank, int(c["next"])], Color(0.95, 0.65, 0.30), 24, Vector2(0, 60))
	ub.disabled = not can
	ub.pressed.connect(func() -> void:
		var err: String = ProgressionManager.upgrade_item(_save, e)
		if err == "":
			Sfx.play("forge")
		_message_ok = err == ""
		_message = ("%s amélioré au rang %d !" % [String(it.get("name", "?")), int(c["next"])]) if err == "" else err
		if err == "":
			ProgressionManager.write_save(_slot, _save)
			crafted.emit()
		refresh())
	_actions.add_child(ub)
	if _message != "":
		var ml := U.lbl(_message, 20, U.C_GOOD if _message_ok else U.C_BAD)
		ml.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		ml.custom_minimum_size = Vector2(500, 0)
		_actions.add_child(ml)
		_actions.move_child(ml, 0)


# ── Mode FUSION ─────────────────────────────────────────────────────────────
func _refresh_fusion_list() -> void:
	var res: Dictionary = ProgressionManager.resources(_save)
	var gold: int = ProgressionManager.gold(_save)
	# Bascule ×1 / MAX : évite de taper 20 fois sur le même bouton
	var qrow := HBoxContainer.new()
	qrow.add_theme_constant_override("separation", 8)
	_list_box.add_child(qrow)
	var ql := U.lbl("Quantité par appui :", 19, U.C_DIM)
	ql.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	ql.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	qrow.add_child(ql)
	for opt: Array in [[false, "×1"], [true, "MAX"]]:
		var on: bool = _fuse_max == bool(opt[0])
		var qb := U.btn(String(opt[1]), Color(0.95, 0.65, 0.30) if on else U.C_BORDER, 20, Vector2(110, 48))
		qb.pressed.connect(func() -> void:
			_fuse_max = bool(opt[0])
			refresh())
		qrow.add_child(qb)
	for name_r: String in ProgressionManager.RES_TYPES:
		var col: Color = U.RES_COLOR.get(name_r, U.C_TXT)
		var card := PanelContainer.new()
		card.add_theme_stylebox_override("panel", U.box(Color(0.13, 0.10, 0.09, 0.92), col.darkened(0.25), 14, 2, 10))
		_list_box.add_child(card)
		var v := VBoxContainer.new()
		v.add_theme_constant_override("separation", 6)
		card.add_child(v)
		var title := _res_label(name_r, name_r, col.lightened(0.2), 24, 38.0)
		v.add_child(title)
		var cells := HBoxContainer.new()
		cells.add_theme_constant_override("separation", 4)
		v.add_child(cells)
		for t: int in range(1, ProgressionManager.MAX_RANK + 1):
			var have: int = int(res.get(ProgressionManager.res_key(name_r, t), 0))
			var cell := VBoxContainer.new()
			cell.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			cell.add_theme_constant_override("separation", 2)
			var rl := U.lbl("R%d" % t, 17, U.C_DIM)
			rl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			cell.add_child(rl)
			var cl := U.lbl(str(have), 26, col.lightened(0.2) if have > 0 else U.C_DIM, true)
			cl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			cell.add_child(cl)
			if t < ProgressionManager.MAX_RANK:
				var gold_cost: int = ProgressionManager.fuse_gold(t + 1)
				var can: bool = have >= ProgressionManager.FUSE_RATIO and gold >= gold_cost
				var fb := U.btn("➜R%d" % (t + 1), Color(0.45, 0.80, 0.50) if can else U.C_BORDER, 17, Vector2(0, 46))
				fb.disabled = not can
				fb.tooltip_text = "%d × %s R%d + %d or → 1 × %s R%d" % [ProgressionManager.FUSE_RATIO, name_r, t, gold_cost, name_r, t + 1]
				fb.pressed.connect(func() -> void:
					var made: int = 0
					var err: String = ""
					while true:
						err = ProgressionManager.fuse_resource(_save, name_r, t)
						if err != "":
							break
						made += 1
						if not _fuse_max:
							break
					_message_ok = made > 0
					_message = ("%d × %s R%d créé(s) !" % [made, name_r, t + 1]) if made > 0 else err
					if made > 0:
						Sfx.play("fuse")
						ProgressionManager.write_save(_slot, _save)
						crafted.emit()
					refresh())
				cell.add_child(fb)
			else:
				cell.add_child(Control.new())
			cells.add_child(cell)


func _refresh_fusion_detail() -> void:
	_detail_box.add_child(U.lbl("FUSION DE RESSOURCES", 22, Color(1.0, 0.76, 0.38), true))
	var txt := U.lbl("%d ressources du même type et du même rang se fondent en 1 ressource du rang suivant, contre un peu d'or. Les ressources de rang élevé servent à fabriquer (onglet Fabriquer) et à améliorer (onglet Améliorer) l'équipement jusqu'au rang 10." % ProgressionManager.FUSE_RATIO, 18, U.C_DIM)
	txt.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	txt.custom_minimum_size = Vector2(500, 0)
	_detail_box.add_child(txt)
	_detail_box.add_child(U.lbl("COÛT PAR RANG", 17, U.C_DIM))
	var grid := GridContainer.new()
	grid.columns = 3
	grid.add_theme_constant_override("h_separation", 22)
	grid.add_theme_constant_override("v_separation", 4)
	_detail_box.add_child(grid)
	for h: String in ["Rang visé", "≈ ressources rang 1", "Or"]:
		grid.add_child(U.lbl(h, 17, U.C_DIM))
	for t: int in range(2, ProgressionManager.MAX_RANK + 1):
		grid.add_child(U.lbl("R%d" % t, 19, U.C_TXT))
		grid.add_child(U.lbl(str(int(pow(ProgressionManager.FUSE_RATIO, t - 1))), 19, U.C_TXT))
		grid.add_child(U.lbl("%d" % ProgressionManager.fuse_gold(t), 19, U.C_GOLD))
	if _message != "":
		var ml := U.lbl(_message, 20, U.C_GOOD if _message_ok else U.C_BAD)
		ml.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		ml.custom_minimum_size = Vector2(500, 0)
		_actions.add_child(ml)
		_actions.move_child(ml, 0)


func _after_craft(err: String, ok_msg: String) -> void:
	_message_ok = err == "" or err.begins_with("Objet fabriqué")
	_message = ok_msg if err == "" else err
	if _message_ok:
		Sfx.play("forge")
		ProgressionManager.write_save(_slot, _save)
		crafted.emit()
	refresh()
