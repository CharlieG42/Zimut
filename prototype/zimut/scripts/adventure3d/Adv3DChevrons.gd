class_name Adv3DChevrons
extends Control
## Adv3DChevrons.gd — Petit pictogramme de chevrons (vers le haut = réduire, vers le bas = agrandir).

var expand: bool = false
var count: int = 2


func _draw() -> void:
	var c: Vector2 = size * 0.5
	var w: float = minf(size.x, size.y) * 0.3
	var step: float = w * 0.75
	var dir: float = 1.0 if expand else -1.0      # +1 : pointe vers le bas
	var total: float = step * float(count - 1)
	for i: int in range(count):
		var y: float = c.y + (float(i) * step - total * 0.5) * 1.0
		var tip := Vector2(c.x, y + dir * w * 0.45)
		var l := Vector2(c.x - w, y - dir * w * 0.45)
		var r := Vector2(c.x + w, y - dir * w * 0.45)
		draw_polyline(PackedVector2Array([l, tip, r]), Color(0.95, 0.85, 0.45), 4.0, true)
