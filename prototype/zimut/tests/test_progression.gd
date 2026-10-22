extends SceneTree
## test_progression.gd — Test headless de la progression (sauvegardes, XP, équipement).
## Lancement : godot --headless -s tests/test_progression.gd --path .
##
## NOTE : on évite `await process_frame` qui peut bloquer indéfiniment en mode
## `-s` (le moteur attend la fin du script avant de lancer la boucle principale).
## On utilise à la place une chaîne de call_deferred pour attendre le _ready.

var pm: Node
var _failures: int = 0

func _init() -> void:
	pm = load("res://scripts/ProgressionManager.gd").new()
	pm.name = "ProgressionManager"
	root.add_child(pm)
	# Attendre que pm._ready() soit appelé, puis lancer le test
	_poll_ready.call_deferred()

func _poll_ready() -> void:
	if pm.get("_items_catalog") == null:
		# _ready() pas encore appelé, réessayer au prochain cycle
		_poll_ready.call_deferred()
		return
	_run_tests.call_deferred()

func _check(cond: bool, label: String) -> void:
	if cond:
		print("  ok  %s" % label)
	else:
		_failures += 1
		print("  KO  %s" % label)

func _run_tests() -> void:
	print("ProgressionManager — tests headless :")

	# Liste des sauvegardes (vide au départ)
	print("saves list:", pm.list_saves().size())

	# Nouvelle partie
	var data = pm.new_game(0, "Test")
	_check(data["level"] == 1, "nouvelle partie niveau 1")
	print("new:", data["level"], "inv:", data["inventory"].size())

	# Victoire 1
	pm.register_victory(data)
	print("after 1 win: lvl=", data["level"], " loots=", data["last_loots"].size(), " inv=", data["inventory"].size())
	_check(data["level"] >= 1, "niveau >= 1 après victoire")
	for l in data["last_loots"]:
		print("  loot: ", l["type"], " ", l["name"])

	# Victoire 2
	pm.register_victory(data)
	print("after 2 wins: lvl=", data["level"], " inv=", data["inventory"].size())
	_check(data["level"] >= 1, "niveau >= 1 après 2 victoires")

	# Sauvegarde / rechargement
	pm.write_save(0, data)
	var back = pm.load_save(0)
	print("reload: lvl=", back["level"], " inv=", back["inventory"].size(), " name=", back["name"])
	_check(back["name"] == "Test", "nom de sauvegarde conservé")
	_check(back["level"] == data["level"], "niveau conservé après save/load")

	# Test équipement
	var team = [{"classe": "Tank", "equipment": {}}]
	back["team"] = team
	var err = pm.equip_item(back, 0, 0)
	print("equip err:", err)
	var bonuses = pm.equipment_bonuses(back["team"][0])
	print("bonuses:", bonuses)

	# Suppression
	print("exists before delete:", pm.save_exists(0))
	_check(pm.save_exists(0), "sauvegarde existe avant suppression")
	pm.delete_save(0)
	print("exists after delete:", pm.save_exists(0))
	_check(not pm.save_exists(0), "sauvegarde supprimée")

	print("")
	if _failures > 0:
		print("ÉCHEC : %d test(s) en erreur." % _failures)
		quit(1)
	else:
		print("OK : tous les tests passent.")
		quit(0)
