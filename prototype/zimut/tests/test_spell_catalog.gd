extends SceneTree
## V43 : catalogue de 30 sorts par héros — chaque sort est analysable et jouable, synergies fonctionnelles.
var failures := 0
func check(c: bool, l: String) -> void:
	if c: print("  ok  ", l)
	else:
		failures += 1
		print("  KO  ", l)
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var gm: Node = root.get_node("/root/GameManager")
	var pm: Node = root.get_node("/root/ProgressionManager")
	var all_names := {}
	var shared_count := 0
	var by_name := {}
	var bad: Array[String] = []
	var combos := 0
	for classe: String in pm.class_names():
		var spells: Array = gm._build_spells(classe, 100)
		var want: int = 31 if classe in ["Géomancien", "Artificier"] else 30   # V73 : + Rappel de pierre ; V63 : + Couplage
		check(spells.size() == want, "%s : %d sorts au niveau 100 (%d)" % [classe, want, spells.size()])
		var names := {}
		for s: Dictionary in spells:
			var n: String = String(s["name"])
			if names.has(n): bad.append("doublon %s/%s" % [classe, n])
			names[n] = true
			by_name[n] = by_name.get(n, 0) + 1
			var p: Dictionary = Combat.parse(s.duplicate(true))
			var kind: String = String(p["kind"])
			var ok := true
			match kind:
				"attack": ok = int(p["dmg"]) > 0 or p["dots"].size() > 0 or p["debuffs"].size() > 0 or bool(p["needs_summon"]) or int(p["stun_chance"]) > 0
				"heal": ok = int(p["heal"]) > 0 or int(p["heal_pct"]) > 0 or int(p["regen"]) > 0
				"buff": ok = p["buffs"].size() > 0 or bool(p["cure"]) or String(p["target"]) != ""
				"summon", "glyph", "trap", "teleport", "revive", "trigger", "trigger_all", "recall", "link": ok = true
			# un sort sans effet reconnu retombe en « petit buff neutre » : on le détecte
			if kind == "buff" and p["buffs"].size() == 1 and String(p["buffs"][0]["id"]) == "dmg_up" and float(p["buffs"][0]["value"]) == 10.0 and not String(s["effect"]).to_lower().contains("10%"):
				ok = false
			if not ok: bad.append("%s/%s non reconnu : %s" % [classe, n, s["effect"]])
			if String(p["combo_status"]) != "" or String(p["chain_spell"]) != "":
				combos += 1
				if String(p["chain_spell"]) != "":
					var found := false
					for o: Dictionary in spells:
						if String(o["name"]).to_lower() == String(p["chain_spell"]): found = true
					if not found: bad.append("%s/%s : enchaînement sur un sort absent (%s)" % [classe, n, p["chain_spell"]])
				if String(s["effect"]).to_lower().contains("combo") and String(p["combo_status"]) == "":
					bad.append("%s/%s : combo non reconnu" % [classe, n])
	for b in bad: print("   ! ", b)
	check(bad.is_empty(), "tous les sorts sont reconnus (%d problème(s))" % bad.size())
	for n in by_name: if int(by_name[n]) > 1: shared_count += 1
	check(shared_count >= 10, "sorts partagés entre classes : %d" % shared_count)
	check(combos >= 30, "sorts à synergie : %d" % combos)
	# Niveaux de déblocage étalés jusqu'au niveau 100
	for classe: String in pm.class_names():
		var lv: Array = []
		for s: Dictionary in pm.spells_of(classe): lv.append(int(s["level"]))
		check(lv.max() == 100 and lv.min() == 1, "%s : sorts de niveau 1 à 100" % classe)
	# Synergies en combat
	gm.fight_biome = "Forêt"
	gm.init_grid(); gm.init_entities()
	var caster: Dictionary = gm.players[0]
	var tgt: Dictionary = gm.enemies[0]
	var sp: Dictionary = {"name": "Test combo", "classe": "Tank", "cost_pa": 1, "cost_pm": 0, "range": 1,
		"effect": "50 dégâts [Combo poison : bonus 40%] [Enchaînement après Protection : bonus 30%]", "spell_type": "Attaque"}
	var p: Dictionary = Combat.parse(sp)
	check(int(p["dmg"]) == 50, "les clauses n'altèrent pas les dégâts (%d)" % int(p["dmg"]))
	check(not (p["buffs"] as Array).size() > 0, "les clauses ne créent pas de buff")
	check(Combat.synergy_pct(p, tgt, {}) == 0, "sans état ni enchaînement : +0 %")
	Combat.add_status(tgt, "poison", 2, 5.0)
	check(Combat.synergy_pct(p, tgt, {}) == 40, "cible empoisonnée : +40 %")
	check(Combat.synergy_pct(p, tgt, {"Protection": 1}) == 70, "après Protection : +40 +30 = +70 %")
	check(Combat.synergy_pct(p, {}, {"Protection": 1}) == 30, "enchaînement seul : +30 %")
	check(Combat.describe(sp).contains("Combo : +40 %"), "la description mentionne le combo")
	# Montée de niveau : les nouveaux sorts comblent les places libres, jamais au-delà de 10
	var data: Dictionary = pm.new_game(4, "Cat")
	pm.rebuild_team(data, ["Mage", "Tank", "Heal"])
	var e: Dictionary = pm.roster_entry(data, "Mage")
	var n0: int = Builds.active_spells(data, "Mage").size()
	var from_l: int = int(e["level"])
	e["level"] = 30
	Builds.on_level_up(data, "Mage", from_l, 30)
	var n1: int = Builds.active_spells(data, "Mage").size()
	check(n1 > n0 and n1 <= Builds.MAX_ACTIVE_SPELLS, "niv 30 : sorts actifs %d → %d (≤ 10)" % [n0, n1])
	e["level"] = 100
	Builds.on_level_up(data, "Mage", 30, 100)
	check(Builds.active_spells(data, "Mage").size() == Builds.MAX_ACTIVE_SPELLS, "niv 100 : build plein (10 sorts) malgré 30 sorts disponibles")
	check(Builds.unlocked_spell_names(data, "Mage").size() == 30, "30 sorts à choisir")
	pm.delete_save(4)
	print("OK" if failures == 0 else "ÉCHEC")
	quit(1 if failures > 0 else 0)
