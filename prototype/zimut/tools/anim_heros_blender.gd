extends SceneTree
## Ajoute des animations (clips) à un héros riggé sous Blender sans animation, puis réécrit le .glb.
## Les gestes sont décrits ici, os par os, en rotations locales (degrés) par rapport à la pose de repos — même principe
## que HeroAnim (Sylvain), mais cuits dans le modèle : le jeu le traite ensuite comme les modèles « à clips » (Hero3D).
##   godot --headless --path . -s tools/anim_heros_blender.gd -- <entrée.glb> <sortie.glb> <préréglage>
## Préréglages : « assassin », « sylvain », « mage », « geomancien », « druide », « heal » (même rig que le mage : bâton à droite, main gauche libre ou objet flottant), « chasseur » et « kharaz » (arc dans la main gauche ; Kharaz, boss du Brasier, tend la corde de son poing enflammé) (squelettes Blender de Charlie, os « .l / .r », exportés en glb depuis le .blend),
## « invocateur » (squelette de 16 os nommés en français : base, Thorax, cou, tete, bras_l/r, avantbras_l/r,
## main_l/r, cuisse_l/r, tibia_l/r, pied_l/r ; livre dans la main droite, lanterne dans la gauche).
## Axes relevés sur ce squelette (V379) : bras_l z− = bras abaissé le long du corps, bras_r x+ = bras levé vers l'avant,
## avantbras x− = avant-bras replié, cuisse x+ = jambe vers l'avant, tibia x− = genou plié, Thorax / tete x+ = penché en arrière.

const FPS := 15.0
const IDLE_GAIN := 1.7   # amplitude globale du repos vivant
const SPREAD := 5.0     # écartement des pieds de la posture de repos (degrés, rotation z des cuisses)


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


## V386 : posture de base naturelle, ajoutée au repos de chaque clip (donc sans à-coup d'un clip à l'autre) : jambe d'appui
## droite, l'autre légèrement avancée et fléchie, pieds écartés, bras libre un peu fléchi, buste et tête tournés de quelques degrés.
static func _stance(free: String, lg: float) -> Dictionary:
	var d: Dictionary = {
		"cuisse.l": Vector3(7.0 * lg, 0, SPREAD * lg), "tibia.l": Vector3(-10.0 * lg, 0, 0),
		"cuisse.r": Vector3(-3.0 * lg, 0, -SPREAD * lg), "tibia.r": Vector3(-4.0 * lg, 0, 0),
		"thorax": Vector3(0, 4.0, 0), "tete": Vector3(0, -6.0, 2.0)}
	return d


## V386 : repos vivant (remplace l'ancienne respiration de ±1,5° qui laissait les héros raides). Toutes les composantes sont
## périodiques (1 ou 2 périodes sur le clip) : transfert d'appui d'une jambe à l'autre, respiration du thorax, buste qui se
## tord à peine, regard qui dérive, bras libre qui balance et se fléchit. [free] = os du bras libre ("" si aucun),
## [lg] = amplitude des jambes (robe longue : moins).
static func _idle_extra(t: float, free: String, lg: float) -> Dictionary:
	# Clip de 5 s : l'appui change une fois, la respiration revient 3 fois, le regard dérive à une autre cadence (pas de
	# battement mécanique). Amplitudes réglées pour qu'elles se voient à ~170 px de haut à l'écran.
	var g: float = IDLE_GAIN
	var sh: float = sin(t * TAU)                   # transfert d'appui
	var br: float = sin(t * TAU * 3.0)             # respiration
	var gl: float = sin(t * TAU * 2.0 + 1.3)       # regard
	var nod: float = sin(t * TAU * 3.0 + 0.8)      # hochement léger, en retard sur la respiration
	var d: Dictionary = {
		"thorax": Vector3(-3.0 * g * br, 5.0 * g * sh, 5.0 * g * sh),
		"tete": Vector3(3.0 * g * nod, -4.0 * g * sh + 8.0 * g * gl, 4.0 * g * gl - 2.0 * g * sh),
		"cuisse.l": Vector3(9.0 * g * sh * lg, 0, 0), "tibia.l": Vector3(-12.0 * g * maxf(sh, 0.0) * lg, 0, 0),
		"cuisse.r": Vector3(-9.0 * g * sh * lg, 0, 0), "tibia.r": Vector3(-12.0 * g * maxf(-sh, 0.0) * lg, 0, 0)}
	if free != "":
		var av: String = "avantbras." + free.get_slice(".", 1)
		var side: float = -1.0 if free.ends_with(".l") else 1.0
		d[free] = Vector3(8.0 * g * sh, 0, side * (4.0 * g * br - 3.0 * g * sh))
		d[av] = Vector3(-8.0 * g * (0.5 + 0.5 * br), 0, 0)
	return d


## V390 : attaque au bâton engagée en trois temps (armement ≈ 0,3 s, impact ≈ 0,57, retour) : le bras repart en arrière, le
## buste se tord et se penche en arrière, puis fente vers l'avant, torsion inverse et bras balayé. [hand] = "r" ou "l" (main
## du bâton ; la torsion du buste est inversée pour la main gauche), [lg] = amplitude des jambes (robe longue : moins).
static func _staff_attack(t: float, lg: float, hand: String) -> Dictionary:
	var o: String = "l" if hand == "r" else "r"
	var tw: float = 1.0 if hand == "r" else -1.0
	var os_: float = 1.0 if o == "l" else -1.0   # sens « écarter le bras » de l'autre bras (z positif pour le gauche)
	var leg_f: String = hand   # jambe qui avance : celle du côté du bâton
	var leg_b: String = o
	return {
		"bras." + hand: Vector3(_curve([0, -25, -60, 25, 100, 80, 30, 0], t), 0, 0),
		"avantbras." + hand: Vector3(_curve([0, -15, -40, -20, -5, -15, -12, 0], t), 0, 0),
		"main." + hand: Vector3(_curve([0, 15, 35, -15, -50, -35, -10, 0], t), 0, 0),
		# V395 : l'autre bras travaille aussi (contrepoids) — il s'avance et s'écarte pendant l'armement du bâton, puis
		# se rabat en arrière et vers le corps sur la frappe, l'avant-bras plié.
		"bras." + o: Vector3(_curve([0, 22, 50, -18, -55, -40, -12, 0], t), 0, os_ * _curve([0, 8, 18, 4, -10, -8, -2, 0], t)),
		"avantbras." + o: Vector3(_curve([0, -12, -34, -14, -28, -20, -8, 0], t), 0, 0),
		"main." + o: Vector3(_curve([0, 8, 18, -6, -22, -14, -4, 0], t), 0, 0),
		"thorax": Vector3(_curve([0, 6, 12, -8, -24, -18, -6, 0], t), tw * _curve([0, -10, -22, 6, 30, 22, 8, 0], t), 0),
		"tete": Vector3(_curve([0, 2, 4, -3, -10, -7, -2, 0], t), tw * _curve([0, 6, 12, -4, -16, -12, -4, 0], t), 0),
		"cuisse." + leg_f: Vector3(_curve([0, -6, -12, 14, 30, 24, 8, 0], t) * lg, 0, 0),
		"tibia." + leg_f: Vector3(_curve([0, 4, 10, -8, -20, -14, -4, 0], t) * lg, 0, 0),
		"cuisse." + leg_b: Vector3(_curve([0, 4, 8, -8, -20, -15, -4, 0], t) * lg, 0, 0),
		"tibia." + leg_b: Vector3(_curve([0, 0, 6, -4, -10, -6, 0, 0], t) * lg, 0, 0)}


## V390 : mort — vacille, genoux qui plient, bras jetés en arrière, tête qui part en arrière, puis corps relâché. Le basculement
## du corps entier (chute en arrière) est fait par Hero3D (motion "dead"). [lg] : amplitude des jambes (robe longue : moins).
static func _dead_pose(t: float, lg: float) -> Dictionary:
	return {
		"thorax": Vector3(_curve([0, 14, 26, 24, 14, 8, 6, 6], t), 0, 0),
		"tete": Vector3(_curve([0, 10, 22, 26, 20, 14, 10, 10], t), 0, _curve([0, 0, 4, 8, 12, 14, 14, 14], t)),
		"cuisse.l": Vector3(_curve([0, 8, 18, 6, 0, -2, -2, -2], t) * lg, 0, 0),
		"tibia.l": Vector3(_curve([0, -10, -30, -10, 0, 0, 0, 0], t) * lg, 0, 0),
		"cuisse.r": Vector3(_curve([0, -4, 6, 14, 6, 2, 2, 2], t) * lg, 0, 0),
		"tibia.r": Vector3(_curve([0, -8, -20, -22, -6, 0, 0, 0], t) * lg, 0, 0),
		"bras.r": Vector3(_curve([0, 20, 30, 10, -5, -10, -10, -10], t), 0, _curve([0, -25, -45, -30, -20, -15, -15, -15], t)),
		"bras.l": Vector3(_curve([0, 20, 30, 10, -5, -10, -10, -10], t), 0, _curve([0, 25, 45, 30, 20, 15, 15, 15], t))}


## Noms d'os du squelette de l'Invocateur (« Thorax », « bras_l »…) à partir des noms des autres héros.
static func _to_fr(d: Dictionary) -> Dictionary:
	var out: Dictionary = {}
	for k: String in d.keys():
		out[("Thorax" if k == "thorax" else k.replace(".", "_"))] = d[k]
	return out


func _preset(name: String) -> Dictionary:
	match name:
		# Assassin (V380) : deux dagues. Garde basse, genoux fléchis ; attaque = coup d'estoc de la dague droite avec fente ;
		# sort = double taillade croisée.
		"assassin":
			var low := func(extra: Dictionary) -> Dictionary:
				var d: Dictionary = {"bras.l": Vector3(0, 0, -62), "bras.r": Vector3(0, 0, 62),
					"avantbras.l": Vector3(-35, 0, 0), "avantbras.r": Vector3(-35, 0, 0),
					"cuisse.l": Vector3(10, 0, 0), "cuisse.r": Vector3(10, 0, 0), "tibia.l": Vector3(-18, 0, 0),
					"tibia.r": Vector3(-18, 0, 0), "thorax": Vector3(-6, 0, 0)}
				for k: String in extra.keys():
					d[k] = (d.get(k, Vector3.ZERO) as Vector3) + (extra[k] as Vector3)
				return d
			return {
				"Idle": {"dur": 5.0, "loop": true, "fn": func(t: float) -> Dictionary:
					return low.call(_idle_extra(t, "", 1.0))},
				"Walk": {"dur": 0.7, "loop": true, "fn": func(t: float) -> Dictionary:
					var p: float = sin(t * TAU)
					var q: float = cos(t * TAU)
					return low.call({"cuisse.l": Vector3(28.0 * p, 0, 0), "cuisse.r": Vector3(-28.0 * p, 0, 0),
						"tibia.l": Vector3(-30.0 * maxf(0.0, -q), 0, 0), "tibia.r": Vector3(-30.0 * maxf(0.0, q), 0, 0),
						"bras.l": Vector3(-18.0 * p, 0, 0), "bras.r": Vector3(18.0 * p, 0, 0),
						"thorax": Vector3(-4.0, 7.0 * p, 0)})},
				"Attack": {"dur": 0.9, "loop": false, "fn": func(t: float) -> Dictionary:
					return low.call({
						"bras.r": Vector3(_curve([0, -25, -35, 60, 85, 70, 15, 0], t), 0, _curve([0, 0, 5, -20, -30, -24, -6, 0], t)),
						"avantbras.r": Vector3(_curve([0, -25, -40, 25, 35, 28, 5, 0], t), 0, 0),
						"bras.l": Vector3(_curve([0, 10, 18, -12, -20, -15, -4, 0], t), 0, 0),
						"thorax": Vector3(_curve([0, 4, 6, -10, -16, -12, -3, 0], t), _curve([0, 14, 22, -10, -22, -16, -5, 0], t), 0),
						"cuisse.r": Vector3(_curve([0, -5, -8, 22, 32, 26, 6, 0], t), 0, 0),
						"tibia.r": Vector3(_curve([0, 0, 0, -12, -18, -14, -3, 0], t), 0, 0),
						"cuisse.l": Vector3(_curve([0, 4, 6, -12, -18, -14, -3, 0], t), 0, 0)})},
				"Cast": {"dur": 1.2, "loop": false, "fn": func(t: float) -> Dictionary:
					var up: float = _curve([0, 0.6, 1.0, 0.2, -0.3, -0.2, 0.0], t)
					var cross: float = _curve([0, 0.0, 0.2, 1.0, 1.0, 0.5, 0.0], t)
					return low.call({
						"bras.l": Vector3(70.0 * maxf(up, 0.0) + 40.0 * cross, 0, 40.0 * cross),
						"bras.r": Vector3(70.0 * maxf(up, 0.0) + 40.0 * cross, 0, -40.0 * cross),
						"avantbras.l": Vector3(-20.0 * up, 0, 0), "avantbras.r": Vector3(-20.0 * up, 0, 0),
						"thorax": Vector3(6.0 * up - 10.0 * cross, 0, 0), "tete": Vector3(4.0 * up, 0, 0),
						"cuisse.l": Vector3(-8.0 * cross, 0, 0), "cuisse.r": Vector3(16.0 * cross, 0, 0)})},
				"Dead": {"dur": 1.0, "loop": false, "fn": func(t: float) -> Dictionary:
					return low.call(_dead_pose(t, 1.0))},
				"Hit": {"dur": 0.5, "loop": false, "fn": func(t: float) -> Dictionary:
					var h: float = _curve([0.0, 1.0, 0.55, 0.0], t)
					return low.call({"thorax": Vector3(18.0 * h, 0, 5.0 * h), "tete": Vector3(14.0 * h, 0, 0),
						"bras.l": Vector3(-12.0 * h, 0, 10.0 * h), "bras.r": Vector3(-12.0 * h, 0, -10.0 * h),
						"cuisse.r": Vector3(8.0 * h, 0, 0), "cuisse.l": Vector3(-6.0 * h, 0, 0)})},
			}
		# Sylvain (V380) : bâton dans la main gauche (main compensée : le bâton reste droit). Attaque = bâton pointé vers
		# l'ennemi ; sort = bâton levé haut, main droite ouverte devant.
		"sylvain":
			var rest := func(extra: Dictionary) -> Dictionary:
				var d: Dictionary = {"bras.l": Vector3(0, 0, -62), "main.l": Vector3(0, 0, 62), "bras.r": Vector3(0, 0, 62),
					"avantbras.r": Vector3(-20, 0, 0)}
				var st: Dictionary = _stance("bras.r", 1.0)
				for k: String in st.keys():
					d[k] = (d.get(k, Vector3.ZERO) as Vector3) + (st[k] as Vector3)
				for k: String in extra.keys():
					d[k] = (d.get(k, Vector3.ZERO) as Vector3) + (extra[k] as Vector3)
				return d
			return {
				"Idle": {"dur": 5.0, "loop": true, "fn": func(t: float) -> Dictionary:
					return rest.call(_idle_extra(t, "bras.r", 1.0))},
				"Walk": {"dur": 0.8, "loop": true, "fn": func(t: float) -> Dictionary:
					var p: float = sin(t * TAU)
					var q: float = cos(t * TAU)
					return rest.call({"cuisse.l": Vector3(30.0 * p, 0, 0), "cuisse.r": Vector3(-30.0 * p, 0, 0),
						"tibia.l": Vector3(-38.0 * maxf(0.0, -q), 0, 0), "tibia.r": Vector3(-38.0 * maxf(0.0, q), 0, 0),
						"bras.l": Vector3(-10.0 * p, 0, 0), "bras.r": Vector3(18.0 * p, 0, 0),
						"thorax": Vector3(-3.0, 6.0 * p, 0)})},
				"Attack": {"dur": 1.0, "loop": false, "fn": func(t: float) -> Dictionary:
					return rest.call(_staff_attack(t, 1.0, "l"))},
				"Cast": {"dur": 1.4, "loop": false, "fn": func(t: float) -> Dictionary:
					var up: float = _curve([0, 0.35, 0.85, 1, 1, 0.9, 0.4, 0], t)
					var z: float = 150.0 * up
					return rest.call({"bras.l": Vector3(-8.0 * up, 0, z), "main.l": Vector3(0, 0, -z),
						"bras.r": Vector3(50.0 * up, 0, -20.0 * up), "avantbras.r": Vector3(10.0 * up, 0, 0),
						"thorax": Vector3(8.0 * up, 0, 0), "tete": Vector3(14.0 * up, 0, 0)})},
				"Dead": {"dur": 1.0, "loop": false, "fn": func(t: float) -> Dictionary:
					return rest.call(_dead_pose(t, 1.0))},
				"Hit": {"dur": 0.5, "loop": false, "fn": func(t: float) -> Dictionary:
					var h: float = _curve([0.0, 1.0, 0.55, 0.0], t)
					return rest.call({"thorax": Vector3(18.0 * h, 0, 5.0 * h), "tete": Vector3(14.0 * h, 0, 0),
						"bras.r": Vector3(-14.0 * h, 0, 0), "bras.l": Vector3(8.0 * h, 0, 10.0 * h), "main.l": Vector3(0, 0, -10.0 * h),
						"cuisse.r": Vector3(8.0 * h, 0, 0), "cuisse.l": Vector3(-6.0 * h, 0, 0)})},
			}
		# Chasseur (V383) : arc dans la main gauche (comme le bâton du Sylvain), attaque = bandage et tir de l'arc.
		"chasseur", "kharaz":
			var rest := func(extra: Dictionary) -> Dictionary:
				var d: Dictionary = {"bras.l": Vector3(0, 0, -62), "main.l": Vector3(0, 0, 62), "bras.r": Vector3(0, 0, 62),
					"avantbras.r": Vector3(-20, 0, 0)}
				var st: Dictionary = _stance("bras.r", 1.0)
				for k: String in st.keys():
					d[k] = (d.get(k, Vector3.ZERO) as Vector3) + (st[k] as Vector3)
				for k: String in extra.keys():
					d[k] = (d.get(k, Vector3.ZERO) as Vector3) + (extra[k] as Vector3)
				return d
			return {
				"Idle": {"dur": 5.0, "loop": true, "fn": func(t: float) -> Dictionary:
					return rest.call(_idle_extra(t, "bras.r", 1.0))},
				"Walk": {"dur": 0.8, "loop": true, "fn": func(t: float) -> Dictionary:
					var p: float = sin(t * TAU)
					var q: float = cos(t * TAU)
					return rest.call({"cuisse.l": Vector3(30.0 * p, 0, 0), "cuisse.r": Vector3(-30.0 * p, 0, 0),
						"tibia.l": Vector3(-38.0 * maxf(0.0, -q), 0, 0), "tibia.r": Vector3(-38.0 * maxf(0.0, q), 0, 0),
						"bras.l": Vector3(-10.0 * p, 0, 0), "bras.r": Vector3(18.0 * p, 0, 0),
						"thorax": Vector3(-3.0, 6.0 * p, 0)})},
				"Attack": {"dur": 1.0, "loop": false, "fn": func(t: float) -> Dictionary:
					# arc dans la main gauche tendue vers la cible, main droite ramenée à la joue puis relâchée (tir ≈ 0,55)
					var bow: float = _curve([0, 0.8, 1, 1, 1, 0.55, 0], t)
					var d: float = _curve([0, 0.5, 1, 1, 0.1, 0.05, 0], t)
					return rest.call({"bras.l": Vector3(75.0 * bow, 0, 38.0 * bow), "avantbras.l": Vector3(-8.0 * bow, 0, 0),
						"main.l": Vector3(-35.0 * bow, 0, -38.0 * bow),
						"bras.r": Vector3(65.0 * d + 10.0 * (bow - d), 0, -30.0 * d),
						"avantbras.r": Vector3(-95.0 * d, 0, 0),
						"thorax": Vector3(-4.0 * bow, -16.0 * bow, 0), "tete": Vector3(0, 12.0 * bow, 0),
						"cuisse.l": Vector3(10.0 * bow, 0, 0), "cuisse.r": Vector3(-10.0 * bow, 0, 0)})},
				"Cast": {"dur": 1.4, "loop": false, "fn": func(t: float) -> Dictionary:
					var up: float = _curve([0, 0.35, 0.85, 1, 1, 0.9, 0.4, 0], t)
					var z: float = 150.0 * up
					return rest.call({"bras.l": Vector3(-8.0 * up, 0, z), "main.l": Vector3(0, 0, -z),
						"bras.r": Vector3(50.0 * up, 0, -20.0 * up), "avantbras.r": Vector3(10.0 * up, 0, 0),
						"thorax": Vector3(8.0 * up, 0, 0), "tete": Vector3(14.0 * up, 0, 0)})},
				"Dead": {"dur": 1.0, "loop": false, "fn": func(t: float) -> Dictionary:
					return rest.call(_dead_pose(t, 1.0))},
				"Hit": {"dur": 0.5, "loop": false, "fn": func(t: float) -> Dictionary:
					var h: float = _curve([0.0, 1.0, 0.55, 0.0], t)
					return rest.call({"thorax": Vector3(18.0 * h, 0, 5.0 * h), "tete": Vector3(14.0 * h, 0, 0),
						"bras.r": Vector3(-14.0 * h, 0, 0), "bras.l": Vector3(8.0 * h, 0, 10.0 * h), "main.l": Vector3(0, 0, -10.0 * h),
						"cuisse.r": Vector3(8.0 * h, 0, 0), "cuisse.l": Vector3(-6.0 * h, 0, 0)})},
			}
		# Mage (V381) : même squelette que le Sylvain, mais bâton dans la main DROITE (main.r) et grimoire ouvert dans la gauche.
		# Gestes = ceux du Sylvain en miroir (z et y inversés). Attaque = bâton pointé vers l'ennemi ; sort = bâton levé haut,
		# grimoire présenté devant.
		"mage", "geomancien", "druide", "heal":
			var lg: float = 0.55 if name == "heal" else 1.0     # robe longue : jambes moins ouvertes
			var rest := func(extra: Dictionary) -> Dictionary:
				var d: Dictionary = {"bras.r": Vector3(0, 0, 62), "main.r": Vector3(0, 0, -62), "bras.l": Vector3(0, 0, -62),
					"avantbras.l": Vector3(-20, 0, 0)}
				var st: Dictionary = _stance("bras.l", lg)
				for k: String in st.keys():
					d[k] = (d.get(k, Vector3.ZERO) as Vector3) + (st[k] as Vector3)
				for k: String in extra.keys():
					d[k] = (d.get(k, Vector3.ZERO) as Vector3) + (extra[k] as Vector3)
				return d
			return {
				"Idle": {"dur": 5.0, "loop": true, "fn": func(t: float) -> Dictionary:
					return rest.call(_idle_extra(t, "bras.l", lg))},
				"Walk": {"dur": 0.8, "loop": true, "fn": func(t: float) -> Dictionary:
					var p: float = sin(t * TAU)
					var q: float = cos(t * TAU)
					return rest.call({"cuisse.l": Vector3(30.0 * p * lg, 0, 0), "cuisse.r": Vector3(-30.0 * p * lg, 0, 0),
						"tibia.l": Vector3(-38.0 * lg * maxf(0.0, -q), 0, 0), "tibia.r": Vector3(-38.0 * lg * maxf(0.0, q), 0, 0),
						"bras.r": Vector3(-10.0 * p, 0, 0), "bras.l": Vector3(18.0 * p, 0, 0),
						"thorax": Vector3(-3.0, -6.0 * p, 0)})},
				"Attack": {"dur": 1.0, "loop": false, "fn": func(t: float) -> Dictionary:
					return rest.call(_staff_attack(t, lg, "r"))},
				"Cast": {"dur": 1.4, "loop": false, "fn": func(t: float) -> Dictionary:
					var up: float = _curve([0, 0.35, 0.85, 1, 1, 0.9, 0.4, 0], t)
					var z: float = 150.0 * up
					return rest.call({"bras.r": Vector3(-8.0 * up, 0, -z), "main.r": Vector3(0, 0, z),
						"bras.l": Vector3(50.0 * up, 0, 20.0 * up), "avantbras.l": Vector3(10.0 * up, 0, 0),
						"thorax": Vector3(8.0 * up, 0, 0), "tete": Vector3(14.0 * up, 0, 0)})},
				"Dead": {"dur": 1.0, "loop": false, "fn": func(t: float) -> Dictionary:
					return rest.call(_dead_pose(t, lg))},
				"Hit": {"dur": 0.5, "loop": false, "fn": func(t: float) -> Dictionary:
					var h: float = _curve([0.0, 1.0, 0.55, 0.0], t)
					return rest.call({"thorax": Vector3(18.0 * h, 0, -5.0 * h), "tete": Vector3(14.0 * h, 0, 0),
						"bras.l": Vector3(-14.0 * h, 0, 0), "bras.r": Vector3(8.0 * h, 0, -10.0 * h), "main.r": Vector3(0, 0, 10.0 * h),
						"cuisse.l": Vector3(8.0 * h, 0, 0), "cuisse.r": Vector3(-6.0 * h, 0, 0)})},
			}
		"invocateur":
			return {
				# repos : lanterne tenue le long du corps (bras abaissé, main compensée : la lanterne reste droite), livre levé
				# V386 : même repos vivant que les autres héros (appui, respiration, regard), noms d'os de ce squelette
				"Idle": {"dur": 5.0, "loop": true, "fn": func(t: float) -> Dictionary:
					var br: float = sin(t * TAU * 2.0)
					var e: Dictionary = _idle_extra(t, "", 1.0)
					return {
						"bras_l": Vector3(0, 0, -38.0 + 2.5 * br), "main_l": Vector3(0, 0, 38.0 - 2.5 * br),
						"bras_r": Vector3(3.0 * br, 0, 0), "Thorax": e["thorax"], "tete": e["tete"],
						"cuisse_l": (e["cuisse.l"] as Vector3) + Vector3(5.0, 0, 3.0), "tibia_l": (e["tibia.l"] as Vector3) + Vector3(-7.0, 0, 0),
						"cuisse_r": (e["cuisse.r"] as Vector3) + Vector3(-2.0, 0, -3.0), "tibia_r": e["tibia.r"]}},
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
				"Dead": {"dur": 1.0, "loop": false, "fn": func(t: float) -> Dictionary:
					return _to_fr(_dead_pose(t, 1.0))},
				"Hit": {"dur": 0.5, "loop": false, "fn": func(t: float) -> Dictionary:
					var h: float = _curve([0.0, 1.0, 0.55, 0.0], t)
					return {
						"Thorax": Vector3(20.0 * h, 0, 6.0 * h), "tete": Vector3(16.0 * h, 0, 0),
						"bras_l": Vector3(10.0 * h, 0, -38.0 + 14.0 * h), "main_l": Vector3(0, 0, 38.0 - 14.0 * h),
						"bras_r": Vector3(-14.0 * h, 0, 0),
						"cuisse_r": Vector3(8.0 * h, 0, 0), "cuisse_l": Vector3(-6.0 * h, 0, 0)}},
			}
	return {}
