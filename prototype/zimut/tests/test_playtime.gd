extends SceneTree
## V46 : compteur de temps de jeu par partie (total + par mode).
var fails := 0
func ck(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c: fails += 1

func _init() -> void:
	_run.call_deferred()

func _run() -> void:
	var pm: Node = root.get_node("ProgressionManager")
	var pt: Node = root.get_node("PlayTimer")
	ck(pt != null, "autoload PlayTimer présent")

	# Nouvelle partie : champs de temps initialisés à 0
	var d: Dictionary = pm.new_game(3, "Horloge")
	ck(pm.playtime_total(d) == 0, "nouvelle partie : temps total = 0")
	ck(pm.playtime_mode(d, "tactique") == 0 and pm.playtime_mode(d, "adventure") == 0
		and pm.playtime_mode(d, "conquest") == 0, "nouvelle partie : temps par mode = 0")

	# add_playtime : incrémente le total et le mode, et persiste sur disque
	pm.add_playtime(3, d, "tactique", 90.0)
	pm.add_playtime(3, d, "tactique", 30.0)
	pm.add_playtime(3, d, "adventure", 3661.0)
	var r: Dictionary = pm.load_save(3)
	ck(pm.playtime_total(r) == 3781, "total persisté = 90+30+3661 = %d s" % pm.playtime_total(r))
	ck(pm.playtime_mode(r, "tactique") == 120, "tactique = 120 s")
	ck(pm.playtime_mode(r, "adventure") == 3661, "adventure = 3661 s")
	ck(pm.playtime_mode(r, "conquest") == 0, "conquest = 0 s (non joué)")

	# list_saves expose le temps total pour l'affichage des vignettes
	var found: bool = false
	for sv: Dictionary in pm.list_saves():
		if int(sv["id"]) == 3:
			found = true
			ck(int(sv["playtime"]) == 3781, "list_saves : playtime = %d" % int(sv["playtime"]))
	ck(found, "list_saves : la partie 4 est listée")

	# Migration : une ancienne sauvegarde sans les champs est complétée au chargement
	var legacy: Dictionary = pm.new_game(4, "Ancienne")
	legacy.erase("playtime")
	legacy.erase("playtime_modes")
	pm.write_save(4, legacy)
	var rl: Dictionary = pm.load_save(4)
	ck(rl.has("playtime") and pm.playtime_total(rl) == 0, "migration : playtime ajouté (= 0)")
	ck(rl.has("playtime_modes") and pm.playtime_mode(rl, "tactique") == 0, "migration : playtime_modes ajouté")

	# Le compteur en mémoire reflète la sauvegarde active (GameManager)
	var gm: Node = root.get_node("GameManager")
	gm.active_slot = 3
	gm.active_save = pm.load_save(3)
	pt.flush()
	pt.resume_tactique()
	ck(pt.get("_running") == true and String(pt.get("_mode")) == "tactique", "timer démarré en mode tactique")
	# Simule 2 s de jeu et force l'écriture
	pt.set("_elapsed", 2.0)
	pt.flush()
	var r2: Dictionary = pm.load_save(3)
	ck(pm.playtime_total(r2) == 3783, "timer : +2 s persistés (%d)" % pm.playtime_total(r2))
	ck(pm.playtime_mode(r2, "tactique") == 122, "timer : mode tactique incrémenté (122 s)")

	# Sans partie active, rien n'est écrit
	gm.active_save = {}
	gm.active_slot = -1
	pt.set("_elapsed", 5.0)
	pt.flush()
	var r3: Dictionary = pm.load_save(3)
	ck(pm.playtime_total(r3) == 3783, "sans partie active : le temps n'est pas écrit")

	# Formatage des durées
	ck(ProgressionManager.format_playtime(0) == "0 s", "format 0 s")
	ck(ProgressionManager.format_playtime(45) == "45 s", "format 45 s")
	ck(ProgressionManager.format_playtime(120) == "2 min", "format 2 min")
	ck(ProgressionManager.format_playtime(3661) == "1 h 01", "format 1 h 01")

	pm.delete_save(3)
	pm.delete_save(4)
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
