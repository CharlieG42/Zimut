extends SceneTree
## V162 : le chrono de tour ne relance plus le rafraîchissement complet (portée, cases, cartes, frise) à chaque image.
## Lancement : godot --headless --path . -s tests/test_chrono_sans_rafraichissement.gd
var fails: int = 0
var n_state: int = 0
var n_tick: int = 0
func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var gm: Node = root.get_node("GameManager")
	gm.set_custom_team([{"classe": "Sylvain"}, {"classe": "Mage"}, {"classe": "Tank"}])
	gm.auto_mode = false
	var main: Node = (load("res://scenes/Main.tscn") as PackedScene).instantiate()
	root.add_child(main)
	# les ennemis jouent d'abord : on attend le tour d'un héros (chrono lancé)
	var waited: float = 0.0
	while gm.turn_timer_duration <= 0.0 and waited < 90.0:
		await create_timer(0.5).timeout
		waited += 0.5
	check(gm.turn_timer_duration > 0.0 and not gm.active_entity.is_empty(), "chrono actif pendant le tour")
	await create_timer(1.0).timeout      # laisse finir l'ouverture du tour
	var rem0: float = gm.turn_timer_remaining
	gm.state_changed.connect(func() -> void: n_state += 1)
	gm.turn_timer_ticked.connect(func() -> void: n_tick += 1)
	for i in 90:
		await process_frame
	check(n_tick >= 60, "le chrono prévient son affichage à chaque image (%d)" % n_tick)
	check(n_state <= 3, "plus de rafraîchissement complet à chaque image (%d state_changed en 90 images)" % n_state)
	check(gm.turn_timer_remaining < rem0, "le chrono continue de décompter")
	var ui: Node = main.find_child("UIManager", true, false)
	check(ui != null and gm.turn_timer_ticked.get_connections().size() > 0, "l'interface est abonnée au signal du chrono")
	print("FIN : ", fails, " échec(s)")
	quit(1 if fails > 0 else 0)
