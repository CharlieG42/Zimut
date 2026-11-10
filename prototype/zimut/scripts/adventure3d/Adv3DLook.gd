class_name Adv3DLook
extends RefCounted
## Adv3DLook.gd — V128 : étalonnage commun des deux vues 3D (monde ouvert et 3D par cases).
##
## Appelé à la fin de la mise en place du ciel / soleil / brouillard :
##   • brume de DISTANCE (nette de près, voile au loin qui fond le bord du monde) à la place du
##     brouillard uniforme qui délavait toute l'image ;
##   • soleil plus franc, lumière ambiante plus basse et plus froide : ombres lisibles et teintées ;
##   • ciel : couche de nuages peinte (panorama calculé une fois, aucun coût par image), halo solaire ;
##   • contraste / saturation réglés par Nation.
## Tout est statique : aucun shader de ciel animé (il forcerait un recalcul du ciel à chaque image).

## Réglages par Nation (facultatifs) : sat, contrast, haze (opacité max de la brume), haze_begin / haze_end (m).
const NATION := {
	"Brasier": {"sat": 1.0, "contrast": 1.08, "haze": 0.80, "haze_begin": 16.0, "haze_end": 95.0, "amb": 0.72, "cool": 0.10, "expo": 1.14, "sun": 1.25, "cloud": Color(0.36, 0.20, 0.16), "cloud_amt": 0.75},
	"Brumes": {"sat": 1.0, "contrast": 1.10, "haze": 0.82, "haze_begin": 12.0, "haze_end": 78.0, "expo": 0.90, "sun": 1.0, "cloud": Color(0.80, 0.90, 0.88), "cloud_amt": 0.85,
		"amb": 0.50, "cool": 0.30, "ground_mist": 0.24, "mist_col": Color(0.80, 0.92, 0.90)},
	"Ombres": {"amb": 0.62, "cool": 0.20, "expo": 1.08, "sat": 1.0, "contrast": 1.08, "haze": 0.85, "haze_begin": 12.0, "haze_end": 85.0, "cloud": Color(0.40, 0.36, 0.52), "cloud_amt": 0.7},
	"Donjon": {"amb": 0.62, "cool": 0.20, "expo": 1.08, "sat": 1.0, "contrast": 1.08, "haze": 0.85, "haze_begin": 12.0, "haze_end": 85.0, "cloud": Color(0.38, 0.34, 0.46), "cloud_amt": 0.7},
	"Désert": {"sat": 1.0, "contrast": 1.10, "haze": 0.62, "haze_begin": 26.0, "haze_end": 140.0, "cloud_amt": 0.35},
	# V142 : soleil plus franc et ambiance bleutée → ombres bleues nettes sur la neige ; exposition retenue (pas de blanc brûlé)
	"Montagne": {"sat": 1.04, "contrast": 1.08, "haze": 0.62, "haze_begin": 26.0, "haze_end": 135.0, "cloud_amt": 0.6,
		"amb": 0.48, "cool": 0.62, "sun": 1.14, "expo": 0.94},
}
## V134 : amb = énergie de la lumière ambiante, cool = part de bleu dans l'ambiance, expo = exposition, sun = énergie du
## soleil. Les Nations sombres (Brasier, Ombres) gardent plus d'ambiance : sinon tout ce qui est à l'ombre devient noir.
const DEFAULT := {"amb": 0.44, "cool": 0.45, "expo": 1.0, "sun": 1.02, "sat": 0.98, "contrast": 1.10, "haze": 0.66, "haze_begin": 26.0, "haze_end": 135.0, "cloud": Color(1.0, 1.0, 1.0), "cloud_amt": 0.9}

static var _covers: Dictionary = {}


static func look(biome: String) -> Dictionary:
	var out: Dictionary = DEFAULT.duplicate()
	var n: Dictionary = NATION.get(biome, {})
	for k: String in n.keys():
		out[k] = n[k]
	return out


## Panorama de nuages (512 × 256, alpha = couverture) : bancs étirés, denses vers l'horizon, ciel
## dégagé au zénith. Calculé une fois par couleur / densité.
static func cloud_cover(col: Color, amt: float) -> Texture2D:
	var key: String = "%s|%.2f" % [col.to_html(false), amt]
	if _covers.has(key):
		return _covers[key]
	var w: int = 512
	var h: int = 256
	var noise := FastNoiseLite.new()
	noise.seed = 4127
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	noise.frequency = 1.0
	noise.fractal_octaves = 4
	noise.fractal_gain = 0.55
	var img := Image.create(w, h, false, Image.FORMAT_RGBA8)
	for y: int in range(h):
		var v: float = float(y) / float(h)                      # 0 = zénith, 0,5 = horizon, 1 = nadir
		var elev: float = clampf(1.0 - v * 2.0, 0.0, 1.0)        # 1 au zénith, 0 à l'horizon
		var band: float = smoothstep(0.0, 0.10, elev) * (1.0 - smoothstep(0.42, 0.85, elev))
		for x: int in range(w):
			var a: float = 0.0
			if band > 0.001:
				var ang: float = float(x) / float(w) * TAU
				# bruit sur un cylindre : raccord parfait à la couture du panorama ; étiré à l'horizontale
				var n: float = noise.get_noise_3d(cos(ang) * 1.6, sin(ang) * 1.6, elev * 7.0) * 0.5 + 0.5
				a = smoothstep(0.44, 0.70, n) * band * amt
			var shade: float = 0.86 + 0.14 * smoothstep(0.0, 0.5, elev)   # dessous un peu plus sombre vers l'horizon
			img.set_pixel(x, y, Color(col.r * shade, col.g * shade, col.b * shade, a))
	var tex: Texture2D = ImageTexture.create_from_image(img)
	_covers[key] = tex
	return tex


## Applique l'étalonnage. `tod` : "jour" | "matin" | "soir".
static func apply(env: Environment, sun: DirectionalLight3D, sky_mat: ProceduralSkyMaterial, pal: Dictionary, biome: String, tod: String) -> void:
	var lk: Dictionary = look(biome)
	# ── brume de distance
	env.fog_enabled = true
	env.fog_mode = Environment.FOG_MODE_DEPTH
	env.fog_depth_begin = float(lk["haze_begin"]) * (0.8 if tod == "matin" else 1.0)
	env.fog_depth_end = float(lk["haze_end"])
	env.fog_depth_curve = 1.25
	env.fog_density = float(lk["haze"])
	env.fog_sky_affect = 0.0                       # le ciel garde ses couleurs ; l'horizon du ciel reprend déjà la teinte de la brume
	env.fog_aerial_perspective = 0.0
	env.fog_sun_scatter = 0.12
	# ── lumière
	sun.light_energy = float(lk["sun"]) * (1.0 if tod == "jour" else 0.96)
	env.ambient_light_color = env.ambient_light_color.lerp(Color(0.56, 0.66, 0.92), float(lk["cool"]))
	env.ambient_light_energy = float(lk["amb"])
	env.reflected_light_source = Environment.REFLECTION_SOURCE_DISABLED     # pas de carte de reflets à calculer
	# ── image
	env.tonemap_mode = Environment.TONE_MAPPER_FILMIC
	env.tonemap_exposure = float(lk["expo"])
	env.tonemap_white = 1.8
	env.adjustment_enabled = true
	env.adjustment_saturation = float(pal.get("sat", 1.0)) * float(lk["sat"])
	env.adjustment_contrast = float(lk["contrast"])
	env.adjustment_brightness = 1.0
	env.glow_intensity = 0.40
	env.glow_bloom = 0.02
	# ── ciel
	if sky_mat != null:
		sky_mat.sky_curve = 0.12
		sky_mat.sky_energy_multiplier = 1.0
		sky_mat.sun_angle_max = 34.0
		sky_mat.sun_curve = 0.10
		sky_mat.ground_bottom_color = (env.fog_light_color as Color).darkened(0.20)
		sky_mat.ground_horizon_color = sky_mat.sky_horizon_color
		sky_mat.ground_curve = 0.06
		if not GfxQuality.low():
			sky_mat.sky_cover = cloud_cover(lk.get("cloud", Color.WHITE), float(lk["cloud_amt"]))
			sky_mat.sky_cover_modulate = Color(1, 1, 1, 1)


## Suit la caméra à l'horizontale : les crêtes restent à distance fixe (comme un décor de ciel), toujours
## en deçà du plan lointain de la caméra (160 m).
class Backdrop extends Node3D:
	func _process(_delta: float) -> void:
		var cam: Camera3D = get_viewport().get_camera_3d()
		if cam != null:
			global_position = Vector3(cam.global_position.x, 0.0, cam.global_position.z)


## Lointain : deux chaînes de crêtes autour de la caméra, teintées par la brume (silhouettes sans éclairage).
## Elles donnent un horizon au lieu d'un bord de monde coupé net sur le ciel.
static func make_backdrop(size: Vector2i, pal: Dictionary, seed_v: int) -> Node3D:
	var root := Backdrop.new()
	root.name = "Lointain"
	var fog: Color = pal.get("fog", Color(0.8, 0.86, 0.92))
	var sky_hor: Color = pal.get("sky_hor", fog)
	var far_col: Color = fog.lerp(pal.get("sky_top", fog), 0.30)
	var mat := StandardMaterial3D.new()
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mat.specular_mode = BaseMaterial3D.SPECULAR_DISABLED
	mat.vertex_color_use_as_albedo = true
	mat.vertex_color_is_srgb = true
	mat.cull_mode = BaseMaterial3D.CULL_DISABLED
	mat.disable_fog = true                       # la teinte de brume est déjà dans les couleurs
	var rng := RandomNumberGenerator.new()
	rng.seed = seed_v * 7 + 31
	for layer: int in range(2):
		var st := SurfaceTool.new()
		st.begin(Mesh.PRIMITIVE_TRIANGLES)
		var rad: float = 138.0 + float(layer) * 14.0
		var hmax: float = 15.0 + float(layer) * 13.0
		var segs: int = 72
		var ph: float = rng.randf() * TAU
		var top_c: Color = far_col.lerp(sky_hor, 0.35 + 0.30 * float(layer)).darkened(0.10 - 0.05 * float(layer))
		var bot_c: Color = fog.lerp(sky_hor, 0.5)
		var pts: Array = []
		for i: int in range(segs + 1):
			var a: float = float(i % segs) / float(segs) * TAU
			var hh: float = hmax * (0.42 + 0.30 * sin(a * 3.0 + ph) + 0.18 * sin(a * 7.0 + ph * 2.3) + 0.10 * sin(a * 13.0 + ph * 0.7))
			pts.append([Vector3(cos(a) * rad, -60.0, sin(a) * rad), Vector3(cos(a) * rad, maxf(hh, 3.0), sin(a) * rad)])
		for i: int in range(segs):
			var b0: Vector3 = pts[i][0]
			var t0: Vector3 = pts[i][1]
			var b1: Vector3 = pts[i + 1][0]
			var t1: Vector3 = pts[i + 1][1]
			for v: Array in [[b0, bot_c], [t0, top_c], [t1, top_c], [b0, bot_c], [t1, top_c], [b1, bot_c]]:
				st.set_color(v[1])
				st.add_vertex(v[0])
		var mi := MeshInstance3D.new()
		mi.mesh = st.commit()
		mi.material_override = mat
		mi.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		mi.extra_cull_margin = 4000.0
		root.add_child(mi)
	return root


const GROUND_MIST := """
shader_type spatial;
render_mode unshaded, blend_mix, depth_draw_never, cull_disabled, shadows_disabled;
uniform sampler2D noise : repeat_enable, filter_linear;
uniform vec3 col : source_color = vec3(0.80, 0.92, 0.90);
uniform float amt = 0.5;
uniform float drift = 1.0;
varying vec3 wp;
void vertex() {
	wp = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}
void fragment() {
	float t = TIME * drift;
	float n = texture(noise, wp.xz * 0.030 + vec2(t * 0.012, t * 0.004)).r * 0.6
		+ texture(noise, wp.xz * 0.085 - vec2(t * 0.008, -t * 0.006)).r * 0.4;
	float d = length(wp - CAMERA_POSITION_WORLD);
	// pas de voile collé à la caméra ; s'efface au loin, où la brume de distance prend le relais
	// vue de dessus (caméra haute) : la nappe s'efface, sinon elle blanchit tout l'écran
	float above = 1.0 - smoothstep(9.0, 26.0, CAMERA_POSITION_WORLD.y - wp.y);
	float a = smoothstep(0.40, 0.80, n) * amt * above * smoothstep(3.5, 12.0, d) * (1.0 - smoothstep(48.0, 70.0, d));
	ALBEDO = col;
	ALPHA = a;
}
"""


## V137 : nappes de brume au ras du sol (Nations qui ont `ground_mist`, donc les Brumes). Deux plans
## horizontaux à deux hauteurs, texture de bruit qui dérive : la brume enveloppe le pied des arbres et des
## personnages. Retourne null si la Nation n'en a pas ou en qualité « Économie ».
static func make_ground_mist(size: Vector2i, biome: String, base_y: float) -> Node3D:
	var lk: Dictionary = look(biome)
	var amt: float = float(lk.get("ground_mist", 0.0))
	if amt <= 0.0 or GfxQuality.low():
		return null
	var root := Node3D.new()
	root.name = "BrumeAuSol"
	var w: float = float(size.x) * Adv3DWorld.CELL
	var d: float = float(size.y) * Adv3DWorld.CELL
	var sh := Shader.new()
	sh.code = GROUND_MIST
	for layer: int in range(2):
		var pm := PlaneMesh.new()
		pm.size = Vector2(w + 30.0, d + 30.0)
		var mat := ShaderMaterial.new()
		mat.shader = sh
		mat.set_shader_parameter("noise", DioramaFx.noise_texture())
		mat.set_shader_parameter("col", lk.get("mist_col", Color(0.8, 0.9, 0.9)))
		mat.set_shader_parameter("amt", amt * (1.0 if layer == 0 else 0.7))
		mat.set_shader_parameter("drift", 1.0 if layer == 0 else -0.7)
		mat.render_priority = -2            # sous les étiquettes et les particules
		var mi := MeshInstance3D.new()
		mi.name = "Nappe%d" % layer
		mi.mesh = pm
		mi.material_override = mat
		mi.position = Vector3(w * 0.5, base_y + 0.45 + 0.85 * float(layer), d * 0.5)
		mi.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		root.add_child(mi)
	return root
