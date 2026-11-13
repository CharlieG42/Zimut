extends SceneTree
## V161 : prototype « Sylvain en 3D en direct » en combat (réglage hors défaut). Le rendu lui-même ne se teste pas en headless
## (pas de GPU) : on vérifie ici la logique (modèle, os, bâton, réglage, repli sur les sprites cuits).
## Lancement : godot --headless --path . -s tests/test_hero3d_direct.gd
var fails: int = 0
func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1
func _init() -> void:
	_boot.call_deferred()
func _view(classe: String) -> EntityView:
	var v := EntityView.new()
	root.add_child(v)
	v.setup({"uid": 5, "classe": classe, "team": "player", "entity_type": "Player", "current_pv": 10, "max_pv": 10, "x": 2, "y": 3})
	return v
func _view_ent(e: Dictionary) -> EntityView:
	var v := EntityView.new()
	root.add_child(v)
	v.setup(e)
	return v
func _boot() -> void:
	await process_frame
	var gs: Node = root.get_node("GameSettings")
	check(not bool(gs.get("hero_3d_direct")), "réglage « 3D en direct » désactivé par défaut")
	check(Hero3D.supported("Sylvain") and not Hero3D.supported("Géomancien"), "seul Sylvain a un modèle 3D direct")
	check(FileAccess.file_exists("res://assets/heroes3d/sylvain.glb"), "modèle sylvain.glb présent")
	check(FileAccess.get_file_as_bytes("res://assets/heroes3d/sylvain.glb").size() < 1_000_000, "modèle léger (< 1 Mo)")
	# réglage par défaut : sprites cuits, pas de 3D
	var v0: EntityView = _view("Sylvain")
	await process_frame
	check(v0._sq_ok and v0._h3d == null, "réglage éteint : sprites cuits, aucun rendu 3D")
	v0.queue_free()
	# réglage allumé : le héros 3D est créé, os et bâton trouvés
	gs.set("hero_3d_direct", true)
	var v: EntityView = _view("Sylvain")
	await process_frame
	await process_frame
	check(v._h3d != null, "réglage allumé : héros 3D créé")
	if v._h3d != null:
		var h: Hero3D = v._h3d
		check(h.tip_ok, "pointe du bâton calculée")
		var names_ok: bool = true
		for bn: String in ["bras.r", "bras.l", "avantbras.r", "cuisse.l", "tibia.r", "pied.l", "torse", "main.r"]:
			if h._bone(bn) < 0:
				names_ok = false
				print("   os introuvable : ", bn)
		check(names_ok, "les os des poses (HeroAnim) se retrouvent dans le .glb")
		check(not h.ready_ok or h.texture() != null, "texture disponible une fois cadré")
	# le héros 3D ne touche pas aux autres classes
	var v2: EntityView = _view("Géomancien")
	await process_frame
	check(v2._h3d == null and v2._sq_ok, "Géomancien : toujours des sprites cuits")
	gs.set("hero_3d_direct", false)
	# V163 : modèles à animations intégrées (Tharok = boss de la Forêt, Ingénieur = classe interne « Artificier »)
	check(Hero3D.model_key({"classe": "Gobelin Roi", "boss": true, "team": "enemy"}) == "Tharok", "boss de la Forêt -> modèle Tharok")
	check(Hero3D.model_key({"classe": "Tharok le Végétal", "boss": true, "team": "enemy"}) == "Tharok", "général Tharok -> modèle Tharok")
	check(Hero3D.model_key({"classe": "Gobelin Roi", "boss": false, "team": "enemy"}) == "", "un Gobelin Roi non-boss n'a pas de modèle 3D")
	check(Hero3D.model_key({"classe": "Artificier", "team": "player"}) == "Ingénieur", "classe Artificier -> modèle Ingénieur")
	check(Hero3D.model_key({"classe": "Artificier", "team": "enemy"}) == "", "un ennemi ne prend pas le modèle d'un héros")
	check(Hero3D.model_key({"classe": "Chasseur", "team": "player"}) == "Chasseur" and Hero3D.model_key({"classe": "Invocateur", "team": "player"}) == "Invocateur", "Chasseur et Invocateur ont leur modèle")
	check(Hero3D.model_key({"classe": "Tank", "team": "player"}) == "Tank", "classe Tank -> modèle Tank")
	for k: String in ["Tharok", "Ingénieur", "Chasseur", "Invocateur", "Tank"]:
		var packed: PackedScene = load(String(Hero3D.MODELS[k]["path"])) as PackedScene
		var inst: Node = packed.instantiate()
		var aps: Array = inst.find_children("*", "AnimationPlayer", true, false)
		check(not aps.is_empty(), k + " : animations dans le .glb")
		var clips: Dictionary = Hero3D.MODELS[k]["clips"]
		var clips_ok: bool = not aps.is_empty()
		for an: String in ["idle", "walk", "attack", "cast", "hit"]:
			if not clips.has(an):
				clips_ok = false
				print("   action sans clip : ", k, " ", an)
				continue
			var c: Dictionary = clips[an]
			if not aps.is_empty():
				var ap: AnimationPlayer = aps[0] as AnimationPlayer
				if not ap.has_animation(String(c["clip"])):
					clips_ok = false
					print("   clip introuvable : ", c["clip"])
				elif float(c["t1"]) > ap.get_animation(String(c["clip"])).length + 0.001 or float(c["t0"]) > float(c["t1"]):
					clips_ok = false
					print("   plage de clip invalide : ", k, " ", an)
		check(clips_ok, k + " : chaque action pointe sur un clip existant et une plage valide")
		inst.free()
	# V163 : hache du Tank rigide (tête et manche liés au même os) : plus aucun sommet n'a pour os dominant les deux os racine du bas du manche
	var tank: Node = (load("res://assets/heroes3d/tank.glb") as PackedScene).instantiate()
	var tmi: MeshInstance3D = tank.find_children("*", "MeshInstance3D", true, false)[0] as MeshInstance3D
	var tsk: Skeleton3D = tank.find_children("*", "Skeleton3D", true, false)[0] as Skeleton3D
	var tar: Array = tmi.mesh.surface_get_arrays(0)
	var tb: PackedInt32Array = tar[Mesh.ARRAY_BONES]
	var tw: PackedFloat32Array = tar[Mesh.ARRAY_WEIGHTS]
	var tper: int = tb.size() / (tar[Mesh.ARRAY_VERTEX] as PackedVector3Array).size()
	var on_thumb: int = 0
	var on_roots: int = 0
	for vtx: int in range((tar[Mesh.ARRAY_VERTEX] as PackedVector3Array).size()):
		var best: int = 0
		for k: int in range(1, tper):
			if tw[vtx * tper + k] > tw[vtx * tper + best]:
				best = k
		var bi: int = tmi.skin.get_bind_bone(tb[vtx * tper + best])
		var bn: String = tsk.get_bone_name(bi) if bi >= 0 else tmi.skin.get_bind_name(tb[vtx * tper + best])
		if bn.to_lower() == "thumb_01_r":
			on_thumb += 1
		if bn.to_lower() in ["bone_053", "bone_052"]:
			on_roots += 1
	check(on_roots == 0 and on_thumb > 600, "Tank : hache rigide (%d sommets au pouce, %d aux os racine)" % [on_thumb, on_roots])
	tank.free()
	gs.set("hero_3d_direct", true)
	var v3: EntityView = _view_ent({"uid": 9, "classe": "Gobelin Roi", "team": "enemy", "entity_type": "Enemy", "boss": true, "current_pv": 10, "max_pv": 10, "x": 3, "y": 3})
	await process_frame
	await process_frame
	# sans GPU (headless) le cadrage ne se termine pas : on vérifie seulement que le héros 3D est créé et son modèle chargé
	var made: bool = false
	for c: Node in v3.get_children():
		if c is Hero3D and (c as Hero3D)._ap != null:
			made = true
	check(made, "Tharok : rendu 3D créé pour le boss (réglage allumé), animations chargées")
	gs.set("hero_3d_direct", false)
	# HeroAnim est livré avec le jeu (scripts/), pas avec les outils
	check(FileAccess.file_exists("res://scripts/HeroAnim.gd"), "HeroAnim dans scripts/ (exporté avec le jeu)")
	print("FIN : ", fails, " échec(s)")
	quit(1 if fails > 0 else 0)
