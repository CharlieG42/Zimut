extends SceneTree
## Fiche personnage › Équipement : détail d'un objet porté au clic + bouton « Équiper le meilleur ».
## Lancement : godot --headless --path . -s tests/test_fiche_equipement_detail.gd
var fails: int = 0
func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var pm: Node = root.get_node("ProgressionManager")
	var d: Dictionary = pm.new_game(4, "Detail")
	pm.rebuild_team(d, ["Mage", "Tank", "Heal"])
	d["heroes_unlocked"] = pm.class_names()
	var weak := {"name": "Bâton faible", "type": "Bâton (1 main)", "level": 1, "rarity": "commun", "force": 1, "intelligence": 1}
	var strong := {"name": "Bâton fort", "type": "Bâton (1 main)", "level": 1, "rarity": "rare", "force": 6, "intelligence": 7}
	var helm := {"name": "Casque simple", "type": "Casque", "level": 1, "rarity": "commun", "defense": 3, "vita": 5}
	var too_high := {"name": "Casque royal", "type": "Casque", "level": 99, "rarity": "legendaire", "defense": 50}
	check(pm.slot_for_type("Bâton (1 main)") == "arme" and pm.slot_for_type("Casque") == "casque", "types de test reconnus")
	var eq: Dictionary = pm.hero_equipment(d, "Mage")
	eq["arme"] = weak
	d["inventory"] = [strong, helm, too_high]
	# auto_equip_hero : un seul héros, niveau respecté
	var n: int = pm.auto_equip_hero(d, "Mage")
	var eq2: Dictionary = pm.hero_equipment(d, "Mage")
	check(n == 2, "2 changements pour le héros (arme + casque), obtenu %d" % n)
	check(String(eq2["arme"]["name"]) == "Bâton fort" and String(eq2["casque"]["name"]) == "Casque simple", "meilleurs objets équipés")
	check(not pm.hero_equipment(d, "Tank").has("casque"), "les autres héros ne sont pas touchés")
	var inv_names: Array = []
	for it: Dictionary in d["inventory"]:
		inv_names.append(String(it["name"]))
	check(inv_names.has("Bâton faible") and inv_names.has("Casque royal") and not inv_names.has("Bâton fort"), "ancien objet rendu à l'inventaire, objet trop haut ignoré")
	check(pm.auto_equip_hero(d, "Mage") == 0, "relancer ne change rien")
	# auto_equip (équipe) toujours fonctionnel
	d["inventory"] = [{"name": "Casque bis", "type": "Casque", "level": 1, "rarity": "commun", "defense": 4}]
	check(pm.auto_equip(d) >= 1 and pm.hero_equipment(d, "Tank").has("casque") or pm.hero_equipment(d, "Heal").has("casque") or pm.hero_equipment(d, "Mage").has("casque"), "auto_equip de l'équipe")
	# héros hors équipe
	d["inventory"] = [{"name": "Gants hors équipe", "type": "Gants", "level": 1, "rarity": "commun", "force": 2}]
	var outsider: String = ""
	for c: String in pm.class_names():
		if not ["Mage", "Tank", "Heal"].has(c):
			outsider = c
			break
	check(outsider != "" and pm.auto_equip_hero(d, outsider) == 1, "équiper le meilleur marche pour un héros hors équipe (%s)" % outsider)
	# vue
	d["inventory"] = [{"name": "Épée neuve", "type": "Bâton (1 main)", "level": 1, "rarity": "epique", "force": 20}]
	pm.hero_equipment(d, "Mage")["arme"] = {"name": "Dague usée", "type": "Bâton (1 main)", "level": 1, "rarity": "rare", "force": 3, "agility": 2, "effect": "Vol de vie 5%", "fort": {"biome": "Vents", "fx": {"pm": 1}}}
	pm.write_save(4, d)
	var ui: CanvasLayer = (load("res://scripts/CharacterSheetUI.gd") as GDScript).new()
	ui.layer = 10
	root.add_child(ui)
	ui.open(d, 4, "Mage")
	ui._tab = "gear"
	ui.refresh()
	await process_frame
	await process_frame
	check(ui.find_child("GearBest", true, false) != null, "bouton « Équiper le meilleur » présent")
	# clic sur un objet porté : détail
	(ui.find_child("GearPick_arme", true, false) as Button).pressed.emit()
	await process_frame
	await process_frame
	check(ui.find_child("GearDetail", true, false) != null, "clic sur un objet porté : fiche détaillée")
	var nm: Label = ui.find_child("GearDetailName", true, false) as Label
	check(nm != null and nm.text.contains("Dague usée"), "nom de l'objet affiché")
	var stats: Control = ui.find_child("GearDetailStats", true, false)
	var txt: String = ""
	if stats != null:
		for row: Node in stats.get_children():
			for l: Node in row.get_children():
				if l is Label:
					txt += (l as Label).text + " "
	check(txt.contains("Force") and txt.contains("+3") and txt.contains("Agilité") and txt.contains("+2"), "caractéristiques listées (« %s »)" % txt.strip_edges())
	check(ui.find_child("GearDetailFort", true, false) != null, "ligne de fortification affichée")
	check(ui.find_child("GearDetailChange", true, false) != null and ui.find_child("GearDetailRemove", true, false) != null, "actions Changer / Retirer")
	# Changer : ouvre la liste de choix
	(ui.find_child("GearDetailChange", true, false) as Button).pressed.emit()
	await process_frame
	await process_frame
	check(ui._gear_pick == "arme" and ui.find_child("GearDetail", true, false) == null, "« Changer » ouvre la liste des objets")
	ui._gear_pick = ""
	ui.refresh()
	await process_frame
	# emplacement vide : directement la liste
	(ui.find_child("GearPick_cape", true, false) as Button).pressed.emit()
	await process_frame
	check(ui._gear_pick == "cape" and ui._gear_detail == "", "emplacement vide : liste de choix directe")
	ui._gear_pick = ""
	ui.refresh()
	await process_frame
	# Retirer depuis le détail
	(ui.find_child("GearPick_arme", true, false) as Button).pressed.emit()
	await process_frame
	(ui.find_child("GearDetailRemove", true, false) as Button).pressed.emit()
	await process_frame
	check(not pm.hero_equipment(ui._save, "Mage").has("arme"), "« Retirer » déséquipe l'objet")
	# Équiper le meilleur depuis la fiche
	(ui.find_child("GearBest", true, false) as Button).pressed.emit()
	await process_frame
	await process_frame
	check(pm.hero_equipment(ui._save, "Mage").has("arme"), "le bouton équipe l'arme disponible")
	var msg: Label = ui.find_child("GearMsg", true, false) as Label
	check(msg != null and msg.text.contains("équipé"), "message de confirmation")
	(ui.find_child("GearBest", true, false) as Button).pressed.emit()
	await process_frame
	await process_frame
	msg = ui.find_child("GearMsg", true, false) as Label
	check(msg != null and msg.text.contains("Rien de mieux"), "rien à équiper : message clair")
	pm.delete_save(4)
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
