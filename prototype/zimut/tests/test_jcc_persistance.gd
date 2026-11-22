extends SceneTree
## Mode Cartes : les déblocages survivent à l'écriture/relecture JSON (V451).
## Bug : le JSON relit [0, 1] en [0.0, 1.0] et Array.has(1) est FAUX sur des floats : les adversaires
## débloqués redevenaient bloqués au rechargement (et récompenses de saison/chapitre recréditées).

var fails: int = 0

func check(cond: bool, what: String) -> void:
	if cond:
		print("  ok : ", what)
	else:
		fails += 1
		print("  ÉCHEC : ", what)

func _roundtrip(d: Dictionary) -> Dictionary:
	return JSON.parse_string(JSON.stringify(d))

func _init() -> void:
	var JC: GDScript = load("res://scripts/JccCollection.gd")
	var save: Dictionary = {"gold": 0}
	JC.ensure(save)
	check(JC.unlock_next(save, 0) == 1, "victoire sur l'adversaire 0 : l'adversaire 1 se débloque")
	var again: Dictionary = _roundtrip(save)
	check(JC.is_unlocked(again, 1), "adversaire 1 toujours débloqué après relecture JSON")
	check(JC.unlock_next(again, 0) == -1, "pas de nouveau déblocage doublon après relecture")
	check((JC.ensure(again)["unlocked"] as Array).size() == 2, "liste sans doublon : %s" % str(JC.ensure(again)["unlocked"]))
	check(JC.unlock_next(again, 1) == 2, "la suite se débloque normalement")
	# saison : un palier réclamé ne se recrédite pas après relecture
	var s2: Dictionary = {"gold": 0}
	JC.ensure(s2)
	var rng := RandomNumberGenerator.new()
	for i in 3:
		JC.season_win(s2, "2026-11-22", rng)
	var gold_after: int = int(s2["gold"])
	var s3: Dictionary = _roundtrip(s2)
	JC.season_win(s3, "2026-11-22", rng)   # 4e victoire : aucun nouveau palier (8 victoires pour le suivant)
	check(int(s3["gold"]) == gold_after, "palier de saison non recrédité après relecture (%d → %d)" % [gold_after, int(s3["gold"])])
	print("FIN : %d échec(s)" % fails)
	quit(1 if fails > 0 else 0)
