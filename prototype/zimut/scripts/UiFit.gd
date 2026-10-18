class_name UiFit
## UiFit.gd — agrandit une interface plein écran sur smartphone.
##
## L'écran de référence du jeu fait 1920x1080 (stretch « viewport ») : sur un téléphone,
## tout est réduit d'environ moitié et les petits textes deviennent illisibles. On construit
## donc l'interface sur une surface plus petite (1920/échelle) puis on l'agrandit d'autant :
## textes, icônes et zones tactiles grossissent sans retoucher chaque taille de police.


## Ajuste `root` (Control enfant direct d'un CanvasLayer) et le réajuste si la fenêtre change.
static func apply(root: Control, max_scale: float) -> void:
	if root == null:
		return
	root.set_anchors_preset(Control.PRESET_TOP_LEFT)
	_fit(root, max_scale)
	var vp: Viewport = root.get_viewport()
	if vp != null:
		var cb := func() -> void:
			if is_instance_valid(root):
				_fit(root, max_scale)
		vp.size_changed.connect(cb)
		root.tree_exiting.connect(func() -> void:
			if vp.size_changed.is_connected(cb):
				vp.size_changed.disconnect(cb))


static func _fit(root: Control, max_scale: float) -> void:
	var vs: Vector2 = root.get_viewport().get_visible_rect().size
	# on garde au moins ~1370 px de large utiles pour les mises en page à plusieurs colonnes
	var sc: float = clampf(minf(vs.x / 1370.0, vs.y / 770.0), 1.0, max_scale)
	root.scale = Vector2(sc, sc)
	root.position = Vector2.ZERO
	root.size = vs / sc
