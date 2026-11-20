extends SceneTree
## Butin de cartes après victoire (Tactique / Aventure / boss) : probabilités, ajout à la collection, last_card_loot.
const CO := preload("res://scripts/JccCollection.gd")
var fails: int = 0
func check(ok: bool, label: String) -> void:
	if ok:
		print("  ok  ", label)
	else:
		fails += 1
		print("  ÉCHEC  ", label)

func _initialize() -> void:
	_run.call_deferred()

func _total(save: Dictionary) -> int:
	var n: int = 0
	for k: Variant in CO.ensure(save)["collection"]:
		n += int(CO.ensure(save)["collection"][k])
	return n

func _run() -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = 12345
	var save: Dictionary = {}
	CO.ensure(save)
	var base: int = _total(save)
	var got: int = 0
	for i in 400:
		if CO.combat_loot(save, 10, false, false, rng) != "":
			got += 1
	check(got > 90 and got < 150, "combat tactique ≈ 30 %% de chance (%d/400)" % got)
	check(_total(save) == base + got, "chaque carte est ajoutée à la collection")
	got = 0
	for i in 400:
		if CO.combat_loot(save, 10, false, true, rng) != "":
			got += 1
	check(got > 130 and got < 190, "Aventure ≈ 40 %% (%d/400)" % got)
	var bosses: int = 0
	var rare: int = 0
	for i in 300:
		var id: String = CO.combat_loot(save, 30, true, false, rng)
		if id == "":
			check(false, "boss : toujours une carte")
			break
		if CO.boss_card_ids().has(id):
			bosses += 1
		if String(JccCards.get_card(id)["rarity"]) in ["E", "L"]:
			rare += 1
	check(bosses > 20, "boss : cartes de boss (20 % directes + pool légendaire) (%d/300)" % bosses)
	check(rare > 60, "boss : bonne part d'épiques/légendaires (%d/300)" % rare)
	check(not CO.boss_card_ids().is_empty(), "cartes de boss listées")
	# intégration : register_victory
	var pm: Node = root.get_node("ProgressionManager")
	var d: Dictionary = pm.new_game(4, "Butin")
	pm.rebuild_team(d, ["Tank", "Mage", "Heal"])
	var seen: int = 0
	for i in 40:
		pm.register_victory(d, {"enemies": [{"type": "Loup", "level": 1, "boss": false}], "turns": 3, "boss": true, "deaths": 0})
		if String(d.get("last_card_loot", "")) != "":
			seen += 1
	check(seen == 40, "register_victory (boss) : last_card_loot toujours rempli (%d/40)" % seen)
	check(CO.owned(d, String(d["last_card_loot"])) >= 1, "la carte est possédée")
	pm.register_defeat(d, {"enemies": [{"type": "Loup", "level": 1, "boss": false}]}) if pm.has_method("register_defeat") else null
	print("BUTIN fails=", fails)
	quit(1 if fails > 0 else 0)
