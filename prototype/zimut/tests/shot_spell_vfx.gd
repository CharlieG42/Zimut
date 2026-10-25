extends SceneTree
## Capture V47 : effets visuels de sorts (lanceur + cible), émis directement sur le bus d'effets du combat.
## xvfb-run -a godot --rendering-method gl_compatibility --path . -s tests/shot_spell_vfx.gd -- <dossier>
func _init() -> void:
	_boot.call_deferred()

func _shot(dir: String, name: String) -> void:
	root.get_viewport().get_texture().get_image().save_png(dir + "/" + name + ".png")

func _boot() -> void:
	var args: PackedStringArray = OS.get_cmdline_user_args()
	var dir: String = args[0] if args.size() > 0 else "/tmp/shots"
	DirAccess.make_dir_recursive_absolute(dir)
	var gm: Node = root.get_node("GameManager")
	var pm: Node = root.get_node("ProgressionManager")
	root.get_node("GameSettings").tutorial_done = true
	var data: Dictionary = pm.new_game(4, "VfxShot")
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
	var caster: Dictionary = gm.players[0]
	var ally: Dictionary = gm.players[1]
	var foe: Dictionary = gm.enemies[0]
	var cp: Vector2i = gm.pos_of(caster)
	var fp: Vector2i = gm.pos_of(foe)
	var ap: Vector2i = gm.pos_of(ally)
	var cells: Array[Vector2i] = [fp, fp + Vector2i(1, 0), fp + Vector2i(0, 1), fp + Vector2i(-1, 0)]
	# 1) boule de feu de zone : charge du lanceur, projectile, impact + onde
	gm.fx.emit("cast", {"caster": caster, "spell": "Boule de feu", "kind": "attack", "dtype": "mag", "from": cp, "to": fp, "ranged": true, "cells": cells})
	await create_timer(0.14).timeout
	_shot(dir, "vfx_1_charge")
	gm.fx.emit("damage", {"target": foe, "attacker": caster, "amount": 31, "crit": false, "dtype": "mag", "pv_after": 20, "back": false})
	await create_timer(0.9).timeout
	_shot(dir, "vfx_2_impact")
	# 2) soin à distance sur un allié
	gm.fx.emit("cast", {"caster": caster, "spell": "Soin", "kind": "heal", "dtype": "mag", "from": cp, "to": ap, "ranged": true, "cells": [ap] as Array[Vector2i]})
	await create_timer(0.45).timeout
	gm.fx.emit("heal", {"target": ally, "amount": 12, "pv_after": int(ally["max_pv"])})
	await create_timer(0.3).timeout
	_shot(dir, "vfx_3_soin")
	await create_timer(1.0).timeout
	# 3) statuts sur plusieurs cibles
	var ids: Array = ["def_up", "stun", "poison", "root", "dmg_up", "curse"]
	var targets: Array = [ally, foe, gm.enemies[1], gm.enemies[2], caster, gm.players[2]]
	for i: int in range(ids.size()):
		var info: Dictionary = Combat.STATUS_INFO[ids[i]]
		gm.fx.emit("status", {"target": targets[i], "id": ids[i], "text": String(info["label"]), "color": info["color"], "good": not Combat.NEGATIVE.has(ids[i])})
	await create_timer(0.55).timeout
	_shot(dir, "vfx_4_statuts")
	pm.delete_save(4)
	quit(0)
