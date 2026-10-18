# V22 — Mode Aventure : fluidité, groupes de monstres, contrats, maîtrise

## Fluidité
- **Un seul appui pour marcher** (avant : un appui pour voir le trajet, un second pour partir). Le trajet s'affiche pendant la marche et se raccourcit pas à pas.
- **Changer de cap en route** : toucher une autre case pendant la marche redirige le héros après le pas en cours.
- Pas un peu plus rapides (0,15 s, jusqu'à deux fois plus vite sur les longs trajets).
- Les petites trouvailles de route (cueillette, bourse, sage) s'affichent en **bandeau + journal**, sans fenêtre à fermer.
- Plus d'**embuscade surprise** qui coupait la marche : les combats sont désormais visibles sur la carte (groupes ci-dessous).
- L'aide de contrôle en bas de la carte disparaît après les 30 premiers pas ; la carte « En chemin » du panneau devient **Objectifs de la carte**.

## Groupes de monstres errants (façon Dofus)
- Chaque carte compte 3 groupes visibles de **2 à 4 ennemis**, avec un badge « niv N · ×effectif » coloré selon le danger (vert / orange / rouge par rapport au niveau de l'équipe).
- Ils **flânent** quand le héros marche et barrent le passage. Toucher un groupe : le héros va à son contact et le combat est proposé (niveau, effectif, risque). Joystick vers un groupe : même fenêtre.
- Le combat Tactique oppose **exactement l'effectif du groupe** (2 ennemis = combat court ; 4 = plus d'XP et de butin).
- Un groupe vaincu **réapparaît ailleurs après 12 pas** : chaque carte est un terrain de chasse.
- **Fourchettes de niveau par carte** pour combler les sauts entre cartes : Sylve 1-7 (prépare aux Ronces niv 10), Ronces 8-14, Lisière 12-19, Cendres 18-25… Donjon 88-100.

## Contrats (au camp)
- Le camp affiche un **tableau des contrats** : « Vaincre 2 (ou 3) groupes sur cette carte », et un contrat sur trois est un **contrat d'élite** qui fait apparaître une bande d'élite (4 ennemis, halo doré, au-dessus de la fourchette).
- Récompense versée à la victoire qui remplit le contrat et annoncée au retour sur la carte : or, ressources de la carte, XP ; pour l'élite, une ressource de rang 2 et un objet rare ou mieux.
- Le contrat en cours est rappelé sous le nom de la carte et dans la fenêtre de combat.
- Le repos au camp n'est plus exploitable à l'infini : de nouveau disponible après 25 pas.

## Maîtrise de carte
- Tous les lieux + toutes les trouvailles ✦ d'une carte : récompense unique (objet rare ou mieux, or, ressource de rang 2) et ★ à côté du nom de la carte.

## Technique
- `scripts/AdventureMobs.gd` (nouveau) : groupes, réapparition, flânerie, contrats — logique pure sur l'état Aventure.
- `ProgressionManager` : victoire contre un groupe (`mob:zone:id`) → groupe retiré, contrat avancé, récompenses (`adventure_contract_reward`, `adventure_mastery_reward`).
- `GameManager` : `pending_count` fixe le nombre d'ennemis d'un combat d'Aventure.
- Tests : `test_adventure_mobs.gd` (nouveau), `test_adventure_move.gd` (appui unique, redirection, contact d'un groupe). Captures : `shot_adventure_v22.gd`.
