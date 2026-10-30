extends SceneTree

## Non-régression : les scripts de rendu doivent compiler et les obstacles
## (arbres/rochers) doivent être affichés sur la grille (cf. bug Forêt : Prop.gd
## ne compilait plus -> aucun arbre/rocher ne s'affichait).

var pm: Node

func _init() -> void:
	pm = load("res://scripts/ProgressionManager.gd").new()
	pm.name = "ProgressionManagerTest"
	root.add_child.call_deferred(pm)
	_boot.call_deferred()

func _boot() -> void:
	var fails: int = 0
	# 1. Les scripts de rendu compilent (un script en échec de parse fait
	#    disparaître tous les éléments du type concerné).
	for script_path: String in ["res://scripts/Prop.gd", "res://scripts/Cell.gd",
			"res://scripts/EntityView.gd", "res://scripts/Portraits.gd"]:
		var script: GDScript = load(script_path)
		var instance = script.new()
		if instance == null:
			print("  ÉCHEC  %s ne s'instancie pas (parse error ?)" % script_path)
			fails += 1
			continue
		if instance is Node:
			instance.free()
		print("  ok  %s compile et s'instancie" % script_path)

	# 2. La scène de combat : les obstacles existent et _sync_props crée
	#    exactement un prop vivant par obstacle, à chaque combat.
	var data: Dictionary = pm.new_game(0, "T-props")
	data["team"] = [{"classe": "Tank", "equipment": {}}, {"classe": "Mage", "equipment": {}}, {"classe": "Heal", "equipment": {}}]
	var sc = (load("res://scenes/Main.tscn") as PackedScene).instantiate()
	root.add_child(sc)
	await process_frame
	var gm: Node = root.get_node("GameManager")
	var grid: Node = root.get_node("Main/GridManager")
	gm.active_slot = 0
	gm.active_save = data
	for fight: int in range(3):
		gm.reset_game()
		await _settle(grid)
		# Vérification déterministe : _sync_now doit afficher exactement
		# un prop vivant par obstacle du combat courant.
		grid._sync_now()
		var obstacles: int = 0
		for oc: Vector2i in gm.obstacles.keys():
			if String(gm.obstacles[oc]) != "void":
				obstacles += 1
		# V73 : plus d'arbres / rochers bloquants générés sur le plateau
		if obstacles != 0:
			print("  ÉCHEC  combat %d : %d obstacle(s) décoratif(s) généré(s)" % [fight + 1, obstacles])
			fails += 1
		# … mais l'affichage suit toujours la liste d'obstacles (ex. décor posé par un script)
		var placed: int = 0
		for yy: int in range(gm.GRID_SIZE):
			for xx: int in range(gm.GRID_SIZE):
				var cc := Vector2i(xx, yy)
				if placed < 2 and gm.is_free(cc):
					gm.obstacles[cc] = "tree" if placed == 0 else "rock"
					placed += 1
		obstacles = placed
		grid._sync_now()
		# les props de la génération précédente (queue_free) disparaissent à la fin de frame
		await process_frame
		await process_frame
		var props: int = _live_props(grid)
		if props == obstacles and obstacles > 0:
			print("  ok  combat %d : %d obstacle(s) affiché(s)" % [fight + 1, obstacles])
		else:
			print("  ÉCHEC  combat %d : obstacles=%d mais props=%d" % [fight + 1, obstacles, props])
			fails += 1

	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
func _live_props(grid: Node) -> int:
	var layer: Node = grid._entity_layer
	var n: int = 0
	for c in layer.get_children():
		if c is Prop:
			n += 1
	return n

func _settle(grid: Node) -> void:
	# Attend que la file d'animations soit vide ET que les queue_free aient tourné.
	for i: int in range(30):
		await process_frame
		if not grid.is_busy():
			await process_frame
			await process_frame
			return
