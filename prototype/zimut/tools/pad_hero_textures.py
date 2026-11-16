#!/usr/bin/env python3
"""Comble le fond noir des textures des héros 3D (atlas très morcelés) en prolongeant la couleur des îlots UV.
Sans cela, le filtrage et les mipmaps font baver le noir du fond sur les coutures : traits noirs parasites sur le
personnage. Écrit <modèle>_albedo_pad.webp, que Hero3D charge en priorité.
Usage : python3 tools/pad_hero_textures.py   (depuis prototype/zimut)"""
import glob, json, struct, io, os
import numpy as np
from PIL import Image, ImageDraw

CT = {5120: 'b', 5121: 'B', 5122: 'h', 5123: 'H', 5125: 'I', 5126: 'f'}
NC = {'SCALAR': 1, 'VEC2': 2, 'VEC3': 3, 'VEC4': 4}

def read_glb(path):
    d = open(path, 'rb').read()
    off = 12
    js = None; bn = b''
    while off < len(d):
        ln, tp = struct.unpack_from('<II', d, off)
        chunk = d[off + 8: off + 8 + ln]
        if tp == 0x4E4F534A: js = json.loads(chunk)
        elif tp == 0x004E4942: bn = chunk
        off += 8 + ln
    return js, bn

def accessor(js, bn, i):
    a = js['accessors'][i]; bv = js['bufferViews'][a['bufferView']]
    n = NC[a['type']]; t = CT[a['componentType']]
    dt = np.dtype('<' + t)
    stride = bv.get('byteStride', dt.itemsize * n)
    start = bv.get('byteOffset', 0) + a.get('byteOffset', 0)
    out = np.zeros((a['count'], n), dtype=dt)
    for k in range(n):
        out[:, k] = np.frombuffer(bn, dtype=dt, count=a['count'], offset=start + k * dt.itemsize) if stride == dt.itemsize * n and n == 1 else \
            np.ndarray((a['count'],), dtype=dt, buffer=bn, offset=start + k * dt.itemsize, strides=(stride,))
    if a.get('normalized'):
        out = out.astype(np.float32) / np.iinfo(dt).max
    return out

def pad(glb):
    js, bn = read_glb(glb)
    img = js['images'][0]; bv = js['bufferViews'][img['bufferView']]
    o = bv.get('byteOffset', 0)
    tex = Image.open(io.BytesIO(bn[o:o + bv['byteLength']])).convert('RGB')
    W, H = tex.size
    S = 4                                   # masque suréchantillonné
    mask = Image.new('L', (W * S, H * S), 0)
    dr = ImageDraw.Draw(mask)
    for m in js['meshes']:
        for p in m['primitives']:
            uv = accessor(js, bn, p['attributes']['TEXCOORD_0']).astype(np.float64)
            uv = uv - np.floor(uv)
            idx = accessor(js, bn, p['indices']).reshape(-1) if 'indices' in p else np.arange(len(uv))
            pts = uv * [W * S, H * S]
            for t in idx.reshape(-1, 3):
                dr.polygon([tuple(pts[t[0]]), tuple(pts[t[1]]), tuple(pts[t[2]])], fill=255, outline=255)
    m = np.asarray(mask.resize((W, H), Image.BOX)) >= 128     # texel couvert pour moitié au moins
    a = np.asarray(tex).astype(np.float32)
    col = a * m[..., None]; w = m.astype(np.float32)
    cov0 = m.mean()
    for _ in range(W):                      # dilatation : chaque texel vide prend la moyenne de ses voisins remplis
        if w.min() > 0: break
        cs = np.zeros_like(col); ws = np.zeros_like(w)
        for dy, dx in ((0, 1), (0, -1), (1, 0), (-1, 0), (1, 1), (1, -1), (-1, 1), (-1, -1)):
            cs += np.roll(col, (dy, dx), (0, 1)); ws += np.roll(w, (dy, dx), (0, 1))
        fill = (w == 0) & (ws > 0)
        col[fill] = cs[fill] / ws[fill][:, None]; w[fill] = 1
    out = glb[:-4] + '_albedo_pad.webp'
    Image.fromarray(np.clip(col, 0, 255).astype(np.uint8)).save(out, quality=92, method=6)
    print('%s : %dx%d, couverture UV %.0f %% -> %s' % (os.path.basename(glb), W, H, cov0 * 100, os.path.basename(out)))

if __name__ == '__main__':
    for g in sorted(glob.glob('assets/heroes3d/*.glb')):
        pad(g)
