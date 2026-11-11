extends SceneTree
## V152 : IA tactique — se placer puis frapper, concentrer les attaques, se replier après avoir frappé,
## ancienne IA conservée pour les ennemis en Facile.
var fails: int = 0
func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1
func _init() -> void:
	_boot.call_deferred()


func _free_cell_at(gm: Node, from: Vector2i, d: int) -> Vector2i:
	for y: int in range(gm.GRID_SIZE):
		for x: int in range(gm.GRID_SIZE):
			var c := Vector2i(x, y)
			if gm.is_free(c) and Combat.manhattan(from, c) == d:
				return c
	return Vector2i(-1, -1)


func _boot() -> void:
	var gm: Node = root.get_node("GameManager")
	await process_frame
	gm.active_save = {"difficulty": 2}
	gm.set_custom_team([{"classe": "Tank"}, {"classe": "Mage"}, {"classe": "Heal"}])
	gm.init_grid()
	gm.init_entities()
	gm.obstacles.clear()
	var tm: Node = (load("res://scripts/TurnManager.gd") as GDScript).new()
	tm.game_manager = gm
	tm.legacy_teams = []

	# Pose les entités : un ennemi acteur, les héros loin sauf une cible
	var foe: Dictionary = gm.enemies[0]
	for x: Dictionary in gm.enemies.slice(1):
		gm.remove_entity_from_grid(x)
	var heroes: Array = gm.players.filter(func(p: Dictionary) -> bool: return String(p.get("team", "")) == "player")
	var corners: Array[Vector2i] = [Vector2i(0, 0), Vector2i(9, 0), Vector2i(0, 9)]
	for i: int in range(heroes.size()):
		gm._teleport_entity(heroes[i], corners[i])
	gm._teleport_entity(foe, Vector2i(9, 9))
	foe["current_pa"] = int(foe["max_pa"])
	foe["current_pm"] = int(foe["max_pm"])
	foe["casts"] = {}

	check(tm._smart(foe), "Difficile : l'ennemi utilise l'IA tactique")
	gm.active_save = {"difficulty": 0}
	check(not tm._smart(foe), "Facile : l'ennemi garde l'ancienne IA")
	check(tm._smart(heroes[0]), "héros (mode Auto) : IA tactique")
	gm.active_save = {"difficulty": 2}

	# 1. Se placer puis frapper : cible juste hors de portée, mais atteignable en marchant
	var rng: int = tm._attack_range(foe)
	var target: Dictionary = heroes[1]
	var spot: Vector2i = _free_cell_at(gm, gm.pos_of(foe), rng + mini(2, int(foe["max_pm"])))
	gm._teleport_entity(target, spot)
	var act: Dictionary = tm.plan(foe)
	check(tm._best_cast_here(foe).is_empty(), "aucune attaque depuis la case de départ (portée %d)" % rng)
	check(not act.is_empty() and String(act["type"]) == "move", "l'ennemi se déplace d'abord")
	if not act.is_empty() and String(act["type"]) == "move":
		gm.try_move(foe, act["cell"])
		var act2: Dictionary = tm.plan(foe, false)
		check(not act2.is_empty() and String(act2["type"]) == "cast", "… puis frappe dans le même tour")

	# 2. Concentration : un héros blessé et un héros en forme à portée → le blessé
	var a: Dictionary = heroes[0]
	var b: Dictionary = heroes[2]
	var fpos: Vector2i = gm.pos_of(foe)
	var near: Array[Vector2i] = []
	for d: Vector2i in Combat.DIRS:
		var c: Vector2i = fpos + d
		if gm.is_free(c):
			near.append(c)
	if near.size() >= 2:
		gm._teleport_entity(target, Vector2i(0, 5))
		gm._teleport_entity(a, near[0])
		gm._teleport_entity(b, near[1])
		a["current_pv"] = int(a["max_pv"])
		b["current_pv"] = maxi(1, int(float(b["max_pv"]) * 0.3))
		foe["current_pa"] = int(foe["max_pa"])
		foe["casts"] = {}
		var hit: Dictionary = tm._best_cast_here(foe)
		var victim: Dictionary = {} if hit.is_empty() else gm.entity_at(hit["act"]["cell"])
		check(not victim.is_empty() and int(victim["uid"]) == int(b["uid"]), "il vise le héros blessé (%s)" % String(victim.get("classe", "?")))
		tm._focus["enemy"] = int(a["uid"])
		b["current_pv"] = int(b["max_pv"])
		var hit2: Dictionary = tm._best_cast_here(foe)
		var victim2: Dictionary = {} if hit2.is_empty() else gm.entity_at(hit2["act"]["cell"])
		check(not victim2.is_empty() and int(victim2["uid"]) == int(a["uid"]), "à PV égaux, il suit la cible de son équipe")

	# 3. Frapper puis reculer : un ennemi prudent au contact, sans PA, se met à l'abri
	foe["uid"] = 3001   # 3001 % 3 == 1 → prudent
	check(tm._trait(foe) == "cautious" and tm._fragile(foe), "ennemi prudent = fragile")
	foe["current_pa"] = 0
	foe["current_pm"] = int(foe["max_pm"])
	var info: Array = tm._foe_info(foe)
	var before: float = tm._threat_at(gm.pos_of(foe), info)
	var back: Dictionary = tm.plan(foe, true)
	check(not back.is_empty() and String(back["type"]) == "move", "après avoir frappé, il se replie")
	if not back.is_empty():
		check(tm._threat_at(back["cell"], info) < before, "la case de repli est moins exposée (%.1f → %.1f)" % [before, tm._threat_at(back["cell"], info)])

	# 4. Coût : la planification reste légère (téléphone)
	foe["current_pa"] = int(foe["max_pa"])
	foe["current_pm"] = int(foe["max_pm"])
	foe["casts"] = {}
	gm._teleport_entity(foe, Vector2i(5, 5))
	var t0: int = Time.get_ticks_usec()
	for _i: int in range(20):
		tm.plan(foe)
	var ms: float = float(Time.get_ticks_usec() - t0) / 20000.0
	check(ms < 40.0, "planification rapide (%.1f ms / action)" % ms)

	print("ÉCHECS : ", fails)
	quit(0 if fails == 0 else 1)
