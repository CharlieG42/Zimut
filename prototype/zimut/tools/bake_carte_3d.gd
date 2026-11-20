extends SceneTree
## Cuit l'illustration d'une carte à partir d'un modèle 3D de Hero3D (rendu sur fond transparent, rogné sur le personnage).
## Usage : xvfb-run -a godot --rendering-driver opengl3 --path . -s tools/bake_carte_3d.gd -- Harpie assets/sprites/cartes/n_harpie.png [animation phase]
func _init() -> void:
	_go.call_deferred()


func _go() -> void:
	var args: PackedStringArray = OS.get_cmdline_user_args()
	if args.size() < 2:
		push_error("usage : -- <modèle> <sortie.png> [animation] [phase]")
		quit(1)
		return
	var h := Hero3D.new()
	root.add_child(h)
	if not h.setup(args[0], 3.0):
		push_error("modèle introuvable : " + args[0])
		quit(1)
		return
	await h.framed
	h.show_pose(args[2] if args.size() > 2 else "idle", float(args[3]) if args.size() > 3 else 0.125, false)
	for i: int in 4:
		await process_frame
	var img: Image = h.texture().get_image()
	var box: Rect2i = img.get_used_rect()
	var m: int = 6
	box = box.grow(m).intersection(Rect2i(Vector2i.ZERO, img.get_size()))
	img.get_region(box).save_png(args[1])
	print("carte 3D : ", args[1], " ", box.size)
	quit(0)
