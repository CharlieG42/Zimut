extends SceneTree
## Test V92 : nouvelle échelle de difficulté des combats.
##   Facile = ancien Normal · Normal = ancien Difficile · Difficile = ancien Enfer · Enfer = 1,5 × l'ancien Enfer.
## Les sauvegardes d'avant sont décalées d'un cran (même difficulté réellement jouée).
## Lancement : godot --headless --path prototype/zimut -s tests/test_difficulte.gd

var fails: int = 0

func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1

func _init() -> void:
	_boot.call_deferred()

func _threat(gs: Node, idx: int) -> float:
	var s: Dictionary = {"difficulty": idx}
	return gs.enemy_hp_mult(s) * gs.enemy_attack_mult(s)

func _boot() -> void:
	var gs: Node = root.get_node("GameSettings")
	var pm: Node = root.get_node("ProgressionManager")
	var old_normal: Dictionary = {"hp": 1.0, "atk": 1.0}
	var old_hard: Dictionary = {"hp": 1.2, "atk": 1.2}
	var old_hell: Dictionary = {"hp": 1.65, "atk": 1.2}
	check(gs.DIFFICULTIES == ["Facile", "Normal", "Difficile", "Enfer"], "quatre niveaux, mêmes noms")
	check(absf(gs.enemy_hp_mult({"difficulty": 0}) - old_normal["hp"]) < 0.001 and absf(gs.enemy_attack_mult({"difficulty": 0}) - old_normal["atk"]) < 0.001,
		"Facile = ancien Normal")
	check(absf(gs.enemy_hp_mult({"difficulty": 1}) - old_hard["hp"]) < 0.001 and absf(gs.enemy_attack_mult({"difficulty": 1}) - old_hard["atk"]) < 0.001,
		"Normal = ancien Difficile")
	# V152 : Difficile = PV de l'ancien Enfer, attaque relevée (1,32) ; Enfer ≈ 1,68 × l'ancien Enfer
	check(absf(gs.enemy_hp_mult({"difficulty": 2}) - old_hell["hp"]) < 0.001 and absf(gs.enemy_attack_mult({"difficulty": 2}) - 1.32) < 0.001,
		"Difficile = PV de l'ancien Enfer, attaque 1,32 (V152)")
	var old_hell_threat: float = float(old_hell["hp"]) * float(old_hell["atk"])
	var ratio: float = _threat(gs, 3) / old_hell_threat
	check(absf(ratio - 1.68) < 0.02, "Enfer ≈ 1,68 × l'ancien Enfer (menace PV × attaque : x%.3f)" % ratio)
	check(_threat(gs, 0) < _threat(gs, 1) and _threat(gs, 1) < _threat(gs, 2) and _threat(gs, 2) < _threat(gs, 3), "menace strictement croissante")
	# Sauvegardes : décalage d'un cran, une seule fois
	for pair: Array in [[0, 0], [1, 0], [2, 1], [3, 2]]:
		var save: Dictionary = pm.new_game(4, "D")
		save["difficulty"] = int(pair[0])
		save.erase("diff_v")
		pm.ensure_roster(save)
		check(int(save["difficulty"]) == int(pair[1]) and int(save["diff_v"]) == 2, "ancienne sauvegarde : difficulté %d -> %d" % [pair[0], pair[1]])
		pm.ensure_roster(save)
		check(int(save["difficulty"]) == int(pair[1]), "pas de second décalage à la réouverture (%d)" % pair[1])
	var fresh: Dictionary = pm.new_game(4, "N")
	var d0: int = int(fresh["difficulty"])
	pm.ensure_roster(fresh)
	check(int(fresh["difficulty"]) == d0 and int(fresh["diff_v"]) == 2, "nouvelle partie : difficulté inchangée à l'ouverture")
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
