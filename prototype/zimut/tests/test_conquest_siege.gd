extends SceneTree

## Test du siège de conquête : villes adverses en 4 batailles (3 mobs + boss),
## villes neutres en 1 bataille, et reprise du siège après défaite.

var fails: int = 0

func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1

func _init() -> void:
	_boot.call_deferred()

func _boot() -> void:
	var pm: Node = root.get_node("ProgressionManager")
	# Ville neutre : 1 victoire suffit
	var d: Dictionary = pm.new_game(4, "Siege1")
	d["campaign_mode"] = "conquest"
	d["conquest"] = {"owned": ["capitale"], "pending_city": "clairiere", "pending_level": 10}
	pm.register_victory(d, {"enemies": [{"type": "Gobelin", "level": 10, "boss": false}]})
	var cq: Dictionary = d.get("conquest", {})
	check(cq.get("owned", []).has("clairiere"), "ville NEUTRE : conquise en 1 bataille")
	check(String(cq.get("pending_city", "x")) == "", "pending_city réinitialisé après prise")

	# Ville adverse : siège en 4 batailles
	var d2: Dictionary = pm.new_game(5, "Siege2")
	d2["campaign_mode"] = "conquest"
	d2["conquest"] = {"owned": ["capitale"], "pending_city": "vieille_tour", "pending_level": 12}
	pm.register_victory(d2, {"enemies": [{"type": "Gobelin", "level": 12, "boss": false}]})
	var cq2: Dictionary = d2.get("conquest", {})
	check(not cq2.get("owned", []).has("vieille_tour"), "ville ADVERSE : pas conquise après 1 bataille")
	check(int(cq2.get("sieges", {}).get("vieille_tour", 0)) == 1, "siège progressé à 1/4")
	check(String(cq2.get("pending_city", "")) == "vieille_tour", "la ville reste la cible du siège")
	check(pm.conquest_siege_is_boss(cq2, "vieille_tour") == false, "bataille 2 : pas encore le boss")
	# vagues suivantes
	var waves: Array = []
	for i: int in range(3):
		pm.register_victory(d2, {"enemies": [{"type": "Gobelin", "level": 12, "boss": false}]})
		cq2 = d2.get("conquest", {})
		waves.append(pm.conquest_siege_is_boss(cq2, "vieille_tour"))
	check(waves == [false, true, false], "vagues du siège : mobs, mobs, BOSS, prise") 
	check(cq2.get("owned", []).has("vieille_tour"), "ville ADVERSE conquise après 4 victoires")
	check(not cq2.get("sieges", {}).has("vieille_tour"), "siège effacé après la prise")

	# Défaite : le siège ne progresse pas mais est conservé
	var d3: Dictionary = pm.new_game(6, "Siege3")
	d3["campaign_mode"] = "conquest"
	d3["conquest"] = {"owned": ["capitale"], "pending_city": "fort_racine", "pending_level": 14, "sieges": {"fort_racine": 2}}
	pm.register_defeat(d3, {"enemies": [{"type": "Troll", "level": 14, "boss": true}]})
	var cq3: Dictionary = d3.get("conquest", {})
	check(int(cq3.get("sieges", {}).get("fort_racine", 0)) == 2, "défaite : progression du siège conservée (2/4)")
	check(String(cq3.get("pending_city", "")) == "fort_racine", "défaite : la cible est conservée")

	# Vague de la reprise : la 3e bataille après 2 victoies = mobs, la 4e = boss
	check(pm.conquest_siege_wave(cq3, "fort_racine") == 3, "reprise du siège : prochaine vague 3/4")
	check(pm.conquest_siege_is_boss(cq3, "fort_racine") == false, "vague 3 : pas le boss")
	print("== TOUS OK ==" if fails == 0 else "== %d ÉCHECS ==" % fails)
	quit(0 if fails == 0 else 1)
