class_name Adv3DWorldMap
extends Control
## Adv3DWorldMap.gd — Carte du MONDE TOTAL (V81) : toutes les nations (une grande zone
## par nation) sur leur grille, avec les portails entre elles (vert = ouvert, rouge =
## fermé), la zone courante en surbrillance et les zones déjà visitées.
## Utilisée dans la carte plein écran du monde ouvert (onglet « Monde »).
## V82 : dessinée sur la carte peinte de la Conquête, un repère par nation à l'emplacement de sa région.

var _save: Dictionary = {}
var _state: Dictionary = {}
var _current: String = ""
const MAP_PATH := "res://assets/ui/conquest/conquest_world_map.jpg"
## Emplacement de chaque nation sur la carte peinte (coordonnées normalisées).
const NATION_POS := {
	"foret_sylve": Vector2(0.17, 0.27), "brasier_cendres": Vector2(0.12, 0.70), "brumes_marais": Vector2(0.50, 0.77),
	"montagne_pics": Vector2(0.55, 0.15), "vents_plateau": Vector2(0.10, 0.07), "ombres_necropole": Vector2(0.45, 0.45),
	"desert_dunes": Vector2(0.77, 0.27), "marees_cotes": Vector2(0.91, 0.52), "cristaux_caverne": Vector2(0.88, 0.80),
	"rouages_atelier": Vector2(0.93, 0.10), "portes_donjon": Vector2(0.63, 0.40),
}
var _tex: Texture2D = null


func setup(save: Dictionary, state: Dictionary, current_zone: String) -> void:
	_save = save
	_state = state
	_current = current_zone
	queue_redraw()


func _draw() -> void:
	var zones: Dictionary = ProgressionManager.ADVENTURE_ZONES
	if zones.is_empty():
		return
	if _tex == null and ResourceLoader.exists(MAP_PATH):
		_tex = load(MAP_PATH) as Texture2D
	var legend_h := 46.0
	var area := Rect2(Vector2(12, 12), size - Vector2(24, 24 + legend_h))
	var ratio: float = 1.5
	var w: float = minf(area.size.x, area.size.y * ratio)
	var r_map := Rect2(area.position + Vector2((area.size.x - w) * 0.5, (area.size.y - w / ratio) * 0.5), Vector2(w, w / ratio))
	if _tex != null:
		draw_texture_rect(_tex, r_map, false)
	else:
		draw_rect(r_map, Color(0.12, 0.30, 0.45))
	draw_rect(r_map, Color(0.95, 0.80, 0.40), false, 3.0)
	var f: Font = ThemeDB.fallback_font
	var unlocked: Array = _state.get("zones_unlocked", ["foret_sylve"])
	var pos: Dictionary = {}
	for z: String in zones.keys():
		var np: Vector2 = NATION_POS.get(z, Vector2(0.5, 0.5))
		pos[z] = r_map.position + np * r_map.size
	# Portails entre nations : vert ouvert, rouge fermé (pointillés)
	for z2: String in zones.keys():
		for dir: String in ["E", "S"]:
			var nb: String = AdventureTerrain.neighbor(z2, dir)
			if nb == "" or not pos.has(nb):
				continue
			var open: bool = ProgressionManager.adventure_gate_open(_state, z2, nb)
			var col: Color = Color(0.30, 0.95, 0.55, 0.95) if open else Color(0.95, 0.35, 0.30, 0.9)
			var a: Vector2 = pos[z2]
			var b: Vector2 = pos[nb]
			if open:
				draw_line(a, b, Color(0, 0, 0, 0.45), 5.0)
				draw_line(a, b, col, 2.5)
			else:
				var steps: int = int(a.distance_to(b) / 16.0)
				for i: int in range(0, steps, 2):
					draw_line(a.lerp(b, float(i) / float(maxi(1, steps))), a.lerp(b, float(i + 1) / float(maxi(1, steps))), col, 4.0)
	# Nations : médaillon de la couleur du biome, nom + niveau
	var fs: int = int(clampf(r_map.size.x * 0.017, 13.0, 24.0))
	for z3: String in zones.keys():
		var meta: Dictionary = zones[z3]
		var c: Vector2 = pos[z3]
		var pal: Dictionary = Adv3DWorld.palette(String(meta.get("biome", "Forêt")))
		var base: Color = (pal["ground"][0] as Color)
		var is_cur: bool = z3 == _current
		var is_unlocked: bool = unlocked.has(z3)
		var rad: float = fs * 1.15
		if not is_unlocked:
			base = base.darkened(0.6)
		draw_circle(c, rad + 4.0, Color(0, 0, 0, 0.55))
		draw_circle(c, rad, base)
		draw_arc(c, rad, 0.0, TAU, 32, Color(1.0, 0.88, 0.30) if is_cur else (Color(0.65, 0.95, 0.72) if is_unlocked else Color(0.45, 0.45, 0.50)), 4.0 if is_cur else 2.5)
		var label: String = String(meta.get("name", z3))
		if not is_unlocked:
			label = "🔒 " + label
		var lvl_txt: String = "niv %d" % ProgressionManager.adventure_zone_level(z3)
		var wl: float = f.get_string_size(label, HORIZONTAL_ALIGNMENT_LEFT, -1, fs).x
		var plate := Rect2(c + Vector2(-wl * 0.5 - 8.0, rad + 4.0), Vector2(wl + 16.0, fs * 2.3))
		draw_rect(plate, Color(0.05, 0.07, 0.12, 0.78))
		draw_string(f, plate.position + Vector2(8.0, fs * 1.0), label, HORIZONTAL_ALIGNMENT_LEFT, -1, fs, Color(1, 1, 1) if is_unlocked else Color(0.75, 0.75, 0.78))
		var wv: float = f.get_string_size(lvl_txt, HORIZONTAL_ALIGNMENT_LEFT, -1, fs - 2).x
		draw_string(f, plate.position + Vector2((plate.size.x - wv) * 0.5, fs * 2.05), lvl_txt, HORIZONTAL_ALIGNMENT_LEFT, -1, fs - 2, Color(1.0, 0.9, 0.5) if is_unlocked else Color(0.7, 0.7, 0.72))
		if is_cur:
			var t: Vector2 = c + Vector2(0, -rad - 12.0)
			draw_colored_polygon(PackedVector2Array([t + Vector2(0, 10), t + Vector2(10, -8), t + Vector2(-10, -8)]), Color(1.0, 0.92, 0.25))
	# Légende
	var ly: float = size.y - 30.0
	draw_circle(Vector2(34, ly), 6, Color(0.30, 0.90, 0.55))
	draw_string(f, Vector2(48, ly + 6), "portail ouvert", HORIZONTAL_ALIGNMENT_LEFT, -1, 18, Color(0.9, 0.9, 0.9))
	draw_line(Vector2(190, ly), Vector2(226, ly), Color(0.90, 0.35, 0.30), 4.0)
	draw_string(f, Vector2(238, ly + 6), "portail fermé", HORIZONTAL_ALIGNMENT_LEFT, -1, 18, Color(0.9, 0.9, 0.9))
	draw_arc(Vector2(380, ly), 8, 0.0, TAU, 20, Color(1.0, 0.85, 0.30), 4.0)
	draw_string(f, Vector2(394, ly + 6), "nation courante", HORIZONTAL_ALIGNMENT_LEFT, -1, 18, Color(0.9, 0.9, 0.9))
	draw_string(f, Vector2(564, ly + 6), "🔒 nation verrouillée", HORIZONTAL_ALIGNMENT_LEFT, -1, 18, Color(0.9, 0.9, 0.9))
