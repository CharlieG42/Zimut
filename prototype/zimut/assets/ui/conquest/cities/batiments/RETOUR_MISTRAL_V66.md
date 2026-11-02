# Retour sur les sprites de bâtiments Conquête (2 nov. 2026)

Complète `AUDIT_V66.md` (généré par `tools/audit_sprites_conquete.py`, à relancer après chaque lot).

## Ce qui est bon
- Style isométrique peint cohérent d'une nation à l'autre ; teintes de nation immédiatement reconnaissables.
- Séries **complètes** : Marées, Ombres, Rouages, Sables, Vents.
- Progression 1→5 lisible (tours, clocher, dôme en plus à chaque niveau). Merveille Sylvestre très réussie.

## À corriger
1. **Manquants** : voir AUDIT_V66.md (Brasier 5 bâtiments, Brumes 8 bâtiments, Cristaux hall + muraille,
   Cimes et Sylvestre : plusieurs bâtiments et niveaux). Cimes `residence.png` et Sylvestre `caserne.png`/
   `residence.png` sont encore à l'ancien nom sans niveau : à redécouper en 5.
2. **Sprites coupés** (liste dans l'audit) : demander une marge de 5 % autour de chaque bâtiment.
   Pires cas : Sylvestre muraille 1 et 3, Sylvestre cabane 1, Cimes tannerie 2, Rouages mine 5.
3. **Points de vue mélangés** (norme §1.3 « même caméra isométrique 2:1 ») : Sylvestre casernes et Rouages
   cabane/verger/tannerie sont en façade plate ; Sylvestre mine/scierie sont des plateaux paysagés beaucoup
   plus larges que l'emprise 2×2 / 3×3 de la norme.
4. **Échelle** : Sylvestre hall 4 (tour d'horloge) est très haut et étroit ; vergers et murailles Sylvestre
   trop petits par rapport à leur emprise 3×3.
5. **Liseré blanc** résiduel autour de certains sprites (Sylvestre caserne/résidence, Vents verger) : à
   générer sur fond vert chroma `#00B140` (norme §1.6) pour un détourage propre.
6. Cristaux tannerie/verger/mine niveaux 2-5 : style qui diverge du niveau 1 (couleurs et socle).

## Décision côté code
Aucun retraitement automatique des PNG : les « fragments isolés » détectés sont soit invisibles (quelques
pixels), soit volontaires (anneau flottant de la cabane Sylvestre 3). Mieux vaut régénérer que retoucher.
