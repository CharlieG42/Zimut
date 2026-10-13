class_name Portraits
extends RefCounted
## Portraits.gd — Cache de textures pour l'interface (timeline, panneau du personnage actif).

static var _cache: Dictionary = {}


static func get_texture(entity: Dictionary) -> Texture2D:
	var folders: Array[String] = ["enemies", "players"]
	if entity.get("team", "") == "player":
		folders = ["players", "enemies"]
	if entity.get("entity_type", "") == "Summon":
		folders = ["summons", "enemies", "players"]
	var names: Array[String] = EntityView.skin_names(entity)
	var key: String = "%s|%s" % [folders[0], "/".join(PackedStringArray(names))]
	if _cache.has(key):
		return _cache[key]
	var tex: Texture2D = null
	for nm: String in names:
		for folder: String in folders:
			for ext: String in ["png", "svg"]:
				var path: String = "res://assets/sprites/%s/%s.%s" % [folder, nm, ext]
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
	if w > h * 1.1:
		# Sprites larges (tortue, loup, centaure) : la tête est à droite, carré calé sur le haut/droite
		side = minf(w, h * 0.95)
		return Rect2((w - side) * 0.9, 0.0, side, side)
	return Rect2((w - side) * 0.5, h * 0.02, side, side)
