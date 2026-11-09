"""Bâtiments assemblés depuis le kit Fantasy Town / Castle (partagé par les Nations du diorama).
jobs : {nom: {"fp": [nx, nz], "gs"?: échelle, "parts": [...]}} ; ROOF / WOOD : couleurs de toit, bâtiments en bois."""
import io, contextlib, runpy, os
KT = os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), "../../../..")) + "/atelier_3d/kenney/"
GS = 1.3   # agrandissement des bâtiments
with contextlib.redirect_stdout(io.StringIO()):
    ns = runpy.run_path(KT + "../../tools/kenney_batiments_jobs.py")
jobs = {j["name"]: j for j in ns["jobs"]}

def P(f, x, y, z, r=0, sc=None):
    d = {"f": f, "p": [x, y, z], "r": r}
    if sc: d["sc"] = sc
    return d

def bat(name, nx, nz, floors, roof_kind, door_i, chimney=True, overhang=False, gable=None):
    """floors : liste de (préfixe, [motifs de fenêtres], motif plein). Fenêtres sur les 4 faces."""
    parts = []
    for fl, (pre, win, plain) in enumerate(floors):
        base = "fantasy-town/" + pre
        def k(i):
            w = win[i % len(win)]
            return w if w else plain
        for i in range(nx):
            kind = "-door" if fl == 0 and i == door_i else k(i + fl)
            parts.append(P(base + kind + ".glb", i + 0.5, fl, nz - 0.5, -90))
            parts.append(P(base + k(i + fl + 1) + ".glb", i + 0.5, fl, 0.5, 90))
        for j in range(nz):
            parts.append(P(base + k(j + fl) + ".glb", nx - 0.5, fl, j + 0.5, 0))
            parts.append(P(base + (plain if (j + fl) % 2 else k(j)) + ".glb", 0.5, fl, j + 0.5, 180))
    nf = len(floors)
    if overhang:
        parts.append(P("fantasy-town/overhang.glb", door_i + 0.5, 0, nz + 0.5, 90))
    if roof_kind in ("roof-point", "roof-high-point"):
        parts.append(P("fantasy-town/%s.glb" % roof_kind, nx / 2.0, nf, nz / 2.0, 0, [nx, 1.0, nz]))
        return {"name": name, "fp": [nx, nz], "parts": parts}
    for i in range(nx):
        parts.append(P("fantasy-town/%s.glb" % roof_kind, i + 0.5, nf, nz / 2.0, 0, [1, 1, float(nz)]))
    h = 1.0 if "high" in roof_kind else 0.6
    wood = "wood" in floors[-1][0]
    col = gable or ([0.62, 0.38, 0.25] if wood else [0.86, 0.80, 0.68])
    for ex in (nx - 0.06, 0.06):
        parts.append({"f": "", "prism": [float(nz), h, 0.12], "col": col, "p": [ex, nf + h / 2, nz / 2.0], "r": 90})
    if chimney:
        parts.append(P("fantasy-town/chimney.glb", nx - 0.9, nf + 0.2, nz / 2.0 + 0.1))
    return {"name": name, "fp": [nx, nz], "parts": parts}

def shift(parts, dx, dz):
    out = []
    for p in parts:
        q = dict(p); q["p"] = [p["p"][0] + dx, p["p"][1], p["p"][2] + dz]; out.append(q)
    return out

ST = ("wall", ["-window-shutters", "", "-window-small"], "")
ST2 = ("wall", ["-window-glass", "-window-shutters"], "")
STR = ("wall", ["-window-round", ""], "-detail-cross")
WD = ("wall-wood", ["-window-shutters", "", "-window-small"], "")
WX = ("wall-wood", ["-window-shutters", "-detail-cross", "-window-small", "-detail-cross"], "-detail-cross")
WDG = ("wall-wood", ["-window-small", "-detail-diagonal"], "-detail-diagonal")
WH = ("wall-wood", ["-window-shutters", "-detail-horizontal"], "-detail-horizontal")
new = [
    bat("taverne", 5, 3, [ST2, WX], "roof-gable", 2, overhang=True),
    bat("colombage", 3, 3, [ST, WX], "roof-high-gable", 1),
    bat("manoir", 4, 3, [STR, STR], "roof-high-gable", 1),
    bat("forge", 3, 2, [("wall", ["-window-stone", ""], "")], "roof-gable", 0, overhang=True),
    bat("longere", 5, 2, [WH], "roof-gable", 2),
    bat("chaumiere", 3, 2, [WD], "roof-gable", 1, chimney=False),
    bat("chaumiere2", 2, 2, [WDG], "roof-gable", 0, chimney=False),
    bat("maison_bois2", 2, 3, [WD, WDG], "roof-high-gable", 0),
    bat("maison_pierre2", 4, 2, [ST2], "roof-gable", 1),
    bat("maison_haute", 2, 2, [ST, ST, WX], "roof-high-point", 0),
]
for j in new:
    jobs[j["name"]] = j
# maison en L : corps en pierre + aile en bois
a = bat("_a", 4, 2, [ST, ST], "roof-gable", 1)
b = bat("_b", 2, 3, [WX], "roof-gable", 0, chimney=False)
jobs["maison_L"] = {"name": "maison_L", "fp": [4, 5], "parts": shift(a["parts"], 0, 3) + shift(b["parts"], 2, 0)}
# tour hexagonale (kit Castle)
hx = [P("castle/tower-hexagon-base.glb", 0.5, 0, 0.5)]
y = 1.31
for _ in range(3):
    hx.append(P("castle/tower-hexagon-mid.glb", 0.5, y, 0.5)); y += 0.46
hx.append(P("castle/tower-hexagon-top.glb", 0.5, y, 0.5)); y += 0.13
hx.append(P("castle/tower-hexagon-roof.glb", 0.5, y, 0.5))
hx.append(P("castle/flag.glb", 0.5, y + 0.8, 0.5))
jobs["tour_hex"] = {"name": "tour_hex", "fp": [1, 1], "gs": 1.8 / GS, "parts": hx}

WOOD = {"maison_bois", "chaumiere", "grange", "maison_bois2", "longere", "chaumiere2", "colombage", "taverne", "maison_L"}
ROOF = {"chapelle": (0.26, 0.29, 0.36), "moulin": (0.36, 0.25, 0.20), "maison_pierre": (0.55, 0.25, 0.17),
        "maison_bois": (0.50, 0.24, 0.17), "grange": (0.42, 0.27, 0.20), "chaumiere": (0.74, 0.58, 0.30),
        "taverne": (0.30, 0.33, 0.40), "forge": (0.33, 0.30, 0.30), "maison_bois2": (0.58, 0.29, 0.18),
        "maison_pierre2": (0.47, 0.22, 0.16), "longere": (0.70, 0.55, 0.29), "chaumiere2": (0.76, 0.60, 0.32),
        "colombage": (0.40, 0.22, 0.16), "manoir": (0.24, 0.27, 0.33), "maison_haute": (0.52, 0.30, 0.20),
        "maison_L": (0.62, 0.32, 0.20), "tour_hex": (0.3, 0.33, 0.4)}

