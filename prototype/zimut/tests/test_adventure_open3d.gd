extends SceneTree
## 4e mode « Monde Ouvert 3D » : scène présente, routage de la vue d'Aventure
## (adventure_view), sauvegarde partagée (héros/loots/XP), bucket de temps de
## jeu « openworld », déclenchement des combats monstre/donjon (pending_challenge).
var fails := 0
func ck(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c: fails += 1

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

	mgr.queue_free()
	pm.delete_save(4)
	gm.active_save = {}
	gm.active_slot = -1
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
