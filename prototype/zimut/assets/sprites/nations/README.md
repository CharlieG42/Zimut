# Sprites « Nations » (planche du 17/10)

Source : `assets/sprites/_sheets/planche_nations.png` (planche d'illustration fournie par Charlie).
Découpage reproductible : `python3 tools/extract_sheet_sprites.py` (détourage rembg + GrabCut,
cadres de découpe dans le script ; voir son en-tête).

## Héros — `nations/heros/<classe>.png` (9)

| Classe | Nation | Utilisé en jeu |
|---|---|---|
| Tank | Cimes | oui (`players/tank.png`) |
| Assassin | Ombres | oui |
| Chasseur | Brasier | oui |
| Mage | Cristaux | oui |
| Druide | Sylvestre | oui |
| Heal | Marées | oui |
| Invocateur | Brumes | **non** — classe qui invoque, sprite à revoir à part |
| Sylvain | Vents | **non** — idem (le skin Sylvain actuel est conservé) |
| Géomancien | Sables | non — classe pas encore dans le jeu |

## Familiers — `familiers/<nom>.png` (9, ex-« invocations »)

golem_de_pierre, loup_spectral, archer_sylvestre, elementaire_de_cristal, esprit_de_la_foret,
requin_des_marees, ombre_invoquee, ent_de_combat, sentinelle_de_gres.
Pas encore reliés au jeu : les invocations actuelles (`assets/sprites/summons/`) gardent leurs
sprites. Ces familiers serviront à la capture en mode Aventure (idée Rappelz).

## Ennemis par nation — `nations/ennemis/<nation>/<nom>.png` (36)

- cimes : rochebrute, guerrier_des_monts, griffon_des_cimes, garde_des_pics
- ombres : assassin_des_ombres, spectre, liche, ombre_infernale
- sylvestre : loup_forestier, araknea, dryade, treant
- cristaux : golem_de_cristal, mage_cristallin, elementaire_de_cristal, araignee_de_cristal
- sables : scarabee_geant, bandit_des_dunes, genie_du_desert, sphinx
- vents : harpie, aigle_celeste, garde_aerien, elementaire_de_vent
- marees : crabe_geant, nereide, requin, pirate_des_mers
- brasier : salamandre, devoreur_de_flammes, golem_de_lave, lieutenant
- brumes : brumeux, liche_des_brumes, fantome, gargouille

Les nations ne sont pas encore une mécanique de jeu (voir `VISION_GLOBALE.md`) : ces ennemis
ne sont pas encore reliés à `data/ennemis.txt`.
