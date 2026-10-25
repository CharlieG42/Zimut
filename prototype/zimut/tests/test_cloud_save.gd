extends SceneTree
## V49 : sauvegarde Cloud (contenu, restauration, écran Options) — sans réseau.
var fails: int = 0
func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var pm: Node = root.get_node("ProgressionManager")
	var CS: GDScript = load("res://scripts/CloudSave.gd")
	# sauvegarde locale de test
	var d: Dictionary = pm.new_game(4, "Nuage")
	d["gold"] = 1234
	pm.write_save(4, d)
	var bundle: Dictionary = CS.build_bundle()
	check(String(bundle["format"]) == "zimut-cloud-1" and (bundle["saves"] as Dictionary).has("4"), "le paquet contient la partie de l'emplacement 5")
	check(CS.describe(bundle).contains("Nuage"), "résumé lisible : " + CS.describe(bundle))
	# aller-retour JSON (comme sur Drive)
	var back: Dictionary = JSON.parse_string(JSON.stringify(bundle))
	pm.delete_save(4)
	check(not pm.save_exists(4), "partie locale supprimée")
	var n: int = CS.apply_bundle(back)
	check(n >= 1 and pm.save_exists(4), "restauration : partie réécrite (%d)" % n)
	check(int(pm.load_save(4).get("gold", 0)) == 1234, "contenu identique après restauration")
	check(CS.apply_bundle({"format": "autre"}) == -1, "format inconnu refusé")
	# config absente : non configuré, pas de jeton
	var had_cfg: bool = FileAccess.file_exists("user://cloud_oauth.json")
	if not had_cfg and not FileAccess.file_exists("res://cloud_oauth.json"):
		check(not CS.is_configured(), "sans identifiants : non configuré")
	var f := FileAccess.open("user://cloud_oauth.json", FileAccess.WRITE)
	f.store_string('{"client_id": "test.apps.googleusercontent.com", "client_secret": "x"}')
	f.close()
	check(CS.is_configured(), "avec identifiants : configuré")
	if not had_cfg:
		DirAccess.remove_absolute(ProjectSettings.globalize_path("user://cloud_oauth.json"))
	# écran Options
	var sc: Node = (load("res://scenes/Settings.tscn") as PackedScene).instantiate() if ResourceLoader.exists("res://scenes/Settings.tscn") else null
	if sc != null:
		root.add_child(sc)
		await create_timer(0.4).timeout
		check(sc.find_child("CloudBackup", true, false) != null and sc.find_child("CloudRestore", true, false) != null, "Options : boutons Sauvegarde / Restauration Cloud")
		sc._show_code("ABCD-EFGH", "https://www.google.com/device")
		await process_frame
		check(String(sc._code_label.text) == "ABCD-EFGH", "fenêtre du code Google affichée")
		sc._hide_code()
	else:
		check(false, "scène Settings introuvable")
	pm.delete_save(4)
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
