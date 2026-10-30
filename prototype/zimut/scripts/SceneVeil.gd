extends CanvasLayer
## SceneVeil.gd (autoload) — Transition entre les écrans : à chaque changement de scène, un voile
## couvre l'écran puis s'efface. Pour un combat ou une carte d'Aventure, le voile prend les couleurs
## de la Nation (dégradé, emblème, nom de la Nation et du lieu) : un « écran de chargement » léger,
## sans toucher aux nombreux appels change_scene_to_file du jeu.
## Désactivé quand le jeu tourne sous un script de test (-s), pour ne pas masquer les captures.

const HOLD_TITLED := 0.75
const HOLD_PLAIN := 0.08
const FADE := 0.45

var _root: Control = null
var _bg: TextureRect = null
var _emblem: Control = null
var _title: Label = null
var _sub: Label = null
var _tween: Tween = null
var _last_scene: Node = null
var force: bool = false        # tests : afficher le voile même sous un script -s


func _ready() -> void:
	layer = 120
	process_mode = Node.PROCESS_MODE_ALWAYS
	_build()
	var tree: SceneTree = get_tree()
	if tree.has_signal("scene_changed"):
		tree.connect("scene_changed", _on_scene_changed)
	else:
		tree.node_added.connect(func(n: Node) -> void:
			if n.get_parent() == tree.root and n == tree.current_scene:
				_on_scene_changed.call_deferred())


func _build() -> void:
	_root = Control.new()
	_root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_root.visible = false
	add_child(_root)
	_bg = TextureRect.new()
	_bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_bg.stretch_mode = TextureRect.STRETCH_SCALE
	_bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_root.add_child(_bg)
	_emblem = _Emblem.new()
	_emblem.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	_emblem.custom_minimum_size = Vector2(220, 220)
	_emblem.position = Vector2(-110, -230)
	_emblem.size = Vector2(220, 220)
	_emblem.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_root.add_child(_emblem)
	_title = _label(64, Color(1, 0.95, 0.82))
	_title.offset_top = 30.0
	_title.offset_bottom = 110.0
	_root.add_child(_title)
	_sub = _label(30, Color(0.88, 0.90, 0.96))
	_sub.offset_top = 112.0
	_sub.offset_bottom = 160.0
	_root.add_child(_sub)


func _label(sz: int, col: Color) -> Label:
	var l := Label.new()
	l.add_theme_font_size_override("font_size", sz)
	l.add_theme_color_override("font_color", col)
	l.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.8))
	l.add_theme_constant_override("outline_size", 10)
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	l.anchor_left = 0.0
	l.anchor_right = 1.0
	l.anchor_top = 0.5
	l.anchor_bottom = 0.5
	l.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return l


func _on_scene_changed() -> void:
	var tree: SceneTree = get_tree()
	if tree.get_script() != null and not force:      # lancé par un script de test : pas de voile
		return
	var sc: Node = tree.current_scene
	if sc == null or sc == _last_scene:
		return
	_last_scene = sc
	var path: String = sc.scene_file_path
	var biome: String = ""
	var title: String = ""
	var sub: String = ""
	if path.ends_with("Main.tscn"):
		biome = String(_autoload("GameManager", "fight_biome", "Forêt"))
		title = "⚔  Combat"
		sub = _nation_line(biome)
	elif path.ends_with("Adventure3D.tscn") or path.ends_with("AdventureMap.tscn"):
		var zid: String = String(sc.get("zone_id")) if sc.get("zone_id") != null else ""
		var mgr: Object = sc.get("manager")
		if zid == "" and mgr != null and mgr.has_method("zone_id"):
			zid = String(mgr.call("zone_id"))
		if zid != "":
			biome = String(ProgressionManager.adventure_zone_biome(zid))
			title = String(ProgressionManager.ADVENTURE_ZONES.get(zid, {}).get("name", "Aventure"))
			sub = _nation_line(biome)
	_show(biome, title, sub)


func _autoload(nm: String, prop: String, def: Variant) -> Variant:
	var n: Node = get_tree().root.get_node_or_null(nm)
	if n == null:
		return def
	var v: Variant = n.get(prop)
	return def if v == null else v


func _nation_line(biome: String) -> String:
	if biome == "":
		return ""
	var nat: String = String(Nations.info(biome).get("nation", ""))
	var label: String = String(ProgressionManager.biome_label(biome))
	if nat != "" and nat != biome:
		return "%s · Nation %s" % [label, nat]
	return label if nat == "" else "Nation %s" % nat


func _accent(biome: String) -> Color:
	if biome == "Donjon":
		return Color(0.75, 0.62, 0.95)
	return Nations.info(biome).get("accent", Color(0.55, 0.70, 0.95))


func _show(biome: String, title: String, sub: String) -> void:
	var titled: bool = title != ""
	var acc: Color = _accent(biome) if biome != "" else Color(0.30, 0.40, 0.62)
	var g := Gradient.new()
	g.colors = PackedColorArray([acc.darkened(0.55), Color(0.03, 0.04, 0.07)])
	var gt := GradientTexture2D.new()
	gt.gradient = g
	gt.fill = GradientTexture2D.FILL_RADIAL
	gt.fill_from = Vector2(0.5, 0.42)
	gt.fill_to = Vector2(1.1, 1.0)
	gt.width = 128
	gt.height = 128
	_bg.texture = gt
	_emblem.set("col", acc)
	_emblem.visible = titled
	_title.text = title
	_sub.text = sub
	_title.visible = titled
	_sub.visible = titled
	_root.visible = true
	_root.modulate.a = 1.0
	_root.mouse_filter = Control.MOUSE_FILTER_STOP
	if _tween != null and _tween.is_valid():
		_tween.kill()
	_tween = create_tween()
	_tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	_tween.tween_interval(HOLD_TITLED if titled else HOLD_PLAIN)
	_tween.tween_callback(func() -> void: _root.mouse_filter = Control.MOUSE_FILTER_IGNORE)
	_tween.tween_property(_root, "modulate:a", 0.0, FADE if titled else 0.3).set_trans(Tween.TRANS_SINE)
	_tween.tween_callback(func() -> void: _root.visible = false)


## Emblème : double anneau et losange aux couleurs de la Nation, qui tourne doucement.
class _Emblem extends Control:
	var col: Color = Color(0.6, 0.7, 1.0)
	var t: float = 0.0
	func _process(d: float) -> void:
		if not is_visible_in_tree():
			return
		t += d
		queue_redraw()
	func _draw() -> void:
		var c: Vector2 = size * 0.5
		var r: float = minf(size.x, size.y) * 0.42
		draw_circle(c, r * 1.05, Color(col.r, col.g, col.b, 0.12))
		draw_arc(c, r, 0.0, TAU, 64, Color(col.r, col.g, col.b, 0.95), 5.0, true)
		draw_arc(c, r * 0.8, t * 0.8, t * 0.8 + TAU * 0.8, 48, col.lightened(0.35), 3.0, true)
		var pts := PackedVector2Array()
		for i: int in range(4):
			var a: float = t * 0.5 + float(i) * PI * 0.5
			pts.append(c + Vector2(cos(a), sin(a)) * r * 0.5)
		pts.append(pts[0])
		draw_colored_polygon(pts.slice(0, 4), Color(col.r, col.g, col.b, 0.35))
		draw_polyline(pts, col.lightened(0.5), 3.0, true)
		draw_circle(c, r * 0.12, col.lightened(0.6))
