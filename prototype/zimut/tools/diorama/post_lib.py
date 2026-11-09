import sys, numpy as np, cv2
from PIL import Image
cv2.setNumThreads(2)
L = './'

def load():
    b = np.array(Image.open(L + 'hi_beauty.png').convert('RGBA')).astype(np.float32) / 255
    d = np.array(Image.open(L + 'hi_depth.png').convert('RGBA')).astype(np.float32)
    n = np.array(Image.open(L + 'hi_normal.png').convert('RGBA')).astype(np.float32) / 255
    a = b[..., 3]
    D = (d[..., 0] + d[..., 1] / 255.0) / 255.0 * 120.0
    N = n[..., :3] * 2 - 1
    N /= np.maximum(np.linalg.norm(N, axis=2, keepdims=True), 1e-4)
    global CLS
    CLS = d[..., 2] / 255.0
    return b[..., :3], a, D, N

def blur(x, s):
    return cv2.GaussianBlur(x, (0, 0), s)

def hsv_grade(rgb, green_sat=0.78, green_val=0.92, green_hue=-6, sat=0.92):
    hsv = cv2.cvtColor(np.clip(rgb, 0, 1).astype(np.float32), cv2.COLOR_RGB2HSV)
    h, s, v = hsv[..., 0], hsv[..., 1], hsv[..., 2]
    g = np.exp(-((h - 105) / 38.0) ** 2)  # verts
    s = s * (1 - g * (1 - green_sat))
    v = v * (1 - g * (1 - green_val))
    h = (h + g * green_hue) % 360
    s = np.clip(s * sat, 0, 1)
    return cv2.cvtColor(np.stack([h, s, v], 2), cv2.COLOR_HSV2RGB)

def ao_map(D, a):
    Df = np.where(a > 0.5, D, 60.0).astype(np.float32)
    occ = np.zeros_like(D)
    for r, k, w in ((6, 2.2, 0.35), (18, 1.1, 0.35), (50, 0.5, 0.3)):
        Db = blur(Df, r)
        occ += w * np.clip((D - Db) * k, 0, 1)
    return np.clip(occ, 0, 1)

def edges(D, N, a, th_d=0.22, th_n=0.55):
    Dm = np.where(a > 0.5, D, 60.0).astype(np.float32)
    e = np.zeros_like(D)
    for dx, dy in ((2, 0), (0, 2), (2, 2), (2, -2)):
        M = np.float32([[1, 0, dx], [0, 1, dy]])
        s = cv2.warpAffine(Dm, M, (D.shape[1], D.shape[0]), borderMode=cv2.BORDER_REPLICATE)
        e = np.maximum(e, np.abs(Dm - s))
    C = CLS if CLS.shape == D.shape else cv2.resize(CLS, (D.shape[1], D.shape[0]), interpolation=cv2.INTER_NEAREST)
    bld = (C > 0.75).astype(np.float32)
    veg = ((C > 0.25) & (C <= 0.75)).astype(np.float32)
    ter = (C <= 0.25).astype(np.float32)
    ed = np.clip((e - th_d) / th_d, 0, 1) * bld + np.clip((e - 0.7) / 0.7, 0, 1) * 0.5 * veg + np.clip((e - th_d) / th_d, 0, 1) * 0.35 * ter
    ed = ed * (a > 0.5)
    # normales : crêtes franches seulement (bâtiments, rochers), pas le feuillage bruité
    ne = np.zeros_like(D)
    for dx, dy in ((2, 0), (0, 2)):
        M = np.float32([[1, 0, dx], [0, 1, dy]])
        s = cv2.warpAffine(N, M, (D.shape[1], D.shape[0]), borderMode=cv2.BORDER_REPLICATE)
        ne = np.maximum(ne, 1 - np.sum(N * s, axis=2))
    en = np.clip((ne - th_n) / th_n, 0, 1) * (a > 0.5) * bld
    return ed.astype(np.float32), en.astype(np.float32)

def silhouette(a):
    m = (a > 0.5).astype(np.float32)
    k = np.ones((3, 3), np.uint8)
    er = cv2.erode(m, k)
    return m - er

def draw_lines(img, mask, width, strength=0.85, tint=(0.10, 0.07, 0.12), dark=0.38):
    if width > 1:
        mask = cv2.dilate(mask, cv2.getStructuringElement(cv2.MORPH_ELLIPSE, (width, width)))
    mask = blur(mask, max(0.6, width * 0.35))
    mask = np.clip(mask * 1.4, 0, 1) * strength
    col = img * dark + np.array(tint, np.float32) * (1 - dark) * 0.6
    return img * (1 - mask[..., None]) + col * mask[..., None]

def bg_gradient(h, w, top, bot):
    t = np.linspace(0, 1, h, dtype=np.float32)[:, None, None]
    top = np.array(top, np.float32); bot = np.array(bot, np.float32)
    return np.repeat(top * (1 - t) + bot * t, w, axis=1)

def composite(img, a, bg, shadow=0.34, off=(0, 0.035)):
    h, w = a.shape
    sh = blur(a, w * 0.012)
    M = np.float32([[1, 0, 0], [0, 1, off[1] * h]])
    sh = cv2.warpAffine(sh, M, (w, h)) * shadow
    out = bg * (1 - sh[..., None])
    return out * (1 - a[..., None]) + img * a[..., None]

def save(img, name, size=(2560, 1440)):
    img = np.clip(img, 0, 1)
    im = cv2.resize(img, size, interpolation=cv2.INTER_AREA)
    Image.fromarray((im * 255 + 0.5).astype(np.uint8)).save(L + name)

def base_grade(B, a, D, N, ao_strength=0.62):
    img = B.copy()
    img = hsv_grade(img)
    ao = ao_map(D, a)
    img = img * (1 - ao_strength * ao[..., None] * np.array([0.9, 0.95, 1.0], np.float32))
    return img, ao

def tone(img, contrast=0.18, warm=(1.04, 1.0, 0.94), shadow_tint=(0.02, 0.025, 0.06)):
    lum = (img * np.array([0.3, 0.59, 0.11], np.float32)).sum(2, keepdims=True)
    img = img + (0.5 - lum) * -contrast * (lum - 0.5) * 2 * 0  # (réservé)
    s = np.clip(1 - lum * 1.6, 0, 1)
    img = img + s * np.array(shadow_tint, np.float32)
    img = img * np.array(warm, np.float32)
    img = img + contrast * (img - 0.5) * (1 - np.abs(img - 0.5) * 1.6)
    return img

def style_a(B, a, D, N):
    img, ao = base_grade(B, a, D, N)
    img = tone(img)
    ed, en = edges(D, N, a)
    sil = silhouette(a)
    img = draw_lines(img, np.maximum(ed, en * 0.55), 3, 0.75)
    img = draw_lines(img, sil, 4, 0.9)
    bg = bg_gradient(*a.shape, (0.93, 0.92, 0.90), (0.84, 0.83, 0.82))
    return composite(img, a, bg), img

def tilt_shift(img, focus=0.52, band=0.16, maxr=22):
    h, w, _ = img.shape
    ys = (np.arange(h, dtype=np.float32) / h)[:, None]
    m = np.clip((np.abs(ys - focus) - band) / 0.30, 0, 1) ** 1.4
    m = np.repeat(m, w, axis=1)
    levels = [img, blur(img, maxr * 0.33), blur(img, maxr * 0.66), blur(img, maxr)]
    f = m * 3
    i0 = np.clip(np.floor(f).astype(np.int32), 0, 2)
    t = (f - i0)[..., None]
    out = np.zeros_like(img)
    for k in range(3):
        sel = (i0 == k)[..., None]
        out += sel * (levels[k] * (1 - t) + levels[k + 1] * t)
    return out

def style_b(B, a, D, N):
    img, ao = base_grade(B, a, D, N, 0.66)
    img = hsv_grade(img, 1.0, 1.0, 0, 1.12)
    ed, en = edges(D, N, a)
    sil = silhouette(a)
    img = draw_lines(img, np.maximum(ed, en * 0.5), 2, 0.38, dark=0.55)
    img = tone(img, 0.22, (1.08, 1.0, 0.88), (0.03, 0.035, 0.09))
    # brume de distance (haut de l'image = loin)
    h, w = a.shape
    ys = (np.arange(h, dtype=np.float32) / h)[:, None, None]
    depth_n = np.clip((D - 38) / 55.0, 0, 1)[..., None]
    fog = np.clip(0.42 * (1 - ys) ** 2.4 + 0.18 * depth_n, 0, 0.4) * 0.7
    fogc = np.array([0.80, 0.84, 0.95], np.float32)
    img = img * (1 - fog) + fogc * fog
    # bloom
    lum = (img * np.array([0.3, 0.59, 0.11], np.float32)).sum(2)
    bright = np.clip(img - 0.8, 0, 1) * np.clip((lum[..., None] - 0.72) * 3, 0, 1)
    bloom = blur(bright, 18) * 0.7 + blur(bright, 70) * 0.9 + blur(bright, 180) * 0.6
    img = img + bloom * np.array([1.0, 0.9, 0.72], np.float32)
    img = tilt_shift(img)
    # le fond (tilt shift flou sur alpha aussi)
    a2 = np.clip(blur(a, 1.2), 0, 1)
    bgc = bg_gradient(h, w, (0.13, 0.15, 0.27), (0.38, 0.27, 0.30))
    yy, xx = np.mgrid[0:h, 0:w].astype(np.float32)
    r = np.sqrt(((xx - w / 2) / (w * 0.62)) ** 2 + ((yy - h * 0.5) / (h * 0.62)) ** 2)
    vig = 1 - np.clip(r - 0.45, 0, 1) ** 1.6 * 0.75
    out = composite(img, a2, bgc, 0.55)
    out = out * vig[..., None]
    rng = np.random.default_rng(1)
    out = out + rng.normal(0, 0.008, out.shape[:2])[..., None].astype(np.float32)
    return out, img

def style_c(B, a, D, N):
    h, w = a.shape
    S = 2  # travail à demi-échelle pour le filtre pictural
    Bs = cv2.resize(B, (w // S, h // S), interpolation=cv2.INTER_AREA)
    as_ = cv2.resize(a, (w // S, h // S), interpolation=cv2.INTER_AREA)
    Ds = cv2.resize(D, (w // S, h // S), interpolation=cv2.INTER_AREA)
    Ns = cv2.resize(N, (w // S, h // S), interpolation=cv2.INTER_AREA)
    img, ao = base_grade(Bs, as_, Ds, Ns, 0.45)
    u8 = (np.clip(img, 0, 1) * 255).astype(np.uint8)
    u8 = cv2.cvtColor(u8, cv2.COLOR_RGB2BGR)
    u8 = cv2.pyrMeanShiftFiltering(u8, 10, 26)
    u8 = cv2.edgePreservingFilter(u8, flags=1, sigma_s=40, sigma_r=0.3)
    img = cv2.cvtColor(u8, cv2.COLOR_BGR2RGB).astype(np.float32) / 255
    # paliers de valeur adoucis (gouache)
    lum = (img * np.array([0.3, 0.59, 0.11], np.float32)).sum(2, keepdims=True)
    q = np.round(lum * 6) / 6
    q = lum * 0.45 + q * 0.55
    img = img * (q / np.maximum(lum, 1e-3))
    img = hsv_grade(img, 0.95, 1.0, -4, 1.12)
    img = tone(img, 0.12, (1.05, 1.0, 0.92), (0.05, 0.03, 0.06))
    # trait d'encre brun, irrégulier
    ed, en = edges(Ds, Ns, as_, 0.25, 0.6)
    sil = silhouette(as_)
    rng = np.random.default_rng(3)
    wob = cv2.GaussianBlur(rng.normal(0, 1, (h // S, w // S)).astype(np.float32), (0, 0), 6)
    wob /= np.abs(wob).max()
    gx, gy = np.meshgrid(np.arange(w // S, dtype=np.float32), np.arange(h // S, dtype=np.float32))
    ink = np.maximum(ed, en * 0.6)
    ink = np.maximum(ink, sil)
    ink = cv2.remap(ink, gx + wob * 2.5, gy + np.roll(wob, 37, 1) * 2.5, cv2.INTER_LINEAR)
    img = draw_lines(img, ink, 3, 0.8, tint=(0.22, 0.12, 0.08), dark=0.30)
    img = cv2.resize(img, (w, h), interpolation=cv2.INTER_CUBIC)
    # papier
    n1 = blur(rng.normal(0, 1, (h, w)).astype(np.float32), 1.2)
    n2 = blur(rng.normal(0, 1, (h, w)).astype(np.float32), 40)
    paper = 1 + 0.018 * n1 / n1.std() + 0.012 * n2 / n2.std()
    img = img * paper[..., None]
    bg = bg_gradient(h, w, (0.96, 0.93, 0.85), (0.90, 0.85, 0.75)) * (1 + 0.012 * (n2 / n2.std())[..., None] + 0.015 * (n1 / n1.std())[..., None])
    return composite(img, a, bg, 0.25), img

if __name__ == '__main__':
    which = sys.argv[1]
    B, a, D, N = load()
    fn = {'a': style_a, 'b': style_b, 'c': style_c}[which]
    out, img = fn(B, a, D, N)
    save(out, f'final_{which}.png')
    # variante détourée (fond transparent) pour l'usage jeu
    rgba = np.dstack([np.clip(img, 0, 1), a])
    im = cv2.resize(rgba, (2560, 1440), interpolation=cv2.INTER_AREA)
    Image.fromarray((im * 255 + 0.5).astype(np.uint8)).save(L + f'final_{which}_alpha.png')
    print('ok', which)
