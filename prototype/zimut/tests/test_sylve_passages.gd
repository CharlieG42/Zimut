extends SceneTree
## V101 : les sentiers du virage du moulin (est) et du potager (sud-ouest) sont praticables de bout en bout.
var fails := 0
func ck(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c: fails += 1

func _init() -> void:
	_run.call_deferred()

func _reach(mask: Array, from: Vector2i, to: Vector2i) -> bool:
	var seen: Dictionary = {from: true}
	var q: Array[Vector2i] = [from]
	while not q.is_empty():
		var c: Vector2i = q.pop_front()
		if c == to:
			return true
		for d: Vector2i in [Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)]:
			var n: Vector2i = c + d
			if n.y >= 0 and n.y < mask.size() and n.x >= 0 and n.x < String(mask[0]).length() and String(mask[n.y])[n.x] == "#" and not seen.has(n):
				seen[n] = true
				q.append(n)
	return false

func _run() -> void:
	var f := FileAccess.open("res://data/boards/foret_sylve_v2.json", FileAccess.READ)
	var d: Dictionary = JSON.parse_string(f.get_as_text())
	var mask: Array = d["mask"]
	var start := Vector2i(int(d["start"][0]), int(d["start"][1]))
	for c: Vector2i in [Vector2i(73, 40), Vector2i(72, 36), Vector2i(71, 43), Vector2i(37, 53), Vector2i(39, 51), Vector2i(31, 56)]:
		ck(String(mask[c.y])[c.x] == "#", "case de sentier %s praticable" % str(c))
	ck(_reach(mask, start, Vector2i(73, 40)), "le virage du moulin est atteignable depuis le départ")
	ck(_reach(mask, start, Vector2i(37, 53)), "le sentier du potager est atteignable depuis le départ")
	ck(_reach(mask, Vector2i(70, 33), Vector2i(72, 42)), "le chemin du moulin est continu de haut en bas")
	ck(_reach(mask, Vector2i(31, 56), Vector2i(40, 51)), "le sentier du potager est continu")
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
