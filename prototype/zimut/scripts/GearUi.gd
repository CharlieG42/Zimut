class_name GearUi
## GearUi.gd — petits utilitaires partagés par les écrans d'équipement (fiche Personnage,
## Inventaire) : ordre et noms des emplacements, icônes, texte d'un objet, tri et filtres.

const ART := "res://assets/ui/forge/"
const SLOT_ORDER: Array[String] = ["arme", "bouclier", "casque", "armure", "bottes", "bague",
	"collier", "gants", "boucle_oreille", "cape"]
const SLOT_LABEL := {
	"arme": "Arme", "bouclier": "Bouclier", "casque": "Casque", "armure": "Armure",
	"bottes": "Bottes", "bague": "Bague", "collier": "Collier", "gants": "Gants",
	"boucle_oreille": "Boucle d'oreille", "cape": "Cape",
}
const RARITY_LABEL := {"commun": "Commun", "rare": "Rare", "epique": "Épique", "legendaire": "Légendaire"}


static func slot_of(item: Dictionary) -> String:
	return ProgressionManager.slot_for_type(String(item.get("type", "")))


static func slot_label(slot: String) -> String:
	return String(SLOT_LABEL.get(slot, slot.capitalize()))


## Tuile d'icône d'un emplacement.
static func tile(slot: String, px: float) -> TextureRect:
	var t := TextureRect.new()
	var path: String = ART + "cat_%s.png" % (slot if SLOT_ORDER.has(slot) else "bague")
	t.texture = load(path) as Texture2D if ResourceLoader.exists(path) else null
	t.custom_minimum_size = Vector2(px, px)
	t.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	t.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	t.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return t


## Deux lignes : nom (rang) puis rareté · niveau · caractéristiques.
static func item_text(it: Dictionary) -> String:
	var fx: Array[String] = ItemRules.fx_lines(ItemRules.parse_effect(String(it.get("effect", ""))))
	return "%s\n%s · niv. %d · %s%s" % [ItemRules.display_name(it), ItemRules.rarity_label(it),
		int(it.get("level", 0)), ItemRules.stat_line(it), ("  ✦" if not fx.is_empty() else "")]


static func rarity_rank(it: Dictionary) -> int:
	return ItemRules.RARITY_ORDER.find(String(it.get("rarity", "commun")))
