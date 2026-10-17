extends Node

## Music.gd — Bande son du jeu (autoload) : musique de menu et de combat par
## biome, en fondu enchaîné. Les pistes OGG bouclent (import Loop: On).
## Usage : Music.play("menu") / Music.play_combat("Forêt") / Music.stop()

const FADE_IN := 1.2
const FADE_OUT := 0.9
const BASE_DB := -6.0

## Pistes par contexte. Le combat choisit sa piste selon le biome ; deux
## variantes par biome pour la variété d'une bataille à l'autre.
const TRACKS := {
	"menu": "res://assets/audio/opening.ogg",
	"adventure": "res://assets/audio/wandering_path.ogg",
	"combat_forest": "res://assets/audio/forest_1.ogg",
	"combat_forest_2": "res://assets/audio/forest_2.ogg",
	"combat_mountain": "res://assets/audio/mountain_1.ogg",
	"combat_mountain_2": "res://assets/audio/mountain_2.ogg",
	"combat_desert": "res://assets/audio/desert_1.ogg",
	"combat_donjon": "res://assets/audio/mountain_1.ogg",
	# Nations : une boucle de combat (percussions) et une d'exploration (calme) chacune
	"combat_cristaux": "res://assets/audio/nation_cristaux_combat.ogg",
	"combat_marees": "res://assets/audio/nation_marees_combat.ogg",
	"combat_vents": "res://assets/audio/nation_vents_combat.ogg",
	"combat_brasier": "res://assets/audio/nation_brasier_combat.ogg",
	"combat_brumes": "res://assets/audio/nation_brumes_combat.ogg",
	"combat_ombres": "res://assets/audio/nation_ombres_combat.ogg",
	"explore_cristaux": "res://assets/audio/nation_cristaux_explore.ogg",
	"explore_marees": "res://assets/audio/nation_marees_explore.ogg",
	"explore_vents": "res://assets/audio/nation_vents_explore.ogg",
	"explore_brasier": "res://assets/audio/nation_brasier_explore.ogg",
	"explore_brumes": "res://assets/audio/nation_brumes_explore.ogg",
	"explore_ombres": "res://assets/audio/nation_ombres_explore.ogg",
}
const NATION_KEY := {"Cristaux": "cristaux", "Marées": "marees", "Vents": "vents", "Brasier": "brasier", "Brumes": "brumes", "Ombres": "ombres"}

var enabled: bool = true
var _current: String = ""
var _a: AudioStreamPlayer
var _b: AudioStreamPlayer
var _fade_out_player: AudioStreamPlayer
var _rng := RandomNumberGenerator.new()

func _ready() -> void:
	_rng.randomize()
	_a = AudioStreamPlayer.new()
	_b = AudioStreamPlayer.new()
	for pl: AudioStreamPlayer in [_a, _b]:
		pl.bus = "Master"
		add_child(pl)
	_a.volume_db = -60.0
	_b.volume_db = -60.0

func _process(delta: float) -> void:
	# Fondu enchaîné simple : la piste active monte, l'ancienne descend.
	for pl: AudioStreamPlayer in [_a, _b]:
		if pl.playing and pl.volume_db < BASE_DB:
			pl.volume_db = minf(BASE_DB, pl.volume_db + delta * (60.0 / FADE_IN))
		elif not pl.playing and pl.volume_db > -60.0:
			pass
	if _fade_out_player != null and _fade_out_player.playing:
		_fade_out_player.volume_db -= delta * (60.0 / FADE_OUT)
		if _fade_out_player.volume_db <= -60.0:
			_fade_out_player.stop()

## Lance une piste par sa clé de contexte (voir TRACKS). Sans effet si déjà
## en cours, sauf force=true (utile après une coupure).
func play(key: String, force: bool = false) -> void:
	if not enabled or not TRACKS.has(key):
		return
	if key == _current and _a.playing and not force:
		return
	if not ResourceLoader.exists(TRACKS[key]):
		push_warning("Piste musicale introuvable : " + TRACKS[key])
		return
	var stream: AudioStream = load(TRACKS[key]) as AudioStream
	if stream is AudioStreamOggVorbis:
		(stream as AudioStreamOggVorbis).loop = true
	if stream == null:
		return
	# l'ancienne piste part en fondu, la nouvelle démarre en face
	if _a.playing:
		_fade_out_player = _a
		_a = _b
		_b = _fade_out_player
	_b.stream = stream
	_b.volume_db = -60.0
	_b.play()
	_current = key

## Musique du combat selon le biome ; variante aléatoire quand il y en a deux.
func play_combat(biome: String) -> void:
	match biome:
		"Forêt":
			play("combat_forest_2" if _rng.randf() < 0.5 else "combat_forest")
		"Montagne":
			play("combat_mountain_2" if _rng.randf() < 0.5 else "combat_mountain")
		"Désert":
			play("combat_desert")
		"Donjon":
			play("combat_donjon")
		"Cristaux", "Marées", "Vents", "Brasier", "Brumes", "Ombres":
			play("combat_" + String(NATION_KEY[biome]))
		_:
			play("combat_forest")

## Musique d'exploration de l'Aventure : calme et propre à la nation, sinon le thème commun.
func play_adventure(biome: String) -> void:
	if NATION_KEY.has(biome):
		play("explore_" + String(NATION_KEY[biome]))
	else:
		play("adventure")

func stop() -> void:
	_fade_out_player = _a if _a.playing else _b
	_current = ""

func set_enabled(on: bool) -> void:
	enabled = on
	if not on:
		stop()
