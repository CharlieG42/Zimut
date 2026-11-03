extends SceneTree
## Fiche personnage : valeurs réelles des effets en % et progression minimale des petites valeurs.
## Lancement : godot --headless --path . -s tests/test_fiche_sorts.gd
var fails: int = 0
func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var pm: Node = root.get_node("ProgressionManager")
	# Lien d'âme : +15 % dégâts de base ; au niveau 3 : 15 × 1,12 = 16,8 (et non « +12 % »)
	var pv: Dictionary = pm.spell_preview("Invocateur", "Lien d'âme", 3)
	var pe: Dictionary = pv["pct_effect"]
	check(not pe.is_empty(), "Lien d'âme : effet en % reconnu")
	check(absf(float(pe["value"]) - 16.8) < 0.05, "Lien d'âme niv 3 : +16,8 %% (obtenu %s)" % str(pe.get("value")))
	check(float(pe["next"]) > float(pe["value"]), "Lien d'âme : le niveau suivant est plus fort")
	var p1: Dictionary = pm.spell_preview("Invocateur", "Lien d'âme", 1)
	check(absf(float(p1["pct_effect"]["value"]) - 15.0) < 0.01, "niveau 1 : valeur de base (+15 %)")
	# Symbiose : soin de 8, ne doit plus rester à 8 au niveau 2
	var s1: Dictionary = pm.spell_preview("Invocateur", "Symbiose", 1)
	var s2: Dictionary = pm.spell_preview("Invocateur", "Symbiose", 2)
	check(int(s2["value"]) > int(s1["value"]), "Symbiose : %d → %d au niveau 2" % [int(s1["value"]), int(s2["value"])])
	check(Combat.scale_value(100, 1.06) == 106, "grandes valeurs : arrondi inchangé")
	check(Combat.scale_value(8, 1.06) == 9, "petites valeurs : au moins +1")
	check(Combat.scale_value(0, 1.5) == 0, "valeur nulle inchangée")
	# la fiche et le combat donnent la même valeur de soin
	var sp: Dictionary = {"name": "Symbiose", "classe": "Invocateur", "cost_pa": 2, "cost_pm": 0, "range": 1,
		"effect": "L'invocation restaure 8 PV à tous les alliés", "level_required": 1, "spell_type": "Soin",
		"Degats_physiques": 0, "Degats_magiques": 0, "Soins": 8, "spell_level": 2, "mult": 1.06}
	check(int(Combat.parse(sp)["heal"]) == int(s2["value"]), "fiche et combat cohérents (soin niv 2)")
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
