extends SceneTree
## V377 : rendu à la résolution de l'écran (canvas_items) en qualité Haute, étirement classique en Économie.
var fails: int = 0
func ck(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1
func _init() -> void:
	_run.call_deferred()
func _run() -> void:
	await process_frame
	var gs: Node = root.get_node("GameSettings")
	var keep: int = gs.graphics_quality
	gs.graphics_quality = 2
	gs.apply_render_scale()
	ck(root.content_scale_mode == Window.CONTENT_SCALE_MODE_CANVAS_ITEMS, "qualité Haute : rendu à la résolution de l'écran")
	var vr: Vector2 = root.get_visible_rect().size
	gs.graphics_quality = 1
	gs.apply_render_scale()
	ck(root.content_scale_mode == Window.CONTENT_SCALE_MODE_VIEWPORT, "qualité Économie : rendu 1080p étiré")
	ck(is_equal_approx(root.get_visible_rect().size.y, vr.y), "la mise en page garde la même hauteur de référence (%d)" % int(vr.y))
	ck(is_equal_approx(root.scaling_3d_scale, 1.0) or OS.has_feature("mobile"), "hors mobile : 3D à pleine résolution")
	gs.graphics_quality = keep
	gs.apply_render_scale()
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
