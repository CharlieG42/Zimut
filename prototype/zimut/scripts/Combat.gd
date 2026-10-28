class_name Combat
extends RefCounted
## Combat.gd — Règles pures (sans état) du combat tactique.
## - Analyse du texte des sorts (colonne "Effet" des CSV) en un "profil" exploitable
## - Statuts avec durée (poison, étourdissement, buffs...)
## - Formule de dégâts façon Dofus (stats, résistances %, critiques, dos)
## - Ligne de vue, directions

const DIRS: Array[Vector2i] = [Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)]

## Sorts qui repoussent la cible (nombre de cases) — signature Dofus
const PUSH := {
	"Coup de bouclier": 1,
	"Coup écrasant": 2,
	"Tremblement de terre": 1,
	"Poing de pierre": 2,
	"Tir de recul": 2,
	"Éboulement": 1,
	"Séisme ambré": 1,
}

## V43 : états que les sorts « Combo » reconnaissent chez la cible (mot du texte -> statut).
const COMBO_STATES := {
	"poison": "poison", "saignement": "bleed", "brûlure": "burn", "étourdissement": "stun",
	"immobilisation": "root", "ralentissement": "slow", "malédiction": "curse",
	"affaiblissement": "weaken", "provocation": "taunted",
}
const COMBO_LABELS := {
	"poison": "empoisonnée", "bleed": "qui saigne", "burn": "en feu", "stun": "étourdie",
	"root": "immobilisée", "slow": "ralentie", "curse": "maudite", "weaken": "affaiblie", "taunted": "provoquée",
}

## V43 : bonus de dégâts/soins (en %) d'un sort grâce à ses synergies.
## `target` = cible du sort ({} pour un sort sans cible) ; `casts` = sorts déjà lancés par le lanceur ce tour.
static func synergy_pct(p: Dictionary, target: Dictionary, casts: Dictionary) -> int:
	var pct: int = 0
	var cs: String = String(p.get("combo_status", ""))
	if cs != "" and not target.is_empty() and has_status(target, cs):
		pct += int(p.get("combo_pct", 0))
	var ch: String = String(p.get("chain_spell", ""))
	if ch != "":
		for k: Variant in casts.keys():
			if String(k).to_lower() == ch and int(casts[k]) > 0:
				pct += int(p.get("chain_pct", 0))
				break
	return pct

const NEGATIVE: Array = ["poison", "bleed", "burn", "stun", "root", "slow", "curse", "weaken", "taunted"]

const STATUS_INFO := {
	"poison":      {"label": "Poison",         "color": Color(0.66, 0.36, 0.86), "icon": "Po"},
	"bleed":       {"label": "Saignement",     "color": Color(0.86, 0.15, 0.20), "icon": "Sa"},
	"burn":        {"label": "Brûlure",        "color": Color(1.00, 0.50, 0.10), "icon": "Br"},
	"stun":        {"label": "Étourdi",        "color": Color(1.00, 0.90, 0.20), "icon": "Ét"},
	"root":        {"label": "Immobilisé",     "color": Color(0.60, 0.42, 0.22), "icon": "Im"},
	"slow":        {"label": "Ralenti",        "color": Color(0.35, 0.80, 0.95), "icon": "Ra"},
	"curse":       {"label": "Maudit (-PA)",   "color": Color(0.45, 0.20, 0.60), "icon": "Ma"},
	"weaken":      {"label": "Affaibli",       "color": Color(0.60, 0.60, 0.60), "icon": "Af"},
	"taunted":     {"label": "Provoqué",       "color": Color(0.95, 0.30, 0.30), "icon": "Pr"},
	"def_up":      {"label": "Défense +",      "color": Color(0.30, 0.55, 1.00), "icon": "Df"},
	"mres_up":     {"label": "Rés. magie +",   "color": Color(0.55, 0.45, 1.00), "icon": "Rm"},
	"dmg_up":      {"label": "Dégâts +",       "color": Color(1.00, 0.60, 0.15), "icon": "Dg"},
	"pa_up":       {"label": "PA +",           "color": Color(0.30, 0.75, 1.00), "icon": "PA"},
	"pm_up":       {"label": "PM +",           "color": Color(0.35, 0.90, 0.45), "icon": "PM"},
	"dodge":       {"label": "Esquive +",      "color": Color(0.70, 0.90, 0.40), "icon": "Es"},
	"immune":      {"label": "Invulnérable",   "color": Color(1.00, 1.00, 0.70), "icon": "In"},
	"immune_phys": {"label": "Immunité phys.", "color": Color(0.90, 0.90, 0.60), "icon": "Ip"},
	"immune_mag":  {"label": "Immunité magie", "color": Color(0.70, 0.80, 1.00), "icon": "Im"},
	"immune_neg":  {"label": "Anti-altération", "color": Color(0.80, 1.00, 0.80), "icon": "An"},
	"invisible":   {"label": "Invisible",      "color": Color(0.80, 0.80, 0.90), "icon": "Iv"},
	"regen":       {"label": "Régénération",   "color": Color(0.40, 0.95, 0.50), "icon": "Rg"},
	"mark":        {"label": "Critique garanti", "color": Color(1.00, 0.85, 0.20), "icon": "Cr"},
	"chief":       {"label": "Chef (objectif)", "color": Color(1.00, 0.80, 0.30), "icon": "★"},
}


# ═══════════════════════════════════════════════════════════════════════════
#  Statuts
# ═══════════════════════════════════════════════════════════════════════════

static func status_info(id: String) -> Dictionary:
	if STATUS_INFO.has(id):
		return STATUS_INFO[id]
	return {"label": id, "color": Color.WHITE, "icon": "?"}


static func add_status(e: Dictionary, id: String, turns: int, value: float = 0.0) -> void:
	if not e.has("statuses"):
		e["statuses"] = []
	for s: Dictionary in e["statuses"]:
		if s["id"] == id:
			s["turns"] = maxi(int(s["turns"]), turns)
			s["value"] = maxf(float(s["value"]), value)
			return
	e["statuses"].append({"id": id, "turns": turns, "value": value})


static func has_status(e: Dictionary, id: String) -> bool:
	for s: Dictionary in e.get("statuses", []):
		if s["id"] == id:
			return true
	return false


static func status_value(e: Dictionary, id: String) -> float:
	for s: Dictionary in e.get("statuses", []):
		if s["id"] == id:
			return float(s["value"])
	return 0.0


static func remove_status(e: Dictionary, id: String) -> void:
	var kept: Array = []
	for s: Dictionary in e.get("statuses", []):
		if s["id"] != id:
			kept.append(s)
	e["statuses"] = kept


static func cure_negative(e: Dictionary) -> int:
	var kept: Array = []
	var removed: int = 0
	for s: Dictionary in e.get("statuses", []):
		if NEGATIVE.has(s["id"]):
			removed += 1
		else:
			kept.append(s)
	e["statuses"] = kept
	return removed


# ═══════════════════════════════════════════════════════════════════════════
#  Géométrie
# ═══════════════════════════════════════════════════════════════════════════

static func manhattan(a: Vector2i, b: Vector2i) -> int:
	return absi(a.x - b.x) + absi(a.y - b.y)


static func dir_to(a: Vector2i, b: Vector2i) -> Vector2i:
	var d: Vector2i = b - a
	if absi(d.x) >= absi(d.y):
		return Vector2i(signi(d.x), 0)
	return Vector2i(0, signi(d.y))


static func is_behind(att_pos: Vector2i, tgt_pos: Vector2i, tgt_facing: Vector2i) -> bool:
	if att_pos == tgt_pos or tgt_facing == Vector2i.ZERO:
		return false
	return dir_to(att_pos, tgt_pos) == tgt_facing


## Bresenham sur la grille : les obstacles (arbres/rochers) bloquent la vue.
static func has_los(a: Vector2i, b: Vector2i, obstacles: Dictionary) -> bool:
	var dx: int = absi(b.x - a.x)
	var dy: int = absi(b.y - a.y)
	var sx: int = 1 if a.x < b.x else -1
	var sy: int = 1 if a.y < b.y else -1
	var err: int = dx - dy
	var x: int = a.x
	var y: int = a.y
	var guard: int = 0
	while guard < 64:
		guard += 1
		if x == b.x and y == b.y:
			break
		var e2: int = 2 * err
		if e2 > -dy:
			err -= dy
			x += sx
		if e2 < dx:
			err += dx
			y += sy
		if x == b.x and y == b.y:
			break
		if obstacles.has(Vector2i(x, y)):
			return false
	return true


## Cases touchées par une zone centrée sur `center`.
static func zone_cells(center: Vector2i, r: int, shape: String, grid_size: int) -> Array[Vector2i]:
	var out: Array[Vector2i] = []
	if shape == "square_side":
		var k: int = (r - 1) / 2
		for dy: int in range(-k, r - k):
			for dx: int in range(-k, r - k):
				var cs := Vector2i(center.x + dx, center.y + dy)
				if cs.x >= 0 and cs.y >= 0 and cs.x < grid_size and cs.y < grid_size:
					out.append(cs)
		return out
	for dy: int in range(-r, r + 1):
		for dx: int in range(-r, r + 1):
			if shape == "diamond" and absi(dx) + absi(dy) > r:
				continue
			var c := Vector2i(center.x + dx, center.y + dy)
			if c.x >= 0 and c.y >= 0 and c.x < grid_size and c.y < grid_size:
				out.append(c)
	return out


# ═══════════════════════════════════════════════════════════════════════════
#  Dégâts
# ═══════════════════════════════════════════════════════════════════════════

static func calc_damage(att: Dictionary, tgt: Dictionary, base: float, dtype: String,
		ignore_def: float, force_crit: bool, simulate: bool) -> Dictionary:
	var stat: float = float(att.get("force", 0)) if dtype == "phys" else float(att.get("intelligence", 0))
	var mult: float = 1.0 + stat / 200.0
	mult *= 1.0 + status_value(att, "dmg_up") / 100.0
	mult *= maxf(0.1, 1.0 - status_value(att, "weaken") / 100.0)

	var back: bool = is_behind(Vector2i(int(att["x"]), int(att["y"])),
		Vector2i(int(tgt["x"]), int(tgt["y"])), tgt.get("facing", Vector2i.ZERO))
	if back:
		mult *= 1.25

	# Effets d'objets : dégâts magiques +%, critique +%
	var afx: Dictionary = att.get("fx", {})
	if dtype != "phys":
		mult *= 1.0 + float(afx.get("mag_pct", 0)) / 100.0
	else:
		mult *= 1.0 + float(afx.get("phys_pct", 0)) / 100.0
	# V42 : bonus de l'arbre de talents du héros (via fx)
	mult *= float(afx.get("talent_dmg_pct", 1.0))
	var crit_chance: float = clampf(0.05 + float(att.get("agility", 0)) / 400.0 + float(afx.get("crit", 0)) / 100.0 + float(afx.get("talent_crit_pct", 0.0)) / 100.0, 0.05, 0.6)
	var crit: bool = force_crit or has_status(att, "mark")
	if simulate:
		if not crit:
			mult *= 1.0 + crit_chance * 0.5
	elif not crit:
		crit = randf() < crit_chance
	if crit:
		mult *= 1.5

	var res: float
	if dtype == "phys":
		var d: float = float(tgt.get("defense", 0)) * (1.0 - ignore_def / 100.0)
		res = d / (d + 100.0) + status_value(tgt, "def_up") / 100.0
	else:
		var d2: float = float(tgt.get("defense", 0)) * 0.5
		res = d2 / (d2 + 100.0) + status_value(tgt, "mres_up") / 100.0 + float(tgt.get("fx", {}).get("mres", 0)) / 100.0
	res = clampf(res, 0.0, 0.85)

	var dmg: float = base * mult * (1.0 - res)
	if not simulate:
		dmg *= randf_range(0.93, 1.07)
	return {"dmg": maxi(1, roundi(dmg)), "crit": crit, "back": back}


# ═══════════════════════════════════════════════════════════════════════════
#  Analyse des sorts
# ═══════════════════════════════════════════════════════════════════════════

static func _num(t: String, pattern: String, group: int = 1, default: int = 0) -> int:
	var rx := RegEx.new()
	rx.compile(pattern)
	var m: RegExMatch = rx.search(t)
	if m == null:
		return default
	return int(m.get_string(group))


static func _has(t: String, pattern: String) -> bool:
	var rx := RegEx.new()
	rx.compile(pattern)
	return rx.search(t) != null


static func _turns(t: String, default: int) -> int:
	return _num(t, "(\\d+) tours?", 1, default)


## Effets d'un glyphe pour un camp : {dmg, dtype, dots, debuffs, buffs, heal} (valeurs x niveau de sort).
static func _glyph_effects(txt: String, default_dtype: String, mult: float) -> Dictionary:
	var out: Dictionary = {"dmg": 0, "dtype": "mag" if (txt.contains("magique") or default_dtype == "mag") else "phys",
		"dots": [], "debuffs": [], "buffs": [], "heal": 0}
	out["dmg"] = roundi(float(_num(txt, "(\\d+) dégâts(?!/)", 1, 0)) * mult)
	var dv: int = _num(txt, "(\\d+) dégâts/tour", 1, 0)
	if dv > 0:
		var did: String = "poison"
		if txt.contains("brûle"):
			did = "burn"
		elif txt.contains("saign"):
			did = "bleed"
		var after: String = txt.substr(txt.find("dégâts/tour"))
		out["dots"].append({"id": did, "value": float(dv) * mult, "turns": _turns(after, 2)})
	if txt.contains("ralenti"):
		out["debuffs"].append({"id": "slow", "value": float(_num(txt, "(\\d+) pm", 1, 1)) * mult, "turns": _turns(txt, 1)})
	if txt.contains("immobilis"):
		out["debuffs"].append({"id": "root", "value": 1.0, "turns": 1})
	if _has(txt, "-\\d+% dégâts"):
		out["debuffs"].append({"id": "weaken", "value": float(_num(txt, "-(\\d+)% dégâts", 1, 20)) * mult, "turns": 1})
	if _has(txt, "\\+\\d+% défense"):
		out["buffs"].append({"id": "def_up", "value": float(_num(txt, "\\+(\\d+)% défense", 1, 20)) * mult, "turns": 2})
	if _has(txt, "\\+\\d+% dégâts"):
		out["buffs"].append({"id": "dmg_up", "value": float(_num(txt, "\\+(\\d+)% dégâts", 1, 20)) * mult, "turns": 2})
	if txt.contains("invisible"):
		out["buffs"].append({"id": "invisible", "value": 1.0, "turns": _turns(txt, 2)})
	if _has(txt, "soigne \\d+"):
		out["heal"] = roundi(float(_num(txt, "soigne (\\d+)", 1, 0)) * mult)
	return out


## Transforme un sort (dictionnaire issu du CSV) en profil de règles. Mis en cache.
static func parse(spell: Dictionary) -> Dictionary:
	if spell.has("_p"):
		return spell["_p"]

	var sname: String = String(spell.get("name", ""))
	var t: String = String(spell.get("effect", "")).to_lower()
	# V43 : clauses de synergie « [Combo poison : bonus 40%] » / « [Enchaînement après X : bonus 30%] »
	var combo_status: String = ""
	var combo_pct: int = 0
	var chain_spell: String = ""
	var chain_pct: int = 0
	if t.contains("["):
		var rx_c := RegEx.new()
		rx_c.compile("\\[combo ([^ :\\]]+) : bonus (\\d+)%\\]")
		var mc: RegExMatch = rx_c.search(t)
		if mc != null:
			combo_status = String(COMBO_STATES.get(mc.get_string(1), ""))
			combo_pct = int(mc.get_string(2))
		var rx_e := RegEx.new()
		rx_e.compile("\\[enchaînement après ([^:\\]]+?) : bonus (\\d+)%\\]")
		var me: RegExMatch = rx_e.search(t)
		if me != null:
			chain_spell = me.get_string(1).strip_edges()
			chain_pct = int(me.get_string(2))
		var rx_s := RegEx.new()
		rx_s.compile("\\s*\\[(?:combo|enchaînement)[^\\]]*\\]")
		t = rx_s.sub(t, "", true)
	var stype: String = String(spell.get("spell_type", "Attaque"))
	var classe: String = String(spell.get("classe", ""))
	var rng: int = int(spell.get("range", 1))
	var magic_class: bool = classe in ["Mage", "Druide", "Invocateur", "Heal", "Géomancien"]

	var p: Dictionary = {
		"kind": "attack",       # attack | heal | buff | summon | teleport | trap | revive
		"target": "enemy",      # enemy | ally | self | cell | free_cell | any_entity
		"aoe": "single",        # single | zone | enemies_in_range | adjacent_enemies | team
		"zone_r": 0, "zone_shape": "diamond",
		"dmg": 0, "dtype": "mag" if (magic_class or t.contains("magique")) else "phys",
		"heal": 0, "heal_pct": 0, "regen": 0, "regen_turns": 0,
		"dots": [], "buffs": [], "debuffs": [], "self_buffs": [],
		"ignore_def": 0, "cond": "", "push": 0,
		"summon": "", "summon_turns": -1,
		"adj_dmg": 0, "chain": 0, "cure": false, "tele": "", "trap": 0,
		"stun_chance": 0, "stun_turns": 0,
		"needs_los": rng > 1, "min_range": 1,
		"summon_dmg_base": 0, "summon_dmg_lvl": 0.0, "needs_summon": false,
		"buff_summons": false,
		"glyph_turns": 0, "glyph_allies": {}, "glyph_foes": {},
		"mine": false,
		"combo_status": combo_status, "combo_pct": combo_pct,
		"chain_spell": chain_spell, "chain_pct": chain_pct,
	}
	if PUSH.has(sname):
		p["push"] = int(PUSH[sname])

	# ── Artificier (V26) : mécanismes posés sur le terrain et Déclencheur ───────────────
	if sname.begins_with("Poser ") and stype == "Invocation":
		p["kind"] = "summon"
		p["target"] = "free_cell"
		p["summon"] = sname.substr(6)
		p["needs_los"] = false
		spell["_p"] = p
		return p
	if sname == "Déclencheur":
		p["kind"] = "trigger"
		p["target"] = "cell"
		p["needs_los"] = false
		p["min_range"] = 0
		spell["_p"] = p
		return p
	# V68 : Rappel (désinvoque un mécanisme) et Maintenance (répare + prolonge les mécanismes)
	if sname == "Rappel":
		p["kind"] = "recall_mech"
		p["target"] = "cell"
		p["needs_los"] = false
		p["min_range"] = 0
		spell["_p"] = p
		return p
	if sname == "Maintenance":
		p["kind"] = "maintain"
		p["target"] = "self"
		p["needs_los"] = false
		p["min_range"] = 0
		spell["_p"] = p
		return p
	if sname == "Arsenal total":
		p["kind"] = "trigger_all"
		p["target"] = "self"
		p["needs_los"] = false
		p["min_range"] = 0
		spell["_p"] = p
		return p

	# ── Invocations ────────────────────────────────────────────────────────
	if stype == "Invocation" and sname.begins_with("Invoquer "):
		p["kind"] = "summon"
		p["target"] = "free_cell"
		p["summon"] = sname.substr(9)
		p["needs_los"] = false
		spell["_p"] = p
		return p
	if sname == "Balise de chasse":
		p["kind"] = "summon"
		p["target"] = "free_cell"
		p["summon"] = "Balise"
		p["needs_los"] = false
		spell["_p"] = p
		return p
	if sname == "Rappel de balise":
		p["kind"] = "recall"
		p["target"] = "any_entity"
		p["needs_los"] = false
		p["min_range"] = 0
		spell["_p"] = p
		return p
	if t.begins_with("invoque 1 loup"):
		p["kind"] = "summon"
		p["target"] = "free_cell"
		p["summon"] = "Loup Spectral"
		p["summon_turns"] = 3
		p["needs_los"] = false
		spell["_p"] = p
		return p

	# ── Glyphes (V19) : zone posée au sol, effet au début du tour de ceux qui s'y trouvent ──
	#   « Trace un glyphe (3x3|croix; N tours) : alliés <effets> | ennemis <effets> »
	if t.begins_with("trace un glyphe"):
		p["kind"] = "glyph"
		p["target"] = "cell"
		p["aoe"] = "zone"
		p["needs_los"] = false
		p["min_range"] = 0
		var gz: int = _num(t, "glyphe \\((\\d)x\\d", 1, 0)
		if gz > 0:
			p["zone_shape"] = "square_side"
			p["zone_r"] = gz
		else:
			p["zone_shape"] = "diamond"
			p["zone_r"] = 1
		p["glyph_turns"] = _num(t, "; (\\d+) tours?\\)", 1, 3)
		var gmul: float = float(spell.get("mult", 1.0))
		var body: String = t.substr(t.find(":") + 1) if t.contains(":") else ""
		for seg: String in body.split("|"):
			var sg: String = seg.strip_edges()
			if sg.begins_with("alliés"):
				p["glyph_allies"] = _glyph_effects(sg.substr("alliés".length()), p["dtype"], gmul)
			elif sg.begins_with("ennemis"):
				p["glyph_foes"] = _glyph_effects(sg.substr("ennemis".length()), p["dtype"], gmul)
		spell["_p"] = p
		return p

	# ── Téléportations ─────────────────────────────────────────────────────
	if t.contains("téléport"):
		p["kind"] = "teleport"
		p["needs_los"] = false
		if t.contains("derrière"):
			p["tele"] = "behind"
			p["target"] = "enemy"
		elif t.contains("tous les alliés"):
			p["tele"] = "group"
			p["target"] = "free_cell"
		else:
			p["tele"] = "near"
			p["target"] = "any_entity"
		spell["_p"] = p
		return p

	# ── Piège ──────────────────────────────────────────────────────────────
	if t.contains("pose un piège"):
		p["kind"] = "trap"
		p["target"] = "free_cell"
		p["mine"] = t.contains("(mine)")
		p["trap"] = _num(t, "(\\d+) dégâts", 1, 50)
		p["needs_los"] = false
		spell["_p"] = p
		return p

	# ── Résurrection ───────────────────────────────────────────────────────
	if t.contains("allié ko"):
		p["kind"] = "revive"
		p["target"] = "self"
		p["heal"] = _num(t, "(\\d+) pv", 1, 100)
		p["min_range"] = 0
		spell["_p"] = p
		return p

	# ── Conditions et modificateurs ────────────────────────────────────────
	if t.contains("dos tourné"):
		p["cond"] = "back_crit"
	if t.contains("<30% pv"):
		p["cond"] = "exec_30"
	if t.contains("tue si <20%"):
		p["cond"] = "kill_20"
	if t.contains("ignore"):
		p["ignore_def"] = _num(t, "ignore (\\d+)%", 1, 0)
	if t.contains("(2 cibles)"):
		p["chain"] = 2
	var chain_n: int = _num(t, "saute sur (\\d+) ennemis", 1, 0)
	if chain_n > 0:
		p["chain"] = chain_n

	# ── Zone ───────────────────────────────────────────────────────────────
	var zn: int = _num(t, "en zone \\((\\d)x\\d\\)", 1, 0)
	if zn > 0:
		p["aoe"] = "zone"
		p["target"] = "cell"
		p["zone_shape"] = "square_side"
		p["zone_r"] = zn

	# ── Soins ──────────────────────────────────────────────────────────────
	var is_heal: bool = t.contains("restaure") or t.contains("soigne")
	if is_heal:
		var col_heal: int = int(spell.get("Soins", 0))
		var txt_heal: int = _num(t, "restaure (\\d+) pv(?!/)", 1, 0)
		p["heal"] = col_heal if col_heal > 0 else txt_heal
		p["heal_pct"] = _num(t, "restaure (\\d+)% pv", 1, 0)
		if p["heal_pct"] > 0:
			p["heal"] = 0
		var regen_v: int = _num(t, "(?:restaure|soigne) (\\d+) pv/tour", 1, 0)
		if regen_v > 0:
			p["regen"] = regen_v
			p["regen_turns"] = _turns(t, 3)
			if t.begins_with("restaure"):
				p["heal"] = 0
		if t.contains("tous les alliés"):
			p["aoe"] = "team"
			p["target"] = "self"
			p["min_range"] = 0
		else:
			p["target"] = "ally"
			p["min_range"] = 0
		p["kind"] = "heal"
		if t.contains("supprime les effets négatifs"):
			p["cure"] = true
		p["needs_los"] = false
		if t.contains("aux ennemis adjacents"):
			p["adj_dmg"] = _num(t, "(\\d+) dégâts", 1, 0)
	elif t.contains("supprime les effets négatifs"):
		p["kind"] = "buff"
		p["target"] = "ally"
		p["min_range"] = 0
		p["cure"] = true
		p["needs_los"] = false

	# ── Dégâts directs ─────────────────────────────────────────────────────
	if not is_heal:
		var direct: int = _num(t, "(\\d+) dégâts(?!/)", 1, 0)
		if direct == 0 and stype == "Attaque":
			direct = maxi(int(spell.get("Degats_physiques", 0)), int(spell.get("Degats_magiques", 0)))
		p["dmg"] = direct
		if t.contains("l'invocation attaque"):
			p["needs_summon"] = true
			p["summon_dmg_base"] = _num(t, "dégâts = (\\d+)", 1, 20)
			p["summon_dmg_lvl"] = 0.5 if t.contains("niveau/2") else 1.0
			p["dmg"] = 0
		if t.contains("à tous les ennemis adjacents") and rng <= 2 and direct > 0 and zn == 0:
			p["aoe"] = "adjacent_enemies"
			p["target"] = "self"
			p["min_range"] = 0
			p["needs_los"] = false
		elif t.contains("tous les ennemis adjacents") and zn == 0:
			p["aoe"] = "zone"
			p["zone_r"] = 1
			p["zone_shape"] = "diamond"
			p["target"] = "cell"
		elif t.contains("à tous les ennemis") or t.contains("aux ennemis (") or t.contains("aux ennemis"):
			if zn == 0:
				p["aoe"] = "enemies_in_range"
				p["target"] = "self"
				p["min_range"] = 0
				p["needs_los"] = false

	# ── Dégâts sur la durée ────────────────────────────────────────────────
	var dot_v: int = _num(t, "(\\d+) dégâts/tour", 1, 0)
	if dot_v > 0:
		var dot_id: String = "poison"
		if t.contains("brûle"):
			dot_id = "burn"
		elif t.contains("saign"):
			dot_id = "bleed"
		var after: String = t.substr(t.find("dégâts/tour"))
		p["dots"].append({"id": dot_id, "value": dot_v, "turns": _turns(after, 2)})

	# ── Altérations négatives ──────────────────────────────────────────────
	if t.contains("étourdit"):
		p["stun_turns"] = _num(t, "étourdit (\\d+) tour", 1, 1)
		p["stun_chance"] = _num(t, "\\((\\d+)%\\)", 1, 100)
	if t.contains("immobilise"):
		p["debuffs"].append({"id": "root", "value": 1, "turns": _turns(t, 1)})
	if t.contains("ralentit") or t.contains("réduit 1 pm"):
		p["debuffs"].append({"id": "slow", "value": float(_num(t, "(\\d+) pm", 1, 1)), "turns": _turns(t, 2)})
	if _has(t, "-\\d+ pa"):
		p["debuffs"].append({"id": "curse", "value": float(_num(t, "-(\\d+) pa", 1, 1)), "turns": _turns(t, 1)})
	if _has(t, "-\\d+% dégâts"):
		p["debuffs"].append({"id": "weaken", "value": float(_num(t, "-(\\d+)% dégâts", 1, 20)), "turns": _turns(t, 2)})
	if t.contains("précision"):
		p["debuffs"].append({"id": "weaken", "value": float(_num(t, "(\\d+)% précision", 1, 30)), "turns": _turns(t, 2)})
	if t.contains("force l'ennemi à attaquer"):
		p["debuffs"].append({"id": "taunted", "value": 1, "turns": _turns(t, 1)})

	# ── Bonus positifs ─────────────────────────────────────────────────────
	var buffs: Array = []
	var bt: int = _turns(t, 2)
	if _has(t, "\\+\\d+% défense"):
		buffs.append({"id": "def_up", "value": float(_num(t, "\\+(\\d+)% défense", 1, 20)), "turns": bt})
	if _has(t, "\\+\\d+% résistance magie"):
		buffs.append({"id": "mres_up", "value": float(_num(t, "\\+(\\d+)% résistance magie", 1, 20)), "turns": bt})
	elif _has(t, "\\+\\d+% résistance"):
		var rv: float = float(_num(t, "\\+(\\d+)% résistance", 1, 20))
		buffs.append({"id": "def_up", "value": rv, "turns": bt})
		buffs.append({"id": "mres_up", "value": rv, "turns": bt})
	if _has(t, "\\+\\d+% dégâts"):
		buffs.append({"id": "dmg_up", "value": float(_num(t, "\\+(\\d+)% dégâts", 1, 20)), "turns": bt})
	if _has(t, "\\+\\d+ pa"):
		buffs.append({"id": "pa_up", "value": float(_num(t, "\\+(\\d+) pa", 1, 1)), "turns": bt})
	if _has(t, "\\+\\d+ pm"):
		buffs.append({"id": "pm_up", "value": float(_num(t, "\\+(\\d+) pm", 1, 1)), "turns": bt})
	if _has(t, "\\+\\d+% esquive"):
		buffs.append({"id": "dodge", "value": float(_num(t, "\\+(\\d+)% esquive", 1, 30)), "turns": bt})
	if t.contains("+3 à toutes les stats"):
		buffs.append({"id": "dmg_up", "value": 20.0, "turns": bt})
		buffs.append({"id": "def_up", "value": 20.0, "turns": bt})
	if t.contains("immunité aux dégâts physiques"):
		buffs.append({"id": "immune_phys", "value": 1, "turns": _turns(t, 1)})
	elif t.contains("immunité aux effets négatifs"):
		buffs.append({"id": "immune_neg", "value": 1, "turns": _turns(t, 1)})
	elif t.contains("immunité") and t.contains("magie"):
		buffs.append({"id": "immune_mag", "value": 1, "turns": bt})
	elif t.contains("immunité"):
		buffs.append({"id": "immune", "value": 1, "turns": _turns(t, 1)})
	if t.contains("bloquant les attaques"):
		buffs.append({"id": "immune", "value": 1, "turns": _turns(t, 1)})
	if t.contains("invisible"):
		buffs.append({"id": "invisible", "value": 1, "turns": bt})
	if t.contains("critique garanti"):
		buffs.append({"id": "mark", "value": 1, "turns": 3})
	if p["regen"] > 0:
		buffs.append({"id": "regen", "value": float(p["regen"]), "turns": p["regen_turns"]})

	var bless: bool = t.contains("bénit")
	if bless:
		p["self_buffs"].append({"id": "dmg_up", "value": 10.0, "turns": 2})

	# Un sort "d'attaque" n'utilise pas ses bonus comme buffs de cible
	var offensive: bool = (p["dmg"] > 0 or p["dots"].size() > 0 or p["debuffs"].size() > 0 or p["needs_summon"])
	if offensive and p["kind"] != "heal":
		p["kind"] = "attack"
		if p["aoe"] == "single" and p["target"] == "enemy":
			pass
		if p["aoe"] == "single" and p["target"] != "enemy" and p["target"] != "cell":
			p["target"] = "enemy"
	elif p["kind"] != "heal" and (buffs.size() > 0):
		p["kind"] = "buff"
		p["needs_los"] = false
		p["min_range"] = 0
		if t.contains("équipe") or t.contains("tous les alliés"):
			p["aoe"] = "team"
			p["target"] = "self"
		elif t.contains("allié"):
			p["target"] = "ally"
		else:
			p["target"] = "self"
		if t.begins_with("l'invocation gagne"):
			p["buff_summons"] = true
			p["target"] = "self"
		p["buffs"] = buffs
	elif p["kind"] == "heal":
		# Buffs accompagnant un soin (ex. Barrière de vie : +30 % défense + soin par tour)
		p["buffs"] = buffs
	elif p["cure"]:
		pass
	else:
		# Sort sans effet reconnu → petit buff neutre pour rester jouable
		p["kind"] = "buff"
		p["target"] = "self"
		p["min_range"] = 0
		p["needs_los"] = false
		p["buffs"] = [{"id": "dmg_up", "value": 10.0, "turns": 2}]

	if p["kind"] == "attack" and bless:
		p["buffs"] = []

	# ── Niveau de sort (amélioration 1..10) : +SPELL_LEVEL_BONUS_PCT / niveau ──
	var smult: float = float(spell.get("mult", 1.0))
	if smult != 1.0 and smult > 0.0:
		for key: String in ["dmg", "heal", "regen", "adj_dmg", "summon_dmg_base"]:
			p[key] = int(roundf(float(p[key]) * smult))
		for d: Dictionary in p["dots"]:
			d["value"] = float(d["value"]) * smult
		for b: Dictionary in p["buffs"]:
			b["value"] = float(b["value"]) * smult
		for db: Dictionary in p["debuffs"]:
			db["value"] = float(db["value"]) * smult

	spell["_p"] = p
	return p


## Nombre de lancers autorisés par tour (évite le spam du meilleur sort).
static func max_casts(spell: Dictionary) -> int:
	# Une seule invocation de créature par tour : on bâtit son armée au fil des tours
	var nm: String = String(spell.get("name", ""))
	if nm.begins_with("Invoquer "):
		var info: Dictionary = SUMMONS.get(nm.substr(9), {})
		if not bool(info.get("terrain", false)):
			return 1
	var pa: int = int(spell.get("cost_pa", 1))
	if pa >= 4:
		return 1
	if pa == 3:
		return 2
	return 3


## Courte description lisible (pour l'infobulle).
static func describe(spell: Dictionary) -> String:
	var p: Dictionary = parse(spell)
	var parts: Array[String] = []
	var rx_b := RegEx.new()
	rx_b.compile("\\s*\\[(?:Combo|Enchaînement)[^\\]]*\\]")
	parts.append(rx_b.sub(String(spell.get("effect", "")), "", true))
	if int(p["push"]) > 0:
		parts.append("Repousse de %d case(s)" % int(p["push"]))
	if String(p.get("combo_status", "")) != "":
		parts.append("Combo : +%d %% si la cible est %s" % [int(p["combo_pct"]), String(COMBO_LABELS.get(p["combo_status"], ""))])
	if String(p.get("chain_spell", "")) != "":
		parts.append("Enchaînement : +%d %% après %s lancé ce tour" % [int(p["chain_pct"]), String(p["chain_spell"]).capitalize()])
	if p["cond"] == "back_crit":
		parts.append("Dans le dos : coup critique")
	return "\n".join(parts)


# ═══════════════════════════════════════════════════════════════════════════
#  Contenu : kits ennemis et invocations
# ═══════════════════════════════════════════════════════════════════════════

static func _mk(sname: String, pa: int, rng: int, effect: String, stype: String = "Attaque") -> Dictionary:
	return {
		"name": sname, "classe": "Ennemi", "cost_pa": pa, "cost_pm": 0, "range": rng,
		"effect": effect, "level_required": 1, "spell_type": stype,
		"Degats_physiques": 0, "Degats_magiques": 0, "Soins": 0,
	}


static func enemy_spells(etype: String, force: int) -> Array:
	var s: Array = []
	match etype:
		"Gobelin":
			s.append(_mk("Coup de massue", 2, 1, "%d dégâts + étourdit 1 tour (15%%)" % int(force * 1.2)))
			s.append(_mk("Jet de dague", 2, 3, "%d dégâts" % int(force * 0.8)))
		"Squelette":
			s.append(_mk("Tir d'os", 2, 4, "%d dégâts" % int(force * 1.0)))
			s.append(_mk("Coup d'os", 2, 1, "%d dégâts" % int(force * 1.15)))
		"Loup":
			s.append(_mk("Morsure", 2, 1, "%d dégâts + saignement (%d dégâts/tour; 2 tours)" % [int(force * 1.0), int(force * 0.3)]))
			s.append(_mk("Hurlement", 2, 4, "%d dégâts magiques + ralentit 1 pm (2 tours)" % int(force * 0.5)))
		"Troll":
			s.append(_mk("Poing de pierre", 3, 1, "%d dégâts" % int(force * 1.5)))
		"Dragonnet":
			s.append(_mk("Souffle de feu", 3, 3, "%d dégâts en zone (3x3) + brûle (%d dégâts/tour; 2 tours)" % [int(force * 0.9), int(force * 0.25)]))
			s.append(_mk("Morsure", 2, 1, "%d dégâts" % int(force * 1.1)))
		_:
			s.append(_mk("Attaque", 2, 1, "%d dégâts" % force))
	return s

## Sorts des boss : le kit du type de base (CaC inclus) + une attaque puissante
## à distance pour menacer l'équipe de loin.
static func boss_spells(base_type: String, force: int) -> Array:
	var s: Array = enemy_spells(base_type, force)
	match base_type:
		"Gobelin":
			s.append(_mk("Pluie de dagues", 3, 6, "%d dégâts en zone (3x3)" % int(force * 0.8)))
		"Squelette":
			s.append(_mk("Trait spectral", 3, 6, "%d dégâts magiques + affaiblit (-%d dégâts; 2 tours)" % [int(force * 0.7), int(force * 0.15)]))
		"Loup":
			s.append(_mk("Rugissement terrifiant", 3, 6, "%d dégâts magiques + étourdit 1 tour (35%%)" % int(force * 0.6)))
		"Troll":
			s.append(_mk("Jet de rocher", 3, 6, "%d dégâts" % int(force * 0.9)))
		"Dragonnet":
			s.append(_mk("Boule de feu", 3, 7, "%d dégâts en zone (3x3) + brûle (%d dégâts/tour; 2 tours)" % [int(force * 0.8), int(force * 0.25)]))
		_:
			s.append(_mk("Frappe à distance", 3, 6, "%d dégâts" % int(force * 0.8)))
	return s


## Sorts signature des boss de nation (en plus du kit du type de base).
static func nation_boss_spells(boss_name: String, force: int) -> Array:
	var s: Array = []
	match boss_name:
		"Golem Prismatique":
			s.append(_mk("Éclat prismatique", 3, 5, "%d dégâts en zone (3x3) + affaiblit (-%d dégâts; 2 tours)" % [int(force * 0.7), int(force * 0.15)]))
		"Crabe Titan":
			s.append(_mk("Pince océane", 2, 1, "%d dégâts + étourdit 1 tour (40%%)" % int(force * 1.0)))
		"Seigneur des Tempêtes":
			s.append(_mk("Foudre céleste", 3, 7, "%d dégâts magiques en zone (3x3) + étourdit 1 tour (30%%)" % int(force * 0.75)))
		"Seigneur de Lave":
			s.append(_mk("Coulée de lave", 3, 6, "%d dégâts en zone (3x3) + brûle (%d dégâts/tour; 3 tours)" % [int(force * 0.75), int(force * 0.3)]))
		"Liche des Brumes":
			s.append(_mk("Brume d'affaiblissement", 3, 6, "%d dégâts magiques + affaiblit (-%d dégâts; 3 tours)" % [int(force * 0.6), int(force * 0.2)]))
		"Colosse d'Engrenages":
			s.append(_mk("Salve de pistons", 3, 5, "%d dégâts en zone (3x3) + étourdit 1 tour (30%%)" % int(force * 0.7)))
		"Liche Éternelle":
			s.append(_mk("Mot de l'éternité", 3, 7, "%d dégâts magiques + affaiblit (-%d dégâts; 2 tours)" % [int(force * 0.8), int(force * 0.2)]))
	return s


const SUMMONS := {
	"Golem de Pierre": {"pv": 300, "force": 25, "defense": 70, "agility": 10, "pa": 3, "pm": 2, "color": Color(0.35, 0.65, 0.35), "spell": ["Poing de roche", 2, 1, 45]},
	"Loup Spectral": {"pv": 170, "force": 50, "defense": 28, "agility": 40, "pa": 4, "pm": 4, "color": Color(0.55, 0.55, 0.60), "spell": ["Morsure spectrale", 2, 1, 60]},
	"Requin des Marées": {"pv": 150, "force": 55, "defense": 24, "agility": 30, "pa": 4, "pm": 3, "color": Color(0.30, 0.75, 0.90), "spell": ["Vague tranchante", 2, 4, 55]},
	"Élémentaire de Cristal": {"pv": 170, "force": 60, "defense": 30, "agility": 34, "pa": 4, "pm": 3, "color": Color(1.00, 0.95, 0.60), "spell": ["Éclat de cristal", 2, 3, 65]},
	"Ombre": {"pv": 160, "force": 65, "defense": 30, "agility": 55, "pa": 4, "pm": 4, "color": Color(0.80, 0.55, 0.25), "spell": ["Lame d'ombre", 2, 3, 70]},
	"Esprit de la Forêt": {"pv": 260, "force": 70, "defense": 40, "agility": 45, "pa": 5, "pm": 4, "color": Color(0.65, 0.40, 0.25), "spell": ["Vrilles sylvestres", 2, 5, 80]},
	"Archer Sylvestre": {"pv": 150, "force": 45, "defense": 24, "agility": 35, "pa": 3, "pm": 3, "color": Color(0.30, 0.55, 0.25), "spell": ["Flèche de sève", 2, 5, "40 dégâts + ralentit 1 pm (1 tour)"]},
	"Ent de Combat": {"pv": 240, "force": 45, "defense": 42, "agility": 12, "pa": 3, "pm": 2, "color": Color(0.85, 0.55, 0.40), "spell": ["Coup de branche", 2, 1, "55 dégâts + étourdit 1 tour (25%)"]},
	"Tronc":        {"pv": 320, "force": 45, "defense": 65, "agility": 10, "pa": 4, "pm": 2, "color": Color(0.45, 0.32, 0.18), "spell": ["Bras de bois", 2, 1, 60]},
	"Sarriette":    {"pv": 200, "force": 60, "defense": 32, "agility": 40, "pa": 4, "pm": 3, "color": Color(0.55, 0.80, 0.35), "spell": ["Fouet de sarriette", 2, 4, 75]},
	"Ronce agressive": {"pv": 140, "force": 55, "defense": 25, "agility": 30, "pa": 3, "pm": 3, "color": Color(0.40, 0.55, 0.25), "spell": ["Fouet de ronce", 2, 2, 45]},	# Arbre du Sylvain : immobile, ne joue pas, bloque la vue, relaie les soins du Sylvain
	"Arbre":        {"pv": 260, "force": 0, "defense": 30, "agility": 0, "pa": 0, "pm": 0, "color": Color(0.30, 0.65, 0.30), "spell": [], "static": true, "blocks_los": true, "relay": true, "unique": true},
	# Racines du Sylvain : bloquent la ligne de vue, sans relais de soins
	"Racines":      {"pv": 200, "force": 0, "defense": 50, "agility": 0, "pa": 0, "pm": 0, "color": Color(0.45, 0.38, 0.22), "spell": [], "static": true, "blocks_los": true, "unique": true},
	# Balise du Chasseur : immobile, réplique les dégâts de zone autour d'elle
	# Terrain du Géomancien : des cases de la grille deviennent des obstacles (« terrain »).
	# Elles ne comptent pas comme familiers, disparaissent après `turns` tours du Géomancien
	# et peuvent être détruites. `span` = nombre de cases posées d'un coup (ligne perpendiculaire).
	"Pilier":       {"pv": 70, "force": 0, "defense": 30, "agility": 0, "pa": 0, "pm": 0, "color": Color(0.80, 0.62, 0.35), "spell": [], "static": true, "blocks_los": true, "terrain": true, "turns": 4, "span": 1, "tower": true},
	"Muraille":     {"pv": 70, "force": 0, "defense": 30, "agility": 0, "pa": 0, "pm": 0, "color": Color(0.72, 0.55, 0.30), "spell": [], "static": true, "blocks_los": true, "terrain": true, "turns": 3, "span": 3},
	"Faille":       {"pv": 999, "force": 0, "defense": 0, "agility": 0, "pa": 0, "pm": 0, "color": Color(0.35, 0.22, 0.12), "spell": [], "static": true, "terrain": true, "turns": 3, "span": 3, "indestructible": true},
	"Cristal ambré": {"pv": 90, "force": 0, "defense": 40, "agility": 0, "pa": 0, "pm": 0, "color": Color(0.95, 0.65, 0.15), "spell": [], "static": true, "terrain": true, "turns": 4, "span": 1},
	# Mécanismes de l'Artificier (V26) : posés comme du terrain (ne comptent pas comme familiers).
	"Bombe":        {"pv": 36, "force": 0, "defense": 10, "agility": 0, "pa": 0, "pm": 0, "color": Color(0.85, 0.25, 0.20), "spell": [], "static": true, "terrain": true, "turns": 4, "span": 1, "mech": "bomb"},
	# V68 : variantes (bomb_* / turret_* sont recopiés sur le mécanisme posé)
	"Bombe incendiaire": {"pv": 36, "force": 0, "defense": 10, "agility": 0, "pa": 0, "pm": 0, "color": Color(1.0, 0.45, 0.10), "spell": [], "static": true, "terrain": true, "turns": 4, "span": 1, "mech": "bomb", "bomb_mult": 0.9, "bomb_status": "burn", "bomb_status_turns": 2},
	"Bombe assourdissante": {"pv": 36, "force": 0, "defense": 10, "agility": 0, "pa": 0, "pm": 0, "color": Color(0.95, 0.85, 0.25), "spell": [], "static": true, "terrain": true, "turns": 4, "span": 1, "mech": "bomb", "bomb_mult": 0.7, "bomb_status": "stun", "bomb_status_turns": 1},
	"Charge à fragmentation": {"pv": 44, "force": 0, "defense": 12, "agility": 0, "pa": 0, "pm": 0, "color": Color(0.55, 0.30, 0.20), "spell": [], "static": true, "terrain": true, "turns": 4, "span": 1, "mech": "bomb", "bomb_mult": 1.6, "bomb_radius": 3},
	"Tourelle lourde": {"pv": 80, "force": 0, "defense": 25, "agility": 0, "pa": 0, "pm": 0, "color": Color(0.40, 0.45, 0.55), "spell": [], "static": true, "terrain": true, "turns": 4, "span": 1, "mech": "turret", "turret_mult": 1.8, "turret_range": 6},
	"Tourelle":     {"pv": 60, "force": 0, "defense": 20, "agility": 0, "pa": 0, "pm": 0, "color": Color(0.55, 0.62, 0.72), "spell": [], "static": true, "terrain": true, "turns": 4, "span": 1, "mech": "turret"},
	"Balise de transposition": {"pv": 15, "force": 0, "defense": 10, "agility": 0, "pa": 0, "pm": 0, "color": Color(0.30, 0.85, 0.90), "spell": [], "static": true, "terrain": true, "turns": 5, "span": 1, "mech": "swap"},
	"Balise":       {"pv": 90, "force": 0, "defense": 30, "agility": 0, "pa": 0, "pm": 0, "color": Color(0.90, 0.60, 0.20), "spell": [], "static": true, "beacon": true},
}


## V16 : comme les sorts des héros, les attaques des invocations sont divisées par 2 (V19).
const SUMMON_SPELL_DIV := 2.0


## Divise les montants « N dégâts » et « N PV » d'un texte d'effet.
static func _scale_effect(t: String, div: float) -> String:
	var rx := RegEx.new()
	rx.compile("(\\d+)(?= dégâts| PV| pv)")
	var out: String = ""
	var last: int = 0
	for m: RegExMatch in rx.search_all(t):
		out += t.substr(last, m.get_start() - last) + str(maxi(1, roundi(float(m.get_string(1)) / div)))
		last = m.get_end()
	return out + t.substr(last)


static func summon_spells(sname: String) -> Array:
	var info: Dictionary = SUMMONS.get(sname, SUMMONS["Loup Spectral"])
	var sp: Array = info["spell"]
	if sp.is_empty():
		return []
	var eff: String = ("%d dégâts" % maxi(1, roundi(float(sp[3]) / SUMMON_SPELL_DIV))) if typeof(sp[3]) == TYPE_INT else _scale_effect(str(sp[3]), SUMMON_SPELL_DIV)
	var stype: String = "Attaque"
	if eff.contains("restaure"):
		stype = "Soin"
	elif eff.begins_with("+"):
		stype = "Buff"
	return [_mk(str(sp[0]), int(sp[1]), int(sp[2]), eff, stype)]
