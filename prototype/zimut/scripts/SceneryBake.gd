class_name SceneryBake
extends Node2D
## SceneryBake.gd — Fige le décor de fond (BattleScenery) en UNE texture (V58).
##
## Le décor (falaises, rebords, props) représentait ~2 000 appels de dessin par image, ce qui
## ralentissait les mouvements sur téléphone. Il est dessiné une seule fois dans un SubViewport
## (rendu unique), puis affiché par un simple Sprite2D : 1 appel de dessin au lieu de ~2 000.
## Les balancements des arbres et le scintillement des torches sont figés (le reste du jeu
## bouge : personnages, particules d'ambiance, brume du fond).

## Zone couverte par le décor, dans le repère de la scène (plateau 8×8).
const BAKE_RECT := Rect2(-1050.0, -480.0, 2100.0, 1650.0)

var _vp: SubViewport
var _inner: BattleScenery
var _sprite: Sprite2D


func _init() -> void:
	_vp = SubViewport.new()
	_vp.transparent_bg = true
	_vp.disable_3d = true
	_vp.size = Vector2i(BAKE_RECT.size)
	_vp.canvas_item_default_texture_filter = Viewport.DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_NEAREST
	_vp.render_target_update_mode = SubViewport.UPDATE_ONCE
	_vp.render_target_clear_mode = SubViewport.CLEAR_MODE_ALWAYS
	add_child(_vp)
	_inner = BattleScenery.new()
	_inner.position = -BAKE_RECT.position
	_inner.set_process(false)
	_vp.add_child(_inner)
	_sprite = Sprite2D.new()
	_sprite.centered = false
	_sprite.position = BAKE_RECT.position
	_sprite.texture = _vp.get_texture()
	add_child(_sprite)


func configure(grid_size: int, biome: String, seed_value: int = 1) -> void:
	_inner.configure(grid_size, biome, seed_value)
	_inner.set_process(false)
	_vp.render_target_update_mode = SubViewport.UPDATE_ONCE
