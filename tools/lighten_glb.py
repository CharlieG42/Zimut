#!/usr/bin/env python3
"""Allège un GLB Meshy (3 M triangles, textures 8192²) en un modèle léger prêt à rigger.

Étapes : soudure des sommets (coutures UV) → décimation quadrique → dépliage UV (xatlas) → cuisson de la couleur
depuis la texture d'origine → recentrage (pieds à y = 0) → export GLB (couleur seule : le shader toon du jeu suffit).
Pas de squelette : le rig se fait dans Blender.

Dépendances : pip install numpy pillow scipy fast-simplification xatlas trimesh
Usage       : python3 tools/lighten_glb.py entree.glb sortie.glb FACES TEXTURE_PX
Exemples    : … 15000 1024   (≈ 2 Mo, version de référence)      … 8000 512   (≈ 0,7 Mo)
Piège connu : trimesh inverse l'axe V à l'export glTF ; on pré-inverse V (sinon la texture sort en patchwork).
"""
import io, json, struct, sys, time
import numpy as np
from PIL import Image
from scipy.spatial import cKDTree
from scipy import ndimage
import fast_simplification, xatlas, trimesh

Image.MAX_IMAGE_PIXELS = None
src, dst, target_faces, tex = sys.argv[1], sys.argv[2], int(sys.argv[3]), int(sys.argv[4])
t0 = time.time()
def log(*a):
    print(f"[{time.time()-t0:6.1f}s]", *a, flush=True)

# ── 1. lecture du GLB ────────────────────────────────────────────────────────────────────
d = open(src, 'rb').read()
off = 12
while off < len(d):
    cl, ct = struct.unpack('<II', d[off:off+8]); off += 8
    ch = d[off:off+cl]; off += cl
    if ct == 0x4E4F534A: j = json.loads(ch)
    else: b = ch
acc, bv = j['accessors'], j['bufferViews']
CT = {5120: '<i1', 5121: '<u1', 5122: '<i2', 5123: '<u2', 5125: '<u4', 5126: '<f4'}
NC = {'SCALAR': 1, 'VEC2': 2, 'VEC3': 3, 'VEC4': 4}
def read(i):
    a = acc[i]; v = bv[a['bufferView']]
    n = NC[a['type']]
    o = v.get('byteOffset', 0) + a.get('byteOffset', 0)
    return np.frombuffer(b, dtype=CT[a['componentType']], count=a['count']*n, offset=o).reshape(-1, n)
pr = j['meshes'][0]['primitives'][0]
P = read(pr['attributes']['POSITION']).astype(np.float64)
UV = read(pr['attributes']['TEXCOORD_0']).astype(np.float64)
F = read(pr['indices']).reshape(-1, 3).astype(np.int64)
log('original', len(P), 'sommets', len(F), 'triangles')
mat = j['materials'][pr.get('material', 0)]
bc = mat['pbrMetallicRoughness']['baseColorTexture']['index']
im = j['images'][j['textures'][bc]['source']]
v = bv[im['bufferView']]
T = Image.open(io.BytesIO(b[v.get('byteOffset', 0):v.get('byteOffset', 0)+v['byteLength']])).convert('RGB')
log('texture couleur', T.size)
T = np.asarray(T)
h, w, _ = T.shape

# couleur de chaque sommet d'origine (texture pleine résolution)
u = np.clip(np.rint(UV[:, 0] * (w - 1)), 0, w - 1).astype(np.int64)
vv = np.clip(np.rint(UV[:, 1] * (h - 1)), 0, h - 1).astype(np.int64)
Cfull = T[vv, u].astype(np.float32)
del T

# ── 2. soudure des sommets (les coutures UV dupliquent les positions) ───────────────────
key = np.round(P * 1e5).astype(np.int64)
uniq, first, inv = np.unique(key, axis=0, return_index=True, return_inverse=True)
inv = inv.reshape(-1)
Pw = P[first]
Cw = np.zeros((len(uniq), 3), np.float64); cnt = np.zeros(len(uniq))
np.add.at(Cw, inv, Cfull); np.add.at(cnt, inv, 1)
Cw = (Cw / cnt[:, None]).astype(np.float32)
Fw = inv[F]
ok = (Fw[:, 0] != Fw[:, 1]) & (Fw[:, 1] != Fw[:, 2]) & (Fw[:, 0] != Fw[:, 2])
Fw = Fw[ok]
log('soudé', len(Pw), 'sommets', len(Fw), 'triangles')

# ── 3. décimation ───────────────────────────────────────────────────────────────────────
red = 1.0 - target_faces / len(Fw)
# deux étages : plus fiable et plus rapide sur un maillage aussi dense
mid = min(0.97, red)
Pd, Fd = fast_simplification.simplify(Pw.astype(np.float32), Fw.astype(np.int32), target_reduction=mid)
log('étage 1 :', len(Fd), 'triangles')
if len(Fd) > target_faces * 1.05:
    Pd, Fd = fast_simplification.simplify(Pd, Fd, target_reduction=1.0 - target_faces / len(Fd))
Pd = Pd.astype(np.float64); Fd = Fd.astype(np.int64)
log('décimé :', len(Pd), 'sommets', len(Fd), 'triangles')
m = trimesh.Trimesh(Pd, Fd, process=False)
nrm = np.asarray(m.vertex_normals)

# ── 4. dépliage UV ───────────────────────────────────────────────────────────────────────
atlas = xatlas.Atlas()
atlas.add_mesh(Pd.astype(np.float32), Fd.astype(np.uint32))
co = xatlas.ChartOptions(); po = xatlas.PackOptions()
po.resolution = tex; po.padding = 4; po.bilinear = True; po.create_image = False
atlas.generate(co, po)
vmap, Fa, uvs = atlas[0]
log('atlas :', len(vmap), 'sommets', len(Fa), 'triangles, uv', uvs.min(0), uvs.max(0), 'atlas', atlas.width, atlas.height)
uvs = np.asarray(uvs, np.float64)
if uvs.max() > 1.5:               # xatlas peut rendre des coordonnées en texels
    uvs = uvs / np.array([atlas.width, atlas.height])
Pa = Pd[vmap]; Na = nrm[vmap]; Fa = Fa.astype(np.int64)

# ── 5. cuisson : chaque texel prend la couleur des sommets d'origine les plus proches ────
tree = cKDTree(Pw)
img = np.zeros((tex, tex, 3), np.float32); mask = np.zeros((tex, tex), bool)
pts = []; pix = []
for tri in Fa:
    uv = uvs[tri] * tex               # px
    x0, y0 = np.floor(uv.min(0)).astype(int); x1, y1 = np.ceil(uv.max(0)).astype(int)
    x0 = max(x0, 0); y0 = max(y0, 0); x1 = min(x1, tex - 1); y1 = min(y1, tex - 1)
    if x1 < x0 or y1 < y0: continue
    gx, gy = np.meshgrid(np.arange(x0, x1 + 1), np.arange(y0, y1 + 1))
    px = np.stack([gx.ravel() + 0.5, gy.ravel() + 0.5], 1)
    a, bb, c = uv
    den = (bb[1] - c[1]) * (a[0] - c[0]) + (c[0] - bb[0]) * (a[1] - c[1])
    if abs(den) < 1e-12: continue
    l1 = ((bb[1] - c[1]) * (px[:, 0] - c[0]) + (c[0] - bb[0]) * (px[:, 1] - c[1])) / den
    l2 = ((c[1] - a[1]) * (px[:, 0] - c[0]) + (a[0] - c[0]) * (px[:, 1] - c[1])) / den
    l3 = 1 - l1 - l2
    e = -0.02
    sel = (l1 >= e) & (l2 >= e) & (l3 >= e)
    if not sel.any(): continue
    L = np.stack([l1[sel], l2[sel], l3[sel]], 1)
    pts.append(L @ Pa[tri]); pix.append(px[sel].astype(int) - 0)
pts = np.concatenate(pts); pix = np.concatenate(pix)
log('texels couverts :', len(pts))
K = 6
dist, idx = tree.query(pts, k=K, workers=-1)
wgt = 1.0 / (dist + 1e-4)
col = (Cw[idx] * wgt[..., None]).sum(1) / wgt.sum(1)[:, None]
img[np.clip(pix[:, 1] - 0, 0, tex - 1) , np.clip(pix[:, 0], 0, tex - 1)] = col
mask[np.clip(pix[:, 1], 0, tex - 1), np.clip(pix[:, 0], 0, tex - 1)] = True
# marge : recopie le texel plein le plus proche (évite les liserés aux coutures)
_, (iy, ix) = ndimage.distance_transform_edt(~mask, return_indices=True)
img = img[iy, ix]
Image.fromarray(np.clip(img, 0, 255).astype(np.uint8)).save(dst.replace('.glb', '_couleur.png'))
log('couleur cuite', tex, 'x', tex)

# ── 6. recentrage (pieds à y = 0, centré en x/z) et export ─────────────────────────────
lo, hi = Pa.min(0), Pa.max(0)
shift = np.array([-(lo[0] + hi[0]) / 2, -lo[1], -(lo[2] + hi[2]) / 2])
Pa = Pa + shift
tex_img = Image.fromarray(np.clip(img, 0, 255).astype(np.uint8))
uv_gltf = uvs.copy()
uv_gltf[:, 1] = 1.0 - uv_gltf[:, 1]      # trimesh inverse V à l'export glTF (origine en haut à gauche) : on pré-inverse
material = trimesh.visual.material.PBRMaterial(baseColorTexture=tex_img, metallicFactor=0.0, roughnessFactor=1.0, name='sentinel')
mesh = trimesh.Trimesh(Pa, Fa, process=False,
                       visual=trimesh.visual.TextureVisuals(uv=uv_gltf, material=material))
mesh.vertex_normals = Na
glb = mesh.export(file_type='glb')
open(dst, 'wb').write(glb)
log('GLB écrit :', len(glb) / 1e6, 'Mo ;', len(Fa), 'triangles ;', len(Pa), 'sommets ;', 'taille', (hi - lo).round(3))
