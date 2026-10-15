# Mode Conquête — pistes de réflexion gameplay

> Document de travail (v0). Proposé pour arbitrage — rien n'est figé.
> Ancré sur l'ébauche existante : 5 villes, assaut = combat tactique,
> victoire = annexion, progression partagée avec le reste du jeu.

## 1. La promesse

« **Construisez votre empire dans le monde de Zimut.** »

La Conquête est la couche stratégique posée sur le combat tactique existant :
chaque bataille sert un objectif territorial, et le territoire conquis
**débloque de la puissance** (ressources, bâtiments, sorts, panoplies).
Le joueur ne « farme » plus des combats abstraits : il agrandit un empire.

**Différenciation des modes :**
| Mode | Ce que le joueur vit |
|---|---|
| Combats Tactiques | Enchaîner des combats équilibrés, progresser son roster (mode « arène ») |
| Aventure | Explorer, découvrir, résoudre (mode « aventure ») |
| **Conquête** | **Décider, développer, dominer** (mode « stratégie ») |

## 2. La boucle de jeu cœur

```
CARTE  →  CHOISIR LA PROCHAINE CIBLE  →  ASSAUT TACTIQUE  →  VICTOIRE
  ↑                                                        |
  |                                        VILLE ANNEXÉE : revenus + options
  ← ← ← ← ← ← ← ← ← ← ← ← ← ← ← ← ← ← ← ← ← ← ← ← ← ←
```

1. **Carte** : voir son territoire, les villes ennemies, les revenus.
2. **Décision** : quelle ville attaquer (adjacente à mon territoire), avec
   quelle équipe — les combats perdus ne coûtent rien d'autre qu'une retraite.
3. **Bataille tactique** : le combat existant (biome de la ville, niveau de la
   ville, boss pour les places fortes).
4. **Annexion** : la ville rejoint l'empire → elle **produit** quelque chose
   (ressources, or) et/ou **débloque** quelque chose (forge, recrues, panoplie).
5. Retour à la carte, plus riche — et la pression ennemie augmente.

## 3. Le territoire

### Adjacence (fortement recommandé, phase 2)
On ne peut attaquer qu'une ville **reliée par route à son territoire**.
Effets :
- donne une forme d'« arbre technologique » spatial : choisir un axe
  (le nord montagneux riche en minerai ? le sud désertique ?) ;
- évite le saut direct sur la place forte finale ;
- rend la carte lisible d'un coup d'œil (routes ouvertes vs routes ennemies).

### Types de villes (à caler sur les biomes existants)
| Type | Rôle | Bataille |
|---|---|---|
| **Capitale** (Sylve-Cœur) | Quartier général, impossible à perdre | — |
| **Village** (neutre) | Économie : produit or + ressources | Niveau bas, 1 bataille |
| **Avant-poste** (ennemi) | Verrou militaire d'un axe | Niveau moyen, garnison renforcée |
| **Place forte** (ennemie) | Capitale ennemie d'un biome | Niveau élevé, **siège** (voir §5), boss du biome |
| **Donjon du Roi Squelette** | Objectif final de la campagne | Big boss (déjà implémenté) |

Extension naturelle : la carte s'ouvre sur les 3 biomes — villages de Forêt,
avant-postes des Pics de Zimut, places fortes des Dunes, puis le Donjon
commun. Chaque biome apporte ses ennemis/boss/décors **déjà en place**.

## 4. L'économie (le cœur du « construire »)

**Principe : réutiliser ce qui existe déjà.** Le jeu a déjà 5 ressources de
craft (Fer, Bois, Cuir, Magie, Venin), l'or, la Forge et les recettes.

- Chaque ville conquise **produit** chaque bataille gagnée :
  - village forestier → Bois + Cuir ; avant-poste montagnard → Fer ;
    place forte du désert → Magie ; etc.
- L'or des combats (existant) devient la monnaie stratégique.
- **Bâtiments à ériger dans les villes conquises** (1 ou 2 emplacements
  par ville, pas plus — on n'est pas dans un city-builder) :
  - **Forge** : débloque des recettes supérieures (déjà le système craft) ;
  - **Caserne** : soigne/gratuite 1 fois par bataille, +PV d'équipe ;
  - **Scierie / Mine / Comptoir** : augmente la production ;
  - **Temple** : +1 lancer de sort / bataille ou bonus d'XP.

Résultat : « construire son empire » = choisir **où** investir l'or et les
ressources, ce qui se ressent **dans chaque combat tactique** (équipement
forgé, bonus de bâtiments). Boucle courte, effets lisibles.

## 5. Les batailles de conquête

- **Niveau = niveau de la ville** (déjà le cas) — la carte affiche le
  « niveau conseillé » comme aujourd'hui.
- **Garnisons variées** : la composition ennemie dépend du type de ville
  (village : 4 sbires ; avant-poste : sbires + capitaine ; place forte :
  boss du biome + sbires, déjà implémenté par `_spawn_boss`).
- **Sièges** (phase 3, optionnel mais narrativement fort) : une place forte
  demande **2 victoires** : « briser les défenses » (bataille 1) puis
  « prendre la ville » (bataille 2, boss). Défaite = on garde le siège en
  cours, pas de remise à zéro — pas de frustration.
- **Défense** (phase 3, optionnel) : tous les N combats joués, l'ennemi
  contre-attaque une de vos villes → bataille défensive ; défaite = la
  ville est « pillée » (production gelée 3 batailles) mais **jamais
  perdue** (on garde la promesse « votre capitale ne peut pas être perdue »,
  on l'étend à tout le territoire : ce mode ne doit jamais punir en dur).

## 6. Récompenses et progression

- **Progression partagée** (principe déjà en place) : XP, loots, or de
  bataille nourrissent le même roster que le mode Tactique. La Conquête
  est une autre façon de faire progresser l'équipe, pas un second perso.
- **Récompenses uniques par ville** (ce que le mode Tactique ne donne pas) :
  - villages → recettes de forge exclusives ;
  - avant-postes → objets « panoplie » (sets existants : runique...) ;
  - places fortes → sort « signature » ou gemme d'amélioration de sort ;
  - Donjon → fin de campagne + récompense cosmétique/trophée.
- **Condition de victoire claire** : contrôler toutes les villes, puis
  vaincre le **Roi Squelette** dans le Donjon. Fin de campagne affichée,
  possibilité de continuer en « empire libre » (fin ouverte).

## 7. Rythme et accessibilité (mobile, sessions courtes)

- Une bataille = 5 à 15 min (existant). La carte doit être **lisible en
  10 secondes** : territoire doré/vert, ennemis rouges, cibles attaquables
  marquées d'une épée, revenus affichés en haut.
- Pas de temps réel, pas de timer hors combat : le joueur avance à son
  rythme, la carte est un plateau entre deux combats.
- Sur mobile : fiche ville en panneau latéral (déjà le layout actuel),
  boutons gros et rares.

## 8. Découpage proposé

**Phase 1 — Jouable propre (reprise de l'existant, peu de travail)**
1. Adjacence obligatoire (routes = graphe déjà dessiné).
2. Villes productrices : or + ressources par bataille gagnée (victoire
   débloquant la production de la ville nouvellement conquise).
3. Étendre la carte aux 3 biomes (8 à 10 villes, réutiliser villes/boss
   existants), siège simple sur les places fortes.
4. Écran de conséquence de victoire : « Ville annexée ! Vous gagnez :
   Bois ×3, recette Scierie ».

**Phase 2 — L'empire (le « construire »)**
5. Bâtiments (2 par ville max) + économie (Forge améliorée, caserne...).
6. Récompenses uniques par ville.
7. Production visible sur la carte, compteurs de revenus.

**Phase 3 — La pression ennemie (le « dominer »)**
8. Contre-attaques ennemies tous les N combats (défense, pillage temporaire).
9. Sièges en 2 batailles pour les places fortes.
10. Fin de campagne (Roi Squelette) + écran de victoire d'empire.

**Graphismes** : la carte actuelle (panneaux + boutons + routes dessinées)
suffit pour les phases 1-2. En phase 2 on peut ajouter des vignettes
PNG par ville (comme les cartes de mode), des icônes de bâtiments, et une
texture de fond de carte par biome — sans refonte.

## 9. Décisions actées (arbitrage du 15/10)

1. **Carte fixe narrative** — le monde de Zimut (Sylve-Cœur, les Pics, les
   Dunes, le Donjon) reste identique d'une partie à l'autre ; la rejouabilité
   vient de l'économie et des choix de bâtiments.
2. **Contre-attaques ennemies : OUI** (35 % par bataille gagnée) — la ville
   ciblée est **pillée** (production gelée 3 batailles), **jamais perdue**,
   et **la capitale ne peut jamais être attaquée** (implémenté).
3. **Une seule équipe héroïque** — pas de garnisons par ville.
4. **Bâtiments de ressources dans les villes conquises** (implémenté) :
   Scierie (Bois), Mine (Fer), Tannerie (Cuir), Cabane des mages (Magie),
   Verger (Venin) ; la production est versée à chaque bataille gagnée.
5. **Brisage d'équipement** (implémenté, voir §10) : les objets en trop
   peuvent être détruits dans la Forge pour récupérer des ressources.

## 10. Brisage d'équipement

La Forge gagne un mode « BRISAGE D'ÉQUIPEMENT » : chaque objet de
l'inventaire peut être brisé (détruit) contre des ressources utiles à
forgé d'autres équipements. Gains selon la rareté et le niveau :
- commun : 1 ressource (Fer/Bois) · rare : 2 (Fer/Cuir/Bois) ;
- épique : 3 (Magie/Fer/Cuir) · légendaire : 5 (Magie/Venin/Fer) ;
- quantité par ressource ≈ (1 + niveau × 0,1) × rareté — un légendaire
  de haut niveau rend largement plus qu'un commun de bas niveau.
