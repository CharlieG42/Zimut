extends SceneTree
## V431 : la harpie en 3D (modèle Meshy sans squelette) — table des ennemis, profil statique, chargement, deck du niveau 1 du mode Cartes.
var fails: int = 0


func check(cond: bool, msg: String) -> void:
	if cond:
		print("ok  : ", msg)
	else:
		fails += 1
		print("KO  : ", msg)


func _init() -> void:
	_go.call_deferred()


func _go() -> void:
	var sq := {"classe": "Squelette", "team": "enemy"}
	check(Hero3D.model_key(sq, "Vents") == "Harpie", "Vents : un squelette ennemi est rendu par la harpie 3D")
	check(Hero3D.model_key({"classe": "Dragonnet", "team": "enemy"}, "Vents") == "Harpie", "Vents : le dragonnet aussi")
	check(Hero3D.model_key({"classe": "Loup", "team": "enemy"}, "Forêt") == "Harpie", "Forêt (bas niveau) : un loup ennemi est rendu par la harpie 3D")
	check(Hero3D.model_key({"classe": "Squelette", "team": "enemy"}, "Forêt") == "", "Forêt : les squelettes gardent leur sprite")
	check(Hero3D.model_key(sq, "Désert") == "" and Hero3D.model_key(sq) == "", "autres biomes et appel sans biome : aucun modèle")
	check(Hero3D.model_key({"classe": "Squelette", "team": "player"}, "Vents") == "", "un allié ne prend pas le modèle d'un ennemi")
	check(Hero3D.is_clip_model("Harpie"), "la harpie est un modèle à clips (durées fournies par le profil)")
	var prof: Dictionary = Hero3D.profile("Harpie")
	for an: String in ["idle", "walk", "attack", "cast", "hit"]:
		var c: Dictionary = (prof["clips"] as Dictionary).get(an, {})
		check(c.has("dur") and c.has("loop") and c.has("key") and c.has("motion"), "clip « %s » complet (dur, loop, key, motion)" % an)
	check(ResourceLoader.exists(String(prof["path"])) and ResourceLoader.exists(String(prof["path_mobile"])), "les deux GLB (PC et mobile) sont présents")
	var h := Hero3D.new()
	root.add_child(h)
	check(h.setup("Harpie", 1.0), "chargement du modèle sans squelette")
	await process_frame
	# sans GPU (CI headless) le cadrage ne se termine pas : on vérifie le modèle et les poses sans attendre le rendu
	check(h._flap_mat != null and h._sk == null and h._ap == null, "modèle statique : matériau à battement d'ailes, ni squelette ni AnimationPlayer")
	h._set_pose("attack", 0.5, false)
	check(absf(h._holder.rotation_degrees.x - 16.0) < 0.01 and float(h._flap_mat.get_shader_parameter("flap")) < 1.01, "pose d'attaque : élan vers l'avant")
	h._set_pose("idle", 0.125, true)
	check(absf(absf(h._holder.rotation_degrees.y) - 180.0) < 0.01 and float(h._flap_mat.get_shader_parameter("flap")) > 0.5, "repos de dos : demi-tour et ailes levées")
	check(h._model.scale.y > 0.0 and absf(h._model.scale.y - h._model.scale.x) < 0.0001, "modèle normalisé (échelle uniforme)")
	# deck du premier adversaire du mode Cartes
	var d0: PackedStringArray = String((JccCollection.OPPONENTS[0] as Dictionary)["deck"]).split(" ")
	check(d0.size() == JccCollection.DECK_SIZE and d0.count("n_harpie") == 2, "niveau 1 du mode Cartes : deck de 20 cartes avec 2 harpies")
	var ok: bool = true
	for id: String in d0:
		if JccCards.get_card(id).is_empty():
			ok = false
	check(ok, "toutes les cartes du deck existent")
	check(ResourceLoader.exists("res://assets/sprites/cartes/n_harpie.png"), "illustration de la carte Harpie présente")
	print("FIN : ", fails, " échec(s)")
	quit(1 if fails > 0 else 0)
