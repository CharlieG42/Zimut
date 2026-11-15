extends SceneTree
## V360 : le sol des cases et le fond de ciel sont cuits en UNE texture (CanvasBake) au lieu d'être re-soumis à chaque image.
## (Cell n'est pas typé ici : son script dépend de l'autoload Loc, absent au chargement du test.)
## Vérifie la logique (pas les pixels) : bascule des cases, annulation d'un cuisson remplacée, re-cuisson quand un gouffre apparaît.
## Mesure des appels de dessin / comparaison de pixels : xvfb-run … --rendering-method gl_compatibility (voir PerfCounter).
var fails: int = 0
func check(c: bool, m: String) -> void:
	if not c:
		print("  ÉCHEC  " + m)
		fails += 1
	else:
		print("  ok  " + m)
func _init() -> void:
	_boot.call_deferred()

class Counter extends RefCounted:
	var n: int = 0
	func paint(_ci: CanvasItem) -> void:
		n += 1

func _boot() -> void:
	# 1) CanvasBake seul
	var holder := Node2D.new()
	root.add_child(holder)
	var bake := CanvasBake.new()
	holder.add_child(bake)
	var cnt := Counter.new()
	check(not bake.is_ready(), "avant cuisson : texture non affichée")
	var first_ok: Array = [null]
	var run_first := func() -> void:
		first_ok[0] = await bake.bake(Rect2(0, 0, 64, 64), 1.0, cnt.paint)
	run_first.call()
	await process_frame
	var second_ok: bool = await bake.bake(Rect2(0, 0, 128, 64), 2.0, cnt.paint)
	await process_frame
	check(first_ok[0] == false, "une cuisson remplacée par une autre rend false")
	check(second_ok and bake.is_ready(), "la dernière cuisson rend true et affiche la texture")
	check(is_equal_approx(bake.pixel_scale, 2.0) and bake.zone == Rect2(0, 0, 128, 64), "zone et échelle mémorisées")
	bake.release()
	check(not bake.is_ready(), "release() cache la texture")
	holder.queue_free()

	# 2) plateau de combat complet
	var gm: Node = root.get_node("GameManager")
	var pm: Node = root.get_node("ProgressionManager")
	root.get_node("GameSettings").tutorial_done = true
	var data: Dictionary = pm.new_game(4, "Bake")
	pm.rebuild_team(data, ["Tank", "Mage", "Heal"])
	gm.active_save = data
	gm.active_slot = 4
	gm.set_custom_team([{"classe": "Tank"}, {"classe": "Mage"}, {"classe": "Heal"}])
	var main: Node = (load("res://scenes/Main.tscn") as PackedScene).instantiate()
	root.add_child(main)
	for i: int in 12:
		await process_frame
	var grid: Node = main.get_node("GridManager")
	var cells: Array = []
	for row in grid.cell_nodes:
		cells.append_array(row)
	var baked: int = 0
	for c in cells:
		if c.baked:
			baked += 1
	check(cells.size() > 0 and baked == cells.size(), "toutes les cases sont cuites (%d / %d)" % [baked, cells.size()])
	var layer: Node = grid.get_node("Cells")
	check(layer.get_child(0) is CanvasBake, "la texture du plateau est derrière toutes les cases")
	check((layer.get_child(0) as CanvasBake).is_ready(), "texture du plateau prête")
	var bd: Node = main.get_node("Backdrop")
	if bd.SKY.has(gm.fight_biome):
		check(bd._bake != null and bd._bake.is_ready() and not bd._static.visible, "fond de ciel cuit, dessin direct coupé (%s)" % gm.fight_biome)
	else:
		check(bd._bake != null and not bd._bake.is_ready(), "biome sans plan fixe : rien de cuit (%s)" % gm.fight_biome)

	var pit_total: int = grid._pits().size()
	var pit_baked: int = grid._pits().filter(func(pt): return pt.baked).size()
	check(pit_baked == pit_total, "tous les gouffres / replats sont cuits (%d / %d)" % [pit_baked, pit_total])

	# 3) un gouffre apparaît : les cases voisines changent de paroi → re-cuisson
	# Le plateau est tiré au hasard : on choisit une case libre dont la voisine du haut n'a pas déjà sa paroi
	# (sinon rien ne change et il n'y a pas de re-cuisson → test instable).
	var target := Vector2i(4, 4)
	for ty: int in range(2, gm.GRID_SIZE - 1):
		for tx: int in range(2, gm.GRID_SIZE - 1):
			var tc := Vector2i(tx, ty)
			if gm.obstacles.has(tc) or gm.obstacles.has(tc + Vector2i(0, -1)) or gm.obstacles.has(tc + Vector2i(0, 1)):
				continue
			if grid.cell_nodes[ty - 1][tx].pit_left:
				continue
			target = tc
			break
		if not gm.obstacles.has(target) and not grid.cell_nodes[target.y - 1][target.x].pit_left and target != Vector2i(4, 4):
			break
	gm.obstacles[target] = "void"
	grid._sync_props()   # direct : update_entity_display() attend la fin des animations en cours
	var mid_baked: int = 0
	for c in cells:
		if c.baked:
			mid_baked += 1
	var pits_mid: int = grid._pits().filter(func(pt): return pt.baked).size()
	check(mid_baked == 0 and pits_mid == 0, "dès le changement, les cases se redessinent elles-mêmes en attendant la re-cuisson (%d cases, %d gouffres cuits)" % [mid_baked, pits_mid])
	for i: int in 8:
		await process_frame
	var after: int = 0
	for c in cells:
		if c.baked:
			after += 1
	check(after == cells.size(), "re-cuisson terminée : toutes les cases cuites (%d / %d)" % [after, cells.size()])
	var pit_cell = grid.cell_nodes[target.y][target.x]
	var pits_after: Array = grid._pits()
	check(pits_after.size() > 0 and pits_after.all(func(pt): return pt.baked), "gouffres re-cuits après le changement (%d)" % pits_after.size())
	check(not pit_cell.visible, "la case de gouffre n'est plus dessinée")
	var nb = grid.cell_nodes[target.y - 1][target.x]
	check(nb.pit_left, "la case voisine montre sa paroi (pit_left)")
	pm.delete_save(4)
	print("FIN : ", fails, " échec(s)")
	quit(1 if fails > 0 else 0)
