extends SceneTree
## Traduction anglaise (V18).
var fails := 0
func ck(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c: fails += 1
func _init() -> void:
	_run.call_deferred()
func _run() -> void:
	var loc: Node = root.get_node("Loc")
	var gs: Node = root.get_node("GameSettings")
	gs.language = "en"
	loc.apply()
	ck(tr("Nouvelle partie") == "New game", "exact : %s" % tr("Nouvelle partie"))
	ck(tr("Niveau %d" % 12) == "Level 12", "modèle : %s" % tr("Niveau 12"))
	ck(tr("Loup forestier Lv3") == "Forest Wolf Lv3", "modèle + nom : %s" % tr("Loup forestier Lv3"))
	ck(tr("60 dégâts magiques") == "60 magic damage", "effet : %s" % tr("60 dégâts magiques"))
	ck(tr("★ Mage") == "★ Mage" and tr("✦ Magie 4") == "✦ Magic 4", "symbole + nombre : %s / %s" % [tr("★ Heal"), tr("✦ Magie 4")])
	ck(tr("Restaure 40 PV") == "Restores 40 HP", "soin : %s" % tr("Restaure 40 PV"))
	ck(tr("Sylve-Cœur · Hameau") == "Heartwood · Hamlet", "segments : %s" % tr("Sylve-Cœur · Hameau"))
	ck(loc.t("PA") == "AP", "Loc.t")
	gs.language = "fr"
	loc.apply()
	ck(tr("Nouvelle partie") == "Nouvelle partie", "retour au français")
	ck(loc.t("PA") == "PA", "Loc.t en français")
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
