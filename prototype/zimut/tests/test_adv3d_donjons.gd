extends SceneTree
## V452 : Aventure 3D — avancement des donjons (marqueur + fenêtre), verrouillage séquentiel, entrée facultative.
var fails := 0
func ck(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c: fails += 1

func _init() -> void:
	_run.call_deferred()

func _run() -> void:
	var gm: Node = root.get_node("GameManager")
	var pm: Node = root.get_node("ProgressionManager")
	var gs: Node = root.get_node("GameSettings")
	gs.adventure_models_3d = false
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
	# On cherche, dans la zone, un donjon de palier > 1 (donc verrouillé au départ) et un palier le plus bas.
	var pois: Dictionary = pm.pois_of(scene.zone_id)
	var low_key := ""; var high_key := ""
	var low_t := 99; var high_t := 0
	for k: String in pois.keys():
		var g: String = String(pois[k].get("guardian", ""))
		if g == "": continue
		var t: int = Dungeons.tier(g)
		if t < low_t: low_t = t; low_key = k
		if t > high_t: high_t = t; high_key = k
	ck(low_key != "", "la zone contient des donjons (palier le plus bas %d, le plus haut %d)" % [low_t, high_t])
	if low_key != "" and high_t > low_t:
		var il: Dictionary = scene._dungeon_info(pois[low_key])
		var ih: Dictionary = scene._dungeon_info(pois[high_key])
		ck(not bool(il["locked"]), "donjon de palier le plus bas : ouvert (%s)" % String(il["short"]))
		ck(bool(ih["locked"]), "donjon de palier supérieur : VERROUILLÉ au départ (%s)" % String(ih["short"]))
		ck(String(ih["short"]).begins_with("🔒"), "marqueur : 2e ligne « 🔒 Verrouillé »")
		# fenêtre de verrou
		scene._ask_dungeon(high_key, pois[high_key])
		ck(scene._modal_root != null, "contact d'un donjon verrouillé : fenêtre d'information (pas de combat)")
		scene._close_modal()
		# fenêtre d'entrée facultative sur un donjon ouvert
		scene._ask_dungeon(low_key, pois[low_key])
		ck(scene._modal_root != null, "contact d'un donjon ouvert : fenêtre « ENTRER / PLUS TARD »")
		get_root().get_viewport().get_texture()
		scene._close_modal()
		# avancement : salle 2/4 → affiché
		var gl: String = String(pois[low_key]["guardian"])
		Dungeons._set_room(scene.manager.state, gl, 2)
		ck(String(scene._dungeon_info(pois[low_key])["short"]) == "Salle 2/%d" % Dungeons.ROOMS, "avancement affiché : « Salle 2/%d »" % Dungeons.ROOMS)
	# Retour direct au monde depuis l'écran d'équipe
	var ts: Node = (load("res://scenes/TeamSelection.tscn") as PackedScene).instantiate()
	gm.active_save["adventure"]["pending_challenge"] = "foret_sylve,3,3"
	root.add_child(ts)
	await process_frame
	ck(ts._adventure_world_back(), "équipe d'un défi d'Aventure 3D : retour au monde proposé")
	gm.active_save["adventure"]["pending_challenge"] = ""
	ck(not ts._adventure_world_back(), "sans défi en cours : retour classique vers « Mes Parties »")
	print("FIN : %d échec(s)" % fails)
	quit(1 if fails > 0 else 0)
