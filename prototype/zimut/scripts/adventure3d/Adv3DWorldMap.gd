class_name Adv3DWorldMap
extends Control
## Adv3DWorldMap.gd — Carte du MONDE TOTAL (V81) : toutes les nations (une grande zone
## par nation) sur leur grille, avec les portails entre elles (vert = ouvert, rouge =
## fermé), la zone courante en surbrillance et les zones déjà visitées.
## Utilisée dans la carte plein écran du monde ouvert (onglet « Monde »).

var _save: Dictionary = {}
var _state: Dictionary = {}
var _current: String = ""


func setup(save: Dictionary, state: Dictionary, current_zone: String) -> void:
	_save = save
	_state = state
	_current = current_zone
	queue_redraw()


func _draw() -> void:
	var zones: Dictionary = ProgressionManager.ADVENTURE_ZONES
	if zones.is_empty():
		return
	var lo := Vector2i(1 << 30, 1 << 30)
	var hi := Vector2i(-(1 << 30), -(1 << 30))
	for z: String in zones.keys():
		var g: Vector2i = AdventureTerrain.grid_of(z)
		lo = Vector2i(mini(lo.x, g.x), mini(lo.y, g.y))
		hi = Vector2i(maxi(hi.x, g.x), maxi(hi.y, g.y))
	var cols: int = hi.x - lo.x + 1
	var rows: int = hi.y - lo.y + 1
	var legend_h := 46.0
	var area := Rect2(Vector2(20, 20), size - Vector2(40, 40 + legend_h))
	var cell: float = minf(area.size.x / float(cols), area.size.y / float(rows))
	var origin: Vector2 = area.position + (area.size - Vector2(float(cols), float(rows)) * cell) * 0.5
	var centers: Dictionary = {}
	# Portails entre nations (E et S pour ne pas doubler) : vert ouvert, rouge fermé.
	for z: String in zones.keys():
		centers[z] = origin + (Vector2(AdventureTerrain.grid_of(z)) - Vector2(lo)) * cell + Vector2(cell, cell) * 0.5
	for z2: String in zones.keys():
		for dir: String in ["E", "S"]:
			var nb: String = AdventureTerrain.neighbor(z2, dir)
			if nb == "":
				continue
			var open: bool = ProgressionManager.adventure_gate_open(_state, z2, nb)
			var col: Color = Color(0.30, 0.90, 0.55, 0.9) if open else Color(0.90, 0.35, 0.30, 0.9)
			var a: Vector2 = centers[z2]
			var b: Vector2 = centers[nb]
			# pointillés si fermé
			if open:
				draw_line(a, b, col, 4.0)
			else:
				var steps: int = int(a.distance_to(b) / 14.0)
				for i: int in range(0, steps, 2):
					var p0: Vector2 = a.lerp(b, float(i) / float(maxi(1, steps)))
					var p1: Vector2 = a.lerp(b, float(i + 1) / float(maxi(1, steps)))
					draw_line(p0, p1, col, 4.0)
	# Chaque nation : tuile de sa couleur de biome, état (courante / visitée / débloquée / verrouillée).
	var unlocked: Array = _state.get("zones_unlocked", ["foret_sylve"])
	var visited: Array = unlocked   # cartes visitées = zones débloquées (voyage rapide)
	var f: Font = ThemeDB.fallback_font
	for z3: String in zones.keys():
		var meta: Dictionary = zones[z3]
		var g3: Vector2i = AdventureTerrain.grid_of(z3)
		var top_left: Vector2 = origin + (Vector2(g3) - Vector2(lo)) * cell
		var r := Rect2(top_left + Vector2(4, 4), Vector2(cell, cell) - Vector2(8, 8))
		var biome: String = String(meta.get("biome", "Forêt"))
		var pal: Dictionary = Adv3DWorld.palette(biome)
		var base: Color = (pal["ground"][0] as Color)
		var is_cur: bool = z3 == _current
		var is_visited: bool = visited.has(z3)
		var is_unlocked: bool = (unlocked as Array).has(z3) or is_visited
		if not is_unlocked:
			base = base.darkened(0.55)
		var sb := StyleBoxFlat.new()
		sb.bg_color = base
		sb.border_color = Color(1.0, 0.85, 0.30) if is_cur else (Color(0.55, 0.95, 0.65) if is_unlocked else Color(0.35, 0.35, 0.40))
		sb.set_border_width_all(5 if is_cur else 2)
		sb.set_corner_radius_all(10)
		draw_style_box(sb, r)
		# nom de la nation + niveau + cadenas si verrouillée
		var label: String = String(meta.get("name", z3))
		var lvl_txt: String = "niv %d" % ProgressionManager.adventure_zone_level(z3)
		if not is_unlocked:
			label = "🔒 " + label
		var fs: int = int(clampf(cell * 0.16, 13.0, 22.0))
		var w_label: float = f.get_string_size(label, HORIZONTAL_ALIGNMENT_LEFT, -1, fs).x
		draw_string(f, r.position + Vector2((r.size.x - w_label) * 0.5, r.size.y * 0.42), label,
			HORIZONTAL_ALIGNMENT_LEFT, -1, fs, Color(1, 1, 1) if is_unlocked else Color(0.75, 0.75, 0.78))
		var w_lvl: float = f.get_string_size(lvl_txt, HORIZONTAL_ALIGNMENT_LEFT, -1, fs - 2).x
		draw_string(f, r.position + Vector2((r.size.x - w_lvl) * 0.5, r.size.y * 0.72), lvl_txt,
			HORIZONTAL_ALIGNMENT_LEFT, -1, fs - 2, Color(1.0, 0.9, 0.5) if is_unlocked else Color(0.7, 0.7, 0.72))
		if is_cur:
			# marqueur « vous êtes ici » : petit triangle au-dessus de la tuile
			var c: Vector2 = r.get_center() + Vector2(0, -r.size.y * 0.62)
			draw_colored_polygon(PackedVector2Array([c + Vector2(0, -10), c + Vector2(9, 7), c + Vector2(-9, 7)]), Color(1.0, 0.92, 0.25))
	# Légende
	var ly: float = size.y - 30.0
	draw_circle(Vector2(34, ly), 6, Color(0.30, 0.90, 0.55))
	draw_string(f, Vector2(48, ly + 6), "portail ouvert", HORIZONTAL_ALIGNMENT_LEFT, -1, 18, Color(0.9, 0.9, 0.9))
	draw_line(Vector2(190, ly), Vector2(226, ly), Color(0.90, 0.35, 0.30), 4.0)
	draw_string(f, Vector2(238, ly + 6), "portail fermé", HORIZONTAL_ALIGNMENT_LEFT, -1, 18, Color(0.9, 0.9, 0.9))
	draw_rect(Rect2(Vector2(370, ly - 8), Vector2(16, 16)), Color(1.0, 0.85, 0.30), false, 4.0)
	draw_string(f, Vector2(394, ly + 6), "nation courante", HORIZONTAL_ALIGNMENT_LEFT, -1, 18, Color(0.9, 0.9, 0.9))
	draw_rect(Rect2(Vector2(540, ly - 8), Vector2(16, 16)), Color(0.3, 0.3, 0.33), false, 2.0)
	draw_string(f, Vector2(564, ly + 6), "nation verrouillée", HORIZONTAL_ALIGNMENT_LEFT, -1, 18, Color(0.9, 0.9, 0.9))
