extends SceneTree
var fails: int = 0
func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var gm: Node = root.get_node("GameManager")
	for b: String in ["Cristaux", "Marées", "Vents", "Brasier", "Brumes", "Ombres"]:
		check(BiomeEffects.has(b) and BiomeEffects.describe(b) != "", "%s : particularité décrite" % b)
		check(ResourceLoader.exists("res://assets/audio/nation_%s_combat.ogg" % Music.NATION_KEY[b]), "%s : musique de combat" % b)
		check(ResourceLoader.exists("res://assets/audio/nation_%s_explore.ogg" % Music.NATION_KEY[b]), "%s : musique d'exploration" % b)
	var e: Dictionary = {"fx": {}, "statuses": [], "max_pv": 200, "current_pv": 200}
	BiomeEffects.setup("Cristaux", [e])
	check(int(e["fx"]["mag_pct"]) == 15, "Cristaux : +15 % magie")
	var e2: Dictionary = {"fx": {"crit": 20}, "statuses": []}
	BiomeEffects.setup("Ombres", [e2])
	check(int(e2["fx"]["crit"]) == 32, "Ombres : +12 crit (cumul avec l'existant)")
	var e3: Dictionary = {"fx": {}, "statuses": []}
	BiomeEffects.setup("Brumes", [e3])
	check(Combat.status_value(e3, "dodge") == 12.0, "Brumes : 12 % d'esquive")
	check(BiomeEffects.pm_bonus("Vents", 1) == 1 and BiomeEffects.pm_bonus("Vents", 2) == 1, "Vents : +1 PM")
	check(BiomeEffects.pm_bonus("Marées", 1) == -1 and BiomeEffects.pm_bonus("Marées", 2) == 1, "Marées : alternance −1/+1 PM")
	check(BiomeEffects.pm_bonus("Forêt", 1) == 0, "Forêt : aucun effet")
	check(BiomeEffects.end_turn_damage("Brasier", {"max_pv": 200, "current_pv": 200}) == 4, "Brasier : 2 % des PV max")
	check(BiomeEffects.end_turn_damage("Brasier", {"max_pv": 200, "current_pv": 2}) == 1, "Brasier : jamais mortel")
	check(BiomeEffects.end_turn_damage("Forêt", {"max_pv": 200, "current_pv": 200}) == 0, "Forêt : pas de brûlure")
	# Combat réel en Brasier : les PV baissent à la fin du tour
	gm.fight_biome = "Brasier"
	gm.active_save = {}
	gm.init_grid()
	gm.init_entities()
	gm.fight_biome = "Brasier"
	gm.start_battle()
	var act: Dictionary = gm.active_entity
	var pv0: int = int(act["current_pv"])
	var pm_expected: int = int(act["max_pm"]) + 1 if false else -1
	gm.end_current_turn()
	await create_timer(0.5).timeout
	check(int(act["current_pv"]) < pv0 or int(act["current_pv"]) == 1, "Brasier en combat : brûlure en fin de tour (%d → %d)" % [pv0, int(act["current_pv"])])
	quit(1 if fails > 0 else 0)
