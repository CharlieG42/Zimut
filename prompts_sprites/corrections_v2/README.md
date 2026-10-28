# Corrections V2 — Prompts optimisés pour grille 2×2 stricte

## Problème identifié
Le modèle FLUX ne respecte pas "2×2 grid" quand on le demande en texte libre.
Il génère souvent 1×4, 2×3, ou des sprites qui se touchent.

## Stratégie adoptée
1. **Décrire les coordonnées pixel exactes** des 4 quadrants
2. **Répéter "EXACTLY 4" et "ONLY 4"** pour interdire les sprites supplémentaires
3. **Définir la ligne des pieds** en pixels pour chaque rangée
4. **Variante B** : vocabulaire plus court et impératif (moins de contexte = moins de confusion)
5. **Stratégie de secours** : générer 1 sprite à la fois, puis composer en 2×2 avec PIL

## Structure de chaque prompt
- LIGNE 1 : Dimensions canvas + nombre exact de sprites + grille
- LIGNE 2 : Coordonnées des 4 quadrants
- LIGNE 3-4 : Contenu de chaque quadrant (face/dos)
- LIGNE 5 : Alignement (hauteur identique, pieds sur ligne Y)
- LIGNE 6-8 : Description du personnage (adulte, traits, tenue)
- LIGNE 9 : Objet tenu (main, visibilité, interdictions)
- LIGNE 10 : Style + interdictions

## Fichiers
- `soigneur_v2_a.txt` — Variante coordonnées pixel (edit_image avec heal.png)
- `soigneur_v2_b.txt` — Variante impérative courte (edit_image avec heal.png)
- `soigneur_v2_c.txt` — Variante texte-à-image sans référence
- `soigneur_v2_d.txt` — Variante "4 panneaux" (generate_image)
- `geomancien_v2_a.txt` — Variante coordonnées pixel
- `geomancien_v2_b.txt` — Variante impérative courte
- `template_2x2.txt` — Template réutilisable pour tout personnage
- `fallback_single_sprite.txt` — Pour génération sprite par sprite
- `compose_2x2.py` — Script PIL pour assembler 4 sprites en grille 2×2
