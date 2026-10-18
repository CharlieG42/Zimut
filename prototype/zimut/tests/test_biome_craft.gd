extends SceneTree

## Tests : biomes (cycle, ennemis, boss) et craft (ressources, recettes, forge).

var fails: int = 0

func check(cond: bool, msg: String) -> void:
	print(("  ok  " if cond else "  ÉCHEC  ") + msg)
	if not cond:
		fails += 1

func _init() -> void:
	_boot.call_deferred()

func _boot() -> void:
	var pm: Node = root.get_node("ProgressionManager")

	# ── Biomes : cycle Forêt → Montagne → Désert tous les 4 combats ──
	check(pm.biome_for_fight(1) == "Forêt", "combat 1 : Forêt")
	check(pm.biome_for_fight(4) == "Forêt", "combat 4 (boss) : Forêt")
	check(pm.biome_for_fight(5) == "Montagne", "combat 5 : Montagne")
	check(pm.biome_for_fight(8) == "Montagne", "combat 8 (boss) : Montagne")
	check(pm.biome_for_fight(9) == "Désert", "combat 9 : Désert")
	check(pm.biome_for_fight(12) == "Désert", "combat 12 (boss) : Désert")
	check(pm.biome_for_fight(13) == "Forêt", "combat 13 : nouveau cycle Forêt")

	# ── Ennemis et boss par biome ──
	var foret: Array = pm.biome_enemy_types("Forêt")
	check(foret.has("Gobelin") and foret.has("Loup") and foret.size() == 2, "Forêt : Gobelin + Loup")
	check(pm.biome_boss("Forêt") == "Gobelin Roi", "boss Forêt : Gobelin Roi")
	check(pm.biome_boss("Montagne") == "Troll Géant", "boss Montagne : Troll Géant")
	check(pm.biome_boss("Désert") == "Dragon", "boss Désert : Dragon")
	check(pm.biome_label("Forêt") == "Forêt de Zimut", "label du biome")

	# Les types du biome existent bien dans ennemis.txt (avec la bonne colonne Biome)
	var data: Dictionary = pm.new_game(3, "T-biome")
	check(pm.next_biome(data) == "Forêt", "premier combat : Forêt")
	pm.register_victory(data, {"enemies": [{"type": "Gobelin", "level": 10, "boss": false},
		{"type": "Loup", "level": 10, "boss": false}], "turns": 5})
	check(pm.next_biome(data) == "Forêt", "après 1 victoire : toujours Forêt")
	for i: int in range(3):
		pm.register_victory(data, {"enemies": [{"type": "Gobelin", "level": 10, "boss": false}], "turns": 4})
	check(pm.next_biome(data) == "Montagne", "après 4 victoires : Montagne")

	# ── Craft : victoire rapporte ressources et or ──
	var res: Dictionary = pm.resources(data)
	check(not res.is_empty(), "des ressources ont été butinées")
	check(pm.gold(data) > 0, "de l'or a été gagné")
	check(int(data.get("victories", 0)) == 4, "4 victoires enregistrées")

	# ── Craft : recettes chargées ──
	var recipes: Array = pm.craft_recipes()
	check(recipes.size() >= 20, "recettes de craft.txt chargées (%d)" % recipes.size())
	var first: Dictionary = recipes[0] if recipes.size() > 0 else {}
	check(int(first.get("level", -1)) <= int((recipes[recipes.size() - 1] if recipes.size() > 0 else {}).get("level", 99)),
		"recettes triées par niveau")

	# ── Craft : fabrication impossible sans ressources ──
	var fresh: Dictionary = pm.new_game(3, "T-craft")
	var dague: String = "Dague en fer"
	var err: String = pm.craft_item(fresh, dague)
	check(err != "", "craft refusé sans ressources : %s" % err)

	# ── Craft : fabrication possible avec ressources ──
	pm.add_resources(fresh, {"Fer": 20})
	fresh["gold"] = 100
	err = pm.craft_item(fresh, dague)
	check(err == "", "craft de la Dague en fer accepté")
	var inv: Array = fresh.get("inventory", [])
	var found: bool = false
	for it: Dictionary in inv:
		if String(it.get("name", "")) == dague:
			found = true
	check(found, "la Dague en fer est dans l'inventaire")
	check(int(pm.resources(fresh).get("Fer", -1)) == 10, "10 unités de Fer consommées")
	check(pm.gold(fresh) == 100 + 120, "or non consommé (coût 0) ; +120 du succès « Apprenti forgeron »")

	# ── Craft : pièce d'épée avec or ──
	pm.add_resources(fresh, {"Fer": 30, "Bois": 10})
	fresh["gold"] = 80
	err = pm.craft_item(fresh, "Épée du chasseur")
	check(err == "", "Épée du chasseur fabriquée")
	check(pm.gold(fresh) == 30, "50 pièces d'or consommées")

	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
