extends CanvasLayer
## InventoryUI.gd — Inventaire complet de la partie (V21).
##
## Montre TOUS les objets : ceux de l'inventaire (libres) et ceux déjà portés par un héros
## (équipe, gouverneurs, héros au repos). Tri, filtres par type / rareté / statut, sélection
## multiple pour envoyer d'un coup au Briseur, ou au Briseur puis directement à la Fusion.
## API : open(save, slot). Signaux : closed, fusion_requested (ouvrir la Forge en Fusion).

signal closed
signal fusion_requested

const U = preload("res://scripts/UiKit.gd")
const C_BG := Color(0.05, 0.07, 0.12, 1.0)
const C_PANEL := Color(0.09, 0.11, 0.17, 0.98)
const C_CARD := Color(0.12, 0.15, 0.23, 1.0)
const C_CARD_SEL := Color(0.20, 0.17, 0.08, 1.0)
const C_BORDER := Color(0.30, 0.36, 0.50, 1.0)
const C_GOLD := Color(1.00, 0.82, 0.35)
const C_TXT := Color(0.95, 0.94, 0.90)
const C_DIM := Color(0.62, 0.66, 0.76)
const C_GOOD := Color(0.45, 0.88, 0.50)
const C_BAD := Color(1.00, 0.45, 0.40)
const C_FUSE := Color(0.55, 0.78, 1.0)

const SORTS: Array = [["rarete", "Rareté"], ["niveau", "Niveau"], ["puissance", "Puissance"], ["type", "Type"], ["nom", "Nom"]]
const STATUTS: Array = [["tous", "Tous"], ["libres", "Libres"], ["portes", "Portés"]]

var _root: Control
var _save: Dictionary = {}
var _slot: int = -1
var _f_type: String = "all"
var _f_rarity: String = "all"
var _f_status: String = "tous"
var _f_text: String = ""
var _sort: String = "rarete"
var _desc: bool = true
var _sel: Dictionary = {}               # clé d'entrée -> true
var _entries: Array = []                # toutes les entrées (avant filtre)
var _shown: Array = []                  # entrées affichées (après filtre / tri)
var _rows: Dictionary = {}              # clé -> Button
var _filters_box: VBoxContainer
var _list_box: VBoxContainer
var _count_lbl: Label
var _msg_lbl: Label
var _act_row: HBoxContainer
var _confirm: Control


func open(save_data: Dictionary, slot: int) -> void:
	_save = save_data
	_slot = slot
	_build()
	refresh()


# ═══════════════════════════════════════════════════════════════════════════
#  Données
# ═══════════════════════════════════════════════════════════════════════════

## Toutes les entrées : { key, it, owner ("" = libre), slot (emplacement porté) }.
func _collect() -> Array:
	var out: Array = []
	var inv: Array = _save.get("inventory", [])
	for i: int in range(inv.size()):
		out.append({"key": "i:%d" % i, "it": inv[i], "owner": "", "slot": ""})
	for classe: String in ProgressionManager.class_names():
		var eq: Dictionary = ProgressionManager.hero_equipment(_save, classe)
		for slot: String in eq.keys():
			if eq[slot] is Dictionary:
				out.append({"key": "e:%s:%s" % [classe, slot], "it": eq[slot], "owner": classe, "slot": slot})
	return out


func _passes(e: Dictionary) -> bool:
	var it: Dictionary = e["it"]
	if _f_type != "all" and GearUi.slot_of(it) != _f_type:
		return false
	if _f_rarity != "all" and String(it.get("rarity", "commun")) != _f_rarity:
		return false
	if _f_status == "libres" and String(e["owner"]) != "":
		return false
	if _f_status == "portes" and String(e["owner"]) == "":
		return false
	if _f_text != "":
		var q: String = _f_text.to_lower()
		var hay: String = "%s %s %s %s".format([
			String(it.get("name", "")),
			String(it.get("type", "")),
			GearUi.slot_label(GearUi.slot_of(it)),
			String(e["owner"]),
		]).to_lower()
		if not hay.contains(q):
			return false
	return true


func _cmp(a: Dictionary, b: Dictionary) -> bool:
	var ia: Dictionary = a["it"]
	var ib: Dictionary = b["it"]
	var va: Variant
	var vb: Variant
	match _sort:
		"niveau":
			va = int(ia.get("level", 0))
			vb = int(ib.get("level", 0))
		"puissance":
			va = ItemRules.power(ia)
			vb = ItemRules.power(ib)
		"type":
			va = GearUi.SLOT_ORDER.find(GearUi.slot_of(ia))
			vb = GearUi.SLOT_ORDER.find(GearUi.slot_of(ib))
		"nom":
			va = String(ia.get("name", "")).to_lower()
			vb = String(ib.get("name", "")).to_lower()
		_:
			va = GearUi.rarity_rank(ia)
			vb = GearUi.rarity_rank(ib)
	if va != vb:
		return (va > vb) if _desc else (va < vb)
	# égalité : puissance décroissante puis nom, pour un ordre stable
	var pa: int = ItemRules.power(ia)
	var pb: int = ItemRules.power(ib)
	if pa != pb:
		return pa > pb
	return String(ia.get("name", "")) < String(ib.get("name", ""))


func _selected_entries() -> Array:
	var out: Array = []
	for e: Dictionary in _entries:
		if _sel.has(String(e["key"])):
			out.append(e)
	return out


# ═══════════════════════════════════════════════════════════════════════════
#  Structure
# ═══════════════════════════════════════════════════════════════════════════

func _build() -> void:
	if _root != null and is_instance_valid(_root):
		_root.queue_free()
	_root = Control.new()
	add_child(_root)
	UiFit.apply(_root, 1.2, Vector2(1600, 900))
	var bg := ColorRect.new()
	bg.color = C_BG
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	_root.add_child(bg)
	var margin := MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	for side in ["left", "right"]:
		margin.add_theme_constant_override("margin_" + side, 30)
	margin.add_theme_constant_override("margin_top", 16)
	margin.add_theme_constant_override("margin_bottom", 18)
	_root.add_child(margin)
	var page := VBoxContainer.new()
	page.add_theme_constant_override("separation", 10)
	margin.add_child(page)

	var top := HBoxContainer.new()
	top.add_theme_constant_override("separation", 20)
	page.add_child(top)
	top.add_child(U.lbl("INVENTAIRE", 36, C_GOLD, true))
	_count_lbl = U.lbl("", 20, C_DIM)
	_count_lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	top.add_child(_count_lbl)
	top.add_child(U.spacer())
	var close := U.btn("✕  FERMER", Color(0.95, 0.75, 0.30), 22, Vector2(190, 52))
	close.name = "CloseButton"
	close.pressed.connect(func() -> void: closed.emit())
	top.add_child(close)

	var fpanel := PanelContainer.new()
	fpanel.add_theme_stylebox_override("panel", U.box(C_PANEL, C_BORDER, 14, 2, 10))
	page.add_child(fpanel)
	_filters_box = VBoxContainer.new()
	_filters_box.add_theme_constant_override("separation", 6)
	fpanel.add_child(_filters_box)

	var lpanel := PanelContainer.new()
	lpanel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	lpanel.add_theme_stylebox_override("panel", U.box(C_PANEL, C_BORDER, 14, 2, 10))
	page.add_child(lpanel)
	var scroll := ScrollContainer.new()
	TouchScroll.install(scroll)
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	lpanel.add_child(scroll)
	_list_box = VBoxContainer.new()
	_list_box.add_theme_constant_override("separation", 6)
	_list_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(_list_box)

	_msg_lbl = U.lbl("", 19, C_GOOD)
	_msg_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	page.add_child(_msg_lbl)
	_act_row = HBoxContainer.new()
	_act_row.add_theme_constant_override("separation", 10)
	page.add_child(_act_row)


## Rangée de boutons-puces ; `current` est la valeur active, `on_pick` reçoit la clé choisie.
func _chip_row(title: String, options: Array, current: String, on_pick: Callable, prefix: String, row: HFlowContainer = null) -> HFlowContainer:
	var shared: bool = row != null
	if row == null:
		row = HFlowContainer.new()
		row.add_theme_constant_override("h_separation", 6)
		row.add_theme_constant_override("v_separation", 6)
		_filters_box.add_child(row)
	var t := U.lbl(title, 17, C_DIM)
	t.custom_minimum_size = Vector2(86 if not shared else 0, 0)
	t.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	row.add_child(t)
	for opt: Array in options:
		var key: String = String(opt[0])
		var on: bool = key == current
		var b := U.btn(String(opt[1]), C_GOLD if on else C_BORDER, 17, Vector2(0, 38))
		b.name = "%s_%s" % [prefix, key]
		b.pressed.connect(func() -> void: on_pick.call(key))
		row.add_child(b)
	return row


func refresh() -> void:
	_entries = _collect()
	# nettoie la sélection d'entrées disparues
	var keys: Dictionary = {}
	for e: Dictionary in _entries:
		keys[String(e["key"])] = true
	for k: String in _sel.keys():
		if not keys.has(k):
			_sel.erase(k)
	_refresh_filters()
	_refresh_list()
	_refresh_actions()


func _refresh_filters() -> void:
	for c in _filters_box.get_children():
		c.queue_free()
	# Champ de recherche texte
	var srow := HBoxContainer.new()
	srow.add_theme_constant_override("separation", 8)
	_filters_box.add_child(srow)
	var slbl := U.lbl("RECHERCHE", 17, C_DIM)
	slbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	srow.add_child(slbl)
	var se := LineEdit.new()
	se.name = "SearchBox"
	se.custom_minimum_size = Vector2(320, 38)
	se.placeholder_text = "Nom, type, propri\u00e9taire..."
	se.text = _f_text
	se.text_changed.connect(func(t: String) -> void:
		_f_text = t
		_refresh_list())
	srow.add_child(se)
	var types: Array = [["all", "Tous"]]
	for s: String in GearUi.SLOT_ORDER:
		types.append([s, GearUi.slot_label(s)])
	_chip_row("TYPE", types, _f_type, func(k: String) -> void:
		_f_type = k
		refresh(), "Type")
	var rar: Array = [["all", "Toutes"]]
	for r: String in ItemRules.RARITY_ORDER:
		rar.append([r, String(GearUi.RARITY_LABEL.get(r, r))])
	var rrow: HFlowContainer = _chip_row("RARETÉ", rar, _f_rarity, func(k: String) -> void:
		_f_rarity = k
		refresh(), "Rarete")
	var sep := Control.new()
	sep.custom_minimum_size = Vector2(14, 0)
	rrow.add_child(sep)
	_chip_row("STATUT", STATUTS, _f_status, func(k: String) -> void:
		_f_status = k
		refresh(), "Statut", rrow)
	# Tri : critère + sens
	var row := HFlowContainer.new()
	row.add_theme_constant_override("h_separation", 6)
	row.add_theme_constant_override("v_separation", 6)
	_filters_box.add_child(row)
	var t := U.lbl("TRI", 17, C_DIM)
	t.custom_minimum_size = Vector2(86, 0)
	t.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	row.add_child(t)
	for opt: Array in SORTS:
		var key: String = String(opt[0])
		var b := U.btn(String(opt[1]), C_GOLD if key == _sort else C_BORDER, 17, Vector2(0, 38))
		b.name = "Tri_" + key
		b.pressed.connect(func() -> void:
			_sort = key
			refresh())
		row.add_child(b)
	var d := U.btn("▼ Décroissant" if _desc else "▲ Croissant", C_FUSE, 17, Vector2(0, 38))
	d.name = "TriSens"
	d.pressed.connect(func() -> void:
		_desc = not _desc
		refresh())
	row.add_child(d)


func _refresh_list() -> void:
	for c in _list_box.get_children():
		c.queue_free()
	_rows.clear()
	_shown = _entries.filter(_passes)
	_shown.sort_custom(_cmp)
	var worn: int = 0
	for e: Dictionary in _entries:
		if String(e["owner"]) != "":
			worn += 1
	_count_lbl.text = "%d objet(s) · %d porté(s) · %d affiché(s)" % [_entries.size(), worn, _shown.size()]
	if _shown.is_empty():
		var e := U.lbl("Aucun objet ne correspond aux filtres." if not _entries.is_empty() else "Inventaire vide : gagnez des combats pour looter de l'équipement.", 20, C_DIM)
		e.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		_list_box.add_child(e)
		return
	for e: Dictionary in _shown:
		var b: Button = _make_row(e)
		_rows[String(e["key"])] = b
		_list_box.add_child(b)


func _make_row(e: Dictionary) -> Button:
	var it: Dictionary = e["it"]
	var key: String = String(e["key"])
	var b := Button.new()
	b.name = "Row_" + key
	b.custom_minimum_size = Vector2(0, 78)
	b.focus_mode = Control.FOCUS_NONE
	b.alignment = HORIZONTAL_ALIGNMENT_LEFT
	b.add_theme_font_size_override("font_size", 19)
	var col: Color = ItemRules.rarity_color(it).lightened(0.3)
	for st_name in ["font_color", "font_hover_color", "font_pressed_color"]:
		b.add_theme_color_override(st_name, col)
	var tile: TextureRect = GearUi.tile(GearUi.slot_of(it), 58.0)
	tile.set_anchors_and_offsets_preset(Control.PRESET_CENTER_LEFT)
	tile.offset_left = 58
	tile.offset_right = 116
	tile.offset_top = -29
	tile.offset_bottom = 29
	b.add_child(tile)
	var chk := U.lbl("☐", 34, C_DIM, true)
	chk.name = "Check"
	chk.set_anchors_and_offsets_preset(Control.PRESET_CENTER_LEFT)
	chk.offset_left = 14
	chk.offset_right = 54
	chk.offset_top = -24
	chk.offset_bottom = 24
	chk.mouse_filter = Control.MOUSE_FILTER_IGNORE
	b.add_child(chk)
	var owner_txt: String = "Libre" if String(e["owner"]) == "" else "Porté : %s" % String(e["owner"])
	var ow := U.lbl(owner_txt, 17, C_DIM if String(e["owner"]) == "" else C_GOOD)
	ow.set_anchors_and_offsets_preset(Control.PRESET_CENTER_RIGHT)
	ow.offset_left = -230
	ow.offset_right = -14
	ow.offset_top = -14
	ow.offset_bottom = 14
	ow.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	ow.mouse_filter = Control.MOUSE_FILTER_IGNORE
	b.add_child(ow)
	b.text = GearUi.item_text(it)
	b.pressed.connect(func() -> void: _toggle(key))
	_style_row(b, e, _sel.has(key))
	return b


func _style_row(b: Button, e: Dictionary, selected: bool) -> void:
	var it: Dictionary = e["it"]
	var edge: Color = ItemRules.rarity_color(it)
	var sb: StyleBoxFlat = U.box(C_CARD_SEL if selected else C_CARD, C_GOLD if selected else edge.darkened(0.25), 12, 3 if selected else 2, 10)
	sb.content_margin_left = 128
	sb.content_margin_right = 240
	b.add_theme_stylebox_override("normal", sb)
	b.add_theme_stylebox_override("hover", sb)
	b.add_theme_stylebox_override("pressed", sb)
	var chk: Node = b.get_node_or_null("Check")
	if chk != null:
		(chk as Label).text = "☑" if selected else "☐"
		(chk as Label).add_theme_color_override("font_color", C_GOLD if selected else C_DIM)


func _toggle(key: String) -> void:
	if _sel.has(key):
		_sel.erase(key)
	else:
		_sel[key] = true
	_msg_lbl.text = ""
	for e: Dictionary in _shown:
		if String(e["key"]) == key and _rows.has(key):
			_style_row(_rows[key], e, _sel.has(key))
			break
	_refresh_actions()


func _refresh_actions() -> void:
	for c in _act_row.get_children():
		c.queue_free()
	var n: int = _sel.size()
	var all_b := U.btn("☑ Tout (affichés)", C_BORDER, 18, Vector2(0, 52))
	all_b.name = "SelectAll"
	all_b.disabled = _shown.is_empty()
	all_b.pressed.connect(func() -> void:
		for e: Dictionary in _shown:
			_sel[String(e["key"])] = true
		_refresh_list()
		_refresh_actions())
	_act_row.add_child(all_b)
	var none_b := U.btn("☐ Aucun", C_BORDER, 18, Vector2(0, 52))
	none_b.name = "SelectNone"
	none_b.disabled = n == 0
	none_b.pressed.connect(func() -> void:
		_sel.clear()
		_refresh_list()
		_refresh_actions())
	_act_row.add_child(none_b)
	var info := U.lbl("%d sélectionné(s)" % n, 19, C_GOLD if n > 0 else C_DIM)
	info.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_act_row.add_child(info)
	_act_row.add_child(U.spacer())
	var salv := U.btn("⚒  ENVOYER AU BRISEUR (%d)" % n, Color(0.95, 0.55, 0.30), 20, Vector2(0, 56))
	salv.name = "SalvageButton"
	salv.disabled = n == 0
	salv.pressed.connect(func() -> void: _ask_confirm(false))
	_act_row.add_child(salv)
	var fuse := U.btn("✦  BRISER PUIS FUSION (%d)" % n, C_FUSE, 20, Vector2(0, 56))
	fuse.name = "FusionButton"
	fuse.disabled = n == 0
	fuse.pressed.connect(func() -> void: _ask_confirm(true))
	_act_row.add_child(fuse)


# ═══════════════════════════════════════════════════════════════════════════
#  Confirmation et envoi au Briseur
# ═══════════════════════════════════════════════════════════════════════════

func _ask_confirm(then_fusion: bool) -> void:
	var picked: Array = _selected_entries()
	if picked.is_empty():
		return
	if _confirm != null and is_instance_valid(_confirm):
		_confirm.queue_free()
	var worn: Array[String] = []
	var est: int = 0
	var rare_plus: int = 0
	for e: Dictionary in picked:
		if String(e["owner"]) != "":
			worn.append("%s (%s)" % [ItemRules.display_name(e["it"]), String(e["owner"])])
		est += int(ProgressionManager.salvage_preview(e["it"]).get("total", 0))
		if GearUi.rarity_rank(e["it"]) >= 2:
			rare_plus += 1
	var dim := ColorRect.new()
	dim.color = Color(0, 0, 0, 0.66)
	dim.set_anchors_preset(Control.PRESET_FULL_RECT)
	dim.mouse_filter = Control.MOUSE_FILTER_STOP
	_root.add_child(dim)
	_confirm = dim
	var centre := CenterContainer.new()
	centre.set_anchors_preset(Control.PRESET_FULL_RECT)
	dim.add_child(centre)
	var panel := PanelContainer.new()
	panel.add_theme_stylebox_override("panel", U.box(Color(0.08, 0.10, 0.16, 0.99), C_GOLD, 16, 3, 18))
	centre.add_child(panel)
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 12)
	v.custom_minimum_size = Vector2(620, 0)
	panel.add_child(v)
	v.add_child(U.lbl("Briser %d objet(s) ?" % picked.size(), 28, C_GOLD, true))
	var txt: String = "Rend environ %d matériaux (selon rareté, niveau et rang)." % est
	if then_fusion:
		txt += "\nLa Forge s'ouvrira ensuite sur l'onglet Fusion pour fondre les ressources obtenues."
	var t := U.lbl(txt, 19, C_TXT)
	t.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	v.add_child(t)
	if rare_plus > 0:
		var w := U.lbl("⚠ %d objet(s) épique(s) ou légendaire(s) dans la sélection." % rare_plus, 18, C_BAD)
		w.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		v.add_child(w)
	if not worn.is_empty():
		var w2 := U.lbl("⚠ Objets actuellement portés (ils seront retirés puis brisés) : %s" % ", ".join(PackedStringArray(worn.slice(0, 5))) + (" …" if worn.size() > 5 else ""), 18, C_BAD)
		w2.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		v.add_child(w2)
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 12)
	v.add_child(row)
	var no := U.btn("ANNULER", C_BORDER, 22, Vector2(0, 56))
	no.name = "ConfirmNo"
	no.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	no.pressed.connect(func() -> void: dim.queue_free())
	row.add_child(no)
	var yes := U.btn("BRISER", Color(0.95, 0.55, 0.30), 22, Vector2(0, 56))
	yes.name = "ConfirmYes"
	yes.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	yes.pressed.connect(func() -> void:
		dim.queue_free()
		_do_salvage(then_fusion))
	row.add_child(yes)


func _do_salvage(then_fusion: bool) -> void:
	var items: Array = []
	for e: Dictionary in _selected_entries():
		items.append(e["it"])
	var res: Dictionary = ProgressionManager.salvage_many(_save, items)
	_sel.clear()
	ProgressionManager.write_save(_slot, _save)
	var parts: PackedStringArray = []
	var gains: Dictionary = res.get("gains", {})
	for r: String in gains.keys():
		parts.append("%s +%d" % [r.replace("@", " R"), int(gains[r])])
	var msg: String = "⚒ %d objet(s) brisé(s)" % int(res.get("count", 0))
	if not parts.is_empty():
		msg += " : " + " · ".join(parts)
	if then_fusion and int(res.get("count", 0)) > 0:
		fusion_requested.emit()
		return
	refresh()
	_msg_lbl.text = msg
