class_name Adv3DExplorer
extends Node3D
## Adv3DExplorer.gd — L'explorateur du monde 3D : le joueur lui-même (pas un héros).
##
## Déplacement libre sur le sol de l'île avec glissement le long des obstacles (pas de
## physique : la praticabilité vient du terrain d'Aventure, Adv3DWorld.point_walkable).
## Caméra à la 3e personne : orbite (yaw) au doigt / à la souris, inclinaison fixe douce.

signal cell_changed(cell: Vector2i)

const SPEED := 4.4
const RADIUS := 0.32
const CAM_DISTANCE := 10.5
const CAM_PITCH := -0.82          # radians (≈ -47°) : vue d'exploration, presque « Dofus 3D »
const PITCH_MIN := -1.30          # presque vue du dessus
const PITCH_MAX := -0.28          # presque à hauteur d'yeux
const DIST_MIN := 5.5
const DIST_MAX := 17.0
const CAM_HEIGHT := 1.1

var terrain: Dictionary = {}
var stick_input: Vector2 = Vector2.ZERO     # fourni par le HUD (x droite, y bas)
var frozen: bool = false                    # vrai pendant une fenêtre (combat, dialogue)
var camera: Camera3D = null
var yaw: float = 0.0
var current_cell: Vector2i = Vector2i(-1, -1)

var _model: Node3D = null
var _sprite: Adv3DSpriteActor = null     # joueur « carton » (illustration) ; null = modèle low-poly de secours
var _facing: float = 0.0
var _walk_t: float = 0.0
var _breath: float = 0.0
var _cam_yaw: float = 0.0
var pitch: float = CAM_PITCH
var distance: float = CAM_DISTANCE


func _ready() -> void:
	if GameSettings.adventure_models_3d:
		_model = Adv3DHeroModel.make_hero()      # vrai modèle low-poly (ombre incluse)
		add_child(_model)
		var dust3: CPUParticles3D = Adv3DActors.make_dust()
		dust3.name = "Dust"
		_model.add_child(dust3)
		_facing = yaw + PI
		_model.rotation.y = _facing
	else:
		_sprite = Adv3DSpriteActor.create("hero")
	if _model != null:
		pass
	elif _sprite != null:
		_model = _sprite
		add_child(_model)
		Adv3DActors.add_shadow(_model, 0.55)
		var dust: CPUParticles3D = Adv3DActors.make_dust()
		dust.name = "Dust"
		_model.add_child(dust)
		_facing = yaw + PI
	else:
		_model = Adv3DActors.make_explorer()
		add_child(_model)
	camera = Camera3D.new()
	camera.fov = 52.0
	camera.near = 0.2
	camera.far = 160.0
	camera.current = true
	add_child(camera)
	camera.top_level = true
	_cam_yaw = yaw
	_place_camera(1.0)


## Pose l'explorateur au point (x, z) du monde, sur le sol.
func place_at(p: Vector3) -> void:
	position = Vector3(p.x, Adv3DWorld.height_at(p.x, p.z), p.z)
	current_cell = Adv3DWorld.world_to_cell(position)
	_place_camera(1.0)


func rotate_camera(delta_yaw: float, delta_pitch: float = 0.0) -> void:
	yaw = wrapf(yaw + delta_yaw, -PI, PI)
	pitch = clampf(pitch + delta_pitch, PITCH_MIN, PITCH_MAX)


## Cap actuel du joueur (même repère que atan2(x, z)).
func facing() -> float:
	return _facing


## Angle de la caméra autour du joueur (lissé).
func camera_yaw() -> float:
	return _cam_yaw


func zoom_camera(factor: float) -> void:
	distance = clampf(distance * factor, DIST_MIN, DIST_MAX)


func _physics_process(delta: float) -> void:
	if Input.is_physical_key_pressed(KEY_Q):
		rotate_camera(1.8 * delta)
	if Input.is_physical_key_pressed(KEY_E):
		rotate_camera(-1.8 * delta)
	var input: Vector2 = stick_input + _keyboard_vector()
	if input.length() > 1.0:
		input = input.normalized()
	if frozen or input.length() < 0.12:
		_idle_pose(delta)
		if _sprite != null:
			_sprite.animate(delta, 0.0)
		_place_camera(delta)
		return
	var dir: Vector3 = Basis(Vector3.UP, yaw) * Vector3(input.x, 0.0, input.y)
	var step: Vector3 = dir * SPEED * input.length() * delta
	_try_move(step)
	_face(dir, delta)
	if _sprite != null:
		_sprite.animate(delta, input.length())
	_walk_t += delta * SPEED * 2.2 * input.length()
	_animate_walk()
	var cell: Vector2i = Adv3DWorld.world_to_cell(position)
	if cell != current_cell:
		current_cell = cell
		cell_changed.emit(cell)
	_place_camera(delta)


func _keyboard_vector() -> Vector2:
	var v := Vector2.ZERO
	if Input.is_physical_key_pressed(KEY_W) or Input.is_physical_key_pressed(KEY_UP):
		v.y -= 1.0
	if Input.is_physical_key_pressed(KEY_S) or Input.is_physical_key_pressed(KEY_DOWN):
		v.y += 1.0
	if Input.is_physical_key_pressed(KEY_A) or Input.is_physical_key_pressed(KEY_LEFT):
		v.x -= 1.0
	if Input.is_physical_key_pressed(KEY_D) or Input.is_physical_key_pressed(KEY_RIGHT):
		v.x += 1.0
	return v


## Glissement : on essaie le pas complet, puis chaque axe séparément.
func _try_move(step: Vector3) -> void:
	var target: Vector3 = position + step
	if _free(target):
		position = target
	elif _free(position + Vector3(step.x, 0.0, 0.0)):
		position += Vector3(step.x, 0.0, 0.0)
	elif _free(position + Vector3(0.0, 0.0, step.z)):
		position += Vector3(0.0, 0.0, step.z)
	position.y = Adv3DWorld.height_at(position.x, position.z)


func _free(p: Vector3) -> bool:
	for o: Vector2 in [Vector2(RADIUS, 0.0), Vector2(-RADIUS, 0.0), Vector2(0.0, RADIUS), Vector2(0.0, -RADIUS)]:
		if not Adv3DWorld.point_walkable(terrain, Vector3(p.x + o.x, p.y, p.z + o.y)):
			return false
	return Adv3DWorld.point_walkable(terrain, p)


func _face(dir: Vector3, delta: float) -> void:
	if _model == null or dir.length() < 0.01:
		return
	var want: float = atan2(dir.x, dir.z)
	_facing = lerp_angle(_facing, want, clampf(delta * 12.0, 0.0, 1.0))
	if _sprite == null:
		_model.rotation.y = _facing


func _animate_walk() -> void:
	if _model == null:
		return
	var tail: Node3D = _model.get_node_or_null("Body/ScarfTail")
	if tail != null:
		tail.rotation.x = -0.35 + sin(_walk_t * 1.3) * 0.18
		tail.rotation.y = sin(_walk_t * 0.9) * 0.25
	var swing: float = sin(_walk_t) * 0.5
	var dust: CPUParticles3D = _model.get_node_or_null("Dust")
	if dust != null:
		dust.emitting = true
	var arml: Node3D = _model.get_node_or_null("Body/ArmL")
	var armr: Node3D = _model.get_node_or_null("Body/ArmR")
	if arml != null:
		arml.rotation.x = -swing * 0.9
	if armr != null:
		armr.rotation.x = swing * 0.9
	var legl: Node3D = _model.get_node_or_null("LegL")
	var legr: Node3D = _model.get_node_or_null("LegR")
	if legl != null:
		legl.rotation.x = swing
	if legr != null:
		legr.rotation.x = -swing
	var bod: Node3D = _model.get_node_or_null("Body")
	if bod != null:
		bod.position.y = absf(sin(_walk_t)) * 0.07


func _idle_pose(delta: float) -> void:
	if _model == null:
		return
	var dust: CPUParticles3D = _model.get_node_or_null("Dust")
	if dust != null:
		dust.emitting = false
	_breath += delta
	var tail: Node3D = _model.get_node_or_null("Body/ScarfTail")
	if tail != null:
		tail.rotation.x = lerpf(tail.rotation.x, 0.1 + sin(_breath * 1.7) * 0.05, clampf(delta * 6.0, 0.0, 1.0))
		tail.rotation.y = lerpf(tail.rotation.y, sin(_breath * 1.1) * 0.12, clampf(delta * 6.0, 0.0, 1.0))
	var bod: Node3D = _model.get_node_or_null("Body")
	if bod != null:
		bod.position.y = sin(_breath * 2.0) * 0.012
	for nm: String in ["Body/ArmL", "Body/ArmR"]:
		var arm: Node3D = _model.get_node_or_null(nm)
		if arm != null:
			arm.rotation.x = lerpf(arm.rotation.x, 0.0, clampf(delta * 10.0, 0.0, 1.0))
	for nm: String in ["LegL", "LegR"]:
		var leg: Node3D = _model.get_node_or_null(nm)
		if leg != null:
			leg.rotation.x = lerpf(leg.rotation.x, 0.0, clampf(delta * 10.0, 0.0, 1.0))


func _place_camera(delta: float) -> void:
	if camera == null:
		return
	_cam_yaw = lerp_angle(_cam_yaw, yaw, clampf(delta * 10.0, 0.0, 1.0))
	var focus: Vector3 = position + Vector3(0.0, CAM_HEIGHT, 0.0)
	var offset: Vector3 = Basis(Vector3.UP, _cam_yaw) * Basis(Vector3.RIGHT, pitch) * Vector3(0.0, 0.0, distance)
	camera.global_position = focus + offset
	camera.look_at(focus, Vector3.UP)
	if _sprite != null:
		_sprite.set_facing(_facing, _cam_yaw)
