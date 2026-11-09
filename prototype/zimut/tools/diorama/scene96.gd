extends SceneTree
## Rend la Sylve en passes : beauty | depth | normal.
## godot --rendering-method gl_compatibility --path <proj> -s scene.gd -- <mode> <out.png> <largeur> <hauteur>
const S := 96.0
var AMP: float = float(OS.get_environment("DIORAMA_AMP")) if OS.get_environment("DIORAMA_AMP") != "" else 2.6   # = HMAX du plan (height2.png normalisé)
const DMAX := 220.0
var DIR: String = OS.get_environment("DIORAMA_WORK").path_join("")
const PASS_HEAD := "shader_type spatial; render_mode unshaded, cull_disabled;
uniform sampler2D tex : source_color, filter_linear_mipmap;
uniform float use_tex = 0.0;
uniform float cut = 0.5;
uniform float cls = 0.0;
varying float dd;
void vertex() { dd = -(MODELVIEW_MATRIX * vec4(VERTEX, 1.0)).z; }
"
const DEPTH_FRAG := "void fragment() { if (use_tex > 0.5 && texture(tex, UV).a < cut) discard; float v = clamp(dd / 220.0, 0.0, 1.0) * 255.0; ALBEDO = vec3(floor(v) / 255.0, fract(v), cls); }"
const ID_FRAG := "uniform vec3 idc = vec3(0.0); void fragment() { if (use_tex > 0.5 && texture(tex, UV).a < cut) discard; ALBEDO = idc; }"
const ID_FRAG_END := ""
const NORMAL_FRAG := "void fragment() { if (use_tex > 0.5 && texture(tex, UV).a < cut) discard; vec3 n = (INV_VIEW_MATRIX * vec4(NORMAL, 0.0)).xyz; if (!FRONT_FACING) n = -n; ALBEDO = n * 0.5 + 0.5; }"
var pass_shader: Shader
const TINT_SHADER := "shader_type spatial; render_mode cull_disabled;
uniform sampler2D tex : source_color, filter_linear_mipmap;
uniform vec3 tint : source_color;
uniform float cut = 0.5;
void fragment() { vec4 t = texture(tex, UV); if (t.a < cut) discard; float l = dot(t.rgb, vec3(0.3, 0.59, 0.11)); ALBEDO = tint * (0.55 + 0.9 * l); ROUGHNESS = 1.0; SPECULAR = 0.0; }"
var tint_shader: Shader
var warm_tex: Texture2D

var cache := {}

func _load(path: String) -> Node:
	if cache.has(path):
		return cache[path]
	var doc := GLTFDocument.new()
	var st := GLTFState.new()
	doc.append_from_file(path, st)
	var n: Node = doc.generate_scene(st)
	_fix(n)
	if path.contains("fantasy-town"):
		_swap(n)
	cache[path] = n
	return n

func _swap(n: Node) -> void:
	if warm_tex == null:
		warm_tex = ImageTexture.create_from_image(Image.load_from_file(DIR + "colormap_warm.png"))
	if n is MeshInstance3D:
		var mi: MeshInstance3D = n
		for i in range(mi.mesh.get_surface_count()):
			var m: Material = mi.get_surface_override_material(i)
			if m is BaseMaterial3D and (m as BaseMaterial3D).albedo_texture != null:
				(m as BaseMaterial3D).albedo_texture = warm_tex
	for c in n.get_children():
		_swap(c)

func _fix(n: Node) -> void:
	if n is MeshInstance3D and String(n.name).contains("ignore"):
		var wm := StandardMaterial3D.new()
		wm.albedo_color = Color(0.13, 0.28, 0.34)
		wm.roughness = 0.12
		wm.metallic_specular = 0.9
		wm.rim_enabled = true
		wm.rim = 0.35
		var wmi: MeshInstance3D = n
		for i in range(wmi.mesh.get_surface_count()):
			wmi.set_surface_override_material(i, wm)
		return
	if n is MeshInstance3D:
		var mi: MeshInstance3D = n
		if mi.mesh != null:
			for i in range(mi.mesh.get_surface_count()):
				var m: Material = mi.mesh.surface_get_material(i)
				if m is BaseMaterial3D:
					var d: BaseMaterial3D = (m as BaseMaterial3D).duplicate()
					d.metallic = 0.0
					d.roughness = 0.88
					d.specular_mode = BaseMaterial3D.SPECULAR_DISABLED
					mi.set_surface_override_material(i, d)
	for c in n.get_children():
		_fix(c)

const ROOF := {"chapelle": Color(0.26, 0.29, 0.36), "moulin": Color(0.36, 0.25, 0.20), "maison_pierre": Color(0.55, 0.25, 0.17), "maison_bois": Color(0.50, 0.24, 0.17), "grange": Color(0.42, 0.27, 0.20), "chaumiere": Color(0.74, 0.58, 0.30)}

func _tint(n: Node, col: Color, mult: bool) -> void:
	if n is MeshInstance3D:
		var mi: MeshInstance3D = n
		if mi.mesh != null:
			for i in range(mi.mesh.get_surface_count()):
				var m: Material = mi.get_surface_override_material(i)
				if m == null:
					m = mi.mesh.surface_get_material(i)
				if m is BaseMaterial3D:
					var d: BaseMaterial3D = (m as BaseMaterial3D).duplicate()
					d.metallic = 0.0
					d.roughness = 0.88
					d.specular_mode = BaseMaterial3D.SPECULAR_DISABLED
					if mult:
						d.albedo_color = col
					else:
						d.albedo_texture = null
						d.albedo_color = col
					mi.set_surface_override_material(i, d)
	for c in n.get_children():
		_tint(c, col, mult)

func _emit(n: Node, col: Color, e: float) -> void:
	if n is MeshInstance3D:
		var mi: MeshInstance3D = n
		if mi.mesh != null:
			for i in range(mi.mesh.get_surface_count()):
				var m: Material = mi.get_surface_override_material(i)
				if m == null:
					m = mi.mesh.surface_get_material(i)
				if m is BaseMaterial3D:
					var d: BaseMaterial3D = (m as BaseMaterial3D).duplicate()
					d.emission_enabled = true
					d.emission = col
					d.emission_energy_multiplier = e
					mi.set_surface_override_material(i, d)
	for c in n.get_children():
		_emit(c, col, e)

func _first_mesh(n: Node, t: Transform3D, out: Array) -> void:
	var tt: Transform3D = t
	if n is Node3D:
		tt = t * (n as Node3D).transform
	if n is MeshInstance3D and out.is_empty():
		out.append([n, tt])
	for c in n.get_children():
		_first_mesh(c, tt, out)

func _terrain() -> Node3D:
	var himg := Image.load_from_file(DIR + "height2.png")
	himg.convert(Image.FORMAT_RF)
	var HW: int = himg.get_width()
	var root3 := Node3D.new()
	var CHN := 2
	var N := 480
	var cs: float = S / CHN
	var NT: int = N * CHN
	var hs := PackedFloat32Array()
	hs.resize((NT + 1) * (NT + 1))
	for j in range(NT + 1):
		for i in range(NT + 1):
			var px: int = mini(HW - 1, int(float(i) / NT * HW))
			var py: int = mini(HW - 1, int(float(j) / NT * HW))
			hs[j * (NT + 1) + i] = himg.get_pixel(px, py).r * AMP
	for cj in range(CHN):
		for ci in range(CHN):
			var st := SurfaceTool.new()
			st.begin(Mesh.PRIMITIVE_TRIANGLES)
			for j in range(N):
				for i in range(N):
					var gi: int = ci * N + i
					var gj: int = cj * N + j
					var p00 := Vector3(float(gi) / NT * S, hs[gj * (NT + 1) + gi], float(gj) / NT * S)
					var p10 := Vector3(float(gi + 1) / NT * S, hs[gj * (NT + 1) + gi + 1], float(gj) / NT * S)
					var p01 := Vector3(float(gi) / NT * S, hs[(gj + 1) * (NT + 1) + gi], float(gj + 1) / NT * S)
					var p11 := Vector3(float(gi + 1) / NT * S, hs[(gj + 1) * (NT + 1) + gi + 1], float(gj + 1) / NT * S)
					var uv00 := Vector2(float(i) / N, float(j) / N)
					var uv10 := Vector2(float(i + 1) / N, float(j) / N)
					var uv01 := Vector2(float(i) / N, float(j + 1) / N)
					var uv11 := Vector2(float(i + 1) / N, float(j + 1) / N)
					for tri in [[p00, p10, p01, uv00, uv10, uv01], [p10, p11, p01, uv10, uv11, uv01]]:
						for k in range(3):
							st.set_uv(tri[3 + k])
							st.add_vertex(tri[k])
			st.generate_normals()
			var mesh: ArrayMesh = st.commit()
			var mat := StandardMaterial3D.new()
			var gimg := Image.load_from_file(DIR + "ground_%d_%d.png" % [ci, cj])
			gimg.generate_mipmaps()
			mat.albedo_texture = ImageTexture.create_from_image(gimg)
			mat.texture_filter = BaseMaterial3D.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS_ANISOTROPIC
			mat.texture_repeat = false
			var emit_path: String = DIR + "ground_emit_%d_%d.png" % [ci, cj]
			mat.roughness = 1.0
			mat.specular_mode = BaseMaterial3D.SPECULAR_DISABLED
			if FileAccess.file_exists(emit_path):
				# lave : émission lue dans une texture (non ombrée), via un shader (plus sûr que emission_texture en GLES3)
				var eimg := Image.load_from_file(emit_path)
				eimg.generate_mipmaps()
				var sh := Shader.new()
				sh.code = "shader_type spatial; render_mode specular_disabled; uniform sampler2D alb : source_color, filter_linear_mipmap_anisotropic; uniform sampler2D emi : source_color, filter_linear_mipmap; void fragment() { ALBEDO = texture(alb, UV).rgb; EMISSION = texture(emi, UV).rgb * 0.55; ROUGHNESS = 1.0; }"
				var smt := ShaderMaterial.new()
				smt.shader = sh
				smt.set_shader_parameter("alb", mat.albedo_texture)
				smt.set_shader_parameter("emi", ImageTexture.create_from_image(eimg))
				mesh.surface_set_material(0, smt)
			else:
				mesh.surface_set_material(0, mat)
			var mi := MeshInstance3D.new()
			mi.mesh = mesh
			root3.add_child(mi)
	# jupe : bords du monde (terre + strates)
	var sk := SurfaceTool.new()
	sk.begin(Mesh.PRIMITIVE_TRIANGLES)
	var bottom := -1.7
	var edges: Array = []
	for i in range(NT):
		edges.append([Vector3(float(i) / NT * S, hs[i], 0.0), Vector3(float(i + 1) / NT * S, hs[i + 1], 0.0)])
		edges.append([Vector3(float(i + 1) / NT * S, hs[NT * (NT + 1) + i + 1], S), Vector3(float(i) / NT * S, hs[NT * (NT + 1) + i], S)])
		edges.append([Vector3(0.0, hs[(i + 1) * (NT + 1)], float(i + 1) / NT * S), Vector3(0.0, hs[i * (NT + 1)], float(i) / NT * S)])
		edges.append([Vector3(S, hs[i * (NT + 1) + NT], float(i) / NT * S), Vector3(S, hs[(i + 1) * (NT + 1) + NT], float(i + 1) / NT * S)])
	for e in edges:
		var a: Vector3 = e[0]
		var b: Vector3 = e[1]
		var ab := Vector3(a.x, bottom, a.z)
		var bb := Vector3(b.x, bottom, b.z)
		var nrm := (b - a).cross(ab - a).normalized()
		for L in range(5):
			var t0: float = float(L) / 5
			var t1: float = float(L + 1) / 5
			var c: Color = [Color(0.36, 0.25, 0.16), Color(0.43, 0.31, 0.20), Color(0.33, 0.24, 0.16), Color(0.46, 0.35, 0.24), Color(0.30, 0.22, 0.15)][L]
			var va := a.lerp(ab, t0)
			var vb := b.lerp(bb, t0)
			var vc := a.lerp(ab, t1)
			var vd := b.lerp(bb, t1)
			for v in [va, vb, vc, vb, vd, vc]:
				sk.set_color(c)
				sk.set_normal(nrm)
				sk.add_vertex(v)
	var skm: ArrayMesh = sk.commit()
	var smat := StandardMaterial3D.new()
	smat.vertex_color_use_as_albedo = true
	smat.roughness = 1.0
	smat.specular_mode = BaseMaterial3D.SPECULAR_DISABLED
	smat.cull_mode = BaseMaterial3D.CULL_DISABLED
	skm.surface_set_material(0, smat)
	var skirt := MeshInstance3D.new()
	skirt.mesh = skm
	root3.add_child(skirt)
	return root3

func _water(o: Dictionary) -> MeshInstance3D:
	var cm := CylinderMesh.new()
	cm.top_radius = 1.0
	cm.bottom_radius = 1.0
	cm.height = 0.02
	cm.radial_segments = 96
	var wm := StandardMaterial3D.new()
	wm.albedo_color = Color(0.13, 0.28, 0.34)
	wm.roughness = 0.12
	wm.metallic_specular = 0.9
	wm.rim_enabled = true
	wm.rim = 0.35
	cm.material = wm
	var mi := MeshInstance3D.new()
	mi.mesh = cm
	var c: Array = o["c"]
	var r: Array = o["r"]
	mi.position = Vector3(float(c[0]), float(o["y"]), float(c[1]))
	mi.rotation_degrees.y = -float(o["ang"])
	mi.scale = Vector3(float(r[0]), 1.0, float(r[1]))
	mi.set_meta("cls", 0.0)
	return mi

func _t(l: String) -> void:
	print("[t] %s %d ms" % [l, Time.get_ticks_msec()])

func _boot() -> void:
	var a: PackedStringArray = OS.get_cmdline_user_args()
	var mode: String = a[0]
	var out: String = a[1]
	var W: int = int(a[2])
	var H: int = int(a[3])
	RenderingServer.directional_shadow_atlas_set_size(8192, true)
	RenderingServer.directional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_ULTRA)
	var vp := SubViewport.new()
	vp.size = Vector2i(W, H)
	vp.transparent_bg = true
	vp.own_world_3d = true
	vp.msaa_3d = Viewport.MSAA_DISABLED
	vp.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	var holder := Node3D.new()
	vp.add_child(holder)
	var world := Node3D.new()
	holder.add_child(world)
	_t("start")
	world.add_child(_terrain())
	_t("terrain")
	var objs: Array = JSON.parse_string(FileAccess.get_file_as_string(DIR + "objects.json"))
	var mm_groups := {}
	for o in objs:
		if o["type"] == "water":
			world.add_child(_water(o))
			continue
		if o["type"] == "lava":
			var lv: MeshInstance3D = _water(o)
			var lm := StandardMaterial3D.new()
			lm.albedo_color = Color(0.9, 0.32, 0.06)
			lm.emission_enabled = true
			lm.emission = Color(1.0, 0.42, 0.08)
			lm.emission_energy_multiplier = 1.1
			lm.roughness = 0.6
			(lv.mesh as CylinderMesh).material = lm
			world.add_child(lv)
			continue
		if o["type"] == "light":
			if mode == "beauty":
				var ol := OmniLight3D.new()
				var lp: Array = o["p"]
				ol.position = Vector3(float(lp[0]), float(lp[1]), float(lp[2]))
				var lc: Array = o["c"]
				ol.light_color = Color(float(lc[0]), float(lc[1]), float(lc[2]))
				ol.light_energy = float(o.get("e", 2.0))
				ol.omni_range = float(o.get("range", 4.0))
				ol.omni_attenuation = 1.4
				ol.shadow_enabled = false
				world.add_child(ol)
			continue
		var p: Array = o["p"]
		if o["type"] == "asm":
			var asm := Node3D.new()
			asm.position = Vector3(p[0], p[1], p[2])
			asm.rotation_degrees.y = float(o["r"])
			var gs: float = float(o["s"])
			asm.scale = Vector3(gs, gs, gs)
			for part in o["parts"]:
				var n: Node3D
				if part.has("prism"):
					var pm := PrismMesh.new()
					var ps: Array = part["prism"]
					pm.size = Vector3(ps[0], ps[1], ps[2])
					var mat := StandardMaterial3D.new()
					var c: Array = part["col"]
					mat.albedo_color = Color(c[0], c[1], c[2]) if bool(o.get("wood", false)) else Color(0.86, 0.80, 0.68) * Color(float(o.get("wall_mul", [1, 1, 1])[0]), float(o.get("wall_mul", [1, 1, 1])[1]), float(o.get("wall_mul", [1, 1, 1])[2]))
					mat.roughness = 0.9
					pm.material = mat
					var mi := MeshInstance3D.new()
					mi.mesh = pm
					n = mi
				else:
					n = _load(ProjectSettings.globalize_path("res://").path_join("../../atelier_3d/kenney/") + String(part["f"])).duplicate()
					var pf: String = String(part["f"])
					if pf.contains("roof"):
						_tint(n, Color(float(o["roof"][0]), float(o["roof"][1]), float(o["roof"][2])), false)
					elif pf.contains("wall") and not pf.contains("wood"):
						var wm: Array = o.get("wall_mul", [1.0, 0.98, 0.95])
						_tint(n, Color(float(wm[0]), float(wm[1]), float(wm[2])), true)
				var pp: Array = part.get("p", [0, 0, 0])
				n.position = Vector3(pp[0], pp[1], pp[2])
				n.rotation_degrees.y = float(part.get("r", 0))
				n.rotation_degrees.x = float(part.get("rx", 0))
				var sc: Array = part.get("sc", [1, 1, 1])
				n.scale = Vector3(sc[0], sc[1], sc[2]) * float(part.get("s", 1.0))
				asm.add_child(n)
			asm.set_meta("cls", 1.0)
			asm.set_meta("oid", int(o.get("oid", 0)))
			world.add_child(asm)
			continue
		var f: String = o["f"]
		var tkey: String = f + ("|" + JSON.stringify(o["tint"]) if o.has("tint") else "")
		var scv: Vector3 = Vector3.ONE * float(o["s"])
		if o.has("sc"):
			scv = Vector3(float(o["sc"][0]), float(o["sc"][1]), float(o["sc"][2])) * float(o["s"])
		var xf := Transform3D(Basis.from_euler(Vector3(0, deg_to_rad(float(o["r"])), 0)) * Basis.from_scale(scv), Vector3(p[0], p[1], p[2]))
		if o.get("mm", false):
			if not mm_groups.has(tkey):
				mm_groups[tkey] = []
			(mm_groups[tkey] as Array).append(xf)
			continue
		var n2: Node3D = _load(f).duplicate()
		n2.transform = xf
		if o.has("mul"):
			_tint(n2, Color(float(o["mul"][0]), float(o["mul"][1]), float(o["mul"][2])), true)
		if o.has("emit"):
			_emit(n2, Color(float(o["emit"][0]), float(o["emit"][1]), float(o["emit"][2])), float(o.get("emit_e", 1.0)))
		n2.set_meta("oid", int(o.get("oid", 0)))
		n2.set_meta("cls", 1.0 if (f.contains("kenney") or f.contains("Rock") or f.contains("rock")) else 0.5)
		world.add_child(n2)
	for key in mm_groups.keys():
		var f: String = String(key).get_slice("|", 0)
		var tint_s: String = String(key).get_slice("|", 1) if String(key).contains("|") else ""
		var found: Array = []
		_first_mesh(_load(f), Transform3D.IDENTITY, found)
		if found.is_empty():
			continue
		var mi0: MeshInstance3D = found[0][0]
		var local: Transform3D = found[0][1]
		var mm := MultiMesh.new()
		mm.transform_format = MultiMesh.TRANSFORM_3D
		var msh: Mesh = mi0.mesh.duplicate()
		for s2 in range(msh.get_surface_count()):
			var m2: Material = mi0.get_surface_override_material(s2)
			if m2 != null:
				if tint_s != "" and m2 is BaseMaterial3D and (m2 as BaseMaterial3D).albedo_texture != null:
					if tint_shader == null:
						tint_shader = Shader.new()
						tint_shader.code = TINT_SHADER
					var tc: Array = JSON.parse_string(tint_s)
					var tm := ShaderMaterial.new()
					tm.shader = tint_shader
					tm.set_shader_parameter("tex", (m2 as BaseMaterial3D).albedo_texture)
					tm.set_shader_parameter("tint", Color(tc[0], tc[1], tc[2]))
					msh.surface_set_material(s2, tm)
				else:
					msh.surface_set_material(s2, m2)
		mm.mesh = msh
		var xs: Array = mm_groups[key]
		mm.instance_count = xs.size()
		for i in range(xs.size()):
			mm.set_instance_transform(i, (xs[i] as Transform3D) * local)
		var mmi := MultiMeshInstance3D.new()
		mmi.set_meta("cls", 1.0 if (f.contains("kenney") or f.contains("Rock") or f.contains("rock")) else 0.5)
		mmi.multimesh = mm
		world.add_child(mmi)
	_t("objets")
	# matériaux de passes
	if mode != "beauty":
		pass_shader = Shader.new()
		pass_shader.code = PASS_HEAD + (DEPTH_FRAG if mode == "depth" else (ID_FRAG if mode == "id" else NORMAL_FRAG))
		_override(world, 0.0)
	# éclairage
	var e := Environment.new()
	e.background_mode = Environment.BG_COLOR
	e.background_color = Color(0, 0, 0, 0)
	var brasier: bool = OS.get_environment("DIORAMA_MOOD") == "brasier"
	if mode == "beauty":
		e.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
		e.ambient_light_color = Color(0.70, 0.62, 0.66) if brasier else Color(0.66, 0.76, 0.95)
		e.ambient_light_energy = 0.55 if brasier else 0.62
		e.tonemap_mode = Environment.TONE_MAPPER_FILMIC
		e.tonemap_exposure = 1.05
	var env := WorldEnvironment.new()
	env.environment = e
	holder.add_child(env)
	var center := Vector3(48, 0.0, 48)
	if mode == "beauty":
		var sun := DirectionalLight3D.new()
		sun.light_energy = 1.3 if brasier else 1.55
		sun.light_color = Color(1.0, 0.88, 0.74) if brasier else Color(1.0, 0.93, 0.80)
		sun.shadow_enabled = true
		sun.directional_shadow_mode = DirectionalLight3D.SHADOW_ORTHOGONAL
		sun.directional_shadow_max_distance = 200.0
		sun.shadow_bias = 0.03
		sun.shadow_normal_bias = 1.2
		sun.shadow_blur = 1.6
		holder.add_child(sun)
		sun.look_at_from_position(center + Vector3(-0.38, 0.82, 0.62) * 100.0, center, Vector3.UP)
		var fill := DirectionalLight3D.new()
		fill.light_energy = 0.28
		fill.light_color = Color(1.0, 0.45, 0.25) if brasier else Color(0.62, 0.74, 1.0)
		holder.add_child(fill)
		fill.look_at_from_position(center + Vector3(0.7, 0.4, -0.5) * 50.0, center, Vector3.UP)
	var cam := Camera3D.new()
	cam.projection = Camera3D.PROJECTION_ORTHOGONAL
	cam.keep_aspect = Camera3D.KEEP_HEIGHT
	var nt: int = int(a[4]) if a.size() > 4 else 1
	var only: String = a[5] if a.size() > 5 else ""
	var full := 99.2
	var fw := full * float(W) / float(H)
	cam.size = full / nt
	cam.near = 0.5
	cam.far = 260.0
	holder.add_child(cam)
	root.add_child(vp)
	await process_frame
	var dir := Vector3(1, 0.8165, 1).normalized()
	cam.look_at_from_position(center + Vector3(0, 1.6, 0) + dir * 100.0, center + Vector3(0, 1.6, 0), Vector3.UP)
	cam.current = true
	for ty in range(nt):
		for tx in range(nt):
			if only != "" and not only.split(",").has("%d_%d" % [tx, ty]):
				continue
			cam.h_offset = -fw / 2.0 + (tx + 0.5) * fw / nt
			cam.v_offset = full / 2.0 - (ty + 0.5) * full / nt
			for i in range(3):
				await process_frame
			await RenderingServer.frame_post_draw
			vp.get_texture().get_image().save_png(out.path_join("%s_%d_%d.png" % [mode, tx, ty]))
			_t("tuile %d %d" % [tx, ty])
	quit()

var cur_oid: int = 0

func _pass_mat(m: Material, cls: float) -> ShaderMaterial:
	var sm := ShaderMaterial.new()
	sm.shader = pass_shader
	sm.set_shader_parameter("cls", cls)
	sm.set_shader_parameter("idc", Color(float(56 + (cur_oid % 13) * 15) / 255.0, float(56 + ((cur_oid / 13) % 13) * 15) / 255.0, float(56 + (cur_oid / 169) * 15) / 255.0) if cur_oid > 0 else Color(0, 0, 0))
	if m is ShaderMaterial and (m as ShaderMaterial).get_shader_parameter("tex") != null:
		sm.set_shader_parameter("tex", (m as ShaderMaterial).get_shader_parameter("tex"))
		sm.set_shader_parameter("use_tex", 1.0)
		sm.set_shader_parameter("cut", 0.5)
	if m is BaseMaterial3D:
		var b: BaseMaterial3D = m
		if b.albedo_texture != null and b.transparency != BaseMaterial3D.TRANSPARENCY_DISABLED:
			sm.set_shader_parameter("tex", b.albedo_texture)
			sm.set_shader_parameter("use_tex", 1.0)
			sm.set_shader_parameter("cut", b.alpha_scissor_threshold if b.transparency == BaseMaterial3D.TRANSPARENCY_ALPHA_SCISSOR else 0.5)
	return sm

func _override(n: Node, cls: float) -> void:
	if n.has_meta("cls"):
		cls = float(n.get_meta("cls"))
	var saved_oid: int = cur_oid
	if n.has_meta("oid"):
		cur_oid = int(n.get_meta("oid"))
	if n is MeshInstance3D and (n as MeshInstance3D).mesh != null:
		var mi: MeshInstance3D = n
		for i in range(mi.mesh.get_surface_count()):
			var m: Material = mi.get_surface_override_material(i)
			if m == null:
				m = mi.mesh.surface_get_material(i)
			mi.set_surface_override_material(i, _pass_mat(m, cls))
	elif n is MultiMeshInstance3D:
		var mmi: MultiMeshInstance3D = n
		var msh: Mesh = mmi.multimesh.mesh.duplicate()
		for i in range(msh.get_surface_count()):
			msh.surface_set_material(i, _pass_mat(msh.surface_get_material(i), cls))
		mmi.multimesh.mesh = msh
	for c in n.get_children():
		_override(c, cls)
	cur_oid = saved_oid

func _init() -> void:
	_boot.call_deferred()
