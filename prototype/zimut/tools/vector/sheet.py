"""Planche de contrôle d'un personnage : toutes ses poses côte à côte."""
import sys, io, cairosvg
from PIL import Image
def sheet(fn, views_poses, out, scale=1.0, bg=(214, 216, 222, 255)):
    ims = []
    for v, ps in views_poses:
        row = []
        for ps_ in ps:
            png = cairosvg.svg2png(bytestring=fn(v, ps_).encode(), scale=scale)
            row.append(Image.open(io.BytesIO(png)).convert("RGBA"))
        ims.append(row)
    cw = max(i.width for r in ims for i in r); ch = max(i.height for r in ims for i in r)
    cols = max(len(r) for r in ims)
    S = Image.new("RGBA", (cols * cw, len(ims) * ch), bg)
    for ri, r in enumerate(ims):
        for ci, i in enumerate(r):
            S.alpha_composite(i, (ci * cw + (cw - i.width) // 2, ri * ch + (ch - i.height)))
    S.convert("RGB").save(out)
if __name__ == "__main__":
    import importlib
    mod = importlib.import_module(sys.argv[1])
    poses = ["idle", "walk", "attack_2", "attack", "cast"]
    sheet(getattr(mod, sys.argv[1]), [("front", poses), ("back", poses)], sys.argv[2], .75)
