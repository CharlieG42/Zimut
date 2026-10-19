# V26 — L'Artificier et la Nation « Rouages »

## Nouveau héros : Artificier (ingénieur / bombardier)
Stats de départ dérivées du Chasseur (tireur), légèrement moins robuste ; +1 PA au niveau 85.
Synergies d'équipe : Artificier + Tank (« Ligne fortifiée », +10 % défense), Artificier + Chasseur (« Tir croisé », +8 % dégâts).

| Niv. | Sort | PA | Portée | Effet |
|---|---|---|---|---|
| 1 | Pistolet à ressort | 2 | 5 | tir de base |
| 1 | Poser Bombe | 2 | 4 | explose en croix (5 cases) à la fin du 2e tour de l'Artificier, ou dès qu'on la déclenche |
| 1 | **Déclencheur** | **1** | 6 | déclenche l'effet d'un de ses mécanismes (3 lancers max / tour) |
| 10 | Poser Mine | 2 | 4 | piège : dégâts au passage d’un ennemi ; explose en croix si déclenchée |
| 20 | Poser Tourelle | 3 | 4 | tire sur l'ennemi le plus proche (rayon 5) à la fin de chaque tour (4 tours) ; Déclencheur = tir immédiat |
| 35 | Poser Balise de transposition | 2 | 6 | pose la balise **et échange sa place avec elle** ; Déclencheur dessus = nouvel échange |
| 50 | Glyphe de surcharge | 3 | 5 | croix, 3 tours : alliés +25 % dégâts, ennemis 22 dégâts ; Déclencheur = effet rejoué |
| 65 | Grenade à fragmentation | 3 | 5 | 3x3 |
| 80 | Fusil à pompe | 3 | 3 | gros coup à courte portée |
| 100 | Arsenal total | 4 | – | déclenche d'un coup bombes, mines, tourelles, glyphes |

### Garde-fous
- **Un seul déplacement (inversion) par tour** (compteur remis à zéro à chaque début de tour) ; impossible si le héros est immobilisé.
- 3 mécanismes max (bombes + tourelles) ; 1 balise de transposition ; 1 tourelle (2 à partir du niveau 65).
- Les mécanismes ne comptent pas comme familiers, ne jouent pas, ne s'insèrent pas dans la timeline ; ils ont peu de PV et expirent seuls.
- Les explosions ne touchent que les ennemis.
- Le Déclencheur ne peut viser que ses propres mécanismes.
- Distinct du Géomancien : lui bloque le terrain (piliers, murs) ; l'Artificier pose des charges à retardement et les déclenche.

## Nation « Rouages » (biome Rouages)
- Biome : dalles d'acier et cuivre, engrenages géants, tuyaux fumants, enclumes, bobines à arcs, grue d'atelier.
- Effet de biome **Surtension** : +12 % de dégâts physiques pour tous.
- Ennemis : Gobelins et Trolls ; boss « Colosse d'Engrenages » (Salve de pistons : zone 3x3 + étourdissement).
- Aventure : nouvelle carte « Ateliers des Rouages » (grille [4,1], accessible depuis les Côtes des Marées), niveaux 82-94.
- Conquête : données de nation prêtes (héros, ressource, quartiers de ville) ; pas encore de villes Rouages sur la carte.

## Provisoire (en attente de vos illustrations)
- Sprite de l'Artificier (`assets/sprites/players/artificier.png`, `nations/heros/artificier.png`), boss (`nations/boss/rouages.png`), skins ennemis (`nations/ennemis/rouages/*.png`, absents : les skins génériques s'affichent).
- Mécanismes : pastilles colorées (Bombe rouge, Tourelle grise, Balise cyan) en attendant des sprites.
- Musique : réutilise les thèmes du Brasier. Illustration de ville : celle du Brasier.
- Tous les chiffres sont une première proposition à valider sur téléphone.

Tests : `tests/test_artificier.gd`, capture `tests/shot_artificier.gd`.
