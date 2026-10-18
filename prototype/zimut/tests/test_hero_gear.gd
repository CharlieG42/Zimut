extends SceneTree
## Équipement par héros (équipe ou non) : équiper, retirer, suivre le héros, gouverneur, briser en lot.
## godot --headless --path . -s tests/test_hero_gear.gd
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
	var data: Dictionary = pm.new_game(4, "GearTest")
	pm.rebuild_team(data, ["Tank", "Mage", "Heal"])
	var arme := {"type": "Épée (1 main)", "name": "Épée test", "level": 1, "rarity": "rare", "force": 10}
	var casque := {"type": "Casque", "name": "Casque test", "level": 1, "rarity": "commun", "defense": 6}
	data["inventory"] = [arme.duplicate(), casque.duplicate(), {"type": "Bague", "name": "Bague test", "level": 1, "rarity": "commun", "force": 2}]
	# Héros hors équipe (Assassin)
	_ok(pm.equip_hero_item(data, "Assassin", 0) == "", "équiper un héros hors équipe")
	_ok(pm.hero_equipment(data, "Assassin").has("arme"), "arme portée par l'Assassin (roster)")
	_ok(data["inventory"].size() == 2, "objet retiré de l'inventaire")
	_ok(pm.hero_gear_power(data, "Assassin") == 10, "puissance du stuff = 10")
	# Membre d'équipe
	_ok(pm.equip_hero_item(data, "Tank", 0) == "", "équiper un membre d'équipe")
	_ok(data["team"][0]["equipment"].has("casque"), "casque dans l'équipement du membre")
	_ok(pm.unequip_hero_item(data, "Tank", "casque") == "", "retirer")
	_ok(data["inventory"].size() == 2, "objet revenu à l'inventaire")
	# Le stuff suit le héros : Assassin entre dans l'équipe
	pm.rebuild_team(data, ["Assassin", "Mage", "Heal"])
	_ok(data["team"][0]["equipment"].has("arme"), "l'Assassin retrouve son arme en rejoignant l'équipe")
	_ok(not data["roster"]["Assassin"].has("equipment"), "plus de doublon dans le roster")
	# Il sort de l'équipe sans être gouverneur : son stuff retourne à l'inventaire
	var inv_n: int = data["inventory"].size()
	pm.rebuild_team(data, ["Tank", "Mage", "Heal"])
	_ok(not pm.hero_equipment(data, "Assassin").has("arme"), "héros écarté (non gouverneur) : stuff rendu à l'inventaire")
	_ok(data["inventory"].size() == inv_n + 1, "l'inventaire récupère son arme")
	# Gouverneur : il garde son stuff en quittant l'équipe, et le stuff compte
	pm.rebuild_team(data, ["Assassin", "Mage", "Heal"])
	pm.equip_hero_item(data, "Assassin", data["inventory"].size() - 1)   # (l'arme équipée est la dernière entrée)
	var conq: Dictionary = data.get("conquest", {})
	var base_def: int = ConquestSystem.defense(data, "capitale")
	conq["owned"] = ["capitale"]
	conq["garrisons"] = {"capitale": {"hero": "Assassin", "troops": 0}}
	data["conquest"] = conq
	pm.rebuild_team(data, ["Tank", "Mage", "Heal"])
	_ok(pm.hero_equipment(data, "Assassin").size() >= 1, "gouverneur écarté de l'équipe : il garde son stuff")
	var def_with: int = ConquestSystem.defense(data, "capitale")
	pm.unequip_hero_item(data, "Assassin", "arme")
	var def_without: int = ConquestSystem.defense(data, "capitale")
	_ok(def_with >= def_without, "défense avec stuff >= sans stuff (%d / %d)" % [def_with, def_without])
	var big := {"type": "Armure", "name": "Armure test", "level": 1, "rarity": "legendaire", "defense": 80, "force": 40}
	data["inventory"].append(big)
	pm.equip_hero_item(data, "Assassin", data["inventory"].size() - 1)
	_ok(ConquestSystem.defense(data, "capitale") > def_without, "le stuff augmente la défense de la ville")
	_ok(ConquestSystem.governor_gear_defense(data, "Assassin") <= ConquestSystem.GEAR_DEF_MAX, "bonus plafonné")
	# Briser en lot (libre + porté)
	var worn: Dictionary = pm.hero_equipment(data, "Assassin")["armure"]
	var free_it: Dictionary = data["inventory"][0]
	var res: Dictionary = pm.salvage_many(data, [free_it, worn])
	_ok(int(res["count"]) == 2, "2 objets brisés (count=%d)" % int(res["count"]))
	_ok(not pm.hero_equipment(data, "Assassin").has("armure"), "l'objet porté a été retiré avant d'être brisé")
	_ok(not (res["gains"] as Dictionary).is_empty(), "des ressources sont rendues")
	# Forge : objets améliorables des héros hors équipe
	pm.equip_hero_item(data, "Assassin", 0)
	var ups: Array = pm.upgradable_items(data)
	_ok(ups.any(func(e: Dictionary) -> bool: return String(e["src"]) == "hero"), "upgradable_items inclut le stuff d'un héros hors équipe")
	pm.delete_save(4)
	print("RÉSULTAT : ", "OK" if _fails == 0 else "%d échec(s)" % _fails)
	quit(1 if _fails > 0 else 0)
