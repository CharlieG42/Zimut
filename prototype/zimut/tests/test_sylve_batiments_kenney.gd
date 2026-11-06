extends SceneTree
## V107 — bâtiments de la Sylve iso : sprites cuits depuis les kits Kenney (tools/bake_kenney.gd).
var fails: int = 0
func check(c: bool, m: String) -> void:
	if not c:
		fails += 1
		print("ÉCHEC : ", m)
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var table: Variant = JSON.parse_string(FileAccess.get_file_as_string("res://data/batiments_kenney.json"))
	check(table is Dictionary, "table des sprites chargée")
	var kinds: Array[String] = ["maison", "chaumiere", "grange", "moulin", "tour", "chapelle"]
	var BN: Script = load("res://scripts/AdventureMapUI.gd")
	for k: String in kinds:
		for seed_v: int in [0, 1, 2, 3]:
			var nm: String = BN.BuildingNode.kenney_sprite(k, seed_v)
			check(nm != "", "%s (graine %d) a un sprite Kenney" % [k, seed_v])
			if nm != "":
				var m: Dictionary = table[nm]
				for f: String in ["ref", "ax", "ay", "w", "h"]:
					check(m.has(f) and float(m[f]) > 0.0, "%s : champ %s" % [nm, f])
				var tex: Texture2D = load("res://assets/sprites/decor/kenney/batiments/%s.png" % nm) as Texture2D
				check(tex != null and tex.get_width() == int(m["w"]) and tex.get_height() == int(m["h"]), "%s : image cohérente avec la table" % nm)
	check(BN.BuildingNode.kenney_sprite("inconnu", 0) == "", "type inconnu : repli sur le dessin en code")
	print("ÉCHECS : %d" % fails)
	quit(fails)
