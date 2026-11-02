extends SceneTree
## Tenues du héros 3D par classe : chaque classe produit un modèle complet, avec sa propre palette.
## Lancement : godot --headless --path . -s tests/test_heros_classes.gd
var fails: int = 0
func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1
func _init() -> void:
	var seen: Dictionary = {}
	for cls: String in Adv3DHeroModel.CLASS_LOOK.keys():
		var h: Node3D = Adv3DHeroModel.make_hero(cls)
		check(h != null and h.find_child("Head", true, false) != null, "héros %s construit" % cls)
		seen[str(Adv3DHeroModel._pal["tun_l"])] = true
		h.free()
	check(seen.size() == Adv3DHeroModel.CLASS_LOOK.size(), "chaque classe a une veste de couleur différente")
	var d: Node3D = Adv3DHeroModel.make_hero("")
	check(d != null, "classe vide : tenue Sylvain par défaut")
	d.free()
	for cls2: String in ["Tank", "Assassin", "Chasseur", "Mage", "Druide", "Heal", "Invocateur", "Sylvain", "Géomancien", "Artificier"]:
		check(Adv3DHeroModel.CLASS_LOOK.has(cls2), "tenue définie pour %s" % cls2)
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
