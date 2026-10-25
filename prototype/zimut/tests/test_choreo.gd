extends SceneTree
## V33 : chorégraphies d'attaque distinctes par sort, stables d'un lancer à l'autre.
var fails: int = 0
func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1
func _init() -> void:
	_boot.call_deferred()
func _sig(v: EntityView, kind: String, key: String) -> String:
	v.play_pose(kind, 0.6, key)
	var parts: Array = [str(v._act_tex.resource_path.get_file())]
	for st in v._seq:
		parts.append((st[0] as Texture2D).resource_path.get_file())
	v._seq.clear()
	v._act_tex = null
	return "+".join(parts)
func _boot() -> void:
	await process_frame
	var total_variety: int = 0
	for c: String in ["Chasseur", "Tank", "Mage", "Assassin", "Druide", "Heal", "Invocateur", "Sylvain", "Géomancien", "Artificier"]:
		var v := EntityView.new()
		root.add_child(v)
		v.setup({"uid": 5, "classe": c, "team": "player", "entity_type": "Player", "current_pv": 10, "max_pv": 10, "x": 2, "y": 3})
		var sigs: Dictionary = {}
		var spells: Array = []
		for s in root.get_node("GameManager")._build_spells(c, 100):
			spells.append(String(s["name"]))
		for nm: String in spells:
			sigs[_sig(v, "attack", nm)] = true
		check(_sig(v, "attack", spells[0]) == _sig(v, "attack", spells[0]), "%s : même sort = même animation" % c)
		print("   %s : %d animations différentes pour %d sorts (%d poses d'attaque)" % [c, sigs.size(), spells.size(), (v._poses.get("attack", []) as Array).size()])
		# Au moins 3 animations… dans la limite des poses dessinées (Druide V45 : 1 attaque + 1 sort de face).
		var avail: int = (v._poses.get("attack", []) as Array).size() + (v._poses.get("cast", []) as Array).size()
		var need: int = mini(3, maxi(1, avail))
		check(sigs.size() >= need, "%s : au moins %d animations différentes (%d poses d'action de face)" % [c, need, avail])
		v.queue_free()
	print("ÉCHECS : ", fails)
	quit(0 if fails == 0 else 1)
