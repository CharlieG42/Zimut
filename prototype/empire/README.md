# Zimut Empire - Mode 3: Empire / Conquete

Prototype du mode Empire / Conquete (solo/PvE), couche strategique macro
au-dessus du combat tactique Zimut.

## Etat - Etape 2 (demo jouable)

- Carte monde 12x12 : capitale du joueur, 5 villages neutres, 3 seigneurs IA.
- Economie passive (or/fer/bois/magie) + batiments (batiments.csv).
- Recrutement : heros (classes Zimut) et unites (unites.csv) via l'UI.
- Attaque d'une ville -> COMBAT TACTIQUE ZIMUT REEL (scenes/Battle.tscn) :
  l'armee attaquante affronte la garnison reelle de la ville, l'issue
  determine la conquete (cf scripts/battle/, pont BattleBridge).
- Reconnaissance, sauvegarde/chargement, IA des seigneurs.

## Lancer

1. Ouvrir Godot 4.x, importer le projet depuis prototype/empire/.
2. Lancer la scene Main.tscn (carte monde).
3. Cliquer une ville non-bleue, puis "Attaquer" -> bataille tactique.

## Structure

- scripts/: managers Empire (EmpireManager autoload + sous-managers).
- scripts/battle/: portage du combat tactique Zimut (BattleGameManager,
  BattleGridManager, BattleUIManager, BattleTurnManager, BattleCell,
  BattleSpellButton, orchestrateur BattleMain).
- scenes/: Main.tscn (carte monde), Battle.tscn (combat tactique).
- data/: CSV du jeu (classes, sorts, unites, batiments, divinites...).
- assets/: sprites du combat (meme chemins que prototype/zimut/).
- DESIGN_EMPIRE.md (a la racine du depot): design complet et roadmap.
