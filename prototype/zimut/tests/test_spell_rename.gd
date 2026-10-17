extends SceneTree
var fails := 0
func ck(c: bool, m: String) -> void:
	print(("  ok  " if c else "  FAIL ") + m)
	if not c: fails += 1
func _init() -> void:
	_run.call_deferred()
func _run() -> void:
	var pm: Node = root.get_node("ProgressionManager")
	var d: Dictionary = pm.new_game(4, "R")
	pm.rebuild_team(d, ["Invocateur", "Sylvain", "Tank", "Heal"])
	d["roster"]["Invocateur"]["spell_levels"] = {"Invoquer Tortue": 3, "Frappe spectrale": 2}
	d["roster"]["Invocateur"]["balance_note"] = ["Invoquer Loup"]
	pm.ensure_roster(d)
	var sl: Dictionary = d["roster"]["Invocateur"]["spell_levels"]
	ck(sl.get("Invoquer Golem de Pierre", 0) == 3 and not sl.has("Invoquer Tortue"), "niveau de sort migré")
	ck(sl.get("Frappe spectrale", 0) == 2, "autres sorts intacts")
	ck(d["roster"]["Invocateur"]["balance_note"][0] == "Invoquer Loup Spectral", "tableaux migrés")
	for n in ["Golem de Pierre", "Loup Spectral", "Requin des Marées", "Élémentaire de Cristal", "Ombre", "Esprit de la Forêt", "Archer Sylvestre", "Ent de Combat"]:
		ck(Combat.SUMMONS.has(n), "SUMMONS : " + n)
		ck(ResourceLoader.exists("res://assets/sprites/summons/%s.png" % EntityView.sprite_key(n)), "sprite : " + n)
	pm.delete_save(4)
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
