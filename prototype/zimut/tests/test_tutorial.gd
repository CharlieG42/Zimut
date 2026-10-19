extends SceneTree
## Tutoriel de Gultur, verrouillage des modes (niv 3 / 5), export-import .zimut, numéros d'ordre.
## godot --headless --path . -s tests/test_tutorial.gd
var _fails: int = 0
func _ok(cond: bool, msg: String) -> void:
	if cond:
		print("  ok   ", msg)
	else:
		print("  ÉCHEC ", msg)
		_fails += 1
func _init() -> void:
	_run.call_deferred()
func _run() -> void:
	var pm: Node = root.get_node("ProgressionManager")
	var gs: Node = root.get_node("GameSettings")
	# Verrouillage des modes
	var data: Dictionary = pm.new_game(4, "Charlie")
	_ok(not pm.mode_unlocked(data, "adventure"), "Aventure verrouillée au niveau 1")
	_ok(not pm.mode_unlocked(data, "conquest"), "Conquête verrouillée au niveau 1")
	_ok(pm.mode_unlocked(data, "tactique"), "Tactique toujours ouvert")
	data["roster"]["Tank"]["level"] = 3
	_ok(pm.mode_unlocked(data, "adventure") and not pm.mode_unlocked(data, "conquest"), "niv 3 : Aventure ouverte, Conquête non")
	data["roster"]["Mage"]["level"] = 5
	_ok(pm.mode_unlocked(data, "conquest"), "un seul héros niv 5 suffit pour la Conquête")
	# Pseudo : doublons autorisés
	var d1: Dictionary = pm.new_game(3, "Charlie")
	var d2: Dictionary = pm.new_game(2, "Charlie")
	_ok(d1["name"] == "Charlie" and d2["name"] == "Charlie", "même pseudo sur deux parties")
	_ok(pm.new_game(1, "")["name"] == "Partie 2", "pseudo vide : nom par défaut")
	# Tutoriel : étapes vues / passer / relancer
	gs.restart_tutorial()
	_ok(Gultur.should_show("intro"), "intro à montrer après relance")
	gs.mark_tuto_seen("intro")
	_ok(not Gultur.should_show("intro") and Gultur.should_show("lvl3"), "intro vue, lvl3 encore à voir")
	gs.skip_tutorial()
	_ok(not Gultur.should_show("lvl3") and gs.tutorial_done, "passer le tutoriel désactive tout")
	gs.restart_tutorial()
	_ok(Gultur.should_show("intro") and gs.tuto_seen.is_empty() and not gs.tutorial_done, "relance : tout est remis à zéro")
	gs.skip_tutorial()
	# Export / import (.zimut)
	data["inventory"] = [{"type": "Casque", "name": "Test", "level": 1, "rarity": "commun", "defense": 3}]
	var code: String = pm.export_code(data)
	_ok(code.begins_with(pm.EXPORT_PREFIX) and pm.EXPORT_EXT == "zimut", "code ZIMUT1 / extension .zimut")
	_ok(pm.import_save(0, "bla\n" + code + "\n") == "", "import depuis un texte de fichier")
	_ok(pm.load_save(0)["name"] == "Charlie" and pm.load_save(0)["inventory"].size() == 1, "partie importée identique")
	_ok(pm.import_save(0, "n'importe quoi") != "", "texte invalide refusé")
	_ok(pm.safe_file_stem("Zoé le Grand!") == "Zo__le_Grand_", "nom de fichier sûr: " + pm.safe_file_stem("Zoé le Grand!"))
	print("KO — %d échec(s)" % _fails if _fails > 0 else "OK — tous les tests passent")
	for s in [0, 1, 2, 3, 4]:
		pm.delete_save(s) if pm.has_method("delete_save") else null
	quit(1 if _fails > 0 else 0)
