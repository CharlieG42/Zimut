# Sprites des cartes de nations (`n_*`)

Source : `prompts_sprites/planche_invocations_nations.png` (10) et `planche_invocations_nations_2.png` (30), planches Mistral.
Découpe : `tools/couper_planche.py` (étiquettes effacées avant, options `--holes 60000 --shadow-delta 300 --ombre-sol` pour les sprites clairs), un PNG par carte : `cartes/<id de carte>.png`.

Les cartes sont nommées d'après **ce que montre l'image**, pas d'après l'étiquette de la planche 2 (qui ne correspond pas à l'image pour la plupart des cases, par exemple « Golem de cristal » = centaure archer sombre, « Dragon blanc » = sirène). La nation est choisie selon l'apparence du sprite.
