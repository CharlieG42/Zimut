# NewAssets — Sprites V2 (Nations)

Planches de sprites générées avec les contraintes V2 :

1. **Personnages humains ADULTES** — style chibi conservé mais traits adultes
   (mâchoire définie, épaules larges, expression calme/sérieuse), jamais d'enfants.
2. **Taille et espacement** — chaque sprite fait au minimum 300px de large,
   avec de larges espaces entre sprites pour faciliter la découpe individuelle.
3. **Cohérence stricte** — forme, couleurs, traits et accessoires identiques
   entre toutes les planches d'un même personnage. Seules la pose, la vue
   (face/dos) et les effets évoluent.

## Structure

```
newAssets/
├── sylvestre/          # Forêt — 6 persos, planche style + vues
│   ├── sylvestre_style_sheet.png
│   ├── druide_vues.png
│   ├── araknea_vues.png
│   ├── loup_forestier_vues.png
│   ├── dryade_vues.png
│   ├── treant_vues.png
│   └── tharok_le_vegetal_vues.png
├── cimes/              # Montagne — planche style + Tank + Griffon
│   ├── cimes_style_sheet.png
│   ├── tank_vues.png
│   └── griffon_des_cimes_vues.png
├── sables/             # Désert — planche style + Géomancien
│   ├── sables_style_sheet.png
│   └── geomancien_vues.png
├── cristaux/           # Cristaux — planche style + Mage
│   ├── cristaux_style_sheet.png
│   └── mage_vues.png
├── marees/             # Marées — planche style
│   └── marees_style_sheet.png
├── vents/              # Vents — planche style
│   └── vents_style_sheet.png
├── brasier/            # Brasier — planche style
│   └── brasier_style_sheet.png
├── brumes/             # Brumes — planche style
│   └── brumes_style_sheet.png
├── ombres/             # Ombres — planche style
│   └── ombres_style_sheet.png
└── rouages/            # Rouages — planche style
    └── rouages_style_sheet.png
```

## Conventions de nommage

| Type | Format | Exemple |
|------|--------|---------|
| Planche de style (référence) | `<nation>_style_sheet.png` | `sylvestre_style_sheet.png` |
| Vues (4 cases 2×2) | `<personnage>_vues.png` | `druide_vues.png` |
| Actions de face (6 cases 3×2) | `<personnage>_actions.png` | `druide_actions.png` |
| Actions de dos (6 cases 3×2) | `<personnage>_actions_dos.png` | `druide_actions_dos.png` |

## Prochaines étapes

- [ ] Générer les planches `actions` et `actions_dos` pour chaque personnage
- [ ] Générer les vues restantes (ennemis + boss de chaque nation)
- [ ] Passe de nettoyage : détourage, découpe en sprites individuels
- [ ] Intégration dans l'Atelier (nommage `druide.png`, `druide_back.png`, etc.)

## Source des prompts

Les prompts utilisés sont dans `prompts_sprites/nations/V1/` et
`prompts_sprites/nations/0[3-9]*.md`, `10_rouages.md`, avec les 3 contraintes
V2 intégrées (adultes, 300px min, cohérence stricte).
