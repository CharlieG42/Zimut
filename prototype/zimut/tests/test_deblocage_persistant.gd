extends SceneTree
## V64c : un héros débloqué depuis « Gérer l'équipe » (Mes Parties) doit survivre au changement
## d'écran. Avant : ce bouton n'activait pas l'emplacement de sauvegarde, donc rien n'était écrit.
var fails: int = 0
func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var pm: Node = root.get_node("ProgressionManager")
	var gm: Node = root.get_node("GameManager")
	root.get_node("GameSettings").tutorial_enabled = false
	var d: Dictionary = pm.new_game(4, "Persist")
	HeroUnlock.pick_initial(d, ["Tank", "Heal", "Mage"])
	d["player"] = {"level": 4, "xp": pm.xp_for_level(4)}
	pm.write_save(4, d)
	gm.active_slot = -1
	gm.active_save = {}

	var sc: Node = (load("res://scenes/SaveSlots.tscn") as PackedScene).instantiate()
	root.add_child(sc)
	await create_timer(0.6).timeout
	sc._on_slot_pressed(4)
	await create_timer(0.6).timeout
	var team_btn: Button = null
	for b: Node in sc.find_children("*", "Button", true, false):
		if (b as Button).tooltip_text.begins_with("Gérer l'équipe"):
			team_btn = b as Button
	check(team_btn != null, "bouton « Gérer l'équipe » trouvé")
	if team_btn != null:
		team_btn.pressed.emit()
	check(gm.active_slot == 4, "« Gérer l'équipe » active l'emplacement de la partie (slot %d)" % gm.active_slot)
	check(not gm.active_save.is_empty() and String(gm.active_save.get("name", "")) == "Persist", "… et charge la bonne partie")
	check(HeroUnlock.pending_unlocks(gm.active_save) == 1, "un déblocage est en attente au niveau 4")

	# Le joueur débloque l'Assassin dans la fenêtre de choix, puis ferme tout : la partie sur disque doit le contenir.
	var ui: HeroPickUI = HeroPickUI.open(root, gm.active_save, false, func(_p: Array) -> void: pass)
	await process_frame
	ui._picked = ["Assassin"]
	ui._on_confirm()
	await process_frame
	var reloaded: Dictionary = pm.load_save(4)
	check((reloaded.get("heroes_unlocked", []) as Array).has("Assassin"), "héros débloqué écrit sur le disque dès la confirmation")
	check(HeroUnlock.pending_unlocks(reloaded) == 0, "… et le déblocage n'est plus proposé")
	pm.delete_save(4)
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
