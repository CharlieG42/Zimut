extends Node
## AssetCache.gd — Cache centralisé de textures (V42).
##
## Évite les appels répétés à load() dans les boucles d'UI.
## Précharge les textures fréquentes au démarrage et fournit un accès O(1).
##
## Usage : AssetCache.texture("res://assets/sprites/players/tank.png")

var _cache: Dictionary = {}
var _missing: Dictionary = {}  # chemins notés comme absents (évite les re-tests)


## Retourne la texture (Texture2D) ou null si introuvable.
func texture(path: String) -> Texture2D:
	if _cache.has(path):
		return _cache[path]
	if _missing.has(path):
		return null
	if not ResourceLoader.exists(path):
		_missing[path] = true
		return null
	var res: Resource = load(path)
	if res is Texture2D:
		_cache[path] = res
		return res
	_missing[path] = true
	return null


## Précharge une liste de chemins (utile au démarrage).
func preload_paths(paths: Array) -> void:
	for p: String in paths:
		texture(p)


## Vide le cache (utile en debug).
func clear() -> void:
	_cache.clear()
	_missing.clear()


## Nombre de textures en cache.
func size() -> int:
	return _cache.size()
