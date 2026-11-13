extends SceneTree
## Le Tank doit pouvoir frapper à distance dès les bas niveaux (V358) : sans sort de portée > 1 il fallait se coller à
## l'ennemi pour la moindre attaque, trop contraignant en début de partie.
var fails: int = 0
func check(c: bool, m: String) -> void:
	if not c:
		print("  ÉCHEC  " + m)
		fails += 1
	else:
		print("  ok  " + m)
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var gm: Node = root.get_node("GameManager")
	await process_frame
	# Attaque à distance (portée > 1) disponible : par niveau, la meilleure portée d'une attaque offensive
	var best: Dictionary = {}
	for lvl: int in [1, 2, 4, 7, 10]:
		var r: int = 0
		for s: Dictionary in gm._build_spells("Tank", lvl):
			if String(s["spell_type"]) == "Attaque" and int(s["Degats_physiques"]) > 0:
				r = maxi(r, int(s["range"]))
		best[lvl] = r
	check(int(best[2]) >= 3, "niveau 2 : une attaque à portée 3 (%d)" % int(best[2]))
	check(int(best[7]) >= 4, "niveau 7 : une attaque à portée 4 (%d)" % int(best[7]))
	check(int(best[1]) >= 1, "niveau 1 : au moins une attaque (portée %d)" % int(best[1]))
	var by_name: Dictionary = {}
	for s: Dictionary in gm._build_spells("Tank", 100):
		by_name[String(s["name"])] = s
	check(by_name.has("Lancer de bouclier") and int(by_name["Lancer de bouclier"]["level_required"]) == 2, "« Lancer de bouclier » au niveau 2")
	check(by_name.has("Javelot lourd") and int(by_name["Javelot lourd"]["level_required"]) == 7, "« Javelot lourd » au niveau 7")
	check(int(by_name["Provocation"]["range"]) == 3, "« Provocation » à portée 3")
	# Les attaques rapprochées d'origine ne changent pas
	check(int(by_name["Coup de bouclier"]["range"]) == 1 and int(by_name["Frappe puissante"]["range"]) == 1, "attaques rapprochées inchangées")
	print("FIN : ", fails, " échec(s)")
	quit(1 if fails > 0 else 0)
