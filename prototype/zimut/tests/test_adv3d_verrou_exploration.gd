extends SceneTree
## V456 : Aventure 3D — donjons verrouillés représentés autrement + progression de découverte.
var fails := 0
func ck(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c: fails += 1

func _init() -> void:
	_run.call_deferred()

func _run() -> void:
	var gm: Node = root.get_node("GameManager")
	var pm: Node = root.get_node("ProgressionManager")
	root.get_node("GameSettings").adventure_models_3d = false
	var d: Dictionary = pm.new_game(4, "Test")
	d["campaign_mode"] = "adventure"
	d["adventure"] = pm.call("adventure_state", d)
	d["adventure_view"] = "open3d"
	gm.active_slot = 4
	gm.active_save = d
	var scene: Node = (load("res://scenes/AdventureOpen3D.tscn") as PackedScene).instantiate()
	root.add_child(scene)
	await process_frame
	await process_frame
	var p0: Dictionary = pm.adventure_zone_progress(scene.manager.state, scene.zone_id)
	ck(int(p0["total"]) > 0 and int(p0["done"]) == 0 and int(p0["pct"]) == 0, "progression de départ 0/%d" % int(p0["total"]))
	# marqueur verrouillé : pas de gemme ni de pulsation, mais un cadenas
	var m_open: Node3D = Adv3DActors.make_poi_marker("dungeon", "A", false, "Nouveau", false)
	var m_lock: Node3D = Adv3DActors.make_poi_marker("dungeon", "B", false, "🔒 Verrouillé", true)
	ck(m_open.get_node_or_null("Gem") != null and m_open.get_node_or_null("Pulse") != null, "donjon ouvert : gemme + pulsation")
	ck(m_lock.get_node_or_null("Gem") == null and m_lock.get_node_or_null("Pulse") == null, "donjon verrouillé : ni gemme ni pulsation")
	ck(m_lock.get_child_count() > 4, "donjon verrouillé : cadenas/chaînes présents")
	# la mini-carte reçoit l'indicateur « locked »
	scene._refresh_minimap_markers()
	var n_locked := 0
	for p: Dictionary in scene._minimap._pois:
		if bool(p.get("locked", false)): n_locked += 1
	ck(n_locked > 0, "mini-carte : %d donjon(s) marqué(s) verrouillé(s)" % n_locked)
	ck(scene._minimap_badge != null and scene._minimap_badge.text.contains("%"), "badge d'exploration sous la mini-carte : « %s »" % scene._minimap_badge.text)
	# complétion d'un lieu → progression qui monte
	var key: String = String(pm.pois_of(scene.zone_id).keys()[0])
	pm.adventure_complete_poi(scene.manager.state, key, "")
	var p1: Dictionary = pm.adventure_zone_progress(scene.manager.state, scene.zone_id)
	ck(int(p1["done"]) == 1 and int(p1["pct"]) > 0, "un lieu accompli → %d/%d (%d %%)" % [p1["done"], p1["total"], p1["pct"]])
	# carte plein écran : bandeau + barre
	scene._open_full_map()
	ck(scene._full_map_prog_lbl != null and scene._full_map_prog_lbl.text.contains("Exploration"), "carte plein écran : « %s »" % scene._full_map_prog_lbl.text)
	scene._toggle_full_map_tab()
	ck(scene._full_map_prog_lbl.text.contains("Monde"), "onglet Monde : « %s »" % scene._full_map_prog_lbl.text)
	scene._close_modal()
	print("FIN – %d échec(s)" % fails)
	quit(1 if fails > 0 else 0)
