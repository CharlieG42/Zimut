extends SceneTree
## Réglage Graphismes « Taille des personnages / adversaires » (mode Tactique, plage 75 % à 125 %).
## Lancement : godot --headless --path prototype/zimut -s tests/test_char_size.gd

var fails: int = 0

func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1

func _init() -> void:
	_boot.call_deferred()

func _boot() -> void:
	var gs: Node = root.get_node("GameSettings")
	check(gs.CHAR_SIZES.size() == 5 and gs.CHAR_SIZES.size() == gs.CHAR_SIZE_MULT.size(), "5 paliers de taille, libellés et multiplicateurs alignés")
	check(is_equal_approx(float(gs.CHAR_SIZE_MULT[0]), 0.75) and is_equal_approx(float(gs.CHAR_SIZE_MULT[gs.CHAR_SIZE_MULT.size() - 1]), 1.25), "plage bornée à 75 % - 125 %")
	check(int(gs.hero_size) == 2 and int(gs.enemy_size) == 2, "100 % par défaut pour les deux équipes")
	check(is_equal_approx(gs.char_scale_mult("player"), 1.0) and is_equal_approx(gs.char_scale_mult("enemy"), 1.0), "char_scale_mult = 1.0 par défaut")
	gs.set_hero_size(0)
	check(is_equal_approx(gs.char_scale_mult("player"), 0.75) and is_equal_approx(gs.char_scale_mult("enemy"), 1.0), "personnages à 75 % sans toucher aux adversaires")
	gs.set_enemy_size(4)
	check(is_equal_approx(gs.char_scale_mult("enemy"), 1.25) and is_equal_approx(gs.char_scale_mult("player"), 0.75), "adversaires à 125 %, personnages toujours à 75 %")
	gs.set_hero_size(99)
	check(int(gs.hero_size) == 4, "index trop grand borné au dernier palier")
	gs.set_hero_size(-2)
	check(int(gs.hero_size) == 0, "index négatif borné au premier palier")
	gs.set_hero_size(0)
	gs.set_enemy_size(4)
	gs.load_settings()
	check(int(gs.hero_size) == 0 and int(gs.enemy_size) == 4, "réglages persistés (rechargés depuis user://settings.json)")
	# EntityView (uniquement sur le plateau du mode Tactique) applique l'échelle à la hauteur d'affichage
	var ev := EntityView.new()
	var hero: Dictionary = {"entity_type": "Player", "team": "player", "classe": "Tank"}
	ev.entity = hero
	var h_hero: float = ev._target_height()
	check(is_equal_approx(h_hero, EntityView.height_for(hero) * 0.75), "EntityView : personnage affiché à 75 %% (%.1f px)" % h_hero)
	gs.set_hero_size(4)
	h_hero = ev._target_height()
	check(is_equal_approx(h_hero, EntityView.height_for(hero) * 1.25), "EntityView : personnage affiché à 125 %% (%.1f px)" % h_hero)
	var boss: Dictionary = {"entity_type": "Enemy", "team": "enemy", "boss": true, "classe": "Tharok le Végétal"}
	ev.entity = boss
	var h_boss: float = ev._target_height()
	check(is_equal_approx(h_boss, EntityView.BOSS_HEIGHT * 1.25), "EntityView : boss (adversaire) à 125 %% (%.1f px)" % h_boss)
	var summon: Dictionary = {"entity_type": "Summon", "team": "player", "classe": "Golem"}
	ev.entity = summon
	var h_sum: float = ev._target_height()
	check(is_equal_approx(h_sum, EntityView.height_for(summon) * 1.25), "invocation alliée : suit le réglage « personnages »")
	# retour aux valeurs par défaut pour ne pas polluer les autres tests
	gs.set_hero_size(2)
	gs.set_enemy_size(2)
	check(is_equal_approx(gs.char_scale_mult("player"), 1.0) and is_equal_approx(gs.char_scale_mult("enemy"), 1.0), "restauré à 100 % en fin de test")
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
