class_name StatEffects
extends RefCounted
## StatEffects.gd — règles de calcul des caractéristiques (V364).
##
## UNE seule source pour les constantes de combat : Combat.calc_damage, GameManager (soins, esquive,
## altérations) et l'onglet CARACTÉRISTIQUES de la fiche Personnage s'en servent, donc ce qui est
## affiché est exactement ce que le combat calcule.

## ── Constantes ──────────────────────────────────────────────────────────────
const DMG_DIV := 200.0          # dégâts : × (1 + Force ou Intelligence / 200)
const HEAL_INT_DIV := 300.0     # soins : × (1 + Intelligence / 300)
const HEAL_WIS_DIV := 300.0     # soins : × (1 + Sagesse / 300)
const CRIT_BASE := 0.05
const CRIT_AGI_DIV := 400.0     # critique : 5 % + Agilité / 400 (en proportion)
const CRIT_MAX := 0.60
const CRIT_MULT := 1.5
const BACK_MULT := 1.25         # attaque dans le dos
const RES_DIV := 100.0          # résistance : D / (D + 100)
const MAG_DEF_FACTOR := 0.5     # la Défense ne compte qu'à moitié contre la magie
const RES_MAX := 0.85
const DODGE_PER_WIS := 0.25     # chaque point de Sagesse retire 0,25 point d'esquive à la cible
const ALTER_BASE := 0.90        # chance d'imposer une altération de contrôle à Sagesse égale
const ALTER_WIS_DIV := 250.0
const ALTER_MIN := 0.50
const ALTER_MAX := 1.00
const INIT_RANDOM := 25.0       # initiative : Agilité ± 25
const DMG_VARIANCE := 0.07      # dégâts : ± 7 %
const PV_PER_VITA := 3


## ── Formules (utilisées par le combat) ───────────────────────────────────────

static func damage_stat_mult(stat_value: float) -> float:
	return 1.0 + stat_value / DMG_DIV


static func crit_chance(agility: float, fx_crit: float, talent_crit: float) -> float:
	return clampf(CRIT_BASE + agility / CRIT_AGI_DIV + fx_crit / 100.0 + talent_crit / 100.0, CRIT_BASE, CRIT_MAX)


## Résistance physique d'une cible (proportion 0..RES_MAX) ; `bonus` = buffs en %.
static func phys_resistance(defense: float, bonus_pct: float = 0.0) -> float:
	return clampf(defense / (defense + RES_DIV) + bonus_pct / 100.0, 0.0, RES_MAX)


static func mag_resistance(defense: float, mres_pct: float = 0.0, bonus_pct: float = 0.0) -> float:
	var d: float = defense * MAG_DEF_FACTOR
	return clampf(d / (d + RES_DIV) + bonus_pct / 100.0 + mres_pct / 100.0, 0.0, RES_MAX)


static func heal_mult(intelligence: float, wisdom: float, fx_heal_pct: float, talent_heal: float) -> float:
	return (1.0 + intelligence / HEAL_INT_DIV) * (1.0 + wisdom / HEAL_WIS_DIV) * (1.0 + fx_heal_pct / 100.0) * talent_heal


static func dodge_chance(target_dodge_pct: float, attacker_wisdom: float) -> float:
	return target_dodge_pct - attacker_wisdom * DODGE_PER_WIS


static func alteration_land(src_wisdom: float, tgt_wisdom: float) -> float:
	return clampf(ALTER_BASE + (src_wisdom - tgt_wisdom) / ALTER_WIS_DIV, ALTER_MIN, ALTER_MAX)


## ── Affichage : ce que valent les caractéristiques d'un héros ────────────────

static func _fmt(x: float, decimals: int = 0) -> String:
	return ("%." + str(decimals) + "f") % x


static func _pct(x: float) -> String:
	return "%d %%" % roundi(x)


## Valeurs chiffrées d'un héros à partir de ItemRules/ProgressionManager.member_stats (`st`).
static func values(st: Dictionary) -> Dictionary:
	var fx: Dictionary = st.get("fx", {})
	var force: float = float(st.get("force", 0))
	var intel: float = float(st.get("intelligence", 0))
	var agi: float = float(st.get("agility", 0))
	var wis: float = float(st.get("wisdom", 0))
	var def: float = float(st.get("defense", 0))
	var tdmg: float = float(st.get("talent_dmg_pct", 1.0))
	var theal: float = float(st.get("talent_heal_pct", 1.0))
	var tcrit: float = float(st.get("talent_crit_pct", 0.0))
	return {
		"phys": damage_stat_mult(force) * (1.0 + float(fx.get("phys_pct", 0)) / 100.0) * tdmg,
		"mag": damage_stat_mult(intel) * (1.0 + float(fx.get("mag_pct", 0)) / 100.0) * tdmg,
		"crit": crit_chance(agi, float(fx.get("crit", 0)), tcrit),
		"phys_res": phys_resistance(def),
		"mag_res": mag_resistance(def, float(fx.get("mres", 0))),
		"heal": heal_mult(intel, wis, float(fx.get("heal_pct", 0)), theal),
		"init": agi,
		"anti_dodge": wis * DODGE_PER_WIS,
		"alter": alteration_land(wis, wis),
		"pv": int(st.get("max_pv", 0)),
		"lifesteal": float(fx.get("lifesteal", 0)),
		"poison": float(fx.get("poison_pct", 0)),
	}


## Cartes de résultats : [{id, title, value, detail}] dans l'ordre d'affichage.
static func results(st: Dictionary) -> Array[Dictionary]:
	var v: Dictionary = values(st)
	var fx: Dictionary = st.get("fx", {})
	var out: Array[Dictionary] = []
	var tdmg: float = (float(st.get("talent_dmg_pct", 1.0)) - 1.0) * 100.0
	out.append({"id": "pv", "title": "Points de vie", "value": str(int(v["pv"])),
		"detail": "base de classe + %d par point de Vitalité + objets" % PV_PER_VITA})
	out.append({"id": "phys", "title": "Dégâts physiques", "value": "+" + _pct((float(v["phys"]) - 1.0) * 100.0),
		"detail": "Force %d (+%s) · objets +%d %% · talents +%s" % [int(st.get("force", 0)), _pct(float(st.get("force", 0)) / DMG_DIV * 100.0), int(fx.get("phys_pct", 0)), _pct(tdmg)]})
	out.append({"id": "mag", "title": "Dégâts magiques", "value": "+" + _pct((float(v["mag"]) - 1.0) * 100.0),
		"detail": "Intelligence %d (+%s) · objets +%d %% · talents +%s" % [int(st.get("intelligence", 0)), _pct(float(st.get("intelligence", 0)) / DMG_DIV * 100.0), int(fx.get("mag_pct", 0)), _pct(tdmg)]})
	out.append({"id": "crit", "title": "Coup critique", "value": _pct(float(v["crit"]) * 100.0),
		"detail": "5 %% + Agilité %d/%d + objets %d %% · dégâts ×%s" % [int(st.get("agility", 0)), int(CRIT_AGI_DIV), int(fx.get("crit", 0)), _fmt(CRIT_MULT, 1).replace(".", ",")]})
	out.append({"id": "phys_res", "title": "Résistance physique", "value": _pct(float(v["phys_res"]) * 100.0),
		"detail": "Défense %d : réduit les dégâts physiques reçus (max %d %%)" % [int(st.get("defense", 0)), roundi(RES_MAX * 100.0)]})
	out.append({"id": "mag_res", "title": "Résistance magique", "value": _pct(float(v["mag_res"]) * 100.0),
		"detail": "moitié de la Défense + objets %d %% (max %d %%)" % [int(fx.get("mres", 0)), roundi(RES_MAX * 100.0)]})
	out.append({"id": "heal", "title": "Soins prodigués", "value": "+" + _pct((float(v["heal"]) - 1.0) * 100.0),
		"detail": "Intelligence %d · Sagesse %d · objets +%d %%" % [int(st.get("intelligence", 0)), int(st.get("wisdom", 0)), int(fx.get("heal_pct", 0))]})
	out.append({"id": "init", "title": "Initiative", "value": str(int(v["init"])),
		"detail": "Agilité (± %d au tirage) : qui joue en premier" % int(INIT_RANDOM)})
	out.append({"id": "anti_dodge", "title": "Précision", "value": "−" + _fmt(float(v["anti_dodge"]), 1).replace(".", ",") + " pts",
		"detail": "d'esquive retirés à la cible (Sagesse %d × %s)" % [int(st.get("wisdom", 0)), _fmt(DODGE_PER_WIS, 2).replace(".", ",")]})
	out.append({"id": "alter", "title": "Altérations", "value": _pct(float(v["alter"]) * 100.0),
		"detail": "chance d'étourdir, ralentir… un ennemi de Sagesse égale (± %s %% par point d'écart)" % _fmt(100.0 / ALTER_WIS_DIV, 1).replace(".", ",")})
	if float(v["lifesteal"]) > 0.0:
		out.append({"id": "lifesteal", "title": "Vol de vie", "value": _pct(float(v["lifesteal"])),
			"detail": "des dégâts infligés rendus en PV (objets)"})
	if float(v["poison"]) > 0.0:
		out.append({"id": "poison", "title": "Poisons", "value": "+" + _pct(float(v["poison"])),
			"detail": "dégâts de poison infligés (objets)"})
	return out


## Règles de calcul, en BBCode, pour l'affichage en fin d'onglet.
static func rules_bbcode() -> String:
	var lines: PackedStringArray = [
		"[b]Dégâts d'un sort[/b] = dégâts de base du sort × (1 + stat / %d) × bonus × (1 − résistance de la cible), puis ± %d %% au hasard." % [int(DMG_DIV), roundi(DMG_VARIANCE * 100.0)],
		"[b]Force[/b] : stat des dégâts physiques. [b]Intelligence[/b] : stat des dégâts magiques. Exemple : 100 points = +50 %.",
		"[b]Bonus[/b] qui se multiplient : objets (dégâts physiques / magiques +%%), talents, affaiblissements ou renforts en combat, attaque dans le dos × %s." % _fmt(BACK_MULT, 2).replace(".", ","),
		"[b]Coup critique[/b] : chance = 5 %% + Agilité / %d (en %%) + objets + talents, entre 5 %% et %d %% ; un critique inflige × %s." % [int(CRIT_AGI_DIV), roundi(CRIT_MAX * 100.0), _fmt(CRIT_MULT, 1).replace(".", ",")],
		"[b]Résistance physique[/b] = Défense / (Défense + %d). [b]Résistance magique[/b] = (Défense / 2) / (Défense / 2 + %d) + résistance magie des objets. Plafond %d %%." % [int(RES_DIV), int(RES_DIV), roundi(RES_MAX * 100.0)],
		"[b]Soins[/b] = soin du sort × (1 + Intelligence / %d) × (1 + Sagesse / %d) × (1 + soins des objets) × talents." % [int(HEAL_INT_DIV), int(HEAL_WIS_DIV)],
		"[b]Initiative[/b] : Agilité ± %d au début du combat ; le plus haut joue en premier." % int(INIT_RANDOM),
		"[b]Précision[/b] : chaque point de Sagesse retire %s point d'esquive à une cible qui esquive (attaques physiques)." % _fmt(DODGE_PER_WIS, 2).replace(".", ","),
		"[b]Altérations de contrôle[/b] (étourdissement, immobilisation, ralentissement, malédiction, affaiblissement) : chance de réussite = %d %% + (Sagesse du lanceur − Sagesse de la cible) / %d, entre %d %% et %d %%." % [roundi(ALTER_BASE * 100.0), int(ALTER_WIS_DIV), roundi(ALTER_MIN * 100.0), roundi(ALTER_MAX * 100.0)],
		"[b]Vitalité[/b] : +%d PV par point. [b]Vol de vie[/b] : un pourcentage des dégâts infligés revient en PV. [b]Poisons +%%[/b] : multiplie les dégâts de poison." % PV_PER_VITA,
		"[b]PA, PM, Portée[/b] : niveaux de capital, objets et talents, plafonnés (PA %d, PM %d, Portée %d)." % [ClassRules.PA_CAP, ClassRules.PM_CAP, ClassRules.PO_CAP],
	]
	return "\n\n".join(lines)
