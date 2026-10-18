extends Node

## GameSettings.gd — Réglages globaux du jeu (autoload) : rapidité de progression XP
## (persistée dans user://settings.json). La difficulté des combats est PROPRE À CHAQUE
## PARTIE (clé « difficulty » de la sauvegarde, réglable dans « Mes Parties ») ; la
## variable `difficulty` ci-dessous ne sert que de valeur par défaut (partie sans réglage).

signal settings_changed

const SETTINGS_PATH := "user://settings.json"

## Difficulté : index dans DIFFICULTIES (0 = Facile, 3 = Enfer).
const DIFFICULTIES: Array[String] = ["Facile", "Normal", "Difficile", "Enfer"]
## Enfer augmente surtout la résistance : les PV dépassent Difficile de 37,5 %.
## Les attaques d'Enfer restent au même niveau que Difficile pour éviter un pic injuste.
const DIFFICULTY_HP_POWER := [0.85, 1.0, 1.2, 1.65]
const DIFFICULTY_ATK_POWER := [0.85, 1.0, 1.2, 1.2]

## Rapidité XP : index dans XP_SPEEDS.
const XP_SPEEDS: Array[String] = ["Lente", "Normale", "Rapide"]
const XP_SPEED_MULT := [0.6, 1.0, 1.6]

## Taille du texte des menus (agrandissement des interfaces, voir UiFit.gd).
const TEXT_SIZES: Array[String] = ["Normal", "Grand", "Très grand"]
const TEXT_SIZE_MULT := [1.0, 1.15, 1.3]

## Vitesse des tours joués par l'ordinateur (ennemis, invocations, mode Auto).
const COMBAT_SPEEDS: Array[String] = ["Normale", "Rapide", "Très rapide"]
const COMBAT_SPEED_MULT := [1.0, 2.0, 3.0]

var difficulty: int = 1
var combat_speed: int = 0
var xp_speed: int = 1
var text_size: int = 1
## Aide du premier combat déjà vue (ou passée).
var tutorial_done: bool = false

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
	text_size = clampi(int(parsed.get("text_size", text_size)), 0, TEXT_SIZES.size() - 1)
	tutorial_done = bool(parsed.get("tutorial_done", tutorial_done))
	combat_speed = clampi(int(parsed.get("combat_speed", combat_speed)), 0, COMBAT_SPEEDS.size() - 1)

func save_settings() -> void:
	var f := FileAccess.open(SETTINGS_PATH, FileAccess.WRITE)
	if f == null:
		push_error("Impossible d'écrire les réglages")
		return
	f.store_string(JSON.stringify({"difficulty": difficulty, "xp_speed": xp_speed, "text_size": text_size, "tutorial_done": tutorial_done, "combat_speed": combat_speed}, "\t"))
	f.close()

func set_difficulty(idx: int) -> void:
	difficulty = clampi(idx, 0, DIFFICULTIES.size() - 1)
	save_settings()
	settings_changed.emit()

func set_xp_speed(idx: int) -> void:
	xp_speed = clampi(idx, 0, XP_SPEEDS.size() - 1)
	save_settings()
	settings_changed.emit()

func set_text_size(idx: int) -> void:
	text_size = clampi(idx, 0, TEXT_SIZES.size() - 1)
	save_settings()
	settings_changed.emit()

func set_combat_speed(idx: int) -> void:
	combat_speed = clampi(idx, 0, COMBAT_SPEEDS.size() - 1)
	save_settings()
	settings_changed.emit()

## Forçage de la vitesse (simulations de test uniquement ; 0 = réglage du joueur).
var speed_override: float = 0.0

func combat_speed_mult() -> float:
	if speed_override > 0.0:
		return speed_override
	return float(COMBAT_SPEED_MULT[clampi(combat_speed, 0, COMBAT_SPEED_MULT.size() - 1)])

func set_tutorial_done(v: bool) -> void:
	tutorial_done = v
	save_settings()

## Facteur d'agrandissement choisi par le joueur (1.0 = taille de base).
func text_mult() -> float:
	return float(TEXT_SIZE_MULT[clampi(text_size, 0, TEXT_SIZE_MULT.size() - 1)])

func difficulty_label() -> String:
	return DIFFICULTIES[clampi(difficulty, 0, DIFFICULTIES.size() - 1)]

func xp_speed_label() -> String:
	return XP_SPEEDS[clampi(xp_speed, 0, XP_SPEEDS.size() - 1)]

## Difficulté d'une partie (sauvegarde) ; à défaut, la valeur par défaut.
func save_difficulty(save: Dictionary) -> int:
	return clampi(int(save.get("difficulty", difficulty)), 0, DIFFICULTIES.size() - 1)

func save_difficulty_label(save: Dictionary) -> String:
	return DIFFICULTIES[save_difficulty(save)]

## Multiplicateurs de PV et d'attaque des ennemis selon la difficulté de la partie
## (`save` vide = difficulté par défaut).
func enemy_hp_mult(save: Dictionary = {}) -> float:
	return float(DIFFICULTY_HP_POWER[save_difficulty(save)])

func enemy_attack_mult(save: Dictionary = {}) -> float:
	return float(DIFFICULTY_ATK_POWER[save_difficulty(save)])

## Compatibilité pour les éventuels scripts externes qui utilisent l'ancien nom.
func enemy_power_mult() -> float:
	return enemy_attack_mult()

## Multiplicateur du gain d'XP par combat selon la rapidité choisie.
func xp_mult() -> float:
	return float(XP_SPEED_MULT[clampi(xp_speed, 0, XP_SPEED_MULT.size() - 1)])
