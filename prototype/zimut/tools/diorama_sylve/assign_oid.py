"""Attribue un identifiant d'occultation (oid) aux objets hauts : bâtiments, arbres, étals, fontaine…"""
import json, math
objs = json.load(open("objects.json"))
plan = json.load(open("plan.json"))
TAGS = {"tree", "stall", "cart", "fountain", "lantern", "banner", "prop", "hay", "grave"}
occ = []
bi = 0
oid = 0
for o in objs:
    o.pop("oid", None)
    if o["type"] == "asm":
        job, cx, cz, r, s = plan["B"][bi]; bi += 1
        oid += 1; o["oid"] = oid
        occ.append({"oid": oid, "kind": "building", "job": job, "c": [cx, cz]})
    elif o.get("tag") in TAGS and not o.get("mm"):
        oid += 1; o["oid"] = oid
        occ.append({"oid": oid, "kind": o["tag"], "c": [o["p"][0], o["p"][2]]})
json.dump(objs, open("objects.json", "w"))
json.dump(occ, open("occluders.json", "w"))
print(oid, "occultants")
