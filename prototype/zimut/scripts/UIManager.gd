extends CanvasLayer
## UIManager.gd — Interface de combat façon Waven / Dofus.
##   • Timeline d'initiative en portraits (haut)
##   • Panneau du personnage actif : PV, orbes PA / PM (bas-gauche)
##   • Colonne de sorts compacte à gauche, avec coûts, raccourcis et infobulle
##   • Commandes compactes : fin de tour au-dessus de la timeline, quitter sous le portrait actif
##   • Journal de combat, bannières de tour, fiche de survol, écran de fin
## Toute l'interface est construite par code (les anciens nœuds de la scène sont masqués).

signal end_turn_requested
signal restart_requested
signal spell_selected(spell)

const COL_PANEL := Color(0.94, 0.89, 0.78, 0.94)
const COL_BORDER := Color(0.72, 0.58, 0.28, 1.0)
const COL_PLAYER := Color(0.22, 0.45, 0.85)
const COL_ENEMY := Color(0.80, 0.22, 0.20)
const COL_SUMMON := Color(0.25, 0.70, 0.45)

## Échelle des cartes de sorts sur téléphones : le HUD est rendu en 1920×1080
## (stretch « viewport »), donc les cartes de 166 px paraissent minuscules sur
## un écran de type S23+ / A55. On grossit toute la colonne sur mobile.
const MOBILE_SPELL_SCALE := 1.25

var game_manager: Node
var _grid: Node

var _root: Control
var _timeline: Control
var _stats: Control
var _spell_scroll: ScrollContainer
var _spell_box: Container
var _tip_panel: PanelContainer
var _tip_label: Label
var _end_btn: Button
var _quit_btn: Button
var _log_box: VBoxContainer
var _banner: Label
var _info_panel: PanelContainer
var _info_label: Label
var _over: ColorRect
var _over_title: Label
var _over_sub: Label
var _cards: Array = []
var _cards_owner: int = -1
var _initialized: bool = false
var _spell_scale: float = 1.0


func _is_mobile() -> bool:
	return OS.has_feature("android") or OS.has_feature("ios")


func _ready() -> void:
	# Sécurité : si cette scène est lancée sans passer par Main.gd, le HUD doit
	# quand même remplacer l'ancienne interface statique au lieu de la laisser visible.
	call_deferred("_ensure_initialized")


func _ensure_initialized() -> void:
	if _initialized:
		return
	var manager: Node = get_node_or_null("/root/GameManager")
	if manager != null:
		init(manager)


# ═══════════════════════════════════════════════════════════════════════════
#  Cartes de sorts
# ═══════════════════════════════════════════════════════════════════════════

class SpellCard extends Button:
	## Carte de sort (refonte V5), dessinée dans un repère logique 188×88 (agrandi sur mobile) :
	##   • médaillon d'élément à gauche (flamme, glace, éclair, feuille, soleil...) ;
	##   • gemme hexagonale PA (bleue) en haut à gauche, PM (verte) en haut à droite si le sort en coûte ;
	##   • pastille PORTÉE (or) en bas à droite avec sa légende ;
	##   • nom lisible sur deux lignes max, puces ★ niveau / zone / lancers restants / touche.
	const LW := 188.0
	const LH := 88.0
	var spell: Dictionary = {}
	var gm: Node = null
	var hotkey: int = 0
	var base_col: Color = Color(0.5, 0.2, 0.2)
	var selected: bool = false
	var usable: bool = true
	var card_scale: float = 1.0
	var badge_mode: bool = false
	var _elem: String = ""

	static func hexagon(c: Vector2, r: float) -> PackedVector2Array:
		var pts := PackedVector2Array()
		for i: int in range(6):
			var a: float = PI / 6.0 + float(i) * TAU / 6.0
			pts.append(c + Vector2(cos(a), sin(a)) * r)
		return pts

	## Gemme hexagonale (style Waven) avec valeur et reflet.
	func _gem(c: Vector2, r: float, val: String, col: Color) -> void:
		var font: Font = ThemeDB.fallback_font
		var base: Color = col if usable else Color(0.36, 0.38, 0.45)
		var outer: PackedVector2Array = hexagon(c, r + 2.5)
		draw_colored_polygon(hexagon(c + Vector2(0, 2.5), r + 2.5), Color(0, 0, 0, 0.5))
		draw_colored_polygon(outer, Color(0.02, 0.03, 0.07))
		draw_colored_polygon(hexagon(c, r), base.darkened(0.35))
		draw_colored_polygon(hexagon(c + Vector2(0, -1.5), r * 0.84), base)
		draw_colored_polygon(PackedVector2Array([c + Vector2(-r * 0.62, -r * 0.2), c + Vector2(-r * 0.2, -r * 0.82), c + Vector2(r * 0.3, -r * 0.82), c + Vector2(-r * 0.1, -r * 0.25)]), Color(1, 1, 1, 0.22))
		draw_polyline(outer + PackedVector2Array([outer[0]]), base.lightened(0.45), 1.6, true)
		var fs: int = 22 if val.length() <= 1 else (19 if val.length() == 2 else 13)
		var pos := Vector2(c.x - r, c.y + float(fs) * 0.36)
		draw_string_outline(font, pos, val, HORIZONTAL_ALIGNMENT_CENTER, r * 2.0, fs, 6, Color(0, 0, 0, 0.92))
		draw_string(font, pos, val, HORIZONTAL_ALIGNMENT_CENTER, r * 2.0, fs, Color.WHITE)

	## Étiquette arrondie ; retourne l'abscisse de fin.
	func _chip(x: float, y: float, txt: String, col: Color) -> float:
		var font: Font = ThemeDB.fallback_font
		var w: float = font.get_string_size(txt, HORIZONTAL_ALIGNMENT_LEFT, -1, 12).x + 12.0
		var rc := Rect2(x, y - 13.0, w, 17.0)
		var sb := StyleBoxFlat.new()
		sb.bg_color = Color(0.02, 0.03, 0.08, 0.9)
		sb.border_color = col if usable else Color(0.4, 0.42, 0.48)
		sb.set_border_width_all(1)
		sb.set_corner_radius_all(8)
		draw_style_box(sb, rc)
		draw_string(font, rc.position + Vector2(6, 13), txt, HORIZONTAL_ALIGNMENT_LEFT, w, 12, col.lightened(0.5) if usable else Color(0.62, 0.64, 0.7))
		return x + w + 4.0

	## Icône de l'élément dans le médaillon.
	func _icon(c: Vector2, elem: String, kind: String) -> void:
		var ink := Color(1.0, 0.97, 0.88) if usable else Color(0.7, 0.72, 0.78)
		match elem:
			"fire":
				draw_colored_polygon(PackedVector2Array([c + Vector2(0, -15), c + Vector2(9, -2), c + Vector2(10, 7), c + Vector2(0, 14), c + Vector2(-10, 7), c + Vector2(-8, -3), c + Vector2(-2, -6)]), Color(1.0, 0.62, 0.18) if usable else ink)
				draw_colored_polygon(PackedVector2Array([c + Vector2(0, -3), c + Vector2(5, 4), c + Vector2(0, 11), c + Vector2(-5, 5)]), Color(1.0, 0.95, 0.5) if usable else ink.lightened(0.1))
			"ice":
				for i: int in range(3):
					var a: float = float(i) * PI / 3.0
					draw_line(c - Vector2(cos(a), sin(a)) * 13.0, c + Vector2(cos(a), sin(a)) * 13.0, Color(0.85, 0.97, 1.0) if usable else ink, 2.6, true)
				draw_circle(c, 3.2, Color.WHITE)
			"lightning":
				draw_colored_polygon(PackedVector2Array([c + Vector2(3, -15), c + Vector2(-8, 2), c + Vector2(-1, 2), c + Vector2(-4, 15), c + Vector2(9, -3), c + Vector2(2, -3)]), Color(1.0, 0.95, 0.45) if usable else ink)
			"poison":
				draw_colored_polygon(PackedVector2Array([c + Vector2(0, -14), c + Vector2(9, 3), c + Vector2(0, 14), c + Vector2(-9, 3)]), Color(0.62, 0.92, 0.34) if usable else ink)
				draw_circle(c + Vector2(-2, 3), 2.6, Color(0.18, 0.3, 0.1))
				draw_circle(c + Vector2(3, 5), 1.8, Color(0.18, 0.3, 0.1))
			"shadow":
				draw_circle(c, 12.0, Color(0.82, 0.7, 1.0) if usable else ink)
				draw_circle(c + Vector2(6, -3), 10.0, base_col.darkened(0.55))
			"holy":
				if kind == "heal":
					draw_rect(Rect2(c.x - 3.5, c.y - 13, 7, 26), Color(0.92, 1.0, 0.86))
					draw_rect(Rect2(c.x - 13, c.y - 3.5, 26, 7), Color(0.92, 1.0, 0.86))
				else:
					draw_circle(c, 7.0, Color(1.0, 0.95, 0.55) if usable else ink)
					for i: int in range(8):
						var a2: float = float(i) * TAU / 8.0
						draw_line(c + Vector2(cos(a2), sin(a2)) * 10.0, c + Vector2(cos(a2), sin(a2)) * 15.0, Color(1.0, 0.95, 0.55) if usable else ink, 2.2, true)
			"nature":
				draw_colored_polygon(PackedVector2Array([c + Vector2(-12, 10), c + Vector2(-8, -6), c + Vector2(4, -14), c + Vector2(12, -12), c + Vector2(10, 2), c + Vector2(0, 11)]), Color(0.6, 0.92, 0.4) if usable else ink)
				draw_line(c + Vector2(-11, 11), c + Vector2(8, -9), Color(0.16, 0.38, 0.14), 1.8, true)
			"earth":
				draw_colored_polygon(PackedVector2Array([c + Vector2(-13, 11), c + Vector2(-9, -3), c + Vector2(-2, -12), c + Vector2(8, -8), c + Vector2(13, 11)]), Color(0.78, 0.6, 0.38) if usable else ink)
				draw_colored_polygon(PackedVector2Array([c + Vector2(-9, -3), c + Vector2(-2, -12), c + Vector2(1, 11), c + Vector2(-13, 11)]), Color(0.92, 0.76, 0.52) if usable else ink.lightened(0.1))
			"water":
				draw_colored_polygon(PackedVector2Array([c + Vector2(0, -14), c + Vector2(9, 2), c + Vector2(6, 11), c + Vector2(-6, 11), c + Vector2(-9, 2)]), Color(0.45, 0.8, 1.0) if usable else ink)
				draw_circle(c + Vector2(-3, 2), 2.4, Color(1, 1, 1, 0.8))
			"arcane":
				draw_colored_polygon(PackedVector2Array([c + Vector2(0, -15), c + Vector2(4, -4), c + Vector2(15, 0), c + Vector2(4, 4), c + Vector2(0, 15), c + Vector2(-4, 4), c + Vector2(-15, 0), c + Vector2(-4, -4)]), Color(0.78, 0.7, 1.0) if usable else ink)
			_:
				draw_line(c + Vector2(-10, 10), c + Vector2(8, -12), Color(0.92, 0.94, 1.0) if usable else ink, 3.4, true)
				draw_line(c + Vector2(-6, 2), c + Vector2(-13, -3), Color(0.78, 0.6, 0.35) if usable else ink, 3.0, true)
				draw_line(c + Vector2(10, 10), c + Vector2(-8, -12), Color(0.82, 0.86, 0.95) if usable else ink, 2.4, true)

	func _draw() -> void:
		var font: Font = ThemeDB.fallback_font
		var p: Dictionary = Combat.parse(spell)
		var kind: String = String(p["kind"])
		if _elem == "":
			_elem = SpellFx.element_for(String(spell.get("name", "")), String(p.get("dtype", "phys")), kind)
		var s: float = card_scale
		draw_set_transform(Vector2.ZERO, 0.0, Vector2(s, s))
		var lw: float = size.x / s
		var lh: float = size.y / s
		if badge_mode:
			_draw_badge(font, p, lw, lh)
			draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
			return
		var accent: Color = base_col if usable else Color(0.40, 0.43, 0.50)
		var ecol: Color = SpellFx.colors(_elem)[0] if usable else Color(0.4, 0.43, 0.5)
		# Reflet haut + liseré de couleur à gauche
		draw_rect(Rect2(8, 3, lw - 16, 4), Color(1, 1, 1, 0.07 if usable else 0.03))
		draw_rect(Rect2(3, 14, 3, lh - 28), accent)
		# Médaillon d'élément
		var mc := Vector2(36, 50)
		draw_circle(mc + Vector2(0, 2.5), 28.0, Color(0, 0, 0, 0.5))
		draw_circle(mc, 27.0, Color(0.02, 0.03, 0.07))
		draw_circle(mc, 24.5, ecol.darkened(0.55))
		draw_circle(mc + Vector2(0, -2), 21.0, ecol.darkened(0.32))
		draw_arc(mc, 25.5, 0.0, TAU, 40, ecol.lightened(0.15) if usable else ecol, 2.0, true)
		draw_circle(mc + Vector2(-8, -10), 7.0, Color(1, 1, 1, 0.14))
		_icon(mc, _elem, kind)
		# Nom (jusqu'à 2 lignes)
		var nm: String = String(spell.get("name", "Sort"))
		var lines: PackedStringArray = _wrap(nm, 13)
		var fs: int = 15 if nm.length() <= 18 else 13
		var ny: float = 48.0 if lines.size() == 1 else 40.0
		var tx: float = 64.0
		var tw: float = lw - tx - 8.0
		for i: int in range(lines.size()):
			var pos := Vector2(tx, ny + float(i) * 17.0)
			draw_string_outline(font, pos, lines[i], HORIZONTAL_ALIGNMENT_LEFT, tw, fs, 5, Color(0, 0, 0, 0.92))
			draw_string(font, pos, lines[i], HORIZONTAL_ALIGNMENT_LEFT, tw, fs, Color.WHITE if usable else Color(0.62, 0.64, 0.7))
		# Rangée du bas : puces
		var x: float = tx
		var yb: float = lh - 10.0
		var slvl: int = int(spell.get("spell_level", 1))
		if slvl > 1:
			x = _chip(x, yb, "★%d" % slvl, Color(1.0, 0.76, 0.2))
		var zone_txt: String = ""
		match String(p["aoe"]):
			"zone":
				zone_txt = "Zone %d" % int(p["zone_r"])
			"adjacent_enemies":
				zone_txt = "Autour"
			"team":
				zone_txt = "Équipe"
		if zone_txt != "" and x < lw - 100.0:
			x = _chip(x, yb, zone_txt, Color(1.0, 0.62, 0.3))
		if gm != null and not gm.active_entity.is_empty():
			var left: int = gm.casts_left(gm.active_entity, spell)
			if left >= 0 and left < Combat.max_casts(spell) and x < lw - 90.0:
				x = _chip(x, yb, "×%d" % left, Color(0.9, 0.9, 0.5))
		# Gemmes PA / PM (coins hauts) — la gemme passe en rouge quand le sort n'est pas payable
		var pa_col: Color = Color(0.16, 0.5, 0.95)
		if not usable and gm != null and not gm.active_entity.is_empty() and not gm.can_afford(gm.active_entity, spell):
			pa_col = Color(0.85, 0.25, 0.22)
		_gem(Vector2(17, 17), 14.0, str(int(spell.get("cost_pa", 0))), pa_col)
		if int(spell.get("cost_pm", 0)) > 0:
			_gem(Vector2(lw - 17, 17), 14.0, str(int(spell["cost_pm"])), Color(0.14, 0.64, 0.32))
		# Portée (bas droite) : pastille dorée + légende
		var rng: int = int(spell.get("range", 1))
		var rtxt: String = str(rng) if rng < 99 else "∞"
		var cap: String = "Portée"
		if String(p["target"]) == "self":
			rtxt = "0"
			cap = "Sur soi"
		var rc := Vector2(lw - 19, lh - 20)
		draw_circle(rc + Vector2(0, 2), 15.0, Color(0, 0, 0, 0.5))
		draw_circle(rc, 15.0, Color(0.02, 0.03, 0.07))
		draw_circle(rc, 13.0, (Color(0.62, 0.46, 0.08) if usable else Color(0.3, 0.32, 0.38)))
		draw_circle(rc + Vector2(0, -1.5), 11.2, (Color(0.92, 0.7, 0.18) if usable else Color(0.42, 0.44, 0.5)))
		draw_circle(rc + Vector2(-4, -6), 3.6, Color(1, 1, 1, 0.3))
		draw_string_outline(font, Vector2(rc.x - 13, rc.y + 7), rtxt, HORIZONTAL_ALIGNMENT_CENTER, 26.0, 19, 5, Color(0, 0, 0, 0.92))
		draw_string(font, Vector2(rc.x - 13, rc.y + 7), rtxt, HORIZONTAL_ALIGNMENT_CENTER, 26.0, 19, Color.WHITE)
		draw_string_outline(font, Vector2(lw - 76, lh - 8), cap, HORIZONTAL_ALIGNMENT_RIGHT, 40.0, 10, 4, Color(0, 0, 0, 0.9))
		draw_string(font, Vector2(lw - 76, lh - 8), cap, HORIZONTAL_ALIGNMENT_RIGHT, 40.0, 10, Color(1.0, 0.86, 0.4) if usable else Color(0.6, 0.62, 0.68))
		# Touche
		if hotkey > 0:
			var hb := Rect2(6, lh - 22, 17, 17)
			var sb := StyleBoxFlat.new()
			sb.bg_color = Color(0.02, 0.03, 0.08, 0.92)
			sb.set_corner_radius_all(4)
			sb.border_color = Color(1.0, 0.9, 0.45, 0.8)
			sb.set_border_width_all(1)
			draw_style_box(sb, hb)
			draw_string(font, hb.position + Vector2(0, 13), str(hotkey % 10), HORIZONTAL_ALIGNMENT_CENTER, 17.0, 12, Color(1.0, 0.92, 0.55))
		# Sélection : halo doré + coins
		if selected:
			var glow := StyleBoxFlat.new()
			glow.bg_color = Color(1.0, 0.85, 0.3, 0.10)
			glow.border_color = Color(1.0, 0.86, 0.3, 0.95)
			glow.set_border_width_all(2)
			glow.set_corner_radius_all(14)
			draw_style_box(glow, Rect2(1, 1, lw - 2, lh - 2))
		# Indisponible : voile sombre
		if not usable:
			var veil := StyleBoxFlat.new()
			veil.bg_color = Color(0.02, 0.03, 0.06, 0.34)
			veil.set_corner_radius_all(14)
			draw_style_box(veil, Rect2(0, 0, lw, lh))
		draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)

	## Badge minimaliste : icône propre au sort et coûts visibles uniquement.
	## Le nom, la portée et les effets restent dans la description au survol.
	func _draw_badge(font: Font, p: Dictionary, lw: float, lh: float) -> void:
		var accent: Color = base_col if usable else Color(0.40, 0.43, 0.50)
		var ecol: Color = SpellFx.colors(_elem)[0] if usable else Color(0.4, 0.43, 0.5)
		draw_rect(Rect2(4, 3, lw - 8, 3), Color(1, 1, 1, 0.07 if usable else 0.03))
		draw_rect(Rect2(2, 8, 3, lh - 16), accent)
		var mc := Vector2(24.0, lh * 0.5)
		draw_circle(mc + Vector2(0, 2), 20.0, Color(0, 0, 0, 0.5))
		draw_circle(mc, 19.0, Color(0.02, 0.03, 0.07))
		draw_circle(mc, 16.8, ecol.darkened(0.55))
		draw_circle(mc + Vector2(0, -1.5), 14.4, ecol.darkened(0.32))
		draw_arc(mc, 17.5, 0.0, TAU, 36, ecol.lightened(0.15) if usable else ecol, 1.5, true)
		_spell_badge_icon(mc, spell, p)
		# PA bleu et PM vert : les gemmes numériques suffisent, les libellés sont retirés.
		var pa_col: Color = Color(0.16, 0.5, 0.95)
		if not usable and gm != null and not gm.active_entity.is_empty() and not gm.can_afford(gm.active_entity, spell):
			pa_col = Color(0.85, 0.25, 0.22)
		_gem(Vector2(lw - 15.0, 18.0), 11.0, str(int(spell.get("cost_pa", 0))), pa_col)
		if int(spell.get("cost_pm", 0)) > 0:
			_gem(Vector2(lw - 15.0, lh - 18.0), 11.0, str(int(spell.get("cost_pm", 0))), Color(0.25, 0.72, 0.4))
		if selected:
			var glow := StyleBoxFlat.new()
			glow.bg_color = Color(1.0, 0.85, 0.3, 0.10)
			glow.border_color = Color(1.0, 0.86, 0.3, 0.95)
			glow.set_border_width_all(2)
			glow.set_corner_radius_all(12)
			draw_style_box(glow, Rect2(1, 1, lw - 2, lh - 2))
		if not usable:
			var veil := StyleBoxFlat.new()
			veil.bg_color = Color(0.02, 0.03, 0.06, 0.34)
			veil.set_corner_radius_all(12)
			draw_style_box(veil, Rect2(0, 0, lw, lh))

	## Icônes vectorielles distinctes, sélectionnées selon le nom du sort.
	func _spell_badge_icon(c: Vector2, s: Dictionary, p: Dictionary) -> void:
		var nm: String = String(s.get("name", "")).to_lower()
		var ink: Color = Color(1.0, 0.97, 0.88) if usable else Color(0.65, 0.67, 0.72)
		var green := Color(0.65, 0.95, 0.48) if usable else ink
		var red := Color(1.0, 0.48, 0.28) if usable else ink
		var blue := Color(0.55, 0.82, 1.0) if usable else ink
		if nm.contains("soin") or nm.contains("guérison") or nm.contains("restaure"):
			draw_circle(c, 10.0, Color(0.2, 0.55, 0.28) if usable else Color(0.35, 0.38, 0.42))
			draw_rect(Rect2(c.x - 3.0, c.y - 10.0, 6.0, 20.0), ink)
			draw_rect(Rect2(c.x - 10.0, c.y - 3.0, 20.0, 6.0), ink)
		elif nm.contains("piège") or nm.contains("piege") or nm.contains("entrave"):
			draw_line(c + Vector2(-11, -9), c + Vector2(11, 9), red, 3.0, true)
			draw_line(c + Vector2(-11, 9), c + Vector2(11, -9), red, 3.0, true)
			draw_circle(c, 4.0, Color(0.98, 0.78, 0.35) if usable else ink)
			draw_circle(c, 1.5, Color(0.08, 0.08, 0.1))
		elif nm.contains("flèche") or nm.contains("fleche") or nm.contains("tir") or nm.contains("projectile"):
			draw_line(c + Vector2(-11, 9), c + Vector2(9, -9), Color(0.8, 0.62, 0.35) if usable else ink, 3.0, true)
			draw_colored_polygon(PackedVector2Array([c + Vector2(12, -12), c + Vector2(5, -10), c + Vector2(10, -5)]), ink)
			if nm.contains("enflamm") or nm.contains("feu") or nm.contains("explos"):
				draw_colored_polygon(PackedVector2Array([c + Vector2(-7, 8), c + Vector2(-8, 0), c + Vector2(-2, 3), c + Vector2(1, -3), c + Vector2(3, 6)]), red)
			elif nm.contains("perçant") or nm.contains("percant"):
				draw_line(c + Vector2(-8, 11), c + Vector2(7, -4), blue, 2.0, true)
		elif nm.contains("lame") or nm.contains("épée") or nm.contains("epee") or nm.contains("coup") or nm.contains("assassin"):
			draw_line(c + Vector2(-9, 10), c + Vector2(8, -10), ink, 4.0, true)
			draw_line(c + Vector2(-12, 2), c + Vector2(-4, 10), Color(0.85, 0.65, 0.3) if usable else ink, 3.0, true)
			draw_line(c + Vector2(4, -5), c + Vector2(11, 2), blue, 2.0, true)
		elif nm.contains("appel") or nm.contains("meute") or nm.contains("invoc") or nm.contains("familier"):
			draw_circle(c + Vector2(-5, -4), 4.0, green)
			draw_circle(c + Vector2(5, -4), 4.0, green)
			draw_circle(c + Vector2(-8, -9), 2.8, green)
			draw_circle(c + Vector2(8, -9), 2.8, green)
			draw_colored_polygon(PackedVector2Array([c + Vector2(-10, 1), c + Vector2(-5, -2), c + Vector2(0, 1), c + Vector2(5, -2), c + Vector2(10, 1), c + Vector2(7, 10), c + Vector2(-7, 10)]), green)
		elif nm.contains("ombre") or nm.contains("invisib") or nm.contains("ténèbre") or nm.contains("tenebre"):
			draw_circle(c + Vector2(1, 1), 10.0, Color(0.72, 0.55, 1.0) if usable else ink)
			draw_circle(c + Vector2(6, -3), 8.0, Color(0.12, 0.12, 0.22))
			draw_circle(c + Vector2(-7, -8), 2.0, ink)
		elif nm.contains("bouclier") or nm.contains("protection") or nm.contains("armure"):
			draw_colored_polygon(PackedVector2Array([c + Vector2(0, -12), c + Vector2(10, -7), c + Vector2(8, 4), c + Vector2(0, 12), c + Vector2(-8, 4), c + Vector2(-10, -7)]), blue)
			draw_line(c + Vector2(-5, -1), c + Vector2(-1, 4), ink, 2.0, true)
			draw_line(c + Vector2(-1, 4), c + Vector2(6, -5), ink, 2.0, true)
		elif nm.contains("feu") or nm.contains("flamme") or nm.contains("brûl") or nm.contains("brul") or nm.contains("boule"):
			draw_colored_polygon(PackedVector2Array([c + Vector2(0, -13), c + Vector2(8, -2), c + Vector2(8, 5), c + Vector2(0, 12), c + Vector2(-8, 5), c + Vector2(-7, -3), c + Vector2(-2, -7)]), red)
			draw_colored_polygon(PackedVector2Array([c + Vector2(0, -3), c + Vector2(4, 4), c + Vector2(0, 9), c + Vector2(-3, 4)]), Color(1.0, 0.92, 0.5) if usable else ink)
		elif nm.contains("nature") or nm.contains("feuille") or nm.contains("racine") or nm.contains("arbre"):
			draw_colored_polygon(PackedVector2Array([c + Vector2(-10, 8), c + Vector2(-7, -5), c + Vector2(1, -12), c + Vector2(10, -8), c + Vector2(8, 2), c + Vector2(0, 9)]), green)
			draw_line(c + Vector2(-9, 10), c + Vector2(8, -9), Color(0.2, 0.45, 0.18) if usable else ink, 2.0, true)
		elif nm.contains("poison") or nm.contains("venin") or nm.contains("toxique"):
			draw_colored_polygon(PackedVector2Array([c + Vector2(0, -12), c + Vector2(8, 2), c + Vector2(5, 10), c + Vector2(-5, 10), c + Vector2(-8, 2)]), green)
			draw_circle(c + Vector2(-2, 2), 2.0, Color(0.15, 0.28, 0.12))
			draw_circle(c + Vector2(3, 5), 1.7, Color(0.15, 0.28, 0.12))
		elif nm.contains("téléport") or nm.contains("teleport") or nm.contains("transfert"):
			draw_arc(c, 10.0, 0.2, TAU - 0.2, 28, blue, 2.5, true)
			draw_colored_polygon(PackedVector2Array([c + Vector2(10, -8), c + Vector2(12, 0), c + Vector2(5, -2)]), blue)
			draw_colored_polygon(PackedVector2Array([c + Vector2(-4, -7), c + Vector2(1, -10), c + Vector2(0, -3)]), ink)
		elif nm.contains("terre") or nm.contains("pierre") or nm.contains("rocher") or nm.contains("tremblement"):
			draw_colored_polygon(PackedVector2Array([c + Vector2(-11, 9), c + Vector2(-8, -3), c + Vector2(-2, -11), c + Vector2(7, -8), c + Vector2(11, 9)]), Color(0.75, 0.57, 0.36) if usable else ink)
			draw_line(c + Vector2(-6, 1), c + Vector2(0, 5), Color(0.35, 0.25, 0.18) if usable else ink, 2.0, true)
		elif nm.contains("glace") or nm.contains("givre") or nm.contains("gel"):
			for i: int in range(3):
				var a: float = float(i) * PI / 3.0
				draw_line(c - Vector2(cos(a), sin(a)) * 11.0, c + Vector2(cos(a), sin(a)) * 11.0, blue, 2.2, true)
			draw_circle(c, 2.5, ink)
		elif nm.contains("foudre") or nm.contains("éclair") or nm.contains("eclair") or nm.contains("élect") or nm.contains("elect"):
			draw_colored_polygon(PackedVector2Array([c + Vector2(3, -13), c + Vector2(-7, 1), c + Vector2(-1, 1), c + Vector2(-4, 12), c + Vector2(9, -3), c + Vector2(2, -3)]), Color(1.0, 0.9, 0.35) if usable else ink)
		else:
			_icon(c, _elem, String(p.get("kind", "attack")))

	## Coupe un nom en 2 lignes max (au plus proche du milieu).
	func _wrap(t: String, max_chars: int) -> PackedStringArray:
		if t.length() <= max_chars or not t.contains(" "):
			return PackedStringArray([t])
		var words: PackedStringArray = t.split(" ")
		var best_i: int = 1
		var best_diff: int = 999
		for i: int in range(1, words.size()):
			var l1: int = " ".join(words.slice(0, i)).length()
			var l2: int = " ".join(words.slice(i)).length()
			if absi(l1 - l2) < best_diff:
				best_diff = absi(l1 - l2)
				best_i = i
		return PackedStringArray([" ".join(words.slice(0, best_i)), " ".join(words.slice(best_i))])


func _flat(bg: Color, border: Color, radius: int = 14, bw: int = 3) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = bg
	s.border_color = border
	s.set_border_width_all(bw)
	s.set_corner_radius_all(radius)
	s.shadow_color = Color(0, 0, 0, 0.45)
	s.shadow_size = 6
	return s


func _kind_color(spell: Dictionary) -> Color:
	## Code couleur uniforme :
	##   rouge = attaque, bleu = buff, vert = soin, jaune = debuff
	var p: Dictionary = Combat.parse(spell)
	var kind: String = String(p["kind"])
	if p["debuffs"].size() > 0 or spell.get("spell_type", "") == "Debuff":
		return Color(0.98, 0.82, 0.25)
	match kind:
		"heal":
			return Color(0.36, 0.78, 0.42)
		"buff":
			return Color(0.40, 0.60, 0.95)
		"summon", "teleport", "revive", "trap":
			return Color(0.40, 0.60, 0.95)
	return Color(0.92, 0.30, 0.25)


# ═══════════════════════════════════════════════════════════════════════════
#  Vues dessinées (timeline, panneau de personnage)
# ═══════════════════════════════════════════════════════════════════════════

class TimelineView extends Control:
	var gm: Node = null

	func _process(_d: float) -> void:
		queue_redraw()

	func _draw() -> void:
		if gm == null or gm.turn_order.is_empty():
			return
		var font: Font = ThemeDB.fallback_font
		# Ordre à partir de l'entité active
		var order: Array = []
		var start: int = 0
		for i: int in range(gm.turn_order.size()):
			if int(gm.turn_order[i]["uid"]) == int(gm.active_entity.get("uid", -1)):
				start = i
				break
		for k: int in range(gm.turn_order.size()):
			var e: Dictionary = gm.turn_order[(start + k) % gm.turn_order.size()]
			if gm.is_alive(e):
				order.append(e)
		# Colonne verticale : vignettes centrées, de haut en bas
		var total_h: float = 0.0
		for k: int in range(order.size()):
			total_h += (124.0 if k == 0 else 96.0) + 10.0
		var y: float = maxf(4.0, (size.y - total_h) * 0.5)
		for k: int in range(order.size()):
			var e2: Dictionary = order[k]
			var big: bool = (k == 0)
			var w: float = 124.0 if big else 96.0
			var x: float = (size.x - w) * 0.5
			var team_col: Color = Color(0.22, 0.45, 0.85)
			if e2["entity_type"] == "Summon":
				team_col = Color(0.25, 0.70, 0.45)
			elif e2["team"] == "enemy":
				team_col = Color(0.80, 0.22, 0.20)
			var bg := StyleBoxFlat.new()
			bg.bg_color = team_col.darkened(0.55)
			bg.border_color = Color(1.0, 0.85, 0.25) if big else team_col.lightened(0.15)
			bg.set_border_width_all(4 if big else 3)
			bg.set_corner_radius_all(14)
			bg.shadow_color = Color(0, 0, 0, 0.5)
			bg.shadow_size = 5
			var rect := Rect2(x, y, w, w)
			draw_style_box(bg, rect)
			var tex: Texture2D = Portraits.get_texture(e2)
			if tex != null:
				draw_texture_rect_region(tex, rect.grow(-6.0), Portraits.head_region(tex))
			else:
				var col: Color = e2.get("color", Color(0.6, 0.6, 0.6))
				draw_circle(rect.get_center(), w * 0.32, col)
				draw_string(font, rect.position + Vector2(0, w * 0.6), String(e2["classe"]).substr(0, 3), HORIZONTAL_ALIGNMENT_CENTER, w, 20, Color.WHITE)
			# Barre de vie
			var ratio: float = clampf(float(e2["current_pv"]) / maxf(1.0, float(e2["max_pv"])), 0.0, 1.0)
			var hb := Rect2(x + 4.0, y + w - 12.0, w - 8.0, 8.0)
			draw_rect(hb, Color(0, 0, 0, 0.8))
			draw_rect(Rect2(hb.position, Vector2(hb.size.x * ratio, hb.size.y)), Color(0.35, 0.9, 0.4) if e2["team"] == "player" else Color(0.95, 0.3, 0.25))
			if big:
				draw_string_outline(font, Vector2(x, y + w + 22.0), String(e2["classe"]), HORIZONTAL_ALIGNMENT_CENTER, w, 18, 5, Color(0, 0, 0, 0.9))
				draw_string(font, Vector2(x, y + w + 22.0), String(e2["classe"]), HORIZONTAL_ALIGNMENT_CENTER, w, 18, Color(1, 0.95, 0.75))
			y += w + 10.0


class StatsView extends Control:
	## Vignette du personnage actif (refonte V5) : grand portrait encadré, nom + classe,
	## barre de PV épaisse (graduations, couleur selon l'état), effets en cours avec durée,
	## gemmes hexagonales PA / PM et bandeau de tour.
	var gm: Node = null

	func _process(_d: float) -> void:
		queue_redraw()

	static func _hex(c: Vector2, r: float) -> PackedVector2Array:
		var pts := PackedVector2Array()
		for i: int in range(6):
			var a: float = PI / 6.0 + float(i) * TAU / 6.0
			pts.append(c + Vector2(cos(a), sin(a)) * r)
		return pts

	func _gem(c: Vector2, r: float, dark: Color, light: Color, text: String) -> void:
		var font: Font = ThemeDB.fallback_font
		draw_colored_polygon(_hex(c + Vector2(0, 3), r + 3.0), Color(0, 0, 0, 0.5))
		draw_colored_polygon(_hex(c, r + 3.0), Color(0.02, 0.03, 0.07))
		draw_colored_polygon(_hex(c, r), dark)
		draw_colored_polygon(_hex(c + Vector2(0, -2), r * 0.82), light)
		draw_colored_polygon(PackedVector2Array([c + Vector2(-r * 0.62, -r * 0.2), c + Vector2(-r * 0.2, -r * 0.8), c + Vector2(r * 0.3, -r * 0.8), c + Vector2(-r * 0.1, -r * 0.25)]), Color(1, 1, 1, 0.22))
		var fs: int = 28 if text.length() <= 1 else 23
		draw_string_outline(font, c + Vector2(-r, float(fs) * 0.36), text, HORIZONTAL_ALIGNMENT_CENTER, r * 2.0, fs, 6, Color(0, 0, 0, 0.92))
		draw_string(font, c + Vector2(-r, float(fs) * 0.36), text, HORIZONTAL_ALIGNMENT_CENTER, r * 2.0, fs, Color.WHITE)

	func _draw() -> void:
		if gm == null or gm.active_entity.is_empty():
			return
		var e: Dictionary = gm.active_entity
		var font: Font = ThemeDB.fallback_font
		var is_player: bool = e["team"] == "player"
		var team_col: Color = Color(0.36, 0.52, 0.85) if is_player else Color(0.85, 0.3, 0.28)
		# Cadre
		var bg := StyleBoxFlat.new()
		bg.bg_color = Color(0.05, 0.07, 0.12, 0.93)
		bg.border_color = team_col.lightened(0.1)
		bg.set_border_width_all(2)
		bg.set_corner_radius_all(20)
		bg.shadow_color = Color(0, 0, 0, 0.55)
		bg.shadow_size = 8
		draw_style_box(bg, Rect2(Vector2.ZERO, size))
		var tint := StyleBoxFlat.new()
		tint.bg_color = Color(team_col.r, team_col.g, team_col.b, 0.13)
		tint.set_corner_radius_all(18)
		draw_style_box(tint, Rect2(3, 3, size.x - 6, 46))
		# Portrait
		var pr := Rect2(12, 14, 100, 100)
		var halo := StyleBoxFlat.new()
		halo.bg_color = Color(team_col.r, team_col.g, team_col.b, 0.35)
		halo.set_corner_radius_all(20)
		halo.shadow_color = Color(team_col.r, team_col.g, team_col.b, 0.45)
		halo.shadow_size = 10
		draw_style_box(halo, pr.grow(2.0))
		var pbg := StyleBoxFlat.new()
		pbg.bg_color = team_col.darkened(0.6)
		pbg.border_color = Color(1, 0.84, 0.3)
		pbg.set_border_width_all(3)
		pbg.set_corner_radius_all(16)
		draw_style_box(pbg, pr)
		var tex: Texture2D = Portraits.get_texture(e)
		if tex != null:
			draw_texture_rect_region(tex, pr.grow(-5.0), Portraits.head_region(tex))
		else:
			draw_circle(pr.get_center(), 32.0, e.get("color", Color(0.6, 0.6, 0.6)))
		# Badge de niveau (coin bas-droit du portrait)
		var lvl: int = int(e.get("level", 1))
		var bc := Vector2(pr.end.x - 6.0, pr.end.y - 6.0)
		draw_circle(bc + Vector2(0, 2), 17.0, Color(0, 0, 0, 0.5))
		draw_circle(bc, 17.0, Color(0.02, 0.03, 0.07))
		draw_circle(bc, 14.5, Color(0.95, 0.72, 0.18))
		draw_circle(bc + Vector2(0, -1.5), 12.0, Color(1.0, 0.86, 0.38))
		draw_string(font, bc + Vector2(-15, 6), str(lvl), HORIZONTAL_ALIGNMENT_CENTER, 30.0, 17, Color(0.25, 0.14, 0.02))
		# Nom et classe
		var full: String = String(e["name"])
		var short: String = full.split(" Lv")[0]
		var sub: String = "Invocation" if e.get("entity_type", "") == "Summon" else String(e.get("classe", ""))
		draw_string_outline(font, Vector2(128, 36), short, HORIZONTAL_ALIGNMENT_LEFT, size.x - 140.0, 24, 5, Color(0, 0, 0, 0.92))
		draw_string(font, Vector2(128, 36), short, HORIZONTAL_ALIGNMENT_LEFT, size.x - 140.0, 24, Color(1, 0.95, 0.8))
		draw_string(font, Vector2(128, 56), "%s · niveau %d" % [sub, lvl], HORIZONTAL_ALIGNMENT_LEFT, size.x - 140.0, 14, Color(0.7, 0.78, 0.92))
		# Barre de PV
		var hb := Rect2(128, 66, size.x - 144.0, 26)
		var hpf: StyleBoxFlat = StyleBoxFlat.new()
		hpf.bg_color = Color(0.02, 0.03, 0.06, 0.95)
		hpf.border_color = Color(0.5, 0.6, 0.78, 0.9)
		hpf.set_border_width_all(2)
		hpf.set_corner_radius_all(9)
		draw_style_box(hpf, hb.grow(2.0))
		var ratio: float = clampf(float(e["current_pv"]) / maxf(1.0, float(e["max_pv"])), 0.0, 1.0)
		var fill_col: Color
		if not is_player:
			fill_col = Color(0.9, 0.28, 0.25)
		elif ratio > 0.5:
			fill_col = Color(0.30, 0.86, 0.36)
		elif ratio > 0.25:
			fill_col = Color(0.95, 0.74, 0.2)
		else:
			fill_col = Color(0.92, 0.28, 0.24)
		var fw: float = hb.size.x * ratio
		if fw > 1.0:
			var fl := StyleBoxFlat.new()
			fl.bg_color = fill_col.darkened(0.2)
			fl.set_corner_radius_all(7)
			draw_style_box(fl, Rect2(hb.position, Vector2(fw, hb.size.y)))
			var hi := StyleBoxFlat.new()
			hi.bg_color = fill_col.lightened(0.25)
			hi.set_corner_radius_all(6)
			draw_style_box(hi, Rect2(hb.position + Vector2(2, 2), Vector2(maxf(0.0, fw - 4.0), hb.size.y * 0.42)))
		for q: int in range(1, 4):
			var qx: float = hb.position.x + hb.size.x * float(q) * 0.25
			draw_line(Vector2(qx, hb.position.y + 3), Vector2(qx, hb.end.y - 3), Color(0, 0, 0, 0.35), 1.5)
		var hp_txt: String = "%d / %d" % [int(e["current_pv"]), int(e["max_pv"])]
		draw_string_outline(font, hb.position + Vector2(0, 19), hp_txt, HORIZONTAL_ALIGNMENT_CENTER, hb.size.x, 16, 4, Color(0, 0, 0, 0.92))
		draw_string(font, hb.position + Vector2(0, 19), hp_txt, HORIZONTAL_ALIGNMENT_CENTER, hb.size.x, 16, Color.WHITE)
		# Effets en cours
		var cx: float = 128.0
		var shown: int = 0
		for st: Dictionary in e.get("statuses", []):
			if shown >= 5:
				break
			var info: Dictionary = Combat.status_info(String(st["id"]))
			var label: String = "%s %d" % [String(info["label"]), int(st["turns"])]
			var cw: float = font.get_string_size(label, HORIZONTAL_ALIGNMENT_LEFT, -1, 12).x + 14.0
			var ccol: Color = info["color"]
			var chip := StyleBoxFlat.new()
			chip.bg_color = Color(ccol.r * 0.3, ccol.g * 0.3, ccol.b * 0.3, 0.95)
			chip.border_color = ccol
			chip.set_border_width_all(1)
			chip.set_corner_radius_all(9)
			draw_style_box(chip, Rect2(cx, 100, cw, 19))
			draw_string(font, Vector2(cx + 7, 114), label, HORIZONTAL_ALIGNMENT_LEFT, cw, 12, ccol.lightened(0.5))
			cx += cw + 4.0
			shown += 1
		# Gemmes PA / PM + bandeau de tour
		_gem(Vector2(150, 142), 21.0, Color(0.05, 0.25, 0.65), Color(0.2, 0.62, 1.0), "%d" % int(e["current_pa"]))
		draw_string_outline(font, Vector2(176, 138), "PA", HORIZONTAL_ALIGNMENT_LEFT, 30.0, 14, 4, Color(0, 0, 0, 0.9))
		draw_string(font, Vector2(176, 138), "PA", HORIZONTAL_ALIGNMENT_LEFT, 30.0, 14, Color(0.6, 0.8, 1.0))
		_gem(Vector2(236, 142), 21.0, Color(0.05, 0.4, 0.15), Color(0.25, 0.8, 0.35), "%d" % int(e["current_pm"]))
		draw_string_outline(font, Vector2(262, 138), "PM", HORIZONTAL_ALIGNMENT_LEFT, 30.0, 14, 4, Color(0, 0, 0, 0.9))
		draw_string(font, Vector2(262, 138), "PM", HORIZONTAL_ALIGNMENT_LEFT, 30.0, 14, Color(0.6, 1.0, 0.7))
		var mine: bool = gm.current_turn == 0
		var rest: String = "À vous" if mine else ("Auto…" if gm.auto_mode else "Adverse")
		var turn_box := StyleBoxFlat.new()
		turn_box.bg_color = Color(1, 0.8, 0.2, 0.16) if mine else Color(0.9, 0.3, 0.25, 0.16)
		turn_box.border_color = Color(1, 0.85, 0.4) if mine else Color(1, 0.55, 0.5)
		turn_box.set_border_width_all(1)
		turn_box.set_corner_radius_all(12)
		draw_style_box(turn_box, Rect2(size.x - 128, 126, 116, 32))
		draw_string(font, Vector2(size.x - 128, 139), "TOUR %d" % int(gm.turn_count), HORIZONTAL_ALIGNMENT_CENTER, 116.0, 13, Color(0.85, 0.9, 1.0))
		draw_string(font, Vector2(size.x - 128, 153), rest, HORIZONTAL_ALIGNMENT_CENTER, 116.0, 13, Color(1, 0.88, 0.45) if mine else Color(1, 0.6, 0.55))
		# Aide : pour les effets, un nom de classe sur la ligne du bas si l'entité n'a rien
		draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)

# ═══════════════════════════════════════════════════════════════════════════
#  Construction
# ═══════════════════════════════════════════════════════════════════════════

func init(manager: Node) -> void:
	if _initialized or manager == null:
		return
	_initialized = true
	game_manager = manager
	_spell_scale = MOBILE_SPELL_SCALE if _is_mobile() else 1.0
	# Le HUD doit toujours passer au-dessus des Node2D du plateau, y compris
	# après les changements de scène et sur les exports Android.
	layer = 20
	visible = true
	_grid = get_node_or_null("../GridManager")

	# Supprime les anciens contrôles statiques (Tour des joueurs, Joueur : -,
	# panneau de sorts vide, etc.). Les masquer ne suffisait pas dans toutes
	# les scènes héritées et pouvait laisser apparaître un HUD fantôme.
	for c: Node in get_children():
		remove_child(c)
		c.queue_free()

	_build_ui()
	_connect_signals()
	_refresh()


func _connect_signals() -> void:
	if not game_manager.turn_started.is_connected(_on_turn_started):
		game_manager.turn_started.connect(_on_turn_started)
	if not game_manager.state_changed.is_connected(_refresh):
		game_manager.state_changed.connect(_refresh)
	if not game_manager.spell_selected.is_connected(_on_spell_state):
		game_manager.spell_selected.connect(_on_spell_state)
	if not game_manager.message_requested.is_connected(_on_message):
		game_manager.message_requested.connect(_on_message)
	if not game_manager.game_ended.is_connected(_on_game_ended):
		game_manager.game_ended.connect(_on_game_ended)
	if not game_manager.fx.is_connected(_on_fx):
		game_manager.fx.connect(_on_fx)
	if _grid != null and _grid.has_signal("hover_changed") and not _grid.hover_changed.is_connected(_on_hover):
		_grid.hover_changed.connect(_on_hover)


func _on_hud_resized() -> void:
	# Relance le layout des contrôles ancrés après un changement de viewport.
	if _root == null:
		return
	_root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	if _timeline != null:
		_timeline.queue_redraw()
	if _stats != null:
		_stats.queue_redraw()


func _build_ui() -> void:
	_root = Control.new()
	_root.name = "HUD"
	_root.set_anchors_preset(Control.PRESET_FULL_RECT)
	_root.set_offsets_preset(Control.PRESET_FULL_RECT)
	_root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_root.visible = true
	_root.z_index = 1000
	add_child(_root)
	# Les contrôles de CanvasLayer n'héritent pas toujours de la taille attendue
	# lorsque le viewport est redimensionné par le mode stretch Android.
	_root.resized.connect(_on_hud_resized)

	# Timeline : colonne VERTICALE sur le bord droit, de haut en bas.
	# L'entité active est en tête (vignette agrandie), les suivantes en dessous.
	var tl := TimelineView.new()
	tl.gm = game_manager
	tl.mouse_filter = Control.MOUSE_FILTER_IGNORE
	tl.anchor_left = 1.0
	tl.anchor_right = 1.0
	tl.anchor_top = 0.0
	tl.anchor_bottom = 1.0
	tl.offset_left = -168.0
	tl.offset_right = -14.0
	tl.offset_top = 76.0
	tl.offset_bottom = -208.0
	_root.add_child(tl)
	_timeline = tl

	# Vignette du personnage actif : en haut à gauche, au-dessus du plateau
	var st := StatsView.new()
	st.gm = game_manager
	st.mouse_filter = Control.MOUSE_FILTER_IGNORE
	st.anchor_top = 0.0
	st.anchor_bottom = 0.0
	st.offset_left = 18.0
	st.offset_right = 458.0
	st.offset_top = 14.0
	st.offset_bottom = 198.0
	_root.add_child(st)
	_stats = st

	# Barre de sorts compacte en bas, sur une seule ligne (inspiration Dofus/Wakfu).
	# Les sorts supplémentaires restent accessibles par défilement horizontal.
	var badge_w: float = 86.0 * _spell_scale
	var badge_h: float = 58.0 * _spell_scale
	_spell_scroll = ScrollContainer.new()
	_spell_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	_spell_scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	_spell_scroll.anchor_left = 0.0
	_spell_scroll.anchor_right = 1.0
	_spell_scroll.anchor_top = 1.0
	_spell_scroll.anchor_bottom = 1.0
	_spell_scroll.offset_left = 240.0
	_spell_scroll.offset_right = -190.0
	_spell_scroll.offset_top = -(badge_h + 18.0)
	_spell_scroll.offset_bottom = -14.0
	_spell_scroll.mouse_filter = Control.MOUSE_FILTER_PASS
	var spell_panel := PanelContainer.new()
	spell_panel.anchor_left = 0.0
	spell_panel.anchor_right = 1.0
	spell_panel.anchor_top = 1.0
	spell_panel.anchor_bottom = 1.0
	spell_panel.offset_left = 232.0
	spell_panel.offset_right = -182.0
	spell_panel.offset_top = -(badge_h + 26.0)
	spell_panel.offset_bottom = -8.0
	spell_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	spell_panel.add_theme_stylebox_override("panel", _flat(Color(0.03, 0.05, 0.09, 0.30), Color(0.35, 0.48, 0.65, 0.35), 20, 1))
	_root.add_child(spell_panel)
	_root.add_child(_spell_scroll)
	# Une seule rangée de badges ; le ScrollContainer gère le débordement.
	_spell_box = HBoxContainer.new()
	_spell_box.add_theme_constant_override("separation", int(6.0 * _spell_scale))
	_spell_scroll.add_child(_spell_box)

	# Infobulle de sort
	_tip_panel = PanelContainer.new()
	_tip_panel.add_theme_stylebox_override("panel", _flat(Color(0.06, 0.08, 0.14, 0.95), Color(1, 0.85, 0.35), 14, 2))
	_tip_panel.anchor_left = 0.0
	_tip_panel.anchor_right = 0.0
	_tip_panel.anchor_top = 1.0
	_tip_panel.anchor_bottom = 1.0
	_tip_panel.offset_left = 240.0
	_tip_panel.offset_right = 240.0 + 440.0 * _spell_scale
	_tip_panel.offset_top = -(76.0 * _spell_scale * 2.0 + 24.0 + 150.0)
	_tip_panel.offset_bottom = -(76.0 * _spell_scale * 2.0 + 24.0 + 10.0)
	_tip_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_tip_panel.visible = false
	_tip_label = Label.new()
	_tip_label.add_theme_font_size_override("font_size", int(22.0 * _spell_scale))
	_tip_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_tip_label.custom_minimum_size = Vector2(420.0 * _spell_scale, 0)
	_tip_panel.add_child(_tip_label)
	_root.add_child(_tip_panel)

	# Bouton fin de tour
	_end_btn = Button.new()
	_end_btn.text = "FIN DU TOUR"
	_end_btn.add_theme_font_size_override("font_size", 18)
	_end_btn.add_theme_color_override("font_color", Color(0.25, 0.18, 0.08))
	_end_btn.add_theme_color_override("font_hover_color", Color(0.15, 0.1, 0.02))
	_end_btn.add_theme_stylebox_override("normal", _flat(Color(0.98, 0.86, 0.45), Color(0.72, 0.58, 0.28), 16, 3))
	_end_btn.add_theme_stylebox_override("hover", _flat(Color(1.0, 0.92, 0.6), Color(0.85, 0.68, 0.3), 16, 3))
	_end_btn.add_theme_stylebox_override("pressed", _flat(Color(0.9, 0.76, 0.35), Color(0.6, 0.48, 0.2), 16, 3))
	_end_btn.add_theme_stylebox_override("disabled", _flat(Color(0.12, 0.14, 0.2), Color(0.3, 0.35, 0.45), 16, 3))
	_end_btn.anchor_left = 1.0
	_end_btn.anchor_right = 1.0
	_end_btn.anchor_top = 0.0
	_end_btn.anchor_bottom = 0.0
	_end_btn.offset_left = -170.0
	_end_btn.offset_right = -14.0
	_end_btn.offset_top = 12.0
	_end_btn.offset_bottom = 60.0
	_end_btn.pressed.connect(func() -> void:
		Sfx.play("click")
		end_turn_requested.emit())
	_root.add_child(_end_btn)

	# Bouton de sortie sous la vignette du personnage actif.
	_quit_btn = _small_button("Quitter le combat", false)
	_quit_btn.custom_minimum_size = Vector2(220.0, 42.0)
	_quit_btn.add_theme_font_size_override("font_size", 17)
	_quit_btn.anchor_left = 0.0
	_quit_btn.anchor_right = 0.0
	_quit_btn.anchor_top = 0.0
	_quit_btn.anchor_bottom = 0.0
	_quit_btn.offset_left = 18.0
	_quit_btn.offset_right = 238.0
	_quit_btn.offset_top = 208.0
	_quit_btn.offset_bottom = 250.0
	_quit_btn.tooltip_text = "Quitter ce combat et revenir à la sélection d'équipe."
	_quit_btn.pressed.connect(_on_quit_combat_pressed)
	_root.add_child(_quit_btn)

	# Journal de combat
	_log_box = VBoxContainer.new()
	_log_box.add_theme_constant_override("separation", 2)
	_log_box.position = Vector2(300, 220)
	_log_box.size = Vector2(560, 300)
	_log_box.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_root.add_child(_log_box)

	# Bannière
	_banner = Label.new()
	_banner.add_theme_font_size_override("font_size", 64)
	_banner.add_theme_color_override("font_color", Color(1, 0.93, 0.6))
	_banner.add_theme_color_override("font_outline_color", Color(0.1, 0.05, 0.0, 0.95))
	_banner.add_theme_constant_override("outline_size", 14)
	_banner.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_banner.set_anchors_preset(Control.PRESET_CENTER_TOP)
	_banner.anchor_left = 0.0
	_banner.anchor_right = 1.0
	_banner.offset_top = 190.0
	_banner.offset_bottom = 290.0
	_banner.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_banner.modulate.a = 0.0
	_root.add_child(_banner)

	# Fiche de survol
	_info_panel = PanelContainer.new()
	_info_panel.add_theme_stylebox_override("panel", _flat(COL_PANEL, COL_BORDER, 14, 2))
	_info_panel.anchor_left = 1.0
	_info_panel.anchor_right = 1.0
	_info_panel.offset_left = -330.0 - 170.0
	_info_panel.offset_right = -20.0 - 170.0
	_info_panel.offset_top = 160.0
	_info_panel.offset_bottom = 330.0
	_info_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_info_panel.visible = false
	_info_label = Label.new()
	_info_label.add_theme_font_size_override("font_size", 18)
	_info_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_info_label.custom_minimum_size = Vector2(280, 0)
	_info_panel.add_child(_info_label)
	_root.add_child(_info_panel)

	# Écran de fin
	_over = ColorRect.new()
	_over.color = Color(0, 0, 0, 0.7)
	_over.set_anchors_preset(Control.PRESET_FULL_RECT)
	_over.visible = false
	_root.add_child(_over)
	var box := VBoxContainer.new()
	box.set_anchors_preset(Control.PRESET_CENTER)
	box.anchor_left = 0.5
	box.anchor_right = 0.5
	box.anchor_top = 0.5
	box.anchor_bottom = 0.5
	box.offset_left = -300.0
	box.offset_right = 300.0
	box.offset_top = -200.0
	box.offset_bottom = 200.0
	box.alignment = BoxContainer.ALIGNMENT_CENTER
	box.add_theme_constant_override("separation", 22)
	_over.add_child(box)
	_over_title = Label.new()
	_over_title.add_theme_font_size_override("font_size", 96)
	_over_title.add_theme_constant_override("outline_size", 16)
	_over_title.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.95))
	_over_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	box.add_child(_over_title)
	_over_sub = Label.new()
	_over_sub.add_theme_font_size_override("font_size", 28)
	_over_sub.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	box.add_child(_over_sub)
	var cont_btn: Button = _big_button("CONTINUER")
	if game_manager.active_save.is_empty() or game_manager.active_slot < 0:
		cont_btn.disabled = true
		cont_btn.tooltip_text = "Nécessite une partie active."
	cont_btn.pressed.connect(func() -> void:
		Sfx.play("click")
		get_tree().change_scene_to_file("res://scenes/TeamSelection.tscn"))
	box.add_child(cont_btn)
	var other: Button = _big_button("Changer d'équipe")
	other.pressed.connect(_on_team_selection_pressed)
	box.add_child(other)
	var saves_btn: Button = _big_button("Mes parties / Progression")
	saves_btn.pressed.connect(func() -> void:
		Sfx.play("click")
		get_tree().change_scene_to_file("res://scenes/SaveSlots.tscn"))
	box.add_child(saves_btn)


func _small_button(text: String, toggle: bool) -> Button:
	var b := Button.new()
	b.text = text
	b.toggle_mode = toggle
	b.custom_minimum_size = Vector2(86, 46)
	b.add_theme_font_size_override("font_size", 15)
	b.add_theme_stylebox_override("normal", _flat(Color(0.1, 0.13, 0.22, 0.92), Color(0.4, 0.5, 0.75), 12, 2))
	b.add_theme_stylebox_override("hover", _flat(Color(0.16, 0.2, 0.32, 0.95), Color(0.6, 0.75, 1.0), 12, 2))
	b.add_theme_stylebox_override("pressed", _flat(Color(0.5, 0.35, 0.08, 0.95), Color(1.0, 0.85, 0.3), 12, 2))
	return b


func _big_button(text: String) -> Button:
	var b := _small_button(text, false)
	b.custom_minimum_size = Vector2(380, 80)
	b.add_theme_font_size_override("font_size", 32)
	b.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	return b


# ═══════════════════════════════════════════════════════════════════════════
#  Mise à jour
# ═══════════════════════════════════════════════════════════════════════════

func _on_turn_started(e: Dictionary) -> void:
	_rebuild_spell_bar(e)
	var txt: String
	var col := Color(1, 0.93, 0.6)
	if e["entity_type"] == "Player" and not game_manager.auto_mode:
		txt = "%s — À vous de jouer !" % ProgressionManager.biome_label(game_manager.fight_biome)
		col = Color(0.65, 0.9, 1.0)
	else:
		txt = "Tour : %s" % e["name"]
		col = Color(1.0, 0.65, 0.55) if e["team"] == "enemy" else Color(0.7, 1.0, 0.75)
	_show_banner(txt, col)
	_refresh()


func _show_banner(text: String, col: Color) -> void:
	_banner.text = text
	_banner.add_theme_color_override("font_color", col)
	_banner.pivot_offset = Vector2(_banner.size.x * 0.5, 50.0)
	_banner.scale = Vector2(0.8, 0.8)
	_banner.modulate.a = 0.0
	var tw: Tween = create_tween()
	tw.tween_property(_banner, "modulate:a", 1.0, 0.15)
	tw.parallel().tween_property(_banner, "scale", Vector2.ONE, 0.2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tw.tween_interval(0.7)
	tw.tween_property(_banner, "modulate:a", 0.0, 0.35)


func _rebuild_spell_bar(e: Dictionary) -> void:
	for c: Node in _spell_box.get_children():
		c.queue_free()
	_cards = []
	_cards_owner = int(e["uid"])
	var idx: int = 0
	var ordered_spells: Array = e.get("spells", []).duplicate()
	ordered_spells.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
		var type_a: int = _spell_type_order(a)
		var type_b: int = _spell_type_order(b)
		if type_a != type_b:
			return type_a < type_b
		var req_a: int = int(a.get("level_required", a.get("required_level", 1)))
		var req_b: int = int(b.get("level_required", b.get("required_level", 1)))
		if req_a != req_b:
			return req_a < req_b
		var lvl_a: int = int(a.get("spell_level", 1))
		var lvl_b: int = int(b.get("spell_level", 1))
		if lvl_a != lvl_b:
			return lvl_a < lvl_b
		return String(a.get("name", "")) < String(b.get("name", "")))
	for spell: Dictionary in ordered_spells:
		idx += 1
		var card := SpellCard.new()
		card.spell = spell
		card.gm = game_manager
		card.hotkey = idx if idx <= 10 else 0
		card.base_col = _kind_color(spell)
		card.card_scale = _spell_scale
		card.badge_mode = true
		card.custom_minimum_size = Vector2(86.0 * _spell_scale, 58.0 * _spell_scale)
		card.text = ""
		card.tooltip_text = String(spell["name"]) + " · " + str(int(spell.get("cost_pa", 0))) + " PA" + (" · " + str(int(spell.get("cost_pm", 0))) + " PM" if int(spell.get("cost_pm", 0)) > 0 else "") + " · Portée " + str(int(spell.get("range", 1)))
		var nlen: int = String(spell["name"]).length()
		card.add_theme_font_size_override("font_size", 14 if nlen <= 10 else (12 if nlen <= 15 else 11))
		card.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		card.add_theme_constant_override("outline_size", 5)
		card.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.85))
		card.focus_mode = Control.FOCUS_NONE
		_style_card(card, false)
		card.pressed.connect(func() -> void: spell_selected.emit(spell))
		card.mouse_entered.connect(func() -> void: _show_tip(spell))
		card.mouse_exited.connect(func() -> void: _show_tip(game_manager.selected_spell))
		_spell_box.add_child(card)
		_cards.append(card)
	_spell_scroll.scroll_horizontal = 0
	_spell_scroll.scroll_vertical = 0


func _spell_type_order(spell: Dictionary) -> int:
	## Ordre stable par rôle tactique, puis niveau requis croissant.
	var kind: String = String(Combat.parse(spell).get("kind", "attack"))
	match kind:
		"attack": return 0
		"heal": return 1
		"buff": return 2
		"trap": return 3
		"summon": return 4
		"teleport": return 5
		"revive": return 6
		_: return 7


func _style_card(card: SpellCard, selected: bool) -> void:
	# Fond dégradé simulé (teinte du type en haut) ; la carte dessine elle-même ses détails.
	var tint: Color = card.base_col if card.usable else Color(0.45, 0.46, 0.50)
	var bg: Color = Color(0.07, 0.09, 0.15, 0.97).lerp(tint, 0.16 if card.usable else 0.05)
	var border: Color = Color(1.0, 0.88, 0.32) if selected else tint.darkened(0.15)
	card.add_theme_stylebox_override("normal", _card_box(bg, border, 3 if selected else 2))
	card.add_theme_stylebox_override("hover", _card_box(bg.lightened(0.10), Color(1, 1, 1, 0.85), 3))
	card.add_theme_stylebox_override("pressed", _card_box(bg.darkened(0.2), Color(1, 0.9, 0.3), 3))
	card.add_theme_stylebox_override("focus", _card_box(bg, border, 2))
	card.add_theme_stylebox_override("disabled", _card_box(bg.darkened(0.3), border, 2))


func _card_box(bg: Color, border: Color, bw: int) -> StyleBoxFlat:
	var sb: StyleBoxFlat = _flat(bg, border, 14, bw)
	sb.shadow_size = 5
	return sb


func _refresh() -> void:
	if game_manager == null or _root == null:
		return
	var e: Dictionary = game_manager.active_entity
	if not e.is_empty() and int(e["uid"]) != _cards_owner:
		_rebuild_spell_bar(e)
	var my_turn: bool = game_manager.current_turn == 0 and not game_manager.game_over
	for card: SpellCard in _cards:
		var usable: bool = false
		if not e.is_empty():
			usable = game_manager.can_afford(e, card.spell) and game_manager.casts_left(e, card.spell) > 0
		var sel: bool = game_manager.selected_spell != null and game_manager.selected_spell["name"] == card.spell["name"]
		if usable != card.usable or sel != card.selected:
			card.usable = usable
			card.selected = sel
			_style_card(card, sel)
		card.modulate = Color(1, 1, 1, 1.0 if my_turn else 0.5)
		card.queue_redraw()
	_end_btn.disabled = not my_turn
	# Réaffirmer la visibilité des couches de combat après chaque changement d'état.
	if is_instance_valid(_root):
		_root.visible = true
	if is_instance_valid(_timeline):
		_timeline.visible = true
		_timeline.queue_redraw()
	if is_instance_valid(_spell_scroll):
		_spell_scroll.visible = true
		_spell_scroll.queue_redraw()
	if is_instance_valid(_stats):
		_stats.visible = true
		_stats.queue_redraw()
	if _grid != null and _info_panel.visible and "hover_cell" in _grid:
		_on_hover(_grid.hover_cell)
	_spell_scroll.modulate = Color(1, 1, 1, 1.0)


func _on_spell_state(spell) -> void:
	_show_tip(spell)
	_refresh()


func _show_tip(spell) -> void:
	if spell == null:
		_tip_panel.visible = false
		return
	var p: Dictionary = Combat.parse(spell)
	var lines: Array[String] = []
	lines.append("%s" % spell["name"])
	var rng_txt: String = "Portée %d" % int(spell["range"]) if p["target"] != "self" else "Sur soi"
	var costs: String = "%d PA" % int(spell["cost_pa"])
	if int(spell.get("cost_pm", 0)) > 0:
		costs += " + %d PM" % int(spell["cost_pm"])
	lines.append("%s  ·  %s  ·  %d/tour" % [costs, rng_txt, Combat.max_casts(spell)])
	lines.append(Combat.describe(spell))
	var tip_lvl: int = int(spell.get("spell_level", 1))
	if tip_lvl > 1:
		lines.append("★ Niveau %d : +%d %% d'efficacité" % [tip_lvl, int(roundf((float(spell.get("mult", 1.0)) - 1.0) * 100.0))])
	if p["aoe"] == "zone":
		lines.append("Zone d'effet")
	if p["needs_los"]:
		lines.append("Ligne de vue requise")
	_tip_label.text = "\n".join(lines)
	_tip_panel.visible = true
	_tip_panel.reset_size()


func _on_message(text: String) -> void:
	if text == "" or _log_box == null:
		return
	var l := Label.new()
	l.text = text
	l.add_theme_font_size_override("font_size", 22)
	l.add_theme_color_override("font_color", Color(1, 1, 0.92))
	l.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.95))
	l.add_theme_constant_override("outline_size", 6)
	l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	l.custom_minimum_size = Vector2(540, 0)
	l.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_log_box.add_child(l)
	while _log_box.get_child_count() > 6:
		var old: Node = _log_box.get_child(0)
		_log_box.remove_child(old)
		old.queue_free()
	var tw: Tween = create_tween()
	tw.tween_interval(5.0)
	tw.tween_property(l, "modulate:a", 0.0, 1.2)
	tw.tween_callback(l.queue_free)


func _on_fx(kind: String, _d: Dictionary) -> void:
	if kind == "banner":
		_show_banner(String(_d.get("text", "")), Color(1, 0.9, 0.5))


func _on_hover(cell: Vector2i) -> void:
	if game_manager == null:
		return
	var e: Dictionary = game_manager.entity_at(cell)
	if e.is_empty():
		_info_panel.visible = false
		return
	var lines: Array[String] = [String(e["name"])]
	lines.append("PV %d / %d" % [int(e["current_pv"]), int(e["max_pv"])])
	lines.append("PA %d · PM %d · Déf %d" % [int(e["max_pa"]), int(e["max_pm"]), int(e["defense"])])
	for s: Dictionary in e["statuses"]:
		var info: Dictionary = Combat.status_info(String(s["id"]))
		var t: String = "" if int(s["turns"]) > 90 else " (%d t.)" % int(s["turns"])
		lines.append("• %s%s" % [info["label"], t])
	_info_label.text = "\n".join(lines)
	_info_panel.visible = true
	_info_panel.reset_size()


func _on_game_ended(victory: bool) -> void:
	await get_tree().create_timer(1.4).timeout
	if game_manager == null or not game_manager.game_over:
		return
	if not game_manager.active_save.is_empty() and not game_manager.active_save.get("last_result", {}).is_empty():
		_show_result_window(victory)
		return
	_show_game_over(victory)

func _show_game_over(victory: bool) -> void:
	Sfx.play("win" if victory else "lose")
	_over_title.text = "VICTOIRE !" if victory else "DÉFAITE"
	_over_title.add_theme_color_override("font_color", Color(1, 0.9, 0.35) if victory else Color(1, 0.35, 0.3))
	_over_sub.text = "Combat terminé en %d tours" % int(game_manager.turn_count)
	_over.visible = true
	_over.modulate.a = 0.0
	create_tween().tween_property(_over, "modulate:a", 1.0, 0.5)

## Fenêtre de résultat (XP, niveaux gagnés, nouveaux sorts, loots avec rareté),
## affichée avant l'écran de fin de combat.
func _show_result_window(victory: bool) -> void:
	var save: Dictionary = game_manager.active_save
	var res: Dictionary = save.get("last_result", {})
	var loots: Array = save.get("last_loots", []) if victory else []
	var panel := PanelContainer.new()
	panel.add_theme_stylebox_override("panel", _flat(Color(0.94, 0.89, 0.78, 0.97), Color(0.72, 0.58, 0.28), 16, 4))
	var dim: ColorRect = ColorRect.new()
	dim.color = Color(0, 0, 0, 0.45)
	dim.set_anchors_preset(Control.PRESET_FULL_RECT)
	dim.mouse_filter = Control.MOUSE_FILTER_STOP
	_root.add_child(dim)
	_root.add_child(panel)
	panel.grow_horizontal = Control.GROW_DIRECTION_BOTH
	panel.grow_vertical = Control.GROW_DIRECTION_BOTH
	panel.set_anchors_and_offsets_preset(Control.PRESET_CENTER, Control.PRESET_MODE_MINSIZE, 0)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 10)
	panel.add_child(box)

	var title := Label.new()
	var fight_no: int = ProgressionManager.next_fight_number(save)
	var next_biome: String = ProgressionManager.biome_for_fight(fight_no)
	var campaign_mode: String = String(save.get("campaign_mode", ""))
	if campaign_mode == "adventure":
		title.text = "DÉFI RÉUSSI — progression partagée !" if victory else "DÉFI ÉCHOUÉ — vous pourrez réessayer"
	elif campaign_mode == "conquest":
		title.text = "VILLE CONQUISE !" if victory else "ASSAUT REPOUSSÉ — la ville reste à l'ennemi"
	elif not victory:
		title.text = "DÉFAITE — un peu d'XP de consolation"
	elif ProgressionManager.is_boss_fight(save):
		title.text = "VICTOIRE !  %s : ☠ BOSS %s et ses sbires au combat %d !" % [ProgressionManager.biome_label(next_biome), ProgressionManager.biome_boss(next_biome), fight_no]
	else:
		title.text = ("VICTOIRE (combat rejoué) !  " if bool(res.get("replay", false)) else "VICTOIRE !  ") + "%s : ennemis niveau %d au prochain combat (%d)" % [ProgressionManager.biome_label(next_biome), ProgressionManager.enemy_level_for(save), fight_no]
	title.add_theme_font_size_override("font_size", 28)
	title.add_theme_color_override("font_color", Color(0.22, 0.15, 0.05) if victory else Color(0.55, 0.12, 0.08))
	box.add_child(title)

	var scroll := ScrollContainer.new()
	scroll.custom_minimum_size = Vector2(1100, 520)
	box.add_child(scroll)
	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 6)
	content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(content)

	# ── XP par personnage ───────────────────────────────────────────────
	var xp_rep: Dictionary = res.get("xp", {})
	var bench: Array[String] = []
	var total_pts: int = 0
	for classe: String in ProgressionManager.class_names():
		if not xp_rep.has(classe):
			continue
		var r: Dictionary = xp_rep[classe]
		if not bool(r.get("in_team", false)):
			bench.append("%s +%d" % [classe, int(r["gain"])])
			continue
		var line := Label.new()
		var up: bool = int(r["to_level"]) > int(r["from_level"])
		line.text = "  %s   +%d XP   niveau %d%s" % [classe, int(r["gain"]),
			int(r["to_level"]), "  ▲ (était %d)" % int(r["from_level"]) if up else ""]
		line.add_theme_font_size_override("font_size", 24 if up else 21)
		line.add_theme_color_override("font_color", Color(0.10, 0.45, 0.12) if up else Color(0.30, 0.22, 0.08))
		content.add_child(line)
		var bar := ProgressBar.new()
		bar.custom_minimum_size = Vector2(1000, 14)
		bar.min_value = 0.0
		bar.max_value = float(maxi(1, int(r["xp_next"]) - int(r["xp_cur"])))
		bar.value = clampf(float(int(r["xp"]) - int(r["xp_cur"])), 0.0, bar.max_value)
		bar.show_percentage = false
		content.add_child(bar)
		if int(r["points"]) > 0:
			total_pts += int(r["points"])
			var pl := Label.new()
			pl.text = "      ✦ +%d points de caractéristiques" % int(r["points"])
			pl.add_theme_font_size_override("font_size", 18)
			pl.add_theme_color_override("font_color", Color(0.15, 0.40, 0.55))
			content.add_child(pl)
		var spells: Array = r.get("spells", [])
		if not spells.is_empty():
			var sl := Label.new()
			sl.text = "      ★ Nouveau(x) sort(s) : %s" % ", ".join(PackedStringArray(spells))
			sl.add_theme_font_size_override("font_size", 18)
			sl.add_theme_color_override("font_color", Color(0.55, 0.30, 0.60))
			content.add_child(sl)
	if not bench.is_empty():
		var bl := Label.new()
		bl.text = "  Hors équipe : %s" % " · ".join(PackedStringArray(bench))
		bl.add_theme_font_size_override("font_size", 16)
		bl.add_theme_color_override("font_color", Color(0.45, 0.36, 0.2))
		content.add_child(bl)
	if total_pts > 0:
		var hint := Label.new()
		hint.text = "  (Les points sont répartis automatiquement ; changez cela dans « Personnages ».)"
		hint.add_theme_font_size_override("font_size", 15)
		hint.add_theme_color_override("font_color", Color(0.45, 0.36, 0.2))
		content.add_child(hint)

	# ── Loots ───────────────────────────────────────────────────────────
	if victory:
		var lbl := Label.new()
		lbl.text = "Objets gagnés (%d) :" % loots.size() if not loots.is_empty() else "Aucun loot cette fois..."
		lbl.add_theme_font_size_override("font_size", 22)
		lbl.add_theme_color_override("font_color", Color(0.22, 0.15, 0.05))
		content.add_child(lbl)
		for it: Dictionary in loots:
			var row := Label.new()
			var fx_txt: String = " · ".join(PackedStringArray(ItemRules.fx_lines(ItemRules.parse_effect(String(it.get("effect", ""))))))
			row.text = "  ✦ [%s] %s (nv%d) — %s%s" % [ItemRules.rarity_label(it), it.get("name", "?"), int(it.get("level", 0)),
				ItemRules.stat_line(it), ("  ✦ " + fx_txt) if fx_txt != "" else ""]
			row.tooltip_text = ItemRules.describe(it)
			row.mouse_filter = Control.MOUSE_FILTER_PASS
			row.add_theme_font_size_override("font_size", 19)
			row.add_theme_color_override("font_color", ItemRules.rarity_color(it).darkened(0.35))
			content.add_child(row)
		# Ressources de craft et or gagnés
		var drops: Dictionary = save.get("last_resources", {})
		if not drops.is_empty():
			var res_parts: PackedStringArray = []
			for k: String in drops.keys():
				res_parts.append("%s +%d" % [k, int(drops[k])])
			var res_row := Label.new()
			res_row.text = "  ⛏ Ressources : %s   ·   🪙 Or : %d" % [" · ".join(res_parts), ProgressionManager.gold(save)]
			res_row.add_theme_font_size_override("font_size", 19)
			res_row.add_theme_color_override("font_color", Color(0.35, 0.30, 0.15))
			res_row.tooltip_text = "À utiliser dans la FORGE (bouton ÉQUIPEMENT de la sélection d'équipe)."
			content.add_child(res_row)

	var cont := Button.new()
	var back_mode: String = String(save.get("campaign_mode", ""))
	if back_mode == "adventure":
		cont.text = "RETOUR À L'AVENTURE"
	elif back_mode == "conquest":
		cont.text = "RETOUR À LA CARTE DE CONQUÊTE"
	else:
		cont.text = "CONTINUER"
	cont.custom_minimum_size = Vector2(380, 66)
	cont.add_theme_font_size_override("font_size", 22)
	cont.add_theme_color_override("font_color", Color(0.22, 0.15, 0.05))
	cont.add_theme_stylebox_override("normal", _flat(Color(0.98, 0.86, 0.45), Color(0.72, 0.58, 0.28), 12, 3))
	cont.pressed.connect(func() -> void:
		dim.queue_free()
		panel.queue_free()
		if back_mode == "adventure":
			get_tree().change_scene_to_file("res://scenes/AdventureMap.tscn")
		elif back_mode == "conquest":
			get_tree().change_scene_to_file("res://scenes/ConquestMap.tscn")
		else:
			_show_game_over(victory))
	box.add_child(cont)


func hide_game_over_panel() -> void:
	if _over != null:
		_over.visible = false


func _on_spell_button_selected(spell: Dictionary) -> void:
	spell_selected.emit(spell)


func _on_quit_combat_pressed() -> void:
	Sfx.play("click")
	get_tree().change_scene_to_file("res://scenes/TeamSelection.tscn")


func _on_team_selection_pressed() -> void:
	var gm: Node = get_node_or_null("/root/GameManager")
	if gm and gm.has_method("clear_custom_team"):
		gm.clear_custom_team()
	get_tree().change_scene_to_file("res://scenes/TeamSelection.tscn")


func _unhandled_key_input(event: InputEvent) -> void:
	if game_manager == null or not (event is InputEventKey) or not event.pressed or event.echo:
		return
	var k: int = (event as InputEventKey).keycode
	if k == KEY_SPACE or k == KEY_ENTER or k == KEY_KP_ENTER:
		end_turn_requested.emit()
	elif k == KEY_ESCAPE:
		if game_manager.selected_spell != null:
			game_manager.selected_spell = null
			game_manager.spell_selected.emit(null)
	elif k >= KEY_1 and k <= KEY_9 or k == KEY_0:
		var i: int = (k - KEY_1) if k != KEY_0 else 9
		if i >= 0 and i < _cards.size():
			spell_selected.emit(_cards[i].spell)
