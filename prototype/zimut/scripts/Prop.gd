class_name Prop
extends Node2D
## Prop.gd — Obstacles et végétation de l'aire de combat (arbres, rochers...).
##
## Depuis la V6, les obstacles sont dessinés par BattleScenery.draw_prop, exactement comme le
## décor du rebord : même palette, mêmes ombres douces, même langage graphique pour tous les
## biomes (arbres feuillus / pins enneigés / cactus et palmiers / piliers de donjon...).
## L'origine est au pied de l'objet.

var kind: String = "tree"
var seed_value: int = 0
var biome: String = "Forêt"
var _sway: float = 0.0
var _draw_kind: String = "tree"
var _scale: float = 1.0
var _t: float = 0.0


func setup(k: String, cell: Vector2i, b: String = "Forêt") -> void:
	kind = k
	biome = b
	seed_value = cell.x * 31 + cell.y * 57
	_sway = float(seed_value % 10) * 0.6
	var v: int = absi(seed_value) % 3
	if kind == "tree":
		match biome:
			"Montagne":
				_draw_kind = "pine"
				_scale = [1.15, 1.3, 1.22][v]
			"Désert":
				_draw_kind = "cactus" if v != 1 else "palm"
				_scale = [1.3, 1.25, 1.3][v]
			"Donjon":
				_draw_kind = "stone_pillar" if v != 2 else "torch"
				_scale = 1.2
			_:
				_draw_kind = "big_tree" if v == 1 else "tree"
				_scale = [1.18, 0.9, 1.3][v]
	else:
		match biome:
			"Montagne":
				_draw_kind = "rock_snow"
			"Désert":
				_draw_kind = "sand_pillar" if v == 0 else "rock"
			"Donjon":
				_draw_kind = "rubble" if v != 1 else "crate"
			_:
				_draw_kind = "rock"
		_scale = [1.35, 1.5, 1.4][v]
	set_process(true)


func _process(delta: float) -> void:
	_t += delta
	if kind == "tree" or _draw_kind == "torch":
		rotation = sin(_t * 1.25 + _sway) * 0.014
	queue_redraw()


func _draw() -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = seed_value + 3
	draw_set_transform(Vector2.ZERO, 0.0, Vector2(_scale, _scale))
	BattleScenery.draw_prop(self, _draw_kind, BattleScenery.pal(biome), biome, rng, _t)
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
