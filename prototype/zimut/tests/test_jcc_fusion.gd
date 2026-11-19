extends SceneTree
## Atelier de fusion : niveaux, stats, coût, fusion, réparation de deck, duel avec carte niveau 5, UI.
const CO := preload("res://scripts/JccCollection.gd")
const CC := preload("res://scripts/JccCards.gd")
const DD := preload("res://scripts/JccDuel.gd")
var fails: int = 0

func check(ok: bool, label: String) -> void:
	if ok:
		print("  ok  ", label)
	else:
		fails += 1
		print("  ÉCHEC  ", label)

func _initialize() -> void:
	root.size = Vector2i(1920, 1080)
	var base: Dictionary = CC.get_card("m_gobelin")
	var l3: Dictionary = CC.get_card("m_gobelin@3")
	var l5: Dictionary = CC.get_card("m_gobelin@5")
	check(int(base["lvl"]) == 1 and int(l3["lvl"]) == 3, "niveaux lus")
	check(int(l3["atk"]) == int(base["atk"]) + 2 and int(l3["hp"]) == int(base["hp"]) + 2, "créature +1/+1 par niveau")
	check(int(l3["cost"]) == maxi(1, int(base["cost"]) - 1), "coût −1 au niveau 3")
	check(int(l5["cost"]) == maxi(1, int(base["cost"]) - 2), "coût −2 au niveau 5")
	var sp: Dictionary = CC.get_card("s_eclair")
	var sp3: Dictionary = CC.get_card("s_eclair@3")
	check(int(sp3["valeur"]) == int(sp["valeur"]) + 2, "sort +1 par niveau")
	check(CC.get_card("zzz@2").is_empty(), "carte inconnue vide")
	var save: Dictionary = {}
	CO.ensure(save)
	check(CO.owned(save, "m_gobelin") == 2 and not CO.can_fuse(save, "m_gobelin@2"), "départ : 2 gobelins niveau 1")
	var k: String = CO.fuse(save, "m_gobelin")
	check(k == "m_gobelin@2" and CO.owned(save, "m_gobelin") == 0 and CO.owned(save, "m_gobelin@2") == 1, "fusion 2 -> 1")
	check(CO.fuse(save, "m_gobelin") == "", "fusion impossible sans 2 exemplaires")
	# deck réparé : les gobelins retirés sont remplacés par la carte fusionnée (une seule fois)
	var d: Array = CO.deck_of(save, CO.active_deck_name(save))
	check(CO.deck_error(save, d) == "" or d.count("m_gobelin") == 0, "deck sans gobelin niveau 1 excédentaire")
	check(d.count("m_gobelin@2") <= 1, "au plus 1 carte fusionnée dans le deck")
	# niveau max
	for i in 40:
		CO.add_card(save, "m_loup")
	var key: String = "m_loup"
	var guard: int = 0
	while CO.can_fuse(save, key) and guard < 100:
		guard += 1
		CO.fuse(save, key)
	check(CO.owned(save, "m_loup") < 2, "épuise les niveaux 1")
	for lv in range(2, 5):
		var kk: String = CC.key_of("m_loup", lv)
		while CO.can_fuse(save, kk):
			CO.fuse(save, kk)
	check(CO.owned(save, "m_loup@5") >= 1 and not CO.can_fuse(save, "m_loup@5"), "niveau 5 non fusionnable")
	# duel avec carte niveau 5
	var dd = DD.new()
	var inst: Dictionary = dd._make_instance("m_gobelin@5")
	check(int(inst["hp"]) == int(CC.get_card("m_gobelin@5")["hp"]) and int(inst["max_hp"]) == int(inst["hp"]), "instance de duel niveau 5")
	# UI
	var ui := CardFusionUI.new()
	root.add_child(ui)
	var sv: Dictionary = {}
	CO.ensure(sv)
	ui.open(sv)
	await process_frame
	check(ui.owned_keys().size() > 10, "UI liste la collection")
	ui._selected = "m_loup"
	ui._refresh()
	await process_frame
	var before: int = CO.owned(sv, "m_loup@2")
	ui._do_fuse()
	check(CO.owned(sv, "m_loup@2") == before + 1, "UI fusionne")
	print("FUSION fails=", fails)
	quit(1 if fails > 0 else 0)
