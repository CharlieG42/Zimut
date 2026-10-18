# V20 — Boss des Nations illustrés, page « Mes Parties » compacte et traduisible

## Boss des Nations
- Les 9 boss de la planche « Boss des Nations » (`assets/sprites/_sheets/planche_boss.png`) sont détourés
  dans `assets/sprites/nations/boss/<nation>.png` (`tools/extract_bosses.py` : rembg isnet-general-use,
  alpha durci ; Zyphéron par GrabCut car son fond lavande est trop proche du personnage).
- Le boss attitré de chaque biome prend le nom et le portrait de la planche :
  Tharok le Végétal (Sylvestre), Vorkann le Givre (Cimes), Zahor le Sableux (Sables),
  Zyphéron le Cristallin (Cristaux), Néréa la Tempête (Marées), Aéron le Céleste (Vents),
  Kharaz le Flamboyant (Brasier), Ombrelis le Brumeux (Brumes), Nébulia l'Illusionniste (Ombres).
- Le kit de combat, les PV et les récompenses ne changent pas (le boss garde son type d'origine en interne).
  Les boss du Donjon (Roi Squelette, Squelette Seigneur) gardent leur apparence.
- Le bestiaire et l'annonce « Prochain combat : ☠ BOSS … » utilisent le nouveau nom.

## Page « Mes Parties »
- Les 6 boutons illustrés (Gérer l'équipe, Personnages, Forge, Gouverneurs, Renommer, Supprimer) sont
  des plaques SANS texte (`assets/ui/actions/plain_*.png`, `tools/gen_action_buttons.py`) ; le libellé
  est écrit par le jeu, donc traduit en anglais, avec une taille de police ajustée à la largeur.
- Mise en page compacte : boutons sur 2 lignes de 3, cartes de mode moins hautes, Succès / Bestiaire /
  Exporter sur une même ligne. Tout tient à l'écran sans défilement (taille de texte normale).
