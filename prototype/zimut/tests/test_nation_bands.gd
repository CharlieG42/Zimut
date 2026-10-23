extends SceneTree
## test_nation_bands.gd — tranches de niveaux par nation (V43).
## godot --headless --script tests/test_nation_bands.gd --path .
var failures: int = 0
func _init() -> void:
	_boot.call_deferred()
func _check(c: bool, l: String) -> void:
	if c:
		print("  ok  %s" % l)
	else:
		failures += 1
		print("  KO  %s" % l)
func _boot() -> void:
	var pm: Node = root.get_node("/root/ProgressionManager")
	var nations: GDScript = load("res://scripts/Nations.gd")
	var mobs: GDScript = load("res://scripts/AdventureMobs.gd")
	print("Tranches par nation :")
	var bands: Dictionary = nations.LEVEL_BANDS
	var prev_max: int = 0
	var contiguous: bool = true
	for b: String in ["Forêt", "Brasier", "Brumes", "Montagne", "Vents", "Ombres", "Désert", "Marées", "Cristaux", "Rouages", "Donjon"]:
		var r: Array = bands[b]
		if int(r[0]) != prev_max + 1 or int(r[1]) < int(r[0]):
			contiguous = false
		prev_max = int(r[1])
	_check(contiguous, "tranches contiguës, sans chevauchement")
	_check(prev_max == 100, "la dernière tranche finit au niveau 100")
	_check(nations.biome_for_level(1) == "Forêt" and nations.biome_for_level(60) == "Ombres" and nations.biome_for_level(100) == "Donjon", "biome_for_level")
	print("Cartes d'Aventure :")
	for zone: String in pm.ADVENTURE_ZONES.keys():
		var biome: String = String(pm.ADVENTURE_ZONES[zone]["biome"])
		var band: Vector2i = nations.level_band(biome)
		var rg: Vector2i = mobs.level_range(zone)
		_check(rg.x >= band.x and rg.y <= band.y, "%s : monstres %d-%d dans la tranche %s %d-%d" % [zone, rg.x, rg.y, biome, band.x, band.y])
		var pois: Dictionary = pm.ADVENTURE_POIS.get(zone, {})
		var ok: bool = true
		for k: String in pois.keys():
			var l: int = int(pois[k].get("level", 1))
			if l < band.x or l > band.y:
				ok = false
		_check(ok, "%s : niveaux des lieux dans la tranche" % zone)
	print("")
	if failures > 0:
		print("ÉCHEC : %d test(s) en erreur." % failures)
		quit(1)
	else:
		print("OK : tous les tests passent.")
		quit(0)
