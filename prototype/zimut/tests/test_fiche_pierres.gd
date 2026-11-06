extends SceneTree
## Fiche personnage : poupée d'équipement + 2 emplacements Pierre (Stones.assign / slots_of, vues).
## Lancement : godot --headless --path . -s tests/test_fiche_pierres.gd
var fails: int = 0
func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var pm: Node = root.get_node("ProgressionManager")
	var d: Dictionary = pm.new_game(4, "Pierres")
	pm.rebuild_team(d, ["Mage", "Tank", "Heal"])
	d["heroes_unlocked"] = pm.class_names()
	for b: String in ["Forêt", "Brasier", "Vents"]:
		Stones.grant(d, b)
	var sl0: Array[String] = Stones.slots_of(d, "Mage")
	check(sl0.size() == 2 and sl0[0] == "" and sl0[1] == "", "2 emplacements vides au départ")
	check(Stones.assign(d, "Forêt", "Mage", 0) == "" and Stones.assign(d, "Brasier", "Mage", 1) == "", "2 Pierres équipées")
	check(Stones.stones_of(d, "Mage").size() == 2 and Stones.MAX_PER_HERO == 2, "2 Pierres au maximum")
	check(Stones.equip(d, "Vents", "Mage") != "", "une 3e Pierre est refusée")
	# remplacement dans un emplacement : l'ancienne est rendue
	check(Stones.assign(d, "Vents", "Mage", 0) == "" and Stones.owner_of(d, "Forêt") == "" and Stones.owner_of(d, "Vents") == "Mage", "remplacer la Pierre d'un emplacement")
	check(Stones.stones_of(d, "Mage").size() == 2, "toujours 2 Pierres")
	# reprise à un autre porteur
	check(Stones.assign(d, "Brasier", "Tank", 0) == "" and Stones.owner_of(d, "Brasier") == "Tank" and Stones.stones_of(d, "Mage").size() == 1, "Pierre reprise à son ancien porteur")
	check(Stones.assign(d, "Brasier", "Tank", 0) == "", "ré-assigner une Pierre déjà portée : sans effet")
	check(Stones.assign(d, "Ombres", "Tank", 1) != "", "Pierre non trouvée refusée")
	check(Stones.assign(d, "Forêt", "Tank", 2) != "", "emplacement invalide refusé")
	# bonus cumulés des deux Pierres
	Stones.assign(d, "Forêt", "Tank", 1)
	var hb: Dictionary = Stones.hero_bonus(d, "Tank")
	check(int(hb["stats"].get("force", 0)) > 0 and int(hb["stats"].get("vita", 0)) > 0, "les bonus des 2 Pierres se cumulent")
	# vue
	pm.write_save(4, d)
	var ui: CanvasLayer = (load("res://scripts/CharacterSheetUI.gd") as GDScript).new()
	ui.layer = 10
	root.add_child(ui)
	ui.open(d, 4, "Tank")
	ui._tab = "gear"
	ui.refresh()
	await process_frame
	await process_frame
	check(ui.find_child("Paperdoll", true, false) != null, "vue poupée d'équipement")
	check(ui.find_child("GearRing", true, false) != null, "tuiles d'équipement en anneau autour du héros")
	var bonus: Label = ui.find_child("DollBonus", true, false) as Label
	check(bonus != null and not bonus.text.contains("F+") and (bonus.text == "Aucun bonus" or bonus.text.contains("Vitalité") or bonus.text.contains("Force") or bonus.text.contains("Défense") or bonus.text.contains("Agilité") or bonus.text.contains("Intelligence") or bonus.text.contains("Sagesse")), "somme des bonus en noms complets (« %s »)" % (bonus.text.replace("\n", " | ") if bonus else ""))
	check(ui.find_child("StonePick_0", true, false) != null and ui.find_child("StonePick_1", true, false) != null, "2 emplacements Pierre affichés")
	for slot: String in ["arme", "bouclier", "casque", "armure", "bottes", "bague", "collier", "gants", "boucle_oreille", "cape"]:
		if ui.find_child("GearPick_" + slot, true, false) == null:
			check(false, "emplacement d'équipement manquant : " + slot)
	check(ui.find_child("GearPick_cape", true, false) != null and ui.find_child("GearPick_arme", true, false) != null, "10 emplacements d'équipement")
	ui._stone_pick = 1
	ui.refresh()
	await process_frame
	check(ui.find_child("StoneChoice_Vents", true, false) != null, "sélecteur de Pierre")
	pm.delete_save(4)
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
