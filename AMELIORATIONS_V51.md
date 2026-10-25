# V51 — Sauvegarde Cloud : portée drive.file

Google refuse la portée `drive.appdata` pour la connexion par code (« invalid_scope : Invalid device flow scope »).
Le jeu utilise maintenant **`drive.file`** : il ne peut lire et écrire **que les fichiers qu'il a lui-même créés** (aucun accès au reste du Drive).

- La sauvegarde est le fichier **`zimut_backup.json`** à la racine de « Mon Drive » (visible ; ne pas le supprimer ni le renommer : il sert à la restauration). Il est mis à jour à chaque sauvegarde (un seul fichier).
- Console Google : **Google Auth Platform → Accès aux données → Ajouter ou supprimer des niveaux d'accès** : cocher / coller `https://www.googleapis.com/auth/drive.file` (la portée `drive.appdata` peut être retirée).
- Rien à changer côté client OAuth ni secrets GitHub.
