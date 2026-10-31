# V63 — Ingénieur, glyphes traversés, donjon en 3D, carte des portails

## Ingénieur (ex-Artificier)
- **Nom affiché « Ingénieur »** partout (Labels, boutons, journal de combat, textes dessinés) via `Loc` :
  la clé interne reste `Artificier` (sauvegardes, données, sprites inchangés). Changer `Loc.CLASS_RENAMES` suffit
  pour un autre nom. En anglais : *Engineer*.
- **Bombes à niveaux** (esprit des bombes du Roublard) : niveau 1 à la pose, +1 à chaque fin de tour du poseur,
  jusqu'au niveau 4. Explosion ×1 / ×1,3 / ×1,65 / ×2. Étoile dorée avec le niveau sur chaque bombe,
  « Niveau N ! » à chaque montée. Déclenchée tôt = faible ; laissée mûrir = dévastatrice.
- **Couplage** (niv. 6, 1 PA, portée 6) : couple un de vos mécanismes pendant 3 tours. Deux mécanismes couplés,
  alignés (ligne ou colonne, 1 à 6 cases d'écart), tendent une **barrière électrique** : les ennemis ne peuvent pas
  la franchir (les alliés oui) et ceux qui s'y trouvent quand elle se forme sont électrocutés. Arc animé entre les
  deux mécanismes, cases illuminées, éclair bleu sur les mécanismes couplés. Fonctionne avec tous les mécanismes
  (bombes, tourelles, balise).
- Gultur présente ces nouveautés sur l'écran d'équipe ; fiche de classe mise à jour.

## Glyphes
- **Traverser un glyphe** (allié ou ennemi) déclenche son effet, comme s'y arrêter (une fois par tour et par
  créature, comme avant).

## Aventure
- **Donjon accessible depuis le monde 3D** : entrée de donjon dédiée (tours, porte sombre, lueur violette),
  bouton « 🏰 Donjon … (salle n/4) », fenêtre des salles (niveaux, Gardien, chance de Pierre) puis combat.
- **Carte plein écran** : chaque accès indique sa destination et son niveau (« → Marais des Brumes · Niv. 26 »,
  « ✖ … · fermé »).

## Conquête
- Panneau de droite : boutons à retour à la ligne, typographie française (espaces insécables avant « : ! ? % »,
  entre un nombre et son unité) — plus de « 100 | % » ni de « 12 | or » coupés, plus de panneau qui déborde.
- PR #199 (Mistral, V62) corrigée : le script de l'écran de ville compilait mal (types Variant), bâtiments affichés
  trois fois trop grands, panneau plus large que l'écran.

## Tests
- `tests/test_v63.gd` : bombes à niveaux, Couplage (barrière, blocage, allié qui passe, expiration), glyphe
  traversé, nom affiché.
- Captures : `shot_ingenieur_v63.gd`, `shot_donjon_3d.gd`, `shot_carte_portails.gd`.
