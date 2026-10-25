# V53

- **Fiche de partie** : le niveau du joueur est affiché à côté du nom (« ✦ Doline · Niv. 4 »).
- **Artificier – bombes** : rayon d'explosion de 2 cases (losange). Une explosion inflige :
  - dégâts pleins aux ennemis et aux autres bombes de la zone ;
  - dégâts réduits de moitié aux alliés (lanceur compris).
  Une bombe détruite (par une explosion ou une attaque) explose à son tour → réactions en chaîne.
  Test : `tests/test_bomb_chain.gd`.
- **HUD de combat** : garde-fou (`UIManager.ensure_hud_layout`) vérifié toutes les 0,3 s, à la reprise
  de l'appli et au redimensionnement : réapplique la mise en page de la barre de sorts / timeline /
  portrait si elle est déformée, et reconstruit la barre de sorts si elle est vide.
  Outil de diagnostic : `tests/monitor_hud.gd`, test : `tests/test_hud_guard.gd`.
