class_name SpriteDecor
extends RefCounted
## SpriteDecor.gd — Décor illustré (sprites) de la carte 2D isométrique de la Sylve (V106, option « Iso »).
##
## Le sol, les falaises et les sentiers restent ceux des biomes tactiques (BattleScenery) ; les arbres,
## rochers, ruines, fleurs… sont des sprites (assets/sprites/decor/sylve/) posés à la place des
## décors dessinés par code. Actif seulement pour le biome « Forêt » quand le réglage vaut « iso ».

const DIR := "res://assets/sprites/decor/sylve/"

## Décors bloquants / de sol — noms propres à ce mode (les clés pointent vers SPRITES).
const OBSTACLES: Array = ["tree", "tree", "tree", "pine", "pine", "big_tree", "rock", "rock", "bush", "stump", "ruin", "log"]
const GROUND: Array = ["flowers", "grass", "grass", "mushrooms", "flowers", "grass"]

## kind -> [ [fichier, largeur affichée en px monde], ... ]. Le pied du sprite est posé au centre de la case.
const SPRITES := {
	"tree": [["oak1", 150], ["oak2", 150], ["oak3", 150]],
	"big_tree": [["oak1", 200], ["oak3", 200]],
	"pine": [["pine1", 120], ["pine2", 124], ["pine3", 128]],
	"rock": [["rock1", 118], ["rock2", 104], ["rock3", 100], ["rock4", 104], ["rock5", 100]],
	"bush": [["bush1", 110], ["bush_flowers", 84]],
	"stump": [["stump", 100]],
	"ruin": [["wall1", 100], ["wall2", 140], ["pillar2", 70], ["pillar1", 44], ["arch", 150], ["stairs", 120]],
	"log": [["log", 150]],
	"flowers": [["flower_red", 52], ["flower_white", 50], ["flower_blue", 52], ["flower_purple", 60], ["flower_yellow", 66], ["flower_orange", 44]],
	"grass": [["grass1", 62], ["grass2", 58], ["grass3", 50], ["grass4", 64], ["grass5", 64], ["grass6", 44]],
	"mushrooms": [["mushroom1", 58], ["mushroom2", 58], ["mushroom_big", 84]],
}

static var _tex: Dictionary = {}


## Mode actif pour ce biome ?
static func active(biome: String) -> bool:
	if biome != "Forêt":
		return false
	var gs: Node = (Engine.get_main_loop() as SceneTree).root.get_node_or_null("GameSettings")
	return gs != null and String(gs.get("sylvestre_board")) == "iso"


static func texture(name: String) -> Texture2D:
	if not _tex.has(name):
		_tex[name] = load(DIR + name + ".png") as Texture2D
	return _tex[name]


## Dessine le décor `kind` en (0,0) = centre de la case ; retourne false si ce kind n'a pas de sprite.
static func draw(ci: CanvasItem, kind: String, rng: RandomNumberGenerator) -> bool:
	if not SPRITES.has(kind):
		return false
	var list: Array = SPRITES[kind]
	var pick: Array = list[rng.randi_range(0, list.size() - 1)]
	var tex: Texture2D = texture(String(pick[0]))
	if tex == null:
		return false
	var w: float = float(pick[1]) * rng.randf_range(0.94, 1.06)
	var h: float = w * float(tex.get_height()) / float(tex.get_width())
	var flip: bool = rng.randf() < 0.5
	BattleScenery.soft_shadow(ci, w * 0.30, 0.20)
	var rect := Rect2(Vector2(-w * 0.5, 16.0 - h), Vector2(w, h))
	if flip:
		ci.draw_set_transform(Vector2.ZERO, 0.0, Vector2(-1.0, 1.0))
	ci.draw_texture_rect(tex, rect, false)
	if flip:
		ci.draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
	return true
