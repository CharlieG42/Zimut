extends SceneTree
## Mode Cartes : audit de TOUS les sorts (cartes-sorts et sorts de créatures) — chaque effet décrit doit se produire.
## Lancement : godot --headless --path . -s tests/test_jcc_sorts.gd
var fails: int = 0
var DD
var CC
func check(c: bool, m: String) -> void:
	if not c:
		print("  ÉCHEC  " + m)
		fails += 1
func _init() -> void:
	_boot.call_deferred()

## Duel de test : plateau vidé, 10 mana, 3 ennemis (2,2)/(1,3)/(3,3) blessés, 2 alliés, mains/pioches remplies.
func _scene() -> RefCounted:
	var d = DD.new()
	var filler: Array = []
	for i in 12:
		filler.append("m_gobelin")
	d.setup(filler, filler, 5)
	for s in 2:
		d.side(s)["units"] = []
		d.side(s)["hand"] = []
	d.side(0)["mana"] = 10
	d.side(0)["hero_hp"] = 10
	d.side(1)["hero_hp"] = 20
	d.place_unit(1, "m_troll", 2, 2)
	d.place_unit(1, "m_troll", 1, 3)
	d.place_unit(1, "m_troll", 3, 3)
	d.place_unit(0, "m_troll", 0, 4)
	d.place_unit(0, "m_troll", 3, 4)
	for u in d.creatures(0):
		u["hp"] = 2     # alliés blessés (max 6) pour tester les soins
	d.current = 0
	return d

func _pick_target(d, cible: String, prefer_hero: bool = false) -> Dictionary:
	var ts: Array = d.targets_for(0, cible)
	if ts.is_empty():
		return {"none": true}
	if prefer_hero:
		for t in ts:
			if not t.is_empty() and int(t["lane"]) == -1:
				return t
	return ts[0]

## Joue l'effet (carte ou sort de créature) et vérifie son résultat.
func _verify(label: String, card: Dictionary, via_creature: bool) -> void:
	var effet: String = String(card["effet"])
	var v: int = int(card["valeur"]) if effet != "invoquer" else 0
	var duree: int = int(card["duree"])
	var cible: String = String(card["cible"])
	for hero_variant in (2 if cible.ends_with("_ou_heros") else 1):
		var d = _scene()
		var prefer_hero: bool = hero_variant == 1
		var tg: Dictionary = _pick_target(d, cible, prefer_hero)
		if tg.has("none"):
			check(false, "%s : aucune cible disponible (carte injouable)" % label)
			return
		var tag: String = label + (" [héros]" if prefer_hero else "")
		var src_cell: int = d.xy_cell(0, 4)
		if via_creature:
			var cr = d.creature_at(0, src_cell)
			# la créature source est l'allié (0,4) : on lui donne le sort de la carte
			for k in ["sort", "sort_cost", "effet", "valeur", "duree", "cible"]:
				cr[k] = card[k]
			cr["sick"] = false
			cr["hp"] = 2
			tg = _pick_target(d, cible, prefer_hero)
		else:
			d.side(0)["hand"] = [d._make_instance(String(card["id"]))]
		var hp_foe_before: Array = []
		for u in d.creatures(1):
			hp_foe_before.append(int(u["hp"]))
		var hp_ally_before: Array = []
		for u in d.creatures(0):
			hp_ally_before.append(int(u["hp"]))
		var atk_ally_before: Array = []
		for u in d.creatures(0):
			atk_ally_before.append(int(u["atk"]))
		var hand_before: int = d.side(0)["hand"].size()
		var mana_before: int = int(d.side(0)["mana"])
		var foe_hero: int = int(d.side(1)["hero_hp"])
		var my_hero: int = int(d.side(0)["hero_hp"])
		var tcell: int = int(tg["lane"]) if tg.has("lane") else -2
		var tside: int = int(tg["side"]) if tg.has("side") else -1
		var tunit = d.creature_at(tside, tcell) if tcell >= 0 else null
		var t_hp0: int = int(tunit["hp"]) if tunit != null else 0
		var t_atk0: int = int(tunit["atk"]) if tunit != null else 0
		var ok: bool = d.use_sort(0, src_cell, tg) if via_creature else d.play_card(0, 0, tg)
		check(ok, "%s : l'action est refusée par le moteur" % tag)
		if not ok:
			continue
		match effet:
			"degats":
				if tcell == -1:
					check(int(d.side(tside)["hero_hp"]) == (foe_hero if tside == 1 else my_hero) - v, "%s : le héros ne perd pas %d PV" % [tag, v])
				else:
					var after = d.creature_at(tside, tcell)
					check(after == null or int(after["hp"]) == t_hp0 - v, "%s : la cible ne perd pas %d PV" % [tag, v])
			"degats_zone":
				var i: int = 0
				for u in d.creature_at(1, d.xy_cell(2, 2)) if false else []:
					pass
				var all_ok: bool = true
				for k in 3:
					var cell: int = [d.xy_cell(2, 2), d.xy_cell(1, 3), d.xy_cell(3, 3)][k]
					var after2 = d.creature_at(1, cell)
					if after2 != null and int(after2["hp"]) != hp_foe_before[k] - v:
						all_ok = false
				check(all_ok, "%s : tous les ennemis ne perdent pas %d PV" % [tag, v])
			"degats_heros":
				check(int(d.side(1)["hero_hp"]) == foe_hero - v, "%s : le héros ennemi ne perd pas %d" % [tag, v])
			"soin":
				if tcell == -1:
					check(int(d.side(0)["hero_hp"]) == mini(JccDuel.HERO_HP, my_hero + v), "%s : le héros n'est pas soigné de %d" % [tag, v])
				else:
					check(int(d.creature_at(tside, tcell)["hp"]) == mini(int(d.creature_at(tside, tcell)["max_hp"]), t_hp0 + v), "%s : la cible n'est pas soignée de %d" % [tag, v])
			"soin_zone":
				var healed: bool = true
				var idx: int = 0
				for u in d.creatures(0):
					if int(u["hp"]) != mini(int(u["max_hp"]), hp_ally_before[idx] + v):
						healed = false
					idx += 1
				check(healed, "%s : tous les alliés ne sont pas soignés de %d" % [tag, v])
			"atq":
				check(int(d.creature_at(tside, tcell)["atk"]) == t_atk0 + v, "%s : l'attaque n'augmente pas de %d" % [tag, v])
			"atq_zone":
				var oka: bool = true
				var ia: int = 0
				for u in d.creatures(0):
					if int(u["atk"]) != atk_ally_before[ia] + v:
						oka = false
					ia += 1
				check(oka, "%s : l'attaque de tous les alliés n'augmente pas de %d" % [tag, v])
			"bouclier":
				check(int(d.creature_at(tside, tcell)["hp"]) == t_hp0 + v, "%s : la cible ne gagne pas %d PV" % [tag, v])
			"bouclier_zone":
				var okb: bool = true
				var ib: int = 0
				for u in d.creatures(0):
					if int(u["hp"]) != hp_ally_before[ib] + v:
						okb = false
					ib += 1
				check(okb, "%s : tous les alliés ne gagnent pas %d PV" % [tag, v])
			"etourdir", "etourdir_zone":
				var cells: Array = [d.xy_cell(2, 2), d.xy_cell(1, 3), d.xy_cell(3, 3)] if effet == "etourdir_zone" else [tcell]
				d.end_turn(0)   # tour adverse : la créature étourdie ne peut RIEN faire
				for cell in cells:
					var su = d.creature_at(1, cell)
					check(su != null and int(su["stun"]) == maxi(duree, 1) - 1, "%s : l'étourdissement ne dure pas %d tour(s)" % [tag, maxi(duree, 1)])
					check(not d.can_attack(1, cell), "%s : une unité étourdie peut attaquer" % tag)
					check(not d.can_use_sort(1, cell), "%s : une unité étourdie peut lancer un sort" % tag)
					check(d.move_targets(1, cell).is_empty(), "%s : une unité étourdie peut se déplacer" % tag)
			"poison":
				d.end_turn(0)
				var pu = d.creature_at(1, tcell)
				check(pu != null and int(pu["hp"]) == t_hp0 - v, "%s : le poison n'inflige pas %d au début du tour de la cible" % [tag, v])
			"invoquer":
				var found: bool = false
				for u in d.creatures(0):
					if String(u["id"]) == String(card["valeur"]):
						found = true
				check(found, "%s : le jeton n'apparaît pas" % tag)
			"pioche":
				var dr: int = d.side(0)["hand"].size() - (hand_before - (0 if via_creature else 1))
				check(dr == int(card["valeur"]), "%s : la pioche ne donne pas %s cartes (%d)" % [tag, card["valeur"], dr])
			"mana":
				var cost: int = int(card["sort_cost"]) if via_creature else int(card["cost"])
				check(int(d.side(0)["mana"]) == mana_before - cost + int(card["valeur"]), "%s : le mana n'augmente pas de %s" % [tag, card["valeur"]])
			_:
				check(false, "%s : effet inconnu « %s »" % [tag, effet])

func _boot() -> void:
	await process_frame
	DD = load("res://scripts/JccDuel.gd")
	CC = load("res://scripts/JccCards.gd")
	var n_spell: int = 0
	var n_sort: int = 0
	for id in CC.collectible_ids():
		var c: Dictionary = CC.get_card(id)
		if String(c["type"]) == "Sort":
			_verify("Carte « %s »" % c["name"], c, false)
			n_spell += 1
		elif String(c["sort"]) != "":
			_verify("Sort « %s » de %s" % [c["sort"], c["name"]], c, true)
			n_sort += 1
	print("%d cartes-sorts et %d sorts de créatures vérifiés" % [n_spell, n_sort])
	print("FIN : %d échec(s)" % fails)
	quit(fails)
