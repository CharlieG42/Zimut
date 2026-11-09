extends SceneTree
## V127 — Effets animés de la carte Diorama (eau, lave, ombres de nuages) : masque, calques, qualité.
var _fails: int = 0
func ck(c: bool, m: String) -> void:
	if c:
		print("  ok  ", m)
	else:
		print("  ÉCHEC  ", m)
		_fails += 1
func _init() -> void:
	_run.call_deferred()
func _run() -> void:
	var BA: GDScript = load("res://scripts/BoardArt.gd")
	var FX: GDScript = load("res://scripts/DioramaFx.gd")
	var gs: Node = root.get_node("GameSettings")
	var gm: Node = root.get_node("GameManager")
	var before_q: int = int(gs.graphics_quality)
	var before_b: String = gs.sylvestre_board
	gm.active_save = {"adventure_view": "map", "campaign_mode": "adventure"}
	gs.set_sylvestre_board("diorama")
	gs.graphics_quality = 2
	for zone: String in ["foret_sylve", "brasier_cendres"]:
		ck(BA.is_diorama(zone), "%s : carte Diorama" % zone)
		var fx: Dictionary = BA.diorama_fx(zone)
		ck(not fx.is_empty() and ResourceLoader.exists(String(fx.get("path", ""))), "%s : masque d'effets présent" % zone)
		var tex: Texture2D = load(String(fx["path"])) as Texture2D
		var img: Image = tex.get_image()
		var gr: Rect2 = fx.get("ground_rect", Rect2())
		ck(gr.size.x > 0.0 and Rect2(Vector2.ZERO, Vector2(img.get_size())).encloses(gr), "%s : zone eau / lave dans le masque" % zone)
		# le masque couvre l'image entière des tuiles (même cadrage)
		var isz: Array = BA.raw(zone).get("image_size", [0, 0])
		ck(absf(float(img.get_width()) * float(fx["scale"]) - float(isz[0]) * BA.diorama_scale(zone)) < 1.0, "%s : masque calé sur l'image des tuiles" % zone)
		# contenu : de l'eau en Sylve, de la lave au Brasier, de la terre ferme partout ; rien hors de la zone
		var water: int = 0
		var hot: int = 0
		var land: int = 0
		var outside: int = 0
		for y: int in range(0, img.get_height(), 4):
			for x: int in range(0, img.get_width(), 4):
				var c: Color = img.get_pixel(x, y)
				water += 1 if c.r > 0.3 else 0
				hot += 1 if c.g > 0.3 else 0
				land += 1 if c.b > 0.5 else 0
				if (c.r > 0.1 or c.g > 0.1) and not gr.has_point(Vector2(x, y)):
					outside += 1
		ck(land > 5000, "%s : terre ferme repérée (%d)" % [zone, land])
		ck((water > 100) if zone == "foret_sylve" else (hot > 300), "%s : %s" % [zone, "lac repéré (%d)" % water if zone == "foret_sylve" else "lave repérée (%d)" % hot])
		ck(outside == 0, "%s : aucun effet hors de la zone dessinée" % zone)
		var holder := Node2D.new()
		var world := Node2D.new()
		root.add_child(world)
		world.add_child(holder)
		var layers: Array = FX.attach(holder, world, zone, "Forêt" if zone == "foret_sylve" else "Brasier")
		ck(layers.size() == 2, "%s : deux calques (sol, ciel)" % zone)
		if layers.size() == 2:
			var g: Sprite2D = layers[0]
			var s: Sprite2D = layers[1]
			ck(g.get_parent() == holder and g.region_enabled and g.region_rect == gr, "%s : calque sol limité à la zone utile" % zone)
			ck(s.get_parent() == world and s.z_index > 1150 and s.z_index < 1320, "%s : calque ciel au-dessus des personnages, sous l'interface" % zone)
			ck(g.material is ShaderMaterial and s.material is ShaderMaterial and (g.material as ShaderMaterial).shader != (s.material as ShaderMaterial).shader, "%s : shaders posés" % zone)
		world.queue_free()
	# qualité « Économie » : aucun calque
	gs.graphics_quality = 1
	var w2 := Node2D.new()
	root.add_child(w2)
	ck(FX.attach(w2, w2, "foret_sylve", "Forêt").is_empty() and w2.get_child_count() == 0, "Économie : pas d'effets")
	w2.queue_free()
	# bruit répétable : bords raccordés
	var n: Image = FX.noise_texture().get_image()
	var seam: float = 0.0
	for i: int in range(n.get_width()):
		seam = maxf(seam, absf(n.get_pixel(0, i).r - n.get_pixel(n.get_width() - 1, i).r))
	ck(n.get_width() == 128 and seam < 0.12, "bruit 128 px répétable (écart au bord %.3f)" % seam)
	gs.graphics_quality = before_q
	gs.set_sylvestre_board(before_b)
	print("OK : tous les tests passent." if _fails == 0 else "ÉCHEC : %d" % _fails)
	quit(1 if _fails > 0 else 0)
