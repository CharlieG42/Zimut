class_name Bounties
extends RefCounted
## Bounties.gd — Tableau des primes (V28) : 3 défis renouvelés chaque jour, valables dans tous
## les modes (Tactique, Aventure, Conquête). Chaque prime terminée est créditée tout de suite ;
## les 3 primes du jour terminées donnent un coffre bonus.
##
## Sauvegarde : save["bounties"] = { "day": "AAAA-MM-JJ", "list": [prime...], "bonus": bool, "streak": int, "last_full": "AAAA-MM-JJ" }
##   prime = { id, kind, title, target, param, progress, done, reward: {gold, res: {clé: n}} }

const PER_DAY := 3
const KINDS: Array[String] = ["kill_type", "win_biome", "win_mode", "flawless", "fast", "boss", "wins"]
const ENEMY_TYPES: Array[String] = ["Gobelin", "Loup", "Squelette", "Troll", "Dragonnet"]
const ENEMY_PLURAL := {"Gobelin": "gobelins", "Loup": "loups", "Squelette": "squelettes", "Troll": "trolls", "Dragonnet": "dragonnets"}
const MODE_LABEL := {"": "Tactique", "adventure": "Aventure", "conquest": "Conquête"}


static func today() -> String:
	return Time.get_date_string_from_system()


static func _max_level(data: Dictionary) -> int:
	var best: int = 1
	for e in data.get("roster", {}).values():
		best = maxi(best, int(e.get("level", 1)))
	return best


## Biomes où le joueur peut combattre aujourd'hui (cycle Tactique + cartes d'Aventure ouvertes).
static func _known_biomes(data: Dictionary) -> Array[String]:
	var out: Array[String] = ["Forêt", "Montagne", "Désert"]
	var tree: SceneTree = Engine.get_main_loop() as SceneTree
	var pm: Node = tree.root.get_node_or_null("ProgressionManager") if tree != null else null
	if pm != null:
		for z in data.get("adventure", {}).get("zones_unlocked", []):
			var b: String = String(pm.ADVENTURE_ZONES.get(String(z), {}).get("biome", ""))
			if b != "" and b != "Donjon" and not out.has(b):
				out.append(b)
	return out


## Primes du jour (régénérées si la date a changé). Retourne la liste.
static func ensure(data: Dictionary) -> Array:
	var bd: Dictionary = data.get("bounties", {})
	var day: String = today()
	if String(bd.get("day", "")) == day and not (bd.get("list", []) as Array).is_empty():
		return bd["list"]
	var rng := RandomNumberGenerator.new()
	rng.seed = absi(("%s|%s" % [day, String(data.get("name", ""))]).hash())
	var lvl: int = _max_level(data)
	var biomes: Array[String] = _known_biomes(data)
	var kinds: Array[String] = KINDS.duplicate()
	var list: Array = []
	for i: int in range(PER_DAY):
		var kind: String = kinds[rng.randi_range(0, kinds.size() - 1)]
		kinds.erase(kind)
		var b: Dictionary = {"id": i, "kind": kind, "progress": 0, "done": false, "param": "", "target": 1}
		var biome: String = biomes[rng.randi_range(0, biomes.size() - 1)]
		match kind:
			"kill_type":
				var t: String = ENEMY_TYPES[rng.randi_range(0, 2)]
				b["param"] = t
				b["target"] = rng.randi_range(6, 12)
				b["title"] = "Vaincre %d %s" % [int(b["target"]), String(ENEMY_PLURAL[t])]
			"win_biome":
				b["param"] = biome
				b["target"] = 2
				b["title"] = "Gagner 2 combats en terre %s" % Nations.nation_name(biome)
			"win_mode":
				var modes: Array[String] = [""]
				if lvl >= 3:
					modes.append("adventure")
				if lvl >= 5:
					modes.append("conquest")
				var m: String = modes[rng.randi_range(0, modes.size() - 1)]
				b["param"] = m
				b["target"] = 2
				b["title"] = "Gagner 2 combats en mode %s" % String(MODE_LABEL[m])
			"flawless":
				b["target"] = 2
				b["title"] = "Gagner 2 combats sans aucun héros K.O."
			"fast":
				b["target"] = 1
				b["title"] = "Gagner un combat en 4 tours ou moins"
			"boss":
				b["target"] = 1
				b["title"] = "Vaincre un boss"
			"wins":
				b["target"] = 4
				b["title"] = "Gagner 4 combats"
		var tier: int = 1 if lvl < 40 else (2 if lvl < 75 else 3)
		var res_name: String = Nations.resource_of(biome)
		var res_key: String = res_name if tier <= 1 else "%s@%d" % [res_name, tier]
		b["reward"] = {"gold": 60 + 8 * lvl, "res": {res_key: rng.randi_range(4, 8)}}
		list.append(b)
	bd["day"] = day
	bd["list"] = list
	bd["bonus"] = false
	data["bounties"] = bd
	return list


## Coffre bonus quand les 3 primes du jour sont faites.
static func bonus_reward(data: Dictionary) -> Dictionary:
	var lvl: int = _max_level(data)
	var tier: int = 2 if lvl < 60 else 3
	return {"gold": 150 + 15 * lvl, "res": {"Magie@%d" % tier: 2, "Fer@%d" % tier: 2}}


static func _credit(data: Dictionary, reward: Dictionary) -> void:
	data["gold"] = int(data.get("gold", 0)) + int(reward.get("gold", 0))
	var res: Dictionary = data.get("resources", {})
	for k: String in (reward.get("res", {}) as Dictionary).keys():
		res[k] = int(res.get(k, 0)) + int(reward["res"][k])
	data["resources"] = res


## Après une victoire : avance les primes. Retourne les titres des primes terminées par ce combat
## (+ « Coffre des primes » si les 3 sont faites).
## info : { enemies: [{type}], turns, deaths, boss, biome } ; le mode vient de save.campaign_mode.
static func on_victory(data: Dictionary, info: Dictionary) -> Array[String]:
	var finished: Array[String] = []
	var list: Array = ensure(data)
	var mode: String = String(data.get("campaign_mode", ""))
	var biome: String = String(info.get("biome", ""))
	var deaths: int = int(info.get("deaths", 1))
	var turns: int = int(info.get("turns", 99))
	var boss: bool = bool(info.get("boss", false))
	for b: Dictionary in list:
		if bool(b["done"]):
			continue
		var add: int = 0
		match String(b["kind"]):
			"kill_type":
				for e in info.get("enemies", []):
					if String(e.get("type", "")) == String(b["param"]):
						add += 1
			"win_biome":
				add = 1 if biome == String(b["param"]) else 0
			"win_mode":
				add = 1 if mode == String(b["param"]) else 0
			"flawless":
				add = 1 if info.has("deaths") and deaths == 0 else 0
			"fast":
				add = 1 if info.has("turns") and turns <= 4 else 0
			"boss":
				add = 1 if boss else 0
			"wins":
				add = 1
		if add <= 0:
			continue
		b["progress"] = mini(int(b["target"]), int(b["progress"]) + add)
		if int(b["progress"]) >= int(b["target"]):
			b["done"] = true
			_credit(data, b["reward"])
			finished.append(String(b["title"]))
	var bd: Dictionary = data["bounties"]
	if not bool(bd.get("bonus", false)) and done_count(data) >= PER_DAY:
		bd["bonus"] = true
		_credit(data, bonus_reward(data))
		# série de jours complets d'affilée
		var yesterday: String = Time.get_date_string_from_unix_time(int(Time.get_unix_time_from_system()) - 86400)
		bd["streak"] = (int(bd.get("streak", 0)) + 1) if String(bd.get("last_full", "")) == yesterday else 1
		bd["last_full"] = today()
		finished.append("Coffre des primes (série : %d jour%s)" % [int(bd["streak"]), "s" if int(bd["streak"]) > 1 else ""])
	return finished


static func done_count(data: Dictionary) -> int:
	var n: int = 0
	for b in data.get("bounties", {}).get("list", []):
		if bool(b.get("done", false)):
			n += 1
	return n


## Ligne de récompense lisible.
static func reward_text(reward: Dictionary) -> String:
	var parts: Array[String] = ["%d or" % int(reward.get("gold", 0))]
	for k: String in (reward.get("res", {}) as Dictionary).keys():
		var nm: String = k
		if k.contains("@"):
			nm = "%s rang %s" % [k.split("@")[0], k.split("@")[1]]
		parts.append("%d %s" % [int(reward["res"][k]), nm])
	return " + ".join(parts)
