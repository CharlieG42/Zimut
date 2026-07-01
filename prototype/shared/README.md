# Shared Resources

Ce dossier contient les **assets et code partages** entre les deux modes du jeu WildZimut:
- Zimut (Mode Combat)
- ZOE (Mode Aventure)

---

## Contenu Prevu

### Assets Graphiques
- Personnages: Sprites et animations communes aux deux modes
- UI: Boutons, menus, icones, polices
- Environnements: Elements graphiques reutilisables (ex: arbres, rochers)

### Sons et Musiques
- Bruitages: Sons d actions communes (ex: clics, notifications)
- Musiques: Themes partages entre les deux modes

### Code
- Scripts: Fonctions utilitaires, classes de base
- Configuration: Fichiers de configuration communs

---

## Organisation

Shared/
- characters/
- ui/
- sounds/
- scripts/
- config/

---

## Utilisation

Pour utiliser un asset partage dans un mode:
1. Importer l asset depuis ce dossier
2. Ne pas dupliquer les fichiers (toujours referencer le dossier shared/)
3. Documenter les dependances dans le README du mode concerne

---

## Notes

- Ce dossier est actuellement vide
- A remplir au fur et a mesure du developpement
- Priorite: Les assets qui sont deja presents dans Godot_iso/ et qui peuvent etre partages avec ZOE/