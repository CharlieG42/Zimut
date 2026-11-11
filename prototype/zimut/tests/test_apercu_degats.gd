extends SceneTree
## V152 : aperçu des dégâts en fourchette (min~max) — les dégâts réels restent dans la fourchette.
var fails: int = 0
func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var gm: Node = root.get_node("GameManager")
	await process_frame
	gm.active_save = {"difficulty": 1}
	gm.set_custom_team([{"classe": "Tank"}, {"classe": "Mage"}, {"classe": "Heal"}])
	gm.init_grid()
	gm.init_entities()
	var mage: Dictionary = {}
	for p: Dictionary in gm.players:
		if String(p.get("classe", "")) == "Mage":
			mage = p
	var foe: Dictionary = gm.enemies[0]
	var spell: Dictionary = {}
	for s: Dictionary in mage["spells"]:
		if Combat.parse(s)["kind"] == "attack" and float(Combat.parse(s)["dmg"]) > 0.0:
			spell = s
			break
	check(not spell.is_empty(), "sort offensif trouvé (%s)" % String(spell.get("name", "?")))
	var r: Vector2i = gm.estimate_damage_range(mage, spell, foe)
	var est: int = gm.estimate_damage(mage, spell, foe)
	check(r.x > 0 and r.x < r.y, "fourchette %d~%d" % [r.x, r.y])
	check(est >= r.x and est <= r.y, "l'estimation moyenne (%d) est dans la fourchette" % est)
	var p2: Dictionary = Combat.parse(spell)
	var lo: int = 1 << 30
	var hi: int = 0
	var out: int = 0
	for _i: int in range(400):
		var d: int = int(Combat.calc_damage(mage, foe, float(p2["dmg"]), String(p2["dtype"]), float(p2["ignore_def"]), false, false)["dmg"])
		lo = mini(lo, d)
		hi = maxi(hi, d)
		if d < r.x - 1 or d > r.y + 1:
			out += 1
	check(out == 0, "400 coups réels dans la fourchette (vus %d~%d)" % [lo, hi])
	# Immunité : rien à afficher
	foe["statuses"] = [{"id": "immune", "turns": 1, "value": 1.0}]
	check(gm.estimate_damage_range(mage, spell, foe) == Vector2i.ZERO, "cible immunisée : pas de dégâts")
	foe["statuses"] = []
	# Texte d'aperçu
	var GM: GDScript = load("res://scripts/GridManager.gd")
	check(GM.damage_preview_text(Vector2i(40, 60), 100) == "-40~60", "texte « -40~60 »")
	check(GM.damage_preview_text(Vector2i(40, 60), 50) == "-40~60  KO ?", "KO possible seulement au maximum")
	check(GM.damage_preview_text(Vector2i(40, 60), 30) == "-40~60  KO", "KO assuré")
	check(GM.damage_preview_text(Vector2i(25, 25), 100) == "-25", "valeur unique sans fourchette")
	print("ÉCHECS : ", fails)
	quit(0 if fails == 0 else 1)
