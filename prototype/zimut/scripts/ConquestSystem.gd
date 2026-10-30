class_name ConquestSystem
extends RefCounted
## Cœur de la campagne Conquête, V14 : villes évolutives, garnisons, héros
## gouverneurs, offensives annoncées et événements entre les batailles.
##
## Tout est stocké dans data["conquest"] (rétro-compatible : chaque clé a une
## valeur par défaut), et toutes les fonctions sont statiques pour être testées
## sans interface. ProgressionManager garde les points d'entrée publics
## (conquest_*) et passe ici le catalogue de routes (pas d'autoload en static).
##
## Clés de data["conquest"] ajoutées :
##   city_levels {id:int}        niveau 1..3 (Hameau / Bourg / Cité)
##   garrisons   {id:{troops,hero}}
##   threat      {city,power,eta}   offensive annoncée (compte à rebours en batailles)
##   event_pending {…}           événement à trancher par le joueur
##   news        [String]        nouvelles de la dernière bataille (affichées puis vidées)
##   truce int                   batailles restantes sans raid ni offensive
##   lost        [id]            villes perdues (reprise en 1 bataille)
##   rewarded    [id]            villes dont le butin d'annexion a déjà été versé
##   battle_count, event_cd, threat_cd

const MAX_LEVEL := 3
const LEVEL_NAMES: Array[String] = ["Hameau", "Bourg", "Cité"]
const TROOP_COST := 30
const WALL_DEFENSE := 6
## Équipement du gouverneur : +1 défense par 10 de puissance (max 20), +1 or par 60 (max 4).
const GEAR_DEF_DIV := 10
const GEAR_DEF_MAX := 20
const GEAR_GOLD_DIV := 60
const GEAR_GOLD_MAX := 4
const RAID_CHANCE := 0.35
const RAVAGE_BATTLES := 3
const THREAT_ETA := 3
const THREAT_MIN_GAP := 5
const THREAT_CHANCE := 0.35
const EVENT_MIN_GAP := 2
const EVENT_CHANCE := 0.45
const RES_KEYS: Array[String] = ["Bois", "Fer", "Cuir", "Magie", "Venin"]

## Chancelier : tous ces batailles, le Conseil propose un édit stratégique
## (trade-off or / effet temporaire), via le même popup que les événements.
const CHANCELLOR_INTERVAL := 5
const CHANCELLOR_MIN_CITIES := 2
const DRILL_DEF := 2
const DRILL_BATTLES := 3
const ROADS_BOIS := 2
const ROADS_BATTLES := 4

## Lieutenance — missions de 3 batailles pour les héros libres : un héros
## envoyé en mission ne participe ni aux assauts ni au gouvernement, et
## rapporte sa récompense (ou sa complication) à son retour.
const MISSION_BATTLES := 3
const MISSION_CHANCE := 0.20
const MISSION_TYPES := {
	"caravane": {"label": "Escorte de caravane", "text": "Protéger les marchands jusqu'aux passes de l'empire.",
		"gold": 90, "res": {"Cuir": 4}},
	"carte": {"label": "Cartographie", "text": "Relever les terres inexplorées au-delà des frontières.",
		"reveal": 2},
	"filon": {"label": "Prospection", "text": "Chercher des filons dans les montagnes voisines.",
		"gold": 30, "res": {"Fer": 8}},
	}

## Généraux du Roi Squelette : chacun tient une forteresse (kind "enemy") d'une
## grande région. Tant qu'il vit, sa forteresse est mieux défendue et il peut
## lancer une offensive nommée ; le vaincre en assaut (4e bataille) calme la
## région et affaiblit le Donjon (tous les vaincus = assaut du Donjon facilité).
const GENERALS := {
	"garnison":      {"name": "Vorkann le Givre",   "region": "Montagne/Cristaux/Vents"},
	"fort_racine":   {"name": "Tharok le Végétal",  "region": "Forêt"},
	"tour_sable":    {"name": "Zahor le Sableux",   "region": "Désert/Marées"},
	"citadelle_ronce": {"name": "Nébulia l'Illusionniste", "region": "Ombres/Brumes"},
}
const GENERAL_DEF_BONUS := 3
const GENERAL_THREAT_BONUS := 2
const GENERAL_THREAT_CHANCE := 0.25

## Plans d'assaut (sièges ennemis) : le blocus et l'infiltration font
## progresser le siège d'une vague sans combat, au prix d'un risque ou d'un
## héros libre. L'assaut direct reste la voie des armes.
const PLAN_COST := {"blocus": 40, "infiltration": 50}
const PLAN_RAID_CHANCE := 0.35

## Reconquête ennemie : les villes non possédées se garnissent au fil de vos
## victoires — attendre une cible la durcit.
const GARRISON_EVERY := 3
const GARRISON_MAX := 6

## Diplomatie : coût d'annexion négociée d'une ville neutre (or + ressource
## de son biome). Plus cher que la voie des armes… en or. La ressource exigée
## est la spécialité de la ville (CITY_TRAITS), payable en une fois.
const DIPLO_GOLD := 120
const DIPLO_RES := 8

## Ruine & reconstruction : une ville perdue puis reprise reste ruinée —
## niveau -1 (min 1) et production gelée RUIN_BATTLES, relevée en payant.
const RUIN_BATTLES := 3
const RUIN_REPAIR_GOLD := 80

## Légende (fin de campagne) : score construit tout au long de la conquête.
## Les composantes sont simples à suivre et affichées dans l'épilogue.
##   villes     : 10 par ville possédée (hors capitale)
##   niveaux    : 5 par niveau de ville au-dessus de Hameau
##   gouverneurs : 4 par gouverneur en poste
##   pierres    : 30 par Pierre Élémentaire possédée
##   diplomatie : 6 par ville annexée par négociation (voie pacifique)
##   ruines    : -8 par ville ruinée non réparée à la fin
const LEGEND_WEIGHTS := {"villes": 10, "niveaux": 5, "gouverneurs": 4, "pierres": 30, "diplomatie": 6, "ruines": -8}

## Spécialité économique de chaque ville (biome/Nation) : ressources versées
## à chaque victoire, mises à l'échelle du niveau de la ville. Les villes sans
## entrée (capitale, Donjon) n'ont pas de spécialité.
const CITY_TRAITS := {
	"clairiere": {"label": "Scierie d'Aube", "res": {"Bois": 2}},
	"vieille_tour": {"label": "Réserve de la Tour", "res": {"Fer": 2}},
	"pont_mousse": {"label": "Pêche du pont", "res": {"Cuir": 2}},
	"fort_racine": {"label": "Arsenal de Racine", "res": {"Fer": 3}},
	"hameau_pin": {"label": "Cabanons des Pics", "res": {"Bois": 2, "Cuir": 1}},
	"garnison": {"label": "Dépôt des Pics", "res": {"Fer": 3}},
	"oasis": {"label": "Herbier de l'Oasis", "res": {"Venin": 2}},
	"tour_sable": {"label": "Verriers des Dunes", "res": {"Magie": 2}},
	"village_brume": {"label": "Herbier des Brumes", "res": {"Venin": 2}},
	"ruines_lierre": {"label": "Pillardage du Lierre", "res": {"Magie": 2}},
	"abbaye_ronce": {"label": "Scriptorium", "res": {"Magie": 2, "Bois": 1}},
	"citadelle_ronce": {"label": "Fonderie des Ronces", "res": {"Fer": 2, "Cuir": 2}},
	"col_givre": {"label": "Cueillette du Col", "res": {"Magie": 2}},
	"mine_cristal": {"label": "Filon de cristal", "res": {"Magie": 3}},
	"bastion_orage": {"label": "Forge de l'Orage", "res": {"Fer": 2, "Bois": 1}},
	"caravanserail": {"label": "Comptoir rouge", "res": {"Cuir": 2}},
	"observatoire": {"label": "Lunettes solaires", "res": {"Magie": 2}},
	"port_sable": {"label": "Chantier naval", "res": {"Cuir": 3}},
	"bois_lune": {"label": "Sève de lune", "res": {"Bois": 2, "Magie": 1}},
	"sanctuaire_mousse": {"label": "Reliques moussues", "res": {"Magie": 1, "Venin": 1}},
	"forge_givre": {"label": "Forge du Givre", "res": {"Fer": 3}},
	"pic_foudroyant": {"label": "Capteurs de foudre", "res": {"Magie": 2, "Fer": 1}},
	"marais_spectres": {"label": "Essences des Marais", "res": {"Venin": 3}},
	"fort_cendre": {"label": "Trempe des Cendres", "res": {"Fer": 2, "Venin": 1}},
	"temple_soleil": {"label": "Offrandes solaires", "res": {"Magie": 3}},
	"citadelle_sable": {"label": "Four à grès", "res": {"Fer": 2, "Cuir": 1}},
	"atelier_cuivre": {"label": "Ateliers de cuivre", "res": {"Fer": 2, "Cuir": 1}},
	"citadelle_engrenages": {"label": "Usines à engrenages", "res": {"Fer": 3, "Magie": 1}},
}

## Coût (or + ressources) pour atteindre le niveau clé.
const UPGRADE := {
	2: {"gold": 120, "res": {"Bois": 10, "Fer": 10}},
	3: {"gold": 300, "res": {"Fer": 20, "Cuir": 10, "Magie": 10}},
}

## Effets d'un héros gouverneur, par classe : def = défense en plus,
## gold = or par bataille, res = ressources par bataille, heal = soldats
## recrutés gratuitement par bataille dans sa ville.
const GOVERNOR := {
	"Tank":       {"def": 8, "gold": 0, "res": {}, "heal": 0, "text": "Rempart vivant : +8 défense"},
	"Assassin":   {"def": 0, "gold": 4, "res": {}, "heal": 0, "text": "Réseau d'informateurs : +4 or par bataille"},
	"Chasseur":   {"def": 2, "gold": 0, "res": {"Cuir": 2}, "heal": 0, "text": "Chasse et peaux : +2 Cuir par bataille"},
	"Mage":       {"def": 2, "gold": 0, "res": {"Magie": 1}, "heal": 0, "text": "Tour d'étude : +1 Magie par bataille"},
	"Druide":     {"def": 0, "gold": 0, "res": {"Bois": 2, "Venin": 1}, "heal": 0, "text": "Jardins sacrés : +2 Bois, +1 Venin"},
	"Heal":       {"def": 0, "gold": 0, "res": {}, "heal": 1, "text": "Infirmerie : +1 soldat par bataille"},
	"Invocateur": {"def": 4, "gold": 0, "res": {}, "heal": 0, "text": "Gardiens invoqués : +4 défense"},
	"Sylvain":    {"def": 3, "gold": 0, "res": {"Bois": 1}, "heal": 0, "text": "Sentinelles : +3 défense, +1 Bois"},
	"Géomancien": {"def": 2, "gold": 0, "res": {"Fer": 2}, "heal": 0, "text": "Filons : +2 Fer, +2 défense"},
	"Artificier": {"def": 2, "gold": 3, "res": {"Fer": 1}, "heal": 0, "text": "Ateliers : +3 or, +1 Fer, +2 défense"},
}

# ═══════════════════════════════════════════════════════════════════════
#  Lecture de l'état
# ═══════════════════════════════════════════════════════════════════════

static func city_level(conq: Dictionary, id: String) -> int:
	return clampi(int(conq.get("city_levels", {}).get(id, 1)), 1, MAX_LEVEL)

static func level_name(level: int) -> String:
	return LEVEL_NAMES[clampi(level, 1, MAX_LEVEL) - 1]

static func garrison_cap(conq: Dictionary, id: String) -> int:
	return 2 + 2 * city_level(conq, id)

static func troops(conq: Dictionary, id: String) -> int:
	return clampi(int(conq.get("garrisons", {}).get(id, {}).get("troops", 0)), 0, garrison_cap(conq, id))

static func hero_of(conq: Dictionary, id: String) -> String:
	return String(conq.get("garrisons", {}).get(id, {}).get("hero", ""))

## Ville où ce héros est en poste, ou "".
static func hero_city(conq: Dictionary, classe: String) -> String:
	var g: Dictionary = conq.get("garrisons", {})
	for id: String in g.keys():
		if String(g[id].get("hero", "")) == classe:
			return id
	return ""

## Héros en poste (classes), pour les exclure de la sélection d'équipe.
static func stationed_heroes(conq: Dictionary) -> Array:
	var out: Array = []
	var g: Dictionary = conq.get("garrisons", {})
	for id: String in g.keys():
		var h: String = String(g[id].get("hero", ""))
		if h != "" and (conq.get("owned", []) as Array).has(id):
			out.append(h)
	return out

static func is_ravaged(conq: Dictionary, id: String) -> bool:
	return int(conq.get("ravage", {}).get(id, 0)) > 0

static func has_wall(conq: Dictionary, id: String) -> bool:
	return (conq.get("buildings", {}).get(id, []) as Array).has("muraille")

static func hero_level(data: Dictionary, classe: String) -> int:
	return int(data.get("roster", {}).get(classe, {}).get("level", 1))

## Équipement du gouverneur : valeur totale de ses objets portés (ItemRules.power).
static func governor_gear_power(data: Dictionary, classe: String) -> int:
	var total: int = 0
	var roster: Dictionary = data.get("roster", {})
	var eq: Dictionary = {}
	for m: Dictionary in data.get("team", []):
		if String(m.get("classe", "")) == classe:
			eq = m.get("equipment", {})
	if eq.is_empty():
		eq = roster.get(classe, {}).get("equipment", {})
	for it: Variant in eq.values():
		if it is Dictionary:
			total += ItemRules.power(it)
	return total

## Bonus de défense apporté par l'équipement du gouverneur (plafonné).
static func governor_gear_defense(data: Dictionary, classe: String) -> int:
	return mini(GEAR_DEF_MAX, governor_gear_power(data, classe) / GEAR_DEF_DIV)

## Bonus d'or par bataille apporté par l'équipement du gouverneur (plafonné).
static func governor_gear_gold(data: Dictionary, classe: String) -> int:
	return mini(GEAR_GOLD_MAX, governor_gear_power(data, classe) / GEAR_GOLD_DIV)

static func governor_text(classe: String) -> String:
	return String(GOVERNOR.get(classe, {}).get("text", "Gouverneur"))

## Défense d'une ville : soldats, niveau, muraille et héros gouverneur.
static func defense(data: Dictionary, id: String) -> int:
	var conq: Dictionary = data.get("conquest", {})
	var d: int = troops(conq, id) * 2 + city_level(conq, id) * 3 + drill_defense(conq)
	if has_wall(conq, id):
		d += WALL_DEFENSE
	var h: String = hero_of(conq, id)
	if h != "":
		d += 6 + int(float(hero_level(data, h)) * 0.5) + int(GOVERNOR.get(h, {}).get("def", 0)) + governor_gear_defense(data, h)
	return d

## Or versé par bataille gagnée par une ville (gelé si pillée).
static func city_income(data: Dictionary, id: String) -> int:
	var conq: Dictionary = data.get("conquest", {})
	if is_ravaged(conq, id) or is_ruined(conq, id):
		return 0
	var base: int = (3 if id == "capitale" else 2) * city_level(conq, id)
	var h: String = hero_of(conq, id)
	if h != "":
		base += 2 + int(GOVERNOR.get(h, {}).get("gold", 0)) + governor_gear_gold(data, h)
	return base

static func total_income(data: Dictionary) -> int:
	var conq: Dictionary = data.get("conquest", {})
	var t: int = 0
	for id: String in conq.get("owned", []):
		t += city_income(data, id)
	return t

## Facteur de production des bâtiments selon le niveau de la ville.
static func level_multiplier(conq: Dictionary, id: String) -> float:
	return 1.0 + 0.5 * float(city_level(conq, id) - 1)

## Ressources produites par les héros gouverneurs (villes non pillées).
static func governor_yield(conq: Dictionary) -> Dictionary:
	var out: Dictionary = {}
	for id: String in conq.get("owned", []):
		if is_ravaged(conq, id) or is_ruined(conq, id):
			continue
		var h: String = hero_of(conq, id)
		if h == "":
			continue
		var r: Dictionary = GOVERNOR.get(h, {}).get("res", {})
		for k: String in r.keys():
			out[k] = int(out.get(k, 0)) + int(r[k])
	return out

static func threat(conq: Dictionary) -> Dictionary:
	return conq.get("threat", {})

# ═══════════════════════════════════════════════════════════════════════
#  Actions du joueur
# ═══════════════════════════════════════════════════════════════════════

static func upgrade_cost(conq: Dictionary, id: String) -> Dictionary:
	return UPGRADE.get(city_level(conq, id) + 1, {})

## Améliore une ville. Retourne "" si OK, sinon la raison.
static func upgrade_city(data: Dictionary, id: String, city_name: String = "") -> String:
	var conq: Dictionary = data.get("conquest", {})
	if not (conq.get("owned", []) as Array).has(id):
		return "Ville non conquise."
	if is_ravaged(conq, id):
		return "Ville pillée : impossible de l'améliorer."
	if city_level(conq, id) >= MAX_LEVEL:
		return "Cette ville est déjà une Cité."
	var cost: Dictionary = upgrade_cost(conq, id)
	var res: Dictionary = data.get("resources", {})
	for k: String in cost.get("res", {}).keys():
		if int(res.get(k, 0)) < int(cost["res"][k]):
			return "Ressource insuffisante : %s (%d/%d)." % [k, int(res.get(k, 0)), int(cost["res"][k])]
	if int(data.get("gold", 0)) < int(cost.get("gold", 0)):
		return "Or insuffisant : %d pièces requises." % int(cost.get("gold", 0))
	for k: String in cost.get("res", {}).keys():
		res[k] = int(res.get(k, 0)) - int(cost["res"][k])
	data["resources"] = res
	data["gold"] = int(data.get("gold", 0)) - int(cost.get("gold", 0))
	var lv: Dictionary = conq.get("city_levels", {})
	lv[id] = city_level(conq, id) + 1
	conq["city_levels"] = lv
	log_event(conq, "Ville améliorée : %s devient un %s" % [city_name if city_name != "" else id, level_name(int(lv[id]))])
	data["conquest"] = conq
	return ""

## Recrute n soldats (30 or pièce) dans la garnison, dans la limite de la place.
static func recruit(data: Dictionary, id: String, n: int) -> String:
	var conq: Dictionary = data.get("conquest", {})
	if not (conq.get("owned", []) as Array).has(id):
		return "Ville non conquise."
	var room: int = garrison_cap(conq, id) - troops(conq, id)
	if room <= 0:
		return "Garnison pleine (%d/%d) : améliorez la ville pour l'agrandir." % [troops(conq, id), garrison_cap(conq, id)]
	var count: int = mini(n, room)
	var cost: int = count * TROOP_COST
	if int(data.get("gold", 0)) < cost:
		return "Or insuffisant : %d pièces requises." % cost
	data["gold"] = int(data.get("gold", 0)) - cost
	_set_garrison(conq, id, troops(conq, id) + count, hero_of(conq, id))
	data["conquest"] = conq
	return ""

static func assign_hero(data: Dictionary, id: String, classe: String) -> String:
	var conq: Dictionary = data.get("conquest", {})
	if not (conq.get("owned", []) as Array).has(id):
		return "Ville non conquise."
	if not GOVERNOR.has(classe):
		return "Héros inconnu."
	if hero_of(conq, id) != "":
		return "Cette ville a déjà un gouverneur."
	if stationed_heroes(conq).size() >= 6:
		return "Trop de gouverneurs : 3 héros doivent rester disponibles pour les assauts."
	var elsewhere: String = hero_city(conq, classe)
	if elsewhere != "":
		return "%s gouverne déjà une autre ville." % classe
	_set_garrison(conq, id, troops(conq, id), classe)
	data["conquest"] = conq
	return ""

static func recall_hero(data: Dictionary, id: String) -> String:
	var conq: Dictionary = data.get("conquest", {})
	if hero_of(conq, id) == "":
		return "Aucun gouverneur dans cette ville."
	_set_garrison(conq, id, troops(conq, id), "")
	data["conquest"] = conq
	return ""

# ═════════════════════════════════════════════════════════════════════════════
#  Lieutenance — missions des héros libres
# ═════════════════════════════════════════════════════════════════════════════

## Héros en mission : {classe -> {"type": mission_id, "eta": batailles restantes}}.
static func missions(conq: Dictionary) -> Dictionary:
	return conq.get("missions", {})

static func hero_on_mission(conq: Dictionary, classe: String) -> Dictionary:
	return missions(conq).get(classe, {})

## Héros indisponibles (gouverneurs + en mission), pour la sélection d'équipe
## et le choix des gouverneurs.
static func busy_heroes(conq: Dictionary) -> Array:
	var out: Array = stationed_heroes(conq)
	for classe: String in missions(conq).keys():
		if not out.has(classe):
			out.append(classe)
	return out

## Types de missions disponibles (tous peuvent être tentés à tout moment).
static func mission_types() -> Array:
	return MISSION_TYPES.keys()

static func mission_text(type_id: String) -> String:
	return String(MISSION_TYPES.get(type_id, {}).get("text", ""))

static func mission_label(type_id: String) -> String:
	return String(MISSION_TYPES.get(type_id, {}).get("label", "Mission"))

## Envoie un héros libre en mission de 3 batailles. Retourne "" si OK.
static func send_mission(conq: Dictionary, classe: String, type_id: String) -> String:
	if not GOVERNOR.has(classe):
		return "Héros inconnu."
	if not MISSION_TYPES.has(type_id):
		return "Mission inconnue."
	if hero_city(conq, classe) != "":
		return "%s gouverne déjà une ville." % classe
	if not hero_on_mission(conq, classe).is_empty():
		return "%s est déjà en mission." % classe
	var m: Dictionary = missions(conq)
	m[classe] = {"type": type_id, "eta": MISSION_BATTLES}
	conq["missions"] = m
	return ""

## Rappelle un héros de sa mission (il revient bredouille, sans récompense).
static func abort_mission(conq: Dictionary, classe: String) -> String:
	if hero_on_mission(conq, classe).is_empty():
		return "Aucune mission en cours pour ce héros."
	var m: Dictionary = missions(conq)
	m.erase(classe)
	conq["missions"] = m
	return ""

## Fait avancer les missions d'une bataille et règle les retours. Les villes
## révélées sont ajoutées à adventure.revealed_cities (pont inter-modes) par
## ProgressionManager, qui passe les candidates ici.
static func _tick_missions(data: Dictionary, conq: Dictionary, rng: RandomNumberGenerator,
		unrevealed: Array) -> void:
	var m: Dictionary = missions(conq)
	if m.is_empty():
		return
	for classe: String in m.keys().duplicate():
		var job: Dictionary = m[classe]
		job["eta"] = int(job.get("eta", 1)) - 1
		if int(job["eta"]) > 0:
			m[classe] = job
			continue
		m.erase(classe)
		var type: String = String(job.get("type", "caravane"))
		if type == "infiltration":
			note(conq, "⚑ %s revient de l'infiltration : il reprend sa place au combat." % classe)
			continue
		var info: Dictionary = MISSION_TYPES.get(type, {})
		var lvl: int = hero_level(data, classe)
		if rng.randf() < MISSION_CHANCE:
			var loss: int = 10 + lvl
			data["gold"] = maxi(0, int(data.get("gold", 0)) - loss)
			note(conq, "⚑ %s revient de « %s » bredouille : l'expédition a coûté %d or." % [classe, mission_label(type), loss])
			continue
		var gold: int = int(info.get("gold", 0)) + lvl * 2
		if gold > 0:
			data["gold"] = int(data.get("gold", 0)) + gold
		var drops: Dictionary = {}
		for r: String in info.get("res", {}).keys():
			drops[r] = int(info["res"][r]) + int(lvl / 3.0)
		if not drops.is_empty():
			_add_res(data, drops)
		var revealed: Array = []
		if int(info.get("reveal", 0)) > 0 and not unrevealed.is_empty():
			for i: int in range(mini(int(info["reveal"]), unrevealed.size())):
				revealed.append(unrevealed[i])
			if not revealed.is_empty():
				var so_far: Array = conq.get("missions_revealed", [])
				for cid: String in revealed:
					if not so_far.has(cid):
						so_far.append(cid)
				conq["missions_revealed"] = so_far
		var parts: Array = ["+%d or" % gold]
		for r: String in drops.keys():
			parts.append("+%d %s" % [int(drops[r]), r])
		if not revealed.is_empty():
			var rnames: Array = []
			for cid: String in revealed:
				rnames.append(_name(conq, cid))
			parts.append("révèle %s" % ", ".join(PackedStringArray(rnames)))
		note(conq, "⚑ %s revient de « %s » : %s." % [classe, mission_label(type), ", ".join(PackedStringArray(parts))])
	conq["missions"] = m

# ═════════════════════════════════════════════════════════════════════════════
#  Généraux du Roi Squelette
# ═════════════════════════════════════════════════════════════════════════════

## Général tenant cette ville, ou "" (vide une fois la ville annexée : le
## général est vaincu quand sa forteresse tombe).
static func general_of(conq: Dictionary, id: String) -> String:
	if (conq.get("owned", []) as Array).has(id):
		return ""
	return String(GENERALS.get(id, {}).get("name", ""))

## Généraux encore en vie (leur forteresse n'est pas conquise).
static func living_generals(conq: Dictionary) -> Array:
	var out: Array = []
	for cid: String in GENERALS.keys():
		if general_of(conq, cid) != "":
			out.append(cid)
	return out

static func living_generals_count(conq: Dictionary) -> int:
	return living_generals(conq).size()

static func general_region(id: String) -> String:
	return String(GENERALS.get(id, {}).get("region", ""))

## Bonus de niveau des batailles de siège tant que le général tient sa
## forteresse (appliqué par GameManager à la difficulté, affiché sur la carte).
static func general_defense_bonus(conq: Dictionary, id: String) -> int:
	return GENERAL_DEF_BONUS if general_of(conq, id) != "" else 0

## Nom du boss de la 4e bataille du siège d'une forteresse de général.
## Vide pour une ville ordinaire (le boss du biome reste utilisé).
static func general_boss_name(conq: Dictionary, id: String) -> String:
	return general_of(conq, id)

## Les généraux vivants lancent parfois leur propre offensive, plus forte que
## les offensives anonymes (réutilise le système threat, avec un visage).
static func _maybe_general_threat(data: Dictionary, conq: Dictionary, rng: RandomNumberGenerator,
		routes: Array, just_conquered: String) -> void:
	if not threat(conq).is_empty():
		return
	var alive: Array = living_generals(conq)
	if alive.is_empty() or rng.randf() > GENERAL_THREAT_CHANCE:
		return
	var pool: Array = _target_pool(conq, routes, just_conquered, true)
	if pool.is_empty():
		return
	var id: String = String(pool[rng.randi_range(0, pool.size() - 1)])
	var power: int = roundi((8.0 + 2.0 * float(owned_count(conq)) + float(int(conq.get("battle_count", 0))) / 3.0) * rng.randf_range(0.95, 1.25)) + GENERAL_THREAT_BONUS
	var gid: String = String(alive[rng.randi_range(0, alive.size() - 1)])
	var gname: String = String(GENERALS.get(gid, {}).get("name", ""))
	conq["threat"] = {"city": id, "power": power, "eta": THREAT_ETA, "general": gname}
	conq["threat_cd"] = 0
	note(conq, "☠ %s, général du Roi Squelette, prépare une offensive (force %d) sur %s dans %d batailles !" % [gname, power, _name(conq, id), THREAT_ETA])

# ═════════════════════════════════════════════════════════════════════════════
#  Plans d'assalt (sièges ennemis)
# ═════════════════════════════════════════════════════════════════════════════

## Coût en or du plan d'assaut (0 pour l'assaut direct).
static func plan_cost(plan: String) -> int:
	return int(PLAN_COST.get(plan, 0))

## L'infiltration exige l'Assassin libre (ni gouverneur ni en mission).
static func infiltration_ready(conq: Dictionary) -> bool:
	return hero_city(conq, "Assassin") == "" and hero_on_mission(conq, "Assassin").is_empty()

## Applique un plan d'assaut au lancement du siège : débite l'or, engage
## l'Assassin si besoin, retourne {"error": raison} en cas de refus.
## Retour {"skipped": true} si le plan fait avancer le siège d'une vague sans
## combat (blocus / infiltration) ; l'Assassin revient après 1 bataille.
static func apply_plan(data: Dictionary, conq: Dictionary, id: String, plan: String, rng: RandomNumberGenerator) -> Dictionary:
	if (conq.get("owned", []) as Array).has(id):
		return {"error": "Ville déjà conquise."}
	match plan:
		"direct":
			return {"skipped": false}
		"blocus":
			var cost: int = plan_cost("blocus")
			if int(data.get("gold", 0)) < cost:
				return {"error": "Or insuffisant : %d pièces requises." % cost}
			data["gold"] = int(data.get("gold", 0)) - cost
			if rng.randf() < PLAN_RAID_CHANCE:
				var pool: Array = _target_pool(conq, [], "", true)
				if not pool.is_empty():
					var rid: String = String(pool[rng.randi_range(0, pool.size() - 1)])
					var r: Dictionary = conq.get("ravage", {})
					r[rid] = RAVAGE_BATTLES
					conq["ravage"] = r
					note(conq, "Le blocus de %s agace l'ennemi : %s est pillée (%d batailles) !" % [_name(conq, id), _name(conq, rid), RAVAGE_BATTLES])
			else:
				note(conq, "Le blocus de %s resserre l'étau : une vague saute sans combat." % _name(conq, id))
			return {"skipped": true}
		"infiltration":
			if not infiltration_ready(conq):
				return {"error": "L'Assassin doit être libre (ni gouverneur ni en mission)."}
			var cost2: int = plan_cost("infiltration")
			if int(data.get("gold", 0)) < cost2:
				return {"error": "Or insuffisant : %d pièces requises." % cost2}
			data["gold"] = int(data.get("gold", 0)) - cost2
			var m: Dictionary = missions(conq)
			m["Assassin"] = {"type": "infiltration", "eta": 1}
			conq["missions"] = m
			note(conq, "L'Assassin s'infiltre dans %s : une vague ennemie est sabordée de l'intérieur. Il revient à la prochaine victoire." % _name(conq, id))
			return {"skipped": true}
	return {"error": "Plan d'assaut inconnu."}

# ═════════════════════════════════════════════════════════════════════════════
#  Reconquête ennemie : garnisons adverses croissantes
# ═════════════════════════════════════════════════════════════════════════════

## Garnison adverse d'une ville non possédée (0 pour une ville possédée).
## Elle monte de 1 toutes les GARRISON_EVERY victoires du joueur, max GARRISON_MAX.
static func enemy_garrison(conq: Dictionary, id: String) -> int:
	if (conq.get("owned", []) as Array).has(id):
		return 0
	var battles: int = int(conq.get("battle_count", 0))
	return mini(GARRISON_MAX, int(battles / float(GARRISON_EVERY)))

## Bonus de niveau des batailles contre une ville défendue (+1 par tranche de 2
## soldats adverses) : attendre une cible la rend plus dure.
static func enemy_garrison_bonus(conq: Dictionary, id: String) -> int:
	return int(enemy_garrison(conq, id) / 2.0)

# ═════════════════════════════════════════════════════════════════════════════
#  Diplomatie — annexion négociée des villes neutres
# ═════════════════════════════════════════════════════════════════════════════

## Coût de l'annexion négociée d'une ville neutre : or + la ressource
## spécialité de la ville (CITY_TRAITS), payable en une fois.
static func diplomacy_cost(conq: Dictionary, id: String) -> Dictionary:
	var res_key: String = ""
	var spec: Dictionary = CITY_TRAITS.get(id, {})
	if not spec.get("res", {}).is_empty():
		res_key = String(spec.get("res", {}).keys()[0])
	if res_key == "":
		res_key = "Bois"
	return {"gold": DIPLO_GOLD, "res": {res_key: DIPLO_RES}}

## Annexe une ville neutre par négociation (voie pacifique). Retourne "" si OK.
## routes : CONQUEST_ROUTES — la ville doit être atteignable (même règle que
## l'assaut : reliée au territoire). names : id -> nom, pour le journal.
static func negotiate_city(data: Dictionary, conq: Dictionary, id: String,
		routes: Array, names: Dictionary) -> String:
	if (conq.get("owned", []) as Array).has(id):
		return "Ville déjà conquise."
	conq["_names"] = names
	var owned: Array = conq.get("owned", [])
	var linked: bool = false
	for pair: Array in routes:
		var a: String = String(pair[0])
		var b: String = String(pair[1])
		if (a == id and owned.has(b)) or (b == id and owned.has(a)):
			linked = true
			break
	if not linked:
		conq.erase("_names")
		return "Aucune route depuis votre territoire : conquérez d'abord une ville voisine."
	var cost: Dictionary = diplomacy_cost(conq, id)
	var res: Dictionary = data.get("resources", {})
	for k: String in cost.get("res", {}).keys():
		if int(res.get(k, 0)) < int(cost["res"][k]):
			conq.erase("_names")
			return "Ressource insuffisante : %s (%d/%d)." % [k, int(res.get(k, 0)), int(cost["res"][k])]
	if int(data.get("gold", 0)) < int(cost.get("gold", 0)):
		conq.erase("_names")
		return "Or insuffisant : %d pièces requises." % int(cost.get("gold", 0))
	for k: String in cost.get("res", {}).keys():
		res[k] = int(res.get(k, 0)) - int(cost["res"][k])
	data["resources"] = res
	data["gold"] = int(data.get("gold", 0)) - int(cost.get("gold", 0))
	owned.append(id)
	conq["owned"] = owned
	var dip: Array = conq.get("annexed_diplomacy", [])
	if not dip.has(id):
		dip.append(id)
	conq["annexed_diplomacy"] = dip
	conq["just_annexed"] = id
	note(conq, "☮ %s rejoint l'empire par négociation : l'or a parlé plus fort que les armes." % _name(conq, id))
	conq.erase("_names")
	return ""

# ═════════════════════════════════════════════════════════════════════════════
#  Ruine & reconstruction
# ═════════════════════════════════════════════════════════════════════════════

## Une ville perdue puis reprise reste ruinée : niveau -1 (min 1, reflété par
## _ruin_level) et production gelée RUIN_BATTLES.
static func is_ruined(conq: Dictionary, id: String) -> bool:
	return int(conq.get("ruin", {}).get(id, 0)) > 0

## La ruine décrémente à chaque victoire ; réparée, elle disparaît.
static func _tick_ruins(conq: Dictionary) -> void:
	var ruins: Dictionary = conq.get("ruin", {})
	if ruins.is_empty():
		return
	for id: String in ruins.keys().duplicate():
		if not (conq.get("owned", []) as Array).has(id):
			continue
		ruins[id] = int(ruins.get(id, 0)) - 1
		if int(ruins[id]) <= 0:
			ruins.erase(id)
			note(conq, "⚒ %s se relève de ses ruines : production reprise." % _name(conq, id))
	conq["ruin"] = ruins

## Répare une ville ruinée (80 or) : la production reprend. Retourne "" si OK.
static func repair_city(data: Dictionary, conq: Dictionary, id: String) -> String:
	if not is_ruined(conq, id):
		return "Cette ville n'est pas ruinée."
	if int(data.get("gold", 0)) < RUIN_REPAIR_GOLD:
		return "Or insuffisant : %d pièces requises." % RUIN_REPAIR_GOLD
	data["gold"] = int(data.get("gold", 0)) - RUIN_REPAIR_GOLD
	var ruins: Dictionary = conq.get("ruin", {})
	ruins.erase(id)
	conq["ruin"] = ruins
	return ""

# ═════════════════════════════════════════════════════════════════════════════
#  Légende — score de fin de campagne et fins multiples
# ═════════════════════════════════════════════════════════════════════════════

## Détail du score de Légende (clé -> points). stones : nombre de Pierres
## Élémentaires du joueur (fourni par ProgressionManager depuis Stones).
static func legend_score(conq: Dictionary, stones: int) -> Dictionary:
	var w: Dictionary = LEGEND_WEIGHTS
	var out: Dictionary = {"villes": 0, "niveaux": 0, "gouverneurs": 0, "pierres": 0, "diplomatie": 0, "ruines": 0}
	out["villes"] = owned_count(conq) * int(w["villes"])
	var lv: int = 0
	for id: String in conq.get("owned", []):
		lv += maxi(0, city_level(conq, id) - 1)
	out["niveaux"] = lv * int(w["niveaux"])
	out["gouverneurs"] = stationed_heroes(conq).size() * int(w["gouverneurs"])
	out["pierres"] = stones * int(w["pierres"])
	out["diplomatie"] = (conq.get("annexed_diplomacy", []) as Array).size() * int(w["diplomatie"])
	var ruined: int = 0
	for id: String in conq.get("owned", []):
		if is_ruined(conq, id):
			ruined += 1
	out["ruines"] = ruined * int(w["ruines"])
	return out

static func legend_total(score: Dictionary) -> int:
	var total: int = 0
	for k: String in score.keys():
		total += int(score[k])
	return total

## Fin de campagne selon le score : trois légendes possibles à la chute du
## Donjon. Le style de jeu (diplomatie, développement, Pierres) décide de la
## fin, pas seulement le fait de gagner.
static func legend_ending(score: Dictionary, conq: Dictionary) -> Dictionary:
	var dip: int = (conq.get("annexed_diplomacy", []) as Array).size()
	var neutral_total: int = 0
	for id: String in conq.get("owned", []):
		if id != "capitale" and id != "donjon_roi":
			neutral_total += 1
	if dip >= 4:
		return {"id": "marchand", "title": "EMPIRE MARCHAND",
			"text": "L'or a conquis plus de villes que le fer. Les routes de Zimut sont à vous, les comptoirs affluent : sous votre règne, le commerce a remplacé la guerre."}
	if int(score.get("niveaux", 0)) >= 40 and int(score.get("gouverneurs", 0)) >= 12:
		return {"id": "bastion", "title": "BASTION DE ZIMUT",
			"text": "Chaque ville est une forteresse, chaque gouverneur un rempart. Les Nations se souviendront longtemps de celui qui a rendu l'empire imprenable."}
	return {"id": "heros", "title": "ÂGE DES HÉROS",
		"text": "Vos héros ont mené chaque assaut, vaincu les généraux et le Roi Squelette en personne. Les bardes de Zimut chanteront leurs noms pendant des siècles."}

## Épilogue récapitulatif (affiché à la chute du Donjon) : score, détail et fin.
static func epilogue(score: Dictionary, ending: Dictionary) -> String:
	var lines: PackedStringArray = []
	lines.append("%s — %d points de Légende" % [String(ending.get("title", "")), legend_total(score)])
	lines.append("")
	lines.append("Villes %d · Développement +%d · Gouverneurs +%d" % [int(score.get("villes", 0)), int(score.get("niveaux", 0)), int(score.get("gouverneurs", 0))])
	lines.append("Pierres +%d · Diplomatie +%d · Ruines %d" % [int(score.get("pierres", 0)), int(score.get("diplomatie", 0)), int(score.get("ruines", 0))])
	lines.append("")
	lines.append(String(ending.get("text", "")))
	return "\n".join(lines)

static func _set_garrison(conq: Dictionary, id: String, n: int, hero: String) -> void:
	var g: Dictionary = conq.get("garrisons", {})
	g[id] = {"troops": clampi(n, 0, garrison_cap(conq, id)), "hero": hero}
	conq["garrisons"] = g

# ═══════════════════════════════════════════════════════════════════════
#  Journal
# ═══════════════════════════════════════════════════════════════════════

static func log_event(conq: Dictionary, text: String) -> void:
	var events: Array = conq.get("events", [])
	events.append(text)
	while events.size() > 10:
		events.pop_front()
	conq["events"] = events

## Nouvelle affichée au retour sur la carte, et gardée dans la chronique.
static func note(conq: Dictionary, text: String) -> void:
	var news: Array = conq.get("news", [])
	news.append(text)
	conq["news"] = news
	log_event(conq, text)

static func _add_res(data: Dictionary, drops: Dictionary) -> void:
	var res: Dictionary = data.get("resources", {})
	for k: String in drops.keys():
		res[k] = int(res.get(k, 0)) + int(drops[k])
	data["resources"] = res

## Noms de villes (renseignés une fois par ProgressionManager au démarrage).
static var city_names: Dictionary = {}

static func _name(conq: Dictionary, id: String) -> String:
	return String(conq.get("_names", city_names).get(id, city_names.get(id, id)))

# ═══════════════════════════════════════════════════════════════════════
#  Boucle après chaque victoire
# ═══════════════════════════════════════════════════════════════════════

## names : id -> nom de ville (fourni par ProgressionManager pour les messages).
## routes : CONQUEST_ROUTES (pour repérer les villes frontalières).
## unrevealed : villes que la cartographie peut révéler (pont Aventure).
static func after_victory(data: Dictionary, conq: Dictionary, rng: RandomNumberGenerator,
		routes: Array, names: Dictionary, just_conquered: String, unrevealed: Array = []) -> void:
	conq["_names"] = names
	conq["news"] = []
	conq["battle_count"] = int(conq.get("battle_count", 0)) + 1
	conq["last_counterattack"] = ""
	data["conquest"] = conq
	_collect_income(data, conq)
	_regen_garrisons(data, conq)
	_tick_threat(data, conq, rng)
	_tick_missions(data, conq, rng, unrevealed)
	_tick_chancellor_buffs(conq)
	_tick_ruins(conq)
	maybe_chancellor(conq)
	if int(conq.get("truce", 0)) > 0:
		conq["truce"] = int(conq["truce"]) - 1
	else:
		_roll_raid(data, conq, rng, routes, just_conquered)
		_maybe_spawn_threat(data, conq, rng, routes, just_conquered)
		_maybe_general_threat(data, conq, rng, routes, just_conquered)
	_maybe_event(data, conq, rng, routes, just_conquered)
	conq.erase("_names")
	data["conquest"] = conq

static func _collect_income(data: Dictionary, conq: Dictionary) -> void:
	var gold: int = total_income(data)
	if gold > 0:
		data["gold"] = int(data.get("gold", 0)) + gold
	conq["last_income"] = gold

static func _regen_garrisons(data: Dictionary, conq: Dictionary) -> void:
	for id: String in conq.get("owned", []):
		var h: String = hero_of(conq, id)
		if h == "" or is_ravaged(conq, id):
			continue
		var heal: int = int(GOVERNOR.get(h, {}).get("heal", 0))
		if heal > 0 and troops(conq, id) < garrison_cap(conq, id):
			_set_garrison(conq, id, troops(conq, id) + heal, h)

## Villes possédées pouvant être visées (ni la capitale, ni le Donjon, ni la
## ville fraîchement conquise), les villes frontalières comptant triple.
static func _target_pool(conq: Dictionary, routes: Array, just_conquered: String, skip_ravaged: bool) -> Array:
	var owned: Array = conq.get("owned", [])
	var pool: Array = []
	for id: String in owned:
		if id == "capitale" or id == "donjon_roi" or id == just_conquered:
			continue
		if skip_ravaged and is_ravaged(conq, id):
			continue
		var weight: int = 1
		for pair: Array in routes:
			var other: String = ""
			if String(pair[0]) == id:
				other = String(pair[1])
			elif String(pair[1]) == id:
				other = String(pair[0])
			if other != "" and not owned.has(other):
				weight = 3
				break
		for i: int in range(weight):
			pool.append(id)
	return pool

static func owned_count(conq: Dictionary) -> int:
	var n: int = 0
	for id: String in conq.get("owned", []):
		if id != "capitale" and id != "donjon_roi":
			n += 1
	return n

# ── Raids : petites attaques, contrées par la garnison ──────────────────
static func raid_power(conq: Dictionary) -> int:
	return 4 + int(float(owned_count(conq)) * 0.5)

static func _roll_raid(data: Dictionary, conq: Dictionary, rng: RandomNumberGenerator,
		routes: Array, just_conquered: String) -> void:
	if rng.randf() > RAID_CHANCE:
		return
	var pool: Array = _target_pool(conq, routes, just_conquered, true)
	if pool.is_empty():
		return
	var id: String = String(pool[rng.randi_range(0, pool.size() - 1)])
	if defense(data, id) >= raid_power(conq):
		var t: int = troops(conq, id)
		if t > 0:
			_set_garrison(conq, id, t - 1, hero_of(conq, id))
		note(conq, "♜ Raid repoussé à %s : la garnison tient bon." % _name(conq, id))
		return
	var r: Dictionary = conq.get("ravage", {})
	r[id] = RAVAGE_BATTLES
	conq["ravage"] = r
	conq["last_counterattack"] = id
	note(conq, "Contre-attaque : %s est pillée (%d batailles)" % [_name(conq, id), RAVAGE_BATTLES])

# ── Offensives annoncées ─────────────────────────────────────────────────
static func _maybe_spawn_threat(data: Dictionary, conq: Dictionary, rng: RandomNumberGenerator,
		routes: Array, just_conquered: String) -> void:
	if not threat(conq).is_empty():
		return
	conq["threat_cd"] = int(conq.get("threat_cd", 0)) + 1
	if owned_count(conq) < 3 or int(conq["threat_cd"]) < THREAT_MIN_GAP or rng.randf() > THREAT_CHANCE:
		return
	var pool: Array = _target_pool(conq, routes, just_conquered, true)
	if pool.is_empty():
		return
	var id: String = String(pool[rng.randi_range(0, pool.size() - 1)])
	var power: int = roundi((8.0 + 2.0 * float(owned_count(conq)) + float(int(conq.get("battle_count", 0))) / 3.0) * rng.randf_range(0.85, 1.15))
	conq["threat"] = {"city": id, "power": power, "eta": THREAT_ETA}
	conq["threat_cd"] = 0
	note(conq, "⚠ GRANDE OFFENSIVE ennemie (force %d) : %s sera attaquée dans %d batailles !" % [power, _name(conq, id), THREAT_ETA])

static func _tick_chancellor_buffs(conq: Dictionary) -> void:
	if int(conq.get("drill", 0)) > 0:
		conq["drill"] = int(conq["drill"]) - 1
	if int(conq.get("roadworks", 0)) > 0:
		conq["roadworks"] = int(conq["roadworks"]) - 1

static func _tick_threat(data: Dictionary, conq: Dictionary, rng: RandomNumberGenerator) -> void:
	var th: Dictionary = threat(conq)
	if th.is_empty():
		return
	var id: String = String(th.get("city", ""))
	if not (conq.get("owned", []) as Array).has(id):
		conq.erase("threat")
		return
	th["eta"] = int(th.get("eta", 1)) - 1
	if int(th["eta"]) > 0:
		conq["threat"] = th
		note(conq, "⚠ Offensive (force %d) sur %s : encore %d bataille(s). Défense actuelle : %d." % [
			int(th["power"]), _name(conq, id), int(th["eta"]), defense(data, id)])
		return
	conq.erase("threat")
	resolve_assault(data, conq, id, int(th.get("power", 10)))

## Résolution d'une offensive : repoussée, brèche, ou ville perdue.
static func resolve_assault(data: Dictionary, conq: Dictionary, id: String, power: int) -> String:
	var d: int = defense(data, id)
	var nm: String = _name(conq, id)
	var t: int = troops(conq, id)
	var h: String = hero_of(conq, id)
	if d >= power:
		_set_garrison(conq, id, t - int(ceil(float(t) * 0.25)), h)
		var loot: int = 20 + power * 3
		data["gold"] = int(data.get("gold", 0)) + loot
		note(conq, "★ OFFENSIVE REPOUSSÉE à %s (défense %d contre force %d) ! Butin : +%d or." % [nm, d, power, loot])
		return "repelled"
	if float(d) >= float(power) * 0.6:
		_set_garrison(conq, id, int(float(t) * 0.5), h)
		var r: Dictionary = conq.get("ravage", {})
		r[id] = RAVAGE_BATTLES + 1
		conq["ravage"] = r
		conq["last_counterattack"] = id
		note(conq, "⚔ BRÈCHE à %s (défense %d contre force %d) : la ville est pillée %d batailles." % [nm, d, power, RAVAGE_BATTLES + 1])
		return "breach"
	# Ville perdue : retirée de l'empire, garnison dispersée, héros libéré.
	var owned: Array = conq.get("owned", [])
	owned.erase(id)
	conq["owned"] = owned
	var g: Dictionary = conq.get("garrisons", {})
	g.erase(id)
	conq["garrisons"] = g
	var lv: Dictionary = conq.get("city_levels", {})
	lv[id] = maxi(1, city_level(conq, id) - 1)
	conq["city_levels"] = lv
	var lost: Array = conq.get("lost", [])
	if not lost.has(id):
		lost.append(id)
	conq["lost"] = lost
	# Ruine & reconstruction : reprise en une bataille, mais ruinée à son retour.
	var ruins: Dictionary = conq.get("ruin", {})
	if int(ruins.get(id, 0)) <= 0:
		ruins[id] = RUIN_BATTLES
		conq["ruin"] = ruins
		note(conq, "⚒ %s est ruinée : sa production sera gelée %d batailles après sa reprise." % [nm, RUIN_BATTLES])
	var r2: Dictionary = conq.get("ravage", {})
	r2.erase(id)
	conq["ravage"] = r2
	note(conq, "☠ %s EST TOMBÉE (défense %d contre force %d) ! Reprenez-la : une seule bataille suffit." % [nm, d, power])
	return "lost"

# ═══════════════════════════════════════════════════════════════════════
#  Événements
# ═══════════════════════════════════════════════════════════════════════

static func pending_event(conq: Dictionary) -> Dictionary:
	return conq.get("event_pending", {})

## Édits du Chancelier : décision stratégique récurrente, distincte des
## événements aléatoires. Le même popup sert à l'affichage.
static func chancellor_ready(conq: Dictionary) -> bool:
	return owned_count(conq) >= CHANCELLOR_MIN_CITIES

static func maybe_chancellor(conq: Dictionary) -> void:
	if not pending_event(conq).is_empty():
		return
	conq["chancellor_cd"] = int(conq.get("chancellor_cd", 0)) + 1
	if not chancellor_ready(conq) or int(conq["chancellor_cd"]) < CHANCELLOR_INTERVAL:
		return
	var drills: Array = []
	if int(conq.get("drill", 0)) > 0:
		drills.append("manœuvres : %d bataille(s)" % int(conq["drill"]))
	if int(conq.get("roadworks", 0)) > 0:
		drills.append("routes : %d bataille(s)" % int(conq["roadworks"]))
	var active: String = ""
	if not drills.is_empty():
		active = " Déjà en cours — %s." % ", ".join(PackedStringArray(drills))
	conq["event_pending"] = {"id": "chancelier", "chancellor": true,
		"title": "LE CHANCELIER DEMANDE AUDIENCE",
		"text": "Monseigneur, le Conseil a réuni les tailles de l'empire. Voici les édits qui s'offrent à vous.%s" % active,
		"options": [
			{"id": "impot", "label": "Lever un impôt — encaisse le revenu d'une victoire par ville, chaque garnison perd 1 soldat", "gold": 0},
			{"id": "manoeuvres", "label": "Organiser des manœuvres — +2 défense dans toutes les villes pendant 3 batailles", "gold": 60},
			{"id": "routes", "label": "Entretenir les routes — +2 Bois et +1 Cuir à chaque victoire pendant 4 batailles", "gold": 40}]}
	conq["chancellor_cd"] = 0
	conq["chancellor_seen"] = int(conq.get("chancellor_seen", 0)) + 1

## Effet défensif temporaire des manœuvres du Chancelier.
static func drill_defense(conq: Dictionary) -> int:
	return DRILL_DEF if int(conq.get("drill", 0)) > 0 else 0

## Production temporaire des routes du Chancelier (par victoire).
static func roadworks_yield(conq: Dictionary) -> Dictionary:
	if int(conq.get("roadworks", 0)) <= 0:
		return {}
	return {"Bois": ROADS_BOIS, "Cuir": 1}

## Spécialité économique d'une ville (CITY_TRAITS), mise à l'échelle du niveau.
static func city_trait_yield(conq: Dictionary, id: String) -> Dictionary:
	var spec: Dictionary = CITY_TRAITS.get(id, {})
	if spec.is_empty() or is_ravaged(conq, id) or is_ruined(conq, id):
		return {}
	var mult: float = level_multiplier(conq, id)
	var out: Dictionary = {}
	for r: String in spec.get("res", {}).keys():
		out[r] = maxi(1, roundi(float(spec["res"][r]) * mult))
	return out

static func city_trait_text(id: String) -> String:
	return String(CITY_TRAITS.get(id, {}).get("label", ""))

## Somme des spécialités des villes possédées (par victoire).
static func trait_yield(conq: Dictionary) -> Dictionary:
	var out: Dictionary = {}
	for id: String in conq.get("owned", []):
		for r: String in city_trait_yield(conq, id).keys():
			out[r] = int(out.get(r, 0)) + int(city_trait_yield(conq, id)[r])
	return out

static func _maybe_event(data: Dictionary, conq: Dictionary, rng: RandomNumberGenerator,
		routes: Array, just_conquered: String) -> void:
	if not pending_event(conq).is_empty():
		return
	conq["event_cd"] = int(conq.get("event_cd", 0)) + 1
	if int(conq["event_cd"]) < EVENT_MIN_GAP or rng.randf() > EVENT_CHANCE:
		return
	var ev: Dictionary = roll_event(data, conq, rng, just_conquered)
	if ev.is_empty():
		return
	conq["event_cd"] = 0
	if bool(ev.get("auto", false)):
		_apply_auto(data, conq, ev)
	else:
		conq["event_pending"] = ev

## Table des événements : id -> poids. Chacun vérifie ses propres conditions.
const EVENT_WEIGHTS := {
	"caravane": 3.0, "refugies": 2.0, "mercenaires": 2.0, "rebellion": 2.0,
	"espion": 1.5, "diplomatie": 1.0,
	"recolte": 2.0, "tresor": 1.5, "epidemie": 1.5, "rapport": 2.0,
}

## Tire un événement parmi ceux dont les conditions sont réunies.
static func roll_event(data: Dictionary, conq: Dictionary, rng: RandomNumberGenerator, just_conquered: String = "") -> Dictionary:
	var made: Array = []
	var weights: Array = []
	for eid: String in EVENT_WEIGHTS.keys():
		var ev: Dictionary = make_event(eid, data, conq, rng, just_conquered)
		if not ev.is_empty():
			made.append(ev)
			weights.append(float(EVENT_WEIGHTS[eid]))
	if made.is_empty():
		return {}
	var total: float = 0.0
	for w in weights:
		total += float(w)
	var pick: float = rng.randf() * total
	for i: int in range(made.size()):
		pick -= float(weights[i])
		if pick <= 0.0:
			return made[i]
	return made[made.size() - 1]

static func _room_cities(conq: Dictionary, skip_capital: bool) -> Array:
	var out: Array = []
	for id: String in conq.get("owned", []):
		if skip_capital and id == "capitale":
			continue
		if garrison_cap(conq, id) - troops(conq, id) > 0:
			out.append(id)
	return out

## Construit l'événement `eid`, ou {} si ses conditions ne sont pas remplies.
static func make_event(eid: String, data: Dictionary, conq: Dictionary, rng: RandomNumberGenerator,
		just_conquered: String = "") -> Dictionary:
	var nc: int = owned_count(conq)
	var owned: Array = conq.get("owned", [])
	match eid:
		"caravane":
			var res: String = RES_KEYS[rng.randi_range(0, RES_KEYS.size() - 1)]
			return {"id": eid, "title": "CARAVANE MARCHANDE", "city": "", "res": res,
				"text": "Une caravane marchande demande le passage sur vos terres. Ses mules sont chargées de %s." % res,
				"options": [
					{"id": "commerce", "label": "Commercer — 50 or → +12 %s, +4 Magie" % res, "gold": 50},
					{"id": "taxe", "label": "Taxer le passage → +45 or", "gold": 0},
					{"id": "refus", "label": "Les laisser passer", "gold": 0}]}
		"refugies":
			var rooms: Array = _room_cities(conq, false)
			if rooms.is_empty():
				return {}
			var id: String = String(rooms[rng.randi_range(0, rooms.size() - 1)])
			return {"id": eid, "title": "RÉFUGIÉS", "city": id,
				"text": "Des villageois fuient les terres ennemies et demandent asile à %s." % _name(conq, id),
				"options": [
					{"id": "accueillir", "label": "Les accueillir → +2 soldats à %s" % _name(conq, id), "gold": 0},
					{"id": "former", "label": "Les équiper — 40 or → +4 soldats", "gold": 40},
					{"id": "refus", "label": "Les renvoyer", "gold": 0}]}
		"mercenaires":
			var rooms2: Array = _room_cities(conq, true)
			if rooms2.is_empty():
				return {}
			var weakest: String = String(rooms2[0])
			for c: String in rooms2:
				if defense(data, c) < defense(data, weakest):
					weakest = c
			var n: int = mini(4, garrison_cap(conq, weakest) - troops(conq, weakest))
			return {"id": eid, "title": "MERCENAIRES", "city": weakest, "n": n,
				"text": "Une compagnie de mercenaires offre ses lances. Ils se posteraient à %s." % _name(conq, weakest),
				"options": [
					{"id": "engager", "label": "Engager %d mercenaires — %d or" % [n, 15 * n], "gold": 15 * n},
					{"id": "refus", "label": "Décliner", "gold": 0}]}
		"rebellion":
			var restless: Array = []
			for id2: String in owned:
				if id2 == "capitale" or id2 == just_conquered or is_ravaged(conq, id2):
					continue
				if troops(conq, id2) == 0 and hero_of(conq, id2) == "":
					restless.append(id2)
			if restless.is_empty():
				return {}
			var rid: String = String(restless[rng.randi_range(0, restless.size() - 1)])
			return {"id": eid, "title": "AGITATION À %s" % _name(conq, rid).to_upper(), "city": rid,
				"text": "Sans garnison, %s gronde : la population réclame des vivres et de la sécurité." % _name(conq, rid),
				"options": [
					{"id": "vivres", "label": "Distribuer des vivres — 40 or", "gold": 40},
					{"id": "reprimer", "label": "Réprimer → ville pillée 2 batailles", "gold": 0},
					{"id": "ignorer", "label": "Ignorer → 50 % de révolte (3 batailles)", "gold": 0}]}
		"espion":
			if nc < 2:
				return {}
			var th: Dictionary = threat(conq)
			var inter: String = "Interroger → l'offensive affaiblie de 15 %, retardée d'1 bataille" if not th.is_empty() else "Interroger → +35 or de rançon"
			return {"id": eid, "title": "ESPION CAPTURÉ", "city": "",
				"text": "Vos sentinelles ont capturé un espion ennemi dans vos lignes.",
				"options": [
					{"id": "interroger", "label": inter, "gold": 0},
					{"id": "retourner", "label": "Le retourner — 60 or → 4 batailles sans raid", "gold": 60},
					{"id": "relacher", "label": "Le relâcher", "gold": 0}]}
		"diplomatie":
			if nc < 4:
				return {}
			return {"id": eid, "title": "ÉMISSAIRE ENNEMI", "city": "",
				"text": "Un émissaire propose une trêve en échange d'un tribut.",
				"options": [
					{"id": "tribut", "label": "Payer le tribut — 80 or → 6 batailles de paix", "gold": 80},
					{"id": "refus", "label": "Refuser", "gold": 0}]}
		"recolte":
			if nc < 1:
				return {}
			var rc: String = String(owned[rng.randi_range(0, owned.size() - 1)])
			return {"id": eid, "auto": true, "city": rc, "res": RES_KEYS[rng.randi_range(0, RES_KEYS.size() - 1)]}
		"tresor":
			return {"id": eid, "auto": true, "gold": 40 + nc * 6}
		"epidemie":
			if nc < 3:
				return {}
			var pool: Array = []
			for id3: String in owned:
				if id3 != "capitale" and not is_ravaged(conq, id3):
					pool.append(id3)
			if pool.is_empty():
				return {}
			return {"id": eid, "auto": true, "city": String(pool[rng.randi_range(0, pool.size() - 1)])}
		"rapport":
			var govs: Array = []
			for id4: String in owned:
				if hero_of(conq, id4) != "" and not is_ravaged(conq, id4):
					govs.append(id4)
			if govs.is_empty():
				return {}
			return {"id": eid, "auto": true, "city": String(govs[rng.randi_range(0, govs.size() - 1)])}
	return {}

static func _apply_auto(data: Dictionary, conq: Dictionary, ev: Dictionary) -> void:
	var id: String = String(ev.get("city", ""))
	match String(ev["id"]):
		"recolte":
			_add_res(data, {String(ev["res"]): 10})
			note(conq, "✦ Bonne récolte à %s : +10 %s." % [_name(conq, id), String(ev["res"])])
		"tresor":
			data["gold"] = int(data.get("gold", 0)) + int(ev["gold"])
			note(conq, "★ Vos éclaireurs découvrent une cache : +%d or." % int(ev["gold"]))
		"epidemie":
			var healer: bool = hero_city(conq, "Heal") != "" and not is_ravaged(conq, hero_city(conq, "Heal"))
			if healer or city_level(conq, id) >= 2:
				note(conq, "✦ Une fièvre menaçait %s, mais %s l'enraye." % [_name(conq, id),
					"votre soigneuse" if healer else "l'hospice de la ville"])
			else:
				var r: Dictionary = conq.get("ravage", {})
				r[id] = 2
				conq["ravage"] = r
				note(conq, "⚠ Une fièvre frappe %s : production gelée 2 batailles. (Un Bourg ou un Soigneur gouverneur l'aurait évité.)" % _name(conq, id))
		"rapport":
			var h: String = hero_of(conq, id)
			var gold: int = 20 + hero_level(data, h)
			data["gold"] = int(data.get("gold", 0)) + gold
			note(conq, "♞ %s (%s) rapporte les tributs de %s : +%d or." % [h, "gouverneur", _name(conq, id), gold])

## Tranche l'événement en attente. Retourne le texte du résultat ("" si choix invalide).
static func resolve_event(data: Dictionary, option_id: String, rng: RandomNumberGenerator, names: Dictionary = {}) -> String:
	var conq: Dictionary = data.get("conquest", {})
	var ev: Dictionary = pending_event(conq)
	if ev.is_empty():
		return ""
	var chosen: Dictionary = {}
	for o: Dictionary in ev.get("options", []):
		if String(o.get("id", "")) == option_id:
			chosen = o
	if chosen.is_empty():
		return ""
	var cost: int = int(chosen.get("gold", 0))
	if int(data.get("gold", 0)) < cost:
		return "Or insuffisant : %d pièces requises." % cost
	conq["_names"] = names
	data["gold"] = int(data.get("gold", 0)) - cost
	var id: String = String(ev.get("city", ""))
	var out: String = ""
	match String(ev["id"]) + ":" + option_id:
		"caravane:commerce":
			_add_res(data, {String(ev["res"]): 12, "Magie": 4})
			out = "Marché conclu : +12 %s, +4 Magie." % String(ev["res"])
		"caravane:taxe":
			data["gold"] = int(data.get("gold", 0)) + 45
			out = "Les marchands paient le péage : +45 or."
		"refugies:accueillir":
			_set_garrison(conq, id, troops(conq, id) + 2, hero_of(conq, id))
			out = "Deux réfugiés rejoignent la garnison de %s." % _name(conq, id)
		"refugies:former":
			_set_garrison(conq, id, troops(conq, id) + 4, hero_of(conq, id))
			out = "Quatre recrues équipées renforcent %s." % _name(conq, id)
		"mercenaires:engager":
			_set_garrison(conq, id, troops(conq, id) + int(ev.get("n", 1)), hero_of(conq, id))
			out = "%d mercenaires prennent position à %s." % [int(ev.get("n", 1)), _name(conq, id)]
		"rebellion:vivres":
			out = "Les vivres apaisent %s : le calme revient." % _name(conq, id)
		"rebellion:reprimer":
			var r: Dictionary = conq.get("ravage", {})
			r[id] = 2
			conq["ravage"] = r
			out = "La révolte est écrasée, mais %s est pillée 2 batailles." % _name(conq, id)
		"rebellion:ignorer":
			if rng.randf() < 0.5:
				var r2: Dictionary = conq.get("ravage", {})
				r2[id] = 3
				conq["ravage"] = r2
				out = "%s se révolte et se fait piller 3 batailles !" % _name(conq, id)
			else:
				out = "L'agitation retombe d'elle-même, cette fois."
		"espion:interroger":
			var th: Dictionary = threat(conq)
			if not th.is_empty():
				th["power"] = maxi(1, roundi(float(th["power"]) * 0.85))
				th["eta"] = int(th["eta"]) + 1
				conq["threat"] = th
				out = "L'espion parle : l'offensive est affaiblie (force %d) et retardée d'une bataille." % int(th["power"])
			else:
				data["gold"] = int(data.get("gold", 0)) + 35
				out = "Sa rançon rapporte 35 or."
		"espion:retourner":
			conq["truce"] = maxi(int(conq.get("truce", 0)), 4)
			out = "L'espion travaille pour vous : plus de raids pendant 4 batailles."
		"espion:relacher":
			out = "Vous relâchez l'espion. Il ne reviendra pas."
		"chancelier:impot":
			var owned: Array = conq.get("owned", [])
			var gold: int = 0
			for cid: String in owned:
				gold += city_income(data, cid)
				if troops(conq, cid) > 0:
					_set_garrison(conq, cid, troops(conq, cid) - 1, hero_of(conq, cid))
			data["gold"] = int(data.get("gold", 0)) + gold
			out = "L'impôt est levé : +%d or. Les garnisons, elles, ont payé le prix. Le revenu reprendra son cours normal à la prochaine victoire." % gold
		"chancelier:manoeuvres":
			conq["drill"] = DRILL_BATTLES
			out = "Les manœuvres commencent : +2 défense dans toutes les villes pendant %d batailles." % DRILL_BATTLES
		"chancelier:routes":
			conq["roadworks"] = ROADS_BATTLES
			out = "Les routes sont réparées : +%d Bois et +1 Cuir à chaque victoire pendant %d batailles." % [ROADS_BOIS, ROADS_BATTLES]
		"diplomatie:tribut":
			conq["truce"] = maxi(int(conq.get("truce", 0)), 6)
			out = "Le tribut est versé : paix pendant 6 batailles (pas de raid, pas de nouvelle offensive)."
		_:
			out = "Vous passez votre chemin."
	conq.erase("event_pending")
	conq.erase("_names")
	log_event(conq, "%s — %s" % [String(ev.get("title", "Événement")).capitalize(), out])
	data["conquest"] = conq
	return out
