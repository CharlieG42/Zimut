extends SceneTree
## V71 : ligne d'état de la sauvegarde Cloud auto sur l'écran de résultat (réseau coupé = avertissement).
var fails: int = 0
func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var gm: Node = root.get_node("GameManager")
	var gs: Node = root.get_node("GameSettings")
	gs.tutorial_done = true
	gm.set_custom_team([{"classe": "Tank"}, {"classe": "Assassin"}, {"classe": "Mage"}])
	var main: Node = (load("res://scenes/Main.tscn") as PackedScene).instantiate()
	root.add_child(main)
	await create_timer(1.0).timeout
	var ui: Node = main.get_node("UIManager")
	var vb := VBoxContainer.new()
	root.add_child(vb)
	# option désactivée : aucune ligne
	gs.cloud_auto = false
	ui._result_cloud_line(vb)
	check(vb.get_child_count() == 0, "option désactivée : pas de ligne d'état")
	# option active + compte relié (faux jeton) + réseau inaccessible : avertissement
	var f := FileAccess.open("user://cloud_token.json", FileAccess.WRITE)
	f.store_string('{"refresh_token":"x"}'); f.close()
	var f2 := FileAccess.open("user://cloud_oauth.json", FileAccess.WRITE)
	f2.store_string('{"client_id":"a","client_secret":"b"}'); f2.close()
	gs.cloud_auto = true
	var CS: GDScript = load("res://scripts/CloudSave.gd")
	check(CS.auto_enabled(self), "option active + compte relié : envoi activé")
	ui._result_cloud_line(vb)
	check(vb.get_child_count() == 1, "ligne d'état ajoutée")
	var lbl: Label = vb.get_child(0)
	check(lbl.text.contains("Sauvegarde sur Google Drive"), "état : envoi en cours (« %s »)" % lbl.text)
	var waited: float = 0.0
	while lbl.text.contains("Sauvegarde sur Google Drive…") and waited < 25.0:
		await create_timer(0.5).timeout
		waited += 0.5
	print("   résultat : ", lbl.text)
	check(lbl.text.begins_with("⚠") or lbl.text.begins_with("☁  ✓"), "état final affiché")
	DirAccess.remove_absolute(ProjectSettings.globalize_path("user://cloud_token.json"))
	DirAccess.remove_absolute(ProjectSettings.globalize_path("user://cloud_oauth.json"))
	gs.cloud_auto = false
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
