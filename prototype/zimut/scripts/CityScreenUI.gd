class_name CityScreenUI
extends CanvasLayer

## CityScreenUI.gd — « Entrer dans la ville » (mode Conquête).
## Fenêtre plein écran propre à la nation de la ville. V61 : la ville est dessinée
## (ConquestCityView) — on touche un bâtiment pour le gérer dans le panneau de droite :
## Hôtel de ville (Hameau → Métropole), caserne, résidence du gouverneur, six bâtiments
## de production à trois niveaux et la Merveille de la Nation.
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
	"Rouages": {"hall": "Grand Atelier", "barracks": "Corps des Ingénieurs", "residence": "Manoir de l'Horloger"},
	"Donjon": {"hall": "Salle du Trône", "barracks": "Geôles-Casernes", "residence": "Tour du Roi"},
}
## Illustration de chaque nation (assets/ui/conquest/cities/).
const ART := {"Forêt": "sylvestre", "Montagne": "cimes", "Désert": "sables", "Cristaux": "cristaux", "Marées": "marees",
	"Vents": "vents", "Brasier": "brasier", "Brumes": "brumes", "Ombres": "ombres", "Rouages": "rouages", "Donjon": "donjon"}
## Illustration de remplacement tant que celle de la nation manque.
const ART_FALLBACK := {"rouages": "brasier"}


## Clé d'illustration d'un biome (avec repli si le fichier n'existe pas encore).
static func art_key(biome: String) -> String:
	var k: String = String(ART.get(biome, "sylvestre"))
	if not ResourceLoader.exists("res://assets/ui/conquest/cities/%s.jpg" % k):
		k = String(ART_FALLBACK.get(k, "sylvestre"))
	return k
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
var _selected: String = "hall"      # quartier affiché à droite (V61)
var _celebrate: String = ""         # effet à jouer après une construction réussie
var _view: ConquestCityView = null

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
	Gultur.say(self, "ville_v61", Gultur.VILLE_V61, _view)

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
	add_child(_root)
	UiFit.apply(_root, 1.1, Vector2(1300, 740))   # lisible sur smartphone

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
	# Illustration de la nation en fond, assombrie
	var art_path: String = "res://assets/ui/conquest/cities/%s.jpg" % art_key(_biome)
	var art: Texture2D = load(art_path) as Texture2D if ResourceLoader.exists(art_path) else null
	if art != null:
		var bgi := TextureRect.new()
		bgi.name = "CityArtBackground"
		bgi.texture = art
		bgi.set_anchors_preset(Control.PRESET_FULL_RECT)
		bgi.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		bgi.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
		bgi.modulate = Color(0.45, 0.45, 0.5)
		bgi.mouse_filter = Control.MOUSE_FILTER_IGNORE
		_root.add_child(bgi)
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
	cols.add_theme_constant_override("separation", 16)
	_body.add_child(cols)
	# Vue illustrée de la ville (V61) : on touche un bâtiment pour le gérer à droite.
	var frame := PanelContainer.new()
	frame.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	frame.size_flags_stretch_ratio = 1.65
	var fs := _box(Color(0.02, 0.03, 0.05, 0.9), _accent, 3, 18)
	fs.set_content_margin_all(4)
	frame.add_theme_stylebox_override("panel", fs)
	cols.add_child(frame)
	_view = ConquestCityView.new()
	_view.name = "CityView"
	_view.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_fill_view(_view)
	_view.plot_pressed.connect(func(key: String) -> void:
		_selected = key
		_info = ""
		_render())
	frame.add_child(_view)
	if _celebrate != "":
		_view.celebrate.call_deferred(_celebrate)
		_celebrate = ""
	_build_council(cols)

## Remplit la vue avec l'état de la ville.
func _fill_view(v: ConquestCityView) -> void:
	var conq: Dictionary = _conq()
	v.biome = _biome
	v.animate = not GfxQuality.low()
	var art_path: String = "res://assets/ui/conquest/cities/%s.jpg" % art_key(_biome)
	v.art = load(art_path) as Texture2D if ResourceLoader.exists(art_path) else null
	v.city_level = ConquestSystem.city_level(conq, _city_id)
	v.troops = ConquestSystem.troops(conq, _city_id)
	var hero: String = ConquestSystem.hero_of(conq, _city_id)
	if hero != "":
		var tex_path := "res://assets/sprites/players/%s.png" % EntityView.sprite_key(hero)
		v.hero_tex = load(tex_path) as Texture2D if ResourceLoader.exists(tex_path) else null
	var used: int = ConquestSystem.buildings_of(conq, _city_id).size()
	var slots: int = ConquestSystem.building_slots(conq, _city_id)
	for key: String in ProgressionManager.CONQUEST_BUILDINGS.keys():
		var lv: int = ConquestSystem.building_level(conq, _city_id, key)
		v.levels[key] = lv
		v.locked[key] = lv == 0 and used >= slots
	v.wonder = ConquestSystem.has_wonder(conq, _city_id)
	v.wonder_shape = String(ConquestSystem.wonder_for(_biome).get("shape", "tree"))
	v.locked["wonder"] = v.city_level < ConquestSystem.WONDER_MIN_LEVEL
	v.ravaged = ProgressionManager._is_city_ravaged(conq, _city_id) or ConquestSystem.is_ruined(conq, _city_id)
	v.threat = String(ConquestSystem.threat(conq).get("city", "")) == _city_id
	v.selected = _selected
	# V62 : heure du jour, événement de ville et spécialisation (allure de la ville)
	v.time_of_day = ConquestSystem.effective_time(conq, _city_id)
	ConquestSystem.maybe_city_event(conq, _city_id)
	v.city_event = ConquestSystem.city_event(conq, _city_id)
	v.spec = ConquestSystem.city_spec(conq, _city_id)

func _build_top_bar() -> void:
	var bar := HBoxContainer.new()
	bar.add_theme_constant_override("separation", 16)
	_body.add_child(bar)
	var back := _btn("← CARTE", Color(0.20, 0.24, 0.30), 24, Vector2(190, 62))
	back.name = "BackButton"
	back.pressed.connect(close)
	bar.add_child(back)
	# V62 : bouton jour / soir / nuit de la ville
	var tod: String = ConquestSystem.effective_time(_conq(), _city_id)
	var glyph: String = {"jour": "☀", "soir": "🌇", "nuit": "🌙"}.get(tod, "☀")
	var day_btn := _btn(glyph, Color(0.24, 0.22, 0.34), 26, Vector2(70, 62))
	day_btn.tooltip_text = tod.capitalize()
	day_btn.name = "DayNightButton"
	day_btn.pressed.connect(func() -> void:
		ConquestSystem.cycle_time_of_day(_conq(), _city_id)
		ProgressionManager.write_save(_slot, _save)
		_render())
	bar.add_child(day_btn)
	var lvl: int = ConquestSystem.city_level(_conq(), _city_id)
	var titles := VBoxContainer.new()
	titles.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	bar.add_child(titles)
	var t := _lbl("%s  ·  %s" % [ConquestSystem.level_name(lvl).to_upper(), ProgressionManager.conquest_city_name(_city_id).to_upper()], 34, GOLD)
	t.name = "CityTitle"
	t.clip_text = true
	t.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	titles.add_child(t)
	var nation: String = String(Nations.DATA.get(_biome, {}).get("nation", ProgressionManager.biome_label(_biome)))
	var sub := _lbl("Nation %s  ·  niveau %d / %d  ·  %s" % [nation, lvl, ConquestSystem.MAX_LEVEL, _desc], 18, DIM)
	sub.clip_text = true
	sub.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	titles.add_child(sub)
	var chips := HBoxContainer.new()
	chips.add_theme_constant_override("separation", 8)
	bar.add_child(chips)
	chips.add_child(_chip("🪙 %d" % int(_save.get("gold", 0)), GOLD))
	var res: Dictionary = _save.get("resources", {})
	for r: String in ["Bois", "Fer", "Cuir", "Magie", "Venin"]:
		chips.add_child(_chip("%s %d" % [r, int(res.get(r, 0))], RES_COLORS[r]))

# ── Panneau de droite : bâtiment sélectionné + résumé de la ville ──────────

func _build_council(parent: Control) -> void:
	var p := PanelContainer.new()
	p.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	p.size_flags_stretch_ratio = 1.0
	p.add_theme_stylebox_override("panel", _box(Color(0.04, 0.06, 0.09, 0.90), GOLD, 3, 18))
	parent.add_child(p)
	var sc := ScrollContainer.new()
	TouchScroll.install(sc)
	sc.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	p.add_child(sc)
	var v := VBoxContainer.new()
	v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	v.size_flags_vertical = Control.SIZE_EXPAND_FILL
	v.add_theme_constant_override("separation", 8)
	sc.add_child(v)
	match _selected:
		"hall": _detail_hall(v)
		"barracks": _detail_barracks(v)
		"residence": _detail_residence(v)
		"wonder": _detail_wonder(v)
		_: _detail_building(v, _selected)
	if _info != "":
		var il := _wrap(_info, 18, BAD)
		il.name = "InfoLine"
		v.add_child(il)
	var sep := HSeparator.new()
	sep.add_theme_constant_override("separation", 10)
	v.add_child(sep)
	_summary(v)

func _head(v: VBoxContainer, glyph: String, title: String, sub: String, col: Color) -> void:
	v.add_child(_lbl("%s  %s" % [glyph, title], 26, col))
	if sub != "":
		v.add_child(_wrap(sub, 17, DIM))

## Ligne de coût colorée (vert si payable) ; retourne vrai si payable.
func _cost_line(v: VBoxContainer, cost: Dictionary) -> bool:
	var gold: int = int(_save.get("gold", 0))
	var res: Dictionary = _save.get("resources", {})
	var ok: bool = gold >= int(cost.get("gold", 0))
	var parts: Array = ["%d or" % int(cost.get("gold", 0))]
	for r: String in cost.get("res", {}).keys():
		parts.append("%s %d/%d" % [r, int(res.get(r, 0)), int(cost["res"][r])])
		ok = ok and int(res.get(r, 0)) >= int(cost["res"][r])
	v.add_child(_wrap("Coût : " + " · ".join(PackedStringArray(parts)), 18, GOOD if ok else BAD))
	return ok

func _detail_hall(v: VBoxContainer) -> void:
	var conq: Dictionary = _conq()
	var lvl: int = ConquestSystem.city_level(conq, _city_id)
	_head(v, "★", String(_names()["hall"]), "Le cœur de la ville : chaque niveau agrandit la garnison, ouvre des emplacements et des niveaux de bâtiment, et augmente la production.", GOLD)
	v.add_child(_pips(lvl, ConquestSystem.MAX_LEVEL, GOLD))
	v.add_child(_wrap("%s (niveau %d) : garnison %d · %d emplacements · bâtiments niv. %d max · production ×%s" % [
		ConquestSystem.level_name(lvl), lvl, 2 + 2 * lvl, ConquestSystem.BUILD_SLOTS[lvl - 1], ConquestSystem.BUILD_LEVEL_CAP[lvl - 1],
		_fmt_mult(ConquestSystem.LEVEL_MULT[lvl - 1])], 18, TEXT))
	if lvl >= ConquestSystem.MAX_LEVEL:
		v.add_child(_lbl("★ %s — niveau maximum" % ConquestSystem.level_name(lvl), 20, GOOD))
		return
	var nx: int = lvl + 1
	var gains: PackedStringArray = ["garnison %d" % (2 + 2 * nx)]
	if ConquestSystem.BUILD_SLOTS[nx - 1] > ConquestSystem.BUILD_SLOTS[lvl - 1]:
		gains.append("%d emplacements" % ConquestSystem.BUILD_SLOTS[nx - 1])
	if ConquestSystem.BUILD_LEVEL_CAP[nx - 1] > ConquestSystem.BUILD_LEVEL_CAP[lvl - 1]:
		gains.append("bâtiments niv. %d" % ConquestSystem.BUILD_LEVEL_CAP[nx - 1])
	gains.append("production ×%s" % _fmt_mult(ConquestSystem.LEVEL_MULT[nx - 1]))
	if nx == ConquestSystem.WONDER_MIN_LEVEL:
		gains.append("Merveille de la Nation")
	v.add_child(_wrap("→ %s : %s" % [ConquestSystem.level_name(nx), " · ".join(gains)], 18, Color(1.0, 0.86, 0.55)))
	var ok: bool = _cost_line(v, ConquestSystem.upgrade_cost(conq, _city_id)) and not ProgressionManager._is_city_ravaged(conq, _city_id)
	var b := _btn("⬆ %s → %s" % [ConquestSystem.level_name(lvl), ConquestSystem.level_name(nx)], Color(0.24, 0.34, 0.16), 21, Vector2(0, 58))
	b.name = "UpgradeButton"
	b.disabled = not ok
	b.pressed.connect(func() -> void:
		_act(ProgressionManager.conquest_upgrade_city(_save, _city_id), "hall"))
	v.add_child(b)

func _detail_barracks(v: VBoxContainer) -> void:
	var conq: Dictionary = _conq()
	var troops: int = ConquestSystem.troops(conq, _city_id)
	var cap: int = ConquestSystem.garrison_cap(conq, _city_id)
	_head(v, "♜", String(_names()["barracks"]), "Chaque soldat ajoute 2 de défense contre les offensives ennemies.", Color(0.62, 0.74, 1.0))
	v.add_child(_lbl("Garnison : %d / %d soldats" % [troops, cap], 21, TEXT))
	v.add_child(_pips(troops, cap, Color(0.55, 0.68, 0.95)))
	if _city_id == "capitale":
		v.add_child(_wrap("La capitale est à l'abri des attaques.", 17, DIM))
		return
	var gold: int = int(_save.get("gold", 0))
	var room: int = cap - troops
	var b1 := _btn("RECRUTER +1 — %d or" % ConquestSystem.TROOP_COST, Color(0.20, 0.28, 0.40), 20, Vector2(0, 54))
	b1.name = "RecruitButton"
	b1.disabled = room < 1 or gold < ConquestSystem.TROOP_COST
	b1.pressed.connect(func() -> void: _act(ProgressionManager.conquest_recruit(_save, _city_id, 1)))
	v.add_child(b1)
	if room > 1:
		var b2 := _btn("REMPLIR (+%d) — %d or" % [room, room * ConquestSystem.TROOP_COST], Color(0.20, 0.28, 0.40), 20, Vector2(0, 54))
		b2.name = "FillButton"
		b2.disabled = gold < room * ConquestSystem.TROOP_COST
		b2.pressed.connect(func() -> void: _act(ProgressionManager.conquest_recruit(_save, _city_id, room)))
		v.add_child(b2)
	if room <= 0:
		v.add_child(_wrap("Garnison pleine : faites évoluer l'%s pour l'agrandir." % String(_names()["hall"]), 17, DIM))

func _detail_residence(v: VBoxContainer) -> void:
	var hero: String = ConquestSystem.hero_of(_conq(), _city_id)
	_head(v, "♞", String(_names()["residence"]), "Un héros gouverneur défend la ville et la fait prospérer, mais ne combat plus en assaut.", Color(0.90, 0.70, 0.95))
	if hero != "":
		v.add_child(_lbl("%s (niv. %d)" % [hero, ConquestSystem.hero_level(_save, hero)], 22, TEXT))
		v.add_child(_wrap(ConquestSystem.governor_text(hero), 18, GOOD))
		var gdef: int = ConquestSystem.governor_gear_defense(_save, hero)
		var ggold: int = ConquestSystem.governor_gear_gold(_save, hero)
		v.add_child(_wrap("Équipement : +%d défense · +%d or par victoire (à équiper dans Personnages › Équipement)" % [gdef, ggold], 16, DIM))
		var b := _btn("RAPPELER LE GOUVERNEUR", Color(0.36, 0.24, 0.32), 19, Vector2(0, 54))
		b.name = "RecallButton"
		b.pressed.connect(func() -> void:
			ProgressionManager.conquest_recall_hero(_save, _city_id)
			_act(""))
		v.add_child(b)
	else:
		var b2 := _btn("NOMMER UN GOUVERNEUR", Color(0.32, 0.24, 0.38), 20, Vector2(0, 58))
		b2.name = "GovernorButton"
		b2.pressed.connect(_show_governor_picker)
		v.add_child(b2)

func _detail_building(v: VBoxContainer, key: String) -> void:
	var conq: Dictionary = _conq()
	var info: Dictionary = ProgressionManager.CONQUEST_BUILDINGS.get(key, {})
	if info.is_empty():
		_selected = "hall"
		_detail_hall(v)
		return
	var lv: int = ConquestSystem.building_level(conq, _city_id, key)
	var label: String = String(info["label"]).split(" (")[0]
	_head(v, "⚒", label, "", Color(0.75, 0.88, 0.62) if lv > 0 else Color(0.85, 0.80, 0.60))
	if lv > 0:
		v.add_child(_pips(lv, ConquestSystem.BUILD_MAX_LEVEL, GOLD))
		v.add_child(_wrap("Niveau %d / %d : %s" % [lv, ConquestSystem.BUILD_MAX_LEVEL, _effect_text(key, info, lv)], 19, TEXT))
	else:
		v.add_child(_wrap("Pas encore construit. Au niveau 1 : %s" % _effect_text(key, info, 1), 18, TEXT))
	var used: int = ConquestSystem.buildings_of(conq, _city_id).size()
	var slots: int = ConquestSystem.building_slots(conq, _city_id)
	if lv == 0:
		v.add_child(_wrap("Emplacements utilisés : %d / %d" % [used, slots], 17, DIM))
		if used >= slots:
			v.add_child(_wrap("🔒 Plus d'emplacement : la ville doit devenir %s." % ConquestSystem.level_name(ConquestSystem.city_level_for_slots(used + 1)), 18, BAD))
			return
		var ok: bool = _cost_line(v, ConquestSystem.building_cost(info, 1)) and not ProgressionManager._is_city_ravaged(conq, _city_id)
		var b := _btn("CONSTRUIRE", Color(0.22, 0.30, 0.20), 21, Vector2(0, 58))
		b.name = "BuildButton_" + key
		b.disabled = not ok
		b.pressed.connect(func() -> void: _act(ProgressionManager.conquest_build(_save, _city_id, key), key))
		v.add_child(b)
		return
	if lv >= ConquestSystem.BUILD_MAX_LEVEL:
		v.add_child(_lbl("★ Niveau maximum", 20, GOOD))
		return
	v.add_child(_wrap("→ Niveau %d : %s" % [lv + 1, _effect_text(key, info, lv + 1)], 18, Color(1.0, 0.86, 0.55)))
	if lv >= ConquestSystem.building_level_cap(conq, _city_id):
		v.add_child(_wrap("🔒 La ville doit devenir %s pour ce niveau." % ConquestSystem.level_name(ConquestSystem.city_level_for_building(lv + 1)), 18, BAD))
		return
	var ok2: bool = _cost_line(v, ConquestSystem.building_cost(info, lv + 1)) and not ProgressionManager._is_city_ravaged(conq, _city_id)
	var b2 := _btn("⬆ AMÉLIORER (niveau %d)" % (lv + 1), Color(0.24, 0.34, 0.16), 21, Vector2(0, 58))
	b2.name = "UpgradeBuilding_" + key
	b2.disabled = not ok2
	b2.pressed.connect(func() -> void: _act(ProgressionManager.conquest_upgrade_building(_save, _city_id, key), key))
	v.add_child(b2)

## Effet d'un bâtiment à un niveau donné (production réelle, facteur de la ville compris).
func _effect_text(key: String, info: Dictionary, lv: int) -> String:
	if key == "muraille":
		return "+%d défense" % ConquestSystem.WALL_DEFENSE_BY_LEVEL[lv - 1]
	var y: Dictionary = ConquestSystem.building_yield_at(info, lv)
	var mult: float = ConquestSystem.level_multiplier(_conq(), _city_id)
	var parts: Array = []
	for r: String in y.keys():
		parts.append("%s +%d" % [r, roundi(float(y[r]) * mult)])
	return " · ".join(PackedStringArray(parts)) + " par victoire"

func _detail_wonder(v: VBoxContainer) -> void:
	var conq: Dictionary = _conq()
	var w: Dictionary = ConquestSystem.wonder_for(_biome)
	_head(v, "✦", "Merveille — %s" % String(w["label"]), String(w["text"]), GOLD)
	var fx: PackedStringArray = []
	if int(w.get("gold", 0)) > 0:
		fx.append("+%d or" % int(w["gold"]))
	for r: String in w.get("res", {}).keys():
		fx.append("%s +%d" % [r, int(w["res"][r])])
	var eff: String = "Effet : %s par victoire" % " · ".join(fx)
	if int(w.get("def", 0)) > 0:
		eff += "  ·  +%d défense" % int(w["def"])
	v.add_child(_wrap(eff, 18, TEXT))
	if ConquestSystem.has_wonder(conq, _city_id):
		v.add_child(_lbl("★ Bâtie — elle rayonne sur toute la ville", 20, GOOD))
		return
	if ConquestSystem.city_level(conq, _city_id) < ConquestSystem.WONDER_MIN_LEVEL:
		v.add_child(_wrap("🔒 La ville doit devenir une %s." % ConquestSystem.level_name(ConquestSystem.WONDER_MIN_LEVEL), 18, BAD))
		return
	var ok: bool = _cost_line(v, ConquestSystem.wonder_cost(_biome)) and not ProgressionManager._is_city_ravaged(conq, _city_id)
	var b := _btn("✦ BÂTIR LA MERVEILLE", Color(0.40, 0.30, 0.10), 21, Vector2(0, 58))
	b.name = "WonderButton"
	b.disabled = not ok
	b.pressed.connect(func() -> void: _act(ProgressionManager.conquest_build_wonder(_save, _city_id), "wonder"))
	v.add_child(b)

## Résumé compact de la ville, sous le bâtiment sélectionné.
func _summary(v: VBoxContainer) -> void:
	var conq: Dictionary = _conq()
	var lvl: int = ConquestSystem.city_level(conq, _city_id)
	v.add_child(_lbl("CONSEIL DE LA VILLE", 20, GOLD))
	v.add_child(_wrap("♜ %d/%d  ·  Défense %d  ·  🪙 +%d or" % [ConquestSystem.troops(conq, _city_id), ConquestSystem.garrison_cap(conq, _city_id),
		ConquestSystem.defense(_save, _city_id), ConquestSystem.city_income(_save, _city_id)], 18, TEXT))
	v.add_child(_wrap("⚒ Bâtiments %d/%d  ·  production ×%s" % [ConquestSystem.buildings_of(conq, _city_id).size(), ConquestSystem.building_slots(conq, _city_id), _fmt_mult(ConquestSystem.LEVEL_MULT[lvl - 1])], 17, DIM))
	var yld: Dictionary = ProgressionManager.conquest_city_building_yield(conq, _city_id)
	if yld.size() > 0:
		var parts: Array = []
		for r: String in yld.keys():
			parts.append("%s +%d" % [r, int(yld[r])])
		v.add_child(_wrap("Production : " + " · ".join(PackedStringArray(parts)), 17, GOOD))
	var city_trait: Dictionary = ProgressionManager.conquest_city_trait(_city_id, conq)
	if String(city_trait.get("label", "")) != "":
		var tp: Array = []
		for r: String in city_trait.get("yield", {}).keys():
			tp.append("%s +%d" % [r, int(city_trait["yield"][r])])
		v.add_child(_wrap("Spécialité — %s : %s" % [String(city_trait["label"]), " · ".join(PackedStringArray(tp))], 17, GOOD))
	if ProgressionManager._is_city_ravaged(conq, _city_id):
		v.add_child(_wrap("⚠ Ville PILLÉE : production gelée (%d bataille(s))." % int(conq.get("ravage", {}).get(_city_id, 0)), 17, BAD))
	if ConquestSystem.is_ruined(conq, _city_id):
		v.add_child(_wrap("⚒ Ville RUINÉE : production gelée %d bataille(s) — réparable sur la carte (%d or)." % [int(conq.get("ruin", {}).get(_city_id, 0)), ConquestSystem.RUIN_REPAIR_GOLD], 17, BAD))
	var th: Dictionary = ConquestSystem.threat(conq)
	if String(th.get("city", "")) == _city_id:
		var tl := _wrap("⚠ OFFENSIVE dans %d bataille(s) — force ennemie %d. Renforcez la garnison !" % [int(th["eta"]), int(th["power"])], 17, BAD)
		tl.name = "ThreatLine"
		v.add_child(tl)
	# V62 : spécialisation de la Cité (choix au niveau 3) et événement de ville en cours
	_build_spec_choice(v, conq, lvl)
	var ev: String = ConquestSystem.city_event(conq, _city_id)
	if ev != "":
		var ev_txt: String = {"fete": "🎉 Fête dans la ville : étals et feu de joie sur la place.",
			"incendie": "🔥 Incendie dans la ville ! La fumée monte sur l'hôtel de ville.",
			"marchand": "🛒 Un marchand de passage dresse sa charrette près de la place."}.get(ev, "")
		v.add_child(_wrap(ev_txt, 17, Color(1.0, 0.85, 0.45)))

## V62 — choix de la spécialisation quand la ville devient une Cité (niveau 3).
func _build_spec_choice(v: VBoxContainer, conq: Dictionary, lvl: int) -> void:
	if lvl < ConquestSystem.SPEC_MIN_LEVEL:
		return
	var cur: String = ConquestSystem.city_spec(conq, _city_id)
	if cur != "":
		var s: Dictionary = ConquestSystem.CITY_SPECS[cur]
		v.add_child(_wrap("⚑ Spécialisation : %s — %s" % [String(s["label"]), String(s["text"])], 17, Color(0.85, 0.75, 1.0)))
		return
	v.add_child(_lbl("⚑ Choisissez la spécialisation de la Cité :", 19, Color(0.85, 0.75, 1.0)))
	for spec: String in ConquestSystem.CITY_SPECS.keys():
		var s: Dictionary = ConquestSystem.CITY_SPECS[spec]
		var b := _btn("%s — %s" % [String(s["label"]), String(s["text"])], Color(0.26, 0.22, 0.38), 17, Vector2(0, 62))
		b.name = "Spec_" + spec
		b.pressed.connect(func() -> void: _act(ConquestSystem.choose_spec(_save, _city_id, spec)))
		v.add_child(b)

func _fmt_mult(m: float) -> String:
	return ("%.1f" % m).replace(".0", "").replace(".", ",")

# ── Gouverneur ──────────────────────────────────────────────────────────────

func _show_governor_picker() -> void:
	var dim := ColorRect.new()
	dim.name = "GovernorPicker"
	dim.color = Color(0.01, 0.02, 0.04, 0.84)
	dim.set_anchors_preset(Control.PRESET_FULL_RECT)
	dim.mouse_filter = Control.MOUSE_FILTER_STOP
	_root.add_child(dim)
	# Centré par un CenterContainer (un preset CENTER posé avant le calcul de la taille
	# faisait partir le panneau du centre vers le bas/droite, hors de l'écran).
	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	dim.add_child(center)
	var avail: Vector2 = _root.size if _root.size.x > 0.0 else Vector2(1600, 900)
	var panel := PanelContainer.new()
	panel.add_theme_stylebox_override("panel", _box(Color(0.08, 0.12, 0.17, 0.99), GOLD, 3, 18))
	panel.custom_minimum_size = Vector2(minf(900.0, avail.x - 60.0), 0)
	center.add_child(panel)
	var outer := VBoxContainer.new()
	outer.add_theme_constant_override("separation", 10)
	panel.add_child(outer)
	outer.add_child(_lbl("GOUVERNEUR — %s" % String(_names()["residence"]).to_upper(), 28, GOLD))
	outer.add_child(_wrap("Un gouverneur défend la ville et la fait prospérer, mais ne combat plus en assaut.", 18, DIM))
	var sc := ScrollContainer.new()
	TouchScroll.install(sc)
	sc.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	sc.custom_minimum_size.y = clampf(avail.y - 300.0, 240.0, 520.0)
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
func _act(err: String, celebrate_key: String = "") -> void:
	_info = err
	if err == "" and celebrate_key != "":
		_celebrate = celebrate_key
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
	# Le texte revient à la ligne : un bouton ne doit jamais élargir le panneau hors de l'écran.
	b.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
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
