class_name Portraits
extends RefCounted
## Portraits.gd — Cache de textures pour l'interface (timeline, panneau du personnage actif).

static var _cache: Dictionary = {}


static func get_texture(entity: Dictionary) -> Texture2D:
	var cname: String = String(entity.get("classe", "")).to_lower()
	var folders: Array[String] = ["enemies", "players"]
	if entity.get("team", "") == "player":
		folders = ["players", "enemies"]
	if entity.get("entity_type", "") == "Summon":
		folders = ["enemies", "players"]
	var key: String = "%s|%s" % [folders[0], cname]
	if _cache.has(key):
		return _cache[key]
	var tex: Texture2D = null
	for folder: String in folders:
		for ext: String in ["png", "svg"]:
			var path: String = "res://assets/sprites/%s/%s.%s" % [folder, cname, ext]
			if tex == null and ResourceLoader.exists(path):
				var res: Resource = load(path)
				if res is Texture2D:
					tex = res
	_cache[key] = tex
	return tex


## Zone carrée du haut du sprite (visage) pour les portraits.
static func head_region(tex: Texture2D) -> Rect2:
	var w: float = float(tex.get_width())
	var h: float = float(tex.get_height())
	var side: float = minf(w, h * 0.8)
	return Rect2((w - side) * 0.5, h * 0.02, side, side)
