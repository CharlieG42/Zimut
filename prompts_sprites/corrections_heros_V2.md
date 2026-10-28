# Corrections des 5 héros — consignes pour Mistral Vibe

Priorité 1 (héros). Ordre conseillé : **Artificier → Géomancien → Invocateur → Druide → Soigneur** (du plus proche du but au plus éloigné).
Pour chaque héros, refaire **d'abord la planche `vues`**, la faire valider, puis `actions` et `actions_dos`
(les deux dernières se font **en édition de la planche vues**, pour garder le même personnage).
Fichiers : `newAssets/<nation>/<perso>_vues.png` (2048×1024), `_actions.png`, `_actions_dos.png` — mêmes noms qu'aujourd'hui, ils remplacent les anciens.

## Règles communes (à répéter dans chaque demande)

1. **Exactement 4 sprites** sur la planche vues, grille 2 × 2 : en haut 2 repos **de face** (deux attitudes différentes), en bas 2 repos **de dos** (deux attitudes différentes). Tous orientés vers la droite. Pas de gros plan, pas de tête seule, pas de vue de profil, **pas de planche de modèle (« model sheet ») avec des tailles différentes**.
2. **Même taille pour les 4 sprites** (même hauteur en pixels). Le haut du personnage et ses pieds sur la même ligne dans chaque rangée.
3. **Adulte** (priorité absolue) : mâchoire marquée, épaules larges, expression calme ou sérieuse, tête ≈ **un tiers** de la hauteur (pas 40 %), jamais un enfant ni un adolescent.
4. **L'objet tenu est dans la main**, visible dans **chaque** case (jamais posé à côté, jamais flottant, jamais absent).
5. **Style** : dessin vectoriel à **contours noirs épais** façon Dofus/Waven (pas de pixel art, pas de trait fin ni blanc, pas de rendu réaliste), **proportions chibi légères** identiques aux sprites déjà dans le jeu.
6. **Fond uni** (blanc ou gris clair), sans sol, sans ombre portée, sans texte. Grands espaces entre les sprites : rien ne se touche, objets tenus compris.
7. Les 4 sprites sont **le même personnage** (mêmes couleurs, mêmes accessoires). Seules la pose et la vue changent.

## 1. Artificier (Rouages) — `rouages/artificier_vues.png`

**Constat** : 3 sprites au lieu de 4 ; gros sprite de face **sans marteau**, deux petits sprites (dos + profil) d'une autre échelle ; visage trop enfantin (très grosse tête).
**Cible** : jeune adulte (25–30 ans), aviateur-ingénieur steampunk ; garder la couleur et l'armure déjà dessinées (cheveux châtains en pointes, lunettes de laiton relevées sur le front, armure bronze/acier avec petites gemmes turquoise #2FE0C8, ceinture à outils, bottes à bouts de laiton).

```text
Redo this character sheet as EXACTLY 4 sprites of the SAME adult steampunk engineer hero (late twenties, defined jaw, serious calm face, head one third of total height), 2x2 grid on a plain light-grey background. Top row: two different relaxed FRONT stances facing front-right. Bottom row: two different BACK views (back of the head, no face), turned toward the upper right. All 4 sprites have EXACTLY the same height, feet on one ground line per row, wide empty gaps between them.
Keep the design of the existing sheet: spiky brown hair (#6B3E1E), green eyes, brass goggles pushed up on the forehead, bronze and steel armor with small teal glowing gems (#2FE0C8), brown trousers with a tool belt and pouches, heavy brown boots with brass caps. No top hat, no gun, no cape.
HELD ITEM in the RIGHT hand, clearly visible and held by the handle in ALL 4 cells: a big hammer with a gear-shaped head. Never missing, never lying on the ground.
Style: smooth vector cartoon with thick dark outlines (Dofus / Waven), light chibi proportions, NOT pixel art, NOT realistic.
```

## 2. Géomancien (Sables) — `sables/geomancien_vues.png`

**Constat** : 2 sprites au lieu de 4 (un de face, un de dos) ; **bâton absent** ; le personnage est bien adulte (à garder), mais la carte exige une tête = 1/3 de la hauteur.
**Cible** : homme d'une trentaine d'années, barbe légère, robe sable et ocre, **bâton doré à cristal ambre dans la main droite**.

```text
Redo this character sheet as EXACTLY 4 sprites of the SAME adult desert geomancer (man in his early thirties, brown hair, light stubble, broad shoulders, defined jaw, head one third of total height), 2x2 grid on a plain white background. Top row: two different FRONT stances facing front-right. Bottom row: two different BACK views (back of the head, no face) toward the upper right. Same height for all 4 sprites, wide empty gaps.
Keep the existing design: layered sand-gold robe (#D9B26A) with terracotta panels (#B8562E) and amber gems, sand wrapped trousers, brown sandals. No hood, no turban, no hat.
HELD ITEM, RIGHT hand, visible in ALL 4 cells: a tall golden staff topped with a large faceted amber crystal (#F2A93B). It is gripped in the hand, never missing, never floating.
Style: smooth vector cartoon with thick dark outlines (Dofus / Waven), NOT pixel art.
```

## 3. Invocateur (Brumes) — `brumes/invocateur_vues.png`

**Constat** : 2 sprites au lieu de 4 ; personnage adulte avec bâton à cristal violet (très bien) mais **proportions réalistes (tête très petite)** : il paraît plus grand que les autres héros et le style diffère du reste du jeu.
**Cible** : même personnage, mais en **chibi léger** (tête = 1/3 de la hauteur, corps ramassé, grandes mains) ; garder l'air adulte et sombre.

```text
Redo this character sheet as EXACTLY 4 sprites of the SAME adult dark summoner hero (man in his late twenties, calm serious face), 2x2 grid on a plain light-grey background. Top row: two different FRONT stances facing front-right. Bottom row: two different BACK views (back of the head, no face), toward the upper right. Same height for all 4 sprites, wide empty gaps.
Proportions: light CHIBI like Dofus heroes — head one third of total height, shorter body, bigger hands and boots — NOT realistic anime proportions.
Keep the design: black medium-length hair with messy bangs (#15151C), violet eyes (#9B6BFF), pale skin, long black coat with violet trims (#7A3FD0) and silver clasps, black trousers, black boots with silver buckles. No hood, no mask, no white hair.
HELD ITEM, RIGHT hand, in ALL 4 cells: a spiked dark staff topped with a violet crystal. A small dark grimoire floats at his LEFT side, visible in each cell.
Style: smooth vector cartoon with thick dark outlines (Dofus / Waven), NOT pixel art, NOT realistic.
```

## 4. Druide (Sylvestre) — `sylvestre/druide_vues.png`

**Constat** : le bâton est **dessiné seul à côté du personnage** ; 3 éléments seulement : un sprite de face, une **tête de profil**, un sprite de dos ; visage de **jeune garçon**. Dans le jeu il a été remplacé par la pose d'attaque de la planche actions (barbu, adulte, bâton en main), qui est **meilleure** que la planche vues.
**Cible** : s'appuyer sur la **planche actions** (druide barbu, robe de feuilles, bâton en main) comme référence de personnage : homme mûr (35–40 ans), barbe courte brune-verte, cheveux verts foncés ébouriffés, robe-armure de feuilles vert mousse (#5E8C3A) et plaques d'écorce (#6B4A2B), ceinture de cuir, bâton de bois à cristal émeraude en feuille (#3FD08A).

```text
Redo this character sheet as EXACTLY 4 sprites of the SAME adult forest druid (man around 40, short dark-green beard, messy dark green hair with small leaves, calm stern face, head one third of total height, broad shoulders), 2x2 grid on a plain white background. Top row: two different FRONT stances facing front-right. Bottom row: two different BACK views (back of the head, no face), toward the upper right. Same height for all 4 sprites, wide empty gaps. NO close-up head, NO profile view, NO child or boy.
Outfit: armor-robe of overlapping moss-green leaves (#5E8C3A) and brown bark plates (#6B4A2B), dark brown trousers, brown boots wrapped with green cloth, two crossed leather belts on the chest. No hood, no cape.
HELD ITEM, RIGHT hand, gripped and visible in ALL 4 cells: a tall wooden staff topped with a leaf-shaped emerald crystal (#3FD08A). The staff is NEVER drawn alone beside the character.
Style: smooth vector cartoon with thick dark outlines (Dofus / Waven), NOT pixel art.
```

Pour `actions` / `actions_dos` du druide : la planche `actions_dos` actuelle n'a que 5 poses sur 6 (case r1c3 vide) → la refaire après validation de la planche vues.

## 5. Soigneur — Héros des Marées (`marees/soigneur_vues.png`)

**Constat** : la planche Vibe montre une **autre femme** (cheveux bleus longs, robe blanche brodée, style « fiche de modèle », bâton **posé à côté**, 3 sprites de tailles différentes). Le jeu utilise déjà (V58) la version ChatGPT : **cheveux blancs longs, oreilles pointues, robe blanche à panneaux turquoise #3CC7C0 et broderies dorées, bâton doré à goutte d'eau cristalline #7FE8FF**. Les deux ne vont pas ensemble : les poses Vibe mélangeaient les deux personnages, d'où le retour à la version V58.
**Décision à prendre** : (A) garder le héros V58 actuel (rien à refaire, le plus simple), ou (B) faire refaire tout le héros par Vibe **à partir de l'image du jeu** `prototype/zimut/assets/sprites/players/heal.png` comme référence stricte. Je recommande (A) tant que les autres héros ne sont pas finis.
Si (B) :

```text
Using the attached in-game sprite (heal.png) as the STRICT character reference — same face, same long white hair, pointed ears, same white robe with turquoise panels and gold embroidery — redo this sheet as EXACTLY 4 sprites of this SAME adult healer (a calm mature woman, head one third of total height), 2x2 grid on a plain light-grey background. Top row: two different FRONT stances facing front-right. Bottom row: two different BACK views (back of the head, no face), toward the upper right. Same height for all 4 sprites, wide empty gaps.
HELD ITEM, RIGHT hand, gripped in ALL 4 cells: a golden staff topped with a glowing water-drop crystal (#7FE8FF). Never standing alone beside her.
Style: smooth vector cartoon with thick dark outlines (Dofus / Waven), NOT pixel art, NOT a thin-line model sheet.
```

## Après chaque planche

Dépose-la dans `newAssets/<nation>/` sur la branche de Vibe et préviens-moi : je relance
`python3 tools/integrer_newassets.py <newAssets> <assets/sprites> prompts_sprites --only <nation>/<perso>`
(le rapport indique cases vides, poses trop proches, cohérence des couleurs) et je vérifie les sprites à l'œil avant de les mettre en jeu.
