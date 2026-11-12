class_name HeroAnim
extends RefCounted
## Animations procédurales du héros « Sylvain » (squelette modélisé sous Blender, 23 os nommés en français).
## Chaque animation donne, pour une phase t ∈ [0, 1), des rotations locales d'os en degrés (x, y, z) par rapport
## à la pose de repos, plus un décalage du corps entier. Utilisé par tools/bake_hero_seq.gd pour cuire les
## séquences de sprites du mode Tactique (les animations ne sont pas stockées dans le modèle).
##
## Conventions (os orientés selon leur axe Y local, comme sous Blender) :
##   x : balancement avant / arrière (flexion), z : écart latéral, y : torsion.
## Côté « r » = main droite du personnage = main qui tient le bâton (à gauche de l'écran, vu de face).

## animation → nombre d'images, boucle, image clé (impact / sommet du geste), durée du cycle en secondes, et
## rotation de base du personnage en ° (0 = de face ; positif = tourné vers la droite de l'écran, comme les sprites) ;
## chaque pose peut y ajouter un « yaw » (le héros se tourne vers sa cible pendant l'attaque, puis reprend sa place).
const ANIMS := {
	"idle":   {"n": 6, "loop": true,  "key": 0, "dur": 1.8,  "yaw": 28.0},
	"walk":   {"n": 8, "loop": true,  "key": 0, "dur": 0.36, "yaw": 28.0},
	"attack": {"n": 7, "loop": false, "key": 4, "dur": 0.42, "yaw": 28.0},
	"cast":   {"n": 8, "loop": false, "key": 4, "dur": 0.60, "yaw": 28.0},
	"hit":    {"n": 4, "loop": false, "key": 1, "dur": 0.30, "yaw": 28.0},
}

static func _s(t: float) -> float:
	return sin(t * TAU)

static func _c(t: float) -> float:
	return cos(t * TAU)

## Interpolation douce entre des valeurs clés régulièrement espacées sur [0, 1].
static func _curve(keys: Array, t: float) -> float:
	var f: float = clampf(t, 0.0, 1.0) * float(keys.size() - 1)
	var i: int = mini(int(f), keys.size() - 2)
	var u: float = f - float(i)
	u = u * u * (3.0 - 2.0 * u)
	return lerpf(float(keys[i]), float(keys[i + 1]), u)


## Pose à la phase t de l'animation [name] : {"bones": {os: Vector3(deg)}, "dy": m, "dx": m, "yaw": deg, "pitch": deg,
## "staff": direction voulue du bâton (repère du personnage : x droite de l'écran, y haut, z avant), "staff_w": poids 0..1}.
## Les décalages dy / dx sont en fraction de la taille du personnage.
static func pose(name: String, t: float) -> Dictionary:
	var b := {}
	var dy: float = 0.0
	var dx: float = 0.0
	var pitch: float = 0.0
	var yaw: float = 0.0
	var staff := Vector3.ZERO
	var staff_w: float = 0.0
	match name:
		"idle":
			var br: float = _s(t)
			b["torax"] = Vector3(-1.2 * br, 0, 0)
			b["tete"] = Vector3(1.0 * br, 0, 0)
			b["bras.r"] = Vector3(0, 0, -1.0 * br)
			b["bras.l"] = Vector3(0, 0, 1.5 * br)
			dy = 0.004 * br
		"walk":
			var p: float = _s(t)
			var q: float = _c(t)
			b["cuisse.r"] = Vector3(34.0 * p, 0, 0)
			b["cuisse.l"] = Vector3(-34.0 * p, 0, 0)
			b["tibia.r"] = Vector3(-34.0 * maxf(0.0, q), 0, 0)
			b["tibia.l"] = Vector3(-34.0 * maxf(0.0, -q), 0, 0)
			b["pied.r"] = Vector3(8.0 * maxf(0.0, q), 0, 0)
			b["pied.l"] = Vector3(8.0 * maxf(0.0, -q), 0, 0)
			b["bras.l"] = Vector3(-26.0 * p, 0, 3)
			b["bras.r"] = Vector3(10.0 * p, 0, 0)
			b["torax"] = Vector3(2.0, 7.0 * p, 0)
			b["tete"] = Vector3(0, -5.0 * p, 0)
			dy = 0.014 * absf(p)
			pitch = 3.0
		"attack":
			# bâton ramené en arrière (images 1-2), balayé vers l'avant (impact à l'image 4), retour
			var arm: float = _curve([0, -20, -40, 40, 75, 65, 20], t)
			var sa: float = deg_to_rad(_curve([0, -30, -60, 40, 100, 85, 20], t))
			b["bras.r"] = Vector3(arm, 0, 0)
			b["avantBras.r"] = Vector3(arm * 0.3, 0, 0)
			b["torax"] = Vector3(_curve([0, -3, -6, 8, 16, 12, 4], t), _curve([0, -12, -24, 6, 26, 20, 6], t), 0)
			b["tete"] = Vector3(_curve([0, -1, -3, 2, 6, 4, 1], t), _curve([0, 6, 14, -4, -14, -10, -3], t), 0)
			b["bras.l"] = Vector3(_curve([0, 10, 25, -10, -28, -20, -6], t), 0, _curve([0, 4, 10, 4, 0, 0, 0], t))
			b["cuisse.l"] = Vector3(_curve([0, 3, 8, 16, 28, 24, 8], t), 0, 0)
			b["tibia.l"] = Vector3(_curve([0, -2, -5, -12, -22, -18, -6], t), 0, 0)
			b["cuisse.r"] = Vector3(_curve([0, -4, -10, -4, 6, 6, 2], t), 0, 0)
			dy = _curve([0, 0, 0, -0.01, -0.025, -0.02, -0.005], t)
			dx = _curve([0, 0, 0, 0.02, 0.05, 0.04, 0.01], t)
			pitch = _curve([0, -1, -3, 3, 7, 5, 2], t)
			yaw = _curve([0, 14, 27, 27, 27, 24, 8], t)
			staff = Vector3(0, cos(sa), sin(sa))
			staff_w = _curve([0, 0.5, 1, 1, 1, 1, 0.5], t)
		"cast":
			# bâton levé vers le ciel (sommet tenu aux images 3-5), retombée
			var up: float = _curve([0, 0.3, 0.8, 1, 1, 0.9, 0.35, 0], t)
			b["bras.r"] = Vector3(70.0 * up, 0, 40.0 * up)
			b["avantBras.r"] = Vector3(10.0 * up, 0, 0)
			b["bras.l"] = Vector3(25.0 * up, 0, 10.0 * up)
			b["torax"] = Vector3(-9.0 * up, 0, 0)
			b["tete"] = Vector3(-16.0 * up, 0, 0)
			b["cuisse.r"] = Vector3(5.0 * up, 0, 0)
			b["cuisse.l"] = Vector3(-5.0 * up, 0, 0)
			dy = 0.014 * up
			yaw = 20.0 * up
			staff = Vector3(0.1, 1, 0.25)
			staff_w = clampf(up * 1.6, 0.0, 1.0)
		"hit":
			var h: float = _curve([0.0, 1.0, 0.55, 0.0], t)
			b["torax"] = Vector3(-14.0 * h, 0, 4.0 * h)
			b["tete"] = Vector3(-16.0 * h, 0, 0)
			b["bras.l"] = Vector3(18.0 * h, 0, 14.0 * h)
			b["bras.r"] = Vector3(14.0 * h, 0, -6.0 * h)
			b["cuisse.r"] = Vector3(10.0 * h, 0, 0)
			b["cuisse.l"] = Vector3(-8.0 * h, 0, 0)
			pitch = -6.0 * h
			dy = -0.01 * h
			dx = 0.0
	var out := {"bones": b, "dy": dy, "dx": dx, "yaw": yaw, "pitch": pitch}
	if staff_w > 0.001:
		out["staff"] = staff
		out["staff_w"] = staff_w
	return out


## Phase de l'image [i] d'une animation (les animations en boucle ne répètent pas la dernière image).
static func phase(name: String, i: int) -> float:
	var info: Dictionary = ANIMS[name]
	var n: int = int(info["n"])
	if bool(info["loop"]):
		return float(i) / float(n)
	return float(i) / float(n - 1)
