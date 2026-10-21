# V40 — Aventure : carte agrandie, étages (ciel / surface / profondeurs), paysage

## Carte plus grande
- Panneau latéral réduit (`SIDE_W` 440), marges resserrées, zoom jusqu'à ×1.9 : l'île remplit l'écran.

## Étages du monde
- Ciel : Vents, Brumes. Surface : les autres. Profondeurs : Ombres, Cristaux, Brasier
  (`ProgressionManager.ADVENTURE_LAYER`, `adventure_zone_layer`, `adventure_climb_info`).
- Portes : libellé ▲ / ▼ quand on change d'étage.
- Transition : fondu clair (montée) ou sombre (descente), héros qui s'élève ou s'enfonce, message.
- Mini-carte : zones décalées verticalement selon l'étage, légende ▲ Ciel / ▼ Profondeurs.
- Les conditions d'accès ne changent pas (présentation et transition seulement).

## Paysage autour des îles (`AdventureLandscape.gd`)
- Surface : horizon de collines/mesas, îles flottantes lointaines.
- Ciel : nuages devant et derrière la falaise, colonnes de vent.
- Profondeurs : plafond de roche, stalactites, bouches de grotte, puits de lumière, brume sombre.
- Les cartes voisines apparaissent dans la direction de leur porte.

## Tests
- `tests/test_adventure_layers.gd` (étages, sens des transitions, libellés) ; captures : `tests/shot_adventure_etages.gd`.
