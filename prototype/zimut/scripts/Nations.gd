class_name Nations
extends RefCounted
## Nations.gd — Les neuf nations de Zimut et leurs biomes.
##
## Chaque nation a un biome (le nom du biome est la clé de ce tableau) avec son identité visuelle :
## palette, sol, décors, monuments, ambiance, ennemis. Les trois biomes historiques (Forêt,
## Montagne, Désert) gardent leur rendu d'origine ; les six autres (Cristaux, Marées, Vents,
## Brasier, Brumes, Ombres) sont rendus par NationScenery. Le Donjon reste un biome à part.
##
## Correspondance : Forêt = Sylvestre, Montagne = Cimes, Désert = Sables.

## Ordre d'affichage (liste des nations) — le Donjon n'en fait pas partie.
const ORDER: Array[String] = ["Forêt", "Montagne", "Désert", "Cristaux", "Marées", "Vents", "Brasier", "Brumes", "Ombres", "Rouages"]

## V43 : tranches de niveaux des monstres PAR NATION (1..100, contiguës, sans chevauchement).
## Source unique pour les cartes d'Aventure (AdventureMobs.LEVEL_RANGE, niveaux des lieux)
## et les donjons de nation. Ordre de progression : Forêt → Brasier → Brumes → Montagne →
## Vents → Ombres → Désert → Marées → Cristaux → Rouages → Donjon final.
const LEVEL_BANDS := {
	"Forêt": [1, 17], "Brasier": [18, 25], "Brumes": [26, 31], "Montagne": [32, 45], "Vents": [46, 54],
	"Ombres": [55, 63], "Désert": [64, 70], "Marées": [71, 78], "Cristaux": [79, 86], "Rouages": [87, 93],
	"Donjon": [94, 100],
}

## Tranche [min, max] d'une nation (Vector2i) ; (1, 100) si inconnue.
static func level_band(biome: String) -> Vector2i:
	if LEVEL_BANDS.has(biome):
		var r: Array = LEVEL_BANDS[biome]
		return Vector2i(int(r[0]), int(r[1]))
	return Vector2i(1, 100)


## Nation dont la tranche contient ce niveau ("" si hors tranche).
static func biome_for_level(level: int) -> String:
	for b: String in LEVEL_BANDS.keys():
		var r: Array = LEVEL_BANDS[b]
		if level >= int(r[0]) and level <= int(r[1]):
			return b
	return ""


const DATA := {
	"Forêt": {
		"nation": "Sylvestre", "hero": "Druide", "folder": "sylvestre", "legacy": true, "accent": Color(0.40, 0.75, 0.35),
		"tile": "forest_ground", "resource": "Bois", "city": "forest",
		"skins": ["araknea", "loup_forestier", "dryade", "treant", "araknea"], "boss_skin": "treant",
		"trait": "Forêts vivantes, ruines couvertes de lierre, rivière et cascade.",
	},
	"Montagne": {
		"nation": "Cimes", "hero": "Tank", "folder": "cimes", "legacy": true, "accent": Color(0.55, 0.72, 0.95),
		"tile": "mountain_ground", "resource": "Fer", "city": "mountain",
		"skins": ["guerrier_des_monts", "griffon_des_cimes", "garde_des_pics", "rochebrute", "griffon_des_cimes"], "boss_skin": "rochebrute",
		"trait": "Neige, pins givrés, portail de glace et cairns.",
	},
	"Désert": {
		"nation": "Sables", "hero": "Géomancien", "folder": "sables", "legacy": true, "accent": Color(0.95, 0.75, 0.35),
		"tile": "desert_ground", "resource": "Venin", "city": "desert",
		"skins": ["bandit_des_dunes", "scarabee_geant", "genie_du_desert", "sphinx", "genie_du_desert"], "boss_skin": "sphinx",
		"trait": "Dunes, cactus, obélisque et puits de grès.",
	},
	"Cristaux": {
		"nation": "Cristaux", "hero": "Mage", "folder": "cristaux", "accent": Color(0.62, 0.55, 1.0),
		"tile": "cristaux_ground", "resource": "Magie", "city": "crystals", "label": "Grottes de Cristal",
		"enemy_types": ["Squelette", "Troll"], "boss": "Golem Prismatique", "boss_base": "Troll",
		"skins": ["araignee_de_cristal", "araignee_de_cristal", "mage_cristallin", "golem_de_cristal", "elementaire_de_cristal"],
		"boss_skin": "golem_de_cristal",
		"pal": {"top_a": Color(0.30, 0.27, 0.52), "top_b": Color(0.25, 0.22, 0.46), "lip": Color(0.55, 0.80, 1.0),
			"l_t": Color(0.36, 0.32, 0.58), "l_b": Color(0.18, 0.15, 0.34), "r_t": Color(0.28, 0.25, 0.48), "r_b": Color(0.12, 0.10, 0.26),
			"leaf": Color(0.45, 0.75, 0.95), "leaf_hi": Color(0.75, 0.62, 1.0), "mist": Color(0.70, 0.65, 0.98)},
		"cell": {"a": Color(0.30, 0.27, 0.52), "b": Color(0.25, 0.22, 0.46), "tuft": Color(0.55, 0.60, 0.95),
			"flowers": [Color(0.55, 0.9, 1.0), Color(0.85, 0.65, 1.0)]},
		"tint": Color(0.40, 0.30, 0.75, 0.30), "ambient": "sparkle", "over": "crystal", "obs_tree": "amethyst_spire", "obs_rock": "crystal_rock",
		"props": [["crystal_cluster", 5], ["amethyst_spire", 3], ["glow_orb", 2], ["stalagmite", 3], ["crystal_rock", 3], ["crystal", 2]],
		"features": ["crystal_throne", "crystal_cluster"],
		"trait": "Sol d'ardoise, éclats lumineux, monolithe de cristal et lueurs flottantes.",
	},
	"Marées": {
		"nation": "Marées", "hero": "Heal", "folder": "marees", "accent": Color(0.35, 0.80, 0.90),
		"tile": "marees_ground", "resource": "Cuir", "city": "tides", "label": "Côtes des Marées",
		"enemy_types": ["Gobelin", "Dragonnet"], "boss": "Crabe Titan", "boss_base": "Troll",
		"skins": ["pirate_des_mers", "requin", "nereide", "crabe_geant", "requin"], "boss_skin": "crabe_geant",
		"pal": {"top_a": Color(0.90, 0.85, 0.66), "top_b": Color(0.84, 0.79, 0.60), "lip": Color(0.45, 0.80, 0.85),
			"l_t": Color(0.82, 0.72, 0.52), "l_b": Color(0.55, 0.45, 0.32), "r_t": Color(0.68, 0.58, 0.42), "r_b": Color(0.42, 0.34, 0.24),
			"leaf": Color(0.30, 0.65, 0.62), "leaf_hi": Color(0.55, 0.88, 0.82), "mist": Color(0.80, 0.95, 0.98)},
		"cell": {"a": Color(0.90, 0.85, 0.66), "b": Color(0.84, 0.79, 0.60), "tuft": Color(0.45, 0.72, 0.70),
			"flowers": [Color(1, 0.8, 0.75), Color(0.95, 0.95, 0.85)]},
		"tint": Color(0.30, 0.75, 0.85, 0.20), "ambient": "bubble", "over": "foam", "obs_tree": "palm", "obs_rock": "tide_rock",
		"props": [["coral", 4], ["shell_big", 3], ["driftwood", 3], ["barrel", 2], ["anchor", 2], ["net_posts", 2], ["tide_rock", 3], ["palm", 3], ["reeds", 2]],
		"features": ["lighthouse", "anchor"],
		"trait": "Sable mouillé, flaques turquoise, coraux, phare et ancre rouillée.",
	},
	"Vents": {
		"nation": "Vents", "hero": "Sylvain", "folder": "vents", "accent": Color(0.70, 0.90, 0.95),
		"tile": "vents_ground", "resource": "Bois", "city": "winds", "label": "Îles des Vents",
		"enemy_types": ["Loup", "Squelette"], "boss": "Seigneur des Tempêtes", "boss_base": "Dragonnet",
		"skins": ["garde_aerien", "aigle_celeste", "harpie", "elementaire_de_vent", "harpie"], "boss_skin": "elementaire_de_vent",
		"pal": {"top_a": Color(0.74, 0.85, 0.80), "top_b": Color(0.68, 0.80, 0.76), "lip": Color(0.95, 0.98, 1.0),
			"l_t": Color(0.70, 0.78, 0.80), "l_b": Color(0.46, 0.54, 0.62), "r_t": Color(0.56, 0.64, 0.70), "r_b": Color(0.34, 0.42, 0.52),
			"leaf": Color(0.50, 0.72, 0.62), "leaf_hi": Color(0.80, 0.94, 0.86), "mist": Color(0.92, 0.97, 1.0)},
		"cell": {"a": Color(0.74, 0.85, 0.80), "b": Color(0.68, 0.80, 0.76), "tuft": Color(0.50, 0.72, 0.62),
			"flowers": [Color(1, 1, 1), Color(0.8, 0.92, 1.0)]},
		"tint": Color(0.70, 0.88, 1.0, 0.22), "ambient": "wind", "over": "wisp", "obs_tree": "wind_totem", "obs_rock": "cloud_rock",
		"props": [["wind_totem", 4], ["cloud_puff", 4], ["feather_banner", 3], ["stone_ring", 3], ["cyclone", 2], ["windmill", 2], ["cloud_rock", 3]],
		"features": ["wind_arch", "wind_totem"],
		"trait": "Îles flottantes, rubans de vent, moulins, totems à plumes et arche céleste.",
	},
	"Brasier": {
		"nation": "Brasier", "hero": "Chasseur", "folder": "brasier", "accent": Color(1.0, 0.55, 0.20),
		"tile": "brasier_ground", "resource": "Fer", "city": "flames", "label": "Terres du Brasier",
		"enemy_types": ["Troll", "Dragonnet"], "boss": "Seigneur de Lave", "boss_base": "Troll",
		"skins": ["lieutenant", "salamandre", "devoreur_de_flammes", "golem_de_lave", "devoreur_de_flammes"], "boss_skin": "golem_de_lave",
		"pal": {"top_a": Color(0.28, 0.20, 0.19), "top_b": Color(0.23, 0.16, 0.16), "lip": Color(0.95, 0.45, 0.15),
			"l_t": Color(0.38, 0.26, 0.24), "l_b": Color(0.18, 0.12, 0.12), "r_t": Color(0.28, 0.19, 0.18), "r_b": Color(0.12, 0.08, 0.08),
			"leaf": Color(0.80, 0.30, 0.10), "leaf_hi": Color(1.0, 0.65, 0.20), "mist": Color(0.95, 0.55, 0.35)},
		"cell": {"a": Color(0.29, 0.21, 0.20), "b": Color(0.24, 0.17, 0.17), "tuft": Color(0.80, 0.35, 0.12),
			"flowers": [Color(1.0, 0.6, 0.2), Color(1.0, 0.85, 0.35)]},
		"tint": Color(0.85, 0.30, 0.10, 0.30), "ambient": "ember", "over": "ember", "obs_tree": "charred_tree", "obs_rock": "lava_rock",
		"props": [["obsidian_spike", 4], ["lava_rock", 4], ["brazier", 3], ["smoke_vent", 3], ["charred_tree", 3], ["bones", 2], ["rubble", 2]],
		"features": ["volcano_cone", "lava_rock"],
		"trait": "Basalte noir, fissures de lave, braseros, fumerolles et cône volcanique.",
	},
	"Brumes": {
		"nation": "Brumes", "hero": "Invocateur", "folder": "brumes", "accent": Color(0.65, 0.90, 0.80),
		"tile": "brumes_ground", "resource": "Venin", "city": "mists", "label": "Marais des Brumes",
		"enemy_types": ["Loup", "Squelette"], "boss": "Liche des Brumes", "boss_base": "Squelette",
		"skins": ["brumeux", "gargouille", "liche_des_brumes", "fantome", "gargouille"], "boss_skin": "liche_des_brumes",
		"pal": {"top_a": Color(0.43, 0.58, 0.53), "top_b": Color(0.38, 0.52, 0.48), "lip": Color(0.62, 0.82, 0.72),
			"l_t": Color(0.40, 0.50, 0.46), "l_b": Color(0.24, 0.32, 0.30), "r_t": Color(0.32, 0.42, 0.40), "r_b": Color(0.18, 0.25, 0.24),
			"leaf": Color(0.38, 0.62, 0.55), "leaf_hi": Color(0.70, 0.92, 0.80), "mist": Color(0.85, 0.95, 0.92)},
		"cell": {"a": Color(0.43, 0.58, 0.53), "b": Color(0.38, 0.52, 0.48), "tuft": Color(0.55, 0.78, 0.60),
			"flowers": [Color(0.85, 0.95, 1.0), Color(0.95, 0.85, 1.0)]},
		"tint": Color(0.45, 0.70, 0.62, 0.30), "ambient": "fog", "over": "moss", "obs_tree": "dead_tree", "obs_rock": "mushroom_big",
		"props": [["mushroom_big", 4], ["dead_tree", 4], ["wisp_lantern", 3], ["reeds", 3], ["fog_puff", 3], ["stump", 2], ["rock", 2]],
		"features": ["spirit_tree", "wisp_lantern"],
		"trait": "Marais embrumé, champignons phosphorescents, arbres morts et feux follets.",
	},
	"Ombres": {
		"nation": "Ombres", "hero": "Assassin", "folder": "ombres", "accent": Color(0.70, 0.50, 0.95),
		"tile": "ombres_ground", "resource": "Magie", "city": "shadows", "label": "Landes des Ombres",
		"enemy_types": ["Squelette", "Loup"], "boss": "Liche Éternelle", "boss_base": "Squelette",
		"skins": ["assassin_des_ombres", "ombre_infernale", "spectre", "liche", "ombre_infernale"], "boss_skin": "liche",
		"pal": {"top_a": Color(0.31, 0.25, 0.43), "top_b": Color(0.26, 0.20, 0.37), "lip": Color(0.60, 0.40, 0.85),
			"l_t": Color(0.34, 0.28, 0.46), "l_b": Color(0.16, 0.12, 0.26), "r_t": Color(0.26, 0.20, 0.38), "r_b": Color(0.11, 0.08, 0.20),
			"leaf": Color(0.45, 0.28, 0.62), "leaf_hi": Color(0.70, 0.50, 0.90), "mist": Color(0.55, 0.45, 0.75)},
		"cell": {"a": Color(0.31, 0.25, 0.43), "b": Color(0.26, 0.20, 0.37), "tuft": Color(0.50, 0.35, 0.70),
			"flowers": [Color(0.75, 0.55, 1.0), Color(0.55, 0.45, 0.85)]},
		"tint": Color(0.30, 0.15, 0.50, 0.40), "ambient": "motes", "over": "thorn", "obs_tree": "dark_spire", "obs_rock": "gravestone",
		"props": [["gravestone", 4], ["dark_spire", 3], ["purple_torch", 3], ["thorn_bush", 4], ["raven_perch", 2], ["cracked_obelisk", 2], ["bones", 2]],
		"features": ["dark_gate", "gravestone"],
		"trait": "Pavés runiques, ronces violettes, torches mauves, corbeaux et porte sombre.",
	},
	"Rouages": {
		"nation": "Rouages", "hero": "Artificier", "folder": "rouages", "accent": Color(0.95, 0.62, 0.22),
		"tile": "rouages_ground", "resource": "Fer", "city": "gears", "label": "Ateliers des Rouages",
		"enemy_types": ["Gobelin", "Troll"], "boss": "Colosse d'Engrenages", "boss_base": "Troll",
		"skins": ["drone_aerien", "araignee_mecanique", "roue_engrenee", "automate_de_combat", "drone_aerien"], "boss_skin": "automate_de_combat",
		"pal": {"top_a": Color(0.41, 0.37, 0.34), "top_b": Color(0.35, 0.32, 0.30), "lip": Color(0.92, 0.60, 0.24),
			"l_t": Color(0.47, 0.41, 0.35), "l_b": Color(0.22, 0.19, 0.17), "r_t": Color(0.36, 0.31, 0.28), "r_b": Color(0.16, 0.14, 0.13),
			"leaf": Color(0.75, 0.48, 0.20), "leaf_hi": Color(0.96, 0.76, 0.36), "mist": Color(0.88, 0.78, 0.66)},
		"cell": {"a": Color(0.41, 0.37, 0.34), "b": Color(0.35, 0.32, 0.30), "tuft": Color(0.72, 0.50, 0.24),
			"flowers": [Color(0.95, 0.70, 0.30), Color(0.80, 0.82, 0.86)]},
		"tint": Color(0.85, 0.55, 0.20, 0.22), "ambient": "ember", "over": "ember", "obs_tree": "gear_tower", "obs_rock": "scrap_pile",
		"props": [["cog_wheel", 4], ["steam_pipe", 3], ["gear_tower", 3], ["anvil", 2], ["tesla_coil", 2], ["scrap_pile", 3], ["smoke_vent", 2], ["rubble", 2]],
		"features": ["workshop_crane", "tesla_coil"],
		"trait": "Dalles d'acier, engrenages géants, tuyaux fumants, enclumes et bobines à arcs.",
	},
}


static func has(biome: String) -> bool:
	return DATA.has(biome)


## Biome rendu par NationScenery (les trois historiques gardent leur code d'origine).
## V20 : boss illustrés de chaque nation (planche « Boss des Nations ») : titre affiché et sprite
## assets/sprites/nations/boss/<dossier>.png. Le kit de combat reste celui du boss d'origine.
const BOSS_TITLE := {
	"Forêt": "Tharok le Végétal", "Montagne": "Vorkann le Givre", "Désert": "Zahor le Sableux",
	"Cristaux": "Zyphéron le Cristallin", "Marées": "Néréa la Tempête", "Vents": "Aéron le Céleste",
	"Brasier": "Kharaz le Flamboyant", "Brumes": "Ombrelis le Brumeux", "Ombres": "Nébulia l'Illusionniste", "Rouages": "Mécanoptère",
}


static func boss_title(biome: String) -> String:
	return String(BOSS_TITLE.get(biome, ""))


static func boss_texture(biome: String) -> Texture2D:
	if not DATA.has(biome):
		return null
	var path: String = "res://assets/sprites/nations/boss/%s.png" % String(DATA[biome]["folder"])
	if not _tex_cache.has(path):
		_tex_cache[path] = load(path) as Texture2D if ResourceLoader.exists(path) else null
	return _tex_cache[path]


static func is_new(biome: String) -> bool:
	return DATA.has(biome) and not bool(DATA[biome].get("legacy", false))


static func info(biome: String) -> Dictionary:
	return DATA.get(biome, {})


static func nation_name(biome: String) -> String:
	return String(DATA.get(biome, {}).get("nation", biome))


static func accent(biome: String) -> Color:
	return DATA.get(biome, {}).get("accent", Color(0.8, 0.8, 0.8))


static func pal(biome: String) -> Dictionary:
	return DATA.get(biome, {}).get("pal", {})


static func cell_palette(biome: String) -> Dictionary:
	return DATA.get(biome, {}).get("cell", {})


static func tile_prefix(biome: String) -> String:
	return String(DATA.get(biome, {}).get("tile", ""))


static func tint(biome: String) -> Color:
	return DATA.get(biome, {}).get("tint", Color(0.40, 0.62, 0.66, 0.18))


static func ambient(biome: String) -> String:
	return String(DATA.get(biome, {}).get("ambient", ""))


static func over(biome: String) -> String:
	return String(DATA.get(biome, {}).get("over", ""))


## Types d'ennemis et boss des biomes « nouveaux » (les anciens biomes ont leurs tables dans ProgressionManager).
static func enemy_types(biome: String) -> Array[String]:
	var out: Array[String] = []
	for t: String in DATA.get(biome, {}).get("enemy_types", []):
		out.append(t)
	return out


static func resource_of(biome: String) -> String:
	return String(DATA.get(biome, {}).get("resource", "Fer"))


## Biome dont le boss porte ce nom, ou "".
static func biome_of_boss(boss_name: String) -> String:
	for b: String in DATA.keys():
		if String(DATA[b].get("boss", "")) == boss_name:
			return b
	return ""


## Type de base (kit de combat) d'un boss de nation.
static func boss_base(boss_name: String) -> String:
	var b: String = biome_of_boss(boss_name)
	return String(DATA.get(b, {}).get("boss_base", ""))


const _TYPE_SLOT := {"Gobelin": 0, "Loup": 1, "Squelette": 2, "Troll": 3, "Dragonnet": 4}


## Texture du sprite de nation pour un ennemi ({} d'entité) selon le biome du combat, ou null
## (Donjon et entités sans correspondance gardent leurs anciens skins).
static func enemy_texture(ent: Dictionary, biome: String) -> Texture2D:
	if String(ent.get("team", "")) != "enemy" or not DATA.has(biome):
		return null
	var d: Dictionary = DATA[biome]
	var file: String = ""
	if bool(ent.get("boss", false)):
		# V20 : boss de nation illustré (posé par GameManager sur le boss du biome)
		var nb: String = String(ent.get("nation_boss", ""))
		if nb != "":
			var bt: Texture2D = boss_texture(nb)
			if bt != null:
				return bt
		# sinon : boss des nations « nouvelles » ; Gobelin Roi, Troll Géant, Dragon, Loup Alpha
		# et les rois squelettes gardent leurs skins de boss d'origine.
		var bb: String = biome_of_boss(String(ent.get("classe", "")))
		if bb != "":
			file = String(DATA[bb].get("boss_skin", ""))
	else:
		var slot: int = int(_TYPE_SLOT.get(String(ent.get("classe", "")), -1))
		var skins: Array = d.get("skins", [])
		if slot >= 0 and slot < skins.size():
			file = String(skins[slot])
	if file == "":
		return null
	return load_enemy(String(d["folder"]), file)


static var _tex_cache: Dictionary = {}

static func load_enemy(folder: String, file: String) -> Texture2D:
	var path: String = "res://assets/sprites/nations/ennemis/%s/%s.png" % [folder, file]
	if not _tex_cache.has(path):
		_tex_cache[path] = load(path) as Texture2D if ResourceLoader.exists(path) else null
	return _tex_cache[path]


const LABEL := {
	"araknea": "Araknéa", "loup_forestier": "Loup forestier", "dryade": "Dryade", "treant": "Tréant",
	"guerrier_des_monts": "Guerrier des monts", "griffon_des_cimes": "Griffon des cimes", "garde_des_pics": "Garde des pics", "rochebrute": "Rochebrute",
	"bandit_des_dunes": "Bandit des dunes", "scarabee_geant": "Scarabée géant", "genie_du_desert": "Génie du désert", "sphinx": "Sphinx",
	"araignee_de_cristal": "Araignée de cristal", "mage_cristallin": "Mage cristallin", "golem_de_cristal": "Golem de cristal", "elementaire_de_cristal": "Élémentaire de cristal",
	"pirate_des_mers": "Pirate des mers", "requin": "Requin", "nereide": "Néréide", "crabe_geant": "Crabe géant",
	"garde_aerien": "Garde aérien", "aigle_celeste": "Aigle céleste", "harpie": "Harpie", "elementaire_de_vent": "Élémentaire de vent",
	"lieutenant": "Lieutenant", "salamandre": "Salamandre", "devoreur_de_flammes": "Dévoreur de flammes", "golem_de_lave": "Golem de lave",
	"brumeux": "Brumeux", "gargouille": "Gargouille", "liche_des_brumes": "Liche des brumes", "fantome": "Fantôme",
	"assassin_des_ombres": "Assassin des ombres", "ombre_infernale": "Ombre infernale", "spectre": "Spectre", "liche": "Liche",
	"drone_aerien": "Drone aérien", "araignee_mecanique": "Araignée mécanique", "roue_engrenee": "Roue engrenée", "automate_de_combat": "Automate de combat",
}


## Nom d'affichage d'un ennemi de ce type dans ce biome (« Araknéa » pour un Gobelin de forêt), ou "".
static func enemy_label(etype: String, biome: String) -> String:
	if not DATA.has(biome) or not _TYPE_SLOT.has(etype):
		return ""
	var skins: Array = DATA[biome].get("skins", [])
	var slot: int = int(_TYPE_SLOT[etype])
	if slot >= skins.size():
		return ""
	return String(LABEL.get(String(skins[slot]), ""))
