extends SceneTree
## Cartes de nations : 40 créatures (10 nations), sprites présents, punchlines FR/EN, noms anglais, langue.
var fails: int = 0
func check(ok: bool, label: String) -> void:
	if ok:
		print("  ok  ", label)
	else:
		fails += 1
		print("  ÉCHEC  ", label)

func _initialize() -> void:
	var nations: Dictionary = {}
	var n_new: int = 0
	for id: String in JccCards.all_ids():
		var c: Dictionary = JccCards.get_card(id)
		if id.begins_with("n_"):
			n_new += 1
			nations[String(c["nation"])] = int(nations.get(String(c["nation"]), 0)) + 1
			check(FileAccess.file_exists("res://assets/sprites/%s.png" % String(c["sprite"])), "sprite présent : %s" % id)
			check(String(c["sort"]) != "" and String(c["effet"]) != "", "sort défini : %s" % id)
			check(String(c["name_en"]) != "", "nom anglais : %s" % id)
			var budget: int = int(c["atk"]) + int(c["hp"])
			check(budget >= 2 * int(c["cost"]) - 1 and budget <= 2 * int(c["cost"]) + 5, "stats raisonnables %s (%d pour %d mana)" % [id, budget, int(c["cost"])])
			if String(c["effet"]) == "invoquer":
				check(not JccCards.get_card(String(c["valeur"])).is_empty(), "jeton existant : %s" % id)
		if String(c["type"]) in ["Creature"]:
			check(String(c["flavor_fr"]) != "" and String(c["flavor_en"]) != "", "punchline FR/EN : %s" % id)
	check(n_new == 40, "40 cartes de nations (%d)" % n_new)
	check(nations.size() == 10, "10 nations représentées (%d)" % nations.size())
	for k: Variant in nations.keys():
		check(int(nations[k]) >= 3, "nation %s : %d cartes" % [String(k), int(nations[k])])
	TranslationServer.set_locale("fr")
	var d: Dictionary = JccCards.get_card("n_dryade")
	check(JccCards.display_name(d) == "Dryade" and JccCards.flavor(d).begins_with("Là où"), "français")
	TranslationServer.set_locale("en")
	check(JccCards.display_name(d) == "Dryad" and JccCards.flavor(d).begins_with("Where she walks"), "anglais")
	check(JccCards.display_name(JccCards.get_card("s_eclair")) == String(JccCards.get_card("s_eclair")["name"]), "sort sans nom anglais : repli français")
	check(JccCards.flavor(JccCards.get_card("s_eclair")) == "", "sort sans punchline")
	# effets en anglais : aucun texte français résiduel
	var fr_left: int = 0
	for cid: String in JccCards.all_ids():
		var cc: Dictionary = JccCards.get_card(cid)
		if String(cc.get("effet", "")) == "":
			continue
		var et: String = JccCards.effect_text(cc)
		if et == "" or et.contains("Inflige") or et.contains("Rend ") or et.contains("Invoque ") or et.contains(" créature") or et.contains("Pioche"):
			fr_left += 1
	check(fr_left == 0, "effets des cartes traduits en anglais (%d restants)" % fr_left)
	var lv: Dictionary = JccCards.get_card("n_dryade@3~P")
	check(String(lv["flavor_fr"]) == String(d["flavor_fr"]) and String(lv["nation"]) == "Sylvestre", "niveau/fortification gardent identité")
	# cartes de nations jouables en duel
	var di := JccDuel.new()
	var deck: Array = []
	for i in 20:
		deck.append("n_sylvin")
	di.setup(deck, deck.duplicate(), 3)
	check(not di.is_over(), "duel avec cartes de nations")
	print("NATIONS fails=", fails)
	quit(1 if fails > 0 else 0)
