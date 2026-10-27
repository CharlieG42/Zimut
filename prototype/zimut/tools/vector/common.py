"""Briques communes pour les sprites vectoriels chibi (style Dofus/Waven/Wakfu)."""
import cairosvg

OUT = "#2b1b17"      # contour brun très sombre
W_OUT = 5            # contour de silhouette
W_IN = 2.6           # contour interne

_gid = [0]
_gcol = {}          # id de dégradé -> (couleur haute, couleur basse)
TONAL = True        # contours fins, de la teinte de la matière (rendu « illustration »)

def _hex(c):
    c = c.lstrip("#")
    if len(c) == 3: c = "".join(ch * 2 for ch in c)
    return [int(c[i:i + 2], 16) for i in (0, 2, 4)]

def tonal(fill):
    """Couleur de contour dérivée de la matière : version sombre et légèrement bleutée."""
    col = None
    if fill.startswith("url(#"):
        col = _gcol.get(fill[5:-1], (None, None))[1]
    elif fill.startswith("#"):
        col = fill
    if col is None:
        return OUT
    r, g, b = _hex(col)
    lum = (0.3 * r + 0.59 * g + 0.11 * b) / 255
    k = 0.58 if lum > 0.75 else 0.40
    return "#%02x%02x%02x" % (int(r * k * 0.95), int(g * k * 0.98), min(255, int(b * k * 1.08)))

def _outline(fill, w, stroke):
    if not TONAL or stroke != OUT or w == 0:
        return w, stroke
    return max(1.1, w * 0.55), tonal(fill)

def grad(defs, c_top, c_bot, x1=0, y1=0, x2=0, y2=1, mid=None):
    """Dégradé linéaire (objectBoundingBox). Retourne 'url(#id)'."""
    _gid[0] += 1
    i = f"g{_gid[0]}"
    _gcol[i] = (c_top, c_bot)
    m = f'<stop offset="0.5" stop-color="{mid}"/>' if mid else ""
    defs.append(f'<linearGradient id="{i}" x1="{x1}" y1="{y1}" x2="{x2}" y2="{y2}">'
                f'<stop offset="0" stop-color="{c_top}"/>{m}<stop offset="1" stop-color="{c_bot}"/></linearGradient>')
    return f"url(#{i})"

def rgrad(defs, c_in, c_out, cx=.4, cy=.35, r=.75):
    _gid[0] += 1
    i = f"r{_gid[0]}"
    _gcol[i] = (c_in, c_out)
    defs.append(f'<radialGradient id="{i}" cx="{cx}" cy="{cy}" r="{r}">'
                f'<stop offset="0" stop-color="{c_in}"/><stop offset="1" stop-color="{c_out}"/></radialGradient>')
    return f"url(#{i})"

def p(d, fill, w=W_IN, stroke=OUT, extra=""):
    w, stroke = _outline(fill, w, stroke)
    return f'<path d="{d}" fill="{fill}" stroke="{stroke}" stroke-width="{w}" stroke-linejoin="round" stroke-linecap="round" {extra}/>'

def e(cx, cy, rx, ry, fill, w=W_IN, stroke=OUT, rot=0):
    w, stroke = _outline(fill, w, stroke)
    t = f' transform="rotate({rot} {cx} {cy})"' if rot else ""
    return f'<ellipse cx="{cx}" cy="{cy}" rx="{rx}" ry="{ry}" fill="{fill}" stroke="{stroke}" stroke-width="{w}"{t}/>'

def hl(d, color="#ffffff", op=.55, w=3):
    """Reflet : trait clair arrondi, sans contour."""
    return f'<path d="{d}" fill="none" stroke="{color}" stroke-opacity="{op}" stroke-width="{w}" stroke-linecap="round"/>'

def fillhl(d, color="#ffffff", op=.35):
    return f'<path d="{d}" fill="{color}" fill-opacity="{op}" stroke="none"/>'

def shade(d, color="#000", op=.22):
    return f'<path d="{d}" fill="{color}" fill-opacity="{op}" stroke="none"/>'

def eye(cx, cy, rx, ry, iris="#4a8fd0", look=(0.15, 0.05)):
    """Grand œil chibi : blanc, iris dégradé, pupille, deux reflets."""
    dx, dy = look[0] * rx, look[1] * ry
    return (e(cx, cy, rx, ry, "#fff", 2.4) +
            e(cx + dx, cy + dy, rx * .68, ry * .8, iris, 0) +
            e(cx + dx * 1.2, cy + dy * 1.2, rx * .36, ry * .5, "#10151f", 0) +
            e(cx + dx - rx * .22, cy + dy - ry * .3, rx * .2, ry * .2, "#fff", 0) +
            e(cx + dx + rx * .2, cy + dy + ry * .3, rx * .1, ry * .1, "#fff", 0))

def crystal(defs, x, y, h, w=None, rot=0, c1="#d9f6ff", c2="#3aa7e0", c3="#1c5fa8"):
    """Cristal de glace facetté."""
    w = w or h * .55
    g = grad(defs, c1, c3, 0, 0, 1, 1, mid=c2)
    pts = f"M0 {-h} L{w/2} {-h*.3} L{w*.4} {h*.15} L0 {h*.25} L{-w*.4} {h*.15} L{-w/2} {-h*.3} Z"
    facet = f"M0 {-h} L{w/2} {-h*.3} L0 {h*.25} Z"
    facet2 = f"M0 {-h} L{-w/2} {-h*.3} L{-w*.1} {-h*.1} Z"
    return (f'<g transform="translate({x} {y}) rotate({rot})">' + p(pts, g, 2.2) +
            fillhl(facet2, "#fff", .6) + shade(facet, "#0a3a80", .25) +
            hl(f"M{-w*.18} {-h*.7} L{-w*.3} {-h*.3}", "#fff", .8, 1.6) + '</g>')

def svg(w, h, defs, body, shadow=True, sx=None):
    sh = ""
    if shadow:
        sx = sx or w * .36
        defs.append('<radialGradient id="gsh"><stop offset="0" stop-color="#000" stop-opacity=".42"/>'
                    '<stop offset=".6" stop-color="#000" stop-opacity=".22"/><stop offset="1" stop-color="#000" stop-opacity="0"/></radialGradient>')
        sh = f'<ellipse cx="{w/2}" cy="{h-14}" rx="{sx*1.15}" ry="{sx*.26}" fill="url(#gsh)"/>'
    return (f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {w} {h}" width="{w}" height="{h}">'
            f'<defs>{"".join(defs)}</defs>{sh}{body}</svg>')

def save(name, s, outdir, scale=2):
    open(f"{outdir}/{name}.svg", "w").write(s)
    cairosvg.svg2png(bytestring=s.encode(), write_to=f"{outdir}/{name}.png", scale=scale)
