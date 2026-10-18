extends SceneTree
## V20 : boss des nations (sprites détourés + titres) et boutons traduisibles de « Mes Parties ».
## Lancement : godot --headless --path . -s tests/test_boss_sprites.gd
var fails: int = 0
func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	await process_frame
	for biome: String in Nations.ORDER:
		var tex: Texture2D = Nations.boss_texture(biome)
		check(tex != null and tex.get_height() >= 200, "%s : sprite de boss (%s)" % [biome, str(tex.get_size()) if tex != null else "absent"])
		check(Nations.boss_title(biome) != "", "%s : titre « %s »" % [biome, Nations.boss_title(biome)])
		var ent: Dictionary = {"team": "enemy", "boss": true, "classe": "X", "nation_boss": biome}
		check(Nations.enemy_texture(ent, biome) == tex, "%s : le boss de nation utilise son sprite" % biome)
	# Boutons illustrés sans texte cuit
	for k: String in ["team", "chars", "forge", "governors", "rename", "delete"]:
		check(ResourceLoader.exists("res://assets/ui/actions/plain_%s.png" % k), "plaque sans texte : " + k)
	var en: String = FileAccess.get_file_as_string("res://data/i18n/en.txt")
	for t: String in ["Gérer l'équipe\t", "Personnages\t", "Gouverneurs\t", "Renommer\t", "Supprimer\t"]:
		check(en.contains("\n" + t), "traduction : " + t.strip_edges())
	print("\n%s — %d échec(s)" % ["OK" if fails == 0 else "KO", fails])
	quit(1 if fails > 0 else 0)
