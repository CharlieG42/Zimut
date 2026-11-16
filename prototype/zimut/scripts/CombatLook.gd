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
uniform float contrast : hint_range(0.0, 1.0) = 0.16;
uniform float saturation : hint_range(0.5, 1.5) = 1.10;
uniform vec3 warm : source_color = vec3(1.0, 0.93, 0.80);
uniform vec3 cool : source_color = vec3(0.80, 0.90, 1.0);
uniform float split : hint_range(0.0, 1.0) = 0.22;
uniform float bloom : hint_range(0.0, 1.0) = 0.22;
uniform float bloom_threshold : hint_range(0.0, 1.0) = 0.72;
void fragment() {
	vec3 c = texture(screen_tex, SCREEN_UV).rgb;
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
	COLOR = vec4(clamp(c, 0.0, 1.0), 1.0);
}
"""

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
