extends SceneTree
## Ajoute des animations (clips) à un héros riggé sous Blender sans animation, puis réécrit le .glb.
## Les gestes sont décrits ici, os par os, en rotations locales (degrés) par rapport à la pose de repos — même principe
## que HeroAnim (Sylvain), mais cuits dans le modèle : le jeu le traite ensuite comme les modèles « à clips » (Hero3D).
##   godot --headless --path . -s tools/anim_heros_blender.gd -- <entrée.glb> <sortie.glb> <préréglage>
## Préréglages : « invocateur » (squelette de 16 os nommés en français : base, Thorax, cou, tete, bras_l/r, avantbras_l/r,
## main_l/r, cuisse_l/r, tibia_l/r, pied_l/r ; livre dans la main droite, lanterne dans la gauche).
## Axes relevés sur ce squelette (V379) : bras_l z− = bras abaissé le long du corps, bras_r x+ = bras levé vers l'avant,
## avantbras x− = avant-bras replié, cuisse x+ = jambe vers l'avant, tibia x− = genou plié, Thorax / tete x+ = penché en arrière.

const FPS := 15.0


func _init() -> void:
	var a: PackedStringArray = OS.get_cmdline_user_args()
	if a.size() < 3:
		push_error("usage : -- <entrée.glb> <sortie.glb> <préréglage>")
		quit(1)
		return
	var doc := GLTFDocument.new()
	var st := GLTFState.new()
	if doc.append_from_file(a[0], st) != OK:
		push_error("glb illisible : " + a[0])
		quit(1)
		return
	var scene: Node = doc.generate_scene(st)
	root.add_child(scene)
	var sk: Skeleton3D = scene.find_children("*", "Skeleton3D", true, false)[0] as Skeleton3D
	var ap := AnimationPlayer.new()
	ap.name = "AnimationPlayer"
	scene.add_child(ap)
	ap.owner = scene
	var lib := AnimationLibrary.new()
	var clips: Dictionary = _preset(a[2])
	if clips.is_empty():
		push_error("préréglage inconnu : " + a[2])
		quit(1)
		return
	var sk_path: String = str(scene.get_path_to(sk))
	for clip: String in clips.keys():
		var c: Dictionary = clips[clip]
		var dur: float = float(c["dur"])
		var anim := Animation.new()
		anim.length = dur
		anim.loop_mode = Animation.LOOP_LINEAR if bool(c["loop"]) else Animation.LOOP_NONE
		var n: int = maxi(2, int(round(dur * FPS)) + 1)
		var tracks := {}
		for i: int in range(n):
			var t: float = float(i) / float(n - 1)
			var pose: Dictionary = (c["fn"] as Callable).call(t)
			for bn: String in pose.keys():
				var bi: int = sk.find_bone(bn)
				if bi < 0:
					push_warning("os introuvable : " + bn)
					continue
				if not tracks.has(bn):
					var tr: int = anim.add_track(Animation.TYPE_ROTATION_3D)
					anim.track_set_path(tr, NodePath(sk_path + ":" + bn))
					tracks[bn] = tr
				var e: Vector3 = (pose[bn] as Vector3) * (PI / 180.0)
				var q: Quaternion = sk.get_bone_rest(bi).basis.get_rotation_quaternion() * Quaternion.from_euler(e)
				anim.rotation_track_insert_key(int(tracks[bn]), t * dur, q)
		lib.add_animation(StringName(clip), anim)
	ap.add_animation_library(&"", lib)
	var gd := GLTFDocument.new()
	gd.image_format = "Lossy WebP"
	gd.lossy_quality = 0.88
	var out := GLTFState.new()
	if gd.append_from_scene(scene, out) != OK or gd.write_to_filesystem(out, a[1]) != OK:
		push_error("export glb impossible")
		quit(1)
		return
	print("OK ", a[1], " animations : ", ap.get_animation_list())
	quit()


# ── outils ────────────────────────────────────────────────────────────────────────────────────────────────────────────
## Courbe lissée passant par les valeurs [keys] réparties régulièrement sur [0, 1].
static func _curve(keys: Array, t: float) -> float:
	var n: int = keys.size() - 1
	var x: float = clampf(t, 0.0, 1.0) * n
	var i: int = mini(int(x), n - 1)
	var f: float = x - i
	f = f * f * (3.0 - 2.0 * f)
	return lerpf(float(keys[i]), float(keys[i + 1]), f)


func _preset(name: String) -> Dictionary:
	match name:
		"invocateur":
			return {
				# repos : lanterne tenue le long du corps (bras abaissé, main compensée : la lanterne reste droite), livre levé
				"Idle": {"dur": 2.4, "loop": true, "fn": func(t: float) -> Dictionary:
					var br: float = sin(t * TAU)
					return {
						"bras_l": Vector3(0, 0, -38.0 + 2.5 * br), "main_l": Vector3(0, 0, 38.0 - 2.5 * br),
						"bras_r": Vector3(3.0 * br, 0, 0), "Thorax": Vector3(-1.5 * br, 0, 0), "tete": Vector3(1.2 * br, 0, 0)}},
				"Walk": {"dur": 0.8, "loop": true, "fn": func(t: float) -> Dictionary:
					var p: float = sin(t * TAU)
					var q: float = cos(t * TAU)
					return {
						"cuisse_l": Vector3(30.0 * p, 0, 0), "cuisse_r": Vector3(-30.0 * p, 0, 0),
						"tibia_l": Vector3(-38.0 * maxf(0.0, -q), 0, 0), "tibia_r": Vector3(-38.0 * maxf(0.0, q), 0, 0),
						"pied_l": Vector3(-6.0 * maxf(0.0, -q), 0, 0), "pied_r": Vector3(-6.0 * maxf(0.0, q), 0, 0),
						"bras_l": Vector3(-20.0 * p, 0, -38.0), "main_l": Vector3(0, 0, 38.0),
						"bras_r": Vector3(8.0 * p, 0, 0),
						"Thorax": Vector3(-4.0, 6.0 * p, 0), "tete": Vector3(2.0, -4.0 * p, 0)}},
				# attaque : le livre est ramené puis poussé vers l'ennemi (impact ≈ 0,6)
				"Attack": {"dur": 1.0, "loop": false, "fn": func(t: float) -> Dictionary:
					return {
						"bras_r": Vector3(_curve([0, -18, -30, 55, 85, 70, 15, 0], t), _curve([0, 0, 0, -14, -26, -20, -6, 0], t), 0),
						"avantbras_r": Vector3(_curve([0, 20, 35, -15, -40, -30, -6, 0], t), 0, 0),
						"bras_l": Vector3(_curve([0, 6, 10, -8, -14, -10, -2, 0], t), 0, -38.0), "main_l": Vector3(0, 0, 38.0),
						"Thorax": Vector3(_curve([0, 4, 8, -9, -16, -12, -4, 0], t), _curve([0, 14, 24, -8, -22, -16, -5, 0], t), 0),
						"tete": Vector3(_curve([0, 1, 2, -2, -5, -4, -1, 0], t), _curve([0, -6, -10, 4, 10, 8, 2, 0], t), 0),
						"cuisse_r": Vector3(_curve([0, -4, -8, 10, 20, 16, 4, 0], t), 0, 0),
						"tibia_r": Vector3(_curve([0, 0, 0, -8, -14, -10, -2, 0], t), 0, 0),
						"cuisse_l": Vector3(_curve([0, 3, 6, -6, -12, -9, -2, 0], t), 0, 0)}},
				# sort : la lanterne est levée haut (sommet tenu ≈ 0,4-0,7), le livre ouvert devant, regard vers le ciel
				"Cast": {"dur": 1.4, "loop": false, "fn": func(t: float) -> Dictionary:
					var up: float = _curve([0, 0.35, 0.85, 1, 1, 0.9, 0.4, 0], t)
					var arm_z: float = lerpf(-38.0, 75.0, up)
					return {
						"bras_l": Vector3(-10.0 * up, 0, arm_z), "main_l": Vector3(0, 0, -arm_z),
						"bras_r": Vector3(30.0 * up, 0, 0), "avantbras_r": Vector3(-15.0 * up, 0, 0),
						"Thorax": Vector3(8.0 * up, 0, 0), "tete": Vector3(14.0 * up, 0, 0),
						"cuisse_l": Vector3(-4.0 * up, 0, 0), "cuisse_r": Vector3(5.0 * up, 0, 0)}},
				"Hit": {"dur": 0.5, "loop": false, "fn": func(t: float) -> Dictionary:
					var h: float = _curve([0.0, 1.0, 0.55, 0.0], t)
					return {
						"Thorax": Vector3(20.0 * h, 0, 6.0 * h), "tete": Vector3(16.0 * h, 0, 0),
						"bras_l": Vector3(10.0 * h, 0, -38.0 + 14.0 * h), "main_l": Vector3(0, 0, 38.0 - 14.0 * h),
						"bras_r": Vector3(-14.0 * h, 0, 0),
						"cuisse_r": Vector3(8.0 * h, 0, 0), "cuisse_l": Vector3(-6.0 * h, 0, 0)}},
			}
	return {}
