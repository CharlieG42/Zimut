extends SceneTree
## test_talents.gd — Tests headless de l'arbre de talents (V42).
## Lancement : godot --headless -s tests/test_talents.gd --path .

var failures: int = 0

func _init() -> void:
	_test_talent_basics()
	_test_talent_bonus_aggregation()
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

func _test_talent_basics() -> void:
	print("TalentTree — bases :")
	# Reset pour partir d'un état connu
	TalentTree.reset_all()
	_check(TalentTree.points() == 0, "0 point au départ")
	_check(TalentTree.unlocked_count() == 0, "aucun talent débloqué")
	_check(not TalentTree.is_unlocked("off_veteran"), "off_veteran verrouillé")
	# Ajout de points et déblocage
	TalentTree.add_points(3)
	_check(TalentTree.points() == 3, "3 points après ajout")
	_check(TalentTree.spend_point("off_veteran"), "déblocage off_veteran réussi")
	_check(TalentTree.is_unlocked("off_veteran"), "off_veteran débloqué")
	_check(TalentTree.points() == 2, "2 points restants")
	_check(not TalentTree.spend_point("off_fury"), "off_fury coûte 3, refusé avec 2 points")
	_check(TalentTree.spend_point("off_veteran") == false, "re-déblocage refusé")
	# Reset
	TalentTree.reset_all()
	_check(TalentTree.points() == 0, "reset remet à 0 point")
	_check(TalentTree.unlocked_count() == 0, "reset vide les talents")

func _test_talent_bonus_aggregation() -> void:
	print("TalentTree — agrégation des bonus :")
	TalentTree.reset_all()
	TalentTree.add_points(10)
	TalentTree.spend_point("off_veteran")    # +5% dmg
	TalentTree.spend_point("off_critique")   # +5% crit
	TalentTree.spend_point("def_vita")       # +5% PV
	TalentTree.spend_point("eco_xp")         # +10% XP
	var bonus: Dictionary = TalentTree.total_bonus()
	_check(int(bonus["dmg_pct"]) == 5, "dmg_pct = 5 (off_veteran)")
	_check(int(bonus["crit_pct"]) == 5, "crit_pct = 5 (off_critique)")
	_check(int(bonus["pv_pct"]) == 5, "pv_pct = 5 (def_vita)")
	_check(int(bonus["xp_pct"]) == 10, "xp_pct = 10 (eco_xp)")
	# Cumul de deux talents dmg
	TalentTree.spend_point("off_fury")       # +10% dmg → total 15%
	bonus = TalentTree.total_bonus()
	_check(int(bonus["dmg_pct"]) == 15, "dmg_pct = 15 après off_veteran + off_fury")
	TalentTree.reset_all()

func _test_synergy_trios() -> void:
	print("Synergies de trio (V42) :")
	# Test via ProgressionManager (nécessite le chargement des données)
	var trio: Array = ProgressionManager.active_synergy_trios(["Tank", "Mage", "Druide"])
	_check(trio.size() == 1, "Tank+Mage+Druide → 1 synergie de trio")
	_check(String(trio[0]["name"]) == "Égide arcanique", "nom = Égende arcanique")
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
