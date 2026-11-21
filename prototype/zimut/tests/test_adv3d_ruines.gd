extends SceneTree
## V437 — Ruines à facettes de la Sylve : présentes en Forêt, absentes ailleurs, hors sentiers, lumières bornées, allégées en « Économie ».
var _fails: int = 0
func ck(c: bool, m: String) -> void:
	if c:
		print("  ok  ", m)
	else:
		print("  ÉCHEC  ", m)
		_fails += 1
func _init() -> void:
	_run.call_deferred()
func _stats(w: Node3D) -> Array:
	var inst: int = 0
	var lights: int = 0
	var r: Node = w.get_node_or_null("Ruines")
	if r != null:
		for n: Node in r.get_children():
			if n is MultiMeshInstance3D:
				inst += (n as MultiMeshInstance3D).multimesh.instance_count
			elif n is OmniLight3D:
				lights += 1
	return [inst, lights]
func _run() -> void:
	var W: GDScript = load("res://scripts/adventure3d/Adv3DWorld.gd")
	var R: GDScript = load("res://scripts/adventure3d/Adv3DRuins.gd")
	var gs: Node = root.get_node("GameSettings")
	var before_q: int = int(gs.graphics_quality)
	gs.graphics_quality = 2
	var hi: Node3D = W.build("foret_sylve", true)
	var s_hi: Array = _stats(hi)
	ck(int(s_hi[0]) >= 40, "Sylve : ruines posées (%d pièces)" % int(s_hi[0]))
	ck(int(s_hi[1]) >= 1 and int(s_hi[1]) <= int(R.MAX_LIGHTS), "feux éclairants bornés (%d)" % int(s_hi[1]))
	ck(hi.get_node_or_null("Ruines/Ruines_flammes") != null, "flammes émissives présentes")
	hi.free()
	gs.graphics_quality = 1
	var lo: Node3D = W.build("foret_sylve", true)
	var s_lo: Array = _stats(lo)
	ck(int(s_lo[1]) == 0, "Économie : aucune lumière de feu")
	ck(int(s_lo[0]) > 0 and int(s_lo[0]) < int(s_hi[0]), "Économie : moins de pièces (%d < %d)" % [int(s_lo[0]), int(s_hi[0])])
	lo.free()
	ck(not R.enabled("Brasier") and not R.enabled("Désert") and R.enabled("Forêt"), "réservé à la Forêt pour le prototype")
	gs.graphics_quality = before_q
	print("OK : tous les tests passent." if _fails == 0 else "ÉCHEC : %d" % _fails)
	quit(1 if _fails > 0 else 0)
