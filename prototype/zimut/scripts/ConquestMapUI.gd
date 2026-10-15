extends CanvasLayer
## Première ébauche du mode Conquête : carte de villes PvE reliée au combat tactique.
## Les héros, sorts, caractéristiques et loots restent ceux de la sauvegarde commune.

const PANEL := Color(0.09, 0.15, 0.20, 0.97)
const TEXT := Color(0.95, 0.94, 0.84)
const GOLD := Color(0.96, 0.75, 0.31)
const CITIES := [
	{"id": "capitale", "name": "Sylve-Cœur", "kind": "capital", "level": 0, "pos": Vector2(0.50, 0.54), "desc": "Votre capitale de départ. Elle ne peut pas être perdue."},
	{"id": "clairiere", "name": "Clairière d'Aube", "kind": "neutral", "level": 10, "pos": Vector2(0.25, 0.35), "desc": "Un village forestier peu défendu."},
	{"id": "vieille_tour", "name": "Vieille Tour", "kind": "enemy", "level": 12, "pos": Vector2(0.74, 0.30), "desc": "Un avant-poste gobelin fortifié."},
	{"id": "pont_mousse", "name": "Pont-Mousse", "kind": "neutral", "level": 11, "pos": Vector2(0.28, 0.74), "desc": "Un passage stratégique au-dessus de la rivière."},
	{"id": "fort_racine", "name": "Fort Racine", "kind": "enemy", "level": 14, "pos": Vector2(0.76, 0.72), "desc": "La forteresse du chef de la forêt."}
]

var _save: Dictionary = {}
var _slot: int = -1
var _conquest: Dictionary = {}
var _selected_id: String = "clairiere"
var _message: Label
var _attack: Button
var _city_buttons: Dictionary = {}
var _build_box: VBoxContainer

func _ready() -> void:
	Music.play("adventure")
	layer = 10
	_save = GameManager.active_save
	_slot = GameManager.active_slot
	if _save.is_empty() or _slot < 0:
		get_tree().change_scene_to_file("res://scenes/SaveSlots.tscn")
		return
	_conquest = _save.get("conquest", {})
	if _conquest.is_empty():
		_conquest = {"owned": ["capitale"], "pending_city": ""}
	_save["conquest"] = _conquest
	_save["campaign_mode"] = "conquest"
	_persist()
	_build()
	var counter: String = String(_conquest.get("last_counterattack", ""))
	if counter != "" and _city_by_id(counter).size() > 0:
		var cname: String = String(_city_by_id(counter).get("name", counter))
		_message.text = "⚠ CONTRE-ATTAQUE ! L\u2019ennemi a pillé %s : production gelée %d bataille(s)." % [cname, ProgressionManager.CONQUEST_RAVAGE_BATTLES]

func _build() -> void:
	var bg := ColorRect.new()
	bg.color = Color(0.34, 0.47, 0.49)
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(bg)

	var root := Control.new()
	root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root.offset_left = 28
	root.offset_right = -28
	root.offset_top = 20
	root.offset_bottom = -20
	add_child(root)

	var title := Label.new()
	title.text = "🏰  ZIMUT — CONQUÊTE"
	title.position = Vector2(8, 0)
	title.add_theme_font_size_override("font_size", 30)
	title.add_theme_color_override("font_color", TEXT)
	root.add_child(title)
	var subtitle := Label.new()
	subtitle.text = "Forêt de Zimut · Développez votre territoire en remportant les batailles tactiques"
	subtitle.position = Vector2(8, 42)
	subtitle.add_theme_font_size_override("font_size", 18)
	subtitle.add_theme_color_override("font_color", GOLD)
	root.add_child(subtitle)

	var map := Panel.new()
	map.position = Vector2(0, 82)
	map.size = Vector2(1320, 760)
	map.add_theme_stylebox_override("panel", _style(PANEL, GOLD))
	root.add_child(map)
	var map_title := Label.new()
	map_title.text = "CARTE DE LA SYLVE"
	map_title.position = Vector2(22, 16)
	map_title.add_theme_font_size_override("font_size", 20)
	map_title.add_theme_color_override("font_color", TEXT)
	map.add_child(map_title)

	# Routes décoratives dessinées derrière les villes.
	var routes := _RouteLines.new()
	routes.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	map.add_child(routes)
	for city: Dictionary in CITIES:
		var id: String = String(city["id"])
		var btn := Button.new()
		var owned: bool = _conquest.get("owned", []).has(String(city["id"]))
		var badge: String = "⚑" if owned else ("⚔" if String(city["kind"]) == "enemy" else "●")
		var siege_p: int = ProgressionManager.conquest_siege_progress(_conquest, String(city["id"]))
		var siege_txt: String = ("\nSiège %d/%d" % [siege_p, ProgressionManager.CONQUEST_SIEGE_BATTLES]) if siege_p > 0 else ""
		btn.text = ("%s\n" % badge) + String(city["name"]) + siege_txt

		btn.position = Vector2(float(city["pos"].x) * map.size.x - 88, float(city["pos"].y) * map.size.y - 34)
		btn.custom_minimum_size = Vector2(176, 72)
		btn.add_theme_font_size_override("font_size", 17)
		btn.add_theme_color_override("font_color", TEXT)
		btn.add_theme_stylebox_override("normal", _style(_city_color(city), GOLD if id == _selected_id else Color(0.5, 0.64, 0.46)))
		btn.add_theme_stylebox_override("hover", _style(_city_color(city).lightened(0.12), GOLD))
		btn.pressed.connect(_select_city.bind(id))
		map.add_child(btn)
		_city_buttons[id] = btn

	var side := PanelContainer.new()
	side.position = Vector2(1340, 82)
	side.size = Vector2(430, 760)
	side.add_theme_stylebox_override("panel", _style(Color(0.10, 0.17, 0.21, 0.98), GOLD))
	root.add_child(side)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 14)
	side.add_child(box)
	var panel_title := Label.new()
	panel_title.text = "CONSEIL DE GUERRE"
	panel_title.add_theme_font_size_override("font_size", 22)
	panel_title.add_theme_color_override("font_color", TEXT)
	box.add_child(panel_title)
	_message = Label.new()
	_message.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_message.custom_minimum_size.y = 160
	_message.add_theme_color_override("font_color", TEXT)
	box.add_child(_message)
	_attack = Button.new()
	_attack.text = "LANCER L'ASSAUT"
	_attack.custom_minimum_size.y = 62
	_attack.add_theme_font_size_override("font_size", 21)
	_attack.pressed.connect(_attack_selected_city)
	box.add_child(_attack)
	_build_box = VBoxContainer.new()
	_build_box.add_theme_constant_override("separation", 6)
	box.add_child(_build_box)
	var spacer := Control.new()
	spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	box.add_child(spacer)
	var note := Label.new()
	note.text = "La victoire en combat tactique rapporte l'XP et les loots habituels. La conquête territoriale sera validée au retour du résultat de bataille dans la prochaine étape."
	note.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	note.add_theme_color_override("font_color", GOLD)
	box.add_child(note)
	var back := Button.new()
	back.text = "← MENU"
	back.custom_minimum_size.y = 50
	back.pressed.connect(_back_to_save)
	box.add_child(back)
	_select_city(_selected_id)

func _select_city(id: String) -> void:
	_selected_id = id
	var city: Dictionary = _city_by_id(id)
	var owned: Array = _conquest.get("owned", ["capitale"])
	var conquered: bool = owned.has(id)
	var ravage: int = int(_conquest.get("ravage", {}).get(id, 0))
	_build_panel(id, conquered)
	if city.get("kind", "") == "capital":
		_message.text = "%s\n\n%s\n\nVotre territoire de départ, à l’abri des attaques." % [city["name"], city["desc"]]
		_attack.disabled = true
		_attack.text = "LANCER L’ASSAUT"
	elif conquered:
		var txt: String = "%s\n\n%s\n\n⚑ Territoire allié." % [city["name"], city["desc"]]
		if ravage > 0:
			txt += "\n\n⚠ PILLÉE : production gelée pendant %d bataille(s)." % ravage
		var builds: Array = _conquest.get("buildings", {}).get(id, [])
		if builds.size() > 0:
			var names: Array = []
			for b: String in builds:
				names.append(String(ProgressionManager.CONQUEST_BUILDINGS.get(b, {}).get("label", b)))
			txt += "\n\nBâtiments : %s" % ", ".join(PackedStringArray(names))
		var yld: Dictionary = {}
		for b: String in builds:
			for r: String in ProgressionManager.CONQUEST_BUILDINGS.get(b, {}).get("yield", {}).keys():
				yld[r] = int(yld.get(r, 0)) + int(ProgressionManager.CONQUEST_BUILDINGS[b]["yield"][r])
		if yld.size() > 0 and ravage == 0:
			var parts: Array = []
			for r: String in yld.keys():
				parts.append("%s +%d" % [r, int(yld[r])])
			txt += "\nProduction : %s" % " · ".join(PackedStringArray(parts))
		_message.text = txt
		_attack.disabled = true
		_attack.text = "LANCER L’ASSAUT"
	else:
		var kind: String = String(city["kind"])
		var cid2: String = String(city["id"])
		var prog: int = ProgressionManager.conquest_siege_progress(_conquest, cid2)
		var wave: int = ProgressionManager.conquest_siege_wave(_conquest, cid2)
		if kind == "enemy":
			var left: int = ProgressionManager.CONQUEST_SIEGE_BATTLES - prog
			var wave_txt: String = ("\n\nSiège en cours : %d/%d — prochaine bataille : %s." % [prog, ProgressionManager.CONQUEST_SIEGE_BATTLES, "BOSS" if wave == ProgressionManager.CONQUEST_SIEGE_BATTLES else "mobs de champs"]) if prog > 0 else ""
			_message.text = "%s · Niveau conseillé %d\n\n%s\n\n⚔ VILLE ADVERSE — siège en %d batailles : 3 plateaux de mobs puis le BOSS du biome.%s" % [city["name"], int(city["level"]), city["desc"], ProgressionManager.CONQUEST_SIEGE_BATTLES, wave_txt]
		else:
			_message.text = "%s · Niveau conseillé %d\n\n%s\n\n● VILLE NEUTRE — 1 bataille contre des mobs de champs suffit à la conquérir." % [city["name"], int(city["level"]), city["desc"]]

		_attack.disabled = false
		if kind == "enemy":
			_attack.text = "LANCER LA BATAILLE %d/4 — %s" % [wave, "BOSS" if wave == ProgressionManager.CONQUEST_SIEGE_BATTLES else "MOBS"]
		else:
			_attack.text = "LANCER L’ASSAUT"
	for other: Dictionary in CITIES:
		var button: Button = _city_buttons[String(other["id"])]
		button.add_theme_stylebox_override("normal", _style(_city_color(other), GOLD if String(other["id"]) == id else Color(0.5, 0.64, 0.46)))

## Panneau de construction de la ville sélectionnée : un bouton par
## bâtiment de ressources disponible, avec coûts, s’il n’est pas déjà bâti.
func _build_panel(city_id: String, conquered: bool) -> void:
	if _build_box == null:
		return
	for c: Node in _build_box.get_children():
		c.queue_free()
	if not conquered:
		return
	var res: Dictionary = _save.get("resources", {})
	var builds: Array = _conquest.get("buildings", {}).get(city_id, [])
	for key: String in ProgressionManager.CONQUEST_BUILDINGS.keys():
		var info: Dictionary = ProgressionManager.CONQUEST_BUILDINGS[key]
		var b := Button.new()
		var cost_parts: Array = []
		for r: String in info.get("cost", {}).keys():
			cost_parts.append("%s %d/%d" % [r, int(res.get(r, 0)), int(info["cost"][r])])
		cost_parts.append("%d or" % int(info.get("gold", 0)))
		b.text = "⚒ %s — %s" % [String(info["label"]), " · ".join(PackedStringArray(cost_parts))]
		b.custom_minimum_size.y = 46
		b.add_theme_font_size_override("font_size", 15)
		b.add_theme_color_override("font_color", TEXT)
		b.add_theme_stylebox_override("normal", _style(Color(0.13, 0.22, 0.27, 0.95), Color(0.55, 0.66, 0.5)))
		b.add_theme_stylebox_override("hover", _style(Color(0.18, 0.30, 0.34, 0.95), GOLD))
		if builds.has(key):
			b.text = "✓ %s (construit)" % String(info["label"])
			b.disabled = true
		else:
			b.pressed.connect(_on_build_pressed.bind(city_id, key))
		_build_box.add_child(b)

func _on_build_pressed(city_id: String, building: String) -> void:
	var err: String = ProgressionManager.conquest_build(_save, city_id, building)
	if err != "":
		_message.text = err
		return
	ProgressionManager.write_save(_slot, _save)
	_conquest = _save.get("conquest", {})
	_select_city(city_id)

func _attack_selected_city() -> void:
	var city: Dictionary = _city_by_id(_selected_id)
	if city.is_empty() or String(city["kind"]) == "capital":
		return
	var owned: Array = _conquest.get("owned", ["capitale"])
	if owned.has(_selected_id):
		return
	_conquest["pending_city"] = _selected_id
	_conquest["pending_level"] = int(city["level"])
	_save["conquest"] = _conquest
	_save["campaign_mode"] = "conquest"
	_persist()
	GameManager.active_save = _save
	GameManager.active_slot = _slot
	GameManager.fight_biome = "Forêt"
	get_tree().change_scene_to_file("res://scenes/TeamSelection.tscn")

func _city_by_id(id: String) -> Dictionary:
	for city: Dictionary in CITIES:
		if String(city["id"]) == id:
			return city
	return {}

## Couleur d’une ville selon son ÉTAT, pas son type d’origine :
##   vert  = conquise ou capitale (imprenable),
##   gris  = neutre (1 bataille de mobs),
##   rouge = adverse (siège : 3 batailles de mobs puis le boss).
func _city_color(city: Dictionary) -> Color:
	var cid: String = String(city["id"])
	if _conquest.get("owned", []).has(cid):
		return Color(0.16, 0.42, 0.24)
	match String(city["kind"]):
		"capital": return Color(0.16, 0.42, 0.24)
		"neutral": return Color(0.34, 0.36, 0.38)
		_: return Color(0.52, 0.16, 0.14)

func _persist() -> void:
	_save["conquest"] = _conquest
	_save["campaign_mode"] = "conquest"
	ProgressionManager.write_save(_slot, _save)
	GameManager.active_save = _save
	GameManager.active_slot = _slot

func _back_to_save() -> void:
	_persist()
	get_tree().change_scene_to_file("res://scenes/SaveSlots.tscn")

func _style(bg: Color, border: Color) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = bg
	s.border_color = border
	s.set_border_width_all(2)
	s.set_corner_radius_all(12)
	s.content_margin_left = 8
	s.content_margin_right = 8
	s.content_margin_top = 6
	s.content_margin_bottom = 6
	return s

class _RouteLines:
	extends Control
	func _draw() -> void:
		var a := Vector2(size.x * 0.25, size.y * 0.35)
		var b := Vector2(size.x * 0.50, size.y * 0.54)
		var c := Vector2(size.x * 0.74, size.y * 0.30)
		var d := Vector2(size.x * 0.28, size.y * 0.74)
		var e := Vector2(size.x * 0.76, size.y * 0.72)
		for pair: Array in [[a, b], [b, c], [b, d], [b, e], [d, e]]:
			draw_line(pair[0], pair[1], Color(0.79, 0.68, 0.43, 0.85), 5.0, true)
