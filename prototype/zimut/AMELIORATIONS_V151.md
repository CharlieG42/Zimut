# V151 — Conquête : Nations unies et chapitres de campagne

## 1. Nation unie

Tenir **toutes les villes d'une Nation** (capitale comprise pour la Sylve) donne sa **Bannière** :

- un bonus pour **tous les héros, dans les trois modes** (Tactique, Aventure, Conquête), ajouté aux statistiques
  comme celui des Pierres Élémentaires (`ProgressionManager.member_stats`) ;
- **+5 de défense** à chaque ville de la Nation (`NATION_UNITED_DEF`).

Perdre une seule ville suspend la Bannière jusqu'à sa reprise : avec l'empire vivant (V146), délaisser la
Conquête peut coûter un bonus utile partout. La première union est annoncée dans les nouvelles.

| Nation | Villes | Bannière |
|---|---|---|
| Sylve | 7 | PV +20, Soins +5 % |
| Cimes | 5 | Défense +4, Résistance magie +5 % |
| Brasier | 4 | Force +4, Dégâts physiques +5 % |
| Brumes | 4 | Intelligence +4, Dégâts magiques +5 % |
| Sables, Cristaux, Marées, Vents, Ombres, Rouages | 4 ou 5 | voir `ConquestSystem.NATION_BANNERS` |

## 2. Chapitres de campagne

Huit étapes annoncées, une à la fois, chacune récompensée :

1. Les premiers pas — conquérir 3 villes — 150 or
2. Libérer la Sylve — unir la Sylve — 300 or, 15 Bois
3. Une vraie cité — une ville au rang de Cité — 250 or
4. Briser un général — vaincre un général du Roi Squelette — 400 or, 10 Magie
5. Au-delà des forêts — unir une deuxième Nation — 500 or
6. Les quatre Nations — unir Sylve, Cimes, Brasier et Brumes — 800 or, 30 Fer, 20 Magie
7. Tout Zimut — conquérir toutes les villes — 1 500 or
8. La chute du Roi Squelette — prendre le Donjon du Roi — 3 000 or

Vérifiés après chaque victoire de Conquête et à l'ouverture de la carte (plusieurs d'un coup si besoin ; une
partie en cours reçoit les chapitres déjà atteints). Sur la carte, un bouton violet en haut du Conseil de guerre
montre le chapitre en cours et son avancement ; le toucher ouvre la liste des chapitres et des Bannières.

## Technique

`ConquestSystem` : `NATION_BANNERS`, `united_nations`, `nation_progress`, `banners_bonus`, `banner_text`,
`announce_united`, `CHAPTERS`, `chapter_index`, `chapter_progress`, `advance_chapters`.
`ProgressionManager.conquest_nation_cities`. Sauvegarde : `conquest.chapter`, `conquest.nations_announced`.

## Tests

`tests/test_v151_nations_chapitres.gd` (nouveau). `test_v145_defense` rendu stable (un raid aléatoire pouvait
retirer un soldat et faire échouer « garnison intacte » environ une fois sur dix).
