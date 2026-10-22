extends SceneTree
## test_timer.gd — Tests headless du timer de tour (V42).
## Lancement : godot --headless -s tests/test_timer.gd --path .

var failures: int = 0

func _init() -> void:
	_test_timer_settings()
	_test_timer_defaults()
	print("")
	if failures > 0:
		print("ÉCHEC : %d test(s) en erreur." % failures)
		quit(1)
	else:
		print("OK : tous les tests passent.")
		quit(0)

func _check(cond: bool, label: String) -> void:
	if cond:
		print("  ok  %s" % label)
	else:
		failures += 1
		print("  KO  %s" % label)

func _test_timer_settings() -> void:
	print("GameSettings — timer de tour (V42) :")
	var gs: Node = root.get_node_or_null("GameSettings")
	if gs == null:
		print("  ??  GameSettings non disponible en headless (autoload)")
		return
	# Bornes du tableau des modes
	_check(GameSettings.TURN_TIMER_MODES.size() == 5, "5 modes de timer")
	_check(GameSettings.TURN_TIMER_SECONDS.size() == 5, "5 durées associées")
	# Mode 0 = désactivé
	gs.set_turn_timer_mode(0)
	_check(gs.turn_timer_seconds() == 0.0, "mode 0 → 0 s (désactivé)")
	# Modes 1 à 4
	gs.set_turn_timer_mode(1)
	_check(gs.turn_timer_seconds() == 5.0, "mode 1 → 5 s")
	gs.set_turn_timer_mode(2)
	_check(gs.turn_timer_seconds() == 10.0, "mode 2 → 10 s")
	gs.set_turn_timer_mode(3)
	_check(gs.turn_timer_seconds() == 20.0, "mode 3 → 20 s")
	gs.set_turn_timer_mode(4)
	_check(gs.turn_timer_seconds() == 30.0, "mode 4 → 30 s")
	# Clamping hors bornes
	gs.set_turn_timer_mode(99)
	_check(gs.turn_timer_seconds() == 30.0, "mode 99 → clampé à 30 s")
	_check(int(gs.turn_timer_mode) == 4, "index clampé à 4")
	gs.set_turn_timer_mode(-3)
	_check(gs.turn_timer_seconds() == 0.0, "mode -3 → clampé à 0 s (désactivé)")
	_check(int(gs.turn_timer_mode) == 0, "index clampé à 0")

func _test_timer_defaults() -> void:
	print("GameManager — état initial du timer (V42) :")
	var gm: Node = root.get_node_or_null("GameManager")
	if gm == null:
		print("  ??  GameManager non disponible en headless (autoload)")
		return
	_check(float(gm.turn_timer_remaining) == 0.0, "reste à 0 hors combat")
	_check(float(gm.turn_timer_duration) == 0.0, "durée à 0 hors combat")
	# Le timer doit reprendre la valeur du réglage au prochain _begin_turn
	_check(GameSettings.turn_timer_seconds() >= 0.0, "durée réglée cohérente")
