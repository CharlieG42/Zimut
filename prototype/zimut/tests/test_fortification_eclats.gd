extends SceneTree
## V362 — Fortification par éclats de caractéristique (rang 1-5), lignes uniques, verrou, plafonds,
## atelier (fabrication / fusion / brisure), butin et forge.
## Lancement : godot --headless --path . -s tests/test_fortification_eclats.gd
var fails: int = 0
func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1
func _init() -> void:
	_boot.call_deferred()
func _item(name: String = "Épée test", force: int = 5) -> Dictionary:
	return {"type": "Épée (1 main)", "name": name, "level": 10, "rarity": "commun", "force": force}
func _boot() -> void:
	var pm: Node = root.get_node("ProgressionManager")
	var data: Dictionary = pm.new_game(4, "Fort362")
	pm.rebuild_team(data, ["Tank", "Mage", "Heal"])
	var rng := RandomNumberGenerator.new()
	rng.seed = 11
	data["gold"] = 100000
	# ── plages par rang : croissantes, avec chevauchement ──
	for st: String in ["force", "vita"]:
		var prev_hi: int = 0
		var mono: bool = true
		for r in range(1, 6):
			var rg: Array = Shards.value_range(st, r)
			if int(rg[1]) < prev_hi or int(rg[0]) > int(rg[1]):
				mono = false
			prev_hi = int(rg[1])
		check(mono, "%s : plages croissantes" % st)
	check(int(Shards.value_range("force", 4)[1]) > int(Shards.value_range("force", 5)[0]), "force : les rangs 4 et 5 se chevauchent")
	check(int(Shards.value_range("vita", 1)[0]) == 3 * int(Shards.value_range("force", 1)[0]), "la Vitalité vaut 3 × les autres caractéristiques")
	var seen: Dictionary = {}
	for _i in range(300):
		seen[Shards.roll_value(rng, "force", 3)] = true
	check(seen.size() >= 3 and seen.keys().min() >= 3 and seen.keys().max() <= 6, "valeur tirée au hasard dans la plage du rang (%s)" % str(seen.keys()))
	# ── pose d'une ligne ──
	var sword: Dictionary = _item()
	check(Shards.fortify_stat(data, sword, "force", 3, rng)["ok"] == false, "sans éclat : refusé")
	Shards.stat_add(data, "force", 3, 2)
	Shards.stat_add(data, "force", 1, 1)
	Shards.stat_add(data, "vita", 4, 1)
	var g0: int = int(data["gold"])
	var res: Dictionary = Shards.fortify_stat(data, sword, "force", 3, rng)
	check(bool(res["ok"]) and int(res["value"]) >= 3 and int(res["value"]) <= 6, "pose Force R3 (+%d)" % int(res["value"]))
	check(Shards.stat_count(data, "force", 3) == 1 and int(data["gold"]) == g0 - Shards.stat_gold(sword, 3), "1 éclat et l'or dépensés")
	var first_v: int = int(sword["forts"]["force"]["v"])
	# ── plusieurs caractéristiques, sans limite ──
	check(bool(Shards.fortify_stat(data, sword, "vita", 4, rng)["ok"]) and sword["forts"].size() == 2, "une 2e caractéristique s'ajoute")
	# ── même caractéristique : remplacement, avertissement ──
	var warn: Dictionary = Shards.fortify_stat(data, sword, "force", 3, rng)
	check(bool(warn["confirm"]) and not bool(warn["ok"]) and Shards.stat_count(data, "force", 3) == 1, "écraser demande confirmation, rien n'est dépensé")
	check(int(sword["forts"]["force"]["v"]) == first_v, "la ligne en place est intacte avant confirmation")
	var rep: Dictionary = Shards.fortify_stat(data, sword, "force", 1, rng, true)
	check(bool(rep["ok"]) and int(sword["forts"]["force"]["rank"]) == 1 and int(sword["forts"]["force"]["v"]) <= 2, "confirmé : la nouvelle ligne (plus faible) remplace l'ancienne")
	check(sword["forts"].size() == 2, "toujours une seule ligne par caractéristique")
	# ── verrou ──
	check(Shards.set_lock(sword, "force", true) and Shards.is_locked(sword, "force"), "ligne verrouillée")
	Shards.stat_add(data, "force", 3, 1)
	var locked: Dictionary = Shards.fortify_stat(data, sword, "force", 3, rng, true)
	check(not bool(locked["ok"]) and String(locked["reason"]).contains("verrouillée") and Shards.stat_count(data, "force", 3) == 2, "ligne verrouillée : pose refusée, éclat conservé")
	check(Shards.remove_line(data, sword, "force") != "", "ligne verrouillée : retrait refusé")
	Shards.set_lock(sword, "force", false)
	var gb: int = int(data["gold"])
	check(Shards.remove_line(data, sword, "force") == "" and not sword["forts"].has("force") and int(data["gold"]) == gb - Shards.remove_gold(sword), "retrait d'une ligne déverrouillée (or payé)")
	# ── effet réel : stats + valeur + affichage ──
	var worn: Dictionary = _item("Épée portée", 5)
	worn["forts"] = {"force": {"v": 9, "rank": 4, "lock": false}, "vita": {"v": 12, "rank": 2, "lock": false}}
	var ag: Dictionary = ItemRules.aggregate({"arme": worn})
	check(int(ag["stats"]["force"]) == 5 + 9 and int(ag["stats"]["vita"]) == 12, "aggregate : base + fortification (force %d, vita %d)" % [int(ag["stats"]["force"]), int(ag["stats"]["vita"])])
	check(ItemRules.power(worn) > ItemRules.power(_item("nue", 5)), "la valeur (équiper le meilleur) compte la fortification")
	check(ItemRules.stat_line(worn).contains("❖ Force +9") and ItemRules.stat_line(worn).contains("❖ Vitalité +12"), "affichage : %s" % ItemRules.stat_line(worn))
	# ── le commun très fortifié peut dépasser un légendaire de bas rang ──
	var common: Dictionary = {"type": "Casque", "name": "Heaume commun", "level": 10, "rarity": "commun", "vita": 6}
	pm.apply_rank(common, 6)
	common["forts"] = {"vita": {"v": int(Shards.value_range("vita", 5)[0]), "rank": 5, "lock": false}}
	var legend: Dictionary = {"type": "Casque", "name": "Heaume légendaire", "level": 10, "rarity": "commun", "vita": 6}
	legend = ItemRules.apply_rarity(legend, "legendaire", rng)
	pm.apply_rank(legend, 1)
	var ca: Dictionary = ItemRules.aggregate({"casque": common})["stats"]
	var la: Dictionary = ItemRules.aggregate({"casque": legend})["stats"]
	check(int(ca["vita"]) > int(la["vita"]), "commun R6 + éclat R5 (vita %d) > légendaire R1 (vita %d)" % [int(ca["vita"]), int(la["vita"])])
	# ── plafonds ──
	var cap_item: Dictionary = _item("Plafond", 0)
	cap_item["forts"] = {"force": {"v": 999, "rank": 5, "lock": false}}
	check(int(Shards.item_fort_stats(cap_item)["force"]) == int(Shards.ITEM_CAP["force"]), "plafond par objet (force %d)" % int(Shards.ITEM_CAP["force"]))
	var many: Dictionary = {}
	for i in range(10):
		many["s%d" % i] = {"type": "Casque", "name": "c%d" % i, "level": 1, "forts": {"force": {"v": 12, "rank": 5, "lock": false}, "pa": {"v": 2, "rank": 5, "lock": false}}}
	var ma: Dictionary = ItemRules.aggregate(many)
	check(int(ma["stats"]["force"]) == int(Shards.HERO_CAP["force"]), "plafond par héros (force %d)" % int(ma["stats"]["force"]))
	check(int(ma["fx"]["pa"]) == int(Shards.HERO_CAP["pa"]), "plafond par héros (PA +%d)" % int(ma["fx"]["pa"]))
	# ── Pierres + caractéristique : tout s'additionne, plafonné ──
	var mix: Dictionary = {"type": "Casque", "name": "Mixte", "level": 1, "pfort": {"Rouages": 1}, "forts": {"pa": {"v": 2, "rank": 5, "lock": false}}}
	check(int(Shards.item_fort_fx(mix)["pa"]) == int(Shards.ITEM_CAP["pa"]), "PA de Pierre + PA d'éclat : plafonné par objet")
	# ── atelier ──
	var d2: Dictionary = {"gold": 5000, "resources": {"Fer": 10, "Fer@2": 5}}
	check(Shards.craft(d2, "force", 1) == "" and Shards.stat_count(d2, "force", 1) == 1 and int(d2["resources"]["Fer"]) == 6, "fabrication Force R1 (4 Fer)")
	check(Shards.craft(d2, "force", 2) == "" and Shards.stat_count(d2, "force", 2) == 1, "fabrication Force R2 (Fer rang 2)")
	check(Shards.craft(d2, "force", 4) != "" and Shards.craft(d2, "pa", 1) != "", "R4+ et PA ne se fabriquent pas")
	check(Shards.fuse(d2, "force", 1) != "", "fusion : il faut 3 éclats")
	Shards.stat_add(d2, "force", 1, 2)
	check(Shards.fuse(d2, "force", 1) == "" and Shards.stat_count(d2, "force", 1) == 0 and Shards.stat_count(d2, "force", 2) == 2, "fusion 3 R1 → 1 R2")
	check(Shards.split(d2, "force", 2) == "" and Shards.stat_count(d2, "force", 1) == 2 and Shards.stat_count(d2, "force", 2) == 1, "brisure 1 R2 → 2 R1")
	check(Shards.split(d2, "force", 1) != "" and Shards.fuse(d2, "force", 5) != "", "bornes : R1 ne se brise pas, R5 ne fusionne pas")
	# ── butin ──
	var n_fight: int = 0
	var n_boss: int = 0
	var rmax_low: int = 0
	var rmax_high: int = 0
	for _i in range(3000):
		if not Shards.roll_stat_fight(rng, 5, false).is_empty():
			n_fight += 1
		var b1: Dictionary = Shards.roll_stat_fight(rng, 5, true)
		if not b1.is_empty():
			n_boss += 1
			rmax_low = maxi(rmax_low, int(b1["rank"]))
		var b2: Dictionary = Shards.roll_stat_fight(rng, 60, true)
		if not b2.is_empty():
			rmax_high = maxi(rmax_high, int(b2["rank"]))
	check(n_fight > 250 and n_fight < 480, "combat normal ~12 %% (%d / 3000)" % n_fight)
	check(n_boss > n_fight * 2, "boss : bien plus de chances (%d)" % n_boss)
	check(rmax_low <= 2 and rmax_high == 5, "le rang suit le niveau (niv 5 boss : R%d max, niv 60 : R%d)" % [rmax_low, rmax_high])
	var got_any: bool = false
	for _i in range(60):
		pm.register_victory(data, {"boss": true, "biome": "Forêt"})
		if not (data.get("last_stat_shards", {}) as Dictionary).is_empty():
			got_any = true
			break
	check(got_any and Shards.stat_total(data) > 0, "register_victory crédite un éclat de caractéristique")
	# ── sauvegarde JSON ──
	var back: Variant = JSON.parse_string(JSON.stringify(worn))
	check(back is Dictionary and int(ItemRules.aggregate({"x": back})["stats"]["force"]) == 14, "lignes de fortification survivent à la sauvegarde")
	# ── forge : interface ──
	var d3: Dictionary = pm.new_game(4, "Fort362ui")
	pm.rebuild_team(d3, ["Tank", "Mage"])
	d3["gold"] = 50000
	var gear: Dictionary = _item("Épée forge", 6)
	d3["inventory"].append(gear)
	Shards.stat_add(d3, "force", 2, 3)
	Shards.stat_add(d3, "defense", 5, 1)
	var ui: CanvasLayer = (load("res://scripts/ForgeUI.gd") as GDScript).new()
	root.add_child(ui)
	ui.open(d3, 4, 0)
	ui.show_mode("fortify")
	var key: String = ""
	for e: Dictionary in pm.upgradable_items(d3):
		if String(e["item"].get("name", "")) == "Épée forge":
			key = ui._entry_key(e)
	ui._up_key = key
	ui._fs_stat = "force"
	ui._fs_rank = 2
	ui.refresh()
	await create_timer(0.3).timeout
	var fb: Button = ui.find_child("FortifyStat", true, false) as Button
	check(fb != null and not fb.disabled, "bouton Fortifier actif")
	check(ui.find_child("AtelierEclats", true, false) != null and ui.find_child("FsRank_5", true, false) != null, "atelier et choix du rang présents")
	fb.pressed.emit()
	await create_timer(0.3).timeout
	var live: Dictionary = {}
	for e: Dictionary in pm.upgradable_items(d3):
		if String(e["item"].get("name", "")) == "Épée forge":
			live = e["item"]
	check(live.has("forts") and live["forts"].has("force") and Shards.stat_count(d3, "force", 2) == 2, "l'objet est fortifié depuis la forge")
	# 2e pose : écrasement => confirmation
	(ui.find_child("FortifyStat", true, false) as Button).pressed.emit()
	await create_timer(0.3).timeout
	check(Shards.stat_count(d3, "force", 2) == 2 and String((ui.find_child("FortifyStat", true, false) as Button).text).contains("CONFIRMER"), "1er appui : demande de confirmation, rien dépensé")
	(ui.find_child("FortifyStat", true, false) as Button).pressed.emit()
	await create_timer(0.3).timeout
	check(Shards.stat_count(d3, "force", 2) == 1, "2e appui : remplacement effectué")
	# verrou et retrait depuis l'interface
	(ui.find_child("FortLock_force", true, false) as Button).pressed.emit()
	await create_timer(0.3).timeout
	check(Shards.is_locked(live, "force") and (ui.find_child("FortRemove_force", true, false) as Button).disabled, "verrou : retrait grisé")
	(ui.find_child("FortifyStat", true, false) as Button).pressed.emit()
	await create_timer(0.3).timeout
	check(Shards.stat_count(d3, "force", 2) == 1, "ligne verrouillée : la forge refuse de remplacer")
	# atelier
	ui._up_key = "atelier|"
	ui.refresh()
	await create_timer(0.3).timeout
	check(ui.find_child("AtelierCraft", true, false) != null and ui.find_child("AtelierFuse", true, false) != null and ui.find_child("AtelierSplit", true, false) != null, "atelier : 3 actions")
	ui._fort_kind = "pierre"
	ui._up_key = key
	ui.refresh()
	await create_timer(0.3).timeout
	check(ui.find_child("FortifyPierre", true, false) != null, "onglet Éclats de Pierre")
	pm.delete_save(4)
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
