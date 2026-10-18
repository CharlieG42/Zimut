extends CanvasLayer
## TeamSelectionUI.gd — Sélection d'équipe refondue façon Waven :
## une vignette de classe à la fois, navigation ‹ ›, descriptif et stats,
## bouton AJOUTER/RETIRER, aperçu de l'équipe en cours (3 emplacements).

signal combat_requested(team_data: Array)
signal back_requested

const MAX_TEAM_SIZE := 3
const COL_PANEL := Color(0.94, 0.89, 0.78, 0.97)
const COL_BORDER := Color(0.72, 0.58, 0.28, 1.0)
const COL_TXT := Color(0.22, 0.15, 0.05)

const CLASS_COLORS: Dictionary = {
	"Tank":       Color(0.15, 0.45, 0.85),
	"Assassin":   Color(0.85, 0.15, 0.15),
	"Chasseur":   Color(0.15, 0.62, 0.15),
	"Mage":       Color(0.60, 0.20, 0.82),
	"Druide":     Color(0.95, 0.60, 0.10),
	"Heal":       Color(0.10, 0.75, 0.75),
	"Invocateur": Color(0.55, 0.15, 0.60),
	"Sylvain":     Color(0.35, 0.65, 0.25),
	"Géomancien":  Color(0.85, 0.62, 0.25),
}

const CLASS_META: Dictionary = {
	"Tank":       {"icon": "🛡️", "description": "Résistant, haute défense, encaisse pour l'équipe."},
	"Assassin":   {"icon": "🗡️", "description": "Rapide, dégâts élevés, frappe les cibles fragiles."},
	"Chasseur":   {"icon": "🏹", "description": "Polyvalent à distance, bon équilibre attaque/défense."},
	"Mage":       {"icon": "🔮", "description": "Dégâts magiques élevés, faible défense."},
	"Druide":     {"icon": "🌿", "description": "Maître de la nature, soigne et renforce avec des sorts naturels."},
	"Heal":       {"icon": "❤️", "description": "Spécialiste des soins et de la survie."},
	"Invocateur": {"icon": "🎭", "description": "Invoque des créatures, contrôle le champ."},
	"Sylvain":     {"icon": "🌿", "description": "Maître des plantes : invoque la forêt, empoisonne et soigne par la sève."},
	"Géomancien":     {"icon": "🪨", "description": "Mage de pierre et de sable : érige piliers, murs et failles pour bloquer, isoler et protéger."},
}

var classes: Array[String] = []       # classes disponibles (triées)
var current: int = 0                 # index de la vignette affichée
var team: Array[String] = []         # classes sélectionnées

const U = preload("res://scripts/UiKit.gd")

var _root: Control
var _grid: GridContainer             # vignettes des 9 classes
var _class_tiles: Dictionary = {}    # classe -> Button
var _portrait: TextureRect
var _name_label: Label
var _desc_label: Label
var _stats_label: Label
var _action_btn: Button
var _team_slots: Array = []          # [Panel, ...]
var _title: Label
var _fight_btn: Button
var _equip_btn: Button
var _chars_btn: Button
var _fight_sel_label: Label
var _fight_prev_btn: Button
var _fight_next_btn: Button

func _ready() -> void:
	_load_classes()
	_build()
	_restore_previous_team()

## Reprise de l'équipe du combat précédent (modifiable librement ensuite).
func _restore_previous_team() -> void:
	team.clear()
	if GameManager.active_slot < 0 or GameManager.active_save.is_empty():
		return
	for m: Dictionary in GameManager.active_save.get("team", []):
		var classe: String = String(m.get("classe", ""))
		if classe != "" and classes.has(classe) and not team.has(classe) and not _is_stationed(classe):
			team.append(classe)
	refresh()

## Conquête : un héros nommé gouverneur d'une ville ne part plus en assaut.
func _is_stationed(classe: String) -> bool:
	if GameManager.active_save.is_empty():
		return false
	return ProgressionManager.conquest_stationed_heroes(GameManager.active_save).has(classe)

func _load_classes() -> void:
	# Stats depuis classes.txt (meilleur niveau), fallback méta
	var file := FileAccess.open("res://data/classes.txt", FileAccess.READ)
	var stats_by_class: Dictionary = {}
	if file:
		var content := file.get_as_text()
		file.close()
		var lines := content.split("\n")
		if lines.size() > 1:
			var headers := lines[0].split(",")
			for i: int in range(headers.size()):
				headers[i] = headers[i].strip_edges()
			for i: int in range(1, lines.size()):
				var cols := lines[i].strip_edges().split(",")
				if cols.size() < 2:
					continue
				var classe: String = cols[0].strip_edges()
				if stats_by_class.has(classe):
					continue  # première ligne = niveau le plus bas, on garde la meilleure plus bas
				var d: Dictionary = {}
				for j: int in range(headers.size()):
					if j < cols.size():
						d[headers[j]] = cols[j].strip_edges()
				stats_by_class[classe] = d
	# Ordre d'affichage voulu
	var order: Array[String] = ["Tank", "Assassin", "Chasseur", "Mage", "Druide", "Heal", "Invocateur", "Sylvain", "Géomancien"]
	classes.clear()
	for c: String in order:
		classes.append(c)

func _stat_line(classe: String) -> String:
	var has_save: bool = GameManager.active_slot >= 0 and not GameManager.active_save.is_empty()
	var level: int = ProgressionManager.START_LEVEL
	var st: Dictionary = {}
	var extra: String = ""
	if has_save:
		var save: Dictionary = GameManager.active_save
		var member: Dictionary = {"classe": classe, "equipment": {}}
		for m: Dictionary in save.get("team", []):
			if String(m.get("classe", "")) == classe:
				member = m
		st = ProgressionManager.member_stats(save, member)
		var ent: Dictionary = ProgressionManager.roster_entry(save, classe)
		level = int(st.get("level", level))
		var nxt: int = ProgressionManager.xp_for_level(mini(ClassRules.MAX_LEVEL, level + 1))
		extra = "Niv %d  ·  XP %d / %d" % [level, int(ent.get("xp", 0)), nxt]
		if int(ent.get("unspent", 0)) > 0:
			extra += "\n✦ %d points de caractéristiques à répartir" % int(ent["unspent"])
	else:
		var row: Dictionary = ProgressionManager.class_row(classe, level)
		if not row.is_empty():
			st = {"max_pv": row["vita"], "pa": row["pa"], "pm": row["pm"], "force": row["force"],
				"intelligence": row["intelligence"], "agility": row["agility"], "wisdom": row["wisdom"],
				"defense": row["defense"]}
		extra = "Niv %d (combat rapide)" % level
	if st.is_empty():
		return extra
	return "%s\nPV %d · PA %d · PM %d\nForce %d · Intel %d · Agi %d\nSagesse %d · Déf %d" % [
		extra, int(st["max_pv"]), int(st["pa"]), int(st["pm"]),
		int(st["force"]), int(st["intelligence"]), int(st["agility"]),
		int(st["wisdom"]), int(st["defense"])]

func _stats_for(classe: String) -> Dictionary:
	# Recharge rapide : classes.txt déjà parsé au _ready ; on garde un cache simple
	if _stats_cache.is_empty():
		_parse_stats()
	return _stats_cache.get(classe, {})

var _stats_cache: Dictionary = {}

func _parse_stats() -> void:
	_stats_cache = {}
	var file := FileAccess.open("res://data/classes.txt", FileAccess.READ)
	if file == null:
		return
	var content := file.get_as_text()
	file.close()
	var lines := content.split("\n")
	if lines.size() < 2:
		return
	var headers := lines[0].strip_edges().split(",")
	for i: int in range(headers.size()):
		headers[i] = headers[i].strip_edges()
	for i: int in range(1, lines.size()):
		var cols := lines[i].strip_edges().split(",")
		if cols.size() < 3:
			continue
		var classe: String = cols[0].strip_edges()
		if classe == "":
			continue
		var d: Dictionary = {}
		for j: int in range(headers.size()):
			if j < cols.size():
				d[headers[j]] = cols[j].strip_edges()
		# garder le niveau le plus proche de 10 (niveau du joueur) sans le dépasser
		var lvl_new: int = int(d.get("Niveau", "0"))
		var old: Dictionary = _stats_cache.get(classe, {})
		var lvl_old: int = int(old.get("Niveau", "-1"))
		if lvl_old < 0:
			_stats_cache[classe] = d
		else:
			var best_old: int = lvl_old if lvl_old <= 10 else 1000000
			var best_new: int = lvl_new if lvl_new <= 10 else 1000000
			if best_new < best_old or (lvl_old > 10 and lvl_new in range(10, lvl_old)):
				_stats_cache[classe] = d

# ═══════════════════════════════════════════════════════════════════════════
#  Construction de l'interface
# ═══════════════════════════════════════════════════════════════════════════

func _build() -> void:
	# Refonte V17 : style sombre et doré (comme la Forge et Mes Parties), toutes les
	# classes visibles d'un coup (un appui pour choisir), interface agrandie (UiFit).
	var bg := ColorRect.new()
	bg.color = Color(0.05, 0.06, 0.10, 1.0)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(bg)
	_root = Control.new()
	add_child(_root)
	UiFit.apply(_root, 1.0, Vector2(1300, 760))
	var margin := MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	for side in ["left", "right"]:
		margin.add_theme_constant_override("margin_" + side, 22)
	margin.add_theme_constant_override("margin_top", 14)
	margin.add_theme_constant_override("margin_bottom", 14)
	_root.add_child(margin)
	var page := VBoxContainer.new()
	page.add_theme_constant_override("separation", 10)
	margin.add_child(page)

	# ── En-tête : retour + titre du combat
	var top := HBoxContainer.new()
	top.add_theme_constant_override("separation", 16)
	page.add_child(top)
	var back := U.btn("←  MENU", Color(0.45, 0.52, 0.70), 22, Vector2(170, 58))
	back.pressed.connect(_on_back)
	top.add_child(back)
	_title = U.lbl("", 30, Color(1.0, 0.86, 0.4), true)
	_title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	top.add_child(_title)
	top.add_child(Control.new())

	# ── Sélecteur de combat (rejouer un combat déjà gagné)
	var sel_row := HBoxContainer.new()
	sel_row.alignment = BoxContainer.ALIGNMENT_CENTER
	sel_row.add_theme_constant_override("separation", 12)
	page.add_child(sel_row)
	_fight_prev_btn = U.btn("◀", Color(0.45, 0.52, 0.70), 22, Vector2(64, 48))
	_fight_prev_btn.pressed.connect(_on_fight_prev)
	sel_row.add_child(_fight_prev_btn)
	_fight_sel_label = U.lbl("", 20, U.C_DIM)
	_fight_sel_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_fight_sel_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_fight_sel_label.custom_minimum_size = Vector2(700, 0)
	sel_row.add_child(_fight_sel_label)
	_fight_next_btn = U.btn("▶", Color(0.45, 0.52, 0.70), 22, Vector2(64, 48))
	_fight_next_btn.pressed.connect(_on_fight_next)
	sel_row.add_child(_fight_next_btn)

	# ── Corps : grille des classes | fiche de la classe choisie
	var body := HBoxContainer.new()
	body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body.add_theme_constant_override("separation", 16)
	page.add_child(body)
	var left := PanelContainer.new()
	left.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	left.size_flags_stretch_ratio = 1.15
	left.add_theme_stylebox_override("panel", U.box(Color(0.08, 0.10, 0.16, 0.95), Color(0.62, 0.50, 0.26), 16, 3, 12))
	body.add_child(left)
	_grid = GridContainer.new()
	_grid.columns = 3
	_grid.add_theme_constant_override("h_separation", 10)
	_grid.add_theme_constant_override("v_separation", 10)
	left.add_child(_grid)
	for c: String in classes:
		var tile := Button.new()
		tile.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		tile.size_flags_vertical = Control.SIZE_EXPAND_FILL
		tile.custom_minimum_size = Vector2(0, 96)
		tile.focus_mode = Control.FOCUS_NONE
		tile.icon = _class_texture(c)
		tile.expand_icon = true
		tile.add_theme_constant_override("icon_max_width", 76)
		tile.alignment = HORIZONTAL_ALIGNMENT_LEFT
		tile.add_theme_font_size_override("font_size", 21)
		for st_name in ["font_color", "font_hover_color", "font_pressed_color"]:
			tile.add_theme_color_override(st_name, U.C_TXT)
		var cls: String = c
		tile.pressed.connect(func() -> void:
			current = classes.find(cls)
			refresh())
		_grid.add_child(tile)
		_class_tiles[c] = tile

	var card := PanelContainer.new()
	card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	card.add_theme_stylebox_override("panel", U.box(Color(0.10, 0.11, 0.17, 0.97), Color(0.95, 0.70, 0.30), 18, 3, 16))
	body.add_child(card)
	var card_box := VBoxContainer.new()
	card_box.add_theme_constant_override("separation", 6)
	card.add_child(card_box)
	var head := HBoxContainer.new()
	head.add_theme_constant_override("separation", 14)
	card_box.add_child(head)
	_portrait = TextureRect.new()
	_portrait.custom_minimum_size = Vector2(130, 130)
	_portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	head.add_child(_portrait)
	var hv := VBoxContainer.new()
	hv.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hv.alignment = BoxContainer.ALIGNMENT_CENTER
	head.add_child(hv)
	_name_label = U.lbl("", 34, Color(1.0, 0.90, 0.6), true)
	hv.add_child(_name_label)
	_desc_label = U.lbl("", 19, U.C_DIM)
	_desc_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_desc_label.custom_minimum_size = Vector2(300, 0)
	hv.add_child(_desc_label)
	_stats_label = U.lbl("", 21, U.C_TXT)
	_stats_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_stats_label.size_flags_vertical = Control.SIZE_EXPAND_FILL
	card_box.add_child(_stats_label)
	_action_btn = U.btn("", Color(0.45, 0.80, 0.50), 24, Vector2(0, 64))
	_action_btn.pressed.connect(_on_action)
	card_box.add_child(_action_btn)

	# ── Bas : équipe (3 emplacements) + boutons
	var bottom := HBoxContainer.new()
	bottom.add_theme_constant_override("separation", 12)
	page.add_child(bottom)
	var tools := VBoxContainer.new()
	tools.add_theme_constant_override("separation", 8)
	bottom.add_child(tools)
	var chars := U.btn("📈  PERSONNAGES", Color(0.40, 0.60, 0.90), 20, Vector2(260, 52))
	_chars_btn = chars
	chars.tooltip_text = "Niveaux, XP et répartition des points de caractéristiques."
	chars.pressed.connect(_on_characters)
	tools.add_child(chars)
	var eq := U.btn("🎒  ÉQUIPEMENT", Color(0.85, 0.62, 0.25), 20, Vector2(260, 52))
	_equip_btn = eq
	eq.tooltip_text = "Équiper vos personnages avec les objets gagnés."
	eq.pressed.connect(_on_equipment)
	tools.add_child(eq)
	var team_row := HBoxContainer.new()
	team_row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	team_row.alignment = BoxContainer.ALIGNMENT_CENTER
	team_row.add_theme_constant_override("separation", 10)
	bottom.add_child(team_row)
	_team_slots.clear()
	for i: int in range(MAX_TEAM_SIZE):
		var slot := Button.new()
		slot.custom_minimum_size = Vector2(200, 112)
		slot.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		slot.focus_mode = Control.FOCUS_NONE
		slot.expand_icon = true
		slot.add_theme_constant_override("icon_max_width", 72)
		slot.alignment = HORIZONTAL_ALIGNMENT_LEFT
		slot.add_theme_font_size_override("font_size", 20)
		for st_name in ["font_color", "font_hover_color", "font_pressed_color"]:
			slot.add_theme_color_override(st_name, U.C_TXT)
		var idx: int = i
		slot.pressed.connect(func() -> void:
			if idx < team.size():
				current = classes.find(team[idx])
				refresh())
		team_row.add_child(slot)
		_team_slots.append(slot)
	var go := U.btn("⚔  COMBATTRE", Color(0.40, 0.80, 0.40), 24, Vector2(330, 112))
	go.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_fight_btn = go
	go.pressed.connect(_on_combat)
	bottom.add_child(go)

	refresh()


## Portrait d'une classe (sprite du héros).
func _class_texture(classe: String) -> Texture2D:
	var tex_path := "res://assets/sprites/players/%s.png" % EntityView.sprite_key(classe)
	return load(tex_path) as Texture2D if ResourceLoader.exists(tex_path) else null


## Retour à la fenêtre des parties (sauvegarde déjà écrite à chaque modification).
func _on_back() -> void:
	back_requested.emit()
	if GameManager.active_slot >= 0 and not GameManager.active_save.is_empty():
		ProgressionManager.write_save(GameManager.active_slot, GameManager.active_save)
	get_tree().change_scene_to_file("res://scenes/SaveSlots.tscn")


## Sélecteur de combat : rejouer un combat déjà gagné (XP réduite si plus bas que le niveau
## du perso, mais loots et ressources) pour progresser si l'on bloque sur le dernier combat.
func _on_fight_prev() -> void:
	_shift_fight(-1)

func _on_fight_next() -> void:
	_shift_fight(1)

func _shift_fight(delta: int) -> void:
	if GameManager.active_slot < 0 or GameManager.active_save.is_empty():
		return
	var save: Dictionary = GameManager.active_save
	ProgressionManager.select_fight(save, ProgressionManager.selected_fight_number(save) + delta)
	ProgressionManager.write_save(GameManager.active_slot, save)
	refresh()

func _nav_btn(txt: String) -> Button:
	var b := Button.new()
	b.text = txt
	b.custom_minimum_size = Vector2(90, 90)
	b.add_theme_font_size_override("font_size", 48)
	b.add_theme_color_override("font_color", COL_TXT)
	b.add_theme_stylebox_override("normal", _flat(COL_PANEL, COL_BORDER, 16, 3))
	b.add_theme_stylebox_override("hover", _flat(Color(1.0, 0.92, 0.6), COL_BORDER, 16, 3))
	# la flèche ne doit pas s'étirer verticalement
	b.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	return b

func _std_btn(txt: String, col: Color) -> Button:
	var b := Button.new()
	b.text = txt
	b.add_theme_font_size_override("font_size", 24)
	b.add_theme_color_override("font_color", COL_TXT)
	b.add_theme_stylebox_override("normal", _flat(col.lightened(0.35), col.darkened(0.2), 14, 3))
	b.add_theme_stylebox_override("hover", _flat(col.lightened(0.5), col.darkened(0.2), 14, 3))
	return b

# ═══════════════════════════════════════════════════════════════════════════
#  Navigation & sélection
# ═══════════════════════════════════════════════════════════════════════════

func _rotate(dir: int) -> void:
	current = (current + dir + classes.size()) % classes.size()
	refresh()

func current_class() -> String:
	return classes[current]

func _on_action() -> void:
	var classe := current_class()
	if _is_stationed(classe):
		return
	if team.has(classe):
		team.erase(classe)
	else:
		if team.size() >= MAX_TEAM_SIZE:
			return
		team.append(classe)
	refresh()

func _on_combat() -> void:
	if team.size() != MAX_TEAM_SIZE:
		return
	# Construire team_data comme l'ancien format (classe + stats)
	var team_data: Array = []
	for classe: String in team:
		team_data.append({"name": classe, "data": {"name": classe}})
	combat_requested.emit(team_data)
	# Rediriger vers la logique existante du GameManager
	if GameManager.custom_team.is_empty() or true:
		var classes_arr: Array = []
		for m: Dictionary in team_data:
			classes_arr.append(m["name"])
		_sync_save_team(classes_arr)
	GameManager.set_custom_team(_build_custom_team())
	get_tree().change_scene_to_file("res://scenes/Main.tscn")

func _build_custom_team() -> Array:
	# Format attendu par _stats_from_custom : stats par classe
	var out: Array = []
	for classe: String in team:
		var s: Dictionary = _stats_for(classe)
		out.append({
			"classe": classe,
			"max_pv": int(s.get("Vita (PV)", 100)),
			"force": int(s.get("Force (CAC)", 10)),
			"intelligence": int(s.get("Intelligence (Magie)", 10)),
			"agilite": int(s.get("Agilité (Vit. Atk)", 10)),
			"sagesse": int(s.get("Sagesse (Précision)", 10)),
			"defense": int(s.get("Défense", 10)),
			"pa": int(s.get("PA", 6)),
			"pm": int(s.get("PM", 3)),
			"color": CLASS_COLORS.get(classe, Color(1, 1, 1)),
		})
	return out

func _sync_save_team(classes_arr: Array) -> void:
	# Partie active : mettre à jour l'équipe en conservant l'équipement par classe
	# (l'équipement des classes retirées retourne à l'inventaire)
	if GameManager.active_slot < 0 or GameManager.active_save.is_empty():
		return
	ProgressionManager.rebuild_team(GameManager.active_save, classes_arr)
	ProgressionManager.write_save(GameManager.active_slot, GameManager.active_save)

func _on_characters() -> void:
	if GameManager.active_slot < 0 or GameManager.active_save.is_empty():
		return
	for child in get_children():
		if child is CanvasLayer and child.get_script() != null:
			if String(child.get_script().resource_path).contains("CharacterSheetUI"):
				return
	var ui: CanvasLayer = (load("res://scripts/CharacterSheetUI.gd") as GDScript).new()
	ui.layer = 10
	add_child(ui)
	ui.closed.connect(func() -> void:
		ui.queue_free()
		refresh())
	ui.open(GameManager.active_save, GameManager.active_slot, _preferred_class())

func _preferred_class() -> String:
	return current_class()

func _on_equipment() -> void:
	if GameManager.active_slot < 0 or GameManager.active_save.is_empty():
		return
	for child in get_children():
		if child is CanvasLayer and child.get_script() != null:
			if String(child.get_script().resource_path).contains("TeamEquipmentUI"):
				return
	var ui: CanvasLayer = (load("res://scripts/TeamEquipmentUI.gd") as GDScript).new()
	ui.layer = 10
	add_child(ui)
	ui.closed.connect(func() -> void:
		ui.queue_free()
		refresh())
	ui.open(GameManager.active_save, GameManager.active_slot)

# ═══════════════════════════════════════════════════════════════════════════
#  Rafraîchissement
# ═══════════════════════════════════════════════════════════════════════════

func refresh() -> void:
	var classe := current_class()
	var meta: Dictionary = CLASS_META.get(classe, {"icon": "❔", "description": ""})
	var col: Color = CLASS_COLORS.get(classe, Color(0.5, 0.5, 0.5))

	# Toujours réinitialiser : sinon une image manquante garde le héros précédent.
	_portrait.texture = _class_texture(classe)
	_name_label.text = "%s  %s" % [meta["icon"], classe]
	_name_label.add_theme_color_override("font_color", col.lightened(0.45))
	var has_save0: bool = GameManager.active_slot >= 0 and not GameManager.active_save.is_empty()
	for c: String in _class_tiles.keys():
		var tile: Button = _class_tiles[c]
		var ccol: Color = CLASS_COLORS.get(c, Color(0.5, 0.5, 0.5))
		var sel: bool = c == classe
		var lvl_txt: String = ("\nNiv %d" % ProgressionManager.member_level(GameManager.active_save, c)) if has_save0 else ""
		var mark: String = "✓ " if team.has(c) else ("♞ " if _is_stationed(c) else "")
		tile.text = "%s%s%s" % [mark, c, lvl_txt]
		var bgc: Color = ccol.darkened(0.55) if team.has(c) else Color(0.12, 0.14, 0.21)
		var st_t: StyleBoxFlat = U.box(bgc, Color(1.0, 0.82, 0.35) if sel else ccol.darkened(0.1), 14, 4 if sel else 2, 8)
		tile.add_theme_stylebox_override("normal", st_t)
		tile.add_theme_stylebox_override("hover", st_t)
		tile.add_theme_stylebox_override("pressed", st_t)
		tile.modulate = Color(0.6, 0.6, 0.65) if _is_stationed(c) else Color.WHITE
	_desc_label.text = String(meta["description"])
	_stats_label.text = _stat_line(classe)

	var in_team: bool = team.has(classe)
	if _is_stationed(classe):
		var home: String = ConquestSystem.hero_city(GameManager.active_save.get("conquest", {}), classe)
		_action_btn.text = "♞  GOUVERNEUR DE %s" % ProgressionManager.conquest_city_name(home).to_upper()
		_action_btn.add_theme_stylebox_override("normal", U.box(Color(0.22, 0.22, 0.25), Color(0.4, 0.4, 0.45), 12, 2, 12))
	elif in_team:
		_action_btn.text = "✕  RETIRER DE L'ÉQUIPE"
		_action_btn.add_theme_stylebox_override("normal", U.box(Color(0.55, 0.16, 0.13), Color(1.0, 0.45, 0.35), 12, 2, 12))
	else:
		var full: bool = team.size() >= MAX_TEAM_SIZE
		_action_btn.text = "＋  AJOUTER À L'ÉQUIPE" if not full else "ÉQUIPE PLEINE"
		_action_btn.add_theme_stylebox_override("normal", U.box(
			Color(0.18, 0.42, 0.20) if not full else Color(0.22, 0.22, 0.25),
			Color(0.45, 0.85, 0.45) if not full else Color(0.4, 0.4, 0.45), 12, 2, 12))

	var fight_no: int = 1
	var boss_fight: bool = false
	var next_lvl: int = 0
	if GameManager.active_slot >= 0 and not GameManager.active_save.is_empty():
		fight_no = ProgressionManager.next_fight_number(GameManager.active_save)
		boss_fight = ProgressionManager.is_boss_fight(GameManager.active_save)
		next_lvl = ProgressionManager.enemy_level_for(GameManager.active_save)
	var biome: String = ProgressionManager.next_biome(GameManager.active_save) if not GameManager.active_save.is_empty() else "Forêt"
	# Conquête : l'assaut se joue dans le biome de la ville ciblée,
	# avec son boss pour la dernière vague de siège.
	var city_name: String = ""
	if not GameManager.active_save.is_empty() and String(GameManager.active_save.get("campaign_mode", "")) == "conquest":
		var pending: String = String(GameManager.active_save.get("conquest", {}).get("pending_city", ""))
		if pending != "":
			biome = ProgressionManager.conquest_city_biome(pending)
			city_name = ProgressionManager.conquest_city_name(pending)
			boss_fight = ProgressionManager.conquest_siege_is_boss(GameManager.active_save.get("conquest", {}), pending)
	# Aventure : le défi se joue dans le biome de la zone explorée, au niveau du POI.
	var challenge_name: String = ""
	if not GameManager.active_save.is_empty() \
			and String(GameManager.active_save.get("campaign_mode", "")) == "adventure":
		var adv: Dictionary = GameManager.active_save.get("adventure", {})
		biome = ProgressionManager.adventure_zone_biome(String(adv.get("zone", "foret_sylve")))
		var pkey: String = String(adv.get("pending_challenge", ""))
		if pkey != "":
			var parts := pkey.split(",")
			if parts.size() >= 3:
				var poi: Dictionary = ProgressionManager.adventure_poi(String(parts[0]),
					Vector2i(int(parts[parts.size() - 2]), int(parts[parts.size() - 1])))
				challenge_name = String(poi.get("name", adv.get("pending_name", "Défi")))
	if boss_fight:
		if city_name != "":
			_title.text = "ASSAUT : %s — ☠ AFFRONTEZ %s ! (%d/%d)" % [city_name,
				(ProgressionManager.biome_boss("Roi Squelette" if biome == "Donjon" else biome)).to_upper(), team.size(), MAX_TEAM_SIZE]
		else:
			_title.text = "COMBAT %d — %s : ☠ AFFRONTEZ %s ! (%d/%d)" % [fight_no, ProgressionManager.biome_label(biome),
				ProgressionManager.biome_boss(biome).to_upper(), team.size(), MAX_TEAM_SIZE]
		_title.add_theme_color_override("font_color", Color(1.0, 0.45, 0.35))
	else:
		if challenge_name != "":
			_title.text = "DÉFI : %s · %s · CONSTITUEZ VOTRE ÉQUIPE (%d/%d)" % [challenge_name,
				ProgressionManager.biome_label(biome), team.size(), MAX_TEAM_SIZE]
		elif city_name != "":
			_title.text = "ASSAUT : %s · %s · CONSTITUEZ VOTRE ÉQUIPE (%d/%d)" % [city_name,
				ProgressionManager.biome_label(biome), team.size(), MAX_TEAM_SIZE]
		else:
			_title.text = "COMBAT %d — %s : CONSTITUEZ VOTRE ÉQUIPE (%d/%d)" % [fight_no, ProgressionManager.biome_label(biome),
				team.size(), MAX_TEAM_SIZE]
		_title.add_theme_color_override("font_color", Color(1.0, 0.86, 0.4))
	if _equip_btn:
		_equip_btn.disabled = GameManager.active_slot < 0 or GameManager.active_save.is_empty()
		_equip_btn.text = "🎒  ÉQUIPEMENT (%d)" % GameManager.active_save.get("inventory", []).size() if not _equip_btn.disabled else "🎒  ÉQUIPEMENT"
	if _chars_btn:
		var has_save2: bool = GameManager.active_slot >= 0 and not GameManager.active_save.is_empty()
		_chars_btn.disabled = not has_save2
		var pts: int = 0
		if has_save2:
			for m2: Dictionary in GameManager.active_save.get("team", []):
				pts += int(ProgressionManager.roster_entry(GameManager.active_save, String(m2.get("classe", ""))).get("unspent", 0))
		_chars_btn.text = "📈  PERSONNAGES (+%d)" % pts if pts > 0 else "📈  PERSONNAGES"
	if _fight_sel_label:
		var has_save3: bool = GameManager.active_slot >= 0 and not GameManager.active_save.is_empty()
		_fight_prev_btn.visible = has_save3
		_fight_next_btn.visible = has_save3
		if has_save3:
			var frontier: int = ProgressionManager.frontier_fight_number(GameManager.active_save)
			var replay: bool = fight_no < frontier
			_fight_prev_btn.disabled = fight_no <= 1
			_fight_next_btn.disabled = fight_no >= frontier
			if replay:
				_fight_sel_label.text = "↻ Combat %d rejoué (déjà gagné) · niveau %d — moins d'XP, mais loots et ressources" % [fight_no, next_lvl]
				_fight_sel_label.add_theme_color_override("font_color", Color(0.65, 0.85, 1.0))
			else:
				_fight_sel_label.text = "Combat %d (progression) · niveau %d   —   ◀ pour rejouer un combat plus facile" % [fight_no, next_lvl]
				_fight_sel_label.add_theme_color_override("font_color", Color(0.75, 0.80, 0.90))
		else:
			_fight_sel_label.text = ""
	if _fight_btn:
		if boss_fight:
			_fight_btn.text = "☠  COMBATTRE %s (nv%d)" % [ProgressionManager.biome_boss(biome).to_upper(), next_lvl]
		elif next_lvl > 0:
			var rp: bool = fight_no < ProgressionManager.frontier_fight_number(GameManager.active_save)
			_fight_btn.text = "%s — %s nv%d" % ["↻  REJOUER" if rp else "⚔  COMBATTRE", biome, next_lvl]
		else:
			_fight_btn.text = "⚔  COMBATTRE"

	# Aperçu de l'équipe
	for i: int in range(MAX_TEAM_SIZE):
		var slot: Button = _team_slots[i]
		if i < team.size():
			var c: String = team[i]
			var ccol: Color = CLASS_COLORS.get(c, Color(0.4, 0.4, 0.4))
			slot.icon = _class_texture(c)
			slot.text = c
			if GameManager.active_slot >= 0 and not GameManager.active_save.is_empty():
				slot.text += "\nNiv %d" % ProgressionManager.member_level(GameManager.active_save, c)
			var st_s: StyleBoxFlat = U.box(ccol.darkened(0.5), ccol.lightened(0.2), 14, 3, 8)
			slot.add_theme_stylebox_override("normal", st_s)
			slot.add_theme_stylebox_override("hover", st_s)
			slot.add_theme_stylebox_override("pressed", st_s)
		else:
			slot.icon = null
			slot.text = "  ＋ emplacement libre"
			var st_e: StyleBoxFlat = U.box(Color(0.08, 0.10, 0.15, 0.9), Color(0.28, 0.32, 0.42), 14, 2, 8)
			slot.add_theme_stylebox_override("normal", st_e)
			slot.add_theme_stylebox_override("hover", st_e)
			slot.add_theme_stylebox_override("pressed", st_e)
	if _fight_btn:
		_fight_btn.disabled = team.size() != MAX_TEAM_SIZE

func _flat(bg: Color, border: Color, radius: int = 12, bw: int = 3) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = bg
	s.border_color = border
	s.set_border_width_all(bw)
	s.set_corner_radius_all(radius)
	return s
