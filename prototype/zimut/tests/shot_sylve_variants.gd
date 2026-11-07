extends SceneTree
## V114 — Captures in-engine des deux variantes de la carte 2D Sylve (v2 enrichie / iso test).
## Nécessite un écran virtuel (le rendu headless ne produit pas de pixels) :
##   xvfb-run -a godot --rendering-method gl_compatibility --path . -s tests/shot_sylve_variants.gd -- <dossier>
## Produit : sylve_v2.png (carte complète), sylve_v2_zoom.png, sylve_iso.png, sylve_iso_zoom.png
func _init() -> void:
	_boot.call_deferred()

func _shot(path: String) -> void:
	root.get_viewport().get_texture().get_image().save_png(path)
	print("capture ", path)

func _boot() -> void:
	var args: PackedStringArray = OS.get_cmdline_user_args()
	var out: String = args[0] if args.size() > 0 else "/tmp"
	var zone: String = "foret_sylve"
	var pm: Node = root.get_node("/root/ProgressionManager")
	var gm: Node = root.get_node("/root/GameManager")
	var gs: Node = root.get_node("/root/GameSettings")
	var data: Dictionary = pm.new_game(4, "ShotSylveV114")
	pm.rebuild_team(data, ["Chasseur", "Mage", "Sylvain"])
	for c in ["Chasseur", "Mage", "Sylvain"]:
		pm.roster_entry(data, c)["level"] = 14
	data["campaign_mode"] = "adventure"
	var adv: Dictionary = pm.adventure_state(data)
	pm.adventure_unlock_zone(adv, zone)
	pm.adventure_enter_zone(adv, zone)
	# découvre une grande partie de la carte et place le héros au départ
	var meta: Dictionary = pm.ADVENTURE_ZONES[zone]
	for y in range(int(meta["size"][1])):
		for x in range(int(meta["size"][0])):
			if x <= 10 or y == int(meta["start"][1]):
				adv["discovered"].append("%s,%d,%d" % [zone, x, y])
	adv["hero_pos"] = meta["start"]
	gm.active_save = data
	gm.active_slot = 4

	# --- Variante v2 (défaut) ---
	gs.set_sylvestre_board("v2")
	var sc: Node = (load("res://scenes/AdventureMap.tscn") as PackedScene).instantiate()
	root.add_child(sc)
	await create_timer(1.5).timeout
	_shot(out + "/sylve_v2.png")
	sc._focus_cell(Vector2i(int(meta["start"][0]), int(meta["start"][1])), false)
	await create_timer(0.8).timeout
	_shot(out + "/sylve_v2_zoom.png")

	# --- Variante iso (test) ---
	gs.set_sylvestre_board("iso")
	sc._rebuild_world()
	sc._refresh_world()
	sc._refresh_side()
	sc._fit_world.call_deferred()
	await create_timer(1.5).timeout
	_shot(out + "/sylve_iso.png")
	sc._focus_cell(Vector2i(56, 41), true, 0.1)   # puits près du départ
	await create_timer(0.8).timeout
	_shot(out + "/sylve_iso_zoom.png")
	pm.delete_save(4)
	quit(0)
