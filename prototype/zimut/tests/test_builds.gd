## test_builds.gd — Tests headless du système de BUILDS par personnage (V42).
## Lancement : godot --headless -s tests/test_builds.gd --path .

var failures: int = 0

func _init() -> void:
	_test_build_crud()
	_test_active_spells()
	_test_activate_deactivate()
	_test_build_talents()
	_test_migration_default()
	print("")
	if failures > 0:
		print("ÉCHEC : %d test(s) en erreur." % failures)
		quit(1)
	else:
		print("OK : tous les tests passent.")
		quit(0)

func _check(cond: bool, label: String) -> void:
	if cond:
		print("  ok  %s" % label)
	else:
		failures += 1
		print("  KO  %s" % label)

## Fabrique une sauvegarde minimale avec un roster complet (comme test_talents).
func _make_save(classe: String, level: int) -> Dictionary:
	var data: Dictionary = {
		"roster": {},
		"team": [{"classe": classe, "equipment": {}}],
		"gold": 0,
		"inventory": [],
		"victories": 0,
	}
	ProgressionManager.ensure_roster(data)
	var ent: Dictionary = data["roster"][classe]
	ent["level"] = level
	ent["xp"] = ProgressionManager.xp_for_level(level)
	ent["talents"] = {"unlocked": {}, "points": TalentTree.power_for_level(level)}
	return data

func _test_build_crud() -> void:
	print("Builds — CRUD :")
	var data: Dictionary = _make_save("Tank", 30)
	_check(Builds.build_count(data, "Tank") == 0, "0 build au départ")
	_check(Builds.active_index(data, "Tank") == -1, "build actif = -1 (libre)")
	# Création
	var i0: int = Builds.create_build(data, "Tank", "Tank DPS")
	_check(i0 == 0, "création build 0")
	_check(Builds.build_count(data, "Tank") == 1, "1 build")
	_check(Builds.display_name(data, "Tank", 0) == "Tank DPS", "nom = Tank DPS")
	var i1: int = Builds.create_build(data, "Tank")
	_check(i1 == 1, "création build 1 (nom auto)")
	_check(Builds.display_name(data, "Tank", 1) == "Build 2", "nom auto = Build 2")
	var i2: int = Builds.create_build(data, "Tank")
	_check(i2 == 2, "création build 2")
	_check(Builds.create_build(data, "Tank") == -1, "4e build refusé (max 3)")
	# Renommage
	Builds.rename_build(data, "Tank", 1, "Tank Heal")
	_check(Builds.display_name(data, "Tank", 1) == "Tank Heal", "renommage OK")
	Builds.rename_build(data, "Tank", 1, "   ")
	_check(Builds.display_name(data, "Tank", 1) == "Tank Heal", "renommage vide refusé")
	# Suppression au milieu : l'index actif doit suivre
	Builds.activate(data, "Tank", 2, -1)
	_check(Builds.active_index(data, "Tank") == 2, "build 2 activé")
	Builds.delete_build(data, "Tank", 0)
	_check(Builds.build_count(data, "Tank") == 2, "2 builds après suppression")
	_check(Builds.active_index(data, "Tank") == 1, "index actif décalé 2→1 après suppression du 0")
	Builds.delete_build(data, "Tank", 1)
	_check(Builds.active_index(data, "Tank") == -1, "suppression du build actif → retour libre (-1)")

func _test_active_spells() -> void:
	print("Builds — sorts actifs :")
	var data: Dictionary = _make_save("Mage", 40)
	# Par défaut : les sorts actifs = premiers sorts débloqués (max 10)
	var def: Array = Builds.active_spells(data, "Mage")
	_check(not def.is_empty(), "sorts actifs par défaut non vide")
	_check(def.size() <= Builds.MAX_ACTIVE_SPELLS, "≤ 10 sorts actifs par défaut")
	# Tous les sorts actifs par défaut sont débloqués au niveau 40
	var ok: bool = true
	for n: String in def:
		if ProgressionManager.spell_unlock_level("Mage", n) > 40:
			ok = false
	_check(ok, "tous les sorts actifs par défaut sont débloqués au niv 40")
	# set_active_spells : filtre les invalides et respecte la limite
	var names: Array = ["Boule de feu", "Éclair", "Sort inexistant", "Bouclier magique"]
	Builds.set_active_spells(data, "Mage", names)
	var cur: Array = Builds.active_spells(data, "Mage")
	_check(cur.has("Boule de feu"), "Boule de feu sélectionné")
	_check(not cur.has("Sort inexistant"), "sort inconnu filtré")
	_check(cur.size() == 3, "3 sorts valides retenus")
	# toggle : retire
	Builds.toggle_spell(data, "Mage", "Éclair")
	_check(not Builds.active_spells(data, "Mage").has("Éclair"), "toggle retire Éclair")
	# toggle : remet
	Builds.toggle_spell(data, "Mage", "Éclair")
	_check(Builds.active_spells(data, "Mage").has("Éclair"), "toggle remet Éclair")
	# Limite 10 : remplir puis tenter un 11e
	var all: Array[String] = Builds.unlocked_spell_names(data, "Mage")
	var ten: Array = all.slice(0, Builds.MAX_ACTIVE_SPELLS)
	Builds.set_active_spells(data, "Mage", ten)
	_check(Builds.active_spell_count(data, "Mage") == Builds.MAX_ACTIVE_SPELLS, "10 sorts actifs")
	if all.size() > Builds.MAX_ACTIVE_SPELLS:
		Builds.toggle_spell(data, "Mage", String(all[Builds.MAX_ACTIVE_SPELLS]))
		_check(Builds.active_spell_count(data, "Mage") == Builds.MAX_ACTIVE_SPELLS, "11e sort refusé (limite 10)")

func _test_activate_deactivate() -> void:
	print("Builds — activation :")
	var data: Dictionary = _make_save("Tank", 30)
	# Équipe un objet dans l'équipement libre
	var item: Dictionary = {"type": "Arme (1 main)", "level": 1, "rank": 1, "rarity": "commun",
		"force": 5, "name": "Épée test"}
	data["inventory"].append(item)
	_check(ProgressionManager.equip_hero_item(data, "Tank", 0) == "", "équipement arme OK")
	_check(ProgressionManager.hero_equipment(data, "Tank").has("arme"), "arme équipée (libre)")
	# Crée 2 builds
	var b0: int = Builds.create_build(data, "Tank", "DPS")
	var b1: int = Builds.create_build(data, "Tank", "Tank")
	# Sauvegarde l'équipement libre dans le build 0 via snapshot manuel
	Builds.set_build_equipment(data, "Tank", b0, ProgressionManager.hero_equipment(data, "Tank"))
	_check(Builds.build_gear_count(Builds.build_equipment(data, "Tank", b0)) == 1, "build 0 a 1 objet (snapshot)")
	# Active le build 0 : l'équipement du héros devient celui du build
	Builds.activate(data, "Tank", b0, -1)
	_check(Builds.active_index(data, "Tank") == b0, "build 0 activé")
	_check(ProgressionManager.hero_equipment(data, "Tank").has("arme"), "arme toujours équipée après activation")
	# Change l'équipement (libre) puis active le build 1 (vide) : l'ancien part dans le build 0
	ProgressionManager.unequip_hero_item(data, "Tank", "arme")
	data["inventory"].append({"type": "Bouclier", "level": 1, "rank": 1, "rarity": "commun", "defense": 3, "name": "Bouclier test"})
	ProgressionManager.equip_hero_item(data, "Tank", 0)
	_check(ProgressionManager.hero_equipment(data, "Tank").has("bouclier"), "bouclier équipé")
	Builds.activate(data, "Tank", b1, b0)
	_check(Builds.active_index(data, "Tank") == b1, "build 1 activé")
	_check(not ProgressionManager.hero_equipment(data, "Tank").has("bouclier"), "bouclier retiré (build 1 vide)")
	# L'ancien état (bouclier) a été sauvegardé dans le build 0
	_check(Builds.build_equipment(data, "Tank", b0).has("bouclier"), "build 0 a récupéré le bouclier")
	# Désactivation
	Builds.deactivate(data, "Tank")
	_check(Builds.active_index(data, "Tank") == -1, "désactivé → -1 (libre)")

func _test_build_talents() -> void:
	print("Builds — talents de build :")
	var data: Dictionary = _make_save("Assassin", 30)
	var ent: Dictionary = data["roster"]["Assassin"]
	ent["talents"]["points"] = 5
	TalentTree.spend_point(data, "Assassin", "off_veteran")
	_check(TalentTree.unlocked_count(data, "Assassin") == 1, "1 talent débloqué (libre)")
	# Crée un build et copie les talents dedans
	var b0: int = Builds.create_build(data, "Assassin", "Crit")
	Builds.set_build_talents(data, "Assassin", b0, ent["talents"])
	_check(Builds.build_talent_count(Builds.build_talents(data, "Assassin", b0)) == 1, "build 0 a 1 talent")
	# Active le build : les talents du roster deviennent ceux du build
	Builds.activate(data, "Assassin", b0, -1)
	_check(TalentTree.is_unlocked(data, "Assassin", "off_veteran"), "talent actif après activation")
	# Modifie les talents (libre maintenant dans le build actif) : retire via nouveau build
	var b1: int = Builds.create_build(data, "Assassin", "Tanky")
	# Le build 1 a des talents vides
	Builds.activate(data, "Assassin", b1, b0)
	_check(TalentTree.unlocked_count(data, "Assassin") == 0, "build 1 vide → 0 talent actif")
	# L'ancien état (off_veteran) est dans le build 0
	_check(Builds.build_talent_count(Builds.build_talents(data, "Assassin", b0)) == 1, "build 0 a conservé le talent")

func _test_migration_default() -> void:
	print("Builds — migration (ensure_roster) :")
	var data: Dictionary = {
		"roster": {"Tank": {"level": 20, "xp": 0, "invested": {}, "unspent": 0,
			"auto": false, "spell_levels": {}, "talents": {"unlocked": {}, "points": 1}}},
		"team": [{"classe": "Tank", "equipment": {}}],
		"gold": 0, "inventory": [], "victories": 0,
	}
	# Simule une vieille sauvegarde SANS les clés builds
	ProgressionManager.ensure_roster(data)
	var ent: Dictionary = data["roster"]["Tank"]
	_check(ent.has("builds"), "clé builds ajoutée")
	_check(ent.has("build_index"), "clé build_index ajoutée")
	_check(ent.has("active_spells"), "clé active_spells ajoutée")
	_check(Builds.active_index(data, "Tank") == -1, "build_index = -1 par défaut")
	_check(Builds.active_spells(data, "Tank").size() > 0, "sorts actifs par défaut renseignés")
	_check(Builds.build_count(data, "Tank") == 0, "aucun build par défaut")
