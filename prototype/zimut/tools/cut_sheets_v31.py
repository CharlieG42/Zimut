import sys, os, glob, json
import numpy as np
from PIL import Image, ImageDraw
from scipy import ndimage as ndi

def mask_fg(im):
    mx = im.max(2); mn = im.min(2)
    bgl = ((mx - mn) <= 26) & (mn >= 196)
    lab, n = ndi.label(bgl)
    border = set(np.unique(np.concatenate([lab[0], lab[-1], lab[:, 0], lab[:, -1]]))) - {0}
    bg = np.isin(lab, list(border))
    # trous fermés à damier
    sizes = ndi.sum(np.ones_like(lab), lab, range(n + 1))
    objs = ndi.find_objects(lab)
    for k in range(1, n + 1):
        if k in border or sizes[k] < 20:
            continue
        sl = objs[k - 1]
        cm = lab[sl] == k
        v = mn[sl][cm]
        white = (v >= 246).mean(); grey = ((v >= 222) & (v <= 244)).mean()
        if white > 0.10 and grey > 0.10:
            bg[sl] |= cm
    return ~bg

def objects(fg, min_area=2500, gap=5):
    lab, n = ndi.label(fg, structure=np.ones((3, 3)))
    sizes = ndi.sum(fg, lab, range(1, n + 1))
    objs = ndi.find_objects(lab)
    boxes = []
    for i, s in enumerate(sizes):
        if s < 40:
            continue
        sl = objs[i]
        boxes.append([sl[1].start, sl[0].start, sl[1].stop, sl[0].stop, [i + 1], s])
    merged = True
    while merged:
        merged = False
        boxes.sort(key=lambda b: -b[5])
        for i in range(len(boxes)):
            for j in range(i + 1, len(boxes)):
                a, b = boxes[i], boxes[j]
                if a[0] - gap < b[2] and b[0] - gap < a[2] and a[1] - gap < b[3] and b[1] - gap < a[3]:
                    boxes[i] = [min(a[0], b[0]), min(a[1], b[1]), max(a[2], b[2]), max(a[3], b[3]), a[4] + b[4], a[5] + b[5]]
                    del boxes[j]; merged = True; break
            if merged: break
    boxes = [b for b in boxes if b[5] >= min_area]
    # ordre de lecture : rangées puis x
    boxes.sort(key=lambda b: (b[1] + b[3]) / 2)
    rows = []
    for b in boxes:
        cy = (b[1] + b[3]) / 2
        if rows and abs(cy - rows[-1][0]) < 120:
            rows[-1][1].append(b)
        else:
            rows.append([cy, [b]])
    out = []
    for _, r in rows:
        out += sorted(r, key=lambda b: b[0])
    return lab, out

def save_obj(im, lab, b, path):
    x0, y0, x1, y1, ids, _ = b
    m = np.isin(lab[y0:y1, x0:x1], ids)
    rgb = im[y0:y1, x0:x1].astype(np.uint8)
    a = m.astype(np.float32)
    edge = m & ~ndi.binary_erosion(m, iterations=1)
    light = (rgb.min(2) >= 185) & ((rgb.max(2).astype(int) - rgb.min(2)) <= 34)
    a[edge & light] = 0.0
    a[edge & ~light] = 0.8
    img = Image.fromarray(np.dstack([rgb, (a * 255).astype(np.uint8)]), 'RGBA')
    img.save(path)

if __name__ == "__main__":
    src, out = sys.argv[1], sys.argv[2]
    os.makedirs(out, exist_ok=True)
    report = {}
    for f in sorted(glob.glob(src + "/*.jpg")):
        name = os.path.basename(f)[:-4]
        im = np.array(Image.open(f).convert('RGB')).astype(np.int16)
        fg = mask_fg(im)
        lab, bs = objects(fg)
        report[name] = []
        for i, b in enumerate(bs):
            save_obj(im, lab, b, f"{out}/{name}_{i:02d}.png")
            report[name].append([int(v) for v in b[:4]])
    json.dump(report, open(out + "/boxes.json", "w"))
    for k, v in report.items():
        print(k, len(v))
