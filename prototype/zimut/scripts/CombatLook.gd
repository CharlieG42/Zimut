class_name CombatLook
extends CanvasLayer
## CombatLook.gd — Étalonnage de l'image en combat (V371) : un seul passage plein écran, pour fondre personnages,
## plateau et décor dans une même lumière, façon jeux peints (Dofus, Waven) :
##  - courbe en S légère (contraste) et saturation un peu relevée,
##  - tons chauds dans les hautes lumières, froids dans les ombres (split-toning),
##  - lueur douce (bloom) sur les zones très claires.
## Désactivé en mode « Économie » (GfxQuality.low()) : il lit l'écran, ce qui coûte sur téléphone modeste.

const SHADER := """
shader_type canvas_item;
render_mode unshaded;
uniform sampler2D screen_tex : hint_screen_texture, filter_linear_mipmap;
uniform float contrast : hint_range(0.0, 1.0) = 0.30;
uniform float saturation : hint_range(0.5, 1.5) = 1.25;
uniform vec3 warm = vec3(1.0, 0.95, 0.78);
uniform vec3 cool = vec3(0.78, 0.92, 0.90);
uniform float split : hint_range(0.0, 1.0) = 0.38;
uniform float bloom : hint_range(0.0, 1.0) = 0.40;
uniform float bloom_threshold : hint_range(0.0, 1.0) = 0.62;
uniform float sharpen : hint_range(0.0, 2.0) = 0.9;
uniform float vignette : hint_range(0.0, 1.0) = 0.30;
void fragment() {
	vec3 c = texture(screen_tex, SCREEN_UV).rgb;
	// netteté (masque flou) : renforce les contours des personnages
	vec3 bz = textureLod(screen_tex, SCREEN_UV, 1.0).rgb;
	c = clamp(c + (c - bz) * sharpen, 0.0, 1.0);
	// lueur : moyenne floue des zones claires (mip 2 et 4)
	vec3 b1 = textureLod(screen_tex, SCREEN_UV, 2.0).rgb;
	vec3 b2 = textureLod(screen_tex, SCREEN_UV, 4.0).rgb;
	vec3 bl = (b1 + b2) * 0.5;
	float lb = dot(bl, vec3(0.299, 0.587, 0.114));
	bl *= smoothstep(bloom_threshold, 1.0, lb);
	c += bl * bloom;
	// contraste en S
	vec3 s = c * c * (3.0 - 2.0 * c);
	c = mix(c, s, contrast);
	// saturation
	float l = dot(c, vec3(0.299, 0.587, 0.114));
	c = mix(vec3(l), c, saturation);
	// split-toning
	c = mix(c, c * mix(cool, warm, smoothstep(0.25, 0.8, l)), split);
	vec2 q = SCREEN_UV - 0.5;
	c *= 1.0 - vignette * smoothstep(0.25, 0.75, dot(q, q) * 2.0);
	COLOR = vec4(clamp(c, 0.0, 1.0), 1.0);
}
"""

## V375 : lumière par biome. « warm » teinte les hautes lumières, « cool » les ombres ; « split » dose la teinte,
## « sat » la saturation, « vig » la vignette. Un biome absent prend le réglage de la Forêt.
const LOOKS := {
	"Forêt":    {"warm": Color(1.00, 0.95, 0.78), "cool": Color(0.78, 0.92, 0.90), "split": 0.38, "sat": 1.25, "vig": 0.30},
	"Montagne": {"warm": Color(0.96, 0.98, 1.00), "cool": Color(0.74, 0.86, 1.00), "split": 0.62, "sat": 1.12, "vig": 0.26},
	"Désert":   {"warm": Color(1.00, 0.90, 0.68), "cool": Color(0.92, 0.82, 0.80), "split": 0.62, "sat": 1.22, "vig": 0.24},
	"Donjon":   {"warm": Color(1.00, 0.88, 0.72), "cool": Color(0.70, 0.72, 0.98), "split": 0.66, "sat": 1.10, "vig": 0.46},
	"Cristaux": {"warm": Color(0.96, 0.90, 1.00), "cool": Color(0.74, 0.76, 1.00), "split": 0.62, "sat": 1.30, "vig": 0.34},
	"Marées":   {"warm": Color(0.98, 0.98, 0.90), "cool": Color(0.70, 0.92, 1.00), "split": 0.58, "sat": 1.26, "vig": 0.26},
	"Vents":    {"warm": Color(1.00, 0.98, 0.92), "cool": Color(0.84, 0.92, 1.00), "split": 0.48, "sat": 1.18, "vig": 0.20},
	"Brasier":  {"warm": Color(1.00, 0.84, 0.62), "cool": Color(0.92, 0.70, 0.66), "split": 0.70, "sat": 1.28, "vig": 0.38},
	"Brumes":   {"warm": Color(0.94, 0.99, 0.92), "cool": Color(0.76, 0.90, 0.86), "split": 0.60, "sat": 1.05, "vig": 0.32},
	"Ombres":   {"warm": Color(0.96, 0.86, 1.00), "cool": Color(0.68, 0.66, 0.96), "split": 0.68, "sat": 1.12, "vig": 0.46},
	"Rouages":  {"warm": Color(1.00, 0.90, 0.70), "cool": Color(0.86, 0.80, 0.74), "split": 0.62, "sat": 1.15, "vig": 0.34},
}


static func look_of(biome: String) -> Dictionary:
	return LOOKS.get(biome, LOOKS["Forêt"])


## Règle l'étalonnage sur le biome du combat.
func apply_biome(biome: String) -> void:
	var lk: Dictionary = look_of(biome)
	var mat: ShaderMaterial = (get_node("Grade") as ColorRect).material as ShaderMaterial
	var w: Color = lk["warm"]
	var c: Color = lk["cool"]
	mat.set_shader_parameter("warm", Vector3(w.r, w.g, w.b))
	mat.set_shader_parameter("cool", Vector3(c.r, c.g, c.b))
	mat.set_shader_parameter("split", float(lk["split"]))
	mat.set_shader_parameter("saturation", float(lk["sat"]))
	mat.set_shader_parameter("vignette", float(lk["vig"]))


static func wanted() -> bool:
	return not GfxQuality.low()


func _init() -> void:
	layer = 0          # même couche que le monde (ajouté après lui), sous l'interface (couche 1)
	name = "CombatLook"
	var sh := Shader.new()
	sh.code = SHADER
	var mat := ShaderMaterial.new()
	mat.shader = sh
	var r := ColorRect.new()
	r.name = "Grade"
	r.material = mat
	r.color = Color.WHITE
	r.set_anchors_preset(Control.PRESET_FULL_RECT)
	r.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(r)
