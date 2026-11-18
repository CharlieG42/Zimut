class_name JccCardView
extends Control
## JccCardView.gd — Une carte du mode Cartes, dessinée en vectoriel (main, plateau, collection, deck).
## Modes : « full » (carte complète avec texte), « board » (créature compacte sur une voie).

signal tapped(view: JccCardView)

const RARITY_COL := {"C": Color(0.78, 0.74, 0.62), "R": Color(0.38, 0.65, 1.0), "E": Color(0.76, 0.45, 0.98), "L": Color(1.0, 0.80, 0.25)}
const ART_ROOT := "res://assets/sprites/"

static var _tex_cache: Dictionary = {}

var card: Dictionary = {}
var board_mode: bool = false
var face_down: bool = false
var selected: bool = false
var target_ok: bool = false       # cible valide (liseré doré qui pulse)
var playable: bool = true         # carte jouable maintenant (sinon assombrie)
var ready_glow: bool = false      # créature qui peut agir (liseré vert)
var count_badge: int = 0          # exemplaires (collection) ; 0 = pas de pastille
var owned_dim: bool = false       # carte non possédée / indisponible
var _t: float = 0.0


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	set_process(true)


func _process(dt: float) -> void:
	_t += dt
	if target_ok or ready_glow or selected:
		queue_redraw()


## Liste défilante (collection) : le tap se déclenche au relâchement, sans bloquer le glissement.
var release_tap: bool = false
## Vrai pendant un glissement de défilement (posé par CardDeckBuilder) : supprime les taps.
static var drag_active: bool = false
var _press_pos: Vector2 = Vector2.ZERO
var _pressed_here: bool = false


func _gui_input(event: InputEvent) -> void:
	if not (event is InputEventMouseButton) or event.button_index != MOUSE_BUTTON_LEFT:
		return
	if not release_tap:
		if event.pressed:
			tapped.emit(self)
			accept_event()
		return
	if event.pressed:
		_press_pos = (event as InputEventMouseButton).global_position
		_pressed_here = true
	elif _pressed_here:
		_pressed_here = false
		if not drag_active and ((event as InputEventMouseButton).global_position - _press_pos).length() < 14.0:
			tapped.emit(self)


func set_card(c: Dictionary) -> void:
	card = c
	queue_redraw()


# ─── Textures ────────────────────────────────────────────────────────────────

static func art_texture(sprite: String) -> Texture2D:
	if sprite == "":
		return null
	if _tex_cache.has(sprite):
		return _tex_cache[sprite]
	var tex: Texture2D = null
	for ext: String in ["png", "svg"]:
		var path: String = "%s%s.%s" % [ART_ROOT, sprite, ext]
		if tex == null and ResourceLoader.exists(path):
			var res: Resource = load(path)
			if res is Texture2D:
				tex = res
	_tex_cache[sprite] = tex
	return tex


## Zone du sprite à montrer : le visage pour les héros (planches de personnages), tout le sprite sinon.
static func art_region(tex: Texture2D, sprite: String) -> Rect2:
	if sprite.begins_with("players/"):
		return Portraits.head_region(tex)
	return Rect2(Vector2.ZERO, tex.get_size())


# ─── Dessin ──────────────────────────────────────────────────────────────────

func _draw() -> void:
	var w: float = size.x
	var h: float = size.y
	if w < 10.0 or card.is_empty() and not face_down:
		return
	var font: Font = ThemeDB.fallback_font
	var rarity: String = String(card.get("rarity", "C"))
	var rcol: Color = RARITY_COL.get(rarity, RARITY_COL["C"])
	var is_spell: bool = String(card.get("type", "")) == "Sort"
	if face_down:
		_draw_back(w, h)
		return
	var base: Color = Color(0.20, 0.13, 0.30) if is_spell else Color(0.12, 0.19, 0.30)
	if rarity == "L":
		base = Color(0.30, 0.22, 0.08)
	var rad: int = 12 if w > 120.0 else 9
	var bg := StyleBoxFlat.new()
	bg.bg_color = base
	bg.border_color = rcol
	bg.set_border_width_all(6 if rarity == "L" else 4)
	bg.set_corner_radius_all(rad)
	bg.shadow_color = Color(0, 0, 0, 0.45)
	bg.shadow_size = 6
	draw_style_box(bg, Rect2(0, 0, w, h))
	if board_mode:
		_draw_board_body(w, h, font, rcol, is_spell, rad)
	else:
		# zone d'illustration
		var art_h: float = h * (0.50 if board_mode else 0.36)
		var art := Rect2(7, 7, w - 14, art_h)
		if not board_mode:
			art = Rect2(7, 32, w - 14, art_h)
		var art_col: Color = Color(0.08, 0.10, 0.16)
		draw_rect(art, art_col)
		_draw_art(art, is_spell, rcol)
		draw_rect(art, rcol.darkened(0.35), false, 2.0)
		# nom
		var name_txt: String = String(card.get("name", ""))
		var ny: float = art.end.y + (6.0 if board_mode else 4.0)
		var fs: int = int(clampf(w * (0.105 if board_mode else 0.095), 13.0, 22.0))
		while fs > 10 and font.get_string_size(name_txt, HORIZONTAL_ALIGNMENT_LEFT, -1, fs).x > w - 14.0:
			fs -= 1
		draw_rect(Rect2(5, ny, w - 10, fs + 8), Color(0, 0, 0, 0.45))
		draw_string(font, Vector2(0, ny + fs + 1), name_txt, HORIZONTAL_ALIGNMENT_CENTER, w, fs, Color(1, 0.97, 0.88))
		var y: float = ny + fs + 12.0
		if not board_mode:
			# type / rareté
			var kind: String = "Sort" if is_spell else ("Boss" if rarity == "L" else "Créature")
			var sub: String = "%s · %s" % [kind, JccCards.rarity_label(rarity)]
			draw_string(font, Vector2(0, y + 11), sub, HORIZONTAL_ALIGNMENT_CENTER, w, 12, rcol.lightened(0.15))
			y += 18.0
			var body: String = ""
			if is_spell:
				body = JccCards.effect_text(card)
			elif String(card.get("sort", "")) != "":
				body = "✦ %s (%d) : %s" % [card["sort"], int(card["sort_cost"]), JccCards.effect_text(card, true)]
			else:
				body = "Jeton"
			var avail: float = h - 50.0 - y
			var bfs: int = 15 if w >= 170.0 else 12
			while bfs > 9 and font.get_multiline_string_size(body, HORIZONTAL_ALIGNMENT_CENTER, w - 16, bfs).y > avail:
				bfs -= 1
			draw_multiline_string(font, Vector2(8, y + bfs), body, HORIZONTAL_ALIGNMENT_CENTER, w - 16, bfs, -1, Color(0.92, 0.90, 0.84))
		else:
			# pastille de sort disponible
			if String(card.get("sort", "")) != "":
				var pc := Vector2(w - 20, 22)
				var usable_sort: bool = ready_glow and not bool(card.get("used", false)) and not bool(card.get("sick", false))
				draw_circle(pc, 15, Color(0.25, 0.14, 0.40) if usable_sort else Color(0.16, 0.16, 0.20))
				draw_arc(pc, 15, 0, TAU, 20, Color(0.85, 0.6, 1.0) if usable_sort else Color(0.4, 0.4, 0.5), 2.0)
				_star(pc, 8.0, Color(0.95, 0.8, 1.0) if usable_sort else Color(0.5, 0.5, 0.6))
		# pastilles de valeurs
		var is_creature: bool = String(card.get("type", "")) != "Sort"
		if String(card.get("type", "")) != "Jeton":
			# gemme bleue = coût en mana (visible aussi sur le plateau)
			_gem(Vector2(20, 20), 13.0 if board_mode else 17.0, str(int(card.get("cost", 0))), Color(0.25, 0.50, 0.95))
		if is_creature:
			var gr: float = 18.0 if board_mode else 20.0
			_gem(Vector2(gr + 4, h - gr - 4), gr, str(int(card.get("atk", 0))), Color(0.92, 0.55, 0.15))
			var hp: int = int(card.get("hp", 0))
			var mx: int = int(card.get("max_hp", hp))
			var hcol: Color = Color(0.85, 0.20, 0.22)
			if board_mode and hp < mx:
				hcol = Color(0.55, 0.12, 0.14)
			_gem(Vector2(w - gr - 4, h - gr - 4), gr, str(hp), hcol)
			# PA / PM / PO lisibles sur chaque créature (plateau et main)
			var stats := [["PA", int(card.get("pa", 1)), Color(0.75, 0.45, 1.0)], ["PM", int(card.get("pm", 2)), Color(0.4, 0.8, 0.9)], ["PO", int(card.get("po", 1)), Color(0.5, 0.9, 0.5)]]
			if board_mode:
				var bx: float = w * 0.5 - 43.0
				for st in stats:
					var bc := Vector2(bx + 13.0, h - 16.0)
					draw_circle(bc, 13.0, Color(0.05, 0.05, 0.08))
					draw_arc(bc, 13.0, 0, TAU, 20, st[2], 2.0)
					draw_string(font, bc + Vector2(-12, 4), "%s%d" % [st[0], st[1]], HORIZONTAL_ALIGNMENT_LEFT, 26, 11, Color.WHITE)
					bx += 30.0
			else:
				var stxt: String = "PA %d · PM %d · PO %d" % [int(card.get("pa", 1)), int(card.get("pm", 2)), int(card.get("po", 1))]
				draw_string(font, Vector2(0, h - 44.0), stxt, HORIZONTAL_ALIGNMENT_CENTER, w, 14, Color(0.85, 0.9, 1.0))
		# statuts
		if board_mode:
			var sx: float = 8.0
			if int(card.get("stun", 0)) > 0:
				draw_string(font, Vector2(sx, art.position.y + 24), "ZZ", HORIZONTAL_ALIGNMENT_LEFT, -1, 22, Color(0.55, 0.85, 1.0))
				sx += 34.0
			var pn: int = 0
			for p: Variant in card.get("poison", []):
				pn += int((p as Dictionary)["n"])
			if pn > 0:
				var dc := Vector2(sx + 8, art.position.y + 16)
				draw_colored_polygon(PackedVector2Array([dc + Vector2(0, -10), dc + Vector2(7, 3), dc + Vector2(0, 9), dc + Vector2(-7, 3)]), Color(0.45, 0.9, 0.3))
				draw_string(font, dc + Vector2(11, 6), str(pn), HORIZONTAL_ALIGNMENT_LEFT, -1, 16, Color(0.7, 1.0, 0.5))
			if bool(card.get("sick", false)):
				draw_string(font, Vector2(0, art.end.y - 6), "zZ", HORIZONTAL_ALIGNMENT_CENTER, w, 16, Color(1, 1, 1, 0.65))
	# exemplaires
	if count_badge > 0:
		var bc := Vector2(w - 22, 20)
		draw_circle(bc, 15, Color(0.10, 0.10, 0.12))
		draw_arc(bc, 15, 0, TAU, 20, Color(0.95, 0.85, 0.5), 2.0)
		draw_string(font, bc + Vector2(-20, 7), "×%d" % count_badge, HORIZONTAL_ALIGNMENT_CENTER, 40, 16, Color(1, 0.92, 0.6))
	# assombrissement / liserés
	if not playable or owned_dim:
		draw_style_box(_veil(rad, 0.45 if owned_dim else 0.38), Rect2(0, 0, w, h))
	if ready_glow:
		draw_style_box(_outline(Color(0.4, 1.0, 0.45, 0.55 + 0.25 * sin(_t * 4.0)), rad, 4), Rect2(-2, -2, w + 4, h + 4))
	if target_ok:
		draw_style_box(_outline(Color(1.0, 0.85, 0.2, 0.65 + 0.35 * sin(_t * 7.0)), rad, 5), Rect2(-4, -4, w + 8, h + 8))
	if selected:
		draw_style_box(_outline(Color(1.0, 1.0, 1.0, 0.95), rad, 4), Rect2(-3, -3, w + 6, h + 6))



## Disposition large du plateau : illustration à gauche ; à droite le nom (jamais masqué),
## puis PA / PM / PO étiquetés, puis ATQ / PV. Valeurs courantes, grisées quand elles sont épuisées.
func _draw_board_body(w: float, h: float, font: Font, rcol: Color, is_spell: bool, rad: int) -> void:
	var art := Rect2(7, 7, h - 14.0, h - 14.0)
	draw_rect(art, Color(0.08, 0.10, 0.16))
	_draw_art(art, is_spell, rcol)
	draw_rect(art, rcol.darkened(0.35), false, 2.0)
	var x0: float = art.end.x + 8.0
	var has_sort: bool = String(card.get("sort", "")) != ""
	# nom
	var name_txt: String = String(card.get("name", ""))
	var nw: float = w - x0 - (40.0 if has_sort else 8.0)
	var fs: int = 20
	while fs > 11 and font.get_string_size(name_txt, HORIZONTAL_ALIGNMENT_LEFT, -1, fs).x > nw:
		fs -= 1
	draw_string(font, Vector2(x0, 10.0 + fs), name_txt, HORIZONTAL_ALIGNMENT_LEFT, nw, fs, Color(1, 0.97, 0.88))
	if has_sort:
		var pc := Vector2(w - 21, 20)
		var usable_sort: bool = ready_glow and not bool(card.get("used", false)) and not bool(card.get("sick", false))
		draw_circle(pc, 14, Color(0.25, 0.14, 0.40) if usable_sort else Color(0.16, 0.16, 0.20))
		draw_arc(pc, 14, 0, TAU, 20, Color(0.85, 0.6, 1.0) if usable_sort else Color(0.4, 0.4, 0.5), 2.0)
		_star(pc, 8.0, Color(0.95, 0.8, 1.0) if usable_sort else Color(0.5, 0.5, 0.6))
	# coût en mana
	if String(card.get("type", "")) != "Jeton":
		_gem(Vector2(20, 20), 13.0, str(int(card.get("cost", 0))), Color(0.25, 0.50, 0.95))
	if is_spell:
		return
	var pw: float = 56.0
	var stats := [
		["PA", int(card.get("pa", 1)), Color(0.75, 0.45, 1.0)],
		["PM", int(card.get("pm", 2)), Color(0.4, 0.8, 0.9)],
		["PO", int(card.get("po", 1)), Color(0.5, 0.9, 0.5)]]
	var px: float = x0
	for st in stats:
		var empty: bool = int(st[1]) <= 0
		var col: Color = st[2]
		var r := Rect2(px, 40.0, pw, 24.0)
		var sbx := StyleBoxFlat.new()
		sbx.bg_color = Color(0.04, 0.05, 0.08, 0.9)
		sbx.border_color = col.darkened(0.55) if empty else col
		sbx.set_border_width_all(2)
		sbx.set_corner_radius_all(8)
		draw_style_box(sbx, r)
		draw_string(font, Vector2(px, 40.0 + 17.0), "%s %d" % [st[0], st[1]], HORIZONTAL_ALIGNMENT_CENTER, pw, 15, Color(0.5, 0.5, 0.55) if empty else Color.WHITE)
		px += pw + 3.0
	# ATQ / PV
	var hp: int = int(card.get("hp", 0))
	var mx: int = int(card.get("max_hp", hp))
	var chips := [
		["ATQ", int(card.get("atk", 0)), Color(0.92, 0.55, 0.15)],
		["PV", hp, Color(0.85, 0.20, 0.22) if hp >= mx else Color(0.60, 0.14, 0.16)]]
	var cx: float = x0
	for ch in chips:
		var rr := Rect2(cx, 68.0, 82.0, 22.0)
		var cb := StyleBoxFlat.new()
		cb.bg_color = (ch[2] as Color).darkened(0.25)
		cb.set_corner_radius_all(8)
		draw_style_box(cb, rr)
		draw_string(font, Vector2(cx, 68.0 + 16.0), "%s %d" % [ch[0], ch[1]], HORIZONTAL_ALIGNMENT_CENTER, 82.0, 16, Color.WHITE)
		cx += 86.0
	# statuts : étourdi / poison / mal d'invocation (au-dessus de l'illustration)
	var sx: float = art.position.x + 4.0
	if int(card.get("stun", 0)) > 0 or bool(card.get("frozen", false)):
		draw_string(font, Vector2(sx, art.end.y - 6.0), "ZZ", HORIZONTAL_ALIGNMENT_LEFT, -1, 22, Color(0.55, 0.85, 1.0))
		sx += 32.0
	var pn: int = 0
	for p: Variant in card.get("poison", []):
		pn += int((p as Dictionary)["n"])
	if pn > 0:
		var dc := Vector2(sx + 8, art.end.y - 14.0)
		draw_colored_polygon(PackedVector2Array([dc + Vector2(0, -10), dc + Vector2(7, 3), dc + Vector2(0, 9), dc + Vector2(-7, 3)]), Color(0.45, 0.9, 0.3))
		draw_string(font, dc + Vector2(11, 6), str(pn), HORIZONTAL_ALIGNMENT_LEFT, -1, 16, Color(0.7, 1.0, 0.5))
	if bool(card.get("sick", false)):
		draw_string(font, Vector2(art.position.x, art.position.y + 16.0), "  zZ", HORIZONTAL_ALIGNMENT_RIGHT, art.size.x, 16, Color(1, 1, 1, 0.8))

func _veil(rad: int, a: float) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = Color(0, 0, 0, a)
	s.set_corner_radius_all(rad)
	return s


func _outline(col: Color, rad: int, bw: int) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = Color(0, 0, 0, 0)
	s.border_color = col
	s.set_border_width_all(bw)
	s.set_corner_radius_all(rad + 3)
	return s


func _draw_back(w: float, h: float) -> void:
	var s := StyleBoxFlat.new()
	s.bg_color = Color(0.16, 0.10, 0.26)
	s.border_color = Color(0.85, 0.65, 0.25)
	s.set_border_width_all(4)
	s.set_corner_radius_all(10)
	draw_style_box(s, Rect2(0, 0, w, h))
	var c := Vector2(w, h) * 0.5
	var r: float = minf(w, h) * 0.28
	draw_arc(c, r, 0, TAU, 32, Color(0.85, 0.65, 0.25, 0.8), 3.0)
	_star(c, r * 0.6, Color(0.85, 0.65, 0.25, 0.9))


func _gem(c: Vector2, r: float, val: String, col: Color) -> void:
	if c.x < 0.0:
		return
	var font: Font = ThemeDB.fallback_font
	draw_circle(c, r + 2.0, Color(0.05, 0.05, 0.08))
	draw_circle(c, r, col)
	draw_circle(c + Vector2(-r * 0.25, -r * 0.3), r * 0.45, Color(1, 1, 1, 0.18))
	draw_arc(c, r, 0, TAU, 24, col.lightened(0.45), 2.0)
	var fs: int = int(r * 1.15)
	draw_string(font, c + Vector2(-r, fs * 0.36), val, HORIZONTAL_ALIGNMENT_CENTER, r * 2.0, fs, Color(1, 1, 1))


func _star(c: Vector2, r: float, col: Color) -> void:
	var pts := PackedVector2Array()
	for i: int in 8:
		var a: float = float(i) * PI / 4.0 - PI / 2.0
		var rr: float = r if i % 2 == 0 else r * 0.45
		pts.append(c + Vector2(cos(a), sin(a)) * rr)
	draw_colored_polygon(pts, col)


func _draw_art(art: Rect2, is_spell: bool, rcol: Color) -> void:
	var sprite: String = String(card.get("sprite", ""))
	var tex: Texture2D = art_texture(sprite) if not is_spell else null
	if tex != null:
		var reg: Rect2 = art_region(tex, sprite)
		var k: float = minf(art.size.x / reg.size.x, art.size.y / reg.size.y)
		var dsz: Vector2 = reg.size * k
		draw_texture_rect_region(tex, Rect2(art.position + (art.size - dsz) * 0.5, dsz), reg)
		return
	# pas de sprite : emblème vectoriel selon l'effet (sorts) ou couronne (boss) / bouclier (créature)
	var kind: String = String(card.get("effet", ""))
	if not is_spell:
		kind = "boss" if String(card.get("rarity", "")) == "L" else "creature"
	draw_glyph(self, kind, art.get_center(), minf(art.size.x, art.size.y) * 0.36, rcol)


## Emblèmes vectoriels des effets (sorts) — remplaçables plus tard par des illustrations.
static func draw_glyph(ci: CanvasItem, kind: String, c: Vector2, r: float, col: Color) -> void:
	var dark: Color = col.darkened(0.45)
	match kind:
		"degats", "degats_heros":
			var pts := PackedVector2Array()
			for i: int in 12:
				var a: float = float(i) * TAU / 12.0 - PI / 2.0
				pts.append(c + Vector2(cos(a), sin(a)) * (r if i % 2 == 0 else r * 0.5))
			ci.draw_colored_polygon(pts, Color(1.0, 0.55, 0.15))
			ci.draw_circle(c, r * 0.35, Color(1.0, 0.92, 0.5))
		"degats_zone":
			for dx: float in [-0.9, 0.0, 0.9]:
				var cc: Vector2 = c + Vector2(dx * r * 0.85, (0.15 if dx == 0.0 else -0.1) * r)
				ci.draw_circle(cc, r * 0.42, Color(1.0, 0.5, 0.15))
				ci.draw_circle(cc, r * 0.2, Color(1.0, 0.9, 0.5))
		"soin", "soin_zone":
			var t: float = r * 0.30
			ci.draw_rect(Rect2(c.x - t, c.y - r, t * 2, r * 2), Color(0.35, 0.9, 0.45))
			ci.draw_rect(Rect2(c.x - r, c.y - t, r * 2, t * 2), Color(0.35, 0.9, 0.45))
			if kind == "soin_zone":
				ci.draw_arc(c, r * 1.2, 0, TAU, 28, Color(0.5, 1.0, 0.6, 0.6), 3.0)
		"atq", "atq_zone":
			ci.draw_line(c + Vector2(-r * 0.7, r * 0.7), c + Vector2(r * 0.7, -r * 0.7), Color(0.9, 0.92, 1.0), 7.0)
			ci.draw_line(c + Vector2(-r * 0.75, r * 0.2), c + Vector2(-r * 0.2, r * 0.75), Color(0.85, 0.6, 0.2), 6.0)
			ci.draw_line(c + Vector2(r * 0.7, -r * 0.7), c + Vector2(r * 0.2, -r * 1.0), Color(1, 0.95, 0.6), 3.0)
		"bouclier", "bouclier_zone":
			var sh := PackedVector2Array([c + Vector2(-r * 0.8, -r * 0.8), c + Vector2(r * 0.8, -r * 0.8), c + Vector2(r * 0.8, r * 0.1), c + Vector2(0, r), c + Vector2(-r * 0.8, r * 0.1)])
			ci.draw_colored_polygon(sh, Color(0.35, 0.6, 0.95))
			ci.draw_polyline(sh + PackedVector2Array([sh[0]]), Color(0.85, 0.93, 1.0), 3.0)
		"etourdir", "etourdir_zone":
			for i: int in 3:
				var a: float = float(i) * PI / 3.0
				ci.draw_line(c + Vector2(cos(a), sin(a)) * r, c - Vector2(cos(a), sin(a)) * r, Color(0.7, 0.9, 1.0), 5.0)
			ci.draw_circle(c, r * 0.22, Color(0.9, 0.97, 1.0))
		"poison":
			var dp := PackedVector2Array([c + Vector2(0, -r), c + Vector2(r * 0.7, r * 0.25), c + Vector2(0, r * 0.95), c + Vector2(-r * 0.7, r * 0.25)])
			ci.draw_colored_polygon(dp, Color(0.45, 0.9, 0.3))
			ci.draw_circle(c + Vector2(-r * 0.2, r * 0.1), r * 0.15, Color(0.85, 1.0, 0.7))
		"invoquer":
			ci.draw_arc(c, r, 0, TAU, 30, Color(0.7, 0.45, 1.0), 5.0)
			ci.draw_arc(c, r * 0.6, 0, TAU, 24, Color(0.85, 0.7, 1.0), 3.0)
			ci.draw_circle(c, r * 0.2, Color(0.95, 0.9, 1.0))
		"pioche":
			ci.draw_rect(Rect2(c.x - r * 0.7, c.y - r * 0.8, r * 0.9, r * 1.4), Color(0.75, 0.55, 1.0))
			ci.draw_rect(Rect2(c.x - r * 0.2, c.y - r * 0.6, r * 0.9, r * 1.4), Color(0.9, 0.8, 1.0))
		"mana":
			var dm := PackedVector2Array([c + Vector2(0, -r), c + Vector2(r * 0.6, 0), c + Vector2(0, r), c + Vector2(-r * 0.6, 0)])
			ci.draw_colored_polygon(dm, Color(0.35, 0.65, 1.0))
			ci.draw_polyline(dm + PackedVector2Array([dm[0]]), Color(0.85, 0.95, 1.0), 3.0)
		"boss":
			var cr := PackedVector2Array([c + Vector2(-r, r * 0.6), c + Vector2(-r, -r * 0.5), c + Vector2(-r * 0.5, 0), c + Vector2(0, -r * 0.9), c + Vector2(r * 0.5, 0), c + Vector2(r, -r * 0.5), c + Vector2(r, r * 0.6)])
			ci.draw_colored_polygon(cr, col)
			ci.draw_polyline(cr + PackedVector2Array([cr[0]]), dark, 3.0)
		_:
			ci.draw_circle(c, r * 0.8, col.darkened(0.2))
			ci.draw_arc(c, r * 0.8, 0, TAU, 24, col.lightened(0.3), 3.0)
