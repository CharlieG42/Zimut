class_name UiFit
## UiFit.gd — agrandit une interface plein écran pour la rendre lisible sur smartphone.
##
## L'écran de référence du jeu fait 1920x1080 (stretch « viewport ») : sur un téléphone,
## tout est réduit d'environ moitié et les petits textes deviennent illisibles. On construit
## donc l'interface sur une surface plus petite (1920/échelle) puis on l'agrandit d'autant :
## textes, icônes et zones tactiles grossissent sans retoucher chaque taille de police.
##
## échelle = base x réglage « Taille du texte » (Options), plafonnée pour que la surface
## utile reste d'au moins min_size (sinon la mise en page à colonnes ne tient plus).


## Ajuste `root` (Control plein écran) et le réajuste si la fenêtre ou le réglage change.
static func apply(root: Control, base_scale: float, min_size: Vector2 = Vector2(1250, 700)) -> void:
	if root == null:
		return
	root.set_anchors_preset(Control.PRESET_TOP_LEFT)
	_fit(root, base_scale, min_size)
	var cb := func() -> void:
		if is_instance_valid(root) and root.is_inside_tree():
			_fit(root, base_scale, min_size)
	var vp: Viewport = root.get_viewport()
	if vp != null:
		vp.size_changed.connect(cb)
	var gs: Node = _settings()
	if gs != null:
		gs.connect("settings_changed", cb)
	root.tree_exiting.connect(func() -> void:
		if vp != null and vp.size_changed.is_connected(cb):
			vp.size_changed.disconnect(cb)
		if gs != null and gs.is_connected("settings_changed", cb):
			gs.disconnect("settings_changed", cb))


## Échelle effective pour une interface (utile aux écrans qui gèrent leur propre mise en page).
static func scale_for(vs: Vector2, base_scale: float, min_size: Vector2 = Vector2(1250, 700)) -> float:
	var want: float = base_scale * user_mult()
	var cap: float = minf(vs.x / min_size.x, vs.y / min_size.y)
	return maxf(1.0, minf(want, cap))


## Réglage « Taille du texte » (1.0 si l'autoload n'est pas disponible).
static func user_mult() -> float:
	var gs: Node = _settings()
	return float(gs.call("text_mult")) if gs != null else 1.0


static func _settings() -> Node:
	var tree := Engine.get_main_loop() as SceneTree
	return tree.root.get_node_or_null("GameSettings") if tree != null else null


static func _fit(root: Control, base_scale: float, min_size: Vector2) -> void:
	var vs: Vector2 = root.get_viewport().get_visible_rect().size
	var sc: float = scale_for(vs, base_scale, min_size)
	root.scale = Vector2(sc, sc)
	root.position = Vector2.ZERO
	root.size = vs / sc
