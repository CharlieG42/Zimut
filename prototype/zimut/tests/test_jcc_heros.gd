extends SceneTree
## Choix du héros : candidats, bonus de début (PV/mana/pioche), bonus par tour, UI.
const CO := preload("res://scripts/JccCollection.gd")
const DD := preload("res://scripts/JccDuel.gd")
var fails: int = 0
func check(ok: bool, label: String) -> void:
	if ok:
		print("  ok  ", label)
	else:
		fails += 1
		print("  ÉCHEC  ", label)

func _deck() -> Array:
	var d: Array = []
	for i in 20:
		d.append("m_gobelin")
	return d

func _initialize() -> void:
	root.size = Vector2i(1920, 1080)
	var save: Dictionary = {}
	CO.ensure(save)
	var cands: Array = CO.hero_candidates(save)
	check(not cands.is_empty() and cands.size() < DD.HERO_BONUS.size(), "candidats = héros possédés seulement (%d)" % cands.size())
	check(not CO.set_hero(save, "b_dragon"), "boss non possédé refusé")
	CO.add_card(save, "b_troll_geant")
	check(CO.set_hero(save, "b_troll_geant") and CO.active_hero(save) == "b_troll_geant", "boss possédé choisi")
	check(CO.hero_power_key("b_troll_geant") == "boss_hero" and CO.hero_power_key("c_mage") == "Mage", "clé de pouvoir")
	# début de duel : PV / mana / pioche
	var d1 = DD.new()
	d1.setup(_deck(), _deck(), 7, ["Tank", ""], ["c_tank", ""])
	check(int(d1.sides[0]["hero_hp"]) == DD.HERO_HP + 4 and int(d1.sides[1]["hero_hp"]) == DD.HERO_HP, "Tank : +4 PV")
	var d2 = DD.new()
	d2.setup(_deck(), _deck(), 7, ["Chasseur", ""], ["c_chasseur", ""])
	check(int(d2.sides[0]["hero_hp"]) == DD.HERO_HP + 3, "Chasseur : +3 PV")
	var d2b = DD.new()
	d2b.setup(_deck(), _deck(), 7, ["Mage", ""], ["", ""])
	d2b.sides[0]["mana_max"] = 1
	var dm = DD.new()
	dm.hero_ids = ["", ""]
	check(DD.hero_bonus("b_colosse").has("turn") and int(DD.hero_bonus("b_colosse")["turn"]["every"]) == 2, "Colosse : bonus de mana par tour")
	var d3 = DD.new()
	d3.setup(_deck(), _deck(), 7, ["Mage", ""], ["c_mage", ""])
	var d0 = DD.new()
	d0.setup(_deck(), _deck(), 7, ["Mage", ""], ["", ""])
	check((d3.sides[0]["hand"] as Array).size() == (d0.sides[0]["hand"] as Array).size() + 1, "Mage : +1 carte au départ")
	# bonus par tour
	var d4 = DD.new()
	d4.setup(_deck(), _deck(), 7, ["boss_hero", ""], ["b_loup_alpha", ""])
	check(int(d4.sides[1]["hero_hp"]) == DD.HERO_HP, "Loup Alpha : rien au 1er tour")
	d4.end_turn(0)
	d4.end_turn(1)
	check(int(d4.sides[1]["hero_hp"]) == DD.HERO_HP, "Loup Alpha : rien au 2e tour")
	d4.end_turn(0)
	d4.end_turn(1)
	check(int(d4.sides[1]["hero_hp"]) == DD.HERO_HP - 1, "Loup Alpha : 1 dégât au début du 3e tour")
	var d5 = DD.new()
	d5.setup(_deck(), _deck(), 7, ["boss", ""], ["b_troll_geant", ""])
	d5.sides[0]["hero_hp"] = 10
	d5.end_turn(0)
	d5.end_turn(1)
	check(int(d5.sides[0]["hero_hp"]) == 12, "Troll : +2 PV un tour sur 2")
	var d6 = DD.new()
	d6.setup(_deck(), _deck(), 7, ["boss", ""], ["b_colosse", ""])
	d6.end_turn(0)
	d6.end_turn(1)
	var m_before: int = int(d6.sides[0]["mana"])
	check(m_before == int(d6.sides[0]["mana_max"]) + 1, "Colosse : +1 mana au 2e tour (%d)" % m_before)
	check(DD.hero_bonus_text("b_dragon") != "" and DD.hero_bonus_text("c_tank").begins_with("Début"), "textes de bonus")
	# UI
	var ui := CardHeroUI.new()
	root.add_child(ui)
	ui.open(save)
	await process_frame
	ui._selected = "c_mage"
	ui._refresh()
	await process_frame
	check(CO.set_hero(save, "c_mage") and CO.active_hero(save) == "c_mage", "choix du Mage")
	print("HEROS fails=", fails)
	quit(1 if fails > 0 else 0)
