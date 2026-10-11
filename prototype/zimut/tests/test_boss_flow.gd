extends SceneTree
## Flux complet : victoires -> boss au 4e combat -> préselection d'équipe.

var pm: Node

func _init() -> void:
	pm = load("res://scripts/ProgressionManager.gd").new()
	pm.name = "ProgressionManagerTest"
	root.add_child.call_deferred(pm)
	_boot.call_deferred()

func _boot() -> void:
	var data = pm.new_game(0, "TestBoss")
	data["team"] = [{"classe": "Tank", "equipment": {}}, {"classe": "Mage", "equipment": {}}, {"classe": "Heal", "equipment": {}}]
	pm.write_save(0, data)

	# Combat 1, 2, 3 : pas de boss
	for i in range(3):
		var d = pm.load_save(0)
		var is_boss = pm.is_boss_fight(d)
		var n = pm.next_fight_number(d)
		print("combat %d: boss=%s (attendu false)" % [n, is_boss])
		assert(not is_boss)
		pm.register_victory(d)
		pm.write_save(0, d)

	# Combat 4 : boss !
	var d4 = pm.load_save(0)
	print("combat %d: boss=%s (attendu true)" % [pm.next_fight_number(d4), pm.is_boss_fight(d4)])
	assert(pm.is_boss_fight(d4))
	print("niveau partie après 3 victoires:", d4["level"], "(attendu 16)")

	# Combat 5 : retour à la normale
	pm.register_victory(d4)
	pm.write_save(0, d4)
	var d5 = pm.load_save(0)
	print("combat %d: boss=%s (attendu false)" % [pm.next_fight_number(d5), pm.is_boss_fight(d5)])
	assert(not pm.is_boss_fight(d5))
	print("PROGRESSION OK")

	# Préselection d'équipe : TeamSelection doit reprendre la team sauvegardée
	var gm = root.get_node("/root/GameManager")
	gm.active_slot = 0
	gm.active_save = pm.load_save(0)
	var sc = (load("res://scenes/TeamSelection.tscn") as PackedScene).instantiate()
	root.add_child(sc)
	await process_frame
	await process_frame
	print("team présélectionnée:", sc.team, "(attendu [Tank, Mage, Heal])")
	assert(sc.team == ["Tank", "Mage", "Heal"])
	print("title:", sc._title.text)
	print("bouton combat:", sc._fight_btn.text)
	print("PRÉSELECTION OK")

	# Spawn des ennemis avec boss : simuler via GameManager
	gm.active_save = pm.load_save(0)
	pm.register_victory(gm.active_save)  # aller au combat 8 (boss)
	pm.register_victory(gm.active_save)
	pm.register_victory(gm.active_save)
	pm.write_save(0, gm.active_save)
	gm.active_save = pm.load_save(0)
	print("prochain combat:", pm.next_fight_number(gm.active_save), "boss:", pm.is_boss_fight(gm.active_save))

	# reset + spawn (comme Main.tscn le ferait)
	gm.init_grid()
	gm.init_entities()
	await process_frame
	var bosses: Array = []
	var minions: Array = []
	for e in gm.enemies:
		if String(e.get("name", "")).contains("BOSS"):
			bosses.append(e)
		else:
			minions.append(e)
	print("ennemis:", gm.enemies.size(), "boss:", bosses.size(), "sbires:", minions.size())
	assert(bosses.size() == 1)
	assert(minions.size() == 3)
	if bosses.size() > 0:
		var b = bosses[0]
		print("BOSS:", b["name"], "PV:", b["max_pv"], "atk:", b["force"], "PA:", b["max_pa"], "PM:", b["max_pm"])
	for m in minions:
		print("sbire:", m["name"], "PV:", m["max_pv"])
	print("BOSS FLOW OK")

	gm.active_slot = -1
	gm.active_save = {}
	pm.delete_save(0)
	quit(0)
