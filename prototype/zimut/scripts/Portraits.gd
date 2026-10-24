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
	if entity.get("team", "") == "enemy":
		var biome: String = EntityView._current_biome()
		var ntex: Texture2D = Nations.enemy_texture(entity, biome)
		if ntex != null:
			return ntex
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
	if tex.resource_path.contains("/players/"):
		# V31 : la tête est cherchée au-dessus du corps (les bâtons dépassent souvent au-dessus)
		var hb: Vector3 = _head_box(tex)
		# Têtes chibi (dont les nouveaux sprites Mistral) : zone plus large pour ne pas couper le menton,
		# et marge au-dessus pour les cheveux / casques.
		side = minf(minf(w, h), maxf(h * 0.40, hb.z * 1.3))
		return Rect2(clampf(hb.x - side * 0.5, 0.0, w - side), clampf(hb.y - side * 0.10, 0.0, h - side), side, side)
	if w > h * 1.1:
		# Sprites larges (tortue, loup, centaure) : la tête est à droite, carré calé sur le haut/droite
		side = minf(w, h * 0.95)
		return Rect2((w - side) * 0.9, 0.0, side, side)
	return Rect2((w - side) * 0.5, h * 0.02, side, side)


static var _head_cache: Dictionary = {}


## (centre x, haut de la tête y, taille conseillée) en pixels de texture.
static func _head_box(tex: Texture2D) -> Vector3:
	var key: String = tex.resource_path
	if _head_cache.has(key):
		return _head_cache[key]
	var w: float = float(tex.get_width())
	var h: float = float(tex.get_height())
	var out := Vector3(w * 0.5, 0.0, h * 0.6)
	var img: Image = tex.get_image()
	if img != null:
		if img.is_compressed():
			img.decompress()
		var iw: int = img.get_width()
		var ih: int = img.get_height()
		var sum: float = 0.0
		var n: int = 0
		for y: int in range(int(ih * 0.5), ih, 3):
			for x: int in range(0, iw, 3):
				if img.get_pixel(x, y).a > 0.5:
					sum += float(x)
					n += 1
		var cx: float = sum / float(n) if n > 0 else float(iw) * 0.5
		var x0: int = maxi(0, int(cx - iw * 0.12))
		var x1: int = mini(iw, int(cx + iw * 0.12))
		var top: int = 0
		for y2: int in range(ih):
			var cnt: int = 0
			for x2: int in range(x0, x1):
				if img.get_pixel(x2, y2).a > 0.5:
					cnt += 1
			if cnt > maxi(3, int((x1 - x0) * 0.25)):
				top = y2
				break
		var sx: float = w / float(iw)
		out = Vector3(cx * sx, float(top) * sx, (float(ih) - float(top)) * 0.42 * sx)
	_head_cache[key] = out
	return out
