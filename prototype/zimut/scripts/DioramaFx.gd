class_name DioramaFx
extends RefCounted
## DioramaFx.gd — V127 : la carte Diorama prend vie, sans retoucher les tuiles pré-rendues.
##
## Un masque basse définition (assets/boards/<nation>/fx.png, produit par tools/diorama/fx_masks.py)
## dit où sont l'eau (R), la lave et les lumières (V) et la terre ferme (B). Deux calques animés :
##   • sol  (sous les personnages) : reflets, creux et écume sur l'eau, croûte et lueurs de la lave ;
##   • ciel (au-dessus de tout)    : ombres de nuages qui dérivent, rayons de lumière ; hors de l'île,
##     une mer de nuages (V131) ; aux Brumes, des nappes de brume au sol (V137).
## Absents en qualité « Économie ». Coût : un quad par calque, 3 à 4 lectures de texture par pixel.

const GROUND := """
shader_type canvas_item;
render_mode blend_premul_alpha, unshaded;
uniform sampler2D noise : repeat_enable, filter_linear;
uniform vec2 msize = vec2(1280.0, 720.0);
uniform vec3 glint_col : source_color = vec3(0.80, 0.96, 1.0);
uniform vec3 deep_col : source_color = vec3(0.02, 0.10, 0.17);
uniform vec3 lava_col : source_color = vec3(1.0, 0.86, 0.42);
uniform vec3 crust_col : source_color = vec3(0.50, 0.09, 0.02);
void fragment() {
	vec4 m = texture(TEXTURE, UV);
	if (m.r + m.g < 0.03) { discard; }
	vec2 p = UV * msize * vec2(1.0, 1.9);          // vue iso : motifs étirés à l'horizontale
	float t = TIME;
	float n1 = texture(noise, p * 0.047 + vec2(t * 0.034, t * 0.015)).r;
	float n2 = texture(noise, p * 0.113 - vec2(t * 0.036, -t * 0.027)).r;
	vec3 add = vec3(0.0);
	vec3 dark = vec3(0.0);
	float a = 0.0;
	if (m.r > 0.03) {
		float c = n1 * n2 * 4.0;                     // ~1 en moyenne
		float glint = smoothstep(1.62, 2.05, c);     // éclats de soleil, rares et fins
		float crest = smoothstep(1.15, 1.62, c);     // crêtes claires
		float trough = 1.0 - smoothstep(0.45, 0.95, c);   // creux un peu plus sombres
		float open_w = smoothstep(0.30, 0.50, m.r);
		float shore = smoothstep(0.03, 0.30, m.r) * (1.0 - smoothstep(0.38, 0.62, m.r));
		float foam = shore * smoothstep(0.40, 0.62, texture(noise, p * 0.21 + vec2(t * 0.060, -t * 0.020)).r);
		add += glint_col * (glint * 0.42 + crest * 0.07) * open_w + vec3(0.92, 1.0, 1.0) * foam * 0.26;
		float da = trough * 0.16 * open_w;
		dark += deep_col * da;
		a += da;
	}
	if (m.g > 0.03) {
		float flow = texture(noise, p * 0.060 + vec2(-t * 0.022, t * 0.040)).r;
		float crust = smoothstep(0.52, 0.74, flow * 0.6 + n2 * 0.4) * m.g * 0.42;   // croûte sombre qui dérive
		float pulse = 0.5 + 0.5 * sin(t * 1.4 + p.x * 0.05 + n1 * 6.0);
		add += lava_col * m.g * (0.10 * pulse + 0.16 * smoothstep(0.60, 0.85, n1)) * (1.0 - crust * 1.6);
		dark += crust_col * crust;
		a += crust;
	}
	COLOR = vec4(add + dark, clamp(a, 0.0, 1.0));
}
"""

const SKY := """
shader_type canvas_item;
render_mode blend_premul_alpha, unshaded;
uniform sampler2D noise : repeat_enable, filter_linear;
uniform vec2 msize = vec2(1280.0, 720.0);
uniform vec3 shadow_col : source_color = vec3(0.04, 0.07, 0.16);
uniform float shadow_amt = 0.17;
uniform vec3 ray_col : source_color = vec3(1.0, 0.93, 0.70);
uniform float ray_amt = 0.07;
uniform vec3 sea_col : source_color = vec3(1.0, 1.0, 1.0);
uniform float sea_amt = 0.30;
uniform vec3 mist_col : source_color = vec3(0.82, 0.93, 0.90);
uniform float mist_amt = 0.0;
void fragment() {
	float land = texture(TEXTURE, UV).b;
	vec2 p = UV * msize;
	float t = TIME;
	if (land < 0.04) {
		// V131 : hors de l'île, une mer de nuages dérive lentement autour du monde
		float s1 = texture(noise, p * vec2(0.0060, 0.0130) + vec2(t * 0.0060, 0.0)).r;
		float s2 = texture(noise, p * vec2(0.0150, 0.0320) + vec2(-t * 0.0045, t * 0.0012)).r;
		float sea = smoothstep(0.50, 0.78, s1 * 0.65 + s2 * 0.35) * sea_amt;
		COLOR = vec4(sea_col * sea, sea);
	} else {
	float c1 = texture(noise, p * vec2(0.0042, 0.0080) + vec2(t * 0.0075, t * 0.0026)).r;
	float c2 = texture(noise, p * vec2(0.0095, 0.0180) - vec2(t * 0.0030, -t * 0.0021)).r;
	float cloud = smoothstep(0.46, 0.70, c1 * 0.72 + c2 * 0.28);
	float a = cloud * shadow_amt * land;
	// rayons : bandes obliques lentes, seulement hors de l'ombre des nuages
	float band = sin((p.x * 0.9 + p.y * 1.6) * 0.020 + t * 0.045 + c2 * 2.5);
	float ray = smoothstep(0.55, 1.0, band) * (1.0 - cloud) * ray_amt * land;
	vec3 rgb = shadow_col * a + ray_col * ray;
	if (mist_amt > 0.0) {
		// V137 : nappes de brume qui dérivent sur le sol (Brumes) ; plus denses au-dessus de l'eau
		float m1 = texture(noise, p * vec2(0.0100, 0.0220) + vec2(t * 0.0100, t * 0.0020)).r;
		float m2 = texture(noise, p * vec2(0.0230, 0.0500) - vec2(t * 0.0070, -t * 0.0030)).r;
		float water = texture(TEXTURE, UV).r;
		float mist = clamp(smoothstep(0.40, 0.78, m1 * 0.6 + m2 * 0.4) + water * 0.35, 0.0, 1.0) * mist_amt * land;
		rgb = rgb * (1.0 - mist) + mist_col * mist;
		a = a + mist * (1.0 - a);
	}
	COLOR = vec4(rgb, a);
	}
}
"""

## Réglages d'ambiance par Nation : couleur / force des ombres de nuages et des rayons.
const MOODS := {
	"Brasier": {"shadow_col": Color(0.10, 0.03, 0.02), "shadow_amt": 0.22, "ray_col": Color(1.0, 0.55, 0.25), "ray_amt": 0.035,
		"glint_col": Color(1.0, 0.85, 0.6), "sea_col": Color(0.95, 0.55, 0.40), "sea_amt": 0.22},
	"Brumes": {"shadow_col": Color(0.03, 0.08, 0.09), "shadow_amt": 0.07, "ray_col": Color(0.75, 1.0, 0.90), "ray_amt": 0.04,
		"glint_col": Color(0.70, 1.0, 0.90), "deep_col": Color(0.02, 0.10, 0.09), "sea_col": Color(0.80, 0.95, 0.90), "sea_amt": 0.46,
		"mist_col": Color(0.84, 0.94, 0.91), "mist_amt": 0.40},
}

static var _noise: Texture2D = null
static var _shaders: Dictionary = {}


## Bruit répétable 128 × 128, calculé une fois (valeurs lissées, raccord parfait sur les bords).
static func noise_texture() -> Texture2D:
	if _noise != null:
		return _noise
	var n: int = 128
	var rng := RandomNumberGenerator.new()
	rng.seed = 20261109
	var img := Image.create(n, n, false, Image.FORMAT_L8)
	var acc := PackedFloat32Array()
	acc.resize(n * n)
	var amp: float = 1.0
	var total: float = 0.0
	for cells: int in [4, 8, 16, 32]:
		var grid := PackedFloat32Array()
		grid.resize(cells * cells)
		for i: int in range(cells * cells):
			grid[i] = rng.randf()
		for y: int in range(n):
			var fy: float = float(y) / float(n) * float(cells)
			var y0: int = int(fy) % cells
			var y1: int = (y0 + 1) % cells
			var ty: float = fy - floorf(fy)
			ty = ty * ty * (3.0 - 2.0 * ty)
			for x: int in range(n):
				var fx: float = float(x) / float(n) * float(cells)
				var x0: int = int(fx) % cells
				var x1: int = (x0 + 1) % cells
				var tx: float = fx - floorf(fx)
				tx = tx * tx * (3.0 - 2.0 * tx)
				var v: float = lerpf(lerpf(grid[y0 * cells + x0], grid[y0 * cells + x1], tx), lerpf(grid[y1 * cells + x0], grid[y1 * cells + x1], tx), ty)
				acc[y * n + x] += v * amp
		total += amp
		amp *= 0.5
	for y: int in range(n):
		for x: int in range(n):
			var v: float = acc[y * n + x] / total
			img.set_pixel(x, y, Color(v, v, v))
	_noise = ImageTexture.create_from_image(img)
	return _noise


static func _material(code: String, biome: String, msize: Vector2) -> ShaderMaterial:
	if not _shaders.has(code):
		var sh := Shader.new()
		sh.code = code
		_shaders[code] = sh
	var m := ShaderMaterial.new()
	m.shader = _shaders[code]
	m.set_shader_parameter("noise", noise_texture())
	m.set_shader_parameter("msize", msize)
	var mood: Dictionary = MOODS.get(biome, {})
	for k: String in mood.keys():
		m.set_shader_parameter(k, mood[k])
	return m


static func _layer(fx: Dictionary, tex: Texture2D, code: String, biome: String, nm: String) -> Sprite2D:
	var s := Sprite2D.new()
	s.name = nm
	s.texture = tex
	s.centered = false
	s.position = fx["pos"]
	s.scale = Vector2.ONE * float(fx["scale"])
	s.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	s.material = _material(code, biome, Vector2(tex.get_size()))
	return s


## Effets actifs pour cette carte ? (masque présent, qualité autre que « Économie »)
static func available(zone_id: String) -> bool:
	return not GfxQuality.low() and not BoardArt.diorama_fx(zone_id).is_empty()


## Pose les deux calques : `ground` (sous les personnages) dans `holder`, `sky` dans `world` au-dessus
## des personnages. Retourne [sol, ciel] ou [] si les effets sont indisponibles.
static func attach(holder: Node2D, world: Node2D, zone_id: String, biome: String) -> Array:
	if not available(zone_id):
		return []
	var fx: Dictionary = BoardArt.diorama_fx(zone_id)
	var tex: Texture2D = load(String(fx["path"])) as Texture2D
	if tex == null:
		return []
	var ground: Sprite2D = _layer(fx, tex, GROUND, biome, "DioramaFxSol")
	var gr: Rect2 = fx.get("ground_rect", Rect2())
	if gr.size.x > 0.0:                    # seule la zone qui contient de l'eau ou de la lave est dessinée
		ground.region_enabled = true
		ground.region_rect = gr
		ground.position += gr.position * float(fx["scale"])
	elif fx.has("ground_rect"):
		ground.visible = false             # ni eau ni lave sur cette carte
	holder.add_child(ground)
	var sky: Sprite2D = _layer(fx, tex, SKY, biome, "DioramaFxCiel")
	sky.z_index = 1200          # au-dessus des personnages (profondeur max ~1150), sous l'interface (1320)
	world.add_child(sky)
	return [ground, sky]
