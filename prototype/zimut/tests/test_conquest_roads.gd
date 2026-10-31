extends SceneTree

## Tests Conquête : adjacence des routes, verrouillage du Donjon du Roi
## Squelette, fin de campagne et écran d'annexion (just_annexed).

var fails: int = 0

func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1

func _init() -> void:
	_boot.call_deferred()

func _boot() -> void:
	var pm: Node = root.get_node("ProgressionManager")
	var base: Dictionary = {"owned": ["capitale"], "pending_city": ""}

	# ── Adjacence : seules les villes reliées au territoire sont attaquables ──
	check(pm.conquest_city_attackable(base, "clairiere"), "Clairière d'Aube attaquable (reliée à la capitale)")
	check(pm.conquest_city_attackable(base, "pont_mousse"), "Pont-Mousse attaquable (relié à la capitale)")
	check(not pm.conquest_city_attackable(base, "vieille_tour"), "Vieille Tour hors de portée (pas de route depuis le territoire)")
	check(not pm.conquest_city_attackable(base, "garnison"), "Garnison des Pics hors de portée")
	check(not pm.conquest_city_attackable(base, "donjon_roi"), "Donjon verrouillé (empire incomplet)")
	check(not pm.conquest_city_attackable(base, "capitale"), "La capitale ne s'attaque jamais")
	check(not pm.conquest_city_attackable(base, "ville_inconnue"), "Ville inconnue non attaquable")

	# ── Extension du territoire : les routes s'ouvrent progressivement ──
	var after_clairiere: Dictionary = {"owned": ["capitale", "clairiere"], "pending_city": ""}
	check(pm.conquest_city_attackable(after_clairiere, "vieille_tour"), "Vieille Tour attaquable après Clairière")
	check(pm.conquest_city_attackable(after_clairiere, "fort_racine"), "Fort Racine attaquable après Clairière")
	check(not pm.conquest_city_attackable(after_clairiere, "hameau_pin"), "Hameau du Pin hors de portée")
	check(not pm.conquest_empire_complete(after_clairiere), "Empire incomplet")

	# ── Fin de campagne : toutes les villes, puis le Donjon ──
	var full: Dictionary = {"owned": ["capitale", "clairiere", "vieille_tour", "pont_mousse",
		"fort_racine", "hameau_pin", "garnison", "oasis", "tour_sable",
		"village_brume", "ruines_lierre", "abbaye_ronce", "citadelle_ronce",
		"col_givre", "mine_cristal", "bastion_orage", "caravanserail",
		"observatoire", "port_sable", "bois_lune", "sanctuaire_mousse",
		"forge_givre", "pic_foudroyant", "marais_spectres", "fort_cendre",
		"temple_soleil", "citadelle_sable", "atelier_cuivre", "citadelle_engrenages"], "pending_city": ""}
	check(pm.CONQUEST_CITIES.size() == 30, "campagne étendue à trente villes (V27 : Rouages)")
	var reachable: Array[String] = ["capitale"]
	var changed: bool = true
	while changed:
		changed = false
		for route: Array in pm.CONQUEST_ROUTES:
			var a: String = String(route[0])
			var b: String = String(route[1])
			if reachable.has(a) and not reachable.has(b):
				reachable.append(b)
				changed = true
			elif reachable.has(b) and not reachable.has(a):
				reachable.append(a)
				changed = true
	check(reachable.size() == pm.CONQUEST_CITIES.size(), "les trente villes sont reliées au réseau routier")
	check(pm.conquest_city_attackable({"owned": ["capitale", "clairiere", "village_brume"], "pending_city": ""}, "ruines_lierre"), "Ruines du Lierre accessibles depuis le Village des Brumes")
	check(pm.conquest_city_attackable({"owned": ["capitale", "fort_racine", "hameau_pin", "col_givre"], "pending_city": ""}, "mine_cristal"), "Mine de Cristal accessible depuis le Col du Givre")
	check(pm.conquest_city_attackable({"owned": ["capitale", "fort_racine", "oasis", "caravanserail"], "pending_city": ""}, "observatoire"), "Observatoire Solaire accessible depuis le Caravansérail")
	check(pm.conquest_empire_complete(full), "Empire complet (toutes les villes hors capitale/donjon)")
	var biome_bonus: Dictionary = pm.conquest_biome_control_bonus(full)
	check(int(biome_bonus.get("Bois", 0)) == 5, "contrôle complet de la Forêt : +5 Bois par victoire")
	check(int(biome_bonus.get("Fer", 0)) == 5, "contrôle complet de la Montagne : +5 Fer par victoire")
	check(int(biome_bonus.get("Venin", 0)) == 5, "contrôle complet du Désert : +5 Venin par victoire")
	check(pm.conquest_city_attackable(full, "donjon_roi"), "Donjon attaquable une fois Zimut contrôlé")
	check(not pm.conquest_campaign_won(full), "Campagne pas encore gagnée")
	full["owned"].append("donjon_roi")
	check(pm.conquest_campaign_won(full), "Campagne gagnée après la chute du Donjon")

	# ── Brouillard : une ville voisine de l'empire reste attaquable même non révélée ──
	var fog: Dictionary = {"revealed_cities": ["capitale", "hameau_pin"]}
	var own3: Dictionary = {"owned": ["capitale", "clairiere", "pont_mousse"], "pending_city": ""}
	check(pm.conquest_city_attackable(own3, "fort_racine", fog), "voie ouverte : Fort Racine attaquable malgré le brouillard")
	check(pm.conquest_city_attackable(own3, "vieille_tour", fog), "voie ouverte : Vieille Tour attaquable malgré le brouillard")
	check(pm.conquest_city_attackable(own3, "sanctuaire_mousse", fog), "voie ouverte : Sanctuaire attaquable malgré le brouillard")
	check(not pm.conquest_city_attackable(own3, "hameau_pin", fog), "révélée mais sans route : reste hors de portée")
	check(not pm.conquest_city_attackable(own3, "garnison", fog), "au-delà de la frontière : hors de portée")

	# ── V64 : chemin vers une ville lointaine, avis d'assaut, niveau d'équipe ──
	var routes: Array = pm.CONQUEST_ROUTES
	var way: Array = ConquestSystem.path_to(["capitale"], routes, "ruines_lierre")
	check(way.size() == 3 and String(way[way.size() - 1]) == "ruines_lierre", "chemin vers les Ruines du Lierre : %s" % str(way))
	check(ConquestSystem.path_to(["capitale"], routes, "clairiere") == ["clairiere"], "ville voisine : chemin d'une étape")
	check(ConquestSystem.path_to(["capitale", "clairiere"], routes, "clairiere").is_empty(), "ville déjà conquise : pas de chemin")
	check(ConquestSystem.assault_advice(10, 10)["verdict"] == "ok", "avis : niveau égal = à portée")
	check(ConquestSystem.assault_advice(10, 14)["verdict"] == "risky", "avis : 4 niveaux d'écart = risqué")
	check(ConquestSystem.assault_advice(5, 15)["verdict"] == "weak", "avis : 10 niveaux d'écart = trop fort")
	var td: Dictionary = {"team": [{"classe": "Mage"}, {"classe": "Chasseur"}], "roster": {"Mage": {"level": 10}, "Chasseur": {"level": 6}}}
	check(ConquestSystem.team_avg_level(td) == 8, "niveau moyen d'équipe")
	check(ConquestSystem.team_avg_level({}) == 1, "équipe vide : niveau 1")

	# ── Annexion : just_annexed posé pour l'écran de victoire, puis consommé ──
	var d: Dictionary = pm.new_game(4, "ConqRoads")
	d["campaign_mode"] = "conquest"
	d["conquest"] = {"owned": ["capitale"], "pending_city": "clairiere", "pending_level": 10, "pending_tactic": "scouts"}
	pm.register_victory(d, {"enemies": [{"type": "Gobelin", "level": 10, "boss": false}]})
	var cq: Dictionary = d.get("conquest", {})
	check(String(cq.get("just_annexed", "")) == "clairiere", "just_annexed posé à l'annexion de Clairière")
	check(not cq.has("pending_tactic"), "la préparation tactique est consommée après la bataille")
	check(pm.conquest_city_attackable(cq, "vieille_tour"), "nouvelle route ouverte après annexion")
	var reward: Dictionary = cq.get("last_city_reward", {})
	check(String(reward.get("city", "")) == "clairiere", "récompense de première annexion enregistrée")
	check(String(reward.get("name", "")) == "Réserve des bûcherons", "Clairière attribue son butin thématique")
	check(int(reward.get("resources", {}).get("Bois", 0)) == 12, "récompense de Clairière crédite 12 Bois")
	check(int(reward.get("gold", 0)) == 35, "récompense de Clairière crédite 35 or")
	check(pm.conquest_city_reward("pont_mousse").get("name", "") != pm.conquest_city_reward("clairiere").get("name", ""), "les villes ont des récompenses distinctes")
	check(pm.CONQUEST_CITY_REWARDS.size() == 29, "29 villes non-capitales disposent d'un butin unique")

	# ── Chronique : événements de campagne bornés et persistants ──
	check(cq.get("events", []).any(func(event: String) -> bool: return event.contains("Ville annexée") and event.contains("Clairière")), "chronique : annexion enregistrée")
	check(cq.get("events", []).any(func(event: String) -> bool: return event.contains("Butin") and event.contains("Réserve des bûcherons")), "chronique : butin thématique enregistré")
	var event_log: Dictionary = {}
	for event_index: int in range(12):
		pm.conquest_add_event(event_log, "Événement %d" % event_index)
	check(event_log.get("events", []).size() == 8, "chronique limitée aux huit événements les plus récents")
	check(String(event_log["events"][0]) == "Événement 4", "chronique supprime les événements les plus anciens")

	# ── Sièges sur les nouvelles villes adverses des autres biomes ──
	check(pm.conquest_city_battles("garnison") == 4, "Garnison (enemy) : siège en 4 batailles")
	check(pm.conquest_city_battles("hameau_pin") == 1, "Hameau (neutral) : 1 bataille")
	check(pm.conquest_city_biome("tour_sable") == "Désert", "Tour des Sables : biome Désert")
	check(pm.conquest_city_biome("garnison") == "Montagne", "Garnison : biome Montagne")
	check(pm.conquest_city_biome("donjon_roi") == "Donjon", "Donjon : biome Donjon")

	print("")
	if fails > 0:
		push_error("ÉCHECS : %d" % fails)
		quit(1)
	else:
		quit(0)
