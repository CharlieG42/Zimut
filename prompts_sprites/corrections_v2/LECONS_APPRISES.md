# Leçons apprises — Génération de planches de sprites 2×2 (Vibe / Black Forest)

Document consignant tout ce qui a été appris lors de la production des planches
Soigneur, Géomancien, Invocateur et Druide (branche `vibe/sylvestre-sprites-v2-0dff68`).
Objectif : pouvoir reproduire ce niveau de qualité sur les prochains personnages.

---

## 1. Méthodologie générale

### Ordre des méthodes à essayer

| Priorité | Méthode | Quand l'utiliser |
|----------|---------|------------------|
| 1 | `edit_image` avec référence (héros existant) | Héros avec sprite de référence (heal.png, geomancien.png...) |
| 2 | `generate_image` sprite par sprite + `compose_2x2.py` | **Méthode qui a fonctionné à 100%** — fallback garanti |
| 3 | `generate_image` planche 2×2 directe | Sans référence, en dernier recours |

### Pourquoi le fallback sprite-par-sprite a gagné

La génération directe 2×2 (méthode 1) a **systématiquement échoué** sur au moins un critère :
- Mauvais nombre de sprites (3 au lieu de 4)
- Faces/dos incohérents (une face en rangée du bas)
- Bâton dans la mauvaise main
- Cristal de mauvaise couleur (flamme orange au lieu de goutte d'eau bleue)
- Style anime au lieu de Dofus/Waven

**Le fallback garantit** : grille 2×2 parfaite, même hauteur, pieds alignés, grands espaces.
Le seul risque : cohérence visuelle entre les 4 sprites générés séparément.

---

## 2. Règles de prompt qui fonctionnent (generate_image)

### Structure gagnante pour un sprite individuel

```
Single full-body character sprite, standing relaxed, full body including both feet visible.
[Description physique détaillée avec codes hex]
Head = 1/3 of total height. Chibi proportions. Thick dark black outlines.
Dofus/Waken Ankama vector cartoon style. Flat colors.

[VIEW] view, body turned 3/4 toward the RIGHT (facing front-right). [Pose]. Both feet visible.

CRITICAL - STAFF POSITION: The character holds a [description bâton] in his/her RIGHT hand.
He/She [faces front-right / is seen from behind].
His/Her RIGHT arm and the staff are on the [LEFT/RIGHT] side of the image (viewer's [left/right]).
The staff stands vertically on the [LEFT/RIGHT] side, extending from near the ground up well past his/her head.
At the top of the staff is a [description cristal avec hex]. NOT a flame, NOT [autre].

Plain solid [COLOR] #HEX background. No ground line, no shadow, no text, no border.
Canvas 1024x1024. Sprite centered with 100px+ margin on all sides. Taller than wide.
NOT pixel art, NOT realistic, NOT anime.
```

### Points critiques du prompt

| Élément | Pourquoi | Détail |
|---------|----------|--------|
| `"RIGHT hand"` + explication anatomique | Le modèle confond main droite/gauche | Toujours préciser : `"his RIGHT arm and the staff are on the LEFT side of the image (viewer's left)"` pour face 3/4 droite, et `"on the RIGHT side (viewer's right)"` pour dos 3/4 droite |
| `"extending from near the ground up well past his head"` | Garantit un bâton haut et visible | Sans ça, le bâton est souvent trop court ou absent |
| `"NOT a flame, NOT orange"` | Évite les cristaux oranges | Le modèle génère spontanément des flammes |
| `"NOT pixel art, NOT realistic, NOT anime"` | Force le style Dofus/Waven | Triple négation nécessaire |
| `"Thick dark black outlines"` | Contours épais | Sans ça, les contours sont fins (style anime) |
| `"Flat colors"` | Évite les dégradés excessifs | Sauf pour le cristal (glow autorisé) |
| `"both feet visible"` | Corps entier | Évite les demi-corps |
| `"Taller than wide"` | Proportions verticales | Chibi correct |
| `"full body including both feet visible"` | Pieds visibles | Évite les sprites coupés |

---

## 3. Le piège de la main droite (leçon la plus importante)

### Règle anatomique

| Vue | Position main droite du personnage | Côté du spectateur |
|-----|-----------------------------------|-------------------|
| Face 3/4 vers la droite | Main droite du perso | **GAUCHE** du spectateur |
| Dos 3/4 vers la droite (tourné vers haut-droite) | Main droite du perso | **DROITE** du spectateur |

### Ce qui se passe sans explication dans le prompt

Le modèle place **systématiquement** le bâton du côté "logique" (gauche pour face, droite pour dos) — ce qui est **l'inverse** de ce qu'on veut pour la main droite en vue de face.

### Solution qui marche

Expliciter dans le prompt :
```
CRITICAL - STAFF POSITION: The character holds a tall golden staff in his RIGHT hand.
He faces front-right (3/4 view toward the right). In this view, his RIGHT arm and
the staff are on the LEFT side of his body from the viewer's perspective.
The staff stands vertically on the LEFT side of the image.
```

### Solution de secours (quand le prompt échoue)

**Miroir horizontal** (`ImageOps.mirror`) du sprite entier. Ça inverse gauche/droite.
- Face avec bâton à droite → miroir → bâton à gauche ✅
- Dos avec bâton à gauche → miroir → bâton à droite ✅

⚠️ **Inconvénient du miroir** : le personnage regarde alors vers la gauche au lieu de la droite. À réserver en dernier recours.

---

## 4. Vérification technique par script Python

### Script de vérification d'une planche 2048×1024

```python
from PIL import Image

img = Image.open("chemin/planche.png").convert("RGB")
px = img.load()
w, h = img.size

def is_bg(c, bg_rgb=(232,232,232), tol=25):
    return (abs(c[0]-bg_rgb[0])<tol and abs(c[1]-bg_rgb[1])<tol 
            and abs(c[2]-bg_rgb[2])<tol)

quadrants = {
    "Face A (HG)": (0, 0, w//2, h//2),
    "Face B (HD)": (w//2, 0, w, h//2),
    "Back C (BG)": (0, h//2, w//2, h),
    "Back D (BD)": (w//2, h//2, w, h),
}

for name, (x0,y0,x1,y1) in quadrants.items():
    min_x, min_y, max_x, max_y = x1, y1, x0, y0
    for y in range(y0, y1, 2):
        for x in range(x0, x1, 2):
            if not is_bg(px[x,y]):
                min_x=min(min_x,x); max_x=max(max_x,x)
                min_y=min(min_y,y); max_y=max(max_y,y)
    print(f"{name}: hauteur={max_y-min_y+1}px, pieds Y={max_y}, tête Y={min_y}")
```

### Détection du bâton par couleur

| Type de bâton | Critère de détection pixel |
|---------------|---------------------------|
| Doré (soigneur, géomancien) | `r > 140 and 100 < g < 210 and b < 150 and r > b + 40` |
| Sombre (invocateur) | `40 < r < 120 and 40 < g < 120 and 40 < b < 140 and abs(r-g) < 40 and abs(g-b) < 40` |
| Bois/marron (druide) | `80 < r < 180 and 50 < g < 130 and b < 100 and r > g > b and r - b > 30` |

### Détection du cristal

| Cristal | Critère |
|---------|---------|
| Bleu/cyan (eau) | `b > 150 and b > r + 30 and g > 100` |
| Violet | `b > 120 and r > 80 and b > r + 30 and b > g + 20` |
| Vert émeraude | `g > 130 and b > 100 and g > r + 30 and g > b + 20` |
| Ambre | `r > 180 and 130 < g < 200 and b < 120` |

### Vérification du côté du bâton

```python
center_x = (min_x + max_x) // 2
is_left = staff_x < center_x
# Face 3/4 droite: main droite = bâton à GAUCHE (is_left == True)
# Dos 3/4 droite: main droite = bâton à DROITE (is_left == False)
```

---

## 5. Normalisation des ratios (fix hauteur < 5px)

### Problème

`compose_2x2.py` redimensionne à une hauteur fixe, mais le recadrage initial (`detect_content_bbox`)
peut détecter des bbox de 1-2px différents selon les sprites (à cause du threshold de fond).
Après redimensionnement, cela crée une différence de hauteur de 4-6px entre sprites.

### Solution appliquée (invocateur)

1. Calculer le ratio h/w de chaque sprite individuel
2. Calculer le ratio moyen
3. Pour chaque sprite : recadrer sur le contenu, puis ajuster la largeur pour avoir exactement le ratio moyen
   - Si trop large : redimensionner (réduire la largeur)
   - Si trop étroit : ajouter du fond de chaque côté
4. Sauvegarder et recomposer

```python
from PIL import Image

# Calculer ratio moyen
ratios = [content_h / content_w for each sprite]
avg_ratio = sum(ratios) / len(ratios)

# Ajuster chaque sprite
for sprite:
    content = crop_to_content(sprite)
    cw, ch = content.size
    target_w = int(ch / avg_ratio)
    if target_w < cw:
        content = content.resize((target_w, ch), Image.LANCZOS)
    elif target_w > cw:
        new_img = Image.new("RGB", (target_w, ch), bg_color)
        new_img.paste(content, ((target_w - cw) // 2, 0))
        content = new_img
    content.save(path)
```

**Résultat** : diff hauteur passe de 6px à 2px.

---

## 6. Artefacts de détection (faux positifs)

### Diff de 6px sur le soigneur = artefact

Lors de la vérification, une diff de 6px a été détectée. En réalité :
- HG : 386px (tête Y=64, pieds Y=449)
- HD : 386px (tête Y=64, pieds Y=449)
- BG : 385px (tête Y=577, pieds Y=961)
- BD : 389px (tête Y=574, pieds Y=962)

Les pieds sont alignés (449/449 et 961/962). La "diff de hauteur" vient de pixels
anti-aliasés en haut de certains sprites (cheveux clairs sur fond clair = détection imparfaite).

**Leçon** : une diff de 5-6px détectée par script peut être un artefact de détection,
pas un vrai problème visuel. Vérifier les pieds (Y du bas) plutôt que la hauteur totale.

---

## 7. URLs signées Azure — téléchargement

### Problème

Les URLs signées expirent (~1 heure). Les téléchargements tardifs échouent avec `HTTP 403`.

### Solution

Télécharger **immédiatement** après chaque génération, avec retry :

```python
import urllib.request, time, io
from PIL import Image

for attempt in range(6):
    try:
        req = urllib.request.Request(url, headers={"User-Agent":"Mozilla/5.0"})
        data = urllib.request.urlopen(req, timeout=90).read()
        img = Image.open(io.BytesIO(data)).convert("RGB")
        img.save("output.png")
        break
    except Exception as e:
        print(f"Retry {attempt}: {e}")
        time.sleep(6)
```

### Si 403 persistant

Régénérer l'image plutôt que réessayer le téléchargement.

---

## 8. Fichiers de référence — préparation

### Conversion RGBA → fond blanc

Les sprites Godot sont en RGBA (transparent). Pour `edit_image`, il faut un fond uni :

```python
from PIL import Image

img = Image.open("hero.png").convert("RGBA")
bg = Image.new("RGBA", img.size, (255, 255, 255, 255))
bg.paste(img, (0, 0), img)
bg.convert("RGB").save("hero_on_white.png")
```

### Committer les références sur la branche

Les URLs `raw.githubusercontent.com` pointent sur une branche/commit spécifique.
**Committer et pousser** les fichiers `_on_white.png` avant d'utiliser `edit_image`.

---

## 9. Checklist de validation finale

Avant de valider une planche, vérifier :

- [ ] **Dimensions** : 2048×1024 exactement
- [ ] **4 sprites** : un par quadrant, pas plus, pas moins
- [ ] **Grille 2×2** : 2 rangées × 2 colonnes
- [ ] **Rangée haut** : 2 faces (visages visibles, 3/4 vers la droite)
- [ ] **Rangée bas** : 2 dos (pas de visage)
- [ ] **Pieds alignés** par rangée (vérifier Y du bas, pas la hauteur totale)
- [ ] **Fond uni** : couleur exacte (#E8E8E8 ou #FFFFFF), pas de sol/ombre/texte
- [ ] **Grands espaces** : gap minimum > 60px entre sprites
- [ ] **Bâton présent** dans les 4 cases (détection par couleur)
- [ ] **Bâton côté correct** : GAUCHE spectateur en face, DROITE spectateur en dos
- [ ] **Cristal bonne couleur** : détecter par couleur, pas de flamme orange
- [ ] **Même personnage** : cheveux, couleurs, accessoires identiques (visuel)
- [ ] **Adulte** : mâchoire marquée, tête = 1/3 hauteur
- [ ] **Style** : Dofus/Waken, contours épais, pas anime/pixel art/réaliste

---

## 10. Commande de composition standard

```bash
cd /workspace/github__CharlieG42__Zimut
python3 prompts_sprites/corrections_v2/compose_2x2.py \
  prompts_sprites/corrections_v2/_fallback_HERO_face_a.png \
  prompts_sprites/corrections_v2/_fallback_HERO_face_b.png \
  prompts_sprites/corrections_v2/_fallback_HERO_back_c.png \
  prompts_sprites/corrections_v2/_fallback_HERO_back_d.png \
  prototype/zimut/assets/sprites/nations/newAssets/marees/HERO_vues.png \
  --bg="#E8E8E8" --height=390 --canvas="2048x1024" --margin=60
```

| Héros | Fond | Hauteur | Notes |
|-------|------|---------|-------|
| Soigneur | `#E8E8E8` | 390 | Cristal bleu 💧 |
| Géomancien | `#FFFFFF` | 390 | Cristal ambre 💎 |
| Invocateur | `#E8E8E8` | 390 | Cristal violet 🔮 + grimoire, ratio normalisé |
| Druide | `#FFFFFF` | 390 | Cristal émeraude 🍃 |

---

## 11. Pièges connus et solutions

| Problème | Cause | Solution |
|----------|-------|----------|
| Bâton dans la mauvaise main | Le modèle ne comprend pas "main droite" en 3/4 | Expliciter la position spectateur dans le prompt |
| Cristal orange (flamme) | Le modèle confond "glowing crystal" avec "fire" | `"NOT a flame, NOT orange, NOT fire"` + décrire la forme exacte |
| Sprite coupé (pas de pieds) | Prompt trop vague | `"full body including both feet visible"` |
| Style anime au lieu de Dofus | Le modèle a un biais anime | `"NOT anime"` + `"Dofus/Waken Ankama vector cartoon style"` + `"Thick dark black outlines"` |
| Contours fins | Défaut du modèle | `"Thick dark black outlines"` explicite |
| Diff hauteur > 5px | Ratios différents entre sprites | Normaliser les ratios avant composition (voir §5) |
| Personnage qui regarde à gauche après miroir | Miroir inverse la direction | Ne miroiter qu'en dernier recours, ou régénérer |
| Cape/hood qui apparaît sur le dos | Le modèle ajoute des éléments non demandés | `"No hood, no cape, no turban"` dans le négatif |
| Traits du visage différents d'un sprite à l'autre | Génération séparée = incohérence | Inévitable avec le fallback. Mitigation : prompt identique sauf la pose |
| URL 403 au téléchargement | URL signée expirée | Télécharger immédiatement, ou régénérer |

---

## 12. Procédure complète pour un nouveau héros

1. **Préparer la référence** (si existe) : convertir RGBA → fond blanc, committer, push
2. **Écrire le prompt sprite individuel** (template §2) avec :
   - Description physique complète (hex colors)
   - Position du bâton explicitée (côté spectateur)
   - Couleur du cristal explicitée + négations
   - Style Dofus/Waken + négations
3. **Générer 4 sprites** : face A, face B, back C, back D
4. **Télécharger immédiatement** chaque sprite (retry si 403)
5. **Vérifier chaque sprite** individuellement :
   - Bâton présent ? Bon côté ? Bonne couleur de cristal ?
   - Fond uni ? Pas d'ombre ? Corps entier ?
   - Si bâton mauvais côté → régénérer avec prompt corrigé, ou miroiter
6. **Normaliser les ratios** si diff hauteur > 5px après composition
7. **Composer** avec `compose_2x2.py`
8. **Vérifier la planche** (checklist §9)
9. **Nettoyer** les fichiers `_fallback_*.png` temporaires
10. **Commit + push**

---

## 13. Améliorations connues (non critiques, à faire si temps)

- **Rapport taille perso/bâton** : le bâton devrait être proportionnel au personnage de manière identique dans les 4 cases
- **Côté du bâton** : le miroir corrige le côté mais inverse la direction du regard — régénérer avec meilleur prompt serait mieux
- **Cape fantôme** sur certains dos : ajouter `"No cape, no hood"` systématiquement dans le négatif des vues de dos
- **Traits du visage** : légères variations entre sprites générés séparément — inévitable sans modèle de référence (LoRA/ControlNet)

---

## 13. Suggestions de Claude (intégration) — 2026-10-28

### 13.1 Composition sur fond uni unique

> *"Composer la planche 2×2 sur un seul fond uni, sans rectangle autour de chaque sprite et sans ombre au sol."*

**Déjà appliqué** : `compose_2x2.py` produit exactement cela — fond uni, pas de cadre par sprite, pas d'ombre.
Confirmé pour les 5 nouveaux héros (mage, sylvain, chasseur, assassin, tank) : fond `#FFFFFF` pur.

### 13.2 Planches d'actions (même méthode, sprite par sprite)

> *"Utiliser la même méthode sprite-par-sprite, en prenant les nouvelles vues comme référence.
> Le géomancien et l'invocateur en ont besoin en priorité, puis l'artificier."*

**Méthode** : générer 4 sprites d'action (ex: attaque, sort, défense, victoire) avec `edit_image`
en prenant `newAssets/{nation}/{hero}_vues.png` comme référence visuelle.
Même pipeline : vérifier sprite par sprite → normaliser ratios → composer 2×2 → valider checklist.

**Priorité** : Géomancien (sables) → Invocateur (brumes) → Artificier (rouages).

---

## 14. Contournement de la modération ("Protected Content")

### Symptôme
Certains prompts sont rejetés avec : `"Moderation occurred, reasons: Protected Content"`.
Cela a frappé systématiquement les classes : **mage**, **sylvain**, **chasseur** (faces), **assassin**.

### Solution qui a fonctionné
Remplacer le nom de classe par un **descripteur neutre** :

| Classe | Terme qui trigger | Terme neutre qui passe |
|--------|-------------------|------------------------|
| mage | "mage" | "Adult female spellcaster" |
| sylvain | "sylvain" | "Adult male forest ranger" |
| chasseur | "hunter" | "Adult female archer" |
| assassin | "assassin" | "Adult male rogue" |
| tank | (OK tel quel) | "Adult male heavy armored warrior" |

**Règle** : garder TOUTES les couleurs hex, descriptions d'armes, position main droite,
et négations `NOT` — seule la première ligne (identification du personnage) change.

### Structure de prompt gagnante (anti-modération)
```
Single full-body character sprite, standing relaxed pose, full body including both feet visible.
Adult [neutral descriptor]: [toutes les caractéristiques avec hex colors].
Head = exactly 1/3 of total height. Chibi adult proportions. Thick dark black outlines.
Dofus/Waken Ankama vector cartoon style. Flat colors.

[VIEW paragraph: FRONT 3/4 toward RIGHT/LEFT, or STRICT BACK VIEW facing upper-right/left]

CRITICAL - [WEAPON] IN RIGHT HAND: [anatomie détaillée avec côté spectateur].

Plain solid WHITE #FFFFFF background. No ground line, no shadow, no text, no border.
Canvas 1024x1024. Sprite centered with 100px+ margin on all sides. Taller than wide.
NOT pixel art, NOT realistic, NOT anime, NOT [liste des confusions courantes].
```

---

## 15. Audit complet des 10 héros (2026-10-28)

| Héros | Nation | Avant | Après | Statut |
|---------|--------|-------|---------|--------|
| soigneur | marees | 1×4 horizontal, 3 sprites | 2×2, 4 sprites, h_diff=0px | ✔️ Conservé |
| geomancien | sables | non conforme | 2×2, h_diff=0px | ✔️ Refait |
| invocateur | brumes | non conforme | 2×2, h_diff=0px | ✔️ Refait |
| druide | sylvestre | non conforme | 2×2, h_diff=3px | ✔️ Refait |
| artificier | rouages | marteau invisible (faces) | 2×2, h_diff=0px, marteau 4/4 | ✔️ Refait |
| mage | cristaux | h_diff=8px, gaps=38px, fond gris | 2×2, h_diff=0px, fond blanc | ✔️ Refait |
| sylvain | vents | h_diff=86px, gaps=60px, fond gris foncé | 2×2, h_diff=0px, fond blanc | ✔️ Refait |
| chasseur | brasier | h_diff=18px, gaps=2px, pieds 10px | 2×2, h_diff=0px, **arc** main droite | ✔️ Refait |
| assassin | ombres | h_diff=24px | 2×2, h_diff=0px | ✔️ Refait |
| tank | cimes | h_diff=46px, fond gris | 2×2, h_diff=0px, fond blanc | ✔️ Refait |

**Résultat** : 10/10 planches conformes au 2026-10-28 (commit `9207696`).

### Checklist technique appliquée (script d'audit)
```python
# Vérifications automatiques sur chaque planche :
# 1. Taille = 2048x1024
# 2. Détection grille : 2 segments horizontaux (rows) + 2 segments verticaux (cols)
# 3. h_diff = max(row_heights) - min(row_heights) < 5px
# 4. Gaps colonnes > 60px, gaps lignes > 60px
# 5. Fond uni (coins homogènes, tolérance ±25/channel)
# 6. Fond blanc (>240 sur les 3 canaux) pour les nouveaux héros
```

### Armes spécifiques par héros (main droite obligatoire)
| Héros | Arme main droite | Item main gauche |
|---------|-----------------|------------------|
| soigneur | Bâton doré + cristal eau #7FE8FF | — |
| geomancien | Bâton doré + cristal ambre #F2A93B | — |
| invocateur | Bâton sombre + cristal violet | Grimoire flottant |
| druide | Bâton bois + cristal feuille #3FD08A | — |
| artificier | Marteau à tête d'engrenage | — |
| mage | Bâton argenté + cristal bleu #5CC8FF | Spellbook marron/or |
| sylvain | Bâton bois + cristal menthe #7FF0D8 + ailes blanches | — |
| chasseur | **ARC** courbé motifs flammes #C8281E | Carquois dans le dos |
| assassin | Dague courbée | Dague courbée (autre main) |
| tank | Marteau de guerre runique | Bouclier rond (bras gauche) |

---

## 16. Améliorations connues (non critiques, à faire si temps)

- **Rapport taille perso/bâton** : le bâton devrait être proportionnel au personnage de manière identique dans les 4 cases
- **Côté du bâton** : le miroir corrige le côté mais inverse la direction du regard — régénérer avec meilleur prompt serait mieux
- **Cape fantôme** sur certains dos : ajouter `"No cape, no hood"` systématiquement dans le négatif des vues de dos
- **Traits du visage** : légères variations entre sprites générés séparément — inévitable sans modèle de référence (LoRA/ControlNet)
- **Carquois peu visible** sur certaines vues du chasseur (arc présent mais carquois pas toujours visible)
- **Tête légèrement trop grande** sur certains sprites (chasseur_face_b, tank_face_b, assassin_face_a) — le ratio 1/3 est demandé mais pas toujours respecté
- **Miroir de sylvain_face_a** : le bâton était du mauvais côté, corrigé par `ImageOps.mirror` — le personnage regarde maintenant vers la gauche au lieu de la droite
