#!/usr/bin/env python3
"""Icônes de sorts de l'Ingénieur (V63) : même cadre que les autres icônes (64×64), fond cuivre.
Usage : python3 tools/gen_icons_ingenieur.py  (écrit assets/icons/spells/ing_*.svg)"""
import os
OUT = "assets/icons/spells"
FRAME = ('<?xml version="1.0" encoding="UTF-8"?>\n<svg xmlns="http://www.w3.org/2000/svg" width="64" height="64" viewBox="0 0 64 64"><defs>'
         '<linearGradient id="bg" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="{c1}"/><stop offset="1" stop-color="{c2}"/></linearGradient>'
         '<radialGradient id="gl" cx="0.5" cy="0.3" r="0.7"><stop offset="0" stop-color="#ffffff" stop-opacity="0.35"/><stop offset="1" stop-color="#ffffff" stop-opacity="0"/></radialGradient></defs>'
         '<rect x="2" y="2" width="60" height="60" rx="14" fill="#1a1020"/><rect x="4" y="4" width="56" height="56" rx="12" fill="url(#bg)"/>'
         '<rect x="4" y="4" width="56" height="56" rx="12" fill="url(#gl)"/>'
         '<rect x="4.8" y="4.8" width="54.4" height="54.4" rx="11.4" fill="none" stroke="#ffe890" stroke-width="1.6" opacity="0.8"/>'
         '<g transform="translate(32,32)">{body}</g></svg>\n')
O = 'stroke="#1a1020" stroke-width="2.4" stroke-linejoin="round" stroke-linecap="round"'


def gear(cx, cy, r, col, teeth=8):
    import math
    pts = []
    for i in range(teeth * 2):
        a = math.pi * i / teeth
        rr = r if i % 2 == 0 else r * 0.78
        a2 = a + math.pi / teeth
        pts.append((cx + math.cos(a) * rr, cy + math.sin(a) * rr))
        pts.append((cx + math.cos(a2 - 0.001) * rr, cy + math.sin(a2 - 0.001) * rr))
    d = "M" + " L".join("%.1f,%.1f" % p for p in pts) + " Z"
    return ('<path d="%s" fill="%s" %s/><circle cx="%.1f" cy="%.1f" r="%.1f" fill="#1a1020"/>' % (d, col, O, cx, cy, r * 0.3))


def bomb(col="#2a2a34", spark="#ffd24a", cx=-2, cy=4, r=15):
    return ('<circle cx="%d" cy="%d" r="%d" fill="%s" %s/>' % (cx, cy, r, col, O) +
            '<circle cx="%d" cy="%d" r="4" fill="#ffffff" opacity="0.35"/>' % (cx - 6, cy - 6) +
            '<rect x="%d" y="%d" width="10" height="7" rx="2" fill="#6a6a78" %s/>' % (cx + 6, cy - 18, O) +
            '<path d="M%d,%d Q%d,%d %d,%d" fill="none" stroke="#c8a060" stroke-width="2.6"/>' % (cx + 11, cy - 18, cx + 16, cy - 26, cx + 20, cy - 24) +
            '<path d="M%d,-24 l4,-4 l1,5 l5,-1 l-4,4 l3,4 l-5,-1 l-2,5 l-1,-5 l-5,1 l4,-4 z" fill="%s"/>' % (cx + 18, spark))


ICONS = {
    "ing_couplage": ("#3a7ab8", "#0e2440",
        gear(-14, 6, 11, "#e0a050") + gear(14, 6, 11, "#e0a050") +
        '<path d="M-6,-14 L2,-20 L-1,-11 L7,-16 L1,-5" fill="none" stroke="#1a1020" stroke-width="6" stroke-linecap="round" stroke-linejoin="round"/>'
        '<path d="M-6,-14 L2,-20 L-1,-11 L7,-16 L1,-5" fill="none" stroke="#bfe8ff" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>'
        '<path d="M-4,6 L0,1 L-1,8 L4,4" fill="none" stroke="#bfe8ff" stroke-width="2.4" stroke-linecap="round"/>'),
    "ing_detonateur": ("#b8562a", "#401808",
        '<rect x="-16" y="0" width="32" height="18" rx="3" fill="#7a4a24" %s/>' % O +
        '<rect x="-3" y="-20" width="6" height="22" fill="#9a9aa8" %s/>' % O +
        '<rect x="-12" y="-24" width="24" height="6" rx="2" fill="#c8c8d4" %s/>' % O +
        '<path d="M16,10 Q24,10 22,20" fill="none" stroke="#ff4a2a" stroke-width="2.6"/>'
        '<path d="M-20,-8 l5,2 M-22,0 l6,0 M18,-8 l-5,2" stroke="#ffd24a" stroke-width="2.6" stroke-linecap="round"/>'),
    "ing_bombe": ("#8a8a9a", "#24242e", bomb()),
    "ing_bombe_feu": ("#d0602a", "#401408", bomb(col="#5a1a10", spark="#ff8a2a") +
        '<path d="M-12,14 q4,-8 8,0 q4,-10 8,0" fill="none" stroke="#ffb03a" stroke-width="2.6"/>'),
    "ing_bombe_assourd": ("#d8c040", "#40380a", bomb(col="#3a3410") +
        '<path d="M-24,-2 a8,8 0 0 1 0,12 M-28,-6 a14,14 0 0 1 0,20" fill="none" stroke="#fff4a0" stroke-width="2.4" stroke-linecap="round"/>'),
    "ing_charge_frag": ("#8a5a3a", "#2a160a",
        '<rect x="-15" y="-10" width="30" height="24" rx="4" fill="#5a3a24" %s/>' % O +
        ''.join('<path d="M0,2 l%d,%d" stroke="#ffd24a" stroke-width="2.4" stroke-linecap="round"/>' % (dx, dy) for dx, dy in [(-22, -18), (22, -18), (-24, 6), (24, 6), (0, -24)]) +
        '<rect x="-6" y="-4" width="12" height="10" fill="#ff4a2a" %s/>' % O),
    "ing_mine": ("#6a8a5a", "#1a2a12",
        '<ellipse cx="0" cy="8" rx="20" ry="9" fill="#4a5a3a" %s/>' % O +
        '<ellipse cx="0" cy="3" rx="13" ry="6" fill="#6a7a5a" %s/>' % O +
        '<circle cx="0" cy="-2" r="4" fill="#ff4a2a" %s/>' % O +
        '<path d="M-6,-12 l3,4 M6,-12 l-3,4 M0,-15 l0,5" stroke="#ffd24a" stroke-width="2.4" stroke-linecap="round"/>'),
    "ing_tourelle": ("#5a7a9a", "#14202e",
        '<path d="M-16,20 L-10,4 L10,4 L16,20 Z" fill="#6a7088" %s/>' % O +
        '<circle cx="0" cy="0" r="10" fill="#8a90a8" %s/>' % O +
        '<rect x="2" y="-6" width="24" height="7" rx="2" fill="#4a5068" %s/>' % O +
        '<circle cx="0" cy="0" r="3" fill="#ff4a2a"/>'),
    "ing_tourelle_lourde": ("#4a5a7a", "#0e1424",
        '<path d="M-18,20 L-12,2 L12,2 L18,20 Z" fill="#5a6078" %s/>' % O +
        '<circle cx="0" cy="-2" r="12" fill="#7a809a" %s/>' % O +
        '<rect x="2" y="-12" width="24" height="7" rx="2" fill="#3a4058" %s/>' % O +
        '<rect x="2" y="-2" width="24" height="7" rx="2" fill="#3a4058" %s/>' % O),
    "ing_rappel": ("#7a6a9a", "#1e1428", gear(0, 4, 13, "#c8a060") +
        '<path d="M-16,-14 A20,20 0 0 1 16,-14" fill="none" stroke="#1a1020" stroke-width="6" stroke-linecap="round"/>'
        '<path d="M-16,-14 A20,20 0 0 1 16,-14" fill="none" stroke="#e8e0ff" stroke-width="3" stroke-linecap="round"/>'
        '<path d="M-20,-20 L-16,-12 L-9,-17" fill="none" stroke="#e8e0ff" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>'),
    "ing_maintenance": ("#5a9a7a", "#0e2a1e", gear(-6, 6, 12, "#c8a060") +
        '<path d="M2,-2 L18,-18" stroke="#1a1020" stroke-width="8" stroke-linecap="round"/>'
        '<path d="M2,-2 L18,-18" stroke="#c8c8d4" stroke-width="4.6" stroke-linecap="round"/>'
        '<path d="M13,-24 a7,7 0 1 0 11,11 l-5,-1 l-1,-5 z" fill="#c8c8d4" %s/>' % O),
}
MAP = {"Couplage": "ing_couplage", "Déclencheur": "ing_detonateur", "Poser Bombe": "ing_bombe",
       "Poser Bombe incendiaire": "ing_bombe_feu", "Poser Bombe assourdissante": "ing_bombe_assourd",
       "Poser Charge à fragmentation": "ing_charge_frag", "Poser Mine": "ing_mine", "Mine à fragmentation": "ing_mine",
       "Poser Tourelle": "ing_tourelle", "Poser Tourelle lourde": "ing_tourelle_lourde", "Rappel": "ing_rappel",
       "Maintenance": "ing_maintenance", "Arsenal total": "ing_detonateur"}

if __name__ == "__main__":
    for k, (c1, c2, body) in ICONS.items():
        open(os.path.join(OUT, k + ".svg"), "w").write(FRAME.format(c1=c1, c2=c2, body=body))
    p = "data/spell_icons.txt"
    lines = open(p).read().split("\n")
    seen = set()
    for i, l in enumerate(lines):
        nm = l.split(",")[0]
        if nm in MAP:
            lines[i] = "%s,%s" % (nm, MAP[nm])
            seen.add(nm)
    for nm in MAP:
        if nm not in seen:
            lines.insert(len(lines) - 1 if lines[-1] == "" else len(lines), "%s,%s" % (nm, MAP[nm]))
    open(p, "w").write("\n".join(lines))
    print(len(ICONS), "icônes")
