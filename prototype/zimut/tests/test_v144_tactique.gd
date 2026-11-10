extends SceneTree
## V144 : fonds de scène par nation et variantes de cases du mode Tactique.
## Lancement : godot --headless --path . -s tests/test_v144_tactique.gd
var fails: int = 0
func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var BS: GDScript = load("res://scripts/BattleScenery.gd")
	var BF: GDScript = load("res://scripts/BackdropFx.gd")
	# variantes : stables, dans 0..5, cases calmes majoritaires, case « accident » rare
	var counts: Array[int] = [0, 0, 0, 0, 0, 0]
	var stable := true
	for x: int in range(40):
		for y: int in range(40):
			var v: int = BS.tile_variant(x, y)
			if v < 0 or v > 5 or v != BS.tile_variant(x, y):
				stable = false
			else:
				counts[v] += 1
	check(stable, "variante de case : toujours entre 0 et 5, stable")
	var calm: int = counts[0] + counts[1] + counts[2]
	check(calm > 800 and calm < 1150, "cases calmes majoritaires (%d sur 1600)" % calm)
	check(counts[5] > 90 and counts[5] < 280, "case « accident » rare (%d sur 1600)" % counts[5])
	# plus de diagonales : deux cases voisines en diagonale n'ont pas systématiquement la même suite
	var same_diag: int = 0
	for x2: int in range(30):
		for y2: int in range(30):
			if BS.tile_variant(x2, y2) == BS.tile_variant(x2 + 5, y2 - 3):       # période de l'ancien x*3 + y*5
				same_diag += 1
	check(same_diag < 400, "plus de répétition en diagonales (%d coïncidences sur 900)" % same_diag)
	# les 6 tuiles des nations retouchées existent
	for prefix: String in ["brasier_ground", "brumes_ground", "mountain_ground", "forest_ground"]:
		var ok := true
		for i: int in range(1, 7):
			if not ResourceLoader.exists("res://assets/sprites/tiles/%s_%02d.svg" % [prefix, i]):
				ok = false
		check(ok, "%s : 6 tuiles présentes" % prefix)
	# fond de scène : les 4 nations ont le leur, les autres gardent le fond d'origine sans erreur
	for b: String in ["Forêt", "Brasier", "Brumes", "Montagne"]:
		check((BF.SKY as Dictionary).has(b), "%s : fond de scène propre" % b)
	var fx: Node2D = BF.new()
	root.add_child(fx)
	for b2: String in ["Forêt", "Brasier", "Brumes", "Montagne", "Désert", "Ombres", "Donjon"]:
		fx.set_biome(b2)
		await process_frame
	check(fx.is_in_group("backdrop"), "le fond écoute le groupe « backdrop » (biome redonné au lancement du combat)")
	fx.queue_free()
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
