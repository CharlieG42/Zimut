extends SceneTree
## V128 — Étalonnage des vues 3D : brume de distance, lumière, nuages peints, crêtes lointaines, sol nuancé.
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
	var L: GDScript = load("res://scripts/adventure3d/Adv3DLook.gd")
	var W: GDScript = load("res://scripts/adventure3d/Adv3DWorld.gd")
	var gs: Node = root.get_node("GameSettings")
	var before_q: int = int(gs.graphics_quality)
	gs.graphics_quality = 2
	# réglages : valeurs par défaut complétées par la Nation
	var lf: Dictionary = L.look("Forêt")
	var lb: Dictionary = L.look("Brasier")
	ck(lf.has("haze_begin") and lf.has("cloud_amt") and float(lb["haze_begin"]) < float(lf["haze_begin"]), "réglages par Nation (Brasier plus brumeux de près)")
	ck(L.look("Nation inconnue") == L.DEFAULT, "Nation inconnue : réglages par défaut")
	# étalonnage appliqué
	for biome: String in ["Forêt", "Brasier", "Montagne"]:
		var pal: Dictionary = W.palette(biome)
		var env := Environment.new()
		env.fog_light_color = pal["fog"]
		env.ambient_light_color = Color(0.8, 0.8, 0.8)
		var sun := DirectionalLight3D.new()
		var sky := ProceduralSkyMaterial.new()
		L.apply(env, sun, sky, pal, biome, "jour")
		ck(env.fog_enabled and env.fog_mode == Environment.FOG_MODE_DEPTH and env.fog_depth_begin >= 9.0 and env.fog_depth_end > env.fog_depth_begin + 40.0 and env.fog_depth_end <= 160.0,
			"%s : brume de distance (nette de près, %d → %d m)" % [biome, int(env.fog_depth_begin), int(env.fog_depth_end)])
		ck(env.fog_density <= 0.9 and env.fog_sky_affect == 0.0, "%s : la brume ne bouche ni le lointain ni le ciel" % biome)
		if biome == "Brasier":
			ck(sun.light_energy > 1.0 and env.ambient_light_energy > 0.6 and env.tonemap_exposure > 1.0, "Brasier : Nation sombre, ambiance et exposition relevées (V134)")
		else:
			ck(sun.light_energy > 1.0 and env.ambient_light_energy < 0.5, "%s : soleil franc, ambiance basse (ombres lisibles)" % biome)
		ck(env.reflected_light_source == Environment.REFLECTION_SOURCE_DISABLED, "%s : pas de carte de reflets" % biome)
		ck(sky.sky_cover != null and (sky.sky_cover as Texture2D).get_width() == 512, "%s : nuages peints dans le ciel" % biome)
		sun.free()
	# nuages : zénith dégagé, couture raccordée, mis en cache
	var cov: Texture2D = L.cloud_cover(Color.WHITE, 0.9)
	var img: Image = cov.get_image()
	var top_a: float = 0.0
	var band_a: float = 0.0
	var seam: float = 0.0
	for x: int in range(0, 512, 4):
		top_a = maxf(top_a, img.get_pixel(x, 2).a)
		band_a = maxf(band_a, img.get_pixel(x, 75).a)
	for y: int in range(0, 128, 2):
		seam = maxf(seam, absf(img.get_pixel(0, y).a - img.get_pixel(511, y).a))
	ck(top_a < 0.01 and band_a > 0.3, "nuages : zénith dégagé, bancs vers l'horizon")
	ck(seam < 0.25, "nuages : couture du panorama raccordée (%.3f)" % seam)
	ck(L.cloud_cover(Color.WHITE, 0.9) == cov, "nuages : calculés une seule fois")
	# Économie : pas de nuages peints
	gs.graphics_quality = 1
	var sky2 := ProceduralSkyMaterial.new()
	var sun2 := DirectionalLight3D.new()
	L.apply(Environment.new(), sun2, sky2, W.palette("Forêt"), "Forêt", "jour")
	ck(sky2.sky_cover == null, "Économie : ciel sans couche de nuages")
	sun2.free()
	gs.graphics_quality = 2
	# crêtes lointaines : deux couches, en deçà du plan lointain de la caméra (160 m)
	var bd: Node3D = L.make_backdrop(Vector2i(54, 36), W.palette("Forêt"), 7)
	var far_ok: bool = bd.get_child_count() == 2
	for ch in bd.get_children():
		var aabb: AABB = (ch as MeshInstance3D).mesh.get_aabb()
		far_ok = far_ok and maxf(absf(aabb.position.x), absf(aabb.end.x)) < 158.0 and aabb.end.y > 10.0 and aabb.end.y < 60.0
	ck(far_ok, "lointain : deux chaînes de crêtes, dans le champ de la caméra")
	bd.free()
	# V137 : brume au ras du sol, seulement aux Brumes et hors « Économie »
	var gm: Node3D = L.make_ground_mist(Vector2i(54, 36), "Brumes", 0.0)
	ck(gm != null and gm.get_child_count() == 2 and (gm.get_child(0) as MeshInstance3D).material_override is ShaderMaterial, "Brumes : deux nappes de brume au sol")
	if gm != null:
		gm.free()
	ck(L.make_ground_mist(Vector2i(54, 36), "Forêt", 0.0) == null, "pas de brume au sol hors des Brumes")
	gs.graphics_quality = 1
	ck(L.make_ground_mist(Vector2i(54, 36), "Brumes", 0.0) == null, "Économie : pas de brume au sol")
	gs.graphics_quality = 2
	ck(float(L.look("Brumes")["haze_begin"]) < float(L.look("Forêt")["haze_begin"]), "Brumes : brume de distance plus proche")
	# V138 : la teinte d'ombre ne touche que la lumière du soleil
	var MS: GDScript = load("res://scripts/adventure3d/Adv3DMeshes.gd")
	ck(String(MS.TOON_LIGHT).contains("if (LIGHT_IS_DIRECTIONAL)") and not String(MS.TOON_LIGHT).contains("DIFFUSE_LIGHT *= shade"), "teinte d'ombre limitée au soleil (plus de sol assombri près des lumières)")
	# sol : plaques de teinte actives
	var world: Node3D = W.build("foret_sylve", true)
	var ground: MeshInstance3D = world.find_child("Ground", true, false) as MeshInstance3D
	ck(ground != null and float((ground.material_override as ShaderMaterial).get_shader_parameter("macro_amt")) > 0.5, "sol : plaques de teinte (mousse) actives")
	world.free()
	gs.graphics_quality = before_q
	print("OK : tous les tests passent." if _fails == 0 else "ÉCHEC : %d" % _fails)
	quit(1 if _fails > 0 else 0)
