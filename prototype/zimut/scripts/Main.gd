extends Node2D
## Main.gd - Script principal pour la scène de combat
## FIX : redémarre explicitement la partie à l'arrivée sur cette scène,
##       pour que GameManager prenne en compte l'équipe choisie dans
##       TeamSelection (custom_team), au lieu de garder l'état du tout
##       premier _ready() de l'autoload (déclenché avant toute sélection).

@onready var grid_manager   = $GridManager
@onready var ui_manager     = $UIManager
@onready var turn_manager   = $TurnManager
@onready var entity_manager = $EntityManager
@onready var spell_manager  = $SpellManager

var game_manager


func _ready() -> void:
	game_manager = GameManager
	_build_background()

	# IMPORTANT : initialiser tous les managers AVANT reset_game().
	# reset_game() déclenche en interne _refresh_grid(), qui appelle
	# GridManager.update_entity_display() — si GridManager.init() n'a pas
	# encore tourné, sa variable game_manager est encore null et l'appel
	# plante avec "Invalid access to property on a base object of type Nil".
	grid_manager.init(game_manager)
	_setup_camera()
	ui_manager.init(game_manager)
	turn_manager.init(game_manager)
	entity_manager.init(game_manager)
	spell_manager.init(game_manager)

	# Reconstruit la grille et les entités à partir de l'état courant de
	# GameManager (qui contient déjà custom_team si on vient de TeamSelection).
	# reset_game() relance proprement init_grid()/init_entities() et remet
	# game_over/victory à false — indispensable si le joueur a déjà fait
	# une partie avant de revenir choisir une nouvelle équipe.
	if game_manager.has_method("reset_game"):
		game_manager.reset_game()

	_connect_signals()


func _connect_signals() -> void:
	## Connexion simple sans disconnect() préalable

	# GridManager → GameManager
	if not grid_manager.cell_clicked.is_connected(game_manager.handle_cell_selected):
		grid_manager.cell_clicked.connect(game_manager.handle_cell_selected)

	# UIManager → GameManager
	if not ui_manager.end_turn_requested.is_connected(game_manager.next_player):
		ui_manager.end_turn_requested.connect(game_manager.next_player)

	if not ui_manager.restart_requested.is_connected(game_manager.reset_game):
		ui_manager.restart_requested.connect(game_manager.reset_game)

	if not ui_manager.spell_selected.is_connected(game_manager.handle_spell_selected):
		ui_manager.spell_selected.connect(game_manager.handle_spell_selected)

	# SpellManager → UIManager
	if not spell_manager.spell_selected.is_connected(ui_manager._on_spell_button_selected):
		spell_manager.spell_selected.connect(ui_manager._on_spell_button_selected)


func _setup_camera() -> void:
	## Caméra centrée sur l'île, zoom adapté au format 16:9 (le HUD occupe haut et bas).
	var cam: Camera2D = get_node_or_null("Camera2D")
	if cam == null:
		return
	cam.enabled = true
	cam.zoom = Vector2(1.38, 1.38)
	cam.position = grid_manager.grid_center() + Vector2(0, -8)
	cam.position_smoothing_enabled = false
	cam.make_current()


func _build_background() -> void:
	## Fond dégradé doux façon Waven (ciel pâle), derrière tout le reste.
	var layer := CanvasLayer.new()
	layer.layer = -10
	add_child(layer)
	var grad := Gradient.new()
	grad.colors = PackedColorArray([Color(0.46, 0.62, 0.74), Color(0.72, 0.83, 0.88), Color(0.80, 0.88, 0.86)])
	grad.offsets = PackedFloat32Array([0.0, 0.62, 1.0])
	var tex := GradientTexture2D.new()
	tex.gradient = grad
	tex.fill_from = Vector2(0.5, 0.0)
	tex.fill_to = Vector2(0.5, 1.0)
	tex.width = 8
	tex.height = 256
	var rect := TextureRect.new()
	rect.texture = tex
	rect.stretch_mode = TextureRect.STRETCH_SCALE
	rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	layer.add_child(rect)
	# Décor lointain : bandeau montagnes + mer, dessiné derrière la grille
	var far := Node2D.new()
	far.z_index = -5
	add_child(far)
	far.draw.connect(_draw_horizon.bind(far))

	# Voile sombre sur les bords (vignette)
	var vg := Gradient.new()
	vg.colors = PackedColorArray([Color(0, 0, 0, 0.0), Color(0, 0, 0, 0.0), Color(0.05, 0.08, 0.12, 0.45)])
	vg.offsets = PackedFloat32Array([0.0, 0.55, 1.0])
	var vtex := GradientTexture2D.new()
	vtex.gradient = vg
	vtex.fill = GradientTexture2D.FILL_RADIAL
	vtex.fill_from = Vector2(0.5, 0.5)
	vtex.fill_to = Vector2(1.0, 0.5)
	vtex.width = 256
	vtex.height = 256
	var vrect := TextureRect.new()
	vrect.texture = vtex
	vrect.stretch_mode = TextureRect.STRETCH_SCALE
	vrect.set_anchors_preset(Control.PRESET_FULL_RECT)
	vrect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	layer.add_child(vrect)


## Horizon lointain façon Waven : montagnes bleutées + mer pâle sous l'île.
func _draw_horizon(far: Node2D) -> void:
	var c: Vector2 = grid_manager.grid_center()
	var w: float = 2600.0
	var sea_y: float = c.y + 120.0
	# Mer : bandeau dégradé sous la grille
	far.draw_rect(Rect2(c.x - w, sea_y, w * 2.0, 900.0), Color(0.55, 0.72, 0.82, 0.55))
	far.draw_rect(Rect2(c.x - w, sea_y, w * 2.0, 14.0), Color(0.75, 0.88, 0.95, 0.6))
	# Montagnes : silhouettes enneigées, deux plans
	for plan: int in range(2):
		var col: Color = Color(0.62, 0.72, 0.82, 0.85 - 0.2 * plan)
		var base_y: float = sea_y - (18.0 if plan == 0 else 0.0)
		var step: float = 260.0 if plan == 0 else 180.0
		var x: float = c.x - w
		var height_rng := RandomNumberGenerator.new()
		height_rng.seed = 91 + plan
		while x < c.x + w:
			var peak: float = height_rng.randf_range(70.0, 150.0) if plan == 0 else height_rng.randf_range(50.0, 110.0)
			var half: float = step * height_rng.randf_range(0.45, 0.62)
			far.draw_colored_polygon(PackedVector2Array([
				Vector2(x, base_y), Vector2(x + half, base_y - peak), Vector2(x + step, base_y)
			]), col)
			# Neige sur les sommets du premier plan
			if plan == 0:
				far.draw_colored_polygon(PackedVector2Array([
					Vector2(x + half * 0.62, base_y - peak * 0.68),
					Vector2(x + half, base_y - peak),
					Vector2(x + half * 1.4, base_y - peak * 0.68),
					Vector2(x + half * 1.12, base_y - peak * 0.55),
					Vector2(x + half * 0.86, base_y - peak * 0.55),
				]), Color(0.97, 0.98, 1.0, 0.9))
			x += step
	far.queue_redraw()
