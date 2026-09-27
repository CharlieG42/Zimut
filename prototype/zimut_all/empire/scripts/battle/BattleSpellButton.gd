extends Button
class_name BattleSpellButton

## BattleSpellButton.gd - Bouton de sort du combat tactique (mode Empire).
## Portage de prototype/zimut/scripts/SpellButton.gd (police agrandie pour mobile).

var spell: Dictionary = {}

signal spell_selected(spell: Dictionary)

func _ready() -> void:
	pressed.connect(_on_pressed)
	add_theme_font_size_override("font_size", 24)
	if not spell.is_empty():
		setup_spell(spell)

func setup_spell(s: Dictionary) -> void:
	spell = s
	if spell.is_empty():
		return
	var spell_name: String = spell.get("name", "Sort")
	var cost_pa: int = int(spell.get("cost_pa", 0))
	var cost_pm: int = int(spell.get("cost_pm", 0))
	var cost_text: String = ""
	if cost_pa > 0:
		cost_text += "PA:%d" % cost_pa
	if cost_pm > 0:
		if cost_text != "":
			cost_text += " "
		cost_text += "PM:%d" % cost_pm
	text = "%s (%s)" % [spell_name, cost_text] if cost_text != "" else spell_name
	var stype: String = spell.get("spell_type", spell.get("Type", ""))
	var type_color: Color = Color.WHITE
	match stype:
		"Attaque", "CAC":
			type_color = Color(0.9, 0.3, 0.3)
		"Magie":
			type_color = Color(0.4, 0.4, 1.0)
		"Défense", "Buff":
			type_color = Color(0.3, 0.9, 0.3)
		"Soin":
			type_color = Color(0.9, 0.9, 0.3)
	add_theme_color_override("font_color",         type_color)
	add_theme_color_override("font_pressed_color", type_color.darkened(0.4))
	add_theme_color_override("font_hover_color",   type_color.lightened(0.2))

func _on_pressed() -> void:
	spell_selected.emit(spell)
