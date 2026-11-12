extends SceneTree
## V154 : animations 3D de Sylvain cuites en séquences de sprites (repos, marche, attaque, sort, coup reçu), face et dos,
## lues par EntityView ; les autres classes gardent leurs poses PNG.
## Lancement : godot --headless --path . -s tests/test_sylvain_seq.gd
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
	var v: EntityView = _view("Sylvain")
	check(v._sq_ok, "Sylvain : séquences 3D chargées")
	var counts := {"idle": 6, "walk": 8, "attack": 7, "cast": 8, "hit": 4}
	var ok_n: bool = true
	for an: String in counts.keys():
		if not v._sq.has(an) or (v._sq[an]["front"] as Array).size() != counts[an] or (v._sq[an]["back"] as Array).size() != counts[an]:
			ok_n = false
	check(ok_n, "5 animations, face et dos, avec le bon nombre d'images")
	check(v._poses.is_empty(), "les anciennes poses PNG ne sont plus chargées")
	check(absf(v.height - 104.0) < 0.5 and v._ph > v.height, "taille d'affichage : personnage 104 px, cellule plus haute (%.0f / %.0f)" % [v.height, v._ph])
	# bout du bâton : dans la cellule pour chaque image
	var ok_tip: bool = true
	var cell: float = float(v._sq_cell)
	for an2: String in v._sq.keys():
		for view: String in ["front", "back"]:
			var tips: Array = v._sq[an2]["tips"][view]
			if tips.size() != counts[an2]:
				ok_tip = false
			for t: Array in tips:
				if float(t[0]) <= 0.0 or float(t[0]) >= cell or float(t[1]) <= 0.0 or float(t[1]) >= cell:
					ok_tip = false
	check(ok_tip, "bout du bâton connu et dans la cellule pour toutes les images")
	# repos / marche
	v.entity["facing"] = Vector2i(0, 1)
	var fr: Texture2D = v._seq_tex()
	check(fr is AtlasTexture and (fr as AtlasTexture).atlas.resource_path.ends_with("sylvain_seq_front.png") or (v._facing_back() and (fr as AtlasTexture).atlas.resource_path.ends_with("sylvain_seq_back.png")), "repos : image d'une planche")
	var seen := {}
	for k: int in range(40):
		v._t = float(k) * 0.07
		seen[v._seq_tex()] = true
	check(seen.size() >= 4, "le repos boucle sur plusieurs images (%d)" % seen.size())
	v._moving = true
	var seen_w := {}
	for k2: int in range(40):
		v._t = float(k2) * 0.03
		seen_w[v._seq_tex()] = true
	check(seen_w.size() >= 6, "la marche boucle sur ses images (%d)" % seen_w.size())
	v._moving = false
	# orientation : de dos → planche de dos
	var up := Vector2i.ZERO
	var down := Vector2i.ZERO
	for d: Vector2i in [Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)]:
		v.entity["facing"] = d
		if v._facing_back():
			up = d
		else:
			down = d
	v.entity["facing"] = up
	check((v._seq_tex() as AtlasTexture).atlas.resource_path.ends_with("_seq_back.png"), "de dos : planche de dos")
	v.entity["facing"] = down
	check((v._seq_tex() as AtlasTexture).atlas.resource_path.ends_with("_seq_front.png"), "de face : planche de face")
	# attaque : démarre, image clé, bout du bâton, retour au repos
	v.play_pose("attack", 0.6, "Coup")
	check(v._sq_act == "attack" and v._sq_act_dur > 0.2 and v._sq_act_dur < 0.8, "attaque : animation lancée (%.2f s)" % v._sq_act_dur)
	var hit: float = v.impact_delay("attack")
	check(hit > 0.15 and hit < v._sq_act_dur, "délai d'impact entre 0,15 s et la fin du geste (%.2f s)" % hit)
	v._sq_act_t = hit + 0.001
	var tx: Texture2D = v._seq_tex()
	var tip: Vector2 = v.tip_position(Vector2(-9999, -9999))
	check(tip.x > -9000.0 and absf(tip.x - v.position.x) < 200.0 and absf(tip.y - v.position.y) < 250.0, "bout du bâton à l'impact près du personnage (%s)" % str(tip))
	check(tx != null, "image d'impact disponible")
	v._sq_act_t = v._sq_act_dur + 0.01
	v._seq_tex()
	check(v._sq_act == "", "fin du geste : retour au repos")
	# sort et coup reçu
	v.cast_pose("Soin")
	check(v._sq_act == "cast" and v.impact_delay("cast") > 0.15, "sort : animation lancée, image clé à %.2f s" % v.impact_delay("cast"))
	v.hit_react(1.0)
	check(v._sq_act == "hit", "coup reçu : animation « hit »")
	# l'élan culmine à l'impact
	v.position = Vector2(100, 100)
	var tw: Tween = v.lunge(Vector2(300, 100), "Coup")
	check(tw != null and v._sq_act == "attack", "lunge lance l'attaque 3D")
	# sans séquences : autre classe inchangée
	var m: EntityView = _view("Mage")
	check(not m._sq_ok and not m._poses.is_empty(), "Mage : poses PNG conservées")
	check(m.impact_delay("attack") == 0.0 and m.tip_position(Vector2(7, 8)) == Vector2(7, 8), "sans séquences : pas de délai, bout de bâton = valeur de repli")
	m.play_pose("attack", 0.6, "Coup")
	check(m._sq_act == "", "sans séquences : play_pose utilise les poses PNG")
	print("ÉCHECS : ", fails)
	quit(1 if fails > 0 else 0)
