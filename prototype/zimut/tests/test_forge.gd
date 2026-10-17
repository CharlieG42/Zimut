extends SceneTree
## Forge : rangs, fusion de ressources, fabrication au rang N, amélioration, Briseur.
var fails: int = 0
func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var pm: Node = root.get_node("ProgressionManager")
	await process_frame
	var d: Dictionary = pm.new_game(4, "ForgeTest")
	pm.rebuild_team(d, ["Tank", "Mage", "Sylvain", "Heal"])
	d["resources"] = {"Fer": 20, "Cuir": 10, "Magie": 4}
	d["gold"] = 1000
	# --- Fusion
	check(pm.fuse_resource(d, "Fer", 1) == "", "fusion Fer R1 → R2")
	check(pm.resource_count(d, "Fer", 1) == 18 and pm.resource_count(d, "Fer", 2) == 1, "2 Fer R1 consommés, 1 Fer R2 créé")
	check(int(d["gold"]) == 1000 - pm.fuse_gold(2), "frais d'or de fusion (%d)" % pm.fuse_gold(2))
	check(pm.fuse_resource(d, "Fer", 2) != "", "fusion refusée sans assez de R2")
	check(pm.fuse_resource(d, "Fer", 10) != "", "pas de fusion au-delà du rang 10")
	check(pm.fuse_resource(d, "Mithril", 1) != "", "ressource inconnue refusée")
	d["gold"] = 0
	check(pm.fuse_resource(d, "Fer", 1) != "", "fusion refusée sans or")
	d["gold"] = 5000
	# --- Craft au rang 1 et au rang 3
	var r: Dictionary = pm.craft_recipe("Dague en fer")
	check(not r.is_empty(), "recette Dague en fer")
	var base_cost: int = int(r["cost"]["Fer"])
	check(pm.craft_item(d, "Dague en fer", 1) == "", "craft rang 1")
	var it1: Dictionary = d["inventory"][d["inventory"].size() - 1]
	check(int(it1.get("rank", 0)) == 1, "objet rang 1")
	check(pm.resource_count(d, "Fer", 1) == 18 - base_cost, "coût rang 1 = quantité de la recette")
	d["resources"]["Fer@3"] = 5
	var q3: int = int(pm.craft_cost(r, 3)["Fer@3"])
	check(q3 < base_cost and q3 >= 1, "coût rang 3 réduit (%d)" % q3)
	check(pm.craft_item(d, "Dague en fer", 3) == "", "craft rang 3")
	var it3: Dictionary = d["inventory"][d["inventory"].size() - 1]
	check(int(it3.get("rank", 0)) == 3, "objet rang 3")
	check(int(it3["force"]) > int(it1["force"]) or int(it3["agility"]) > int(it1["agility"]), "stats rang 3 > rang 1")
	check(ItemRules.display_name(it3).ends_with("R3"), "nom affiché avec rang (%s)" % ItemRules.display_name(it3))
	check(pm.craft_item(d, "Dague en fer", 9) != "", "craft rang 9 refusé sans ressources")
	# --- Amélioration
	d["resources"]["Fer@2"] = 1
	var entries: Array = pm.upgradable_items(d)
	var target: Dictionary = {}
	for e: Dictionary in entries:
		if String(e["src"]) == "inv" and String(e["item"]["name"]) == "Dague en fer" and int(e["item"].get("rank", 1)) == 1:
			target = e
	check(not target.is_empty(), "objet améliorable trouvé")
	var stat_before: int = int(target["item"]["force"]) + int(target["item"]["agility"])
	check(pm.upgrade_item(d, target) == "", "amélioration R1 → R2")
	check(int(target["item"]["rank"]) == 2, "rang 2 appliqué")
	check(int(target["item"]["force"]) + int(target["item"]["agility"]) > stat_before, "stats augmentées")
	d["resources"]["Fer@3"] = 0
	check(pm.upgrade_item(d, target) != "", "R2 → R3 refusé sans ressource R3")
	d["resources"]["Fer@10"] = 5
	for _i in range(8):
		d["resources"]["Fer@%d" % (int(target["item"]["rank"]) + 1)] = 1
		d["gold"] = 5000
		pm.upgrade_item(d, target)
	check(int(target["item"]["rank"]) == 10, "rang 10 atteint")
	check(pm.upgrade_item(d, target) != "", "rang max refusé")
	# base_stats préservés : rang 10 ≈ x2.08
	var bs: int = int(target["item"]["base_stats"].get("force", 0))
	if bs > 0:
		check(int(target["item"]["force"]) >= int(float(bs) * 2.0), "stats rang 10 ≈ x2")
	# --- Briseur : rend une ressource de rang (rang-1)
	var idx: int = -1
	for j in range(d["inventory"].size()):
		if int(d["inventory"][j].get("rank", 1)) == 10:
			idx = j
	check(idx >= 0, "objet rang 10 dans l'inventaire")
	if idx >= 0:
		var res: Dictionary = pm.salvage_item(d, idx)
		check(bool(res["ok"]) and res["gains"].has("Fer@9"), "Briseur rend du Fer rang 9")
	# --- Équipé : amélioration d'un objet porté
	d["inventory"].append(pm.forged_item_ranked(pm.craft_recipe("Dague en fer"), 1))
	pm.equip_item(d, 0, d["inventory"].size() - 1)
	var worn: Array = pm.upgradable_items(d).filter(func(e: Dictionary) -> bool: return String(e["src"]) == "team")
	check(worn.size() > 0, "objet porté listé")
	if worn.size() > 0:
		d["resources"]["Fer@2"] = 1
		d["resources"]["Cuir@2"] = 1
		d["resources"]["Magie@2"] = 1
		d["gold"] = 500
		check(pm.upgrade_item(d, worn[0]) == "", "amélioration d'un objet équipé")
	pm.delete_save(4)
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
