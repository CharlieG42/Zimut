extends SceneTree
## Cuit Zimut (le personnage du joueur, modèle 3D animé du mode 3D) en planche de sprites pour la carte 2D d'aventure.
##   xvfb-run -a -s "-screen 0 1280x720x24" godot --rendering-method gl_compatibility --path . -s tools/bake_walk_sprites.gd -- <dossier>
## Une seule planche (zimut.png), la même pour toutes les classes (V153) : 8 lignes (directions : bas, bas-droite, droite, haut-droite, haut,
## haut-gauche, gauche, bas-gauche) × 12 colonnes (4 images de repos, puis 8 images de marche).
## Cellule 128 × 160 px, personnage ≈ 89 % de la hauteur, pieds à 5 % du bas.

const CELL := Vector2i(128, 160)
const SS := 2                      # sur-échantillonnage avant réduction
const IDLE_N := 4
const WALK_N := 8
const ORTHO_H := 2.2               # hauteur du cadre en mètres
const PITCH := 16.0                # inclinaison de la caméra (°)

func _init() -> void:
	_run.call_deferred()

func _run() -> void:
	var args: PackedStringArray = OS.get_cmdline_user_args()
	var out: String = args[0]
	DirAccess.make_dir_recursive_absolute(out)
	var vp := SubViewport.new()
	vp.size = CELL * SS
	vp.transparent_bg = true
	vp.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	vp.msaa_3d = Viewport.MSAA_4X
	root.add_child(vp)
	var env := Environment.new()
	env.background_mode = Environment.BG_CLEAR_COLOR
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color(0.82, 0.86, 0.95)
	env.ambient_light_energy = 0.65
	var we := WorldEnvironment.new()
	we.environment = env
	vp.add_child(we)
	var sun := DirectionalLight3D.new()
	sun.rotation_degrees = Vector3(-50, -25, 0)
	sun.light_energy = 0.95
	vp.add_child(sun)
	var cam := Camera3D.new()
	cam.projection = Camera3D.PROJECTION_ORTHOGONAL
	cam.size = ORTHO_H
	vp.add_child(cam)
	cam.current = true
	var pitch: float = deg_to_rad(PITCH)
	var dist: float = 8.0
	var target := Vector3(0, ORTHO_H * 0.5 - 0.10, 0)
	cam.position = target + Vector3(0, sin(pitch) * dist, cos(pitch) * dist)
	cam.look_at(target)
	var rig: Adv3DZimut = Adv3DZimut.make() as Adv3DZimut
	vp.add_child(rig)
	for ch: Node in rig.get_children():
		if ch is MeshInstance3D:
			ch.visible = false         # ombre au sol : le 2D dessine la sienne
	var sheet := Image.create(CELL.x * (IDLE_N + WALK_N), CELL.y * 8, false, Image.FORMAT_RGBA8)
	for dir: int in range(8):
		rig.rotation.y = float(dir) * PI / 4.0
		for col: int in range(IDLE_N + WALK_N):
			if col < IDLE_N:
				rig.pose_idle(float(col) / float(IDLE_N))
			else:
				rig.pose_walk(float(col - IDLE_N) / float(WALK_N))
			await process_frame
			await process_frame
			await RenderingServer.frame_post_draw
			var img: Image = vp.get_texture().get_image()
			img.convert(Image.FORMAT_RGBA8)
			img.resize(CELL.x, CELL.y, Image.INTERPOLATE_LANCZOS)
			sheet.blit_rect(img, Rect2i(Vector2i.ZERO, CELL), Vector2i(col * CELL.x, dir * CELL.y))
	sheet.save_png(out + "/zimut.png")
	print("OK zimut")
	quit()
