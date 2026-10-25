class_name CloudSave
extends Node
## CloudSave.gd — Sauvegarde et restauration des parties sur Google Drive (V49).
##
## Connexion : flux OAuth « appareils à saisie limitée » (device flow). Pas de module Android
## natif ni d'empreinte SHA-1 : la première fois, le jeu affiche un code et ouvre
## google.com/device ; le joueur valide avec son compte Google, puis le jeton de
## rafraîchissement est gardé (user://cloud_token.json) et les sauvegardes suivantes sont directes.
##
## Stockage : dossier caché de l'application sur Drive (appDataFolder, portée drive.appdata) :
## l'app ne voit que ses propres fichiers et le joueur ne les voit pas dans son Drive.
## Un seul fichier « zimut_backup.json » : toutes les parties + les réglages.
##
## Identifiants OAuth (client « TV et appareils à saisie limitée ») : res://cloud_oauth.json,
## écrit par le workflow GitHub depuis les secrets (ZIMUT_GDRIVE_CLIENT_ID / _SECRET),
## ou user://cloud_oauth.json. Format : {"client_id": "…", "client_secret": "…"}.

signal status(text: String)
## Code à saisir sur verification_url (premier branchement uniquement).
signal user_code(code: String, url: String)

const SCOPE := "https://www.googleapis.com/auth/drive.appdata"
const DEVICE_URL := "https://oauth2.googleapis.com/device/code"
const TOKEN_URL := "https://oauth2.googleapis.com/token"
const FILES_URL := "https://www.googleapis.com/drive/v3/files"
const UPLOAD_URL := "https://www.googleapis.com/upload/drive/v3/files"
const BACKUP_NAME := "zimut_backup.json"
const TOKEN_PATH := "user://cloud_token.json"
const FORMAT := "zimut-cloud-1"

var _cancel: bool = false
var _token: Dictionary = {}


# ═══════════════════════════════════════════════════════════════════════════
#  Configuration / jeton
# ═══════════════════════════════════════════════════════════════════════════

static func oauth_config() -> Dictionary:
	for path: String in ["user://cloud_oauth.json", "res://cloud_oauth.json"]:
		if FileAccess.file_exists(path):
			var d: Variant = JSON.parse_string(FileAccess.get_file_as_string(path))
			if d is Dictionary and String((d as Dictionary).get("client_id", "")) != "":
				return d
	return {}


static func is_configured() -> bool:
	return not oauth_config().is_empty()


static func is_linked() -> bool:
	if not FileAccess.file_exists(TOKEN_PATH):
		return false
	var d: Variant = JSON.parse_string(FileAccess.get_file_as_string(TOKEN_PATH))
	return d is Dictionary and String((d as Dictionary).get("refresh_token", "")) != ""


## Oublie le compte Google (le prochain envoi redemandera le code).
static func unlink() -> void:
	if FileAccess.file_exists(TOKEN_PATH):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(TOKEN_PATH))


func cancel() -> void:
	_cancel = true


func _load_token() -> void:
	_token = {}
	if FileAccess.file_exists(TOKEN_PATH):
		var d: Variant = JSON.parse_string(FileAccess.get_file_as_string(TOKEN_PATH))
		if d is Dictionary:
			_token = d


func _save_token() -> void:
	var f := FileAccess.open(TOKEN_PATH, FileAccess.WRITE)
	if f != null:
		f.store_string(JSON.stringify(_token))
		f.close()


static func _form(fields: Dictionary) -> String:
	var parts: PackedStringArray = []
	for k in fields.keys():
		parts.append("%s=%s" % [String(k).uri_encode(), String(fields[k]).uri_encode()])
	return "&".join(parts)


func _http(url: String, headers: PackedStringArray, method: int, body: Variant = "") -> Dictionary:
	var h := HTTPRequest.new()
	h.timeout = 40.0
	add_child(h)
	var err: int
	if body is PackedByteArray:
		err = h.request_raw(url, headers, method, body)
	else:
		err = h.request(url, headers, method, String(body))
	if err != OK:
		h.queue_free()
		return {"ok": false, "code": 0, "text": "", "json": {}}
	var r: Array = await h.request_completed
	h.queue_free()
	var text: String = (r[3] as PackedByteArray).get_string_from_utf8()
	var js: Variant = JSON.parse_string(text) if text.begins_with("{") else null
	return {"ok": int(r[0]) == HTTPRequest.RESULT_SUCCESS and int(r[1]) >= 200 and int(r[1]) < 300,
		"code": int(r[1]), "text": text, "json": js if js is Dictionary else {}, "net": int(r[0])}


## Jeton d'accès valide ("" si échec). Lance la connexion par code au premier usage.
func access_token() -> String:
	var cfg: Dictionary = oauth_config()
	if cfg.is_empty():
		status.emit("Cloud non configuré : identifiants Google absents de cette version du jeu.")
		return ""
	_load_token()
	var now: float = Time.get_unix_time_from_system()
	if String(_token.get("access_token", "")) != "" and float(_token.get("expires_at", 0.0)) > now + 60.0:
		return String(_token["access_token"])
	if String(_token.get("refresh_token", "")) != "":
		status.emit("Connexion à Google Drive…")
		var r: Dictionary = await _http(TOKEN_URL, PackedStringArray(["Content-Type: application/x-www-form-urlencoded"]),
			HTTPClient.METHOD_POST, _form({"client_id": cfg["client_id"], "client_secret": cfg.get("client_secret", ""),
				"refresh_token": _token["refresh_token"], "grant_type": "refresh_token"}))
		if r["ok"]:
			_token["access_token"] = String(r["json"].get("access_token", ""))
			_token["expires_at"] = now + float(r["json"].get("expires_in", 3000))
			_save_token()
			return String(_token["access_token"])
		if int(r["code"]) == 0:
			status.emit("Pas de connexion Internet.")
			return ""
		# Jeton révoqué ou expiré : on refait le branchement
		unlink()
		_token = {}
	return await _device_login(cfg)


func _device_login(cfg: Dictionary) -> String:
	_cancel = false
	status.emit("Demande d'un code de connexion Google…")
	var r: Dictionary = await _http(DEVICE_URL, PackedStringArray(["Content-Type: application/x-www-form-urlencoded"]),
		HTTPClient.METHOD_POST, _form({"client_id": cfg["client_id"], "scope": SCOPE}))
	if not r["ok"]:
		status.emit("Impossible de joindre Google (%s)." % ("hors ligne" if int(r["code"]) == 0 else "erreur %d" % int(r["code"])))
		return ""
	var j: Dictionary = r["json"]
	var device_code: String = String(j.get("device_code", ""))
	var url: String = String(j.get("verification_url", j.get("verification_uri", "https://www.google.com/device")))
	var interval: float = maxf(2.0, float(j.get("interval", 5)))
	var deadline: float = Time.get_unix_time_from_system() + float(j.get("expires_in", 1800))
	user_code.emit(String(j.get("user_code", "")), url)
	status.emit("En attente de ta validation sur Google…")
	while Time.get_unix_time_from_system() < deadline:
		await get_tree().create_timer(interval).timeout
		if _cancel:
			status.emit("Connexion annulée.")
			return ""
		var p: Dictionary = await _http(TOKEN_URL, PackedStringArray(["Content-Type: application/x-www-form-urlencoded"]),
			HTTPClient.METHOD_POST, _form({"client_id": cfg["client_id"], "client_secret": cfg.get("client_secret", ""),
				"device_code": device_code, "grant_type": "urn:ietf:params:oauth:grant-type:device_code"}))
		if p["ok"]:
			var now: float = Time.get_unix_time_from_system()
			_token = {"access_token": String(p["json"].get("access_token", "")),
				"refresh_token": String(p["json"].get("refresh_token", "")),
				"expires_at": now + float(p["json"].get("expires_in", 3000))}
			_save_token()
			status.emit("Compte Google relié !")
			return String(_token["access_token"])
		var e: String = String(p["json"].get("error", ""))
		if e == "authorization_pending":
			continue
		if e == "slow_down":
			interval += 5.0
			continue
		status.emit("Connexion refusée." if e == "access_denied" else "Connexion impossible (%s)." % (e if e != "" else str(p["code"])))
		return ""
	status.emit("Le code a expiré : réessaie.")
	return ""


# ═══════════════════════════════════════════════════════════════════════════
#  Contenu de la sauvegarde
# ═══════════════════════════════════════════════════════════════════════════

## Toutes les parties + réglages, prêts à être envoyés.
static func build_bundle() -> Dictionary:
	var saves: Dictionary = {}
	for slot: int in range(ProgressionManager.MAX_SAVES):
		if ProgressionManager.save_exists(slot):
			var d: Dictionary = ProgressionManager.load_save(slot)
			if not d.is_empty():
				saves[str(slot)] = d
	var settings: Variant = null
	if FileAccess.file_exists(GameSettings.SETTINGS_PATH):
		settings = JSON.parse_string(FileAccess.get_file_as_string(GameSettings.SETTINGS_PATH))
	return {"format": FORMAT, "date": Time.get_datetime_string_from_system(),
		"version": str(ProjectSettings.get_setting("application/config/version", "")),
		"saves": saves, "settings": settings}


## Résumé lisible d'une sauvegarde Cloud.
static func describe(bundle: Dictionary) -> String:
	var names: PackedStringArray = []
	for k in (bundle.get("saves", {}) as Dictionary).keys():
		names.append(String(bundle["saves"][k].get("name", "Partie %d" % (int(k) + 1))))
	var date: String = String(bundle.get("date", "?")).replace("T", " à ")
	return "Sauvegarde du %s : %d partie(s)%s" % [date, names.size(), (" — " + ", ".join(names)) if not names.is_empty() else ""]


## Écrit les parties d'une sauvegarde Cloud sur l'appareil (remplace les emplacements
## concernés ; les autres emplacements locaux sont supprimés pour retrouver l'état sauvegardé).
static func apply_bundle(bundle: Dictionary) -> int:
	if String(bundle.get("format", "")) != FORMAT:
		return -1
	var saves: Dictionary = bundle.get("saves", {})
	var n: int = 0
	for slot: int in range(ProgressionManager.MAX_SAVES):
		var key: String = str(slot)
		if saves.has(key) and saves[key] is Dictionary:
			var d: Dictionary = (saves[key] as Dictionary).duplicate(true)
			ProgressionManager.ensure_roster(d)
			ProgressionManager.ensure_playtime(d)
			if ProgressionManager.write_save(slot, d):
				n += 1
		elif ProgressionManager.save_exists(slot):
			ProgressionManager.delete_save(slot)
	var st: Variant = bundle.get("settings", null)
	if st is Dictionary:
		var f := FileAccess.open(GameSettings.SETTINGS_PATH, FileAccess.WRITE)
		if f != null:
			f.store_string(JSON.stringify(st, "\t"))
			f.close()
		if GameSettings.has_method("load_settings"):
			GameSettings.call("load_settings")
	return n


# ═══════════════════════════════════════════════════════════════════════════
#  Drive
# ═══════════════════════════════════════════════════════════════════════════

func _find_file(token: String) -> Dictionary:
	var q: String = ("name='%s'" % BACKUP_NAME).uri_encode()
	var r: Dictionary = await _http("%s?spaces=appDataFolder&q=%s&fields=files(id,modifiedTime)" % [FILES_URL, q],
		PackedStringArray(["Authorization: Bearer " + token]), HTTPClient.METHOD_GET)
	if not r["ok"]:
		return {"error": int(r["code"])}
	var files: Array = r["json"].get("files", [])
	return files[0] if not files.is_empty() else {}


## Envoie toutes les parties sur Drive. Retourne true si réussi.
func backup() -> bool:
	var token: String = await access_token()
	if token == "":
		return false
	status.emit("Envoi des parties sur Google Drive…")
	var content: String = JSON.stringify(build_bundle())
	var found: Dictionary = await _find_file(token)
	if found.has("error"):
		status.emit("Drive inaccessible (erreur %d)." % int(found["error"]))
		return false
	var r: Dictionary
	if found.has("id"):
		r = await _http("%s/%s?uploadType=media" % [UPLOAD_URL, String(found["id"])],
			PackedStringArray(["Authorization: Bearer " + token, "Content-Type: application/json"]),
			HTTPClient.METHOD_PATCH, content.to_utf8_buffer())
	else:
		var boundary: String = "zimut_%d" % (Time.get_ticks_usec() % 1000000007)
		var meta: String = JSON.stringify({"name": BACKUP_NAME, "parents": ["appDataFolder"], "mimeType": "application/json"})
		var body: String = "--%s\r\nContent-Type: application/json; charset=UTF-8\r\n\r\n%s\r\n--%s\r\nContent-Type: application/json\r\n\r\n%s\r\n--%s--\r\n" % [boundary, meta, boundary, content, boundary]
		r = await _http("%s?uploadType=multipart" % UPLOAD_URL,
			PackedStringArray(["Authorization: Bearer " + token, "Content-Type: multipart/related; boundary=" + boundary]),
			HTTPClient.METHOD_POST, body.to_utf8_buffer())
	if r["ok"]:
		status.emit("✓ Parties sauvegardées sur Google Drive.")
		return true
	status.emit("Échec de l'envoi (erreur %d)." % int(r["code"]))
	return false


## Télécharge la sauvegarde Cloud (sans l'appliquer). {} si absente ou erreur.
func fetch() -> Dictionary:
	var token: String = await access_token()
	if token == "":
		return {}
	status.emit("Recherche de ta sauvegarde sur Google Drive…")
	var found: Dictionary = await _find_file(token)
	if found.has("error"):
		status.emit("Drive inaccessible (erreur %d)." % int(found["error"]))
		return {}
	if not found.has("id"):
		status.emit("Aucune sauvegarde Cloud pour ce compte Google.")
		return {}
	var r: Dictionary = await _http("%s/%s?alt=media" % [FILES_URL, String(found["id"])],
		PackedStringArray(["Authorization: Bearer " + token]), HTTPClient.METHOD_GET)
	if not r["ok"] or (r["json"] as Dictionary).is_empty():
		status.emit("Téléchargement impossible (erreur %d)." % int(r["code"]))
		return {}
	status.emit(describe(r["json"]))
	return r["json"]
