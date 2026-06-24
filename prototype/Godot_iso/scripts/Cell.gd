extends Node2D
class_name Cell
## Cell.gd - Cellule isométrique style Waven
## Rendu natif avec _draw() - Version corrigée

const CELL_SIZE := Vector2i(100, 100)
const HALF := Vector2(50, 50)

# Couleurs style Waven (tons chauds)
const GRASS_COLOR := Color(0.42, 0.56, 0.14)  # #6B8E23
const GRASS_SIDE_LEFT := Color(0.33, 0.42, 0.18)  # #556B2F
const GRASS_SIDE_RIGHT := Color(0.56, 0.74, 0.56)  # #8FBC8F
const GRASS_HIGHLIGHT := Color(0.68, 1.0, 0.18, 0.4)
const GRASS_SHADOW := Color(0.18, 0.54, 0.34, 0.3)

const DIRT_COLOR := Color(0.54, 0.27, 0.07)  # #8B4513
const DIRT_SIDE_LEFT := Color(0.40, 0.26, 0.13)  # #654321
const DIRT_SIDE_RIGHT := Color(0.63, 0.32, 0.18)  # #A0522D
const DIRT_HIGHLIGHT := Color(0.80, 0.52, 0.25, 0.5)
const DIRT_SHADOW := Color(0.29, 0.17, 0.16, 0.4)

const STONE_COLOR := Color(0.41, 0.41, 0.41)
const STONE_SIDE_LEFT := Color(0.29, 0.29, 0.29)
const STONE_SIDE_RIGHT := Color(0.50, 0.50, 0.50)
const STONE_HIGHLIGHT := Color(0.66, 0.66, 0.66, 0.6)
const STONE_SHADOW := Color(0.18, 0.18, 0.18, 0.5)

const BORDER_HIGHLIGHT := Color(1.0, 0.83, 0.0, 0.6)
const SELECTION_COLOR := Color(1.0, 0.84, 0.0, 0.5)
const HIGHLIGHT_COLOR := Color(1.0, 1.0, 1.0, 0.3)

var grid_position: Vector2i = Vector2i(0, 0)
var entity = null
var selected: bool = false
var highlighted: bool = false

signal cell_clicked(x: int, y: int)


func _ready():
	pass


func _draw():
	# Dessiner la tuile isométrique (losange)
	var points = PackedVector2Array()
	points.append(Vector2(0, 50))
	points.append(Vector2(50, 0))
	points.append(Vector2(100, 50))
	points.append(Vector2(50, 100))
	
	# Déterminer le type de tuile (effet damier)
	var is_grass := (grid_position.x + grid_position.y) % 2 == 0
	
	if is_grass:
		# Herbe - style Waven
		draw_polygon(points, make_colors([Color(0,0,0,0), GRASS_COLOR, GRASS_COLOR, GRASS_COLOR]))
		
		# Face latérale gauche
		var left_points = PackedVector2Array()
		left_points.append(Vector2(0, 50))
		left_points.append(Vector2(50, 0))
		left_points.append(Vector2(50, 50))
		draw_polygon(left_points, make_colors([Color(0,0,0,0), GRASS_SIDE_LEFT, GRASS_SIDE_LEFT]))
		
		# Face latérale droite
		var right_points = PackedVector2Array()
		right_points.append(Vector2(50, 50))
		right_points.append(Vector2(100, 50))
		right_points.append(Vector2(50, 100))
		draw_polygon(right_points, make_colors([Color(0,0,0,0), GRASS_SIDE_RIGHT, GRASS_SIDE_RIGHT]))
		
		# Highlight supérieur
		var top_hl = PackedVector2Array()
		top_hl.append(Vector2(15, 45))
		top_hl.append(Vector2(50, 5))
		top_hl.append(Vector2(85, 45))
		top_hl.append(Vector2(50, 35))
		draw_polygon(top_hl, make_colors([Color(0,0,0,0), GRASS_HIGHLIGHT, GRASS_HIGHLIGHT, GRASS_HIGHLIGHT]))
		
		# Ombre inférieure
		var bottom_sh = PackedVector2Array()
		bottom_sh.append(Vector2(15, 55))
		bottom_sh.append(Vector2(50, 95))
		bottom_sh.append(Vector2(85, 55))
		bottom_sh.append(Vector2(50, 65))
		draw_polygon(bottom_sh, make_colors([Color(0,0,0,0), GRASS_SHADOW, GRASS_SHADOW, GRASS_SHADOW]))
		
		# Bordure lumineuse style Waven
		draw_polygon(points, make_colors([BORDER_HIGHLIGHT, BORDER_HIGHLIGHT, BORDER_HIGHLIGHT, BORDER_HIGHLIGHT]), null, null, 1)
		
		# Texture herbe (lignes courbes)
		draw_grass_texture()
	else:
		# Terre - style Waven
		draw_polygon(points, make_colors([Color(0,0,0,0), DIRT_COLOR, DIRT_COLOR, DIRT_COLOR]))
		
		# Face latérale gauche
		var left_points = PackedVector2Array()
		left_points.append(Vector2(0, 50))
		left_points.append(Vector2(50, 0))
		left_points.append(Vector2(50, 50))
		draw_polygon(left_points, make_colors([Color(0,0,0,0), DIRT_SIDE_LEFT, DIRT_SIDE_LEFT]))
		
		# Face latérale droite
		var right_points = PackedVector2Array()
		right_points.append(Vector2(50, 50))
		right_points.append(Vector2(100, 50))
		right_points.append(Vector2(50, 100))
		draw_polygon(right_points, make_colors([Color(0,0,0,0), DIRT_SIDE_RIGHT, DIRT_SIDE_RIGHT]))
		
		# Highlight supérieur
		var top_hl = PackedVector2Array()
		top_hl.append(Vector2(15, 45))
		top_hl.append(Vector2(50, 5))
		top_hl.append(Vector2(85, 45))
		top_hl.append(Vector2(50, 35))
		draw_polygon(top_hl, make_colors([Color(0,0,0,0), DIRT_HIGHLIGHT, DIRT_HIGHLIGHT, DIRT_HIGHLIGHT]))
		
		# Ombre inférieure
		var bottom_sh = PackedVector2Array()
		bottom_sh.append(Vector2(15, 55))
		bottom_sh.append(Vector2(50, 95))
		bottom_sh.append(Vector2(85, 55))
		bottom_sh.append(Vector2(50, 65))
		draw_polygon(bottom_sh, make_colors([Color(0,0,0,0), DIRT_SHADOW, DIRT_SHADOW, DIRT_SHADOW]))
		
		# Bordure lumineuse style Waven
		draw_polygon(points, make_colors([BORDER_HIGHLIGHT, BORDER_HIGHLIGHT, BORDER_HIGHLIGHT, BORDER_HIGHLIGHT]), null, null, 1)
		
		# Texture terre
		draw_dirt_texture()
	
	# Dessiner la sélection si active
	if selected:
		var sel_points = PackedVector2Array()
		sel_points.append(Vector2(5, 50))
		sel_points.append(Vector2(50, 5))
		sel_points.append(Vector2(95, 50))
		sel_points.append(Vector2(50, 95))
		draw_polygon(sel_points, make_colors([Color(0,0,0,0), SELECTION_COLOR, SELECTION_COLOR, SELECTION_COLOR]), null, null, 1)
	
	# Dessiner le highlight si active
	if highlighted:
		var hl_points = PackedVector2Array()
		hl_points.append(Vector2(3, 50))
		hl_points.append(Vector2(50, 3))
		hl_points.append(Vector2(97, 50))
		hl_points.append(Vector2(50, 97))
		draw_polygon(hl_points, make_colors([Color(0,0,0,0), HIGHLIGHT_COLOR, HIGHLIGHT_COLOR, HIGHLIGHT_COLOR]), null, null, 1)
	
	# Dessiner l'entité si présente
	if entity:
		draw_entity()


func make_colors(arr: Array) -> PackedColorArray:
	"""Convertit un tableau de Color en PackedColorArray"""
	var result = PackedColorArray()
	for c in arr:
		result.append(c)
	return result


func draw_grass_texture():
	"""Dessine la texture d'herbe"""
	var grass_color := Color(0.24, 0.70, 0.44)
	
	draw_line(Vector2(20, 30), Vector2(30, 20), grass_color, 1.5, true)
	draw_line(Vector2(60, 35), Vector2(70, 25), grass_color, 1.5, true)
	draw_line(Vector2(30, 60), Vector2(40, 50), grass_color, 1.5, true)
	draw_line(Vector2(70, 65), Vector2(80, 55), grass_color, 1.5, true)


func draw_dirt_texture():
	"""Dessine la texture de terre"""
	var dirt_color := Color(0.63, 0.32, 0.18)
	
	# Dessiner des ellipses comme textures
	var ellipse_positions = [
		Vector2(25, 35),
		Vector2(45, 40),
		Vector2(75, 30),
		Vector2(35, 65),
		Vector2(65, 70)
	]
	var ellipse_sizes = [
		Vector2(4, 2),
		Vector2(3, 1.5),
		Vector2(5, 2.5),
		Vector2(3.5, 2),
		Vector2(4, 2)
	]
	
	for i in range(ellipse_positions.size()):
		var center = ellipse_positions[i]
		var radius = ellipse_sizes[i]
		var num_points := 20
		var pts := PackedVector2Array()
		var cols := PackedColorArray()
		
		for j in range(num_points + 1):
			var angle := j * TAU / num_points
			pts.append(center + Vector2(cos(angle) * radius.x, sin(angle) * radius.y))
			cols.append(dirt_color)
		
		draw_polygon(pts, cols)


func draw_entity():
	"""Dessine l'entité au centre de la cellule"""
	var center := HALF
	var entity_type = entity.get("entity_type", "")
	var classe = entity.get("classe", "")
	var color = GameManager.COLORS.get(classe, Color(0.5, 0.5, 0.5))
	
	if entity_type == "Player":
		# Cercle pour les joueurs
		draw_custom_circle(center, 25.0, color, false, 1.0)
		
		# Bordure active
		if entity.get("is_active", false):
			draw_custom_circle(center, 28.0, Color.YELLOW, true, 2.0)
		else:
			draw_custom_circle(center, 28.0, Color.WHITE, true, 1.5)
	else:
		# Triangle pour les ennemis
		var triangle_points = PackedVector2Array()
		triangle_points.append(center + Vector2(-20, -15))
		triangle_points.append(center + Vector2(20, -15))
		triangle_points.append(center + Vector2(0, 20))
		draw_polygon(triangle_points, make_colors([color, color, color]))
		
		# Bordure rouge
		var border_points = PackedVector2Array()
		border_points.append(center + Vector2(-20, -15))
		border_points.append(center + Vector2(20, -15))
		border_points.append(center + Vector2(0, 20))
		draw_polygon(border_points, make_colors([Color.RED, Color.RED, Color.RED]), null, null, 1)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var local_pos = to_local(get_global_mouse_position())
		if _is_point_in_cell(local_pos):
			emit_signal("cell_clicked", grid_position.x, grid_position.y)


func _is_point_in_cell(point: Vector2) -> bool:
	"""Vérifie si un point est dans la cellule (forme losange)"""
	var dx = abs(point.x - HALF.x)
	var dy = abs(point.y - HALF.y)
	return (dx + dy) < 50


# Fonction utilitaire pour dessiner un cercle (renommée pour éviter conflit)
func draw_custom_circle(center: Vector2, radius: float, color: Color, outline_only: bool, outline_width: float):
	var num_points := 32
	var pts := PackedVector2Array()
	var cols := PackedColorArray()
	
	for i in range(num_points + 1):
		var angle := i * TAU / num_points
		pts.append(center + Vector2(cos(angle), sin(angle)) * radius)
		cols.append(color)
	
	if outline_only:
		# Dessiner juste la bordure avec des lignes
		for i in range(num_points):
			var start := pts[i]
			var end := pts[i + 1] if i < num_points else pts[0]
			draw_line(start, end, color, outline_width, true)
	else:
		# Dessiner le cercle rempli
		draw_polygon(pts, cols)
		
		# Bordure blanche
		for i in range(num_points):
			var start := pts[i]
			var end := pts[i + 1] if i < num_points else pts[0]
			draw_line(start, end, Color.WHITE, 1.0, true)