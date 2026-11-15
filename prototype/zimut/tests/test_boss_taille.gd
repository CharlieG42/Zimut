extends SceneTree
## Les boss sont plus volumineux que les autres unités (V359).
var fails: int = 0
func check(c: bool, m: String) -> void:
	if not c:
		print("  ÉCHEC  " + m)
		fails += 1
	else:
		print("  ok  " + m)
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var boss: float = EntityView.height_for({"boss": true, "entity_type": "Enemy", "classe": "Tharok le Végétal"})
	var hero: float = EntityView.height_for({"entity_type": "Player", "classe": "Tank"})
	var enemy: float = EntityView.height_for({"entity_type": "Enemy", "classe": "Loup"})
	var troll: float = EntityView.height_for({"entity_type": "Enemy", "classe": "Troll"})
	var summon: float = EntityView.height_for({"entity_type": "Summon", "classe": "Golem"})
	check(is_equal_approx(boss, EntityView.BOSS_HEIGHT), "boss : hauteur BOSS_HEIGHT (%.0f)" % boss)
	check(boss >= hero * 1.6, "boss au moins 1,6 fois un héros (%.0f / %.0f)" % [boss, hero])
	check(boss > troll and boss > enemy and boss > summon, "boss plus grand que troll, ennemi et invocation")
	check(boss >= EntityView.BOSS_HEIGHT_BASE * 1.25, "boss agrandi d'au moins 25 % par rapport à l'ancienne taille")
	var k: float = EntityView.UNIT_SCALE
	check(is_equal_approx(hero, 104.0 * k) and is_equal_approx(enemy, 92.0 * k) and is_equal_approx(summon, 76.0 * k) and is_equal_approx(troll, 118.0 * k),
		"V361 : héros, ennemis, invocations et trolls agrandis de %d %% (héros %.0f px)" % [roundi((k - 1.0) * 100.0), hero])
	check(is_equal_approx(k, 1.10), "agrandissement des unités : +10 %")
	var oc_p: Color = EntityView.outline_color({"team": "player"})
	var oc_e: Color = EntityView.outline_color({"team": "enemy"})
	check(oc_p.b > oc_p.r and oc_e.r > oc_e.b and oc_p.get_luminance() < 0.2 and oc_e.get_luminance() < 0.2, "contour sombre : bleu pour les alliés, rouge pour les ennemis")
	check(EntityView.OUTLINE_PX_ACTIVE > EntityView.OUTLINE_PX and EntityView.OUTLINE_DIRS.size() == 4, "contour par 4 copies, plus épais pour l'unité active")
	print("FIN : ", fails, " échec(s)")
	quit(1 if fails > 0 else 0)
