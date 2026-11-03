#!/usr/bin/env python3
"""Prépare le Stylized Nature MegaKit (Quaternius, CC0) pour le jeu : copie un sous-ensemble de modèles glTF
dans assets/nature/ et réduit les textures (512 px max, JPG pour l'opaque) pour garder l'APK léger.
Usage : python3 tools/prep_nature_kit.py "<dossier glTF du kit>" """
import json, os, shutil, sys
from PIL import Image

SRC = sys.argv[1]
DST = os.path.join(os.path.dirname(__file__), "..", "assets", "nature")
MODELS = (["CommonTree_%d" % i for i in range(1, 6)] + ["Pine_%d" % i for i in range(1, 6)]
          + ["DeadTree_%d" % i for i in range(1, 4)] + ["TwistedTree_1", "TwistedTree_2"]
          + ["Bush_Common", "Bush_Common_Flowers", "Fern_1", "Plant_1", "Plant_7", "Clover_1"]
          + ["Rock_Medium_%d" % i for i in range(1, 4)] + ["Pebble_Round_%d" % i for i in range(1, 4)] + ["Pebble_Square_1", "Pebble_Square_2"]
          + ["Mushroom_Common", "Mushroom_Laetiporus", "Flower_3_Group", "Flower_4_Group"]
          + ["Grass_Common_Short", "Grass_Common_Tall", "Grass_Wispy_Short", "Grass_Wispy_Tall"])
MAXPX = 512
os.makedirs(DST, exist_ok=True)
done = {}


def tex(name):
    """Réduit une texture ; renvoie (fichier, mime)."""
    if name in done:
        return done[name]
    im = Image.open(os.path.join(SRC, name + ".png"))
    im.thumbnail((MAXPX, MAXPX), Image.LANCZOS)
    has_alpha = im.mode in ("RGBA", "LA") and im.getextrema()[-1][0] < 250
    if has_alpha:
        out = name + ".png"
        im.convert("RGBA").save(os.path.join(DST, out), optimize=True)
        res = (out, "image/png")
    else:
        out = name + ".jpg"
        im.convert("RGB").save(os.path.join(DST, out), quality=88)
        res = (out, "image/jpeg")
    done[name] = res
    return res


# image « vide » pour les normales (non utilisées : on pose notre propre éclairage)
Image.new("RGB", (4, 4), (128, 128, 255)).save(os.path.join(DST, "_flat.png"))
for m in MODELS:
    j = json.load(open(os.path.join(SRC, m + ".gltf")))
    used = {t["index"] for mat in j["materials"] for t in [mat["pbrMetallicRoughness"].get("baseColorTexture")] if t}
    used_img = {j["textures"][i]["source"] for i in used}
    for idx, img in enumerate(j["images"]):
        if idx in used_img:
            f, mime = tex(os.path.splitext(img["uri"])[0])
            img["uri"] = f
            img["mimeType"] = mime
        else:
            img["uri"] = "_flat.png"
            img["mimeType"] = "image/png"
    json.dump(j, open(os.path.join(DST, m + ".gltf"), "w"))
    shutil.copy(os.path.join(SRC, m + ".bin"), os.path.join(DST, m + ".bin"))
print(len(MODELS), "modèles,", len(done), "textures")
