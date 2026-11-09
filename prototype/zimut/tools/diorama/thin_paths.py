"""V124 : éclaircit l'herbe haute le long des chemins (lisibilité des routes, moins d'objets).
thin(objs, mask, S) retire une part des touffes hautes (tag « grass », fichier *Tall*) situées à moins de `edge` unités d'un chemin."""
import numpy as np, cv2

def thin(objs, mask, S, edge=1.8, keep=0.25, seed=124):
    res = mask.shape[0]
    dist = cv2.distanceTransform((mask <= 0.25).astype(np.uint8), cv2.DIST_L2, 5) * (S / res)    # unités du monde jusqu'au chemin
    rng = np.random.default_rng(seed)
    out = []
    n = 0
    for o in objs:
        if o.get("tag") == "grass" and "Tall" in str(o.get("f", "")):
            x, _, z = o["p"]
            i = min(res - 1, max(0, int(z / S * res))); j = min(res - 1, max(0, int(x / S * res)))
            d = float(dist[i, j])
            if d < edge:
                k = keep + (1.0 - keep) * (d / edge) ** 2          # plus on s'éloigne du bord, plus on en garde
                if rng.random() > k:
                    n += 1
                    continue
        out.append(o)
    print("herbe haute retirée le long des chemins :", n)
    return out
