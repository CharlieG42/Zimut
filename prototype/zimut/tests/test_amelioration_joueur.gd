extends SceneTree
## V75 : journal des nouveautés, indice de niveau suivant dans l'infobulle, portée des mécanismes.
var fails: int = 0
func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	await process_frame
	var gs: Node = root.get_node("GameSettings")
	var c: Dictionary = Changelog.latest()
	check(not c.is_empty() and c["lines"].size() >= 3, "journal des nouveautés lu")
	gs.changelog_seen = ""
	check(not Changelog.pending().is_empty(), "nouveautés non vues : à afficher")
	var pop: Control = Changelog.build_popup(c)
	root.add_child(pop)
	await process_frame
	gs.mark_changelog_seen(String(c["id"]))
	check(Changelog.pending().is_empty(), "nouveautés vues : plus affichées")
	pop.queue_free()
	gs.changelog_seen = ""
	gs.save_settings()
	# Indice de niveau : un sort de dégâts niv. 3 annonce la valeur du niv. 4
	var pm: Node = root.get_node("ProgressionManager")
	var row: Dictionary = {}
	for r: Dictionary in pm.spells_of("Mage"):
		if int(r["mag"]) > 0:
			row = r
			break
	var sp: Dictionary = {"name": row["name"], "classe": "Mage", "cost_pa": int(row["pa"]), "cost_pm": int(row["pm"]),
		"range": int(row["range"]), "effect": String(row["effect"]), "level_required": int(row["level"]),
		"spell_type": String(row["type"]), "Degats_physiques": int(row["phys"]), "Degats_magiques": int(row["mag"]),
		"Soins": int(row["heal"]), "spell_level": 3, "mult": 1.12}
	var hint: String = Combat.level_hint(sp)
	check(hint.contains("au niv. 4"), "infobulle : valeur du niveau suivant (%s)" % hint)
	sp["spell_level"] = 10
	sp["mult"] = 1.54
	sp.erase("_p")
	check(Combat.level_hint(sp).contains("niveau max"), "niveau 10 : niveau max")
	print("ÉCHECS : ", fails)
	quit(0 if fails == 0 else 1)
