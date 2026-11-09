"""Attribue un identifiant d'occultation (oid) aux objets hauts : bâtiments, donjons, arbres, étals, ruines…
V118 : un donjon (groupe d'objets) = un seul occultant ; les petits décors (lanternes, bannières, tombes,
meules, panneaux…) ne sont plus découpés (ils dépassent à peine le héros) -> moins de nœuds en jeu."""
import json
objs = json.load(open("objects.json"))
plan = json.load(open("plan.json"))
TAGS = {"tree", "stall", "cart", "fountain", "ruin"}
occ = []
groups = {}
bi = 0
oid = 0
for o in objs:
    o.pop("oid", None)
    if o["type"] == "asm":
        job, cx, cz, r, s = plan["B"][bi]; bi += 1
        oid += 1; o["oid"] = oid
        occ.append({"oid": oid, "kind": "building", "job": job, "c": [cx, cz]})
    elif o.get("group"):
        g = o["group"]
        if g not in groups:
            oid += 1; groups[g] = oid
            occ.append({"oid": oid, "kind": "dungeon", "c": o["gc"]})
        if o["type"] == "glb":
            o["oid"] = groups[g]
    elif o.get("tag") in TAGS and not o.get("mm"):
        oid += 1; o["oid"] = oid
        occ.append({"oid": oid, "kind": o["tag"], "c": [o["p"][0], o["p"][2]]})
json.dump(objs, open("objects.json", "w"))
json.dump(occ, open("occluders.json", "w"))
print(oid, "occultants")
