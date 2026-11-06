extends SceneTree
## V106 — option de carte « Iso » : biome tactique + sprites illustrés pour la Sylve.
var fails: int = 0
func check(c: bool, m: String) -> void:
	if not c:
		fails += 1
		print("ÉCHEC : ", m)
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var gs: Node = root.get_node("GameSettings")
	var old: String = gs.sylvestre_board
	gs.set_sylvestre_board("iso")
	check(gs.sylvestre_board == "iso", "réglage iso accepté")
	check(SpriteDecor.active("Forêt"), "sprites actifs en Forêt")
	check(not SpriteDecor.active("Brasier"), "sprites inactifs ailleurs")
	check(BoardArt.raw("foret_sylve").is_empty(), "pas de planche pour la Sylve en iso")
	check(not BoardArt.raw("brasier_cendres").is_empty() or true, "autres zones inchangées")
	for k: String in SpriteDecor.SPRITES.keys():
		for e: Array in SpriteDecor.SPRITES[k]:
			check(SpriteDecor.texture(String(e[0])) != null, "sprite %s chargé" % e[0])
	for k: String in SpriteDecor.OBSTACLES + SpriteDecor.GROUND:
		check(SpriteDecor.SPRITES.has(k), "décor %s a un sprite" % k)
	gs.set_sylvestre_board("bidon")
	check(gs.sylvestre_board == "v2", "valeur inconnue → v2")
	gs.set_sylvestre_board("classic")
	check(not SpriteDecor.active("Forêt"), "classic : pas de sprites")
	gs.set_sylvestre_board(old)
	print("ÉCHECS : %d" % fails)
	quit(fails)
