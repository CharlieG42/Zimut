import sys, os
sys.path.insert(0, os.path.dirname(__file__))
from common import save
from tank import tank
from ennemis import guerrier, griffon, garde, rochebrute
from boss import vorkann
OUT = os.path.join(os.path.dirname(__file__), "../../assets/sprites/vector/cimes")
os.makedirs(OUT, exist_ok=True)
for n, f in (("tank", tank), ("guerrier_des_monts", guerrier), ("griffon_des_cimes", griffon), ("garde_des_pics", garde), ("rochebrute", rochebrute), ("boss_cimes", vorkann)):
    save(n, f(), OUT); print("ok", n)
from PIL import Image
names = ["tank", "guerrier_des_monts", "griffon_des_cimes", "garde_des_pics", "rochebrute", "boss_cimes"]
ims = [Image.open(f"{OUT}/{n}.png").convert("RGBA") for n in names]
H = 520; ims = [i.resize((int(i.width * H / i.height), H), Image.LANCZOS) for i in ims]
W = sum(i.width for i in ims) + 12 * len(ims)
sh = Image.new("RGBA", (W, H), (128, 140, 150, 255)); x = 0
for i in ims: sh.alpha_composite(i, (x, 0)); x += i.width + 12
sh.convert("RGB").save(sys.argv[1] if len(sys.argv) > 1 else "/tmp/preview.png")
