extends SceneTree
## Éclats de Pierre Élémentaire : drops, brisure d'une Pierre, fortification et plafonds.
## Lancement : godot --headless --path . -s tests/test_eclats.gd
var fails: int = 0
func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var pm: Node = root.get_node("ProgressionManager")
	var data: Dictionary = pm.new_game(4, "Eclats")
	pm.rebuild_team(data, ["Tank", "Mage", "Heal"])
	var rng := RandomNumberGenerator.new()
	rng.seed = 7
	# ── tirages ──
	var got: int = 0
	for _i in range(4000):
		got += int(Shards.roll_fight(rng, "Forêt", false).size())
	check(got > 40 and got < 250, "combat normal : éclat très rare (%d / 4000)" % got)
	var got_boss: int = 0
	for _i in range(4000):
		got_boss += int(Shards.roll_fight(rng, "Forêt", true).size())
	check(got_boss > got, "boss : plus de chances qu'un combat normal (%d > %d)" % [got_boss, got])
	var dn: int = 0
	for _i in range(1000):
		var d: Dictionary = Shards.roll_dungeon(rng, "Vents")
		if not d.is_empty():
			dn += 1
			check(int(d["Vents"]) >= 1 and int(d["Vents"]) <= 3, "donjon : 1 à 3 éclats") if dn == 1 else null
	check(dn > 300 and dn < 500, "donjon : ~40 %% (%d / 1000)" % dn)
	check(Shards.roll_fight(rng, "Donjon", true).is_empty(), "biome inconnu : aucun éclat")
	# Pierre déjà possédée : le Gardien peut TOUJOURS laisser des éclats
	Stones.grant(data, "Forêt")
	var owned_drops: int = 0
	for _i in range(300):
		if not Shards.roll_dungeon(rng, "Forêt").is_empty():
			owned_drops += 1
	check(Stones.has(data, "Forêt") and owned_drops > 0, "Pierre possédée : des éclats peuvent encore tomber (%d / 300)" % owned_drops)
	# ── victoire : l'éclat arrive dans la sauvegarde (aucune erreur, clé last_shards) ──
	pm.register_victory(data, {"boss": true, "biome": "Désert"})
	check(data.has("last_shards"), "register_victory renseigne last_shards")
	# ── brisure ──
	Stones.owned(data)["Forêt"]["level"] = 3
	Stones.equip(data, "Forêt", "Tank")
	var before: int = Shards.count(data, "Forêt")
	var y: int = Shards.shatter_yield(data, "Forêt")
	check(y == Shards.SHATTER_BASE + 6 / 2, "rendement niveau 3 = %d (base + moitié des 6 éclats investis)" % y)
	var r: Dictionary = Shards.shatter(data, "Forêt")
	check(bool(r["ok"]) and not Stones.has(data, "Forêt"), "la Pierre disparaît")
	check(Shards.count(data, "Forêt") == before + y, "les éclats sont crédités")
	check(Stones.stones_of(data, "Tank").is_empty(), "le porteur perd la Pierre")
	check(Stones.grant(data, "Forêt"), "la Pierre peut être regagnée après brisure")
	check(not bool(Shards.shatter(data, "Montagne")["ok"]), "briser une Pierre absente échoue")
	# ── éveil : coûte des éclats de la Nation ──
	Stones.grant(data, "Vents")
	data["gold"] = 100000
	data["resources"] = {"Fer": 999, "Bois": 999, "Cuir": 999, "Magie": 999, "Venin": 999}
	var c2: Dictionary = Stones.awaken_cost(data, "Vents")
	check(int(c2["shards"]) == 2, "éveil 1 → 2 coûte 2 éclats")
	data["shards"] = {}
	check(Stones.can_awaken(data, "Vents") != "", "éveil refusé sans éclats")
	Shards.add(data, "Vents", 20)
	var paid: bool = true
	for _i in range(4):
		paid = paid and Stones.awaken(data, "Vents") == ""
	check(paid and Stones.level(data, "Vents") == Stones.MAX_LEVEL, "4 éveils → niveau max")
	check(Shards.count(data, "Vents") == 0, "20 éclats dépensés au total")
	check(Shards.shatter_yield(data, "Vents") < 20, "briser un niveau 5 rend moins que ce qui a été investi (%d < 20)" % Shards.shatter_yield(data, "Vents"))
	Shards.shatter(data, "Vents")
	# ── fortification ──
	var item: Dictionary = {"type": "Épée (1 main)", "name": "Épée test", "level": 10, "rarity": "commun", "force": 5, "defense": 2}
	check(Shards.can_fortify(data, item, "Rouages") != "", "sans éclats : fortification refusée")
	Shards.add(data, "Rouages", 8)
	data["gold"] = 1000
	check(Shards.fortify(data, item, "Rouages") == "", "fortification Rouages (+1 PA)")
	check(Shards.count(data, "Rouages") == 0 and int(data["gold"]) == 1000 - Shards.gold_cost(item), "coût payé (éclats + or)")
	check(item["fort"]["fx"]["pa"] == 1, "l'objet porte +1 PA")
	check(ItemRules.stat_line(item).contains("❖ +1 PA"), "caractéristiques : ❖ +1 PA marqué (%s)" % ItemRules.stat_line(item))
	check(Shards.fortify(data, item, "Rouages") != "", "même bonus deux fois refusé")
	Shards.add(data, "Vents", 6)
	check(Shards.fortify(data, item, "Vents") == "" and not item["fort"]["fx"].has("pa") and item["fort"]["fx"]["pm"] == 1, "refortifier remplace l'ancien bonus")
	check(Shards.can_fortify(data, {"type": "Potion", "name": "x"}, "Vents") != "", "un non-équipement ne se fortifie pas")
	# ── effet réel sur les statistiques + plafond ──
	var eq: Dictionary = {}
	for i in range(4):
		eq["slot%d" % i] = {"type": "Casque", "name": "c%d" % i, "level": 1, "fort": {"biome": "Rouages", "fx": {"pa": 1}}}
	var agg: Dictionary = ItemRules.aggregate(eq)
	check(int(agg["fx"].get("pa", 0)) == Shards.FORT_CAP["pa"], "4 fortifications PA : plafonnées à +%d" % Shards.FORT_CAP["pa"])
	var member: Dictionary = data["team"][0]
	var base_pa: int = int(pm.member_stats(data, member)["pa"])
	member["equipment"] = {"arme": item.duplicate(true)}
	member["equipment"]["arme"]["fort"] = {"biome": "Rouages", "fx": {"pa": 1}}
	var with_pa: int = int(pm.member_stats(data, member)["pa"])
	check(with_pa == base_pa + 1, "member_stats : +1 PA grâce à la fortification (%d → %d)" % [base_pa, with_pa])
	# ── sauvegarde : l'objet fortifié survit à une sérialisation ──
	var back: Variant = JSON.parse_string(JSON.stringify(item))
	check(back is Dictionary and (back as Dictionary).has("fort") and ItemRules.stat_line(back).contains("❖"), "l'objet fortifié survit à la sauvegarde JSON")
	# ── 10 Nations couvertes, effets valides ──
	var all_ok: bool = true
	for b: String in Stones.ORDER:
		if not Shards.FORT.has(b) or Shards.fx_text(Shards.fort_fx(b)) == "" or Shards.shard_name(b) == "":
			all_ok = false
	check(all_ok, "les 10 Nations ont un éclat et un bonus lisible")
	pm.delete_save(4)
	print("ÉCHECS : ", fails)
	quit(0 if fails == 0 else 1)
