extends Node
## PlayTimer.gd — Compteur de temps de jeu par partie (V46, autoload).
##
## Le temps ne tourne que pendant le jeu effectif : il démarre à l'entrée dans
## une scène de jeu (combat, Aventure, Conquête, sélection d'équipe) et se met en
## pause dès qu'on revient sur un écran de menu (Mes Parties, Accueil, Réglages).
## Le temps écoulé est ajouté à la sauvegarde : total ("playtime") et par mode
## ("playtime_modes"), affichés dans « Mes Parties ».
##
## Le mode suivi est déduit de la scène courante (pas besoin de le régler à la
## main) : Main.tscn + TeamSelection.tscn → "tactique", AdventureMap.tscn →
## "adventure", ConquestMap.tscn → "conquest".

signal playtime_updated(mode: String, seconds: float)

## Persiste le temps écoulé toutes les 10 s (et à chaque changement de scène).
const SAVE_EVERY := 10.0

var _running: bool = false       # le compteur tourne
var _mode: String = ""           # mode en cours ("" = aucun)
var _elapsed: float = 0.0       # secondes accumulées depuis le dernier flush
var _since_save: float = 0.0     # secondes depuis le dernier flush disque


func _ready() -> void:
	get_tree().node_added.connect(_on_node_added)
	# La scène de démarrage peut être déjà chargée quand l'autoload s'initialise.
	_check_scene.call_deferred()


func _process(delta: float) -> void:
	if not _running:
		return
	_elapsed += delta
	_since_save += delta
	if _since_save >= SAVE_EVERY:
		_flush()


func _exit_tree() -> void:
	_flush()


## Scène changée : le timer démarre ou se met en pause selon la nouvelle scène.
func _on_node_added(node: Node) -> void:
	if node == get_tree().current_scene:
		_check_scene()


func _check_scene() -> void:
	var scene: Node = get_tree().current_scene
	if scene == null:
		return
	var path: String = scene.scene_file_path
	if path.ends_with("/Main.tscn") or path.ends_with("/TeamSelection.tscn"):
		_start("tactique")
	elif path.ends_with("/AdventureMap.tscn"):
		_start("adventure")
	elif path.ends_with("/ConquestMap.tscn"):
		_start("conquest")
	else:
		_pause()


## Démarre le compteur pour `mode` (bascule de mode incluse : le temps déjà
## accumulé dans l'ancien mode est d'abord écrit dans la sauvegarde).
func _start(mode: String) -> void:
	if _running and _mode == mode:
		return
	if _running:
		_flush()
	_mode = mode
	_running = true
	_elapsed = 0.0
	_since_save = 0.0


## Met le compteur en pause et écrit le temps écoulé dans la sauvegarde.
func _pause() -> void:
	if not _running:
		return
	_flush()
	_running = false
	_mode = ""


## Écrit immédiatement le temps écoulé dans la sauvegarde. À appeler avant de
## quitter une scène de jeu en réinitialisant la partie active (sinon le temps
## depuis le dernier flush serait perdu).
func flush() -> void:
	_flush()


## Reprend le compteur en mode tactique (appelé quand une partie active est
## reprise depuis l'accueil : la scène cible, TeamSelection, démarre le timer
## d'elle-même via _check_scene, mais l'appel explicite couvre le cas où la
## scène courante ne change pas — ex. Continuer relancé depuis le menu pause).
func resume_tactique() -> void:
	_start("tactique")


## Ajoute le temps écoulé au total et au mode courant, puis l'écrit sur disque.
func _flush() -> void:
	if _elapsed <= 0.0:
		return
	var slot: int = GameManager.active_slot
	if slot < 0 or GameManager.active_save.is_empty():
		_elapsed = 0.0
		_since_save = 0.0
		return
	ProgressionManager.add_playtime(slot, GameManager.active_save, _mode, _elapsed)
	playtime_updated.emit(_mode, _elapsed)
	_elapsed = 0.0
	_since_save = 0.0
