extends SceneTree
## Cinématique 3D d'ouverture (héros vs boss entre Intro et MainMenu). Le rendu 3D ne se teste
## pas en headless (pas de GPU) : on vérifie ici le réglage, le routage Intro -> cinématique ->
## accueil, la présence des modèles, et la construction logique de la scène (acteurs, caméra,
## letterbox, timeline, passage).
## Lancement : godot --headless --path . -s tests/test_cinematic3d.gd
var fails: int = 0
func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	await process_frame
	var gs: Node = root.get_node("GameSettings")
	var Cin = preload("res://scripts/Cinematic3D.gd")
	var IntroUI = preload("res://scripts/IntroUI.gd")
	check(bool(gs.get("cinematic_3d")), "réglage « cinematic_3d » activé par défaut (PC)")
	check(Cin.enabled(), "Cinematic3D.enabled() vrai par défaut")
	check(Cin.SCENE == "res://scenes/Cinematic3D.tscn" and ResourceLoader.exists(Cin.SCENE), "scène Cinematic3D.tscn présente")
	check(IntroUI.next_scene() == Cin.SCENE, "IntroUI mène à la cinématique quand elle est activée")
	# routage : réglage éteint -> directement l'accueil
	gs.set("cinematic_3d", false)
	check(not Cin.enabled() and IntroUI.next_scene() == IntroUI.MENU_SCENE, "réglage éteint : IntroUI -> MainMenu directement")
	gs.set("cinematic_3d", true)
	# tous les modèles de la distribution existent
	var keys: Array = Cin.LINEUP.duplicate()
	for b in Cin.BOSSES:
		keys.append(String(b["model"]))
	var models_ok: bool = true
	for k in keys:
		var p: String = String((Hero3D.MODELS[k] as Dictionary)["path"])
		if not ResourceLoader.exists(p):
			models_ok = false
			print("   modèle introuvable : ", p)
	check(models_ok and keys.size() == 6, "les 6 modèles de la distribution (5 héros + boss) existent")
	# construction de la scène en headless
	var ps: PackedScene = load(Cin.SCENE)
	check(ps != null, "la scène se charge")
	var cin = ps.instantiate()
	root.add_child(cin)
	await process_frame
	await process_frame
	check(cin._actors.size() == Cin.LINEUP.size() + Cin.BOSSES.size(), "7 acteurs instanciés (5 héros + 2 boss)")
	var holders_ok: bool = true
	var aps_ok: bool = true
	for a in cin._actors:
		if a["holder"] == null:
			holders_ok = false
		if a["ap"] == null:
			aps_ok = false
	check(holders_ok, "chaque acteur a son modèle instancié")
	check(aps_ok, "chaque acteur a son AnimationPlayer jouant le clip de marche")
	check(cin._cam != null and cin._cam.current, "caméra active")
	check(cin._bar_top != null and cin._bar_bot != null and cin._fade != null, "letterbox + fondu présents")
	check(cin._t >= 0.0 and not cin._leaving, "timeline lancée")
	# on avance la timeline : entrées, assauts et flash se déclenchent sans erreur
	cin._t = 7.5
	await process_frame
	await process_frame
	check(cin._did.size() >= 6, "les assauts des héros et des boss se sont déclenchés (%d)" % cin._did.size())
	var once: bool = false
	for a in cin._actors:
		if a["mode"] == "once":
			once = true
	check(once, "au moins un acteur joue un clip d'attaque one-shot")
	# retour à la marche après le one-shot
	cin._t = 9.5
	await process_frame
	await process_frame
	var back: bool = true
	for a in cin._actors:
		if a["mode"] != "walk":
			back = false
	check(back, "les acteurs reviennent en marche après leur assaut")
	# un appui passe la cinématique
	cin._skip()
	check(cin._leaving, "_skip() arrête la cinématique")
	cin.queue_free()
	print("FIN : ", fails, " échec(s)")
	quit(1 if fails > 0 else 0)
