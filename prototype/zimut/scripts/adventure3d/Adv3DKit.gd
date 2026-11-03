class_name Adv3DKit
extends RefCounted
## Adv3DKit.gd — Modèles du « Stylized Nature MegaKit » (Quaternius, CC0 ; voir assets/nature/ et
## tools/prep_nature_kit.py), habillés avec l'éclairage cartoon du monde 3D (V87).
##
## Chaque glTF est importé par Godot ; on en extrait le maillage et on remplace ses matériaux par un
## ShaderMaterial maison (texture de base + découpe alpha des feuilles + vent + TOON_LIGHT).

const DIR := "res://assets/nature/"

static var _meshes: Dictionary = {}
static var _mats: Dictionary = {}

const SHADER := """
shader_type spatial;
render_mode cull_disabled, specular_disabled;
uniform sampler2D albedo_tex : source_color, filter_linear_mipmap, repeat_enable;
uniform float cutout = 0.0;
uniform float cutoff = 0.4;
uniform float sway = 0.1;
uniform float speed = 1.4;
uniform float normal_up = 0.0;
uniform float emit = 0.10;
uniform float swap_rg = 0.0;       // 1 : feuilles rouges → vertes (buissons)
uniform float fade_near = 1.0;
uniform float fade_far = 2.6;
float bayer4(vec2 p) {
	ivec2 q = ivec2(mod(p, 4.0));
	int i = q.x + q.y * 4;
	int m[16] = int[16](0, 8, 2, 10, 12, 4, 14, 6, 3, 11, 1, 9, 15, 7, 13, 5);
	return (float(m[i]) + 0.5) / 16.0;
}
void vertex() {
	float h = max(VERTEX.y, 0.0);
	vec3 wp = MODEL_MATRIX[3].xyz;
	float ph = wp.x * 0.42 + wp.z * 0.31;
	float w = sin(TIME * speed + ph) * 0.6 + sin(TIME * speed * 1.7 + ph * 1.3) * 0.25;
	VERTEX.x += w * sway * h * h * 0.05;
	VERTEX.z += cos(TIME * speed * 0.8 + ph) * sway * h * h * 0.03;
}
void fragment() {
	float dist = length(VERTEX);
	if (dist < fade_far) {
		float a = clamp((dist - fade_near) / (fade_far - fade_near), 0.0, 1.0);
		if (a < bayer4(FRAGCOORD.xy)) {
			discard;
		}
	}
	vec4 t = texture(albedo_tex, UV);
	if (cutout > 0.5 && t.a < cutoff) {
		discard;
	}
	if (!FRONT_FACING) {
		NORMAL = -NORMAL;
	}
	vec3 up_v = normalize((VIEW_MATRIX * vec4(0.0, 1.0, 0.0, 0.0)).xyz);
	NORMAL = normalize(mix(NORMAL, up_v, normal_up));
	vec3 tc = mix(t.rgb, t.grb, swap_rg);
	ALBEDO = tc * COLOR.rgb;
	EMISSION = ALBEDO * emit;
	ROUGHNESS = 0.9;
}
"""


static func _shader() -> Shader:
	if not _mats.has("shader"):
		var sh := Shader.new()
		sh.code = SHADER + Adv3DMeshes.TOON_LIGHT
		_mats["shader"] = sh
	return _mats["shader"]


## Matériau cartoon pour une texture de base (découpe alpha pour les feuillages).
static func material_for(src: Material, swap_rg: bool = false) -> ShaderMaterial:
	var bm := src as BaseMaterial3D
	var tex: Texture2D = bm.albedo_texture if bm != null else null
	var cut: bool = bm != null and bm.transparency == BaseMaterial3D.TRANSPARENCY_ALPHA_SCISSOR
	var key: String = "%s|%s|%s" % [tex.resource_path if tex != null else "none", cut, swap_rg]
	if _mats.has(key):
		return _mats[key]
	var m := ShaderMaterial.new()
	m.shader = _shader()
	m.set_shader_parameter("albedo_tex", tex)
	m.set_shader_parameter("cutout", 1.0 if cut else 0.0)
	m.set_shader_parameter("cutoff", bm.alpha_scissor_threshold if bm != null else 0.4)
	m.set_shader_parameter("swap_rg", 1.0 if swap_rg else 0.0)
	m.set_shader_parameter("sway", 0.12 if cut else 0.0)
	m.set_shader_parameter("normal_up", 0.35 if cut else 0.0)
	_mats[key] = m
	return m


## Maillage d'un modèle du kit (cartoon, mis en cache) ; null si absent.
static func mesh(model: String, swap_rg: bool = false) -> Mesh:
	var ck: String = model + ("|g" if swap_rg else "")
	if _meshes.has(ck):
		return _meshes[ck]
	var out: Mesh = null
	var path: String = DIR + model + ".gltf"
	if ResourceLoader.exists(path):
		var ps: PackedScene = load(path)
		if ps != null:
			var root: Node = ps.instantiate()
			var mi: MeshInstance3D = _first_mesh(root)
			if mi != null:
				out = (mi.mesh as Mesh).duplicate()
				for i: int in range(out.get_surface_count()):
					out.surface_set_material(i, material_for(out.surface_get_material(i), swap_rg))
			root.free()
	_meshes[ck] = out
	return out


static func _first_mesh(n: Node) -> MeshInstance3D:
	if n is MeshInstance3D:
		return n
	for c: Node in n.get_children():
		var r: MeshInstance3D = _first_mesh(c)
		if r != null:
			return r
	return null


## Liste de maillages « Nom_1 … Nom_n » (ceux qui existent).
static func variants(prefix: String, count: int) -> Array:
	var out: Array = []
	for i: int in range(1, count + 1):
		var m: Mesh = mesh("%s_%d" % [prefix, i])
		if m != null:
			out.append(m)
	return out


static func available() -> bool:
	return ResourceLoader.exists(DIR + "CommonTree_1.gltf")
