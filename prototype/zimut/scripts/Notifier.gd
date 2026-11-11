extends RefCounted
## Notifications locales Android : rappel avant une offensive d'absence en Conquête (V146, branché V147).
##
## S'appuie sur le module libre « Notification Scheduler » (addons/NotificationSchedulerPlugin, licence MIT,
## github.com/godot-mobile-plugins/godot-notification-scheduler), embarqué par l'export Android en Gradle.
## Hors Android (PC, tests) ou si le module est absent, rien n'est programmé et rien ne casse.
## Le réglage « Rappels de Conquête » (GameSettings.notifications_on) coupe tout.

const SINGLETON := "NotificationSchedulerPlugin"
const SERVICE_SCRIPT := "res://scripts/NotifierService.gd"
const SERVICE_NODE := "ZimutNotifier"
const ID_ABSENCE := 4601
const WARN_BEFORE_SECONDS := 86400      ## prévenir un jour avant la première offensive
## Mode test (APK de vérification uniquement) : > 0 = rappel envoyé N secondes après l'ouverture de la carte de
## Conquête, quel que soit l'empire. Toujours 0 dans le jeu normal.
const TEST_DELAY_SECONDS := 120
const TITLE := "Zimut — votre empire est menacé"
const TEXT := "Sans bataille de Conquête d'ici demain, le Roi Squelette lancera une offensive sur vos villes."


static func available() -> bool:
	return Engine.has_singleton(SINGLETON)


static func _enabled() -> bool:
	var gs: Node = _tree_node("/root/GameSettings")
	return gs == null or bool(gs.get("notifications_on"))


static func _tree_node(path: String) -> Node:
	var tree: SceneTree = Engine.get_main_loop() as SceneTree
	return tree.root.get_node_or_null(path) if tree != null else null


## Service (nœud) qui parle au module : créé à la demande, une seule fois. null hors Android.
static func _service() -> Node:
	if not available():
		return null
	var tree: SceneTree = Engine.get_main_loop() as SceneTree
	if tree == null:
		return null
	var node: Node = tree.root.get_node_or_null(SERVICE_NODE)
	if node == null:
		node = (load(SERVICE_SCRIPT) as GDScript).new()
		node.name = SERVICE_NODE
		tree.root.add_child.call_deferred(node)
	return node


## Délai du rappel en secondes pour une offensive dans `seconds_before_offensive` (0 = pas de rappel).
static func absence_delay(seconds_before_offensive: int) -> int:
	if seconds_before_offensive <= 0:
		return 0
	return maxi(0, seconds_before_offensive - WARN_BEFORE_SECONDS)


## Programme (ou annule) le rappel « votre empire est menacé ». Renvoie le délai retenu (0 = rien).
static func schedule_absence_warning(seconds_before_offensive: int) -> int:
	var delay: int = absence_delay(seconds_before_offensive) if _enabled() else 0
	if TEST_DELAY_SECONDS > 0 and _enabled():
		delay = TEST_DELAY_SECONDS
	var svc: Node = _service()
	if svc != null:
		if delay > 0:
			svc.call("request", ID_ABSENCE, TITLE, TEXT, delay)
		else:
			svc.call("cancel_id", ID_ABSENCE)
	return delay


static func cancel_all() -> void:
	var svc: Node = _service()
	if svc != null:
		svc.call("cancel_id", ID_ABSENCE)
