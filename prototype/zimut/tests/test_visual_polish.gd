extends SceneTree
## Vérifie les ajouts visuels des étapes 1 et 2 sans dépendre d'une capture d'écran.
var fails: int = 0

func check(ok: bool, message: String) -> void:
	print(("  ok  " if ok else "  ÉCHEC  ") + message)
	if not ok:
		fails += 1

func _init() -> void:
	var ambient: String = FileAccess.get_file_as_string("res://scripts/SceneryAmbient.gd")
	var adventure: String = FileAccess.get_file_as_string("res://scripts/AdventureMapUI.gd")
	check(ambient.contains('"depth": rng.randf_range(0.62, 1.18)'), "les particules d'ambiance possèdent une profondeur visuelle déterministe")
	check(ambient.contains('float(pt.get("depth", 1.0))'), "la profondeur module la taille des particules")
	check(adventure.contains("var idle_breath: float = sin(_t * 1.9)"), "le héros Aventure reçoit une respiration discrète au repos")
	check(adventure.contains("var breathe: float = 1.0 + sin(phase)"), "les monstres ont une respiration différenciée")
	check(adventure.contains("var bob: float = sin(phase) * (2.2 if i == 0 else 2.8)"), "les monstres ont un léger mouvement vertical indépendant")
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
