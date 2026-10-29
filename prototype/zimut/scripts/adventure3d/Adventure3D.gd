extends Node3D
## Adventure3D.gd — Mode Aventure en monde 3D (V60, bêta).
##
## Même monde que la carte classique (AdventureMapUI) mais vu au sol : l'explorateur — le
## joueur lui-même, pas un héros — marche sur l'île 3D de la carte courante. Toute la
## logique de jeu reste celle de AdventureManager / AdventureMobs / ProgressionManager :
## sauvegarde, groupes de monstres, lieux, portes, contrats, récompenses. Seul le rendu
## et le déplacement changent. Les combats sont les combats Tactiques 2D habituels
## (TeamSelection → Main), jamais modifiés ; au retour, on revient ici.
##
## Réglage : Réglages → « Mode Aventure » (GameSettings.adventure_3d).

const U = preload("res://scripts/UiKit.gd")

const MOB_TOUCH_DIST := 2.4        # distance de contact avec un groupe de monstres
const POI_TOUCH_DIST := 2.1
const GATE_TOUCH_DIST := 1.7
const PERSIST_EVERY := 3.0
const MOB_STEP_TIME := 0.7

var manager: Node = null
var zone_id: String = ""
var terrain: Dictionary = {}
var explorer: Adv3DExplorer = null
var world_root: Node3D = null
var _clouds: Node3D = null
var _islets: Node3D = null
var _ambient: CPUParticles3D = null
var _minimap: Adv3DMinimap = null
var _map_btn: Button = null
var _map_icon: Adv3DChevrons = null
var _map_tick: float = 0.0
var _cam_stick: Adv3DStick = null
var _anim_t: float = 0.0

var _mob_nodes: Dictionary = {}       # id de groupe -> Node3D
var _mob_tweens: Dictionary = {}
var _poi_nodes: Dictionary = {}       # clé "x,y" -> Node3D
var _gate_nodes: Dictionary = {}      # Vector2i -> Node3D
var _declined_mobs: Dictionary = {}   # groupes refusés : ne reproposent le combat qu'une fois le héros éloigné
var _declined_gate: Vector2i = Vector2i(-99, -99)

var _hud: CanvasLayer = null
var _stick: Adv3DStick = null
var _zone_label: Label = null
var _toast: Label = null
var _toast_tween: Tween = null
var _act_btn: Button = null
var _act_poi_key: String = ""
var _modal_root: Control = null
var _drag_index: int = -1
var _touches: Dictionary = {}         # doigts actuellement posés (index -> true)
var _btn_touch: Dictionary = {}       # doigt secondaire -> bouton visé
var _dirty: bool = false
var _since_persist: float = 0.0
var _left: bool = false


func _ready() -> void:
	var save: Dictionary = GameManager.active_save
	if save.is_empty() or GameManager.active_slot < 0:
		get_tree().change_scene_to_file("res://scenes/SaveSlots.tscn")
		return
	manager = Node.new()
	manager.set_script(load("res://scripts/AdventureManager.gd"))
	add_child(manager)
	manager.load_state(save, GameManager.active_slot)
	zone_id = manager.zone_id()
	terrain = AdventureTerrain.zone_terrain(zone_id)
	_build_environment()
	world_root = Adv3DWorld.build(zone_id)
	add_child(world_root)
	_clouds = Adv3DWorld.make_clouds(terrain["size"], absi(zone_id.hash()))
	add_child(_clouds)
	_islets = Adv3DWorld.make_islets(terrain["size"], String(terrain["biome"]), absi(zone_id.hash()))
	add_child(_islets)
	_build_explorer()
	_build_hud()
	_spawn_static_markers()
	manager.ensure_mobs()
	_sync_mobs(true)
	# Retour de combat : un groupe encore collé à l'explorateur ne redemande pas le combat tout de suite.
	var p0 := Vector2(explorer.position.x, explorer.position.z)
	for id: int in _mob_nodes.keys():
		var n0: Node3D = _mob_nodes[id]
		if Vector2(n0.position.x, n0.position.z).distance_to(p0) <= MOB_TOUCH_DIST:
			_declined_mobs[id] = true
	_show_toast("%s — niveau %d" % [manager.zone_name(), ProgressionManager.adventure_zone_level(zone_id)])


# ══════════════════════════════════════════════════════════════════════
#  Décor général : ciel, lumière, brouillard
# ══════════════════════════════════════════════════════════════════════

func _build_environment() -> void:
	var pal: Dictionary = Adv3DWorld.palette(String(terrain["biome"]))
	var sky_mat := ProceduralSkyMaterial.new()
	sky_mat.sky_top_color = pal["sky_top"]
	sky_mat.sky_horizon_color = pal["sky_hor"]
	sky_mat.ground_bottom_color = (pal["sky_hor"] as Color).darkened(0.35)
	sky_mat.ground_horizon_color = pal["sky_hor"]
	var sky := Sky.new()
	sky.sky_material = sky_mat
	var env := Environment.new()
	env.background_mode = Environment.BG_SKY
	env.sky = sky
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color(0.78, 0.84, 0.92)
	env.ambient_light_energy = 0.55
	env.fog_enabled = true
	env.fog_light_color = pal["fog"]
	env.fog_density = 0.0035
	env.tonemap_mode = Environment.TONE_MAPPER_FILMIC
	env.glow_enabled = true
	env.glow_intensity = 0.5
	env.glow_bloom = 0.04
	env.adjustment_enabled = true
	env.adjustment_saturation = 1.15
	env.adjustment_contrast = 1.06
	var we := WorldEnvironment.new()
	we.environment = env
	add_child(we)
	var sun := DirectionalLight3D.new()
	sun.light_color = pal["sun"]
	sun.light_energy = 1.0
	sun.rotation_degrees = Vector3(-52.0, -38.0, 0.0)
	sun.shadow_enabled = false          # mobile d'abord : pas d'ombres temps réel
	add_child(sun)


# ══════════════════════════════════════════════════════════════════════
#  Explorateur
# ══════════════════════════════════════════════════════════════════════

func _build_explorer() -> void:
	explorer = Adv3DExplorer.new()
	explorer.terrain = terrain
	explorer.name = "Explorer"
	add_child(explorer)
	explorer.place_at(_start_position())
	explorer.cell_changed.connect(_on_cell_changed)
	_build_ambient()


## Particules d'ambiance autour du joueur : lucioles (forêt), sable (désert), neige (montagne).
func _build_ambient() -> void:
	var biome: String = String(terrain["biome"])
	var p := CPUParticles3D.new()
	p.name = "Ambiance"
	p.local_coords = false
	p.emission_shape = CPUParticles3D.EMISSION_SHAPE_BOX
	p.emission_box_extents = Vector3(11.0, 4.0, 11.0)
	p.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	var mat := StandardMaterial3D.new()
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	var orb := SphereMesh.new()
	orb.radius = 0.5
	orb.height = 1.0
	orb.radial_segments = 6
	orb.rings = 3
	p.mesh = orb
	match biome:
		"Montagne":
			p.amount = 90
			p.lifetime = 7.0
			p.gravity = Vector3(0.25, -1.0, 0.1)
			p.initial_velocity_min = 0.0
			p.initial_velocity_max = 0.4
			p.scale_amount_min = 0.08
			p.scale_amount_max = 0.16
			mat.albedo_color = Color(1, 1, 1, 0.9)
		"Désert":
			p.amount = 40
			p.lifetime = 5.0
			p.gravity = Vector3(1.2, 0.0, 0.3)
			p.initial_velocity_min = 0.3
			p.initial_velocity_max = 0.9
			p.scale_amount_min = 0.05
			p.scale_amount_max = 0.11
			mat.albedo_color = Color(0.92, 0.80, 0.55, 0.7)
		_:
			p.amount = 40
			p.lifetime = 6.0
			p.gravity = Vector3(0, 0.06, 0)
			p.initial_velocity_min = 0.1
			p.initial_velocity_max = 0.4
			p.direction = Vector3.UP
			p.spread = 180.0
			p.scale_amount_min = 0.07
			p.scale_amount_max = 0.14
			mat.albedo_color = Color(1.0, 0.95, 0.5, 0.85)
			mat.emission_enabled = true
			mat.emission = Color(1.0, 0.9, 0.4)
			mat.emission_energy_multiplier = 1.5
	p.material_override = mat
	add_child(p)
	_ambient = p


## Reprend la position 3D sauvegardée si elle correspond encore à la case du héros
## (la carte classique a pu le déplacer entre-temps), sinon le centre de sa case.
func _start_position() -> Vector3:
	var hp: Vector2i = manager.hero_pos()
	var saved: Array = manager.state.get("pos3d", [])
	if saved.size() == 2 and String(manager.state.get("pos3d_zone", "")) == zone_id:
		var p := Vector3(float(saved[0]), 0.0, float(saved[1]))
		if Adv3DWorld.world_to_cell(p) == hp and Adv3DWorld.point_walkable(terrain, p):
			return p
	if not AdventureTerrain.walkable(zone_id, hp):
		hp = terrain["start"]
	return Adv3DWorld.cell_center(hp)


# ══════════════════════════════════════════════════════════════════════
#  Marqueurs : lieux et portes
# ══════════════════════════════════════════════════════════════════════

func _spawn_static_markers() -> void:
	var pois: Dictionary = ProgressionManager.ADVENTURE_POIS.get(zone_id, {})
	for key: String in pois.keys():
		_make_poi_node(key, pois[key])
	for c: Vector2i in manager.gates().keys():
		var g: Dictionary = manager.gate_at(c)
		var node: Node3D = Adv3DActors.make_gate(String(g.get("dir", "E")), String(g.get("name", "?")), bool(g.get("open", false)))
		node.position = Adv3DWorld.cell_center(c)
		world_root.add_child(node)
		_gate_nodes[c] = node


func _make_poi_node(key: String, poi: Dictionary) -> void:
	if _poi_nodes.has(key) and is_instance_valid(_poi_nodes[key]):
		(_poi_nodes[key] as Node3D).queue_free()
	var cell: Vector2i = AdventureTerrain.parse(key)
	var done: bool = ProgressionManager.adventure_poi_completed(manager.state, key)
	var node: Node3D = Adv3DActors.make_poi_marker(String(poi.get("kind", "")), String(poi.get("name", "Lieu")), done)
	node.position = Adv3DWorld.cell_center(cell)
	world_root.add_child(node)
	_poi_nodes[key] = node


# ══════════════════════════════════════════════════════════════════════
#  Groupes de monstres
# ══════════════════════════════════════════════════════════════════════

## Aligne les nœuds 3D sur les groupes de la sauvegarde (apparitions, disparitions).
func _sync_mobs(snap: bool) -> void:
	var alive: Dictionary = {}
	for g: Dictionary in manager.mobs():
		var id: int = int(g.get("id", -1))
		alive[id] = true
		if not _mob_nodes.has(id):
			var node: Node3D = Adv3DActors.make_mob_group(g, AdventureMobs.label(g, manager.zone_biome()).split("·")[-1].strip_edges())
			node.position = Adv3DWorld.cell_center(AdventureMobs.pos_of(g))
			world_root.add_child(node)
			_mob_nodes[id] = node
		elif snap:
			(_mob_nodes[id] as Node3D).position = Adv3DWorld.cell_center(AdventureMobs.pos_of(g))
	for id2: int in _mob_nodes.keys():
		if not alive.has(id2):
			if is_instance_valid(_mob_nodes[id2]):
				(_mob_nodes[id2] as Node3D).queue_free()
			_mob_nodes.erase(id2)


func _on_cell_changed(cell: Vector2i) -> void:
	if not AdventureTerrain.walkable(zone_id, cell) and not (manager.gates() as Dictionary).has(cell):
		return
	ProgressionManager.adventure_move(manager.state, cell)
	_dirty = true
	var frozen_id: int = -1
	for id: int in _declined_mobs.keys():
		frozen_id = id
	var moved: Array = manager.wander_mobs(frozen_id)
	for m: Dictionary in moved:
		var node: Node3D = _mob_nodes.get(int(m["id"]))
		if node == null or not is_instance_valid(node):
			continue
		var to: Vector3 = Adv3DWorld.cell_center(m["to"])
		var old: Variant = _mob_tweens.get(int(m["id"]))
		if old is Tween and (old as Tween).is_valid():
			(old as Tween).kill()
		var tw: Tween = create_tween()
		tw.tween_property(node, "position", to, MOB_STEP_TIME)
		_mob_tweens[int(m["id"])] = tw
	if not manager.ensure_mobs().is_empty():
		_sync_mobs(false)


# ══════════════════════════════════════════════════════════════════════
#  Boucle : contacts, sauvegarde
# ══════════════════════════════════════════════════════════════════════

func _animate_world(delta: float) -> void:
	_anim_t += delta
	if _clouds != null:
		var lo: float = _clouds.get_meta("min_x")
		var hi: float = _clouds.get_meta("max_x")
		for c: Node3D in _clouds.get_children():
			c.position.x += float(c.get_meta("speed")) * delta
			if c.position.x > hi:
				c.position.x = lo
	if _islets != null:
		for isl: Node3D in _islets.get_children():
			isl.position.y = float(isl.get_meta("base_y")) + sin(_anim_t * 0.4 + float(isl.get_meta("phase"))) * 0.8
			isl.rotation.y += delta * 0.02
	if _ambient != null and explorer != null:
		_ambient.global_position = explorer.global_position + Vector3(0, 3.0, 0)
	for k: String in _poi_nodes.keys():
		var pn: Node3D = _poi_nodes[k]
		if not is_instance_valid(pn):
			continue
		var gem: Node3D = pn.get_node_or_null("Gem")
		if gem != null:
			gem.rotation.y = _anim_t * 1.6
			gem.scale = Vector3.ONE * (1.0 + sin(_anim_t * 3.0) * 0.08)
		var pulse: Node3D = pn.get_node_or_null("Pulse")
		if pulse != null:
			var f: float = fmod(_anim_t * 0.7, 1.0)
			pulse.scale = Vector3.ONE * (0.6 + f * 0.9)
	for id: int in _mob_nodes.keys():
		var mn: Node3D = _mob_nodes[id]
		if not is_instance_valid(mn):
			continue
		for ch: Node in mn.get_children():
			if ch.has_meta("phase"):
				(ch as Node3D).position.y = absf(sin(_anim_t * 3.0 + float(ch.get_meta("phase")))) * 0.08


func _process(delta: float) -> void:
	_animate_world(delta)
	if explorer == null or _left:
		return
	_since_persist += delta
	if _dirty and _since_persist >= PERSIST_EVERY:
		_persist()
	if _modal_root != null:
		return
	explorer.stick_input = _stick.value if _stick != null else Vector2.ZERO
	if _cam_stick != null and _cam_stick.value.length() > 0.12:
		var cv: Vector2 = _cam_stick.value
		explorer.rotate_camera(-cv.x * 2.4 * delta, -cv.y * 1.3 * delta)
	if _minimap != null and _minimap.visible:
		_minimap.set_player(Vector2(explorer.position.x, explorer.position.z) / Adv3DWorld.CELL, explorer.yaw)
		_map_tick += delta
		if _map_tick >= 0.4:
			_map_tick = 0.0
			_refresh_minimap_markers()
	var pos: Vector3 = explorer.position
	# Groupes de monstres : contact → proposition de combat.
	var pos2 := Vector2(pos.x, pos.z)
	for id: int in _declined_mobs.keys():
		var n: Node3D = _mob_nodes.get(id)
		if n == null or not is_instance_valid(n) or Vector2(n.position.x, n.position.z).distance_to(pos2) > MOB_TOUCH_DIST + 2.5:
			_declined_mobs.erase(id)
	for g: Dictionary in manager.mobs():
		var id2: int = int(g.get("id", -1))
		var node: Node3D = _mob_nodes.get(id2)
		if node == null or _declined_mobs.has(id2):
			continue
		if Vector2(node.position.x, node.position.z).distance_to(pos2) <= MOB_TOUCH_DIST:
			_ask_mob_combat(g)
			return
	# Portes
	var gcell: Vector2i = Vector2i(-99, -99)
	for c: Vector2i in _gate_nodes.keys():
		var ctr: Vector3 = Adv3DWorld.cell_center(c)
		if Vector2(ctr.x, ctr.z).distance_to(pos2) <= GATE_TOUCH_DIST:
			gcell = c
			break
	if gcell == Vector2i(-99, -99):
		_declined_gate = Vector2i(-99, -99)
	elif gcell != _declined_gate:
		_ask_gate(gcell)
		return
	# Lieux : bouton d'action contextuel
	_update_action_button(pos2)


func _update_action_button(pos2: Vector2) -> void:
	var near_key: String = ""
	var pois: Dictionary = ProgressionManager.ADVENTURE_POIS.get(zone_id, {})
	for key: String in pois.keys():
		var ctr: Vector3 = Adv3DWorld.cell_center(AdventureTerrain.parse(key))
		if Vector2(ctr.x, ctr.z).distance_to(pos2) <= POI_TOUCH_DIST:
			near_key = key
			break
	if near_key == "":
		_act_btn.visible = false
		_act_poi_key = ""
		return
	_act_poi_key = near_key
	var poi: Dictionary = pois[near_key]
	var done: bool = ProgressionManager.adventure_poi_completed(manager.state, near_key)
	var kind: String = String(poi.get("kind", ""))
	_act_btn.visible = true
	_act_btn.text = "%s  %s" % [_kind_icon(kind), String(poi.get("name", "Lieu"))] if (not done or kind == "camp") else "✓  %s" % String(poi.get("name", "Lieu"))
	_act_btn.disabled = done and kind != "camp"


func _kind_icon(kind: String) -> String:
	match kind:
		"combat":
			return "⚔"
		"exit":
			return "➜"
		_:
			return "✦"


# ══════════════════════════════════════════════════════════════════════
#  Actions : combat, lieux, portes
# ══════════════════════════════════════════════════════════════════════

func _ask_mob_combat(g: Dictionary) -> void:
	var title: String = AdventureMobs.label(g, manager.zone_biome())
	var box: VBoxContainer = _modal("⚔  " + title, Color(0.90, 0.28, 0.22))
	var t: Label = U.lbl("Combat au tour par tour (mode Tactique), ennemis niveau %d, décor %s.\nVictoire : XP, objets, or et ressources pour toute l'équipe." % [
		int(g.get("level", 1)), ProgressionManager.biome_label(manager.zone_biome())], 22, U.C_TXT)
	t.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	box.add_child(t)
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 14)
	box.add_child(row)
	var go: Button = _btn("⚔  COMBATTRE", Color(0.90, 0.28, 0.22), 24, Vector2(300, 84))
	go.pressed.connect(func() -> void:
		_close_modal()
		_start_mob_combat(g))
	row.add_child(go)
	var flee: Button = _btn("PLUS TARD", U.C_BORDER, 22, Vector2(220, 84))
	flee.pressed.connect(func() -> void:
		_declined_mobs[int(g.get("id", -1))] = true
		_close_modal())
	row.add_child(flee)


func _start_mob_combat(g: Dictionary) -> void:
	_save_position()
	manager.start_mob_combat(g)
	GameManager.fight_biome = manager.zone_biome()
	_leave_to("res://scenes/TeamSelection.tscn")


func _on_action_pressed() -> void:
	if _act_poi_key == "" or _modal_root != null:
		return
	var key: String = _act_poi_key
	var poi: Dictionary = ProgressionManager.ADVENTURE_POIS.get(zone_id, {}).get(key, {})
	if poi.is_empty():
		return
	var kind: String = String(poi.get("kind", ""))
	var cell: Vector2i = AdventureTerrain.parse(key)
	# Les mécaniques de la carte classique lisent la case du héros : on l'y pose.
	manager.state["hero_pos"] = [cell.x, cell.y]
	match kind:
		"combat":
			if Dungeons.is_dungeon(poi):
				_show_toast("Donjon : à explorer pour l'instant depuis la carte classique.")
				return
			_confirm_poi_combat(key, poi)
		"chest":
			var res: Dictionary = manager.interact()
			var names: Array[String] = []
			for l: Dictionary in res.get("loots", []):
				names.append(String(l.get("name", "objet")))
			_after_poi(key, poi, "Coffre ouvert !" + (" Butin : " + ", ".join(names) if not names.is_empty() else ""))
		"camp":
			var wait: int = manager.camp_rest_wait(key)
			if wait > 0:
				_show_toast("Le camp se repose encore : revenez dans %d pas." % wait)
				return
			var res2: Dictionary = manager.interact()
			_after_poi(key, poi, "Repos au camp : +%d XP d'exploration." % int(res2.get("xp", 0)))
		"reveal":
			var res3: Dictionary = manager.interact()
			var cities: Array = res3.get("names", [])
			_after_poi(key, poi, "Belvédère : %s" % (", ".join(cities) if not cities.is_empty() else "rien de nouveau"))
		"exit":
			var revealed: Array = manager.take_exit(key)
			_after_poi(key, poi, "Sentier découvert !" if not revealed.is_empty() else "Le sentier est déjà connu.")
		_:
			_show_toast("Énigme : à résoudre pour l'instant depuis la carte classique.")


func _confirm_poi_combat(key: String, poi: Dictionary) -> void:
	var lvl: int = manager.challenge_level(poi)
	var box: VBoxContainer = _modal("⚔  " + String(poi.get("name", "Combat")), Color(0.90, 0.28, 0.22))
	var t: Label = U.lbl("%s\n\nCombat Tactique, ennemis niveau %d, décor %s." % [String(poi.get("desc", "")), lvl, ProgressionManager.biome_label(manager.zone_biome())], 22, U.C_TXT)
	t.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	box.add_child(t)
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 14)
	box.add_child(row)
	var go: Button = _btn("⚔  COMBATTRE", Color(0.90, 0.28, 0.22), 24, Vector2(300, 84))
	go.pressed.connect(func() -> void:
		_close_modal()
		manager.interact()                       # pose pending_challenge
		manager.state["pending_level"] = lvl
		_save_position()
		GameManager.fight_biome = manager.zone_biome()
		_leave_to("res://scenes/TeamSelection.tscn"))
	row.add_child(go)
	var later: Button = _btn("PLUS TARD", U.C_BORDER, 22, Vector2(220, 84))
	later.pressed.connect(_close_modal)
	row.add_child(later)


func _after_poi(key: String, poi: Dictionary, message: String) -> void:
	_make_poi_node(key, poi)
	_dirty = true
	_persist()
	_show_toast(message)


func _ask_gate(c: Vector2i) -> void:
	var g: Dictionary = manager.gate_at(c)
	if g.is_empty():
		return
	_declined_gate = c
	if not bool(g.get("open", false)):
		_show_toast("%s — %s" % [String(g.get("name", "?")), String(g.get("reason", "Route gardée."))])
		return
	var box: VBoxContainer = _modal("➜  " + String(g.get("name", "Carte voisine")), Color(0.40, 0.85, 0.65))
	var t: Label = U.lbl("Niveau %d · %s" % [int(g.get("level", 1)), ProgressionManager.biome_label(String(g.get("biome", "Forêt")))], 22, U.C_TXT)
	box.add_child(t)
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 14)
	box.add_child(row)
	var go: Button = _btn("➜  PASSER", Color(0.30, 0.72, 0.55), 24, Vector2(280, 84))
	go.pressed.connect(func() -> void:
		_close_modal()
		manager.state["hero_pos"] = [c.x, c.y]
		if manager.cross_gate(c):
			manager.state.erase("pos3d")
			_persist()
			get_tree().reload_current_scene()
		else:
			_show_toast("Le passage est impossible pour le moment."))
	row.add_child(go)
	var stay: Button = _btn("RESTER", U.C_BORDER, 22, Vector2(200, 84))
	stay.pressed.connect(_close_modal)
	row.add_child(stay)


# ══════════════════════════════════════════════════════════════════════
#  Sauvegarde / sorties de scène
# ══════════════════════════════════════════════════════════════════════

func _save_position() -> void:
	if explorer == null:
		return
	manager.state["pos3d"] = [explorer.position.x, explorer.position.z]
	manager.state["pos3d_zone"] = zone_id
	var c: Vector2i = Adv3DWorld.world_to_cell(explorer.position)
	if AdventureTerrain.walkable(zone_id, c):
		manager.state["hero_pos"] = [c.x, c.y]


func _persist() -> void:
	_save_position()
	manager.persist()
	_dirty = false
	_since_persist = 0.0


func _leave_to(scene_path: String) -> void:
	_left = true
	_persist()
	PlayTimer.flush()
	get_tree().change_scene_to_file(scene_path)


func _notification(what: int) -> void:
	if what == NOTIFICATION_APPLICATION_FOCUS_OUT or what == NOTIFICATION_WM_WINDOW_FOCUS_OUT:
		_touches.clear()
		_btn_touch.clear()
	if what == NOTIFICATION_APPLICATION_PAUSED or what == NOTIFICATION_WM_CLOSE_REQUEST:
		if manager != null and explorer != null and not _left:
			_persist()


# ══════════════════════════════════════════════════════════════════════
#  Interface (HUD, fenêtres, messages)
# ══════════════════════════════════════════════════════════════════════

func _build_hud() -> void:
	_hud = CanvasLayer.new()
	_hud.layer = 10
	add_child(_hud)
	var root := Control.new()
	root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_hud.add_child(root)
	# Fond tactile : glisser pour tourner la caméra.
	var look := Control.new()
	look.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	look.mouse_filter = Control.MOUSE_FILTER_STOP
	look.gui_input.connect(_on_look_input)
	root.add_child(look)
	# Stick de déplacement (quart bas-gauche).
	_stick = Adv3DStick.new()
	_stick.anchor_top = 0.38
	_stick.anchor_right = 0.45
	_stick.anchor_bottom = 1.0
	root.add_child(_stick)
	# Bandeau de zone
	_zone_label = U.lbl("", 26, U.C_GOLD, true)
	_zone_label.position = Vector2(26, 18)
	_zone_label.text = manager.zone_name()
	root.add_child(_zone_label)
	# Boutons haut-droite
	var top := HBoxContainer.new()
	top.add_theme_constant_override("separation", 10)
	top.anchor_left = 1.0
	top.anchor_right = 1.0
	top.offset_left = -520.0
	top.offset_right = -20.0
	top.offset_top = 14.0
	root.add_child(top)
	var classic: Button = _btn("Carte classique", U.C_BORDER, 22, Vector2(260, 74))
	classic.pressed.connect(func() -> void: _leave_to("res://scenes/AdventureMap.tscn"))
	top.add_child(classic)
	var menu: Button = _btn("☰ Menu", U.C_BORDER, 22, Vector2(160, 74))
	menu.pressed.connect(func() -> void: _leave_to("res://scenes/SaveSlots.tscn"))
	top.add_child(menu)
	# Bouton d'action contextuel (bas-droite)
	_act_btn = _btn("", Color(0.30, 0.55, 0.85), 27, Vector2(440, 100))
	_act_btn.anchor_left = 1.0
	_act_btn.anchor_right = 1.0
	_act_btn.anchor_top = 1.0
	_act_btn.anchor_bottom = 1.0
	_act_btn.offset_left = -740.0
	_act_btn.offset_right = -300.0
	_act_btn.offset_top = -160.0
	_act_btn.offset_bottom = -60.0
	_act_btn.visible = false
	_act_btn.pressed.connect(_on_action_pressed)
	root.add_child(_act_btn)
	# Mini-carte (haut-droite, sous les boutons) + bouton pour la réduire / la masquer
	var map_box := VBoxContainer.new()
	map_box.add_theme_constant_override("separation", 8)
	map_box.anchor_left = 1.0
	map_box.anchor_right = 1.0
	map_box.offset_left = -340.0
	map_box.offset_right = -20.0
	map_box.offset_top = 100.0
	map_box.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root.add_child(map_box)
	_map_btn = _btn("", U.C_BORDER, 20, Vector2(84, 56))
	_map_btn.size_flags_horizontal = Control.SIZE_SHRINK_END
	_map_icon = Adv3DChevrons.new()
	_map_icon.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_map_icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_map_btn.add_child(_map_icon)
	_map_btn.pressed.connect(_cycle_map_mode)
	map_box.add_child(_map_btn)
	_minimap = Adv3DMinimap.new()
	_minimap.size_flags_horizontal = Control.SIZE_SHRINK_END
	map_box.add_child(_minimap)
	_minimap.setup(terrain, Adv3DWorld.palette(String(terrain["biome"])))
	_minimap.set_mode(Adv3DMinimap.mode)
	_update_map_button()
	_refresh_minimap_markers()
	# Stick de caméra (quart bas-droit) : gauche/droite = rotation, haut/bas = inclinaison.
	_cam_stick = Adv3DStick.new()
	_cam_stick.rest_right = true
	_cam_stick.tint = Color(0.55, 0.78, 1.0)
	_cam_stick.caption = "Caméra"
	_cam_stick.anchor_left = 0.70
	_cam_stick.anchor_right = 1.0
	_cam_stick.anchor_top = 0.38
	_cam_stick.anchor_bottom = 1.0
	root.add_child(_cam_stick)
	# Message éphémère (bas-centre)
	_toast = U.lbl("", 24, U.C_TXT, true)
	_toast.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_toast.anchor_left = 0.2
	_toast.anchor_right = 0.8
	_toast.anchor_top = 0.82
	_toast.anchor_bottom = 0.82
	_toast.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_toast.modulate.a = 0.0
	root.add_child(_toast)


# ══════════════════════════════════════════════════════════════════════
#  Boutons : réactivité
# ══════════════════════════════════════════════════════════════════════
## Godot ne transforme en « clic » que le PREMIER doigt posé : tant qu'un doigt tient le stick,
## un bouton touché avec un deuxième doigt ne réagit pas. On traite donc nous-mêmes les doigts
## secondaires (appui à la pose, déclenchement au relâchement dans le bouton), sans doublon avec
## le premier doigt, géré par le moteur.

func _btn(text: String, col: Color, size: int, min_size: Vector2) -> Button:
	var b: Button = U.btn(text, col, size, min_size)
	b.button_down.connect(func() -> void: _press_feedback(b, true))
	b.button_up.connect(func() -> void: _press_feedback(b, false))
	return b


func _press_feedback(b: Button, down: bool) -> void:
	if not is_instance_valid(b):
		return
	b.modulate = Color(0.78, 0.78, 0.78) if down else Color.WHITE
	b.pivot_offset = b.size * 0.5
	b.scale = Vector2(0.96, 0.96) if down else Vector2.ONE
	if down and GameSettings.haptics_on and OS.has_feature("mobile"):
		Input.vibrate_handheld(14)


func _input(event: InputEvent) -> void:
	if not (event is InputEventScreenTouch):
		return
	var t := event as InputEventScreenTouch
	if t.pressed:
		var secondary: bool = not _touches.is_empty()
		_touches[t.index] = true
		if secondary:
			var b: Button = _button_at(t.position)
			if b != null:
				_btn_touch[t.index] = b
				b.button_down.emit()
				get_viewport().set_input_as_handled()
	else:
		_touches.erase(t.index)
		if _btn_touch.has(t.index):
			var tb: Button = _btn_touch[t.index]
			_btn_touch.erase(t.index)
			if is_instance_valid(tb):
				tb.button_up.emit()
				if not t.canceled and tb.is_visible_in_tree() and not tb.disabled \
						and tb.get_global_rect().grow(10.0).has_point(t.position):
					tb.pressed.emit()
			get_viewport().set_input_as_handled()


## Bouton visible sous le doigt (dans la fenêtre ouverte s'il y en a une, sinon dans le HUD).
func _button_at(p: Vector2) -> Button:
	var scope: Node = _modal_root if (_modal_root != null and is_instance_valid(_modal_root)) else _hud
	if scope == null:
		return null
	var found: Button = null
	var stack: Array[Node] = [scope]
	while not stack.is_empty():
		var n: Node = stack.pop_back()
		if n is Button:
			var cand := n as Button
			if cand.is_visible_in_tree() and not cand.disabled and cand.get_global_rect().grow(10.0).has_point(p):
				found = cand
		for c: Node in n.get_children():
			stack.append(c)
	return found



func _cycle_map_mode() -> void:
	_minimap.set_mode((Adv3DMinimap.mode + 1) % 3)
	_update_map_button()


func _update_map_button() -> void:
	if _map_btn == null:
		return
	# chevrons vers le haut = réduire (grande → petite → masquée), vers le bas = agrandir
	_map_icon.expand = Adv3DMinimap.mode == Adv3DMinimap.MODE_HIDDEN
	_map_icon.count = 2 if Adv3DMinimap.mode == Adv3DMinimap.MODE_BIG else 1 if Adv3DMinimap.mode == Adv3DMinimap.MODE_SMALL else 2
	_map_icon.queue_redraw()


func _refresh_minimap_markers() -> void:
	if _minimap == null:
		return
	var pois: Array = []
	var defs: Dictionary = ProgressionManager.ADVENTURE_POIS.get(zone_id, {})
	for key: String in defs.keys():
		var poi: Dictionary = defs[key]
		pois.append({"cell": AdventureTerrain.parse(key), "kind": String(poi.get("kind", "")), "dungeon": Dungeons.is_dungeon(poi),
			"done": ProgressionManager.adventure_poi_completed(manager.state, key)})
	var gates: Array = []
	for c: Vector2i in manager.gates().keys():
		gates.append({"cell": c, "open": bool(manager.gate_at(c).get("open", false))})
	var mobs: Array = []
	for g: Dictionary in manager.mobs():
		mobs.append(AdventureMobs.pos_of(g))
	_minimap.set_markers(pois, gates, mobs)


func _on_look_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		var t := event as InputEventScreenTouch
		if t.pressed and _drag_index == -1:
			_drag_index = t.index
		elif t.index == _drag_index and (not t.pressed or t.canceled):
			_drag_index = -1
	elif event is InputEventScreenDrag:
		var d := event as InputEventScreenDrag
		if d.index == _drag_index:
			explorer.rotate_camera(-d.relative.x * 0.006, -d.relative.y * 0.004)
	elif event is InputEventMouseMotion:
		var m := event as InputEventMouseMotion
		if m.device != InputEvent.DEVICE_ID_EMULATION and (m.button_mask & MOUSE_BUTTON_MASK_RIGHT) != 0:
			explorer.rotate_camera(-m.relative.x * 0.006, -m.relative.y * 0.004)
	elif event is InputEventMouseButton and (event as InputEventMouseButton).pressed:
		var mb := event as InputEventMouseButton
		if mb.button_index == MOUSE_BUTTON_WHEEL_UP:
			explorer.zoom_camera(0.9)
		elif mb.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			explorer.zoom_camera(1.1)


func _show_toast(text: String) -> void:
	if _toast == null:
		return
	_toast.text = text
	if _toast_tween != null and _toast_tween.is_valid():
		_toast_tween.kill()
	_toast.modulate.a = 1.0
	_toast_tween = create_tween()
	_toast_tween.tween_interval(3.2)
	_toast_tween.tween_property(_toast, "modulate:a", 0.0, 0.8)


func _modal(title: String, accent: Color) -> VBoxContainer:
	_close_modal()
	explorer.stick_input = Vector2.ZERO
	var dim := ColorRect.new()
	dim.color = Color(0, 0, 0, 0.5)
	dim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	dim.mouse_filter = Control.MOUSE_FILTER_STOP
	_hud.add_child(dim)
	_modal_root = dim
	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	dim.add_child(center)
	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(680, 0)
	panel.add_theme_stylebox_override("panel", U.box(Color(0.07, 0.09, 0.15, 0.98), accent, 20, 3, 26))
	center.add_child(panel)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 16)
	panel.add_child(box)
	box.add_child(U.lbl(title, 30, accent, true))
	return box


func _close_modal() -> void:
	if _modal_root != null and is_instance_valid(_modal_root):
		_modal_root.queue_free()
	_modal_root = null
