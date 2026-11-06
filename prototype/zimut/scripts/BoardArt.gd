class_name BoardArt
extends RefCounted
## BoardArt.gd — Planches illustrées du mode 2D (V83, TEST).
##
## Une « planche » remplace le biome généré par code : une illustration de la zone sert de décor ;
## la logique reste celle de la grille (déplacement, monstres, lieux, sauvegarde). Chaque planche =
## data/boards/<zone>.json : masque des cases jouables, départ, lieux (entrées de donjon incluses).
## Générée par tools/gen_board.py à partir de l'illustration.
##
## Les planches ne sont actives que dans la carte 2D (`enabled`), jamais dans les vues 3D.

const DIR := "res://data/boards/"
## Échelle de l'illustration dans le monde 2D (pixels du monde par pixel d'illustration).
const IMAGE_SCALE := 2.0
## Dossier des retouches de masque faites en jeu (par zone : cases ouvertes / fermées).
const EDIT_DIR := "user://boards/"

static var enabled: bool = true
static var _defs: Dictionary = {}
static var rev: int = 0   # incrémenté à chaque retouche (invalide le cache du terrain)


## Définition de la planche d'une zone ({} si la zone n'a pas de planche ou si le mode est inactif).
## Autoload GameManager, résolu à l'exécution (voir AdventureTerrain._pm).
static func _gm() -> Node:
	return (Engine.get_main_loop() as SceneTree).root.get_node("GameManager")


static func def(zone_id: String) -> Dictionary:
	if not enabled:
		return {}
	# Actif seulement tant que la partie est dans la carte 2D (y compris pendant un combat lancé d'ici).
	if String(_gm().active_save.get("adventure_view", "")) != "map":
		return {}
	return raw(zone_id)


## Planche à utiliser pour une zone : « foret_sylve » (ancienne planche, conservée en BACKUP) ou
## « foret_sylve_v2 » (nouvelle illustration, par défaut). Réglage : GameSettings.sylvestre_board.
## Les Cimes (V103) : « montagne_pics_v2 » ; en mode « Ancienne », la zone retrouve son décor généré par code.
const ALT_BOARDS := {"foret_sylve": "foret_sylve_v2", "montagne_pics": "montagne_pics_v2"}


static func _variant() -> String:
	var gs: Node = (Engine.get_main_loop() as SceneTree).root.get_node_or_null("GameSettings")
	return "v2" if gs == null else String(gs.get("sylvestre_board"))


static func file_stem(zone_id: String) -> String:
	if not ALT_BOARDS.has(zone_id):
		return zone_id
	var variant: String = _variant()
	if variant == "classic":
		return zone_id
	# V106 : « Iso » = plateau isométrique à étages pour la Sylve ; les autres nations gardent leur planche v2.
	if variant == "iso" and zone_id == "foret_sylve" and FileAccess.file_exists(DIR + "foret_sylve_iso.json"):
		return "foret_sylve_iso"
	return String(ALT_BOARDS[zone_id]) if FileAccess.file_exists(DIR + String(ALT_BOARDS[zone_id]) + ".json") else zone_id


static func raw(zone_id: String) -> Dictionary:
	var stem: String = file_stem(zone_id)
	if _defs.has(stem):
		return _defs[stem]
	var out: Dictionary = {}
	var path: String = DIR + stem + ".json"
	if FileAccess.file_exists(path):
		var f: FileAccess = FileAccess.open(path, FileAccess.READ)
		var parsed: Variant = JSON.parse_string(f.get_as_text())
		if parsed is Dictionary:
			out = parsed
	if not out.is_empty():
		out["base_mask"] = (out["mask"] as Array).duplicate()
		_apply_edits(stem, out)
	_defs[stem] = out
	return out


## Retouches faites en jeu (user://boards/<zone>_edits.json : {"open": ["x,y"…], "close": ["x,y"…]}).
static func _apply_edits(zone_id: String, d: Dictionary) -> void:
	var path: String = EDIT_DIR + zone_id + "_edits.json"   # zone_id = nom de fichier de la planche
	if not FileAccess.file_exists(path):
		return
	var parsed: Variant = JSON.parse_string(FileAccess.open(path, FileAccess.READ).get_as_text())
	if not (parsed is Dictionary):
		return
	var rows: Array = (d["mask"] as Array).duplicate()
	for key: String in ["open", "close"]:
		for k: Variant in (parsed as Dictionary).get(key, []):
			var xy: PackedStringArray = String(k).split(",")
			if xy.size() != 2:
				continue
			var x: int = int(xy[0])
			var y: int = int(xy[1])
			if y < 0 or y >= rows.size() or x < 0 or x >= String(rows[y]).length():
				continue
			var row: String = rows[y]
			rows[y] = row.substr(0, x) + ("#" if key == "open" else ".") + row.substr(x + 1)
	d["mask"] = rows
	d["edits"] = parsed


## Ouvre / ferme une case en mémoire (retouche en jeu) ; le terrain est recalculé.
static func set_cell(zone_id: String, c: Vector2i, walk: bool) -> void:
	var d: Dictionary = raw(zone_id)
	var rows: Array = d.get("mask", [])
	if c.y < 0 or c.y >= rows.size() or c.x < 0 or c.x >= String(rows[c.y]).length():
		return
	var row: String = rows[c.y]
	rows[c.y] = row.substr(0, c.x) + ("#" if walk else ".") + row.substr(c.x + 1)
	rev += 1


## Cases modifiées par rapport au masque généré : {"open": ["x,y"…], "close": ["x,y"…]}.
static func diff(zone_id: String) -> Dictionary:
	var d: Dictionary = raw(zone_id)
	var base: Array = d.get("base_mask", [])
	var cur: Array = d.get("mask", [])
	var opened: Array = []
	var closed: Array = []
	for y: int in range(mini(base.size(), cur.size())):
		var rb: String = base[y]
		var rc: String = cur[y]
		for x: int in range(mini(rb.length(), rc.length())):
			if rb[x] != rc[x]:
				(opened if rc[x] == "#" else closed).append("%d,%d" % [x, y])
	return {"open": opened, "close": closed}


## Enregistre les retouches courantes (user://boards/<zone>_edits.json).
static func save_edits(zone_id: String) -> Dictionary:
	var df: Dictionary = diff(zone_id)
	DirAccess.make_dir_recursive_absolute(EDIT_DIR)
	var f: FileAccess = FileAccess.open(EDIT_DIR + file_stem(zone_id) + "_edits.json", FileAccess.WRITE)
	f.store_string(JSON.stringify(df))
	f.close()
	return df


## Annule toutes les retouches (retour au masque généré).
static func reset_edits(zone_id: String) -> void:
	var d: Dictionary = raw(zone_id)
	d["mask"] = (d.get("base_mask", d["mask"]) as Array).duplicate()
	var path: String = EDIT_DIR + file_stem(zone_id) + "_edits.json"
	if FileAccess.file_exists(path):
		DirAccess.remove_absolute(path)
	rev += 1





## Taille d'une case en pixels du monde 2D.
static func cell_world(zone_id: String) -> float:
	return float(raw(zone_id).get("cell_px", 16)) * IMAGE_SCALE


static func has_board(zone_id: String) -> bool:
	return not raw(zone_id).is_empty()


static func size(zone_id: String) -> Vector2i:
	var d: Dictionary = raw(zone_id)
	return Vector2i(int(d.get("cols", 0)), int(d.get("rows", 0)))


static func start(zone_id: String) -> Vector2i:
	var s: Array = raw(zone_id).get("start", [1, 1])
	return Vector2i(int(s[0]), int(s[1]))


static func walkable_cell(zone_id: String, c: Vector2i) -> bool:
	var rows: Array = raw(zone_id).get("mask", [])
	if c.y < 0 or c.y >= rows.size():
		return false
	var row: String = rows[c.y]
	return c.x >= 0 and c.x < row.length() and row[c.x] == "#"


## Cases non jouables (« voids » du terrain).
static func voids(zone_id: String) -> Dictionary:
	var out: Dictionary = {}
	var sz: Vector2i = size(zone_id)
	for y: int in range(sz.y):
		for x: int in range(sz.x):
			var c := Vector2i(x, y)
			if not walkable_cell(zone_id, c):
				out[c] = true
	return out


## Lieux de la planche, complétés (niveau des donjons d'après leur palier).
static func pois(zone_id: String) -> Dictionary:
	var out: Dictionary = {}
	var src: Dictionary = raw(zone_id).get("pois", {})
	for k: String in src.keys():
		var p: Dictionary = (src[k] as Dictionary).duplicate(true)
		if String(p.get("guardian", "")) != "":
			p["level"] = Dungeons.room_level(String(p["guardian"]), Dungeons.ROOMS)
		out[k] = p
	return out


## Taille de l'illustration dans le monde 2D (pixels).
static func world_size(zone_id: String) -> Vector2:
	var d: Dictionary = raw(zone_id)
	if bool(d.get("iso", false)):
		var cs: float = iso_cs(zone_id)
		var span: float = float(int(d.get("cols", 0)) + int(d.get("rows", 0)))
		return Vector2(span * ISO_TW * cs * 0.5 + 200.0, span * ISO_TH * cs * 0.5 + iso_origin(zone_id).y + 330.0)
	var isz: Array = d.get("image_size", [0, 0])
	return Vector2(float(isz[0]), float(isz[1])) * IMAGE_SCALE



# ══════════════════════════════════════════════════════════════════════
#  V106 — plateau isométrique à étages (« foret_sylve_iso »)
#  Cases de ISO_TW×ISO_TH × cell_scale, hauteur par case en quarts d'étage (`unit`), un étage = ISO_LEVEL_PX.
# ══════════════════════════════════════════════════════════════════════
const ISO_TW := 128.0
const ISO_TH := 64.0
const ISO_LEVEL_PX := 64.0
static var _heights: Dictionary = {}


static func is_iso(zone_id: String) -> bool:
	return bool(raw(zone_id).get("iso", false))


static func iso_cs(zone_id: String) -> float:
	return float(raw(zone_id).get("cell_scale", 0.625))


## Pixels du monde par quart d'étage.
static func iso_unit_px(zone_id: String) -> float:
	return ISO_LEVEL_PX / float(maxi(1, int(raw(zone_id).get("unit", 4))))


## Hauteur de chaque case (quarts d'étage) : { Vector2i: int }.
static func heights(zone_id: String) -> Dictionary:
	var stem: String = file_stem(zone_id)
	var key: String = "%s:%d" % [stem, rev]
	if _heights.has(key):
		return _heights[key]
	var out: Dictionary = {}
	var rows: Array = raw(zone_id).get("heights", [])
	for y: int in range(rows.size()):
		var row: String = rows[y]
		for x: int in range(row.length()):
			var code: int = row.unicode_at(x)
			out[Vector2i(x, y)] = code - 48 if code < 97 else 10 + code - 97
	_heights[key] = out
	return out


static func iso_max_height(zone_id: String) -> int:
	var m: int = 0
	for v: Variant in heights(zone_id).values():
		m = maxi(m, int(v))
	return m


## Origine du monde 2D de la case (0,0) : tout reste en coordonnées positives.
static func iso_origin(zone_id: String) -> Vector2:
	var cs: float = iso_cs(zone_id)
	var rows: int = int(raw(zone_id).get("rows", 0))
	return Vector2(float(rows) * ISO_TW * cs * 0.5 + 100.0, 220.0 + float(iso_max_height(zone_id)) * iso_unit_px(zone_id))


static func iso_pos(zone_id: String, c: Vector2i) -> Vector2:
	var cs: float = iso_cs(zone_id)
	var h: float = float(heights(zone_id).get(c, 0)) * iso_unit_px(zone_id)
	return iso_origin(zone_id) + Vector2(float(c.x - c.y) * ISO_TW * cs * 0.5, float(c.x + c.y) * ISO_TH * cs * 0.5 - h)


## Case sous un point du monde (tient compte des hauteurs : on teste du plus haut au plus bas).
static func iso_cell_at(zone_id: String, w: Vector2) -> Vector2i:
	var cs: float = iso_cs(zone_id)
	var hs: Dictionary = heights(zone_id)
	var d: Vector2 = w - iso_origin(zone_id)
	var up: float = iso_unit_px(zone_id)
	var fallback := Vector2i(-1, -1)
	for hu: int in range(iso_max_height(zone_id), -1, -1):
		var ly: float = d.y + float(hu) * up
		var gx: float = (ly / (ISO_TH * cs * 0.5) + d.x / (ISO_TW * cs * 0.5)) * 0.5
		var gy: float = (ly / (ISO_TH * cs * 0.5) - d.x / (ISO_TW * cs * 0.5)) * 0.5
		var c := Vector2i(roundi(gx), roundi(gy))
		if hu == 0:
			fallback = c
		if int(hs.get(c, -1)) == hu:
			return c
	return fallback
