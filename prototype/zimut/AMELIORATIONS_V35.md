# V35 — Animation procédurale réglable par personnage

L'animation procédurale d'`EntityView.gd` (respiration, petits sauts de marche, fente
d'attaque, saut de sort) utilisait des constantes communes à tous les personnages.
Elles sont maintenant réglables **par sprite**, sans toucher au code.

## Fichier de réglages

À côté du sprite de repos, un fichier `<sprite>_anim.txt` (JSON) surcharge tout ou
partie des valeurs ; les clés absentes gardent la valeur par défaut :

```json
{ "respiration": 0.02, "rebond_marche": 4, "elan_attaque": 40 }
```

| Clé | Défaut | Effet |
|---|---|---|
| `respiration` | 0.014 | amplitude d'échelle verticale au repos |
| `flottement` | 1.6 | montée/descente au repos (px) |
| `vitesse_repos` | 2.2 | pulsation du repos (rad/s) |
| `balancement` | 0.018 | oscillation de rotation au repos (rad) |
| `rebond_marche` | 9 | hauteur des sauts de marche (px) |
| `ecrasement_marche` | 0.07 | écrasement à chaque appui |
| `penche_marche` | 0.10 | inclinaison en marchant |
| `elan_attaque` | 26 | avancée de la fente (px) |
| `recul_attaque` | 8 | armé avant la fente (px) |
| `etirement_attaque` | 1.0 | multiplicateur de l'étirement d'élan |
| `saut_sort` | 12 | saut au lancement d'un sort (px) |

- Extension `.txt` : déjà incluse à l'export Android (`include_filter="*.txt"`).
- Valeurs bornées (un réglage extrême ne casse pas l'affichage), lues une fois par
  sprite puis mises en cache.
- Sans fichier : comportement identique à la V34.

Ces fichiers sont produits par **SpriteBuilder** (Atelier Sprites) : l'aperçu des
animations permet de régler les valeurs à l'œil, et l'export les range dans le zip à
côté des PNG.

Test : `godot --headless -s tests/test_anim_params.gd`.
