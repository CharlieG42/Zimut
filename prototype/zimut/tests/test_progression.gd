extends SceneTree
var pm: Node

func _init() -> void:
	pm = load("res://scripts/ProgressionManager.gd").new()
	pm.name = "ProgressionManager"
	# _ready() lit stuff.txt et fait DirAccess -> il faut être dans l'arbre
	root.add_child.call_deferred(pm)
	_boot.call_deferred()
func _boot() -> void:
	# Scène SaveSlots doit compiler et s'afficher
	var sc = (load("res://scenes/SaveSlots.tscn") as PackedScene).instantiate()
	root.add_child(sc)
	await process_frame
	await process_frame
	print("saves list:", pm.list_saves().size())
	# Nouvelle partie, victoire x2, équipement
	var data = pm.new_game(0, "Test")
	print("new:", data["level"], "inv:", data["inventory"].size())
	pm.register_victory(data)
	print("after 1 win: lvl=", data["level"], " loots=", data["last_loots"].size(), " inv=", data["inventory"].size())
	for l in data["last_loots"]:
		print("  loot: ", l["type"], " ", l["name"])
	pm.register_victory(data)
	print("after 2 wins: lvl=", data["level"], " inv=", data["inventory"].size())
	pm.write_save(0, data)
	var back = pm.load_save(0)
	print("reload: lvl=", back["level"], " inv=", back["inventory"].size(), " name=", back["name"])
	# Test équipement
	var team = [{"classe": "Tank", "equipment": {}}]
	back["team"] = team
	var err = pm.equip_item(back, 0, 0)
	print("equip err:", err)
	print("bonuses:", pm.equipment_bonuses(back["team"][0]))
	print("exists before delete:", pm.save_exists(0))
	pm.delete_save(0)
	print("exists after delete:", pm.save_exists(0))
	quit(0)
