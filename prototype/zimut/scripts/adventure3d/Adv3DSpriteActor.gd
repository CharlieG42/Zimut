class_name Adv3DSpriteActor
extends Node3D
## Adv3DSpriteActor.gd — Personnage « carton » du monde 3D : une illustration qui reste debout et
## face à la caméra, dont la vue (face, trois-quarts, profil, dos) change selon l'angle sous lequel
## on le regarde (8 directions : 5 vues dessinées + miroirs). Sert au joueur et à Gligli.
##
## Animation sans images supplémentaires : rebond, étirement et balancement à la marche, respiration à l'arrêt.

const DIR_HERO := "res://assets/adventure3d/hero/"
const DIR_GLIGLI := "res://assets/adventure3d/gligli/"

var _sprite: Sprite3D = null
var _views: Dictionary = {}          # nom -> Texture2D
var _kind: String = "hero"
var _height: float = 1.9
var _facing: float = 0.0             # cap du personnage (même repère que atan2(x, z))
var _cam_yaw: float = 0.0
var _t: float = 0.0
var _walk: float = 0.0               # 0..1, vitesse de marche lissée
var _sitting: bool = false
var _running: bool = false
var _current_key: String = ""
var _base_scale: Vector3 = Vector3.ONE


## kind : "hero" (joueur) ou "gligli" (compagnon). Renvoie null si les images manquent.
static func create(kind: String) -> Adv3DSpriteActor:
	var a := Adv3DSpriteActor.new()
	a._kind = kind
	var names: Array = ["face", "quart_face", "cote", "quart_dos", "dos"] if kind == "hero" else ["face", "quart_face", "cote", "dos", "assis", "action"]
	var dir: String = DIR_HERO if kind == "hero" else DIR_GLIGLI
	for n: String in names:
		if not ResourceLoader.exists(dir + n + ".png"):
			return null
		a._views[n] = load(dir + n + ".png")
	a._height = 2.3 if kind == "hero" else 1.1
	a._build()
	return a


func _build() -> void:
	_sprite = Sprite3D.new()
	_sprite.name = "Sprite"
	_sprite.billboard = BaseMaterial3D.BILLBOARD_FIXED_Y
	_sprite.shaded = false
	_sprite.double_sided = true
	_sprite.alpha_cut = SpriteBase3D.ALPHA_CUT_OPAQUE_PREPASS
	_sprite.texture_filter = BaseMaterial3D.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS
	_sprite.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	add_child(_sprite)
	_show("face", false)
	_cam_yaw = 0.0
	set_facing(_facing + PI, 0.0)


func set_facing(facing: float, cam_yaw: float) -> void:
	_facing = facing
	_cam_yaw = cam_yaw
	_refresh_view()


func facing() -> float:
	return _facing


func set_sitting(v: bool) -> void:
	_sitting = v
	_refresh_view()


## Écart entre le cap et la direction de la caméra : 0 = regarde la caméra, ±π = de dos, > 0 = vers la droite de l'écran.
func _rel() -> float:
	return wrapf(_facing - _cam_yaw, -PI, PI)


func _refresh_view() -> void:
	if _sprite == null:
		return
	var rel: float = _rel()
	var flip: bool = rel < 0.0
	var step: int = roundi(absf(rel) / (PI * 0.25))     # 0 face · 1 quart · 2 profil · 3 quart arrière · 4 dos
	var key: String
	if _kind == "hero":
		key = ["face", "quart_face", "cote", "quart_dos", "dos"][clampi(step, 0, 4)]
	else:
		if _sitting:
			key = "assis"
		elif _running:
			key = "action"
		else:
			key = ["face", "quart_face", "cote", "dos", "dos"][clampi(step, 0, 4)]
	_show(key, flip)


func _show(key: String, flip: bool) -> void:
	var tex: Texture2D = _views.get(key)
	if tex == null:
		return
	if key != _current_key:
		_current_key = key
		_sprite.texture = tex
		var h_px: float = float(tex.get_height())
		_sprite.pixel_size = _height / h_px
		_sprite.offset = Vector2(0.0, h_px * 0.5)         # les pieds au sol (origine = bas de l'image)
		_sprite.centered = true
	_sprite.flip_h = flip


## Animation : `speed` = 0..1 (fraction de la vitesse de marche), appelée à chaque image.
func animate(delta: float, speed: float) -> void:
	_t += delta
	_walk = lerpf(_walk, speed, clampf(delta * 10.0, 0.0, 1.0))
	if _sprite == null:
		return
	if _walk > 0.05:
		var ph: float = _t * (9.0 if _kind == "hero" else 11.0)
		var bob: float = absf(sin(ph))
		_sprite.position.y = bob * (0.09 if _kind == "hero" else 0.12) * _walk
		var sq: float = 1.0 + (bob - 0.5) * 0.06 * _walk
		_sprite.scale = Vector3(1.0 / sq, sq, 1.0)
		_sprite.position.x = 0.0
	else:
		var br: float = sin(_t * 2.0) * 0.012
		_sprite.position.y = lerpf(_sprite.position.y, 0.0, clampf(delta * 10.0, 0.0, 1.0))
		_sprite.scale = Vector3(1.0 - br * 0.5, 1.0 + br, 1.0)


## Pose « en action » de Gligli quand il court derrière le joueur.
func set_running(v: bool) -> void:
	_running = v
	_refresh_view()
