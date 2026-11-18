extends CanvasLayer
## DeckPickUI.gd — Choix du deck avant un duel du mode Cartes (V401).
## Ouvert par la tuile « Cartes » de Mes Parties : liste les decks de data/decks.txt (sauf celui des
## ennemis) avec leur composition (types de cartes, coût moyen) ; le choix est mémorisé dans la
## sauvegarde (clé « cards_deck ») et le duel démarre.

signal picked(deck_name: String)
signal closed

const GOLD := Color(1.0, 0.85, 0.40)
const ENEMY_DECK := "Deck de test ennemis"
## Noms d'affichage (le deck historique garde son nom de données pour les anciennes sauvegardes).
const LABELS := {"Deck de test": "Équilibré"}
const BLURBS := {
	"Deck de test": "Un peu de tout : trois invocations, des attaques, des soins et des renforts.",
	"Assaut": "Beaucoup de dégâts directs, presque aucun soin : finissez le champion ennemi avant lui.",
	"Invocateurs": "Neuf invocations pour tenir le terrain et protéger votre champion, soutenues par des soins.",
	"Magie et soutien": "Sorts à distance et soins : gardez vos distances et durez plus longtemps.",
}


## Noms des decks proposables (ordre du fichier, sans le deck des ennemis).
static func deck_names() -> Array:
	var out: Array = []
	for nm: Variant in DataLoader.get_deck_names():
		if String(nm) != ENEMY_DECK:
			out.append(String(nm))
	return out


## Composition d'un deck : {total, avg_cost, attack, support, summon}.
static func summarize(deck_name: String) -> Dictionary:
	var names: Array = DataLoader.get_deck_cards(deck_name)
	var attack: int = 0
	var support: int = 0
	var summon: int = 0
	var cost: int = 0
	var total: int = 0
	for nm: Variant in names:
		var row: Dictionary = DataLoader.get_card_by_name(String(nm))
		if row.is_empty():
			continue
		total += 1
		cost += int(row.get("Cout_PA", "1"))
		match String(row.get("Type", "Attaque")):
			"Invocation":
				summon += 1
			"Soin", "Buff":
				support += 1
			_:
				attack += 1
	return {"total": total, "avg_cost": float(cost) / float(maxi(total, 1)), "attack": attack, "support": support, "summon": summon}


func open(current: String) -> void:
	layer = 30
	var dim := ColorRect.new()
	dim.color = Color(0, 0, 0, 0.70)
	dim.set_anchors_preset(Control.PRESET_FULL_RECT)
	dim.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(dim)
	var panel := PanelContainer.new()
	panel.set_anchors_preset(Control.PRESET_CENTER)
	panel.grow_horizontal = Control.GROW_DIRECTION_BOTH
	panel.grow_vertical = Control.GROW_DIRECTION_BOTH
	panel.custom_minimum_size = Vector2(900, 0)
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0.07, 0.08, 0.15, 0.98)
	sb.border_color = GOLD
	sb.set_border_width_all(3)
	sb.set_corner_radius_all(18)
	sb.content_margin_left = 26
	sb.content_margin_right = 26
	sb.content_margin_top = 20
	sb.content_margin_bottom = 22
	panel.add_theme_stylebox_override("panel", sb)
	dim.add_child(panel)
	var vb := VBoxContainer.new()
	vb.add_theme_constant_override("separation", 12)
	panel.add_child(vb)
	var title := Label.new()
	title.text = "CHOISIR UN DECK"
	title.add_theme_font_size_override("font_size", 34)
	title.add_theme_color_override("font_color", GOLD)
	vb.add_child(title)
	var sub := Label.new()
	sub.text = "Mana commun : 3 à la première manche, +1 par manche. Chaque camp désigne un champion : s'il tombe, le duel est perdu."
	sub.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	sub.add_theme_font_size_override("font_size", 17)
	sub.add_theme_color_override("font_color", Color(0.7, 0.76, 0.88))
	vb.add_child(sub)
	for nm: String in deck_names():
		vb.add_child(_deck_row(nm, nm == current))
	var cancel := Button.new()
	cancel.text = "Annuler"
	cancel.add_theme_font_size_override("font_size", 22)
	cancel.custom_minimum_size = Vector2(0, 52)
	cancel.pressed.connect(func() -> void:
		closed.emit())
	vb.add_child(cancel)


func _deck_row(nm: String, is_current: bool) -> Control:
	var info: Dictionary = summarize(nm)
	var b := Button.new()
	b.custom_minimum_size = Vector2(0, 104)
	b.text = ""
	b.focus_mode = Control.FOCUS_NONE
	var st := StyleBoxFlat.new()
	st.bg_color = Color(0.13, 0.15, 0.26) if not is_current else Color(0.22, 0.20, 0.10)
	st.border_color = GOLD if is_current else Color(0.35, 0.42, 0.62)
	st.set_border_width_all(3 if is_current else 2)
	st.set_corner_radius_all(12)
	b.add_theme_stylebox_override("normal", st)
	var hv: StyleBoxFlat = st.duplicate()
	hv.bg_color = st.bg_color.lightened(0.12)
	b.add_theme_stylebox_override("hover", hv)
	b.add_theme_stylebox_override("pressed", hv)
	var box := VBoxContainer.new()
	box.set_anchors_preset(Control.PRESET_FULL_RECT)
	box.offset_left = 18
	box.offset_top = 8
	box.offset_right = -18
	box.offset_bottom = -8
	box.mouse_filter = Control.MOUSE_FILTER_IGNORE
	b.add_child(box)
	var head := Label.new()
	head.text = String(LABELS.get(nm, nm)) + ("   ✔ dernier deck joué" if is_current else "")
	head.add_theme_font_size_override("font_size", 26)
	head.add_theme_color_override("font_color", Color(1, 0.96, 0.8))
	head.mouse_filter = Control.MOUSE_FILTER_IGNORE
	box.add_child(head)
	var stats := Label.new()
	stats.text = "%d cartes  ·  coût moyen %.1f  ·  %d attaques  ·  %d soins / renforts  ·  %d invocations" % [
		int(info["total"]), float(info["avg_cost"]), int(info["attack"]), int(info["support"]), int(info["summon"])]
	stats.add_theme_font_size_override("font_size", 17)
	stats.add_theme_color_override("font_color", Color(0.65, 0.85, 1.0))
	stats.mouse_filter = Control.MOUSE_FILTER_IGNORE
	box.add_child(stats)
	var blurb := Label.new()
	blurb.text = String(BLURBS.get(nm, ""))
	blurb.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	blurb.add_theme_font_size_override("font_size", 16)
	blurb.add_theme_color_override("font_color", Color(0.78, 0.8, 0.88))
	blurb.mouse_filter = Control.MOUSE_FILTER_IGNORE
	box.add_child(blurb)
	b.pressed.connect(func() -> void:
		picked.emit(nm))
	return b
