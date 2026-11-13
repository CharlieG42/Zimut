extends SceneTree

## V159 : lien Aventure → Conquête — une Nation n'est conquérable que si sa zone est débloquée en Aventure.

var fails: int = 0

func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1

func _init() -> void:
	_boot.call_deferred()

func _boot() -> void:
	var pm: Node = root.get_node("ProgressionManager")
	var CS: GDScript = load("res://scripts/ConquestSystem.gd")
	var adv_start: Dictionary = {"zones_unlocked": ["foret_sylve"]}
	var adv_more: Dictionary = {"zones_unlocked": ["foret_sylve", "brasier_cendres"]}

	# ── Ouverture des Nations ──
	check(pm.conquest_nation_open(adv_start, "Forêt"), "la Sylve (départ) est toujours ouverte")
	check(not pm.conquest_nation_open(adv_start, "Brasier"), "le Brasier est fermé tant que sa zone n'est pas débloquée")
	check(pm.conquest_nation_open(adv_more, "Brasier"), "le Brasier s'ouvre avec sa zone d'Aventure")
	check(pm.conquest_nation_open({}, "Forêt") and not pm.conquest_nation_open({}, "Montagne"), "sans état d'Aventure : seule la Sylve est ouverte")
	check(pm.conquest_city_unlock_hint(adv_start, "fort_cendre") == "Terres de Cendre", "indice : zone à débloquer")
	check(pm.conquest_city_unlock_hint(adv_more, "fort_cendre") == "", "pas d'indice une fois ouverte")

	# ── Attaquabilité : voisine d'une ville possédée mais Nation fermée ──
	var conq: Dictionary = {"owned": ["capitale", "clairiere", "vieille_tour", "fort_racine"]}
	var open_ids: Array = []
	var closed_ids: Array = []
	for id: String in pm.CONQUEST_CITIES.keys():
		if pm.conquest_city_adjacent_to_empire(conq, id) and not conq["owned"].has(id) and id != "donjon_roi":
			if pm.conquest_city_open(adv_start, id):
				open_ids.append(id)
			else:
				closed_ids.append(id)
	check(not closed_ids.is_empty(), "il existe des villes voisines d'une Nation fermée (%s)" % ", ".join(PackedStringArray(closed_ids)))
	for id: String in closed_ids:
		check(not pm.conquest_city_attackable(conq, id, adv_start), "%s : non attaquable (Nation fermée)" % id)
		check(pm.conquest_city_attackable(conq, id, {"zones_unlocked": pm.ADVENTURE_ZONES.keys()}), "%s : attaquable une fois la Nation ouverte" % id)
		check(pm.conquest_city_attackable(conq, id), "%s : appel historique sans Aventure inchangé" % id)
	for id: String in open_ids:
		check(pm.conquest_city_attackable(conq, id, adv_start), "%s : attaquable (Sylve ouverte)" % id)

	# ── Ville déjà perdue : on peut toujours la reprendre ──
	if not closed_ids.is_empty():
		var lost_conq: Dictionary = conq.duplicate(true)
		lost_conq["lost"] = [closed_ids[0]]
		check(pm.conquest_city_attackable(lost_conq, closed_ids[0], adv_start), "une ville perdue reste reprenable")

	# ── Négociation refusée dans une Nation fermée ──
	var data: Dictionary = pm.new_game(4, "LienAventure")
	pm.rebuild_team(data, ["Tank", "Mage", "Heal"])
	data["campaign_mode"] = "conquest"
	data["adventure"] = adv_start.duplicate(true)
	data["gold"] = 99999
	var neutral_closed: String = ""
	for id: String in pm.CONQUEST_CITIES.keys():
		if pm.conquest_city_kind(id) == "neutral" and not pm.conquest_city_open(adv_start, id):
			neutral_closed = id
			break
	data["conquest"] = {"owned": ["capitale"]}
	check(pm.conquest_negotiate_city(data, neutral_closed).begins_with("Nation fermée"), "négocier dans une Nation fermée est refusé")

	# ── Fin de campagne et chapitres : seules les Nations ouvertes comptent ──
	var all_open_start: Array = []
	for id: String in pm.CONQUEST_CITIES.keys():
		if id != "donjon_roi" and pm.conquest_city_open(adv_start, id):
			all_open_start.append(id)
	var done_conq: Dictionary = {"owned": all_open_start}
	check(pm.conquest_empire_complete(done_conq, adv_start), "toutes les villes ouvertes conquises : empire complet pour le Donjon… ")
	check(not pm.conquest_empire_complete(done_conq), "… mais sans filtre Aventure, il manque encore des villes")
	check(not pm.conquest_city_attackable(done_conq, "donjon_roi", adv_start), "le Donjon exige aussi sa zone « Portes du Donjon »")
	var all_zones: Dictionary = {"zones_unlocked": pm.ADVENTURE_ZONES.keys()}
	var every: Array = ["capitale"]
	for id: String in pm.CONQUEST_CITIES.keys():
		if id != "donjon_roi":
			every.append(id)
	check(pm.conquest_city_attackable({"owned": every}, "donjon_roi", all_zones), "toutes zones ouvertes et villes conquises : Donjon attaquable")
	data["conquest"] = done_conq.duplicate(true)
	var ch_all: Dictionary = {}
	for ch: Dictionary in CS.CHAPTERS:
		if String(ch["type"]) == "all":
			ch_all = ch
	var pr: Dictionary = CS.chapter_progress(data, ch_all)
	check(bool(pr["done"]), "chapitre « Tout Zimut » atteint avec les Nations ouvertes (%d/%d)" % [pr["cur"], pr["max"]])
	data["adventure"] = all_zones
	check(not bool(CS.chapter_progress(data, ch_all)["done"]), "… et de nouveau en cours dès que d'autres Nations s'ouvrent")

	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
