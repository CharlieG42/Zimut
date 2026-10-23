extends SceneTree
## test_timer.gd — Tests headless du timer de tour (V42).
## Lancement : godot --headless -s tests/test_timer.gd --path .
##
## NOTE : en mode `-s` (script), les class_name ne sont PAS enregistrés dans
## le ClassDB. Il faut charger explicitement les scripts avec load().

var failures: int = 0
var GameSettings = load("res://scripts/GameSettings.gd")

func _init() -> void:
	_boot.call_deferred()

func _boot() -> void:
	_test_timer_settings()
	_test_timer_defaults()
	_test_timer_countdown()
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
	# Créer une instance de GameSettings (extends Node)
	var gs: Node = GameSettings.new()
	_check(gs != null, "instance GameSettings créée")
	# Bornes du tableau des modes
	_check(GameSettings.TURN_TIMER_MODES.size() == 5, "5 modes de timer")
	_check(GameSettings.TURN_TIMER_SECONDS.size() == 5, "5 durées associées")
	# Mode 0 = désactivé
	gs.set_turn_timer_mode(0)
	_check(gs.turn_timer_seconds() == 0.0, "mode 0 → 0 s (désactivé)")
	# Modes 1 à 4 : 10 / 20 / 30 / 60 s
	gs.set_turn_timer_mode(1)
	_check(gs.turn_timer_seconds() == 10.0, "mode 1 → 10 s")
	gs.set_turn_timer_mode(2)
	_check(gs.turn_timer_seconds() == 20.0, "mode 2 → 20 s")
	gs.set_turn_timer_mode(3)
	_check(gs.turn_timer_seconds() == 30.0, "mode 3 → 30 s")
	gs.set_turn_timer_mode(4)
	_check(gs.turn_timer_seconds() == 60.0, "mode 4 → 60 s")
	# Clamping hors bornes
	gs.set_turn_timer_mode(99)
	_check(gs.turn_timer_seconds() == 60.0, "mode 99 → clampé à 60 s")
	_check(int(gs.turn_timer_mode) == 4, "index clampé à 4")
	gs.set_turn_timer_mode(-3)
	_check(gs.turn_timer_seconds() == 0.0, "mode -3 → clampé à 0 s (désactivé)")
	_check(int(gs.turn_timer_mode) == 0, "index clampé à 0")
	# Défaut = 30 s (mode 3) — choix de CharlieG42
	gs.set_turn_timer_mode(3)
	_check(gs.turn_timer_seconds() == 30.0, "défaut 30 s restauré")

func _test_timer_defaults() -> void:
	print("GameManager — état initial du timer (V42) :")
	var gm: Node = root.get_node("/root/GameManager")
	_check(gm != null, "autoload GameManager présent")
	# L'autoload peut déjà porter un combat de démonstration : on vérifie l'arrêt, pas l'état initial.
	gm._stop_turn_timer()
	_check(float(gm.turn_timer_remaining) == 0.0, "reste à 0 après arrêt")
	_check(float(gm.turn_timer_duration) == 0.0, "durée à 0 après arrêt")
	# Le timer doit reprendre la valeur du réglage au prochain _begin_turn
	var gs: Node = GameSettings.new()
	_check(gs.turn_timer_seconds() >= 0.0, "durée réglée cohérente")
	gs.free()


func _test_timer_countdown() -> void:
	print("GameManager — décompte du chrono (V43) :")
	var gm: Node = root.get_node("/root/GameManager")
	gm.game_over = false
	gm.active_entity = {"name": "Testeur", "team": "player", "uid": 1}
	gm.current_turn = 0
	gm.turn_timer_duration = 30.0
	gm.turn_timer_remaining = 30.0
	gm._turn_timer_epoch = gm._epoch
	_check(not gm.tick_turn_timer(10.0), "10 s écoulées : pas fini")
	_check(absf(float(gm.turn_timer_remaining) - 20.0) < 0.001, "il reste 20 s (la jauge bouge)")
	_check(not gm.tick_turn_timer(15.0), "15 s de plus (reste 5 s) : pas fini")
	_check(bool(gm._turn_timer_warned), "avertissement à 5 s déclenché")
	_check(gm.tick_turn_timer(10.0), "temps écoulé → true")
	_check(float(gm.turn_timer_remaining) == 0.0, "reste à 0, sans passer en négatif")
	# Tour de l'ordinateur : le chrono ne décompte pas
	gm.turn_timer_remaining = 30.0
	gm.current_turn = 1
	_check(not gm.tick_turn_timer(40.0), "tour ennemi : chrono ignoré")
	_check(float(gm.turn_timer_remaining) == 30.0, "tour ennemi : temps intact")
	# Arrêt du chrono
	gm._stop_turn_timer()
	_check(float(gm.turn_timer_duration) == 0.0 and float(gm.turn_timer_remaining) == 0.0, "arrêt : durée et reste à 0")
	gm.active_entity = {}
