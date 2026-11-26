extends SceneTree
## Mise à jour automatique GitHub (V455) : logique statique de UpdateChecker
## (comparaison de versions, parsing de la release, choix de l'asset, SHA-256).
const UC := preload("res://scripts/UpdateChecker.gd")
var fails := 0
func ck(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c: fails += 1

const SAMPLE_RELEASE := """{"tag_name":"build-latest","name":"Build latest — 455","body":"Dernière build de main : Zimut 0.1.001.455.1400 (commit abc1234).\\nAPK Android (debug + release signé) + EXE Windows (PC).","assets":[{"name":"SHA256SUMS.txt","size":278,"browser_download_url":"https://github.com/CharlieG42/Zimut/releases/download/build-latest/SHA256SUMS.txt"},{"name":"Zimut-debug_v0.001-455.apk","size":100,"browser_download_url":"https://x/Zimut-debug_v0.001-455.apk"},{"name":"Zimut-release_v0.001-455.apk","size":200,"browser_download_url":"https://x/Zimut-release_v0.001-455.apk"},{"name":"Zimut-pc_v0.001-455.exe","size":300,"browser_download_url":"https://x/Zimut-pc_v0.001-455.exe"}]}"""

func _init() -> void:
	_run.call_deferred()

func _run() -> void:
	ck(UC.parse_version("0.1.001.455.1400") == [0, 1, 1, 455, 1400], "parse_version 5 composantes")
	ck(UC.parse_version("abc").size() == 1 and UC.parse_version("abc")[0] == 0, "parse_version tolérant")
	ck(UC.is_newer("0.1.001.455.1400", "0.1.001.454.9999"), "PR suivant > PR précédent (dernier chiffre quel qu'il soit)")
	ck(UC.is_newer("0.1.001.454.9999", "0.1.001.454.1328"), "même PR, push plus récent")
	ck(not UC.is_newer("0.1.001.454.1328", "0.1.001.454.1328"), "version identique : pas de mise à jour")
	ck(not UC.is_newer("0.1.001.454.1328", "0.1.001.455.1"), "version distante inférieure : pas de mise à jour")
	ck(UC.is_newer("0.1.001.455", "0.1.001.454.9999"), "composantes manquantes = 0")
	ck(UC.version_from_text("Dernière build de main : Zimut 0.1.001.455.1400 (commit abc).") == "0.1.001.455.1400", "version extraite des notes de release")
	ck(UC.version_from_text("rien ici") == "", "pas de version dans le texte")
	var rel: Dictionary = UC.parse_release(SAMPLE_RELEASE)
	ck(rel.get("version", "") == "0.1.001.455.1400", "parse_release : version lue dans le body")
	ck((rel.get("assets", []) as Array).size() == 4, "parse_release : 4 assets")
	ck(String(rel.get("sums_url", "")).ends_with("SHA256SUMS.txt"), "parse_release : URL de SHA256SUMS.txt")
	ck(UC.parse_release("pas du json").is_empty(), "parse_release : JSON invalide -> vide")
	var assets: Array = rel.get("assets", [])
	var apk: Dictionary = UC.pick_asset(assets, true, false)
	ck(String(apk.get("name", "")) == "Zimut-release_v0.001-455.apk", "Android : APK release signé préféré")
	var exe: Dictionary = UC.pick_asset(assets, false, true)
	ck(String(exe.get("name", "")) == "Zimut-pc_v0.001-455.exe", "Windows : EXE PC choisi")
	ck(UC.pick_asset(assets, false, false).is_empty(), "autre plateforme : aucun asset auto")
	var apk_only: Array = assets.filter(func(a: Variant) -> bool: return String(a.get("name", "")).contains("debug"))
	ck(String(UC.pick_asset(apk_only, true, false).get("name", "")) == "Zimut-debug_v0.001-455.apk", "Android sans release signé : retombe sur l'APK dispo")
	ck(UC.sha256_from_sums("aaa111  Zimut-pc_v0.001-455.exe\nbbb222  SHA256SUMS.txt\n", "Zimut-pc_v0.001-455.exe") == "aaa111", "sha256 lu dans SHA256SUMS.txt")
	ck(UC.sha256_from_sums("aaa111 *Zimut-pc_v0.001-455.exe\n", "Zimut-pc_v0.001-455.exe") == "aaa111", "sha256 mode binaire (*) toléré")
	ck(UC.sha256_from_sums("aaa111  autre.exe\n", "Zimut-pc_v0.001-455.exe") == "", "sha256 absent : chaîne vide")
	var tmp := "user://test_update_checker_tmp.bin"
	var f := FileAccess.open(tmp, FileAccess.WRITE)
	f.store_string("hello")
	f.close()
	ck(UC.sha256_matches(tmp, "2CF24DBA5FB0A30E26E83B2AC5B9E29E1B161E5C1FA7425E73043362938B9824"), "sha256 du fichier vérifié (casse insensible)")
	ck(not UC.sha256_matches(tmp, "deadbeef"), "mauvais sha256 rejeté")
	ck(not UC.sha256_matches("user://inexistant.bin", "2cf24dba5fb0a30e26e83b2ac5b9e29e1b161e5c1fa7425e73043362938b9824"), "fichier absent rejeté")
	DirAccess.remove_absolute(tmp)
	ck(UC.current_version() == str(ProjectSettings.get_setting("application/config/version", "")), "current_version = application/config/version")
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
