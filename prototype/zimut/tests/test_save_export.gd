extends SceneTree
## Export / import d'une partie par code texte.
var fails := 0
func ck(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c: fails += 1
func _init() -> void:
	_run.call_deferred()
func _run() -> void:
	var pm: Node = root.get_node("ProgressionManager")
	var d: Dictionary = pm.new_game(3, "Exportée")
	pm.rebuild_team(d, ["Tank", "Mage", "Heal"])
	d["gold"] = 1234
	d["victories"] = 7
	var code: String = pm.export_code(d)
	ck(code.begins_with("ZIMUT1:") and code.length() < 200000, "code généré (%d caractères)" % code.length())
	ck(pm.import_code("n'importe quoi").is_empty(), "texte invalide refusé")
	ck(pm.import_save(4, code) == "", "import dans l'emplacement 5")
	var l: Dictionary = pm.load_save(4)
	ck(String(l.get("name", "")) == "Exportée" and int(l["gold"]) == 1234 and int(l["victories"]) == 7, "contenu identique")
	ck(int(l.get("slot", -1)) == 4, "emplacement mis à jour")
	ck(pm.import_save(4, "  \n" + code + "\n ") == "", "espaces/retours ignorés")
	pm.delete_save(4)
	pm.delete_save(3)
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
