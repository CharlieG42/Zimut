extends SceneTree
var fails := 0
func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c: fails += 1
func _init() -> void:
	var cases := {"Boule de feu": "fire", "Gel": "ice", "Éclair": "lightning", "Poison": "poison", "Lame fatale": "shadow",
		"Soin de groupe": "holy", "Ronce": "nature", "Tremblement de terre": "earth", "Vague": "water", "Frappe puissante": "physical"}
	for k: String in cases:
		var dt: String = "phys" if cases[k] == "physical" else "mag"
		check(SpellFx.element_for(k, dt, "attack") == cases[k], "%s -> %s (obtenu %s)" % [k, cases[k], SpellFx.element_for(k, dt, "attack")])
	check(SpellFx.element_for("Invoquer Loup Spectral", "mag", "summon") == "arcane", "invocation -> arcane")
	check(EntityView.sprite_key("Sirène") == "sirene" and EntityView.sprite_key("Homme-Faucon") == "homme_faucon", "clés de sprite sans accents")
	for n in ["gobelin", "squelette", "loup", "troll", "dragonnet", "dragonnet_boss"]:
		check(ResourceLoader.exists("res://assets/sprites/enemies/%s.svg" % n), "skin ennemi " + n)
	for n in ["tortue", "loup", "sirene", "ange", "homme_faucon", "centaure", "buisson", "champignon", "tronc", "sarriette"]:
		check(ResourceLoader.exists("res://assets/sprites/summons/%s.svg" % n) or ResourceLoader.exists("res://assets/sprites/summons/%s.png" % n), "skin invocation " + n)
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
