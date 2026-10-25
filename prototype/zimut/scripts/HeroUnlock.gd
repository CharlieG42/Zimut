class_name HeroUnlock
extends RefCounted
## HeroUnlock.gd — Niveau du joueur et déblocage des héros (V47).
##
## · Le joueur a son propre niveau (data["player"] = {level, xp}). Il gagne l'XP de chaque
##   combat à 100 % (sans multiplicateur de classe) : son niveau suit donc de près celui
##   d'un héros que l'on emmène en permanence, sans forcément égaler le plus haut.
## · Aucun héros ne dépasse le niveau du joueur (plafond appliqué dans award_xp) ; l'XP
##   en trop est conservée et se transforme en niveau dès que le joueur monte.
## · En fin de tutoriel, le joueur choisit START_PICKS héros. Ensuite, un nouveau héros
##   se débloque (au choix) au niveau FIRST_UNLOCK_LEVEL puis tous les UNLOCK_EVERY niveaux.
##   Avec 10 héros : les 7 restants sont tous disponibles au niveau 22 du joueur.
## · Les anciennes sauvegardes gardent tous leurs héros (migration : tout est débloqué,
##   niveau joueur = niveau du meilleur héros).
##
## Sauvegarde : data["heroes_unlocked"] = [classes], data["player"] = {"level", "xp"}.

const START_PICKS := 3
const FIRST_UNLOCK_LEVEL := 4
const UNLOCK_EVERY := 3


static func _all_classes() -> Array[String]:
	var out: Array[String] = []
	for c in ClassRules.CLASSES.keys():
		out.append(String(c))
	return out


## À appeler depuis ProgressionManager.ensure_roster (après construction du roster).
static func ensure(data: Dictionary, xp_for_level: Callable) -> void:
	if data.is_empty():
		return
	if not data.has("heroes_unlocked"):
		# Ancienne sauvegarde : tout est débloqué, le joueur rattrape son meilleur héros.
		data["heroes_unlocked"] = _all_classes()
		var best: int = 1
		for c in (data.get("roster", {}) as Dictionary).keys():
			best = maxi(best, int(data["roster"][c].get("level", 1)))
		data["player"] = {"level": best, "xp": int(xp_for_level.call(best))}
	var p: Dictionary = data.get("player", {})
	p["level"] = clampi(int(p.get("level", 1)), 1, ClassRules.MAX_LEVEL)
	p["xp"] = int(p.get("xp", 0))
	data["player"] = p
	var clean: Array = []
	for c in data["heroes_unlocked"]:
		if ClassRules.CLASSES.has(String(c)) and not clean.has(String(c)):
			clean.append(String(c))
	data["heroes_unlocked"] = clean


static func player_level(data: Dictionary) -> int:
	return int((data.get("player", {}) as Dictionary).get("level", 1))


static func player_xp(data: Dictionary) -> int:
	return int((data.get("player", {}) as Dictionary).get("xp", 0))


static func unlocked(data: Dictionary) -> Array[String]:
	var out: Array[String] = []
	for c in data.get("heroes_unlocked", []):
		out.append(String(c))
	return out


static func is_unlocked(data: Dictionary, classe: String) -> bool:
	if data.is_empty() or not data.has("heroes_unlocked"):
		return true   # pas de partie : tout est visible (tests, menus)
	return (data["heroes_unlocked"] as Array).has(classe)


static func locked(data: Dictionary) -> Array[String]:
	var out: Array[String] = []
	for c: String in _all_classes():
		if not is_unlocked(data, c):
			out.append(c)
	return out


## Faut-il encore choisir les héros de départ ?
static func needs_initial_picks(data: Dictionary) -> bool:
	return not data.is_empty() and (data.get("heroes_unlocked", []) as Array).size() < START_PICKS \
		and not locked(data).is_empty()


## Niveau du joueur auquel se débloque le n-ième héros bonus (n = 1, 2, …).
static func level_for_unlock(n: int) -> int:
	return FIRST_UNLOCK_LEVEL + (n - 1) * UNLOCK_EVERY


## Nombre de héros bonus gagnés au niveau `level`.
static func earned_unlocks(level: int) -> int:
	if level < FIRST_UNLOCK_LEVEL:
		return 0
	return 1 + (level - FIRST_UNLOCK_LEVEL) / UNLOCK_EVERY


## Héros bonus déjà débloqués (au-delà des héros de départ).
static func bonus_unlocked(data: Dictionary) -> int:
	return maxi(0, (data.get("heroes_unlocked", []) as Array).size() - START_PICKS)


## Déblocages gagnés mais pas encore dépensés.
static func pending_unlocks(data: Dictionary) -> int:
	if data.is_empty() or needs_initial_picks(data):
		return 0
	var n: int = earned_unlocks(player_level(data)) - bonus_unlocked(data)
	return clampi(n, 0, locked(data).size())


## Niveau du joueur requis pour le prochain déblocage (-1 s'il n'en reste plus).
static func next_unlock_level(data: Dictionary) -> int:
	if locked(data).is_empty():
		return -1
	return level_for_unlock(bonus_unlocked(data) + 1)


static func pick_initial(data: Dictionary, classes: Array) -> bool:
	var seen: Array[String] = []
	for c in classes:
		if ClassRules.CLASSES.has(String(c)) and not seen.has(String(c)):
			seen.append(String(c))
	if seen.size() != START_PICKS or not needs_initial_picks(data):
		return false
	data["heroes_unlocked"] = seen
	return true


static func unlock(data: Dictionary, classe: String) -> bool:
	if pending_unlocks(data) <= 0 or is_unlocked(data, classe) or not ClassRules.CLASSES.has(classe):
		return false
	(data["heroes_unlocked"] as Array).append(classe)
	return true


## Ajoute de l'XP au joueur. Retourne { from, to, gain, xp, xp_cur, xp_next, new_unlocks }.
static func add_xp(data: Dictionary, gain: int, xp_for_level: Callable, level_for_xp: Callable) -> Dictionary:
	var p: Dictionary = data.get("player", {"level": 1, "xp": 0})
	var from_lvl: int = int(p.get("level", 1))
	p["xp"] = int(p.get("xp", 0)) + maxi(0, gain)
	var to_lvl: int = mini(ClassRules.MAX_LEVEL, int(level_for_xp.call(int(p["xp"]))))
	p["level"] = maxi(from_lvl, to_lvl)
	data["player"] = p
	var new_unlocks: int = maxi(0, earned_unlocks(int(p["level"])) - earned_unlocks(from_lvl))
	var lvl: int = int(p["level"])
	return {"from": from_lvl, "to": lvl, "gain": gain, "xp": int(p["xp"]),
		"xp_cur": int(xp_for_level.call(lvl)),
		"xp_next": int(xp_for_level.call(mini(ClassRules.MAX_LEVEL, lvl + 1))),
		"new_unlocks": new_unlocks if not locked(data).is_empty() else 0}
