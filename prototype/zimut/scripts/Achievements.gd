class_name Achievements
## Achievements.gd — Succès et bestiaire (V18), stockés dans la sauvegarde :
##   data["stats"]        compteurs (victoires, boss, fabrications, fusions…)
##   data["achievements"] { id: date } des succès débloqués
##   data["bestiary"]     { nom: {sprite, type, nation, level, pv, atk, spells, seen, killed} }
## Chaque succès rapporte de l'or ou des ressources de rang supérieur (pour la Forge).

## id, nom, description, statistique suivie, seuil, récompense {or | "Fer@2": n}
const LIST: Array = [
	["premier_sang", "Premier sang", "Gagner un combat", "wins", 1, {"gold": 80}],
	["veteran", "Vétéran", "Gagner 10 combats", "wins", 10, {"Fer@2": 2, "Cuir@2": 2}],
	["legende", "Légende", "Gagner 50 combats", "wins", 50, {"Magie@3": 2, "Fer@3": 2}],
	["sans_perte", "Sans une égratignure", "Gagner un combat sans aucun héros K.O.", "flawless", 1, {"Cuir@2": 2}],
	["intouchables", "Intouchables", "Gagner 10 combats sans aucun héros K.O.", "flawless", 10, {"Cuir@3": 2}],
	["eclair", "Éclair", "Gagner un combat en 3 tours ou moins", "fast", 1, {"Bois@2": 2}],
	["tueur_de_boss", "Tueur de boss", "Vaincre un boss", "bosses", 1, {"Magie@2": 3}],
	["chasseur_de_boss", "Chasseur de boss", "Vaincre 5 boss", "bosses", 5, {"Fer@3": 2, "Magie@3": 1}],
	["forgeron", "Apprenti forgeron", "Fabriquer un objet à la Forge", "crafted", 1, {"gold": 120}],
	["maitre_forgeron", "Maître forgeron", "Posséder un objet de rang 5", "max_rank", 5, {"Fer@4": 1, "Magie@4": 1}],
	["alchimiste", "Alchimiste", "Réaliser 20 fusions de ressources", "fusions", 20, {"Venin@3": 2}],
	["collectionneur", "Collectionneur", "Récupérer 30 objets en combat", "loots", 30, {"Bois@3": 2}],
	["stratege", "Stratège", "Réussir 5 objectifs de combat", "objectives", 5, {"Fer@3": 1, "Cuir@3": 1}],
	["conquerant", "Conquérant", "Contrôler 5 villes", "cities", 5, {"gold": 300}],
	["empereur", "Empereur", "Contrôler 15 villes", "cities", 15, {"Magie@4": 2}],
	["aguerri", "Aguerri", "Monter un héros au niveau 25", "max_level", 25, {"Cuir@3": 2}],
	["heros_legendaire", "Héros légendaire", "Monter un héros au niveau 50", "max_level", 50, {"Magie@4": 1, "Fer@4": 1}],
	["premiere_pierre", "Éveil", "Retrouver une Pierre Élémentaire", "stones", 1, {"gold": 200}],
	["gardien_pierres", "Gardien des Pierres", "Retrouver 5 Pierres Élémentaires", "stones", 5, {"Magie@3": 3}],
	["equilibre", "L'Équilibre retrouvé", "Retrouver toutes les Pierres Élémentaires", "stones", 10, {"Magie@4": 3, "Fer@4": 3}],
	["naturaliste", "Naturaliste", "Rencontrer 20 ennemis différents", "bestiary", 20, {"Venin@2": 3}],
]


static func _pm() -> Node:
	return (Engine.get_main_loop() as SceneTree).root.get_node("ProgressionManager")


static func stat(data: Dictionary, key: String) -> int:
	match key:
		"cities":
			return (data.get("conquest", {}).get("owned", []) as Array).size()
		"max_level":
			var best: int = 0
			for e in data.get("roster", {}).values():
				best = maxi(best, int(e.get("level", 1)))
			return best
		"bestiary":
			return (data.get("bestiary", {}) as Dictionary).size()
		"stones":
			return (data.get("stones", {}) as Dictionary).size()
		"max_rank":
			var r: int = int(data.get("stats", {}).get("max_rank", 1))
			for it in data.get("inventory", []):
				r = maxi(r, int(it.get("rank", 1)))
			for m in data.get("team", []):
				for it2 in m.get("equipment", {}).values():
					if it2 is Dictionary:
						r = maxi(r, int(it2.get("rank", 1)))
			for e2 in data.get("roster", {}).values():
				for it3 in e2.get("equipment", {}).values():
					if it3 is Dictionary:
						r = maxi(r, int(it3.get("rank", 1)))
			return r
	return int(data.get("stats", {}).get(key, 0))


static func bump(data: Dictionary, key: String, n: int = 1) -> void:
	var st: Dictionary = data.get("stats", {})
	st[key] = int(st.get(key, 0)) + n
	data["stats"] = st


static func set_max(data: Dictionary, key: String, v: int) -> void:
	var st: Dictionary = data.get("stats", {})
	st[key] = maxi(int(st.get(key, 0)), v)
	data["stats"] = st


static func is_unlocked(data: Dictionary, id: String) -> bool:
	return (data.get("achievements", {}) as Dictionary).has(id)


static func reward_text(rw: Dictionary) -> String:
	var parts: PackedStringArray = []
	for k: String in rw.keys():
		if k == "gold":
			parts.append("+%d or" % int(rw[k]))
		else:
			var p: PackedStringArray = k.split("@")
			parts.append("+%d %s R%s" % [int(rw[k]), p[0], p[1]] if p.size() > 1 else "+%d %s" % [int(rw[k]), k])
	return " · ".join(parts)


## Débloque les succès atteints, verse leurs récompenses et les ajoute à
## data["last_achievements"] (affichés en fin de combat / dans la Forge).
static func check(data: Dictionary) -> Array:
	var got: Dictionary = data.get("achievements", {})
	var news: Array = []
	for a: Array in LIST:
		var id: String = String(a[0])
		if got.has(id) or stat(data, String(a[3])) < int(a[4]):
			continue
		got[id] = Time.get_date_string_from_system()
		var rw: Dictionary = a[5]
		var res: Dictionary = {}
		for k: String in rw.keys():
			if k == "gold":
				data["gold"] = int(data.get("gold", 0)) + int(rw[k])
			else:
				res[k] = int(rw[k])
		if not res.is_empty():
			_pm().add_resources(data, res)
		news.append({"id": id, "name": String(a[1]), "reward_text": reward_text(rw)})
		# Chaque succès débloqué rapporte 1 point de gloire (arbre de talents account-wide)
		TalentTree.add_points(1)
	data["achievements"] = got
	if not news.is_empty():
		var last: Array = data.get("last_achievements", [])
		last.append_array(news)
		data["last_achievements"] = last
	return news


# ── Bestiaire ────────────────────────────────────────────────────────────────

static func _base_name(e: Dictionary) -> String:
	var n: String = String(e.get("name", e.get("classe", "?")))
	var i: int = n.find(" Lv")
	return n.substr(0, i) if i > 0 else n


## Un ennemi apparaît en combat : on l'inscrit (ou on met à jour sa fiche).
static func bestiary_seen(data: Dictionary, e: Dictionary, biome: String) -> void:
	if data.is_empty() or String(e.get("team", "")) != "enemy":
		return
	var b: Dictionary = data.get("bestiary", {})
	var key: String = _base_name(e)
	var f: Dictionary = b.get(key, {"seen": 0, "killed": 0, "level": 0})
	f["seen"] = int(f["seen"]) + 1
	if int(e.get("level", 0)) >= int(f.get("level", 0)):
		f["level"] = int(e.get("level", 0))
		f["pv"] = int(e.get("max_pv", 0))
		f["atk"] = int(e.get("force", e.get("attack", 0)))
		f["defense"] = int(e.get("defense", 0))
		f["pm"] = int(e.get("max_pm", 0))
	f["type"] = String(e.get("classe", ""))
	f["boss"] = bool(e.get("boss", false))
	f["nation"] = biome
	var names: PackedStringArray = []
	for sp in e.get("spells", []):
		names.append(String(sp.get("name", "")))
	f["spells"] = ", ".join(names)
	if not f.has("sprite") or String(f["sprite"]) == "":
		var tex: Texture2D = Nations.enemy_texture(e, biome)
		f["sprite"] = tex.resource_path if tex != null else "res://assets/sprites/enemies/%s.png" % EntityView.sprite_key(String(e.get("classe", "")))
	b[key] = f
	data["bestiary"] = b


static func bestiary_kill(data: Dictionary, e: Dictionary) -> void:
	if data.is_empty() or String(e.get("team", "")) != "enemy":
		return
	var b: Dictionary = data.get("bestiary", {})
	var key: String = _base_name(e)
	if b.has(key):
		b[key]["killed"] = int(b[key].get("killed", 0)) + 1
