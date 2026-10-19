class_name EntityView
extends Node2D
## EntityView.gd — Représentation visuelle d'une entité (sprite, ombre, barre de vie,
## statuts, animations). La logique de jeu reste dans GameManager.

const FLASH_SHADER := """
shader_type canvas_item;
uniform float flash : hint_range(0.0, 1.0) = 0.0;
uniform vec4 outline_color : source_color = vec4(1.0, 0.9, 0.3, 1.0);
uniform float outline : hint_range(0.0, 6.0) = 0.0;
void fragment() {
	vec4 c = texture(TEXTURE, UV);
	vec2 px = TEXTURE_PIXEL_SIZE * outline;
	float a = 0.0;
	if (outline > 0.0) {
		a = texture(TEXTURE, UV + vec2(px.x, 0.0)).a;
		a = max(a, texture(TEXTURE, UV - vec2(px.x, 0.0)).a);
		a = max(a, texture(TEXTURE, UV + vec2(0.0, px.y)).a);
		a = max(a, texture(TEXTURE, UV - vec2(0.0, px.y)).a);
	}
	vec4 base = vec4(mix(c.rgb, vec3(1.0), flash), c.a);
	COLOR = c.a > 0.1 ? base : vec4(outline_color.rgb, a * outline_color.a);
}
"""

static var _shader: Shader = null

var entity: Dictionary = {}
var sprite: Sprite2D = null
var height: float = 96.0
var shown_pv: float = 0.0
var ghost_pv: float = 0.0
var preview_text: String = ""
var hovered: bool = false
var dying: bool = false

var _t: float = 0.0
var _flash: float = 0.0
var _shake: float = 0.0
var _hop: float = 0.0
var _moving: bool = false
var _float_count: int = 0
var _float_decay: float = 0.0
var _has_tex: bool = false
var _mat: ShaderMaterial = null
var _phase: float = 0.0
# V30 : profondeur (ombre portée, contre-jour, lumière du biome, touffes devant les pieds)
var _shadow: Sprite2D = null
var _rim: Sprite2D = null
var _front: FrontTufts = null
var _base_sc: float = 1.0
var _light: Dictionary = {}
var _tilt: float = 0.0          # inclinaison (coup reçu), revient à 0
var _kb: Vector2 = Vector2.ZERO # recul (coup reçu), revient à 0
var _stretch: float = 0.0       # étirement d'élan (attaque)
var _lean: float = 0.0          # penché pendant la marche
var _move_dx: float = 0.0
var _falling: bool = false


## Lumière par biome : teinte du personnage, couleur du contre-jour, direction de la
## lumière (écran) et opacité de l'ombre portée.
const LIGHT := {
	"Forêt":    {"tint": Color(1.02, 1.03, 0.96), "rim": Color(1.25, 1.20, 0.80, 0.85), "dir": Vector2(-1.0, -0.6), "shadow": 0.34},
	"Montagne": {"tint": Color(0.96, 1.00, 1.08), "rim": Color(1.05, 1.20, 1.45, 0.85), "dir": Vector2(-1.0, -0.7), "shadow": 0.30},
	"Désert":   {"tint": Color(1.08, 1.02, 0.90), "rim": Color(1.45, 1.20, 0.70, 0.90), "dir": Vector2(-0.6, -1.0), "shadow": 0.42},
	"Donjon":   {"tint": Color(0.88, 0.86, 0.98), "rim": Color(0.90, 0.75, 1.30, 0.75), "dir": Vector2(1.0, -0.6), "shadow": 0.40},
	"Cristaux": {"tint": Color(0.94, 0.92, 1.08), "rim": Color(0.95, 0.85, 1.55, 0.90), "dir": Vector2(1.0, -0.5), "shadow": 0.36},
	"Marées":   {"tint": Color(0.98, 1.03, 1.05), "rim": Color(0.85, 1.35, 1.45, 0.85), "dir": Vector2(-1.0, -0.8), "shadow": 0.30},
	"Vents":    {"tint": Color(1.02, 1.04, 1.06), "rim": Color(1.25, 1.30, 1.35, 0.80), "dir": Vector2(-0.8, -1.0), "shadow": 0.26},
	"Brasier":  {"tint": Color(1.08, 0.94, 0.86), "rim": Color(1.70, 0.95, 0.45, 0.95), "dir": Vector2(1.0, 0.2), "shadow": 0.44},
	"Brumes":   {"tint": Color(0.94, 1.00, 0.97), "rim": Color(0.90, 1.30, 1.10, 0.75), "dir": Vector2(-1.0, -0.6), "shadow": 0.26},
	"Ombres":   {"tint": Color(0.90, 0.86, 1.00), "rim": Color(1.15, 0.80, 1.55, 0.90), "dir": Vector2(1.0, -0.4), "shadow": 0.40},
	"Rouages":  {"tint": Color(1.04, 0.98, 0.92), "rim": Color(1.55, 1.10, 0.60, 0.90), "dir": Vector2(1.0, -0.5), "shadow": 0.40},
}


static func light_of(biome: String) -> Dictionary:
	return LIGHT.get(biome, LIGHT["Forêt"])


## Touffes d'herbe / cailloux devant les pieds : le personnage « entre » dans la case.
class FrontTufts extends Node2D:
	var col: Color = Color(0.32, 0.60, 0.22)
	var pebbles: bool = false
	var seed_v: int = 0
	var t: float = 0.0
	func _draw() -> void:
		var rng := RandomNumberGenerator.new()
		rng.seed = seed_v
		var n: int = 5
		for i: int in range(n):
			var x: float = -26.0 + float(i) * 13.0 + rng.randf_range(-3.0, 3.0)
			var y: float = 8.0 + rng.randf_range(-1.5, 2.5)
			if pebbles:
				var r: float = rng.randf_range(2.2, 3.6)
				draw_circle(Vector2(x, y), r, col.darkened(0.35))
				draw_circle(Vector2(x - r * 0.3, y - r * 0.35), r * 0.45, col.lightened(0.25))
			else:
				var hgt: float = rng.randf_range(7.0, 12.0)
				var sway: float = sin(t * 1.8 + float(i) * 1.3 + float(seed_v % 5)) * 1.8
				for k: int in range(3):
					var bx: float = x + float(k - 1) * 2.4
					var tip := Vector2(bx + float(k - 1) * 2.2 + sway, y - hgt + float(absi(k - 1)) * 2.5)
					draw_colored_polygon(PackedVector2Array([Vector2(bx - 1.6, y), tip, Vector2(bx + 1.6, y)]),
						col.lightened(0.10 * float(k)) if k != 1 else col.darkened(0.05))


## Couleur de la pastille de numéro d'ordre : héros bleu, ennemi or, invocation verte.
static func ord_color(e: Dictionary) -> Color:
	if String(e.get("entity_type", "")) == "Summon":
		return Color(0.40, 0.85, 0.55)
	if String(e.get("team", "")) == "enemy":
		return Color(0.95, 0.75, 0.20)
	return Color(0.45, 0.70, 1.0)


func setup(e: Dictionary) -> void:
	entity = e
	_phase = float(int(e["uid"]) % 7)
	shown_pv = float(e["current_pv"])
	ghost_pv = shown_pv
	_light = light_of(_current_biome())
	_shadow = Sprite2D.new()
	_shadow.centered = true
	add_child(_shadow)
	_rim = Sprite2D.new()
	add_child(_rim)
	sprite = Sprite2D.new()
	add_child(sprite)
	_load_texture()
	_setup_depth()
	set_process(true)


## Entités posées (terrain, mécanismes, balises) : pas de respiration ni de touffes.
func _is_static() -> bool:
	return bool(entity.get("static", false)) or bool(entity.get("terrain", false)) or bool(entity.get("beacon", false))


func _setup_depth() -> void:
	if not _has_tex:
		_shadow.visible = false
		_rim.visible = false
		return
	var tex: Texture2D = sprite.texture
	# Ombre portée : la silhouette, aplatie et projetée à l'opposé de la lumière
	_shadow.texture = tex
	_shadow.offset = Vector2(0, -float(tex.get_height()) * 0.5)
	_shadow.self_modulate = Color(0.02, 0.02, 0.05, float(_light["shadow"]))
	var ld: Vector2 = (_light["dir"] as Vector2).normalized()
	_shadow.skew = clampf(ld.x * 0.75, -0.9, 0.9)
	# Contre-jour : copie claire derrière le sprite, décalée vers la lumière
	_rim.texture = tex
	_rim.self_modulate = _light["rim"]
	sprite.self_modulate = _light["tint"]
	if not _is_static() and not bool(entity.get("fly", false)):
		_front = FrontTufts.new()
		_front.seed_v = int(entity.get("uid", 0)) * 31 + 7
		var b: String = _current_biome()
		# (couleurs des biomes historiques recopiées de Cell.gd : ne pas dépendre de Cell ici)
		var legacy := {"Forêt": Color(0.32, 0.60, 0.22), "Montagne": Color(0.38, 0.48, 0.30), "Désert": Color(0.60, 0.55, 0.25), "Donjon": Color(0.30, 0.30, 0.38)}
		_front.col = Nations.cell_palette(b).get("tuft", Color(0.32, 0.6, 0.22)) if Nations.is_new(b) else legacy.get(b, legacy["Forêt"])
		_front.pebbles = b in ["Rouages", "Donjon", "Brasier", "Cristaux", "Ombres", "Désert"]
		add_child(_front)


## Profondeur du plateau : 0 au fond (haut de l'écran), 1 au premier plan.
func _depth_factor() -> float:
	var tree: SceneTree = get_tree()
	var gm: Node = tree.root.get_node_or_null("GameManager") if tree != null else null
	var n: int = int(gm.get("GRID_SIZE")) if gm != null else 10
	return clampf(position.y / maxf(1.0, float(2 * (n - 1)) * 32.0), 0.0, 1.0)


## Nom de fichier d'un sprite : minuscules, sans accents, « - » et espaces -> « _ »
## (« Sirène » -> sirene, « Homme-Faucon » -> homme_faucon).
static func sprite_key(raw: String) -> String:
	var k: String = raw.to_lower()
	for pair in [["é", "e"], ["è", "e"], ["ê", "e"], ["ë", "e"], ["à", "a"], ["â", "a"], ["î", "i"],
			["ï", "i"], ["ô", "o"], ["û", "u"], ["ù", "u"], ["ç", "c"]]:
		k = k.replace(pair[0], pair[1])
	return k.replace("-", "_").replace(" ", "_")


## Skin des boss nommés (nom du boss -> fichier de sprite).
const BOSS_SKINS := {
	"Gobelin Roi": "gobelin_boss", "Troll Géant": "troll_boss", "Dragon": "dragonnet_boss",
	"Squelette Seigneur": "squelette_boss", "Loup Alpha": "loup_boss",
}

## Clé de biome pour les variantes de skin ("" = forêt / sans variante).
static func _biome_key() -> String:
	var tree: SceneTree = Engine.get_main_loop() as SceneTree
	if tree == null:
		return ""
	var gm: Node = tree.root.get_node_or_null("GameManager")
	if gm == null:
		return ""
	match String(gm.get("fight_biome")):
		"Montagne":
			return "montagne"
		"Désert":
			return "desert"
	return ""


## Biome du combat en cours ("" hors combat).
static func _current_biome() -> String:
	var tree: SceneTree = Engine.get_main_loop() as SceneTree
	if tree == null:
		return ""
	var gm: Node = tree.root.get_node_or_null("GameManager")
	return String(gm.get("fight_biome")) if gm != null else ""


## Noms de fichiers de sprite à essayer, par ordre de priorité.
static func skin_names(ent: Dictionary) -> Array[String]:
	var classe: String = String(ent.get("classe", ""))
	var out: Array[String] = []
	if bool(ent.get("boss", false)):
		if BOSS_SKINS.has(classe):
			out.append(String(BOSS_SKINS[classe]))
		out.append(sprite_key(classe) + "_boss")
	# Variante de biome (loup blanc en montagne, gobelin sable dans le désert...) pour les ennemis
	if String(ent.get("team", "")) == "enemy":
		var bk: String = _biome_key()
		if bk != "":
			out.append(sprite_key(classe) + "_" + bk)
	out.append(sprite_key(classe))
	var sk: String = String(ent.get("skin", ""))
	if sk != "":
		out.append(sprite_key(sk))
	return out


func _find_texture() -> Texture2D:
	# Ennemis : sprite de la nation du biome en cours (Forêt = Sylvestre, Désert = Sables, ...)
	if String(entity.get("team", "")) == "enemy":
		var ntex: Texture2D = Nations.enemy_texture(entity, _current_biome())
		if ntex != null:
			return ntex
	var folders: Array[String] = ["enemies", "players"]
	if entity["team"] == "player":
		folders = ["players", "enemies"]
	if entity["entity_type"] == "Summon":
		folders = ["summons", "enemies", "players"]
	for nm: String in skin_names(entity):
		for folder: String in folders:
			for ext: String in ["png", "svg"]:
				var path: String = "res://assets/sprites/%s/%s.%s" % [folder, nm, ext]
				if ResourceLoader.exists(path):
					var res: Resource = load(path)
					if res is Texture2D:
						return res
	return null


## Hauteur d'affichage selon le type : héros > ennemis, invocations plus petites,
## Troll/Dragonnet imposants, boss géant.
func _target_height() -> float:
	if bool(entity.get("boss", false)):
		return 150.0
	match String(entity.get("classe", "")):
		"Troll":
			return 118.0
		"Dragonnet":
			return 100.0
		"Arbre":
			return 150.0
	if entity["entity_type"] == "Summon":
		return 76.0
	return 104.0 if entity["entity_type"] == "Player" else 92.0


func _load_texture() -> void:
	var tex: Texture2D = _find_texture()
	if tex == null:
		_has_tex = false
		height = 78.0
		sprite.visible = false
		return
	_has_tex = true
	sprite.texture = tex
	var target_h: float = _target_height()
	var max_w: float = (140.0 if String(entity.get("entity_type", "")) == "Player" else 112.0) * target_h / 92.0
	var sc: float = minf(target_h / float(tex.get_height()), max_w / float(tex.get_width()))
	sprite.scale = Vector2(sc, sc)
	_base_sc = sc
	height = float(tex.get_height()) * sc
	sprite.position = Vector2(0, -height * 0.5 + 6.0)
	# Le shader de contour/flash peut échouer sur certains pilotes Android
	# et rendre le Sprite2D entièrement invisible. Sur mobile, privilégier la
	# texture native : le personnage reste visible même sans contour animé.
	if not OS.has_feature("mobile"):
		if _shader == null:
			_shader = Shader.new()
			_shader.code = FLASH_SHADER
		_mat = ShaderMaterial.new()
		_mat.shader = _shader
		sprite.material = _mat
	else:
		_mat = null
		sprite.material = null
	sprite.visible = true


func _process(delta: float) -> void:
	_t += delta
	if _flash > 0.0:
		_flash = maxf(0.0, _flash - delta * 5.0)
	if _shake > 0.0:
		_shake = maxf(0.0, _shake - delta * 4.0)
	if _float_decay > 0.0:
		_float_decay -= delta
		if _float_decay <= 0.0:
			_float_count = 0
	ghost_pv = move_toward(ghost_pv, shown_pv, maxf(0.0, delta * float(entity.get("max_pv", 100)) * 0.35))
	if ghost_pv < shown_pv:
		ghost_pv = shown_pv
	if not _falling:
		_tilt = move_toward(_tilt, 0.0, delta * 1.6)
		_kb = _kb.move_toward(Vector2.ZERO, delta * 70.0)
	_stretch = move_toward(_stretch, 0.0, delta * 2.5)
	_lean = lerpf(_lean, clampf(_move_dx, -1.0, 1.0) * 0.10 if _moving else 0.0, minf(1.0, delta * 10.0))
	if _has_tex and sprite != null:
		var still: bool = _is_static()
		var bob: float = 0.0 if still else sin(_t * 2.2 + _phase) * 1.6
		var hop_n: float = absf(sin(_t * 13.0)) if _moving else 0.0
		var hop: float = hop_n * 9.0
		# profondeur : un peu plus petit et voilé au fond du plateau
		var df: float = _depth_factor()
		var dsc: float = lerpf(0.94, 1.04, df)
		var sc: float = _base_sc * dsc
		var breathe: float = 0.0 if still else sin(_t * 2.2 + _phase) * 0.014
		var squash: float = (1.0 - hop_n) * 0.07 if _moving else 0.0
		var sx: float = sc * (1.0 + _stretch * 0.10 + squash * 0.6)
		var sy: float = sc * (1.0 + breathe - _stretch * 0.07 - squash)
		var base_pos := Vector2(randf_range(-1.0, 1.0) * _shake * 6.0, -height * 0.5 + 6.0 - bob - hop) + _kb
		sprite.scale = Vector2(sx, sy)
		sprite.position = base_pos
		sprite.rotation = _tilt + (0.0 if still else sin(_t * 1.3 + _phase) * 0.018)
		sprite.skew = _lean
		var haze: Color = Color(0.86, 0.90, 1.0).lerp(Color(1, 1, 1), df)
		var tint: Color = _light.get("tint", Color.WHITE)
		var bright: float = lerpf(0.90, 1.03, df)
		sprite.self_modulate = Color(tint.r * haze.r * bright, tint.g * haze.g * bright, tint.b * haze.b * bright, 1.0)
		# contre-jour : même pose, décalé de 3 px vers la lumière
		var ld: Vector2 = (_light.get("dir", Vector2(-1, -0.6)) as Vector2).normalized()
		_rim.scale = sprite.scale
		_rim.rotation = sprite.rotation
		_rim.skew = sprite.skew
		_rim.flip_h = sprite.flip_h
		_rim.position = sprite.position + ld * 4.0
		_rim.visible = not _falling
		# ombre portée au sol (ne suit pas le saut, se resserre quand il est en l'air)
		var air: float = clampf((bob + hop) / 14.0, 0.0, 1.0)
		_shadow.flip_h = sprite.flip_h
		_shadow.position = Vector2(_kb.x * 0.5, 6.0)
		# contre-jour : la lumière vient de l'arrière, l'ombre s'étire vers l'avant (vers le bas de l'écran)
		_shadow.scale = Vector2(sc * (1.0 - air * 0.15), -sc * 0.46 * (1.0 - air * 0.2))
		_shadow.self_modulate.a = minf(0.60, float(_light.get("shadow", 0.35)) * 1.5) * (1.0 - air * 0.35)
		_shadow.visible = not _falling
		if _front != null:
			_front.t = _t
			_front.queue_redraw()
		if _mat != null:
			_mat.set_shader_parameter("flash", _flash)
			# Contour sombre permanent pour détacher les sprites du feuillage et du sol.
			# Le contour actif reste plus épais et coloré pour garder le repérage tactique.
			var outline_w: float = 1.35
			var oc := Color(0.10, 0.16, 0.12, 0.96)
			if entity.get("is_active", false):
				outline_w = 2.5 + sin(_t * 5.0) * 0.35
				oc = Color(1.0, 0.83, 0.24, 1.0)
			elif hovered:
				outline_w = 2.25
				oc = Color(1, 1, 1, 0.98) if entity["team"] == "player" else Color(1.0, 0.38, 0.28, 1.0)
			_mat.set_shader_parameter("outline", outline_w)
			_mat.set_shader_parameter("outline_color", oc)
	else:
		_hop = absf(sin(_t * 13.0)) * 9.0 if _moving else 0.0
	queue_redraw()


func face_screen_dx(dx: float) -> void:
	if absf(dx) > 0.1:
		_move_dx = signf(dx)
	if _has_tex and absf(dx) > 0.1:
		sprite.flip_h = dx < 0.0


func set_hp(pv: float) -> void:
	shown_pv = pv


func next_float_offset() -> float:
	var off: float = float(_float_count) * 24.0
	_float_count += 1
	_float_decay = 0.9
	return off


# ── Animations ─────────────────────────────────────────────────────────────

func move_along(points: Array[Vector2], step_time: float = 0.16) -> Tween:
	var tw: Tween = create_tween()
	tw.tween_callback(func() -> void: _moving = true)
	var prev: Vector2 = position
	for p: Vector2 in points:
		var dx: float = p.x - prev.x
		tw.tween_callback(face_screen_dx.bind(dx))
		tw.tween_property(self, "position", p, step_time)
		prev = p
	tw.tween_callback(func() -> void: _moving = false)
	return tw


func slide_to(points: Array[Vector2], step_time: float = 0.09) -> Tween:
	var tw: Tween = create_tween()
	for p: Vector2 in points:
		tw.tween_property(self, "position", p, step_time).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	return tw


func lunge(toward: Vector2) -> Tween:
	var dir: Vector2 = (toward - position)
	dir = dir.normalized() if dir.length() > 1.0 else Vector2.ZERO
	face_screen_dx(dir.x)
	var origin: Vector2 = position
	var tw: Tween = create_tween()
	tw.tween_callback(func() -> void: _stretch = 1.0)
	tw.tween_property(self, "position", origin - dir * 8.0, 0.07)
	tw.tween_property(self, "position", origin + dir * 26.0, 0.07).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tw.tween_property(self, "position", origin, 0.14)
	return tw


func cast_pose() -> Tween:
	var tw: Tween = create_tween()
	var origin: Vector2 = position
	tw.tween_property(self, "position", origin + Vector2(0, -12), 0.12).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tw.tween_property(self, "position", origin, 0.16).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	return tw


func hit_react(strength: float = 1.0, from: Vector2 = Vector2.INF) -> void:
	_flash = 1.0
	_shake = 0.35 * strength
	# recul et bascule à l'opposé de l'attaquant
	var dir := Vector2(1.0 if (sprite != null and sprite.flip_h) else -1.0, 0.0)
	if from != Vector2.INF and (position - from).length() > 1.0:
		dir = (position - from).normalized()
	_kb = Vector2(dir.x * 10.0, dir.y * 4.0) * strength
	_tilt = clampf(dir.x, -1.0, 1.0) * 0.16 * strength


func pop_in() -> Tween:
	scale = Vector2(0.1, 0.1)
	modulate.a = 0.0
	var tw: Tween = create_tween().set_parallel(true)
	tw.tween_property(self, "scale", Vector2.ONE, 0.35).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tw.tween_property(self, "modulate:a", 1.0, 0.25)
	return tw


func vanish() -> Tween:
	var tw: Tween = create_tween()
	tw.tween_property(self, "scale", Vector2(0.2, 1.6), 0.14)
	tw.parallel().tween_property(self, "modulate:a", 0.0, 0.14)
	return tw


func appear() -> Tween:
	scale = Vector2(0.2, 1.6)
	var tw: Tween = create_tween()
	tw.tween_property(self, "scale", Vector2.ONE, 0.16).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tw.parallel().tween_property(self, "modulate:a", 1.0, 0.1)
	return tw


func die() -> Tween:
	dying = true
	_flash = 1.0
	var tw: Tween = create_tween()
	if _has_tex and sprite != null and not _is_static():
		# il bascule en arrière, s'affaisse, puis s'efface
		var side: float = -1.0 if sprite.flip_h else 1.0
		tw.tween_property(self, "scale", Vector2(1.08, 0.94), 0.10)
		tw.tween_callback(func() -> void: _falling = true)
		tw.tween_property(self, "_tilt", -side * 1.35, 0.32).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
		tw.parallel().tween_property(self, "_kb", Vector2(-side * 18.0, 16.0), 0.32).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
		tw.parallel().tween_property(self, "scale", Vector2.ONE, 0.2)
		tw.tween_interval(0.12)
		tw.tween_property(self, "modulate:a", 0.0, 0.3)
		return tw
	tw.tween_property(self, "scale", Vector2(1.15, 0.85), 0.12)
	tw.tween_property(self, "scale", Vector2(0.4, 0.05), 0.35).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tw.parallel().tween_property(self, "modulate:a", 0.0, 0.35)
	return tw


# ── Dessin ─────────────────────────────────────────────────────────────────

func _team_color() -> Color:
	if entity.get("entity_type", "") == "Summon":
		return Color(0.35, 0.9, 0.55)
	return Color(0.3, 0.6, 1.0) if entity.get("team", "") == "player" else Color(1.0, 0.3, 0.25)


func _grid_dir_to_screen(f: Vector2i) -> Vector2:
	return Vector2(float(f.x - f.y), float(f.x + f.y) * 0.5).normalized()


func _draw() -> void:
	if entity.is_empty():
		return
	var tc: Color = _team_color()
	# Ombre
	draw_set_transform(Vector2(0, 5), 0.0, Vector2(1.0, 0.42))
	draw_circle(Vector2.ZERO, 30.0, Color(0, 0, 0, 0.26))
	# contact au sol : petite zone très sombre juste sous les pieds
	draw_circle(Vector2.ZERO, 17.0, Color(0, 0, 0, 0.30))
	draw_circle(Vector2.ZERO, 9.0, Color(0, 0, 0, 0.22))
	# Anneau d'équipe au sol
	var active: bool = entity.get("is_active", false)
	var ring_col: Color = Color(1.0, 0.85, 0.2) if active else tc
	var ring_w: float = 4.0 + (sin(_t * 5.0) * 1.2 if active else 0.0)
	draw_arc(Vector2.ZERO, 33.0, 0.0, TAU, 40, Color(ring_col.r, ring_col.g, ring_col.b, 0.9), ring_w, true)
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)

	# Arbre du Sylvain : zone de relais des soins (les 8 cases autour) en losange vert pulsant
	if bool(entity.get("relay", false)):
		var pl: float = 0.5 + 0.5 * sin(_t * 2.2)
		var hw: float = 96.0   # 1,5 case iso en largeur
		var hh: float = 48.0
		var cpt := Vector2(0, 4)
		var diamond := PackedVector2Array([cpt + Vector2(0, -hh), cpt + Vector2(hw, 0), cpt + Vector2(0, hh), cpt + Vector2(-hw, 0), cpt + Vector2(0, -hh)])
		draw_colored_polygon(diamond.slice(0, 4), Color(0.4, 1.0, 0.5, 0.08 + 0.06 * pl))
		draw_polyline(diamond, Color(0.5, 1.0, 0.6, 0.35 + 0.35 * pl), 3.0, true)

	# Boss : aura rouge pulsante au sol
	if bool(entity.get("boss", false)):
		var pulse: float = 0.5 + 0.5 * sin(_t * 3.0)
		draw_set_transform(Vector2(0, 5), 0.0, Vector2(1.0, 0.42))
		draw_arc(Vector2.ZERO, 46.0 + pulse * 6.0, 0.0, TAU, 48, Color(1.0, 0.25, 0.1, 0.35 + 0.3 * pulse), 6.0, true)
		draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)

	# Indicateur d'orientation (utile pour les attaques dans le dos)
	var facing: Vector2i = entity.get("facing", Vector2i.ZERO)
	if facing != Vector2i.ZERO:
		var sd: Vector2 = _grid_dir_to_screen(facing)
		var c: Vector2 = Vector2(sd.x * 38.0, 5.0 + sd.y * 16.0)
		var perp: Vector2 = Vector2(-sd.y, sd.x) * 0.5
		draw_colored_polygon(PackedVector2Array([c + sd * Vector2(9, 5), c + perp * Vector2(8, 5), c - perp * Vector2(8, 5)]),
			Color(ring_col.r, ring_col.g, ring_col.b, 0.95))

	# Corps procédural si pas de sprite
	if not _has_tex and entity.get("classe", "") == "Dragonnet":
		_draw_dragonnet()
	elif not _has_tex and entity.get("classe", "") == "Troll":
		_draw_troll()
	elif not _has_tex:
		var col: Color = entity.get("color", Color(0.7, 0.4, 0.4))
		var by: float = -_hop
		draw_circle(Vector2(0, -34 + by), 26.0, col.darkened(0.25))
		draw_circle(Vector2(0, -36 + by), 24.0, col)
		draw_circle(Vector2(-8, -44 + by), 8.0, col.lightened(0.3))
		draw_circle(Vector2(-8, -38 + by), 4.5, Color.WHITE)
		draw_circle(Vector2(8, -38 + by), 4.5, Color.WHITE)
		draw_circle(Vector2(-7, -38 + by), 2.2, Color.BLACK)
		draw_circle(Vector2(9, -38 + by), 2.2, Color.BLACK)
		var font0: Font = ThemeDB.fallback_font
		draw_string(font0, Vector2(-14, -8 + by), String(entity.get("classe", "?")).substr(0, 3), HORIZONTAL_ALIGNMENT_CENTER, 28, 14, Color(1, 1, 1, 0.9))

	# Barre de vie
	var bw: float = 62.0
	var bh: float = 9.0
	var by2: float = -height - 18.0
	var maxpv: float = maxf(1.0, float(entity.get("max_pv", 1)))
	var back := Rect2(-bw * 0.5 - 2.0, by2 - 2.0, bw + 4.0, bh + 4.0)
	draw_rect(back, Color(0.05, 0.05, 0.08, 0.85))
	draw_rect(Rect2(-bw * 0.5, by2, bw * clampf(ghost_pv / maxpv, 0.0, 1.0), bh), Color(1, 1, 1, 0.75))
	var ratio: float = clampf(shown_pv / maxpv, 0.0, 1.0)
	var hp_col: Color
	if entity.get("team", "") == "player":
		hp_col = Color(0.3, 0.85, 0.35).lerp(Color(0.95, 0.75, 0.2), 1.0 - ratio) if ratio > 0.35 else Color(0.95, 0.3, 0.25)
	else:
		hp_col = Color(0.9, 0.25, 0.22)
	draw_rect(Rect2(-bw * 0.5, by2, bw * ratio, bh), hp_col)
	draw_rect(Rect2(-bw * 0.5, by2, bw * ratio, bh * 0.4), Color(1, 1, 1, 0.22))
	draw_rect(back, tc, false, 1.5)
	var ord_no: int = int(entity.get("ord", 0))
	if ord_no > 0:
		var oc := Vector2(-bw * 0.5 - 16.0, by2 + bh * 0.5)
		draw_circle(oc, 12.0, Color(0, 0, 0, 0.88))
		draw_circle(oc, 10.5, ord_color(entity))
		draw_string(ThemeDB.fallback_font, oc + Vector2(-10.0, 6.0), str(ord_no), HORIZONTAL_ALIGNMENT_CENTER, 20.0, 17, Color(0.1, 0.05, 0.0))

	# Statuts
	var font: Font = ThemeDB.fallback_font
	var sts: Array = entity.get("statuses", [])
	var count: int = mini(sts.size(), 6)
	var sx: float = -float(count) * 17.0 * 0.5
	for i: int in range(count):
		var s: Dictionary = sts[i]
		var info: Dictionary = Combat.status_info(String(s["id"]))
		var r := Rect2(sx + float(i) * 17.0, by2 - 19.0, 16.0, 16.0)
		draw_rect(r, Color(0, 0, 0, 0.7))
		draw_rect(r.grow(-1.0), info["color"])
		draw_string(font, r.position + Vector2(0, 12), String(info["icon"]), HORIZONTAL_ALIGNMENT_CENTER, 16.0, 9, Color(0, 0, 0, 0.85))
		if int(s["turns"]) < 99:
			draw_string(font, r.position + Vector2(9, 25), str(s["turns"]), HORIZONTAL_ALIGNMENT_LEFT, 12.0, 10, Color(1, 1, 1))

	# Prévisualisation des dégâts (survol d'un sort)
	if preview_text != "":
		var pc := Color(1.0, 0.85, 0.3) if preview_text.begins_with("-") else Color(0.5, 1.0, 0.6)
		draw_string_outline(font, Vector2(-45, by2 - 30.0), preview_text, HORIZONTAL_ALIGNMENT_CENTER, 90, 26, 7, Color(0, 0, 0, 0.95))
		draw_string(font, Vector2(-45, by2 - 30.0), preview_text, HORIZONTAL_ALIGNMENT_CENTER, 90, 26, pc)


func _draw_dragonnet() -> void:
	var by: float = -_hop - sin(_t * 3.0 + _phase) * 3.0
	var flap: float = sin(_t * 9.0) * 8.0
	var body := Color(0.92, 0.38, 0.2)
	var dark := Color(0.62, 0.18, 0.14)
	# ailes
	draw_colored_polygon(PackedVector2Array([Vector2(-10, -44 + by), Vector2(-48, -78 + by - flap), Vector2(-40, -40 + by), Vector2(-14, -30 + by)]), dark)
	draw_colored_polygon(PackedVector2Array([Vector2(10, -44 + by), Vector2(48, -78 + by - flap), Vector2(40, -40 + by), Vector2(14, -30 + by)]), dark)
	# queue
	draw_polyline(PackedVector2Array([Vector2(-14, -16 + by), Vector2(-34, -12 + by), Vector2(-44, -22 + by)]), body.darkened(0.2), 7.0)
	# corps
	draw_circle(Vector2(0, -30 + by), 25.0, body.darkened(0.2))
	draw_circle(Vector2(0, -32 + by), 23.0, body)
	draw_circle(Vector2(0, -24 + by), 14.0, Color(1.0, 0.82, 0.5))
	# tête
	draw_circle(Vector2(0, -62 + by), 17.0, body)
	draw_colored_polygon(PackedVector2Array([Vector2(-12, -72 + by), Vector2(-18, -90 + by), Vector2(-5, -76 + by)]), Color(1, 0.95, 0.8))
	draw_colored_polygon(PackedVector2Array([Vector2(12, -72 + by), Vector2(18, -90 + by), Vector2(5, -76 + by)]), Color(1, 0.95, 0.8))
	draw_circle(Vector2(-6, -64 + by), 4.0, Color.WHITE)
	draw_circle(Vector2(6, -64 + by), 4.0, Color.WHITE)
	draw_circle(Vector2(-5, -64 + by), 2.0, Color(0.1, 0.0, 0.0))
	draw_circle(Vector2(7, -64 + by), 2.0, Color(0.1, 0.0, 0.0))
	draw_circle(Vector2(0, -55 + by), 3.0, Color(0.3, 0.05, 0.05))


func _draw_troll() -> void:
	var by: float = -_hop - sin(_t * 1.6 + _phase) * 2.0
	var skin := Color(0.45, 0.58, 0.36)
	# massue
	draw_line(Vector2(34, -20 + by), Vector2(46, -78 + by), Color(0.4, 0.26, 0.14), 8.0)
	draw_circle(Vector2(46, -82 + by), 13.0, Color(0.5, 0.33, 0.18))
	# corps massif
	draw_circle(Vector2(0, -34 + by), 32.0, skin.darkened(0.3))
	draw_circle(Vector2(0, -36 + by), 30.0, skin)
	draw_circle(Vector2(0, -28 + by), 18.0, skin.lightened(0.15))
	# bras
	draw_circle(Vector2(-30, -36 + by), 11.0, skin.darkened(0.1))
	draw_circle(Vector2(32, -30 + by), 11.0, skin.darkened(0.1))
	# tête
	draw_circle(Vector2(0, -72 + by), 17.0, skin)
	draw_circle(Vector2(-7, -75 + by), 3.5, Color(1, 0.9, 0.3))
	draw_circle(Vector2(7, -75 + by), 3.5, Color(1, 0.9, 0.3))
	draw_line(Vector2(-8, -64 + by), Vector2(8, -64 + by), Color(0.15, 0.1, 0.05), 3.0)
	draw_colored_polygon(PackedVector2Array([Vector2(-6, -64 + by), Vector2(-3, -58 + by), Vector2(0, -64 + by)]), Color.WHITE)
	draw_colored_polygon(PackedVector2Array([Vector2(6, -64 + by), Vector2(3, -58 + by), Vector2(0, -64 + by)]), Color.WHITE)
