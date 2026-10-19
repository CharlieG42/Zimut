import sys, json
import numpy as np
from PIL import Image, ImageFilter
from scipy import ndimage as ndi

SRC = sys.argv[1]; OUT = sys.argv[2]
im = np.array(Image.open(SRC).convert('RGB')).astype(np.int16)
H, W, _ = im.shape
mx = im.max(2); mn = im.min(2)
bglike = ((mx - mn) <= 22) & (mn >= 200)

def cut_region(x0, y0, x1, y1, min_core=700):
    sub_bg = bglike[y0:y1, x0:x1]
    # fond = pixels "damier" reliés au bord de la zone
    lab, n = ndi.label(sub_bg)
    border = set(np.unique(np.concatenate([lab[0], lab[-1], lab[:, 0], lab[:, -1]]))) - {0}
    bg = np.isin(lab, list(border))
    # trous fermés montrant encore le damier (entre les jambes, sous les bras) : retirés aussi
    sub = im[y0:y1, x0:x1]
    mnv = sub.min(2)
    for k in range(1, n + 1):
        if k in border:
            continue
        cm = lab == k
        cnt = int(cm.sum())
        if cnt < 12:
            continue
        v = mnv[cm]
        white = float((v >= 248).mean()); grey = float(((v >= 222) & (v <= 236)).mean())
        if white > 0.12 and grey > 0.12:
            bg |= cm
    fg = ~bg
    flab, fn = ndi.label(fg, structure=np.ones((3, 3)))
    sizes = ndi.sum(fg, flab, range(1, fn + 1))
    objs = ndi.find_objects(flab)
    def is_text(i):
        sl = objs[i]
        h = sl[0].stop - sl[0].start; w = sl[1].stop - sl[1].start
        return h <= 18
    cores = [i + 1 for i, s in enumerate(sizes) if s >= min_core and not is_text(i)]
    # regroupe les noyaux proches (bbox à moins de 14 px)
    boxes = [[objs[c - 1][1].start, objs[c - 1][0].start, objs[c - 1][1].stop, objs[c - 1][0].stop, [c]] for c in cores]
    merged = True
    while merged:
        merged = False
        for i in range(len(boxes)):
            for j in range(i + 1, len(boxes)):
                a, b = boxes[i], boxes[j]
                if a[0] - 3 < b[2] and b[0] - 3 < a[2] and a[1] - 3 < b[3] and b[1] - 3 < a[3]:
                    boxes[i] = [min(a[0], b[0]), min(a[1], b[1]), max(a[2], b[2]), max(a[3], b[3]), a[4] + b[4]]
                    del boxes[j]; merged = True; break
            if merged: break
    res = []
    for bx in boxes:
        ids = list(bx[4])
        # petites particules entièrement dans la boîte (effets, éclats) : on les garde
        for i, s in enumerate(sizes):
            k = i + 1
            if k in ids or s < 6 or is_text(i) and s > 40: continue
            sl = objs[i]
            if sl[1].start >= bx[0] - 2 and sl[1].stop <= bx[2] + 2 and sl[0].start >= bx[1] - 2 and sl[0].stop <= bx[3] + 2:
                ids.append(k)
        m = np.isin(flab, ids)
        res.append((bx[0] + x0, bx[1] + y0, bx[2] + x0, bx[3] + y0, m[bx[1]:bx[3], bx[0]:bx[2]]))
    res.sort(key=lambda r: (r[0]))
    return res

def save(r, name, scale=2.0):
    x0, y0, x1, y1, m = r
    rgb = im[y0:y1, x0:x1].astype(np.uint8)
    a = m.astype(np.float32)
    # liseré clair (anti-crénelage mêlé au damier) : on l'adoucit
    edge = m & ~ndi.binary_erosion(m, iterations=1)
    light = (rgb.min(2) >= 190) & ((rgb.max(2).astype(int) - rgb.min(2)) <= 30)
    a[edge & light] = 0.0
    a[edge & ~light] = 0.85
    alpha = (a * 255).astype(np.uint8)
    img = Image.fromarray(np.dstack([rgb, alpha]), 'RGBA')
    pad = 4
    canvas = Image.new('RGBA', (img.width + 2 * pad, img.height + 2 * pad), (0, 0, 0, 0))
    canvas.paste(img, (pad, pad))
    if scale != 1.0:
        canvas = canvas.resize((int(canvas.width * scale), int(canvas.height * scale)), Image.LANCZOS)
    canvas.save(f"{OUT}/{name}.png")
    return canvas.size

regions = json.load(open(sys.argv[3]))
report = []
for reg in regions:
    rs = cut_region(*reg["box"], min_core=reg.get("min", 700))
    if reg.get("single") and len(rs) > 1:
        x0 = min(r[0] for r in rs); y0 = min(r[1] for r in rs); x1 = max(r[2] for r in rs); y1 = max(r[3] for r in rs)
        m = np.zeros((y1 - y0, x1 - x0), bool)
        for r in rs:
            m[r[1]-y0:r[3]-y0, r[0]-x0:r[2]-x0] |= r[4]
        rs = [(x0, y0, x1, y1, m)]
    rows = reg.get("rows", 1)
    if rows > 1:
        ymid = reg.get("ysplit")
        rs.sort(key=lambda r: (0 if (r[1] + r[3]) / 2 < ymid else 1, r[0]))
    names = reg["names"]
    report.append(f"{reg['id']}: {len(rs)} objets / {len(names)} attendus")
    for r, nm in zip(rs, names):
        sz = save(r, nm, reg.get("scale", 2.0))
        report.append(f"   {nm}: {r[2]-r[0]}x{r[3]-r[1]} -> {sz}")
print("\n".join(report))
