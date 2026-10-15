class_name SpellIcons
extends RefCounted
## SpellIcons.gd — Icône propre à chaque sort (data/spell_icons.txt : « Nom du sort,id d'icône »).
## Les icônes sont générées par tools/gen_icons.py et tools/gen_summon_icons.py dans
## assets/icons/spells/ (SVG ou PNG). Un même sort porte la même icône pour toutes les classes ;
## les sorts de même nature (soins, tirs, boucliers...) en partagent le motif.

static var _map: Dictionary = {}
static var _loaded: bool = false
static var _cache: Dictionary = {}


static func _load() -> void:
	_loaded = true
	var f := FileAccess.open("res://data/spell_icons.txt", FileAccess.READ)
	if f == null:
		return
	var first: bool = true
	while not f.eof_reached():
		var line: String = f.get_line().strip_edges()
		if first:
			first = false
			continue
		var i: int = line.rfind(",")
		if i > 0:
			_map[line.substr(0, i)] = line.substr(i + 1)
	f.close()


## Identifiant d'icône d'un sort ("" si inconnu).
static func icon_id(spell_name: String) -> String:
	if not _loaded:
		_load()
	return String(_map.get(spell_name, ""))


## Texture (64x64) de l'icône d'un sort, ou null.
static func texture_for(spell_name: String) -> Texture2D:
	var id: String = icon_id(spell_name)
	if id == "":
		return null
	if _cache.has(id):
		return _cache[id]
	var tex: Texture2D = null
	for ext: String in ["png", "svg"]:
		var path: String = "res://assets/icons/spells/%s.%s" % [id, ext]
		if ResourceLoader.exists(path):
			tex = load(path) as Texture2D
			break
	_cache[id] = tex
	return tex
