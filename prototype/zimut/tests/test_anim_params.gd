extends SceneTree
## V35 : réglages d'animation procédurale (<sprite>_anim.txt) — valeurs par défaut,
## surcharge, bornes de sécurité. Usage : godot --headless -s tests/test_anim_params.gd
func _init() -> void:
	var ok: bool = true
	var d: Dictionary = EntityView.anim_params("res://assets/sprites/players/__absent__.png")
	ok = ok and is_equal_approx(float(d["rebond_marche"]), 9.0)
	var dir: String = "user://anim_test"
	DirAccess.make_dir_recursive_absolute(dir)
	var f := FileAccess.open(dir + "/golem_anim.txt", FileAccess.WRITE)
	f.store_string('{"rebond_marche": 3, "respiration": 0.5, "inconnu": 1}')
	f.close()
	var g: Dictionary = EntityView.anim_params(dir + "/golem.png")
	ok = ok and is_equal_approx(float(g["rebond_marche"]), 3.0)
	ok = ok and is_equal_approx(float(g["respiration"]), 0.08)  # borné
	ok = ok and is_equal_approx(float(g["elan_attaque"]), 26.0)  # défaut conservé
	ok = ok and not g.has("inconnu")
	print("test_anim_params : ", "OK" if ok else "ÉCHEC", " ", g)
	quit(0 if ok else 1)
