# V47 — Effets visuels des sorts (lanceur + cible)

Tout est dessiné par code (aucune image ajoutée), piloté par données et borné en nombre d'effets.

## Côté lanceur
- **Charge d'incantation** (`SpellFx.Charge`) : halo qui gonfle + étincelles qui convergent vers le lanceur, à la couleur de l'élément du sort. Pour une attaque physique à distance : traits de vitesse (élan). Remplace la simple rune sur les attaques à distance ; s'ajoute à la rune sur les soins/buffs.
- **Teinte du sprite** (`EntityView.tint_flash`) : le lanceur luit brièvement de la couleur de l'élément.
- Les attaques à distance attendent 0,12 s de charge avant le tir (suit la vitesse de combat via `Engine.time_scale`).

## Trajectoire
- Projectiles par élément inchangés (flèche, éclat de glace, boule de feu, glu, orbe d'ombre, feuille, éclair).
- **Étincelle de soutien** (`Missile` « wisp ») : les soins et buffs lancés sur un allié éloigné y voyagent en arc, avec traînée.

## Côté cible
- **Teinte d'impact** : le sprite touché prend la couleur de l'élément (plus forte sur coup critique).
- **Pointes d'impact** (`SpellFx.Spikes`) : cristaux de glace, pierres, épines, rayons sacrés, étoile arcanique, éclair — table `IMPACT_SPIKES` (élément → nombre, longueur, rotation).
- **Zone d'effet** : onde de choc case par case, retardée selon la distance au centre (`Ring` à départ différé), 12 cases maximum.
- **Marques de statut** (`SpellFx.StatusMark`) selon `STATUS_VFX` (statut → style) : bouclier (défense/résistance/immunités), chevrons montants (buffs) ou descendants (ralentissement/affaiblissement), étoiles (étourdi), racines (immobilisé), gouttes (poison/saignement), braises (brûlure), tourbillon (malédiction), réticule (marque/provocation), ondulation (esquive/invisible), croix de soin (régénération), couronne (chef). Repli automatique : chevrons haut/bas selon le statut positif/négatif. Ajouter un statut = une ligne.
- **Soin** : teinte verte + croix montantes en plus du pilier de lumière.
- L'événement `status` transporte maintenant l'identifiant du statut (`id`).

## Performance
- Couche d'effets plafonnée (`_fx_ok`) : les effets secondaires sont omis au-delà de 70/90 nœuds.
- Tous les nœuds se libèrent seuls ; vérifié par test (retour au repos après une salve de 6 sorts + 5 statuts).

## Tests
- `tests/test_spell_vfx.gd` : couverture des statuts, libération des nœuds, couche FX bornée puis revenue au repos.
- `tests/shot_spell_vfx.gd` : captures (charge + boule de feu de zone, impact, soin à distance, statuts).

## Limites
- Rendu de captures sous xvfb : à valider sur téléphone (lisibilité en vitesse de combat rapide).
- Le sprite est teinté par multiplication : les teintes sombres (ombre) assombrissent légèrement le sprite.
- Pas de sons nouveaux.
