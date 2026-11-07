#!/usr/bin/env python3
"""Ajoute des petits aménagements (V114) à la planche iso de la Sylve :
puits près du départ, feu de camp près d'un camp, étal de marché au village.

Les empreintes des bâtiments deviennent des obstacles "building" (comme les
bâtiments existants) : jamais sur le sentier, un POI, un obstacle ou un décor
existant, et de préférence sur un replat (hauteur = celle des voisins).

Usage : python3 tools/gen_sylve_iso_buildings.py [foret_sylve_iso]
"""
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
BOARDS = ROOT / "data" / "boards"
SEED = 114


def hmap(d):
    hs = {}
    for y, row in enumerate(d["heights"]):
        for x, ch in enumerate(row):
            hs[(x, y)] = ord(ch) - 48 if ord(ch) < 97 else 10 + ord(ch) - 97
    return hs


def main() -> None:
    name = sys.argv[1] if len(sys.argv) > 1 else "foret_sylve_iso"
    path = BOARDS / (name + ".json")
    d = json.loads(path.read_text(encoding="utf-8"))
    hs = hmap(d)
    mask = d["mask"]
    cols, rows = int(d["cols"]), int(d["rows"])
    trail = {tuple(int(v) for v in k.split(",")) for k in d.get("trail", [])}
    pois = {tuple(int(v) for v in k.split(",")): v for k, v in d.get("pois", {}).items()}
    obstacles = {tuple(int(v) for v in k.split(",")): v for k, v in d.get("obstacles", {}).items()}
    decor = {tuple(int(v) for v in k.split(",")): v for k, v in d.get("decor", {}).items()}
    footprints = set()
    for b in d.get("buildings", []):
        for yy in range(int(b["y"]), int(b["y"]) + int(b["h"])):
            for xx in range(int(b["x"]), int(b["x"]) + int(b["w"])):
                footprints.add((xx, yy))

    def walkable(c):
        return 0 <= c[1] < rows and 0 <= c[0] < len(mask[c[1]]) and mask[c[1]][c[0]] == "#"

    def free(c, w, h):
        for yy in range(c[1], c[1] + h):
            for xx in range(c[0], c[0] + w):
                cc = (xx, yy)
                if not walkable(cc) or cc in trail or cc in pois or cc in obstacles or cc in footprints:
                    return False
        # replat : hauteur uniforme sur l'emprise
        return len({hs.get((xx, yy), 0) for yy in range(c[1], c[1] + h) for xx in range(c[0], c[0] + w)}) == 1

    def candidates(target, radius):
        out = []
        for dy in range(-radius, radius + 1):
            for dx in range(-radius, radius + 1):
                if max(abs(dx), abs(dy)) <= 1:
                    continue
                out.append(((target[0] + dx, target[1] + dy), abs(dx) + abs(dy)))
        out.sort(key=lambda t: t[1])
        return [c for c, _ in out]

    start = tuple(int(v) for v in d["start"])
    camps = [c for c, p in pois.items() if p.get("kind") == "camp"]
    village = (57, 38)
    existing = {b["k"] for b in d.get("buildings", [])}
    wanted = []
    for kind, anchor, radius, w, h in [("puits", start, 5, 2, 2), ("feu", camps[0] if camps else start, 8, 2, 2),
                                        ("etal", village, 10, 3, 2)]:
        if kind in existing:
            continue
        cell = None
        for cand in candidates(anchor, radius):
            if free(cand, w, h):
                cell = cand
                break
        wanted.append((kind, cell, w, h))
    added = []
    for kind, cell, w, h in wanted:
        if cell is None:
            print("!! aucun emplacement libre pour", kind)
            continue
        d.setdefault("buildings", []).append({"k": kind, "x": cell[0], "y": cell[1], "w": w, "h": h})
        for yy in range(cell[1], cell[1] + h):
            for xx in range(cell[0], cell[0] + w):
                obstacles[(xx, yy)] = "building"
                footprints.add((xx, yy))
                decor.pop((xx, yy), None)
        added.append((kind, cell))
    d["obstacles"] = {"%d,%d" % c: v for c, v in sorted(obstacles.items())}
    d["decor"] = {"%d,%d" % c: v for c, v in sorted(decor.items())}
    path.write_text(json.dumps(d, ensure_ascii=False, indent="") + "\n", encoding="utf-8")
    print("%s : bâtiments ajoutés %s (%d au total)" % (path.name, added, len(d["buildings"])))


if __name__ == "__main__":
    main()
