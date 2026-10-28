# Guide d'utilisation — Corrections V2

## Objectif
Obtenir des planches de sprites en **grille 2×2 stricte** (4 sprites, 2 rangées × 2 colonnes) avec :
- Même hauteur pour les 4 sprites
- Pieds alignés par rangée
- Fond uni, sans sol, sans ombre, sans texte
- Objet tenu visible dans la main droite dans les 4 cases
- Personnage adulte, tête = 1/3 de la hauteur
- Style vectoriel Dofus/Waven, contours noirs épais

---

## Méthode 1 : Génération directe 2×2 (à essayer d'abord)

### Pour le Soigneur (avec référence heal.png)

**Outil** : `edit_image`
**Image source** : `https://raw.githubusercontent.com/CharlieG42/Zimut/vibe/sylvestre-sprites-v2-0dff68/prototype/zimut/assets/sprites/nations/heros/heal_on_white.png`

**Prompts à essayer dans l'ordre** :

| Priorité | Fichier | Stratégie |
|----------|---------|-----------|
| 1 | `soigneur_v2_a.txt` | Coordonnées pixel exactes, très détaillé |
| 2 | `soigneur_v2_b.txt` | Court et impératif, moins de contexte |
| 3 | `soigneur_v2_c.txt` | Vocabulaire neutre, "panels" au lieu de "grid" |
| 4 | `soigneur_v2_d.txt` | Ultra-court, style télégraphique |

### Pour le Géomancien (sans référence)

**Outil** : `generate_image`

| Priorité | Fichier | Stratégie |
|----------|---------|-----------|
| 1 | `geomancien_v2_a.txt` | Coordonnées pixel exactes |
| 2 | `geomancien_v2_b.txt` | Court et impératif |

---

## Méthode 2 : Sprite par sprite + composition (fallback garanti)

Si la méthode 1 échoue (mauvais nombre de sprites, pas 2×2, sprites qui se touchent) :

### Étape 1 : Générer 4 sprites individuels

Utiliser `generate_image` (ou `edit_image` pour le soigneur) avec le template `fallback_single_sprite.txt`.

**Exemple pour le Soigneur — Sprite 1 (face A)** :
```
Single full-body character sprite. Adult female healer. Long WHITE hair (#F4FAF2),
pointed ears, calm mature face. White robe with TURQUOISE panels (#24C1C9) and
GOLD embroidery (#E8C067). Head = 1/3 of height. Chibi. Thick dark outlines.
Dofus/Waven vector style.
FRONT view, facing front-right (3/4), standing relaxed, both feet visible.
RIGHT hand holds a golden staff (#E8C067) topped with a glowing water-drop crystal (#7FE8FF).
Plain solid light gray #E8E8E8 background. No ground, no shadow, no text.
Canvas 1024x1024. Sprite centered with 100px+ margin on all sides. Taller than wide.
NOT pixel art, NOT realistic.
```

Générer 4 sprites :
1. `soigneur_face_a.png` — face, pose relaxed
2. `soigneur_face_b.png` — face, autre pose
3. `soigneur_back_c.png` — dos, pose 1
4. `soisseur_back_d.png` — dos, pose 2

### Étape 2 : Assembler avec le script

```bash
cd /workspace/github__CharlieG42__Zimut
python3 prompts_sprites/corrections_v2/compose_2x2.py \
  soigneur_face_a.png soigneur_face_b.png soigneur_back_c.png soigneur_back_d.png \
  prototype/zimut/assets/sprites/nations/newAssets/marees/soigneur_vues.png \
  --bg="#E8E8E8" --height=420 --canvas="2048x1024" --margin=60
```

### Étape 3 : Vérifier et ajuster

```bash
python3 << 'EOF'
from PIL import Image
img = Image.open("prototype/zimut/assets/sprites/nations/newAssets/marees/soigneur_vues.png")
print(f"Taille: {img.size}")
# Vérifier les dimensions et l'alignement...
EOF
```

---

## Checklist de validation d'une planche

Avant de valider une planche, vérifier :

- [ ] **Exactement 4 sprites** (ni 2, ni 3, ni 6)
- [ ] **Grille 2×2** (2 rangées × 2 colonnes, pas 1×4 ni 2×3)
- [ ] **Rangée du haut** : 2 sprites de FACE (3/4 vers la droite)
- [ ] **Rangée du bas** : 2 sprites de DOS (vers le haut-droite, pas de visage)
- [ ] **Même hauteur** pour les 4 sprites (différence < 5px)
- [ ] **Pieds alignés** par rangée (différence < 5px)
- [ ] **Fond uni** (#E8E8E8 gris clair ou #FFFFFF blanc selon le perso)
- [ ] **Pas de sol, pas d'ombre, pas de texte**
- [ ] **Grands espaces** entre les sprites (rien ne se touche)
- [ ] **Objet tenu dans la main DROITE** dans les 4 cases
- [ ] **Même personnage** dans les 4 cases (mêmes couleurs, mêmes accessoires)
- [ ] **Adulte** : mâchoire marquée, tête = 1/3 de la hauteur, pas d'enfant
- [ ] **Style** : vectoriel Dofus/Waven, contours noirs épais, pas de pixel art
- [ ] **Taille** : 2048×1024 minimum

---

## Commandes utiles

### Vérifier une planche
```bash
python3 << 'EOF'
from PIL import Image
img = Image.open("chemin/vers/planche.png").convert("RGB")
w, h = img.size
print(f"Dimensions: {w}x{h}")
px = img.load()
def is_bg(c):
    return c[0]>200 and c[1]>200 and c[2]>200  # blanc ou gris clair

# Détecter les quadrants avec contenu
for name, (x0,y0,x1,y1) in {
    "Haut-Gauche (face 1)": (0,0,w//2,h//2),
    "Haut-Droite (face 2)": (w//2,0,w,h//2),
    "Bas-Gauche (dos 1)":  (0,h//2,w//2,h),
    "Bas-Droite (dos 2)":  (w//2,h//2,w,h),
}.items():
    content = sum(1 for y in range(y0,y1,4) for x in range(x0,x1,4) if not is_bg(px[x,y]))
    print(f"  {name}: {content} pixels de contenu {'✅' if content > 100 else '❌ VIDE'}")
EOF
```

### Télécharger une image générée
```bash
python3 << 'EOF'
import urllib.request, time
from PIL import Image
url = "URL_SIGNEE_AZURE"
for attempt in range(6):
    try:
        req = urllib.request.Request(url, headers={"User-Agent":"Mozilla/5.0"})
        data = urllib.request.urlopen(req, timeout=90).read()
        open("temp.jpg","wb").write(data)
        img = Image.open("temp.jpg").convert("RGB")
        img.resize((2048,1024), Image.LANCZOS).save("output_2048.png")
        print(f"OK {img.size}")
        break
    except Exception as e:
        print(f"Retry {attempt}: {e}")
        time.sleep(6)
EOF
```

### Commit + push
```bash
cd /workspace/github__CharlieG42__Zimut
git add -A
git commit -m "FIX V2: [perso] planche 2x2 corrigée"
git push origin vibe/sylvestre-sprites-v2-0dff68
```

---

## Ordre de traitement recommandé

1. **Soigneur** (edit_image avec heal.png) — priorité absolue, à refaire
2. **Géomancien** (generate_image) — refaire en vrai 2×2
3. **Invocateur** — refaire en vrai 2×2 (actuellement 2×3)
4. **Druide** — refaire en vrai 2×2 (actuellement 1×2)
5. **Artificier** — déjà OK en 2×2, garder

Pour chaque personnage : essayer méthode 1 (2-3 prompts), si échec → méthode 2 (4 sprites + compose_2x2.py).