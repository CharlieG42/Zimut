extends SceneTree
## V145 : défendre une ville en personne (Conquête → combat Tactique).
## Lancement : godot --headless --path . -s tests/test_v145_defense.gd
var fails: int = 0
var pm: Node
func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1
func _init() -> void:
	_boot.call_deferred()
func _fresh() -> Dictionary:
	var data: Dictionary = pm.new_game(4, "V145")
	pm.rebuild_team(data, ["Tank", "Mage", "Sylvain"])
	data["campaign_mode"] = "conquest"
	data["conquest"] = {"owned": ["capitale", "clairiere", "hameau_pin"], "pending_city": "",
		"threat": {"city": "clairiere", "power": 30, "eta": 3}}
	return data
func _boot() -> void:
	pm = root.get_node("/root/ProgressionManager")
	var CS: GDScript = load("res://scripts/ConquestSystem.gd")
	# ── niveau des assaillants : dépend de la préparation de la ville
	var d: Dictionary = _fresh()
	var cq: Dictionary = d["conquest"]
	check(CS.can_defend(cq), "une offensive annoncée peut être défendue en personne")
	var avg: int = CS.team_avg_level(d)
	var weak: int = CS.defense_battle_level(d, cq)
	check(weak > avg and weak <= avg + CS.DEFEND_LEVEL_MAX, "ville peu défendue : assaillants au-dessus de l'équipe (niv %d contre %d)" % [weak, avg])
	cq["city_levels"] = {"clairiere": 5}
	cq["garrisons"] = {"clairiere": {"troops": 12, "hero": ""}}
	var strong_def: int = CS.defense(d, "clairiere")
	var easy: int = CS.defense_battle_level(d, cq)
	check(strong_def >= 30 and easy <= avg, "ville bien défendue (défense %d) : assaillants pas plus forts que l'équipe (niv %d)" % [strong_def, easy])
	check(easy >= 1, "le niveau ne descend jamais sous 1")
	cq.erase("garrisons")
	cq.erase("city_levels")
	check(not CS.can_defend({"owned": ["capitale"]}), "pas d'offensive : rien à défendre")
	# ── lancement : la ville menacée devient le lieu du combat
	check(CS.start_defense(d, cq) == "", "le combat de défense se prépare")
	cq = d["conquest"]
	check(String(cq["pending_city"]) == "clairiere" and CS.is_defense_battle(cq) and int(cq["pending_level"]) == weak, "ville, niveau et mode défense posés")
	check(not pm.conquest_siege_is_boss(cq, "clairiere") or CS.is_defense_battle(cq), "ce n'est pas une vague de boss de siège")
	# ── victoire : offensive brisée, garnison intacte, butin, la ville reste à l'empire, pas de siège
	cq["garrisons"] = {"clairiere": {"troops": 2, "hero": ""}}
	var gold0: int = int(d.get("gold", 0))
	pm.register_victory(d, {"enemies": [], "turns": 5})
	cq = d["conquest"]
	check(CS.threat(cq).is_empty() or String(CS.threat(cq).get("city", "")) != "clairiere" or int(CS.threat(cq).get("eta", 0)) == CS.THREAT_ETA, "victoire : l'offensive est levée")
	check((cq["owned"] as Array).has("clairiere"), "victoire : la ville reste à l'empire")
	check(not CS.is_defense_battle(cq) and String(cq.get("pending_city", "")) == "", "victoire : plus de combat en attente")
	check(not (cq.get("sieges", {}) as Dictionary).has("clairiere"), "victoire : aucun siège ouvert sur sa propre ville")
	check(int(d.get("gold", 0)) >= gold0 + int(round(float(20 + 30 * 3) * CS.DEFEND_LOOT_BONUS)), "victoire : butin ×1,5 (%d or gagnés)" % (int(d.get("gold", 0)) - gold0))
	check(CS.troops(cq, "clairiere") >= 2, "victoire : garnison intacte")
	check(int(cq.get("defended_in_person", 0)) == 1, "victoire : compteur de défenses en personne")
	var told := false
	for line: Variant in cq.get("news", []):
		if String(line).contains("OFFENSIVE BRISÉE EN PERSONNE"):
			told = true
	check(told, "victoire : annoncée dans les nouvelles de l'empire")
	# ── défaite : une seule tentative, l'offensive suit son cours
	var d2: Dictionary = _fresh()
	CS.start_defense(d2, d2["conquest"])
	pm.register_defeat(d2, {"enemies": [], "turns": 5})
	var c2: Dictionary = d2["conquest"]
	check(not CS.threat(c2).is_empty() and int(CS.threat(c2)["eta"]) == 3, "défaite : l'offensive continue, échéance inchangée")
	check(not CS.can_defend(c2), "défaite : pas de seconde tentative")
	check((c2["owned"] as Array).has("clairiere"), "défaite : la ville n'est pas perdue sur le coup")
	check(not CS.is_defense_battle(c2) and String(c2.get("pending_city", "")) == "", "défaite : plus de combat en attente")
	# ── retour sur la carte sans résolution
	var d3: Dictionary = _fresh()
	CS.start_defense(d3, d3["conquest"])
	CS.settle_unresolved_defense(d3, d3["conquest"])
	check(CS.can_defend(d3["conquest"]) and not CS.is_defense_battle(d3["conquest"]), "retour depuis le choix de l'équipe : annulation sans pénalité")
	CS.start_defense(d3, d3["conquest"])
	CS.mark_defense_started(d3["conquest"])
	CS.settle_unresolved_defense(d3, d3["conquest"])
	check(not CS.can_defend(d3["conquest"]) and not CS.threat(d3["conquest"]).is_empty(), "abandon en plein combat : tentative consommée, l'offensive continue")
	# ── l'offensive non défendue se règle toujours aux chiffres
	var d4: Dictionary = _fresh()
	var c4: Dictionary = d4["conquest"]
	c4["threat"]["eta"] = 1
	c4["threat"]["fought"] = true
	var rng := RandomNumberGenerator.new()
	rng.seed = 5
	CS.after_victory(d4, c4, rng, pm.CONQUEST_ROUTES, {}, "")
	check(not (d4["conquest"]["owned"] as Array).has("clairiere") or int((d4["conquest"].get("ravage", {}) as Dictionary).get("clairiere", 0)) > 0, "à l'échéance, la résolution chiffrée s'applique comme avant")
	pm.delete_save(4)
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
