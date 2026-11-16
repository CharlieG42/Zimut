extends SceneTree
## V371 : étalonnage de l'image en combat (CombatLook) — présent en qualité Haute, absent en Économie.
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
	gs.graphics_quality = 2
	ck(CombatLook.wanted(), "qualité Haute : étalonnage actif")
	gs.graphics_quality = 1
	ck(not CombatLook.wanted(), "qualité Économie : étalonnage coupé")
	var l := CombatLook.new()
	root.add_child(l)
	var g: ColorRect = l.get_node("Grade") as ColorRect
	ck(g != null and g.material is ShaderMaterial, "rectangle plein écran avec shader")
	ck(l.layer == 0 and g.mouse_filter == Control.MOUSE_FILTER_IGNORE, "sous l'interface, ne bloque pas les clics")
	ck((g.material as ShaderMaterial).shader.code.contains("hint_screen_texture"), "le shader lit l'écran")
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
