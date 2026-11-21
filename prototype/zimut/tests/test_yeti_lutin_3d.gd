extends SceneTree
## V435 : yéti (Montagne) et lutin des spores (Forêt) en 3D — modèles Meshy texturés par projection, sans squelette ni battement d'ailes.
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
	check(Hero3D.model_key({"classe": "Troll", "team": "enemy"}, "Montagne") == "Yeti", "Montagne : un troll ennemi est rendu par le yéti 3D")
	check(Hero3D.model_key({"classe": "Gobelin", "team": "enemy"}, "Forêt") == "Lutin", "Forêt : un gobelin ennemi est rendu par le lutin des spores 3D")
	check(Hero3D.model_key({"classe": "Loup", "team": "enemy"}, "Forêt") == "Harpie", "Forêt : le loup garde la harpie (essai V431)")
	check(Hero3D.model_key({"classe": "Troll", "team": "enemy"}, "Désert") == "" and Hero3D.model_key({"classe": "Troll", "team": "enemy"}) == "", "autres biomes, ou sans biome : aucun modèle")
	check(Hero3D.model_key({"classe": "Troll", "team": "player"}, "Montagne") == "", "un allié ne prend pas le modèle d'un ennemi")
	check(Hero3D.model_key({"classe": "Troll", "team": "enemy", "boss": true, "title": "Vorkann le Givre"}, "Montagne") == "Vorkann", "le boss de la Montagne garde son propre modèle")
	for k: String in ["Yeti", "Lutin"]:
		var prof: Dictionary = Hero3D.profile(k)
		check(Hero3D.is_clip_model(k), "%s : modèle à clips" % k)
		for an: String in ["idle", "walk", "attack", "cast", "hit"]:
			var c: Dictionary = (prof["clips"] as Dictionary).get(an, {})
			check(c.has("dur") and c.has("loop") and c.has("key") and c.has("motion"), "%s : clip « %s » complet" % [k, an])
		check(ResourceLoader.exists(String(prof["path"])) and ResourceLoader.exists(String(prof["path_mobile"])), "%s : GLB PC et mobile présents" % k)
		var h := Hero3D.new()
		root.add_child(h)
		check(h.setup(k, 1.0), "%s : chargement" % k)
		await process_frame
		check(h._flap_mat != null and h._sk == null and h._ap == null, "%s : statique (ni squelette ni AnimationPlayer)" % k)
		h._set_pose("walk", 0.25, false)
		check(float(h._flap_mat.get_shader_parameter("flap")) == 0.0, "%s : aucun battement d'ailes en marche" % k)
		check(absf(h._holder.rotation_degrees.z) > 0.5, "%s : le corps se balance en marchant" % k)
		h._set_pose("attack", 0.5, false)
		check(absf(h._holder.rotation_degrees.x - 16.0) < 0.01, "%s : élan à l'attaque" % k)
		h._set_pose("idle", 0.0, true)
		check(absf(absf(h._holder.rotation_degrees.y) - 180.0) < 0.01, "%s : demi-tour de dos" % k)
		check(h._model.scale.y > 0.0 and absf(h._model.scale.y - h._model.scale.x) < 0.0001, "%s : échelle uniforme" % k)
		h.queue_free()
	print("FIN : ", fails, " échec(s)")
	quit(1 if fails > 0 else 0)
