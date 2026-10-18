extends SceneTree
## Succès et bestiaire (V18).
var fails := 0
func ck(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c: fails += 1
func _init() -> void:
	_run.call_deferred()
func _run() -> void:
	var pm: Node = root.get_node("ProgressionManager")
	var d: Dictionary = pm.new_game(4, "Succès")
	pm.rebuild_team(d, ["Tank", "Mage", "Heal"])
	var g0: int = int(d.get("gold", 0))
	pm.register_victory(d, {"enemies": [{"type": "Loup", "level": 1, "boss": false}], "turns": 3, "boss": false, "deaths": 0})
	ck(Achievements.is_unlocked(d, "premier_sang"), "Premier sang débloqué")
	ck(Achievements.is_unlocked(d, "sans_perte") and Achievements.is_unlocked(d, "eclair"), "sans perte + éclair")
	ck((d.get("last_achievements", []) as Array).size() >= 3, "succès listés pour l'écran de victoire")
	ck(int(d["resources"].get("Cuir@2", 0)) >= 2, "récompense en ressources de rang 2")
	ck(not Achievements.is_unlocked(d, "veteran"), "Vétéran pas encore")
	var nb: int = (d.get("achievements", {}) as Dictionary).size()
	Achievements.check(d)
	ck((d.get("achievements", {}) as Dictionary).size() == nb, "pas de double déblocage")
	var en := {"team": "enemy", "name": "Loup forestier Lv3", "classe": "Loup", "level": 3, "max_pv": 120, "force": 20, "defense": 5, "max_pm": 3, "spells": [{"name": "Morsure"}]}
	Achievements.bestiary_seen(d, en, "Forêt")
	Achievements.bestiary_kill(d, en)
	var f: Dictionary = d["bestiary"].get("Loup forestier", {})
	ck(int(f.get("seen", 0)) == 1 and int(f.get("killed", 0)) == 1 and int(f.get("level", 0)) == 3, "fiche de bestiaire")
	d["resources"]["Fer"] = 100
	d["gold"] = 1000
	var before: int = (d.get("achievements", {}) as Dictionary).size()
	var r: Dictionary = pm.craft_recipes()[0]
	d["resources"]["Bois"] = 100
	d["resources"]["Cuir"] = 100
	d["resources"]["Magie"] = 100
	d["resources"]["Venin"] = 100
	var err: String = pm.craft_item(d, String(r["name"]))
	ck(err == "" and Achievements.is_unlocked(d, "forgeron"), "Apprenti forgeron à la première fabrication (%s)" % err)
	pm.delete_save(4)
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
