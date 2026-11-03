extends SceneTree
## 4e mode « Monde Ouvert 3D » : scène présente, routage de la vue d'Aventure
## (adventure_view), sauvegarde partagée (héros/loots/XP), bucket de temps de
## jeu « openworld », déclenchement des combats monstre/donjon (pending_challenge).
var fails := 0
func ck(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c: fails += 1

func _find_btn(n: Node, txt: String) -> Button:
	if n is Button and String((n as Button).text) == txt:
		return n as Button
	for c: Node in n.get_children():
		var r: Button = _find_btn(c, txt)
		if r != null:
			return r
	return null

func _init() -> void:
	_run.call_deferred()

func _run() -> void:
	var gs: Node = root.get_node("GameSettings")
	var gm: Node = root.get_node("GameManager")
	var pm: Node = root.get_node("ProgressionManager")
	ck(gs != null and gm != null and pm != null, "autoloads présents")

	# La scène et son script existent et se chargent.
	ck(ResourceLoader.exists("res://scenes/AdventureOpen3D.tscn"), "scène AdventureOpen3D.tscn présente")
	ck(load("res://scripts/adventure3d/AdventureOpen3D.gd") != null, "script AdventureOpen3D.gd charge")
	ck(String(gs.ADVENTURE_SCENES.get("open3d", "")) == "res://scenes/AdventureOpen3D.tscn", "ADVENTURE_SCENES['open3d'] = AdventureOpen3D.tscn")

	# Routage adventure_scene() selon la vue mémorisée dans la partie active.
	gm.active_save = {}
	gs.set("adventure_3d", false)
	ck(String(gs.call("adventure_scene")) == "res://scenes/AdventureMap.tscn", "sans vue mémorisée + réglage carte → AdventureMap")
	gs.set("adventure_3d", true)
	ck(String(gs.call("adventure_scene")) == "res://scenes/Adventure3D.tscn", "sans vue mémorisée + réglage 3D → Adventure3D")
	gm.active_save = {"adventure_view": "open3d"}
	ck(String(gs.call("adventure_scene")) == "res://scenes/AdventureOpen3D.tscn", "vue open3d → retour de combat en monde ouvert")
	gm.active_save = {"adventure_view": "map"}
	ck(String(gs.call("adventure_scene")) == "res://scenes/AdventureMap.tscn", "vue map → AdventureMap")
	gm.active_save = {}
	gs.set("adventure_3d", false)

	# Le 4e mode partage la sauvegarde : campaign_mode adventure + vue open3d persistés ensemble.
	var d: Dictionary = pm.new_game(4, "OpenWorldTest")
	d["campaign_mode"] = "adventure"
	d["adventure"] = pm.call("adventure_state", d)
	d["adventure_view"] = "open3d"
	ck(pm.write_save(4, d), "écriture de la partie (slot 4)")
	var r: Dictionary = pm.load_save(4)
	ck(String(r.get("adventure_view", "")) == "open3d", "adventure_view persisté")
	ck(String(r.get("campaign_mode", "")) == "adventure", "campaign_mode = adventure (héros/loots/XP partagés)")
	ck(not (r.get("adventure", {}) as Dictionary).is_empty(), "état Aventure présent")
	ck(typeof(pm.mode_unlocked(r, "adventure")) == TYPE_BOOL, "mode_unlocked lisible sur la partie")

	# Temps de jeu : bucket propre au 4e mode, persisté.
	pm.add_playtime(4, r, "openworld", 125.0)
	ck(pm.playtime_mode(r, "openworld") == 125, "playtime_mode openworld = 125 s")
	ck(pm.playtime_total(r) == 125, "playtime total = 125 s")
	var r2: Dictionary = pm.load_save(4)
	ck(pm.playtime_mode(r2, "openworld") == 125, "openworld persisté sur disque")

	# Combat monstre depuis le monde ouvert : pending_challenge en « mob:zone:id ».
	gm.active_slot = 4
	gm.active_save = r
	var mgr: Node = Node.new()
	mgr.set_script(load("res://scripts/AdventureManager.gd"))
	root.add_child(mgr)
	mgr.call("load_state", r, 4)
	mgr.call("ensure_mobs")
	var mobs: Array = mgr.call("mobs")
	ck(not mobs.is_empty(), "groupes de monstres présents dans la zone")
	if not mobs.is_empty():
		var g: Dictionary = mobs[0]
		mgr.call("start_mob_combat", g)
		var st: Dictionary = mgr.get("state")
		ck(String(st.get("pending_challenge", "")).begins_with("mob:"), "start_mob_combat → pending_challenge « mob:… » (%s)" % String(st.get("pending_challenge", "")))
		ck(int(st.get("pending_count", 0)) >= 1, "pending_count renseigné (%d)" % int(st.get("pending_count", 0)))
		st.erase("pending_challenge")

	# Un donjon de Nation existe dans le catalogue et begin() ouvre la salle 1.
	var dungeon_zone: String = ""
	var dungeon_key: String = ""
	for zone: String in pm.ADVENTURE_POIS.keys():
		for k: String in pm.ADVENTURE_POIS[zone].keys():
			if String(pm.ADVENTURE_POIS[zone][k].get("guardian", "")) != "":
				dungeon_zone = zone
				dungeon_key = k
	ck(dungeon_key != "", "donjon présent dans le catalogue (%s %s)" % [dungeon_zone, dungeon_key])
	if dungeon_key != "":
		var poi: Dictionary = pm.ADVENTURE_POIS[dungeon_zone][dungeon_key]
		ck(Dungeons.is_dungeon(poi), "Dungeons.is_dungeon(poi) vrai")
		var adv: Dictionary = mgr.get("state")
		adv["zone"] = dungeon_zone
		var parts: PackedStringArray = dungeon_key.split(",")
		adv["hero_pos"] = [int(parts[0]), int(parts[1])]
		var res: Dictionary = mgr.call("interact")
		ck(String(res.get("action", "")) == "combat", "interact() sur le donjon → action combat (%s)" % String(res.get("action", "")))
		Dungeons.begin(adv, String(poi.get("guardian", "")))
		ck(Dungeons.current_room(adv, String(poi.get("guardian", ""))) == 1, "Dungeons.begin → salle 1/%d" % Dungeons.ROOMS)

	# V81 : monde par nations — 11 zones (10 nations + Donjon), grandes tailles, ≤ 2 portails,
	# POI générés en plus du catalogue (déterministes).
	ck(pm.ADVENTURE_ZONES.size() == 11, "11 zones : 10 nations + le Donjon (%d)" % pm.ADVENTURE_ZONES.size())
	var max_gates: int = 0
	for z: String in pm.ADVENTURE_ZONES.keys():
		max_gates = maxi(max_gates, pm.adventure_gates(z).size())
		var sz: Array = pm.ADVENTURE_ZONES[z].get("size", [14, 10])
		if String(pm.ADVENTURE_ZONES[z].get("biome", "")) != "Donjon":
			ck(int(sz[0]) >= 30 and int(sz[1]) >= 20, "%s : grande zone de nation %s" % [z, str(sz)])
	ck(max_gates <= 2, "au plus 2 portails par zone (max %d)" % max_gates)
	var pois_gen: Dictionary = pm.pois_of("foret_sylve")
	ck(pois_gen.size() > pm.ADVENTURE_POIS["foret_sylve"].size(),
		"POI générés en plus du catalogue : %d > %d" % [pois_gen.size(), pm.ADVENTURE_POIS["foret_sylve"].size()])
	ck(pm.pois_of("foret_sylve") == pois_gen, "pois_of déterministe (cache stable)")

	# V81 : scène du monde ouvert instanciée — caméra reculée, mini-carte ronde,
	# pop-up « combattre ou non », carte plein écran à onglets (instance + monde).
	gs = root.get_node("GameSettings")
	gs.adventure_models_3d = false
	var scene: Node = (load("res://scenes/AdventureOpen3D.tscn") as PackedScene).instantiate()
	root.add_child(scene)
	await process_frame
	await process_frame
	ck(scene.explorer != null, "scène open3d : explorateur présent")
	ck(scene.explorer.distance >= 9.0, "caméra reculée : distance %.1f (≥ 9 m)" % scene.explorer.distance)
	ck(scene._minimap != null and scene._minimap._tex_round != null, "mini-carte ronde : texture circulaire construite")
	ck(scene._minimap != null and scene._minimap.custom_minimum_size.x == scene._minimap.custom_minimum_size.y,
		"mini-carte carrée (affichée en rond)")
	var gates_n: int = scene.manager.gates().size()
	ck(gates_n >= 1 and gates_n <= 2, "foret_sylve : %d portail(s) (1-2 max)" % gates_n)
	# Rencontre avec un groupe → pop-up demandant si l'on veut battre
	var mobs2: Array = scene.manager.mobs()
	ck(not mobs2.is_empty(), "groupes de monstres présents dans la zone (%d)" % mobs2.size())
	if not mobs2.is_empty():
		var g0: Dictionary = mobs2[0]
		var mnode: Node3D = scene._mob_nodes[int(g0["id"])]
		scene._declined_mobs.clear()
		scene.explorer.place_at(Vector3(mnode.position.x, 0.0, mnode.position.z))
		await process_frame
		await process_frame
		ck(scene._modal_root != null, "rencontre : la pop-up s'ouvre (battre ou non ?)")
		var later: Button = _find_btn(scene._modal_root, "PLUS TARD")
		var fight: Button = _find_btn(scene._modal_root, "⚔  COMBATTRE")
		ck(later != null and fight != null, "pop-up : boutons « COMBATTRE » et « PLUS TARD »")
		if later != null:
			later.pressed.emit()
			ck(scene._modal_root == null and scene._declined_mobs.has(int(g0["id"])),
				"« PLUS TARD » ferme la fenêtre et laisse passer le groupe")
	# Carte plein écran : onglet instance (nation) + onglet monde (toutes les nations)
	scene._open_full_map()
	ck(scene._modal_root != null and scene._full_map_big != null, "carte plein écran : onglet instance ouvert")
	ck(scene._full_map_world != null and not scene._full_map_world.visible, "onglet monde présent (masqué au départ)")
	scene._toggle_full_map_tab()
	ck(scene._full_map_world.visible and not scene._full_map_big.visible, "bascule vers la carte du monde total")
	scene._toggle_full_map_tab()
	ck(scene._full_map_big.visible and not scene._full_map_world.visible, "retour à la carte de l'instance (nation)")
	scene._close_modal()
	ck(scene._modal_root == null, "la carte plein écran se ferme")
	scene.queue_free()
	await process_frame
	gs.adventure_models_3d = true

	mgr.queue_free()
	pm.delete_save(4)
	gm.active_save = {}
	gm.active_slot = -1
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
