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


func setup(e: Dictionary) -> void:
	entity = e
	_phase = float(int(e["uid"]) % 7)
	shown_pv = float(e["current_pv"])
	ghost_pv = shown_pv
	sprite = Sprite2D.new()
	add_child(sprite)
	_load_texture()
	set_process(true)


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
	if _has_tex and sprite != null:
		var bob: float = sin(_t * 2.2 + _phase) * 1.6
		var hop: float = absf(sin(_t * 13.0)) * 9.0 if _moving else 0.0
		sprite.position = Vector2(randf_range(-1.0, 1.0) * _shake * 6.0, -height * 0.5 + 6.0 - bob - hop)
		sprite.scale.y = absf(sprite.scale.x) * (1.0 + sin(_t * 2.2 + _phase) * 0.012)
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


func hit_react(strength: float = 1.0) -> void:
	_flash = 1.0
	_shake = 0.35 * strength


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
	draw_circle(Vector2.ZERO, 30.0, Color(0, 0, 0, 0.34))
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
		draw_circle(oc, 10.5, Color(0.95, 0.75, 0.2))
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
