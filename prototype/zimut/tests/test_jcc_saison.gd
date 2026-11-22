extends SceneTree
## Mode Cartes : saison mensuelle (paliers de victoires, récompenses uniques, reset au changement de mois).
var fails: int = 0
func check(ok: bool, label: String) -> void:
	if ok:
		print("  ok  ", label)
	else:
		fails += 1
		print("  ÉCHEC  ", label)

func _initialize() -> void:
	var save: Dictionary = {"gold": 0}
	JccCollection.ensure(save)
	var rng := RandomNumberGenerator.new()
	rng.seed = 5
	check(JccCollection.season_id("2026-11-22") == "2026-11", "id de saison = mois")
	var got: Array = []
	for i in 2:
		got.append_array(JccCollection.season_win(save, "2026-11-05", rng))
	check(got.is_empty() and int(save["gold"]) == 0, "2 victoires : pas de palier")
	got = JccCollection.season_win(save, "2026-11-06", rng)
	check(got.size() == 1 and int(save["gold"]) == 100, "3e victoire : palier 1 (+100 or)")
	for i in 4:
		JccCollection.season_win(save, "2026-11-07", rng)
	got = JccCollection.season_win(save, "2026-11-08", rng)
	check(got.size() == 1 and int(got[0]["wins"]) == 8 and int(save["gold"]) == 350, "8e victoire : palier 2 (+250 or)")
	var owned_before: int = JccCollection.owned(save, "m_gobelin")
	for i in 6:
		got = JccCollection.season_win(save, "2026-11-09", rng)
	var ids: Array = []
	for i in 1:
		ids.append(got)
	var s: Dictionary = JccCollection.season_info(save, "2026-11-09")
	check(int(s["wins"]) == 14 and not (s["claimed"] as Array).has(15), "14 victoires : palier 3 pas encore")
	got = JccCollection.season_win(save, "2026-11-10", rng)
	check(got.size() == 1 and String(got[0]["card"]) != "" and int(save["gold"]) == 750, "15e victoire : palier 3 (+400 or + carte)")
	check(JccCollection.season_win(save, "2026-11-11", rng).is_empty(), "16e victoire : rien de plus")
	var s2: Dictionary = JccCollection.season_info(save, "2026-12-01")
	check(String(s2["id"]) == "2026-12" and int(s2["wins"]) == 0 and (s2["claimed"] as Array).is_empty(), "nouveau mois : saison remise à zéro")
	check(JccCollection.season_win(save, "2026-12-02", rng).is_empty() and int(JccCollection.season_info(save, "2026-12-02")["wins"]) == 1, "nouvelle saison : compteur repart")
	print("SAISON fails=", fails)
	quit(1 if fails > 0 else 0)
