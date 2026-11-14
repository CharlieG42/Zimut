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
	check(boss >= hero * 1.8, "boss au moins 1,8 fois un héros (%.0f / %.0f)" % [boss, hero])
	check(boss > troll and boss > enemy and boss > summon, "boss plus grand que troll, ennemi et invocation")
	check(boss >= EntityView.BOSS_HEIGHT_BASE * 1.25, "boss agrandi d'au moins 25 % par rapport à l'ancienne taille")
	check(is_equal_approx(hero, 104.0) and is_equal_approx(enemy, 92.0) and is_equal_approx(summon, 76.0) and is_equal_approx(troll, 118.0),
		"hauteurs des héros, ennemis, invocations et trolls inchangées")
	print("FIN : ", fails, " échec(s)")
	quit(1 if fails > 0 else 0)
