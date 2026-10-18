extends SceneTree
## V22 Aventure : groupes de monstres errants, contrats, camp, maîtrise.
## godot --headless --path . -s tests/test_adventure_mobs.gd
var fails: int = 0
func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1
func _init() -> void:
	_run.call_deferred()
func _run() -> void:
	var pm: Node = root.get_node("ProgressionManager")
	var gm: Node = root.get_node("GameManager")
	var data: Dictionary = pm.new_game(4, "MobsTest")
	pm.rebuild_team(data, ["Chasseur", "Mage", "Sylvain"])
	data["campaign_mode"] = "adventure"
	var adv: Dictionary = pm.adventure_state(data)
	gm.active_save = data
	gm.active_slot = 4
	var mgr: Node = Node.new()
	mgr.set_script(load("res://scripts/AdventureManager.gd"))
	root.add_child(mgr)
	mgr.load_state(data, 4)
	var zone: String = mgr.zone_id()
	var rng := RandomNumberGenerator.new()
	rng.seed = 42
	# Peuplement
	mgr.ensure_mobs()
	var groups: Array = mgr.mobs()
	check(groups.size() == AdventureMobs.PER_ZONE, "la carte se peuple de %d groupes (%d)" % [AdventureMobs.PER_ZONE, groups.size()])
	var hero: Vector2i = mgr.hero_pos()
	var ok_pos: bool = true
	var t: Dictionary = AdventureTerrain.zone_terrain(zone)
	for g: Dictionary in groups:
		var p: Vector2i = AdventureMobs.pos_of(g)
		if not AdventureTerrain.walkable(zone, p) or (t["pois"] as Array).has(p) or (t["gates"] as Array).has(p) or absi(p.x - hero.x) + absi(p.y - hero.y) < AdventureMobs.MIN_SPAWN_DIST:
			ok_pos = false
		if int(g["count"]) < 2 or int(g["count"]) > 4 or int(g["level"]) < 1:
			ok_pos = false
	check(ok_pos, "groupes posés sur des cases libres, loin du héros, 2 à 4 ennemis")
	check(mgr.ensure_mobs().is_empty(), "pas de nouveau groupe tant que la carte est pleine")
	# Flânerie : toujours sur des cases valides
	var valid: bool = true
	for i in range(40):
		AdventureMobs.wander(adv, zone, hero, rng)
		var seen: Dictionary = {}
		for g2: Dictionary in mgr.mobs():
			var p2: Vector2i = AdventureMobs.pos_of(g2)
			if seen.has(p2) or not AdventureTerrain.walkable(zone, p2) or (t["pois"] as Array).has(p2) or p2 == hero:
				valid = false
			seen[p2] = true
	check(valid, "les groupes flânent sans se superposer ni marcher sur un lieu")
	# Ils bloquent le chemin
	var g0: Dictionary = mgr.mobs()[0]
	var gp: Vector2i = AdventureMobs.pos_of(g0)
	var through: Array = mgr.path_to(gp)
	check(through.is_empty() or through[through.size() - 1] == gp, "un groupe n'est franchissable que comme destination")
	check(not mgr.can_move_to(gp) , "on ne marche pas sur un groupe")
	# Contrat de chasse
	var offer: Dictionary = mgr.contract_offer()
	check(String(offer["kind"]) == "hunt" and int(offer["need"]) >= 2, "premier contrat : chasse (%d groupes)" % int(offer.get("need", 0)))
	var c: Dictionary = mgr.accept_contract()
	check(not mgr.contract().is_empty(), "contrat accepté")
	# Combat contre un groupe puis victoire
	var gold0: int = int(data.get("gold", 0))
	var need: int = int(c["need"])
	for k in range(need):
		var gk: Dictionary = mgr.mobs()[0]
		mgr.start_mob_combat(gk)
		check(int(data["adventure"]["pending_count"]) == int(gk["count"]) and int(data["adventure"]["pending_level"]) == int(gk["level"]), "défi préparé : %d ennemis niv %d" % [int(gk["count"]), int(gk["level"])])
		check(pm.campaign_fight_level(data) == int(gk["level"]), "niveau du combat = niveau du groupe")
		var enemies: Array = []
		for e in range(int(gk["count"])):
			enemies.append({"type": "Gobelin", "level": int(gk["level"]), "boss": false})
		pm.register_victory(data, {"enemies": enemies, "turns": 4, "deaths": 0})
		check(AdventureMobs.by_id(data["adventure"], zone, int(gk["id"])).is_empty(), "groupe vaincu retiré de la carte")
		check(String(data["adventure"]["pending_challenge"]) == "" and not data["adventure"].has("pending_count"), "défi nettoyé")
		check(not (data["adventure"]["completed"] as Array).has(AdventureMobs.challenge_key(zone, int(gk["id"]))), "un groupe ne pollue pas la liste des lieux complétés")
	check(mgr.contract().is_empty(), "contrat de chasse rempli")
	var rew: Dictionary = mgr.take_contract_reward()
	check(int(rew.get("gold", 0)) > 0 and int(data["gold"]) > gold0, "récompense de contrat versée (+%d or)" % int(rew.get("gold", 0)))
	check(mgr.take_contract_reward().is_empty(), "récompense annoncée une seule fois")
	check(int(data["adventure"]["mob_kills"][zone]) == need, "groupes vaincus comptés")
	# Réapparition
	var n_before: int = mgr.mobs().size()
	check(mgr.ensure_mobs().is_empty(), "pas de réapparition immédiate")
	data["adventure"]["moves"] = int(data["adventure"]["moves"]) + AdventureMobs.RESPAWN_STEPS + 1
	check(mgr.ensure_mobs().size() == 1 and mgr.mobs().size() == n_before + 1, "un groupe réapparaît après %d pas" % AdventureMobs.RESPAWN_STEPS)
	# Contrats suivants : chasse puis élite
	data["adventure"]["contracts_done"] = 2
	var off2: Dictionary = mgr.contract_offer()
	check(String(off2["kind"]) == "elite", "un contrat sur trois est un contrat d'élite")
	var c2: Dictionary = mgr.accept_contract()
	var elite: Dictionary = AdventureMobs.by_id(data["adventure"], zone, int(c2.get("elite_id", -1)))
	check(not elite.is_empty() and bool(elite["elite"]) and int(elite["count"]) == 4, "la bande d'élite apparaît (4 ennemis)")
	check(int(elite["level"]) == AdventureMobs.level_range(zone).y + AdventureMobs.ELITE_BONUS_LEVEL / 2, "élite au-dessus de la fourchette de la carte (niv %d)" % int(elite["level"]))
	var rg: Vector2i = AdventureMobs.level_range(zone)
	var in_range: bool = true
	for gg: Dictionary in mgr.mobs():
		if not bool(gg["elite"]) and (int(gg["level"]) < rg.x or int(gg["level"]) > rg.y):
			in_range = false
	check(in_range, "groupes dans la fourchette de la carte (%d-%d)" % [rg.x, rg.y])
	var inv0: int = data["inventory"].size()
	mgr.start_mob_combat(elite)
	pm.register_victory(data, {"enemies": [{"type": "Gobelin", "level": int(elite["level"]), "boss": false}], "turns": 6, "deaths": 0})
	var rew2: Dictionary = mgr.take_contract_reward()
	check(rew2.has("item") and data["inventory"].size() >= inv0 + 2, "contrat d'élite : objet garanti en plus du butin")
	# Camp : repos avec délai
	var xp1: int = mgr.rest_at_camp("test,camp")
	var xp2: int = mgr.rest_at_camp("test,camp")
	check(xp1 > 0 and xp2 == 0, "le repos au camp n'est plus exploitable à l'infini")
	data["adventure"]["moves"] = int(data["adventure"]["moves"]) + mgr.CAMP_REST_STEPS
	check(mgr.rest_at_camp("test,camp") > 0, "repos de nouveau possible après %d pas" % mgr.CAMP_REST_STEPS)
	# Maîtrise
	check(mgr.check_mastery().is_empty(), "pas de maîtrise sans tout explorer")
	for k2: String in pm.adventure_zone_pois(zone).keys():
		var key: String = "%s,%s" % [zone, k2]
		if not (data["adventure"]["completed"] as Array).has(key):
			data["adventure"]["completed"].append(key)
	for fp: Vector2i in AdventureTerrain.finds_of(zone).keys():
		data["adventure"]["finds"].append("%s,%d,%d" % [zone, fp.x, fp.y])
	var inv1: int = data["inventory"].size()
	var m: Dictionary = mgr.check_mastery()
	check(not m.is_empty() and data["inventory"].size() == inv1 + 1 and mgr.is_mastered(), "carte maîtrisée : récompense unique avec objet")
	check(mgr.check_mastery().is_empty(), "maîtrise versée une seule fois")
	# Événements de route : plus d'embuscade surprise
	var kinds: Dictionary = {}
	data["adventure"]["hero_pos"] = [0, 0]
	for i2 in range(200):
		var ev: Dictionary = mgr.roll_event(rng)
		if not ev.is_empty():
			kinds[String(ev["kind"])] = true
	check(not kinds.has("ambush"), "plus d'embuscade surprise (%s)" % str(kinds.keys()))
	pm.delete_save(4)
	print("\n%s — %d échec(s)" % ["OK" if fails == 0 else "KO", fails])
	quit(1 if fails > 0 else 0)
