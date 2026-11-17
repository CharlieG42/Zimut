"""Héros riggé sous Blender (.blend) -> .glb léger pour le jeu (V380).
Décime le maillage (avant l'armature, poids conservés), rend au thorax l'influence des bras sur les pans de tissu éloignés
des bras (cape…), ne garde que la couleur du matériau, réduit la texture à 1024, exporte en glb (WebP).
Nécessite le module bpy (pip install bpy, Python 3.13) :
  python tools/blend_vers_glb.py <héros.blend> <sortie.glb> <triangles> <seuil_pans>
  ex. python tools/blend_vers_glb.py assassin.blend /tmp/assassin_12k.glb 12000 0.14
Ensuite : godot --headless --path . -s tools/anim_heros_blender.gd -- /tmp/assassin_12k.glb assets/heroes3d/assassin.glb assassin
"""
import bpy, sys
src, out, target, FAR = sys.argv[-4], sys.argv[-3], int(sys.argv[-2]), float(sys.argv[-1])
bpy.ops.wm.open_mainfile(filepath=src)
me_obj = [o for o in bpy.data.objects if o.type == 'MESH'][0]
tris = sum(len(p.vertices) - 2 for p in me_obj.data.polygons)
bpy.context.view_layer.objects.active = me_obj
for o in bpy.data.objects: o.select_set(o == me_obj)
m = me_obj.modifiers.new("Decim", 'DECIMATE')
m.decimate_type = 'COLLAPSE'; m.ratio = target / tris; m.use_collapse_triangulate = True
# placer la décimation AVANT l'armature
while me_obj.modifiers.find("Decim") > 0:
    bpy.ops.object.modifier_move_up(modifier="Decim")
bpy.ops.object.modifier_apply(modifier="Decim")
tris2 = sum(len(p.vertices) - 2 for p in me_obj.data.polygons)

# Pans de tissu (cape…) pondérés sur les bras par les poids automatiques : un sommet loin de tout os du bras perd
# l'influence du bras au profit du thorax (sinon la cape tourne avec les bras quand ils s'abaissent depuis la pose en T).
import mathutils
arm = me_obj.parent if me_obj.parent and me_obj.parent.type == 'ARMATURE' else [o for o in bpy.data.objects if o.type == 'ARMATURE'][0]
to_mesh = me_obj.matrix_world.inverted() @ arm.matrix_world
segs = {b.name: (to_mesh @ b.head_local, to_mesh @ b.tail_local) for b in arm.data.bones}
zs = [v.co.z for v in me_obj.data.vertices]; Hm = max(zs) - min(zs)
lim = FAR * Hm
gi = {g.name: g.index for g in me_obj.vertex_groups}
tor = next(n for n in gi if n.lower() == 'thorax')
armb = [n for n in gi if n.split('.')[0].lower() in ('bras', 'avantbras', 'main')]
def dseg(p, a, b):
    ab = b - a; t = max(0.0, min(1.0, (p - a).dot(ab) / max(ab.dot(ab), 1e-12))); return (a + ab * t - p).length
moved = 0
for v in me_obj.data.vertices:
    dmin = min(dseg(v.co, *segs[n]) for n in armb if n in segs)
    if dmin <= lim: continue
    # l'objet tenu (bâton, dague…) suit la main : on n'y touche pas
    top = max(v.groups, key=lambda g: g.weight, default=None)
    if top is not None and me_obj.vertex_groups[top.group].name.split('.')[0].lower() == 'main': continue
    w_arm = 0.0
    for g in list(v.groups):
        nm = me_obj.vertex_groups[g.group].name
        if nm in armb and g.weight > 0:
            w_arm += g.weight; me_obj.vertex_groups[g.group].remove([v.index])
    if w_arm > 0:
        me_obj.vertex_groups[tor].add([v.index], w_arm, 'ADD'); moved += 1
print("PANS", moved, "sommets : influence des bras rendue au thorax (seuil", round(lim, 3), ")")
# matériau : ne garder que la couleur (le jeu n'utilise que l'albedo) et réduire à 1024
mat = me_obj.data.materials[0]
base_img = None
for n in mat.node_tree.nodes:
    if n.type == 'BSDF_PRINCIPLED':
        lk = n.inputs['Base Color'].links
        if lk and lk[0].from_node.type == 'TEX_IMAGE': base_img = lk[0].from_node.image
        for inp in ('Metallic', 'Roughness', 'Normal'):
            for l in list(n.inputs[inp].links): mat.node_tree.links.remove(l)
base_img.scale(1024, 1024)
print("DECIM", tris, "->", tris2, "albedo", base_img.name, tuple(base_img.size))
bpy.ops.export_scene.gltf(filepath=out, export_format='GLB', use_visible=True, export_animations=False, export_skins=True, export_image_format='WEBP', export_image_quality=90)
print("EXPORTED", out)
