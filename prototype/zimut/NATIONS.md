# Nations et biomes (V11)

Six nouveaux biomes de combat, un par nation, définis dans `scripts/Nations.gd` (palette, tuiles de sol,
props, monuments, ambiance, ennemis, boss) et dessinés par `scripts/NationScenery.gd`.

| Biome | Particularité | Ambiance | Ressource |
|---|---|---|---|
| Cristaux | cristaux lumineux, trône de cristal | étincelles | Magie |
| Marées | sable humide, coraux, phare, ancres | bulles | (cf. Nations.gd) |
| Vents | totems, tourbillons, arche des vents | rafales | (cf. Nations.gd) |
| Brasier | obsidienne, lave, volcan | braises | Fer |
| Brumes | champignons, arbres morts, esprits | brume | Venin |
| Ombres | tombes, ronces violettes, porte sombre | lueurs mauves | Magie |

- Ennemis : sprites de nation (`assets/sprites/nations/ennemis`) mappés sur les 5 types de base ; noms de nation affichés.
- Villes de Conquête réparties par nation (voir `CONQUEST_CITIES`), sprites de ville par nation.
- Musique : pas de piste dédiée — les nouveaux biomes réutilisent les pistes existantes (à composer).
- Joystick Aventure : `scripts/ZJoystick.gd` ; défilement tactile partout : `scripts/TouchScroll.gd`.

## V12 — Boss et Aventure
- Boss de nation : lignes « Boss … » dans `data/ennemis.txt`, sorts signature (`Combat.nation_boss_spells`) et kits (`GameManager._spawn_boss`).
- Aventure : 6 zones de nation (Plateau des Vents, Marais des Brumes, Terres de Cendre, Nécropole d'Ombre, Caverne de Cristal, Côtes des Marées), chacune avec combats, coffre, énigme, belvédère et camp.
- Trouvailles cachées (herbes, bourses, reliques) : 6 par zone, ramassées en marchant ; progression ✦ affichée dans le bandeau.
- Décors et particules de biome pendant l'exploration, objets de lieux propres à chaque nation.
