extends SceneTree
## Objectifs de combat et synergies (V18).
var fails := 0
func ck(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c: fails += 1
func _init() -> void:
	_run.call_deferred()
func _run() -> void:
	var pm: Node = root.get_node("ProgressionManager")
	var d: Dictionary = pm.new_game(4, "Objectifs")
	pm.rebuild_team(d, ["Tank", "Mage", "Heal"])
	var o: Dictionary = pm.combat_objective(d)
	ck(not o.is_empty() and o.has("label") and o.has("reward_text"), "objectif proposé : %s" % String(o.get("label", "")))
	ck(pm.combat_objective(d) == o, "objectif stable avant le combat")
	d["campaign_mode"] = "conquest"
	ck(pm.combat_objective(d).is_empty(), "pas d'objectif en Conquête (défis propres)")
	d["campaign_mode"] = ""
	var obj := {"kind": "flawless", "label": "x", "gold": 50, "resources": {"Fer@2": 1}, "reward_text": "+50 or"}
	var g0: int = int(d.get("gold", 0))
	pm.register_victory(d, {"enemies": [{"type": "Loup", "level": 1, "boss": false}], "turns": 6, "boss": false, "deaths": 0, "objective": obj})
	var ro: Dictionary = d["last_result"].get("objective", {})
	ck(bool(ro.get("success", false)), "objectif « sans K.O. » réussi")
	ck(int(d["resources"].get("Fer@2", 0)) >= 1, "récompense versée")
	ck(Achievements.stat(d, "objectives") == 1, "compteur d'objectifs")
	var obj2 := {"kind": "swift", "label": "y", "gold": 50, "resources": {"Fer@2": 1}, "reward_text": ""}
	pm.register_victory(d, {"enemies": [{"type": "Loup", "level": 1, "boss": false}], "turns": 9, "boss": false, "deaths": 0, "objective": obj2})
	ck(not bool(d["last_result"]["objective"].get("success", true)), "objectif « rapide » manqué en 9 tours")
	var syn: Array = pm.active_synergies(["Tank", "Heal", "Mage"])
	ck(syn.size() == 2, "Tank+Heal et Tank+Mage actives (%d)" % syn.size())
	ck(pm.active_synergies(["Assassin", "Heal", "Sylvain"]).is_empty(), "pas de synergie sans duo")
	pm.delete_save(4)
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
