# Retour sur les planches V65 — ce qui est livré, ce que Mistral doit reprendre

Analyse des 80 planches (8 nations × 10 bâtiments) et des sprites découpés, 2026-11-01.

## 0. Mise à jour du 2026-11-01 (après fusion des PR #214-#216) — sprites retirés
Une revue visuelle des sprites fusionnés a montré 15 planches défectueuses : elles sont **retirées** (le jeu retombe sur le
dessin vectoriel) et sont à refaire. Une planche = un bâtiment × 5 niveaux ; dès qu'un niveau est mauvais, toute la ligne part,
pour garder une progression cohérente.

| Nation | Bâtiment | Défauts constatés |
|---|---|---|
| Brumes | Caserne | Niv. 3 = dalle vide sans bâtiment, niv. 4 = petite maison, niv. 5 = énorme tour : progression incohérente |
| Brumes | Résidence | Niv. 2 et 4 réduits à un fragment ; niv. 1, 3, 5 avec une étiquette de texte flottante (« Swamp manor », « Manor plus ») |
| Brumes | Scierie | Niv. 2 et 4 fragments ; niv. 1, 3, 5 avec deux bâtiments empilés dans l'image |
| Brumes | Mine | Niv. 2 et 4 fragments ; niv. 3 avec deux bâtiments empilés |
| Brumes | Tannerie | Niv. 2 et 4 coupés à gauche/droite ; niv. 3 et 5 : socle collé au bord |
| Brumes | Cabane | Niv. 2 minuscule, niv. 4 coupé en deux, niv. 5 trop grand |
| Brumes | Verger | Niv. 2 et 4 coupés ; socle du niv. 3 tronqué |
| Brumes | Muraille | Niv. 3 coupé en deux ; niv. 1, 2, 4 socle tronqué d'un côté |
| Brasier | Résidence | Niv. 1 minuscule, niv. 5 coupé verticalement |
| Brasier | Mine | Deux bâtiments empilés dans chaque image ; niv. 2 et 4 fragments |
| Brasier | Tannerie | Niv. 3, 4, 5 : socle tronqué à gauche et en bas |
| Brasier | Verger | Trois variantes empilées dans chaque image ; niv. 2 et 4 coupés |
| Brasier | Muraille | Niv. 1 minuscule, niv. 2 et 4 bandes coupées, niv. 3 grande dalle plate + fragments |
| Cristaux | Hôtel de ville | Niv. 2 et 4 : base rognée et échelle bien plus petite que les niv. 1, 3, 5 |
| Cristaux | Muraille | Niv. 2 et 4 = petites tours de porte, niv. 1, 3, 5 = enceintes carrées : pas le même objet |

**Conservés (revus, corrects)** : Brumes hôtel de ville + merveille ; Brasier hôtel de ville, caserne, scierie, cabane, merveille ;
Cristaux résidence, scierie, merveille ; Ombres hôtel de ville, merveille ; Rouages résidence, mine, muraille, merveille ;
Marées, Sables, Vents merveille.
**Jamais livrés** (à produire) : Cristaux caserne/mine/tannerie/cabane/verger ; Rouages hôtel de ville/caserne/scierie/tannerie/cabane/verger ;
Ombres 8 bâtiments (tout sauf hôtel de ville) ; Marées, Sables, Vents 9 bâtiments chacun (tout sauf merveille).
Les consignes du §4 s'appliquent, en particulier : **une seule rangée de 5 niveaux, un seul bâtiment par niveau (pas d'empilement),
aucun texte, marges suffisantes** (rien ne doit toucher le bord de l'image).

## 1. Pourquoi les premiers sprites étaient coupés
La première découpe tranchait chaque planche en **5 colonnes de largeur fixe**. Les bâtiments grandissent avec le
niveau et débordent de leur colonne : niveaux 2 à 4 tronqués à gauche et à droite, avec des morceaux du voisin.
La découpe a été refaite (`tools/slice_city_sprites.py --v65`) : détection des silhouettes, suppression du fond
(blanc, pastel ou dégradé), du liseré blanc/vert, du texte et des bandeaux noirs. Elle ne livre un bâtiment que
si les 5 niveaux sortent **propres** ; sinon les anciens sprites cassés sont retirés (le jeu retombe sur le dessin
vectoriel) et la planche est à refaire.

## 2. Livré (19 planches, utilisables en jeu)
| Nation | Planches livrées |
|---|---|
| Brasier | scierie, cabane des mages, merveille |
| Brumes | caserne, merveille |
| Cristaux | hôtel de ville, résidence, scierie, muraille, merveille |
| Marées | merveille |
| Ombres | hôtel de ville, merveille |
| Rouages | résidence, mine, muraille, merveille |
| Sables | merveille |
| Vents | merveille |

Réserves mineures : caserne de Brumes très petite (échelle à agrandir) ; socle légèrement entamé sur les niveaux 2 et 4 de l'hôtel de Cristaux.

## 3. À reprendre par Mistral (61 planches)
Cause : **N** niveaux au lieu de 5 · **Grille** au lieu d'une rangée · **Collés** = les socles se touchent ou se chevauchent (impossible à
séparer sans entamer le voisin) · **Unique** = un seul grand ensemble au lieu de 5 niveaux · **Texte/Fond** = texte ou fond inexploitable.

| Nation | Bâtiment | Problème précis |
|---|---|---|
| Brasier | Hôtel de ville | Unique : 5 niveaux sur un socle continu, se chevauchent |
| Brasier | Caserne | Collés (socles en zigzag imbriqués) |
| Brasier | Résidence | 4 niveaux (+ mini décor parasite) |
| Brasier | Mine | Grille 2×3 (6 variantes) |
| Brasier | Tannerie | Collés |
| Brasier | Verger | Grille 3×3 (9 vignettes) |
| Brasier | Muraille | Unique : une enceinte, pas de niveaux |
| Brumes | Hôtel de ville | 4 niveaux |
| Brumes | Résidence | 3 vignettes + texte « Cell #1… » dans l'image |
| Brumes | Scierie | Grille 2×3 |
| Brumes | Mine | 4 vignettes en quinconce, aucune progression |
| Brumes | Tannerie | Collés |
| Brumes | Cabane | 3 bâtiments, échelles incohérentes (le 3ᵉ énorme), bulles décoratives |
| Brumes | Verger | Collés |
| Brumes | Muraille | Unique |
| Cristaux | Caserne | Unique : un diorama de plusieurs bâtiments |
| Cristaux | Mine | Unique : un grand complexe |
| Cristaux | Tannerie | Collés (socle continu) |
| Cristaux | Cabane | 4 niveaux |
| Cristaux | Verger | Grille : 4 vignettes en croix |
| Marées | Hôtel de ville | Unique |
| Marées | Caserne | 4 vignettes (1 + 3) |
| Marées | Résidence | Grille 2×3 |
| Marées | Scierie | Texte/Fond : bandeau noir « Hear Sawmill — Upgrades 2xx Levels » |
| Marées | Mine | Collés (5 imbriqués sur un socle commun) |
| Marées | Tannerie | Grille 2×3 |
| Marées | Cabane | 3 niveaux |
| Marées | Verger | 4 niveaux |
| Marées | Muraille | 3 pièces |
| Ombres | Caserne | Collés |
| Ombres | Résidence | Grille 2×3 |
| Ombres | Scierie | 3 bâtiments |
| Ombres | Mine | Grille : 6 fosses différentes |
| Ombres | Tannerie | Collés, niveaux 1 et 2 superposés |
| Ombres | Cabane | 4 niveaux |
| Ombres | Verger | 4 vignettes (3 + 1) |
| Ombres | Muraille | 3 bâtiments |
| Rouages | Hôtel de ville | 3 bâtiments |
| Rouages | Caserne | Collés |
| Rouages | Scierie | 4 vignettes |
| Rouages | Tannerie | Grille 2×3 |
| Rouages | Cabane | 3 niveaux + texte « Level 1… » |
| Rouages | Verger | 4 vignettes |
| Sables | Hôtel de ville | Unique |
| Sables | Caserne | Grille 2×3 |
| Sables | Résidence | Grille 3×3 |
| Sables | Scierie | 4 niveaux, fond rosé |
| Sables | Mine | Texte : 5 minuscules + « level 1… » sous chaque |
| Sables | Tannerie | Grille 2×3 (+ 1) |
| Sables | Cabane | 3 niveaux + chiffres |
| Sables | Verger | Collés (les socles sont coupés à droite) |
| Sables | Muraille | Unique : un seul long mur |
| Vents | Hôtel de ville | 3 bâtiments, fond teinté |
| Vents | Caserne | Collés |
| Vents | Résidence | Fond : sol blanc fondu dans le fond rose, socle mangé |
| Vents | Scierie | Collés, niveau 1 avec deux objets |
| Vents | Mine | Unique : un plateau |
| Vents | Tannerie | 4 niveaux |
| Vents | Cabane | Collés |
| Vents | Verger | Fond : vert du fond = vert du feuillage, détourage impossible |
| Vents | Muraille | 3 rangées de murs |

**Forêt et Montagne** (mes découpes, V65 de départ) : à compléter aux niveaux 2 à 5 selon la norme (un seul dessin pour l'hôtel de
ville de la Forêt, la mine, la scierie, la caserne, la résidence ; muraille et merveille de la Montagne manquantes).

## 4. Consignes à ajouter au prompt (par ordre d'importance)
1. **Exactement 5 niveaux, en une seule rangée horizontale, de gauche à droite.** Pas de grille, pas de 3 ou 4 niveaux.
2. **Un espace de fond vide entre deux niveaux** : les losanges de sol ne doivent ni se toucher ni se chevaucher
   (pas de zigzag, pas de socle commun).
3. **Un socle isolé par niveau**, de même emprise sur les 5 niveaux (norme §2). Seul le bâtiment change.
4. **Fond blanc pur (#FFFFFF), uniforme**, y compris pour Marées et Vents : le vert chroma n'a pas été respecté, les fonds
   sont pastel, roses ou dégradés. Pas de bande noire, pas de bandeau.
5. **Aucun texte, chiffre, étiquette ni légende** dans l'image.
6. **Aucune ombre portée ni halo** (ils sont mangés par le détourage et laissent des liserés).
7. **Muraille** : 5 niveaux d'un même tronçon de rempart (mur + porte), pas une enceinte complète ni 3 rangées.
8. **Hôtel de ville, mine, verger** : 5 dessins distincts, pas un seul ensemble.
9. **Même échelle** : un niveau ne doit pas être 3 fois plus grand que le précédent sans raison (cabane de Brumes).
10. Pas de feuillage ni d'herbe de la **même teinte que le fond** (verger de Vents).
