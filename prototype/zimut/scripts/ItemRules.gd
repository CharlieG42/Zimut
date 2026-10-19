class_name ItemRules
extends RefCounted
## ItemRules.gd — Règles des objets : effets spéciaux (texte de stuff.txt → effets
## réellement appliqués en combat), raretés, panoplies (bonus de set), tooltips.
##
## Une entité de combat reçoit un dictionnaire "fx" avec les clés :
##   crit (%), lifesteal (%), mag_pct (%), mres (%), heal_pct (%), pa, pm,
##   poison_hit_dmg, poison_hit_turns, poison_pct (%), start_immune_neg (tours),
##   start_immune (tours), bless_def (% de défense donnés aux alliés au début)

const STAT_KEYS: Array[String] = ["vita", "force", "intelligence", "agility", "wisdom", "defense"]
const STAT_SHORT := {"vita": "V", "force": "F", "intelligence": "I", "agility": "A", "wisdom": "S", "defense": "D"}
const STAT_NAME := {"vita": "Vitalité", "force": "Force", "intelligence": "Intelligence",
	"agility": "Agilité", "wisdom": "Sagesse", "defense": "Défense"}

const FX_LABEL := {
	"crit": "Critique +%d%%", "phys_pct": "Dégâts physiques +%d%%", "lifesteal": "Vol de vie %d%%", "mag_pct": "Dégâts magiques +%d%%",
	"mres": "Résistance magie +%d%%", "heal_pct": "Soins +%d%%", "pa": "+%d PA", "pm": "+%d PM", "po": "+%d Portée",
	"poison_pct": "Poisons +%d%%", "bless_def": "Bénit l'équipe (+%d%% défense)",
	"start_immune_neg": "Anti-altération %d t. au départ", "start_immune": "Invulnérable %d t. au départ",
}

# ═══════════════════════════════════════════════════════════════════════════
#  Raretés
# ═══════════════════════════════════════════════════════════════════════════

const RARITY := {
	"commun":     {"label": "Commun",     "color": Color(0.82, 0.82, 0.82), "mult": 1.00, "bonus": 0},
	"rare":       {"label": "Rare",       "color": Color(0.38, 0.68, 1.00), "mult": 1.15, "bonus": 0},
	"epique":     {"label": "Épique",     "color": Color(0.78, 0.48, 0.98), "mult": 1.30, "bonus": 1},
	"legendaire": {"label": "Légendaire", "color": Color(1.00, 0.72, 0.18), "mult": 1.50, "bonus": 2},
}
const RARITY_ORDER: Array[String] = ["commun", "rare", "epique", "legendaire"]

## Poids de tirage : combat normal / boss (le boss garantit au moins du rare)
const RARITY_WEIGHTS := {
	"normal": {"commun": 62, "rare": 26, "epique": 10, "legendaire": 2},
	"boss":   {"commun": 0,  "rare": 45, "epique": 40, "legendaire": 15},
}


static func rarity_color(item: Dictionary) -> Color:
	return RARITY.get(String(item.get("rarity", "commun")), RARITY["commun"])["color"]


static func rarity_label(item: Dictionary) -> String:
	return String(RARITY.get(String(item.get("rarity", "commun")), RARITY["commun"])["label"])


static func roll_rarity(rng: RandomNumberGenerator, boss: bool = false) -> String:
	var table: Dictionary = RARITY_WEIGHTS["boss" if boss else "normal"]
	var total: float = 0.0
	for k: String in table.keys():
		total += float(table[k])
	var r: float = rng.randf() * total
	for k: String in RARITY_ORDER:
		r -= float(table[k])
		if r <= 0.0:
			return k
	return "commun"


## Applique une rareté à un objet de base (copie) : stats x mult, + stats bonus.
static func apply_rarity(base: Dictionary, rarity: String, rng: RandomNumberGenerator) -> Dictionary:
	var it: Dictionary = base.duplicate(true)
	var info: Dictionary = RARITY.get(rarity, RARITY["commun"])
	it["rarity"] = rarity
	var mult: float = float(info["mult"])
	for k: String in STAT_KEYS:
		var v: int = int(it.get(k, 0))
		if v > 0 and mult > 1.0:
			it[k] = maxi(v + 1, roundi(float(v) * mult))
	var lvl: int = int(it.get("level", 1))
	for _i in range(int(info["bonus"])):
		var stat: String = STAT_KEYS[rng.randi_range(0, STAT_KEYS.size() - 1)]
		var amount: int = 1 + lvl / 12
		if stat == "vita":
			amount *= 3
		it[stat] = int(it.get(stat, 0)) + amount
	it["set"] = set_key(String(it.get("name", "")))
	return it


## Valeur indicative d'un objet (tri / meilleur équipement).
static func power(item: Dictionary) -> int:
	var p: float = 0.0
	for k: String in STAT_KEYS:
		p += float(item.get(k, 0)) * (0.34 if k == "vita" else 1.0)
	var fx: Dictionary = parse_effect(String(item.get("effect", "")))
	p += float(fx.size()) * 4.0
	return roundi(p)


# ═══════════════════════════════════════════════════════════════════════════
#  Effets spéciaux (texte → effets)
# ═══════════════════════════════════════════════════════════════════════════

static func _num(text: String, pattern: String) -> int:
	var re := RegEx.new()
	re.compile(pattern)
	var m: RegExMatch = re.search(text)
	if m == null:
		return 0
	return int(m.get_string(1))


static func parse_effect(text: String) -> Dictionary:
	var out: Dictionary = {}
	var t: String = text.strip_edges().to_lower()
	if t == "" or t == "-" or t.begins_with("effet sp"):
		return out
	if t.begins_with("critique"):
		out["crit"] = maxi(1, _num(t, "(\\d+)"))
	if t.begins_with("vol de vie"):
		out["lifesteal"] = maxi(1, _num(t, "(\\d+)\\s*%"))
	if t.contains("dégâts magiques") or t.contains("degats magiques"):
		out["mag_pct"] = maxi(1, _num(t, "(\\d+)\\s*%"))
	if t.begins_with("résistance magie") or t.begins_with("resistance magie"):
		out["mres"] = maxi(1, _num(t, "(\\d+)\\s*%"))
	if t.begins_with("venin"):
		out["poison_pct"] = maxi(1, _num(t, "(\\d+)\\s*%"))
	if t.begins_with("poison"):
		out["poison_hit_dmg"] = maxi(1, _num(t, "(\\d+)\\s*dég"))
		out["poison_hit_turns"] = maxi(1, _num(t, "(\\d+)\\s*tour"))
	if _num(t, "^\\+(\\d+)\\s*pm") > 0:
		out["pm"] = _num(t, "^\\+(\\d+)\\s*pm")
	if _num(t, "^\\+(\\d+)\\s*pa") > 0:
		out["pa"] = _num(t, "^\\+(\\d+)\\s*pa")
	if _num(t, "^\\+(\\d+)\\s*(?:portée|portee|po)") > 0:
		out["po"] = _num(t, "^\\+(\\d+)\\s*(?:portée|portee|po)")
	if t.begins_with("bénit") or t.begins_with("benit"):
		out["bless_def"] = maxi(1, _num(t, "\\+(\\d+)\\s*%"))
	if t.begins_with("immunité aux effets") or t.begins_with("immunite aux effets"):
		out["start_immune_neg"] = maxi(1, _num(t, "(\\d+)\\s*tour"))
	elif t.begins_with("immunité aux dégâts") or t.begins_with("immunite aux degats"):
		out["start_immune"] = maxi(1, _num(t, "(\\d+)\\s*tour"))
	return out


static func merge_fx(into: Dictionary, add: Dictionary) -> void:
	for k: String in add.keys():
		if k == "poison_hit_turns":
			into[k] = maxi(int(into.get(k, 0)), int(add[k]))
		else:
			into[k] = int(into.get(k, 0)) + int(add[k])


## Libellé lisible d'un dictionnaire d'effets.
static func fx_lines(fx: Dictionary) -> Array[String]:
	var lines: Array[String] = []
	for k: String in fx.keys():
		if FX_LABEL.has(k):
			lines.append(String(FX_LABEL[k]) % int(fx[k]))
	if fx.has("poison_hit_dmg"):
		lines.append("Poison à l'impact (%d dég./tour, %d t.)" % [int(fx["poison_hit_dmg"]), int(fx.get("poison_hit_turns", 2))])
	return lines


# ═══════════════════════════════════════════════════════════════════════════
#  Panoplies
# ═══════════════════════════════════════════════════════════════════════════

## mot-clé (dans le nom, sans accents/pluriels) -> panoplie
const SETS := {
	"cuir": {"label": "Panoplie du Vagabond", "bonus": {
		2: {"agility": 4, "vita": 10}, 4: {"agility": 8, "vita": 20}}},
	"fer": {"label": "Panoplie de Fer", "bonus": {
		2: {"defense": 4}, 4: {"defense": 8, "vita": 20}}},
	"chasseur": {"label": "Panoplie du Chasseur", "bonus": {
		2: {"force": 4, "agility": 3}, 4: {"force": 8, "fx": {"crit": 5}}}},
	"tank": {"label": "Panoplie du Rempart", "bonus": {
		2: {"defense": 6, "vita": 15}, 3: {"defense": 12, "vita": 30}}},
	"magique": {"label": "Panoplie Arcanique", "bonus": {
		2: {"intelligence": 6, "fx": {"mres": 8}}, 3: {"intelligence": 12, "fx": {"mres": 15, "mag_pct": 5}}}},
	"runique": {"label": "Panoplie Runique", "bonus": {
		2: {"intelligence": 5, "wisdom": 5}, 4: {"wisdom": 8, "fx": {"mres": 10, "mag_pct": 8}},
		6: {"fx": {"pa": 1}}}},
	"lumiere": {"label": "Panoplie de Lumière", "bonus": {
		2: {"wisdom": 5, "vita": 15}, 4: {"wisdom": 8, "fx": {"heal_pct": 10, "bless_def": 8}}}},
	"legendaire": {"label": "Panoplie Légendaire", "bonus": {
		2: {"force": 3, "intelligence": 3, "agility": 3, "wisdom": 3, "defense": 3},
		4: {"force": 4, "intelligence": 4, "fx": {"crit": 5}}, 6: {"fx": {"pm": 1}}}},
	"sacre": {"label": "Panoplie Sacrée", "bonus": {
		2: {"defense": 8, "vita": 20}, 3: {"fx": {"start_immune_neg": 1}}}},
	"ultime": {"label": "Panoplie Ultime", "bonus": {
		2: {"force": 6, "intelligence": 6}, 3: {"fx": {"lifesteal": 4}}}},
	"berserker": {"label": "Panoplie du Berserker", "bonus": {
		2: {"force": 8, "vita": 15}, 3: {"force": 10, "fx": {"lifesteal": 3}}}},
}


static func _norm(s: String) -> String:
	var t: String = s.to_lower()
	for pair in [["é", "e"], ["è", "e"], ["ê", "e"], ["ë", "e"], ["à", "a"], ["â", "a"], ["î", "i"], ["ï", "i"],
			["ô", "o"], ["û", "u"], ["ù", "u"], ["ç", "c"]]:
		t = t.replace(pair[0], pair[1])
	return t


## Clé de panoplie d'un objet d'après son nom ("" si aucune).
static func set_key(item_name: String) -> String:
	var n: String = _norm(item_name)
	for key: String in SETS.keys():
		for word in n.split(" "):
			var w: String = String(word)
			if w == key or w == key + "s" or w == key + "e" or w == key + "es":
				return key
	return ""


## Bonus de panoplies d'un équipement : { "stats": {...}, "fx": {...}, "lines": [...] }
static func set_bonuses(equipment: Dictionary) -> Dictionary:
	var counts: Dictionary = {}
	for slot: String in equipment.keys():
		var it: Dictionary = equipment[slot]
		var key: String = String(it.get("set", ""))
		if key == "":
			key = set_key(String(it.get("name", "")))
		if key != "":
			counts[key] = int(counts.get(key, 0)) + 1
	var stats: Dictionary = {}
	var fx: Dictionary = {}
	var lines: Array[String] = []
	for key: String in counts.keys():
		var n: int = int(counts[key])
		var info: Dictionary = SETS[key]
		var best: int = 0
		for need: int in info["bonus"].keys():
			if n >= need:
				var b: Dictionary = info["bonus"][need]
				for sk: String in b.keys():
					if sk == "fx":
						merge_fx(fx, b[sk])
					else:
						stats[sk] = int(stats.get(sk, 0)) + int(b[sk])
				best = maxi(best, need)
		if best > 0:
			lines.append("%s (%d pièces, palier %d)" % [info["label"], n, best])
		else:
			lines.append("%s (%d pièce)" % [info["label"], n])
	return {"stats": stats, "fx": fx, "lines": lines}


# ═══════════════════════════════════════════════════════════════════════════
#  Agrégation & texte
# ═══════════════════════════════════════════════════════════════════════════

## Somme tout ce que l'équipement apporte : { "stats", "fx", "sets" }
static func aggregate(equipment: Dictionary) -> Dictionary:
	var stats: Dictionary = {}
	for k: String in STAT_KEYS:
		stats[k] = 0
	var fx: Dictionary = {}
	for slot: String in equipment.keys():
		var it: Dictionary = equipment[slot]
		for k: String in STAT_KEYS:
			stats[k] = int(stats[k]) + int(it.get(k, 0))
		merge_fx(fx, parse_effect(String(it.get("effect", ""))))
	var sb: Dictionary = set_bonuses(equipment)
	for k: String in sb["stats"].keys():
		stats[k] = int(stats.get(k, 0)) + int(sb["stats"][k])
	merge_fx(fx, sb["fx"])
	return {"stats": stats, "fx": fx, "sets": sb["lines"]}


## Nom affiché : « Dague en fer R3 » pour un objet de rang 3.
static func display_name(item: Dictionary) -> String:
	var rank: int = int(item.get("rank", 1))
	return "%s%s" % [String(item.get("name", "?")), (" R%d" % rank) if rank > 1 else ""]


static func stat_line(item: Dictionary) -> String:
	var parts: Array[String] = []
	for k: String in STAT_KEYS:
		var v: int = int(item.get(k, 0))
		if v != 0:
			parts.append("%s%+d" % [STAT_SHORT[k], v])
	return " ".join(parts)


static func describe(item: Dictionary) -> String:
	var lines: Array[String] = []
	lines.append("%s %s  (niv. %d)" % [rarity_label(item), display_name(item), int(item.get("level", 0))])
	lines.append(String(item.get("type", "")))
	var st: String = stat_line(item)
	if st != "":
		lines.append(st)
	for l: String in fx_lines(parse_effect(String(item.get("effect", "")))):
		lines.append("✦ " + l)
	var sk: String = String(item.get("set", ""))
	if sk == "":
		sk = set_key(String(item.get("name", "")))
	if sk != "":
		lines.append("◈ " + String(SETS[sk]["label"]))
	return "\n".join(lines)


## Une arme à deux mains bloque l'emplacement du bouclier.
static func is_two_handed(item: Dictionary) -> bool:
	return String(item.get("type", "")).contains("2 mains")
