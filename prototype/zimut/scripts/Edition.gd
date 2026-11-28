class_name Edition
extends RefCounted
## Edition.gd — Édition du jeu : DÉMO (Play Store) ou version complète (V460).
##
## · L'édition est choisie À L'EXPORT par les « custom features » du preset Android :
##     « demo »      → version démo (plafond de niveau, bandeau, lien vers la version complète)
##     « playstore » → build distribué par Google Play (aucune mise à jour hors du Play Store)
##   Dans l'éditeur et sur PC, aucune de ces étiquettes n'existe : le jeu est complet.
## · La démo est une application distincte (package « com.zimut.iso.demo ») : ses sauvegardes
##   locales sont donc séparées de celles de la version complète.
## · Plafond de démo : le joueur (et donc ses héros, qui ne dépassent jamais son niveau)
##   s'arrête au niveau DEMO_MAX_LEVEL ; l'XP excédentaire n'est pas conservée.

const DEMO_MAX_LEVEL := 16
const FULL_PACKAGE := "com.zimut.iso"
## Politique de confidentialité hébergée (GitHub Pages, dossier docs/ du dépôt) : lien exigé par Google Play.
const PRIVACY_URL := "https://charlieg42.github.io/Zimut/privacy.html"

## Forçage pour les tests automatiques (-1 = pas de forçage, 0 = complet, 1 = démo).
static var _forced: int = -1


static func is_demo() -> bool:
	if _forced >= 0:
		return _forced == 1
	return OS.has_feature("demo")


## Build distribué par le Play Store : pas d'installation d'APK ni de mise à jour GitHub.
static func is_store_build() -> bool:
	return is_demo() or OS.has_feature("playstore")


## Niveau maximum du joueur / des héros dans cette édition.
static func max_level() -> int:
	return mini(DEMO_MAX_LEVEL, ClassRules.MAX_LEVEL) if is_demo() else ClassRules.MAX_LEVEL


static func force_demo(on: bool) -> void:
	_forced = 1 if on else 0


static func clear_force() -> void:
	_forced = -1


## Fiche Play Store de la version complète (ouverte par le bouton « Version complète »).
static func store_url() -> String:
	return "market://details?id=" + FULL_PACKAGE


static func store_web_url() -> String:
	return "https://play.google.com/store/apps/details?id=" + FULL_PACKAGE


## Ouvre la fiche de la version complète (application Play Store, sinon navigateur).
static func open_full_version() -> void:
	if OS.has_feature("android"):
		if OS.shell_open(store_url()) == OK:
			return
	OS.shell_open(store_web_url())


## Libellé court affiché sur l'accueil et dans les Réglages.
static func demo_banner_text() -> String:
	return "VERSION DÉMO · niveau %d maximum" % DEMO_MAX_LEVEL
