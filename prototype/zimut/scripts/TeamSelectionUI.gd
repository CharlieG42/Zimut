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
}

var classes: Array[String] = []       # classes disponibles (triées)
var current: int = 0                 # index de la vignette affichée
var team: Array[String] = []         # classes sélectionnées

var _root: Control
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
		if classe != "" and classes.has(classe) and not team.has(classe):
			team.append(classe)
	refresh()

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
	var order: Array[String] = ["Tank", "Assassin", "Chasseur", "Mage", "Druide", "Heal", "Invocateur", "Sylvain"]
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
	_root = Control.new()
	_root.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(_root)
	var bg := ColorRect.new()
	bg.color = Color(0.06, 0.09, 0.14, 0.97)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	_root.add_child(bg)

	# Titre
	_title = Label.new()
	_title.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
	_title.offset_top = 30.0
	_title.offset_bottom = 110.0
	_title.text = "CONSTITUEZ VOTRE ÉQUIPE (%d/%d)" % [team.size(), MAX_TEAM_SIZE]
	_title.add_theme_font_size_override("font_size", 42)
	_title.add_theme_color_override("font_color", Color(1.0, 0.86, 0.4))
	_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_root.add_child(_title)

	# Navigation : ‹  vignette  ›
	var nav := HBoxContainer.new()
	nav.set_anchors_and_offsets_preset(Control.PRESET_CENTER_TOP)
	nav.offset_left = -330.0
	nav.offset_right = 330.0
	nav.offset_top = 140.0
	nav.offset_bottom = 560.0
	nav.add_theme_constant_override("separation", 20)
	_root.add_child(nav)

	var prev := _nav_btn("‹")
	prev.pressed.connect(func() -> void: _rotate(-1))
	nav.add_child(prev)

	# Vignette centrale : portrait + nom + descriptif + stats
	var card := PanelContainer.new()
	nav.add_child(card)
	card.add_theme_stylebox_override("panel", _flat(COL_PANEL, COL_BORDER, 18, 4))
	var card_box := VBoxContainer.new()
	card_box.add_theme_constant_override("separation", 10)
	card.add_child(card_box)

	var portrait_box := HBoxContainer.new()
	portrait_box.alignment = BoxContainer.ALIGNMENT_CENTER
	card_box.add_child(portrait_box)
	_portrait = TextureRect.new()
	_portrait.custom_minimum_size = Vector2(180, 180)
	_portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	portrait_box.add_child(_portrait)

	_name_label = Label.new()
	_name_label.add_theme_font_size_override("font_size", 34)
	_name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_name_label.add_theme_color_override("font_color", COL_TXT)
	card_box.add_child(_name_label)

	_desc_label = Label.new()
	_desc_label.add_theme_font_size_override("font_size", 21)
	_desc_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_desc_label.add_theme_color_override("font_color", COL_TXT)
	_desc_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_desc_label.custom_minimum_size = Vector2(420, 0)
	card_box.add_child(_desc_label)

	_stats_label = Label.new()
	_stats_label.add_theme_font_size_override("font_size", 18)
	_stats_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_stats_label.add_theme_color_override("font_color", Color(0.35, 0.25, 0.08))
	card_box.add_child(_stats_label)

	var next := _nav_btn("›")
	next.pressed.connect(func() -> void: _rotate(1))
	nav.add_child(next)

	# Bouton AJOUTER / RETIRER
	_action_btn = Button.new()
	_action_btn.set_anchors_and_offsets_preset(Control.PRESET_CENTER_TOP)
	_action_btn.offset_left = -190.0
	_action_btn.offset_right = 190.0
	_action_btn.offset_top = 590.0
	_action_btn.offset_bottom = 670.0
	_action_btn.add_theme_font_size_override("font_size", 26)
	_action_btn.pressed.connect(_on_action)
	_root.add_child(_action_btn)

	# Aperçu de l'équipe (3 emplacements)
	var preview_title := Label.new()
	preview_title.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
	preview_title.offset_top = -260.0
	preview_title.offset_bottom = -220.0
	preview_title.text = "VOTRE ÉQUIPE"
	preview_title.add_theme_font_size_override("font_size", 24)
	preview_title.add_theme_color_override("font_color", Color(1.0, 0.86, 0.4))
	preview_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_root.add_child(preview_title)

	var team_row := HBoxContainer.new()
	team_row.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
	team_row.offset_top = -210.0
	team_row.offset_bottom = -60.0
	team_row.alignment = BoxContainer.ALIGNMENT_CENTER
	team_row.add_theme_constant_override("separation", 30)
	_root.add_child(team_row)
	for i: int in range(MAX_TEAM_SIZE):
		var slot := PanelContainer.new()
		slot.custom_minimum_size = Vector2(220, 150)
		slot.add_theme_stylebox_override("panel", _flat(Color(0.10, 0.13, 0.20, 0.9), Color(0.3, 0.35, 0.45), 14, 2))
		var lbl := Label.new()
		lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		lbl.add_theme_font_size_override("font_size", 22)
		lbl.text = "(vide)"
		slot.add_child(lbl)
		team_row.add_child(slot)
		_team_slots.append(slot)

	# Bouton COMBATTRE (texte actualisé dans refresh())
	var go := _std_btn("⚔  COMBATTRE", Color(0.35, 0.70, 0.30))
	_fight_btn = go
	go.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_RIGHT)
	go.offset_left = -400.0
	go.offset_right = -60.0
	go.offset_top = -160.0
	go.offset_bottom = -80.0
	go.pressed.connect(_on_combat)
	_root.add_child(go)

	# Fiche des personnages : niveaux, XP, points de caractéristiques (AU-DESSUS de l'équipement)
	var chars := _std_btn("📈  PERSONNAGES", Color(0.40, 0.60, 0.85))
	_chars_btn = chars
	chars.tooltip_text = "Niveaux, XP et répartition des points de caractéristiques."
	chars.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_LEFT)
	chars.offset_left = 60.0
	chars.offset_right = 400.0
	chars.offset_top = -250.0
	chars.offset_bottom = -170.0
	chars.pressed.connect(_on_characters)
	_root.add_child(chars)

	# Équipement (si partie active)
	var eq := _std_btn("🎒  ÉQUIPEMENT", Color(0.75, 0.55, 0.20))
	_equip_btn = eq
	eq.tooltip_text = "Équiper vos personnages avec les objets gagnés."
	eq.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_LEFT)
	eq.offset_left = 60.0
	eq.offset_right = 400.0
	eq.offset_top = -160.0
	eq.offset_bottom = -80.0
	eq.pressed.connect(_on_equipment)
	_root.add_child(eq)

	# Retour
	var back := _std_btn("←  MENU", Color(0.35, 0.40, 0.55))
	back.set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)
	back.offset_left = 40.0
	back.offset_right = 240.0
	back.offset_top = 30.0
	back.offset_bottom = 100.0
	back.pressed.connect(func() -> void: back_requested.emit())
	_root.add_child(back)

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

	var tex_path := "res://assets/sprites/players/%s.png" % classe.to_lower()
	if ResourceLoader.exists(tex_path):
		_portrait.texture = load(tex_path)

	_name_label.text = "%s  %s" % [meta["icon"], classe]
	_desc_label.text = String(meta["description"])
	_stats_label.text = _stat_line(classe)

	var in_team: bool = team.has(classe)
	if in_team:
		_action_btn.text = "✕  RETIRER DE L'ÉQUIPE"
		_action_btn.add_theme_stylebox_override("normal", _flat(Color(0.92, 0.35, 0.28), Color(0.6, 0.2, 0.15), 14, 3))
	else:
		var full: bool = team.size() >= MAX_TEAM_SIZE
		_action_btn.text = "＋  AJOUTER À L'ÉQUIPE" if not full else "ÉQUIPE PLEINE"
		_action_btn.add_theme_stylebox_override("normal", _flat(
			Color(0.45, 0.78, 0.38) if not full else Color(0.4, 0.4, 0.42),
			Color(0.25, 0.5, 0.2) if not full else Color(0.3, 0.3, 0.32), 14, 3))

	var fight_no: int = 1
	var boss_fight: bool = false
	var next_lvl: int = 0
	if GameManager.active_slot >= 0 and not GameManager.active_save.is_empty():
		fight_no = ProgressionManager.next_fight_number(GameManager.active_save)
		boss_fight = ProgressionManager.is_boss_fight(GameManager.active_save)
		next_lvl = int(GameManager.active_save.get("level", 0))
	var biome: String = ProgressionManager.next_biome(GameManager.active_save) if not GameManager.active_save.is_empty() else "Forêt"
	if boss_fight:
		_title.text = "COMBAT %d — %s : ☠ AFFRONTEZ %s ! (%d/%d)" % [fight_no, ProgressionManager.biome_label(biome),
			ProgressionManager.biome_boss(biome).to_upper(), team.size(), MAX_TEAM_SIZE]
		_title.add_theme_color_override("font_color", Color(1.0, 0.4, 0.3))
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
	if _fight_btn:
		if boss_fight:
			_fight_btn.text = "☠  COMBATTRE %s (nv%d)" % [ProgressionManager.biome_boss(biome).to_upper(), next_lvl]
		elif next_lvl > 0:
			_fight_btn.text = "⚔  COMBATTRE — %s nv%d" % [biome, next_lvl]
		else:
			_fight_btn.text = "⚔  COMBATTRE"

	# Aperçu
	for i: int in range(MAX_TEAM_SIZE):
		var slot: PanelContainer = _team_slots[i]
		var lbl: Label = slot.get_child(0)
		if i < team.size():
			var c: String = team[i]
			var m: Dictionary = CLASS_META.get(c, {"icon": "❔"})
			lbl.text = "%s %s" % [m["icon"], c]
			if GameManager.active_slot >= 0 and not GameManager.active_save.is_empty():
				lbl.text += "\nNiv %d" % ProgressionManager.member_level(GameManager.active_save, c)
			slot.add_theme_stylebox_override("panel", _flat(
				CLASS_COLORS.get(c, Color(0.4, 0.4, 0.4)).lightened(0.25),
				CLASS_COLORS.get(c, Color(0.4, 0.4, 0.4)).darkened(0.3), 14, 3))
		else:
			lbl.text = "(vide)"
			slot.add_theme_stylebox_override("panel", _flat(Color(0.10, 0.13, 0.20, 0.9), Color(0.3, 0.35, 0.45), 14, 2))

func _flat(bg: Color, border: Color, radius: int = 12, bw: int = 3) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = bg
	s.border_color = border
	s.set_border_width_all(bw)
	s.set_corner_radius_all(radius)
	return s
