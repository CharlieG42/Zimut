extends SceneTree
## Test : chaque sort du jeu (sorts.txt + sorts de monstres/invocations) possède une icône chargeable.
var fails: int = 0
func check(c: bool, m: String) -> void:
	if not c:
		print("  ÉCHEC  " + m)
		fails += 1
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var f := FileAccess.open("res://data/sorts.txt", FileAccess.READ)
	var names: Array[String] = []
	var first: bool = true
	while not f.eof_reached():
		var line: String = f.get_line()
		if first:
			first = false
			continue
		var c: PackedStringArray = line.split(",")
		if c.size() > 1 and not names.has(c[1].strip_edges()):
			names.append(c[1].strip_edges())
	for extra in ["Morsure", "Coup d'os", "Coup de massue", "Hurlement", "Jet de dague", "Pluie de dagues", "Poing de pierre", "Souffle de feu", "Tir d'os", "Trait spectral", "Attaque", "Bras de bois", "Carapace", "Chant marin", "Flèche de centaure", "Fouet de ronce", "Fouet de sarriette", "Lumière", "Piqué", "Spores toxiques", "Sève fertilisante"]:
		names.append(extra)
	var ids: Dictionary = {}
	for n: String in names:
		var tex: Texture2D = SpellIcons.texture_for(n)
		check(tex != null, "icône manquante pour « %s » (id %s)" % [n, SpellIcons.icon_id(n)])
		ids[SpellIcons.icon_id(n)] = true
	print("  %d sorts, %d icônes distinctes" % [names.size(), ids.size()])
	check(ids.size() >= 100, "au moins 100 icônes distinctes (%d)" % ids.size())
	check(SpellIcons.icon_id("Soin de groupe") == SpellIcons.icon_id("Soin de groupe"), "même nom = même icône entre classes")
	check(SpellIcons.icon_id("Boule de feu") != SpellIcons.icon_id("Éclair"), "sorts différents = icônes différentes")
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
