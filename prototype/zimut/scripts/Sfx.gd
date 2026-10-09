extends Node
## Sfx.gd — Effets sonores synthétisés par code (aucun fichier audio requis).
## Usage : Sfx.play("hit")

const RATE := 22050

var enabled: bool = true
var _bank: Dictionary = {}
var _players: Array[AudioStreamPlayer] = []
var _next: int = 0


func _ready() -> void:
	_build()
	for i: int in range(8):
		var pl := AudioStreamPlayer.new()
		pl.bus = "Master"
		add_child(pl)
		_players.append(pl)


func _build() -> void:
	_bank["hit"]    = _tone(0.16, 240.0, 70.0, 0.55, 0.9, 3.0)
	_bank["crit"]   = _concat([_tone(0.05, 900.0, 400.0, 0.7, 0.9, 1.0), _tone(0.22, 200.0, 50.0, 0.5, 1.0, 2.5)])
	_bank["slash"]  = _tone(0.12, 1800.0, 600.0, 0.9, 0.5, 2.0)
	_bank["cast"]   = _tone(0.28, 380.0, 980.0, 0.05, 0.5, 1.6)
	_bank["magic"]  = _tone(0.32, 700.0, 260.0, 0.15, 0.5, 2.0)
	_bank["heal"]   = _concat([_tone(0.10, 520.0, 520.0, 0.0, 0.45, 1.0), _tone(0.10, 660.0, 660.0, 0.0, 0.45, 1.0), _tone(0.22, 880.0, 880.0, 0.0, 0.45, 2.0)])
	_bank["buff"]   = _tone(0.30, 500.0, 900.0, 0.0, 0.4, 2.2)
	_bank["debuff"] = _tone(0.30, 500.0, 160.0, 0.2, 0.45, 2.0)
	_bank["step"]   = _tone(0.05, 90.0, 60.0, 0.8, 0.35, 2.0)
	_bank["death"]  = _tone(0.55, 320.0, 45.0, 0.35, 0.7, 1.6)
	_bank["click"]  = _tone(0.04, 880.0, 880.0, 0.0, 0.3, 1.0, true)
	_bank["turn"]   = _concat([_tone(0.09, 523.0, 523.0, 0.0, 0.35, 1.5), _tone(0.14, 784.0, 784.0, 0.0, 0.35, 2.0)])
	_bank["teleport"] = _tone(0.25, 1200.0, 200.0, 0.1, 0.4, 2.0)
	_bank["trap"]   = _tone(0.2, 150.0, 400.0, 0.5, 0.6, 2.0)
	_bank["win"]    = _concat([_tone(0.14, 523.0, 523.0, 0.0, 0.4, 1.5), _tone(0.14, 659.0, 659.0, 0.0, 0.4, 1.5), _tone(0.14, 784.0, 784.0, 0.0, 0.4, 1.5), _tone(0.5, 1046.0, 1046.0, 0.0, 0.4, 2.0)])
	_bank["lose"]   = _concat([_tone(0.22, 392.0, 392.0, 0.0, 0.4, 1.5), _tone(0.22, 330.0, 330.0, 0.0, 0.4, 1.5), _tone(0.6, 196.0, 160.0, 0.1, 0.45, 2.0)])
	_bank["error"]  = _tone(0.12, 180.0, 140.0, 0.1, 0.4, 1.5, true)
	for k: String in _bank.keys():
		_bank[k] = _make_stream(_bank[k])


func play(sound: String, volume_db: float = 0.0) -> void:
	if not enabled or not _bank.has(sound):
		return
	var pl: AudioStreamPlayer = _players[_next]
	_next = (_next + 1) % _players.size()
	pl.stream = _bank[sound]
	pl.volume_db = volume_db - 6.0
	pl.pitch_scale = randf_range(0.95, 1.05)
	pl.play()


func _tone(dur: float, f0: float, f1: float, noise: float, vol: float, decay: float, square: bool = false) -> PackedByteArray:
	var n: int = int(dur * RATE)
	var data := PackedByteArray()
	data.resize(n * 2)
	var phase: float = 0.0
	for i: int in range(n):
		var t: float = float(i) / float(n)
		phase += TAU * lerpf(f0, f1, t) / float(RATE)
		var s: float = sin(phase)
		if square:
			s = 0.6 if s > 0.0 else -0.6
		s = s * (1.0 - noise) + (randf() * 2.0 - 1.0) * noise
		var env: float = pow(1.0 - t, decay) * minf(1.0, float(i) / (RATE * 0.004))
		data.encode_s16(i * 2, int(clampf(s * env * vol, -1.0, 1.0) * 32767.0))
	return data


func _concat(parts: Array) -> PackedByteArray:
	var out := PackedByteArray()
	for part: PackedByteArray in parts:
		out.append_array(part)
	return out


func _make_stream(data: PackedByteArray) -> AudioStreamWAV:
	var w := AudioStreamWAV.new()
	w.format = AudioStreamWAV.FORMAT_16_BITS
	w.mix_rate = RATE
	w.stereo = false
	w.data = data
	return w
