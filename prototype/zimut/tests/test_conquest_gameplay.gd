extends SceneTree

## Tests du mode Conquête : contre-attaques (jamais la capitale), bâtiments
## de ressources, production d'empire, et brisage d'équipement.

var fails: int = 0

func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1

func _init() -> void:
	_boot.call_deferred()

func _boot() -> void:
	var pm: Node = root.get_node("ProgressionManager")
	var data: Dictionary = pm.new_game(4, "ConqTest")
	pm.rebuild_team(data, ["Tank", "Mage", "Heal"])
	data["campaign_mode"] = "conquest"
	data["conquest"] = {"owned": ["capitale"], "pending_city": "clairiere", "pending_level": 10}

	# ── Victoire : annexion + première production vide (pas encore de bâtiments) ──
	pm.register_victory(data, {"enemies": [{"type": "Gobelin", "level": 10, "boss": false}]})
	var conquest: Dictionary = data.get("conquest", {})
	check(conquest.get("owned", []).has("clairiere"), "victoire : Clairière d'Aube annexée")
	check(String(conquest.get("pending_city", "x")) == "", "pending_city réinitialisé")

	# ── Construction : coûts, doublon, ville inconnue ──
	data["resources"] = {"Bois": 30, "Fer": 5}
	data["gold"] = 100
	check(pm.conquest_build(data, "clairiere", "scierie") == "", "construction d'une scierie à Clairière")
	check(int(data["resources"].get("Bois", -1)) == 18, "coût Bois déduit (30-12=18)")
	check(int(data["gold"]) == 60, "coût or déduit (100-40=60)")
	check(pm.conquest_build(data, "clairiere", "scierie") != "", "doublon refusé")
	check(pm.conquest_build(data, "vieille_tour", "mine") != "", "ville non conquise refusée")
	check(pm.conquest_build(data, "capitale", "scierie") == "", "construction possible dans la capitale")
	check(pm.conquest_build(data, "clairiere", "mine") != "", "ressources insuffisantes refusées (Fer 5 < 12)")

	# ── Production de l'empire à la prochaine victoire ──
	conquest = data.get("conquest", {})
	conquest["pending_city"] = "vieille_tour"
	conquest["pending_level"] = 12
	data["conquest"] = conquest
	var res_before: int = int(data["resources"].get("Bois", 0))
	var gold_before: int = int(data.get("gold", 0))
	data["campaign_mode"] = "conquest"
	pm.register_victory(data, {"enemies": [{"type": "Gobelin", "level": 12, "boss": false}]})
	conquest = data.get("conquest", {})
	check(conquest.get("owned", []).has("vieille_tour"), "Vieille Tour annexée")
	var yld: Dictionary = conquest.get("last_yield", {})
	check(int(yld.get("Bois", 0)) >= 3, "production empire : scieries Bois +%d par bataille gagnée" % int(yld.get("Bois", 0)))
	check(int(data["resources"].get("Bois", 0)) >= res_before + 3, "Bois crédité (scierie)")

	# ── Contre-attaques : jamais la capitale ni la ville fraîchement conquise ──
	var counter_seen: bool = false
	var capital_hit: bool = false
	var fresh_hit: bool = false
	for trial: int in range(60):
		var dd: Dictionary = pm.new_game(5, "Cc%d" % trial)
		dd["campaign_mode"] = "conquest"
		# territoire : capitale + 2 villes, une fraîchement conquise
		dd["conquest"] = {"owned": ["capitale", "clairiere", "pont_mousse"], "pending_city": "pont_mousse", "pending_level": 11}
		dd["resources"] = {}
		pm.register_victory(dd, {"enemies": [{"type": "Gobelin", "level": 11, "boss": false}]})
		var cc: Dictionary = dd.get("conquest", {})
		var counter: String = String(cc.get("last_counterattack", ""))
		if counter != "":
			counter_seen = true
			if counter == "capitale":
				capital_hit = true
			if counter == "pont_mousse":
				fresh_hit = true
	check(counter_seen, "contre-attaques observées sur 60 victoires (35 % de chance)")
	check(not capital_hit, "la capitale n'est JAMAIS contre-attaquée")
	check(not fresh_hit, "la ville fraîchement conquise n'est pas ciblée")
	var ravaged: Dictionary = {}
	for trial2: int in range(60):
		# une contre-attaque = pillage 3 batailles, décrémenté à chaque victoire
		pass
	# Décrément direct du pillage : on appelle le décompte isolément
	var cq: Dictionary = {"owned": ["capitale", "clairiere"], "ravage": {"clairiere": 3}}
	for v: int in range(3):
		pm._tick_ravage(cq)
	check(not cq.get("ravage", {}).has("clairiere"), "pillage décrémenté à chaque victoire, expiré après 3")
	check(pm._is_city_ravaged(cq, "clairiere") == false, "ville débloquée après expiration du pillage")

	# ── Brisage d'équipement ──
	var d3: Dictionary = pm.new_game(7, "Salvage")
	d3["inventory"] = [
		{"type": "Arme (1 main)", "name": "Dague usée", "level": 5, "rarity": "commun", "force": 3, "effect": "-"},
		{"type": "Casque", "name": "Heaume runique", "level": 12, "rarity": "rare", "defense": 6, "effect": "-"},
		{"type": "Bottes", "name": "Bottes du vent", "level": 20, "rarity": "legendaire", "agility": 9, "effect": "+1 PM"},
	]
	var inv_n: int = d3["inventory"].size()
	var res0: int = int(d3["resources"].get("Fer", 0)) + int(d3["resources"].get("Bois", 0)) + int(d3["resources"].get("Cuir", 0))
	var r1: Dictionary = pm.salvage_item(d3, 1)
	check(bool(r1.get("ok")), "brisage d'un objet rare")
	check(d3["inventory"].size() == inv_n - 1, "objet retiré de l'inventaire")
	var g1: Dictionary = r1.get("gains", {})
	var tot1: int = 0
	for k: String in g1.keys():
		tot1 += int(g1[k])
	check(tot1 >= 2, "le rare rend plusieurs ressources (%d)" % tot1)
	var r2: Dictionary = pm.salvage_item(d3, 99)
	check(not bool(r2.get("ok")), "index invalide refusé")
	# le légendaire rend plus que le commun
	var d4: Dictionary = pm.new_game(8, "Salv2")
	d4["inventory"] = [
		{"type": "Bague", "name": "Anneau simple", "level": 5, "rarity": "commun", "effect": "-"},
		{"type": "Bague", "name": "Anneau ultime", "level": 20, "rarity": "legendaire", "effect": "-"},
	]
	var rl: Dictionary = pm.salvage_item(d4, 1)
	var totl: int = 0
	for k2: String in rl.get("gains", {}).keys():
		totl += int(rl["gains"][k2])
	var d5: Dictionary = pm.new_game(9, "Salv3")
	d5["inventory"] = [{"type": "Bague", "name": "Anneau simple", "level": 5, "rarity": "commun", "effect": "-"}]
	var rc: Dictionary = pm.salvage_item(d5, 0)
	var totc: int = 0
	for k3: String in rc.get("gains", {}).keys():
		totc += int(rc["gains"][k3])
	check(totl > totc, "légendaire (%d) rend plus que commun (%d)" % [totl, totc])
	print("== TOUS OK ==" if fails == 0 else "== %d ÉCHECS ==" % fails)
	quit(0 if fails == 0 else 1)
