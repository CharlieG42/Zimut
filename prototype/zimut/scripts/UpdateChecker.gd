extends Node
## UpdateChecker.gd — Mise à jour automatique depuis GitHub (V455) — autoload « UpdateChecker ».
## Au lancement du jeu (hors éditeur), interroge la release « build-latest » du dépôt
## (API REST) : si la version publiée (ex. 0.1.001.455.1400, lue dans les notes de la
## release) est plus récente que application/config/version, le jeu propose de
## télécharger l'APK Android (release signé) ou l'EXE Windows, vérifie le SHA-256
## (SHA256SUMS.txt de la release), puis applique la mise à jour :
##  - Windows : lance le nouvel EXE avec « -- --zimut-replace=<exe actuel> » ; la
##    nouvelle instance remplace l'ancien exécutable dès qu'il est libéré, le
##    relance, puis quitte ;
##  - Android : ouvre l'installateur système sur l'APK téléchargé (FileProvider Godot,
##    autorité « <package>.fileprovider », racine filesRoot = user://).
## Contrôle aussi lançable à la main depuis Réglages > À propos.

signal checked(result: Dictionary)
signal update_available(info: Dictionary)
signal progress(frac: float, label: String)
signal status(text: String)

const REPO := "CharlieG42/Zimut"
const RELEASE_TAG := "build-latest"
const API_URL := "https://api.github.com/repos/%s/releases/tags/%s" % [REPO, RELEASE_TAG]
const PAGE_URL := "https://github.com/%s/releases/tag/%s" % [REPO, RELEASE_TAG]
const DOWNLOAD_DIR := "user://update/"
const REPLACE_ARG := "--zimut-replace="
const APK_MIME := "application/vnd.android.package-archive"

var last_check: Dictionary = {}
var latest_update: Dictionary = {}
var _http: HTTPRequest = null
var _dl: HTTPRequest = null
var _dl_path: String = ""
var _busy: bool = false
var _popup_open: bool = false


# ══════════════════════════════════════════════════════════════════════════════
#  Partie purement statique (testée par tests/test_update_checker.gd)
# ══════════════════════════════════════════════════════════════════════════════

static func current_version() -> String:
	return str(ProjectSettings.get_setting("application/config/version", "0.1.001.0.0"))

static func parse_version(s: String) -> Array[int]:
	var out: Array[int] = []
	for p: String in s.split("."):
		var n: String = ""
		for ch: String in p:
			if ch.is_valid_int() or (ch == "-" and n == ""):
				n += ch
			else:
				break
		out.append(int(n) if n != "" and n != "-" else 0)
	return out

static func is_newer(remote: String, local: String) -> bool:
	var r: Array[int] = parse_version(remote)
	var l: Array[int] = parse_version(local)
	var n: int = maxi(r.size(), l.size())
	for i: int in range(n):
		var rv: int = r[i] if i < r.size() else 0
		var lv: int = l[i] if i < l.size() else 0
		if rv != lv:
			return rv > lv
	return false

static func version_from_text(text: String) -> String:
	var re := RegEx.new()
	re.compile("[0-9]+(\\.[0-9]+){3,}")
	var m := re.search(text)
	return m.get_string() if m != null else ""

## {"version": …, "assets": [{"name","url","size"}…], "sums_url": …} depuis le JSON de l'API.
static func parse_release(json_text: String) -> Dictionary:
	var j: Variant = JSON.parse_string(json_text)
	if typeof(j) != TYPE_DICTIONARY:
		return {}
	var assets: Array = []
	for a: Variant in (j as Dictionary).get("assets", []):
		if typeof(a) == TYPE_DICTIONARY:
			assets.append({"name": String(a.get("name", "")),
				"url": String(a.get("browser_download_url", "")),
				"size": int(a.get("size", 0))})
	var sums_url := ""
	for a: Dictionary in assets:
		if a["name"] == "SHA256SUMS.txt":
			sums_url = a["url"]
	var body := String((j as Dictionary).get("body", ""))
	return {"version": version_from_text(body), "assets": assets, "sums_url": sums_url,
		"name": String((j as Dictionary).get("name", ""))}

## Asset à télécharger selon la plateforme : APK release signé sur Android, EXE PC sur Windows.
static func pick_asset(assets: Array, android: bool, windows: bool) -> Dictionary:
	var fallback := {}
	for a: Variant in assets:
		if typeof(a) != TYPE_DICTIONARY:
			continue
		var n: String = String(a.get("name", ""))
		if android and n.ends_with(".apk"):
			if n.contains("-release_v"):
				return a
			if fallback.is_empty():
				fallback = a
		elif windows and n.ends_with(".exe") and n.contains("-pc_v"):
			return a
	return fallback

static func sha256_from_sums(sums_text: String, filename: String) -> String:
	for line: String in sums_text.split("\n"):
		var parts: PackedStringArray = line.split(" ", false)
		if parts.size() >= 2 and parts[1].trim_prefix("*") == filename:
			return parts[0].to_lower()
	return ""

static func sha256_matches(path: String, expected: String) -> bool:
	if expected == "" or not FileAccess.file_exists(path):
		return false
	return FileAccess.get_sha256(path) == expected.to_lower()


# ══════════════════════════════════════════════════════════════════════════════
#  Cycle de vie
# ══════════════════════════════════════════════════════════════════════════════

func _ready() -> void:
	DirAccess.make_dir_recursive_absolute(DOWNLOAD_DIR)
	for a: String in OS.get_cmdline_user_args():
		if a.begins_with(REPLACE_ARG):
			_self_replace(a.trim_prefix(REPLACE_ARG))
			return
	if OS.has_feature("editor") or DisplayServer.get_name() == "headless":
		return
	if Edition.is_store_build():
		return   # V460 : Google Play gère les mises à jour (pas d'installation d'APK hors Play Store)
	if not OS.has_feature("android"):
		DirAccess.remove_absolute(OS.get_executable_path() + ".old")
	var gs: Node = get_node_or_null("/root/GameSettings")
	if gs != null and not bool(gs.get("auto_update")):
		return
	_auto_check.call_deferred()

func _process(_delta: float) -> void:
	if _dl != null:
		var total: int = maxi(1, _dl.get_body_size())
		progress.emit(clampf(float(_dl.get_downloaded_bytes()) / float(total), 0.0, 1.0), _dl_path.get_file())

func _auto_check() -> void:
	await get_tree().create_timer(1.5).timeout
	await check_now()

## Interroge la release build-latest et émet checked() / update_available().
func check_now() -> Dictionary:
	var local := current_version()
	var res: Dictionary = {"ok": false, "update": false, "local": local, "remote": "", "asset": {}, "error": ""}
	last_check = res
	if Edition.is_store_build():
		res["error"] = "Les mises à jour passent par Google Play."
		return res
	var r: Dictionary = await _http_get(API_URL)
	if not r["ok"]:
		if int(r["code"]) == 403:
			res["error"] = "Limite de requêtes GitHub atteinte (403) : réessaie plus tard."
		elif int(r["code"]) > 0:
			res["error"] = "GitHub ne répond pas (code %d)." % int(r["code"])
		else:
			res["error"] = "Pas de connexion Internet."
		checked.emit(res)
		return res
	var rel: Dictionary = parse_release(r["text"])
	res["ok"] = true
	res["remote"] = String(rel.get("version", ""))
	var asset: Dictionary = pick_asset(rel.get("assets", []), OS.has_feature("android"), OS.get_name() == "Windows")
	if res["remote"] == "" or asset.is_empty():
		res["error"] = "Release « %s » sans version ni asset pour cette plateforme." % RELEASE_TAG
		checked.emit(res)
		return res
	res["asset"] = asset
	if is_newer(res["remote"], local):
		var sums: Dictionary = await _http_get(String(rel.get("sums_url", "")))
		var sha := sha256_from_sums(String(sums.get("text", "")), String(asset["name"])) if sums["ok"] else ""
		latest_update = {"version": res["remote"], "name": String(asset["name"]), "url": String(asset["url"]),
			"size": int(asset.get("size", 0)), "sha256": sha, "page": PAGE_URL}
		res["update"] = true
		update_available.emit(latest_update)
	checked.emit(res)
	return res

## Télécharge l'asset puis applique la mise à jour (avec barre de progression).
func download_and_apply() -> void:
	if _busy or latest_update.is_empty():
		return
	_busy = true
	var name: String = String(latest_update["name"])
	_dl_path = DOWNLOAD_DIR + name
	status.emit("Téléchargement de %s…" % name)
	_dl = HTTPRequest.new()
	_dl.timeout = 0.0
	_dl.download_file = _dl_path
	add_child(_dl)
	var err: int = _dl.request(String(latest_update["url"]))
	if err != OK:
		status.emit("Échec du téléchargement.")
		_dl.queue_free()
		_dl = null
		_busy = false
		return
	var r: Array = await _dl.request_completed
	_dl.queue_free()
	_dl = null
	if int(r[0]) != HTTPRequest.RESULT_SUCCESS or int(r[1]) != 200:
		status.emit("Téléchargement interrompu (code %d)." % int(r[1]))
		DirAccess.remove_absolute(_dl_path)
		_busy = false
		return
	if not sha256_matches(_dl_path, String(latest_update.get("sha256", ""))):
		status.emit("SHA-256 invalide : fichier supprimé, réessaie plus tard.")
		DirAccess.remove_absolute(_dl_path)
		_busy = false
		return
	status.emit("Mise à jour prête : application…")
	_apply(_dl_path)
	_busy = false


# ══════════════════════════════════════════════════════════════════════════════
#  Application de la mise à jour
# ══════════════════════════════════════════════════════════════════════════════

func _apply(path: String) -> void:
	if OS.has_feature("android"):
		_install_apk(path)
	elif OS.get_name() == "Windows":
		var target: String = OS.get_executable_path()
		if OS.create_process(path, ["--", REPLACE_ARG + target]) == OK:
			status.emit("Nouvelle version lancée…")
			get_tree().quit()
		else:
			status.emit("Impossible de lancer %s." % path.get_file())
	else:
		OS.shell_open(String(latest_update.get("url", PAGE_URL)))

## Android : installateur système sur l'APK téléchargé (FileProvider Godot de l'app).
func _install_apk(path: String) -> void:
	var fallback: String = String(latest_update.get("url", PAGE_URL))
	if not OS.has_feature("android"):
		OS.shell_open(fallback)
		return
	var runtime: Object = Engine.get_singleton("AndroidRuntime")
	var jcw: Object = Engine.get_singleton("JavaClassWrapper")
	if runtime == null or jcw == null:
		OS.shell_open(fallback)
		return
	var activity: Object = runtime.getActivity()
	var rel: String = path.trim_prefix("user://")
	var uri_str: String = "content://%s.fileprovider/filesRoot/%s" % [String(activity.getPackageName()), rel]
	var Intent: Object = jcw.wrap("android.content.Intent")
	var Uri: Object = jcw.wrap("android.net.Uri")
	var intent: Object = Intent.Intent()
	intent.setAction(Intent.ACTION_VIEW)
	intent.setDataAndType(Uri.parse(uri_str), APK_MIME)
	intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
	activity.startActivity(intent)
	status.emit("Installation de %s lancée…" % path.get_file())

## PC : la nouvelle instance remplace l'ancien EXE dès qu'il est libéré, puis le relance.
func _self_replace(target: String) -> void:
	var ok := false
	for i: int in range(100):
		if DirAccess.rename_absolute(target, target + ".old") == OK:
			ok = true
			break
		await get_tree().create_timer(0.1).timeout
	if ok and DirAccess.copy_absolute(OS.get_executable_path(), target) == OK:
		OS.create_process(target, [])
		get_tree().quit()


# ══════════════════════════════════════════════════════════════════════════════
#  HTTP
# ══════════════════════════════════════════════════════════════════════════════

func _http_get(url: String) -> Dictionary:
	if url == "":
		return {"ok": false, "code": 0, "text": ""}
	if _http == null:
		_http = HTTPRequest.new()
		_http.timeout = 20.0
		add_child(_http)
	var headers := PackedStringArray(["User-Agent: Zimut/%s" % current_version(), "Accept: application/vnd.github+json"])
	if _http.request(url, headers, HTTPClient.METHOD_GET) != OK:
		return {"ok": false, "code": 0, "text": ""}
	var r: Array = await _http.request_completed
	return {"ok": int(r[0]) == HTTPRequest.RESULT_SUCCESS and int(r[1]) >= 200 and int(r[1]) < 300,
		"code": int(r[1]), "text": (r[3] as PackedByteArray).get_string_from_utf8()}


# ══════════════════════════════════════════════════════════════════════════════
#  Popup (style Changelog.build_popup)
# ══════════════════════════════════════════════════════════════════════════════

func build_popup() -> Control:
	if _popup_open:
		return Control.new()
	_popup_open = true
	var info: Dictionary = latest_update
	var dim := ColorRect.new()
	dim.color = Color(0, 0, 0, 0.6)
	dim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	dim.mouse_filter = Control.MOUSE_FILTER_STOP
	var box := PanelContainer.new()
	box.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	box.custom_minimum_size = Vector2(760, 0)
	box.grow_horizontal = Control.GROW_DIRECTION_BOTH
	box.grow_vertical = Control.GROW_DIRECTION_BOTH
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0.1, 0.1, 0.16, 0.97)
	sb.border_color = Color(1.0, 0.86, 0.4)
	sb.set_border_width_all(3)
	sb.set_corner_radius_all(16)
	sb.set_content_margin_all(24)
	box.add_theme_stylebox_override("panel", sb)
	dim.add_child(box)
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 12)
	box.add_child(v)
	var title := Label.new()
	title.text = "⬇  Mise à jour disponible"
	title.add_theme_font_size_override("font_size", 34)
	title.add_theme_color_override("font_color", Color(1.0, 0.86, 0.4))
	v.add_child(title)
	var mo: float = float(info.get("size", 0)) / 1048576.0
	var body := Label.new()
	body.text = "Version %s (vous avez %s).\nFichier : %s (%.0f Mo) — téléchargé depuis GitHub, empreinte SHA-256 vérifiée." % [
		String(info.get("version", "?")), current_version(), String(info.get("name", "?")), mo]
	body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	body.custom_minimum_size = Vector2(700, 0)
	body.add_theme_font_size_override("font_size", 22)
	v.add_child(body)
	var bar := ProgressBar.new()
	bar.min_value = 0.0
	bar.max_value = 1.0
	bar.custom_minimum_size = Vector2(700, 26)
	bar.visible = false
	v.add_child(bar)
	var st := Label.new()
	st.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	st.custom_minimum_size = Vector2(700, 0)
	st.add_theme_font_size_override("font_size", 20)
	st.add_theme_color_override("font_color", Color(0.75, 0.8, 0.95))
	v.add_child(st)
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 12)
	v.add_child(row)
	var install := _popup_btn("Télécharger et installer", Color(0.35, 0.62, 0.35))
	install.pressed.connect(func() -> void:
		install.disabled = true
		bar.visible = true
		download_and_apply())
	row.add_child(install)
	var page := _popup_btn("Page GitHub", Color(0.25, 0.35, 0.6))
	page.pressed.connect(func() -> void: OS.shell_open(PAGE_URL))
	row.add_child(page)
	var later := _popup_btn("Plus tard", Color(0.45, 0.4, 0.35))
	later.pressed.connect(func() -> void:
		_popup_open = false
		dim.queue_free())
	row.add_child(later)
	progress.connect(func(frac: float, label: String) -> void:
		bar.value = frac
		st.text = "Téléchargement de %s : %d %%" % [label, int(frac * 100.0)])
	status.connect(func(t: String) -> void: st.text = t)
	dim.tree_exiting.connect(func() -> void: _popup_open = false)
	return dim

func _popup_btn(text: String, bg: Color) -> Button:
	var b := Button.new()
	b.text = text
	b.custom_minimum_size = Vector2(0, 56)
	b.add_theme_font_size_override("font_size", 22)
	var s := StyleBoxFlat.new()
	s.bg_color = bg
	s.border_color = Color(1.0, 0.86, 0.4)
	s.set_border_width_all(2)
	s.set_corner_radius_all(12)
	b.add_theme_stylebox_override("normal", s)
	b.add_theme_stylebox_override("hover", s)
	b.add_theme_stylebox_override("pressed", s)
	b.add_theme_stylebox_override("disabled", s)
	return b
