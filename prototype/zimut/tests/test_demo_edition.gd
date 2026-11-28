extends SceneTree
## V460 : édition démo — plafond de niveau 16 pour le joueur et les héros, édition complète inchangée.
var fails: int = 0
func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var pm: Node = root.get_node("ProgressionManager")
	root.get_node("GameSettings").tutorial_done = true
	# ── Étiquettes d'export
	check(not Edition.is_demo() and not Edition.is_store_build(), "éditeur / PC : édition complète, pas de build Play Store")
	check(Edition.max_level() == ClassRules.MAX_LEVEL, "édition complète : niveau max = %d" % ClassRules.MAX_LEVEL)
	check(Edition.DEMO_MAX_LEVEL == 16, "plafond de la démo = 16")
	check(Edition.store_url() == "market://details?id=com.zimut.iso", "lien Play Store de la version complète")
	# ── Édition complète : le joueur dépasse 16
	var full: Dictionary = pm.new_game(4, "Complet")
	HeroUnlock.pick_initial(full, ["Tank", "Heal", "Mage"])
	pm.rebuild_team(full, ["Tank", "Heal", "Mage"])
	for i in range(80):
		pm.award_xp(full, 3000, 1.0, 40)
	check(HeroUnlock.player_level(full) > 16, "complet : le joueur dépasse 16 (%d)" % HeroUnlock.player_level(full))
	# ── Démo
	Edition.force_demo(true)
	check(Edition.is_demo() and Edition.is_store_build() and Edition.max_level() == 16, "démo : édition, build store, niveau max 16")
	var d: Dictionary = pm.new_game(4, "Demo")
	HeroUnlock.pick_initial(d, ["Tank", "Heal", "Mage"])
	pm.rebuild_team(d, ["Tank", "Heal", "Mage"])
	var capped_seen: bool = false
	for i in range(120):
		pm.award_xp(d, 3000, 1.0, 40)
		if bool((d["last_player"] as Dictionary).get("demo_capped", false)):
			capped_seen = true
	check(HeroUnlock.player_level(d) == 16, "démo : le joueur s'arrête au niveau 16 (%d)" % HeroUnlock.player_level(d))
	check(capped_seen, "démo : le rapport signale le plafond (demo_capped)")
	var top: int = 0
	for c in d["roster"].keys():
		top = maxi(top, int(d["roster"][c]["level"]))
	check(top == 16, "démo : aucun héros au-dessus de 16 (max %d)" % top)
	check(int(d["roster"]["Tank"]["level"]) == 16, "démo : un héros d'équipe atteint bien 16")
	check(HeroUnlock.player_xp(d) <= pm.xp_for_level(16), "démo : l'XP excédentaire n'est pas conservée")
	var xp_before: int = HeroUnlock.player_xp(d)
	pm.award_xp(d, 5000, 1.0, 40)
	check(HeroUnlock.player_level(d) == 16 and HeroUnlock.player_xp(d) == xp_before, "démo : au plafond, plus rien ne bouge")
	check(int(d["last_player"]["xp_next"]) == pm.xp_for_level(16), "démo : la barre d'XP n'annonce pas de niveau 17")
	# Déblocages de héros : 16 → 5 héros bonus (8 sur 10)
	check(HeroUnlock.earned_unlocks(16) == 5, "démo : 5 héros bonus au niveau 16")
	# Sauvegarde d'une édition complète (niveau 40) ouverte en démo : rien n'est supprimé
	var big: Dictionary = pm.new_game(4, "Grand")
	big["player"]["level"] = 40
	pm.ensure_roster(big)
	check(HeroUnlock.player_level(big) == 40, "démo : une sauvegarde de niveau 40 n'est pas rabotée")
	Edition.clear_force()
	check(not Edition.is_demo(), "forçage retiré : édition complète")
	print("ÉCHECS : %d" % fails if fails > 0 else "OK")
	quit(1 if fails > 0 else 0)
