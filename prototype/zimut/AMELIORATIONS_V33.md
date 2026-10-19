# V33 — Chorégraphies d'attaque par sort, plus fluides et plus rapides

- **Une animation par sort** : chaque sort a sa propre chorégraphie, toujours la même pour ce sort (graine = nom du sort + classe) :
  élan éventuel (pose d'incantation, de marche ou variante de repos) puis 1 ou 2 frappes, dans un ordre propre au sort.
  Exemple : 9 animations différentes pour les 10 sorts du Chasseur, 10 pour le Heal, le Géomancien et le Sylvain.
- **Plus rapide** : élan 0,09 s, frappes 0,12 s, dernière pose tenue 0,20 s (avant : 0,3 à 0,5 s par pose).
- **Plus fluide** : fondu très court (≈ 0,08 s) entre deux poses + petit étirement à chaque changement.
- **Nouvelles poses récupérées** sur les planches où plusieurs poses se touchaient (séparation par silhouette) :
  Chasseur 4 attaques (visée, tir en saut, tir accroupi, tir en course), Invocateur 4, Artificier 4, Mage 3, Géomancien 3,
  Druide 5 incantations, Heal 3 ; boss des Cimes (dos, marche, 2 attaques, incantation), des Cristaux (2 attaques, 3 incantations)
  et du Brasier (2 attaques, incantation).

Test : `tests/test_choreo.gd` (même sort = même animation, au moins 3 animations différentes par héros).
