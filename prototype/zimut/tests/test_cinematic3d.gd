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
	# valeur par défaut du CODE (instance fraîche, sans load_settings) : activée hors mobile
	var fresh = (load("res://scripts/GameSettings.gd") as GDScript).new()
	check(bool(fresh.get("cinematic_3d")) == (not OS.has_feature("mobile")), "cinematic_3d : activé par défaut hors mobile, éteint sur mobile")
	fresh.free()
	gs.set("cinematic_3d", true)
	check(Cin.enabled(), "Cinematic3D.enabled() vrai quand le réglage est actif")
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
	check(models_ok and keys.size() == Cin.LINEUP.size() + Cin.BOSSES.size(), "les modèles de la distribution existent (%d acteurs : 5 héros + 2 boss)" % keys.size())
	check(String((Cin.BOSSES[0] as Dictionary)["model"]) != String((Cin.BOSSES[1] as Dictionary)["model"]), "les deux boss ont des modèles différents (%s / %s)" % [String((Cin.BOSSES[0] as Dictionary)["model"]), String((Cin.BOSSES[1] as Dictionary)["model"])])
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
	check(cin._bars.size() == Cin.BOSSES.size(), "une barre de PV par boss (%d)" % cin._bars.size())
	check(cin._t >= 0.0 and not cin._leaving, "timeline lancée")
	# combat : roar + 5 assauts de héros + 5 impacts déclenchés à t = 9, PV des boss à jour
	cin._t = 9.0
	await process_frame
	await process_frame
	# Les deux boss sont de vrais modèles de boss (aucun modèle de héros jouable côté ennemi)
	var boss_models: Array = Hero3D.BOSS_MODEL.values()
	var hero_models: Array = Hero3D.CLASS_MODEL.values()
	var bosses_ok: bool = true
	for bb in Cin.BOSSES:
		if not boss_models.has(String(bb["model"])) or hero_models.has(String(bb["model"])):
			bosses_ok = false
	check(bosses_ok, "les deux boss de l'opening sont de vrais modèles de boss (pas un héros)")
	check(cin._fx.size() > 0, "effets visuels créés (entrées / combat) : %d en cours" % cin._fx.size())
	check(cin._did.has("roar") and cin._did.has("atk0") and cin._did.has("atk4") and cin._did.has("imp4"), "roar + assauts des héros + impacts déclenchés (%d événements)" % cin._did.size())
	var once: bool = false
	for a in cin._actors:
		if a["mode"] == "once":
			once = true
	check(once, "au moins un acteur joue un clip d'attaque one-shot")
	var n: int = Cin.LINEUP.size()
	check(int(cin._actors[n]["hp"]) == Cin.BOSS_HP - 3 * Cin.DMG, "boss de gauche : 3 impacts -> PV %d" % int(cin._actors[n]["hp"]))
	check(int(cin._actors[n + 1]["hp"]) == Cin.BOSS_HP - 2 * Cin.DMG, "boss de droite : 2 impacts -> PV %d" % int(cin._actors[n + 1]["hp"]))
	check(not bool(cin._actors[n]["dead"]) and not bool(cin._actors[n + 1]["dead"]), "aucun boss abattu à t = 9")
	# impact final à t = 10,3 : le premier boss chute
	cin._t = 10.5
	await process_frame
	await process_frame
	check(cin._did.has("imp_final") and bool(cin._actors[n]["dead"]), "impact final : le premier boss est abattu")
	check(not bool(cin._actors[n + 1]["dead"]), "le second boss tient encore")
	# retour à la marche après les one-shots (boss vivant compris ; la volée a pu être
	# déclenchée tard si le test saute _t par paliers : on laisse 1,4 s de marge)
	cin._t = 12.2
	await process_frame
	await process_frame
	var back: bool = true
	for a in cin._actors:
		if not bool(a.get("dead", false)) and a["mode"] != "walk":
			back = false
	check(back, "les acteurs vivants reviennent en marche après leurs assauts")
	# un appui passe la cinématique
	cin._skip()
	check(cin._leaving, "_skip() arrête la cinématique")
	cin.queue_free()
	# la bascule des Réglages pilote bien le réglage (options [Désactivée, Activée] : off = 0, on = 1)
	# (chargée à l'exécution : elle référence l'autoload GameSettings, indisponible à la compilation en -s)
	gs.set("cinematic_3d", false)
	var sui = (load("res://scripts/SettingsUI.gd") as GDScript).new()
	root.add_child(sui)
	await process_frame
	await process_frame
	var cell: Control = _find_cell(sui, "Cinématique 3D d'ouverture")
	check(cell != null, "bascule « Cinématique 3D d'ouverture » présente dans Réglages")
	if cell != null:
		var btns: Array = []
		for c in cell.get_children():
			if c is HBoxContainer:
				for b in c.get_children():
					if b is Button:
						btns.append(b)
		check(btns.size() == 2 and (btns[0] as Button).text == "Désactivée" and (btns[1] as Button).text == "Activée",
			"options [Désactivée, Activée] (off = 0, on = 1)")
		(btns[1] as Button).pressed.emit()
		check(bool(gs.get("cinematic_3d")) and Cin.enabled() and IntroUI.next_scene() == Cin.SCENE,
			"clic « Activée » -> cinématique lancée après l'intro")
		(btns[0] as Button).pressed.emit()
		check(not bool(gs.get("cinematic_3d")) and IntroUI.next_scene() == IntroUI.MENU_SCENE,
			"clic « Désactivée » -> intro vers l'accueil directement")
	sui.queue_free()
	gs.call("set_cinematic_3d", true)   # restaure le réglage (et le fichier) pour les tests suivants
	print("FIN : ", fails, " échec(s)")
	quit(1 if fails > 0 else 0)
func _find_cell(n: Node, label: String) -> Control:
	if n is VBoxContainer:
		for c in n.get_children():
			if c is Label and (c as Label).text == label:
				return n as Control
	for c in n.get_children():
		var r := _find_cell(c, label)
		if r != null:
			return r
	return null
