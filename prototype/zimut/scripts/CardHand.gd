extends Control
## CardHand.gd — Interface du mode « Cartes tactiques » (V401, refonte Krosmaga).
##
## Remplace la colonne de badges de sorts par une vraie main de cartes :
##   • la main en éventail au bas de l'écran (cadre, gemme de coût, illustration du sort, nom,
##     type, texte d'effet, portée) ; la carte survolée ou choisie se redresse et se soulève ;
##   • la pioche (en bas à gauche) et la défausse (en bas à droite), avec leur nombre de cartes —
##     un appui ouvre leur contenu ;
##   • le mana commun du camp en colonne de cristaux à gauche (rempli / dépensé / à venir) ;
##   • les animations : une carte piochée glisse depuis la pioche, une carte jouée file vers la défausse.
## Ce contrôle couvre tout l'écran mais ne « capte » que les cartes et les piles (_has_point) : le
## plateau reste cliquable partout ailleurs. Il ne connaît pas l'interface : il émet card_chosen(spell)
## et UIManager le branche sur spell_selected, comme les anciens badges.

signal card_chosen(spell: Dictionary)
signal pile_pressed(which: String)

const CW := 124.0          # taille logique d'une carte
const CH := 184.0
const LIFT := 70.0         # hauteur dont une carte se soulève (survol / choix)
const CRYSTALS := 10
const GOLD := Color(1.0, 0.85, 0.40)

var gm: Node = null
var _cards: Array = []     # {uid, spell, pos, rot, sc, alpha, tpos, trot, tsc}
var _ghosts: Array = []    # cartes jouées en route vers la défausse
var _hover_uid: int = -1
var _mana: int = 0
var _mana_max: int = 3
var _deck_n: int = 0
var _discard_n: int = 0
var _enemy_hand_n: int = 0
var _my_turn: bool = false
var _t: float = 0.0
var _press_uid: int = -1


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP
	focus_mode = Control.FOCUS_NONE
	resized.connect(_layout_targets)


# ── Géométrie ───────────────────────────────────────────────────────────────

func _k() -> float:
	return clampf(size.y / 1080.0, 0.6, 1.3)


func _deck_pos() -> Vector2:
	return Vector2(80.0 * _k() + 10.0, size.y - 110.0 * _k())


func _discard_pos() -> Vector2:
	return Vector2(size.x - 90.0 * _k() - 10.0, size.y - 110.0 * _k())


## Cibles de chaque carte de la main : éventail centré, carte active soulevée.
func _layout_targets() -> void:
	var n: int = _cards.size()
	if n == 0:
		return
	var k: float = _k()
	var step: float = minf(CW * 0.84 * k, (size.x * 0.46) / float(maxi(n - 1, 1)))
	var mid: float = float(n - 1) * 0.5
	var base_y: float = size.y - CH * k * 0.5 - 16.0 * k
	for i: int in range(n):
		var c: Dictionary = _cards[i]
		var f: float = float(i) - mid
		var lift: bool = int(c["uid"]) == _hover_uid or _is_selected(int(c["uid"]))
		var tp := Vector2(size.x * 0.5 + f * step, base_y + f * f * 3.2 * k)
		var tr: float = f * 0.045
		var ts: float = k
		if lift:
			tp.y -= LIFT * k
			tr = 0.0
			ts = k * 1.12
		c["tpos"] = tp
		c["trot"] = tr
		c["tsc"] = ts


func _is_selected(uid: int) -> bool:
	if gm == null or gm.selected_spell == null:
		return false
	return int((gm.selected_spell as Dictionary).get("card_uid", -2)) == uid


# ── État ────────────────────────────────────────────────────────────────────

## Relit l'état du combat (appelé à chaque changement d'état par UIManager).
func refresh() -> void:
	if gm == null:
		return
	var st: Dictionary = gm.card_state("player")
	if st.is_empty():
		return
	var hand: Array = st["hand"]
	var seen: Dictionary = {}
	var fresh_cards: Array = []
	for card: Dictionary in hand:
		var uid: int = int(card.get("card_uid", -1))
		seen[uid] = true
		var existing: Dictionary = _find(uid)
		if existing.is_empty():
			existing = {"uid": uid, "pos": _deck_pos(), "rot": -0.5, "sc": 0.3 * _k(), "alpha": 0.0,
				"tpos": _deck_pos(), "trot": 0.0, "tsc": _k()}
		existing["spell"] = gm.card_to_spell(card)
		fresh_cards.append(existing)
	# cartes qui ont quitté la main : elles filent vers la défausse
	for old: Dictionary in _cards:
		if not seen.has(int(old["uid"])):
			old["tpos"] = _discard_pos()
			old["tsc"] = 0.28 * _k()
			old["trot"] = 0.6
			old["fade"] = true
			_ghosts.append(old)
	_cards = fresh_cards
	_mana = int(st["mana"])
	_mana_max = int(st["mana_max"])
	_deck_n = (st["deck"] as Array).size()
	_discard_n = (st["discard"] as Array).size()
	var est: Dictionary = gm.card_state("enemy")
	_enemy_hand_n = (est.get("hand", []) as Array).size() if not est.is_empty() else 0
	var e: Dictionary = gm.active_entity
	_my_turn = gm.current_turn == 0 and not gm.game_over and not e.is_empty() and String(e.get("team", "")) == "player"
	_layout_targets()
	queue_redraw()


func _find(uid: int) -> Dictionary:
	for c: Dictionary in _cards:
		if int(c["uid"]) == uid:
			return c
	return {}


func _usable(c: Dictionary) -> bool:
	if gm == null or not _my_turn:
		return false
	var e: Dictionary = gm.active_entity
	var sp: Dictionary = c["spell"]
	return gm.can_afford(e, sp) and gm.casts_left(e, sp) > 0


func _process(dt: float) -> void:
	_t += dt
	var a: float = 1.0 - exp(-13.0 * dt)
	for c: Dictionary in _cards:
		c["pos"] = (c["pos"] as Vector2).lerp(c["tpos"] as Vector2, a)
		c["rot"] = lerpf(float(c["rot"]), float(c["trot"]), a)
		c["sc"] = lerpf(float(c["sc"]), float(c["tsc"]), a)
		c["alpha"] = lerpf(float(c["alpha"]), 1.0, 1.0 - exp(-9.0 * dt))
	var i: int = _ghosts.size() - 1
	while i >= 0:
		var g: Dictionary = _ghosts[i]
		g["pos"] = (g["pos"] as Vector2).lerp(g["tpos"] as Vector2, 1.0 - exp(-9.0 * dt))
		g["rot"] = lerpf(float(g["rot"]), float(g["trot"]), a)
		g["sc"] = lerpf(float(g["sc"]), float(g["tsc"]), a)
		g["alpha"] = float(g["alpha"]) - dt * 1.5
		if float(g["alpha"]) <= 0.02 or (g["pos"] as Vector2).distance_to(g["tpos"] as Vector2) < 6.0:
			_ghosts.remove_at(i)
		i -= 1
	queue_redraw()


# ── Saisie ──────────────────────────────────────────────────────────────────

## Carte sous le point (la plus à droite d'abord : elle est dessinée par-dessus), ou {}.
func _card_at(p: Vector2) -> Dictionary:
	var order: Array = _cards.duplicate()
	# la carte soulevée est dessinée en dernier : elle a la priorité
	order.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
		return _z(a) < _z(b))
	for j: int in range(order.size() - 1, -1, -1):
		var c: Dictionary = order[j]
		var sc: float = float(c["sc"])
		var local: Vector2 = (p - (c["pos"] as Vector2)).rotated(-float(c["rot"])) / maxf(sc, 0.01)
		if absf(local.x) <= CW * 0.5 and absf(local.y) <= CH * 0.5:
			return c
	return {}


func _z(c: Dictionary) -> int:
	return 1000 if int(c["uid"]) == _hover_uid or _is_selected(int(c["uid"])) else _cards.find(c)


func _pile_at(p: Vector2) -> String:
	var k: float = _k()
	if p.distance_to(_deck_pos()) <= 62.0 * k:
		return "deck"
	if p.distance_to(_discard_pos()) <= 62.0 * k:
		return "discard"
	return ""


func _has_point(p: Vector2) -> bool:
	return not _card_at(p).is_empty() or _pile_at(p) != ""


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var h: Dictionary = _card_at((event as InputEventMouseMotion).position)
		var uid: int = int(h["uid"]) if not h.is_empty() else -1
		if uid != _hover_uid:
			_hover_uid = uid
			_layout_targets()
			if not h.is_empty() and gm != null:
				_show_tip(h["spell"])
	elif event is InputEventMouseButton or event is InputEventScreenTouch:
		var pressed: bool = (event as InputEventMouseButton).pressed if event is InputEventMouseButton else (event as InputEventScreenTouch).pressed
		var pos: Vector2 = (event as InputEventMouseButton).position if event is InputEventMouseButton else (event as InputEventScreenTouch).position
		if event is InputEventMouseButton and (event as InputEventMouseButton).button_index != MOUSE_BUTTON_LEFT:
			return
		if pressed:
			var h2: Dictionary = _card_at(pos)
			_press_uid = int(h2["uid"]) if not h2.is_empty() else -1
		else:
			var h3: Dictionary = _card_at(pos)
			if not h3.is_empty() and int(h3["uid"]) == _press_uid:
				_choose(h3)
				accept_event()
			elif h3.is_empty():
				var pile: String = _pile_at(pos)
				if pile != "":
					pile_pressed.emit(pile)
					accept_event()
			_press_uid = -1


func _show_tip(spell: Dictionary) -> void:
	var ui: Node = get_parent().get_parent() if get_parent() != null else null
	if ui != null and ui.has_method("_show_tip"):
		ui.call("_show_tip", spell)


func _choose(c: Dictionary) -> void:
	if not _usable(c):
		return
	card_chosen.emit(c["spell"])
	_layout_targets()


func _unhandled_input(event: InputEvent) -> void:
	if not (event is InputEventKey) or not (event as InputEventKey).pressed or (event as InputEventKey).echo:
		return
	var kc: int = (event as InputEventKey).keycode
	if kc >= KEY_1 and kc <= KEY_9:
		var i: int = kc - KEY_1
		if i < _cards.size():
			_choose(_cards[i])
			get_viewport().set_input_as_handled()


# ── Dessin ──────────────────────────────────────────────────────────────────

func _draw() -> void:
	if gm == null:
		return
	_draw_mana()
	_draw_pile(_deck_pos(), "PIOCHE", _deck_n, Color(0.30, 0.45, 0.80))
	_draw_pile(_discard_pos(), "DÉFAUSSE", _discard_n, Color(0.55, 0.38, 0.62))
	if _enemy_hand_n > 0:
		_draw_enemy_hand()
	for g: Dictionary in _ghosts:
		_draw_card(g, false, false)
	var order: Array = _cards.duplicate()
	order.sort_custom(func(a: Dictionary, b: Dictionary) -> bool: return _z(a) < _z(b))
	for c: Dictionary in order:
		_draw_card(c, _usable(c), _is_selected(int(c["uid"])))


## Colonne de mana : cristaux du bas vers le haut ; pleins (disponibles), creux (dépensés),
## sombres (pas encore débloqués : +1 par manche).
func _draw_mana() -> void:
	var k: float = _k()
	var font: Font = ThemeDB.fallback_font
	var x: float = 52.0 * k
	var y_top: float = 300.0 * k
	var y_bot: float = size.y - 215.0 * k
	var slot: float = (y_bot - y_top) / float(CRYSTALS)
	var r: float = minf(slot * 0.40, 24.0 * k)
	draw_string_outline(font, Vector2(x - 40.0 * k, y_top - 34.0 * k), "MANA", HORIZONTAL_ALIGNMENT_CENTER, 80.0 * k, int(17.0 * k), 5, Color(0, 0, 0, 0.9))
	draw_string(font, Vector2(x - 40.0 * k, y_top - 34.0 * k), "MANA", HORIZONTAL_ALIGNMENT_CENTER, 80.0 * k, int(17.0 * k), Color(0.7, 0.88, 1.0))
	var num: String = "%d/%d" % [_mana, _mana_max]
	draw_string_outline(font, Vector2(x - 40.0 * k, y_top - 8.0 * k), num, HORIZONTAL_ALIGNMENT_CENTER, 80.0 * k, int(26.0 * k), 6, Color(0, 0, 0, 0.95))
	draw_string(font, Vector2(x - 40.0 * k, y_top - 8.0 * k), num, HORIZONTAL_ALIGNMENT_CENTER, 80.0 * k, int(26.0 * k), Color.WHITE)
	for i: int in range(CRYSTALS):
		var c := Vector2(x, y_bot - slot * (float(i) + 0.5))
		var pts := PackedVector2Array([c + Vector2(0, -r * 1.25), c + Vector2(r * 0.85, 0), c + Vector2(0, r * 1.25), c + Vector2(-r * 0.85, 0)])
		if i < _mana:
			var pulse: float = 0.5 + 0.5 * sin(_t * 3.0 + float(i) * 0.6)
			draw_circle(c, r * (1.7 + 0.15 * pulse), Color(0.3, 0.6, 1.0, 0.16))
			draw_colored_polygon(pts, Color(0.30, 0.66, 1.0))
			draw_colored_polygon(PackedVector2Array([pts[0], c + Vector2(r * 0.42, -r * 0.15), c + Vector2(-r * 0.15, -r * 0.1)]), Color(1, 1, 1, 0.65))
			draw_polyline(pts + PackedVector2Array([pts[0]]), Color(0.85, 0.95, 1.0), 2.0, true)
		elif i < _mana_max:
			draw_colored_polygon(pts, Color(0.10, 0.17, 0.30, 0.65))
			draw_polyline(pts + PackedVector2Array([pts[0]]), Color(0.45, 0.65, 0.95, 0.95), 2.0, true)
		else:
			draw_polyline(pts + PackedVector2Array([pts[0]]), Color(0.45, 0.50, 0.62, 0.45), 1.5, true)


func _draw_pile(c: Vector2, title: String, n: int, col: Color) -> void:
	var k: float = _k()
	var font: Font = ThemeDB.fallback_font
	var w: float = 70.0 * k
	var h: float = 98.0 * k
	for i: int in range(mini(3, maxi(1, n))):
		var o := Vector2(float(i) * -3.0, float(i) * -3.0) * k
		var r := Rect2(c - Vector2(w, h) * 0.5 + o, Vector2(w, h))
		draw_style_box(_box(Color(0.10, 0.12, 0.20), col.lightened(0.15), 8, 3), r)
	if n > 0:
		var r2 := Rect2(c - Vector2(w, h) * 0.5 + Vector2(-6, -6) * k, Vector2(w, h))
		draw_rect(Rect2(r2.position + Vector2(8, 8) * k, r2.size - Vector2(16, 16) * k), col.darkened(0.35))
		draw_circle(r2.get_center(), 14.0 * k, col.lightened(0.2))
		draw_circle(r2.get_center(), 8.0 * k, col.darkened(0.4))
	var num: String = str(n)
	draw_string_outline(font, c + Vector2(-w * 0.5, 9.0 * k), num, HORIZONTAL_ALIGNMENT_CENTER, w, int(34.0 * k), 8, Color(0, 0, 0, 0.95))
	draw_string(font, c + Vector2(-w * 0.5, 9.0 * k), num, HORIZONTAL_ALIGNMENT_CENTER, w, int(34.0 * k), Color.WHITE)
	draw_string_outline(font, c + Vector2(-w, h * 0.5 + 24.0 * k), title, HORIZONTAL_ALIGNMENT_CENTER, w * 2.0, int(15.0 * k), 5, Color(0, 0, 0, 0.9))
	draw_string(font, c + Vector2(-w, h * 0.5 + 24.0 * k), title, HORIZONTAL_ALIGNMENT_CENTER, w * 2.0, int(15.0 * k), col.lightened(0.55))


func _draw_enemy_hand() -> void:
	var k: float = _k()
	var font: Font = ThemeDB.fallback_font
	var p: Vector2 = _discard_pos() + Vector2(0, -92.0 * k)
	var txt: String = "Ennemi : %d carte%s" % [_enemy_hand_n, "s" if _enemy_hand_n > 1 else ""]
	draw_string_outline(font, p + Vector2(-90.0 * k, 0), txt, HORIZONTAL_ALIGNMENT_CENTER, 180.0 * k, int(15.0 * k), 5, Color(0, 0, 0, 0.9))
	draw_string(font, p + Vector2(-90.0 * k, 0), txt, HORIZONTAL_ALIGNMENT_CENTER, 180.0 * k, int(15.0 * k), Color(1.0, 0.72, 0.65))


## Traduction via l'autoload Loc (lu dans l'arbre : le script se charge aussi sans autoloads, en test).
static func _tr(txt: String) -> String:
	var tree := Engine.get_main_loop() as SceneTree
	var l: Node = tree.root.get_node_or_null("Loc") if tree != null else null
	return String(l.call("t", txt)) if l != null else txt


static func _box(bg: Color, border: Color, radius: int, bw: int) -> StyleBoxFlat:
	var sb := StyleBoxFlat.new()
	sb.bg_color = bg
	sb.border_color = border
	sb.set_border_width_all(bw)
	sb.set_corner_radius_all(radius)
	return sb


## Couleur du type de carte : rouge = attaque, vert = soin, bleu = renfort, violet = invocation, jaune = affaiblissement.
static func kind_color(spell: Dictionary) -> Color:
	var p: Dictionary = Combat.parse(spell)
	if (p["debuffs"] as Array).size() > 0:
		return Color(0.95, 0.78, 0.25)
	match String(p["kind"]):
		"heal":
			return Color(0.32, 0.74, 0.40)
		"buff":
			return Color(0.36, 0.58, 0.95)
		"summon", "teleport", "revive", "trap", "glyph":
			return Color(0.66, 0.42, 0.92)
		_:
			return Color(0.88, 0.34, 0.30)


static func kind_label(spell: Dictionary) -> String:
	var p: Dictionary = Combat.parse(spell)
	var lbl: String
	match String(p["kind"]):
		"heal":
			lbl = "SOIN"
		"buff":
			lbl = "RENFORT"
		"summon":
			lbl = "INVOCATION"
		"teleport":
			lbl = "DÉPLACEMENT"
		"trap", "glyph":
			lbl = "PIÈGE"
		_:
			lbl = "ATTAQUE"
	if String(p["aoe"]) == "zone":
		lbl += " · ZONE"
	return lbl


func _hexagon(c: Vector2, r: float) -> PackedVector2Array:
	var pts := PackedVector2Array()
	for i: int in range(6):
		var a: float = PI / 6.0 + float(i) * TAU / 6.0
		pts.append(c + Vector2(cos(a), sin(a)) * r)
	return pts


func _draw_card(c: Dictionary, usable: bool, selected: bool) -> void:
	var sp: Dictionary = c["spell"]
	var font: Font = ThemeDB.fallback_font
	var al: float = clampf(float(c["alpha"]), 0.0, 1.0) * (1.0 if _my_turn else 0.62)
	var col: Color = kind_color(sp)
	var hover: bool = int(c["uid"]) == _hover_uid
	draw_set_transform(c["pos"] as Vector2, float(c["rot"]), Vector2.ONE * float(c["sc"]))
	var tint := Color(1, 1, 1, al)
	var rect := Rect2(-CW * 0.5, -CH * 0.5, CW, CH)
	# ombre + halo de sélection
	draw_style_box(_box(Color(0, 0, 0, 0.38 * al), Color(0, 0, 0, 0), 12, 0), Rect2(rect.position + Vector2(4, 7), rect.size))
	if selected or hover:
		draw_style_box(_box(Color(1.0, 0.85, 0.35, 0.22 * al), Color(1.0, 0.88, 0.4, 0.9 * al), 14, 3), rect.grow(7.0))
	# corps
	var body := Color(0.12, 0.10, 0.16, al).lerp(Color(col.r * 0.30, col.g * 0.30, col.b * 0.30, al), 0.55)
	draw_style_box(_box(body, Color(GOLD.r, GOLD.g, GOLD.b, al) if usable else Color(0.5, 0.5, 0.55, al), 10, 4), rect)
	# illustration
	var art := Rect2(-CW * 0.5 + 9.0, -CH * 0.5 + 9.0, CW - 18.0, 72.0)
	draw_style_box(_box(Color(col.r * 0.55, col.g * 0.55, col.b * 0.55, al), Color(0, 0, 0, 0.6 * al), 6, 2), art)
	draw_rect(Rect2(art.position + Vector2(3, 3), Vector2(art.size.x - 6, 22)), Color(1, 1, 1, 0.10 * al))
	var ico: Texture2D = SpellIcons.texture_for(String(sp.get("name", "")))
	var acen: Vector2 = art.get_center()
	if ico != null:
		draw_circle(acen + Vector2(0, 2), 33.0, Color(0, 0, 0, 0.30 * al))
		draw_texture_rect(ico, Rect2(acen - Vector2(31, 31), Vector2(62, 62)), false, tint if usable else Color(0.6, 0.6, 0.66, al))
	else:
		_draw_glyph(acen, sp, al)
	# gemme de coût (PA = mana) et PM éventuel
	var cost: int = int(sp.get("cost_pa", 0))
	var affordable: bool = gm != null and not gm.active_entity.is_empty() and gm.can_afford(gm.active_entity, sp)
	var gem_col: Color = Color(0.16, 0.52, 0.98) if (affordable or not _my_turn) else Color(0.85, 0.25, 0.22)
	_gem(Vector2(-CW * 0.5 + 15.0, -CH * 0.5 + 15.0), 17.0, str(cost), gem_col, al)
	if int(sp.get("cost_pm", 0)) > 0:
		_gem(Vector2(CW * 0.5 - 15.0, -CH * 0.5 + 15.0), 14.0, str(int(sp["cost_pm"])), Color(0.16, 0.64, 0.34), al)
	# nom
	var nm: String = _tr(String(sp.get("name", "Carte")))
	var band := Rect2(-CW * 0.5 + 6.0, -CH * 0.5 + 85.0, CW - 12.0, 24.0)
	draw_style_box(_box(Color(0.05, 0.05, 0.09, 0.92 * al), Color(col.r, col.g, col.b, al), 5, 2), band)
	var fs: int = 14
	while fs > 9 and font.get_string_size(nm, HORIZONTAL_ALIGNMENT_LEFT, -1, fs).x > band.size.x - 8.0:
		fs -= 1
	draw_string(font, band.position + Vector2(0, 16.0 + float(14 - fs) * 0.3), nm, HORIZONTAL_ALIGNMENT_CENTER, band.size.x, fs, Color(1, 1, 0.92, al))
	# type
	var lc: Color = col.lightened(0.45)
	draw_string(font, Vector2(-CW * 0.5, -CH * 0.5 + 123.0), kind_label(sp), HORIZONTAL_ALIGNMENT_CENTER, CW, 10, Color(lc.r, lc.g, lc.b, al))
	# effet (3 lignes au plus ; le texte complet est dans l'infobulle)
	var desc: String = Combat.describe(sp)
	draw_multiline_string(font, Vector2(-CW * 0.5 + 8.0, -CH * 0.5 + 137.0), desc, HORIZONTAL_ALIGNMENT_CENTER, CW - 16.0, 10, 3, Color(0.92, 0.9, 0.82, al))
	# portée
	var p: Dictionary = Combat.parse(sp)
	var rng: int = int(sp.get("range", 1))
	var rtxt: String = "Sur soi" if String(p["target"]) == "self" else "Portée %d" % rng
	var chip := Rect2(-CW * 0.5 + 7.0, CH * 0.5 - 21.0, 68.0, 16.0)
	draw_style_box(_box(Color(0.02, 0.03, 0.08, 0.9 * al), Color(GOLD.r, GOLD.g, GOLD.b, 0.7 * al), 8, 1), chip)
	draw_string(font, chip.position + Vector2(0, 12), rtxt, HORIZONTAL_ALIGNMENT_CENTER, chip.size.x, 10, Color(1.0, 0.9, 0.55, al))
	# indisponible : voile
	if not usable:
		draw_style_box(_box(Color(0.02, 0.03, 0.06, 0.42), Color(0, 0, 0, 0), 10, 0), rect)
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)


func _gem(c: Vector2, r: float, val: String, col: Color, al: float) -> void:
	var font: Font = ThemeDB.fallback_font
	draw_colored_polygon(_hexagon(c + Vector2(0, 2.5), r + 2.5), Color(0, 0, 0, 0.5 * al))
	draw_colored_polygon(_hexagon(c, r + 2.5), Color(0.02, 0.03, 0.07, al))
	draw_colored_polygon(_hexagon(c, r), Color(col.r * 0.65, col.g * 0.65, col.b * 0.65, al))
	draw_colored_polygon(_hexagon(c + Vector2(0, -1.5), r * 0.84), Color(col.r, col.g, col.b, al))
	draw_colored_polygon(PackedVector2Array([c + Vector2(-r * 0.62, -r * 0.2), c + Vector2(-r * 0.2, -r * 0.82), c + Vector2(r * 0.3, -r * 0.82), c + Vector2(-r * 0.1, -r * 0.25)]), Color(1, 1, 1, 0.24 * al))
	var fs: int = int(r * 1.35) if val.length() <= 1 else int(r * 1.1)
	var pos := Vector2(c.x - r, c.y + float(fs) * 0.36)
	draw_string_outline(font, pos, val, HORIZONTAL_ALIGNMENT_CENTER, r * 2.0, fs, 6, Color(0, 0, 0, 0.92 * al))
	draw_string(font, pos, val, HORIZONTAL_ALIGNMENT_CENTER, r * 2.0, fs, Color(1, 1, 1, al))


## Illustration de repli (sort sans icône dédiée) : motif simple selon le type.
func _draw_glyph(c: Vector2, sp: Dictionary, al: float) -> void:
	var ink := Color(1.0, 0.97, 0.88, al)
	match String(Combat.parse(sp)["kind"]):
		"heal":
			draw_rect(Rect2(c.x - 6, c.y - 22, 12, 44), ink)
			draw_rect(Rect2(c.x - 22, c.y - 6, 44, 12), ink)
		"buff":
			var pts := PackedVector2Array()
			for i: int in range(10):
				var a: float = -PI * 0.5 + float(i) * PI / 5.0
				pts.append(c + Vector2(cos(a), sin(a)) * (24.0 if i % 2 == 0 else 11.0))
			draw_colored_polygon(pts, ink)
		"summon":
			draw_circle(c + Vector2(-9, -6), 8.0, ink)
			draw_circle(c + Vector2(9, -6), 8.0, ink)
			draw_circle(c + Vector2(0, 12), 11.0, ink)
		_:
			draw_line(c + Vector2(-20, 20), c + Vector2(18, -22), ink, 6.0, true)
			draw_line(c + Vector2(-14, 4), c + Vector2(-26, -4), Color(0.85, 0.65, 0.3, al), 5.0, true)


# ── Contenu des piles (fenêtre simple) ──────────────────────────────────────

## Ouvre la liste des cartes d'une pile (nom, coût, effet) dans une fenêtre fermée d'un appui.
## La pioche est présentée triée par nom : son ordre réel reste caché, comme dans un vrai jeu de cartes.
static func open_pile(parent: Node, gm_ref: Node, which: String) -> Control:
	var st: Dictionary = gm_ref.card_state("player")
	if st.is_empty():
		return null
	var cards: Array = (st["deck"] as Array).duplicate() if which == "deck" else (st["discard"] as Array).duplicate()
	cards.sort_custom(func(a: Dictionary, b: Dictionary) -> bool: return String(a.get("Nom", "")) < String(b.get("Nom", "")))
	var dim := ColorRect.new()
	dim.name = "PileView"
	dim.color = Color(0, 0, 0, 0.62)
	dim.set_anchors_preset(Control.PRESET_FULL_RECT)
	dim.mouse_filter = Control.MOUSE_FILTER_STOP
	dim.z_index = 2000
	var panel := PanelContainer.new()
	panel.set_anchors_preset(Control.PRESET_CENTER)
	panel.custom_minimum_size = Vector2(760, 0)
	panel.grow_horizontal = Control.GROW_DIRECTION_BOTH
	panel.grow_vertical = Control.GROW_DIRECTION_BOTH
	var sb: StyleBoxFlat = _box(Color(0.07, 0.08, 0.14, 0.97), GOLD, 16, 3)
	sb.content_margin_left = 22
	sb.content_margin_right = 22
	sb.content_margin_top = 16
	sb.content_margin_bottom = 18
	panel.add_theme_stylebox_override("panel", sb)
	dim.add_child(panel)
	var vb := VBoxContainer.new()
	vb.add_theme_constant_override("separation", 6)
	panel.add_child(vb)
	var head := Label.new()
	head.text = ("PIOCHE" if which == "deck" else "DÉFAUSSE") + " — %d carte%s" % [cards.size(), "s" if cards.size() > 1 else ""]
	head.add_theme_font_size_override("font_size", 28)
	head.add_theme_color_override("font_color", GOLD)
	vb.add_child(head)
	var note := Label.new()
	note.text = "Ordre de pioche caché." if which == "deck" else "Cartes déjà jouées ou défaussées."
	note.add_theme_font_size_override("font_size", 16)
	note.add_theme_color_override("font_color", Color(0.65, 0.7, 0.8))
	vb.add_child(note)
	var grid := GridContainer.new()
	grid.columns = 2
	grid.add_theme_constant_override("h_separation", 22)
	grid.add_theme_constant_override("v_separation", 4)
	vb.add_child(grid)
	if cards.is_empty():
		var empty := Label.new()
		empty.text = "(vide)"
		empty.add_theme_font_size_override("font_size", 20)
		vb.add_child(empty)
	for card: Dictionary in cards:
		var sp: Dictionary = gm_ref.card_to_spell(card)
		var row := Label.new()
		row.text = "[%d]  %s" % [int(sp.get("cost_pa", 0)), _tr(String(sp.get("name", "")))]
		row.add_theme_font_size_override("font_size", 20)
		var kc: Color = kind_color(sp)
		row.add_theme_color_override("font_color", kc.lightened(0.4))
		row.custom_minimum_size = Vector2(340, 0)
		grid.add_child(row)
	var hint := Label.new()
	hint.text = "Touchez pour fermer"
	hint.add_theme_font_size_override("font_size", 15)
	hint.add_theme_color_override("font_color", Color(0.6, 0.65, 0.75))
	vb.add_child(hint)
	dim.gui_input.connect(func(ev: InputEvent) -> void:
		if (ev is InputEventMouseButton and (ev as InputEventMouseButton).pressed) or (ev is InputEventScreenTouch and (ev as InputEventScreenTouch).pressed):
			dim.queue_free())
	parent.add_child(dim)
	return dim
