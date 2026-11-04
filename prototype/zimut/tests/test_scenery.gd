extends SceneTree
## Test : décor de contour (BattleScenery / SceneryOver / SceneryAmbient / BackdropFx) pour les 4 biomes.
var fails: int = 0
func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	for biome in ["Forêt", "Montagne", "Désert", "Donjon"]:
		var back := BattleScenery.new()
		var over := SceneryOver.new()
		var amb := SceneryAmbient.new()
		root.add_child(back)
		root.add_child(over)
		root.add_child(amb)
		back.configure(8, biome, 7)
		over.configure(8, biome, 7)
		amb.configure(8, biome, 7)
		var bd := BackdropFx.new()
		root.add_child(bd)
		bd.configure(biome)
		await process_frame
		await process_frame
		check(back.get_child_count() >= 24, "%s : rebord surélevé généré (%d éléments)" % [biome, back.get_child_count()])
		check(is_instance_valid(over) and is_instance_valid(amb) and is_instance_valid(bd), "%s : couches de lèvre / ambiance / fond créées" % biome)
		check(amb.particle_count() == maxi(12, roundi(34.0 * clampf(GfxQuality.density(), 0.35, 1.0))),
			"%s : densité de particules adaptée au réglage graphique" % biome)
		# reconfiguration (changement de biome en cours de partie) : pas de fuite de nœuds
		var before: int = back.get_child_count()
		back.configure(8, biome, 7)
		await process_frame
		check(back.get_child_count() <= before + 2, "%s : reconfiguration sans doublon" % biome)
		back.queue_free(); over.queue_free(); amb.queue_free(); bd.queue_free()
	# déterminisme : même graine = même décor
	var a := BattleScenery.new()
	var b := BattleScenery.new()
	root.add_child(a)
	root.add_child(b)
	a.configure(8, "Forêt", 99)
	b.configure(8, "Forêt", 99)
	await process_frame
	check(a.get_child_count() == b.get_child_count(), "décor déterministe pour une même graine")
	# la forêt a bien l'arche, la rivière (cascade) et un rebord à deux terrasses
	var kinds: Array = []
	for c in a.get_children():
		kinds.append(String(c.get("kind")))
	check(kinds.has("ruin_arch"), "forêt : arche en ruine présente")
	# Chaque biome a son monument signature (parité avec la forêt)
	var feats: Dictionary = {"Forêt": "ruin_arch", "Montagne": "ice_portal", "Désert": "obelisk", "Donjon": ""}
	for fb: String in feats.keys():
		if String(feats[fb]) == "":
			continue
		var fsc := BattleScenery.new()
		root.add_child(fsc)
		fsc.configure(8, fb, 7)
		await process_frame
		var fkinds: Array = []
		for fc in fsc.get_children():
			fkinds.append(String(fc.get("kind")))
		check(fkinds.has(String(feats[fb])), "%s : monument %s présent" % [fb, feats[fb]])
		fsc.queue_free()
	var water_cnt: int = 0
	for c in a.get_children():
		if c.get("water") == true:
			water_cnt += 1
	check(water_cnt >= 3, "forêt : rivière sur le rebord (%d blocs d'eau)" % water_cnt)
	# Profils d’ambiance des Nations : ils doivent rester distincts et pilotés par Nations.gd.
	var nation_profiles: Dictionary = {"Marées": "bubble", "Vents": "wind", "Brasier": "ember",
		"Brumes": "fog", "Ombres": "motes", "Rouages": "ember"}
	for nation: String in nation_profiles.keys():
		check(Nations.ambient(nation) == String(nation_profiles[nation]),
			"%s : profil d’ambiance dédié conservé" % nation)
	var nation_ambient := SceneryAmbient.new()
	root.add_child(nation_ambient)
	for nation: String in nation_profiles.keys():
		nation_ambient.configure(8, nation, 17)
		check(nation_ambient.particle_count() > 0, "%s : particules générées" % nation)
	nation_ambient.queue_free()
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
