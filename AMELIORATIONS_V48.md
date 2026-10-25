# V48 — Niveau du joueur et déblocage des héros

## Principe
- En fin de tutoriel (ou dès la création de la partie si le tutoriel est désactivé), Gultur demande de **choisir 3 héros** parmi 10. Seuls ces trois sont disponibles au début.
- Le joueur a un **niveau propre** (`data["player"]`). D'autres héros se débloquent **au choix du joueur** : au niveau 4, puis tous les 3 niveaux (4, 7, 10, 13, 16, 19, 22). Un joueur qui garde la même équipe a donc tous les héros vers le niveau 22 (réglable : `HeroUnlock.FIRST_UNLOCK_LEVEL` / `UNLOCK_EVERY`).

## Niveau du joueur
- Il gagne l'XP de chaque combat au **multiplicateur de classe maximal (×1,10)**, avec le même facteur de niveau de combat que les héros. Il suit donc de près un héros que l'on emmène toujours, sans être forcément égal au plus haut niveau.
- **Aucun héros ne peut dépasser le niveau du joueur** : l'XP en excès est conservée et se convertit en niveaux dès que le joueur monte. Les héros d'équipe gagnent un peu plus ou moins vite (Tank/Heal ×1,10, Assassin/Mage ×0,95…) : le plafond ne gêne qu'à la marge.
- Les héros au banc restent à 5 % d'XP : ils rattrapent grâce au facteur de niveau de combat.

## Interface
- `HeroPickUI` : écran de choix (grille, fiche détaillée, ✓ choisir, confirmer). Mode « 3 héros » et mode « 1 héros à débloquer ».
- Écran d'équipe : héros verrouillés 🔒 (non ajoutables), ligne « Niveau du joueur N · prochain héros au niveau X », bouton 🔓 quand un déblocage est disponible.
- Fenêtre de victoire : carte « Niveau du joueur » avec barre d'XP et bouton « Choisir un nouveau héros ».
- Fiche personnage / Équipement : seuls les héros débloqués apparaissent.
- `ClassInfo` : fiches de classes étoffées (rôle, description, points forts/faibles, conseil, difficulté ★) — source unique pour l'écran d'équipe et le choix de héros.

## Anciennes sauvegardes
Tout est débloqué ; niveau du joueur = niveau du meilleur héros (aucun héros n'est bridé).

## Tests
`tests/test_hero_unlock.gd` : courbe de déblocage, choix initial, plafond de niveau, persistance, migration, fiches, écrans.

## Dialogues de Gultur (enrichis)
- **Choix des héros** (`PICK`, 6 répliques) : présentation des 10 héros et de leurs rôles, lecture des fiches et des étoiles de difficulté, trio conseillé, déblocage futur « c'est toi qui décides », puis `AFTER_PICK` avant le premier combat.
- **Écran d'équipe** : `TEAM` mentionne les cadenas 🔒 et le bouton ★ Explorateur ; `PLAYER` explique le niveau du joueur (plafond des héros, déblocages) ; `UNLOCK` apparaît la première fois qu'un héros est à débloquer ; `ALL_UNLOCKED` félicite quand les dix héros sont à soi. Chaque dialogue ne s'affiche qu'une fois et respecte « Passer le tutoriel ».

## Retours de test (V48b)
- Gultur cite aussi le **Chasseur** dans la présentation des héros ; texte de Gultur agrandi (26 px, bandeau plus haut).
- Fiches des héros (choix et écran d'équipe) : texte agrandi, et **glisser n'importe où dans la fiche** fait défiler (plus seulement la barre).
- Mes Parties : fenêtres **Supprimer**, **Renommer** et **Importer** remplacées par de grandes fenêtres lisibles sur téléphone (gros boutons, texte 24 px).
