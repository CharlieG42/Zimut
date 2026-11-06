extends SceneTree
## Journal des nouveautés en un fichier par version : fusion et comparaison numérique.
var fails := 0
func ck(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c: fails += 1

func _init() -> void:
	_run.call_deferred()

func _run() -> void:
	var r: Dictionary = Changelog.merge_latest(["V98|a\nV98|b\nV9|c", "V100|x\nV100|y\nV100|z\nV99|w"])
	ck(r["id"] == "V100" and r["lines"].size() == 3, "V100 > V99 (comparaison numérique), 3 lignes")
	var r2: Dictionary = Changelog.merge_latest(["V5|a\nV5|b", "V5|c"])
	ck(r2["id"] == "V5" and r2["lines"].size() == 3, "lignes d'une même version fusionnées entre fichiers")
	ck(Changelog.merge_latest([]).is_empty() and Changelog.merge_latest(["rien\n\n"]).is_empty(), "sans entrée : vide")
	var c: Dictionary = Changelog.latest()
	ck(not c.is_empty() and c["lines"].size() >= 3, "journal réel lu (%s)" % str(c.get("id", "")))
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
