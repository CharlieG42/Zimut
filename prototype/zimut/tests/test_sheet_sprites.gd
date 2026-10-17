extends SceneTree
## Vérifie les sprites issus de la planche « Nations » : présence, chargement, fond transparent
## (coins vides, personnage visible) et héros réellement utilisés en jeu.
## Lancement : godot --headless --path . -s tests/test_sheet_sprites.gd
var fails: int = 0
func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1
func _init() -> void:
	_boot.call_deferred()
func _opaque_ratio(img: Image) -> float:
	var n: int = 0
	for y: int in range(img.get_height()):
		for x: int in range(img.get_width()):
			if img.get_pixel(x, y).a > 0.5:
				n += 1
	return float(n) / float(img.get_width() * img.get_height())
func _check_sprite(path: String, label: String) -> void:
	var tex: Texture2D = load(path) as Texture2D
	if tex == null:
		check(false, "%s : chargement" % label)
		return
	var img: Image = tex.get_image()
	var w: int = img.get_width()
	var h: int = img.get_height()
	var corners_clear: bool = img.get_pixel(0, 0).a < 0.1 and img.get_pixel(w - 1, 0).a < 0.1 \
		and img.get_pixel(0, h - 1).a < 0.1 and img.get_pixel(w - 1, h - 1).a < 0.1
	var ratio: float = _opaque_ratio(img)
	check(corners_clear and ratio > 0.18 and ratio < 0.92, "%s : fond transparent (%dx%d, %d %% opaque)" % [label, w, h, int(ratio * 100.0)])
func _boot() -> void:
	var heros: Array[String] = ["tank", "assassin", "chasseur", "mage", "druide", "heal", "invocateur", "sylvain", "geomancien"]
	for c: String in heros:
		_check_sprite("res://assets/sprites/nations/heros/%s.png" % c, "héros " + c)
	for f: String in ["golem_de_pierre", "loup_spectral", "archer_sylvestre", "elementaire_de_cristal", "esprit_de_la_foret",
			"requin_des_marees", "ombre_invoquee", "ent_de_combat", "sentinelle_de_gres"]:
		_check_sprite("res://assets/sprites/familiers/%s.png" % f, "familier " + f)
	var ennemis := {
		"cimes": ["rochebrute", "guerrier_des_monts", "griffon_des_cimes", "garde_des_pics"],
		"ombres": ["assassin_des_ombres", "spectre", "liche", "ombre_infernale"],
		"sylvestre": ["loup_forestier", "araknea", "dryade", "treant"],
		"cristaux": ["golem_de_cristal", "mage_cristallin", "elementaire_de_cristal", "araignee_de_cristal"],
		"sables": ["scarabee_geant", "bandit_des_dunes", "genie_du_desert", "sphinx"],
		"vents": ["harpie", "aigle_celeste", "garde_aerien", "elementaire_de_vent"],
		"marees": ["crabe_geant", "nereide", "requin", "pirate_des_mers"],
		"brasier": ["salamandre", "devoreur_de_flammes", "golem_de_lave", "lieutenant"],
		"brumes": ["brumeux", "liche_des_brumes", "fantome", "gargouille"],
	}
	var count: int = 0
	for nation: String in ennemis.keys():
		for e: String in ennemis[nation]:
			_check_sprite("res://assets/sprites/nations/ennemis/%s/%s.png" % [nation, e], "ennemi %s/%s" % [nation, e])
			count += 1
	check(count == 36, "36 ennemis par nation")
	# Héros utilisés en jeu : mêmes images que la planche (sauf classes qui invoquent)
	var used: Array[String] = ["tank", "assassin", "chasseur", "mage", "druide", "heal", "invocateur", "sylvain", "geomancien"]
	for c2: String in used:
		var a: Image = (load("res://assets/sprites/players/%s.png" % c2) as Texture2D).get_image()
		var b: Image = (load("res://assets/sprites/nations/heros/%s.png" % c2) as Texture2D).get_image()
		var ra: float = float(a.get_width()) / float(a.get_height())
		var rb: float = float(b.get_width()) / float(b.get_height())
		check(ra > rb * 1.15, "%s : proportions chibi (largeur/hauteur %.2f contre %.2f sur la planche)" % [c2, ra, rb])
	var tex: Texture2D = Portraits.get_texture({"classe": "Tank", "team": "player", "entity_type": "Player"})
	check(tex != null and tex.get_height() > 200, "Portraits charge le nouveau Tank (hauteur %d)" % (tex.get_height() if tex != null else 0))
	print("\n%s — %d échec(s)" % ["OK" if fails == 0 else "KO", fails])
	quit(1 if fails > 0 else 0)
