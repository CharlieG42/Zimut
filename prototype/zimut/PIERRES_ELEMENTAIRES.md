# Les Pierres Élémentaires — objectif final du jeu (design proposé, non implémenté)

> Statut : **idée validée dans l'intention, mécaniques à définir**. Ce document sert de base de discussion ;
> rien ici n'est encore dans le code, à part la narration de Gultur (`scripts/Gultur.gd`).

## 1. Récit (déjà raconté par Gultur dans le tutoriel)
- Chaque Nation de Zimut veille sur un élément. Une **Pierre Élémentaire par Nation** maintenait l'équilibre du monde.
- Les Pierres ont disparu, dispersées. Les créatures se déchaînent, les routes sont coupées.
- Le joueur vient d'un autre monde, appelé par les Pierres : seul lui peut les retrouver.
- **Objectif final : retrouver toutes les Pierres.** Chaque nouvelle Nation ajoutée au jeu ajoute une Pierre → durée de vie extensible.

## 2. Règles proposées
| Sujet | Proposition |
|---|---|
| Nombre | 1 Pierre par Nation (9 Nations prévues dans `NATIONS.md` / `VISION_GLOBALE.md`) |
| Équipement | Un héros porte **2 Pierres maximum**, dans 2 emplacements dédiés « Pierre », en plus des 10 emplacements de stuff |
| Effets | Une capacité de **sort** et/ou un **gain de caractéristiques**, propre à la Pierre (elle est unique : pas de rareté ni de rang au départ) |
| Unicité | Une Pierre n'existe qu'en un exemplaire par partie : la prêter à un héros la retire à l'autre |
| Obtention | Récompense de fin d'arc d'une Nation : boss de la Nation (Tactique), maîtrise de carte ★ ou lieu clé (Aventure), cité-sanctuaire (Conquête) |
| Progression | Idée à valider : une Pierre « s'éveille » (niveaux 1 à 5) avec des ressources de rang élevé, pour relier la Forge au but final |

## 3. Idées de capacités (une par Nation — à équilibrer)
| Nation | Pierre | Capacité de sort (idée) | Bonus de caractéristiques (idée) |
|---|---|---|---|
| Sylvestre | Pierre de Sève | *Floraison* : soigne et enracine en zone | +Sagesse, +PV |
| Cimes | Pierre de Givre | *Avalanche* : dégâts de zone + ralentissement | +Défense |
| Sables | Pierre d'Ocre | *Mirage* : esquive une attaque / leurre | +Agilité |
| Ombres | Pierre d'Ébène | *Pacte d'ombre* : vol de vie | +Force |
| Vents | Pierre d'Azur | *Rafale* : repousse tous les ennemis adjacents | +PM |
| Marées | Pierre de Corail | *Marée* : soigne l'équipe | +Intelligence |
| Brasier | Pierre de Braise | *Éruption* : dégâts de zone sur 2 tours | +Dégâts |
| Cristaux | Pierre de Prisme | *Résonance* : renvoie un sort | +PA |
| Brumes | Pierre de Lune-des-Marais | *Voile* : invisibilité d'un allié 1 tour | +Résistances |

## 4. Où cela s'inscrit dans le jeu
- **Tutoriel** : Gultur présente le but à l'accueil, puis rappelle les Pierres à l'ouverture de l'Aventure (niv 3) et de la Conquête (niv 5).
- **Tactique** : sert à monter en niveau et à vaincre les boss qui détiennent des Pierres.
- **Aventure** : lieux et cartes de Nation cachent les Pierres (ex. maîtrise d'une carte clé).
- **Conquête** : les cités-sanctuaires des Nations gardent leurs Pierres.

## 5. À décider
1. Une Pierre est-elle liée à un boss précis ou à un lieu précis ? (suggestion : boss de la Nation, une fois ses cités conquises)
2. Les Pierres ont-elles un niveau ou un éveil ? (suggestion : oui, 5 niveaux)
3. Compatibilité avec les classes : libre pour tous, ou bonus d'affinité de Nation (cf. tableau des classes de `VISION_GLOBALE.md`) ?
4. Sauvegarde : prévoir `save["stones"] = { "pierre_id": { "owner": "Classe" | "", "level": 1 } }` (clé optionnelle, rétro-compatible).
