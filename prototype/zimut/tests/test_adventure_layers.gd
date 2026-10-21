extends SceneTree
## Étages du monde d'Aventure : ciel (Vents, Brumes), surface, profondeurs (Ombres, Cristaux, Brasier).
## Lancement : godot --headless --path . -s tests/test_adventure_layers.gd
var fails: int = 0
func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var pm: Node = root.get_node("ProgressionManager")
	for b: String in ["Vents", "Brumes"]:
		check(pm.adventure_biome_layer(b) == 1, "%s : ciel" % b)
	for b: String in ["Ombres", "Cristaux", "Brasier"]:
		check(pm.adventure_biome_layer(b) == -1, "%s : profondeurs" % b)
	check(pm.adventure_biome_layer("Forêt") == 0, "Forêt : surface")
	var ups: int = 0
	var downs: int = 0
	for z: String in pm.ADVENTURE_ZONES.keys():
		var l: int = pm.adventure_zone_layer(z)
		check(l >= -1 and l <= 1, "%s : étage valide (%d)" % [z, l])
		for d in ["N", "E", "S", "W"]:
			var n: String = pm.adventure_neighbor(z, d)
			if n == "":
				continue
			var info: Dictionary = pm.adventure_climb_info(z, n)
			var back: Dictionary = pm.adventure_climb_info(n, z)
			var dl: int = pm.adventure_zone_layer(n) - l
			check(int(info["climb"]) == dl, "%s→%s : climb %d" % [z, n, dl])
			check(int(info["climb"]) == -int(back["climb"]), "%s↔%s : sens inverse" % [z, n])
			check((info["label"] != "") == (dl != 0), "%s→%s : libellé seulement si changement d'étage" % [z, n])
			if dl > 0:
				ups += 1
			elif dl < 0:
				downs += 1
	check(ups > 0 and downs > 0, "le monde contient des montées et des descentes")
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
