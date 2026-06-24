extends Node2D
class_name Cell
## Cell.gd - Cellule isométrique style Waven
## Rendu natif avec _draw() au lieu de Sprite2D imbriqués

const CELL_SIZE := Vector2i(100, 100)
const HALF := Vector2(50, 50)

# Couleurs style Waven (tons chauds)
const GRASS_COLOR := Color(0.42, 0.56, 0.14)  # #6B8E23
const GRASS_SIDE_LEFT := Color(0.33, 0.42, 0.18)  # #556B2F
const GRASS_SIDE_RIGHT := Color(0.56, 0.74, 0.56)  # #8FBC8F
const GRASS_HIGHLIGHT := Color(0.68, 1.0, 0.18)  # #ADFF2F
const GRASS_SHADOW := Color(0.18, 0.54, 0.34)  # #2E8B57

const DIRT_COLOR := Color(0.54, 0.27, 0.07)  # #8B4513
const DIRT_SIDE_LEFT := Color(0.40, 0.26, 0.13)  # #654321
const DIRT_SIDE_RIGHT := Color(0.63, 0.32, 0.18)  # #A0522D
const DIRT_HIGHLIGHT := Color(0.80, 0.52, 0.25)  # #CD853F
const DIRT_SHADOW := Color(0.29, 0.17, 0.16)  # #4A2C2A

const STONE_COLOR := Color(0.41, 0.41, 0.41)  # #696969
const STONE_SIDE_LEFT := Color(0.29, 0.29, 0.29)  # #4A4A4A
const STONE_SIDE_RIGHT := Color(0.50, 0.50, 0.50)  # #808080
const STONE_HIGHLIGHT := Color(0.66, 0.66, 0.66)  # #A9A9A9
const STONE_SHADOW := Color(0.18, 0.18, 0.18)  # #2F2F2F

const BORDER_HIGHLIGHT := Color(1.0, 0.83, 0.0)  # #FFD700 (or clair)
const SELECTION_COLOR := Color(1.0, 0.84, 0.0, 0.4)  # Orange transparent
const HIGHLIGHT_COLOR := Color(1.0, 1.0, 1.0, 0.3)  # Blanc transparent

var grid_position: Vector2i = Vector2i(0, 0)
var entity = null
var selected: bool = false
var highlighted: bool = false

signal cell_clicked(x: int, y: int)


func _ready():
	# Plus besoin de charger des textures SVG ou de créer des Sprite2D
	# Tout est dessiné directement dans _draw()
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
		draw_polygon(points, [Color(0, 0, 0, 0), GRASS_COLOR, GRASS_COLOR, GRASS_COLOR])
		
		# Face latérale gauche
		var left_points = PackedVector2Array()
		left_points.append(Vector2(0, 50))
		left_points.append(Vector2(50, 0))
		left_points.append(Vector2(50, 50))
		draw_polygon(left_points, [Color(0, 0, 0, 0), GRASS_SIDE_LEFT, GRASS_SIDE_LEFT, GRASS_SIDE_LEFT])
		
		# Face latérale droite
		var right_points = PackedVector2Array()
		right_points.append(Vector2(50, 50))
		right_points.append(Vector2(100, 50))
		right_points.append(Vector2(50, 100))
		draw_polygon(right_points, [Color(0, 0, 0, 0), GRASS_SIDE_RIGHT, GRASS_SIDE_RIGHT, GRASS_SIDE_RIGHT])
		
		# Highlight supérieur
		var top_hl = PackedVector2Array()
		top_hl.append(Vector2(15, 45))
		top_hl.append(Vector2(50, 5))
		top_hl.append(Vector2(85, 45))
		top_hl.append(Vector2(50, 35))
		draw_polygon(top_hl, [Color(0, 0, 0, 0), GRASS_HIGHLIGHT, GRASS_HIGHLIGHT, GRASS_HIGHLIGHT], [], true, 0.4)
		
		# Ombre inférieure
		var bottom_sh = PackedVector2Array()
		bottom_sh.append(Vector2(15, 55))
		bottom_sh.append(Vector2(50, 95))
		bottom_sh.append(Vector2(85, 55))
		bottom_sh.append(Vector2(50, 65))
		draw_polygon(bottom_sh, [Color(0, 0, 0, 0), GRASS_SHADOW, GRASS_SHADOW, GRASS_SHADOW], [], true, 0.3)
		
		# Bordure lumineuse style Waven
		draw_polygon(points, [], [BORDER_HIGHLIGHT], true, 0.6, true)
		
		# Texture herbe (lignes courbes)
		draw_grass_texture()
	else:
		# Terre - style Waven
		draw_polygon(points, [Color(0, 0, 0, 0), DIRT_COLOR, DIRT_COLOR, DIRT_COLOR])
		
		# Face latérale gauche
		var left_points = PackedVector2Array()
		left_points.append(Vector2(0, 50))
		left_points.append(Vector2(50, 0))
		left_points.append(Vector2(50, 50))
		draw_polygon(left_points, [Color(0, 0, 0, 0), DIRT_SIDE_LEFT, DIRT_SIDE_LEFT, DIRT_SIDE_LEFT])
		
		# Face latérale droite
		var right_points = PackedVector2Array()
		right_points.append(Vector2(50, 50))
		right_points.append(Vector2(100, 50))
		right_points.append(Vector2(50, 100))
		draw_polygon(right_points, [Color(0, 0, 0, 0), DIRT_SIDE_RIGHT, DIRT_SIDE_RIGHT, DIRT_SIDE_RIGHT])
		
		# Highlight supérieur
		var top_hl = PackedVector2Array()
		top_hl.append(Vector2(15, 45))
		top_hl.append(Vector2(50, 5))
		top_hl.append(Vector2(85, 45))
		top_hl.append(Vector2(50, 35))
		draw_polygon(top_hl, [Color(0, 0, 0, 0), DIRT_HIGHLIGHT, DIRT_HIGHLIGHT, DIRT_HIGHLIGHT], [], true, 0.5)
		
		# Ombre inférieure
		var bottom_sh = PackedVector2Array()
		bottom_sh.append(Vector2(15, 55))
		bottom_sh.append(Vector2(50, 95))
		bottom_sh.append(Vector2(85, 55))
		bottom_sh.append(Vector2(50, 65))
		draw_polygon(bottom_sh, [Color(0, 0, 0, 0), DIRT_SHADOW, DIRT_SHADOW, DIRT_SHADOW], [], true, 0.4)
		
		# Bordure lumineuse style Waven
		draw_polygon(points, [], [BORDER_HIGHLIGHT], true, 0.6, true)
		
		# Texture terre (ellipses)
		draw_dirt_texture()
	
	# Dessiner la sélection si active
	if selected:
		var sel_points = PackedVector2Array()
		sel_points.append(Vector2(5, 50))
		sel_points.append(Vector2(50, 5))
		sel_points.append(Vector2(95, 50))
		sel_points.append(Vector2(50, 95))
		draw_polygon(sel_points, [Color(0, 0, 0, 0), SELECTION_COLOR, SELECTION_COLOR, SELECTION_COLOR], [], true, 0.5, true)
	
	# Dessiner le highlight si active
	if highlighted:
		var hl_points = PackedVector2Array()
		hl_points.append(Vector2(3, 50))
		hl_points.append(Vector2(50, 3))
		hl_points.append(Vector2(97, 50))
		hl_points.append(Vector2(50, 97))
		draw_polygon(hl_points, [Color(0, 0, 0, 0), HIGHLIGHT_COLOR, HIGHLIGHT_COLOR, HIGHLIGHT_COLOR], [], true, 0.5, true)
	
	# Dessiner l'entité si présente
	if entity:
		draw_entity()


func draw_grass_texture():
	"""Dessine la texture d'herbe"""
	var grass_color := Color(0.24, 0.70, 0.44)
	
	# Brins d'herbe
	draw_line(Vector2(20, 30), Vector2(30, 20), grass_color, 1.5, true)
	draw_line(Vector2(60, 35), Vector2(70, 25), grass_color, 1.5, true)
	draw_line(Vector2(30, 60), Vector2(40, 50), grass_color, 1.5, true)
	draw_line(Vector2(70, 65), Vector2(80, 55), grass_color, 1.5, true)


func draw_dirt_texture():
	"""Dessine la texture de terre"""
	var dirt_color := Color(0.63, 0.32, 0.18)
	
	# Ellipses pour la texture
	draw_ellipse(Vector2(25, 35), Vector2(4, 2), dirt_color, 0.7)
	draw_ellipse(Vector2(45, 40), Vector2(3, 1.5), dirt_color, 0.7)
	draw_ellipse(Vector2(75, 30), Vector2(5, 2.5), dirt_color, 0.7)
	draw_ellipse(Vector2(35, 65), Vector2(3.5, 2), dirt_color, 0.7)
	draw_ellipse(Vector2(65, 70), Vector2(4, 2), dirt_color, 0.7)


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
		draw_polygon(triangle_points, [color, color, color])
		
		# Bordure
		draw_polygon(triangle_points, [], [Color.RED], true, 1.0, true)


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
	var points := PackedVector2Array()
	var num_points := 32
	for i in range(num_points + 1):
		var angle := i * TAU / num_points
		points.append(center + Vector2(cos(angle), sin(angle)) * radius)
	
	if outline_only:
		# Dessiner juste la bordure
		for i in range(num_points):
			var start := points[i]
			var end := points[i + 1] if i < num_points else points[0]
			draw_line(start, end, color, outline_width)
	else:
		# Dessiner le cercle rempli
		draw_polygon(points, [color] * (num_points + 1))
		
		# Bordure
		for i in range(num_points):
			var start := points[i]
			var end := points[i + 1] if i < num_points else points[0]
			draw_line(start, end, Color.WHITE, 1.0)


# Fonction utilitaire pour dessiner une ellipse
func draw_ellipse(center: Vector2, radius: Vector2, color: Color, opacity: float = 1.0):
	var points := PackedVector2Array()
	var num_points := 20
	for i in range(num_points + 1):
		var angle := i * TAU / num_points
		points.append(center + Vector2(cos(angle) * radius.x, sin(angle) * radius.y))
	
	var colors := []
	for _i in range(num_points + 1):
		colors.append(Color(color.r, color.g, color.b, opacity))
	
	draw_polygon(points, colors)