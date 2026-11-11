extends SceneTree
## V147 : notifications Android (module Notification Scheduler) — ce qui se vérifie hors téléphone.
## Lancement : godot --headless --path . -s tests/test_v147_notifications.gd
var fails: int = 0
func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var N: GDScript = load("res://scripts/Notifier.gd")
	var gs: Node = root.get_node("/root/GameSettings")
	# module embarqué dans le projet
	check(FileAccess.file_exists("res://addons/NotificationSchedulerPlugin/plugin.cfg"), "module présent dans addons/")
	check(FileAccess.file_exists("res://addons/NotificationSchedulerPlugin/bin/release/NotificationSchedulerPlugin-release.aar")
		and FileAccess.file_exists("res://addons/NotificationSchedulerPlugin/bin/debug/NotificationSchedulerPlugin-debug.aar"), "bibliothèques Android (.aar) debug et release présentes")
	var icons_ok := FileAccess.file_exists("res://assets/NotificationSchedulerPlugin/android/drawable-anydpi-v24/ic_zimut_notification.xml") \
		and FileAccess.file_exists("res://assets/NotificationSchedulerPlugin/android/drawable-xxhdpi/zimut_notification_large.png")
	for dens: String in ["mdpi", "hdpi", "xhdpi", "xxhdpi", "xxxhdpi"]:
		icons_ok = icons_ok and FileAccess.file_exists("res://assets/NotificationSchedulerPlugin/android/drawable-%s/ic_zimut_notification.png" % dens)
	check(icons_ok, "icônes Zimut présentes (petite icône pour 5 densités + vectorielle, grande icône)")
	var svc_src: String = FileAccess.get_file_as_string("res://scripts/NotifierService.gd")
	check(svc_src.contains("ic_zimut_notification") and svc_src.contains("zimut_notification_large"), "la notification utilise les icônes Zimut")
	var plugins: PackedStringArray = ProjectSettings.get_setting("editor_plugins/enabled", PackedStringArray())
	check(plugins.has("res://addons/NotificationSchedulerPlugin/plugin.cfg"), "module activé dans project.godot")
	var presets := ConfigFile.new()
	presets.load("res://export_presets.cfg")
	var android_sec: String = ""
	for sec: String in presets.get_sections():
		if sec.ends_with(".options") and String(presets.get_value(sec.trim_suffix(".options"), "platform", "")) == "Android":
			android_sec = sec
	check(android_sec != "" and bool(presets.get_value(android_sec, "gradle_build/use_gradle_build", false)), "export Android en Gradle (indispensable au module)")
	check(android_sec != "" and bool(presets.get_value(android_sec, "permissions/post_notifications", false)), "permission POST_NOTIFICATIONS demandée")
	# les scripts du module se chargent sans erreur
	for p: String in ["res://addons/NotificationSchedulerPlugin/NotificationScheduler.gd", "res://addons/NotificationSchedulerPlugin/model/NotificationData.gd",
			"res://addons/NotificationSchedulerPlugin/model/NotificationChannel.gd", "res://scripts/NotifierService.gd"]:
		check(load(p) != null, "%s se charge" % p.get_file())
	# hors Android : rien n'est programmé, rien ne casse, le délai reste juste
	check(not N.available(), "PC / tests : module natif absent")
	gs.set("notifications_on", true)
	check(N.schedule_absence_warning(3 * 86400) == 2 * 86400, "rappel un jour avant l'offensive")
	check(N.schedule_absence_warning(3600) == 0 and N.schedule_absence_warning(0) == 0, "offensive trop proche ou déjà due : pas de rappel")
	gs.set("notifications_on", false)
	check(N.schedule_absence_warning(3 * 86400) == 0, "réglage « Rappels de Conquête » désactivé : rien de programmé")
	gs.set("notifications_on", true)
	N.cancel_all()
	check(root.get_node_or_null(N.SERVICE_NODE) == null, "aucun service créé hors Android")
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
