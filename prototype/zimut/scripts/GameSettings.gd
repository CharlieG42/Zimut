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

## V42 : Mode Contre-la-montre (speedrun) — limite de tours par combat.
## 0 = désactivé, 1 = 10 tours, 2 = 6 tours, 3 = 3 tours.
## Si le joueur gagne avant la limite : bonus XP + or. Sinon : malus.
const SPEEDRUN_MODES: Array[String] = ["Désactivé", "10 tours", "6 tours", "3 tours"]
const SPEEDRUN_TURN_LIMIT := [0, 10, 6, 3]
const SPEEDRUN_XP_BONUS := [0.0, 0.15, 0.30, 0.50]
const SPEEDRUN_GOLD_BONUS := [0.0, 0.10, 0.25, 0.50]

## V42 : Timer de tour — limite de temps pour jouer son tour (tous personnages).
## 0 = désactivé, 1 = 10s, 2 = 20s, 3 = 30s, 4 = 60s.
## À l'expiration, le tour se termine automatiquement.
## 30 s est le mode par défaut (demande de CharlieG42).
const TURN_TIMER_MODES: Array[String] = ["Désactivé", "10 s", "20 s", "30 s", "60 s"]
const TURN_TIMER_SECONDS := [0.0, 10.0, 20.0, 30.0, 60.0]

## Vitesse des tours joués par l'ordinateur (ennemis, invocations, mode Auto).
const COMBAT_SPEEDS: Array[String] = ["Normale", "Rapide", "Très rapide"]
## V34 : vitesse des animations des personnages (poses d'attaque / incantation).
const ANIM_SPEEDS: Array[String] = ["Lente", "Normale", "Rapide", "Très rapide"]
const ANIM_SPEED_MULT: Array[float] = [1.5, 1.0, 0.7, 0.5]
const COMBAT_SPEED_MULT := [1.0, 2.0, 3.0]

var difficulty: int = 1
var combat_speed: int = 0
var anim_speed: int = 1
## V42 : index dans SPEEDRUN_MODES (0 = désactivé).
var speedrun_mode: int = 0
## V42 : index dans TURN_TIMER_MODES (0 = désactivé). Défaut = 30 s.
var turn_timer_mode: int = 3
## Sons d'effets / vibrations (V18)
## Langue : "fr" ou "en" (voir Loc.gd)
var language: String = "fr"
var sfx_on: bool = true
var haptics_on: bool = true
var xp_speed: int = 1
var text_size: int = 1
## Aide du premier combat déjà vue (ou passée).
var tutorial_done: bool = false
## Tutoriel guidé par Gultur : actif ? + étapes déjà vues { id: true }.
var tutorial_enabled: bool = true
var tuto_seen: Dictionary = {}

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
	tutorial_enabled = bool(parsed.get("tutorial_enabled", tutorial_enabled))
	var seen_v: Variant = parsed.get("tuto_seen", {})
	if typeof(seen_v) == TYPE_DICTIONARY:
		tuto_seen = seen_v
	combat_speed = clampi(int(parsed.get("combat_speed", combat_speed)), 0, COMBAT_SPEEDS.size() - 1)
	anim_speed = clampi(int(parsed.get("anim_speed", anim_speed)), 0, ANIM_SPEEDS.size() - 1)
	speedrun_mode = clampi(int(parsed.get("speedrun_mode", speedrun_mode)), 0, SPEEDRUN_MODES.size() - 1)
	turn_timer_mode = clampi(int(parsed.get("turn_timer_mode", turn_timer_mode)), 0, TURN_TIMER_MODES.size() - 1)
	sfx_on = bool(parsed.get("sfx_on", sfx_on))
	language = String(parsed.get("language", language))
	haptics_on = bool(parsed.get("haptics_on", haptics_on))
	_apply_sfx()

func save_settings() -> void:
	var f := FileAccess.open(SETTINGS_PATH, FileAccess.WRITE)
	if f == null:
		push_error("Impossible d'écrire les réglages")
		return
	f.store_string(JSON.stringify({"difficulty": difficulty, "xp_speed": xp_speed, "text_size": text_size, "tutorial_done": tutorial_done, "tutorial_enabled": tutorial_enabled, "tuto_seen": tuto_seen, "combat_speed": combat_speed, "anim_speed": anim_speed, "sfx_on": sfx_on, "haptics_on": haptics_on, "language": language, "speedrun_mode": speedrun_mode, "turn_timer_mode": turn_timer_mode}, "\t"))
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

func set_language(lang: String) -> void:
	language = lang
	save_settings()
	var loc: Node = get_node_or_null("/root/Loc")
	if loc != null:
		loc.call("apply")
	settings_changed.emit()

func set_sfx(on: bool) -> void:
	sfx_on = on
	_apply_sfx()
	save_settings()

func set_haptics(on: bool) -> void:
	haptics_on = on
	save_settings()

func _apply_sfx() -> void:
	var sfx: Node = get_node_or_null("/root/Sfx")
	if sfx != null:
		sfx.set("enabled", sfx_on)

func set_combat_speed(idx: int) -> void:
	combat_speed = clampi(idx, 0, COMBAT_SPEEDS.size() - 1)
	save_settings()
	settings_changed.emit()

## Forçage de la vitesse (simulations de test uniquement ; 0 = réglage du joueur).
var speed_override: float = 0.0

func set_anim_speed(idx: int) -> void:
	anim_speed = clampi(idx, 0, ANIM_SPEEDS.size() - 1)
	save_settings()

## V42 : définit le mode contre-la-montre.
func set_speedrun_mode(idx: int) -> void:
	speedrun_mode = clampi(idx, 0, SPEEDRUN_MODES.size() - 1)
	save_settings()
	settings_changed.emit()

## V42 : limite de tours du mode contre-la-montre (0 = désactivé).
func speedrun_turn_limit() -> int:
	return SPEEDRUN_TURN_LIMIT[clampi(speedrun_mode, 0, SPEEDRUN_TURN_LIMIT.size() - 1)]

## V42 : bonus XP si contre-la-montre réussi.
func speedrun_xp_bonus() -> float:
	return SPEEDRUN_XP_BONUS[clampi(speedrun_mode, 0, SPEEDRUN_XP_BONUS.size() - 1)]

## V42 : bonus or si contre-la-montre réussi.
func speedrun_gold_bonus() -> float:
	return SPEEDRUN_GOLD_BONUS[clampi(speedrun_mode, 0, SPEEDRUN_GOLD_BONUS.size() - 1)]

## V42 : définit le mode timer de tour.
func set_turn_timer_mode(idx: int) -> void:
	turn_timer_mode = clampi(idx, 0, TURN_TIMER_MODES.size() - 1)
	save_settings()
	settings_changed.emit()

## V42 : durée du timer de tour en secondes (0 = désactivé).
func turn_timer_seconds() -> float:
	return TURN_TIMER_SECONDS[clampi(turn_timer_mode, 0, TURN_TIMER_SECONDS.size() - 1)]


## Facteur de durée des poses (1 = normal, < 1 = plus rapide).
func anim_duration_mult() -> float:
	return float(ANIM_SPEED_MULT[clampi(anim_speed, 0, ANIM_SPEED_MULT.size() - 1)])


func combat_speed_mult() -> float:
	if speed_override > 0.0:
		return speed_override
	return float(COMBAT_SPEED_MULT[clampi(combat_speed, 0, COMBAT_SPEED_MULT.size() - 1)])

## Marque une étape du tutoriel de Gultur comme vue.
func mark_tuto_seen(id: String) -> void:
	tuto_seen[id] = true
	save_settings()

## « Passer le tutoriel » : désactive Gultur et l'aide du premier combat.
func skip_tutorial() -> void:
	tutorial_enabled = false
	tutorial_done = true
	save_settings()

## Relance le tutoriel depuis le début (Options).
func restart_tutorial() -> void:
	tutorial_enabled = true
	tutorial_done = false
	tuto_seen = {}
	save_settings()

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
