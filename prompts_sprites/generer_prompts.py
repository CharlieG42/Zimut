#!/usr/bin/env python3
"""Génère les prompts de sprites chibi de Zimut (un fichier Markdown par nation + familiers + mécanismes).

Usage :  python3 prompts_sprites/generer_prompts.py
Modifier une description : éditer les dictionnaires ci-dessous puis relancer le script.
Les noms de fichiers suivent la convention du jeu (scripts/EntityView.gd, V31-V32) :
  <nom>.png (repos), <nom>_idle_2/_idle_3, <nom>_back, <nom>_walk, <nom>_attack[_2.._4], <nom>_cast[_2,_3]
"""
from pathlib import Path

OUT = Path(__file__).resolve().parent
GAME = "prototype/zimut/assets/sprites"

# --------------------------------------------------------------------------------------------
# Blocs communs (anglais : les générateurs d'images suivent mieux l'anglais)
# --------------------------------------------------------------------------------------------
STYLE = (
    "Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. "
    "Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer "
    "silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, "
    "leather straps), saturated but harmonious colors, readable silhouette at small size. "
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
    "inconsistent scale, different outfit between cells, weapon switching hands, extra arms, extra fingers, "
    "blurry smoke, semi-transparent effects, soft glow halo, floor, cast shadow, gradient background, "
    "photorealistic, 3D render, pixel art"
)


def grid(cols, rows):
    return (
        f"Strict grid of {cols} columns x {rows} rows, {cols*rows} equal cells, exactly one pose per cell. "
        "The character is centered in its cell and entirely inside it, with clear empty space all around. "
        "Wide empty gutters between cells (at least 20% of a cell). Same scale in every cell. "
        "Feet on the same ground line in each row. Effects stay small and inside their own cell."
    )


# --------------------------------------------------------------------------------------------
# Archétypes de combat : décrivent les poses d'attaque et de sort
# --------------------------------------------------------------------------------------------
ARCH = {
    "hammer_shield": dict(
        atk=["wind-up, hammer raised high behind the head, shield forward",
             "overhead strike, hammer slamming down in front, small {fx} impact at the hammer head",
             "follow-through, hammer low, body leaning forward",
             "shield bash, shield thrust forward, hammer pulled back"],
        cast=["bracing, shield planted on the ground, {fx} gathering around",
              "war cry, hammer raised to the sky, {fx} swirling around the body",
              "releasing a ring of {fx} around the feet"]),
    "daggers": dict(
        atk=["crouched wind-up, both daggers crossed in front of the chest",
             "dash slash forward, both arms extended, short {fx} slash crescents",
             "spinning follow-through, one dagger high, one low",
             "backhand stab, one dagger thrust forward, body twisted"],
        cast=["kneeling, one hand on the ground, {fx} rising from the shadow below",
              "half vanished into {fx}, only the eyes and daggers clearly visible",
              "reappearing from a burst of {fx}, daggers ready"]),
    "bow": dict(
        atk=["drawing the bow, arrow nocked, string pulled to the cheek",
             "release, arrow flying forward with a short {fx} trail",
             "follow-through, bow arm extended, string hand open behind",
             "quick shot from a low crouch, bow tilted"],
        cast=["arrow raised to the sky, {fx} gathering on the arrowhead",
              "aiming upward, the arrow fully wrapped in {fx}",
              "releasing a volley of three {fx} arrows into the air"]),
    "staff": dict(
        atk=["wind-up, staff held back with both hands",
             "staff swing forward, small {fx} burst at the tip",
             "follow-through, staff low, body turned",
             "thrust with the staff tip forward, short {fx} spark"],
        cast=["staff raised, {fx} orb forming at the top",
              "staff held high with both hands, {fx} swirling around",
              "staff pointed forward, releasing a compact {fx} blast"]),
    "staff_book": dict(
        atk=["wind-up, staff held back, grimoire floating open beside",
             "staff swing forward, small {fx} burst at the tip",
             "follow-through, staff low, coat swirling",
             "open palm thrust, {fx} bolt leaving the hand"],
        cast=["grimoire floating open, pages turning, {fx} rising from it",
              "staff raised, a {fx} summoning circle drawn on the ground",
              "both arms open, a {fx} creature silhouette emerging from the circle"]),
    "wrench": dict(
        atk=["wind-up, gear hammer swung back over the shoulder",
             "smash forward, gear hammer hitting with a burst of {fx}",
             "follow-through, hammer low, goggles bouncing",
             "throwing a small round bomb forward with the free hand"],
        cast=["kneeling, adjusting a small device on the ground, {fx} crackling",
              "standing, raising a glowing remote control, {fx} arcing around",
              "pointing forward, a {fx} blast leaving the device"]),
    "beast": dict(
        atk=["crouched wind-up, ready to pounce",
             "lunge forward, jaws or claws first, small {fx} impact",
             "follow-through, landing after the lunge",
             "second strike, swiping sideways"],
        cast=["head raised, {fx} gathering around the body",
              "roaring, {fx} burst around the head",
              "releasing a short {fx} breath or wave forward"]),
    "brute": dict(
        atk=["wind-up, fist or weapon raised high",
             "heavy smash forward, ground cracking with a small {fx} burst",
             "follow-through, body leaning forward",
             "sweeping backhand blow"],
        cast=["stomping, {fx} cracks spreading under the feet",
              "arms raised, {fx} gathering between the hands",
              "slamming both fists down, {fx} shockwave"]),
    "spirit": dict(
        atk=["drawing back, body stretched upward",
             "lunging forward, claws of {fx} reaching out",
             "follow-through, body trailing behind",
             "spinning strike, {fx} whirl around the body"],
        cast=["hovering higher, {fx} orbs circling the body",
              "arms spread, {fx} pulsing outward",
              "releasing a compact {fx} wave forward"]),
    "ranged_caster": dict(
        atk=["wind-up, weapon or hand pulled back",
             "strike forward, small {fx} burst",
             "follow-through",
             "second strike, aimed low"],
        cast=["hand raised, {fx} gathering",
              "both hands raised, {fx} swirling",
              "releasing a {fx} projectile forward"]),
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

HERO_CELLS = [  # (suffixe de fichier, description de cellule)
    ("", "idle, 3/4 view facing front-right, relaxed ready stance"),
    ("_idle_2", "idle variant, breathing in, shoulders slightly raised, same stance"),
    ("_idle_3", "idle variant, alert, glancing to the side, weapon ready"),
    ("_back", "idle seen from behind, 3/4 back-right view"),
    ("_walk", "walking, 3/4 front-right, mid-stride, left foot forward"),
    ("_attack", "ATK0"), ("_attack_2", "ATK1"), ("_attack_3", "ATK2"), ("_attack_4", "ATK3"),
    ("_cast", "CAST0"), ("_cast_2", "CAST1"), ("_cast_3", "CAST2"),
]
SMALL_CELLS = [
    ("", "idle, 3/4 view facing front-right"),
    ("_idle_2", "idle variant, breathing, slightly different posture"),
    ("_back", "idle seen from behind, 3/4 back-right view"),
    ("_walk", "moving forward, 3/4 front-right"),
    ("_attack", "ATK0"), ("_attack_2", "ATK1"), ("_cast", "CAST0"), ("_cast_2", "CAST2"),
]


def cells(kind, arch, fx):
    a = ARCH[arch]
    rep = {f"ATK{i}": s.format(fx=fx) for i, s in enumerate(a["atk"])}
    rep.update({f"CAST{i}": s.format(fx=fx) for i, s in enumerate(a["cast"])})
    src = HERO_CELLS if kind == "big" else SMALL_CELLS
    return [(suf, rep.get(d, d), d) for suf, d in src]


LABELS = {"": "repos", "_idle_2": "repos 2", "_idle_3": "repos 3", "_back": "dos", "_walk": "marche",
          "_attack": "attaque 1", "_attack_2": "attaque 2", "_attack_3": "attaque 3", "_attack_4": "attaque 4",
          "_cast": "sort 1", "_cast_2": "sort 2", "_cast_3": "sort 3"}


def pose_label(suf):
    return LABELS.get(suf, suf)


def prompt_sheet(who, role, nation, desc, kind, arch, fx, rim, palette, pale):
    cs = cells(kind, arch, fx)
    cols, rows = (4, 3) if kind == "big" else (4, 2)
    lines = [
        f"Sprite sheet of ONE {role} for a chibi isometric tactical RPG.",
        f"CHARACTER: {who}, {nation}. {desc[0].upper() + desc[1:]}.",
        "Keep exactly the same design in every cell: same outfit, colors, proportions, accessories"
        + (", weapon always in the same hand." if kind == "big" else "."),
        f"NATION PALETTE: {palette}.",
        "STYLE: " + STYLE.format(rim=rim),
        "GRID: " + grid(cols, rows),
        "CELLS, left to right, top to bottom:",
    ]
    for i, (_, d, _) in enumerate(cs):
        lines.append(f"{i+1}. {d}.")
    lines.append(f"EFFECTS: {fx}, stylized, opaque, with dark outlines, small and inside their cell.")
    lines.append("BACKGROUND: " + (BG_GRAY if pale else BG_WHITE) + BG_TAIL)
    return "\n".join(lines), cs, (cols, rows)


def name_table(base, cs, cols):
    out = ["| Case | Pose | Nom à donner dans l'Atelier | Fichier |", "|---|---|---|---|"]
    for i, (suf, _, raw) in enumerate(cs):
        out.append(f"| {i//cols+1}-{i%cols+1} | {pose_label(suf)} | `{base}{suf}` | `{base}{suf}.png` |")
    return "\n".join(out)


def block(title, intro, prompt, table, path_hint):
    return (f"### {title}\n\n{intro}\n\n```text\n{prompt}\n```\n\n"
            f"Fichiers attendus dans `{path_hint}` :\n\n{table}\n")


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
        f"LAYOUT: {len(chars)} characters standing side by side in ONE single row, all in idle pose, all in "
        "3/4 view facing front-right, all feet on the same ground line, a wide empty gap between characters "
        "(at least half a character width). Nobody overlaps or touches another character.",
        "CHARACTERS, left to right:",
        *[f"{i+1}. {c}." for i, c in enumerate(chars)],
        "BACKGROUND: " + (BG_GRAY if pale else BG_WHITE) + BG_TAIL,
    ])


def nation_md(n):
    h, b = n["hero"], n["boss"]
    parts = [f"# Nation {n['nom']} ({n['biome']})\n",
             f"Palette : {n['palette']}. Effets : {n['fx']}. Contre-jour : {n['rim']}.\n",
             "Ordre conseillé : 1) planche de référence, 2) héros (en joignant la planche 1 comme image de "
             "référence), 3) ennemis, 4) boss. Prompt négatif : voir en bas de page.\n"]
    parts.append("## 1. Planche de référence (style de la nation)\n\nNe sert pas en jeu : elle fixe palette, "
                 "matières et silhouettes. Joins-la comme image de référence aux planches suivantes.\n\n"
                 f"```text\n{lineup_prompt(n)}\n```\n")
    p, cs, (c, _) = prompt_sheet(h["nom"], "playable hero", f"hero of the {n['nom']} nation", h["desc"], "big",
                                 h["arch"], n["fx"], n["rim"], n["palette"], h["pale"])
    parts.append("## 2. Héros\n\n" + block(f"{h['nom']} — 12 poses", "Grille 4 × 3.", p,
                                           name_table(h["id"], cs, c), f"{GAME}/players/"))
    parts.append(f"Copie conseillée de la pose de repos vers `{GAME}/nations/heros/{h['id']}.png` "
                 "et des poses vers `nations/heros/poses/`.\n")
    parts.append("## 3. Ennemis\n")
    for e in n["enemies"]:
        p, cs, (c, _) = prompt_sheet(e["nom"], "enemy monster", f"enemy of the {n['nom']} nation", e["desc"],
                                     "small", e["arch"], n["fx"], n["rim"], n["palette"], e.get("pale", False))
        parts.append(block(f"{e['nom']} — 8 poses", "Grille 4 × 2.", p, name_table(e["id"], cs, c),
                           f"{GAME}/nations/ennemis/{n['id']}/"))
    p, cs, (c, _) = prompt_sheet(b["nom"], "final boss", f"boss of the {n['nom']} nation",
                                 b["desc"] + ", imposing chibi with slightly longer body proportions than regular "
                                 "characters (head about 1/4 of total height)", "big", b["arch"], n["fx"], n["rim"],
                                 n["palette"], b["pale"])
    parts.append("## 4. Boss\n\n" + block(f"{b['nom']} — 12 poses", "Grille 4 × 3.", p,
                                          name_table(b["id"], cs, c), f"{GAME}/nations/boss/"))
    parts.append(f"## Prompt négatif (toutes les planches de cette page)\n\n```text\n{NEGATIVE}\n```\n")
    return "\n".join(parts)


def familiers_md():
    parts = ["# Familiers (invocations)\n",
             "Fichiers dans `" + GAME + "/summons/`. Palette libre par familier, même style que les nations. "
             "Les familiers d'une même classe gagnent à être générés avec la planche du héros en référence.\n"]
    for f in FAMILIERS:
        p, cs, (c, _) = prompt_sheet(f["nom"].split(" (")[0], "summoned familiar", "a summon", f["desc"], "small",
                                     f["arch"], "matching magical sparks", "soft colored", "colors as described",
                                     f.get("pale", False))
        parts.append(block(f"{f['nom']} — 8 poses", "Grille 4 × 2.", p, name_table(f["id"], cs, c),
                           f"{GAME}/summons/"))
    parts.append(f"## Prompt négatif\n\n```text\n{NEGATIVE}\n```\n")
    return "\n".join(parts)


def mecanismes_md():
    parts = ["# Mécanismes (objets fixes)\n",
             "Une seule pose par objet : ces planches peuvent regrouper plusieurs objets. Fichiers dans `"
             + GAME + "/summons/<id>.png`.\n"]
    for cls, objs in MECANISMES:
        n = len(objs)
        cols = min(4, n)
        rows = (n + cols - 1) // cols
        lines = [f"Object sprite sheet for a chibi isometric tactical RPG: {n} summoned objects of the {cls} class.",
                 "STYLE: " + OBJ_STYLE,
                 f"GRID: strict grid of {cols} columns x {rows} rows, one object per cell, each object centered "
                 "and entirely inside its cell, wide empty gutters between cells, all objects resting on the "
                 "same ground line, seen from a 3/4 top-front angle.",
                 "OBJECTS, left to right:"]
        lines += [f"{i+1}. {d}." for i, (_, d) in enumerate(objs)]
        lines.append("BACKGROUND: " + BG_WHITE + BG_TAIL)
        table = ["| Case | Objet | Fichier |", "|---|---|---|"]
        table += [f"| {i+1} | {o} | `{o}.png` |" for i, (o, _) in enumerate(objs)]
        parts.append(f"## {cls}\n\n```text\n" + "\n".join(lines) + "\n```\n\n" + "\n".join(table) + "\n")
    parts.append(f"## Prompt négatif\n\n```text\n{NEGATIVE}\n```\n")
    return "\n".join(parts)


def main():
    (OUT / "nations").mkdir(exist_ok=True)
    for i, n in enumerate(NATIONS, 1):
        (OUT / "nations" / f"{i:02d}_{n['id']}.md").write_text(nation_md(n), encoding="utf-8")
    (OUT / "familiers.md").write_text(familiers_md(), encoding="utf-8")
    (OUT / "mecanismes.md").write_text(mecanismes_md(), encoding="utf-8")
    total = len(NATIONS) * 7 + len(FAMILIERS) + len(MECANISMES)
    print(f"{total} prompts générés dans {OUT}")


if __name__ == "__main__":
    main()
