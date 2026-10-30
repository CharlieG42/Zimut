extends Node2D
## Main.gd - Script principal pour la scène de combat
## FIX : redémarre explicitement la partie à l'arrivée sur cette scène,
##       pour que GameManager prenne en compte l'équipe choisie dans
##       TeamSelection (custom_team), au lieu de garder l'état du tout
##       premier _ready() de l'autoload (déclenché avant toute sélection).

@onready var grid_manager   = $GridManager
@onready var ui_manager     = $UIManager
@onready var turn_manager   = $TurnManager

var game_manager


func _exit_tree() -> void:
	# Quitter un combat en plein tour ennemi ne doit pas laisser le jeu accéléré
	Engine.time_scale = 1.0


func _ready() -> void:
	game_manager = GameManager
	_build_background()

	# IMPORTANT : initialiser tous les managers AVANT reset_game().
	# reset_game() déclenche en interne _refresh_grid(), qui appelle
	# GridManager.update_entity_display() — si GridManager.init() n'a pas
	# encore tourné, sa variable game_manager est encore null et l'appel
	# plante avec "Invalid access to property on a base object of type Nil".
	grid_manager.init(game_manager)
	Music.play_combat(String(game_manager.fight_biome))
	_setup_camera()
	_build_vignette()
	ui_manager.init(game_manager)
	turn_manager.init(game_manager)

	# Reconstruit la grille et les entités à partir de l'état courant de
	# GameManager (qui contient déjà custom_team si on vient de TeamSelection).
	# reset_game() relance proprement init_grid()/init_entities() et remet
	# game_over/victory à false — indispensable si le joueur a déjà fait
	# une partie avant de revenir choisir une nouvelle équipe.
	if game_manager.has_method("reset_game"):
		game_manager.reset_game()
	grid_manager.show_start_zones()

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

	# EntityManager supprimé : les signaux entity_moved/attacked/casted
	# déclenchent directement GridManager.update_entity_display()
	var refresh_display: Callable = func(_a = null, _b = null, _c = null, _d = null) -> void:
		grid_manager.update_entity_display()
	if not game_manager.entity_moved.is_connected(refresh_display):
		game_manager.entity_moved.connect(refresh_display)
	if not game_manager.entity_attacked.is_connected(refresh_display):
		game_manager.entity_attacked.connect(refresh_display)
	if not game_manager.spell_casted.is_connected(refresh_display):
		game_manager.spell_casted.connect(refresh_display)


func _setup_camera() -> void:
	## Caméra centrée sur l'île, zoom adapté au format 16:9 (le HUD occupe haut et bas).
	var cam: Camera2D = get_node_or_null("Camera2D")
	if cam == null:
		return
	cam.enabled = true
	# V62 : cadrage serré ; V73 : le zoom suit la taille du plateau (10 × 10 → cases et personnages
	# un peu plus petits à l'écran, le plateau entier reste visible au même endroit).
	var z: float = 1.30 * 8.0 / float(game_manager.GRID_SIZE)
	cam.zoom = Vector2(z, z)
	cam.position = grid_manager.grid_center() + Vector2(0, -30)
	cam.position_smoothing_enabled = false
	cam.make_current()
	var bd: Node2D = get_node_or_null("Backdrop")
	if bd != null:
		bd.position = grid_manager.grid_center()


func _build_vignette() -> void:
	## V62 : léger assombrissement des bords de l'écran → le regard reste sur le plateau.
	var layer := CanvasLayer.new()
	layer.layer = 0
	add_child(layer)
	var g := Gradient.new()
	g.colors = PackedColorArray([Color(0, 0, 0, 0.0), Color(0, 0, 0, 0.0), Color(0.02, 0.04, 0.08, 0.38)])
	g.offsets = PackedFloat32Array([0.0, 0.62, 1.0])
	var tex := GradientTexture2D.new()
	tex.gradient = g
	tex.fill = GradientTexture2D.FILL_RADIAL
	tex.fill_from = Vector2(0.5, 0.5)
	tex.fill_to = Vector2(1.0, 0.5)
	tex.width = 256
	tex.height = 256
	var r := TextureRect.new()
	r.texture = tex
	r.stretch_mode = TextureRect.STRETCH_SCALE
	r.set_anchors_preset(Control.PRESET_FULL_RECT)
	r.mouse_filter = Control.MOUSE_FILTER_IGNORE
	layer.add_child(r)


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
	# Fond du monde : lumière, nuages, îles flottantes lointaines, eau (BackdropFx)
	var backdrop := BackdropFx.new()
	backdrop.z_index = -5
	backdrop.name = "Backdrop"
	add_child(backdrop)

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
