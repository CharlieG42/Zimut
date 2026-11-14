class_name CanvasBake
extends Node2D
## CanvasBake.gd — V360 : fige un dessin STATIQUE en UNE texture.
##
## Un dessin par code (draw_polygon, draw_line…) est conservé par Godot mais RE-SOUMIS à chaque image :
## 100 cases du plateau ou un fond de ciel en bandes, ce sont des centaines d'appels de dessin par image,
## alors que rien ne bouge. Ici le dessin est exécuté une seule fois dans un SubViewport (rendu unique) puis
## affiché par un simple Sprite2D : 1 appel de dessin.
##
## Usage : `var ok: bool = await bake.bake(zone, 1.25, peintre)` où `peintre` est un Callable(ci: CanvasItem)
## qui dessine sur `ci` en coordonnées de la scène. Pendant la préparation (2 images) le Sprite2D reste
## caché : l'appelant continue de dessiner lui-même, puis bascule quand `bake()` rend `true`.
## Un nouvel appel de `bake()` annule le précédent (il rend alors `false`).

## Peintre : un Node2D dont _draw délègue au Callable.
class Painter extends Node2D:
	var fn: Callable
	func _draw() -> void:
		if fn.is_valid():
			fn.call(self)

var zone: Rect2 = Rect2()
var pixel_scale: float = 1.0
var _vp: SubViewport
var _painter: Painter
var _sprite: Sprite2D
var _serial: int = 0


func _init() -> void:
	_vp = SubViewport.new()
	_vp.transparent_bg = true
	_vp.disable_3d = true
	_vp.canvas_item_default_texture_filter = Viewport.DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_NEAREST
	_vp.render_target_update_mode = SubViewport.UPDATE_DISABLED
	_vp.render_target_clear_mode = SubViewport.CLEAR_MODE_ALWAYS
	add_child(_vp)
	_painter = Painter.new()
	_vp.add_child(_painter)
	_sprite = Sprite2D.new()
	_sprite.centered = false
	_sprite.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	_sprite.visible = false
	add_child(_sprite)


## true quand la texture est prête et affichée.
func is_ready() -> bool:
	return _sprite.visible


## Cache la texture (l'appelant doit alors dessiner lui-même).
func release() -> void:
	_serial += 1
	_sprite.visible = false


## Dessine `painter` sur `area` (repère de ce nœud) à `px_scale` pixels par unité, puis affiche le résultat.
## Rend true si la texture est prête, false si un autre bake l'a remplacé ou si le nœud a quitté l'arbre.
func bake(area: Rect2, px_scale: float, painter: Callable) -> bool:
	_serial += 1
	var mine: int = _serial
	_sprite.visible = false
	zone = area
	pixel_scale = maxf(px_scale, 0.1)
	_vp.size = Vector2i(ceili(area.size.x * pixel_scale), ceili(area.size.y * pixel_scale))
	_painter.position = -area.position * pixel_scale
	_painter.scale = Vector2(pixel_scale, pixel_scale)
	_painter.fn = painter
	_painter.queue_redraw()
	_vp.render_target_update_mode = SubViewport.UPDATE_ONCE
	_sprite.texture = _vp.get_texture()
	_sprite.position = area.position
	_sprite.scale = Vector2.ONE / pixel_scale
	if not is_inside_tree():
		return false
	# Le rendu unique a lieu à la fin de l'image en cours ; on laisse deux images de marge.
	await get_tree().process_frame
	if mine != _serial or not is_inside_tree():
		return false
	await get_tree().process_frame
	if mine != _serial or not is_inside_tree():
		return false
	_sprite.visible = true
	return true
