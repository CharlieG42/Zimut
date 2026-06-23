extends Button
class_name SpellButton
## SpellButton.gd - Bouton de sort avec police agrandie pour mobile

var spell: Dictionary = {}

signal spell_selected(spell: Dictionary)

func _ready():
    pressed.connect(_on_pressed)
    add_theme_font_size_override("font_size", 24)

    if spell:
        text = spell.get("name", "Sort")
        var cost_text = ""
        if spell.get("cost_pa", 0) > 0:
            cost_text += "PA: %d" % spell["cost_pa"]
        if spell.get("cost_pm", 0) > 0:
            if cost_text:
                cost_text += " | "
            cost_text += "PM: %d" % spell["cost_pm"]
        if cost_text:
            text += " (" + cost_text + ")"
        var type_color = Color.WHITE
        match spell.get("spell_type", ""):
            "CAC":
                type_color = Color(0.8, 0.2, 0.2)
            "Magie":
                type_color = Color(0.2, 0.2, 0.8)
            "Defense":
                type_color = Color(0.2, 0.8, 0.2)
            "Soin":
                type_color = Color(0.8, 0.8, 0.2)
        add_theme_color_override("font_color", type_color)
        add_theme_color_override("font_pressed_color", type_color.darkened(0.5))
        add_theme_color_override("font_hover_color", type_color.lightened(0.2))

func _on_pressed():
    spell_selected.emit(spell)