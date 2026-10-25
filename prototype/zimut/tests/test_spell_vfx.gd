extends SceneTree
## V47 — effets visuels de sorts : données (statuts/éléments) + pas de fuite de nœuds en combat.
var fails := 0
func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c: fails += 1

func _init() -> void:
	_run.call_deferred()

func _run() -> void:
	# --- données : chaque statut a un style connu, chaque élément a des couleurs
	var styles := ["up", "down", "dome", "stars", "roots", "drip", "embers", "swirl", "target", "ghost", "cross", "crown"]
	for id: String in Combat.STATUS_INFO.keys():
		var st: String = SpellFx.status_style(id, not Combat.NEGATIVE.has(id))
		check(st in styles, "statut %s -> style %s" % [id, st])
	check(SpellFx.status_style("inconnu", true) == "up" and SpellFx.status_style("inconnu", false) == "down", "repli up/down")
	for st2: String in SpellFx.STATUS_VFX.values():
		check(st2 in styles, "style déclaré valide : " + st2)
	for el: String in SpellFx.IMPACT_SPIKES.keys():
		check(SpellFx.ELEMENTS.has(el), "pointes d'impact : élément connu " + el)
	# --- nœuds : se détruisent seuls, Ring différé n'est pas dessiné avant son départ
	var holder := Node2D.new()
	root.add_child(holder)
	var ring := SpellFx.Ring.new()
	ring.t = -0.2
	ring.life = 0.3
	holder.add_child(ring)
	for style: String in styles:
		var m := SpellFx.StatusMark.new()
		m.style = style
		holder.add_child(m)
	var ch := SpellFx.Charge.new()
	holder.add_child(ch)
	var sp := SpellFx.Spikes.new()
	holder.add_child(sp)
	await create_timer(0.1).timeout
	check(holder.get_child_count() == styles.size() + 3, "effets encore présents à 0,1 s")
	await create_timer(1.3).timeout
	check(holder.get_child_count() == 0, "tous les effets se libèrent seuls (reste %d)" % holder.get_child_count())
	holder.queue_free()
	# --- combat : une salve d'événements ne laisse rien dans la couche FX
	var gm: Node = root.get_node("GameManager")
	var pm: Node = root.get_node("ProgressionManager")
	root.get_node("GameSettings").tutorial_done = true
	var data: Dictionary = pm.new_game(4, "VfxTest")
	pm.rebuild_team(data, ["Mage", "Tank", "Chasseur"])
	data["adventure"] = {"zone": "foret_sylve"}
	data["campaign_mode"] = "adventure"
	gm.active_save = data
	gm.active_slot = 4
	gm.set_custom_team([{"classe": "Mage"}, {"classe": "Tank"}, {"classe": "Chasseur"}])
	gm.auto_mode = false
	var main: Node = (load("res://scenes/Main.tscn") as PackedScene).instantiate()
	root.add_child(main)
	await create_timer(1.5).timeout
	var grid: Node = main.get_node("GridManager")
	var layer: Node = grid.get("_fx_layer")
	await create_timer(1.0).timeout
	var base: int = layer.get_child_count()
	var caster: Dictionary = gm.players[0]
	var foe: Dictionary = gm.enemies[0]
	var cp: Vector2i = gm.pos_of(caster)
	var fp: Vector2i = gm.pos_of(foe)
	var cells: Array[Vector2i] = [fp, fp + Vector2i(1, 0), fp + Vector2i(0, 1)]
	for spell: Array in [["Boule de feu", "mag"], ["Gel", "mag"], ["Éclair", "mag"], ["Ronce", "mag"], ["Tremblement de terre", "mag"], ["Frappe", "phys"]]:
		gm.fx.emit("cast", {"caster": caster, "spell": spell[0], "kind": "attack", "dtype": spell[1], "from": cp, "to": fp, "ranged": true, "cells": cells})
		gm.fx.emit("damage", {"target": foe, "attacker": caster, "amount": 5, "crit": false, "dtype": spell[1], "pv_after": int(foe["current_pv"]), "back": false})
	for id: String in ["def_up", "stun", "burn", "regen", "mark"]:
		var info: Dictionary = Combat.STATUS_INFO[id]
		gm.fx.emit("status", {"target": foe, "id": id, "text": String(info["label"]), "color": info["color"], "good": not Combat.NEGATIVE.has(id)})
	await create_timer(0.8).timeout
	check(layer.get_child_count() < 120, "couche FX bornée pendant la salve (%d)" % layer.get_child_count())
	await create_timer(7.0).timeout
	check(layer.get_child_count() <= base + 2, "couche FX revenue au repos (%d, base %d)" % [layer.get_child_count(), base])
	pm.delete_save(4)
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
