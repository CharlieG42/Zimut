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
	check(ambient.contains('"kind": "firefly" if is_firefly else "leaf"'), "la forêt mélange feuilles dérivantes et lucioles discrètes")
	check(ambient.contains('draw_circle(c, r * 4.2, Color(glow.r, glow.g, glow.b') and ambient.contains('Color(1.0, 0.94, 0.52)'), "les lucioles ont un halo doux et localisé")
	check(ambient.contains('_effect_kind = Nations.ambient(_biome)'), "le type d’ambiance est résolu à la configuration")
	check(ambient.contains('var st: String = _effect_kind'), "la boucle d’animation réutilise le type d’ambiance mis en cache")
	check(ambient.contains('if st == "leaves" and String(pt.get("kind", "leaf")) == "firefly"'), "les lucioles ont une trajectoire dédiée")
	check(ambient.contains('var depth_speed: float = float(pt["v"]) * float(pt.get("depth", 1.0))'), "la profondeur module aussi la vitesse des particules")
	check(adventure.contains("var idle_breath: float = sin(_t * 1.9)"), "le héros Aventure reçoit une respiration discrète au repos")
	check(adventure.contains("var breathe: float = 1.0 + sin(phase)"), "les monstres ont une respiration différenciée")
	check(adventure.contains("var bob: float = sin(phase) * (2.2 if i == 0 else 2.8)"), "les monstres ont un léger mouvement vertical indépendant")
	check(adventure.contains('walk_variants = _load_pose_variants(base + "_walk", false)'), "les variantes de marche des monstres sont chargées lorsqu'elles existent")
	check(adventure.contains("func begin_walk()") and adventure.contains("func end_walk()"), "les monstres disposent d'un état de déplacement explicite")
	check(adventure.contains('mob_tween.tween_callback(Callable(mn, "end_walk"))'), "la pose de marche s'arrête à la fin du déplacement")
	check(adventure.contains("if not walk_pool.is_empty()"), "l'absence de pose de marche conserve un repli sur le sprite de base")
	check(adventure.contains("var ground_radius: float = 48.0 if is_dungeon else 34.0"), "les POI ont une assise au sol adaptée à leur type")
	check(adventure.contains("draw_arc(Vector2.ZERO, ground_radius - 3.0"), "les POI disposent d'un anneau de matière au sol")
	# Lucioles de la planche : elles couvrent toute l'image (pas la grille isométrique) et restent visibles.
	var amb := SceneryAmbient.new()
	amb.configure_board(Vector2(3072.0, 1728.0), "Forêt", 5)
	check(amb.particle_count() >= 40, "la planche illustrée a assez de particules d'ambiance (%d)" % amb.particle_count())
	var in_rect: bool = true
	var fireflies: int = 0
	for pt: Dictionary in amb._parts:
		if absf(float(pt["x"])) > 1536.0 or absf(float(pt["y"])) > 864.0:
			in_rect = false
		if String(pt["kind"]) == "firefly":
			fireflies += 1
	check(in_rect, "les particules de la planche sont réparties sur toute l'image")
	check(fireflies >= 12, "la planche illustrée compte plusieurs lucioles (%d)" % fireflies)
	amb.free()
	check(adventure.contains("plate.z_index = 1320") and adventure.contains("_joystick.z_index = 1322"),
		"l'interface de la planche reste au-dessus des nœuds de profondeur du monde")
	check(adventure.contains("Reflet supérieur"), "les médaillons de POI ont un reflet de volume discret")
	check(adventure.contains("draw_polyline(ring, rim_col"), "les médaillons de POI ont un contour sombre et un liseré coloré, avec une silhouette propre à chaque type")
	check(adventure.contains("Ombre portée typographique"), "les noms des POI disposent d'un contraste renforcé")
	check(adventure.contains("pn.set_process(n.visible)"), "les POI non découverts ne rafraîchissent pas leur rendu en continu")
	check(adventure.contains("_modal_canvas.layer = 100"), "les fenêtres de l’Aventure utilisent une couche d’affichage prioritaire")
	check(adventure.contains("_modal_canvas.add_child(dim)"), "les fenêtres modales sont indépendantes du clipping de la carte")
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
