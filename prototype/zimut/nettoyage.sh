#!/bin/bash
# Supprime les fichiers temporaires Godot accidentellement commités.
cd "$(dirname "$0")/.." || exit 1
git rm -f --ignore-unmatch zimut/data/*.tmp zimut/scenes/*.tmp zoe/scenes/*.tmp 2>/dev/null
find . -name "*.tmp" -delete
grep -qxF '*.tmp' ../.gitignore 2>/dev/null || echo '*.tmp' >> ../.gitignore
echo "Nettoyage terminé."
