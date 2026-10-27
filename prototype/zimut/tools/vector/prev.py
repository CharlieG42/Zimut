import sys, os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import importlib, common
from PIL import Image
names = sys.argv[2:]
ims = []
for n in names:
    mod, fn = n.split(".")
    m = importlib.import_module(mod)
    s = getattr(m, fn)()
    import cairosvg, io
    png = cairosvg.svg2png(bytestring=s.encode(), scale=1.5)
    ims.append(Image.open(io.BytesIO(png)).convert("RGBA"))
H = max(i.height for i in ims)
W = sum(i.width for i in ims)
sh = Image.new("RGBA", (W, H), (214, 216, 222, 255)); x = 0
for i in ims: sh.alpha_composite(i, (x, H - i.height)); x += i.width
sh.convert("RGB").save(sys.argv[1])
