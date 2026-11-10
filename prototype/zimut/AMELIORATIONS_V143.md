# V143 — Passe visuelle 3D : Sylve, Brasier, Brumes

Même esprit que la passe des Cimes (V142), sans nouvel asset et sans géométrie ajoutée, sauf un rond de sol
par arbre (un seul dessin par zone). Tout passe par la palette 3D de chaque Nation (`Adv3DWorld.PALETTES`).

| Nation | Sol | Herbe et fleurs | Pied des arbres | Lumière |
|---|---|---|---|---|
| Sylve | verts moins fluo, du vert mousse au vert tendre, plaques plus sombres | brins légèrement désaturés | litière de feuilles | soleil doré plus franc, saturation 0,93 |
| Brasier | terre de cendre gris-brun (le rouge reste à la lave, aux braises et au ciel) | herbe sèche rare, couleur paille brûlée (densité 0,24) | cendre noire | soleil et ambiance moins rouges, saturation 0,92 |
| Brumes | plus profond, plaques de tourbe sombre | joncs vert olive ; fleurs pâles et froides à la place des bouquets jaunes et roses | tourbe détrempée | inchangée |

Nouvelles clés de palette, toutes facultatives : `ring` (couleur et opacité du rond au pied des arbres),
`tuft3d` (teinte de l'herbe en 3D), `tuft_mul` (multiplicateur pour l'herbe des anciens biomes),
`flowers3d` (couleurs des fleurs en 3D), `macro` (teinte des grandes plaques du sol). Le rond des Cimes
(V142) passe par la même clé. Les arbres de Nation concernés sont listés dans `RING_NATION_KINDS`.

Triangles par image sur la vue de test, avant → après : Sylve 329 531 → 333 939 ; Brasier 279 195 → 289 516 ;
Brumes 357 649 → 364 542. La hausse vient des ronds au pied des arbres. Non mesuré sur téléphone.
