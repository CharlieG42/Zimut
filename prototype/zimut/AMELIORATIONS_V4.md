# Zimut — Améliorations V4 (à partir de ta version avec forge, biomes et niveaux de sorts)

## Interface
* **Fenêtre PERSONNAGES refaite** (`CharacterSheetUI.gd`) : colonne des 8 classes avec portrait, niveau, barre d'XP et
  points à dépenser ; en-tête (portrait, rôle, XP, PV/PA/PM) ; **deux onglets** :
  * *Caractéristiques* : 6 cartes avec barre de composition (base / points / objets), affinité A-B-C, coût du prochain
    point, boutons − / +, répartition auto, réinitialisation, panoplies et effets actifs.
  * *Sorts* : une carte par sort avec **pastilles PA / PM / Portée**, type, zone, ligne de vue, description,
    valeur actuelle → valeur au niveau suivant, **10 crans de niveau**, coût en or + Magie (rouge si insuffisant), bouton AMÉLIORER.
* **Badges de sorts en combat** : fond sombre + texte blanc contourné ; pastille **PA en haut à gauche**, **PM en haut à
  droite** (si le sort en coûte), **Portée en bas à droite**, légendes sous chaque pastille ; touche, niveau du sort (★),
  zone et lancers restants en petites étiquettes. Colonne élargie, journal et infobulle décalés pour ne plus se chevaucher.
* **Forge refaite** (`ForgeUI.gd`, fenêtre dédiée) : stock de ressources toujours visible, filtres par catégorie avec
  compteur « fabricables / total », « fabricables seulement », liste triée (fabricables d'abord), ressources en vert/rouge
  avec « possédé/requis », panneau de détail : choix du personnage (portraits), **comparaison avec l'objet porté**
  (écarts +/−), barres de ressources, motif exact de ce qui manque, boutons **FABRIQUER** et **FABRIQUER ET ÉQUIPER**.
  Les objets forgés sont de qualité **Rare** (+15 % de stats).
* **Écran Équipement** : stats totales et panoplies sous les cases (elles chevauchaient les emplacements), contrastes
  corrigés, cadres plus hauts.
* **Bouton MENU** : il émettait un signal que personne n'écoutait → il ramène maintenant au menu principal.
* **Pop-up « Voir tous les loots gagnés »** : centré avec voile sombre (clic pour fermer).
* `UiKit.gd` : petits composants de style partagés (panneaux, pastilles, boutons, barres).

## Progression
* **XP hors équipe : 10 %** (au lieu de 35 %), plus de bonus de rattrapage.
* **Chaque victoire sur le combat de progression fait monter chaque personnage de l'équipe d'au moins 1 niveau**,
  quel que soit le niveau de ses alliés (un perso en retard rattrape jusqu'à +50 % d'XP).
* **Rejouer un combat déjà gagné** : sélecteur ◀ ▶ sur l'écran d'équipe. Le combat garde le niveau auquel il a été gagné ;
  XP réduite si l'ennemi est plus faible que le perso (jusqu'à −90 %), loots et ressources normaux, or ×0,6. Rejouer ne fait
  pas avancer la progression. Historique sauvegardé (`fight_levels`) ; anciennes parties gérées par estimation.

## Sylvain
* **Nouveau skin** inspiré des Sadida : chevelure-feuillage fleurie, collerette et jupe de feuilles, bâton noueux à fleur lumineuse.
* **Sort « Invoquer Arbre »** (niveau 8, 3 PA, portée 2) : arbre **immobile, qui ne joue pas**, **bloque la ligne de vue**
  (pour les sorts et l'IA), 1 seul par Sylvain (le précédent se fane). **Relais de soins** : quand le Sylvain soigne, tous
  les alliés **et leurs invocations** sur les 8 cases autour de l'arbre reçoivent le même soin. Zone de relais affichée
  en losange vert pulsant sous l'arbre.

## Skins
* 21 skins générés par `tools/gen_skins.py` : nouveau **Sylvain**, **Arbre de vie**, et trois **boss de biome** distincts
  (**Gobelin Roi**, **Troll Géant**, **Squelette Seigneur**) en plus du Dragon ; ennemis et invocations de la V2 conservés.

## Tests
`test_replay.gd` (rejouer, XP 10 %, +1 niveau garanti, bouton MENU), `test_tree.gd` (arbre : immobile, vue, relais),
`test_progression_v2.gd` adapté à la nouvelle fiche ; outils de capture : `shot_ui.gd` (sheet | spells | forge | equip | team),
`shot_battle.gd`, `shot_tree.gd`. Les tests existants passent toujours.

## Non fait (à venir)
Refonte du rendu des scènes de combat (ambiance par biome, particules d'ambiance), aperçu des dégâts au survol,
accélération des animations ennemies.
