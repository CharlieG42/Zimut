extends CanvasLayer
## CardDuelUI.gd — Mode Cartes (JCC à voies) : accueil, choix de l'adversaire, duel, résultat.
## Les règles sont dans JccDuel ; les cartes dans JccCards ; la collection / le deck dans JccCollection.
## Plateau : grille 2D de 4 x 6 cases (style Krosmaga). Adversaire en haut, vous en bas.
## Chaque camp déploie sur sa ligne arrière ; PM = déplacement, PA = attaque/sort, PO = portée.

const W: float = 1920.0
const H: float = 1080.0
const BOARD := Rect2(560.0, 116.0, 800.0, 576.0)   # 4 colonnes x 6 lignes
const CELL := Vector2(200.0, 96.0)
const SLOT := Vector2(200.0, 96.0)   # carte sur le plateau (= CELL)
const HAND_Y: float = 792.0
const BIOMES: Array = ["Forêt", "Plaine", "Désert", "Montagne", "Marais"]
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
var _board_views: Dictionary = {}    # "side:cell" -> JccCardView
var _board_anchor: Control = null    # ancre du tutoriel sur le plateau
var _biome: String = "Forêt"
var _hand_views: Array = []
var _hero_nodes: Array = [null, null]
var _info_holder: Control
var _action_bar: HBoxContainer
var _toast: Label
var _log_lbl: Label
var _end_btn: Button
var _mana_node: Control
var _pile_lbl: Label
# duel — sélection
var _sel_hand: int = -1
var _sel_cell: int = -1   # case de l'unité sélectionnée (index y * COLS + x)
var _pending: Dictionary = {}        # ciblage en cours : {kind, idx|lane, cible}
var _targets: Array = []
var _inspect: Dictionary = {}


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
	var sub: Label = UiKit.lbl("Duels de cartes à quatre voies — deck de 20 cartes, mana croissant, héros à 30 PV", 26, UiKit.C_DIM)
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
	st.position = Vector2(0, 1010)
	st.size = Vector2(W, 36)
	st.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_root.add_child(st)


func _on_duel_pressed() -> void:
	var j: Dictionary = JccCollection.ensure(_save)
	if JccCollection.deck_error(_save, j["deck"] as Array) != "":
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
		var b: Button = UiKit.btn("", Color(0.95, 0.65, 0.25) if boss != "" else Color(0.45, 0.65, 0.95), 24, Vector2(520, 320))
		b.pressed.connect(func() -> void: _start_duel(i))
		grid.add_child(b)
		var tex: Texture2D = JccCardView.art_texture(String(op["sprite"]))
		if tex != null:
			var tr := TextureRect.new()
			tr.texture = tex
			tr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			tr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			tr.position = Vector2(20, 20)
			tr.size = Vector2(190, 200)
			tr.mouse_filter = Control.MOUSE_FILTER_IGNORE
			b.add_child(tr)
		var nm: Label = UiKit.lbl(String(op["name"]), 32, UiKit.C_TXT, true)
		nm.position = Vector2(225, 30)
		nm.mouse_filter = Control.MOUSE_FILTER_IGNORE
		b.add_child(nm)
		var desc: String = "Duel classique" if boss == "" else "Boss — peut laisser sa carte légendaire"
		var dl: Label = UiKit.lbl(desc, 20, UiKit.C_GOLD if boss != "" else UiKit.C_DIM)
		dl.position = Vector2(225, 86)
		dl.size = Vector2(280, 100)
		dl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		dl.mouse_filter = Control.MOUSE_FILTER_IGNORE
		b.add_child(dl)
		var rw: Label = UiKit.lbl("Butin : 1 carte", 20, UiKit.C_GOOD)
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
	var j: Dictionary = JccCollection.ensure(_save)
	_duel = JccDuel.new()
	_duel.setup((j["deck"] as Array).duplicate(), JccCollection.parse_deck(String(_opp["deck"])))
	_biome = BIOMES[_opp_idx % BIOMES.size()]
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
	var biome_bg := _BiomeBG.new()
	biome_bg.biome = _biome
	biome_bg.seedv = _opp_idx * 7919 + 13
	biome_bg.board = BOARD
	_root.add_child(biome_bg)
	_board_anchor = Control.new()
	_board_anchor.position = BOARD.position
	_board_anchor.size = BOARD.size
	_board_anchor.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_root.add_child(_board_anchor)
	# emplacements : une case cliquable par cellule de la grille 4 x 6
	for cell in JccDuel.LANES:
		var p := Panel.new()
		p.position = _cell_pos(cell)
		p.size = CELL
		var sb := StyleBoxFlat.new()
		sb.bg_color = Color(0, 0, 0, 0.20)
		sb.border_color = Color(1, 1, 1, 0.14)
		sb.set_border_width_all(2)
		sb.set_corner_radius_all(10)
		p.add_theme_stylebox_override("panel", sb)
		p.gui_input.connect(func(ev: InputEvent) -> void:
			if ev is InputEventMouseButton and ev.pressed and ev.button_index == MOUSE_BUTTON_LEFT:
				_on_slot(cell))
		_root.add_child(p)
		_slots["%d" % cell] = p
	_cards_layer = Control.new()
	_cards_layer.set_anchors_preset(Control.PRESET_FULL_RECT)
	_cards_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_root.add_child(_cards_layer)
	# héros
	_hero_nodes[1] = _make_hero_panel(1, Rect2(700, 8, 520, 104))
	_hero_nodes[0] = _make_hero_panel(0, Rect2(30, 690, 340, 360))
	# colonne gauche : fiche de carte
	_info_holder = Control.new()
	_info_holder.position = Vector2(60, 128)
	_info_holder.size = Vector2(300, 430)
	_root.add_child(_info_holder)
	# barre d'actions (créature sélectionnée)
	_action_bar = HBoxContainer.new()
	_action_bar.position = Vector2(420, 700)
	_action_bar.size = Vector2(1100, 64)
	_action_bar.alignment = BoxContainer.ALIGNMENT_CENTER
	_action_bar.add_theme_constant_override("separation", 14)
	_root.add_child(_action_bar)
	# colonne droite : journal, pioche, fin de tour
	var logp := PanelContainer.new()
	logp.position = Vector2(1560, 126)
	logp.size = Vector2(330, 250)
	logp.add_theme_stylebox_override("panel", UiKit.box(Color(0, 0, 0, 0.35), UiKit.C_BORDER, 12, 2, 10))
	_root.add_child(logp)
	_log_lbl = UiKit.lbl("", 18, UiKit.C_TXT)
	_log_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_log_lbl.custom_minimum_size = Vector2(300, 0)
	_log_lbl.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
	logp.add_child(_log_lbl)
	_end_btn = UiKit.btn("Fin du tour", Color(0.95, 0.75, 0.25), 30, Vector2(330, 96))
	_end_btn.position = Vector2(1560, 440)
	_end_btn.pressed.connect(_on_end_turn)
	_root.add_child(_end_btn)
	var quit: Button = UiKit.btn("Abandonner", Color(0.8, 0.45, 0.4), 20, Vector2(200, 48))
	quit.position = Vector2(30, 14)
	quit.pressed.connect(_on_quit_duel)
	_root.add_child(quit)
	var fo: Button = UiKit.btn("Fosse adverse", Color(0.55, 0.5, 0.7), 18, Vector2(190, 44))
	fo.position = Vector2(1560, 392)
	fo.pressed.connect(func() -> void: _show_fosse(1))
	_root.add_child(fo)
	var fp: Button = UiKit.btn("Votre fosse", Color(0.55, 0.5, 0.7), 20, Vector2(190, 52))
	fp.position = Vector2(1560, 990)
	fp.pressed.connect(func() -> void: _show_fosse(0))
	_root.add_child(fp)
	_pile_lbl = UiKit.lbl("", 24, UiKit.C_TXT, true)
	_pile_lbl.position = Vector2(1560, 930)
	_root.add_child(_pile_lbl)
	_fx_layer = Control.new()
	_fx_layer.set_anchors_preset(Control.PRESET_FULL_RECT)
	_fx_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_root.add_child(_fx_layer)
	_toast = UiKit.lbl("", 28, UiKit.C_GOLD, true)
	_toast.position = Vector2(420, BOARD.end.y + 6.0)
	_toast.size = Vector2(1100, 46)
	_toast.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_toast.modulate.a = 0.0
	_toast.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_fx_layer.add_child(_toast)


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
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0.07, 0.09, 0.14, 0.92)
	sb.border_color = Color(1.0, 0.85, 0.2) if hot else (Color(0.95, 0.45, 0.4) if side == 1 else Color(0.45, 0.75, 1.0))
	sb.set_border_width_all(5 if hot else 3)
	sb.set_corner_radius_all(16)
	panel.add_theme_stylebox_override("panel", sb)
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
		var nm: Label = UiKit.lbl(_hero_name(side), 26, UiKit.C_TXT, true)
		nm.position = Vector2(110, 6)
		nm.mouse_filter = Control.MOUSE_FILTER_IGNORE
		p.add_child(nm)
		var info: Label = UiKit.lbl("Main : %d   Pioche : %d   Mana : %d/%d" % [(sd["hand"] as Array).size(), (sd["deck"] as Array).size(), int(sd["mana"]), int(sd["mana_max"])], 19, UiKit.C_DIM)
		info.position = Vector2(110, 50)
		info.mouse_filter = Control.MOUSE_FILTER_IGNORE
		p.add_child(info)
		_hp_gem(p, Vector2(p.size.x - 56, 52), 36, hp)
	else:
		var nm2: Label = UiKit.lbl("Vous", 30, UiKit.C_TXT, true)
		nm2.position = Vector2(170, 104)
		nm2.mouse_filter = Control.MOUSE_FILTER_IGNORE
		p.add_child(nm2)
		_hp_gem(p, Vector2(p.size.x - 62, 62), 44, hp)
		var ml: Label = UiKit.lbl("MANA  %d / %d" % [int(sd["mana"]), int(sd["mana_max"])], 28, Color(0.6, 0.85, 1.0), true)
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
	for cell in JccDuel.LANES:
		var slot: Panel = _slots["%d" % cell]
		var occ: Dictionary = _duel.occupant(cell)
		var empty_ok: bool = occ.is_empty() and _is_target_any(cell)
		var sbx: StyleBoxFlat = slot.get_theme_stylebox("panel") as StyleBoxFlat
		sbx.border_color = Color(1.0, 0.85, 0.2, 0.9) if empty_ok else Color(1, 1, 1, 0.14)
		sbx.set_border_width_all(5 if empty_ok else 2)
		if occ.is_empty():
			continue
		var side: int = int(occ["side"])
		var cr: Dictionary = occ["unit"]
		var v := JccCardView.new()
		v.board_mode = true
		v.position = _cell_pos(cell)
		v.size = CELL
		v.set_card(cr)
		v.target_ok = _is_target(side, cell)
		v.selected = side == 0 and _sel_cell == cell
		if side == 0 and not _over:
			v.ready_glow = _duel.can_attack(0, cell) or _duel.can_use_sort(0, cell) or not _duel.move_targets(0, cell).is_empty()
		v.tapped.connect(func(_vw: JccCardView) -> void: _on_board_card(side, cell))
		_cards_layer.add_child(v)
		_board_views["%d:%d" % [side, cell]] = v
	_refresh_hand()
	_refresh_hero(0)
	_refresh_hero(1)
	_refresh_action_bar()
	_refresh_info()
	var sd: Dictionary = _duel.side(0)
	_pile_lbl.text = "Pioche : %d" % (sd["deck"] as Array).size()
	_end_btn.disabled = _busy or _duel.current != 0 or _over
	_end_btn.text = "Fin du tour" if _duel.current == 0 else "Tour adverse…"
	var lines: Array = _duel.log.slice(maxi(0, _duel.log.size() - 7))
	_log_lbl.text = "\n".join(PackedStringArray(lines))


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
	var card: Dictionary = {}
	if _sel_hand >= 0 and _sel_hand < (_duel.side(0)["hand"] as Array).size():
		card = (_duel.side(0)["hand"] as Array)[_sel_hand]
	elif _sel_cell >= 0 and _duel.creature_at(0, _sel_cell) != null:
		card = _duel.creature_at(0, _sel_cell)
	elif not _inspect.is_empty():
		card = _inspect
	if card.is_empty():
		var hint: Label = UiKit.lbl("Touchez une carte pour la voir en grand.\n\nUne créature attaque à portée PO (1 PA) et se déplace case par case (1 PM par case).", 20, UiKit.C_DIM)
		hint.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		hint.custom_minimum_size = Vector2(290, 0)
		_info_holder.add_child(hint)
		return
	var v := JccCardView.new()
	v.size = Vector2(300, 430)
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
			var txt: String = "Choisissez un emplacement libre" if String(c["type"]) == "Creature" else ("Choisissez une cible" if needs else "")
			if needs:
				_action_bar.add_child(UiKit.lbl(txt, 26, UiKit.C_GOLD, true))
			else:
				var play: Button = UiKit.btn("▶  Jouer %s" % String(c["name"]), Color(0.35, 0.8, 0.45), 24, Vector2(320, 60))
				play.pressed.connect(func() -> void: _play_hand(_sel_hand, {}))
				_action_bar.add_child(play)
		else:
			var why: String = "Pas assez de mana" if int(c["cost"]) > int(_duel.side(0)["mana"]) else "Aucune cible / aucun emplacement"
			if _duel.current != 0:
				why = "Ce n'est pas votre tour"
			_action_bar.add_child(UiKit.lbl(why, 24, UiKit.C_BAD, true))
		return
	if _sel_cell >= 0 and _duel.creature_at(0, _sel_cell) != null:
		var cr: Dictionary = _duel.creature_at(0, _sel_cell)
		var cell: int = _sel_cell
		var atk: Button = UiKit.btn("⚔ Attaquer (1 PA · portée PO %d)" % int(cr.get("po", 1)), Color(0.95, 0.5, 0.3), 20, Vector2(380, 60))
		atk.disabled = not _duel.can_attack(0, cell)
		atk.pressed.connect(func() -> void: _begin_attack(cell))
		_action_bar.add_child(atk)
		if String(cr["sort"]) != "":
			var sb: Button = UiKit.btn("✦ %s (%d mana · 1 PA)" % [String(cr["sort"]), int(cr["sort_cost"])], Color(0.7, 0.45, 1.0), 20, Vector2(380, 60))
			sb.disabled = not _duel.can_use_sort(0, cell)
			sb.pressed.connect(func() -> void: _begin_sort(cell))
			_action_bar.add_child(sb)
		var mv: Array = _duel.move_targets(0, cell)
		var hint: Label = UiKit.lbl("PM %d — cliquez une case dorée pour vous déplacer" % int(cr.get("pm", 0)), 22, Color(0.6, 0.85, 1.0) if not mv.is_empty() else UiKit.C_DIM)
		_action_bar.add_child(hint)


# ─── Cibles ──────────────────────────────────────────────────────────────────

func _compute_targets() -> Array:
	if not _pending.is_empty():
		if String(_pending["kind"]) == "attack":
			return _duel.attack_targets(0, int(_pending["lane"]))
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
		if kind == "attack":
			_do_attack_target(lane, t)
		else:
			_use_sort(lane, t)
	elif _sel_hand >= 0:
		_play_hand(_sel_hand, t)


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
	var v: JccCardView = _board_views.get("%d:%d" % [side, lane])
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
	return _cell_pos(cell) + CELL * 0.5


func _show_event(e: Dictionary) -> void:
	var side: int = int(e["side"])
	var lane: int = int(e["lane"])
	var n: int = int(e["n"])
	var c: Vector2 = _node_center(side, lane)
	match String(e["k"]):
		"dmg":
			_float("-%d" % n, c, Color(1.0, 0.35, 0.3))
			_shake("%d:%d" % [side, lane])
		"heal":
			if n > 0:
				_float("+%d" % n, c, Color(0.4, 1.0, 0.5))
		"buff":
			_float("+%d" % n, c, Color(1.0, 0.85, 0.3))
		"stun":
			_float("ZZ", c, Color(0.6, 0.85, 1.0))
		"poison":
			_float("poison", c, Color(0.6, 1.0, 0.4))
		"die":
			_float("✖", c, Color(0.9, 0.9, 0.9))
		"summon":
			var v: JccCardView = _board_views.get("%d:%d" % [side, lane])
			if v != null:
				v.pivot_offset = SLOT * 0.5
				v.scale = Vector2(0.4, 0.4)
				create_tween().tween_property(v, "scale", Vector2.ONE, 0.25).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		"mana":
			_float("+%d mana" % n, c, Color(0.5, 0.8, 1.0))
		"draw":
			if side == 0:
				_float("Pioche : %s" % String(e.get("name", "")), Vector2(960, 700), Color(0.8, 0.9, 1.0))
		"burn":
			_float("Main pleine : %s brûlée" % String(e.get("name", "")), Vector2(960, 700), Color(1.0, 0.6, 0.4))
		"cast":
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
	var v: JccCardView = _board_views.get(key)
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
		var act: Dictionary = _duel.ai_step(1)
		if String(act["type"]) == "end":
			break
		if String(act["type"]) == "attack":
			await _lunge(1, int(act["lane"]))
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
	if win:
		j["wins"] = int(j["wins"]) + 1
		var rng := RandomNumberGenerator.new()
		rng.randomize()
		loot = JccCollection.roll_loot(rng, String(_opp.get("boss", "")))
		JccCollection.add_card(_save, loot)
	elif _duel.winner == 1:
		j["losses"] = int(j["losses"]) + 1
	_save_now()
	_refresh()
	_show_result(win, _duel.winner == 2, loot)


func _show_result(win: bool, draw_game: bool, loot: String) -> void:
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
	var t: Label = UiKit.lbl("%s — %d carte%s" % ["Votre fosse" if side == 0 else "Fosse adverse", fosse.size(), "s" if fosse.size() > 1 else ""], 40, UiKit.C_GOLD, true)
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


func _confirm(msg: String, yes: Callable) -> void:
	var ov := ColorRect.new()
	ov.color = Color(0, 0, 0, 0.7)
	ov.set_anchors_preset(Control.PRESET_FULL_RECT)
	_root.add_child(ov)
	var panel := PanelContainer.new()
	panel.position = Vector2(W * 0.5 - 380, 380)
	panel.size = Vector2(760, 260)
	panel.add_theme_stylebox_override("panel", UiKit.box(UiKit.C_PANEL, UiKit.C_BORDER, 16, 3, 24))
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
	var biome: String = "Forêt"
	var seedv: int = 1
	var board: Rect2 = Rect2(560, 116, 800, 576)
	const PALETTES := {
		"Forêt": [Color(0.10, 0.22, 0.14), Color(0.05, 0.12, 0.08), Color(0.16, 0.34, 0.18), Color(0.45, 0.30, 0.18)],
		"Plaine": [Color(0.32, 0.36, 0.16), Color(0.20, 0.24, 0.10), Color(0.42, 0.48, 0.22), Color(0.50, 0.42, 0.25)],
		"Désert": [Color(0.55, 0.44, 0.24), Color(0.40, 0.31, 0.17), Color(0.65, 0.54, 0.30), Color(0.55, 0.45, 0.28)],
		"Montagne": [Color(0.25, 0.27, 0.32), Color(0.16, 0.18, 0.23), Color(0.35, 0.37, 0.44), Color(0.50, 0.48, 0.45)],
		"Marais": [Color(0.12, 0.20, 0.18), Color(0.07, 0.12, 0.11), Color(0.18, 0.30, 0.26), Color(0.35, 0.30, 0.20)],
	}

	func _ready() -> void:
		set_anchors_preset(Control.PRESET_FULL_RECT)
		mouse_filter = Control.MOUSE_FILTER_IGNORE

	func _draw() -> void:
		var pal: Array = PALETTES.get(biome, PALETTES["Forêt"])
		var w: float = size.x
		var h: float = size.y
		var steps := 48
		for i in steps:
			var col: Color = (pal[0] as Color).lightened(0.22).lerp(pal[1] as Color, float(i) / float(steps))
			draw_rect(Rect2(0, h * float(i) / float(steps), w, h / float(steps) + 1.0), col)
		# décor procédural seedé autour du plateau (arbres, rochers, buissons)
		var rng := RandomNumberGenerator.new()
		rng.seed = seedv
		var zone := Rect2(board.position + Vector2(-50, -40), board.size + Vector2(100, 80))
		for i in 70:
			var pt := Vector2(rng.randf_range(zone.position.x, zone.end.x), rng.randf_range(zone.position.y, zone.end.y))
			var s: float = rng.randf_range(0.6, 1.6)
			match rng.randi_range(0, 2):
				0:
					draw_colored_polygon(PackedVector2Array([pt + Vector2(0, -22) * s, pt + Vector2(12, 0) * s, pt + Vector2(-12, 0) * s]), (pal[2] as Color).darkened(rng.randf_range(0.0, 0.25)))
					draw_rect(Rect2(pt + Vector2(-2.5, -4) * s, Vector2(5, 8) * s), pal[3] as Color)
				1:
					draw_colored_polygon(PackedVector2Array([pt + Vector2(-10, 4) * s, pt + Vector2(-4, -6) * s, pt + Vector2(5, -8) * s, pt + Vector2(11, 2) * s]), Color(0.5, 0.5, 0.55, 0.8))
				_:
					draw_circle(pt, 5.0 * s, (pal[2] as Color).lightened(0.3))
		# grille du plateau
		draw_rect(board, Color(1, 1, 1, 0.05))
		for gx in JccDuel.COLS + 1:
			var x: float = board.position.x + float(gx) * (board.size.x / float(JccDuel.COLS))
			draw_line(Vector2(x, board.position.y), Vector2(x, board.end.y), Color(1, 1, 1, 0.07), 2.0)
		for gy in JccDuel.ROWS + 1:
			var y: float = board.position.y + float(gy) * (board.size.y / float(JccDuel.ROWS))
			draw_line(Vector2(board.position.x, y), Vector2(board.end.x, y), Color(1, 1, 1, 0.07), 2.0)
		draw_rect(board, Color(1, 0.9, 0.6, 0.25), false, 3.0)


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
