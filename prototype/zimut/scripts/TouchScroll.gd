class_name TouchScroll
extends Node
## TouchScroll.gd — Défilement au doigt sur TOUTE la zone d'un ScrollContainer (pas seulement
## sa barre) : on pose le doigt n'importe où (même sur un bouton ou un panneau) et on glisse.
## Un appui court reste un clic normal ; au-delà de THRESHOLD px, c'est un défilement et le
## clic de fin est annulé. Usage : TouchScroll.install(mon_scroll_container).

const THRESHOLD := 14.0

var _sc: ScrollContainer
## Zone où le défilement tactile ne s'applique pas (ex. carte à déplacement propre).
var exclude: Control = null
var _down: bool = false
var _dragging: bool = false
var _start := Vector2.ZERO
var _last := Vector2.ZERO


static func install(sc: ScrollContainer) -> ScrollContainer:
	var ts := TouchScroll.new()
	ts._sc = sc
	ts.name = "TouchScroll"
	sc.add_child(ts)
	return sc


func _input(event: InputEvent) -> void:
	if _sc == null or not is_instance_valid(_sc) or not _sc.is_visible_in_tree():
		return
	if event is InputEventMouseButton and (event as InputEventMouseButton).button_index == MOUSE_BUTTON_LEFT:
		var mb := event as InputEventMouseButton
		if mb.pressed:
			_down = false
			_dragging = false
			if _sc.get_global_rect().has_point(mb.global_position) and not _on_range(mb.global_position) \
					and not (exclude != null and is_instance_valid(exclude) and exclude.get_global_rect().has_point(mb.global_position)):
				_down = true
				_start = mb.global_position
				_last = mb.global_position
		else:
			var was: bool = _dragging
			_down = false
			_dragging = false
			if was:
				get_viewport().set_input_as_handled()
	elif event is InputEventMouseMotion and _down:
		var mm := event as InputEventMouseMotion
		if not _dragging:
			if (mm.global_position - _start).length() < THRESHOLD:
				return
			_dragging = true
			_last = mm.global_position
			var f: Control = get_viewport().gui_get_focus_owner()
			if f != null:
				f.release_focus()
		var d: Vector2 = mm.global_position - _last
		_last = mm.global_position
		if _sc.vertical_scroll_mode != ScrollContainer.SCROLL_MODE_DISABLED:
			_sc.scroll_vertical = int(_sc.scroll_vertical - d.y)
		if _sc.horizontal_scroll_mode != ScrollContainer.SCROLL_MODE_DISABLED:
			_sc.scroll_horizontal = int(_sc.scroll_horizontal - d.x)
		get_viewport().set_input_as_handled()


func _on_range(pos: Vector2) -> bool:
	var h: Control = get_viewport().gui_get_hovered_control()
	return h is Range or h is LineEdit or h is TextEdit
