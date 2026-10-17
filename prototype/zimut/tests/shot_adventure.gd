extends SceneTree
## Captures du mode Aventure (écran virtuel) :
##   xvfb-run -a godot --rendering-method gl_compatibility --path . -s tests/shot_adventure.gd -- <dossier> <zone>
## Produit : carte explorée, énigme à choix, runes, dalles, combat, événement.
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var args: PackedStringArray = OS.get_cmdline_user_args()
	var out: String = args[0]
	var zone: String = args[1] if args.size() > 1 else "foret_sylve"
	var pm: Node = root.get_node("ProgressionManager")
	var gm: Node = root.get_node("GameManager")
	var data: Dictionary = pm.new_game(4, "CaptureAdv")
	pm.rebuild_team(data, ["Chasseur", "Mage", "Sylvain"])
	for c in ["Chasseur", "Mage", "Sylvain"]:
		pm.roster_entry(data, c)["level"] = 14
	data["campaign_mode"] = "adventure"
	var adv: Dictionary = pm.adventure_state(data)
	for z: String in ["foret_ronces", "lisiere_col", "montagne_pics", "piemont_ocre", "desert_dunes", zone]:
		pm.adventure_unlock_zone(adv, z)
	pm.adventure_enter_zone(adv, zone)
	# Découvre une bonne partie de la carte, déplace le héros au centre
	var meta: Dictionary = pm.ADVENTURE_ZONES[zone]
	for y in range(int(meta["size"][1])):
		for x in range(int(meta["size"][0])):
			if x <= 7 or y == 3:
				adv["discovered"].append("%s,%d,%d" % [zone, x, y])
	adv["hero_pos"] = [4, 3]
	adv["journal"] = ["Arrivée : %s." % pm.adventure_zone_name(zone), "Coffre ouvert.", "Vous contournez l'embuscade."]
	gm.active_save = data
	gm.active_slot = 4
	var sc: Node = (load("res://scenes/AdventureMap.tscn") as PackedScene).instantiate()
	root.add_child(sc)
	await create_timer(1.5).timeout
	_shot(out + "/adv_map.png")
	# Énigme à choix
	var riddle_key: String = ""
	var runes_key: String = ""
	var lights_key: String = ""
	for k: String in pm.ADVENTURE_PUZZLES.keys():
		var t: String = String(pm.ADVENTURE_PUZZLES[k].get("type", "riddle"))
		if t == "riddle" and riddle_key == "":
			riddle_key = k
		elif t == "runes" and runes_key == "":
			runes_key = k
		elif t == "lights" and lights_key == "":
			lights_key = k
	sc._puzzle_riddle(riddle_key, pm.ADVENTURE_PUZZLES[riddle_key])
	await create_timer(0.6).timeout
	_shot(out + "/adv_riddle.png")
	sc._puzzle_runes(runes_key, pm.ADVENTURE_PUZZLES[runes_key])
	await create_timer(1.1).timeout
	_shot(out + "/adv_runes.png")
	sc._puzzle_lights(lights_key, pm.ADVENTURE_PUZZLES[lights_key])
	await create_timer(0.6).timeout
	_shot(out + "/adv_lights.png")
	var combat_poi: Dictionary = {}
	for k2: String in pm.ADVENTURE_POIS[zone].keys():
		if String(pm.ADVENTURE_POIS[zone][k2]["kind"]) == "combat":
			combat_poi = pm.ADVENTURE_POIS[zone][k2]
			break
	sc._confirm_combat(combat_poi)
	await create_timer(0.6).timeout
	_shot(out + "/adv_combat.png")
	sc._show_event({"kind": "ambush", "title": "Embuscade de gobelins", "text": "Des ennemis surgissent des fourrés ! Les affronter rapporte XP et butin ; vous pouvez aussi les contourner.", "level": 11})
	await create_timer(0.6).timeout
	_shot(out + "/adv_event.png")
	sc._close_modal()
	# Passage de frontière : héros sur la porte est (ou la première porte), clés acquises
	var gates: Dictionary = pm.adventure_gates(zone)
	if not gates.is_empty():
		var gp: Vector2i = gates.keys()[0]
		for g: Vector2i in gates.keys():
			if String(gates[g]["dir"]) == "E":
				gp = g
		for z2: String in pm.ADVENTURE_ZONES.keys():
			adv["completed"].append("%s,%s" % [z2, String(pm.ADVENTURE_ZONES[z2].get("key_poi", ""))])
		adv["hero_pos"] = [gp.x, gp.y]
		sc._rebuild_world()
		sc._refresh_side()
		await create_timer(0.5).timeout
		_shot(out + "/adv_gate.png")
		sc._cross_gate(gp)
		await create_timer(0.3).timeout
		_shot(out + "/adv_fade.png")
		await create_timer(1.6).timeout
		_shot(out + "/adv_arrive.png")
	pm.delete_save(4)
	quit(0)

func _shot(path: String) -> void:
	root.get_viewport().get_texture().get_image().save_png(path)
	print("capture ", path)
