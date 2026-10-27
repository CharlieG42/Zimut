"""Rig minimal : un sprite = parties empilées ; une pose = transformations (rot, dx, dy[, échelle]) par clé.
Les parties qui ont un parent (par défaut 'body') suivent sa transformation (penché, rebond)."""
from common import *
import math

class Rig:
    def __init__(self, pose=None, body_pivot=(170, 330), pivots=None):
        self.pose = pose or {}
        self.body_pivot = body_pivot
        self.pivots = pivots or {}
        self.out = []; self.cur = None

    def part(self, key, pivot=None, parent="body"):
        self.cur = []
        self.out.append((key, pivot or self.pivots.get(key), parent, self.cur))
        return self

    def add(self, *items):
        self.cur.extend(items)

    def raw(self, s):
        self.out.append((None, None, None, [s]))

    def _t(self, key, pivot):
        t = self.pose.get(key)
        if not t:
            return None
        rot, dx, dy = (list(t) + [0, 0, 0])[:3]
        sc = t[3] if len(t) > 3 else None
        px, py = pivot if key != "body" else self.body_pivot
        s = f"translate({dx} {dy}) rotate({rot} {px} {py})"
        if sc:
            s += f" translate({px} {py}) scale({sc}) translate({-px} {-py})"
        return s

    def render(self):
        res = []
        for key, pivot, parent, items in self.out:
            body = "".join(items)
            if key is None:
                res.append(body); continue
            t = self._t(key, pivot or self.body_pivot)
            if t:
                body = f'<g transform="{t}">{body}</g>'
            if parent and key != parent:
                tp = self._t(parent, self.body_pivot)
                if tp:
                    body = f'<g transform="{tp}">{body}</g>'
            res.append(body)
        return "".join(res)

# ------------------------------------------------------------------ effets
def aura(d, cx, cy, r, c_in="#d9fbff", c_out="#2ab4ff", op=.55):
    g = rgrad(d, c_in, c_out, .5, .5, .5)
    gid = g[5:-1]
    d.append(f'<style></style>') if False else None
    return (f'<g opacity="{op}"><circle cx="{cx}" cy="{cy}" r="{r}" fill="{g}" opacity=".55"/>'
            f'<circle cx="{cx}" cy="{cy}" r="{r*.8}" fill="none" stroke="#bff3ff" stroke-width="3" opacity=".9"/>'
            f'<circle cx="{cx}" cy="{cy}" r="{r*.62}" fill="none" stroke="#7be0ff" stroke-width="1.8" stroke-dasharray="6 7" opacity=".9"/></g>')

def star(cx, cy, r, n=8, c1="#ffffff", c2="#6fd8ff", inner=.42, rot=0):
    pts = []
    for i in range(n * 2):
        a = math.radians(rot + i * 180 / n)
        rr = r if i % 2 == 0 else r * inner
        pts.append(f"{cx + rr*math.cos(a):.1f},{cy + rr*math.sin(a):.1f}")
    return (f'<polygon points="{" ".join(pts)}" fill="{c2}" stroke="#1f5f9a" stroke-width="2" stroke-linejoin="round"/>'
            f'<polygon points="{" ".join(pts)}" fill="{c1}" opacity=".0"/>'
            f'<circle cx="{cx}" cy="{cy}" r="{r*.32}" fill="{c1}" opacity=".95"/>')

def burst(d, cx, cy, s=1.0, shards=7, spread=150):
    """Éclat de glace : étoile + éclats de cristaux projetés."""
    out = [star(cx, cy, 34 * s, 9, "#ffffff", "#9fe8ff", .45, 10)]
    for i in range(shards):
        a = math.radians(-spread / 2 - 90 + i * spread / max(1, shards - 1))
        rr = (46 + 14 * (i % 2)) * s
        x, y = cx + rr * math.cos(a), cy + rr * math.sin(a)
        out.append(crystal(d, x, y, (20 + 8 * (i % 3)) * s, None, rot=math.degrees(a) + 90))
    return "".join(out)

def snow(pts, c="#ffffff"):
    return "".join(f'<circle cx="{x}" cy="{y}" r="{r}" fill="{c}" stroke="#7fb4d8" stroke-width="1"/>' for x, y, r in pts)

def swoosh(x0, y0, x1, y1, bend=40, w=16, c="#ffffff", op=.8):
    """Trait de vitesse en croissant."""
    mx, my = (x0 + x1) / 2, (y0 + y1) / 2
    nx, ny = -(y1 - y0), (x1 - x0)
    n = math.hypot(nx, ny) or 1
    cx, cy = mx + nx / n * bend, my + ny / n * bend
    cx2, cy2 = mx + nx / n * (bend - w), my + ny / n * (bend - w)
    return (f'<path d="M{x0} {y0} Q{cx} {cy} {x1} {y1} Q{cx2} {cy2} {x0} {y0} Z" fill="{c}" fill-opacity="{op}" stroke="#7fd0ff" stroke-width="1.6"/>')

def rune_ring(cx, cy, rx, ry, c="#7be9ff"):
    out = [f'<ellipse cx="{cx}" cy="{cy}" rx="{rx}" ry="{ry}" fill="{c}" fill-opacity=".12" stroke="{c}" stroke-width="3" opacity=".9"/>',
           f'<ellipse cx="{cx}" cy="{cy}" rx="{rx*.74}" ry="{ry*.74}" fill="none" stroke="{c}" stroke-width="1.6" stroke-dasharray="5 6" opacity=".9"/>']
    for k in range(8):
        a = math.radians(k * 45 + 10)
        x, y = cx + rx * .87 * math.cos(a), cy + ry * .87 * math.sin(a)
        out.append(f'<path d="M{x-4:.1f} {y-3:.1f} L{x:.1f} {y+4:.1f} L{x+4:.1f} {y-3:.1f}" fill="none" stroke="#e8fcff" stroke-width="1.8"/>')
    return "".join(out)

IDLE2 = {"body": (0, 0, -3), "head": (3, 0, 0)}
