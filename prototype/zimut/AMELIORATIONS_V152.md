# V152 — IA tactique, équilibrage, fourchette de dégâts, nouveaux succès

## 1. IA tactique (`scripts/TurnManager.gd`)

L'ancienne IA était « gloutonne » : elle lançait le meilleur sort depuis sa case, sinon elle marchait vers une
distance idéale. La nouvelle IA ajoute ce qu'un joueur fait naturellement :

- **Se placer puis frapper** : pour chaque case atteignable, elle évalue la meilleure attaque (ou le meilleur
  soin) possible une fois arrivée, et se déplace si c'est nettement mieux que ce qu'elle peut faire sur place.
  Le calcul ne regarde que les cases autour des cibles (environ 1 ms par action sur PC).
- **Concentration** : bonus pour finir un héros blessé, viser les soigneurs (Heal, Druide) et suivre la cible
  déjà entamée par un autre ennemi (cible commune par équipe). Les constructions comptent moins.
- **Frapper puis reculer** : après avoir lancé ses sorts, une unité fragile (tireur, soigneur, prudent) utilise
  ses PM restants pour s'éloigner des menaces (portée de déplacement + d'attaque des héros), en restant à portée
  utile. Un soigneur reste près de l'allié le plus blessé.
- **Exposition** : les fragiles évitent les cases où plusieurs héros peuvent les atteindre.

Qui l'utilise : les ennemis en Normal, Difficile et Enfer ; les invocations alliées et le mode **Auto** des héros.
Les ennemis en **Facile** gardent l'ancienne IA.

## 2. Équilibrage (`scripts/GameSettings.gd`)

| Difficulté | PV ennemis | Attaque ennemie (avant → V152) | Menace PV × attaque |
|---|---|---|---|
| Facile | ×1,0 | ×1,0 | 1,0 |
| Normal | ×1,2 | ×1,2 → **×1,32** | 1,44 → 1,58 (×1,1) |
| Difficile | ×1,65 | ×1,2 → **×1,32** | 1,98 → 2,18 |
| Enfer | ×2,145 | ×1,38 → **×1,55** | 2,96 → 3,32 |

Mesure (`tests/sim_difficulte.gd`, héros pilotés par l'ancienne IA, niveau 10, Difficile, combats 1, 4, 7, 10) :
ancienne IA ennemie 2 victoires sur 4 (39 % de PV restants en moyenne), nouvelle IA 1 sur 4 (16 %), avant même la
hausse d'attaque. Normal est relevé de 10 % (attaque ×1,1) à la demande de Charlie. La simulation oppose une IA à une autre : elle compare des versions, elle ne remplace pas
l'avis d'un joueur. À réajuster après tes parties.

## 3. Aperçu des dégâts en fourchette

`GameManager.estimate_damage_range` renvoie le minimum (coup normal, aléa ×0,93) et le maximum (critique,
aléa ×1,07). Il tient compte du combo, de l'exécution, de la Marque, du critique de dos et des immunités.
Texte au-dessus de la cible : `-42~63`, suivi de `KO` si le minimum tue, ou de `KO ?` si seul le maximum tue.

## 4. Nouveaux succès (25 → 42)

Centurion (100 victoires), Inarrêtable (250), Trempé dans l'acier (10 victoires en Difficile ou Enfer),
Revenu des Enfers (10 en Enfer), Sang-froid (sans K.O. en Difficile ou Enfer), Explorateur et Maître des donjons
(5 et 20 donjons différents), Bannière levée et Unificateur (1 et 4 Nations unies), Chroniqueur (3 chapitres),
Rempart vivant (3 défenses en personne), Encyclopédiste (50 ennemis rencontrés), Exterminateur (500 vaincus),
Grand stratège (25 objectifs), Artisan (10 fabrications), Fortune (5 000 or), Au sommet (niveau 100).

Les succès basés sur des données déjà présentes (donjons, Nations, chapitres, bestiaire) se débloquent à la
prochaine vérification pour les parties existantes.

## Tests

- `test_ia_tactique` : se placer puis frapper, cible blessée, cible commune, repli, Facile = ancienne IA, coût.
- `test_apercu_degats` : 400 coups réels dans la fourchette, immunité, textes `KO` / `KO ?`.
- `test_succes_v152` : compteurs de difficulté et statistiques dérivées.
- `test_difficulte` : mis à jour pour les nouveaux multiplicateurs.
