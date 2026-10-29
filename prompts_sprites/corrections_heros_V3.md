# Corrections V3 — planches héros (contrôle du 2026-10-28, soir)

## Règle de référence (importante)
Les **vues de repos font foi** : les planches d'actions doivent montrer EXACTEMENT le même personnage (visage, âge, barbe, cheveux, tenue).
Référence à utiliser à chaque génération = la planche `*_vues.png` indiquée ci-dessous (sprite par sprite, méthode « fallback »).
Fond blanc uni #FFFFFF, aucun cadre, aucune ombre, personnage entier, 80 px de marge, tous regardant vers la DROITE.

## État après contrôle
| Héros | Statut | Détail |
|---|---|---|
| tank, géomancien, mage, sylvain, assassin, invocateur | ✔ intégrés | rien à faire |
| chasseur | ⚠ à reprendre | intérieur de l'arc rempli de blanc plein sur plusieurs poses (doit être TRANSPARENT/fond uni identique au fond) |
| druide | ⚠ décision | vos nouvelles *vues* montrent un garçon imberbe ; les *actions* montrent l'homme barbu. **Nous gardons l'homme barbu adulte** (anciennes vues V67) → ne pas toucher aux actions ; **ne pas** refaire les vues en garçon. |
| soigneur | ⚠ décision | vos nouvelles *vues* ont les cheveux turquoise (style enfant) ; les *actions* ont les cheveux blancs. **Nous gardons les cheveux blancs, adulte** (anciennes vues) → actions OK ; **ne pas** refaire les vues en turquoise. |
| artificier | ⚠ à reprendre | actions de FACE « attaque 1 » et « attaque 2 » : homme barbu (autre personnage). Les poses sort 1/2 et toutes les poses de dos sont bonnes. |

## Prompt 1 — artificier, attaque 1 (face) — référence : `rouages/artificier_vues.png`
Single full-body sprite, canvas 1024x1024, plain solid white #FFFFFF background, no ground, no shadow, no text.
EXACTLY the same young adult man as the reference: clean-shaven (NO beard, NO moustache), spiky brown hair, teal-green eyes, brass aviator goggles pushed up on the forehead, brown leather and brass gear-decorated armor.
Pose: ATTACK 1 — FRONT view facing right (3/4), both feet visible, wide stance, both hands swinging the gear-headed war hammer from the RIGHT side overhead, mid-strike.
Head = 1/3 of height, chibi, thick dark outlines, Dofus/Waven smooth vector style. Sprite centered, 100 px margin, taller than wide.
NEGATIVE: beard, moustache, older man, different face, second character, ground, shadow, pixel art, realistic.

## Prompt 2 — artificier, attaque 2 (face)
Same character and rules as prompt 1. Pose: ATTACK 2 — FRONT view facing right, hammer held low and swung upward from the left hip toward the right, body leaning forward, one foot lifted.
Same young clean-shaven man with goggles, NO beard.

## Prompt 3 — chasseur, 3 poses avec arc (face attaque 1/2, face sort 1 si besoin) — référence : `brasier/chasseur_vues.png`
Single full-body sprite, canvas 1024x1024, plain solid white #FFFFFF background everywhere, including INSIDE the bow (the area between the bowstring and the bow limb must be the SAME plain white background, not a filled shape, not a white sail/disc).
Same young adult woman archer as the reference: long red ponytail, red scarf, black armor with flame patterns (#C8281E), brown boots.
Curved wooden bow with flame motifs in the RIGHT hand, thin string visible, arrow nocked. Quiver on the back.
Pose: [ATTACK 1: drawing the bow, aiming right] / [ATTACK 2: releasing the arrow, hair and scarf flying] / [CAST: raising the bow with a flame glowing around the arrow].
FRONT/3-quarter view facing right, head = 1/3 of height, chibi, thick dark outlines, Dofus/Waven vector style, taller than wide, 100 px margin.
NEGATIVE: filled white bow interior, white disc behind the bow, sticker outline, ground, shadow, second character.

## Prompt 4 — chasseur, dos « attaque 2 »
Same as prompt 3 but BACK view facing upper-right, bow drawn, quiver visible on the back, red ponytail seen from behind. Entire cell must be plain white (NO dark rectangle, NO cropped character).

## Facultatif — marche
Les planches 2×2 n'ont plus de pose « marche » ni « attaque 3 ». Si vous voulez de vraies animations : un 2×2 « marche » (2 poses face + 2 dos) par héros, mêmes règles.
