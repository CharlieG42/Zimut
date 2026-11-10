"""V119 : décor peint autour du diorama (île flottante).
Ciel en dégradé, montagnes lointaines dans la brume, nuages, falaise rocheuse sous l'île,
cascades (eau ou lave) qui tombent du bord, mer de nuages en bas.
Tout est calculé à l'échelle globale réduite (facteur Q2) puis remis à l'échelle de chaque tuile."""
import numpy as np, cv2


def fbm(h, w, rng, octaves=6, base=4, persist=0.55, aspect=1.0):
    """Bruit fractal lisse (somme d'aléas agrandis) dans [0, 1]."""
    out = np.zeros((h, w), np.float32)
    amp, tot = 1.0, 0.0
    for o in range(octaves):
        gh = max(2, int(base * 2 ** o))
        gw = max(2, int(base * 2 ** o * w / h * aspect))
        g = rng.random((gh, gw)).astype(np.float32)
        out += cv2.resize(g, (w, h), interpolation=cv2.INTER_CUBIC) * amp
        tot += amp
        amp *= persist
    out /= tot
    lo, hi = np.percentile(out, 1), np.percentile(out, 99)
    return np.clip((out - lo) / max(hi - lo, 1e-4), 0, 1)


def ridge(w, rng, base, amp, octaves=7):
    x = np.zeros(w, np.float32)
    a, tot = 1.0, 0.0
    for o in range(octaves):
        n = max(2, int(base * 2 ** o))
        g = rng.random(n + 1).astype(np.float32)
        x += np.interp(np.linspace(0, n, w), np.arange(n + 1), g).astype(np.float32) * a
        tot += a
        a *= 0.5
    x /= tot
    return (x - x.mean()) * amp


SYLVE = dict(
    sky_top=(0.22, 0.42, 0.78), sky_mid=(0.52, 0.72, 0.93), sky_hor=(0.93, 0.92, 0.84), hor=0.50,
    mount=[((0.48, 0.60, 0.78), 0.40, 0.10), ((0.36, 0.50, 0.66), 0.47, 0.07)],
    cloud=(1.0, 0.99, 0.96), cloud_sh=(0.66, 0.74, 0.88), sea=(0.93, 0.95, 0.98),
    rock_lit=(0.62, 0.50, 0.40), rock_dark=(0.30, 0.24, 0.24), rock_band=(0.50, 0.40, 0.34), lip=(0.30, 0.45, 0.18),
    fall=(0.82, 0.93, 1.0), fall_core=(1.0, 1.0, 1.0), fall_glow=0.0, crack=None)
BRUMES = dict(
    sky_top=(0.30, 0.42, 0.46), sky_mid=(0.55, 0.68, 0.68), sky_hor=(0.82, 0.88, 0.80), hor=0.50,
    mount=[((0.46, 0.58, 0.58), 0.40, 0.10), ((0.34, 0.46, 0.48), 0.47, 0.07)],
    cloud=(0.90, 0.95, 0.92), cloud_sh=(0.56, 0.66, 0.66), sea=(0.80, 0.88, 0.84),
    rock_lit=(0.46, 0.46, 0.38), rock_dark=(0.20, 0.22, 0.18), rock_band=(0.36, 0.36, 0.28), lip=(0.22, 0.34, 0.20),
    fall=(0.78, 0.92, 0.88), fall_core=(0.95, 1.0, 0.98), fall_glow=0.0, crack=None)
CIMES = dict(
    sky_top=(0.18, 0.36, 0.72), sky_mid=(0.50, 0.70, 0.94), sky_hor=(0.92, 0.95, 1.0), hor=0.50,
    mount=[((0.74, 0.82, 0.94), 0.36, 0.16), ((0.52, 0.62, 0.80), 0.45, 0.10)],
    cloud=(1.0, 1.0, 1.0), cloud_sh=(0.68, 0.76, 0.92), sea=(0.94, 0.96, 1.0),
    rock_lit=(0.60, 0.62, 0.70), rock_dark=(0.26, 0.28, 0.36), rock_band=(0.46, 0.48, 0.56), lip=(0.86, 0.90, 0.97),
    fall=(0.80, 0.92, 1.0), fall_core=(1.0, 1.0, 1.0), fall_glow=0.0, crack=None)
BRASIER = dict(
    sky_top=(0.10, 0.04, 0.07), sky_mid=(0.34, 0.10, 0.08), sky_hor=(0.86, 0.42, 0.18), hor=0.52,
    mount=[((0.36, 0.14, 0.12), 0.40, 0.11), ((0.22, 0.08, 0.08), 0.47, 0.08)],
    cloud=(0.46, 0.30, 0.28), cloud_sh=(0.16, 0.08, 0.09), sea=(0.34, 0.16, 0.13),
    rock_lit=(0.34, 0.22, 0.20), rock_dark=(0.12, 0.07, 0.08), rock_band=(0.24, 0.14, 0.13), lip=(0.30, 0.18, 0.12),
    fall=(1.0, 0.52, 0.12), fall_core=(1.0, 0.86, 0.45), fall_glow=0.9, crack=(1.0, 0.38, 0.08))


def build(alpha, col, brasier, seed=7, pal=None):
    """alpha, col : vue globale de l'île (H, W) / (H, W, 3) à l'échelle Q2.
    Renvoie (fond RGB, masque « devant l'île » RGBA) : le fond passe derrière l'île,
    la mer de nuages basse passe devant la falaise mais derrière l'île elle-même."""
    S = BRUMES if pal == "brumes" else (CIMES if pal == "cimes" else (BRASIER if brasier else SYLVE))
    H, W = alpha.shape
    rng = np.random.default_rng(seed)
    yy = np.linspace(0, 1, H, dtype=np.float32)[:, None]
    xx = np.linspace(0, 1, W, dtype=np.float32)[None, :]
    # ── ciel
    top, mid, hor = (np.array(S[k], np.float32) for k in ("sky_top", "sky_mid", "sky_hor"))
    t1 = np.clip(yy / S["hor"], 0, 1)[..., None]
    sky = np.where(t1 < 0.6, top + (mid - top) * (t1 / 0.6), mid + (hor - mid) * ((t1 - 0.6) / 0.4))
    sky = np.broadcast_to(sky, (H, W, 3)).copy()
    # lueur douce (soleil haut à gauche / braise du volcan à droite)
    sx, sy = (0.22, 0.10) if not brasier else (0.80, 0.30)
    glow = np.exp(-(((xx - sx) / 0.30) ** 2 + ((yy - sy) / 0.25) ** 2))[..., None]
    sky += glow * (np.array([0.20, 0.17, 0.08]) if not brasier else np.array([0.35, 0.12, 0.02]))
    # ── montagnes lointaines (deux plans, voilées par la brume)
    for i, (mc, base_y, amp) in enumerate(S["mount"]):
        line = base_y * H + ridge(W, rng, 3 + i * 2, amp * H * 1.6)
        # pics plus marqués
        line -= np.abs(ridge(W, rng, 6, amp * H * 0.9))
        m = (np.arange(H, dtype=np.float32)[:, None] > line[None, :]).astype(np.float32)
        m = cv2.GaussianBlur(m, (0, 0), 1.2)
        tex = fbm(H, W, rng, 5, 6, 0.5)[..., None]
        depth = np.clip((np.arange(H, dtype=np.float32)[:, None] - line[None, :]) / (0.12 * H), 0, 1)[..., None]
        c = np.array(mc, np.float32) * (0.92 + 0.16 * tex)
        c = c * (1 - 0.35 * depth) + hor * 0.35 * depth          # brume au pied
        # face éclairée : pente lissée (pas de stries colonne par colonne)
        sl = np.convolve(np.gradient(line), np.ones(41) / 41, mode="same")
        c = c * (1 + np.clip(-sl * 0.25, -0.15, 0.15))[None, :, None]
        # les montagnes se fondent dans la brume de l'horizon vers le bas
        hz = np.clip((np.arange(H, dtype=np.float32)[:, None] - base_y * H) / (0.16 * H), 0, 1)[..., None]
        c = c * (1 - 0.8 * hz) + hor * 0.8 * hz
        sky = sky * (1 - m[..., None]) + c * m[..., None]
    # ── nuages hauts (bancs étirés)
    cl = fbm(H, W, rng, 6, 3, 0.55, aspect=0.45)
    band = np.exp(-((yy - 0.22) / 0.10) ** 2) * 0.9 + np.exp(-((yy - 0.40) / 0.06) ** 2) * 0.7
    dens = np.clip((cl - 0.52) * 3.2, 0, 1) * band
    sh = np.clip(cv2.GaussianBlur(dens, (0, 0), H * 0.006) - cv2.GaussianBlur(np.roll(dens, -int(H * 0.01), 0), (0, 0), H * 0.006), -1, 1)
    cc = np.array(S["cloud"], np.float32) * (1 - 0.35 * np.clip(-sh * 6, 0, 1))[..., None] + np.array(S["cloud_sh"], np.float32) * 0.35 * np.clip(-sh * 6, 0, 1)[..., None]
    a = (dens * (0.55 if not brasier else 0.65))[..., None]
    sky = sky * (1 - a) + cc * a
    # ── falaise sous l'île
    isl = alpha > 0.5
    cols = np.where(isl.any(0))[0]
    x0, x1 = cols.min(), cols.max()
    ybot = np.full(W, -1, np.int32)
    ytop = np.full(W, -1, np.int32)
    has = isl.any(0)
    ybot[has] = H - 1 - np.argmax(isl[::-1, has], axis=0)
    ytop[has] = np.argmax(isl[:, has], axis=0)
    xb = int(np.argmax(np.where(has, ybot, -1)))            # coin bas
    u = np.zeros(W, np.float32)
    xs = np.arange(W)
    u[xs <= xb] = (xs[xs <= xb] - xb) / max(1, xb - x0)
    u[xs > xb] = (xs[xs > xb] - xb) / max(1, x1 - xb)
    dmax = 0.30 * H
    prof = np.clip(1 - np.abs(u) ** 1.25, 0, 1) ** 0.75
    jag = 0.65 + 0.35 * (ridge(W, rng, 10, 1.0) + 0.5) + 0.20 * np.abs(ridge(W, rng, 40, 1.0))
    depth = dmax * prof * jag
    depth[~has] = 0
    depth = np.convolve(depth, np.ones(5) / 5, mode="same")
    Y = np.arange(H, dtype=np.float32)[:, None]
    rel = (Y - ybot[None, :]) / np.maximum(depth[None, :], 1)           # 0 sous l'île -> 1 au bas
    cliff = ((rel > -0.002) & (rel < 1) & has[None, :] & ~isl).astype(np.float32)
    cliff = cv2.GaussianBlur(cliff, (0, 0), 0.8)
    strata = fbm(H, W, rng, 6, 5, 0.6, aspect=0.25)
    vert = fbm(H, W, rng, 5, 8, 0.6, aspect=4.0)
    lit = np.array(S["rock_lit"], np.float32)
    dark = np.array(S["rock_dark"], np.float32)
    bandc = np.array(S["rock_band"], np.float32)
    side = np.clip(0.5 - u * 2.5, 0, 1)[None, :, None]                      # face gauche éclairée
    rock = dark + (lit - dark) * side
    bands = np.sin((Y - ybot[None, :]) * (0.09 + 0.02 * strata) + strata * 6.0)[..., None]
    rock = rock * (0.80 + 0.35 * vert[..., None]) + (bandc - rock) * 0.35 * (bands > 0.45)
    # facettes : pseudo-relief éclairé depuis le haut gauche, fissures verticales sombres
    hgt = fbm(H, W, rng, 6, 10, 0.55, aspect=1.6)
    gy_, gx_ = np.gradient(cv2.GaussianBlur(hgt, (0, 0), 1.2))
    shade = np.clip(0.5 - (gx_ * 0.7 + gy_ * 0.7) * H * 0.05, 0, 1)
    rock = rock * (0.70 + 0.60 * shade[..., None])
    fis = np.abs(fbm(H, W, rng, 5, 12, 0.6, aspect=5.0) - 0.5)
    rock = rock * (1 - 0.55 * np.clip((0.04 - fis) / 0.04, 0, 1))[..., None]
    relc = np.clip(rel, 0, 1)[..., None]
    rock *= (1 - 0.55 * np.exp(-relc * 14))                                 # ombre sous la dalle
    rock = rock * (1 - 0.35 * relc) + np.array(S["sea"], np.float32) * 0.25 * relc
    # liseré de végétation / scories qui déborde sous l'herbe
    lipm = np.exp(-np.clip(rel, 0, None) * 30)[..., None] * (vert[..., None] > 0.45)
    rock = rock * (1 - lipm * 0.6) + np.array(S["lip"], np.float32) * lipm * 0.6
    if S["crack"] is not None:   # veines de lave dans le basalte
        cr = np.abs(fbm(H, W, rng, 6, 6, 0.6) - 0.5)
        crm = np.clip((0.016 - cr) / 0.016, 0, 1) * (1 - relc[..., 0]) ** 1.5 * 0.85
        crg = cv2.GaussianBlur(crm, (0, 0), H * 0.004)[..., None]
        rock = rock + np.array(S["crack"], np.float32) * crg * 0.5
        rock = rock * (1 - crm[..., None]) + np.array(S["crack"], np.float32) * crm[..., None] * 1.3
    out = sky * (1 - cliff[..., None]) + rock * cliff[..., None]
    # ── cascades : où l'eau / la lave touche le bord bas de l'île
    cand = []
    for x in range(int(x0) + 8, int(x1) - 8, 2):
        y = ybot[x]
        if y < 4:
            continue
        c = col[max(0, y - int(H * 0.030)):max(1, y - int(H * 0.012)), x].max(0)
        if brasier:
            sc = c[1] + c[0] - 1.6 * c[2]          # lave jaune-blanc
            if c[0] > 0.9 and c[1] > 0.8:
                cand.append((sc, x))
        else:
            if c[2] > c[0] + 0.12 and c[2] > 0.45 and c[1] > 0.4:
                cand.append((c[2], x))
    falls = []
    for sc, x in sorted(cand, reverse=True):
        if len(falls) < 3 and all(abs(x - f) > W * 0.05 for f in falls):
            falls.append(x)
    if not brasier and not falls:     # sources jaillissant de la falaise (Sylve)
        falls = [int(x0 + (xb - x0) * 0.55), int(xb + (x1 - xb) * 0.42)]
    fall_a = np.zeros((H, W), np.float32)
    streak = fbm(H, W, rng, 5, 3, 0.6, aspect=12.0)
    for fx in falls:
        y0 = ybot[fx] - 2
        y1 = int(min(H - 1, ybot[fx] + depth[fx] * 1.25 + H * 0.04))
        wpx = max(7, int(W * 0.0075))
        for y in range(y0, y1):
            t = (y - y0) / max(1, y1 - y0)
            ww = wpx * (1 + 1.2 * t)
            xc = fx + 2.0 * np.sin(y * 0.02)
            lo, hi = int(xc - ww - 2), int(xc + ww + 3)
            xr = np.arange(lo, hi)
            v = np.clip(1 - np.abs(xr - xc) / ww, 0, 1) ** 0.6 * (1 - t ** 3)
            fall_a[y, lo:hi] = np.maximum(fall_a[y, lo:hi], v)
    fall_a = cv2.GaussianBlur(fall_a, (0, 0), 1.0)
    fc = np.array(S["fall"], np.float32) * (0.75 + 0.45 * streak[..., None]) + (np.array(S["fall_core"], np.float32) - np.array(S["fall"], np.float32)) * (streak[..., None] > 0.62)
    if S["fall_glow"] > 0:
        g = cv2.GaussianBlur(fall_a, (0, 0), W * 0.008)[..., None]
        out = out + np.array(S["fall"], np.float32) * g * S["fall_glow"] * 0.6
    out = out * (1 - fall_a[..., None] * 0.95) + fc * fall_a[..., None] * 0.95
    # brume au pied des chutes
    mist = np.zeros((H, W), np.float32)
    for fx in falls:
        yb = int(min(H - 1, ybot[fx] + depth[fx] * 1.1))
        cv2.circle(mist, (int(fx), yb), int(W * 0.02), 1.0, -1)
    mist = cv2.GaussianBlur(mist, (0, 0), W * 0.012)[..., None] * 0.7
    out = out * (1 - mist) + np.array(S["cloud"], np.float32) * mist
    # ── mer de nuages (devant la falaise, derrière l'île)
    sea = fbm(H, W, rng, 6, 4, 0.55, aspect=0.5)
    ramp = np.clip((yy - 0.66) / 0.20, 0, 1)
    # bourrelets autour du pied de l'île
    foot = np.zeros((H, W), np.float32)
    for x in range(int(x0), int(x1), 6):
        if has[x] and depth[x] > 0:
            cv2.circle(foot, (x, int(ybot[x] + depth[x] * 0.9)), int(H * 0.035 + 0.25 * depth[x] * 0.3), 1.0, -1)
    foot = cv2.GaussianBlur(foot, (0, 0), H * 0.02)
    sd = np.clip((sea * 0.9 + 0.1) * (ramp + foot * 0.85) * 1.4 - 0.35, 0, 1)
    sd = cv2.GaussianBlur(sd, (0, 0), 1.5)
    shade = np.clip(cv2.GaussianBlur(sd, (0, 0), H * 0.008) - np.roll(cv2.GaussianBlur(sd, (0, 0), H * 0.008), int(H * 0.012), 0), -1, 1)
    sc = np.array(S["sea"], np.float32) + (np.array(S["cloud_sh"], np.float32) - np.array(S["sea"], np.float32)) * np.clip(-shade * 5 + 0.25, 0, 0.8)[..., None]
    out = out * (1 - sd[..., None]) + sc * sd[..., None]
    return np.clip(out, 0, 1).astype(np.float32)


def paint(img, brasier, d=7, brumes=False):
    """Étalonnage « peint » de l'île : couleurs plus riches, aplats lissés en gardant les contours."""
    img = np.clip(img, 0, 1).astype(np.float32)
    # V120 : lissage « peint » plus léger (0.65 -> 0.40) pour garder les brins, tuiles et contours
    sm = cv2.bilateralFilter(img, d, 0.10, d * 0.8)
    img = img * 0.68 + sm * 0.32            # V124 : encore un peu moins de lissage (dessins plus fins)
    hsv = cv2.cvtColor(img, cv2.COLOR_RGB2HSV)
    h, s, v = hsv[..., 0], hsv[..., 1], hsv[..., 2]
    if brumes:
        s = np.clip(s * 0.92, 0, 1)                     # V124 : marais, verts gris
    elif not brasier:
        y = np.exp(-((h - 62) / 22.0) ** 2)              # jaune-vert acide -> vert prairie
        h = h + y * 16
        s = s * (1 + 0.10 * y)
        v = v * (1 - 0.10 * y * np.clip((v - 0.6) * 3, 0, 1))
        s = np.clip(s * 1.10, 0, 1)
    else:
        s = np.clip(s * 1.08, 0, 1)
    # courbe en S douce
    v = np.clip(v, 0, 1)
    v = v + 0.10 * (v - 0.5) * (1 - np.abs(2 * v - 1))
    if brasier:
        v = v * (0.88 + 0.12 * v)
    out = cv2.cvtColor(np.stack([h % 360, s, np.clip(v, 0, 1)], 2).astype(np.float32), cv2.COLOR_HSV2RGB)
    # V120 : netteté — masque flou à deux rayons (micro-détails + formes), sans halo sur les forts contrastes
    for rad, amt in ((0.8, 0.65), (2.5, 0.25)):
        hi = out - cv2.GaussianBlur(out, (0, 0), rad)
        out = out + amt * np.clip(hi, -0.12, 0.12)
    return np.clip(out, 0, 1)
