class_name GfxQuality
extends RefCounted
## GfxQuality.gd — Niveau de détail graphique (Réglages → « Qualité graphique »).
## Auto : « Économie » sur les téléphones modestes (moins de 6 cœurs), « Haute » sinon.
## Économie : herbe ×0,5, particules ×0,5, pas de halo lumineux (glow), moins d'effets de sorts
## simultanés, décors de sol masqués plus tôt au loin.

const LABELS: Array[String] = ["Auto", "Économie", "Haute"]


static func _setting() -> int:
	var tree := Engine.get_main_loop() as SceneTree
	if tree == null:
		return 0
	var gs: Node = tree.root.get_node_or_null("GameSettings")
	if gs == null or gs.get("graphics_quality") == null:
		return 0
	return int(gs.get("graphics_quality"))


## Vrai si on doit alléger le rendu.
static func low() -> bool:
	match _setting():
		1:
			return true
		2:
			return false
	return OS.has_feature("mobile") and OS.get_processor_count() < 6


## Facteur de densité (herbe, particules) : 1 en Haute, 0,5 en Économie.
static func density() -> float:
	return 0.5 if low() else 1.0
