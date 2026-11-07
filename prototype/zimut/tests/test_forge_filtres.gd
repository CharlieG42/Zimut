extends SceneTree
## Forge : rareté selon le niveau de la recette, filtres (rareté, bonus) et tri de la fabrication.
## Lancement : godot --headless --path . -s tests/test_forge_filtres.gd
var fails: int = 0
func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1
func _init() -> void:
	_boot.call_deferred()
func _names(rows: Array) -> Array:
	return rows.map(func(x: Dictionary) -> String: return String(x["r"]["name"]))
func _boot() -> void:
	var pm: Node = root.get_node("ProgressionManager")
	# ── rareté par niveau ──
	for pair: Array in [[1, "commun"], [33, "commun"], [34, "rare"], [66, "rare"], [67, "epique"], [89, "epique"], [90, "legendaire"], [100, "legendaire"]]:
		check(pm.recipe_rarity({"level": pair[0]}) == pair[1], "niveau %d → %s" % [pair[0], pair[1]])
	var all: Array = pm.craft_recipes()
	var seen: Dictionary = {}
	var stable: bool = true
	for r: Dictionary in all:
		var a: Dictionary = pm.forged_item(r)
		var b: Dictionary = pm.forged_item(r)
		seen[String(a["rarity"])] = true
		if a["rarity"] != pm.recipe_rarity(r) or ItemRules.stat_line(a) != ItemRules.stat_line(b):
			stable = false
	check(stable, "objet forgé : rareté de la recette et stats identiques à chaque appel")
	check(seen.size() == 4, "les 4 raretés existent dans les recettes (%d)" % seen.size())
	# ── interface ──
	var data: Dictionary = pm.new_game(4, "Filtres")
	pm.rebuild_team(data, ["Tank", "Mage", "Heal"])
	var ui: CanvasLayer = (load("res://scripts/ForgeUI.gd") as GDScript).new()
	root.add_child(ui)
	ui.open(data, 4, 0)
	await process_frame
	var base: int = ui._visible_recipes().size()
	check(base == all.size(), "sans filtre : toutes les recettes (%d)" % base)
	ui._rar_filter = "epique"
	var rows: Array = ui._visible_recipes()
	check(rows.size() > 0 and rows.all(func(x: Dictionary) -> bool: return pm.recipe_rarity(x["r"]) == "epique"), "filtre Épique : %d recettes, toutes épiques" % rows.size())
	ui._rar_filter = ""
	ui._stat_filter = ["force", "defense"]
	rows = ui._visible_recipes()
	var ok_stats: bool = rows.size() > 0
	for x: Dictionary in rows:
		var it: Dictionary = pm.forged_item(x["r"])
		if int(it["force"]) <= 0 or int(it["defense"]) <= 0:
			ok_stats = false
	check(ok_stats, "filtre Force + Défense : %d recettes, toutes avec les deux bonus" % rows.size())
	ui._stat_filter = ["force"]
	var n_force: int = ui._visible_recipes().size()
	check(n_force >= rows.size() and n_force < base, "moins de filtres → plus de résultats (%d ≥ %d)" % [n_force, rows.size()])
	ui._stat_filter = []
	ui._rar_filter = "legendaire"
	ui._stat_filter = ["vita"]
	var combo: Array = ui._visible_recipes()
	check(combo.all(func(x: Dictionary) -> bool: return pm.recipe_rarity(x["r"]) == "legendaire" and pm.forged_item(x["r"])["vita"] > 0), "rareté + bonus combinés (%d)" % combo.size())
	ui._rar_filter = ""
	ui._stat_filter = []
	# ── tri ──
	ui._sort = "name"
	var nm: Array = _names(ui._visible_recipes())
	var sorted_nm: Array = nm.duplicate()
	sorted_nm.sort_custom(func(a: String, b: String) -> bool: return a.naturalnocasecmp_to(b) < 0)
	check(nm == sorted_nm, "tri par nom croissant")
	ui._sort_desc = true
	var nm_d: Array = _names(ui._visible_recipes())
	var rev: Array = sorted_nm.duplicate()
	rev.reverse()
	check(nm_d == rev, "tri par nom décroissant")
	ui._sort_desc = false
	ui._sort = "rarity"
	rows = ui._visible_recipes()
	var mono: bool = true
	for i: int in range(1, rows.size()):
		if int(rows[i]["rar"]) < int(rows[i - 1]["rar"]):
			mono = false
	check(mono, "tri par rareté croissant")
	ui._sort = "level"
	rows = ui._visible_recipes()
	mono = true
	for i: int in range(1, rows.size()):
		if int(rows[i]["r"]["level"]) < int(rows[i - 1]["r"]["level"]):
			mono = false
	check(mono, "tri par niveau croissant")
	ui._sort = "power"
	ui._sort_desc = true
	rows = ui._visible_recipes()
	mono = true
	for i: int in range(1, rows.size()):
		if int(rows[i]["pow"]) > int(rows[i - 1]["pow"]):
			mono = false
	check(mono, "tri par puissance décroissant")
	# panneau déplié : l'interface se construit sans erreur
	ui._filters_open = true
	ui.refresh()
	await process_frame
	check(ui._filters_box.get_child_count() >= 5, "panneau « Filtres et tri » construit (%d lignes)" % ui._filters_box.get_child_count())
	pm.delete_save(4)
	print("ÉCHECS : ", fails)
	quit(0 if fails == 0 else 1)
