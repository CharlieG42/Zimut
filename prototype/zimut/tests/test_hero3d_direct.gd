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
	# HeroAnim est livré avec le jeu (scripts/), pas avec les outils
	check(FileAccess.file_exists("res://scripts/HeroAnim.gd"), "HeroAnim dans scripts/ (exporté avec le jeu)")
	print("FIN : ", fails, " échec(s)")
	quit(1 if fails > 0 else 0)
