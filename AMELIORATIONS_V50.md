# V50 — Améliorations de fond

## Sauvegarde Cloud
- **Erreurs Google lisibles** : le message affiche la raison renvoyée par Google (`invalid_client`, `invalid_scope`, `access_denied`…) et le point à vérifier (type de client « TV et appareils à entrée limitée », secrets, utilisateurs test).
- Les identifiants sont nettoyés (espaces / retours à la ligne collés avec les secrets).
- Le workflow vérifie le format de l'ID client et la présence du secret (log « Sauvegarde Cloud : ID client au bon format… »).
- Erreur serveur Google (5xx) : le compte n'est plus délié, il suffit de réessayer.
- Options : toucher la ligne d'état (compte relié) permet de **changer de compte Google**.

## Héros
- Déblocage d'un héros : bouton **PLUS TARD** (le choix reste disponible depuis l'écran d'équipe et la fenêtre de victoire).
- **Druide** : nouvelle pose de sort de face (bâton pointé, rayon de feuilles), tirée de la planche d'actions Sylvestre non utilisée jusqu'ici. Il lui manque encore des attaques de face : à demander à Mistral (planche « actions de face » du Druide).

## Tests
- Toute la suite (67 tests) passe : réparés `test_tree` (sorts actifs du build), `test_playtime` (référence statique), `test_adventure_scroll` (taille réelle de la Sylve agrandie), `test_choreo` (variété limitée aux poses dessinées).
- Le workflow lance aussi `test_hero_unlock`, `test_cloud_save`, `test_void_pits`, `test_tree` (étape de tests portée à 10 min).
