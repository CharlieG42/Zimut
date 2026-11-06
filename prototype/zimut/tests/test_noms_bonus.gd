extends SceneTree
## V98 : les bonus sont écrits avec leur nom complet (équipement, inventaire, forge).
var fails := 0
func ck(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c: fails += 1

func _init() -> void:
	_run.call_deferred()

func _run() -> void:
	var it: Dictionary = {"force": 4, "agility": 4, "wisdom": 2}
	var s: String = ItemRules.stat_line(it)
	ck(s == "Force +4 · Agilité +4 · Sagesse +2", "stat_line : « %s »" % s)
	ck(ItemRules.stat_line({"vita": 30, "defense": -2}) == "Vitalité +30 · Défense -2", "stat_line : vitalité et malus")
	ck(ItemRules.stat_line({}) == "", "stat_line : objet sans bonus = vide")
	var t: String = ItemRules.totals_line({"max_pv": 161, "force": 28, "intelligence": 46, "agility": 38, "wisdom": 45, "defense": 45, "pa": 6, "pm": 4}).replace("\u00a0", " ")
	ck(t == "Vitalité 161 · Force 28 · Intelligence 46 · Agilité 38 · Sagesse 45 · Défense 45 · PA 6 · PM 4", "totals_line : « %s »" % t)

	var pm: Node = root.get_node("ProgressionManager")
	var d: Dictionary = pm.new_game(5, "Noms")
	d["team"] = [{"classe": "Tank", "equipment": {}}, {"classe": "Mage", "equipment": {}}, {"classe": "Sylvain", "equipment": {}}]
	var ui: CanvasLayer = load("res://scripts/TeamEquipmentUI.gd").new()
	root.add_child(ui)
	ui.open(d, 5)
	await process_frame
	var holder: Control = ui._member_frames[0].get_child(0)
	var lbl: Label = holder.get_node("stats_summary") as Label
	ck(lbl.text.begins_with("Vitalité") and lbl.text.contains("Force") and lbl.text.contains("Agilité"), "vue équipement : somme en noms complets (« %s »)" % lbl.text.replace("\n", " | "))
	ck(not lbl.text.contains("F2") and not lbl.text.contains(" I4"), "vue équipement : plus d'abréviations")
	ui.queue_free()
	pm.delete_save(5)
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
