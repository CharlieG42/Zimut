extends SceneTree
## V34 : poses de dos (<sprite>_back_attack…), variantes jusqu'à 9, marche sur plusieurs poses.
## Lancement : godot --headless --path . -s tests/test_back_poses.gd
var fails: int = 0
func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1
func _init() -> void:
	_boot.call_deferred()
func _tex(c: Color) -> Texture2D:
	var img := Image.create(4, 4, false, Image.FORMAT_RGBA8)
	img.fill(c)
	return ImageTexture.create_from_image(img)
func _boot() -> void:
	await process_frame
	var v := EntityView.new()
	root.add_child(v)
	v.setup({"uid": 3, "classe": "Assassin", "team": "player", "entity_type": "Player", "current_pv": 10, "max_pv": 10, "x": 2, "y": 3})
	check((v._poses.get("attack", []) as Array).size() >= 5, "poses d'attaque de face chargées (%d)" % (v._poses.get("attack", []) as Array).size())
	check(v._load_variants("res://assets/sprites/players/assassin_attack", false).size() == (v._poses["attack"] as Array).size(), "_load_variants lit les mêmes fichiers")
	# orientation : trouver une direction de grille vue de dos et une vue de face
	var up := Vector2i.ZERO
	var down := Vector2i.ZERO
	for d: Vector2i in [Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)]:
		v.entity["facing"] = d
		if v._facing_back():
			up = d
		else:
			down = d
	check(up != Vector2i.ZERO and down != Vector2i.ZERO, "directions de face et de dos trouvées")
	# sans poses de dos dédiées : attaques de face (comportement d'avant)
	v.entity["facing"] = up
	v.play_pose("attack", 0.6, "Test")
	check(v._act_tex != null and (v._poses["attack"] + v._poses.get("cast", []) + v._poses.get("walk", []) + v._poses.get("idle", [])).has(v._act_tex), "de dos sans fichiers _back_attack : poses de face conservées")
	v._seq.clear()
	v._act_tex = null
	# avec poses de dos : uniquement elles
	var b1: Texture2D = _tex(Color.RED)
	var b2: Texture2D = _tex(Color.BLUE)
	var w1: Texture2D = _tex(Color.GREEN)
	var w2: Texture2D = _tex(Color.YELLOW)
	v._poses["back_attack"] = [b1, b2]
	v._poses["back_walk"] = [w1, w2]
	var ok_back: bool = true
	for s: String in ["Coup", "Lame", "Ombre", "Saut", "Piège"]:
		v.play_pose("attack", 0.6, s)
		var used: Array = [v._act_tex]
		for st in v._seq:
			used.append(st[0])
		for t in used:
			if not [b1, b2, w1, w2, v._poses["back"][0]].has(t):
				ok_back = false
		v._seq.clear()
		v._act_tex = null
	check(ok_back, "de dos : seules les poses de dos sont jouées")
	v.entity["facing"] = down
	v.play_pose("attack", 0.6, "Coup")
	check(not [b1, b2, w1, w2].has(v._act_tex), "de face : les poses de dos ne sont pas utilisées")
	v._seq.clear()
	v._act_tex = null
	# marche de dos : alterne back_walk et repos de dos
	v.entity["facing"] = up
	v._moving = true
	var seen: Dictionary = {}
	for i: int in range(8):
		v._t = 0.05 + 0.16 * float(i)
		seen[v._wanted_tex()] = true
	check(seen.has(w1) and seen.has(w2) and seen.has(v._poses["back"][0]), "marche de dos : walk, walk_2 et repos de dos en alternance")
	v._moving = false
	check(v._wanted_tex() == v._poses["back"][0], "à l'arrêt de dos : repos de dos")
	print("ÉCHECS : ", fails)
	quit(0 if fails == 0 else 1)
