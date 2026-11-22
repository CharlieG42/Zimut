extends SceneTree
## Mode Cartes : rochers infranchissables (2 cases en lignes centrales, ni passage ni dépôt).
var fails: int = 0
func check(ok: bool, label: String) -> void:
	if ok:
		print("  ok  ", label)
	else:
		fails += 1
		print("  ÉCHEC  ", label)

func _initialize() -> void:
	var deck: Array = ["m_gobelin", "m_loup", "m_troll", "m_gobelin", "m_loup", "m_troll", "m_gobelin", "m_loup", "m_troll", "m_gobelin"]
	for seed_v in range(1, 41):
		var d := JccDuel.new()
		d.setup(deck, deck, seed_v)
		var rocks: Array = []
		for i in JccDuel.LANES:
			if d.terrain_at(i) == JccDuel.ROCK:
				rocks.append(i)
		check(rocks.size() == JccDuel.ROCK_COUNT, "seed %d : %d rochers" % [seed_v, rocks.size()])
		for r: Variant in rocks:
			var cy: int = d.cell_xy(int(r)).y
			if d.deploy_rows(0).has(cy) or d.deploy_rows(1).has(cy):
				check(false, "seed %d : rocher en zone de déploiement" % seed_v)
			check(not d.is_free_xy(d.cell_xy(int(r)).x, cy), "rocher non libre")
	# chemin : un rocher n'est jamais atteignable ni traversé
	var d2 := JccDuel.new()
	d2.setup(["m_gobelin"], ["m_loup"], 3)
	d2.terrain = ["", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""]
	var c0: int = d2.xy_cell(1, 3)
	d2.terrain[c0] = JccDuel.ROCK
	check(d2._path_cost(d2.xy_cell(0, 3), c0) == -1, "case rocher inaccessible")
	check(d2._path_cost(d2.xy_cell(0, 3), d2.xy_cell(2, 3)) == 4, "contournement du rocher (4 PM)")
	print("OBSTACLES fails=", fails)
	quit(1 if fails > 0 else 0)
