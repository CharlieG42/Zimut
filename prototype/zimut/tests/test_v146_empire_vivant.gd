extends SceneTree
## V146 : empire vivant — absence, impôts accumulés, bonus du jour, offensives pendant les autres modes.
## Lancement : godot --headless --path . -s tests/test_v146_empire_vivant.gd
var fails: int = 0
var pm: Node
var CS: GDScript
const T0 := 1800000000
const DAY := 86400
func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1
func _init() -> void:
	_boot.call_deferred()
func _fresh(owned: Array, strong: Array = []) -> Dictionary:
	var data: Dictionary = pm.new_game(4, "V146")
	pm.rebuild_team(data, ["Tank", "Mage", "Sylvain"])
	data["campaign_mode"] = "conquest"
	var g: Dictionary = {}
	var lv: Dictionary = {}
	for id: String in strong:
		lv[id] = 5
		g[id] = {"troops": 12, "hero": ""}
	data["conquest"] = {"owned": owned.duplicate(), "pending_city": "", "garrisons": g, "city_levels": lv, "last_active": T0, "last_tax": T0}
	return data
func _rng() -> RandomNumberGenerator:
	var r := RandomNumberGenerator.new()
	r.seed = 7
	return r
func _boot() -> void:
	pm = root.get_node("/root/ProgressionManager")
	CS = load("res://scripts/ConquestSystem.gd")
	var owned: Array = ["capitale", "clairiere", "hameau_pin", "fort_racine", "col_givre"]
	# ── délai de grâce
	check(CS.absence_offensives_due(2.9) == 0 and CS.absence_offensives_due(3.0) == 1 and CS.absence_offensives_due(5.0) == 2 and CS.absence_offensives_due(400.0) == CS.ABSENCE_MAX_OFFENSIVES,
		"offensives dues : 0 avant 3 jours, 1 à 3 jours, +1 tous les 2 jours, plafonnées")
	var d: Dictionary = _fresh(owned)
	var rep: Dictionary = CS.process_absence(d, d["conquest"], T0 + 2 * DAY, _rng())
	check((rep.get("results", []) as Array).is_empty() and (rep.get("pending", {}) as Dictionary).is_empty() and CS.threat(d["conquest"]).is_empty(), "2 jours d'absence : aucune offensive")
	check(int(rep.get("taxes", 0)) == CS.total_income(d) * 2 and int(rep["taxes"]) > 0, "2 jours d'absence : 2 jours d'impôts encaissés (+%d or)" % int(rep.get("taxes", 0)))
	check(CS.process_absence(d, d["conquest"], T0 + 2 * DAY + 60, _rng()).is_empty(), "rouvrir la carte une minute après : rien de plus")
	# ── impôts plafonnés
	var dt: Dictionary = _fresh(["capitale", "clairiere"])
	var rt: Dictionary = CS.process_absence(dt, dt["conquest"], T0 + 30 * DAY, _rng())
	check(int(rt.get("taxes", 0)) == CS.total_income(dt) * CS.ABSENCE_TAX_DAYS_MAX, "impôts plafonnés à %d jours" % CS.ABSENCE_TAX_DAYS_MAX)
	check((rt.get("results", []) as Array).is_empty() and (rt.get("pending", {}) as Dictionary).is_empty(), "moins de 3 villes : jamais d'offensive d'absence")
	# ── 3 jours : une offensive, laissée en attente pour être défendue
	var d3: Dictionary = _fresh(owned)
	var r3: Dictionary = CS.process_absence(d3, d3["conquest"], T0 + 3 * DAY + 10, _rng())
	check((r3["results"] as Array).is_empty() and not (r3["pending"] as Dictionary).is_empty(), "3 jours : une offensive en attente, rien de perdu")
	check(CS.can_defend(d3["conquest"]) and int(CS.threat(d3["conquest"])["eta"]) == CS.THREAT_ETA, "elle peut être défendue en personne")
	check((d3["conquest"]["owned"] as Array).size() == owned.size(), "3 jours : toutes les villes sont encore là")
	check(CS.process_absence(d3, d3["conquest"], T0 + 3 * DAY + 600, _rng()).is_empty(), "rouvrir la carte sans se battre : pas de seconde offensive le même jour")
	# ── longue absence : pertes plafonnées, capitale intacte
	var dl: Dictionary = _fresh(owned)
	var rl: Dictionary = CS.process_absence(dl, dl["conquest"], T0 + 60 * DAY, _rng())
	var lost: int = 0
	for r: Dictionary in rl["results"]:
		if String(r["outcome"]) == "lost":
			lost += 1
	check((rl["results"] as Array).size() == CS.ABSENCE_MAX_OFFENSIVES - 1 and not (rl["pending"] as Dictionary).is_empty(), "60 jours : %d offensives réglées + 1 en attente" % (CS.ABSENCE_MAX_OFFENSIVES - 1))
	check(lost == CS.ABSENCE_MAX_LOST, "60 jours sans garnison : %d villes perdues, pas plus (%d)" % [CS.ABSENCE_MAX_LOST, lost])
	check((dl["conquest"]["owned"] as Array).has("capitale") and (dl["conquest"]["owned"] as Array).size() == owned.size() - CS.ABSENCE_MAX_LOST, "la capitale et les autres villes restent à l'empire")
	check((dl["conquest"].get("lost", []) as Array).size() == CS.ABSENCE_MAX_LOST, "les villes tombées sont « perdues » : reprise en une bataille")
	check(String(rl.get("text", "x")) != "" , "bilan produit")
	# ── la préparation protège : villes bien gardées, rien ne tombe
	var ds: Dictionary = _fresh(owned, ["clairiere", "hameau_pin", "fort_racine", "col_givre"])
	var rs: Dictionary = CS.process_absence(ds, ds["conquest"], T0 + 60 * DAY, _rng())
	var held := true
	for r2: Dictionary in rs["results"]:
		if String(r2["outcome"]) != "repelled":
			held = false
	check(held and (ds["conquest"]["owned"] as Array).size() == owned.size(), "villes bien gardées : toutes les offensives repoussées")
	# ── une bataille remet l'absence à zéro
	CS.touch_activity(dl["conquest"], T0 + 60 * DAY)
	check(CS.process_absence(dl, dl["conquest"], T0 + 61 * DAY, _rng()).get("results", []).is_empty(), "après une bataille, le délai de grâce repart")
	var dn: Dictionary = _fresh(owned)
	check(CS.seconds_before_absence(dn["conquest"], T0 + DAY) == 2 * DAY, "prochaine offensive d'absence dans 2 jours")
	check(CS.seconds_before_absence(dl["conquest"], T0 + 61 * DAY) == 0, "moins de 3 villes conquises : pas d'offensive à annoncer")
	# ── horloge reculée : rien de simulé, rien de gagné
	var dc: Dictionary = _fresh(owned)
	var g0: int = int(dc.get("gold", 0))
	check(CS.process_absence(dc, dc["conquest"], T0 - 10 * DAY, _rng()).is_empty() and int(dc.get("gold", 0)) == g0, "horloge reculée : ni offensive ni impôts")
	# ── bilan lisible, via ProgressionManager
	var dp: Dictionary = _fresh(owned)
	pm.conquest_clock_override = T0 + 9 * DAY
	var rp: Dictionary = pm.conquest_process_absence(dp)
	check(String(rp.get("text", "")).contains("jours sans bataille") and String(rp["text"]).contains("Impôts encaissés"), "bilan « Pendant votre absence » rédigé")
	# ── première victoire du jour : revenus doublés, une seule fois
	var dv: Dictionary = _fresh(["capitale", "clairiere", "hameau_pin"])
	pm.conquest_clock_override = T0 + DAY
	var inc: int = CS.total_income(dv)
	check(CS.daily_bonus(dv, dv["conquest"], 100) == inc and CS.daily_bonus(dv, dv["conquest"], 100) == 0 and CS.daily_bonus(dv, dv["conquest"], 101) == inc, "bonus du jour : une fois par jour")
	dv["conquest"]["pending_city"] = "fort_racine"
	dv["conquest"]["pending_level"] = 1
	pm.register_victory(dv, {"enemies": [], "turns": 5})
	check(int(dv["conquest"]["last_active"]) == T0 + DAY, "une bataille de Conquête note la présence")
	var told := false
	for line: Variant in dv["conquest"].get("news", []):
		if String(line).contains("Première victoire du jour"):
			told = true
	check(told, "première victoire du jour annoncée")
	# ── autres modes : l'empire vit
	var da: Dictionary = _fresh(owned)
	da["campaign_mode"] = ""
	var alerts: int = 0
	var ro := _rng()
	for i: int in range(60):
		if CS.outside_victory(da, da["conquest"], ro, pm.CONQUEST_ROUTES) != "":
			alerts += 1
	check(alerts > 0, "victoires hors Conquête : des offensives sont annoncées ou avancent (%d alertes en 60 victoires)" % alerts)
	check(int(da["conquest"].get("last_active", 0)) == T0, "…sans compter comme une présence en Conquête")
	var small: Dictionary = _fresh(["capitale", "clairiere"])
	var quiet := true
	for i2: int in range(30):
		if CS.outside_victory(small, small["conquest"], ro, pm.CONQUEST_ROUTES) != "":
			quiet = false
	check(quiet and CS.threat(small["conquest"]).is_empty(), "moins de 3 villes : l'empire n'est pas inquiété")
	# ── notification : délai calculé, sans module natif rien n'est programmé mais rien ne casse
	var N: GDScript = load("res://scripts/Notifier.gd")
	check(N.schedule_absence_warning(3 * DAY) == 2 * DAY and N.schedule_absence_warning(DAY / 2) == 0 and N.schedule_absence_warning(0) == 0, "rappel programmé un jour avant l'offensive")
	pm.conquest_clock_override = 0
	pm.delete_save(4)
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
