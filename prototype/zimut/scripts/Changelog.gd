class_name Changelog
extends RefCounted
## Journal des nouveautés : data/changelog.txt (historique) + data/changelog.d/*.txt (un fichier par version, lignes « version|texte »).
## Affiché une seule fois par version, au premier lancement du menu (réglage « changelog_seen »).

const PATH := "res://data/changelog.txt"
## Nouvelles entrées : UN FICHIER PAR VERSION (data/changelog.d/V101.txt, lignes « V101|texte »).
## Chaque PR ajoute son propre fichier : plus aucun conflit de merge sur le haut de changelog.txt.
const DIR := "res://data/changelog.d/"


static func _num(id: String) -> int:
	return int(id.trim_prefix("V"))


## Fusionne plusieurs textes « version|texte » et renvoie la version la plus élevée
## (comparaison numérique : V100 > V99) avec toutes ses lignes, dans l'ordre des sources.
static func merge_latest(sources: Array) -> Dictionary:
	var best: String = ""
	var lines_by: Dictionary = {}
	for src: Variant in sources:
		for raw: String in String(src).split("\n"):
			var l: String = raw.strip_edges()
			if l == "" or not l.contains("|"):
				continue
			var parts: PackedStringArray = l.split("|", true, 1)
			var id: String = parts[0].strip_edges()
			if not lines_by.has(id):
				lines_by[id] = [] as Array[String]
			lines_by[id].append(parts[1])
			if best == "" or _num(id) > _num(best):
				best = id
	return {} if best == "" else {"id": best, "lines": lines_by[best]}


## { "id": "V74", "lines": [texte, …] } pour la version la plus récente ({} si rien).
static func latest() -> Dictionary:
	var sources: Array = []
	var f := FileAccess.open(PATH, FileAccess.READ)
	if f != null:
		sources.append(f.get_as_text())
		f.close()
	var names: PackedStringArray = DirAccess.get_files_at(DIR)
	names.sort()
	for n: String in names:
		if n.ends_with(".txt"):
			var g := FileAccess.open(DIR + n, FileAccess.READ)
			if g != null:
				sources.append(g.get_as_text())
				g.close()
	return merge_latest(sources)


## Faut-il montrer le journal ? (nouvelle version jamais vue)
static func pending() -> Dictionary:
	var c: Dictionary = latest()
	if c.is_empty():
		return {}
	var gs: Node = Engine.get_main_loop().root.get_node_or_null("GameSettings")
	if gs == null or String(gs.get("changelog_seen")) == String(c["id"]):
		return {}
	return c


## Construit la fenêtre (à ajouter à un CanvasLayer / Control) ; la fermeture mémorise la version vue.
static func build_popup(c: Dictionary) -> Control:
	var dim := ColorRect.new()
	dim.color = Color(0, 0, 0, 0.6)
	dim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var box := PanelContainer.new()
	box.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	box.custom_minimum_size = Vector2(760, 0)
	box.grow_horizontal = Control.GROW_DIRECTION_BOTH
	box.grow_vertical = Control.GROW_DIRECTION_BOTH
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0.1, 0.1, 0.16, 0.97)
	sb.border_color = Color(1.0, 0.86, 0.4)
	sb.set_border_width_all(3)
	sb.set_corner_radius_all(16)
	sb.set_content_margin_all(24)
	box.add_theme_stylebox_override("panel", sb)
	dim.add_child(box)
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 10)
	box.add_child(v)
	var title := Label.new()
	title.text = "Nouveautés"
	title.add_theme_font_size_override("font_size", 34)
	title.add_theme_color_override("font_color", Color(1.0, 0.86, 0.4))
	v.add_child(title)
	for l: String in c["lines"]:
		var lb := Label.new()
		lb.text = "• " + l
		lb.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		lb.custom_minimum_size = Vector2(700, 0)
		lb.add_theme_font_size_override("font_size", 22)
		v.add_child(lb)
	var ok := Button.new()
	ok.text = "C'est noté"
	ok.custom_minimum_size = Vector2(0, 56)
	ok.add_theme_font_size_override("font_size", 24)
	ok.pressed.connect(func() -> void:
		var gs: Node = Engine.get_main_loop().root.get_node_or_null("GameSettings")
		if gs != null:
			gs.call("mark_changelog_seen", String(c["id"]))
		dim.queue_free())
	v.add_child(ok)
	return dim
