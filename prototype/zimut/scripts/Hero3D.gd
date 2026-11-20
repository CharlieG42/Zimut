class_name Hero3D
extends Node
## Hero3D.gd — PROTOTYPE (V161) : un héros modélisé en 3D, rendu EN DIRECT dans un petit SubViewport (192 × 192) et affiché
## par EntityView à la place des sprites cuits (tools/bake_hero_seq.gd). Même cadrage, mêmes animations (HeroAnim), même
## cellule : EntityView lui demande simplement « telle animation, telle phase, de face ou de dos » et reçoit la texture.
## Différences avec les planches : mouvements continus (pas d'images fixes), un rendu 3D par héros et par image.
##
## Les parties communes avec le script de cuisson (bâton rigide, visée du bâton, pose) sont volontairement recopiées :
## à fusionner si le prototype est retenu.

const CELL := 192
## V370 : le rendu 3D est fait à RES_K fois la résolution logique de la cellule (suréchantillonnage) puis réduit à l'écran :
## contours et détails nets sur grand écran (PC, tablette). EntityView divise l'échelle du sprite par RES_K.
const RES_K := 2
const CHAR_FRAC := 0.74            # hauteur du personnage au repos dans la cellule (comme la cuisson)
const FEET_ROW := 0.965            # ligne des pieds
const HERO_H := 1.8
const FRAME_MAX_PASSES := 8        # passes de cadrage au plus
const LUM_START := 0.08           # écart de luminosité (8 %) à partir duquel les couleurs sont recalées
const RECALE := false            # V373 : recalage des couleurs coupé (rendu identique sur tous les appareils)
const LUM_TOL := 0.04              # écart toléré après recalage
const FRAME_TOL := 0.04            # écart toléré (4 %) entre la hauteur mesurée et la hauteur voulue
## Deux familles de modèles :
##  - « procédural » (Sylvain) : pose calculée à l'exécution par HeroAnim, bâton rigide, pointe du bâton ;
##  - « clips » (modèles Meshy rigifiés, V163) : animations intégrées au .glb (AnimationPlayer). Chaque action du jeu
##    (idle, walk, attack, cast, hit) renvoie à un morceau de clip [t0, t1] (secondes) joué sur la durée [dur] du jeu ;
##    « key » = instant d'impact (fraction de l'action). Sans clip pour une action : pose tenue + mouvement du corps (« motion »).
## ref_cam = (taille, hauteur) de caméra et ref_lum = luminosité moyenne, mesurées sur ordinateur (V357) : le cadrage est
## imposé, et les couleurs sont recalées si l'appareil rend plus clair ou plus sombre. Pour les recalculer (nouveau modèle,
## ou réglage de lumière modifié), retirer ces deux clés, lancer un rendu et relever `Hero3D.diag` / `image_stats`.
const MODELS := {
	## Sylvain (V380) : nouveau modèle et rig de Charlie sous Blender (bâton dans la main gauche), clips cuits par
	## tools/anim_heros_blender.gd (préréglage « sylvain ») — remplace l'ancien modèle animé par HeroAnim.
	"Sylvain": {"path": "res://assets/heroes3d/sylvain.glb", "root_bone": "base", "gain": 1.0, "ref_cam": Vector2(4.45, 1.97), "ref_lum": 0.649,
		"clips": {
			"idle":   {"clip": "Idle", "t0": 0.0, "t1": 0.0, "dur": 5.0, "loop": true, "key": 0.0},
			"walk":   {"clip": "Walk", "t0": 0.0, "t1": 0.8, "dur": 0.8, "loop": true, "key": 0.0},
			"attack": {"clip": "Attack", "t0": 0.0, "t1": 1.0, "dur": 0.8, "loop": false, "key": 0.55},
			"cast":   {"clip": "Cast", "t0": 0.0, "t1": 1.4, "dur": 1.2, "loop": false, "key": 0.5},
			"hit":    {"clip": "Hit", "t0": 0.0, "t1": 0.5, "dur": 0.4, "loop": false, "key": 0.2},
			"dead":   {"clip": "Dead", "t0": 0.0, "t1": 1.0, "dur": 1.0, "loop": false, "key": 0.0, "motion": "dead"},
		}},
	## Mage (V381) : modèle et rig de Charlie sous Blender (bâton dans la main droite, grimoire dans la gauche), clips cuits (préréglage « mage »).
	"Mage": {"path": "res://assets/heroes3d/mage.glb", "root_bone": "base", "gain": 1.0, "ref_cam": Vector2(4.45, 1.97), "ref_lum": 0.649,
		"clips": {
			"idle":   {"clip": "Idle", "t0": 0.0, "t1": 0.0, "dur": 5.0, "loop": true, "key": 0.0},
			"walk":   {"clip": "Walk", "t0": 0.0, "t1": 0.8, "dur": 0.8, "loop": true, "key": 0.0},
			"attack": {"clip": "Attack", "t0": 0.0, "t1": 1.0, "dur": 0.8, "loop": false, "key": 0.55},
			"cast":   {"clip": "Cast", "t0": 0.0, "t1": 1.4, "dur": 1.2, "loop": false, "key": 0.5},
			"hit":    {"clip": "Hit", "t0": 0.0, "t1": 0.5, "dur": 0.4, "loop": false, "key": 0.2},
			"dead":   {"clip": "Dead", "t0": 0.0, "t1": 1.0, "dur": 1.0, "loop": false, "key": 0.0, "motion": "dead"},
		}},
	## Géomancien (V382) : modèle et rig de Charlie sous Blender (bâton à torche dans la main droite, sphère de lumière flottant au-dessus de la gauche), clips cuits (préréglage « geomancien »).
	"Géomancien": {"path": "res://assets/heroes3d/geomancien.glb", "root_bone": "base", "gain": 1.0, "ref_cam": Vector2(4.29, 1.90), "ref_lum": 0.55,
		"clips": {
			"idle":   {"clip": "Idle", "t0": 0.0, "t1": 0.0, "dur": 5.0, "loop": true, "key": 0.0},
			"walk":   {"clip": "Walk", "t0": 0.0, "t1": 0.8, "dur": 0.8, "loop": true, "key": 0.0},
			"attack": {"clip": "Attack", "t0": 0.0, "t1": 1.0, "dur": 0.8, "loop": false, "key": 0.55},
			"cast":   {"clip": "Cast", "t0": 0.0, "t1": 1.4, "dur": 1.2, "loop": false, "key": 0.5},
			"hit":    {"clip": "Hit", "t0": 0.0, "t1": 0.5, "dur": 0.4, "loop": false, "key": 0.2},
			"dead":   {"clip": "Dead", "t0": 0.0, "t1": 1.0, "dur": 1.0, "loop": false, "key": 0.0, "motion": "dead"},
		}},
	## Kharaz le Flamboyant (V384) : boss de la nation du Brasier, modèle et rig de Charlie sous Blender (arc enflammé dans la main gauche, poing de feu à droite), clips cuits (préréglage « kharaz »).
	"Kharaz": {"path": "res://assets/heroes3d/kharaz.glb", "root_bone": "base", "gain": 1.0, "ref_cam": Vector2(4.45, 1.97), "ref_lum": 0.55,
		"clips": {
			"idle":   {"clip": "Idle", "t0": 0.0, "t1": 0.0, "dur": 5.0, "loop": true, "key": 0.0},
			"walk":   {"clip": "Walk", "t0": 0.0, "t1": 0.8, "dur": 0.8, "loop": true, "key": 0.0},
			"attack": {"clip": "Attack", "t0": 0.0, "t1": 1.0, "dur": 0.8, "loop": false, "key": 0.55},
			"cast":   {"clip": "Cast", "t0": 0.0, "t1": 1.4, "dur": 1.2, "loop": false, "key": 0.5},
			"hit":    {"clip": "Hit", "t0": 0.0, "t1": 0.5, "dur": 0.4, "loop": false, "key": 0.2},
			"dead":   {"clip": "Dead", "t0": 0.0, "t1": 1.0, "dur": 1.0, "loop": false, "key": 0.0, "motion": "dead"},
		}},
	## Assassin (V380) : modèle et rig de Charlie sous Blender (deux dagues), clips cuits (préréglage « assassin »).
	"Assassin": {"path": "res://assets/heroes3d/assassin.glb", "root_bone": "base", "gain": 1.0, "ref_cam": Vector2(4.626, 1.991), "ref_lum": 0.25,
		"clips": {
			"idle":   {"clip": "Idle", "t0": 0.0, "t1": 0.0, "dur": 5.0, "loop": true, "key": 0.0},
			"walk":   {"clip": "Walk", "t0": 0.0, "t1": 0.7, "dur": 0.7, "loop": true, "key": 0.0},
			"attack": {"clip": "Attack", "t0": 0.0, "t1": 0.9, "dur": 0.7, "loop": false, "key": 0.55},
			"cast":   {"clip": "Cast", "t0": 0.0, "t1": 1.2, "dur": 1.0, "loop": false, "key": 0.5},
			"hit":    {"clip": "Hit", "t0": 0.0, "t1": 0.5, "dur": 0.4, "loop": false, "key": 0.2},
			"dead":   {"clip": "Dead", "t0": 0.0, "t1": 1.0, "dur": 1.0, "loop": false, "key": 0.0, "motion": "dead"},
		}},
	"Tharok": {"path": "res://assets/heroes3d/tharok.glb", "root_bone": "spine", "gain": 1.0, "ref_cam": Vector2(3.62, 1.545), "ref_lum": 0.425,
		"clips": {
			"idle":   {"clip": "Walking", "t0": 0.0, "t1": 0.0, "dur": 3.0, "loop": true, "key": 0.0},
			"walk":   {"clip": "Walking", "t0": 0.0, "t1": 1.0333, "dur": 1.0, "loop": true, "key": 0.0},
			"attack": {"clip": "Axe_Spin_Attack", "t0": 0.2, "t1": 1.8, "dur": 1.0, "loop": false, "key": 0.5},
			"cast":   {"clip": "Double_Combo_Attack", "t0": 0.1, "t1": 1.5, "dur": 1.0, "loop": false, "key": 0.5},
			"hit":    {"clip": "Walking", "t0": 0.0, "t1": 0.0, "dur": 0.4, "loop": false, "key": 0.0, "motion": "hit"},
		}},
	"Ingénieur": {"path": "res://assets/heroes3d/ingenieur.glb", "root_bone": "spine", "gain": 1.0, "ref_cam": Vector2(3.151, 1.361), "ref_lum": 0.57,
		"clips": {
			"idle":   {"clip": "Walking", "t0": 0.0, "t1": 0.0, "dur": 3.0, "loop": true, "key": 0.0},
			"walk":   {"clip": "Walking", "t0": 0.0, "t1": 1.0333, "dur": 1.0, "loop": true, "key": 0.0},
			"attack": {"clip": "Attack", "t0": 0.2, "t1": 1.8, "dur": 1.0, "loop": false, "key": 0.56},
			"cast":   {"clip": "Axe_Spin_Attack", "t0": 0.2, "t1": 1.8, "dur": 1.0, "loop": false, "key": 0.5},
			"hit":    {"clip": "Walking", "t0": 0.0, "t1": 0.0, "dur": 0.4, "loop": false, "key": 0.0, "motion": "hit"},
		}},
	## Tank (V378, « Frostbeard Guardian » Meshy, 9 clips) : garde = « Axe_Stance » à 5,6 s (debout, hache basse, bouclier levé) ;
	## attaque = premier coup du « Double_Combo_Attack » ; sort = « Axe_Spin_Attack » (tour complet, impact ≈ 1 s).
	"Tank": {"path": "res://assets/heroes3d/tank.glb", "root_bone": "spine", "gain": 1.0, "ref_cam": Vector2(3.264, 1.502), "ref_lum": 0.452,
		"clips": {
			"idle":   {"clip": "Axe_Stance", "t0": 5.6, "t1": 5.6, "dur": 3.0, "loop": true, "key": 0.0},
			"walk":   {"clip": "Walking", "t0": 0.0, "t1": 1.0333, "dur": 1.0, "loop": true, "key": 0.0},
			"attack": {"clip": "Double_Combo_Attack", "t0": 0.1, "t1": 1.3, "dur": 0.9, "loop": false, "key": 0.52},
			"cast":   {"clip": "Axe_Spin_Attack", "t0": 0.1, "t1": 2.2, "dur": 1.4, "loop": false, "key": 0.45},
			"hit":    {"clip": "Axe_Stance", "t0": 5.6, "t1": 5.6, "dur": 0.4, "loop": false, "key": 0.0, "motion": "hit"},
		}},
	## Vorkann le Givre (V378, boss des Cimes, Meshy) : bouclier rendu rigide à l'import (tools/import_fbx.gd, boîte
	## « Bone_019@-9,-0.75,-9,9,-9,9 ») — sinon il se pliait à chaque pas. 30 900 triangles (pas de niveau de détail généré).
	"Vorkann": {"path": "res://assets/heroes3d/vorkann.glb", "root_bone": "spine", "gain": 1.0, "ref_cam": Vector2(3.304, 1.449), "ref_lum": 0.370,
		"clips": {
			"idle":   {"clip": "Walking", "t0": 0.0, "t1": 0.0, "dur": 3.0, "loop": true, "key": 0.0},
			"walk":   {"clip": "Walking", "t0": 0.0, "t1": 1.0333, "dur": 1.0, "loop": true, "key": 0.0},
			"attack": {"clip": "Triple_Combo_Attack", "t0": 0.2, "t1": 1.9, "dur": 1.0, "loop": false, "key": 0.6},
			"cast":   {"clip": "Triple_Combo_Attack", "t0": 0.2, "t1": 3.0, "dur": 1.5, "loop": false, "key": 0.55},
			"hit":    {"clip": "Walking", "t0": 0.0, "t1": 0.0, "dur": 0.4, "loop": false, "key": 0.0, "motion": "hit"},
		}},
	## Chasseur (V383) : modèle et rig de Charlie sous Blender (arc dans la main gauche), clips cuits (préréglage « chasseur ») : tir = arc tendu puis corde relâchée.
	"Chasseur": {"path": "res://assets/heroes3d/chasseur.glb", "root_bone": "base", "gain": 1.0, "ref_cam": Vector2(4.45, 1.97), "ref_lum": 0.55,
		"clips": {
			"idle":   {"clip": "Idle", "t0": 0.0, "t1": 0.0, "dur": 5.0, "loop": true, "key": 0.0},
			"walk":   {"clip": "Walk", "t0": 0.0, "t1": 0.8, "dur": 0.8, "loop": true, "key": 0.0},
			"attack": {"clip": "Attack", "t0": 0.0, "t1": 1.0, "dur": 0.8, "loop": false, "key": 0.55},
			"cast":   {"clip": "Cast", "t0": 0.0, "t1": 1.4, "dur": 1.2, "loop": false, "key": 0.5},
			"hit":    {"clip": "Hit", "t0": 0.0, "t1": 0.5, "dur": 0.4, "loop": false, "key": 0.2},
			"dead":   {"clip": "Dead", "t0": 0.0, "t1": 1.0, "dur": 1.0, "loop": false, "key": 0.0, "motion": "dead"},
		}},
	## Druide (V383) : modèle et rig de Charlie (bâton à cristal dans la main droite), clips cuits (préréglage « druide »).
	"Druide": {"path": "res://assets/heroes3d/druide.glb", "root_bone": "base", "gain": 1.0, "ref_cam": Vector2(4.54, 2.0), "ref_lum": 0.55,
		"clips": {
			"idle":   {"clip": "Idle", "t0": 0.0, "t1": 0.0, "dur": 5.0, "loop": true, "key": 0.0},
			"walk":   {"clip": "Walk", "t0": 0.0, "t1": 0.8, "dur": 0.8, "loop": true, "key": 0.0},
			"attack": {"clip": "Attack", "t0": 0.0, "t1": 1.0, "dur": 0.8, "loop": false, "key": 0.55},
			"cast":   {"clip": "Cast", "t0": 0.0, "t1": 1.4, "dur": 1.2, "loop": false, "key": 0.5},
			"hit":    {"clip": "Hit", "t0": 0.0, "t1": 0.5, "dur": 0.4, "loop": false, "key": 0.2},
			"dead":   {"clip": "Dead", "t0": 0.0, "t1": 1.0, "dur": 1.0, "loop": false, "key": 0.0, "motion": "dead"},
		}},
	## Heal (V383) : modèle et rig de Charlie (bâton à sphère dans la main droite, robe longue : jambes peu ouvertes), clips cuits (préréglage « heal »).
	"Heal": {"path": "res://assets/heroes3d/heal.glb", "root_bone": "base", "gain": 1.0, "ref_cam": Vector2(4.45, 1.97), "ref_lum": 0.55,
		"clips": {
			"idle":   {"clip": "Idle", "t0": 0.0, "t1": 0.0, "dur": 5.0, "loop": true, "key": 0.0},
			"walk":   {"clip": "Walk", "t0": 0.0, "t1": 0.8, "dur": 0.8, "loop": true, "key": 0.0},
			"attack": {"clip": "Attack", "t0": 0.0, "t1": 1.0, "dur": 0.8, "loop": false, "key": 0.55},
			"cast":   {"clip": "Cast", "t0": 0.0, "t1": 1.4, "dur": 1.2, "loop": false, "key": 0.5},
			"hit":    {"clip": "Hit", "t0": 0.0, "t1": 0.5, "dur": 0.4, "loop": false, "key": 0.2},
			"dead":   {"clip": "Dead", "t0": 0.0, "t1": 1.0, "dur": 1.0, "loop": false, "key": 0.0, "motion": "dead"},
		}},
	## Invocateur (V379) : modèle et rig de Charlie sous Blender (16 os nommés en français), sans animation d'origine ;
	## les clips sont cuits par tools/anim_heros_blender.gd (préréglage « invocateur »). Lanterne dans la main gauche,
	## livre dans la droite. Attaque = livre poussé vers l'ennemi ; sort = lanterne levée.
	"Invocateur": {"path": "res://assets/heroes3d/invocateur.glb", "root_bone": "base", "gain": 1.0, "ref_cam": Vector2(3.827, 1.702), "ref_lum": 0.191,
		"clips": {
			"idle":   {"clip": "Idle", "t0": 0.0, "t1": 0.0, "dur": 5.0, "loop": true, "key": 0.0},
			"walk":   {"clip": "Walk", "t0": 0.0, "t1": 0.8, "dur": 0.8, "loop": true, "key": 0.0},
			"attack": {"clip": "Attack", "t0": 0.0, "t1": 1.0, "dur": 0.8, "loop": false, "key": 0.6},
			"cast":   {"clip": "Cast", "t0": 0.0, "t1": 1.4, "dur": 1.2, "loop": false, "key": 0.5},
			"hit":    {"clip": "Hit", "t0": 0.0, "t1": 0.5, "dur": 0.4, "loop": false, "key": 0.2},
			"dead":   {"clip": "Dead", "t0": 0.0, "t1": 1.0, "dur": 1.0, "loop": false, "key": 0.0, "motion": "dead"},
		}},
}
## Classe du joueur (nom interne) ou nom de boss -> modèle.
## Harpie (Meshy, sans squelette) : modèle « statique ». Pas d'AnimationPlayer : le corps bouge (vol, élan, recul) et les ailes
## battent par déformation des sommets dans le shader (uniform « flap »). Version allégée sur téléphone (12 k triangles, 1024²).
const HARPIE_MODEL := {"path": "res://assets/monstres3d/harpie.glb", "path_mobile": "res://assets/monstres3d/harpie_mobile.glb",
	"static": true, "gain": 1.0,
	"clips": {
		"idle":   {"dur": 2.4, "loop": true, "key": 0.0, "motion": "idle"},
		"walk":   {"dur": 1.0, "loop": true, "key": 0.0, "motion": "walk"},
		"attack": {"dur": 0.9, "loop": false, "key": 0.5, "motion": "attack"},
		"cast":   {"dur": 1.1, "loop": false, "key": 0.6, "motion": "cast"},
		"hit":    {"dur": 0.4, "loop": false, "key": 0.0, "motion": "hit"},
	}}
const CLASS_MODEL := {"Sylvain": "Sylvain", "Mage": "Mage", "Géomancien": "Géomancien", "Assassin": "Assassin", "Artificier": "Ingénieur", "Chasseur": "Chasseur", "Druide": "Druide", "Heal": "Heal", "Invocateur": "Invocateur", "Tank": "Tank"}
const BOSS_MODEL := {"Gobelin Roi": "Tharok", "Tharok le Végétal": "Tharok", "Troll Géant": "Vorkann", "Vorkann le Givre": "Vorkann", "Kharaz le Flamboyant": "Kharaz"}
## Ennemis ordinaires rendus en 3D : biome -> type -> modèle. ESSAI : la harpie remplace les squelettes/dragonnets des Vents
## et les loups de la Forêt (biome de bas niveau). Vider la table pour revenir aux sprites 2D.
const ENEMY_MODEL := {"Vents": {"Squelette": "Harpie", "Dragonnet": "Harpie"}, "Forêt": {"Loup": "Harpie"}}
## Battement d'ailes d'un modèle sans squelette : déplacement vertical des sommets, nul près de l'axe et sous la taille.
## span_info = (demi-envergure, centre x, hauteur à partir de laquelle les ailes commencent).
const FLAP_UNIFORMS := """
uniform float flap = 0.0;
uniform vec3 span_info = vec3(0.95, 0.0, 1.1);
float flap_offset(vec3 v, float f, vec3 info) {
	float w = smoothstep(0.18, 1.0, clamp(abs(v.x - info.y) / max(info.x, 0.0001), 0.0, 1.0));
	float up = smoothstep(info.z - 0.25, info.z + 0.2, v.y);
	return f * w * w * up * info.x * 0.32;
}
"""
const CLIP_FRAMES := 24             # nombre d'images fictives d'une action (EntityView raisonne en images pour les temps d'impact)
## V373 : ombrage calculé dans le shader (sans lumière de scène) : le rendu ne dépend plus de l'appareil — sur PC les
## lumières délavaient les couleurs de la texture, sur téléphone elles sortaient plus sombres puis étaient recalées.
const SHADER := """
shader_type spatial;
render_mode cull_back, unshaded;
uniform sampler2D albedo_tex : source_color, filter_linear_mipmap_anisotropic, repeat_enable, hint_default_white;
uniform float gain = 1.0;
uniform float gamma = 1.0;     // V357 : correction automatique des couleurs (voir _calibrate_color)
const vec3 LDIR = vec3(-0.36, 0.62, 0.70);   // lumière fixe, dans le repère de la caméra (haut gauche, vers le spectateur)
varying float wy;
void vertex() {
	wy = (MODEL_MATRIX * vec4(VERTEX, 1.0)).y;
}
void fragment() {
	vec3 c = pow(texture(albedo_tex, UV, -0.5).rgb, vec3(gamma)) * gain;
	vec3 n = normalize(NORMAL);
	float h = dot(n, normalize(LDIR)) * 0.5 + 0.5;
	// V385 : dégradé doux (ombre bleutée -> lumière chaude) au lieu de deux marches nettes, volumes plus lisibles
	float band = smoothstep(0.22, 0.86, h);
	vec3 shade = mix(vec3(0.66, 0.70, 0.90), vec3(1.07, 1.05, 1.0), band);
	// occlusion ambiante factice : le bas du corps (pieds, bas des vêtements) s'assombrit légèrement
	float ao = mix(0.84, 1.0, smoothstep(0.0, 0.55, wy));
	// liseré de lumière sur les bords, côté lumière : détache la silhouette du fond
	float fres = pow(1.0 - clamp(dot(n, normalize(VIEW)), 0.0, 1.0), 2.6);
	float side = clamp(dot(n, normalize(vec3(LDIR.x, LDIR.y, 0.0))) * 0.5 + 0.5, 0.0, 1.0);
	ALBEDO = c * shade * ao + vec3(1.0, 0.96, 0.88) * fres * side * 0.20;
}
"""
signal framed

## Diagnostic du dernier cadrage de chaque modèle (affiché sous le compteur d'images).
static var diag: Dictionary = {}
var _bone_cache := {}                      # le cadrage est calculé : la texture est utilisable

var vp: SubViewport
var ready_ok: bool = false         # modèle chargé, cadré et prêt à être affiché
var tip_ok: bool = false
var rendered: int = 0              # nombre de rendus demandés (compteur de performances)

var _cam: Camera3D
var _holder: Node3D
var _model: Node3D
var _sk: Skeleton3D
var _mi: MeshInstance3D
var _skin: Skin
var _prof: Dictionary
var _key: String = ""
var _mat: ShaderMaterial = null
var _rest_q: Array = []
var _rest_p: Array = []
var _tip_local := Vector3.ZERO
var _rest_dir := Vector3.UP
var _last_key: String = ""
var _cell_px: float = float(CELL)
## V386 : facteur de résolution effectif (texels du rendu par pixel logique de cellule), au moins RES_K (384 px) ; EntityView le règle
## pour que la réduction à l'écran soit de 2 pour 1 (filtre de boîte exact avec le filtrage linéaire).
var res_k: float = float(RES_K)
const BLEND_T := 0.12        # V391 : durée du fondu entre deux actions (s)
const BLEND_STEPS := 6       # pas de fondu rendus (chaque pas = un rendu du modèle)
const SIDE_YAW := 34.0       # V391 : le héros se tourne de ±34° vers la droite ou la gauche de l'écran (plus de miroir)
var _cur_anim: String = ""
var _blend_from: Array = []
var _blend_t0: int = 0
var _blend_w: float = 1.0
var _side: float = 0.0
var _ap: AnimationPlayer = null
var _clips: Dictionary = {}
var _flap_mat: ShaderMaterial = null


static func profile(key: String) -> Dictionary:
	if key == "Harpie":
		return HARPIE_MODEL
	return MODELS.get(key, {})


static func supported(classe: String) -> bool:
	var p: Dictionary = profile(classe)
	return not p.is_empty() and ResourceLoader.exists(String(p["path"]))


## Modèle 3D d'une entité ("" si aucun) : boss nommé, sinon classe de héros.
static func model_key(ent: Dictionary, biome: String = "") -> String:
	var classe: String = String(ent.get("classe", ""))
	var key: String = ""
	if bool(ent.get("boss", false)):
		# boss de nation : reconnu par son titre (le type de base, ex. « Dragonnet », est partagé entre plusieurs nations)
		key = String(BOSS_MODEL.get(String(ent.get("title", "")), BOSS_MODEL.get(classe, "")))
	elif String(ent.get("team", "")) == "player":
		key = String(CLASS_MODEL.get(classe, ""))
	elif String(ent.get("team", "")) == "enemy":
		key = String((ENEMY_MODEL.get(biome, {}) as Dictionary).get(classe, ""))
	return key if supported(key) else ""


## Modèle à clips (sans planches cuites pour fournir les durées) ?
static func is_clip_model(key: String) -> bool:
	return profile(key).has("clips")


## Charge le modèle et prépare le rendu. Asynchrone (quelques images pour mesurer le cadrage) : attendre [signal framed].
## [px_scale] > 0 : nombre de pixels écran occupés par un pixel logique de cellule (taille d'affichage ÷ CELL × zoom × étirement).
func setup(classe: String, px_scale: float = 0.0) -> bool:
	if not supported(classe):
		return false
	_prof = profile(classe)
	_key = classe
	if px_scale > 0.0:
		# Suréchantillonnage 2×2 (RES_K = 2, soit 384 px) : réduit exactement de moitié à l'écran, le filtrage linéaire donne
		# alors un vrai filtre de boîte (arêtes lissées sans flou). Plus grand si l'écran agrandit le plateau (tablette, PC).
		# V391 : réglage « Qualité graphique » Économie : 256 px au lieu de 384 (réduction ≈ 1,5 pour 1), moins de pixels par héros
		var floor_k: float = 1.35 if GfxQuality.low() else float(RES_K)
		res_k = clampf(px_scale * floor_k, floor_k, floor_k * 1.5)
	var side: int = roundi(float(CELL) * res_k)
	res_k = float(side) / float(CELL)
	vp = SubViewport.new()
	vp.size = Vector2i(side, side)
	vp.transparent_bg = true
	vp.own_world_3d = true
	vp.msaa_3d = Viewport.MSAA_4X
	vp.render_target_update_mode = SubViewport.UPDATE_ONCE
	add_child(vp)
	var env := Environment.new()
	env.background_mode = Environment.BG_CLEAR_COLOR
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color(0.86, 0.90, 1.0)
	env.ambient_light_energy = 0.55
	var we := WorldEnvironment.new()
	we.environment = env
	vp.add_child(we)
	var sun := DirectionalLight3D.new()
	sun.rotation_degrees = Vector3(-38, -28, 0)
	sun.light_energy = 0.9
	vp.add_child(sun)
	_cam = Camera3D.new()
	_cam.projection = Camera3D.PROJECTION_ORTHOGONAL
	_cam.size = 3.0
	vp.add_child(_cam)
	_cam.current = true
	var mpath: String = String(_prof["path"])
	if OS.has_feature("mobile") and _prof.has("path_mobile") and ResourceLoader.exists(String(_prof["path_mobile"])):
		mpath = String(_prof["path_mobile"])
	if not _load_model(mpath):
		return false
	_frame.call_deferred()
	return true


func texture() -> Texture2D:
	return vp.get_texture()


func _load_model(path: String) -> bool:
	var packed: PackedScene = load(path) as PackedScene
	if packed == null:
		return false
	var n: Node3D = packed.instantiate() as Node3D
	_holder = Node3D.new()
	vp.add_child(_holder)
	_model = Node3D.new()
	_holder.add_child(_model)
	_model.add_child(n)
	var sks: Array = n.find_children("*", "Skeleton3D", true, false)
	var mis: Array = n.find_children("*", "MeshInstance3D", true, false)
	if bool(_prof.get("static", false)):
		return _load_static(mis)
	if sks.is_empty() or mis.is_empty():
		return false
	_sk = sks[0] as Skeleton3D
	_mi = mis[0] as MeshInstance3D
	var src: Material = _mi.mesh.surface_get_material(0)
	var tex: Texture2D = (src as BaseMaterial3D).albedo_texture if src is BaseMaterial3D else null
	# V373 : texture au fond comblé (tools/pad_hero_textures.py) — sans elle, le noir du fond de l'atlas bave sur les coutures
	var pad_path: String = path.get_basename() + "_albedo_pad.webp"
	if ResourceLoader.exists(pad_path):
		tex = load(pad_path) as Texture2D
	if tex == null:
		return false
	var sh := Shader.new()
	sh.code = SHADER
	var mat := ShaderMaterial.new()
	mat.shader = sh
	mat.set_shader_parameter("albedo_tex", tex)
	mat.set_shader_parameter("gain", float(_prof.get("gain", 1.0)))
	_mat = mat
	# V373 : plus de coque inversée — sur ces maillages (faces disjointes) elle semait des éclats noirs sur le visage et
	# l'armure. Le contour vient du sprite 2D (EntityView), net et régulier.
	_skin = _mi.skin
	for i: int in range(_sk.get_bone_count()):
		_rest_q.append(_sk.get_bone_rest(i).basis.get_rotation_quaternion())
		_rest_p.append(_sk.get_bone_rest(i).origin)
	# taille : les os couvrent le personnage de la tête aux pieds
	var lo := Vector3(1e9, 1e9, 1e9)
	var hi := Vector3(-1e9, -1e9, -1e9)
	for k: int in range(_sk.get_bone_count()):
		var p: Vector3 = (_sk.global_transform * _sk.get_bone_global_pose(k)).origin
		lo = lo.min(p)
		hi = hi.max(p)
	var s: float = HERO_H / maxf(hi.y - lo.y, 0.0001)
	_model.scale = Vector3.ONE * s
	var bas: int = _bone(String(_prof.get("root_bone", "bassin")))
	var bx: float = (_sk.global_transform * _sk.get_bone_global_pose(bas)).origin.x
	_model.position = Vector3(-bx * s, -lo.y * s, 0)
	if _prof.has("clips"):
		_clips = _prof["clips"]
		var aps: Array = n.find_children("*", "AnimationPlayer", true, false)
		if aps.is_empty():
			push_warning("Hero3D : aucune animation dans " + path)
			return false
		_ap = aps[0] as AnimationPlayer
		_ap.callback_mode_process = AnimationMixer.ANIMATION_CALLBACK_MODE_PROCESS_MANUAL
	else:
		_rig_staff()
	_mi.set_surface_override_material(0, mat)
	return true


## Modèle sans squelette (harpie) : normalisé à HERO_H par sa boîte englobante, pieds à y = 0, centré. Les ailes battent par
## déformation des sommets (FLAP_UNIFORMS) : seuls les sommets hauts et éloignés de l'axe bougent (jambes et jupe fixes).
func _load_static(mis: Array) -> bool:
	if mis.is_empty():
		return false
	_mi = mis[0] as MeshInstance3D
	var src: Material = _mi.mesh.surface_get_material(0)
	var tex: Texture2D = (src as BaseMaterial3D).albedo_texture if src is BaseMaterial3D else null
	if tex == null:
		return false
	var ab: AABB = _mi.get_aabb()
	var sh := Shader.new()
	sh.code = SHADER.replace("varying float wy;", "varying float wy;\n" + FLAP_UNIFORMS).replace("void vertex() {", "void vertex() {\n\tVERTEX.y += flap_offset(VERTEX, flap, span_info);")
	var mat := ShaderMaterial.new()
	mat.shader = sh
	mat.set_shader_parameter("albedo_tex", tex)
	mat.set_shader_parameter("gain", float(_prof.get("gain", 1.0)))
	mat.set_shader_parameter("span_info", Vector3(ab.size.x * 0.5, ab.get_center().x, ab.position.y + ab.size.y * 0.58))
	_mat = mat
	_flap_mat = mat
	_mi.set_surface_override_material(0, mat)
	var wab: AABB = _mi.global_transform * ab
	var k: float = HERO_H / maxf(wab.size.y, 0.0001)
	_model.scale = Vector3.ONE * k
	_model.position = Vector3(-(wab.position.x + wab.size.x * 0.5) * k, -wab.position.y * k, -(wab.position.z + wab.size.z * 0.5) * k)
	_clips = _prof["clips"]
	return true


## Pose d'un modèle statique : mouvement du corps + battement d'ailes selon l'action (phase ph de 0 à 1).
func _set_pose_static(anim: String, ph: float, back: bool) -> void:
	var c: Dictionary = _clips.get(anim, _clips["idle"])
	var p: float = clampf(ph, 0.0, 1.0)
	var s1: float = sin(p * PI)
	var dy: float = 0.0
	var pitch: float = 0.0
	var flap: float = 0.0
	match String(c.get("motion", "")):
		"idle":
			dy = 0.03 * sin(p * TAU)
			flap = 0.55 * sin(p * TAU * 2.0)
		"walk":
			dy = 0.045 * sin(p * TAU * 2.0)
			flap = 0.9 * sin(p * TAU * 2.0)
		"attack":
			pitch = 16.0 * s1
			dy = 0.05 * s1
			flap = sin(p * TAU * 1.5)
		"cast":
			dy = 0.08 * s1
			pitch = -8.0 * s1
			flap = -0.9 * s1
		"hit":
			pitch = -14.0 * s1
			flap = -0.6 * s1
	_flap_mat.set_shader_parameter("flap", flap)
	_holder.position = Vector3(0, dy * HERO_H, 0)
	var yaw: float = (180.0 if back else 0.0) + _side * SIDE_YAW * (-1.0 if back else 1.0)
	_holder.rotation_degrees = Vector3(pitch, yaw, 0)


func _bind_bone(b: int) -> int:
	if _skin != null and b < _skin.get_bind_count():
		var idx: int = _skin.get_bind_bone(b)
		if idx >= 0:
			return idx
		return _sk.find_bone(_skin.get_bind_name(b))
	return b


func _is_staff(p: Vector3) -> bool:
	return p.x < float(_prof["staff_x"]) and p.z <= float(_prof["staff_z_max"])


## Le bâton est lié à la main, mais son cristal est réparti sur le torse dans les poids de peau : on le rend rigide (100 %
## main). Le bout du bâton (point le plus haut de ces sommets) est exprimé dans le repère de l'os de la main grâce à la
## pose de liaison : plus de mesure par rendu, contrairement à la cuisson.
func _rig_staff() -> void:
	var arr: Array = _mi.mesh.surface_get_arrays(0)
	var verts: PackedVector3Array = arr[Mesh.ARRAY_VERTEX]
	var bones: PackedInt32Array = arr[Mesh.ARRAY_BONES]
	var weights: PackedFloat32Array = arr[Mesh.ARRAY_WEIGHTS]
	var per: int = bones.size() / verts.size()
	var hand: int = _bone(String(_prof["tip_bone"]))
	var hand_bind: int = -1
	for b: int in range(_skin.get_bind_count()):
		if _bind_bone(b) == hand:
			hand_bind = b
	if hand_bind < 0:
		push_warning("Hero3D : os de la main introuvable")
		return
	var best: int = -1
	for v: int in range(verts.size()):
		if not _is_staff(verts[v]):
			continue
		for k: int in range(per):
			bones[v * per + k] = hand_bind if k == 0 else 0
			weights[v * per + k] = 1.0 if k == 0 else 0.0
		if best < 0 or verts[v].z > verts[best].z:
			best = v
	if best < 0:
		push_warning("Hero3D : bâton introuvable")
		return
	arr[Mesh.ARRAY_BONES] = bones
	arr[Mesh.ARRAY_WEIGHTS] = weights
	var am := ArrayMesh.new()
	am.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arr)
	am.surface_set_material(0, _mi.mesh.surface_get_material(0))
	_mi.mesh = am
	_tip_local = _skin.get_bind_pose(hand_bind) * verts[best]
	tip_ok = true


## Cadrage : comme la cuisson, un rendu de la pose de repos de face fixe l'échelle (le personnage occupe CHAR_FRAC de la
## cellule, pieds sur FEET_ROW).
func _frame() -> void:
	if not is_inside_tree():
		await tree_entered
	_set_pose("idle", 0.0, false)
	var passes: int = 0
	var vp_h: float = float(vp.size.y)
	var how: String = "mesuré"
	var guarded: bool = false
	var ref_cam: Vector2 = _prof.get("ref_cam", Vector2.ZERO)
	if ref_cam != Vector2.ZERO:
		# V357 : cadrage de référence (mesuré une fois sur ordinateur). Le personnage est normalisé à HERO_H par ses os :
		# le cadrage ne dépend donc pas de l'appareil, alors que la mesure sur l'image ne se stabilisait pas sur téléphone.
		_cam.size = ref_cam.x
		_cam.position = Vector3(0, ref_cam.y, 10)
		how = "réf"
	else:
		passes = await _measure_frame()
		if passes < 0:
			return
		if not size_plausible(_cam.size):
			guarded = true
			_cam.size = expected_cam_size()
			_cam.position = Vector3(0, (FEET_ROW - 0.5) * _cam.size, 10)
	await _render_wait()
	var img: Image = vp.get_texture().get_image()
	vp_h = float(img.get_height())
	var st: Dictionary = image_stats(img)
	var color_txt: String = await _calibrate_color(st)
	diag[_key] = "cam %.2f %s%s img %d %s" % [_cam.size, how, " GARDE-FOU" if guarded else "", int(vp_h), color_txt]
	if tip_ok:
		var hand: int = _bone(String(_prof["tip_bone"]))
		var g: Transform3D = _sk.global_transform * _sk.get_bone_global_pose(hand)
		_rest_dir = (g.basis * _tip_local).normalized()
	ready_ok = true
	_last_key = ""
	framed.emit()


## Cadrage mesuré sur l'image rendue (outil de calibrage, et repli pour un modèle sans cadrage de référence).
## Renvoie le nombre de passes, ou -1 si le personnage est introuvable.
func _measure_frame() -> int:
	_cam.size = 8.0
	_cam.position = Vector3(0, 1.0, 10)
	var passes: int = 0
	for pass_i: int in range(FRAME_MAX_PASSES):
		await _render_wait()
		var img: Image = vp.get_texture().get_image()
		var vp_h: float = float(img.get_height())
		var bb: Rect2i = _alpha_bbox(img)
		if bb.size.y < 10:
			push_warning("Hero3D : personnage introuvable dans l'image (cadrage)")
			diag[_key] = "introuvable"
			return -1
		passes += 1
		var wpp_old: float = _cam.size / vp_h
		var feet_world: float = _cam.position.y + (0.5 * vp_h - float(bb.end.y)) * wpp_old
		var f: float = (CHAR_FRAC * vp_h) / float(bb.size.y)
		if pass_i >= 2 and absf(f - 1.0) < FRAME_TOL:
			break
		_cam.size = _cam.size / f
		var wpp: float = _cam.size / vp_h
		_cam.position = Vector3(0, feet_world - (0.5 * vp_h - FEET_ROW * vp_h) * wpp, 10)
	return passes


## Recale les couleurs si la luminosité rendue s'écarte de la référence mesurée sur ordinateur (V357 : sur téléphone,
## l'Ingénieur sortait délavé). Renvoie le texte de diagnostic.
func _calibrate_color(st: Dictionary) -> String:
	var l0: float = float(_prof.get("ref_lum", 0.0))
	var lum: float = float(st["lum"])
	var txt: String = "lum %.3f α %.2f bord %.2f" % [lum, float(st["alpha"]), float(st["semi"])]
	if l0 <= 0.0 or _mat == null:
		return txt
	txt += " (réf %.3f)" % l0
	# V373 : l'ombrage ne dépend plus des lumières de la scène, donc plus de l'appareil — pas de recalage.
	if not RECALE or absf(lum / l0 - 1.0) <= LUM_START:
		return txt
	var g: float = 1.0
	for i: int in range(5):
		g = gamma_for(g, l0, lum)
		_mat.set_shader_parameter("gamma", g)
		await _render_wait()
		st = image_stats(vp.get_texture().get_image())
		lum = float(st["lum"])
		if absf(lum / l0 - 1.0) <= LUM_TOL:
			break
	return txt + " → recalé g %.2f lum %.3f" % [g, lum]


## Prochain gamma pour ramener la luminosité [lum] vers [cible] (la luminosité varie comme albédo^gamma).
static func gamma_for(g: float, cible: float, lum: float) -> float:
	var l: float = clampf(lum, 0.02, 0.98)
	var c: float = clampf(cible, 0.02, 0.98)
	return clampf(g * log(c) / log(l), 0.5, 3.0)


## Statistiques de l'image rendue : luminosité moyenne des pixels opaques, opacité moyenne et part de pixels de bord
## (semi-transparents). Sert au recalage des couleurs et au diagnostic.
static func image_stats(img: Image) -> Dictionary:
	var w: int = img.get_width()
	var h: int = img.get_height()
	var n_opaque: int = 0
	var lum_sum: float = 0.0
	var n_vis: int = 0
	var a_sum: float = 0.0
	var n_semi: int = 0
	for y: int in range(h):
		for x: int in range(w):
			var c: Color = img.get_pixel(x, y)
			if c.a > 0.05:
				n_vis += 1
				a_sum += c.a
				if c.a < 0.95:
					n_semi += 1
			if c.a > 0.9:
				n_opaque += 1
				lum_sum += 0.299 * c.r + 0.587 * c.g + 0.114 * c.b
	return {"lum": lum_sum / maxf(1.0, float(n_opaque)), "alpha": a_sum / maxf(1.0, float(n_vis)),
		"semi": float(n_semi) / maxf(1.0, float(n_vis)), "n": n_vis}


## Taille de caméra attendue (hauteur visible en unités) pour un personnage de HERO_H occupant CHAR_FRAC de la cellule.
static func expected_cam_size() -> float:
	return HERO_H / CHAR_FRAC * 1.15


## La taille mesurée est-elle crédible ? (les modèles testés vont de 1,1 à 1,8 fois HERO_H / CHAR_FRAC)
static func size_plausible(size: float) -> bool:
	var base: float = HERO_H / CHAR_FRAC
	return size >= base * 0.85 and size <= base * 2.3


func _render_wait() -> void:
	vp.render_target_update_mode = SubViewport.UPDATE_ONCE
	await get_tree().process_frame
	await get_tree().process_frame
	await RenderingServer.frame_post_draw


func _alpha_bbox(img: Image) -> Rect2i:
	var x0: int = img.get_width()
	var y0: int = img.get_height()
	var x1: int = -1
	var y1: int = -1
	for y: int in range(img.get_height()):
		for x: int in range(img.get_width()):
			if img.get_pixel(x, y).a > 0.3:
				x0 = mini(x0, x)
				x1 = maxi(x1, x)
				y0 = mini(y0, y)
				y1 = maxi(y1, y)
	if x1 < 0:
		return Rect2i()
	return Rect2i(x0, y0, x1 - x0 + 1, y1 - y0 + 1)


## Pose + rendu demandé. Phase ∈ [0, 1] de l'animation [anim] (voir HeroAnim). Rien n'est refait si la pose ne change pas
## (phase arrondie au 1/72).
func show_pose(anim: String, phase: float, back: bool, side: float = 0.0) -> void:
	if not ready_ok:
		return
	# V391 : fondu entre deux actions (0,12 s) : la pose affichée juste avant le changement sert de point de départ
	var wq: int = BLEND_STEPS
	if _ap != null:
		if anim != _cur_anim:
			if _cur_anim != "":
				_blend_from = _snapshot()
				_blend_t0 = Time.get_ticks_msec()
			_cur_anim = anim
		if not _blend_from.is_empty():
			var w: float = clampf(float(Time.get_ticks_msec() - _blend_t0) / 1000.0 / BLEND_T, 0.0, 1.0)
			wq = roundi(w * float(BLEND_STEPS))
			if wq >= BLEND_STEPS:
				_blend_from = []
				wq = BLEND_STEPS
	_blend_w = float(wq) / float(BLEND_STEPS)
	_side = side
	var key: String = "%s|%d|%d|%d|%d" % [anim, roundi(phase * 72.0), 1 if back else 0, wq, roundi(side)]
	if key == _last_key:
		return
	_last_key = key
	_set_pose(anim, phase, back)
	vp.render_target_update_mode = SubViewport.UPDATE_ONCE
	rendered += 1


## Rotation et position locale de chaque os dans la pose actuelle (point de départ d'un fondu).
func _snapshot() -> Array:
	var out: Array = []
	if _sk == null:
		return out
	for i: int in range(_sk.get_bone_count()):
		out.append([_sk.get_bone_pose_rotation(i), _sk.get_bone_pose_position(i)])
	return out


## Position (pixels de la texture, cellule × RES_K) du bout du bâton dans la pose affichée.
func tip_px() -> Vector2:
	if not tip_ok or not ready_ok:
		return Vector2(-1.0, -1.0)
	var hand: int = _bone(String(_prof["tip_bone"]))
	var g: Transform3D = _sk.global_transform * _sk.get_bone_global_pose(hand)
	return _cam.unproject_position(g * _tip_local)


## Oriente le bâton (voir tools/bake_hero_seq.gd, _aim_staff) : la main pivote pour que le bâton pointe vers [d].
func _aim_staff(d: Vector3, w: float) -> void:
	var hand: int = _bone(String(_prof["tip_bone"]))
	var g: Transform3D = _sk.get_bone_global_pose(hand)
	var t_hs: Basis = (_holder.global_transform.affine_inverse() * _sk.global_transform).basis.orthonormalized()
	var target: Vector3 = (t_hs.inverse() * d.normalized()).normalized()
	var cur: Vector3 = (g.basis * _tip_local).normalized()
	var want: Vector3 = _rest_dir.slerp(target, w).normalized()
	var axis: Vector3 = cur.cross(want)
	if axis.length() < 0.0001:
		return
	var rot := Basis(axis.normalized(), cur.angle_to(want))
	_sk.set_bone_global_pose(hand, Transform3D(rot * g.basis, g.origin))


## Les noms d'os du .glb n'ont pas de point (« bras_r », « avantBras_r », « torax ») : on retrouve celui d'une pose (« bras.r », « avantbras.r », « torse »).
func _bone(name: String) -> int:
	if _bone_cache.has(name):
		return _bone_cache[name]
	var want: String = name.replace(".", "_").to_lower()
	if want == "torse":
		want = "torax"
	var found: int = -1
	for i: int in range(_sk.get_bone_count()):
		if _sk.get_bone_name(i).to_lower() == want:
			found = i
			break
	_bone_cache[name] = found
	return found


## Pose d'un modèle à clips : temps dans le clip de l'action, puis éventuel mouvement du corps (actions sans clip propre).
func _set_pose_clip(anim: String, ph: float, back: bool) -> void:
	var c: Dictionary = _clips.get(anim, _clips["idle"])
	var name: String = String(c["clip"])
	if _ap.has_animation(name):
		var len: float = _ap.get_animation(name).length
		var t: float = clampf(lerpf(float(c["t0"]), float(c["t1"]), clampf(ph, 0.0, 1.0)), 0.0, len)
		if _ap.current_animation != name:
			_ap.play(name)
		_ap.seek(t, true)
		_ap.pause()
		_ap.advance(0.0)
		if _blend_w < 1.0 and not _blend_from.is_empty():
			for i: int in range(mini(_blend_from.size(), _sk.get_bone_count())):
				var f: Array = _blend_from[i]
				_sk.set_bone_pose_rotation(i, (f[0] as Quaternion).slerp(_sk.get_bone_pose_rotation(i), _blend_w))
				_sk.set_bone_pose_position(i, (f[1] as Vector3).lerp(_sk.get_bone_pose_position(i), _blend_w))
	var dy: float = 0.0
	var pitch: float = 0.0
	var s1: float = sin(clampf(ph, 0.0, 1.0) * PI)
	match String(c.get("motion", "")):
		"walk":
			dy = 0.025 * absf(sin(ph * TAU * 2.0))
		"attack":
			pitch = 14.0 * s1
			dy = 0.03 * s1
		"cast":
			dy = 0.07 * s1
			pitch = -6.0 * s1
		"hit":
			pitch = -12.0 * s1
		"dead":
			# V391 : le corps entier bascule en arrière à partir de 30 % du clip et finit couché ; on relève un peu le modèle
			# (le pivot est aux pieds, le dos passerait sous le sol)
			var f2: float = smoothstep(0.30, 1.0, clampf(ph, 0.0, 1.0))
			pitch = -86.0 * f2 * f2
			dy = 0.07 * f2
	_holder.position = Vector3(0, dy * HERO_H, 0)
	var yaw: float = (180.0 if back else 0.0) + _side * SIDE_YAW * (-1.0 if back else 1.0)
	_holder.rotation_degrees = Vector3(pitch, yaw, 0)


func _set_pose(anim: String, ph: float, back: bool) -> void:
	if _flap_mat != null:
		_set_pose_static(anim, ph, back)
		return
	if _ap != null:
		_set_pose_clip(anim, ph, back)
		return
	for i: int in range(_sk.get_bone_count()):
		_sk.set_bone_pose_rotation(i, _rest_q[i])
		_sk.set_bone_pose_position(i, _rest_p[i])
	var p: Dictionary = HeroAnim.pose(anim, ph)
	var bones: Dictionary = p["bones"]
	for bn: String in bones.keys():
		var i2: int = _bone(bn)
		if i2 < 0:
			continue
		var e: Vector3 = (bones[bn] as Vector3) * (PI / 180.0)
		_sk.set_bone_pose_rotation(i2, _rest_q[i2] * Quaternion.from_euler(e))
	_holder.position = Vector3(float(p["dx"]) * HERO_H, float(p["dy"]) * HERO_H, 0)
	var yaw: float = float(HeroAnim.ANIMS[anim]["yaw"]) + float(p["yaw"])
	_holder.rotation_degrees = Vector3(float(p["pitch"]), 180.0 - yaw if back else yaw, 0)
	if p.has("staff") and tip_ok and ready_ok:
		_aim_staff(p["staff"] as Vector3, float(p["staff_w"]))
