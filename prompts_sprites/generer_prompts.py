#!/usr/bin/env python3
"""Génère les prompts de sprites chibi de Zimut (un fichier Markdown par nation + familiers + mécanismes).

Usage :  python3 prompts_sprites/generer_prompts.py
Modifier une description : éditer les dictionnaires ci-dessous puis relancer le script.

V44 — format « 3 planches par personnage » (héros, ennemis, boss, familiers), noms de fichiers du jeu :
- Planche VUES (4 cases, génération normale) : repos de FACE ×2 (deux attitudes différentes) puis repos de
  DOS ×2. Tout est orienté vers la droite : le jeu retourne l'image pour la gauche (les quarts de tour de
  la V40-V43 donnaient des profils et des vues vers la gauche inutilisables, et des doublons).
  Fichiers : <nom>.png, <nom>_idle_2.png, <nom>_back.png, <nom>_back_idle_2.png.
- Planche ACTIONS DE FACE (6 cases, en ÉDITION de la planche vues) : 3 attaques, 2 sorts, 1 marche,
  toutes en 3/4 avant droite. Fichiers : _attack, _attack_2, _attack_3, _cast, _cast_2, _walk.
- Planche ACTIONS DE DOS (6 cases, en édition, mêmes 6 poses vues de dos) : _back_attack, _back_attack_2,
  _back_attack_3, _back_cast, _back_cast_2, _back_walk. Facultative pour les monstres (le jeu retombe
  sur les poses de face). Une planche = UN seul sens de vue : quand face et dos étaient sur la même
  planche, le générateur dessinait tout de face.
- ARME : la ligne WEAPON n'existe que pour les personnages armés, placée dès la première phrase.
  Les créatures reçoivent « UNARMED » : l'ancien ordre générique « mains jamais vides » faisait
  inventer des torches et des armes aux monstres (Salamandre, Dévoreur de flammes).
- Retour V43 (le Chasseur tenait un bâton en attaque) : l'arme est répétée dans CHAQUE pose d'action.
Historique : V40-V43 = planche vues à 4 quarts de tour, actions face/dos sur une même planche,
édition corrective de l'arme.
Chaque prompt commence par la carte d'identité du personnage (identites.py), recopiée mot pour
mot, pour que toutes les planches dessinent le même personnage sans image jointe.
Noms de fichiers : convention du jeu (scripts/EntityView.gd : <nom>_back_attack, pas <nom>_attack_back).
"""
import sys
import re
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from identites import IDENT, card  # noqa: E402

OUT = Path(__file__).resolve().parent

# --------------------------------------------------------------------------------------------
# Vocabulaire « modération » (V57) : Mistral bloque ou reformule les prompts qui contiennent des mots
# de violence ou d'armes (et supprimait alors l'arme du personnage). Les prompts écrits dans les .md
# passent par `soften` : mêmes consignes, mots neutres. Les fonctions de génération gardent les mots
# d'origine (le contrôle qualité les teste), seul le texte publié est adouci.
# --------------------------------------------------------------------------------------------
SOFT = [
    (r"WEAPON CHECK", "ITEM CHECK"), (r"WEAPON LOCK", "ITEM LOCK"), (r"\bWEAPON\b", "HELD ITEM"),
    (r"\bUNARMED\b", "NO HELD ITEM"), (r"\bunarmed\b", "item-free"),
    (r"\bweapons\b", "held items"), (r"\bWeapon\b", "Held item"), (r"\bweapon\b", "held item"),
    (r"\barmed with\b", "carrying"), (r"\barmed\b", "equipped"),
    (r"\bdaggers\b", "short curved blades"), (r"\bDAGGERS\b", "SHORT CURVED BLADES"),
    (r"\bdagger\b", "short curved blade"), (r"\bDAGGER\b", "SHORT CURVED BLADE"),
    (r"\bwar hammer\b", "heavy hammer"), (r"\bWAR CRY\b", "BATTLE SHOUT"),
    (r"\bSMASH\b", "STRIKE"), (r"\bsmash\b", "strike"), (r"\bSLAM\b", "DRIVE"), (r"\bslammed\b", "driven"),
    (r"\bslam\b", "drive"), (r"\bSTAB\b", "THRUST"), (r"\bSLASH\b", "SWEEP"), (r"\bslash\b", "sweep"),
    (r"\bPOINT-BLANK KICK\b", "CLOSE LEG LIFT"), (r"\bKICK\b", "LEG LIFT"), (r"\bkicking\b", "lifting"),
    (r"\bBLAST\b", "BURST"), (r"\bblast\b", "burst"),
    (r"\bbombs?\b", "round charge"), (r"\bBOMB\b", "ROUND CHARGE"),
    (r"it fights only with its own body \(claws, teeth, fists, tail, magic\)",
     "it acts only with its own body (claws, fists, tail, magic)"),
    (r"\bfights\b", "acts"), (r"\bfight\b", "act"), (r"\bkill(s|ed|ing)?\b", "defeat"),
    (r"\bblood\b", "red paint"), (r"\bdeath\b", "defeat"),
]


def soften(text):
    for pat, rep in SOFT:
        text = re.sub(pat, rep, text)
    return text


def soften_fences(md):
    """Adoucit uniquement le contenu des blocs ```text``` (les prompts), pas la documentation en français."""
    return re.sub(r"```text\n(.*?)```", lambda m: "```text\n" + soften(m.group(1)) + "```", md, flags=re.S)

GAME = "prototype/zimut/assets/sprites"

# --------------------------------------------------------------------------------------------
# Blocs communs (anglais : les générateurs d'images suivent mieux l'anglais)
# --------------------------------------------------------------------------------------------
STYLE = (
    "Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), "
    "short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. "
    "Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 "
    "tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather "
    "straps), saturated but harmonious colors, strong readable silhouette at small size. "
    "Soft key light from the upper left, with only a thin subtle {rim} highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell)."
)
OBJ_STYLE = (
    "Polished 2D game art inspired by Dofus and Waven, matching chibi character sprites: clean bold dark "
    "outlines, 3-tone cel shading, crisp material details, saturated harmonious colors, slightly cute "
    "rounded proportions, readable at small size. Soft key light from the upper left."
)
# Verrou de style : une planche est sortie en pixel art (griffon) au milieu de planches en dessin vectoriel.
STYLE_LOCK = (
    "STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu "
    "character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a "
    "painterly or soft-edged style, never a thin or white outline."
)
# Mots de description qui imposent le fond gris (blanc sur blanc : le découpage mange la fourrure, la tête…).
PALE_WORDS = ("white", "snow", "pale", "silver", "ivory", "bone", "cream", "frost", "ice ")
BG_WHITE = "Pure flat white background (#FFFFFF) — not cream, not beige, not ivory"
BG_GRAY = "Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it)"
BG_TAIL = (", no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, "
           "no numbers, no arrows, no frame or border lines."
           )
# Verrou arme : l'arme de la classe ne doit jamais changer d'une planche (ou d'une case) à l'autre.
NEGATIVE = (
    "checkerboard, transparency grid, text, letters, labels, numbers, watermark, signature, "
    "overlapping characters, touching poses, cropped limbs, character cut by the cell edge, "
    "effects crossing into another cell, weapon crossing into another cell, side profile view, facing left, "
    "inconsistent scale, different outfit between cells, weapon switching hands, extra arms, extra fingers, "
    "blurry smoke, semi-transparent effects, soft glow halo, floor, cast shadow, gradient background, "
    "golden glow, light flare, sun rays, color tint over the sprite, glowing aura on one side, cream background, "
    "beige background, colored background, ground shadow ellipse, "
    "photorealistic, 3D render, pixel art, frames around poses, boxes, borders, dividing lines, grid lines, "
    "pixel grid, low-resolution pixels, painterly soft brush style, mirror image of another sprite, flipped copy, "
    "copy of the source pose, "
    "isometric floor grid, tiles, duplicate poses in the same viewing angle, identical poses side by side, "
    "the same pose copied twice in the same view, front and back mixed inside one cell, "
    "weapon changing shape, weapon changing color, weapon replaced by another weapon, missing weapon, "
    "missing accessories, closed eyes, looking up at the sky, different hair color, different eye color, "
    "different hairstyle, new clothing pieces, weapon drawn alone without the character, extra objects, "
    "different character between poses, realistic proportions, small head"
)
# Planche VUES : le négatif commun + les erreurs de comptage observées (10 sprites au lieu de 4).
NEGATIVE_VUES = (
    NEGATIVE + ", more than 4 sprites, extra sprites, only 3 sprites, empty cell, duplicated row of sprites, "
    "one sprite bigger or smaller than the others, size changing between cells, mirror image of another "
    "sprite, flipped copy, left-right mirrored pair, four identical front views, back row drawn from the front, "
    "low-resolution pixels, pixel grid"
)
# Créatures sans arme : jamais d'objet tenu (les torches inventées de la Salamandre et du Dévoreur).
# Le négatif commun parle d'« arme manquante » : pour une créature on retire ces termes (un négatif qui
# nomme une arme peut la faire apparaître) et on interdit au contraire tout objet tenu.
def _no_weapon_terms(neg):
    keep = [t for t in neg.split(", ") if not any(w in t for w in ("weapon", "accessories", "empty hands"))]
    return ", ".join(keep)


NEGATIVE_UNARMED = ("weapon, torch, staff, sword, bow, held object, tool, item in the hands or claws")
NEGATIVE_CREATURE_VUES = _no_weapon_terms(NEGATIVE_VUES) + ", " + NEGATIVE_UNARMED
NEGATIVE_CREATURE_ACTIONS = _no_weapon_terms(NEGATIVE) + ", " + NEGATIVE_UNARMED

# Planche VUES : 4 poses en 2 colonnes × 2 rangées sur image 2:1, « autocollants » largement
# espacés (la largeur horizontale compte surtout : elle facilite la découpe).
VUES_LAYOUT = (
    "4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), "
    "like four separate stickers floating on the background. Each pose occupies at most 55% of the width and "
    "height of its quarter of the image and is centered in it, so that there is a wide empty space, especially "
    "horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay "
    "inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide "
    "effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per "
    "cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same "
    "size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than "
    "the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing "
    "lines between poses, no floor, no grid on the ground."
)

# Planche ACTIONS : 6 poses en 3 colonnes × 2 rangées sur image 2:1.
ACTIONS_LAYOUT = (
    "6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), "
    "like six separate stickers floating on the background. Each pose occupies at most 55% of the width and "
    "height of its sixth of the image and is centered in it, so that there is a wide empty space, especially "
    "horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay "
    "inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide "
    "effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, "
    "same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is "
    "wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between "
    "poses, no floor, no grid on the ground."
)

# Vue 3/4 avant droite (rangée du haut de la planche actions ; le jeu retourne l'image pour la gauche)
FACE_VIEW = ("3/4 FRONT view: the character faces the viewer and turns slightly to the right "
             "(face, chest and right side visible), facing front-right in every pose")
# Vue 3/4 dos droite (rangée du bas de la planche actions)
BACK_VIEW = ("3/4 BACK view: the character is seen from behind and turns slightly to the right "
             "(back of the head and right shoulder visible), facing away from the viewer toward "
             "the upper right; we see the BACK of the head: no face, no eyes")

# (ancienne description des 4 angles, remplacée en V44 — voir VIEWS4 ci-dessous)
# Les 4 angles de la planche vues : (suffixe de fichier, libellé, description de l'angle).
# La caméra ne bouge pas : le personnage fait des quarts de tour (90°) entre les cases —
# d'où 2 vues plutôt de face (1, 4) et 2 plutôt de dos (2, 3). Le décompte des quarts de
# tour et la position de case sont écrits dans la description : le générateur a montré
# (retour V40) qu'il mélangeait les angles et survirait l'un d'eux sans ça.
VIEWS4 = [
    ("", "repos de face",
     "FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest "
     "and right side visible), facing front-right; both eyes visible; standing calm"),
    ("_idle_2", "repos de face, variante",
     "FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — the free "
     "hand rests on the hip, the head is turned slightly toward the right, the weight is on the other leg (the "
     "weapon stays in its hand); the face is visible and the drawing must not be a copy of cell 1"),
    ("_back", "repos de dos",
     "BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right "
     "shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile"),
    ("_back_idle_2", "repos de dos, variante",
     "BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — the free "
     "hand rests on the hip, the head is turned slightly to the left, the weight is on the other leg (the weapon "
     "stays in its hand); no face, no eyes; the drawing must not be a copy of cell 3"),
]
# Position de chaque angle dans la grille 2 × 2 (l'ordre des cases n'était pas respecté en V40).
VIEWS4_POS = ["TOP-LEFT", "TOP-RIGHT", "BOTTOM-LEFT", "BOTTOM-RIGHT"]  # haut = de face, bas = de dos


# --------------------------------------------------------------------------------------------
# Archétypes de combat : 6 attaques et 3 poses de sort par archétype
# --------------------------------------------------------------------------------------------
ARCH = {
    # 6 attaques aux silhouettes toutes différentes (A0 coup haut, A1 poussée vers l'avant, A2 coup de côté,
    # A3 saut, A4 coup bas, A5 coup spécial) et 3 sorts (C0 concentration, C1 bras levés, C2 projection).
    "hammer_shield": dict(
        atk=["OVERHEAD SMASH: hammer raised high above the head with both arms up, shield on the back arm",
             "SHIELD CHARGE: body leaning far forward, shield thrust in front, hammer pulled back low",
             "SIDE SWING: hammer swept horizontally to the side at full arm length, torso twisted",
             "JUMPING SLAM: whole body in the air, knees tucked, hammer above the head",
             "LOW SWEEP: crouched on one knee, hammer swinging just above the ground",
             "GROUND QUAKE: hammer slammed into the ground in front, a ring of {fx} bursting around it"],
        cast=["BRACING: shield planted on the ground in front, head down, {fx} gathering at the feet",
              "WAR CRY: mouth open, hammer raised straight to the sky, {fx} swirling above",
              "AURA: arms spread wide, a dome of {fx} around the body"]),
    "daggers": dict(
        atk=["CROSS SLASH: both daggers crossed high above the head, about to strike down",
             "LUNGE STAB: body stretched forward almost horizontal, one dagger thrust far ahead",
             "SPIN: body twisted, arms spread to both sides, short {fx} slash arcs",
             "LEAP: whole body in the air, knees tucked, daggers pointed down",
             "LOW SWEEP: crouched very low on one knee, one dagger slashing near the ground",
             "THROW: one arm extended after throwing a dagger, the dagger flying ahead with a {fx} trail"],
        cast=["SHADOW KNEEL: kneeling, one hand on the ground, {fx} rising around",
              "VANISH: half the body dissolving into {fx}, only the eyes and daggers clear",
              "MARK: one arm pointing forward, a {fx} sigil appearing in front of the hand"]),
    "bow": dict(
        atk=["SKY SHOT: bow pointed almost straight up, string fully drawn",
             "FULL DRAW: bow aimed straight forward, string pulled to the cheek, body sideways",
             "RELEASE: string hand open behind, bow arm extended, arrow leaving with a {fx} trail",
             "JUMPING SHOT: whole body in the air, aiming down and forward",
             "KNEELING SHOT: on one knee, bow held low and tilted",
             "POINT-BLANK KICK: bow held back, one leg kicking high forward"],
        cast=["ENCHANTED ARROW: arrow held up to the face, its tip wrapped in {fx}",
              "VOLLEY: bow raised overhead, three {fx} arrows rising into the air",
              "TRAP: crouched, placing a {fx} trap on the ground with the free hand"]),
    "staff": dict(
        atk=["OVERHEAD STRIKE: staff raised high above the head with both hands",
             "THRUST: body leaning forward, staff tip pushed far ahead with a short {fx} spark",
             "SIDE SWING: staff swept horizontally at shoulder height, torso twisted",
             "JUMPING STRIKE: whole body in the air, staff held back over the shoulder",
             "LOW SWEEP: crouched, staff swinging at ankle height",
             "SPIN: staff whirling around the body, a {fx} trail circling it"],
        cast=["FOCUS: eyes closed, staff held vertically in front of the face, {fx} orb at the top",
              "INVOCATION: staff raised high with both hands, {fx} swirling above the head",
              "BLAST: staff pointed forward, a compact {fx} blast leaving the tip"]),
    "staff_book": dict(
        atk=["OVERHEAD STRIKE: staff raised high above the head, grimoire floating behind",
             "PALM BOLT: free arm stretched forward, a {fx} bolt leaving the open palm",
             "SIDE SWING: staff swept horizontally, coat swirling",
             "GRIMOIRE SLAM: grimoire snapping shut in front, a small {fx} shockwave",
             "LOW SWEEP: crouched, staff swinging near the ground",
             "CLAWS: free hand raised as a claw, {fx} claws forming in front"],
        cast=["READING: grimoire floating open in front, pages turning, {fx} rising from it",
              "SUMMONING CIRCLE: staff raised, a {fx} circle drawn on the ground",
              "SUMMON: both arms open wide, a {fx} creature silhouette emerging beside"]),
    "wrench": dict(
        atk=["OVERHEAD SMASH: gear hammer raised high above the head with both hands",
             "BOMB THROW: free arm extended forward after throwing a small round bomb",
             "SIDE SWING: gear hammer swept horizontally, goggles bouncing",
             "JUMPING SMASH: whole body in the air, hammer above the head",
             "LOW SWEEP: crouched, hammer swinging near the ground with sparks",
             "SHOULDER CHARGE: body leaning far forward, hammer held back, {fx} puffs behind"],
        cast=["TINKERING: kneeling, adjusting a small device on the ground, {fx} crackling",
              "REMOTE: standing, raising a glowing remote control high, {fx} arcing around",
              "OVERLOAD: arms spread, a {fx} ring around the body"]),
    "beast": dict(
        atk=["REARING: standing up on the hind legs, front claws raised high",
             "POUNCE: body stretched forward in the air, jaws open",
             "SIDE SWIPE: head and claws swept to the side, body twisted",
             "BITE DOWN: head low near the ground, jaws snapping",
             "TAIL WHIP: body turned, tail lashing forward",
             "CHARGE: head down, running forward, {fx} trail behind"],
        cast=["HOWL: head raised to the sky, {fx} gathering around the body",
              "ROAR: mouth wide open, {fx} burst in front of the head",
              "BREATH: a short {fx} breath released forward"]),
    "brute": dict(
        atk=["OVERHEAD SMASH: both fists or weapon raised high above the head",
             "PUNCH: one arm thrust far forward, the other pulled back, body leaning forward",
             "BACKHAND: arm swept horizontally to the side, torso twisted",
             "JUMPING SLAM: whole body in the air, fists above the head",
             "STOMP: one foot raised then slammed down, {fx} cracks under it",
             "CHARGE: shoulder first, body leaning far forward, running"],
        cast=["ROOTED: stomping, {fx} cracks spreading under the feet",
              "GATHER: arms raised, {fx} gathering between the hands",
              "SHOCKWAVE: both fists slammed into the ground, {fx} wave"]),
    "spirit": dict(
        atk=["RISE: body stretched tall upward, arms raised",
             "LUNGE: body stretched forward, claws of {fx} reaching out",
             "SPIN: body whirling, {fx} trail around it",
             "DIVE: body diving down, compact",
             "DOUBLE SWIPE: both arms crossed in front, claws out",
             "FAN: body opening into a fan of {fx} blades in front"],
        cast=["HOVER: floating higher, {fx} orbs circling",
              "PULSE: arms spread, {fx} pulsing outward",
              "WAVE: a compact {fx} wave released forward"]),
}

# Cases des planches actions : (suffixe de fichier, code, libellé). A = attaque, C = sort, W = marche.
# Deux planches identiques en poses : l'une de face, l'autre de dos (un seul sens de vue par planche).
ACTION_POSES = [("_attack", "A0", "attaque 1"), ("_attack_2", "A1", "attaque 2"), ("_attack_3", "A2", "attaque 3"),
                ("_cast", "C0", "sort 1"), ("_cast_2", "C1", "sort 2"), ("_walk", "W", "marche")]
ACTIONS_FACE = ACTION_POSES
ACTIONS_BACK = [("_back" + suf, code, lab) for suf, code, lab in ACTION_POSES]
# Silhouette attendue par case : même si deux textes de pose se ressemblent, la forme d'ensemble diffère.
SILHOUETTE = {
    "A0": "tall and vertical, limbs raised above the head",
    "A1": "wide and horizontal, body stretched far forward",
    "A2": "low and wide, crouched or twisted with a long side reach",
    "C0": "compact and rounded, hands gathered near the chest",
    "C1": "tall, both arms thrown up or spread wide",
    "W": "mid-stride with legs clearly apart, moving forward",
}
WALK = {
    "beast": "WALK: mid-stride, one front paw raised, body moving forward",
    "spirit": "DRIFT: floating forward with the body tilted slightly ahead, a short trail behind",
    "brute": "WALK: heavy mid-stride, one foot raised, arms swinging",
}
WALK_DEFAULT = "WALK: mid-stride, one foot raised, arms swinging naturally, weapon held"

# --------------------------------------------------------------------------------------------
# Nations (scripts/Nations.gd) : héros, 4 ennemis (ordre : Gobelin, Loup, Squelette, Troll), boss
# --------------------------------------------------------------------------------------------
NATIONS = [
    dict(id="sylvestre", nom="Sylvestre", biome="Forêt", rim="warm golden sunlight",
         palette="moss green, bark brown, leaf gold, small emerald glows",
         fx="green leaves and glowing spores",
         hero=dict(id="druide", nom="Druide", arch="staff", pale=False,
                   desc="young druid with messy dark green hair, layered armor-robe made of overlapping leaves "
                        "and bark plates in moss green and brown, leather belts, a tall wooden staff topped with a "
                        "carved leaf-shaped emerald crystal held in the right hand"),
         enemies=[
             dict(id="araknea", nom="Araknéa", arch="beast",
                  desc="forest spider-beetle with an emerald armored carapace, curved horns, sharp mandibles and six legs"),
             dict(id="loup_forestier", nom="Loup forestier", arch="beast",
                  desc="sturdy wolf with dark moss-green fur, a mane of leaves and twigs, amber eyes"),
             dict(id="dryade", nom="Dryade", arch="bow",
                  desc="dryad archer whose body is made of branches and leaves, wooden bow, leafy hair"),
             dict(id="treant", nom="Tréant", arch="brute",
                  desc="walking tree trunk brute covered in moss and leaves, root-like legs, glowing green eyes"),
         ],
         boss=dict(id="sylvestre", nom="Tharok le Végétal", arch="brute", pale=False,
                   desc="towering forest giant with a body of bark and moss, great deer antlers covered in leaves, "
                        "a long beard of hanging moss, wielding a thorny wooden club set with a green crystal")),
    dict(id="cimes", nom="Cimes", biome="Montagne", rim="cold icy blue",
         palette="steel blue, dark iron, snow white fur, ice cyan crystals",
         fx="ice shards and snow bursts",
         hero=dict(id="tank", nom="Tank", arch="hammer_shield", pale=False,
                   desc="stout veteran warrior with a big white beard and white hair, heavy dark steel-blue plate armor "
                        "with white fur trim and ice-blue crystal inlays, a large round shield with a cloud and "
                        "mountain emblem on the left arm, a rune-engraved war hammer in the right hand"),
         enemies=[
             dict(id="guerrier_des_monts", nom="Guerrier des monts", arch="brute",
                  desc="mountain warrior with rocky brown skin, stocky body, crude stone gauntlets"),
             dict(id="griffon_des_cimes", nom="Griffon des cimes", arch="beast",
                  desc="griffin with a white eagle head, blue-grey feathered wings and a lion body"),
             dict(id="garde_des_pics", nom="Garde des pics", arch="brute",
                  desc="peak guardian golem of blue-grey stone with glowing ice-blue crystals on the shoulders"),
             dict(id="rochebrute", nom="Rochebrute", arch="brute",
                  desc="hulking brute made of brown boulders, small glowing eyes, huge fists"),
         ],
         boss=dict(id="cimes", nom="Vorkann le Givre", arch="hammer_shield", pale=False,
                   desc="massive frost knight in dark steel armor covered with ice crystals and snow fur, crowned helm "
                        "of ice spikes, huge crystal-studded tower shield and a heavy rune hammer")),
    dict(id="sables", nom="Sables", biome="Désert", rim="warm golden",
         palette="sand gold, terracotta, amber, small turquoise accents",
         fx="swirling sand and amber shards",
         hero=dict(id="geomancien", nom="Géomancien", arch="staff", pale=False,
                   desc="adult geomancer in his late twenties with short brown hair, layered sand-gold robe with terracotta panels and "
                        "amber gems, sandals and wraps, a golden staff topped with a large faceted amber crystal "
                        "in the right hand"),
         enemies=[
             dict(id="bandit_des_dunes", nom="Bandit des dunes", arch="daggers",
                  desc="small desert jackal-folk bandit with orange fur, a sand-colored scarf and a curved dagger"),
             dict(id="scarabee_geant", nom="Scarabée géant", arch="beast",
                  desc="giant scarab beetle with a black and gold shell and golden horns"),
             dict(id="genie_du_desert", nom="Génie du désert", arch="spirit",
                  desc="golden sand djinn with muscular arms and a lower body of swirling sand"),
             dict(id="sphinx", nom="Sphinx", arch="beast",
                  desc="golden lion sphinx wearing a striped pharaoh headdress"),
         ],
         boss=dict(id="sables", nom="Zahor le Sableux", arch="staff", pale=False,
                   desc="sand sovereign in ornate golden armor with sharp layered plates, crested golden helm, "
                        "holding a tall golden staff with a giant amber crystal")),
    dict(id="cristaux", nom="Cristaux", biome="Cristaux", rim="violet",
         palette="silver white, sapphire blue, amethyst violet",
         fx="prismatic blue and violet crystal shards",
         hero=dict(id="mage", nom="Mage", arch="staff", pale=True,
                   desc="young mage with dark blue hair, long silver-white robe with crystal patterns and sapphire "
                        "trims, an ornate silver staff topped with a glowing blue crystal in the right hand"),
         enemies=[
             dict(id="araignee_de_cristal", nom="Araignée de cristal", arch="beast",
                  desc="spider made of violet amethyst crystals with ice-blue glowing legs"),
             dict(id="mage_cristallin", nom="Mage cristallin", arch="staff",
                  desc="slender crystal mage with violet crystal hair and a pale blue body, crystal staff"),
             dict(id="golem_de_cristal", nom="Golem de cristal", arch="brute",
                  desc="heavy golem made of violet and blue crystal clusters"),
             dict(id="elementaire_de_cristal", nom="Élémentaire de cristal", arch="spirit",
                  desc="floating elemental made of sharp violet crystal shards in a humanoid shape"),
         ],
         boss=dict(id="cristaux", nom="Zyphéron le Cristallin", arch="staff", pale=True,
                   desc="tall crystal sorcerer with a crown of ice-blue shards, long robe of shattered pale crystal "
                        "plates, holding an ornate crystal staff")),
    dict(id="marees", nom="Marées", biome="Marées", rim="aqua",
         palette="turquoise, white, gold trims, coral pink accents",
         fx="water splashes and bubbles",
         hero=dict(id="heal", nom="Heal (Soigneur)", arch="staff", pale=True,
                   desc="gentle healer with teal hair, ornate white and turquoise robe with gold embroidery and "
                        "wave patterns, a golden staff topped with a glowing water-drop crystal in the right hand"),
         enemies=[
             dict(id="pirate_des_mers", nom="Pirate des mers", arch="daggers",
                  desc="sea pirate with a red bandana, blue coat, leather belts and a short cutlass"),
             dict(id="requin", nom="Requin", arch="beast",
                  desc="blue shark with a white belly swimming upright in the air, toothy grin"),
             dict(id="nereide", nom="Néréide", arch="spirit",
                  desc="water nymph made of translucent-looking turquoise water, flowing hair of waves"),
             dict(id="crabe_geant", nom="Crabe géant", arch="beast",
                  desc="giant crab with a blue shell striped with red, huge pincers"),
         ],
         boss=dict(id="marees", nom="Néréa la Tempête", arch="staff", pale=False,
                   desc="sea queen in turquoise coral armor with gold edges, crown of red coral branches, "
                        "flowing sea-foam cape, holding a golden trident")),
    dict(id="vents", nom="Vents", biome="Vents", rim="pale sky white",
         palette="pale teal, silver, sky white, mint",
         fx="wind ribbons and feathers",
         hero=dict(id="sylvain", nom="Sylvain", arch="staff", pale=True,
                   desc="nature-wind guardian with silver-teal hair, robe of pale teal layered leaves and feathers, "
                        "silver bracers, a staff topped with a wing-shaped mint crystal in the right hand"),
         enemies=[
             dict(id="garde_aerien", nom="Garde aérien", arch="staff",
                  desc="sky guard in blue and silver armor with small wings on the helmet, holding a halberd"),
             dict(id="aigle_celeste", nom="Aigle céleste", arch="beast",
                  desc="large deep blue eagle with golden talons and spread wings"),
             dict(id="harpie", nom="Harpie", arch="spirit",
                  desc="harpy with green and gold feathered wings for arms and bird legs"),
             dict(id="elementaire_de_vent", nom="Élémentaire de vent", arch="spirit",
                  desc="swirling pale blue wind spirit with a round cloud body and small arms of wind"),
         ],
         boss=dict(id="vents", nom="Aéron le Céleste", arch="staff", pale=True,
                   desc="celestial lord in pale cyan feathered armor with long flowing layers, crown of silver "
                        "spikes, holding a tall silver staff with a wing crystal")),
    dict(id="brasier", nom="Brasier", biome="Brasier", rim="orange ember",
         palette="crimson red, black obsidian, ember orange, gold",
         fx="flames and embers",
         hero=dict(id="chasseur", nom="Chasseur", arch="bow", pale=False,
                   desc="hunter with long red hair in a high ponytail, black armor with gold trims and red flame-shaped plates "
                        "and glowing ember cracks, a red scarf and short red flame-hem cape, quiver of arrows on the back, "
                        "a curved flame-patterned bow in the left hand"),
         enemies=[
             dict(id="lieutenant", nom="Lieutenant", arch="staff",
                  desc="fire hooded lieutenant in orange and red robes holding a flaming staff"),
             dict(id="salamandre", nom="Salamandre", arch="beast",
                  desc="chubby orange lava lizard standing upright, glowing cracks on its back and a flaming tail"),
             dict(id="devoreur_de_flammes", nom="Dévoreur de flammes", arch="beast",
                  desc="stocky upright fiery orange beast with two curved horns, a mane of flames and big claws"),
             dict(id="golem_de_lave", nom="Golem de lave", arch="brute",
                  desc="dark basalt golem with bright orange lava cracks and a molten core"),
         ],
         boss=dict(id="brasier", nom="Kharaz le Flamboyant", arch="bow", pale=False,
                   desc="flame warlord with burning hair, black and crimson ember armor with sharp plates, "
                        "holding a great curved flame bow")),
    dict(id="brumes", nom="Brumes", biome="Brumes", rim="pale mint",
         palette="black, deep violet, mist mint green, silver",
         fx="mint mist and violet spectral wisps",
         hero=dict(id="invocateur", nom="Invocateur", arch="staff_book", pale=False,
                   desc="summoner with black hair, long black coat with violet trims and silver clasps, a spiked dark "
                        "staff topped with a violet crystal in the right hand, a grimoire floating at his side"),
         enemies=[
             dict(id="brumeux", nom="Brumeux", arch="spirit",
                  desc="hulking lavender mist beast with a fluffy cloud body and small glowing eyes"),
             dict(id="gargouille", nom="Gargouille", arch="beast",
                  desc="grey stone gargoyle with bat wings and a long tail"),
             dict(id="liche_des_brumes", nom="Liche des brumes", arch="staff",
                  desc="thin violet lich in tattered robes holding a crooked staff"),
             dict(id="fantome", nom="Fantôme", arch="spirit",
                  desc="pale blue ghost with a wavy tail and a mischievous face"),
         ],
         boss=dict(id="brumes", nom="Ombrelis le Brumeux", arch="staff_book", pale=False,
                   desc="dark necromancer in black spiked armor with a violet tattered cloak, spiked crown, "
                        "holding a skull-topped staff surrounded by mist")),
    dict(id="ombres", nom="Ombres", biome="Ombres", rim="violet",
         palette="black, charcoal, violet glow, silver-teal cloth accents",
         fx="violet shadow smoke",
         hero=dict(id="assassin", nom="Assassin", arch="daggers", pale=False,
                   desc="agile assassin with black hair, a black cloth mask covering the lower face (eyes clearly "
                        "visible), dark charcoal hooded armor with layered tattered silver-teal cloth panels, "
                        "violet glowing rune details, a curved dagger in each hand"),
         enemies=[
             dict(id="assassin_des_ombres", nom="Assassin des ombres", arch="beast",
                  desc="hunched shadow beast-assassin with a spiky purple mane and long claws"),
             dict(id="ombre_infernale", nom="Ombre infernale", arch="spirit",
                  desc="swirling mass of purple shadow with claws and glowing eyes"),
             dict(id="spectre", nom="Spectre", arch="spirit",
                  desc="violet spectral figure wrapped in shadow curls, long claw-like hands"),
             dict(id="liche", nom="Liche", arch="staff",
                  desc="tall dark purple lich in a spiked robe holding a staff"),
         ],
         boss=dict(id="ombres", nom="Nébulia l'Illusionniste", arch="daggers", pale=False,
                   desc="tall illusionist in black armor with spiky layers of silver-teal tattered cloth, "
                        "horned mask-helm, long blades, mirror-like violet glints")),
    dict(id="rouages", nom="Rouages", biome="Rouages", rim="warm brass",
         palette="brass, copper, dark steel, teal glowing lights",
         fx="sparks, steam puffs and teal electric arcs",
         hero=dict(id="artificier", nom="Artificier", arch="wrench", pale=False,
                   desc="young engineer with spiky brown hair, brass goggles on the forehead, bronze and steel "
                        "steampunk armor with teal glowing gems, tool belt with pouches, a big gear-headed hammer "
                        "in the right hand"),
         enemies=[
             dict(id="drone_aerien", nom="Drone aérien", arch="spirit",
                  desc="bronze flying drone with claw arms, small propellers and a glowing blue core"),
             dict(id="araignee_mecanique", nom="Araignée mécanique", arch="beast",
                  desc="bronze mechanical spider with long jointed legs and a blue gem eye"),
             dict(id="roue_engrenee", nom="Roue engrenée", arch="brute",
                  desc="rolling bronze cog-wheel creature with a single glowing blue gem eye in the center"),
             dict(id="automate_de_combat", nom="Automate de combat", arch="brute",
                  desc="heavy combat automaton of riveted bronze and stone plates with big fists"),
         ],
         boss=dict(id="rouages", nom="Mécanoptère, Colosse d'Engrenages", arch="brute", pale=False,
                   desc="giant steam colossus of steel and brass with two smoking chimneys on the back, "
                        "a glowing blue core in the chest and a huge gear hammer")),
]

# Familiers (invocations jouables) — assets/sprites/summons/<id>.png
FAMILIERS = [
    dict(id="golem_de_pierre", nom="Golem de pierre (Invocateur, ex-Tortue)", arch="brute",
         desc="grey stone golem with blue crystals growing from the shoulders and back"),
    dict(id="loup_spectral", nom="Loup spectral (Invocateur)", arch="beast",
         desc="spectral violet wolf with flame-like spiky fur and glowing eyes"),
    dict(id="requin_des_marees", nom="Requin des marées (Invocateur, ex-Sirène)", arch="beast",
         desc="bright blue shark with a white belly floating upright, fins like small arms"),
    dict(id="elementaire_de_cristal", nom="Élémentaire de cristal (Invocateur, ex-Ange)", arch="spirit",
         desc="small elemental made of violet and blue crystals, friendly glowing eyes"),
    dict(id="ombre", nom="Ombre (Invocateur, ex-Homme-Faucon)", arch="spirit",
         desc="coiled purple shadow serpent with a dragon-like head, stylized opaque smoke curls"),
    dict(id="esprit_de_la_foret", nom="Esprit de la forêt (Invocateur, ex-Centaure)", arch="beast",
         desc="forest stag spirit with a body of leaves and moss and large branching antlers"),
    dict(id="archer_sylvestre", nom="Archer sylvestre (Sylvain)", arch="bow",
         desc="slim wooden archer made of branches and leaves, carrying a wooden bow"),
    dict(id="ent_de_combat", nom="Ent de combat (Sylvain)", arch="brute",
         desc="small wooden ent warrior covered in leaves, stubby branch arms"),
    dict(id="tronc", nom="Tronc (Sylvain)", arch="brute",
         desc="cute walking tree stump with a round leafy crown, big eyes and branch arms"),
    dict(id="sarriette", nom="Sarriette (Sylvain)", arch="staff",
         desc="tiny leaf sprite girl in a green leaf hood with little horns and a curly vine"),
    dict(id="ronce_agressive", nom="Ronce agressive (Sylvain)", arch="spirit",
         desc="angry bramble bulb covered in thorns with red eyes and whipping vines"),
    dict(id="sentinelle_de_gres", nom="Sentinelle de grès (pas encore utilisée)", arch="brute",
         desc="sandstone sentinel statue with amber eyes and carved armor"),
]

# Mécanismes (objets fixes, une pose chacun) — assets/sprites/summons/<id>.png
MECANISMES = [
    ("Sylvain", [("arbre", "immobile magical tree with a thick trunk, round dense foliage and roots spreading on the ground"),
                 ("racines", "ring of gnarled roots coming out of the ground")]),
    ("Géomancien", [("pilier", "tall sandstone pillar with carved runes and an amber gem"),
                    ("muraille", "short sandstone wall section with two carved posts"),
                    ("faille", "glowing amber crack in the ground with small floating rocks"),
                    ("cristal_ambre", "large amber crystal cluster standing on the ground")]),
    ("Chasseur", [("balise", "hunter's marker beacon: a wooden post topped with a golden target sigil")]),
    ("Artificier", [("bombe", "round black bomb with brass bands and a lit fuse"),
                    ("tourelle", "small brass tripod turret with a teal glowing barrel"),
                    ("balise_de_transposition", "brass teleport beacon on three legs with a spinning teal ring")]),
]


# --------------------------------------------------------------------------------------------
# Prompts des 2 planches d'un personnage
# --------------------------------------------------------------------------------------------
def cell_text(code, arch, fx):
    if code == "W":
        return WALK.get(arch, WALK_DEFAULT)
    src = ARCH[arch]["atk" if code[0] == "A" else "cast"]
    return src[int(code[1:])].format(fx=fx)


def weapon_of(ent_id):
    """Arme de la carte d'identité, ou None pour une créature sans arme."""
    ident = IDENT.get(ent_id)
    return dict(ident["parts"]).get("weapon") if ident else None


def subject_line(role, who, ent_id, what):
    """Première phrase du prompt : le sujet ET son arme (le début du prompt est le plus pondéré)."""
    w = weapon_of(ent_id)
    if w:
        return f"{what} of ONE {role}: {who}, armed with: {w}."
    return f"{what} of ONE {role}: {who} — an UNARMED creature (no weapon of any kind)."


def weapon_block(ent_id, scope):
    """Verrou d'arme pour un personnage armé ; verrou « sans arme » pour une créature."""
    w = weapon_of(ent_id)
    if w:
        return (f"WEAPON: {w}. It is held in the SAME hand and is clearly visible in {scope}: never missing, "
                "never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different "
                "shape or color.")
    return (f"UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in {scope}; "
            "it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.")


def reminder(ent_id, who, desc, never):
    """Rappel final (les générateurs pèsent davantage le début et la fin du prompt)."""
    ident = IDENT.get(ent_id)
    if ident is None:
        return f"REMINDER: this is {who}: {desc}."
    by_part = dict(ident["parts"])
    prio = [k for k in ("weapon", "hair", "eyes", "top") if k in by_part]
    rest = [p for p, _ in ident["parts"] if p not in prio]
    key = "; ".join(by_part[p] for p in (prio + rest))
    tail = ("The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff)."
            if by_part.get("weapon") else "NO weapon and no held object, ever.")
    return (f"REMINDER: this is {who}: {key}. {tail}" + (f" Forbidden: {never}." if never else "")
            + " Every sprite faces RIGHT (front or back 3/4), never left.")


def view_text(vtxt, ent_id):
    """Texte d'une case de vue : pour une créature sans arme, on retire « l'arme reste dans sa main » et la main sur la hanche."""
    if weapon_of(ent_id):
        return vtxt
    return (vtxt.replace(" (the weapon stays in its hand)", "")
            .replace("the free hand rests on the hip", "one limb (paw, claw or hand) is lifted or resting in a different position"))


def prop_lines(ent_id):
    """Ligne PROPORTIONS facultative de la carte d'identité (ex. héros adulte : tête moins grosse)."""
    ident = IDENT.get(ent_id)
    return ["PROPORTIONS: " + ident["proportions"]] if ident and ident.get("proportions") else []


def held_short(ent_id):
    """Objet tenu en quelques mots (début de la ligne d'arme) : rappelé dans CHAQUE case."""
    w = weapon_of(ent_id)
    if not w:
        return ""
    return re.split(r" \(|, ", w)[0]


def held_suffix(ent_id):
    h = held_short(ent_id)
    return f" The {h} is held in the right hand and fully visible in this cell." if h else ""


def prompt_vues(who, role, nation, desc, fx, rim, palette, pale, ent_id=""):
    """Planche VUES : 2 repos de face + 2 repos de dos, tous orientés vers la droite. Génération normale."""
    idc, never = card(ent_id, desc, who, nation)
    lines = [
        subject_line(role, who, ent_id, "Sprite sheet for a chibi isometric tactical RPG showing 4 idle poses"),
        "The sheet contains EXACTLY 4 sprites of the SAME character: the top row shows it from the FRONT "
        "twice (two different relaxed stances), the bottom row shows it from BEHIND twice (two different "
        "relaxed stances). Same design, same outfit, same colors, same size in all 4 cells.",
        idc,
        weapon_block(ent_id, "all 4 cells"),
        f"NATION PALETTE: {palette}.",
        STYLE_LOCK,
        "STYLE: " + STYLE.format(rim=rim),
        *prop_lines(ent_id),
        "LAYOUT: " + VUES_LAYOUT,
        "CELLS — follow the grid positions EXACTLY:",
    ]
    for i, ((_, _, vtxt), pos) in enumerate(zip(VIEWS4, VIEWS4_POS)):
        lines.append(f"{i+1}. {pos} cell: {view_text(vtxt, ent_id)}.{held_suffix(ent_id)}")
    lines.append("Every sprite faces RIGHT (front-right on the top row, away toward the upper right on the "
                 "bottom row): never facing left, never a pure side profile. The two sprites of a row are "
                 "clearly different stances, never the same drawing twice.")
    lines.append("COUNT AND VIEWS: exactly FOUR sprites, two per row, no empty cell. The two sprites of the SAME "
                 "row are NOT a mirrored pair and NOT a copy: change the head tilt, the arm and hand positions "
                 "and which leg carries the weight. The BOTTOM row is drawn from BEHIND: we see the back of the "
                 "head, the back of the outfit and the tail or cape from behind — no face, no eyes, no beak or "
                 "snout visible. A bottom-row sprite that shows a face is wrong.")
    lines.append(f"EFFECTS: {fx}, stylized, opaque, with dark outlines, small, kept close to the character "
                 "inside its own quarter of the image.")
    lines.append("BACKGROUND: " + (BG_GRAY if pale else BG_WHITE) + BG_TAIL)
    lines.append(weapon_block(ent_id, "every cell").replace("WEAPON:", "WEAPON CHECK:", 1)
                 if weapon_of(ent_id) else weapon_block(ent_id, "every cell"))
    lines.append(reminder(ent_id, who, desc, never))
    return "\n".join(lines)


def prompt_actions(who, role, nation, desc, arch, fx, rim, palette, pale, ent_id="", view="face"):
    """Planche ACTIONS (6 poses : 3 attaques, 2 sorts, 1 marche), de FACE ou de DOS (un seul sens de vue).
    À générer EN ÉDITION de la planche vues ; en repli, génération normale (carte d'identité recopiée)."""
    idc, never = card(ent_id, desc, who, nation)
    poses = [cell_text(code, arch, fx) for _, code, _ in ACTION_POSES]
    face = view == "face"
    view_txt = (FACE_VIEW + ", facing front-right in every pose" if face else BACK_VIEW)
    lines = [
        subject_line(role, who, ent_id, "Image edit — sprite sheet for a chibi isometric tactical RPG showing "
                     "6 action poses " + ("seen from the FRONT" if face else "seen from BEHIND")),
        f"SOURCE IMAGE: it shows this {role}, {who}, in 4 idle views (top row from the front, bottom row from "
        "behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, "
        "proportions, accessories" + (", weapon in the same hand" if weapon_of(ent_id) else "") +
        ". The 6 new poses must show this SAME character, unchanged. The source is ONLY a CHARACTER "
        "REFERENCE (design, colors, proportions): do NOT reuse, copy, trace or lightly modify ANY of its "
        "poses — every one of the 6 poses below is a brand-NEW drawing with its own silhouette."
        + ("" if face else " Use the BACK views of the source as the reference for the back of the outfit."),
        idc,
        weapon_block(ent_id, "all 6 poses"),
        "TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: " + view_txt +
        ". Never a pure side profile, never facing left" +
        ("" if face else "; no face and no eyes visible in any pose") + ".",
        f"NATION PALETTE: {palette}.",
        STYLE_LOCK,
        "STYLE: " + STYLE.format(rim=rim),
        *prop_lines(ent_id),
        "LAYOUT: " + ACTIONS_LAYOUT,
        "POSES, left to right, top to bottom:",
    ]
    for i, ((_, code, _), p) in enumerate(zip(ACTION_POSES, poses)):
        lines.append(f"{i+1}. {p} — silhouette: {SILHOUETTE[code]}.{held_suffix(ent_id)}")
    lines.append("The 6 poses MUST be clearly different from each other: different arm, leg and weapon "
                 "positions, different body angle and height. Never repeat or copy a pose; if two poses look "
                 "alike, change one. SELF-CHECK before answering: fill every pose in solid black — the 6 "
                 "black silhouettes must be easy to tell apart, and none may be the standing idle pose.")
    lines.append(f"EFFECTS: {fx}, stylized, opaque, with dark outlines, small, kept close to the character "
                 "inside its own sixth of the image.")
    lines.append("BACKGROUND: keep the plain flat background of the source image "
                 "(" + (BG_GRAY if pale else BG_WHITE) + ")" + BG_TAIL)
    if weapon_of(ent_id):
        lines.append(f"WEAPON CHECK: {weapon_of(ent_id)} — visible in EVERY one of the 6 poses (held or used).")
    lines.append(reminder(ent_id, who, desc, never))
    return "\n".join(lines)


def prompt_vues_court(who, role, desc, palette, pale, ent_id=""):
    """Version COURTE de la planche vues (≈ 1 000 caractères) : les générateurs qui reformulent ou
    ignorent un long prompt (nombre de cases, objet tenu) la respectent mieux."""
    idc, never = card(ent_id, desc, who, "")
    parts = IDENT.get(ent_id, {}).get("parts")
    ident = "; ".join(d for _, d in parts) if parts else desc
    h = held_short(ent_id)
    item = (f" It always holds the {h} in the right hand, clearly visible in all 4 sprites." if h else
            " It holds nothing in its hands, paws or claws.")
    bg = "flat medium gray" if pale else "flat white"
    prop = (" " + prop_lines(ent_id)[0] + ".") if prop_lines(ent_id) else ""
    return (f"Character sheet, exactly 4 sprites in a 2x2 grid, plain {bg} background, wide empty gaps, no overlap, "
            f"no text, no frame. ONE {role}: {who}. {ident}.{item}{prop} "
            "Top row: two front 3/4 views facing right, two slightly different relaxed stances (not mirrored). "
            "Bottom row: two views from behind, facing away toward the upper right, no face visible, two different "
            "stances. Same outfit, colors and size in all 4, feet on one line. Style: smooth hand-drawn vector "
            "cartoon, thick dark outlines, Dofus / Waven look, NOT pixel art. Never facing left."
            + (f" Forbidden: {never}." if never else ""))


def prompt_vues_fix(who, role, nation, desc, fx, rim, palette, pale, ent_id=""):
    """Édition CORRECTIVE de la planche vues (arme manquante, ou objet inventé sur une créature).
    Répète la structure des cases : une édition qui ne la répète pas aplatit tout dans le même angle."""
    idc, never = card(ent_id, desc, who, nation)
    w = weapon_of(ent_id)
    task = ("fix the sprites so that EVERY sprite visibly HOLDS its weapon in the correct hand — add the "
            "weapon where it is missing, correct the hand if it is held wrong"
            if w else
            "REMOVE every weapon, torch, tool or held object from the hands, claws or tail — this creature "
            "is unarmed")
    lines = [
        subject_line(role, who, ent_id, "Image edit of a sprite sheet for a chibi isometric tactical RPG showing "
                     "4 idle poses"),
        f"SOURCE IMAGE: it shows this {role}, {who}, 4 times: top row from the FRONT twice, bottom row from "
        "BEHIND twice, all facing right.",
        idc,
        f"TASK: {task}. Nothing else changes.",
        "CRITICAL — KEEP THE VIEWS: the top row stays FRONT views and the bottom row stays BACK views; the "
        "two sprites of a row stay two different stances. Never redraw the whole sheet from a single angle:",
    ]
    for i, ((_, _, vtxt), pos) in enumerate(zip(VIEWS4, VIEWS4_POS)):
        lines.append(f"{i+1}. {pos} cell: {view_text(vtxt, ent_id)}.{held_suffix(ent_id)}")
    lines.append(weapon_block(ent_id, "every cell"))
    lines.append("CHANGE NOTHING ELSE: keep the exact same character, poses, sizes, outfit, hair, background "
                 "and layout.")
    lines.append("BACKGROUND: keep the plain flat background of the source image.")
    lines.append(reminder(ent_id, who, desc, never))
    return "\n".join(lines)


def name_table_vues(base):
    out = ["| Case | Vue | Fichier |", "|---|---|---|"]
    for i, (suf, vlabel, _) in enumerate(VIEWS4):
        out.append(f"| {i//2+1}-{i%2+1} | {vlabel} | `{base}{suf}.png` |")
    return "\n".join(out)


def name_table_actions(base, back=False):
    out = ["| Case | Pose | Fichier |", "|---|---|---|"]
    for i, (suf, _, plabel) in enumerate(ACTIONS_BACK if back else ACTIONS_FACE):
        out.append(f"| {i//3+1}-{i%3+1} | {plabel}{' — dos' if back else ''} | `{base}{suf}.png` |")
    return "\n".join(out)


def character_md(title, ent, role, nation_txt, fx, rim, palette, path_hint, extra_desc=""):
    desc = ent["desc"] + extra_desc
    key = ent["id"]
    if role == "summoned familiar" and ("familier:" + key) in IDENT:
        key = "familier:" + key
    who = ent["nom"].split(" (")[0]
    pale = ent.get("pale", False) or any(w in desc.lower() for w in PALE_WORDS)
    armed = weapon_of(key) is not None
    parts = [
        f"### {title}\n\n3 planches : **vues** (génération normale), puis **actions de face** et **actions "
        f"de dos** en **édition** de la planche vues (image source = planche vues de ce personnage : c'est ce "
        f"qui garantit le même personnage). "
        + ("Personnage armé : l'arme est verrouillée dans chaque prompt. " if armed else
           "Créature **sans arme** : chaque prompt interdit tout objet tenu. ")
        + f"Fichiers dans `{path_hint}` ; nomme tes images `{ent['id']}_vues.png`, "
        f"`{ent['id']}_actions.png` et `{ent['id']}_actions_dos.png` pour que l'Atelier les reconnaisse.\n",
    ]
    p = prompt_vues(who, role, nation_txt, desc, fx, rim, palette, pale, key)
    parts.append(
        "#### Planche 1 — Vues · 2 repos de face + 2 repos de dos (`vues`)\n\nGénération normale, aucune image "
        "à joindre. Tout est orienté vers la droite ; deux attitudes différentes par rangée.\n\n"
        f"```text\n{p}\n```\n\n{name_table_vues(ent['id'])}\n")
    pc = prompt_vues_court(who, role, desc, palette, pale, key)
    parts.append(
        "##### Version courte de la planche vues\n\nÀ utiliser si le générateur reformule le prompt, "
        "bloque sur un mot ou ne respecte pas le nombre de cases : mêmes consignes, 1 000 caractères.\n\n"
        f"```text\n{pc}\n```\n")
    p = prompt_vues_fix(who, role, nation_txt, desc, fx, rim, palette, pale, key)
    parts.append(
        "##### Édition corrective (" + ("arme manquante" if armed else "objet inventé dans les mains") +
        ")\n\nSi une case est fausse : édition avec la planche `vues` en image source. Ce prompt répète la "
        "structure des cases (haut = face, bas = dos) pour que l'éditeur n'aplatisse pas toutes les vues dans "
        f"le même angle.\n\n```text\n{p}\n```\n")
    p = prompt_actions(who, role, nation_txt, desc, ent["arch"], fx, rim, palette, pale, key, "face")
    parts.append(
        "#### Planche 2 — Actions de face · 3 attaques, 2 sorts, 1 marche (`actions`)\n\n**Édition d'image** : "
        "source = la planche `vues` (l'image générée à l'étape précédente). Si ton outil ne permet pas "
        "l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.\n\n"
        "**Si les 6 poses sortent identiques** (V55) : relance deux fois avec le même prompt en ne gardant que "
        "les poses 1 à 3 (« draw ONLY poses 1, 2 and 3, 3 columns x 1 row »), puis que les poses 4 à 6 : "
        "le générateur recopie beaucoup moins la pose source avec 3 cases qu'avec 6. Découpe en `--grid 3x1`.\n\n"
        f"```text\n{p}\n```\n\n{name_table_actions(ent['id'])}\n")
    p = prompt_actions(who, role, nation_txt, desc, ent["arch"], fx, rim, palette, pale, key, "dos")
    parts.append(
        "#### Planche 3 — Actions de dos · mêmes 6 poses vues de dos (`actions_dos`)\n\n**Édition d'image**, "
        "source = la planche `vues`. "
        + ("" if role in ("playable hero", "final boss") else
           "**Facultative pour un monstre** : sans elle, le jeu utilise les poses de face. ")
        + f"\n\n```text\n{p}\n```\n\n{name_table_actions(ent['id'], True)}\n")
    return "\n".join(parts)


def lineup_prompt(n):
    chars = [f"the hero ({n['hero']['nom']}: {n['hero']['desc']})"]
    chars += [f"{e['nom']} ({e['desc']})" for e in n["enemies"]]
    chars.append(f"the final boss {n['boss']['nom']} ({n['boss']['desc']}), about 1.5x taller than the others")
    pale = n["hero"]["pale"] or n["boss"]["pale"]
    return "\n".join([
        f"Character lineup reference sheet for a chibi isometric tactical RPG: the {n['nom']} nation "
        f"({n['biome']} biome).",
        f"NATION PALETTE: {n['palette']}. Signature effects: {n['fx']}.",
        "STYLE: " + STYLE.format(rim=n["rim"]),
        f"LAYOUT: two rows with the same {len(chars)} characters in the same order, all in idle pose. "
        "Top row: 3/4 front view, facing front-right. Bottom row: 3/4 back view, seen from behind, turned toward "
        "the upper right. All feet of a row on the same ground line. Leave a wide empty gap (at least half a "
        "character width) between characters and between the two rows: nobody overlaps or touches anyone, "
        "weapons and capes included. Image aspect ratio 2:1, as large as possible.",
        "CHARACTERS, left to right:",
        *[f"{i+1}. {c}." for i, c in enumerate(chars)],
        "BACKGROUND: " + (BG_GRAY if pale else BG_WHITE) + BG_TAIL,
    ])


def nation_md(n):
    h, b = n["hero"], n["boss"]
    nt = f"of the {n['nom']} nation"
    parts = [f"# Nation {n['nom']} ({n['biome']})\n",
             f"Palette : {n['palette']}. Effets : {n['fx']}. Contre-jour : {n['rim']}.\n",
             "Format 3 planches par personnage (V44) :\n\n"
             "1. **Vues** — 4 cases : repos de FACE ×2 (deux attitudes différentes) puis repos de DOS ×2, tout "
             "orienté vers la droite (le jeu retourne l'image pour la gauche). Grille 2 × 2 sur image 2:1, poses "
             "largement espacées. Génération normale.\n"
             "2. **Actions de face** — 3 attaques + 2 sorts + 1 marche (3 colonnes × 2 rangées), en **édition** de "
             "la planche vues : le personnage réellement dessiné sert d'ancre.\n"
             "3. **Actions de dos** — les mêmes 6 poses vues de dos, en édition de la planche vues. Une planche = "
             "un seul sens de vue (face et dos mélangés sur une même planche étaient dessinés de face). "
             "Facultative pour les monstres.\n\n"
             "Les personnages **armés** ont l'arme écrite dans la première phrase, dans la carte d'identité, en "
             "fin de prompt et dans chaque pose ; les **créatures** reçoivent « UNARMED » (plus de torche "
             "inventée). Chaque prompt recopie la carte d'identité (`identites.py`) : aucune image à joindre. "
             "Ordre conseillé : 1) planche de style, 2) héros, 3) ennemis, 4) boss ; pour chaque personnage : "
             "vues, actions de face, actions de dos. Prompt négatif : en bas de page.\n"]
    parts.append("## 1. Planche de référence (style de la nation)\n\nNe sert pas en jeu : elle fixe palette, "
                 "matières et silhouettes, de face et de dos.\n\n"
                 f"```text\n{lineup_prompt(n)}\n```\n")
    parts.append("## 2. Héros\n\n" + character_md(f"{h['nom']} — 10 poses", h, "playable hero", "hero " + nt,
                                                  n["fx"], n["rim"], n["palette"], f"{GAME}/players/"))
    parts.append(f"L'export Zimut de l'Atelier copie aussi le repos (case 1 de la planche vues) vers "
                 f"`nations/heros/{h['id']}.png`.\n")
    parts.append("## 3. Ennemis\n")
    for e in n["enemies"]:
        parts.append(character_md(f"{e['nom']} — 10 poses", e, "enemy monster", "enemy " + nt, n["fx"], n["rim"],
                                  n["palette"], f"{GAME}/nations/ennemis/{n['id']}/"))
    parts.append("## 4. Boss\n\n" + character_md(
        f"{b['nom']} — 10 poses", b, "final boss", "boss " + nt, n["fx"], n["rim"], n["palette"],
        f"{GAME}/nations/boss/",
        ", imposing chibi with slightly longer body proportions than regular characters (head about 1/4 of "
        "total height)"))
    parts.append("## Prompt négatif\n\n**Personnages armés — planches vues** :\n\n```text\n" + NEGATIVE_VUES +
                 "\n```\n\n**Personnages armés — planches actions et planche de style** :\n\n```text\n" + NEGATIVE +
                 "\n```\n\n**Créatures sans arme (Salamandre, golems, bêtes…) — planches vues** :\n\n```text\n" +
                 NEGATIVE_CREATURE_VUES + "\n```\n\n**Créatures sans arme — planches actions** :\n\n```text\n" +
                 NEGATIVE_CREATURE_ACTIONS + "\n```\n")
    return "\n".join(parts)


def familiers_md():
    parts = ["# Familiers (invocations)\n",
             "Fichiers dans `" + GAME + "/summons/`. Format 3 planches par familier : **vues** (2 repos de face + "
             "2 de dos), **actions de face** et **actions de dos** (3 attaques, 2 sorts, 1 marche), générées en "
             "édition de la planche vues comme pour les personnages. Joins la planche du héros qui l'invoque "
             "comme référence de style.\n"]
    for f in FAMILIERS:
        parts.append(character_md(f"{f['nom']} — 10 poses", f, "summoned familiar", "a summon",
                                  "matching magical sparks", "soft colored", "colors as described",
                                  f"{GAME}/summons/"))
    parts.append("## Prompt négatif\n\nFamiliers sans arme — planches vues :\n\n```text\n" + NEGATIVE_CREATURE_VUES +
                 "\n```\n\nFamiliers sans arme — planches actions :\n\n```text\n" + NEGATIVE_CREATURE_ACTIONS +
                 "\n```\n\nFamiliers armés (Archer sylvestre, Sarriette) : négatifs des fichiers nation.\n")
    return "\n".join(parts)


def mecanismes_md():
    parts = ["# Mécanismes (objets fixes)\n",
             "Une seule vue par objet (ils ne se tournent pas) : ces planches peuvent regrouper plusieurs objets. "
             "Fichiers dans `" + GAME + "/summons/<id>.png`.\n"]
    for cls, objs in MECANISMES:
        n = len(objs)
        cols = min(4, n)
        rows = (n + cols - 1) // cols
        lines = [f"Object sprite sheet for a chibi isometric tactical RPG: {n} summoned objects of the {cls} class.",
                 "STYLE: " + OBJ_STYLE,
                 f"LAYOUT: {cols} columns x {rows} rows, like separate stickers floating on the background: each "
                 "object occupies at most 55% of its part of the image and is centered in it, with a wide empty "
                 "space between objects, nothing touching; all objects on the same ground line, seen from a 3/4 "
                 "top-front angle. No frames, borders, dividing lines, floor or grid on the ground.",
                 "OBJECTS, left to right:"]
        lines += [f"{i+1}. {d}." for i, (_, d) in enumerate(objs)]
        lines.append("BACKGROUND: " + BG_WHITE + BG_TAIL)
        table = ["| Case | Objet | Fichier |", "|---|---|---|"]
        table += [f"| {i+1} | {o} | `{o}.png` |" for i, (o, _) in enumerate(objs)]
        parts.append(f"## {cls}\n\n```text\n" + "\n".join(lines) + "\n```\n\n" + "\n".join(table) + "\n")
    parts.append(f"## Prompt négatif\n\n```text\n{NEGATIVE}\n```\n")
    return "\n".join(parts)


def atelier_catalog():
    """Liste des personnages pour l'Atelier Sprites : [groupe, libellé, id, grand, dossier]."""
    out = []
    for n in NATIONS:
        g = f"Nation {n['nom']}"
        h, b = n["hero"], n["boss"]
        out.append([g, f"{h['nom'].split(' (')[0]} (héros)", h["id"], True, "players"])
        out += [[g, e["nom"], e["id"], False, f"nations/ennemis/{n['id']}"] for e in n["enemies"]]
        out.append([g, f"{b['nom']} (boss)", b["id"], True, "nations/boss"])
    out += [["Familiers", f["nom"].split(" (")[0], f["id"], False, "summons"] for f in FAMILIERS]
    return out


def main():
    (OUT / "nations").mkdir(exist_ok=True)
    for i, n in enumerate(NATIONS, 1):
        (OUT / "nations" / f"{i:02d}_{n['id']}.md").write_text(soften_fences(nation_md(n)), encoding="utf-8")
    (OUT / "familiers.md").write_text(soften_fences(familiers_md()), encoding="utf-8")
    (OUT / "mecanismes.md").write_text(soften_fences(mecanismes_md()), encoding="utf-8")
    # 10 nations × (1 planche de style + 6 personnages × 3 planches) + 12 familiers × 3 + mécanismes
    sheets = len(NATIONS) * (1 + 6 * 3) + len(FAMILIERS) * 3 + len(MECANISMES)
    print(f"{sheets} prompts générés dans {OUT}")


if __name__ == "__main__":
    main()
