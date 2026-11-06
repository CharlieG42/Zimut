#!/usr/bin/env python3
"""Génère les jobs de cuisson (tools/bake_kenney.gd) des bâtiments assemblés depuis le kit Fantasy Town / Castle.
Usage : python3 tools/kenney_batiments_jobs.py > /tmp/jobs.json
Repère : +x = droite écran, +z = gauche écran ; la façade (porte) est sur la face +z ; les panneaux de mur
sont posés sur le côté +x du module et pivotent autour de Y pour s'orienter."""
import json

def P(f, x, y, z, r=0, sc=None):
    d = {"f": f, "p": [x, y, z], "r": r}
    if sc: d["sc"] = sc
    return d

def maison(name, nx, nz, floors, wood, roof_kind, door_i, windows, chimney=True):
    pre = "fantasy-town/wall-wood" if wood else "fantasy-town/wall"
    parts = []
    for fl in range(floors):
        for i in range(nx):
            kind = ""
            if fl == 0 and i == door_i: kind = "-door"
            elif windows[(i + fl) % len(windows)]: kind = windows[(i + fl) % len(windows)]
            parts.append(P(pre + kind + ".glb", i + 0.5, fl, nz - 0.5, -90))
            parts.append(P(pre + ".glb", i + 0.5, fl, 0.5, 90))
        for j in range(nz):
            parts.append(P(pre + ".glb", nx - 0.5, fl, j + 0.5, 0))
            parts.append(P(pre + ".glb", 0.5, fl, j + 0.5, 180))
    if roof_kind == "roof-point":
        parts.append(P("fantasy-town/roof-point.glb", nx / 2.0, floors, nz / 2.0, 0, [nx, 1.6, nz]))
        parts.append(dict(P("fantasy-town/windmill.glb", nx / 2.0, floors + 0.1, nz + 0.12, 90), s=0.6))
        return {"name": name, "fp": [nx, nz], "parts": parts}
    for i in range(nx):
        parts.append(P("fantasy-town/%s.glb" % roof_kind, i + 0.5, floors, nz / 2.0, 0, [1, 1, float(nz)]))
    h = 1.0 if "high" in roof_kind else 0.6
    col = [0.62, 0.38, 0.25] if wood else [0.70, 0.72, 0.84]
    for ex in (nx - 0.06, 0.06):
        parts.append({"f": "", "prism": [float(nz), h, 0.12], "col": col, "p": [ex, floors + h / 2, nz / 2.0], "r": 90})
    if chimney:
        parts.append(P("fantasy-town/chimney.glb", nx - 0.9, floors + 0.2, nz / 2.0 + 0.1))
    return {"name": name, "fp": [nx, nz], "parts": parts}

W = ["-window-shutters", "-window-small", "-window-shutters", "-window-small"]
jobs = [
    maison("maison_bois", 3, 3, 1, True, "roof-high-gable", 1, ["-window-shutters"]),
    maison("maison_pierre", 3, 3, 2, False, "roof-gable", 0, ["-window-small", "-window-shutters"]),
    maison("chaumiere", 3, 2, 1, True, "roof-gable", 1, ["-window-small"], chimney=False),
    maison("grange", 4, 3, 1, True, "roof-high-gable", 1, [""], chimney=False),
    maison("chapelle", 3, 3, 2, False, "roof-high-gable", 1, ["-window-round"]),
    dict(maison("moulin", 2, 2, 2, False, "roof-point", 0, ["-window-small"], chimney=False), fp=[3, 3], gs=1.5),
    {"name": "tour", "fp": [3, 3], "gs": 1.6, "parts": [
        P("castle/tower-square-base.glb", 0.9375, 0, 0.9375), P("castle/tower-square-mid-windows.glb", 0.9375, 1, 0.9375),
        P("castle/tower-square-top-roof-high.glb", 0.9375, 2, 0.9375), P("castle/flag.glb", 0.9375, 4, 0.9375)]},
]
print(json.dumps(jobs))
