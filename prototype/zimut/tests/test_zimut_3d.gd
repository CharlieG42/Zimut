extends SceneTree
## V153 : Zimut, modèle 3D animé unique du joueur (monde 3D) — même personnage pour toutes les classes.
## Lancement : godot --headless --path . -s tests/test_zimut_3d.gd
var fails: int = 0
func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1

func _init() -> void:
	_run.call_deferred()

func _tris(n: Node) -> int:
	var t: int = 0
	for mi: Node in n.find_children("*", "MeshInstance3D", true, false):
		var arr: Array = (mi as MeshInstance3D).mesh.surface_get_arrays(0)
		t += (arr[Mesh.ARRAY_INDEX] as PackedInt32Array).size() / 3
	return t

func _run() -> void:
	check(Adv3DZimut.available(), "le modèle de Zimut est présent (assets/zimut/zimut.glb)")
	# 1. même personnage quelle que soit la classe
	var first_scale: float = -1.0
	var all_zimut: bool = true
	for cls: String in ["Tank", "Assassin", "Chasseur", "Mage", "Sylvain", "Druide", "Heal", "Invocateur", "Géomancien", "Artificier", "", "Inconnue"]:
		var h: Node3D = Adv3DHeroModel.make_player(cls)
		var is_z: bool = h is Adv3DZimut
		all_zimut = all_zimut and is_z
		if is_z:
			var sc: float = (h as Adv3DZimut)._model.scale.x
			if first_scale < 0.0:
				first_scale = sc
			check(is_equal_approx(sc, first_scale), "classe « %s » : même échelle" % cls)
		h.free()
	check(all_zimut, "toutes les classes donnent Zimut")
	# 2. gabarit
	var z: Adv3DZimut = Adv3DZimut.make() as Adv3DZimut
	root.add_child(z)
	var top: float = 0.0
	for mi: Node in z._model.find_children("*", "MeshInstance3D", true, false):
		top = maxf(top, (mi as MeshInstance3D).get_aabb().end.y * z._model.scale.y)
	check(absf(top - Adv3DZimut.HEIGHT) < 0.05, "taille ≈ %.2f m (%.2f)" % [Adv3DZimut.HEIGHT, top])
	check(_tris(z._model) <= 8000, "maillage léger pour téléphone (%d triangles)" % _tris(z._model))
	check(z._player != null and z._player.has_animation("Walk"), "animation « Walk » présente")
	check(z._player.get_animation("Walk").loop_mode == Animation.LOOP_LINEAR, "la marche boucle")
	# 3. au repos : animation figée, pose jambes jointes
	for i: int in range(30):
		z.animate(0.05, 0.0, 0.0)
		await process_frame
	check(not z._player.is_playing(), "à l'arrêt, l'animation est figée")
	check(z.stride() < 0.05 and z.run_amount() < 0.01, "à l'arrêt : pas d'amplitude, pas de course")
	var rest_t: float = z._player.current_animation_position
	check(absf(rest_t) < 0.02 or absf(rest_t - z._len * 0.5) < 0.02, "pose de repos = jambes jointes (t = %.3f)" % rest_t)
	# 4. en marche : l'animation tourne, la cadence suit la vitesse
	for i: int in range(20):
		z.animate(0.05, 2.0, 0.0)
		await process_frame
	check(z._player.is_playing(), "en marche, l'animation tourne")
	check(z.stride() > 0.35, "en marche : amplitude du pas > 0,35 (%.2f)" % z.stride())
	var slow: float = z._player.speed_scale
	for i: int in range(30):
		z.animate(0.05, 4.0, 0.0)
	check(z._player.speed_scale > slow, "plus vite → cadence plus rapide (%.2f → %.2f)" % [slow, z._player.speed_scale])
	check(z.run_amount() > 0.3, "à 4 m/s : course (%.2f)" % z.run_amount())
	# 5. arrêt : le pas se termine puis se fige
	for i: int in range(80):
		z.animate(0.05, 0.0, 0.0)
		await process_frame
	check(not z._player.is_playing(), "après l'arrêt, l'animation se fige de nouveau")
	var t2: float = z._player.current_animation_position
	check(absf(t2) < 0.02 or absf(t2 - z._len * 0.5) < 0.02, "…dans une pose jambes jointes (t = %.3f)" % t2)
	# 6. les poses de la planche 2D diffèrent bien d'une phase à l'autre
	var sk: Skeleton3D = z._model.find_children("*", "Skeleton3D", true, false)[0] as Skeleton3D
	var lf: int = sk.find_bone("mixamorig_LeftUpLeg")
	z.pose_walk(0.0)
	await process_frame
	var a: Quaternion = sk.get_bone_pose_rotation(lf)
	z.pose_walk(0.25)
	await process_frame
	var b: Quaternion = sk.get_bone_pose_rotation(lf)
	check(a.angle_to(b) > 0.2, "la cuisson 2D obtient des poses différentes (%.2f rad)" % a.angle_to(b))
	z.free()
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
