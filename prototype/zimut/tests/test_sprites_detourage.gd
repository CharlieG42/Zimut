extends SceneTree
## V99 : les sprites des personnages n'ont plus de fond blanc résiduel (cape du mage, poches entre les membres).
var fails := 0
func ck(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c: fails += 1

func _white_border_px(img: Image) -> int:
	var n: int = 0
	var w: int = img.get_width()
	for y: int in range(img.get_height()):
		for x: int in [w - 1, w - 2, w - 3]:
			var c: Color = img.get_pixel(x, y)
			if c.a > 0.8 and c.r > 0.98 and c.g > 0.98 and c.b > 0.98:
				n += 1
	return n

func _init() -> void:
	_run.call_deferred()

func _run() -> void:
	var mage: Image = Image.load_from_file("res://assets/sprites/players/mage.png")
	ck(mage != null and _white_border_px(mage) < 40, "mage : plus de fond blanc collé au bord droit")
	var inv: Image = Image.load_from_file("res://assets/sprites/players/invocateur.png")
	ck(inv.get_pixel(5, inv.get_height() - 40).a < 0.1 and inv.get_pixel(20, inv.get_height() - 60).a < 0.1, "invocateur : fragment parasite en bas à gauche supprimé")
	for k: String in ["artificier", "assassin", "chasseur", "druide", "geomancien", "heal", "invocateur", "mage", "sylvain", "tank"]:
		var im: Image = Image.load_from_file("res://assets/sprites/players/%s.png" % k)
		var opaque: int = 0
		for y: int in range(0, im.get_height(), 4):
			for x: int in range(0, im.get_width(), 4):
				if im.get_pixel(x, y).a > 0.5:
					opaque += 1
		ck(opaque > 800, "%s : le personnage est toujours présent (%d)" % [k, opaque])
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
