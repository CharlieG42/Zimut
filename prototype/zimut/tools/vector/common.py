"""Briques communes pour les sprites vectoriels chibi (style Dofus/Waven/Wakfu)."""
import cairosvg

OUT = "#2b1b17"      # contour brun très sombre
W_OUT = 5            # contour de silhouette
W_IN = 2.6           # contour interne

_gid = [0]

def grad(defs, c_top, c_bot, x1=0, y1=0, x2=0, y2=1, mid=None):
    """Dégradé linéaire (objectBoundingBox). Retourne 'url(#id)'."""
    _gid[0] += 1
    i = f"g{_gid[0]}"
    m = f'<stop offset="0.5" stop-color="{mid}"/>' if mid else ""
    defs.append(f'<linearGradient id="{i}" x1="{x1}" y1="{y1}" x2="{x2}" y2="{y2}">'
                f'<stop offset="0" stop-color="{c_top}"/>{m}<stop offset="1" stop-color="{c_bot}"/></linearGradient>')
    return f"url(#{i})"

def rgrad(defs, c_in, c_out, cx=.4, cy=.35, r=.75):
    _gid[0] += 1
    i = f"r{_gid[0]}"
    defs.append(f'<radialGradient id="{i}" cx="{cx}" cy="{cy}" r="{r}">'
                f'<stop offset="0" stop-color="{c_in}"/><stop offset="1" stop-color="{c_out}"/></radialGradient>')
    return f"url(#{i})"

def p(d, fill, w=W_IN, stroke=OUT, extra=""):
    return f'<path d="{d}" fill="{fill}" stroke="{stroke}" stroke-width="{w}" stroke-linejoin="round" stroke-linecap="round" {extra}/>'

def e(cx, cy, rx, ry, fill, w=W_IN, stroke=OUT, rot=0):
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
        sh = f'<ellipse cx="{w/2}" cy="{h-14}" rx="{sx}" ry="{sx*.2}" fill="#000" fill-opacity=".28"/>'
    return (f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {w} {h}" width="{w}" height="{h}">'
            f'<defs>{"".join(defs)}</defs>{sh}{body}</svg>')

def save(name, s, outdir, scale=2):
    open(f"{outdir}/{name}.svg", "w").write(s)
    cairosvg.svg2png(bytestring=s.encode(), write_to=f"{outdir}/{name}.png", scale=scale)
