extends SceneTree
## V374 : sensations d'impact — nombres de dégâts colorés par élément, taille selon le poids du coup, série de coups.
var fails: int = 0
func ck(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1
func _init() -> void:
	_run.call_deferred()
func _run() -> void:
	await process_frame
	ck(is_equal_approx(SpellFx.hit_weight(50, 200), 0.25), "poids : 50 dégâts sur 200 PV = 25 %")
	ck(SpellFx.hit_weight(999, 100) == 1.0 and SpellFx.hit_weight(10, 0) == 0.0, "poids borné, sans PV max = 0")
	ck(SpellFx.dmg_size(0.0, false) == 28 and SpellFx.dmg_size(0.4, false) == 44 and SpellFx.dmg_size(1.0, false) == 44,
			"taille : 28 pour une égratignure, 44 pour un coup lourd")
	ck(SpellFx.dmg_size(0.1, true) == SpellFx.dmg_size(0.1, false) + 10, "critique : +10")
	var fire: Color = SpellFx.dmg_color("fire", "mag")
	var ice: Color = SpellFx.dmg_color("ice", "mag")
	ck(fire.r > fire.b + 0.3 and ice.b > ice.r + 0.2, "feu orangé, glace bleutée")
	ck(SpellFx.dmg_color("fire", "dot") == Color(0.8, 0.45, 0.95), "dégâts sur la durée : violet")
	var v := EntityView.new()
	ck(v.next_combo() == 1, "premier coup : pas de série")
	v.next_float_offset()
	ck(v.next_combo() == 2, "deuxième coup rapproché : série ×2")
	v.next_float_offset()
	ck(v.next_combo() == 3, "troisième : ×3")
	v._float_decay = 0.0
	ck(v.next_combo() == 1, "après la retombée : la série repart de 1")
	v.free()
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
