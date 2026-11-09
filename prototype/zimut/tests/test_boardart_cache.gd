extends SceneTree
## V123 — BoardArt.iso_pos / cell_center ne doivent plus parcourir toute la carte à chaque appel
## (c'était la cause des saccades de ~100 ms en marchant sur la carte Diorama).
## Lancement : godot --headless --path . -s tests/test_boardart_cache.gd
var fails: int = 0
func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1

func _init() -> void:
	_boot.call_deferred()

func _boot() -> void:
	var gs: Node = root.get_node("/root/GameSettings")
	var BA: GDScript = load("res://scripts/BoardArt.gd")
	var before: String = gs.sylvestre_board
	gs.set_sylvestre_board("diorama")
	var z := "foret_sylve"
	check(BA.file_stem(z) == "foret_sylve_diorama", "planche Diorama choisie")
	var mx := 0
	for v: Variant in BA.heights(z).values():
		mx = maxi(mx, int(v))
	check(BA.iso_max_height(z) == mx and BA.iso_max_height(z) == mx, "hauteur maximale juste (%d), mémorisée" % mx)
	var p0: Vector2 = BA.iso_pos(z, Vector2i(10, 20))
	var t0: int = Time.get_ticks_usec()
	var acc := Vector2.ZERO
	for i in range(3000):
		acc += BA.iso_pos(z, Vector2i(i % 144, (i * 7) % 144))
	var ms: float = (Time.get_ticks_usec() - t0) / 1000.0
	check(ms < 400.0, "3000 iso_pos en %.0f ms (< 400)" % ms)
	check(BA.iso_pos(z, Vector2i(10, 20)) == p0, "iso_pos stable")
	gs.set_sylvestre_board("classic")
	check(BA.file_stem(z) == "foret_sylve", "le changement de réglage change bien de planche")
	gs.set_sylvestre_board(before)
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
