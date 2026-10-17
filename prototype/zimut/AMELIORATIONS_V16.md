# V16 — Corrections, équilibrage et lisibilité mobile

## Corrections
- **Boutons Forge / Gouverneurs invisibles** : les images étaient exclues du dépôt par `.gitignore` (`*.png`).
  L'APK construit par GitHub n'avait donc pas les images. Étaient aussi concernés : les médaillons des villes
  (Conquête) et tout l'habillage de la Forge. Tout `assets/**` (png/jpg) est désormais suivi.
- **Garde-fou CI** : `tools/check_assets.py` est lancé avant l'export et fait échouer le build s'il manque une image.
- 23 fichiers `.import` orphelins supprimés.

## Équilibrage
- Sorts des héros : **dégâts et soins / 1,5** (texte, colonnes et poisons ; `tools/gen_balance_v15.py`, `HERO_SPELL_DIV`).
- Attaques des invocations / 1,5 (`Combat.SUMMON_SPELL_DIV`).
- Attaque des ennemis ×2,0 → ×1,7 pour compenser : en simulation (`tests/sim_balance.gd`), les héros seuls
  perdaient au niveau 20 après le nerf ; avec ×1,7 les combats durent un peu plus longtemps qu'avant pour une difficulté comparable.
- **Une seule invocation de créature par tour** (on construit son armée au fil des tours).
- Kits des invocations adaptés aux nouveaux sprites : Archer Sylvestre tire à distance et ralentit, Ent de Combat frappe au corps à corps et peut étourdir, etc.

## Interface
- **Forge lisible sur smartphone** : interface agrandie ×1,4, catégories en barre au-dessus de la liste,
  boutons d'action toujours visibles en bas du panneau, coût affiché sans défiler.
  Le Briseur fonctionne en deux temps : choisir l'objet, voir le rendement, puis BRISER. Fusion : bouton ×1 / MAX.
- Fiches Personnages et écran de ville agrandis ×1,2 (`UiFit.gd`).
- Équipement de l'équipe : tuiles illustrées par emplacement (comme dans la Forge), cases vides estompées.
- Icônes des sorts d'invocation refaites à partir des nouveaux sprites.
- Carte de sélection d'équipe : les stats ne débordent plus sous le bouton.
