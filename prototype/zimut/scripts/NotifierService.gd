extends Node
## V147 : nœud qui pilote le module Android « Notification Scheduler » (voir Notifier.gd).
## Créé à la demande sous /root, seulement quand le module est présent (Android).
## Ordre imposé par le module : initialiser → canal → permission → programmer. Les demandes arrivées
## avant la fin de l'initialisation sont gardées et envoyées ensuite (seule la dernière compte).

const CHANNEL_ID := "zimut_conquete"
## Icônes aux couleurs de Zimut (assets/NotificationSchedulerPlugin/android) : petite icône = étoile-boussole
## du logo en silhouette blanche (règle Android), grande icône = le héros et son familier, en couleur.
const SMALL_ICON := "ic_zimut_notification"
const LARGE_ICON := "zimut_notification_large"

var _scheduler: Node
var _ready_done: bool = false
var _pending: Dictionary = {}          ## dernière demande en attente {id, title, text, delay}
var _asked_permission: bool = false


func _ready() -> void:
	var cls: GDScript = load("res://addons/NotificationSchedulerPlugin/NotificationScheduler.gd")
	_scheduler = cls.new()
	add_child(_scheduler)
	_scheduler.connect("initialization_completed", _on_initialized)
	_scheduler.connect("post_notifications_permission_granted", _on_permission_granted)
	_scheduler.call("initialize")


func _on_initialized() -> void:
	var ch_cls: GDScript = load("res://addons/NotificationSchedulerPlugin/model/NotificationChannel.gd")
	var ch: RefCounted = ch_cls.new()
	ch.call("set_id", CHANNEL_ID)
	ch.call("set_name", "Conquête")
	ch.call("set_description", "Rappels avant une offensive du Roi Squelette sur votre empire.")
	ch.call("set_importance", 3)       # NotificationChannel.Importance.DEFAULT
	_scheduler.call("create_notification_channel", ch)
	_ready_done = true
	_flush()


func _on_permission_granted(_name: String) -> void:
	_flush()


## Programme une notification (remplace celle du même id).
func request(id: int, title: String, text: String, delay: int) -> void:
	_pending = {"id": id, "title": title, "text": text, "delay": delay}
	_flush()


func cancel_id(id: int) -> void:
	if _pending.get("id", -1) == id:
		_pending = {}
	if _ready_done:
		_scheduler.call("cancel", id)


func _flush() -> void:
	if not _ready_done or _pending.is_empty():
		return
	if not bool(_scheduler.call("has_post_notifications_permission")):
		# Android 13+ : on demande la permission au moment où un rappel devient utile, une fois par session.
		if not _asked_permission:
			_asked_permission = true
			_scheduler.call("request_post_notifications_permission")
		return
	var data_cls: GDScript = load("res://addons/NotificationSchedulerPlugin/model/NotificationData.gd")
	var d: RefCounted = data_cls.new()
	d.call("set_id", int(_pending["id"]))
	d.call("set_channel_id", CHANNEL_ID)
	d.call("set_title", String(_pending["title"]))
	d.call("set_content", String(_pending["text"]))
	d.call("set_delay", int(_pending["delay"]))
	d.call("set_small_icon_name", SMALL_ICON)
	d.call("set_large_icon_name", LARGE_ICON)
	_scheduler.call("cancel", int(_pending["id"]))
	_scheduler.call("schedule", d)
	_pending = {}
