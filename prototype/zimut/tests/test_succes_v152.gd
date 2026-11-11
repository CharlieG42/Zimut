extends SceneTree
## V152 : nouveaux succès — difficulté, donjons, Conquête, bestiaire, longévité.
var fails: int = 0
func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var pm: Node = root.get_node("ProgressionManager")
	await process_frame
	check(Achievements.LIST.size() >= 42, "au moins 42 succès (%d)" % Achievements.LIST.size())
	var ids: Dictionary = {}
	for a: Array in Achievements.LIST:
		ids[a[0]] = true
	check(ids.size() == Achievements.LIST.size(), "identifiants uniques")

	var data: Dictionary = pm.new_game(4, "Succès")
	pm.ensure_roster(data)
	data["difficulty"] = 2
	# 10 victoires en Difficile, dont une sans K.O.
	for i: int in range(10):
		pm.register_victory(data, {"turns": 8, "deaths": 0 if i == 0 else 1, "enemies": []})
	check(Achievements.stat(data, "wins_hard") == 10, "victoires en Difficile comptées")
	check(Achievements.is_unlocked(data, "trempe_acier"), "« Trempé dans l'acier » débloqué")
	check(Achievements.is_unlocked(data, "sang_froid"), "« Sang-froid » débloqué")
	check(not Achievements.is_unlocked(data, "revenu_enfers"), "« Revenu des Enfers » pas encore (Difficile ≠ Enfer)")

	# Statistiques dérivées
	data["adventure"] = {"dungeons": {"Forêt": {"clears": 1}, "Forêt#2": {"clears": 2}, "Cimes": {"clears": 0},
		"Brasier": {"clears": 1}, "Brumes": {"clears": 1}, "Sylve": {"clears": 3}}}
	check(Achievements.stat(data, "dungeons") == 5, "donjons différents terminés : 5")
	data["bestiary"] = {"Loup": {"killed": 300}, "Ours": {"killed": 250}}
	check(Achievements.stat(data, "kills") == 550, "ennemis vaincus : 550")
	data["gold"] = 6000
	data["conquest"] = {"owned": [], "chapter": 3, "defended_in_person": 3}
	check(Achievements.stat(data, "chapters") == 3, "chapitres de Conquête : 3")
	check(Achievements.stat(data, "defended") == 3, "défenses en personne : 3")
	var news: Array = Achievements.check(data)
	var got: Array = news.map(func(n: Dictionary) -> String: return String(n["id"]))
	for id: String in ["explorateur", "exterminateur", "fortune", "chroniqueur", "rempart_vivant"]:
		check(got.has(id), "« %s » débloqué" % id)
	check(not got.has("banniere_levee"), "aucune nation unie : pas de « Bannière levée »")
	print("ÉCHECS : ", fails)
	pm.delete_save(4)
	quit(0 if fails == 0 else 1)
