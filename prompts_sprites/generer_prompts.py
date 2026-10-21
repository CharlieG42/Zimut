#!/usr/bin/env python3
"""Génère les prompts de sprites chibi de Zimut (un fichier Markdown par nation + familiers + mécanismes).

Usage :  python3 prompts_sprites/generer_prompts.py
Modifier une description : éditer les dictionnaires ci-dessous puis relancer le script.
V38 : chaque prompt commence par la carte d'identité du personnage (identites.py), recopiée
mot pour mot, pour que toutes les planches dessinent le même personnage sans image jointe.
V36 : une fiche de référence (repos de face + repos de dos) puis des planches de 4 poses
(grille 2 × 2, une seule vue), poses décrites par leur silhouette pour éviter les doublons.
Les noms de fichiers suivent la convention du jeu (scripts/EntityView.gd, V34) :
  face : <nom>.png (repos), <nom>_idle_2/_idle_3, <nom>_walk[_2], <nom>_attack[_2.._8], <nom>_cast[_2,_3]
  dos  : <nom>_back.png (repos), <nom>_back_idle_2/_3, <nom>_back_walk[_2], <nom>_back_attack[_2.._8], <nom>_back_cast[_2,_3]
"""
import math
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from identites import IDENT, card  # noqa: E402

OUT = Path(__file__).resolve().parent
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
    "Soft key light from the upper left, subtle {rim} rim light on the right edge."
)
OBJ_STYLE = (
    "Polished 2D game art inspired by Dofus and Waven, matching chibi character sprites: clean bold dark "
    "outlines, 3-tone cel shading, crisp material details, saturated harmonious colors, slightly cute "
    "rounded proportions, readable at small size. Soft key light from the upper left."
)
BG_WHITE = "Pure flat white background (#FFFFFF)"
BG_GRAY = "Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it)"
BG_TAIL = (", no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, "
           "no numbers, no arrows, no frame or border lines."
           )
NEGATIVE = (
    "checkerboard, transparency grid, text, letters, labels, numbers, watermark, signature, "
    "overlapping characters, touching poses, cropped limbs, character cut by the cell edge, "
    "effects crossing into another cell, weapon crossing into another cell, side profile view, facing left, "
    "inconsistent scale, different outfit between cells, weapon switching hands, extra arms, extra fingers, "
    "blurry smoke, semi-transparent effects, soft glow halo, floor, cast shadow, gradient background, "
    "photorealistic, 3D render, pixel art, frames around poses, boxes, borders, dividing lines, grid lines, "
    "isometric floor grid, tiles, duplicate poses, identical poses, repeated pose, copy of the same pose, "
    "closed eyes, looking up at the sky, different hair color, different eye color, different hairstyle, "
    "new clothing pieces, weapon drawn alone without the character, extra objects, "
    "front and back views mixed, different character between poses, realistic proportions, small head"
)


def grid(cols, rows):
    if (cols, rows) == (2, 2):
        return (
            "4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), "
            "like four separate stickers floating on the background. Each pose occupies at most 55% of the width "
            "and height of its quarter of the image and is centered in it, so that there is a wide empty space "
            "between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its "
            "quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn "
            "smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in "
            "each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground."
        )
    return (
        f"Strict grid of {cols} columns x {rows} rows of equal square cells, exactly one pose per cell "
        f"(image aspect ratio {cols//math.gcd(cols, rows)}:{rows//math.gcd(cols, rows)}, as large as possible, "
        f"e.g. {cols*512}x{rows*512}). "
        "Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay "
        "entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. "
        "Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: "
        "no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. "
        "Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. "
        "Same character size in every cell, feet on the same ground line in each row."
    )


VIEWS = {
    "face": ("3/4 FRONT view: the character faces the viewer and turns slightly to the right "
             "(face, chest and right side visible), facing front-right in every pose", "front-right"),
    "dos": ("3/4 BACK view: the character is seen from behind and turns slightly to the right "
            "(back, back of the head and right shoulder visible), facing away from the viewer toward the upper right in "
            "every pose. We see the BACK of the head or helmet: NO face, NO eyes, NO mask or visor visible", "back-right, away from the viewer"),
}


# --------------------------------------------------------------------------------------------
# Archétypes de combat : 8 poses d'attaque et 3 poses de sort par archétype
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
                   desc="young geomancer with short brown hair, layered sand-gold robe with terracotta panels and "
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
                   desc="hunter with long red hair in a high ponytail, red and black armor with flame-shaped plates "
                        "and glowing ember cracks, a red scarf, quiver of arrows on the back, a curved flame-patterned "
                        "bow in the left hand"),
         enemies=[
             dict(id="lieutenant", nom="Lieutenant", arch="staff",
                  desc="fire cultist lieutenant in orange and red robes holding a flaming staff"),
             dict(id="salamandre", nom="Salamandre", arch="beast",
                  desc="orange lava lizard with glowing cracks on its back and a flaming tail"),
             dict(id="devoreur_de_flammes", nom="Dévoreur de flammes", arch="beast",
                  desc="fiery orange beast with a mane of flames and big claws"),
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
# Planches : 4 x 2 cases chacune. Héros et boss : 4 planches (face/dos x repos-sorts/attaques).
# Ennemis et familiers : 2 planches (face, dos).
# Noms de fichiers (EntityView.gd, V34) : vue de face <nom><suffixe>, vue de dos <nom>_back<suffixe>
# --------------------------------------------------------------------------------------------
IDLE = ["IDLE: relaxed standing pose, weapon held calmly",
        "GUARD: knees bent, weapon raised in front of the body, ready to fight"]
WALK = ["WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far "
        "forward, right leg far back, opposite arm swinging forward",
        "WALK (passing): same 3/4 view, head level, standing on the left leg, right knee raised high, body slightly higher"]
# (clé, libellé Atelier, vue, cases [(suffixe, code)]) — doit rester identique à
# SpriteBuilder/atelier_sprites/lib/data/catalog.dart.
REF = ("ref", "Référence · repos de face + repos de dos", None, [("", "I0"), ("_back", "I0")])
SHEETS_BIG = [
    REF,
    ("face_1", "Face 1 · garde, marche, sort", "face", [("_idle_2", "I1"), ("_walk", "W0"), ("_walk_2", "W1"), ("_cast", "C0")]),
    ("face_2", "Face 2 · attaques 1 à 4", "face", [("_attack", "A0"), ("_attack_2", "A1"), ("_attack_3", "A2"), ("_attack_4", "A3")]),
    ("face_3", "Face 3 · attaques 5-6, sorts 2-3", "face", [("_attack_5", "A4"), ("_attack_6", "A5"), ("_cast_2", "C1"), ("_cast_3", "C2")]),
    ("dos_1", "Dos 1 · marche, attaque, sort", "dos", [("_walk", "W0"), ("_walk_2", "W1"), ("_attack", "A0"), ("_cast", "C0")]),
    ("dos_2", "Dos 2 · attaques 2 à 4, garde", "dos", [("_attack_2", "A1"), ("_attack_3", "A2"), ("_attack_4", "A3"), ("_idle_2", "I1")]),
]
SHEETS_SMALL = [
    REF,
    ("face_1", "Face · marche, 2 attaques, sort", "face", [("_walk", "W0"), ("_attack", "A0"), ("_attack_2", "A1"), ("_cast", "C0")]),
    ("dos_1", "Dos · marche, 2 attaques, sort", "dos", [("_walk", "W0"), ("_attack", "A0"), ("_attack_2", "A1"), ("_cast", "C0")]),
]


def file_suffix(view, suf):
    """Vue de dos : _back (repos) puis _back_idle_2, _back_walk, _back_attack_3…"""
    if view != "dos":
        return suf
    return "_back" + (suf if suf else "")


def cell_text(code, arch, fx):
    k, i = code[0], int(code[1:])
    if k == "I":
        return IDLE[i]
    if k == "W":
        return WALK[i]
    src = ARCH[arch]["atk" if k == "A" else "cast"]
    return src[i].format(fx=fx)


LABELS = {"I": "repos", "W": "marche", "A": "attaque", "C": "sort"}


def pose_label(code):
    return f"{LABELS[code[0]]} {int(code[1:]) + 1}"


def prompt_sheet(who, role, nation, desc, view, cells, arch, fx, rim, palette, pale, ent_id=""):
    vtxt, vdir = VIEWS[view]
    idc, never = card(ent_id, desc, who, nation)
    lines = [
        f"Sprite sheet of ONE {role} for a chibi isometric tactical RPG. The same character appears 4 times.",
        idc,
        "Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, "
        "weapon always in the same hand, eyes open.",
        f"VIEW: {vtxt}. Never a pure side profile, never facing left.",
        f"NATION PALETTE: {palette}.",
        "STYLE: " + STYLE.format(rim=rim),
        "LAYOUT: " + grid(2, 2),
        f"POSES, left to right, top to bottom (all in {vdir} 3/4 view, never mix front and back views):",
    ]
    for i, (_, code) in enumerate(cells):
        lines.append(f"{i+1}. {cell_text(code, arch, fx)}.")
    lines.append("The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, "
                 "different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.")
    lines.append(f"EFFECTS: {fx}, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.")
    lines.append("BACKGROUND: " + (BG_GRAY if pale else BG_WHITE) + BG_TAIL)
    lines.append(reminder(ent_id, who, desc, never))
    return "\n".join(lines)


def reminder(ent_id, who, desc, never):
    """Rappel final (les générateurs pèsent davantage le début et la fin du prompt)."""
    ident = IDENT.get(ent_id)
    if ident is None:
        return f"REMINDER: this is {who}: {desc}."
    key = "; ".join(t for _, t in ident["parts"][:4])
    return f"REMINDER: this is {who}: {key}." + (f" Forbidden: {never}." if never else "")


def prompt_reference(who, role, nation, desc, rim, palette, pale, fx, ent_id=""):
    idc, never = card(ent_id, desc, who, nation)
    return "\n".join([
        f"Character reference sheet of ONE {role} for a chibi isometric tactical RPG.",
        idc,
        f"NATION PALETTE: {palette}. Signature effects (keep them small): {fx}.",
        "STYLE: " + STYLE.format(rim=rim),
        "LAYOUT: exactly 2 poses side by side on a 2:1 image (as large as possible, e.g. 2048x1024), like two "
        "separate stickers: each pose occupies at most 55% of its half of the image and is centered in it, with a "
        "wide empty space between them, feet on the same ground line. No frames, borders or dividing line.",
        "POSES: 1. LEFT: idle pose in 3/4 FRONT view, facing the viewer and turned slightly to the right. "
        "2. RIGHT: the same idle pose in 3/4 BACK view, seen from behind, turned toward the upper right, face hidden.",
        "Exactly the same character, outfit, colors and weapon in both poses (weapon in the same hand).",
        "BACKGROUND: " + (BG_GRAY if pale else BG_WHITE) + BG_TAIL,
        reminder(ent_id, who, desc, never),
    ])


def name_table(base, view, cells):
    out = ["| Case | Pose | Fichier |", "|---|---|---|"]
    cols = 2
    for i, (suf, code) in enumerate(cells):
        vue = "" if view else (" (face)" if i == 0 else " (dos)")
        out.append(f"| {i//cols+1}-{i%cols+1} | {pose_label(code)}{vue} | `{base}{file_suffix(view, suf)}.png` |")
    return "\n".join(out)


def character_md(title, ent, role, nation_txt, big, fx, rim, palette, path_hint, extra_desc=""):
    sheets = SHEETS_BIG if big else SHEETS_SMALL
    desc = ent["desc"] + extra_desc
    key = ent["id"]
    if role == "summoned familiar" and ("familier:" + key) in IDENT:
        key = "familier:" + key
    who = ent["nom"].split(" (")[0]
    nposes = sum(len(c) for _, _, _, c in sheets)
    parts = [f"### {title}\n\n{len(sheets)} planches, {nposes} poses. Commence par la fiche de référence. Chaque prompt "
             f"recopie la carte d'identité du personnage : aucune image à joindre. Fichiers dans `{path_hint}` ; nomme tes "
             f"images `{ent['id']}_<clé>.png` (ex. `{ent['id']}_face_2.png`) pour que l'Atelier les reconnaisse.\n"]
    for k, (cle, slabel, view, cells) in enumerate(sheets, 1):
        if view is None:
            p = prompt_reference(who, role, nation_txt, desc, rim, palette, ent.get("pale", False), fx, key)
        else:
            p = prompt_sheet(who, role, nation_txt, desc, view, cells, ent["arch"], fx, rim, palette,
                             ent.get("pale", False), key)
        parts.append(f"#### Planche {k} — {slabel} (`{cle}`)\n\nDans l'Atelier : personnage « {who} », "
                     f"planche « {slabel} ».\n\n```text\n{p}\n```\n\n{name_table(ent['id'], view, cells)}\n")
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
             "Chaque personnage est dessiné en **vue 3/4 avant (face)** et en **vue 3/4 arrière (dos)**. "
             "Le jeu retourne l'image pour les directions vers la gauche. Une fiche de référence (repos face + dos), "
             "puis des planches de 4 poses (2 × 2) bien séparées. Prompt négatif : voir en bas de page.\n",
             "Ordre conseillé : 1) planche de référence, 2) héros, 3) ennemis, 4) boss.\n"]
    parts.append("## 1. Planche de référence (style de la nation)\n\nNe sert pas en jeu : elle fixe palette, "
                 "matières et silhouettes, de face et de dos. Joins-la comme image de référence à toutes les "
                 "planches suivantes.\n\n"
                 f"```text\n{lineup_prompt(n)}\n```\n")
    parts.append("## 2. Héros\n\n" + character_md(f"{h['nom']} — 22 poses", h, "playable hero", "hero " + nt,
                                                  True, n["fx"], n["rim"], n["palette"], f"{GAME}/players/"))
    parts.append(f"L'export Zimut de l'Atelier copie aussi le repos vers `nations/heros/{h['id']}.png` et les "
                 "autres poses vers `nations/heros/poses/`.\n")
    parts.append("## 3. Ennemis\n")
    for e in n["enemies"]:
        parts.append(character_md(f"{e['nom']} — 10 poses", e, "enemy monster", "enemy " + nt, False, n["fx"],
                                  n["rim"], n["palette"], f"{GAME}/nations/ennemis/{n['id']}/"))
    parts.append("## 4. Boss\n\n" + character_md(
        f"{b['nom']} — 22 poses", b, "final boss", "boss " + nt, True, n["fx"], n["rim"], n["palette"],
        f"{GAME}/nations/boss/",
        ", imposing chibi with slightly longer body proportions than regular characters (head about 1/4 of "
        "total height)"))
    parts.append(f"## Prompt négatif (toutes les planches de cette page)\n\n```text\n{NEGATIVE}\n```\n")
    return "\n".join(parts)


def familiers_md():
    parts = ["# Familiers (invocations)\n",
             "Fichiers dans `" + GAME + "/summons/`. Trois planches par familier : fiche de référence (face + dos), "
             "vue 3/4 avant, vue 3/4 arrière. Joins la planche du héros qui l'invoque comme référence de style.\n"]
    for f in FAMILIERS:
        parts.append(character_md(f"{f['nom']} — 10 poses", f, "summoned familiar", "a summon", False,
                                  "matching magical sparks", "soft colored", "colors as described",
                                  f"{GAME}/summons/"))
    parts.append(f"## Prompt négatif\n\n```text\n{NEGATIVE}\n```\n")
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
        (OUT / "nations" / f"{i:02d}_{n['id']}.md").write_text(nation_md(n), encoding="utf-8")
    (OUT / "familiers.md").write_text(familiers_md(), encoding="utf-8")
    (OUT / "mecanismes.md").write_text(mecanismes_md(), encoding="utf-8")
    sheets = len(NATIONS) * (1 + len(SHEETS_BIG) * 2 + 4 * len(SHEETS_SMALL)) + len(FAMILIERS) * len(SHEETS_SMALL) + len(MECANISMES)
    print(f"{sheets} prompts générés dans {OUT}")


if __name__ == "__main__":
    main()
