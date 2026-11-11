extends RefCounted
## V146 : notifications locales Android (rappel avant une offensive d'absence en Conquête).
##
## Godot ne sait pas programmer une notification sans module natif. Ce script parle à un module Android
## nommé « ZimutNotify » S'IL EST PRÉSENT, et ne fait rien sinon (PC, tests, APK actuel). Contrat attendu :
##   schedule(id: int, title: String, text: String, delay_seconds: int)   — remplace celle du même id
##   cancel(id: int)
## Tant que l'APK est exporté sans Gradle (export_presets.cfg : use_gradle_build=false), aucun module natif
## ne peut être embarqué : voir TODO.md.

const PLUGIN := "ZimutNotify"
const ID_ABSENCE := 4601
const WARN_BEFORE_SECONDS := 86400      ## prévenir un jour avant la première offensive


static func available() -> bool:
	return Engine.has_singleton(PLUGIN)


## Programme (ou annule si `seconds_before_offensive` <= 0) le rappel « votre empire est menacé ».
## Renvoie le délai retenu en secondes (0 = rien de programmé) : utile aux tests.
static func schedule_absence_warning(seconds_before_offensive: int) -> int:
	var delay: int = seconds_before_offensive - WARN_BEFORE_SECONDS
	if seconds_before_offensive <= 0 or delay <= 0:
		if available():
			Engine.get_singleton(PLUGIN).call("cancel", ID_ABSENCE)
		return 0
	if available():
		Engine.get_singleton(PLUGIN).call("schedule", ID_ABSENCE, "Zimut — votre empire est menacé",
			"Sans bataille de Conquête d'ici demain, le Roi Squelette lancera une offensive sur vos villes.", delay)
	return delay
