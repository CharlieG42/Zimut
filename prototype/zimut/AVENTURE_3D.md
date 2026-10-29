# Aventure 3D (bêta) — monde ouvert au sol

> Deuxième rendu du mode Aventure : le **même monde** que la carte classique, vu à la
> 3e personne. Réglage : **Réglages → Mode Aventure → Monde 3D (bêta)**. La carte classique
> reste le mode par défaut et reste accessible depuis le monde 3D (bouton « Carte classique »).

## Principe : deux couches

| Couche | Rendu | Rôle |
|---|---|---|
| **Exploration** | 3D low-poly (`scripts/adventure3d/`) | marcher, découvrir, ramasser, rencontrer |
| **Combats** | 2D isométrique, héros chibi (**inchangés**) | toute rencontre lance le combat Tactique habituel |

L'explorateur est **le joueur lui-même** (silhouette vectorielle low-poly), pas un héros.
Au retour d'un combat, on revient dans le monde 3D à la même place.

## Ce qui est réutilisé (aucune duplication d'état)

- `AdventureTerrain` : cases, île, obstacles, sentiers, portes, lieux → le monde 3D est généré
  à partir du même terrain déterministe (même carte = même disposition).
- `AdventureManager` / `AdventureMobs` / `ProgressionManager` : sauvegarde, groupes de monstres
  (apparition, errance, respawn), contrats, XP d'exploration, déblocage des cartes.
- `TeamSelection` → `Main` → fenêtre de résultat : le circuit de combat est exactement le même.

## Fichiers

```
scenes/Adventure3D.tscn
scripts/adventure3d/
  Adventure3D.gd      # scène : environnement, HUD, contacts (monstres, lieux, portes), sauvegarde
  Adv3DWorld.gd       # génération du monde 3D (sol, falaises, arbres, décors, marqueurs, explorateur)
  Adv3DExplorer.gd    # déplacement (glissement), caméra 3e personne orbitale
  Adv3DStick.gd       # joystick virtuel tactile / souris
tests/test_adventure3d.gd     # headless : monde, connexité, scène, combat
tests/shot_adventure3d.gd     # captures d'écran (xvfb)
```

## Contrôles

| Action | Tactile | PC |
|---|---|---|
| Se déplacer | stick à gauche | ZQSD / WASD / flèches |
| Tourner la caméra | glisser sur l'écran | clic droit + glisser |
| Lieu proche | bouton d'action en bas à droite | idem |

## Ce que gère déjà la bêta

- Groupes de monstres visibles : contact → proposition de combat (« Plus tard » le laisse passer).
- Lieux : combat, coffre, camp, belvédère, sentier.
- Portes entre cartes (routes gardées respectées) : on change de carte et la scène se recharge.
- Position 3D sauvegardée (`adventure.pos3d`) ; si la carte classique déplace le héros, on reprend sa case.

## Reste à faire

- [ ] Énigmes (3 types) et donjons dans le monde 3D (aujourd'hui : via « Carte classique »).
- [ ] Brouillard de découverte 3D et mini-carte.
- [ ] Biomes des Nations (Vents, Brumes, Brasier…) : palettes et props dédiés (repli sur la Forêt).
- [ ] Sprites HD / ambiance sonore par zone ; pinch pour zoomer.
- [ ] Mesure de fluidité sur téléphone milieu de gamme (pas d'ombres temps réel pour l'instant).
