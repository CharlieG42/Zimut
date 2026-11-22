extends SceneTree
## Mode Cartes : succès de collection (paliers, or unique, fusions comptées).
var fails: int = 0
func check(ok: bool, label: String) -> void:
	if ok:
		print("  ok  ", label)
	else:
		fails += 1
		print("  ÉCHEC  ", label)

func _initialize() -> void:
	var ids := {}
	for a: Variant in JccCollection.ACHIEVEMENTS:
		check(not ids.has(a["id"]), "id unique : " + String(a["id"]))
		ids[a["id"]] = true
	var save: Dictionary = {"gold": 0}
	JccCollection.ensure(save)
	var r0: Array = JccCollection.check_achievements(save)
	check(JccCollection.achievement_value(save, "wins") == 0, "0 victoire au départ")
	var n_start: int = r0.size()
	save["jcc"]["wins"] = 1
	var r1: Array = JccCollection.check_achievements(save)
	check(r1.size() == 1 and r1[0]["id"] == "win1" and int(save["gold"]) >= 50, "1re victoire : succès + or")
	check(JccCollection.check_achievements(save).is_empty(), "or accordé une seule fois")
	var g: int = int(save["gold"])
	save["jcc"]["wins"] = 10
	check(JccCollection.check_achievements(save).size() == 1 and int(save["gold"]) == g + 150, "10 victoires : Duelliste +150 or")
	# fusion comptée
	var key := ""
	for k: Variant in save["jcc"]["collection"]:
		if JccCollection.can_fuse(save, String(k)):
			key = String(k)
			break
	check(key != "", "une fusion est possible avec la collection de départ")
	var res: String = JccCollection.fuse(save, key)
	check(res != "" and JccCollection.achievement_value(save, "fusions") == 1, "fusion comptée")
	check(JccCollection.check_achievements(save).any(func(a: Dictionary) -> bool: return a["id"] == "fus1"), "succès Alchimiste")
	# cartes de nations / légendaires comptées
	var s2: Dictionary = {"gold": 0}
	JccCollection.ensure(s2)
	for id: String in JccCards.collectible_ids():
		JccCollection.add_card(s2, id)
	check(JccCollection.achievement_value(s2, "nations") >= 40, "toutes les cartes : 40 nations (%d)" % JccCollection.achievement_value(s2, "nations"))
	check(JccCollection.achievement_value(s2, "legend") >= 5, "toutes les cartes : >= 5 légendaires")
	check(JccCollection.achievement_value(s2, "distinct") >= 106, "toutes les cartes : 106 différentes (%d)" % JccCollection.achievement_value(s2, "distinct"))
	print("SUCCES (départ %d) fails=%d" % [n_start, fails])
	quit(1 if fails > 0 else 0)
