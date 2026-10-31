extends SceneTree
## Chaque sort d'une classe a sa propre icône (la colonne de sorts du combat n'affiche que les
## icônes : deux sorts identiques y étaient indiscernables). Après l'ajout d'un sort :
## python3 tools/gen_icon_variants.py
var fails: int = 0
func check(c: bool, m: String) -> void:
	if not c:
		print("  ÉCHEC  " + m)
		fails += 1
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var gm: Node = root.get_node("GameManager")
	var pm: Node = root.get_node("ProgressionManager")
	var n: int = 0
	for classe: String in pm.class_names():
		var seen: Dictionary = {}
		for s: Dictionary in gm._build_spells(classe, 100):
			var nm: String = String(s["name"])
			var id: String = SpellIcons.icon_id(nm)
			n += 1
			check(id != "", "%s / %s : aucune icône" % [classe, nm])
			check(SpellIcons.texture_for(nm) != null, "%s / %s : fichier d'icône introuvable (%s)" % [classe, nm, id])
			check(not seen.has(id), "%s : « %s » et « %s » ont la même icône (%s) — lancer tools/gen_icon_variants.py" % [classe, nm, String(seen.get(id, "")), id])
			seen[id] = nm
	print("%d sorts vérifiés" % n)
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
