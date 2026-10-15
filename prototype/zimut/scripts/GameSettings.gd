extends Node

## GameSettings.gd — Réglages globaux du jeu (autoload) : difficulté des combats
## et rapidité de progression XP. Persistés dans user://settings.json.

signal settings_changed

const SETTINGS_PATH := "user://settings.json"

## Difficulté : index dans DIFFICULTIES (0 = Facile, 3 = Enfer).
const DIFFICULTIES: Array[String] = ["Facile", "Normal", "Difficile", "Enfer"]
## Multiplicateurs de puissance des ennemis (PV et attaque).
## Enfer dépasse nettement Difficile : 1.65 contre 1.20, soit +37,5 %.
const DIFFICULTY_POWER := [0.85, 1.0, 1.2, 1.65]

## Rapidité XP : index dans XP_SPEEDS.
const XP_SPEEDS: Array[String] = ["Lente", "Normale", "Rapide"]
const XP_SPEED_MULT := [0.6, 1.0, 1.6]

var difficulty: int = 1
var xp_speed: int = 1

func _ready() -> void:
	load_settings()

func load_settings() -> void:
	if not FileAccess.file_exists(SETTINGS_PATH):
		return
	var f := FileAccess.open(SETTINGS_PATH, FileAccess.READ)
	if f == null:
		return
	var parsed = JSON.parse_string(f.get_as_text())
	f.close()
	if typeof(parsed) != TYPE_DICTIONARY:
		return
	difficulty = clampi(int(parsed.get("difficulty", difficulty)), 0, DIFFICULTIES.size() - 1)
	xp_speed = clampi(int(parsed.get("xp_speed", xp_speed)), 0, XP_SPEEDS.size() - 1)

func save_settings() -> void:
	var f := FileAccess.open(SETTINGS_PATH, FileAccess.WRITE)
	if f == null:
		push_error("Impossible d'écrire les réglages")
		return
	f.store_string(JSON.stringify({"difficulty": difficulty, "xp_speed": xp_speed}, "\t"))
	f.close()

func set_difficulty(idx: int) -> void:
	difficulty = clampi(idx, 0, DIFFICULTIES.size() - 1)
	save_settings()
	settings_changed.emit()

func set_xp_speed(idx: int) -> void:
	xp_speed = clampi(idx, 0, XP_SPEEDS.size() - 1)
	save_settings()
	settings_changed.emit()

func difficulty_label() -> String:
	return DIFFICULTIES[clampi(difficulty, 0, DIFFICULTIES.size() - 1)]

func xp_speed_label() -> String:
	return XP_SPEEDS[clampi(xp_speed, 0, XP_SPEEDS.size() - 1)]

## Multiplicateur de puissance des ennemis (PV et attaque) selon la difficulté.
func enemy_power_mult() -> float:
	return float(DIFFICULTY_POWER[clampi(difficulty, 0, DIFFICULTY_POWER.size() - 1)])

## Multiplicateur du gain d'XP par combat selon la rapidité choisie.
func xp_mult() -> float:
	return float(XP_SPEED_MULT[clampi(xp_speed, 0, XP_SPEED_MULT.size() - 1)])
