class_name UiKit
extends RefCounted
## UiKit.gd — Petits éléments d'interface partagés (thème sombre V4) : panneaux, étiquettes,
## pastilles, boutons, barres. Évite de dupliquer le style dans chaque fenêtre.

const C_BG := Color(0.05, 0.07, 0.12, 1.0)
const C_PANEL := Color(0.09, 0.11, 0.17, 0.98)
const C_CARD := Color(0.12, 0.15, 0.23, 1.0)
const C_CARD_HI := Color(0.17, 0.21, 0.31, 1.0)
const C_BORDER := Color(0.30, 0.36, 0.50, 1.0)
const C_GOLD := Color(1.00, 0.82, 0.35)
const C_TXT := Color(0.95, 0.94, 0.90)
const C_DIM := Color(0.62, 0.66, 0.76)
const C_GOOD := Color(0.45, 0.88, 0.50)
const C_BAD := Color(1.00, 0.45, 0.40)

const RES_COLOR := {
	"Fer": Color(0.70, 0.76, 0.85), "Bois": Color(0.75, 0.55, 0.32), "Cuir": Color(0.85, 0.62, 0.40),
	"Magie": Color(0.70, 0.55, 0.98), "Venin": Color(0.55, 0.88, 0.35),
}
const RES_ICON := {"Fer": "⛏", "Bois": "🪵", "Cuir": "🟫", "Magie": "✦", "Venin": "☠"}
const SLOT_ICON := {"arme": "⚔", "bouclier": "⛨", "casque": "⛑", "armure": "👕", "bottes": "🥾",
	"bague": "💍", "collier": "📿", "gants": "🧤", "boucle_oreille": "👂", "cape": "🧣"}


static func box(bg: Color, border: Color, radius: int = 14, bw: int = 2, margin: int = 12) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = bg
	s.border_color = border
	s.set_border_width_all(bw)
	s.set_corner_radius_all(radius)
	s.content_margin_left = margin
	s.content_margin_right = margin
	s.content_margin_top = margin * 0.7
	s.content_margin_bottom = margin * 0.7
	return s


static func lbl(text: String, size: int = 20, col: Color = C_TXT, outline: bool = false) -> Label:
	var l := Label.new()
	l.text = text
	l.add_theme_font_size_override("font_size", size)
	l.add_theme_color_override("font_color", col)
	if outline:
		l.add_theme_constant_override("outline_size", 5)
		l.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.85))
	return l


static func chip(text: String, col: Color, size: int = 17) -> PanelContainer:
	var p := PanelContainer.new()
	p.add_theme_stylebox_override("panel", box(col.darkened(0.55), col, 10, 2, 8))
	p.add_child(lbl(text, size, col.lightened(0.45)))
	return p


static func orb(val: String, caption: String, col: Color, d: float = 46.0) -> Control:
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 0)
	var c := PanelContainer.new()
	c.custom_minimum_size = Vector2(d, d)
	var sb := box(col, col.lightened(0.45), int(d * 0.5), 3, 0)
	sb.content_margin_top = 0
	sb.content_margin_bottom = 0
	c.add_theme_stylebox_override("panel", sb)
	var l := lbl(val, int(d * 0.5), Color.WHITE, true)
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	c.add_child(l)
	v.add_child(c)
	var cap := lbl(caption, 12, col.lightened(0.5))
	cap.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	v.add_child(cap)
	return v


static func btn(text: String, col: Color, size: int = 22, min_size: Vector2 = Vector2(0, 56)) -> Button:
	var b := Button.new()
	b.text = text
	b.custom_minimum_size = min_size
	b.add_theme_font_size_override("font_size", size)
	b.add_theme_color_override("font_color", C_TXT)
	b.add_theme_color_override("font_hover_color", Color.WHITE)
	b.add_theme_color_override("font_disabled_color", Color(0.45, 0.48, 0.56))
	b.add_theme_stylebox_override("normal", box(col.darkened(0.35), col, 12, 2, 12))
	b.add_theme_stylebox_override("hover", box(col.darkened(0.15), col.lightened(0.3), 12, 3, 12))
	b.add_theme_stylebox_override("pressed", box(col.darkened(0.5), col.lightened(0.3), 12, 3, 12))
	b.add_theme_stylebox_override("disabled", box(Color(0.13, 0.15, 0.2), Color(0.25, 0.28, 0.36), 12, 2, 12))
	b.focus_mode = Control.FOCUS_NONE
	return b


static func style_bar(bar: ProgressBar, fill: Color) -> void:
	var bg := StyleBoxFlat.new()
	bg.bg_color = Color(0.03, 0.04, 0.08)
	bg.set_corner_radius_all(6)
	bg.border_color = C_BORDER
	bg.set_border_width_all(1)
	var fl := StyleBoxFlat.new()
	fl.bg_color = fill
	fl.set_corner_radius_all(6)
	bar.add_theme_stylebox_override("background", bg)
	bar.add_theme_stylebox_override("fill", fl)


static func spacer() -> Control:
	var s := Control.new()
	s.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	return s


## Portrait carré (tête du sprite) d'une classe ou d'un type d'ennemi.
static func portrait(classe: String, px: float, team: String = "player") -> Control:
	var tr := TextureRect.new()
	tr.custom_minimum_size = Vector2(px, px)
	tr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	tr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	var tex: Texture2D = Portraits.get_texture({"classe": classe, "team": team,
		"entity_type": "Player" if team == "player" else "Enemy"})
	if tex != null:
		var at := AtlasTexture.new()
		at.atlas = tex
		at.region = Portraits.head_region(tex)
		tr.texture = at
	return tr
