extends CanvasLayer
## CardDuelUI.gd — Mode Cartes (JCC à voies) : accueil, choix de l'adversaire, duel, résultat.
## Les règles sont dans JccDuel ; les cartes dans JccCards ; la collection / le deck dans JccCollection.
## Plateau : grille 2D de 4 x 6 cases (style Krosmaga). Adversaire en haut, vous en bas.
## Chaque camp déploie sur ses 2 lignes proches du héros ; PM = déplacement, PA = attaque/sort, PO = portée.

const W: float = 1920.0
const H: float = 1080.0
const BOARD := Rect2(400.0, 116.0, 1120.0, 576.0)   # 4 colonnes x 6 lignes
const CELL := Vector2(280.0, 96.0)
const SLOT := Vector2(280.0, 96.0)   # carte sur le plateau (= CELL)
const HAND_Y: float = 792.0
const BIOMES: Array = ["Forêt", "Plaine", "Désert", "Montagne", "Marais"]
## Biome Cartes -> nation du mode tactique (mêmes tuiles de sol et palette de falaise).
const BIOME_NATION := {"Forêt": "Forêt", "Plaine": "Vents", "Désert": "Désert", "Montagne": "Montagne", "Marais": "Marées"}
const HAND_CARD := Vector2(190, 275)
const HAND_X0: float = 410.0
const HAND_X1: float = 1520.0

var _save: Dictionary = {}
var _slot: int = -1
var _root: Control
var _duel: JccDuel = null
var _opp: Dictionary = {}
var _opp_idx: int = 0
var _busy: bool = false
var _over: bool = false
# duel — nœuds
var _cards_layer: Control
var _fx_layer: Control
var _slots: Dictionary = {}          # "cell" -> Panel (case vide cliquable)
var _board_views: Dictionary = {}    # "side:cell" -> _UnitView
var _iso: bool = false                # plateau en perspective (réglage Options > Cartes)
var _cell_polys: Array = []           # PackedVector2Array (écran) par case
var _cell_ctr: Array = []             # centre de chaque case
var _cell_scale: Array = []           # échelle de l'unité posée sur la case
var _range_cells: Array = []          # cases à portée PO de l'unité sélectionnée
var _board_anchor: Control = null    # ancre du tutoriel sur le plateau
var _biome: String = "Forêt"
var _foe_accent: Color = Color(1.0, 0.42, 0.38)
var _hand_views: Array = []
var _hero_nodes: Array = [null, null]
var _info_holder: Control
var _action_bar: HBoxContainer
var _toast: Label
var _log_lbl: Label
var _end_btn: Button
var _power_btn: Button
var _mull_btn: Button
var _mana_node: Control
var _pile_lbl: Label
var _fx_draw: Control = null
var _atk_from: Vector2 = Vector2.ZERO
var _atk_pending: bool = false
# duel — sélection
var _sel_hand: int = -1
var _sel_cell: int = -1   # case de l'unité sélectionnée (index y * COLS + x)
var _pending: Dictionary = {}        # ciblage en cours : {kind, idx|lane, cible}
var _targets: Array = []
var _inspect: Dictionary = {}
var _inspect_cell: int = -1          # case de l'unité ennemie inspectée (aperçu de ses déplacements / menace)
var _foe_moves: Array = []
var _foe_threat: Array = []


## StyleBox avec ombre portee (encarts du duel).
func _panel_sb(bg: Color, border: Color, radius: int = 14, bw: int = 2, shadow: int = 8) -> StyleBoxFlat:
	var sb := StyleBoxFlat.new()
	sb.bg_color = bg
	sb.border_color = border
	sb.set_border_width_all(bw)
	sb.set_corner_radius_all(radius)
	sb.shadow_color = Color(0, 0, 0, 0.5)
	sb.shadow_size = shadow
	sb.shadow_offset = Vector2(0, 4)
	return sb


## Bouton avec ombre et etats en relief (fin de tour, fosses, abandon).
func _fancy_btn(b: Button, col: Color, radius: int = 14) -> void:
	b.add_theme_stylebox_override("normal", _panel_sb(col.darkened(0.35), col.lightened(0.15), radius, 3, 8))
	b.add_theme_stylebox_override("hover", _panel_sb(col.darkened(0.12), col.lightened(0.45), radius, 3, 10))
	b.add_theme_stylebox_override("pressed", _panel_sb(col.darkened(0.55), col.lightened(0.3), radius, 3, 3))
	b.add_theme_stylebox_override("disabled", _panel_sb(Color(0.13, 0.15, 0.2), Color(0.25, 0.28, 0.36), radius, 2, 0))


func _fx_orb(a: Vector2, b: Vector2, col: Color) -> void:
	if _fx_draw != null and is_instance_valid(_fx_draw):
		_fx_draw.orb(a, b, col)


func _fx_burst(c: Vector2, col: Color, r0: float = 22.0) -> void:
	if _fx_draw != null and is_instance_valid(_fx_draw):
		_fx_draw.burst(c, col, r0)


func _shake_node(n: Node) -> void:
	if n == null or not is_instance_valid(n):
		return
	var p0: Vector2 = (n as Control).position
	var tw: Tween = create_tween()
	tw.tween_property(n, "position", p0 + Vector2(8, 0), 0.04)
	tw.tween_property(n, "position", p0 - Vector2(8, 0), 0.07)
	tw.tween_property(n, "position", p0, 0.04)


func _ready() -> void:
	layer = 10
	_save = GameManager.active_save
	_slot = GameManager.active_slot
	if _save.is_empty() or _slot < 0:
		get_tree().change_scene_to_file("res://scenes/SaveSlots.tscn")
		return
	JccCollection.ensure(_save)
	Music.play("adventure")
	_root = Control.new()
	_root.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(_root)
	_show_hub()


func _clear() -> void:
	for c: Node in _root.get_children():
		c.queue_free()
	_slots = {}
	_board_views = {}
	_hand_views = []
	_hero_nodes = [null, null]
	_over = false


func _bg(top: Color = Color(0.08, 0.12, 0.20), bottom: Color = Color(0.03, 0.04, 0.08)) -> void:
	var g := Gradient.new()
	g.set_color(0, top)
	g.set_color(1, bottom)
	var gt := GradientTexture2D.new()
	gt.gradient = g
	gt.fill_from = Vector2(0.5, 0.0)
	gt.fill_to = Vector2(0.5, 1.0)
	gt.width = 8
	gt.height = 256
	var tr := TextureRect.new()
	tr.texture = gt
	tr.stretch_mode = TextureRect.STRETCH_SCALE
	tr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	tr.set_anchors_preset(Control.PRESET_FULL_RECT)
	tr.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_root.add_child(tr)


func _save_now() -> void:
	ProgressionManager.write_save(_slot, _save)


func _leave() -> void:
	PlayTimer.flush()
	get_tree().change_scene_to_file("res://scenes/SaveSlots.tscn")


# ═══════════════════════════════════════════════════════════════════════════
#  Accueil et choix de l'adversaire
# ═══════════════════════════════════════════════════════════════════════════

func _show_hub() -> void:
	_clear()
	_bg()
	var j: Dictionary = JccCollection.ensure(_save)
	var title: Label = UiKit.lbl("CARTES", 84, UiKit.C_GOLD, true)
	title.position = Vector2(0, 90)
	title.size = Vector2(W, 100)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_root.add_child(title)
	var sub: Label = UiKit.lbl("Duels de cartes à quatre voies — deck de 20 cartes, mana croissant, héros à 20 PV", 26, UiKit.C_DIM)
	sub.position = Vector2(0, 200)
	sub.size = Vector2(W, 40)
	sub.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_root.add_child(sub)
	# aperçu de quelques cartes en éventail
	var fan: Array = ["b_vorkann", "c_mage", "s_boule_feu", "b_tharok", "c_tank"]
	for i: int in fan.size():
		var v := JccCardView.new()
		v.size = Vector2(190, 275)
		v.pivot_offset = Vector2(95, 380)
		v.position = Vector2(W * 0.5 - 95 + (i - 2) * 150, 262 + abs(i - 2) * 18)
		v.rotation = (i - 2) * 0.12
		v.set_card(JccCards.get_card(String(fan[i])))
		v.mouse_filter = Control.MOUSE_FILTER_IGNORE
		_root.add_child(v)
	var col := VBoxContainer.new()
	col.position = Vector2(W * 0.5 - 260, 625)
	col.size = Vector2(520, 360)
	col.add_theme_constant_override("separation", 18)
	_root.add_child(col)
	var duel: Button = UiKit.btn("⚔  Duel", Color(0.95, 0.65, 0.25), 34, Vector2(0, 86))
	duel.pressed.connect(_on_duel_pressed)
	col.add_child(duel)
	var deck: Button = UiKit.btn("🃏  Mon deck", Color(0.45, 0.65, 0.95), 30, Vector2(0, 72))
	deck.pressed.connect(_show_builder)
	col.add_child(deck)
	var back: Button = UiKit.btn("←  Mes Parties", Color(0.6, 0.62, 0.72), 26, Vector2(0, 62))
	back.pressed.connect(_leave)
	col.add_child(back)
	var n_owned: int = 0
	for k: Variant in (j["collection"] as Dictionary):
		n_owned += int((j["collection"] as Dictionary)[k])
	var st: Label = UiKit.lbl("Victoires : %d · Défaites : %d · Cartes possédées : %d" % [int(j["wins"]), int(j["losses"]), n_owned], 22, UiKit.C_DIM)
	st.position = Vector2(0, 1006)
	st.size = Vector2(W, 34)
	st.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_root.add_child(st)
	var ch: Dictionary = JccCollection.daily_challenge(_save)
	var ch_done: bool = bool(ch.get("done", false))
	var ch_lbl: Label = UiKit.lbl("Défi du jour : %s  (%d/%d)%s" % [String(ch.get("text", "")), int(ch.get("progress", 0)), int(ch.get("target", 0)), " — réussi ✓" if ch_done else ""], 22, UiKit.C_GOLD if ch_done else UiKit.C_TXT)
	ch_lbl.position = Vector2(0, 1046)
	ch_lbl.size = Vector2(W, 30)
	ch_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_root.add_child(ch_lbl)


func _on_duel_pressed() -> void:
	var deck_now: Array = JccCollection.deck_of(_save, JccCollection.active_deck_name(_save))
	if JccCollection.deck_error(_save, deck_now) != "":
		_show_builder()
		return
	_show_opponents()


func _show_builder() -> void:
	_clear()
	var b := CardDeckBuilder.new()
	_root.add_child(b)
	b.closed.connect(func(saved: bool) -> void:
		if saved:
			_save_now()
		_show_hub())
	b.open(_save)


func _show_opponents() -> void:
	_clear()
	_bg()
	var title: Label = UiKit.lbl("Choisissez votre adversaire", 52, UiKit.C_GOLD, true)
	title.position = Vector2(0, 40)
	title.size = Vector2(W, 70)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_root.add_child(title)
	var grid := GridContainer.new()
	grid.columns = 3
	grid.position = Vector2(150, 150)
	grid.add_theme_constant_override("h_separation", 40)
	grid.add_theme_constant_override("v_separation", 40)
	_root.add_child(grid)
	for i: int in JccCollection.OPPONENTS.size():
		var op: Dictionary = JccCollection.opponent(i)
		var boss: String = String(op["boss"])
		var unlocked: bool = JccCollection.is_unlocked(_save, i)
		var b: Button = UiKit.btn("", Color(0.95, 0.65, 0.25) if boss != "" and unlocked else (Color(0.45, 0.65, 0.95) if unlocked else Color(0.24, 0.26, 0.31)), 24, Vector2(520, 320))
		if unlocked:
			b.pressed.connect(func() -> void: _start_duel(i))
		else:
			b.disabled = true
		grid.add_child(b)
		var tex: Texture2D = JccCardView.art_texture(String(op["sprite"]))
		if tex != null:
			var tr := TextureRect.new()
			tr.texture = tex
			tr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			tr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			tr.position = Vector2(20, 20)
			tr.size = Vector2(190, 200)
			tr.modulate = Color(1, 1, 1) if unlocked else Color(0.4, 0.4, 0.45)
			tr.mouse_filter = Control.MOUSE_FILTER_IGNORE
			b.add_child(tr)
		var nm: Label = UiKit.lbl(String(op["name"]), 32, UiKit.C_TXT if unlocked else UiKit.C_DIM, true)
		nm.position = Vector2(225, 30)
		nm.mouse_filter = Control.MOUSE_FILTER_IGNORE
		b.add_child(nm)
		var desc: String = "Duel classique" if boss == "" else "Boss — peut laisser sa carte légendaire"
		if not unlocked:
			desc = "🔒 Battre « %s » pour débloquer" % String(JccCollection.opponent(i - 1)["name"])
		var dl: Label = UiKit.lbl(desc, 20, UiKit.C_GOLD if boss != "" and unlocked else UiKit.C_DIM)
		dl.position = Vector2(225, 86)
		dl.size = Vector2(280, 100)
		dl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		dl.mouse_filter = Control.MOUSE_FILTER_IGNORE
		b.add_child(dl)
		var rw: Label = UiKit.lbl("Butin : 1 carte" if unlocked else "", 20, UiKit.C_GOOD)
		rw.position = Vector2(225, 240)
		rw.mouse_filter = Control.MOUSE_FILTER_IGNORE
		b.add_child(rw)
	var back: Button = UiKit.btn("←  Retour", Color(0.6, 0.62, 0.72), 26, Vector2(260, 64))
	back.position = Vector2(80, 980)
	back.pressed.connect(_show_hub)
	_root.add_child(back)


# ═══════════════════════════════════════════════════════════════════════════
#  Duel
# ═══════════════════════════════════════════════════════════════════════════

func _start_duel(idx: int) -> void:
	_opp_idx = idx
	_opp = JccCollection.opponent(idx)
	JccCollection.ensure(_save)
	_duel = JccDuel.new()
	var cls: String = String(ProgressionManager.adventure_state(_save).get("hero_class", "Mage"))
	var opp_pow: String = "boss" if String(_opp.get("boss", "")) != "" else ""
	var deck_now: Array = JccCollection.deck_of(_save, JccCollection.active_deck_name(_save))
	_duel.setup(deck_now.duplicate(), JccCollection.parse_deck(String(_opp["deck"])), 0, [cls, opp_pow])
	_biome = String(_opp.get("biome", BIOMES[_opp_idx % BIOMES.size()]))
	_foe_accent = Color(String(_opp.get("accent", "#ff6b61")))
	_inspect_cell = -1
	_sel_hand = -1
	_sel_cell = -1
	_pending = {}
	_busy = false
	_clear()
	Music.play_combat("Forêt")
	_build_duel_ui()
	_refresh()
	_toast_msg("Le duel commence ! Votre tour.")
	_tutorial()


func _build_duel_ui() -> void:
	_bg(Color(0.10, 0.20, 0.22), Color(0.03, 0.06, 0.08))
	# fond cliquable : annule la sélection
	var catcher := Control.new()
	catcher.set_anchors_preset(Control.PRESET_FULL_RECT)
	catcher.gui_input.connect(func(ev: InputEvent) -> void:
		if ev is InputEventMouseButton and ev.pressed and not _busy:
			_cancel_selection())
	_root.add_child(catcher)
	# fond de biome 2D stylisé derrière le plateau + ancre du tutoriel
	_iso = GameSettings.cards_iso
	_build_geometry()
	var biome_bg := _BiomeBG.new()
	biome_bg.iso = _iso
	biome_bg.polys = _cell_polys
	biome_bg.biome = _biome
	biome_bg.seedv = _opp_idx * 7919 + 13
	biome_bg.board = BOARD
	biome_bg.nation = String(BIOME_NATION.get(_biome, _biome))
	biome_bg.camps = [_camp_art(0), _camp_art(1)]
	biome_bg.foe_accent = _foe_accent
	_root.add_child(biome_bg)
	_board_anchor = Control.new()
	_board_anchor.position = BOARD.position
	_board_anchor.size = BOARD.size
	_board_anchor.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_root.add_child(_board_anchor)
	# emplacements : une case cliquable par cellule de la grille 4 x 6
	for cell in JccDuel.LANES:
		var poly: PackedVector2Array = _cell_polys[cell]
		var mn := Vector2(1e9, 1e9)
		var mx := Vector2(-1e9, -1e9)
		for q in poly:
			mn = Vector2(minf(mn.x, q.x), minf(mn.y, q.y))
			mx = Vector2(maxf(mx.x, q.x), maxf(mx.y, q.y))
		var p := _CellNode.new()
		p.position = mn
		p.size = mx - mn
		var loc := PackedVector2Array()
		for q in poly:
			loc.append(q - mn)
		p.poly = loc
		p.gui_input.connect(func(ev: InputEvent) -> void:
			if ev is InputEventMouseButton and ev.pressed and ev.button_index == MOUSE_BUTTON_LEFT:
				_on_slot(cell))
		_root.add_child(p)
		_slots["%d" % cell] = p
	# socle de la main
	var tray := Panel.new()
	tray.position = Vector2(HAND_X0 - 36.0, HAND_Y - 20.0)
	tray.size = Vector2(HAND_X1 - HAND_X0 + 72.0, HAND_CARD.y + 44.0)
	tray.mouse_filter = Control.MOUSE_FILTER_IGNORE
	tray.add_theme_stylebox_override("panel", _panel_sb(Color(0.05, 0.07, 0.11, 0.85), Color(0.35, 0.42, 0.58), 18, 2, 10))
	_root.add_child(tray)
	_cards_layer = Control.new()
	_cards_layer.set_anchors_preset(Control.PRESET_FULL_RECT)
	_cards_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_root.add_child(_cards_layer)
	# héros
	_hero_nodes[1] = _make_hero_panel(1, Rect2(700, 8, 520, 104))
	_hero_nodes[0] = _make_hero_panel(0, Rect2(30, 690, 340, 360))
	# colonne gauche : fiche de carte (grande vignette)
	_info_holder = Control.new()
	_info_holder.position = Vector2(28, 118)
	_info_holder.size = Vector2(360, 520)
	_root.add_child(_info_holder)
	# barre d'actions (créature sélectionnée)
	_action_bar = HBoxContainer.new()
	_action_bar.position = Vector2(420, 700)
	_action_bar.size = Vector2(1480, 64)
	_action_bar.alignment = BoxContainer.ALIGNMENT_CENTER
	_action_bar.add_theme_constant_override("separation", 14)
	_root.add_child(_action_bar)
	# colonne droite : journal, pioche, fin de tour
	var logt: Label = UiKit.lbl("Journal", 24, UiKit.C_GOLD, true)
	logt.position = Vector2(1562, 96)
	_root.add_child(logt)
	var logp := PanelContainer.new()
	logp.position = Vector2(1560, 126)
	logp.size = Vector2(330, 250)
	logp.clip_contents = true
	logp.add_theme_stylebox_override("panel", _panel_sb(Color(0, 0, 0, 0.38), Color(0.42, 0.48, 0.62), 14, 2, 10))
	_root.add_child(logp)
	_log_lbl = UiKit.lbl("", 22, UiKit.C_TXT)
	_log_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_log_lbl.custom_minimum_size = Vector2(300, 0)
	_log_lbl.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
	logp.add_child(_log_lbl)
	_end_btn = UiKit.btn("Fin du tour", Color(0.98, 0.80, 0.30), 32, Vector2(330, 104))
	_end_btn.position = Vector2(1560, 440)
	_fancy_btn(_end_btn, Color(0.98, 0.80, 0.30), 16)
	_end_btn.add_theme_color_override("font_color", Color(0.16, 0.11, 0.04))
	_end_btn.add_theme_color_override("font_hover_color", Color(0.10, 0.07, 0.02))
	_end_btn.add_theme_color_override("font_pressed_color", Color(0.28, 0.20, 0.07))
	_end_btn.add_theme_color_override("font_disabled_color", Color(0.45, 0.44, 0.42))
	_end_btn.pressed.connect(_on_end_turn)
	_root.add_child(_end_btn)
	var quit: Button = UiKit.btn("Abandonner", Color(0.8, 0.45, 0.4), 20, Vector2(200, 48))
	quit.position = Vector2(30, 14)
	_fancy_btn(quit, Color(0.8, 0.45, 0.4))
	quit.pressed.connect(_on_quit_duel)
	_root.add_child(quit)
	var hb: Button = UiKit.btn("❓ Aide", Color(0.45, 0.65, 0.85), 20, Vector2(150, 48))
	hb.position = Vector2(250, 14)
	_fancy_btn(hb, Color(0.45, 0.65, 0.85))
	hb.pressed.connect(_show_help)
	_root.add_child(hb)
	var fo: Button = UiKit.btn("Fosse adverse", Color(0.55, 0.5, 0.7), 18, Vector2(190, 44))
	fo.position = Vector2(1560, 384)
	_fancy_btn(fo, Color(0.55, 0.5, 0.7))
	fo.pressed.connect(func() -> void: _show_fosse(1))
	_root.add_child(fo)
	var fp: Button = UiKit.btn("Votre fosse", Color(0.55, 0.5, 0.7), 20, Vector2(190, 52))
	fp.position = Vector2(1560, 990)
	_fancy_btn(fp, Color(0.55, 0.5, 0.7))
	fp.pressed.connect(func() -> void: _show_fosse(0))
	_root.add_child(fp)
	_power_btn = UiKit.btn("", Color(0.85, 0.65, 1.0), 22, Vector2(330, 60))
	_power_btn.position = Vector2(1560, 556)
	_fancy_btn(_power_btn, Color(0.85, 0.65, 1.0))
	_power_btn.pressed.connect(_on_power_pressed)
	_root.add_child(_power_btn)
	_mull_btn = UiKit.btn("↺ Nouvelle main (1×)", Color(0.45, 0.75, 0.9), 20, Vector2(330, 52))
	_mull_btn.position = Vector2(1560, 624)
	_fancy_btn(_mull_btn, Color(0.45, 0.75, 0.9))
	_mull_btn.pressed.connect(_on_mulligan)
	_root.add_child(_mull_btn)
	_pile_lbl = UiKit.lbl("", 24, UiKit.C_TXT, true)
	_pile_lbl.position = Vector2(1560, 930)
	_root.add_child(_pile_lbl)
	_fx_layer = Control.new()
	_fx_layer.set_anchors_preset(Control.PRESET_FULL_RECT)
	_fx_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_root.add_child(_fx_layer)
	_fx_draw = _FxDraw.new()
	_fx_layer.add_child(_fx_draw)
	_toast = UiKit.lbl("", 32, UiKit.C_GOLD, true)
	_toast.position = Vector2(420, BOARD.end.y + 6.0)
	_toast.size = Vector2(1100, 46)
	_toast.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_toast.modulate.a = 0.0
	_toast.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_fx_layer.add_child(_toast)


const ISO_TOP: float = 126.0
const ISO_BOTTOM: float = 690.0
const ISO_TOP_F: float = 0.80
const ISO_W: Array = [0.80, 0.88, 0.96, 1.04, 1.12, 1.20]


func _iso_y(i: int) -> float:
	var acc: float = 0.0
	for k in i:
		acc += float(ISO_W[k])
	return ISO_TOP + acc / 6.0 * (ISO_BOTTOM - ISO_TOP)


func _iso_hw(y: float) -> float:
	return BOARD.size.x * 0.5 * lerpf(ISO_TOP_F, 1.0, (y - ISO_TOP) / (ISO_BOTTOM - ISO_TOP))


## Calcule le polygone, le centre et l'échelle d'unité de chaque case (plat ou perspective).
func _build_geometry() -> void:
	_cell_polys = []
	_cell_ctr = []
	_cell_scale = []
	var cx: float = BOARD.position.x + BOARD.size.x * 0.5
	for cell in JccDuel.LANES:
		var gx: int = cell % JccDuel.COLS
		var gy: int = cell / JccDuel.COLS
		var pts := PackedVector2Array()
		var sc: float = 1.0
		if not _iso:
			var r := Rect2(_cell_pos(cell), CELL)
			pts = PackedVector2Array([r.position, Vector2(r.end.x, r.position.y), r.end, Vector2(r.position.x, r.end.y)])
		else:
			var yt: float = _iso_y(gy)
			var yb: float = _iso_y(gy + 1)
			var ht: float = _iso_hw(yt)
			var hb: float = _iso_hw(yb)
			var n: float = float(JccDuel.COLS)
			pts = PackedVector2Array([
				Vector2(cx - ht + float(gx) * 2.0 * ht / n, yt), Vector2(cx - ht + float(gx + 1) * 2.0 * ht / n, yt),
				Vector2(cx - hb + float(gx + 1) * 2.0 * hb / n, yb), Vector2(cx - hb + float(gx) * 2.0 * hb / n, yb)])
			var cw: float = (ht + hb) / n
			sc = minf(cw / CELL.x, (yb - yt) / CELL.y) * 0.97
		var ctr := Vector2.ZERO
		for q in pts:
			ctr += q
		_cell_polys.append(pts)
		_cell_ctr.append(ctr / 4.0)
		_cell_scale.append(sc)


## Case cliquable de forme quelconque (rectangle ou trapèze), teintée selon son rôle.
class _CellNode extends Control:
	var poly := PackedVector2Array()   # coordonnées locales
	var fill := Color(0, 0, 0, 0.20)
	var border := Color(1, 1, 1, 0.14)
	var bw: float = 2.0
	var terrain: String = ""           # "", "boue", "hauteur", "buisson"

	func _has_point(p: Vector2) -> bool:
		return Geometry2D.is_point_in_polygon(p, poly)

	func _draw() -> void:
		if poly.size() < 3:
			return
		draw_colored_polygon(poly, fill)
		var closed := poly.duplicate()
		closed.append(poly[0])
		draw_polyline(closed, border, bw, true)
		# glyphe de terrain au centre de la case
		var c := Vector2(size.x * 0.5, size.y * 0.62)
		match terrain:
			"boue":
				draw_circle(c + Vector2(-14, 0), 9, Color(0.25, 0.35, 0.55, 0.55))
				draw_circle(c + Vector2(10, 6), 12, Color(0.25, 0.35, 0.55, 0.55))
				draw_circle(c + Vector2(2, -8), 8, Color(0.25, 0.35, 0.55, 0.55))
				draw_arc(c + Vector2(0, 2), 20, PI * 0.15, PI * 0.85, 8, Color(0.55, 0.7, 0.9, 0.6), 2.0)
			"hauteur":
				draw_colored_polygon(PackedVector2Array([c + Vector2(-26, 12), c + Vector2(0, -18), c + Vector2(26, 12)]), Color(0.75, 0.75, 0.80, 0.75))
				draw_colored_polygon(PackedVector2Array([c + Vector2(-8, -4), c + Vector2(0, -18), c + Vector2(8, -4), c + Vector2(0, -10)]), Color(0.95, 0.97, 1.0, 0.9))
			"buisson":
				draw_circle(c + Vector2(-10, 2), 10, Color(0.15, 0.45, 0.18, 0.6))
				draw_circle(c + Vector2(8, 4), 12, Color(0.18, 0.52, 0.22, 0.6))
				draw_circle(c + Vector2(0, -6), 9, Color(0.22, 0.58, 0.26, 0.6))


## Unité posée sur une case : son sprite en pied (à la place d'une carte compacte) + gemmes ATQ/PV, pastilles PA/PM/PO, étoile de sort et mots-clés.
class _UnitView extends Control:
	signal tapped(view)

	const KW_STYLE := {
		"vol": ["V", Color(0.85, 0.25, 0.30)],
		"perforation": ["F", Color(0.95, 0.60, 0.20)],
		"provocation": ["T", Color(0.60, 0.65, 0.90)],
		"regeneration": ["R", Color(0.35, 0.85, 0.40)],
		"initiative": ["I", Color(0.45, 0.85, 0.95)],
	}

	var card: Dictionary = {}
	var selected: bool = false
	var target_ok: bool = false
	var ready_glow: bool = false
	var side: int = 0
	var team_col: Color = Color(0.45, 0.72, 1.0)
	var _t: float = 0.0

	func _ready() -> void:
		mouse_filter = Control.MOUSE_FILTER_STOP
		set_process(true)

	func _process(dt: float) -> void:
		_t += dt
		if target_ok or ready_glow or selected:
			queue_redraw()

	func _gui_input(event: InputEvent) -> void:
		if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			tapped.emit(self)
			accept_event()

	func set_card(c: Dictionary) -> void:
		card = c
		queue_redraw()

	func _gem(c: Vector2, r: float, val: String, col: Color) -> void:
		var font: Font = ThemeDB.fallback_font
		draw_circle(c, r + 2.0, Color(0.05, 0.05, 0.08))
		draw_circle(c, r, col)
		draw_circle(c + Vector2(-r * 0.25, -r * 0.3), r * 0.45, Color(1, 1, 1, 0.18))
		draw_arc(c, r, 0, TAU, 24, col.lightened(0.45), 2.0)
		var fs: int = int(r * 1.15)
		draw_string(font, c + Vector2(-r, fs * 0.36), val, HORIZONTAL_ALIGNMENT_CENTER, r * 2.0, fs, Color(1, 1, 1))

	func _star(c: Vector2, r: float, col: Color) -> void:
		var pts := PackedVector2Array()
		for i in 10:
			var an: float = -PI * 0.5 + TAU * float(i) / 10.0
			var rr: float = r if i % 2 == 0 else r * 0.45
			pts.append(c + Vector2(cos(an), sin(an)) * rr)
		draw_colored_polygon(pts, col)

	func _pulse_ellipse(c: Vector2, rx: float, ry: float, col: Color, wd: float) -> void:
		var a: float = 0.55 + 0.45 * sin(_t * 6.0)
		var pts := PackedVector2Array()
		for i in 40:
			var an: float = TAU * float(i) / 40.0
			pts.append(c + Vector2(cos(an) * rx, sin(an) * ry))
		pts.append(pts[0])
		draw_polyline(pts, Color(col.r, col.g, col.b, col.a * a), wd, true)

	func _draw() -> void:
		var w: float = size.x
		var h: float = size.y
		if w < 10.0 or card.is_empty():
			return
		var font: Font = ThemeDB.fallback_font
		var spr: float = minf(w * 0.72, h * 2.05)
		var art := Rect2((w - spr) * 0.5, h - spr, spr, spr)
		var feet := Vector2(w * 0.5, h - 5.0)
		var sh := PackedVector2Array()
		for i in 24:
			var a0: float = TAU * float(i) / 24.0
			sh.append(feet + Vector2(cos(a0) * spr * 0.32, sin(a0) * spr * 0.09))
		draw_colored_polygon(sh, Color(0, 0, 0, 0.35))
		var ring := PackedVector2Array()
		for i in 32:
			var a1: float = TAU * float(i) / 32.0
			ring.append(feet + Vector2(cos(a1) * spr * 0.36, sin(a1) * spr * 0.105))
		ring.append(ring[0])
		draw_colored_polygon(ring.slice(0, 32), Color(team_col.r, team_col.g, team_col.b, 0.22))
		draw_polyline(ring, Color(team_col.r, team_col.g, team_col.b, 0.9), 3.0, true)
		if target_ok:
			_pulse_ellipse(feet, spr * 0.40, spr * 0.12, Color(1.0, 0.35, 0.3, 0.95), 4.0)
		elif ready_glow:
			_pulse_ellipse(feet, spr * 0.40, spr * 0.12, Color(0.4, 1.0, 0.5, 0.85), 3.0)
		if selected:
			_pulse_ellipse(feet, spr * 0.45, spr * 0.14, Color(1.0, 0.85, 0.25, 1.0), 5.0)
		var tex: Texture2D = JccCardView.art_texture(String(card.get("sprite", "")))
		if tex != null:
			var ts: Vector2 = tex.get_size()
			var sc: float = minf(art.size.x / ts.x, art.size.y / ts.y)
			draw_texture_rect(tex, Rect2(art.position + (art.size - ts * sc) * 0.5, ts * sc), false)
		else:
			draw_rect(art, Color(0.20, 0.26, 0.38))
			draw_rect(art, Color(0.5, 0.6, 0.8), false, 2.0)
		if bool(card.get("used", false)) or bool(card.get("sick", false)) or int(card.get("stun", 0)) > 0 or bool(card.get("frozen", false)):
			draw_rect(art, Color(0, 0, 0, 0.35))
		var name_txt: String = String(card.get("name", ""))
		if name_txt != "":
			var fs: int = 16
			var nw: float = font.get_string_size(name_txt, HORIZONTAL_ALIGNMENT_LEFT, -1, fs).x
			var cap: float = w - 30.0
			while nw > cap and fs > 10:
				fs -= 1
				nw = font.get_string_size(name_txt, HORIZONTAL_ALIGNMENT_LEFT, -1, fs).x
			var pb := StyleBoxFlat.new()
			pb.bg_color = Color(0.05, 0.06, 0.10, 0.78)
			pb.set_corner_radius_all(9)
			draw_style_box(pb, Rect2(w * 0.5 - nw * 0.5 - 7.0, art.position.y - 24.0, nw + 14.0, 20.0))
			draw_string(font, Vector2(w * 0.5 - nw * 0.5, art.position.y - 9.0), name_txt, HORIZONTAL_ALIGNMENT_LEFT, nw + 2.0, fs, Color(1, 0.97, 0.88))
		var sx: float = art.position.x + 4.0
		var sy: float = art.position.y + 16.0
		if int(card.get("stun", 0)) > 0 or bool(card.get("frozen", false)):
			draw_string(font, Vector2(sx, sy), "ZZ", HORIZONTAL_ALIGNMENT_LEFT, -1, 20, Color(0.55, 0.85, 1.0))
			sx += 34.0
		var pn: int = 0
		for pe: Variant in card.get("poison", []):
			pn += int((pe as Dictionary)["n"])
		if pn > 0:
			var dc := Vector2(sx + 8.0, sy - 8.0)
			draw_colored_polygon(PackedVector2Array([dc + Vector2(0, -9), dc + Vector2(6, 3), dc + Vector2(0, 8), dc + Vector2(-6, 3)]), Color(0.45, 0.9, 0.3))
			draw_string(font, dc + Vector2(10, 5), str(pn), HORIZONTAL_ALIGNMENT_LEFT, -1, 15, Color(0.7, 1.0, 0.5))
		var rx: float = art.end.x - 6.0
		if String(card.get("sort", "")) != "":
			var usable: bool = ready_glow and not bool(card.get("used", false)) and not bool(card.get("sick", false))
			_star(Vector2(rx - 12.0, art.position.y + 14.0), 9.0, Color(0.95, 0.8, 1.0) if usable else Color(0.5, 0.5, 0.6))
			rx -= 26.0
		var kws: Array = card.get("keywords", [])
		for i in kws.size():
			var kw: String = String(kws[i])
			var st: Array = KW_STYLE.get(kw, [kw.left(1).to_upper(), Color(0.7, 0.7, 0.8)])
			var kc := Vector2(rx - 12.0 - float(i) * 24.0, art.position.y + 14.0)
			draw_circle(kc, 11.0, Color(0.05, 0.05, 0.08))
			draw_circle(kc, 9.0, (st[1] as Color).darkened(0.35))
			draw_arc(kc, 9.0, 0, TAU, 16, st[1] as Color, 1.6)
			draw_string(font, kc + Vector2(-5, 5), String(st[0]), HORIZONTAL_ALIGNMENT_LEFT, 10.0, 13, Color(1, 1, 1))
		_gem(Vector2(26.0, h - 22.0), 16.0, str(int(card.get("atk", 0))), Color(0.92, 0.55, 0.15))
		var hp: int = int(card.get("hp", 0))
		var mx: int = int(card.get("max_hp", hp))
		_gem(Vector2(w - 26.0, h - 22.0), 16.0, str(maxi(hp, 0)), Color(0.85, 0.20, 0.22) if hp >= mx else Color(0.60, 0.14, 0.16))
		var pips := [["PA", int(card.get("pa", 1)), Color(0.75, 0.45, 1.0)], ["PM", int(card.get("pm", 2)), Color(0.4, 0.8, 0.9)], ["PO", int(card.get("po", 1)), Color(0.5, 0.9, 0.5)]]
		var px: float = w * 0.5 - 39.0
		for pip in pips:
			var empty: bool = int(pip[1]) <= 0
			var col: Color = pip[2] as Color
			var pc := Vector2(px + 13.0, h - 13.0)
			draw_circle(pc, 11.0, Color(0.05, 0.05, 0.08))
			draw_circle(pc, 9.0, col.darkened(0.45) if empty else col.darkened(0.15))
			draw_arc(pc, 9.0, 0, TAU, 14, col if not empty else Color(0.4, 0.4, 0.45), 1.5)
			draw_string(font, pc + Vector2(-8, 4), String(pip[0]), HORIZONTAL_ALIGNMENT_LEFT, 16.0, 11, Color(0.55, 0.55, 0.6) if empty else Color(1, 1, 1))
			px += 26.0


func _cell_pos(cell: int) -> Vector2:
	return BOARD.position + Vector2(float(cell % JccDuel.COLS) * CELL.x, float(cell / JccDuel.COLS) * CELL.y)


func _hero_sprite(side: int) -> String:
	if side == 1:
		return String(_opp.get("sprite", ""))
	var cls: String = String(ProgressionManager.adventure_state(_save).get("hero_class", "Mage"))
	var key: String = cls.to_lower().replace("é", "e").replace("è", "e").replace(" ", "")
	return "players/" + key


func _hero_name(side: int) -> String:
	return String(_opp.get("name", "Adversaire")) if side == 1 else "Vous"


## Sprite du héros pour son camp (image entière, pas le portrait) : {tex, reg} ou vide.
func _camp_art(side: int) -> Dictionary:
	var sprite: String = _hero_sprite(side)
	var tex: Texture2D = JccCardView.art_texture(sprite)
	if tex == null:
		return {}
	return {"tex": tex, "reg": Rect2(Vector2.ZERO, tex.get_size())}


func _make_hero_panel(side: int, r: Rect2) -> Control:
	var p := Control.new()
	p.position = r.position
	p.size = r.size
	p.gui_input.connect(func(ev: InputEvent) -> void:
		if ev is InputEventMouseButton and ev.pressed and ev.button_index == MOUSE_BUTTON_LEFT:
			_on_hero(side))
	_root.add_child(p)
	return p


func _refresh_hero(side: int) -> void:
	var p: Control = _hero_nodes[side]
	for c: Node in p.get_children():
		c.queue_free()
	var sd: Dictionary = _duel.side(side)
	var hot: bool = _is_target(side, -1)
	var panel := Panel.new()
	panel.size = p.size
	var bcol: Color = Color(1.0, 0.85, 0.2) if hot else (_foe_accent if side == 1 else Color(0.45, 0.75, 1.0))
	panel.add_theme_stylebox_override("panel", _panel_sb(Color(0.07, 0.09, 0.14, 0.95), bcol, 16, 5 if hot else 3, 10))
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	p.add_child(panel)
	var tex: Texture2D = JccCardView.art_texture(_hero_sprite(side))
	var sprite: String = _hero_sprite(side)
	var portrait := Control.new()
	portrait.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if side == 1:
		portrait.position = Vector2(10, 8)
		portrait.size = Vector2(88, 88)
	else:
		portrait.position = Vector2(20, 18)
		portrait.size = Vector2(130, 130)
	p.add_child(portrait)
	if tex != null:
		var tr := TextureRect.new()
		var at := AtlasTexture.new()
		at.atlas = tex
		at.region = JccCardView.art_region(tex, sprite)
		tr.texture = at
		tr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		tr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		tr.size = portrait.size
		tr.mouse_filter = Control.MOUSE_FILTER_IGNORE
		portrait.add_child(tr)
	var hp: int = int(sd["hero_hp"])
	if side == 1:
		var nm: Label = UiKit.lbl(_hero_name(side), 30, UiKit.C_TXT, true)
		nm.position = Vector2(110, 4)
		nm.mouse_filter = Control.MOUSE_FILTER_IGNORE
		p.add_child(nm)
		var info: Label = UiKit.lbl("Main : %d   Pioche : %d   Mana : %d/%d" % [(sd["hand"] as Array).size(), (sd["deck"] as Array).size(), int(sd["mana"]), int(sd["mana_max"])], 21, UiKit.C_DIM)
		info.position = Vector2(110, 52)
		info.mouse_filter = Control.MOUSE_FILTER_IGNORE
		p.add_child(info)
		_hp_gem(p, Vector2(p.size.x - 56, 52), 36, hp)
		if String(_opp.get("boss", "")) != "":
			var bd: Label = UiKit.lbl("👑 BOSS", 20, UiKit.C_GOLD, true)
			bd.position = Vector2(p.size.x - 200, 8)
			bd.mouse_filter = Control.MOUSE_FILTER_IGNORE
			p.add_child(bd)
	else:
		var nm2: Label = UiKit.lbl("Vous", 34, UiKit.C_TXT, true)
		nm2.position = Vector2(170, 100)
		nm2.mouse_filter = Control.MOUSE_FILTER_IGNORE
		p.add_child(nm2)
		_hp_gem(p, Vector2(p.size.x - 62, 62), 44, hp)
		var ml: Label = UiKit.lbl("MANA  %d / %d" % [int(sd["mana"]), int(sd["mana_max"])], 30, Color(0.6, 0.85, 1.0), true)
		ml.position = Vector2(24, 170)
		ml.mouse_filter = Control.MOUSE_FILTER_IGNORE
		p.add_child(ml)
		_mana_node = Control.new()
		_mana_node.position = Vector2(24, 220)
		_mana_node.size = Vector2(300, 110)
		_mana_node.mouse_filter = Control.MOUSE_FILTER_IGNORE
		p.add_child(_mana_node)
		for i: int in JccDuel.MANA_MAX:
			var gem := ColorRect.new()
			gem.size = Vector2(26, 26)
			gem.position = Vector2(float(i % 5) * 58.0 + 6.0, float(i / 5) * 54.0 + 6.0)
			gem.rotation = PI / 4.0
			gem.pivot_offset = Vector2(13, 13)
			if i < int(sd["mana"]):
				gem.color = Color(0.35, 0.7, 1.0)
			elif i < int(sd["mana_max"]):
				gem.color = Color(0.15, 0.25, 0.4)
			else:
				gem.color = Color(0.1, 0.12, 0.16)
			gem.mouse_filter = Control.MOUSE_FILTER_IGNORE
			_mana_node.add_child(gem)


func _hp_gem(parent: Control, c: Vector2, r: float, hp: int) -> void:
	var g := _GemDraw.new()
	g.position = c - Vector2(r, r)
	g.size = Vector2(r * 2, r * 2)
	g.r = r
	g.text = str(maxi(hp, 0))
	g.col = Color(0.85, 0.2, 0.22) if hp > 10 else Color(0.95, 0.1, 0.1)
	g.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(g)


class _GemDraw extends Control:
	var r: float = 30.0
	var text: String = ""
	var col: Color = Color.RED

	func _draw() -> void:
		var c := Vector2(r, r)
		draw_circle(c, r, Color(0.05, 0.05, 0.08))
		draw_circle(c, r - 3.0, col)
		draw_circle(c + Vector2(-r * 0.25, -r * 0.3), r * 0.4, Color(1, 1, 1, 0.18))
		draw_arc(c, r - 3.0, 0, TAU, 28, col.lightened(0.45), 3.0)
		var fs: int = int(r * 1.0)
		draw_string(ThemeDB.fallback_font, c + Vector2(-r, fs * 0.36), text, HORIZONTAL_ALIGNMENT_CENTER, r * 2.0, fs, Color.WHITE)


# ─── Rafraîchissement ────────────────────────────────────────────────────────

func _refresh() -> void:
	for c: Node in _cards_layer.get_children():
		c.queue_free()
	_board_views = {}
	_hand_views = []
	_targets = _compute_targets()
	_range_cells = []
	var rsrc: int = -1
	if not _pending.is_empty():
		if String(_pending.get("kind", "")) == "attack":
			rsrc = int(_pending["lane"])
	elif _sel_hand < 0 and _sel_cell >= 0:
		rsrc = _sel_cell
	if rsrc >= 0 and _duel.creature_at(0, rsrc) != null:
		var rpo: int = int((_duel.creature_at(0, rsrc) as Dictionary).get("po", 1))
		for rc in JccDuel.LANES:
			var dd: int = _duel.manhattan_cell(rsrc, rc)
			if dd >= 1 and dd <= rpo:
				_range_cells.append(rc)
	_foe_moves = []
	_foe_threat = []
	if _inspect.is_empty() or _duel.creature_at(1, _inspect_cell) == null:
		_inspect_cell = -1
	if _inspect_cell >= 0:
		var fpo: int = int((_duel.creature_at(1, _inspect_cell) as Dictionary).get("po", 1))
		for mt: Variant in _duel.move_targets(1, _inspect_cell):
			_foe_moves.append(int((mt as Dictionary)["lane"]))
		var reach: Array = [_inspect_cell] + _foe_moves
		for rc2 in JccDuel.LANES:
			for src2 in reach:
				var d2: int = _duel.manhattan_cell(int(src2), rc2)
				if d2 >= 1 and d2 <= fpo:
					_foe_threat.append(rc2)
					break
	for cell in JccDuel.LANES:
		var slot: _CellNode = _slots["%d" % cell]
		var occ: Dictionary = _duel.occupant(cell)
		var empty_ok: bool = occ.is_empty() and _is_target_any(cell)
		slot.terrain = _duel.terrain_at(cell)
		slot.border = Color(1.0, 0.85, 0.2, 0.9) if empty_ok else Color(1, 1, 1, 0.14)
		slot.bw = 5.0 if empty_ok else 2.0
		if _is_move_target(cell):
			slot.fill = Color(0.30, 0.60, 1.0, 0.22)
		elif cell in _range_cells:
			slot.fill = Color(1.0, 0.30, 0.25, 0.20)
		elif _inspect_cell >= 0 and cell in _foe_moves:
			slot.fill = Color(1.0, 0.55, 0.15, 0.30)
		elif _inspect_cell >= 0 and cell in _foe_threat:
			slot.fill = Color(0.85, 0.15, 0.45, 0.22)
		elif _duel.deploy_rows(0).has(_duel.cell_xy(cell).y):
			slot.fill = Color(0.30, 0.60, 1.0, 0.11)
		elif _duel.deploy_rows(1).has(_duel.cell_xy(cell).y):
			slot.fill = Color(_foe_accent.r, _foe_accent.g, _foe_accent.b, 0.13)
		else:
			slot.fill = Color(0, 0, 0, 0.20)
		slot.queue_redraw()
		if occ.is_empty():
			continue
		var side: int = int(occ["side"])
		var cr: Dictionary = occ["unit"]
		var v := _UnitView.new()
		var us: float = float(_cell_scale[cell])
		v.size = CELL
		v.scale = Vector2(us, us)
		v.position = (_cell_ctr[cell] as Vector2) - CELL * us * 0.5
		v.side = side
		v.team_col = _foe_accent.lightened(0.15) if side == 1 else Color(0.45, 0.72, 1.0)
		v.set_card(cr)
		v.target_ok = _is_target(side, cell)
		v.selected = side == 0 and _sel_cell == cell
		if side == 0 and not _over:
			v.ready_glow = _duel.can_attack(0, cell) or _duel.can_use_sort(0, cell) or not _duel.move_targets(0, cell).is_empty()
		v.tapped.connect(func(_vw) -> void: _on_board_card(side, cell))
		_cards_layer.add_child(v)
		_board_views["%d:%d" % [side, cell]] = v
	_draw_previews()
	_refresh_hand()
	_refresh_hero(0)
	_refresh_hero(1)
	_refresh_action_bar()
	_refresh_info()
	var sd: Dictionary = _duel.side(0)
	_pile_lbl.text = "Pioche : %d" % (sd["deck"] as Array).size()
	_end_btn.disabled = _busy or _duel.current != 0 or _over
	_power_btn.visible = not _over and not _busy and _duel.can_use_hero_power(0)
	if not ( _duel.side(0)["power"] as Dictionary).is_empty():
		_power_btn.text = "⚡ %s" % String(_duel.side(0)["power"].get("name", "Pouvoir"))
	_power_btn.disabled = not _power_btn.visible
	_mull_btn.visible = not _over and not _busy and _duel.can_mulligan(0)
	_mull_btn.disabled = not _mull_btn.visible
	_end_btn.text = "Fin du tour" if _duel.current == 0 else "Tour adverse…"
	var lines: Array = _duel.log.slice(maxi(0, _duel.log.size() - 7))
	_log_lbl.text = "\n".join(PackedStringArray(lines))


## Aperçu de l'effet annoncé : texte court d'un effet de sort.
func _effect_preview(effet: String, valeur: String) -> String:
	var v: int = int(valeur) if valeur.is_valid_int() else 0
	match effet:
		"degats", "degats_zone", "degats_heros":
			return "-%d" % v
		"soin", "soin_zone":
			return "+%d PV" % v
		"bouclier", "bouclier_zone":
			return "+%d PV max" % v
		"atq", "atq_zone":
			return "+%d ATQ" % v
		"etourdir", "etourdir_zone":
			return "ZZ"
		"poison":
			return "poison %d" % v
	return ""


## Aperçu sur chaque cible valide (attaque : dégâts et riposte ; sort : valeur de l'effet).
func _draw_previews() -> void:
	if _busy or _over or _targets.is_empty():
		return
	var kind: String = ""
	var effet: String = ""
	var valeur: String = ""
	var atk: int = 0
	if not _pending.is_empty():
		var src: Dictionary = _duel.creature_at(0, int(_pending["lane"])) if _pending.has("lane") else {}
		if src.is_empty():
			return
		if String(_pending["kind"]) == "attack":
			kind = "attack"
			atk = int(src["atk"])
		else:
			kind = "sort"
			effet = String(src["effet"])
			valeur = String(src["valeur"])
	elif _sel_hand >= 0 and _sel_hand < (_duel.side(0)["hand"] as Array).size():
		var c: Dictionary = (_duel.side(0)["hand"] as Array)[_sel_hand]
		if String(c["type"]) != "Sort":
			return
		kind = "sort"
		effet = String(c["effet"])
		valeur = String(c["valeur"])
	else:
		return
	for t: Variant in _targets:
		var td: Dictionary = t
		if td.is_empty():
			continue
		var side: int = int(td["side"])
		var lane: int = int(td["lane"])
		var txt: String = ""
		var col := Color(1.0, 0.85, 0.3)
		if kind == "attack":
			txt = "-%d" % atk
			if lane >= 0:
				var tgt: Variant = _duel.creature_at(side, lane)
				if tgt != null:
					txt += "  riposte -%d" % int((tgt as Dictionary)["atk"])
			col = Color(1.0, 0.55, 0.45)
		else:
			txt = _effect_preview(effet, valeur)
			if txt.begins_with("+"):
				col = Color(0.5, 1.0, 0.6)
		if txt == "":
			continue
		var c0: Vector2 = _node_center(side, lane)
		var off: float = 62.0 * (float(_cell_scale[lane]) if lane >= 0 else 1.0)
		var lb: Label = UiKit.lbl(txt, 26, col, true)
		lb.size = Vector2(240, 36)
		lb.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		lb.position = c0 - Vector2(120, off)
		lb.mouse_filter = Control.MOUSE_FILTER_IGNORE
		lb.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.95))
		lb.add_theme_constant_override("outline_size", 8)
		_cards_layer.add_child(lb)


func _refresh_hand() -> void:
	var hand: Array = _duel.side(0)["hand"]
	var n: int = hand.size()
	var step: float = HAND_CARD.x + 12.0
	if n > 1:
		step = minf(step, (HAND_X1 - HAND_X0 - HAND_CARD.x) / float(n - 1))
	var total: float = HAND_CARD.x + step * float(maxi(n - 1, 0))
	var x0: float = (HAND_X0 + HAND_X1) * 0.5 - total * 0.5
	for i: int in n:
		var v := JccCardView.new()
		v.size = HAND_CARD
		var lift: float = 0.0
		v.set_card(hand[i] as Dictionary)
		v.playable = _duel.can_play(0, i) and not _busy
		v.selected = i == _sel_hand
		if i == _sel_hand:
			lift = -46.0
		v.position = Vector2(x0 + step * float(i), HAND_Y + lift)
		v.tapped.connect(func(_vw: JccCardView) -> void: _on_hand_card(i))
		_cards_layer.add_child(v)
		_hand_views.append(v)
	# la carte sélectionnée passe au premier plan
	if _sel_hand >= 0 and _sel_hand < _hand_views.size():
		_cards_layer.move_child(_hand_views[_sel_hand], -1)


func _refresh_info() -> void:
	for c: Node in _info_holder.get_children():
		c.queue_free()
	var bg := Panel.new()
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	bg.add_theme_stylebox_override("panel", _panel_sb(Color(0.06, 0.08, 0.13, 0.92), Color(0.42, 0.50, 0.66), 18, 3, 10))
	_info_holder.add_child(bg)
	var card: Dictionary = {}
	if _sel_hand >= 0 and _sel_hand < (_duel.side(0)["hand"] as Array).size():
		card = (_duel.side(0)["hand"] as Array)[_sel_hand]
	elif _sel_cell >= 0 and _duel.creature_at(0, _sel_cell) != null:
		card = _duel.creature_at(0, _sel_cell)
	elif not _inspect.is_empty():
		card = _inspect
	if card.is_empty():
		var hint: Label = UiKit.lbl("Touchez une carte pour la voir en grand.\n\nUne créature attaque à portée PO (1 PA) et se déplace case par case (1 PM par case).", 22, UiKit.C_DIM)
		hint.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		hint.custom_minimum_size = Vector2(330, 0)
		hint.position = Vector2(10, 12)
		_info_holder.add_child(hint)
		return
	var v := JccCardView.new()
	v.size = Vector2(_info_holder.size.x - 16.0, _info_holder.size.y - 16.0)
	v.position = Vector2(8, 8)
	v.set_card(card)
	v.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_info_holder.add_child(v)


func _refresh_action_bar() -> void:
	for c: Node in _action_bar.get_children():
		c.queue_free()
	if _busy or _over:
		return
	if not _pending.is_empty():
		var hint: Label = UiKit.lbl("Choisissez une cible (liseré doré)", 26, UiKit.C_GOLD, true)
		_action_bar.add_child(hint)
		var cancel: Button = UiKit.btn("Annuler", Color(0.8, 0.45, 0.4), 22, Vector2(150, 56))
		cancel.pressed.connect(_cancel_selection)
		_action_bar.add_child(cancel)
		return
	if _sel_hand >= 0 and _sel_hand < (_duel.side(0)["hand"] as Array).size():
		var c: Dictionary = (_duel.side(0)["hand"] as Array)[_sel_hand]
		if _duel.can_play(0, _sel_hand):
			var needs: bool = String(c["type"]) == "Creature" or _duel.needs_target(String(c["cible"]))
			var txt: String = "Posez-la sur une case libre de vos 2 lignes (côté héros)" if String(c["type"]) == "Creature" else ("Choisissez une cible" if needs else "")
			if needs:
				_action_bar.add_child(UiKit.lbl(txt, 26, UiKit.C_GOLD, true))
			else:
				var play: Button = UiKit.btn("▶  Jouer %s" % String(c["name"]), Color(0.35, 0.8, 0.45), 24, Vector2(320, 60))
				play.pressed.connect(func() -> void: _play_hand(_sel_hand, {}))
				_action_bar.add_child(play)
		else:
			var why: String = _duel.play_block_reason(0, _sel_hand)
			if _duel.current != 0:
				why = "Ce n'est pas votre tour"
			_action_bar.add_child(UiKit.lbl(why, 24, UiKit.C_BAD, true))
		return
	if _sel_cell >= 0 and _duel.creature_at(0, _sel_cell) != null:
		var cr: Dictionary = _duel.creature_at(0, _sel_cell)
		var cell: int = _sel_cell
		var atk: Button = UiKit.btn("⚔ Attaquer · 1 PA", Color(0.95, 0.5, 0.3), 24, Vector2(300, 64))
		atk.disabled = not _duel.can_attack(0, cell)
		atk.pressed.connect(func() -> void: _begin_attack(cell))
		_action_bar.add_child(atk)
		var why_a: String = _duel.attack_block_reason(0, cell)
		if atk.disabled and why_a != "":
			_action_bar.add_child(UiKit.lbl(why_a, 24, UiKit.C_BAD))
		if String(cr["sort"]) != "":
			var sb: Button = UiKit.btn("✦ %s (%d mana · 1 PA)" % [String(cr["sort"]), int(cr["sort_cost"])], Color(0.7, 0.45, 1.0), 24, Vector2(400, 64))
			sb.disabled = not _duel.can_use_sort(0, cell)
			sb.pressed.connect(func() -> void: _begin_sort(cell))
			_action_bar.add_child(sb)
			var why_s: String = _duel.sort_block_reason(0, cell)
			if sb.disabled and why_s != "":
				_action_bar.add_child(UiKit.lbl(why_s, 24, UiKit.C_BAD))
		var mv: Array = _duel.move_targets(0, cell)
		var hint: Label = UiKit.lbl("PM %d — touchez une case dorée pour vous déplacer" % int(cr.get("pm", 0)), 24, Color(0.6, 0.85, 1.0) if not mv.is_empty() else UiKit.C_DIM)
		_action_bar.add_child(hint)


# ─── Cibles ──────────────────────────────────────────────────────────────────

func _compute_targets() -> Array:
	if not _pending.is_empty():
		if String(_pending["kind"]) == "attack":
			return _duel.attack_targets(0, int(_pending["lane"]))
		if String(_pending["kind"]) == "power":
			return _duel.hero_power_targets(0)
		return _duel.targets_for(0, String(_pending["cible"]))
	if _sel_hand >= 0 and _sel_hand < (_duel.side(0)["hand"] as Array).size():
		var c: Dictionary = (_duel.side(0)["hand"] as Array)[_sel_hand]
		if _duel.can_play(0, _sel_hand):
			var cible: String = "voie" if String(c["type"]) == "Creature" else String(c["cible"])
			if _duel.needs_target(cible):
				return _duel.targets_for(0, cible)
	elif _sel_cell >= 0 and _duel.creature_at(0, _sel_cell) != null:
		return _duel.move_targets(0, _sel_cell)
	return []


func _is_target(side: int, lane: int) -> bool:
	for t: Variant in _targets:
		var td: Dictionary = t
		if not td.is_empty() and int(td["side"]) == side and int(td["lane"]) == lane:
			return true
	return false


func _is_target_any(cell: int) -> bool:
	for t: Variant in _targets:
		var td: Dictionary = t
		if not td.is_empty() and int(td["lane"]) == cell:
			return true
	return false


func _is_move_target(cell: int) -> bool:
	if _sel_cell < 0 or _duel.creature_at(0, _sel_cell) == null:
		return false
	for t: Variant in _duel.move_targets(0, _sel_cell):
		if int((t as Dictionary)["lane"]) == cell:
			return true
	return false


func _cancel_selection() -> void:
	_sel_hand = -1
	_sel_cell = -1
	_pending = {}
	_inspect = {}
	if _duel != null and not _over:
		_refresh()


# ─── Saisies ─────────────────────────────────────────────────────────────────

func _on_hand_card(i: int) -> void:
	if _busy or _over:
		return
	if _sel_hand == i:
		# 2e touche : joue directement si aucune cible n'est à choisir
		var c: Dictionary = (_duel.side(0)["hand"] as Array)[i]
		if _duel.can_play(0, i) and String(c["type"]) != "Creature" and not _duel.needs_target(String(c["cible"])):
			_play_hand(i, {})
			return
		_cancel_selection()
		return
	_sel_hand = i
	_sel_cell = -1
	_pending = {}
	_refresh()


func _on_board_card(side: int, cell: int) -> void:
	if _busy or _over:
		return
	if _is_target(side, cell):
		_apply_target({"side": side, "lane": cell})
		return
	if side == 0:
		if _sel_cell == cell:
			_cancel_selection()
			return
		_sel_cell = cell
		_sel_hand = -1
		_pending = {}
		_inspect = {}
		_refresh()
	else:
		_inspect = _duel.creature_at(1, cell)
		_inspect_cell = cell
		_sel_hand = -1
		_sel_cell = -1
		_pending = {}
		_refresh()


func _on_slot(cell: int) -> void:
	if _busy or _over:
		return
	if not _pending.is_empty():
		# la cible cliquée peut être un camp ou l'autre selon l'occupant de la case
		var occ: Dictionary = _duel.occupant(cell)
		var side: int = int(occ["side"]) if not occ.is_empty() else int(_pending.get("side", 0))
		_apply_target({"side": side, "lane": cell})
		return
	if _sel_hand >= 0 and _is_target(0, cell):
		_play_hand(_sel_hand, {"side": 0, "lane": cell})
		return
	if _sel_cell >= 0 and _is_move_target(cell):
		_do_move(_sel_cell, cell)


func _on_hero(side: int) -> void:
	if _busy or _over:
		return
	if _is_target(side, -1):
		_apply_target({"side": side, "lane": -1})


## Une cible a été touchée : joue la carte / le sort / l'attaque en attente.
func _apply_target(t: Dictionary) -> void:
	if not _pending.is_empty():
		var lane: int = int(_pending["lane"])
		var kind: String = String(_pending["kind"])
		_pending = {}
		if kind == "power":
			_do_power(t)
		elif kind == "attack":
			_do_attack_target(lane, t)
		else:
			_use_sort(lane, t)
	elif _sel_hand >= 0:
		_play_hand(_sel_hand, t)


func _on_power_pressed() -> void:
	if _busy or _duel == null or not _duel.can_use_hero_power(0):
		return
	var pw: Dictionary = _duel.side(0)["power"]
	if _duel.needs_target(String(pw["cible"])):
		_pending = {"kind": "power", "lane": -1, "cible": String(pw["cible"])}
		_refresh()
	else:
		_do_power({})


func _do_power(t: Dictionary) -> void:
	if _busy or _duel == null:
		return
	_busy = true
	var pname: String = String(_duel.side(0)["power"].get("name", "Pouvoir"))
	if _duel.use_hero_power(0, t):
		_sel_hand = -1
		_sel_cell = -1
		await _after_action("⚡ %s" % pname)
	_busy = false
	_finish_if_over()
	_refresh()


func _on_mulligan() -> void:
	if _busy or _duel == null or not _duel.can_mulligan(0):
		return
	_busy = true
	if _duel.mulligan(0):
		await _after_action("Nouvelle main")
	_busy = false
	_refresh()


func _begin_sort(lane: int) -> void:
	var cr: Dictionary = _duel.creature_at(0, lane)
	var cible: String = String(cr["cible"])
	if _duel.needs_target(cible):
		_pending = {"kind": "sort", "lane": lane, "cible": cible}
		_refresh()
	else:
		_use_sort(lane, {})


func _on_end_turn() -> void:
	if _busy or _over or _duel.current != 0:
		return
	_cancel_selection_silent()
	_run_enemy_turn()


func _cancel_selection_silent() -> void:
	_sel_hand = -1
	_sel_cell = -1
	_pending = {}
	_inspect = {}


func _on_quit_duel() -> void:
	if _over or _busy:
		return
	_confirm("Abandonner le duel ? (compté comme une défaite)", func() -> void:
		var j: Dictionary = JccCollection.ensure(_save)
		j["losses"] = int(j["losses"]) + 1
		_save_now()
		_show_hub())


# ─── Actions (animées) ───────────────────────────────────────────────────────

func _play_hand(i: int, target: Dictionary) -> void:
	_busy = true
	var name_txt: String = String(((_duel.side(0)["hand"] as Array)[i] as Dictionary)["name"])
	var ok: bool = _duel.play_card(0, i, target)
	_cancel_selection_silent()
	if ok:
		await _after_action("Vous jouez %s" % name_txt)
	_busy = false
	_finish_if_over()
	_refresh()


func _use_sort(lane: int, target: Dictionary) -> void:
	_busy = true
	var ok: bool = _duel.use_sort(0, lane, target)
	if ok:
		_sel_cell = lane
		await _after_action("")
	_busy = false
	_finish_if_over()
	_refresh()


## Attaque : passe en mode ciblage (les cibles à portée PO s'illuminent).
func _begin_attack(cell: int) -> void:
	if _busy or not _duel.can_attack(0, cell):
		return
	_pending = {"kind": "attack", "lane": cell, "cible": "_atk", "side": 1}
	_refresh()


func _do_attack_target(cell: int, t: Dictionary) -> void:
	if _busy or not _duel.can_attack(0, cell):
		return
	_busy = true
	await _lunge(0, cell)
	await get_tree().create_timer(0.18).timeout
	if _duel.attack(0, cell, t):
		_sel_cell = -1
		await _after_action("")
	_busy = false
	_finish_if_over()
	_refresh()


func _do_move(from: int, to: int) -> void:
	if _busy:
		return
	if _duel.move(0, from, to):
		_sel_cell = to
		_duel.take_events()
		_refresh()


func _lunge(side: int, lane: int) -> void:
	var v: Control = _board_views.get("%d:%d" % [side, lane])
	if v == null:
		return
	var dir: float = -1.0 if side == 0 else 1.0
	var p0: Vector2 = v.position
	_cards_layer.move_child(v, -1)
	var tw: Tween = create_tween()
	tw.tween_property(v, "position", p0 + Vector2(0, dir * 60.0), 0.12).set_ease(Tween.EASE_IN)
	await tw.finished


## Après une action du moteur : redessine puis joue les effets (chiffres, secousses, bandeau).
func _after_action(msg: String) -> void:
	var evs: Array = _duel.take_events()
	_refresh()
	if msg != "":
		_toast_msg(msg)
	for e: Variant in evs:
		_show_event(e as Dictionary)
	await get_tree().create_timer(0.55).timeout


func _node_center(side: int, cell: int) -> Vector2:
	if cell < 0:
		var p: Control = _hero_nodes[side]
		return p.position + p.size * 0.5
	return _cell_ctr[cell]


func _show_event(e: Dictionary) -> void:
	var side: int = int(e["side"])
	var lane: int = int(e["lane"])
	var n: int = int(e["n"])
	var c: Vector2 = _node_center(side, lane)
	match String(e["k"]):
		"attack":
			_atk_from = c
			_atk_pending = true
		"dmg":
			_float("-%d" % n, c, Color(1.0, 0.35, 0.3))
			_shake("%d:%d" % [side, lane])
			_fx_burst(c, Color(1.0, 0.45, 0.3), 26.0)
			if _atk_pending:
				_fx_orb(_atk_from, c, Color(1.0, 0.8, 0.35))
				_atk_pending = false
			if lane < 0:
				_shake_node(_hero_nodes[side])
		"heal":
			if n > 0:
				_float("+%d" % n, c, Color(0.4, 1.0, 0.5))
				_fx_burst(c, Color(0.45, 1.0, 0.55), 20.0)
		"buff":
			_float("+%d" % n, c, Color(1.0, 0.85, 0.3))
		"stun":
			_float("ZZ", c, Color(0.6, 0.85, 1.0))
		"poison":
			_float("poison", c, Color(0.6, 1.0, 0.4))
		"die":
			_float("✖", c, Color(0.9, 0.9, 0.9))
			_fx_burst(c, Color(0.8, 0.8, 0.85), 30.0)
		"summon":
			_fx_burst(c, Color(0.6, 1.0, 0.6), 24.0)
			var v: Control = _board_views.get("%d:%d" % [side, lane])
			if v != null:
				var tsc: Vector2 = v.scale
				v.scale = tsc * 0.4
				v.position += v.size * (tsc - tsc * 0.4) * 0.5
				var tp: Vector2 = v.position - v.size * (tsc - tsc * 0.4) * 0.5
				create_tween().tween_property(v, "position", tp, 0.25)
				create_tween().tween_property(v, "scale", tsc, 0.25).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		"mana":
			_float("+%d mana" % n, c, Color(0.5, 0.8, 1.0))
		"draw":
			if side == 0:
				_float("Pioche : %s" % String(e.get("name", "")), Vector2(960, 700), Color(0.8, 0.9, 1.0))
		"burn":
			_float("Main pleine : %s brûlée" % String(e.get("name", "")), Vector2(960, 700), Color(1.0, 0.6, 0.4))
		"power":
			_fx_burst(_node_center(side, -1), Color(1.0, 0.85, 0.3), 40.0)
			_shake_node(_hero_nodes[side])
			if side == 1:
				_toast_msg("L'adversaire : ⚡ %s" % String(e.get("name", "pouvoir")))
		"cast":
			var cc: Vector2 = c
			if lane < 0:
				cc = Vector2(960, HAND_Y + 120.0) if side == 0 else _node_center(side, -1)
			_fx_burst(cc, Color(0.75, 0.5, 1.0), 30.0)
			if side == 1:
				_toast_msg("L'adversaire : %s" % String(e["name"]))


func _float(txt: String, c: Vector2, col: Color) -> void:
	var l: Label = UiKit.lbl(txt, 42, col, true)
	l.position = c - Vector2(60, 30)
	l.size = Vector2(120, 50)
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	l.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_fx_layer.add_child(l)
	var tw: Tween = create_tween()
	tw.set_parallel(true)
	tw.tween_property(l, "position:y", l.position.y - 70.0, 0.9)
	tw.tween_property(l, "modulate:a", 0.0, 0.9).set_delay(0.3)
	tw.chain().tween_callback(l.queue_free)


func _shake(key: String) -> void:
	var v: Control = _board_views.get(key)
	if v == null:
		return
	var p0: Vector2 = v.position
	var tw: Tween = create_tween()
	tw.tween_property(v, "position", p0 + Vector2(10, 0), 0.04)
	tw.tween_property(v, "position", p0 - Vector2(10, 0), 0.07)
	tw.tween_property(v, "position", p0, 0.04)


func _toast_msg(t: String) -> void:
	if _toast == null or not is_instance_valid(_toast):
		return
	_toast.text = t
	_toast.modulate.a = 1.0
	var tw: Tween = create_tween()
	tw.tween_interval(1.1)
	tw.tween_property(_toast, "modulate:a", 0.0, 0.5)


# ─── Tour adverse ────────────────────────────────────────────────────────────

func _run_enemy_turn() -> void:
	_busy = true
	_duel.end_turn(0)
	await _after_action("Tour de l'adversaire")
	var guard: int = 0
	while not _duel.is_over() and _duel.current == 1 and guard < 40:
		guard += 1
		var ev0: int = (_duel.events as Array).size()
		var act: Dictionary = _duel.ai_step(1)
		if String(act["type"]) == "end":
			break
		if String(act["type"]) == "attack":
			await _lunge(1, int(act["lane"]))
			var from: Vector2 = _node_center(1, int(act["lane"]))
			for e2: Variant in (_duel.events as Array).slice(ev0):
				var ed: Dictionary = e2
				if String(ed["k"]) == "dmg":
					_fx_orb(from, _node_center(int(ed["side"]), int(ed["lane"])), Color(1.0, 0.6, 0.3))
					break
		await _after_action("")
		await get_tree().create_timer(0.25).timeout
	if not _duel.is_over():
		_duel.end_turn(1)
		await _after_action("Votre tour")
	_busy = false
	_finish_if_over()
	_refresh()


# ─── Fin de duel ─────────────────────────────────────────────────────────────

func _finish_if_over() -> void:
	if _over or _duel == null or not _duel.is_over():
		return
	_over = true
	var j: Dictionary = JccCollection.ensure(_save)
	var win: bool = _duel.winner == 0
	var loot: String = ""
	var extra: Dictionary = {}
	if win:
		j["wins"] = int(j["wins"]) + 1
		var rng := RandomNumberGenerator.new()
		rng.randomize()
		loot = JccCollection.roll_loot(rng, String(_opp.get("boss", "")))
		JccCollection.add_card(_save, loot)
		var nu: int = JccCollection.unlock_next(_save, _opp_idx)
		if nu >= 0:
			extra["unlock"] = String(JccCollection.opponent(nu)["name"])
	elif _duel.winner == 1:
		j["losses"] = int(j["losses"]) + 1
	extra["challenge"] = JccCollection.challenge_report(_save, _duel.side(0)["stats"], win)
	_save_now()
	_refresh()
	_show_result(win, _duel.winner == 2, loot, extra)


func _show_result(win: bool, draw_game: bool, loot: String, extra: Dictionary = {}) -> void:
	var ov := ColorRect.new()
	ov.color = Color(0, 0, 0, 0.72)
	ov.set_anchors_preset(Control.PRESET_FULL_RECT)
	_root.add_child(ov)
	var t: Label = UiKit.lbl("ÉGALITÉ" if draw_game else ("VICTOIRE !" if win else "DÉFAITE"), 96, UiKit.C_GOLD if win else (UiKit.C_DIM if draw_game else UiKit.C_BAD), true)
	t.position = Vector2(0, 90)
	t.size = Vector2(W, 120)
	t.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	ov.add_child(t)
	if loot != "":
		var lt: Label = UiKit.lbl("Nouvelle carte gagnée !", 34, UiKit.C_GOOD, true)
		lt.position = Vector2(0, 240)
		lt.size = Vector2(W, 50)
		lt.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		ov.add_child(lt)
		var v := JccCardView.new()
		v.size = Vector2(300, 430)
		v.position = Vector2(W * 0.5 - 150, 310)
		v.set_card(JccCards.get_card(loot))
		v.mouse_filter = Control.MOUSE_FILTER_IGNORE
		v.pivot_offset = Vector2(150, 215)
		v.scale = Vector2(0.3, 0.3)
		ov.add_child(v)
		create_tween().tween_property(v, "scale", Vector2.ONE, 0.45).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	var info := VBoxContainer.new()
	info.position = Vector2(0, 754)
	info.size = Vector2(W, 62)
	info.add_theme_constant_override("separation", 2)
	ov.add_child(info)
	if String(extra.get("unlock", "")) != "":
		var ul: Label = UiKit.lbl("🔓 Adversaire débloqué : %s" % String(extra["unlock"]), 26, UiKit.C_GOOD, true)
		ul.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		ul.custom_minimum_size = Vector2(0, 30)
		info.add_child(ul)
	var chr: Dictionary = extra.get("challenge", {})
	if not chr.is_empty():
		var ct: String = "Défi du jour : %s  (%d/%d)" % [String(chr.get("text", "")), int(chr.get("progress", 0)), int(chr.get("target", 0))]
		if bool(chr.get("done", false)):
			ct += " — réussi !"
			var rw: String = String(chr.get("reward", ""))
			if rw != "":
				ct += "  + %s" % String(JccCards.get_card(rw).get("name", rw))
		var cl: Label = UiKit.lbl(ct, 24, UiKit.C_GOLD if bool(chr.get("done", false)) else UiKit.C_TXT)
		cl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		cl.custom_minimum_size = Vector2(0, 28)
		info.add_child(cl)
	var row := HBoxContainer.new()
	row.position = Vector2(W * 0.5 - 420, 820)
	row.size = Vector2(840, 80)
	row.add_theme_constant_override("separation", 20)
	ov.add_child(row)
	var again: Button = UiKit.btn("Rejouer", Color(0.95, 0.65, 0.25), 28, Vector2(260, 72))
	again.pressed.connect(func() -> void: _start_duel(_opp_idx))
	row.add_child(again)
	var deck: Button = UiKit.btn("Mon deck", Color(0.45, 0.65, 0.95), 28, Vector2(260, 72))
	deck.pressed.connect(_show_builder)
	row.add_child(deck)
	var back: Button = UiKit.btn("Retour", Color(0.6, 0.62, 0.72), 28, Vector2(260, 72))
	back.pressed.connect(_show_hub)
	row.add_child(back)


# ─── Fenêtres ────────────────────────────────────────────────────────────────

func _show_fosse(side: int) -> void:
	if _root.get_node_or_null("FosseView") != null:
		return
	var ov := ColorRect.new()
	ov.name = "FosseView"
	ov.color = Color(0, 0, 0, 0.78)
	ov.set_anchors_preset(Control.PRESET_FULL_RECT)
	_root.add_child(ov)
	var fosse: Array = _duel.side(side)["fosse"]
	var t: Label = UiKit.lbl("%s — %d carte%s" % ["Votre fosse" if side == 0 else "Fosse adverse", fosse.size(), "s" if fosse.size() > 1 else ""], 44, UiKit.C_GOLD, true)
	t.position = Vector2(60, 30)
	ov.add_child(t)
	var sc := ScrollContainer.new()
	sc.position = Vector2(60, 110)
	sc.size = Vector2(1800, 800)
	sc.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	ov.add_child(sc)
	var grid := GridContainer.new()
	grid.columns = 8
	grid.add_theme_constant_override("h_separation", 12)
	grid.add_theme_constant_override("v_separation", 12)
	sc.add_child(grid)
	for c: Variant in fosse:
		var holder := Control.new()
		holder.custom_minimum_size = Vector2(212, 300)
		grid.add_child(holder)
		var v := JccCardView.new()
		v.size = Vector2(200, 290)
		v.set_card(c as Dictionary)
		v.mouse_filter = Control.MOUSE_FILTER_IGNORE
		holder.add_child(v)
	if fosse.is_empty():
		var e: Label = UiKit.lbl("La fosse est vide. Les sorts joués et les créatures tombées y atterrissent.", 26, UiKit.C_DIM)
		e.position = Vector2(60, 140)
		ov.add_child(e)
	var close: Button = UiKit.btn("Fermer", Color(0.6, 0.62, 0.72), 26, Vector2(260, 64))
	close.position = Vector2(W * 0.5 - 130, 960)
	close.pressed.connect(func() -> void: ov.queue_free())
	ov.add_child(close)


## Légende : PA / PM / PO / mana, mots-clés, couleurs du plateau.
func _show_help() -> void:
	if _root.get_node_or_null("HelpView") != null:
		return
	var ov := ColorRect.new()
	ov.name = "HelpView"
	ov.color = Color(0, 0, 0, 0.82)
	ov.set_anchors_preset(Control.PRESET_FULL_RECT)
	_root.add_child(ov)
	var t: Label = UiKit.lbl("Aide du duel", 44, UiKit.C_GOLD, true)
	t.position = Vector2(80, 30)
	ov.add_child(t)
	var txt := "PA — points d'action : chaque attaque ou sort de créature coûte des PA, rendus à chaque tour.\nPM — points de mouvement : nombre de cases dont la créature peut se déplacer par tour.\nPO — portée : distance maximale (en cases) d'une attaque ou d'un sort.\nMana — coût d'une carte ; +1 par tour (max 10). Un sort de créature coûte son mana + 1 PA.\n\nMots-clés :  V Vol (ignore les cases occupées)   F Perforation (l'excès touche le héros)\nT Provocation (à attaquer en premier)   R Régénération (soigne chaque tour)   I Initiative (frappe d'abord)\n\nPlateau :  bleu = votre zone de déploiement, couleur du camp ennemi = la sienne.\nCases rouges = portée de votre unité ; orange = déplacements possibles d'une unité ennemie touchée, rose = ce qu'elle peut menacer.\nAnneau bleu sous l'unité = à vous, anneau de la couleur adverse = ennemi."
	var l: Label = UiKit.lbl(txt, 28, UiKit.C_TXT)
	l.position = Vector2(80, 120)
	l.size = Vector2(1760, 760)
	l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	ov.add_child(l)
	var close: Button = UiKit.btn("Fermer", Color(0.6, 0.62, 0.72), 26, Vector2(260, 64))
	close.position = Vector2(W * 0.5 - 130, 960)
	close.pressed.connect(func() -> void: ov.queue_free())
	ov.add_child(close)


func _confirm(msg: String, yes: Callable) -> void:
	var ov := ColorRect.new()
	ov.color = Color(0, 0, 0, 0.7)
	ov.set_anchors_preset(Control.PRESET_FULL_RECT)
	_root.add_child(ov)
	var panel := PanelContainer.new()
	panel.position = Vector2(W * 0.5 - 380, 380)
	panel.size = Vector2(760, 260)
	panel.add_theme_stylebox_override("panel", _panel_sb(UiKit.C_PANEL, Color(0.85, 0.70, 0.30), 16, 3, 12))
	ov.add_child(panel)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 24)
	panel.add_child(box)
	var l: Label = UiKit.lbl(msg, 28, UiKit.C_TXT)
	l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	l.custom_minimum_size = Vector2(700, 0)
	box.add_child(l)
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 20)
	box.add_child(row)
	var ok: Button = UiKit.btn("Oui", Color(0.8, 0.45, 0.4), 26, Vector2(200, 60))
	ok.pressed.connect(func() -> void:
		ov.queue_free()
		yes.call())
	row.add_child(ok)
	var no: Button = UiKit.btn("Non", Color(0.6, 0.62, 0.72), 26, Vector2(200, 60))
	no.pressed.connect(func() -> void: ov.queue_free())
	row.add_child(no)


# ── Fond de biome 2D stylisé derrière le plateau 4 x 6 ──

class _BiomeBG extends Control:
	## Sol pavé de vraies tuiles du biome (comme l'aire tactique), cases texturées en damier,
	## falaise sous le plateau, décors sprite sur les côtés, brume animée, et camps
	## (tour + héros + feu de camp) aux 2 extrémités du plateau.
	var biome: String = "Forêt"
	var nation: String = "Forêt"
	var seedv: int = 1
	var board: Rect2 = Rect2(400, 116, 1120, 576)
	var iso: bool = false
	var polys: Array = []
	var foe_accent: Color = Color(1.0, 0.42, 0.38)
	var camps: Array = []     # [{tex, reg}] sprite du héros : side 0 (vous) puis side 1 (ennemi)
	var _t: float = 0.0
	var _last: float = -1.0
	static var _tex_cache: Dictionary = {}

	const DECOR := {
		"Forêt": ["decor/sylve/pine1.png", "decor/sylve/pine2.png", "decor/sylve/pine3.png", "decor/sylve/oak1.png", "decor/sylve/oak2.png", "decor/sylve/rock1.png", "decor/sylve/rock2.png", "decor/sylve/bush1.png", "decor/sylve/mushroom1.png", "decor/sylve/flower_red.png", "decor/sylve/grass1.png"],
		"Plaine": ["decor/sylve/oak1.png", "decor/sylve/bush1.png", "decor/sylve/bush_flowers.png", "decor/sylve/flower_red.png", "decor/sylve/flower_blue.png", "decor/sylve/flower_yellow.png", "decor/sylve/grass1.png", "decor/sylve/grass3.png", "decor/sylve/grass5.png"],
		"Désert": ["decor/sylve/rock2.png", "decor/sylve/rock3.png", "decor/sylve/rock4.png", "decor/sylve/stump.png", "decor/sylve/bush1.png"],
		"Montagne": ["decor/sylve/rock1.png", "decor/sylve/rock2.png", "decor/sylve/rock3.png", "decor/sylve/rock4.png", "decor/sylve/rock5.png", "decor/sylve/pine1.png", "decor/sylve/crystal.png"],
		"Marais": ["decor/sylve/mushroom1.png", "decor/sylve/mushroom2.png", "decor/sylve/mushroom_big.png", "decor/sylve/bush1.png", "decor/sylve/log.png", "decor/sylve/flower_blue.png"],
	}
	const DECOR_TINT := {
		"Forêt": Color(1, 1, 1), "Plaine": Color(1.02, 1.04, 0.95), "Désert": Color(1.06, 0.98, 0.82),
		"Montagne": Color(1.04, 1.05, 1.08), "Marais": Color(0.92, 1.0, 0.96),
	}
	const CAMP := {
		"tower": "res://assets/sprites/decor/kenney/batiments/tour.png",
		"wall": "res://assets/sprites/decor/sylve/wall1.png",
		"pillar": "res://assets/sprites/decor/sylve/pillar1.png",
		"torch": "res://assets/sprites/decor/sylve/torch.png",
	}

	func _ready() -> void:
		set_anchors_preset(Control.PRESET_FULL_RECT)
		mouse_filter = Control.MOUSE_FILTER_IGNORE
		set_process(true)

	func _process(dt: float) -> void:
		_t += dt
		if _t - _last >= 0.05:   # brume et feu de camp animés à ~20 ips
			_last = _t
			queue_redraw()

	func _tex(path: String) -> Texture2D:
		if _tex_cache.has(path):
			return _tex_cache[path]
		var t: Texture2D = null
		if ResourceLoader.exists(path):
			t = load(path) as Texture2D
		_tex_cache[path] = t
		return t

	func _pal() -> Dictionary:
		return BattleScenery.pal(nation)

	## Sprite ancré par son pied (bottom_center), mis à l'échelle h_px, teinté.
	func _sprite(path: String, bottom_center: Vector2, h_px: float, tint: Color = Color(1, 1, 1)) -> void:
		var t: Texture2D = _tex(path)
		if t == null:
			return
		var w: float = h_px * float(t.get_width()) / float(t.get_height())
		draw_texture_rect(t, Rect2(bottom_center - Vector2(w * 0.5, h_px), Vector2(w, h_px)), false, tint)

	func _ellipse(c: Vector2, r: Vector2, col: Color) -> void:
		var pts := PackedVector2Array()
		for i in 20:
			var a: float = float(i) / 20.0 * TAU
			pts.append(c + Vector2(cos(a) * r.x, sin(a) * r.y))
		draw_colored_polygon(pts, col)

	func _draw() -> void:
		var p: Dictionary = _pal()
		var w: float = 1920.0
		var h: float = 1080.0
		var hor: float = board.position.y - 8.0
		var mist: Color = p.get("mist", Color(0.8, 0.88, 0.96))
		var steps := 40
		for i in steps:
			var col: Color = mist.lightened(0.30).lerp(Color(0.03, 0.05, 0.04), float(i) / float(steps))
			draw_rect(Rect2(0, h * float(i) / float(steps), w, h / float(steps) + 1.0), col)
		# sol uni peint : dégradé du biome + grandes touches douces (PAS de tuiles répétées,
		# pour que le damier du plateau ressorte nettement du fond)
		var g0: Color = (p["top_a"] as Color).darkened(0.45)
		var g1: Color = (p["top_a"] as Color).darkened(0.74)
		var gsteps := 36
		for i in gsteps:
			var gc: Color = g0.lerp(g1, float(i) / float(gsteps))
			var gy0: float = hor + (h - hor) * float(i) / float(gsteps)
			draw_rect(Rect2(0, gy0, w, (h - hor) / float(gsteps) + 1.0), gc)
		var rng0 := RandomNumberGenerator.new()
		rng0.seed = seedv * 17 + 5
		for i in 46:
			var bp := Vector2(rng0.randf_range(0, w), rng0.randf_range(hor, h))
			var br: float = rng0.randf_range(30.0, 110.0)
			var bc: Color = (p["leaf"] as Color) if rng0.randf() < 0.6 else (p["top_b"] as Color)
			_ellipse(bp, Vector2(br, br * 0.45), Color(bc.r, bc.g, bc.b, rng0.randf_range(0.05, 0.11)))
		draw_rect(Rect2(0, hor - 2, w, 4), Color(mist.r, mist.g, mist.b, 0.12))
		# voile de couleur du biome
		var accent: Color = Nations.info(nation).get("accent", Color(0.5, 0.7, 0.4))
		draw_rect(Rect2(0, hor, w, h - hor), Color(accent.r, accent.g, accent.b, 0.05))
		# décors sprite sur les côtés du plateau
		_draw_decors(p, hor, w, h)
		# plateau : ombre de contact, falaise, dalles texturées
		_draw_board(p)
		# camps aux 2 extrémités
		_draw_camps()
		# brume animée
		for i in 3:
			var byy: float = hor + 40.0 + float(i) * 150.0 + sin(_t * 0.10 + float(i) * 2.1) * 14.0
			draw_rect(Rect2(0, byy, w, 54.0), Color(mist.r, mist.g, mist.b, 0.05 + 0.015 * sin(_t * 0.23 + float(i))))
		# rayons de lumière
		for i in 3:
			var lx: float = 300.0 + float(i) * 550.0 + sin(_t * 0.07 + float(i)) * 30.0
			draw_colored_polygon(PackedVector2Array([Vector2(lx, 0), Vector2(lx + 190, 0), Vector2(lx + 60, hor), Vector2(lx - 130, hor)]), Color(1, 1, 0.92, 0.045))
		# vignette
		for i in 14:
			var a: float = 0.30 * (1.0 - float(i) / 14.0)
			draw_rect(Rect2(i * 14.0, 0, 14.0, h), Color(0, 0, 0, a * 0.5))
			draw_rect(Rect2(w - (i + 1) * 14.0, 0, 14.0, h), Color(0, 0, 0, a * 0.5))
			draw_rect(Rect2(0, h - (i + 1) * 12.0, w, 12.0), Color(0, 0, 0, a * 0.7))

	func _draw_decors(p: Dictionary, hor: float, w: float, h: float) -> void:
		var rng := RandomNumberGenerator.new()
		rng.seed = seedv * 31 + 7
		var list: Array = DECOR.get(biome, DECOR["Forêt"])
		var tint: Color = DECOR_TINT.get(biome, Color(1, 1, 1))
		var spots: Array = []
		for i in 13:
			spots.append(Vector2(board.position.x - 34.0 - rng.randf_range(12.0, 150.0), board.position.y + rng.randf_range(0.0, board.size.y)))
		for i in 13:
			spots.append(Vector2(board.end.x + 34.0 + rng.randf_range(12.0, 150.0), board.position.y + rng.randf_range(0.0, board.size.y)))
		for i in 12:
			spots.append(Vector2(rng.randf_range(240.0, w - 60.0), hor - rng.randf_range(4.0, 42.0)))
		for i in 5:
			spots.append(Vector2(rng.randf_range(board.position.x - 60.0, board.end.x + 60.0), board.end.y + 40.0 + rng.randf_range(0.0, 34.0)))
		spots.sort_custom(func(a: Vector2, b: Vector2) -> bool: return a.y < b.y)
		for sp: Vector2 in spots:
			if board.grow(26.0).has_point(sp):
				continue
			if sp.y < 118.0 and sp.x > 690.0 and sp.x < 1230.0:
				continue   # panneau héros adverse en haut
			var path: String = "res://assets/sprites/" + String(list[rng.randi_range(0, list.size() - 1)])
			var t: Texture2D = _tex(path)
			if t == null:
				continue
			var depth: float = clampf((sp.y - hor) / maxf(1.0, h - hor), 0.0, 1.0)
			var sc: float = (0.34 + 0.60 * depth) * rng.randf_range(0.85, 1.15)
			_sprite(path, sp, float(t.get_height()) * sc, tint)

	func _draw_board(p: Dictionary) -> void:
		var th: float = 30.0
		var tl := board.position
		var tr := Vector2(board.end.x, board.position.y)
		var bl := Vector2(board.position.x, board.end.y)
		var br := board.end
		if polys.size() >= 24:
			tl = (polys[0] as PackedVector2Array)[0]
			tr = (polys[3] as PackedVector2Array)[1]
			br = (polys[23] as PackedVector2Array)[2]
			bl = (polys[20] as PackedVector2Array)[3]
		# ombre de contact
		if not iso:
			draw_rect(Rect2(tl + Vector2(14, th + 10), board.size), Color(0, 0, 0, 0.30))
		else:
			draw_colored_polygon(PackedVector2Array([bl + Vector2(14, th + 10), br + Vector2(14, th + 10), br, bl]), Color(0, 0, 0, 0.30))
		# falaise : face avant (dégradé + strates + cailloux) et 2 côtés, palette du biome
		var rng := RandomNumberGenerator.new()
		rng.seed = seedv + 3
		var face: Color = (p["l_b"] as Color).lerp(p["r_b"] as Color, 0.5).darkened(0.12)
		draw_colored_polygon(PackedVector2Array([bl, br, br + Vector2(0, th), bl + Vector2(0, th)]), face)
		for sy in [0.35, 0.7]:
			draw_line(bl + Vector2(0, sy * th), br + Vector2(0, sy * th), Color(0, 0, 0, 0.16), 2.0)
		for i in 22:
			var rp := Vector2(lerpf(bl.x, br.x, rng.randf()), bl.y + rng.randf_range(2.0, th - 2.0))
			draw_circle(rp, rng.randf_range(2.5, 6.0), (p["l_b"] as Color).lightened(0.25))
		draw_colored_polygon(PackedVector2Array([tl, bl, bl + Vector2(0, th), tl + Vector2(-8, th - 8)]), (p["l_t"] as Color).darkened(0.18))
		draw_colored_polygon(PackedVector2Array([tr, br, br + Vector2(0, th), tr + Vector2(8, th - 8)]), (p["r_t"] as Color).darkened(0.22))
		for cp in [tl, tr, bl, br]:
			draw_colored_polygon(PackedVector2Array([cp + Vector2(-4, -4), cp + Vector2(4, -4), cp + Vector2(4, th + 4), cp + Vector2(-4, th + 4)]), (p["l_t"] as Color).darkened(0.3))
		# dalles des cases : damier franc à fort contraste + biseautage (la texture de
		# matière n'est qu'un voile léger pour ne pas tuer le damier)
		for cell in polys.size():
			var pl: PackedVector2Array = polys[cell]
			var gx: int = cell % JccDuel.COLS
			var gy: int = cell / JccDuel.COLS
			var chk: bool = (gx + gy) % 2 == 0
			var base: Color = (p["top_a"] as Color).lightened(0.10) if chk else (p["top_b"] as Color).darkened(0.22)
			var shade: float = clampf(1.0 - 0.20 * float(gy) / 5.0, 0.74, 1.0) if iso else 1.0
			draw_colored_polygon(pl, Color(base.r * shade, base.g * shade, base.b * shade))
			var tile: Texture2D = BattleScenery.tile_tex(nation, BattleScenery.tile_variant(gx, gy))
			if tile != null:
				var p0: Vector2 = pl[0]
				var p1: Vector2 = pl[1]
				var p3: Vector2 = pl[3]
				var tw2: float = float(tile.get_width())
				var th2: float = float(tile.get_height())
				draw_set_transform_matrix(Transform2D((p1 - p0) / tw2, (p3 - p0) / th2, p0))
				draw_texture_rect(tile, Rect2(0, 0, tw2, th2), false, Color(1, 1, 1, 0.16))
				draw_set_transform_matrix(Transform2D.IDENTITY)
			# biseautage : lumière en haut/gauche, ombre en bas/droite
			draw_line(pl[0], pl[1], (p["lip"] as Color).lightened(0.25), 2.5, true)
			draw_line(pl[0], pl[3], (p["lip"] as Color).lightened(0.15), 2.0, true)
			draw_line(pl[3], pl[2], Color(0, 0, 0, 0.35), 3.0, true)
			draw_line(pl[1], pl[2], Color(0, 0, 0, 0.25), 2.0, true)
			var closed := pl.duplicate()
			closed.append(pl[0])
			draw_polyline(closed, Color(0, 0, 0, 0.45), 2.0, true)
		# cadre épais du plateau pour bien le détacher du fond
		draw_polyline(PackedVector2Array([tl, tr, br, bl, tl]), Color(0, 0, 0, 0.5), 7.0, true)
		draw_polyline(PackedVector2Array([tl, tr, br, bl, tl]), p.get("lip", Color(1, 1, 1)), 4.0, true)
		if polys.size() >= 24:
			var m0: Vector2 = (polys[8] as PackedVector2Array)[3]
			var m1: Vector2 = (polys[11] as PackedVector2Array)[2]
			draw_line(m0, m1, Color(1, 1, 1, 0.10), 3.0)

	func _draw_camps() -> void:
		if polys.size() < 24 or camps.size() < 2:
			return
		var top_base: Vector2
		var bot_base: Vector2
		if not iso:
			top_base = Vector2(board.position.x + 110.0, board.position.y + 2.0)
			bot_base = Vector2(board.end.x - 110.0, board.end.y + 30.0 + 150.0)
		else:
			var tl: Vector2 = (polys[0] as PackedVector2Array)[0]
			var tr: Vector2 = (polys[3] as PackedVector2Array)[1]
			var bl: Vector2 = (polys[20] as PackedVector2Array)[3]
			var br: Vector2 = (polys[23] as PackedVector2Array)[2]
			top_base = (tl + tr) * 0.5 + Vector2(-340.0, 2.0)
			bot_base = (bl + br) * 0.5 + Vector2(150.0, 30.0 + 150.0)
		_draw_camp(top_base, 1)   # camp ennemi en haut
		_draw_camp(bot_base, 0)   # votre camp en bas

	## Camp d'un camp : clairière, palissade, piliers, tour avec girouette, héros du camp
	## (vrai sprite), feu de camp animé.
	func _draw_camp(base: Vector2, side: int) -> void:
		var p: Dictionary = _pal()
		var team: Color = Color(0.45, 0.72, 1.0) if side == 0 else foe_accent
		var tint: Color = Color(1, 1, 1) if side == 0 else Color(1.0, 0.80, 0.76)
		var th: float = 88.0 if side == 1 else 150.0   # le camp ennemi tient dans la bande du haut
		# clairière
		_ellipse(base + Vector2(0, 8), Vector2(150, 20), Color(0, 0, 0, 0.28))
		_ellipse(base + Vector2(0, 4), Vector2(135, 17), (p["top_a"] as Color).darkened(0.42))
		# palissade et piliers d'entrée
		_sprite(CAMP["wall"], base + Vector2(-95, 0), 86.0, tint)
		_sprite(CAMP["wall"], base + Vector2(62, 0), 86.0, tint)
		_sprite(CAMP["pillar"], base + Vector2(-128, 0), 66.0, tint)
		_sprite(CAMP["pillar"], base + Vector2(110, 0), 66.0, tint)
		# tour (vrai sprite) + girouette aux couleurs du camp
		var tw: float = 0.0
		var ttex: Texture2D = _tex(CAMP["tower"])
		if ttex != null:
			tw = th * float(ttex.get_width()) / float(ttex.get_height())
			_sprite(CAMP["tower"], base, th, tint)
		var px: float = base.x
		var py: float = base.y - th
		draw_line(Vector2(px, py), Vector2(px, py - 26.0), Color(0.25, 0.20, 0.15), 4.0)
		var fl := PackedVector2Array([Vector2(px, py - 26.0), Vector2(px + 26.0, py - 19.0), Vector2(px, py - 11.0)])
		draw_colored_polygon(fl, team)
		draw_polyline(fl + PackedVector2Array([Vector2(px, py - 26.0)]), team.darkened(0.3), 2.0)
		# héros du camp à côté de la tour, avec lueur d'équipe sous les pieds
		var art: Dictionary = camps[side]
		if not art.is_empty():
			var hh: float = 84.0 if side == 1 else 120.0
			var tex: Texture2D = art["tex"]
			var hw: float = hh * float(tex.get_width()) / float(tex.get_height())
			var hx: float = base.x - tw * 0.5 - hw - 10.0 if side == 0 else base.x + tw * 0.5 + 10.0
			_ellipse(Vector2(hx + hw * 0.5, base.y + 2.0), Vector2(hw * 0.62, 10.0), Color(team.r, team.g, team.b, 0.35))
			draw_texture_rect(tex, Rect2(Vector2(hx, base.y - hh), Vector2(hw, hh)), false, tint)
			draw_arc(Vector2(hx + hw * 0.5, base.y - 4.0), hw * 0.55, 0, TAU, 24, Color(team.r, team.g, team.b, 0.55), 2.0)
		# feu de camp animé
		var fx: float = base.x + (tw * 0.5 + 36.0 if side == 0 else -(tw * 0.5 + 36.0))
		var fy: float = base.y - 2.0
		var flick: float = 0.5 + 0.5 * sin(_t * 6.0 + float(side) * 3.0)
		draw_circle(Vector2(fx, fy - 8.0), 40.0 + 8.0 * flick, Color(1.0, 0.65, 0.25, 0.10 + 0.05 * flick))
		_sprite(CAMP["torch"], Vector2(fx, fy), 74.0, tint)
		draw_circle(Vector2(fx, fy - 20.0 - 3.0 * flick), 8.0 + 2.0 * flick, Color(1.0, 0.78, 0.3, 0.9))
		draw_circle(Vector2(fx, fy - 16.0), 4.5, Color(1.0, 0.94, 0.6, 0.95))


## Couche d'effets animés en vectoriel : projectiles d'attaque et gerbes d'impact.
class _FxDraw extends Control:
	var items: Array = []

	func _ready() -> void:
		set_anchors_preset(Control.PRESET_FULL_RECT)
		mouse_filter = Control.MOUSE_FILTER_IGNORE
		set_process(true)

	func orb(a: Vector2, b: Vector2, col: Color, dur: float = 0.22) -> void:
		items.append({"kind": "orb", "t": 0.0, "dur": dur, "a": a, "b": b, "col": col})

	func burst(c: Vector2, col: Color, r0: float = 22.0, dur: float = 0.38) -> void:
		items.append({"kind": "burst", "t": 0.0, "dur": dur, "c": c, "col": col, "r0": r0})

	func _process(dt: float) -> void:
		var alive: Array = []
		for it: Variant in items:
			var d: Dictionary = it
			d["t"] = float(d["t"]) + dt
			if float(d["t"]) < float(d["dur"]):
				alive.append(it)
		items = alive
		queue_redraw()

	func _pos(it: Dictionary, k: float) -> Vector2:
		var a: Vector2 = it["a"]
		var b: Vector2 = it["b"]
		return a.lerp(b, k) + Vector2(0, -sin(k * PI) * 46.0)

	func _draw() -> void:
		for it: Variant in items:
			var d: Dictionary = it
			var k: float = float(d["t"]) / float(d["dur"])
			if String(d["kind"]) == "orb":
				var col: Color = d["col"]
				var p: Vector2 = _pos(d, k)
				var p2: Vector2 = _pos(d, maxf(0.0, k - 0.14))
				draw_line(p2, p, Color(col.r, col.g, col.b, 0.45), 7.0, true)
				draw_circle(p, 15.0 * (1.0 - k * 0.3), Color(col.r, col.g, col.b, 0.25))
				draw_circle(p, 9.5 * (1.0 - k * 0.3), Color(col.r, col.g, col.b, 0.55))
				draw_circle(p, 5.0, Color(1, 1, 1, 0.95))
			else:
				var c: Vector2 = d["c"]
				var col2: Color = d["col"]
				var r0: float = d["r0"]
				var rr: float = r0 * (0.4 + 2.6 * k)
				draw_arc(c, rr, 0, TAU, 32, Color(col2.r, col2.g, col2.b, 0.75 * (1.0 - k)), 5.0)
				draw_circle(c, r0 * 0.9 * (1.0 - k), Color(1, 1, 1, 0.5 * (1.0 - k)))
				for i in 8:
					var an: float = float(i) * TAU / 8.0 + 0.4
					var pd: Vector2 = c + Vector2(cos(an), sin(an)) * r0 * (0.5 + 2.4 * k)
					draw_circle(pd, 4.5 * (1.0 - k) + 1.0, Color(col2.r, col2.g, col2.b, 0.85 * (1.0 - k)))


## Tutoriel Gultur du mode Cartes (affiché une seule fois).
func _tutorial() -> void:
	if not Gultur.should_show("jcc_intro"):
		return
	Gultur.say(self, "jcc_intro", Gultur.JCC_INTRO, _root, func() -> void:
		if not Gultur.should_show("jcc_board"):
			return
		Gultur.say(self, "jcc_board", Gultur.JCC_BOARD, _board_anchor, func() -> void:
			if Gultur.should_show("jcc_stats"):
				Gultur.say(self, "jcc_stats", Gultur.JCC_STATS, _info_holder)))
