# V21 — Équipement des héros, Inventaire, fenêtre d'annexion

## 1. Onglet « Équipement » (fiche Personnages)
- Nouveau bouton **ÉQUIPEMENT**, à côté de *Sorts* : 10 emplacements (arme, bouclier, casque, armure, bottes, bague, collier, gants, boucle d'oreille, cape), objet porté, bonus cumulés et panoplies.
- **ÉQUIPER / CHANGER** ouvre la liste des objets libres compatibles, triés par puissance, avec le gain par rapport à l'objet porté (+21 / −3) ; niveau requis indiqué en rouge.
- Fonctionne pour **tous** les héros, dans l'équipe ou non (`ProgressionManager.hero_equipment`, `equip_hero_item`, `unequip_hero_item`). L'équipement d'un héros hors équipe est stocké dans le roster.
- **Gouverneurs** : le stuff compte pour la ville — +1 défense par 10 de puissance (max +20) et +1 or par victoire pour 60 de puissance (max +4). Affiché dans la fiche de la ville et dans l'onglet.
- Un héros écarté de l'équipe rend son stuff à l'inventaire (comportement inchangé), **sauf** s'il est gouverneur : il le garde. Un héros qui revient dans l'équipe retrouve son stuff.
- La Forge (onglet Améliorer) voit aussi le stuff des héros hors équipe.

## 2. Fenêtre « Inventaire » (Mes Parties)
- Bouton **🎒 Inventaire** à côté de Succès / Bestiaire.
- Liste **tous** les objets : libres et portés (« Porté : Assassin »).
- Filtres : type (10), rareté (4), statut (tous / libres / portés). Tri : rareté, niveau, puissance, type, nom, croissant/décroissant.
- Sélection multiple par case à cocher, « Tout (affichés) » / « Aucun ».
- **Envoyer au Briseur** : confirmation (avertit pour les objets portés et épiques/légendaires), puis brise le lot et affiche les ressources obtenues. Un objet porté est retiré à son porteur avant d'être brisé.
- **Briser puis Fusion** : brise le lot puis ouvre la Forge directement sur l'onglet Fusion (les ressources obtenues s'y fondent). La Fusion du jeu concerne les ressources, pas les objets : c'est pourquoi la fusion passe par le Briseur.

## 3. Fenêtre d'annexion (Conquête)
- La fenêtre « VILLE ANNEXÉE ! » était posée directement sur la couche de la carte : elle se collait en haut à gauche, coupée par le bord. Elle est maintenant dans un conteneur de centrage plein écran.

## Tests
`test_hero_gear.gd`, `test_inventory_ui.gd` (nouveaux) ; captures `shot_inventory.gd`, `shot_annex.gd`, `shot_result_conq.gd`.
