extends SceneTree
## Mode Cartes : verrouillé tant que tous les héros ne sont pas débloqués (niveau joueur 22 avec 10 classes).
var fails: int = 0
func check(ok: bool, label: String) -> void:
	if ok:
		print("  ok  ", label)
	else:
		fails += 1
		print("  ÉCHEC  ", label)

func _initialize() -> void:
	var n: int = ClassRules.CLASSES.size()
	check(n == 10, "10 classes (%d)" % n)
	check(HeroUnlock.all_unlocked_level() == 22, "dernier héros au niveau 22 (%d)" % HeroUnlock.all_unlocked_level())
	# Partie neuve : 3 héros de départ → verrouillé
	var keys: Array = ClassRules.CLASSES.keys()
	var d: Dictionary = {"heroes_unlocked": [keys[0], keys[1], keys[2]]}
	check(not HeroUnlock.all_unlocked(d), "3 héros : Cartes verrouillé")
	# Un héros manquant → toujours verrouillé
	var nine: Array = keys.slice(0, n - 1)
	check(not HeroUnlock.all_unlocked({"heroes_unlocked": nine}), "9 héros : verrouillé")
	# Tous débloqués → ouvert
	check(HeroUnlock.all_unlocked({"heroes_unlocked": keys.duplicate()}), "10 héros : ouvert")
	# Ancienne sauvegarde sans champ (migration = tout débloqué)
	check(HeroUnlock.all_unlocked({}), "sans partie : ouvert (tests/menus)")
	print("DEBLOCAGE fails=", fails)
	quit(1 if fails > 0 else 0)
