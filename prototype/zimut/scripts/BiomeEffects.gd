class_name BiomeEffects
extends RefCounted
## BiomeEffects.gd — Particularité de combat de chaque nation (symétrique : elle touche alliés et
## ennemis, c'est le terrain qui change la tactique, pas la difficulté).
##   Cristaux : Résonance — +15 % de dégâts magiques.
##   Marées   : Marée — rounds impairs « marée haute » (−1 PM), rounds pairs « marée basse » (+1 PM).
##   Vents    : Vents porteurs — +1 PM.
##   Brasier  : Chaleur — chaque fin de tour brûle 2 % des PV max (jamais mortel).
##   Brumes   : Brume épaisse — 12 % d'esquive physique.
##   Ombres   : Ténèbres — +12 % de chance de coup critique.

const INFO := {
	"Cristaux": {"name": "Résonance", "text": "les cristaux amplifient la magie : +15 % de dégâts magiques pour tous."},
	"Marées": {"name": "Marée", "text": "rounds impairs : marée haute (−1 PM) ; rounds pairs : marée basse (+1 PM)."},
	"Vents": {"name": "Vents porteurs", "text": "le vent pousse chacun : +1 PM pour tous."},
	"Brasier": {"name": "Chaleur", "text": "le sol brûle : −2 % des PV max à chaque fin de tour (jamais mortel)."},
	"Brumes": {"name": "Brume épaisse", "text": "la brume brouille les coups : 12 % d'esquive physique pour tous."},
	"Rouages": {"name": "Surtension", "text": "les machines vrombissent : +12 % de dégâts physiques pour tous."},
	"Ombres": {"name": "Ténèbres", "text": "l'ombre guide les coups : +12 % de coups critiques pour tous."},
}


static func has(biome: String) -> bool:
	return INFO.has(biome)


## « Résonance — … » ou "" pour les biomes sans particularité.
static func describe(biome: String) -> String:
	if not INFO.has(biome):
		return ""
	return "%s : %s" % [String(INFO[biome]["name"]), String(INFO[biome]["text"])]


static func title(biome: String) -> String:
	return String(INFO.get(biome, {}).get("name", ""))


## Appliqué une fois au début du combat à toutes les entités présentes.
static func setup(biome: String, entities: Array) -> void:
	for e: Dictionary in entities:
		var fx: Dictionary = e.get("fx", {})
		match biome:
			"Cristaux":
				fx["mag_pct"] = int(fx.get("mag_pct", 0)) + 15
			"Ombres":
				fx["crit"] = int(fx.get("crit", 0)) + 12
			"Rouages":
				fx["phys_pct"] = int(fx.get("phys_pct", 0)) + 12
		e["fx"] = fx
		if biome == "Brumes":
			Combat.add_status(e, "dodge", 999, 12.0)


## Bonus / malus de PM au début du tour (round `turn_count`, à partir de 1).
static func pm_bonus(biome: String, round_no: int) -> int:
	match biome:
		"Vents":
			return 1
		"Marées":
			return -1 if round_no % 2 == 1 else 1
	return 0


## Annonce de l'état de la marée quand le round change.
static func round_banner(biome: String, round_no: int) -> String:
	if biome == "Marées":
		return "Marée haute : −1 PM" if round_no % 2 == 1 else "Marée basse : +1 PM"
	return ""


## Dégâts de fin de tour (0 si aucun) — jamais mortels.
static func end_turn_damage(biome: String, e: Dictionary) -> int:
	if biome == "Brasier":
		var d: int = maxi(3, int(float(e.get("max_pv", 0)) * 0.02))
		return mini(d, maxi(0, int(e.get("current_pv", 1)) - 1))
	return 0
