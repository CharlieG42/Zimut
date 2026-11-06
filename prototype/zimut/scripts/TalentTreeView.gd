class_name TalentTreeView
extends Control
## TalentTreeView.gd — Arbre de talents dessiné comme un vrai arbre : un tronc, quatre branches maîtresses
## (Offense, Défense, Utilitaire, Puissance), des rameaux qui se divisent et des nœuds-fruits.
##
## Un talent ne se débloque qu'une fois son parent débloqué (voir TalentTree.PARENT). Toucher un nœud le
## sélectionne (signal node_selected) ; la fiche affiche alors son détail et le bouton « Débloquer ».

signal node_selected(id: String)

## Position de chaque nœud dans le cadre (0..1, y vers le bas).
const LAYOUT: Dictionary = {
	"off_veteran": Vector2(0.125, 0.68), "off_critique": Vector2(0.063, 0.42), "off_fury": Vector2(0.187, 0.42),
	"off_master": Vector2(0.063, 0.18),
	"def_vita": Vector2(0.375, 0.68), "def_armure": Vector2(0.313, 0.42), "def_resilience": Vector2(0.437, 0.42),
	"def_implacable": Vector2(0.313, 0.18),
	"util_pa": Vector2(0.625, 0.68), "util_pm": Vector2(0.563, 0.42), "util_soin": Vector2(0.687, 0.42),
	"pow_rage": Vector2(0.875, 0.68), "pow_aura": Vector2(0.875, 0.42), "pow_second_souffle": Vector2(0.875, 0.18),
}
## Point où chaque branche maîtresse quitte le tronc.
const BRANCH_ORDER: Array[String] = ["offense", "defense", "utility", "power"]
const C_BARK := Color(0.36, 0.24, 0.14)
const C_BARK_LIGHT := Color(0.52, 0.36, 0.20)
const C_LOCKED := Color(0.28, 0.31, 0.40)
const C_GOOD := Color(0.45, 0.88, 0.50)
const C_GOLD := Color(1.00, 0.82, 0.35)

var save: Dictionary = {}
var classe: String = ""
var selected: String = ""
var _t: float = 0.0
var _pulse: bool = false


func setup(save_data: Dictionary, hero: String, sel: String = "") -> void:
	save = save_data
	classe = hero
	selected = sel
	_pulse = false
	for id: String in LAYOUT.keys():
		if state(id) == "available":
			_pulse = true
	set_process(_pulse)
	queue_redraw()


## "unlocked" | "available" (débloquable maintenant) | "short" (parent ok, points insuffisants) | "locked".
func state(id: String) -> String:
	if TalentTree.is_unlocked(save, classe, id):
		return "unlocked"
	var par: String = TalentTree.parent_of(id)
	if par != "" and not TalentTree.is_unlocked(save, classe, par):
		return "locked"
	if TalentTree.points(save, classe) >= int(TalentTree.talent_info(id).get("cost", 99)):
		return "available"
	return "short"


func _process(delta: float) -> void:
	_t += delta
	queue_redraw()


func _node_pos(id: String) -> Vector2:
	var p: Vector2 = LAYOUT[id]
	return Vector2(p.x * size.x, p.y * size.y)


func _radius() -> float:
	return clampf(minf(size.x * 0.030, size.y * 0.075), 20.0, 30.0)


func _trunk_top() -> Vector2:
	return Vector2(size.x * 0.5, size.y * 0.86)


func _gui_input(event: InputEvent) -> void:
	var pos: Vector2 = Vector2.ZERO
	var hit: bool = false
	if event is InputEventMouseButton:
		var mb: InputEventMouseButton = event
		if mb.pressed and mb.button_index == MOUSE_BUTTON_LEFT:
			pos = mb.position
			hit = true
	elif event is InputEventScreenTouch:
		var st: InputEventScreenTouch = event
		if st.pressed:
			pos = st.position
			hit = true
	if not hit:
		return
	var best: String = ""
	var best_d: float = 1e9
	for id: String in LAYOUT.keys():
		var rc: Rect2 = _node_rect(id).grow(8.0)
		var d: float = _node_pos(id).distance_to(pos)
		if rc.has_point(pos) and d < best_d:
			best_d = d
			best = id
	if best != "":
		selected = best
		node_selected.emit(best)
		queue_redraw()
		accept_event()


# ═══════════════════════════════════════════════════════════════════════════
#  Dessin
# ═══════════════════════════════════════════════════════════════════════════

func _curve(a: Vector2, b: Vector2, bend: float = 0.5) -> PackedVector2Array:
	var c1: Vector2 = a + Vector2(0, (b.y - a.y) * bend)
	var c2: Vector2 = b + Vector2(0, (a.y - b.y) * bend)
	var pts := PackedVector2Array()
	for i: int in range(25):
		var t: float = float(i) / 24.0
		var u: float = 1.0 - t
		pts.append(u * u * u * a + 3.0 * u * u * t * c1 + 3.0 * u * t * t * c2 + t * t * t * b)
	return pts


## Branche maîtresse : part à l'horizontale depuis le tronc puis se redresse vers la racine de la branche.
func _bough(a: Vector2, b: Vector2) -> PackedVector2Array:
	var c1: Vector2 = Vector2(lerpf(a.x, b.x, 0.75), a.y)
	var c2: Vector2 = Vector2(b.x, lerpf(a.y, b.y, 0.70))
	var pts := PackedVector2Array()
	for i: int in range(25):
		var t: float = float(i) / 24.0
		var u: float = 1.0 - t
		pts.append(u * u * u * a + 3.0 * u * u * t * c1 + 3.0 * u * t * t * c2 + t * t * t * b)
	return pts


func _draw() -> void:
	if size.x < 10.0:
		return
	var font: Font = get_theme_default_font()
	var r: float = _radius()
	# Ciel / sous-bois
	draw_rect(Rect2(Vector2.ZERO, size), Color(0.05, 0.08, 0.10), true)
	# Feuillage : nuées de disques sombres derrière les rameaux
	for bi: int in range(BRANCH_ORDER.size()):
		var col: Color = TalentTree.BRANCHES[BRANCH_ORDER[bi]]["color"]
		var cx: float = size.x * [0.13, 0.37, 0.63, 0.87][bi]
		for k: int in range(9):
			var a: float = float(k) * 2.399
			var rr: float = size.y * (0.10 + 0.05 * float(k % 4))
			var cc: Vector2 = Vector2(cx + cos(a) * size.x * 0.07, size.y * 0.34 + sin(a) * size.y * 0.24)
			draw_circle(cc, rr, Color(0.10 + col.r * 0.06, 0.20 + col.g * 0.08, 0.13 + col.b * 0.05, 0.40))
	# Sol et racines
	draw_rect(Rect2(0, size.y * 0.95, size.x, size.y * 0.05), Color(0.10, 0.12, 0.09), true)
	var base: Vector2 = Vector2(size.x * 0.5, size.y * 0.975)
	for sx: float in [-1.0, 1.0]:
		draw_polyline(_curve(base + Vector2(sx * 6.0, -4.0), base + Vector2(sx * size.x * 0.075, 8.0), 0.2), C_BARK, 9.0, true)
	# Tronc
	var top: Vector2 = _trunk_top()
	var w0: float = size.x * 0.040
	var w1: float = size.x * 0.022
	var trunk := PackedVector2Array([
		Vector2(base.x - w0, base.y), Vector2(top.x - w1, top.y), Vector2(top.x + w1, top.y), Vector2(base.x + w0, base.y)])
	draw_colored_polygon(trunk, C_BARK)
	draw_line(Vector2(base.x - w0 * 0.3, base.y), Vector2(top.x - w1 * 0.3, top.y), C_BARK_LIGHT, 3.0, true)
	# Branches maîtresses : du sommet du tronc vers la racine de chaque branche
	for branch: String in BRANCH_ORDER:
		var root_id: String = _root_of(branch)
		var rp: Vector2 = _node_pos(root_id)
		var col2: Color = TalentTree.BRANCHES[branch]["color"]
		var pts: PackedVector2Array = _bough(top + Vector2(0, 6), rp + Vector2(0, _node_rect(root_id).size.y * 0.5))
		draw_polyline(pts, C_BARK, 14.0, true)
		draw_polyline(pts, C_BARK_LIGHT, 4.0, true)
		if TalentTree.is_unlocked(save, classe, root_id):
			draw_polyline(pts, col2.darkened(0.15), 3.0, true)
	# Rameaux entre talents
	for id: String in LAYOUT.keys():
		var par: String = TalentTree.parent_of(id)
		if par == "":
			continue
		var col3: Color = TalentTree.BRANCHES[String(TalentTree.talent_info(id)["branch"])]["color"]
		var a2: Vector2 = _node_pos(par) + Vector2(0, -_node_rect(par).size.y * 0.5)
		var b2: Vector2 = _node_pos(id) + Vector2(0, _node_rect(id).size.y * 0.5)
		var pts2: PackedVector2Array = _curve(a2, b2, 0.5)
		draw_polyline(pts2, C_BARK, 10.0, true)
		draw_polyline(pts2, C_BARK_LIGHT, 3.0, true)
		if TalentTree.is_unlocked(save, classe, id):
			draw_polyline(pts2, col3.lightened(0.1), 3.5, true)
	# Titres de branches
	for bi2: int in range(BRANCH_ORDER.size()):
		var br: Dictionary = TalentTree.BRANCHES[BRANCH_ORDER[bi2]]
		var lbl: String = "%s %s" % [br["icon"], br["label"]]
		var cx2: float = size.x * [0.13, 0.37, 0.63, 0.87][bi2]
		draw_string(font, Vector2(cx2 - 90.0, size.y * 0.045 + 14.0), lbl, HORIZONTAL_ALIGNMENT_CENTER, 180.0, 22, br["color"])
	# Nœuds
	for id2: String in LAYOUT.keys():
		_draw_node(id2, font, r)


func _root_of(branch: String) -> String:
	for t: Array in TalentTree.branch_talents(branch):
		if TalentTree.parent_of(String(t[0])) == "":
			return String(t[0])
	return ""


func _node_rect(id: String) -> Rect2:
	var sz: Vector2 = Vector2(clampf(size.x * 0.116, 96.0, 132.0), 50.0)
	return Rect2(_node_pos(id) - sz * 0.5, sz)


func _draw_node(id: String, font: Font, _r: float) -> void:
	var info: Dictionary = TalentTree.talent_info(id)
	var col: Color = TalentTree.BRANCHES[String(info["branch"])]["color"]
	var st: String = state(id)
	var rc: Rect2 = _node_rect(id)
	var c: Vector2 = rc.get_center()
	var ring: Color
	var fill: Color
	var txt: Color = Color(0.95, 0.94, 0.90)
	match st:
		"unlocked":
			ring = C_GOOD
			fill = col.darkened(0.55)
		"available":
			ring = col.lightened(0.25)
			fill = Color(0.12, 0.15, 0.22)
		"short":
			ring = col.darkened(0.30)
			fill = Color(0.09, 0.11, 0.16)
			txt = Color(0.82, 0.80, 0.72)
		_:
			ring = C_LOCKED
			fill = Color(0.07, 0.08, 0.11)
			txt = Color(0.52, 0.55, 0.64)
	if st == "unlocked":
		_box(rc.grow(7.0), Color(col.r, col.g, col.b, 0.20), Color(0, 0, 0, 0), 0, 18)
	elif st == "available":
		var pu: float = 0.5 + 0.5 * sin(_t * 3.2)
		_box(rc.grow(5.0 + 4.0 * pu), Color(col.r, col.g, col.b, 0.10 + 0.20 * pu), Color(0, 0, 0, 0), 0, 18)
	if id == selected:
		_box(rc.grow(6.0), Color(0, 0, 0, 0), Color(1, 1, 1, 0.95), 3, 18)
	_box(rc, fill, ring, 4 if st != "locked" else 2, 14)
	# pastille : coût / validé / verrou
	var br: float = 15.0
	var bc: Vector2 = Vector2(rc.position.x + br + 4.0, c.y)
	draw_circle(bc, br, Color(0.03, 0.04, 0.06))
	draw_arc(bc, br, 0.0, TAU, 32, ring, 2.5, true)
	var mark: String = "✓" if st == "unlocked" else ("🔒" if st == "locked" else "★%d" % int(info["cost"]))
	var mcol: Color = C_GOOD if st == "unlocked" else (C_GOLD if st == "available" else Color(0.70, 0.66, 0.52))
	draw_string(font, Vector2(bc.x - br, bc.y + 6.0), mark, HORIZONTAL_ALIGNMENT_CENTER, br * 2.0, 17, mcol)
	# nom (1 ou 2 lignes)
	var tx: float = rc.position.x + br * 2.0 + 9.0
	var tw: float = rc.end.x - tx - 4.0
	var nm: String = String(info["name"])
	var one: float = font.get_string_size(nm, HORIZONTAL_ALIGNMENT_LEFT, -1, 14).x
	if one <= tw:
		draw_string(font, Vector2(tx, c.y + 5.0), nm, HORIZONTAL_ALIGNMENT_LEFT, tw, 14, txt)
	else:
		draw_multiline_string(font, Vector2(tx, c.y - 3.0), nm, HORIZONTAL_ALIGNMENT_LEFT, tw, 12, 2, txt)


func _box(rc: Rect2, bg: Color, border: Color, bw: int, radius: int) -> void:
	var sb := StyleBoxFlat.new()
	sb.bg_color = bg
	sb.border_color = border
	sb.set_border_width_all(bw)
	sb.set_corner_radius_all(radius)
	draw_style_box(sb, rc)
