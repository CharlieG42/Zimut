class_name Builds
extends RefCounted
## Builds.gd — Gestion des builds PAR PERSONNAGE (V42).
##
## Chaque héros possède 3 builds nommables. Un build regroupe :
##   · un équipement complet (10 emplacements, mêmes règles que l'équipement actif)
##   · une sélection de sorts actifs (jusqu'à 10, parmi tous les sorts débloqués
##     par niveau — les niveaux de sort restent ceux du héros, partagés)
##   · un arbre de talents dédié (mêmes règles que l'arbre actif, copie libre)
##
## Le build ACTIF est celui du membre d'équipe (data["team"][i]) : son équipement
## est hero_equipment(), ses talents sont lus via TalentTree, et ses sorts actifs
## sont stockés dans le roster : data["roster"][classe]["active_spells"] = [noms].
##
## Les builds sont stockés dans le roster :
##   data["roster"][classe]["builds"] = [
##     {"name": String, "equipment": {slot: item}, "spells": [name...], "talents": {"unlocked": {}, "points": n}},
##     ... (jusqu'à MAX_BUILDS)
##   ]
##   data["roster"][classe]["build_index"] = 0..MAX_BUILDS-1  (build actif, -1 = équipement libre)

const MAX_BUILDS := 3
## Nombre maximum de sorts actifs dans un build.
const MAX_ACTIVE_SPELLS := 10


## ── Lecture ──

static func _entry(data: Dictionary, classe: String) -> Dictionary:
	if not data.has("roster") or not data["roster"].has(classe):
		return {}
	return data["roster"][classe]


static func _builds(data: Dictionary, classe: String) -> Array:
	var ent: Dictionary = _entry(data, classe)
	if ent.is_empty():
		return []
	if not ent.has("builds"):
		ent["builds"] = []
	return ent["builds"]


## Index du build actif (-1 = équipement/sorts/talents « libres », hors builds).
static func active_index(data: Dictionary, classe: String) -> int:
	var ent: Dictionary = _entry(data, classe)
	if ent.is_empty():
		return -1
	return int(ent.get("build_index", -1))


static func build_count(data: Dictionary, classe: String) -> int:
	return _builds(data, classe).size()


## Le build à l'index i (0-based), ou {} si absent.
static func build_at(data: Dictionary, classe: String, index: int) -> Dictionary:
	var arr: Array = _builds(data, classe)
	if index < 0 or index >= arr.size():
		return {}
	return arr[index]


## ── Création / renommage / suppression ──

## Crée un build (vide ou copie d'un snapshot). Retourne son index ou -1 si plein.
static func create_build(data: Dictionary, classe: String, name: String = "", snapshot: Dictionary = {}) -> int:
	var arr: Array = _builds(data, classe)
	if arr.size() >= MAX_BUILDS:
		return -1
	var b: Dictionary = {
		"name": name if name != "" else ("Build %d" % (arr.size() + 1)),
		"equipment": {},
		"spells": [],
		"talents": {"unlocked": {}, "points": 0},
	}
	if not snapshot.is_empty():
		if snapshot.has("equipment"):
			b["equipment"] = (snapshot["equipment"] as Dictionary).duplicate(true)
		if snapshot.has("spells"):
			b["spells"] = (snapshot["spells"] as Array).duplicate()
		if snapshot.has("talents"):
			b["talents"] = (snapshot["talents"] as Dictionary).duplicate(true)
			if name == "":
				b["name"] = String(snapshot.get("name", b["name"]))
	arr.append(b)
	var ent: Dictionary = _entry(data, classe)
	ent["builds"] = arr
	return arr.size() - 1


static func rename_build(data: Dictionary, classe: String, index: int, name: String) -> void:
	var b: Dictionary = build_at(data, classe, index)
	if b.is_empty() or name.strip_edges() == "":
		return
	b["name"] = name.strip_edges()


static func delete_build(data: Dictionary, classe: String, index: int) -> void:
	var arr: Array = _builds(data, classe)
	if index < 0 or index >= arr.size():
		return
	arr.remove_at(index)
	var ent: Dictionary = _entry(data, classe)
	ent["builds"] = arr
	if active_index(data, classe) == index:
		ent["build_index"] = -1
	elif active_index(data, classe) > index:
		ent["build_index"] = active_index(data, classe) - 1


## ── Sorts actifs ──

## Liste des noms de sorts actifs du build actif (ou du roster si hors build).
static func active_spells(data: Dictionary, classe: String) -> Array:
	var ent: Dictionary = _entry(data, classe)
	if ent.is_empty():
		return []
	var ai: int = active_index(data, classe)
	if ai >= 0:
		var b: Dictionary = build_at(data, classe, ai)
		if not b.is_empty():
			return (b.get("spells", []) as Array).duplicate()
	return (ent.get("active_spells", []) as Array).duplicate()


## Sorts actifs bruts du roster (hors build) — référence persistée.
static func _roster_spells(data: Dictionary, classe: String) -> Array:
	var ent: Dictionary = _entry(data, classe)
	if ent.is_empty():
		return []
	if not ent.has("active_spells"):
		ent["active_spells"] = _default_active_spells(data, classe)
	return ent["active_spells"]


static func _pm() -> Node:
	return (Engine.get_main_loop() as SceneTree).root.get_node("ProgressionManager")


## Premier choix par défaut : les 10 premiers sorts débloqués par niveau.
static func _default_active_spells(data: Dictionary, classe: String) -> Array:
	var ent: Dictionary = _entry(data, classe)
	var lvl: int = int(ent.get("level", 1))
	var out: Array = []
	var unlocked: Array = []
	var pm: Node = _pm()
	for s: Dictionary in pm.spells_of(classe):
		if int(s["level"]) <= lvl:
			unlocked.append(String(s["name"]))
	unlocked.sort_custom(func(a: String, b: String) -> bool:
		return pm.spell_unlock_level(classe, a) < pm.spell_unlock_level(classe, b))
	for n: String in unlocked:
		if out.size() >= MAX_ACTIVE_SPELLS:
			break
		out.append(n)
	return out


## Nombre de sorts actifs (pour l'UI).
static func active_spell_count(data: Dictionary, classe: String) -> int:
	return active_spells(data, classe).size()


## Tous les sorts débloqués par niveau pour ce héros (candidats à la sélection).
static func unlocked_spell_names(data: Dictionary, classe: String) -> Array[String]:
	var ent: Dictionary = _entry(data, classe)
	var lvl: int = int(ent.get("level", 1))
	var out: Array[String] = []
	var pm: Node = _pm()
	for s: Dictionary in pm.spells_of(classe):
		if int(s["level"]) <= lvl:
			out.append(String(s["name"]))
	out.sort_custom(func(a: String, b: String) -> bool:
		return pm.spell_unlock_level(classe, a) < pm.spell_unlock_level(classe, b))
	return out


## Définit la sélection de sorts actifs (max 10, noms valides uniquement).
## Si hors build actif : écrit dans le roster. Sinon : écrit dans le build.
static func set_active_spells(data: Dictionary, classe: String, names: Array) -> void:
	var valid: Array[String] = unlocked_spell_names(data, classe)
	var out: Array = []
	for n: Variant in names:
		var sn: String = String(n)
		if valid.has(sn) and not out.has(sn) and out.size() < MAX_ACTIVE_SPELLS:
			out.append(sn)
	var ent: Dictionary = _entry(data, classe)
	if ent.is_empty():
		return
	var ai: int = active_index(data, classe)
	if ai >= 0:
		var b: Dictionary = build_at(data, classe, ai)
		if not b.is_empty():
			b["spells"] = out
			return
	ent["active_spells"] = out


## Écrit la sélection de sorts DANS un build précis (quel qu'il soit actif ou non).
static func set_active_spells_in_build(data: Dictionary, classe: String, index: int, names: Array) -> void:
	var b: Dictionary = build_at(data, classe, index)
	if b.is_empty():
		return
	var valid: Array[String] = unlocked_spell_names(data, classe)
	var out: Array = []
	for n: Variant in names:
		var sn: String = String(n)
		if valid.has(sn) and not out.has(sn) and out.size() < MAX_ACTIVE_SPELLS:
			out.append(sn)
	b["spells"] = out


static func toggle_spell(data: Dictionary, classe: String, spell_name: String) -> void:
	var cur: Array = active_spells(data, classe)
	if cur.has(spell_name):
		cur.erase(spell_name)
	else:
		if cur.size() >= MAX_ACTIVE_SPELLS:
			return
		if not unlocked_spell_names(data, classe).has(spell_name):
			return
		cur.append(spell_name)
	set_active_spells(data, classe, cur)


## Montée de niveau : les sorts nouvellement débloqués prennent les places LIBRES du build actif
## (jamais à la place d'un sort déjà choisi : au-delà de 10, c'est au joueur de trancher).
static func on_level_up(data: Dictionary, classe: String, from_level: int, to_level: int) -> void:
	var cur: Array = active_spells(data, classe)
	if cur.size() >= MAX_ACTIVE_SPELLS:
		return
	var changed: bool = false
	for n: String in _pm().spells_unlocked_between(classe, from_level, to_level):
		if cur.size() >= MAX_ACTIVE_SPELLS:
			break
		if not cur.has(n):
			cur.append(n)
			changed = true
	if changed:
		set_active_spells(data, classe, cur)


## ── Équipement d'un build ──

## Équipement d'un build (copie) — {} si le build est vide ou absent.
static func build_equipment(data: Dictionary, classe: String, index: int) -> Dictionary:
	var b: Dictionary = build_at(data, classe, index)
	if b.is_empty():
		return {}
	return (b.get("equipment", {}) as Dictionary).duplicate(true)


## Remplace l'équipement d'un build par une copie profonde de `eq`.
static func set_build_equipment(data: Dictionary, classe: String, index: int, eq: Dictionary) -> void:
	var b: Dictionary = build_at(data, classe, index)
	if b.is_empty():
		return
	b["equipment"] = eq.duplicate(true)


## ── Talents d'un build ──

static func build_talents(data: Dictionary, classe: String, index: int) -> Dictionary:
	var b: Dictionary = build_at(data, classe, index)
	if b.is_empty():
		return {"unlocked": {}, "points": 0}
	return (b.get("talents", {"unlocked": {}, "points": 0}) as Dictionary).duplicate(true)


static func set_build_talents(data: Dictionary, classe: String, index: int, talents: Dictionary) -> void:
	var b: Dictionary = build_at(data, classe, index)
	if b.is_empty():
		return
	b["talents"] = talents.duplicate(true)


## ── Activation ──

## Active le build `index` : copie son équipement dans l'équipement du héros,
## sa sélection de sorts dans le roster, et ses talents dans l'arbre actif.
## L'ancien état (avant activation) est sauvegardé dans le build source si
## `from_index >= 0`, sinon il reste dans « équipement libre » (inchangé).
static func activate(data: Dictionary, classe: String, index: int, from_index: int = -1) -> void:
	if index < 0 or index >= build_count(data, classe):
		return
	var ent: Dictionary = _entry(data, classe)
	if ent.is_empty():
		return
	# Sauvegarde l'état courant dans le build d'où l'on vient
	if from_index >= 0 and from_index != index:
		var src: Dictionary = build_at(data, classe, from_index)
		if not src.is_empty():
			src["equipment"] = _pm().hero_equipment(data, classe).duplicate(true)
			src["spells"] = _roster_spells(data, classe).duplicate()
			src["talents"] = _current_talents(data, classe).duplicate(true)
	# Applique le build cible
	var b: Dictionary = build_at(data, classe, index)
	_pm().set_hero_equipment(data, classe, (b.get("equipment", {}) as Dictionary).duplicate(true))
	ent["active_spells"] = (b.get("spells", []) as Array).duplicate()
	ent["talents"] = (b.get("talents", {"unlocked": {}, "points": 0}) as Dictionary).duplicate(true)
	ent["build_index"] = index


## Désactive les builds : l'équipement/sorts/talents actuels restent en place
## (état « libre »), build_index = -1.
static func deactivate(data: Dictionary, classe: String) -> void:
	var ent: Dictionary = _entry(data, classe)
	if ent.is_empty():
		return
	ent["build_index"] = -1


## Talents actuellement actifs (ceux du roster — build actif ou libres).
static func _current_talents(data: Dictionary, classe: String) -> Dictionary:
	var ent: Dictionary = _entry(data, classe)
	if ent.is_empty():
		return {"unlocked": {}, "points": 0}
	if not ent.has("talents"):
		ent["talents"] = {"unlocked": {}, "points": TalentTree.power_for_level(int(ent.get("level", 1)))}
	return ent["talents"]


## ── Migration ──

## Appelé par ensure_roster : ajoute les clés builds/active_spells/build_index
## aux héros existants qui ne les ont pas encore.
static func ensure(data: Dictionary, classe: String) -> void:
	var ent: Dictionary = _entry(data, classe)
	if ent.is_empty():
		return
	if not ent.has("builds"):
		ent["builds"] = []
	if not ent.has("build_index"):
		ent["build_index"] = -1
	if not ent.has("active_spells"):
		ent["active_spells"] = _default_active_spells(data, classe)


## ── Aperçu ──

## Nom d'affichage d'un build (ou « Équipement libre » pour l'index -1).
static func display_name(data: Dictionary, classe: String, index: int) -> String:
	if index < 0:
		return "Équipement libre"
	var b: Dictionary = build_at(data, classe, index)
	if b.is_empty():
		return "Build %d" % (index + 1)
	return String(b.get("name", "Build %d" % (index + 1)))


## Nombre d'objets équipés dans un build.
static func build_gear_count(eq: Dictionary) -> int:
	var n: int = 0
	for v: Variant in eq.values():
		if v is Dictionary and not (v as Dictionary).is_empty():
			n += 1
	return n


## Nombre de talents débloqués dans un arbre de build.
static func build_talent_count(talents: Dictionary) -> int:
	return (talents.get("unlocked", {}) as Dictionary).size()
