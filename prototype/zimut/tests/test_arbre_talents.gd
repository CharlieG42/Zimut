extends SceneTree
## Arbre de talents en vrai arbre : structure (parents), états des nœuds, disposition sans chevauchement.
## Lancement : godot --headless --path . -s tests/test_arbre_talents.gd
var fails: int = 0
func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var View: GDScript = load("res://scripts/TalentTreeView.gd")
	var ids: Array[String] = TalentTree.all_ids()
	var lay: Dictionary = View.LAYOUT
	check(lay.size() == ids.size(), "un nœud par talent (%d)" % ids.size())
	var par_ok: bool = true
	for id: String in ids:
		if not lay.has(id) or not TalentTree.PARENT.has(id):
			par_ok = false
		var p: String = TalentTree.parent_of(id)
		if p != "" and (not ids.has(p) or String(TalentTree.talent_info(p)["branch"]) != String(TalentTree.talent_info(id)["branch"])):
			par_ok = false
	check(par_ok, "chaque talent a une position et un parent de la même branche")
	var roots: Dictionary = {}
	for id2: String in ids:
		if TalentTree.parent_of(id2) == "":
			roots[String(TalentTree.talent_info(id2)["branch"])] = true
	check(roots.size() == 4, "une racine par branche")
	# données
	var d: Dictionary = {"roster": {"Mage": {"level": 40, "talents": {"unlocked": {}, "points": 3}}}}
	var v: Control = View.new()
	v.size = Vector2(1100, 372)
	v.setup(d, "Mage")
	check(v.state("off_veteran") == "available", "racine débloquable : disponible")
	check(v.state("off_critique") == "locked", "enfant dont le parent n'est pas pris : verrouillé")
	check(v.state("off_fury") == "locked", "off_fury verrouillé tant que le Vétéran n'est pas pris")
	check(TalentTree.spend_point(d, "Mage", "off_veteran"), "Vétéran débloqué")
	check(not TalentTree.spend_point(d, "Mage", "off_master"), "Maître d'armes refusé (il faut Coup critique)")
	v.setup(d, "Mage")
	check(v.state("off_veteran") == "unlocked", "nœud débloqué")
	check(v.state("off_critique") == "available", "parent pris + points suffisants : disponible")
	check(v.state("off_fury") == "short", "parent pris mais 3 points requis (il en reste 2) : points insuffisants")
	check(v.state("off_master") == "locked", "petit-enfant verrouillé")
	# pas de chevauchement des capsules
	var overlap: bool = false
	for a: String in ids:
		for b: String in ids:
			if a < b and v._node_rect(a).intersects(v._node_rect(b)):
				overlap = true
	check(not overlap, "aucun nœud ne chevauche un autre (cadre 1100 × 372)")
	var inside: bool = true
	for a2: String in ids:
		if not Rect2(Vector2.ZERO, v.size).encloses(v._node_rect(a2)):
			inside = false
	check(inside, "tous les nœuds sont dans le cadre")
	v.free()
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
