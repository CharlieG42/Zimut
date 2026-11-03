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
## Taille d'une case, en pixels du monde 2D (l'illustration est mise à l'échelle en conséquence).
const CELL_WORLD := 48.0

static var enabled: bool = true
static var _defs: Dictionary = {}


## Définition de la planche d'une zone ({} si la zone n'a pas de planche ou si le mode est inactif).
static func def(zone_id: String) -> Dictionary:
	if not enabled:
		return {}
	# Actif seulement tant que la partie est dans la carte 2D (y compris pendant un combat lancé d'ici).
	if String(GameManager.active_save.get("adventure_view", "")) != "map":
		return {}
	return raw(zone_id)


static func raw(zone_id: String) -> Dictionary:
	if _defs.has(zone_id):
		return _defs[zone_id]
	var out: Dictionary = {}
	var path: String = DIR + zone_id + ".json"
	if FileAccess.file_exists(path):
		var f: FileAccess = FileAccess.open(path, FileAccess.READ)
		var parsed: Variant = JSON.parse_string(f.get_as_text())
		if parsed is Dictionary:
			out = parsed
	_defs[zone_id] = out
	return out


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
	var cell_px: float = float(d.get("cell_px", 24))
	return Vector2(float(d.get("cols", 0)), float(d.get("image_size", [0, 0])[1] / cell_px)) * CELL_WORLD
