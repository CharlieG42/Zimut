# Topo Zimut V65 — à lire en début de nouvelle session

## Contexte
Repo : `CharlieG42/Zimut` (clone local : `/workspace/github__CharlieG42__Zimut`).
On travaille sur les sprites isométriques des villes de Conquête (10 nations × 10 bâtiments × 5 niveaux).

## Branches / PRs clés
- `main` : prod.
- `vibe/v65-reprise-planches-f375ae` → **PR #216 MERGEE**. Contient :
  - `prompts_sprites/villes/prompts_v65_reprise/` : **69 prompts prêts** (`<nation>_<batiment>.txt` + README), avec les 10 règles dures + carte d'identité de chaque nation.
  - `tools/slice_city_sprites.py` (dans `prototype/zimut/`) version **v214 rendue générique** : toute planche déposée dans `prototype/zimut/assets/ui/conquest/cities/batiments/planches/<nation>/` est découpée automatiquement en `row5` (ou `single` pour `merveille`).
  - `RETOUR_MISTRAL_V65.md` (dans `.../batiments/`) : statut des 80 planches, problème précis des 61 à refaire.
- `feature/ville-decoupe-v65` → PR #214 mergée (découpe v214 d'origine).
- PRs ouvertes sans rapport : #223, #224, #225 (V72) — ne pas y toucher.

## Ce qui est déjà fait et validé
- **brasier/hall_1..5** et **brumes/hall_1..5** : re-générés + découpés, contrôle 5 composantes / 0 pixel au bord / visuel 10/10.
- Sprites en jeu actuellement : brasier 46, brumes 46, cristaux 21, rouages 16, sylvestre 17, cimes 16, ombres 6, marees/sables/vents 1 (merveille seule).

## Mission : finir les ~67 planches restantes
Ordre conseillé : hall (marees, rouages, sables, vents, sylvestre, cimes) → caserne, residence, mine, muraille → scierie, tannerie, cabane, verger → merveilles (sylvestre, cimes) en dernier.
Nations : brasier, brumes, cristaux, marees, ombres, rouages, sables, vents, sylvestre (Forêt), cimes (Montagne).
Bâtiments : hall, caserne, residence, mine, scierie, tannerie, cabane, verger, muraille, merveille.

## Pipeline par planche (CRITIQUE : l'utilisateur exige des images ENTIERES, jamais coupées/tronquées)
1. Générer l'image avec le prompt `prompts_sprites/villes/prompts_v65_reprise/<nation>_<batiment>.txt` (outil de génération d'images de la session — s'il répond « Unknown hidden tool », le signaler, ne pas inventer).
2. Sauvegarder : `prototype/zimut/assets/ui/conquest/cities/batiments/planches/<nation>/<nation>_<batiment>.jpg`
3. **Contrôle qualité obligatoire** (rejeter et regénérer si KO) :
   `python3 /tmp/v65_gen/check_planche.py <fichier.jpg>` → OK = exactement 5 composantes séparées + 0 pixel au bord + marges ≥ ~10%. Un rejet = image coupée ou < 5 niveaux.
   (Si `/tmp` est vidé : recréer le script, il tient en 25 lignes, cf. historique — ou demander.)
4. Découper : `cd prototype/zimut && python3 tools/slice_city_sprites.py assets/ui/conquest/cities/batiments --v65` (ajoute `--only <nation>` pour tester).
5. Vérifier visuellement que chaque `<batiment>_<n>.png` contient UN seul bâtiment complet (pas de fragment, pas de texte flottant, pas de morceau de voisin).
6. Créer les `.import` Godot pour chaque nouveau PNG (format CompressedTexture2D, voir les fichiers existants à côté).
7. `python3 tools/check_assets.py` → doit finir par « OK : N ressources importées, toutes suivies par git. »
8. Commit + push sur `vibe/v65-reprise-planches-f375ae` : `git add -A && git commit -m "V65 <nation> <batiment> 1-5 OK" && git push origin vibe/v65-reprise-planches-f375ae`

## Règles dures des prompts (déjà dans les fichiers, à respecter si régénération)
5 niveaux en UNE rangée horizontale ; gap de fond entre chaque socle (ni toucher ni chevaucher) ; socle isolé même emprise (3x3 pour hall/mine/verger/muraille/merveille, 2x2 pour les autres) ; fond blanc pur #FFFFFF même pour Marées/Vents (PAS de chroma vert #00B140) ; aucun texte/chiffre ; pas d'ombre portée ni bandeau noir ; pas de feuillage de la teinte du fond ; même échelle d'un niveau à l'autre ; **marge ≥ 12% sur les 4 bords** (rien ne touche le bord de l'image).

## Pièges observés (à surveiller)
- Mistral colle parfois les 5 bâtiments en un bloc (1 composante) → rejeter.
- Mistral touche le bord gauche/droit → rejeter (règle 12%).
- Mistral met du texte flottant (« Manor plus », « Level 1 ») → rejeter.
- Parfois 4 bâtiments au lieu de 5 → rejeter.
- La découpe v214 peut produire des fragments si la planche source est mauvaise → le contrôle étape 3 évite ça.

## Commandes utiles
```bash
cd /workspace/github__CharlieG42__Zimut
git checkout vibe/v65-reprise-planches-f375ae
ls prompts_sprites/villes/prompts_v65_reprise/          # les 69 prompts
ls prototype/zimut/assets/ui/conquest/cities/batiments/planches/<nation>/
cd prototype/zimut && python3 tools/slice_city_sprites.py assets/ui/conquest/cities/batiments --v65 --only <nation>
python3 tools/check_assets.py
gh pr view 216 --repo CharlieG42/Zimut                   # état de la PR
```
