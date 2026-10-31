extends SceneTree
## Test V61b : sprites de bâtiments de la vue de ville Conquête (chemins + repli vectoriel).
var fails: int = 0
func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var base := "res://assets/ui/conquest/cities/batiments"
	# Convention des chemins : niveau en suffixe, caserne/résidence/merveille sans suffixe
	check(ConquestCityView.sprite_path("sylvestre", "hall", 3) == base + "/sylvestre/hall_3.png",
		"sprite_path : hall de niveau 3 → hall_3.png")
	check(ConquestCityView.sprite_path("cimes", "caserne", 0) == base + "/cimes/caserne.png",
		"sprite_path : caserne sans suffixe")
	check(ConquestCityView.sprite_path("sables", "mine", 2) == base + "/sables/mine_2.png",
		"sprite_path : mine de niveau 2 → mine_2.png")
	check(ConquestCityView.sprite_path("rouages", "merveille", 0) == base + "/rouages/merveille.png",
		"sprite_path : merveille sans suffixe")
	# Couverture : chaque biome stylé a une clé de nation, et réciproquement
	var seen := {}
	for biome: String in ConquestCityView.STYLE.keys():
		check(ConquestCityView.NATION_KEY.has(biome), "NATION_KEY couvre le biome « %s »" % biome)
	for biome: String in ConquestCityView.NATION_KEY.keys():
		check(ConquestCityView.STYLE.has(biome), "STYLE couvre le biome « %s »" % biome)
		seen[ConquestCityView.NATION_KEY[biome]] = true
	check(seen.size() == ConquestCityView.NATION_KEY.size(), "une seule clé de dossier par nation (pas de doublon)")
	# SPRITE_WIDTH couvre chaque parcelle de la vue (hall, caserne, résidence, merveille, production)
	var sprite_of := {"barracks": "caserne", "wonder": "merveille"}
	for plot: String in ConquestCityView.PLOTS.keys():
		var sk: String = String(sprite_of.get(plot, plot))
		check(ConquestCityView.SPRITE_WIDTH.has(sk), "SPRITE_WIDTH couvre la parcelle « %s » (sprite « %s »)" % [plot, sk])
	# Repli : sans PNG découpé, _sprite renvoie null → la vue dessine en vectoriel
	var v := ConquestCityView.new()
	v.biome = "Forêt"
	check(v._sprite("hall", 99) == null, "repli vectoriel : pas de hall_99.png → null")
	check(v._sprite("caserne", 0) == null, "repli vectoriel : pas de caserne.png → null")
	v.free()
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
