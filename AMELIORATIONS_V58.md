# V58
- Cristaux : héros Mage, Araignée, Mage cristallin, Golem, Élémentaire, boss — repos, dos, sort face, sort dos (planches Gemini ; l'ancienne série de poses est remplacée).
- Marées : héros Soigneur (`heal`) — 14 poses depuis la planche ChatGPT (repos ×2 face/dos, marche, 2 attaques, 2 sorts, face et dos).
- Prompts : grimoire du Mage dans la fiche d'identité.
- Suivi : md des nations terminées déplacés dans `prompts_sprites/nations/V1/` (Sylvestre, Cimes).

## Fluidité en combat (mesure : combat de boss, rendu logiciel)
- Appels de dessin par image : 3 715 → 1 396 (−62 %) ; objets rendus : 12 443 → 5 522.
- Décor de fond (falaises, rebords, arbres) : dessiné une seule fois dans une texture (`SceneryBake.gd`) au lieu de ~2 000 appels par image. Balancement des arbres du rebord et scintillement des torches figés.
- Cases : les 4 arêtes en une seule commande de dessin.
- Obstacles (`Prop.gd`) : redessinés ~15 fois par seconde au lieu de 60.
- Outil de mesure : `tests/perf_boss.gd` (`-- quick` pour les chiffres seuls).
