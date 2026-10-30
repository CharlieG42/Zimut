extends SceneTree
## V60 : mode Aventure en monde 3D (bêta) — génération du monde, praticabilité, connexité,
## scène jouable (marche, contact avec un groupe, sauvegarde, lancement d'un combat Tactique).
## Lancement : godot --headless --path . -s tests/test_adventure3d.gd
var fails: int = 0

func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1

func _init() -> void:
	_boot.call_deferred()

func _boot() -> void:
	var pm: Node = root.get_node("ProgressionManager")
	var gm: Node = root.get_node("GameManager")

	# ── 1. Repère et relief ───────────────────────────────────────────
	var c := Vector2i(5, 7)
	check(Adv3DWorld.world_to_cell(Adv3DWorld.cell_center(c)) == c, "cell_center ↔ world_to_cell cohérents")
	var edge_a: float = Adv3DWorld.height_at(Adv3DWorld.CELL * 4.0 - 0.0001, 7.3)
	var edge_b: float = Adv3DWorld.height_at(Adv3DWorld.CELL * 4.0 + 0.0001, 7.3)
	check(absf(edge_a - edge_b) < 0.01, "relief continu à la frontière de deux cases")
	check(absf(Adv3DWorld.height_at(10.0, 10.0)) <= Adv3DWorld.HEIGHT_AMPLITUDE + 0.001, "relief borné")

	# ── 2. Construction du monde pour plusieurs biomes ────────────────
	for z: String in ["foret_sylve", "montagne_pics", "desert_dunes"]:
		var w: Node3D = Adv3DWorld.build(z)
		root.add_child(w)
		var ground: MeshInstance3D = w.get_node_or_null("Ground")
		check(ground != null and ground.mesh != null and ground.mesh.get_surface_count() == 1, "%s : sol généré" % z)
		var t: Dictionary = AdventureTerrain.zone_terrain(z)
		var multis: int = 0
		for ch: Node in w.get_children():
			if ch is MultiMeshInstance3D:
				multis += (ch as MultiMeshInstance3D).multimesh.instance_count
		check(multis >= (t["obstacles"] as Dictionary).size(), "%s : un décor par obstacle (%d)" % [z, multis])
		w.queue_free()

	# ── 3. Praticabilité et connexité (marche libre sur l'île) ────────
	for z2: String in ["foret_sylve", "montagne_pics", "desert_dunes"]:
		var t2: Dictionary = AdventureTerrain.zone_terrain(z2)
		var size: Vector2i = t2["size"]
		var start_p: Vector3 = Adv3DWorld.cell_center(t2["start"])
		check(Adv3DWorld.point_walkable(t2, start_p), "%s : le départ est praticable" % z2)
		var blocked_ok := true
		for o: Vector2i in (t2["obstacles"] as Dictionary).keys():
			if Adv3DWorld.point_walkable(t2, Adv3DWorld.cell_center(o)):
				blocked_ok = false
		check(blocked_ok, "%s : le centre d'un obstacle bloque" % z2)
		var void_ok := true
		for v: Vector2i in (t2["voids"] as Dictionary).keys():
			if Adv3DWorld.point_walkable(t2, Adv3DWorld.cell_center(v)):
				void_ok = false
		check(void_ok, "%s : le vide bloque" % z2)
		check(not Adv3DWorld.point_walkable(t2, Vector3(-1.0, 0.0, 2.0)), "%s : hors de l'île = bloqué" % z2)
		var reach: Dictionary = _flood(t2, start_p)
		var targets: Array = []
		for p: Vector2i in t2["pois"]:
			targets.append(p)
		for g: Vector2i in t2["gates"]:
			targets.append(g)
		var unreachable := 0
		for tg: Vector2i in targets:
			var tp: Vector3 = Adv3DWorld.cell_center(tg)
			var key := Vector2i(roundi(tp.x / 0.5), roundi(tp.z / 0.5))
			if not reach.has(key):
				unreachable += 1
		check(unreachable == 0, "%s : lieux et portes atteignables à pied (%d cibles, %d inaccessibles)" % [z2, targets.size(), unreachable])
		check(size.x > 0, "%s : taille %s" % [z2, str(size)])

	# ── 4. Scène jouable ──────────────────────────────────────────────
	var data: Dictionary = pm.new_game(4, "Test3D")
	pm.rebuild_team(data, ["Chasseur", "Mage", "Sylvain"])
	data["campaign_mode"] = "adventure"
	pm.adventure_state(data)
	gm.active_save = data
	gm.active_slot = 4
	var gset: Node = root.get_node("GameSettings")
	gset.adventure_models_3d = false          # scène « illustrations » (les modèles 3D sont testés plus bas)
	var scene: Node = (load("res://scenes/Adventure3D.tscn") as PackedScene).instantiate()
	root.add_child(scene)
	await process_frame
	await process_frame
	check(scene.explorer != null, "scène : explorateur présent")
	check(scene.get("world_root") != null, "scène : monde construit")
	var mobs: Array = scene.manager.mobs()
	check(mobs.size() >= 1 and scene._mob_nodes.size() == mobs.size(), "scène : un nœud 3D par groupe de monstres (%d)" % mobs.size())
	var pois: Dictionary = pm.ADVENTURE_POIS["foret_sylve"]
	check(scene._poi_nodes.size() == pois.size(), "scène : un marqueur par lieu (%d)" % pois.size())
	check(scene._gate_nodes.size() == scene.manager.gates().size(), "scène : un portique par porte")

	# personnage « carton » : joueur et Gligli, 8 directions
	var spr: Adv3DSpriteActor = scene.explorer._sprite
	check(spr != null, "sprites : le joueur est une illustration")
	check(scene._companion != null, "sprites : Gligli est présent")
	if spr != null:
		var expect: Array = [[0.0, "face", false], [PI * 0.25, "quart_face", false], [PI * 0.5, "cote", false], [PI * 0.75, "quart_dos", false],
			[PI, "dos", false], [-PI * 0.75, "quart_dos", true], [-PI * 0.5, "cote", true], [-PI * 0.25, "quart_face", true]]
		var ok_dirs := true
		for e: Array in expect:
			spr.set_facing(float(e[0]) + 0.3, 0.3)
			if spr._current_key != String(e[1]) or (String(e[1]) != "dos" and spr._sprite.flip_h != bool(e[2])):
				ok_dirs = false
				print("   direction ", e, " -> ", spr._current_key, " flip=", spr._sprite.flip_h)
		check(ok_dirs, "sprites : la vue suit l'angle caméra / cap (8 directions)")
		check(absf(spr._sprite.pixel_size * spr._sprite.texture.get_height() - 2.3) < 0.01, "sprites : le joueur mesure 2,3 m")
	if scene._companion != null:
		var dd: float = scene._companion.position.distance_to(scene.explorer.position)
		check(dd < 3.0, "sprites : Gligli est près du joueur (%.1f m)" % dd)
		scene._companion.emote("heureux")
		check(scene._companion._emote.visible, "sprites : bulle d'émotion affichée")

	# vrais modèles 3D (réglage « Modèles 3D ») : joueur + Gligli plus petit, animés
	gset.adventure_models_3d = true
	var scene3: Node = (load("res://scenes/Adventure3D.tscn") as PackedScene).instantiate()
	root.add_child(scene3)
	await process_frame
	await process_frame
	check(scene3.explorer._sprite == null and scene3.explorer._model != null and scene3.explorer._model.name == "Hero3D", "modèles 3D : le joueur est un vrai modèle")
	check(scene3._companion != null and scene3._companion._model != null, "modèles 3D : Gligli est un vrai modèle")
	if scene3._companion != null and scene3._companion._model != null:
		check(absf(scene3._companion._model.scale.x - 0.8) < 0.01, "modèles 3D : Gligli à 80 %")
		var rig: Adv3DHeroRig = scene3.explorer._rig
		check(rig != null, "modèles 3D : le joueur est animé (squelette)")
		scene3._stick.value = Vector2(0.3, -0.95)
		var max_stride := 0.0
		var max_hop := 0.0
		for _i: int in range(50):
			await physics_frame
			if rig != null:
				max_stride = maxf(max_stride, rig.stride())
			max_hop = maxf(max_hop, scene3._companion._model.body.position.y)
		check(scene3._companion.position.distance_to(scene3.explorer.position) < 4.0, "modèles 3D : Gligli suit le joueur")
		check(max_stride > 0.35, "modèles 3D : le joueur fait de vrais pas (%.2f rad)" % max_stride)
		check(max_hop > 0.03, "modèles 3D : Gligli avance en bondissant (%.2f m)" % max_hop)
		scene3._stick.value = Vector2.ZERO
		for _i: int in range(70):
			await physics_frame
		if rig != null:
			check(rig.stride() < 0.08, "modèles 3D : retour au repos à l'arrêt (%.2f rad)" % rig.stride())
		scene3._companion.emote("surpris")
		check(scene3._companion._emote.visible, "modèles 3D : bulle d'émotion")
	scene3.queue_free()
	await process_frame
	gset.adventure_models_3d = false

	# marche : on déplace l'explorateur de quelques cases et on vérifie l'état de jeu
	var moves0: int = int(scene.manager.state.get("moves", 0))
	var start_cell: Vector2i = scene.explorer.current_cell
	var next_cell: Vector2i = start_cell
	for d: Vector2i in [Vector2i(1, 0), Vector2i(0, 1), Vector2i(-1, 0), Vector2i(0, -1)]:
		var cand: Vector2i = start_cell + d
		if AdventureTerrain.walkable("foret_sylve", cand) and scene.manager.mob_at(cand).is_empty():
			next_cell = cand
			break
	scene.explorer.place_at(Adv3DWorld.cell_center(next_cell))
	scene.explorer.cell_changed.emit(next_cell)
	check(int(scene.manager.state.get("moves", 0)) == moves0 + 1, "marche : un pas de plus compté")
	check(scene.manager.hero_pos() == next_cell, "marche : la case du héros suit l'explorateur")

	# contact avec un groupe : fenêtre de combat, puis « plus tard »
	var g: Dictionary = mobs[0]
	var mnode: Node3D = scene._mob_nodes[int(g["id"])]
	scene._declined_mobs.clear()
	scene.explorer.place_at(Vector3(mnode.position.x, 0.0, mnode.position.z))
	await process_frame
	await process_frame
	check(scene._modal_root != null, "contact : la proposition de combat s'ouvre")
	scene._close_modal()
	scene._declined_mobs[int(g["id"])] = true
	await process_frame
	check(scene._modal_root == null, "contact : « plus tard » ne rouvre pas la fenêtre")

	# sauvegarde de la position 3D
	scene._persist()
	check(scene.manager.state.has("pos3d") and String(scene.manager.state.get("pos3d_zone", "")) == "foret_sylve", "sauvegarde : position 3D enregistrée")
	var again: Vector3 = scene._start_position()
	check(Adv3DWorld.world_to_cell(again) == scene.manager.hero_pos(), "reprise : position cohérente avec la case du héros")

	# lancement du combat : même circuit que la carte classique
	scene.set("_left", false)
	scene._start_mob_combat(g)
	var st: Dictionary = scene.manager.state
	check(String(st.get("pending_challenge", "")) == AdventureMobs.challenge_key("foret_sylve", int(g["id"])), "combat : défi « groupe » posé")
	check(int(st.get("pending_level", 0)) == int(g["level"]), "combat : niveau du groupe transmis")
	check(gm.fight_biome == "Forêt", "combat : décor de la zone")

	# réglage et scène d'Aventure
	var gs: Node = root.get_node("GameSettings")
	gs.adventure_3d = false
	check(gs.adventure_scene().ends_with("AdventureMap.tscn"), "réglage : carte classique par défaut")
	gs.adventure_3d = true
	check(gs.adventure_scene().ends_with("Adventure3D.tscn"), "réglage : monde 3D si activé")
	gs.adventure_3d = false

	pm.delete_save(4)
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)


## Remplissage à pas de 0,5 m depuis le départ, avec le même rayon que l'explorateur.
func _flood(t: Dictionary, from: Vector3) -> Dictionary:
	var seen: Dictionary = {}
	var q: Array[Vector2i] = [Vector2i(roundi(from.x / 0.5), roundi(from.z / 0.5))]
	seen[q[0]] = true
	var r: float = Adv3DExplorer.RADIUS
	var head := 0
	while head < q.size():
		var cur: Vector2i = q[head]
		head += 1
		for d: Vector2i in [Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)]:
			var n: Vector2i = cur + d
			if seen.has(n):
				continue
			var p := Vector3(float(n.x) * 0.5, 0.0, float(n.y) * 0.5)
			var ok := Adv3DWorld.point_walkable(t, p)
			if ok:
				for o: Vector2 in [Vector2(r, 0.0), Vector2(-r, 0.0), Vector2(0.0, r), Vector2(0.0, -r)]:
					if not Adv3DWorld.point_walkable(t, Vector3(p.x + o.x, 0.0, p.z + o.y)):
						ok = false
						break
			if ok:
				seen[n] = true
				q.append(n)
	return seen
