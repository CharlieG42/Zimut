# V64 — Conquête : voies rétablies, cibles, brouillard, explorateur

## Correctif : voies d'attaque
- Avant : dès que l'Aventure révélait une ville, seules les villes révélées restaient attaquables — les voisines
  de l'empire passaient en « ? » et la campagne se bloquait.
- Maintenant : une ville **reliée par une route à l'empire est toujours visible et attaquable**
  (`ProgressionManager.conquest_city_adjacent_to_empire`). Le brouillard ne cache que ce qui est au-delà de la frontière.

## Carte et conseil de guerre
- Onglet **⚔ CIBLES** : villes attaquables, de la plus facile à la plus dure (niveau, type, avis, butin) ;
  un toucher sélectionne la ville et recentre la carte. Bouton **Envoyer un explorateur** tant qu'il reste du brouillard.
- **Aide au siège** (`ConquestSystem.assault_advice`) : niveau moyen de l'équipe contre le niveau conseillé →
  à votre portée (≤ 2 niveaux d'écart) / risqué (≤ 6) / trop fort. Un siège « trop fort » demande confirmation.
- Détails de la ville repliables (**▾ DÉTAILS**) : « Lancer l'assaut » reste visible sans défiler.
- **Villes vues de loin** (révélées, sans route) : anneau pointillé, « à N étapes » sous le nom, chemin à ouvrir dans le panneau
  (`ConquestSystem.path_to`, parcours en largeur).
- **Terres inconnues** : le panneau n'affiche plus ni nom, ni niveau, ni description — seulement comment les révéler.
- Noms au-delà de la frontière : contour plus épais, couleur plus claire.
- Récapitulatif d'annexion : « Nouvelles voies ouvertes : … ».

## Explorateur
- Mission de **Cartographie** (3 batailles, 2 villes révélées, 1 chance sur 5 de complication) : recommandée et placée
  en premier dans le sélecteur tant qu'il reste du brouillard, avec le nombre de villes à découvrir.

## Difficulté
- Niveaux conseillés plafonnés selon la distance à la capitale (étapes 1 à 7 : 5 / 18 / 30 / 45 / 60 / 85 / 120),
  vérifié par `test_conquest_roads`. Changés : Sanctuaire Moussu 33→18, Bastion de l'Orage 63→30,
  Fort des Cendres 110→30, Pic Foudroyant 90→45, Citadelle de Sable 120→45.

## Gultur
- Nouveaux conseils : brouillard (`conq_brouillard`), explorateur (`conq_explorateur`), nouveautés de la carte (`conq_v64`),
  belvédère en Aventure (`adv_belvedere`, 2D et 3D).

## Personnages
- Sélecteur de sorts actifs : vraie case à cocher de 48 px, lisible au doigt.

## CI / tests
- Le workflow lance désormais **tous** les `tests/test_*.gd` ; les échecs sont signalés en `::warning::` sans bloquer l'APK.
- Nouveaux : `test_gultur_conquete`, `test_conquest_ui_v64` ; `test_conquest_roads` étendu (brouillard, chemins, niveaux).
- Captures : `shot_conquete_voies`, `shot_conquete_portrait`, `shot_gultur_brouillard`.
