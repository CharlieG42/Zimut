extends SceneTree
## V100 / V153 : héros de la carte 2D = Zimut (modèle 3D) cuit en planche de sprites (8 directions, repos + marche), le même pour toutes les classes.
var fails := 0
func ck(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c: fails += 1

func _init() -> void:
	_run.call_deferred()

func _run() -> void:
	var HV: Variant = load("res://scripts/AdventureMapUI.gd").HeroView
	# 1. planches présentes et de bonne taille
	var p: String = "res://assets/sprites/walk3d/zimut.png"
	var ok: bool = ResourceLoader.exists(p)
	var sz: Vector2i = (load(p) as Texture2D).get_size() if ok else Vector2i.ZERO
	ck(ok and sz == Vector2i(1536, 1280), "planche Zimut : 12 colonnes × 8 directions (%s)" % str(sz))
	for k: String in ["artificier", "assassin", "chasseur", "druide", "geomancien", "heal", "invocateur", "mage", "sylvain", "tank"]:
		ck(not ResourceLoader.exists("res://assets/sprites/walk3d/%s.png" % k), "plus de planche propre à la classe %s" % k)
	# 2. direction : bas, droite, haut, gauche, diagonales
	ck(HV.sheet_dir(Vector2(0, 1)) == 0, "direction bas = 0")
	ck(HV.sheet_dir(Vector2(1, 1)) == 1, "direction bas-droite = 1")
	ck(HV.sheet_dir(Vector2(1, 0)) == 2, "direction droite = 2")
	ck(HV.sheet_dir(Vector2(0, -1)) == 4, "direction haut = 4")
	ck(HV.sheet_dir(Vector2(-1, 0)) == 6, "direction gauche = 6")
	ck(HV.sheet_dir(Vector2(-1, 1)) == 7, "direction bas-gauche = 7")
	# 3. colonnes : repos 0-3, marche 4-11
	ck(HV.sheet_col(false, false, 0.0, 0.0) < 4, "à l'arrêt : colonne de repos")
	var cols: Dictionary = {}
	for i: int in range(40):
		var c: int = HV.sheet_col(true, false, float(i) * 0.05, 0.0)
		cols[c] = true
		if c < 4 or c > 11:
			ck(false, "marche hors plage : %d" % c)
	ck(cols.size() == 8, "la marche parcourt 8 images (%d)" % cols.size())
	# 4. HeroView : planche chargée et dessin sans erreur
	var gs: Node = root.get_node("GameSettings")
	ck(bool(gs.get("adventure_walk_sprites")), "réglage actif par défaut")
	var sheets: Dictionary = {}
	for cls: String in ["mage", "tank", "chasseur", "sylvain", "artificier"]:
		var hc: Node2D = HV.new()
		hc.tex = load("res://assets/sprites/players/%s.png" % cls)
		root.add_child(hc)
		await process_frame
		ck(hc.sheet != null, "classe %s : le héros charge une planche" % cls)
		sheets[hc.sheet.resource_path] = true
		hc.queue_free()
	ck(sheets.size() == 1 and sheets.has(p), "toutes les classes partagent la planche de Zimut")
	var hv: Node2D = HV.new()
	hv.tex = load("res://assets/sprites/players/mage.png")
	root.add_child(hv)
	await process_frame
	hv.locomotion(Vector2(1, 0.2), true)
	await process_frame
	await process_frame
	ck(hv.walking and hv.sheet != null, "marche : dessin avec la planche")
	hv.queue_free()
	gs.set("adventure_walk_sprites", false)
	var hv2: Node2D = HV.new()
	hv2.tex = load("res://assets/sprites/players/mage.png")
	root.add_child(hv2)
	await process_frame
	ck(hv2.sheet == null, "réglage « Illustrés » : pas de planche (anciens sprites)")
	gs.set("adventure_walk_sprites", true)
	hv2.queue_free()
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
