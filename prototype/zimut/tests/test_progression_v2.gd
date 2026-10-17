extends SceneTree
## Tests : XP / niveaux / points / objets / panoplies / fiche perso.
var fails: int = 0
func check(cond: bool, msg: String) -> void:
	print(("  ok  " if cond else "  ÉCHEC  ") + msg)
	if not cond:
		fails += 1
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var pm: Node = root.get_node("ProgressionManager")
	var data: Dictionary = pm.new_game(3, "T2")
	pm.rebuild_team(data, ["Tank", "Assassin", "Mage"])
	check(pm.member_level(data, "Tank") == 1, "niveau de départ 1")
	check(pm.spells_unlocked_between("Tank", 0, 1).size() == 3, "3 sorts au niveau 1")
	for c: String in ["Tank", "Assassin", "Mage"]:
		var ent: Dictionary = pm.roster_entry(data, c)
		ent["level"] = 20
		ent["xp"] = pm.xp_for_level(20)
		ent["unspent"] = ClassRules.total_points_for_level(20)
		ent["invested"] = {}
		pm.auto_points(data, c)
	var e: Dictionary = pm.roster_entry(data, "Tank")
	check(int(e["unspent"]) == 0 and int(e["invested"].get("vita", 0)) > 0, "capital auto-réparti au départ")
	var st0: Dictionary = pm.member_stats(data, data["team"][0])
	var rep: Dictionary = pm.award_xp(data, 5000)
	check(int(rep["Tank"]["to_level"]) > 20, "l'XP fait monter de niveau")
	check(int(rep["Tank"]["gain"]) > int(rep["Heal"]["gain"]) * 0 and not bool(rep["Sylvain"]["in_team"]), "rapport XP complet")
	check(int(rep["Sylvain"]["gain"]) < int(rep["Tank"]["gain"]), "classe hors équipe : moins d'XP")
	var st1: Dictionary = pm.member_stats(data, data["team"][0])
	check(int(st1["max_pv"]) > int(st0["max_pv"]), "PV du Tank augmentent avec le niveau")
	# points manuels
	pm.reset_points(data, "Mage")
	var cap: int = int(pm.roster_entry(data, "Mage")["unspent"])
	check(cap == ClassRules.total_points_for_level(pm.member_level(data, "Mage")), "reset rend tout le capital")
	check(pm.invest_point(data, "Mage", "intelligence") == "", "investir 1 point")
	check(int(pm.roster_entry(data, "Mage")["unspent"]) == cap - 1, "coût 1 (affinité A)")
	check(ClassRules.point_cost("Mage", "force", 0) == 3, "coût 3 hors-métier")
	pm.refund_point(data, "Mage", "intelligence")
	check(int(pm.roster_entry(data, "Mage")["unspent"]) == cap, "remboursement exact")
	# objets
	var fx: Dictionary = ItemRules.parse_effect("Critique +10%")
	check(int(fx.get("crit", 0)) == 10, "parse Critique +10%")
	check(int(ItemRules.parse_effect("+2 PM").get("pm", 0)) == 2, "parse +2 PM")
	check(int(ItemRules.parse_effect("Vol de vie (5% des dégâts)").get("lifesteal", 0)) == 5, "parse vol de vie")
	check(int(ItemRules.parse_effect("Poison (10 dégâts/tour; 2 tours)").get("poison_hit_dmg", 0)) == 10, "parse poison")
	check(ItemRules.set_key("Casque runique") == "runique" and ItemRules.set_key("Bottes runiques") == "runique", "panoplie runique (pluriel)")
	var rng := RandomNumberGenerator.new()
	rng.seed = 7
	var base: Dictionary = {"type": "Casque", "name": "Casque runique", "level": 5, "force": 0, "intelligence": 4, "agility": 0, "wisdom": 2, "vita": 0, "defense": 3, "effect": "-"}
	var epic: Dictionary = ItemRules.apply_rarity(base, "epique", rng)
	check(ItemRules.power(epic) > ItemRules.power(base), "épique > commun")
	data["inventory"].append(epic)
	data["inventory"].append({"type": "Épée (2 mains)", "name": "Espadon", "level": 5, "force": 9, "effect": "-"})
	data["inventory"].append({"type": "Bouclier", "name": "Bouclier en bois", "level": 5, "defense": 3, "effect": "-"})
	data["inventory"].append({"type": "Bottes", "name": "Bottes du vent", "level": 99, "agility": 5, "effect": "+1 PM"})
	var idx_bottes: int = data["inventory"].size() - 1
	check(pm.equip_item(data, 0, idx_bottes) != "", "niveau requis refusé")
	check(pm.equip_item(data, 0, data["inventory"].size() - 3) == "", "équiper une arme 2 mains")
	var ib: int = data["inventory"].size() - 2
	check(pm.equip_item(data, 0, ib) != "", "bouclier refusé avec arme 2 mains")
	var n: int = pm.auto_equip(data)
	check(n >= 1, "auto-équipement (%d changements)" % n)
	# victoire
	var inv_before: int = data["inventory"].size()
	pm.register_victory(data, {"enemies": [{"type": "Gobelin", "level": 10, "boss": false}], "boss": true})
	check(data["last_loots"].size() >= 3, "boss : au moins 3 loots")
	check(data["last_loots"][0].has("rarity") and data["last_loots"][0]["rarity"] != "commun", "boss : premier loot rare+")
	check(data["inventory"].size() >= inv_before + 3, "loots ajoutés à l'inventaire")
	# retrait d'un perso : équipement récupéré
	var eq_count: int = 0
	for m: Dictionary in data["team"]:
		eq_count += m["equipment"].size()
	var inv_n: int = data["inventory"].size()
	pm.rebuild_team(data, ["Chasseur", "Druide", "Heal"])
	check(data["inventory"].size() == inv_n + eq_count, "équipement des persos retirés rendu à l'inventaire")
	# sauvegarde / migration
	pm.write_save(3, data)
	var back: Dictionary = pm.load_save(3)
	check(back["roster"].has("Sylvain"), "roster sauvegardé")
	var old: Dictionary = {"name": "old", "level": 22, "victories": 6, "team": [{"classe": "Tank", "equipment": {}}], "inventory": []}
	pm.ensure_roster(old)
	check(pm.member_level(old, "Tank") == pm.level_from_old(22), "migration d'une ancienne partie (niveau 22 -> %d)" % pm.level_from_old(22))
	# Ancienne partie AVEC roster (équilibrage < V15) : niveaux étirés, capital conservé, sorts remis à zéro
	var old2: Dictionary = {"name": "old2", "level": 30, "victories": 40, "team": [{"classe": "Mage", "equipment": {}}], "inventory": [],
		"roster": {"Mage": {"level": 30, "xp": 1, "invested": {"intelligence": 20, "vita": 10}, "unspent": 4, "auto": false,
			"spell_levels": {"Boule de feu": 4}}}}
	pm.ensure_roster(old2)
	var me: Dictionary = old2["roster"]["Mage"]
	check(int(me["level"]) == pm.level_from_old(30), "ancienne partie : niveau 30 -> %d" % pm.level_from_old(30))
	check(int(me["invested"]["intelligence"]) == 20, "points investis conservés")
	var spent: int = ClassRules.cost_between("Mage", "intelligence", 0, 20) + ClassRules.cost_between("Mage", "vita", 0, 10)
	check(int(me["unspent"]) == ClassRules.total_points_for_level(int(me["level"])) - spent, "capital restant recalculé")
	check(me["spell_levels"].is_empty(), "points de sorts remis à zéro")
	check(int(old2["balance_v"]) == pm.BALANCE_VERSION and old2.has("difficulty"), "version d'équilibrage + difficulté par partie")
	pm.ensure_roster(old2)
	check(int(old2["roster"]["Mage"]["level"]) == pm.level_from_old(30), "migration idempotente")
	pm.delete_save(3)
	# fiche perso
	var sheet: CanvasLayer = (load("res://scripts/CharacterSheetUI.gd") as GDScript).new()
	root.add_child(sheet)
	var d2: Dictionary = pm.new_game(3, "T3")
	pm.rebuild_team(d2, ["Tank", "Assassin", "Mage"])
	sheet.open(d2, 3, "Mage")
	await process_frame
	check(sheet._content.get_child_count() > 3, "fiche perso construite")
	pm.delete_save(3)
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
