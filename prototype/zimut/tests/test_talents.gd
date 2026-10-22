extends SceneTree
## test_talents.gd — Tests headless de l'arbre de talents PAR PERSONNAGE (V42 refonte).
## Lancement : godot --headless -s tests/test_talents.gd --path .

var failures: int = 0

func _init() -> void:
	_test_talent_basics()
	_test_talent_paliers()
	_test_talent_bonus_aggregation()
	_test_member_stats_integration()
	_test_synergy_trios()
	_test_speedrun_settings()
	print("")
	if failures > 0:
		print("ÉCHEC : %d test(s) en erreur." % failures)
		quit(1)
	else:
		print("OK : tous les tests passent.")
		quit(0)

func _check(cond: bool, label: String) -> void:
	if cond:
		print("  ok  %s" % label)
	else:
		failures += 1
		print("  KO  %s" % label)

## Fabrique une sauvegarde minimale avec un roster complet.
func _make_save(classe: String, level: int) -> Dictionary:
	var data: Dictionary = {
		"roster": {},
		"team": [{"classe": classe, "equipment": {}}],
		"gold": 0,
		"inventory": [],
		"victories": 0,
	}
	ProgressionManager.ensure_roster(data)
	var ent: Dictionary = data["roster"][classe]
	ent["level"] = level
	ent["xp"] = ProgressionManager.xp_for_level(level)
	# Réapplique l'entrée talents avec les points rétrospectifs
	ent["talents"] = {"unlocked": {}, "points": TalentTree.power_for_level(level)}
	return data

func _test_talent_basics() -> void:
	print("TalentTree — bases (par personnage) :")
	var data: Dictionary = _make_save("Tank", 20)
	_check(TalentTree.points(data, "Tank") == 2, "niveau 20 → 2 points de pouvoir")
	_check(TalentTree.unlocked_count(data, "Tank") == 0, "aucun talent débloqué")
	_check(not TalentTree.is_unlocked(data, "Tank", "off_veteran"), "off_veteran verrouillé")
	# Dépense
	_check(TalentTree.spend_point(data, "Tank", "off_veteran"), "déblocage off_veteran réussi")
	_check(TalentTree.is_unlocked(data, "Tank", "off_veteran"), "off_veteran débloqué")
	_check(TalentTree.points(data, "Tank") == 1, "1 point restant")
	_check(not TalentTree.spend_point(data, "Tank", "off_fury"), "off_fury coûte 3, refusé avec 1 point")
	_check(not TalentTree.spend_point(data, "Tank", "off_veteran"), "re-déblocage refusé")
	_check(not TalentTree.spend_point(data, "Tank", "id_inexistant"), "talent inconnu refusé")
	_check(TalentTree.unlocked_count(data, "Tank") == 1, "1 talent débloqué au total")
	# Perso sans entrée roster
	var empty: Dictionary = {}
	_check(TalentTree.points(empty, "Mage") == 0, "pas de roster → 0 point")
	_check(not TalentTree.spend_point(empty, "Mage", "off_veteran"), "pas de roster → dépense refusée")

func _test_talent_paliers() -> void:
	print("TalentTree — paliers de niveau :")
	_check(TalentTree.power_for_level(1) == 0, "niveau 1 → 0 point")
	_check(TalentTree.power_for_level(14) == 0, "niveau 14 → 0 point (verrouillé)")
	_check(TalentTree.power_for_level(15) == 1, "niveau 15 → 1 point (débloqué)")
	_check(TalentTree.power_for_level(19) == 1, "niveau 19 → 1 point")
	_check(TalentTree.power_for_level(20) == 2, "niveau 20 → 2 points")
	_check(TalentTree.power_for_level(25) == 3, "niveau 25 → 3 points")
	_check(TalentTree.power_for_level(100) == 18, "niveau 100 → 18 points")
	# Gains entre niveaux
	_check(TalentTree.power_gained(14, 15) == 1, "14→15 : +1 point")
	_check(TalentTree.power_gained(14, 20) == 2, "14→20 : +2 points")
	_check(TalentTree.power_gained(15, 15) == 0, "15→15 : +0 point")
	_check(TalentTree.power_gained(20, 14) == 0, "20→14 (impossible) : +0 point")
	# apply_level_up sur une vraie sauvegarde
	var data: Dictionary = _make_save("Mage", 15)
	_check(TalentTree.points(data, "Mage") == 1, "Mage niveau 15 → 1 point (rétroactif)")
	var ent: Dictionary = data["roster"]["Mage"]
	ent["level"] = 20
	TalentTree.apply_level_up(data, "Mage", 15, 20)
	_check(TalentTree.points(data, "Mage") == 2, "15→20 via apply_level_up : +1 point (total 2)")

func _test_talent_bonus_aggregation() -> void:
	print("TalentTree — agrégation des bonus (par personnage) :")
	var data: Dictionary = _make_save("Assassin", 30)
	var ent: Dictionary = data["roster"]["Assassin"]
	ent["talents"]["points"] = 10
	TalentTree.spend_point(data, "Assassin", "off_veteran")    # +5% dmg
	TalentTree.spend_point(data, "Assassin", "off_critique")   # +5% crit
	TalentTree.spend_point(data, "Assassin", "def_vita")       # +5% PV
	TalentTree.spend_point(data, "Assassin", "util_soin")      # +10% soins
	var bonus: Dictionary = TalentTree.total_bonus(data, "Assassin")
	_check(int(bonus["dmg_pct"]) == 5, "dmg_pct = 5 (off_veteran)")
	_check(int(bonus["crit_pct"]) == 5, "crit_pct = 5 (off_critique)")
	_check(int(bonus["pv_pct"]) == 5, "pv_pct = 5 (def_vita)")
	_check(int(bonus["heal_pct"]) == 10, "heal_pct = 10 (util_soin)")
	# Cumul de deux talents dmg
	TalentTree.spend_point(data, "Assassin", "off_fury")       # +10% dmg → total 15%
	bonus = TalentTree.total_bonus(data, "Assassin")
	_check(int(bonus["dmg_pct"]) == 15, "dmg_pct = 15 après off_veteran + off_fury")
	# Un AUTRE héros n'a aucun bonus
	var other: Dictionary = TalentTree.total_bonus(data, "Tank")
	_check(int(other["dmg_pct"]) == 0, "Tank (sans talents) → dmg_pct = 0")
	_check(int(other["pv_pct"]) == 0, "Tank (sans talents) → pv_pct = 0")

func _test_member_stats_integration() -> void:
	print("ProgressionManager.member_stats — intégration talents par perso :")
	var data: Dictionary = _make_save("Tank", 30)
	var ent: Dictionary = data["roster"]["Tank"]
	ent["talents"]["points"] = 5
	TalentTree.spend_point(data, "Tank", "def_vita")     # +5% PV
	TalentTree.spend_point(data, "Tank", "def_armure")   # +5% défense
	TalentTree.spend_point(data, "Tank", "util_pa")      # +1 PA
	var member: Dictionary = {"classe": "Tank", "equipment": {}}
	var st: Dictionary = ProgressionManager.member_stats(data, member)
	_check(not st.is_empty(), "member_stats non vide")
	var st_clean: Dictionary = ProgressionManager.member_stats(_make_save("Tank", 30), member)
	_check(float(st["talent_dmg_pct"]) == 1.0, "talent_dmg_pct = 1.0 sans talent dmg")
	_check(float(st["talent_def_pct"]) == 1.05, "talent_def_pct = 1.05 (+5% def)")
	_check(int(st["pa"]) == int(st_clean["pa"]) + 1, "+1 PA grâce à util_pa")
	_check(int(st["max_pv"]) > int(st_clean["max_pv"]), "+5% PV max grâce à def_vita")
	# Le bonus ne touche pas un autre héros
	var st_mage: Dictionary = ProgressionManager.member_stats(data, {"classe": "Mage", "equipment": {}})
	_check(float(st_mage["talent_def_pct"]) == 1.0, "Mage (sans talents) → def_pct = 1.0")

func _test_synergy_trios() -> void:
	print("Synergies de trio (V42) :")
	# Test via ProgressionManager (nécessite le chargement des données)
	var trio: Array = ProgressionManager.active_synergy_trios(["Tank", "Mage", "Druide"])
	_check(trio.size() == 1, "Tank+Mage+Druide → 1 synergie de trio")
	_check(String(trio[0]["name"]) == "Égide arcanique", "nom = Égide arcanique")
	_check(String(trio[0]["status"]) == "def_up", "statut = def_up")
	_check(float(trio[0]["value"]) == 15.0, "valeur = 15%")
	# Sans le trio complet
	var duo: Array = ProgressionManager.active_synergy_trios(["Tank", "Mage"])
	_check(duo.is_empty(), "Tank+Mage seuls → pas de synergie de trio")
	# Trio différent
	var trio2: Array = ProgressionManager.active_synergy_trios(["Assassin", "Chasseur", "Sylvain"])
	_check(trio2.size() == 1, "Assassin+Chasseur+Sylvain → 1 synergie")
	_check(String(trio2[0]["name"]) == "Meute", "nom = Meute")
	# Les synergies de duo existantes sont préservées
	var synergies: Array = ProgressionManager.active_synergies(["Tank", "Heal"])
	_check(synergies.size() == 1, "Tank+Heal → synergie de duo préservée")
	_check(String(synergies[0]["name"]) == "Rempart béni", "nom du duo = Rempart béni")

func _test_speedrun_settings() -> void:
	print("GameSettings — contre-la-montre (V42) :")
	var gs: Node = root.get_node_or_null("GameSettings")
	if gs == null:
		print("  ??  GameSettings non disponible en headless (autoload)")
		return
	_check(int(gs.speedrun_turn_limit()) == 0, "limite par défaut = 0 (désactivé)")
	gs.set_speedrun_mode(2)
	_check(int(gs.speedrun_turn_limit()) == 6, "mode 2 → limite 6 tours")
	_check(gs.speedrun_xp_bonus() == 0.30, "mode 2 → +30% XP")
	_check(gs.speedrun_gold_bonus() == 0.25, "mode 2 → +25% or")
	gs.set_speedrun_mode(3)
	_check(int(gs.speedrun_turn_limit()) == 3, "mode 3 → limite 3 tours")
	_check(gs.speedrun_xp_bonus() == 0.50, "mode 3 → +50% XP")
	gs.set_speedrun_mode(0)
	_check(int(gs.speedrun_turn_limit()) == 0, "retour mode 0 → désactivé")
