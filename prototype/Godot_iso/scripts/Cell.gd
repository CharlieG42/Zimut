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
const GRASS_HIGHLIGHT := Color(0.68, 1.0, 0.18, 0.4)  # #ADFF2F avec transparence
const GRASS_SHADOW := Color(0.18, 0.54, 0.34, 0.3)  # #2E8B57 avec transparence

const DIRT_COLOR := Color(0.54, 0.27, 0.07)  # #8B4513
const DIRT_SIDE_LEFT := Color(0.40, 0.26, 0.13)  # #654321
const DIRT_SIDE_RIGHT := Color(0.63, 0.32, 0.18)  # #A0522D
const DIRT_HIGHLIGHT := Color(0.80, 0.52, 0.25, 0.5)  # #CD853F avec transparence
const DIRT_SHADOW := Color(0.29, 0.17, 0.16, 0.4)  # #4A2C2A avec transparence

const STONE_COLOR := Color(0.41, 0.41, 0.41)  # #696969
const STONE_SIDE_LEFT := Color(0.29, 0.29, 0.29)  # #4A4A4A
const STONE_SIDE_RIGHT := Color(0.50, 0.50, 0.50)  # #808080
const STONE_HIGHLIGHT := Color(0.66, 0.66, 0.66, 0.6)  # #A9A9A9 avec transparence
const STONE_SHADOW := Color(0.18, 0.18, 0.18, 0.5)  # #2F2F2F avec transparence

const BORDER_HIGHLIGHT := Color(1.0, 0.83, 0.0, 0.6)  # #FFD700 (or clair avec transparence)
const SELECTION_COLOR := Color(1.0, 0.84, 0.0, 0.5)  # Orange transparent
const HIGHLIGHT_COLOR := Color(1.0, 1.0, 1.0, 0.3)  # Blanc transparent

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
		var grass_colors = PackedColorArray()
		grass_colors.append(Color(0, 0, 0, 0))
		grass_colors.append(GRASS_COLOR)
		grass_colors.append(GRASS_COLOR)
		grass_colors.append(GRASS_COLOR)
		draw_polygon(points, grass_colors)
		
		# Face latérale gauche
		var left_points = PackedVector2Array()
		left_points.append(Vector2(0, 50))
		left_points.append(Vector2(50, 0))
		left_points.append(Vector2(50, 50))
		var left_colors = PackedColorArray()
		left_colors.append(Color(0, 0, 0, 0))
		left_colors.append(GRASS_SIDE_LEFT)
		left_colors.append(GRASS_SIDE_LEFT)
		draw_polygon(left_points, left_colors)
		
		# Face latérale droite
		var right_points = PackedVector2Array()
		right_points.append(Vector2(50, 50))
		right_points.append(Vector2(100, 50))
		right_points.append(Vector2(50, 100))
		var right_colors = PackedColorArray()
		right_colors.append(Color(0, 0, 0, 0))
		right_colors.append(GRASS_SIDE_RIGHT)
		right_colors.append(GRASS_SIDE_RIGHT)
		draw_polygon(right_points, right_colors)
		
		# Highlight supérieur
		var top_hl = PackedVector2Array()
		top_hl.append(Vector2(15, 45))
		top_hl.append(Vector2(50, 5))
		top_hl.append(Vector2(85, 45))
		top_hl.append(Vector2(50, 35))
		var top_hl_colors = PackedColorArray()
		top_hl_colors.append(Color(0, 0, 0, 0))
		top_hl_colors.append(GRASS_HIGHLIGHT)
		top_hl_colors.append(GRASS_HIGHLIGHT)
		top_hl_colors.append(GRASS_HIGHLIGHT)
		draw_polygon(top_hl, top_hl_colors)
		
		# Ombre inférieure
		var bottom_sh = PackedVector2Array()
		bottom_sh.append(Vector2(15, 55))
		bottom_sh.append(Vector2(50, 95))
		bottom_sh.append(Vector2(85, 55))
		bottom_sh.append(Vector2(50, 65))
		var bottom_sh_colors = PackedColorArray()
		bottom_sh_colors.append(Color(0, 0, 0, 0))
		bottom_sh_colors.append(GRASS_SHADOW)
		bottom_sh_colors.append(GRASS_SHADOW)
		bottom_sh_colors.append(GRASS_SHADOW)
		draw_polygon(bottom_sh, bottom_sh_colors)
		
		# Bordure lumineuse style Waven
		var border_colors = PackedColorArray()
		border_colors.append(BORDER_HIGHLIGHT)
		border_colors.append(BORDER_HIGHLIGHT)
		border_colors.append(BORDER_HIGHLIGHT)
		border_colors.append(BORDER_HIGHLIGHT)
		draw_polygon(points, border_colors, null, null, 1)
		
		# Texture herbe (lignes courbes)
		draw_grass_texture()
	else:
		# Terre - style Waven
		var dirt_colors = PackedColorArray()
		dirt_colors.append(Color(0, 0, 0, 0))
		dirt_colors.append(DIRT_COLOR)
		dirt_colors.append(DIRT_COLOR)
		dirt_colors.append(DIRT_COLOR)
		draw_polygon(points, dirt_colors)
		
		# Face latérale gauche
		var left_points = PackedVector2Array()
		left_points.append(Vector2(0, 50))
		left_points.append(Vector2(50, 0))
		left_points.append(Vector2(50, 50))
		var left_colors = PackedColorArray()
		left_colors.append(Color(0, 0, 0, 0))
		left_colors.append(DIRT_SIDE_LEFT)
		left_colors.append(DIRT_SIDE_LEFT)
		draw_polygon(left_points, left_colors)
		
		# Face latérale droite
		var right_points = PackedVector2Array()
		right_points.append(Vector2(50, 50))
		right_points.append(Vector2(100, 50))
		right_points.append(Vector2(50, 100))
		var right_colors = PackedColorArray()
		right_colors.append(Color(0, 0, 0, 0))
		right_colors.append(DIRT_SIDE_RIGHT)
		right_colors.append(DIRT_SIDE_RIGHT)
		draw_polygon(right_points, right_colors)
		
		# Highlight supérieur
		var top_hl = PackedVector2Array()
		top_hl.append(Vector2(15, 45))
		top_hl.append(Vector2(50, 5))
		top_hl.append(Vector2(85, 45))
		top_hl.append(Vector2(50, 35))
		var top_hl_colors = PackedColorArray()
		top_hl_colors.append(Color(0, 0, 0, 0))
		top_hl_colors.append(DIRT_HIGHLIGHT)
		top_hl_colors.append(DIRT_HIGHLIGHT)
		top_hl_colors.append(DIRT_HIGHLIGHT)
		draw_polygon(top_hl, top_hl_colors)
		
		# Ombre inférieure
		var bottom_sh = PackedVector2Array()
		bottom_sh.append(Vector2(15, 55))
		bottom_sh.append(Vector2(50, 95))
		bottom_sh.append(Vector2(85, 55))
		bottom_sh.append(Vector2(50, 65))
		var bottom_sh_colors = PackedColorArray()
		bottom_sh_colors.append(Color(0, 0, 0, 0))
		bottom_sh_colors.append(DIRT_SHADOW)
		bottom_sh_colors.append(DIRT_SHADOW)
		bottom_sh_colors.append(DIRT_SHADOW)
		draw_polygon(bottom_sh, bottom_sh_colors)
		
		# Bordure lumineuse style Waven
		var border_colors = PackedColorArray()
		border_colors.append(BORDER_HIGHLIGHT)
		border_colors.append(BORDER_HIGHLIGHT)
		border_colors.append(BORDER_HIGHLIGHT)
		border_colors.append(BORDER_HIGHLIGHT)
		draw_polygon(points, border_colors, null, null, 1)
		
		# Texture terre (ellipses)
		draw_dirt_texture()
	
	# Dessiner la sélection si active
	if selected:
		var sel_points = PackedVector2Array()
		sel_points.append(Vector2(5, 50))
		sel_points.append(Vector2(50, 5))
		sel_points.append(Vector2(95, 50))
		sel_points.append(Vector2(50, 95))
		var sel_colors = PackedColorArray()
		sel_colors.append(Color(0, 0, 0, 0))
		sel_colors.append(SELECTION_COLOR)
		sel_colors.append(SELECTION_COLOR)
		sel_colors.append(SELECTION_COLOR)
		draw_polygon(sel_points, sel_colors, null, null, 1)
	
	# Dessiner le highlight si active
	if highlighted:
		var hl_points = PackedVector2Array()
		hl_points.append(Vector2(3, 50))
		hl_points.append(Vector2(50, 3))
		hl_points.append(Vector2(97, 50))
		hl_points.append(Vector2(50, 97))
		var hl_colors = PackedColorArray()
		hl_colors.append(Color(0, 0, 0, 0))
		hl_colors.append(HIGHLIGHT_COLOR)
		hl_colors.append(HIGHLIGHT_COLOR)
		hl_colors.append(HIGHLIGHT_COLOR)
		draw_polygon(hl_points, hl_colors, null, null, 1)
	
	# Dessiner l'entité si présente
	if entity:
		draw_entity()


func draw_grass_texture():
	"""Dessine la texture d'herbe"""
	var grass_color := Color(0.24, 0.70, 0.44)  # #3CB371
	
	# Brins d'herbe
	draw_line(Vector2(20, 30), Vector2(30, 20), grass_color, 1.5, true)
	draw_line(Vector2(60, 35), Vector2(70, 25), grass_color, 1.5, true)
	draw_line(Vector2(30, 60), Vector2(40, 50), grass_color, 1.5, true)
	draw_line(Vector2(70, 65), Vector2(80, 55), grass_color, 1.5, true)


func draw_dirt_texture():
	"""Dessine la texture de terre"""
	var dirt_color := Color(0.63, 0.32, 0.18)  # #A0522D
	
	# Dessiner des ellipses comme textures
	for i in range(5):
		var cx = 25.0 + i * 20.0
		var cy = 35.0 + (i % 2) * 10.0
		var rx = 4.0 - i * 0.5
		var ry = 2.0 - i * 0.3
		if rx > 0 and ry > 0:
			draw_ellipse(cx, rx, ry, dirt_color)


func draw_entity():
	"""Dessine l'entité au centre de la cellule"""
	var center := HALF
	var entity_type = entity.get("entity_type", "")
	var classe = entity.get("classe", "")
	var color = GameManager.COLORS.get(classe, Color(0.5, 0.5, 0.5))
	
	if entity_type == "Player":
		# Cercle pour les joueurs
		draw_circle(center, 25.0, color)
		
		# Bordure active
		if entity.get("is_active", false):
			draw_circle(center, 28.0, Color.YELLOW, true, 2.0)
		else:
			draw_circle(center, 28.0, Color.WHITE, true, 1.5)
	else:
		# Triangle pour les ennemis
		var triangle_points = PackedVector2Array()
		triangle_points.append(center + Vector2(-20, -15))
		triangle_points.append(center + Vector2(20, -15))
		triangle_points.append(center + Vector2(0, 20))
		var triangle_colors = PackedColorArray()
		triangle_colors.append(color)
		triangle_colors.append(color)
		triangle_colors.append(color)
		draw_polygon(triangle_points, triangle_colors)
		
		# Bordure rouge
		var border_points = PackedVector2Array()
		border_points.append(center + Vector2(-20, -15))
		border_points.append(center + Vector2(20, -15))
		border_points.append(center + Vector2(0, 20))
		var border_colors = PackedColorArray()
		border_colors.append(Color.RED)
		border_colors.append(Color.RED)
		border_colors.append(Color.RED)
		draw_polygon(border_points, border_colors, null, null, 1)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var local_pos = to_local(get_global_mouse_position())
		if _is_point_in_cell(local_pos):
			emit_signal("cell_clicked", grid_position.x, grid_position.y)


func _is_point_in_cell(point: Vector2) -> bool:
	"""Vérifie si un point est dans la cellule (forme losange)"""
	var center = HALF
	var dx = abs(point.x - center.x)
	var dy = abs(point.y - center.y)
	return (dx + dy) < 50


# Fonction utilitaire pour dessiner un cercle avec bordure
func draw_circle(center: Vector2, radius: float, color: Color, outline_only: bool = false, outline_width: float = 1.0):
	var num_points := 32
	var points := PackedVector2Array()
	var colors := PackedColorArray()
	
	for i in range(num_points + 1):
		var angle := i * TAU / num_points
		points.append(center + Vector2(cos(angle), sin(angle)) * radius)
		colors.append(color)
	
	if outline_only:
		# Dessiner juste la bordure avec des lignes
		for i in range(num_points):
			var start := points[i]
			var end := points[i + 1] if i < num_points else points[0]
			draw_line(start, end, color, outline_width, true)
	else:
		# Dessiner le cercle rempli
		draw_polygon(points, colors)
		
		# Bordure blanche
		for i in range(num_points):
			var start := points[i]
			var end := points[i + 1] if i < num_points else points[0]
			draw_line(start, end, Color.WHITE, 1.0, true)


# Fonction utilitaire pour dessiner une ellipse (remplace la native pour éviter le conflit)
func draw_ellipse(cx: float, rx: float, ry: float, color: Color):
	var num_points := 20
	var points := PackedVector2Array()
	var colors := PackedColorArray()
	
	for i in range(num_points + 1):
		var angle := i * TAU / num_points
		points.append(Vector2(cx, 50) + Vector2(cos(angle) * rx, sin(angle) * ry))
		colors.append(color)
	
	draw_polygon(points, colors)