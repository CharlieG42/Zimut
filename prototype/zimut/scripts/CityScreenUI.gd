class_name CityScreenUI
extends CanvasLayer

## CityScreenUI.gd — « Entrer dans la ville » (mode Conquête).
## Fenêtre plein écran propre à la nation de la ville : on y gère l'Hôtel de ville
## (évolution Hameau → Bourg → Cité), la caserne (garnison), la résidence du
## gouverneur (héros en poste) et les bâtiments de production.
## Elle travaille directement sur la sauvegarde partagée avec la carte (même dictionnaire),
## l'écrit à chaque action et émet `closed` à la fermeture.

signal closed()

const TEXT := Color(0.96, 0.94, 0.86)
const DIM := Color(0.72, 0.74, 0.78)
const GOLD := Color(0.96, 0.75, 0.31)
const GOOD := Color(0.55, 0.88, 0.50)
const BAD := Color(0.95, 0.45, 0.40)

## Noms des quartiers selon la nation (biome) de la ville.
const DISTRICTS := {
	"Forêt": {"hall": "Hutte du Conseil", "barracks": "Cercle des Gardes-Racines", "residence": "Arbre-Demeure"},
	"Montagne": {"hall": "Grand Hall de Givre", "barracks": "Casernes de Roc", "residence": "Donjon du Thane"},
	"Désert": {"hall": "Palais des Sables", "barracks": "Caserne des Dunes", "residence": "Pavillon du Vizir"},
	"Cristaux": {"hall": "Sanctum de Cristal", "barracks": "Garde Prismatique", "residence": "Tour des Mages"},
	"Marées": {"hall": "Amirauté", "barracks": "Quais des Marins", "residence": "Villa du Capitaine"},
	"Vents": {"hall": "Aire des Vents", "barracks": "Perchoir des Gardes", "residence": "Tour des Courants"},
	"Brasier": {"hall": "Forge-Hôtel", "barracks": "Caserne de Braise", "residence": "Palais de Lave"},
	"Brumes": {"hall": "Salle des Brumes", "barracks": "Veilleurs du Marais", "residence": "Cabane du Sage"},
	"Ombres": {"hall": "Chapitre des Ombres", "barracks": "Garde des Cryptes", "residence": "Crypte du Régent"},
	"Donjon": {"hall": "Salle du Trône", "barracks": "Geôles-Casernes", "residence": "Tour du Roi"},
}
const RES_COLORS := {"Bois": Color(0.62, 0.78, 0.40), "Fer": Color(0.72, 0.78, 0.88), "Cuir": Color(0.82, 0.62, 0.42),
	"Magie": Color(0.70, 0.58, 0.98), "Venin": Color(0.55, 0.85, 0.55)}

var _save: Dictionary = {}
var _slot: int = -1
var _city_id: String = ""
var _biome: String = "Forêt"
var _sprite: Texture2D = null
var _accent: Color = Color(0.6, 0.7, 0.5)
var _root: Control
var _body: VBoxContainer
var _info: String = ""
var _desc: String = ""

func open(save: Dictionary, slot: int, city_id: String, sprite: Texture2D, desc: String = "") -> void:
	_save = save
	_slot = slot
	_city_id = city_id
	_sprite = sprite
	_desc = desc
	_biome = ProgressionManager.conquest_city_biome(city_id)
	var nd: Dictionary = Nations.DATA.get(_biome, {})
	_accent = nd.get("accent", Color(0.6, 0.7, 0.5))
	layer = 30
	_build()

func _conq() -> Dictionary:
	return _save.get("conquest", {})

func _names() -> Dictionary:
	return DISTRICTS.get(_biome, DISTRICTS["Forêt"])

# ── Construction ────────────────────────────────────────────────────────────

func _build() -> void:
	if _root != null:
		_root.queue_free()
	_root = Control.new()
	_root.name = "CityRoot"
	_root.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(_root)

	# Fond aux couleurs de la nation
	var nd: Dictionary = Nations.DATA.get(_biome, {})
	var pal: Dictionary = nd.get("pal", {})
	var top: Color = pal.get("l_t", _accent.darkened(0.55)).darkened(0.35)
	var bot: Color = pal.get("r_b", _accent.darkened(0.8)).darkened(0.35)
	var grad := Gradient.new()
	grad.set_color(0, top)
	grad.set_color(1, bot)
	var gt := GradientTexture2D.new()
	gt.gradient = grad
	gt.fill_from = Vector2(0.5, 0.0)
	gt.fill_to = Vector2(0.5, 1.0)
	var bg := TextureRect.new()
	bg.texture = gt
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	bg.stretch_mode = TextureRect.STRETCH_SCALE
	bg.mouse_filter = Control.MOUSE_FILTER_STOP
	_root.add_child(bg)
	# Voile d'ambiance (brume de la nation)
	var mist := ColorRect.new()
	mist.color = Color(pal.get("mist", _accent.lightened(0.5)), 0.07)
	mist.set_anchors_preset(Control.PRESET_FULL_RECT)
	mist.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_root.add_child(mist)

	var margin := MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	for side: String in ["left", "right"]:
		margin.add_theme_constant_override("margin_" + side, 28)
	margin.add_theme_constant_override("margin_top", 18)
	margin.add_theme_constant_override("margin_bottom", 18)
	_root.add_child(margin)
	_body = VBoxContainer.new()
	_body.add_theme_constant_override("separation", 12)
	margin.add_child(_body)
	_render()

func _render() -> void:
	for c: Node in _body.get_children():
		c.queue_free()
	_build_top_bar()
	var cols := HBoxContainer.new()
	cols.size_flags_vertical = Control.SIZE_EXPAND_FILL
	cols.add_theme_constant_override("separation", 18)
	_body.add_child(cols)
	var left := VBoxContainer.new()
	left.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	left.size_flags_stretch_ratio = 1.75
	left.add_theme_constant_override("separation", 12)
	cols.add_child(left)
	_build_scene(left)
	_build_districts(left)
	_build_council(cols)

func _build_top_bar() -> void:
	var bar := HBoxContainer.new()
	bar.add_theme_constant_override("separation", 16)
	_body.add_child(bar)
	var back := _btn("← CARTE", Color(0.20, 0.24, 0.30), 24, Vector2(190, 62))
	back.name = "BackButton"
	back.pressed.connect(close)
	bar.add_child(back)
	var lvl: int = ConquestSystem.city_level(_conq(), _city_id)
	var titles := VBoxContainer.new()
	titles.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	bar.add_child(titles)
	var t := _lbl("%s  ·  %s" % [ConquestSystem.level_name(lvl).to_upper(), ProgressionManager.conquest_city_name(_city_id).to_upper()], 36, GOLD)
	t.name = "CityTitle"
	titles.add_child(t)
	var nation: String = String(Nations.DATA.get(_biome, {}).get("nation", ProgressionManager.biome_label(_biome)))
	titles.add_child(_lbl("Nation %s  ·  niveau %d / %d" % [nation, lvl, ConquestSystem.MAX_LEVEL], 20, DIM))
	var chips := HBoxContainer.new()
	chips.add_theme_constant_override("separation", 8)
	bar.add_child(chips)
	chips.add_child(_chip("🪙 %d" % int(_save.get("gold", 0)), GOLD))
	var res: Dictionary = _save.get("resources", {})
	for r: String in ["Bois", "Fer", "Cuir", "Magie", "Venin"]:
		chips.add_child(_chip("%s %d" % [r, int(res.get(r, 0))], RES_COLORS[r]))

func _build_scene(parent: Control) -> void:
	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(0, 250)
	panel.add_theme_stylebox_override("panel", _box(Color(0.04, 0.06, 0.09, 0.55), _accent, 3, 18))
	parent.add_child(panel)
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 20)
	panel.add_child(row)
	if _sprite != null:
		var tr := TextureRect.new()
		tr.name = "CityIllustration"
		tr.texture = _sprite
		tr.custom_minimum_size = Vector2(300, 220)
		tr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		tr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		row.add_child(tr)
	var txt := VBoxContainer.new()
	txt.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	txt.alignment = BoxContainer.ALIGNMENT_CENTER
	row.add_child(txt)
	var desc := _lbl(_desc if _desc != "" else String(Nations.DATA.get(_biome, {}).get("trait", "")), 22, TEXT)
	desc.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	txt.add_child(desc)
	var trait_txt: String = String(Nations.DATA.get(_biome, {}).get("trait", ""))
	if trait_txt != "":
		var tl := _lbl(trait_txt, 18, DIM)
		tl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		txt.add_child(tl)
	if _info != "":
		var il := _lbl(_info, 20, GOLD)
		il.name = "InfoLine"
		il.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		txt.add_child(il)

func _build_districts(parent: Control) -> void:
	parent.add_child(_lbl("QUARTIERS", 22, GOLD))
	var sc := ScrollContainer.new()
	TouchScroll.install(sc)
	sc.size_flags_vertical = Control.SIZE_EXPAND_FILL
	sc.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	parent.add_child(sc)
	var grid := GridContainer.new()
	grid.columns = 3
	grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	grid.add_theme_constant_override("h_separation", 12)
	grid.add_theme_constant_override("v_separation", 12)
	sc.add_child(grid)
	_card_hall(grid)
	_card_barracks(grid)
	_card_residence(grid)
	for key: String in ProgressionManager.CONQUEST_BUILDINGS.keys():
		_card_building(grid, key)

# ── Cartes de quartier ──────────────────────────────────────────────────────

func _card(grid: Control, glyph: String, title: String, color: Color) -> VBoxContainer:
	var p := PanelContainer.new()
	p.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	p.add_theme_stylebox_override("panel", _box(Color(0.05, 0.08, 0.12, 0.82), color, 2, 14))
	grid.add_child(p)
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 6)
	p.add_child(v)
	v.add_child(_lbl("%s  %s" % [glyph, title], 23, color.lightened(0.3)))
	return v

func _card_hall(grid: Control) -> void:
	var v := _card(grid, "★", _names()["hall"], GOLD)
	v.name = "CardHall"
	var lvl: int = ConquestSystem.city_level(_conq(), _city_id)
	v.add_child(_wrap("Fait évoluer la ville : garnison plus grande, production et défense accrues.", 17, DIM))
	if lvl >= ConquestSystem.MAX_LEVEL:
		v.add_child(_lbl("★ %s — niveau maximum" % ConquestSystem.level_name(lvl), 20, GOOD))
		return
	var cost: Dictionary = ConquestSystem.upgrade_cost(_conq(), _city_id)
	var gold: int = int(_save.get("gold", 0))
	var res: Dictionary = _save.get("resources", {})
	var ok: bool = gold >= int(cost["gold"]) and not ProgressionManager._is_city_ravaged(_conq(), _city_id)
	var parts: Array = ["%d or" % int(cost["gold"])]
	for r: String in cost["res"].keys():
		parts.append("%s %d/%d" % [r, int(res.get(r, 0)), int(cost["res"][r])])
		ok = ok and int(res.get(r, 0)) >= int(cost["res"][r])
	v.add_child(_wrap(" · ".join(PackedStringArray(parts)), 17, GOOD if ok else BAD))
	var b := _btn("⬆ %s → %s" % [ConquestSystem.level_name(lvl), ConquestSystem.level_name(lvl + 1)], Color(0.24, 0.34, 0.16), 19, Vector2(0, 54))
	b.name = "UpgradeButton"
	b.disabled = not ok
	b.pressed.connect(func() -> void:
		_act(ProgressionManager.conquest_upgrade_city(_save, _city_id)))
	v.add_child(b)

func _card_barracks(grid: Control) -> void:
	var v := _card(grid, "♜", _names()["barracks"], Color(0.55, 0.68, 0.95))
	v.name = "CardBarracks"
	var troops: int = ConquestSystem.troops(_conq(), _city_id)
	var cap: int = ConquestSystem.garrison_cap(_conq(), _city_id)
	v.add_child(_lbl("Garnison : %d / %d soldats" % [troops, cap], 20, TEXT))
	v.add_child(_wrap("Chaque soldat renforce la défense contre les offensives ennemies.", 17, DIM))
	if _city_id == "capitale":
		v.add_child(_wrap("La capitale est à l'abri des attaques.", 17, DIM))
		return
	var gold: int = int(_save.get("gold", 0))
	var room: int = cap - troops
	var b1 := _btn("RECRUTER +1 — %d or" % ConquestSystem.TROOP_COST, Color(0.20, 0.28, 0.40), 19, Vector2(0, 50))
	b1.name = "RecruitButton"
	b1.disabled = room < 1 or gold < ConquestSystem.TROOP_COST
	b1.pressed.connect(func() -> void: _act(ProgressionManager.conquest_recruit(_save, _city_id, 1)))
	v.add_child(b1)
	if room > 1:
		var b2 := _btn("REMPLIR (+%d) — %d or" % [room, room * ConquestSystem.TROOP_COST], Color(0.20, 0.28, 0.40), 19, Vector2(0, 50))
		b2.name = "FillButton"
		b2.disabled = gold < room * ConquestSystem.TROOP_COST
		b2.pressed.connect(func() -> void: _act(ProgressionManager.conquest_recruit(_save, _city_id, room)))
		v.add_child(b2)

func _card_residence(grid: Control) -> void:
	var v := _card(grid, "♞", _names()["residence"], Color(0.85, 0.62, 0.90))
	v.name = "CardResidence"
	var hero: String = ConquestSystem.hero_of(_conq(), _city_id)
	if hero != "":
		var row := HBoxContainer.new()
		row.add_theme_constant_override("separation", 10)
		v.add_child(row)
		var tex_path := "res://assets/sprites/players/%s.png" % EntityView.sprite_key(hero)
		if ResourceLoader.exists(tex_path):
			var tr := TextureRect.new()
			tr.texture = load(tex_path)
			tr.custom_minimum_size = Vector2(70, 70)
			tr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			tr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			row.add_child(tr)
		var tv := VBoxContainer.new()
		tv.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(tv)
		tv.add_child(_lbl("%s (niv. %d)" % [hero, ConquestSystem.hero_level(_save, hero)], 21, TEXT))
		tv.add_child(_wrap(ConquestSystem.governor_text(hero), 16, DIM))
		var b := _btn("RAPPELER LE GOUVERNEUR", Color(0.36, 0.24, 0.32), 18, Vector2(0, 50))
		b.name = "RecallButton"
		b.pressed.connect(func() -> void:
			ProgressionManager.conquest_recall_hero(_save, _city_id)
			_act(""))
		v.add_child(b)
	else:
		v.add_child(_wrap("Un héros gouverneur défend la ville et la fait prospérer, mais ne combat plus en assaut.", 17, DIM))
		var b2 := _btn("NOMMER UN GOUVERNEUR", Color(0.32, 0.24, 0.38), 19, Vector2(0, 54))
		b2.name = "GovernorButton"
		b2.pressed.connect(_show_governor_picker)
		v.add_child(b2)

func _card_building(grid: Control, key: String) -> void:
	var info: Dictionary = ProgressionManager.CONQUEST_BUILDINGS[key]
	var builds: Array = _conq().get("buildings", {}).get(_city_id, [])
	var built: bool = builds.has(key)
	var v := _card(grid, "⚒", String(info["label"]), Color(0.62, 0.74, 0.55) if built else Color(0.72, 0.68, 0.50))
	v.name = "CardBuilding_" + key
	var yparts: Array = []
	for r: String in info.get("yield", {}).keys():
		yparts.append("%s +%d par victoire" % [r, int(info["yield"][r])])
	v.add_child(_wrap(" · ".join(PackedStringArray(yparts)) if yparts.size() > 0 else "Renforce les remparts (+6 défense).", 17, DIM))
	if built:
		v.add_child(_lbl("✓ Construit", 20, GOOD))
		return
	var res: Dictionary = _save.get("resources", {})
	var ok: bool = int(_save.get("gold", 0)) >= int(info.get("gold", 0))
	var cparts: Array = ["%d or" % int(info.get("gold", 0))]
	for r: String in info.get("cost", {}).keys():
		cparts.append("%s %d/%d" % [r, int(res.get(r, 0)), int(info["cost"][r])])
		ok = ok and int(res.get(r, 0)) >= int(info["cost"][r])
	v.add_child(_wrap(" · ".join(PackedStringArray(cparts)), 17, GOOD if ok else BAD))
	var b := _btn("CONSTRUIRE", Color(0.22, 0.30, 0.20), 19, Vector2(0, 50))
	b.name = "BuildButton_" + key
	b.disabled = not ok
	b.pressed.connect(func() -> void: _act(ProgressionManager.conquest_build(_save, _city_id, key)))
	v.add_child(b)

# ── Conseil de la ville (colonne de droite) ─────────────────────────────────

func _build_council(parent: Control) -> void:
	var p := PanelContainer.new()
	p.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	p.size_flags_stretch_ratio = 1.0
	p.add_theme_stylebox_override("panel", _box(Color(0.04, 0.06, 0.09, 0.78), GOLD, 3, 18))
	parent.add_child(p)
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 10)
	p.add_child(v)
	v.add_child(_lbl("CONSEIL DE LA VILLE", 26, GOLD))
	var conq: Dictionary = _conq()
	var lvl: int = ConquestSystem.city_level(conq, _city_id)
	v.add_child(_lbl("%s — niveau %d / %d" % [ConquestSystem.level_name(lvl), lvl, ConquestSystem.MAX_LEVEL], 22, TEXT))
	v.add_child(_pips(lvl, ConquestSystem.MAX_LEVEL, GOLD))
	var troops: int = ConquestSystem.troops(conq, _city_id)
	var cap: int = ConquestSystem.garrison_cap(conq, _city_id)
	v.add_child(_lbl("♜ Garnison %d / %d" % [troops, cap], 22, TEXT))
	v.add_child(_pips(troops, cap, Color(0.55, 0.68, 0.95)))
	v.add_child(_lbl("Défense : %d" % ConquestSystem.defense(_save, _city_id), 22, TEXT))
	v.add_child(_lbl("Revenu : +%d or par victoire" % ConquestSystem.city_income(_save, _city_id), 22, GOOD))
	var hero: String = ConquestSystem.hero_of(conq, _city_id)
	v.add_child(_lbl("♞ Gouverneur : %s" % (hero if hero != "" else "aucun"), 22, TEXT))
	if ProgressionManager._is_city_ravaged(conq, _city_id):
		v.add_child(_wrap("⚠ Ville PILLÉE : production gelée (%d bataille(s))." % int(conq.get("ravage", {}).get(_city_id, 0)), 19, BAD))
	var th: Dictionary = ConquestSystem.threat(conq)
	if String(th.get("city", "")) == _city_id:
		var tl := _wrap("⚠ OFFENSIVE dans %d bataille(s) — force ennemie %d. Renforcez la garnison !" % [int(th["eta"]), int(th["power"])], 19, BAD)
		tl.name = "ThreatLine"
		v.add_child(tl)
	var yld: Dictionary = {}
	var mult: float = ConquestSystem.level_multiplier(conq, _city_id)
	for b: String in conq.get("buildings", {}).get(_city_id, []):
		for r: String in ProgressionManager.CONQUEST_BUILDINGS.get(b, {}).get("yield", {}).keys():
			yld[r] = int(yld.get(r, 0)) + roundi(float(ProgressionManager.CONQUEST_BUILDINGS[b]["yield"][r]) * mult)
	if yld.size() > 0:
		var parts: Array = []
		for r: String in yld.keys():
			parts.append("%s +%d" % [r, int(yld[r])])
		v.add_child(_wrap("Production : " + " · ".join(PackedStringArray(parts)), 19, TEXT))
	var spacer := Control.new()
	spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	v.add_child(spacer)
	v.add_child(_wrap("Les bonus du biome s'obtiennent en contrôlant toutes ses villes.", 16, DIM))

# ── Gouverneur ──────────────────────────────────────────────────────────────

func _show_governor_picker() -> void:
	var dim := ColorRect.new()
	dim.name = "GovernorPicker"
	dim.color = Color(0.01, 0.02, 0.04, 0.84)
	dim.set_anchors_preset(Control.PRESET_FULL_RECT)
	dim.mouse_filter = Control.MOUSE_FILTER_STOP
	_root.add_child(dim)
	var panel := PanelContainer.new()
	panel.add_theme_stylebox_override("panel", _box(Color(0.08, 0.12, 0.17, 0.99), GOLD, 3, 18))
	panel.custom_minimum_size = Vector2(900, 0)
	panel.set_anchors_and_offsets_preset(Control.PRESET_CENTER, Control.PRESET_MODE_MINSIZE, 0)
	dim.add_child(panel)
	var outer := VBoxContainer.new()
	outer.add_theme_constant_override("separation", 10)
	panel.add_child(outer)
	outer.add_child(_lbl("GOUVERNEUR — %s" % String(_names()["residence"]).to_upper(), 28, GOLD))
	outer.add_child(_wrap("Un gouverneur défend la ville et la fait prospérer, mais ne combat plus en assaut.", 18, DIM))
	var sc := ScrollContainer.new()
	TouchScroll.install(sc)
	sc.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	sc.custom_minimum_size.y = 520
	outer.add_child(sc)
	var list := VBoxContainer.new()
	list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	list.add_theme_constant_override("separation", 8)
	sc.add_child(list)
	for classe: String in ProgressionManager.CLASS_ORDER:
		var elsewhere: String = ConquestSystem.hero_city(_conq(), classe)
		var b := _btn("%s — niv. %d · %s" % [classe, ConquestSystem.hero_level(_save, classe), ConquestSystem.governor_text(classe)],
			Color(0.20, 0.24, 0.32), 18, Vector2(0, 58))
		b.name = "Pick_" + classe
		b.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		if elsewhere != "":
			b.text = "%s — déjà en poste à %s" % [classe, ProgressionManager.conquest_city_name(elsewhere)]
			b.disabled = true
		else:
			b.pressed.connect(func() -> void:
				dim.queue_free()
				_act(ProgressionManager.conquest_assign_hero(_save, _city_id, classe)))
		list.add_child(b)
	var cancel := _btn("ANNULER", Color(0.30, 0.20, 0.20), 20, Vector2(0, 54))
	cancel.pressed.connect(func() -> void: dim.queue_free())
	outer.add_child(cancel)

# ── Actions ─────────────────────────────────────────────────────────────────

## Applique le résultat d'une action de gestion : erreur affichée, sinon sauvegarde.
func _act(err: String) -> void:
	_info = err
	ProgressionManager.write_save(_slot, _save)
	_render()

func close() -> void:
	ProgressionManager.write_save(_slot, _save)
	closed.emit()

# ── Petits utilitaires d'interface ──────────────────────────────────────────

func _lbl(t: String, size: int, col: Color) -> Label:
	var l := Label.new()
	l.text = t
	l.add_theme_font_size_override("font_size", size)
	l.add_theme_color_override("font_color", col)
	return l

func _wrap(t: String, size: int, col: Color) -> Label:
	var l := _lbl(t, size, col)
	l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	l.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	return l

func _chip(t: String, col: Color) -> PanelContainer:
	var p := PanelContainer.new()
	p.add_theme_stylebox_override("panel", _box(Color(0.03, 0.05, 0.08, 0.8), col.darkened(0.3), 2, 18))
	p.add_child(_lbl(t, 20, col))
	return p

func _pips(n: int, total: int, col: Color) -> Control:
	var h := HBoxContainer.new()
	h.add_theme_constant_override("separation", 4)
	for i: int in range(total):
		var r := ColorRect.new()
		r.custom_minimum_size = Vector2(22 if total <= 8 else 14, 12)
		r.color = col if i < n else Color(0.18, 0.2, 0.28)
		h.add_child(r)
	return h

func _btn(t: String, col: Color, size: int, min_size: Vector2) -> Button:
	var b := Button.new()
	b.text = t
	b.custom_minimum_size = min_size
	b.add_theme_font_size_override("font_size", size)
	b.add_theme_color_override("font_color", TEXT)
	b.add_theme_color_override("font_disabled_color", Color(0.55, 0.57, 0.60))
	b.add_theme_stylebox_override("normal", _box(col, col.lightened(0.35), 2, 12))
	b.add_theme_stylebox_override("hover", _box(col.lightened(0.15), GOLD, 3, 12))
	b.add_theme_stylebox_override("pressed", _box(col.darkened(0.15), GOLD, 3, 12))
	b.add_theme_stylebox_override("disabled", _box(col.darkened(0.55), col.darkened(0.2), 1, 12))
	return b

func _box(bg: Color, border: Color, bw: int, radius: int) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = bg
	s.border_color = border
	s.set_border_width_all(bw)
	s.set_corner_radius_all(radius)
	s.content_margin_left = 14
	s.content_margin_right = 14
	s.content_margin_top = 10
	s.content_margin_bottom = 10
	return s
