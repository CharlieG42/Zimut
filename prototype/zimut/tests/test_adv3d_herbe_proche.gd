extends SceneTree
## V132 — Monde 3D : tapis d'herbe rase autour du joueur (dense, à courte portée, absent en « Économie »).
var _fails: int = 0
func ck(c: bool, m: String) -> void:
	if c:
		print("  ok  ", m)
	else:
		print("  ÉCHEC  ", m)
		_fails += 1
func _init() -> void:
	_run.call_deferred()
func _count(world: Node, prefix: String) -> Array:
	var chunks: int = 0
	var inst: int = 0
	var max_range: float = 0.0
	for n in world.find_children(prefix + "*", "MultiMeshInstance3D", true, false):
		if String(n.name).begins_with(prefix + "_"):
			chunks += 1
			inst += (n as MultiMeshInstance3D).multimesh.instance_count
			max_range = maxf(max_range, (n as MultiMeshInstance3D).visibility_range_end)
	return [chunks, inst, max_range]
func _run() -> void:
	var W: GDScript = load("res://scripts/adventure3d/Adv3DWorld.gd")
	var gs: Node = root.get_node("GameSettings")
	var before_q: int = int(gs.graphics_quality)
	gs.graphics_quality = 2
	var world: Node3D = W.build("foret_sylve", true)
	var near: Array = _count(world, "HerbesProches")
	var far: Array = _count(world, "Herbes")
	ck(int(near[0]) > 4 and int(near[1]) > int(far[1]) * 2, "tapis d'herbe rase nettement plus dense que l'herbe haute (%d contre %d)" % [near[1], far[1]])
	ck(float(near[2]) == W.NEAR_GRASS_RANGE and float(near[2]) < float(far[2]), "dessiné seulement près du joueur (%d m contre %d m)" % [int(near[2]), int(far[2])])
	ck(int(near[1]) < 80000, "nombre de touffes borné (%d)" % int(near[1]))
	var shadow_ok: bool = true
	for n in world.find_children("HerbesProches*", "MultiMeshInstance3D", true, false):
		shadow_ok = shadow_ok and (n as MultiMeshInstance3D).cast_shadow == GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	ck(shadow_ok, "l'herbe rase ne projette pas d'ombre")
	var far_inst: int = int(far[1])
	world.free()
	gs.graphics_quality = 1
	var low: Node3D = W.build("foret_sylve", true)
	ck(int(_count(low, "HerbesProches")[1]) == 0, "Économie : pas de tapis d'herbe rase")
	var low_far: int = int(_count(low, "Herbes")[1])
	ck(low_far > 0 and low_far <= far_inst, "Économie : l'herbe haute reste (allégée)")
	low.free()
	gs.graphics_quality = before_q
	print("OK : tous les tests passent." if _fails == 0 else "ÉCHEC : %d" % _fails)
	quit(1 if _fails > 0 else 0)
