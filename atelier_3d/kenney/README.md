# Kits Kenney (3D, CC0)

Bibliothèque **source** de modèles 3D (format GLB / glTF) fournis par [Kenney](https://www.kenney.nl), licence **CC0** (domaine public, usage commercial permis, attribution non requise mais appréciée).

Ce dossier est **hors du projet Godot** (comme `atelier_sprites/`) : il n'ajoute aucun fichier `.import` et n'alourdit ni l'import ni la CI. Les modèles se chargent à la volée (`GLTFDocument.append_from_file`) pour être **cuits en sprites 2D** ; seuls les sprites cuits entrent dans `prototype/zimut/assets/`.

| Dossier | Modèles | Contenu | Pistes d'usage dans Zimut |
|---|---|---|---|
| `fantasy-town/` | 167 | Éléments **modulaires** : murs bois/pierre, toits (4 formes, 2 couleurs), portes, fenêtres, cheminées, escaliers, étals, fontaines, haies, clôtures, moulin à eau/à vent, charrettes, lanternes, bannières | **Villages et bâtiments** : on assemble des maisons de tailles variées (mur + toit + porte + fenêtre + cheminée), puis on cuit chaque bâtiment. Villes des Nations, Conquête |
| `nature/` | 329 | Arbres (≈35 espèces : chênes, pins, plateau, cônes, détaillés…), cactus, fleurs, plantes, champignons, souches, troncs, rochers et pierres (≈60), **falaises avec pentes, escaliers et coins** (≈30), ponts bois/pierre, tentes, feux de camp, cultures, statues, clôtures, canoë | **Végétation de toutes les Nations** (forêt, désert, marais) ; **falaises et rampes** pour les plateaux à étages ; ponts ; champs cultivés autour des villages |
| `mini-forest/`, `mini-dungeon/`, `mini-arena/` | 22 / 30 / 22 | Petits kits cohérents (arbres, rochers, plateformes, tente, cible ; salles et pièges de donjon ; murs, colonnes, statue) | Décor de donjons, camps d'archers, arènes (déjà utilisé : `assets/kenney_arena`) |
| `castle/` | 76 | Tours carrées/hexagonales modulaires, remparts, portes, ponts, drapeaux, machines de siège | **Donjons finaux, forts, postes de garde** (Cimes, Citadelle des Ronces) |
| `survival/` | 80 | Tentes, feux de camp, coffres, caisses, tonneaux, panneaux, établis, outils, ressources, poissons | **Camps, coffres, trouvailles** (lieux « camp » / « chest ») |
| `graveyard/` | 91 | Cryptes, pierres tombales, cercueils, grilles de fer, lanternes, citrouilles, fantômes, squelettes | Nations des **Ombres** et des **Brumes** : entrées de donjon en crypte, cimetières |
| `pirate/` | 72 | Navires, canons, pontons, tonneaux, palmiers | Nation des **Marées** (côtes, ports) |
| `tower-defense/` | 160 | Tours, socles, armes, ennemis, routes | Nation des **Rouages** (mécanismes, tourelles) |
| `platformer/` | 153 | Blocs, plateformes, pièces, clés, cœurs, panneaux | Énigmes, icônes d'objets, nations mécaniques/cristaux (à étudier) |
| `holiday/` | 99 | Sapins, neige, cadeaux, bonhommes de neige | Biome enneigé (Cimes, Vents) et événements saisonniers |
| `3d-road-tiles/` | 302 | Tuiles de route glTF | Routes de la carte de Conquête |

Chaque dossier contient les `.glb` (ou `.gltf`), le dossier `Textures/` (palette `colormap.png`), `License.txt` et `Preview.png`. `_planches/` contient des planches-contacts des kits (noms des modèles sous chaque vignette) pour choisir sans ouvrir chaque fichier.

## Idée de pipeline (à venir)
1. Script Godot `tools/bake_kenney.gd` : charge un `.glb`, le pose avec une lumière et un angle isométriques identiques à la carte (caméra orthographique, 2:1), rend sur fond transparent en haute résolution puis réduit.
2. Un assembleur de bâtiments (fantasy-town) compose des maisons à partir de modules, puis les cuit.
3. Les sprites obtenus vont dans `prototype/zimut/assets/sprites/decor/kenney/<kit>/` et remplacent les bâtiments dessinés en code (`BuildingNode`) et une partie de la végétation.

Un essai de cuisson avec le MegaKit Quaternius (`prototype/zimut/assets/nature/`) a confirmé que le rendu est bon (arbres, pins, buissons fleuris, rochers).
