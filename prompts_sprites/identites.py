"""Cartes d'identité des personnages (V38) — recopiées mot pour mot dans CHAQUE prompt.

Le générateur d'images ne voit pas les autres planches : tout ce qui n'est pas écrit est réinventé
(couleur des yeux, du pantalon, des bottes, forme de l'arme…). Chaque carte fixe donc TOUTES les
parties visibles, avec des couleurs nommées et un code hexadécimal, et liste ce qui est interdit.

Pour modifier un personnage : éditer sa carte ici, puis relancer `python3 prompts_sprites/generer_prompts.py`.
Clé = identifiant du personnage (nom de fichier). Champs : liste de (partie, description).
Le champ « never » liste les dérives déjà observées à interdire explicitement.
"""

IDENT = {
    # ---------------------------------------------------------------- héros
    "druide": dict(parts=[
        ("hair", "messy short dark green hair (#2E5E3A) with a few small leaves in it"),
        ("eyes", "amber eyes (#E0A030), always open"),
        ("skin", "light peach skin"),
        ("top", "armor-robe of overlapping moss-green leaves (#5E8C3A) and brown bark plates (#6B4A2B)"),
        ("bottom", "dark brown trousers (#4A3420)"),
        ("feet", "brown leather boots wrapped with green cloth"),
        ("weapon", "tall wooden staff topped with a leaf-shaped emerald crystal (#3FD08A), RIGHT hand"),
        ("details", "two crossed leather belts on the chest"),
    ], never="no hood, no cape, no blond hair, no blue clothes"),
    "tank": dict(parts=[
        ("hair", "white hair combed back and a big full white beard"),
        ("eyes", "steel-blue eyes (#4A7FB0), thick white eyebrows, always open"),
        ("skin", "tanned skin"),
        ("top", "heavy dark steel-blue plate armor (#3A4E6E) with white fur trim on the shoulders and small ice-blue crystal inlays (#9FE3FF)"),
        ("bottom", "steel-blue armored tassets over dark grey trousers"),
        ("feet", "heavy steel boots"),
        ("weapon", "rune-engraved war hammer in the RIGHT hand; large round steel shield with a cloud-and-mountain emblem on the LEFT arm"),
    ], never="no helmet, no cape, no sword, no brown beard"),
    "geomancien": dict(parts=[
        ("age", "ADULT man in his late twenties (not a boy, not a teenager): mature square face with a defined jaw and light stubble, broad shoulders, sturdy athletic build"),
        ("hair", "short brown hair (#7A4A28)"),
        ("eyes", "amber-brown eyes, always open"),
        ("skin", "light tan skin"),
        ("top", "layered sand-gold robe (#D9B26A) with terracotta panels (#B8562E) and small amber gems"),
        ("bottom", "sand-colored wrapped trousers"),
        ("feet", "brown sandals with cloth wraps"),
        ("weapon", "golden staff topped with a large faceted amber crystal (#F2A93B), RIGHT hand"),
    ], never="no hood, no turban, no hat, no headband, no scarf over the head, no blue or green clothes, no child proportions, no round baby face, no missing staff",
       proportions="adult chibi: head about one third of the total height (NOT 40%), adult body proportions, broad shoulders, "
                   "defined jaw and brows, serious calm expression — clearly a grown man like the adult heroes of Dofus, never a child"),
    "mage": dict(parts=[
        ("hair", "dark navy-blue hair (#1E2C5A), medium length, side bangs"),
        ("eyes", "bright blue eyes (#3FA0FF), always open"),
        ("skin", "fair skin"),
        ("top", "long silver-white robe (#E8ECF4) with light-blue crystal patterns and sapphire trims (#2A5BD7)"),
        ("bottom", "the robe reaches the ankles, dark blue trousers visible below"),
        ("feet", "dark blue boots with silver tips"),
        ("weapon", "ornate silver staff topped with a glowing blue crystal (#5CC8FF), RIGHT hand"),
        ("held item", "an ornate brown leather spellbook with golden corners and a sapphire gem on the cover, held open in the LEFT hand"),
    ], never="no wizard hat, no white or silver hair, no beard, no missing spellbook"),
    "heal": dict(parts=[
        ("hair", "long teal hair (#2BB3A8) tied low behind the back"),
        ("eyes", "soft turquoise eyes, always open"),
        ("skin", "fair skin"),
        ("top", "ornate white robe with turquoise panels (#3CC7C0), gold embroidery and wave patterns"),
        ("bottom", "long white robe skirt with turquoise hem"),
        ("feet", "white and gold slippers"),
        ("weapon", "golden staff topped with a glowing water-drop crystal (#7FE8FF), RIGHT hand"),
    ], never="no hood, no armor, no dark clothes"),
    "sylvain": dict(parts=[
        ("hair", "short messy pale mint-white hair (#DDF2EE) with long bangs over the forehead"),
        ("eyes", "teal-green eyes (#2E9C94), always open, calm smile"),
        ("skin", "light peach skin"),
        ("top", "pale teal tunic (#9FE0D6) made of layered leaf-shaped feathers, white collar and a white front panel, small gold leaf brooch on the chest"),
        ("bottom", "pale teal and white layered skirt-robe down to the knees, dark charcoal leggings (#33383F)"),
        ("feet", "white boots with gold trims"),
        ("arms", "silver bracers on both forearms"),
        ("weapon", "slim brown wooden staff topped with a mint crystal (#7FF0D8) between two small white wings, RIGHT hand"),
    ], never="no orange or brown trousers, no brown eyes, no closed eyes, no pure white spiky hair, no long hair, no blue robe, no spear"),
    "chasseur": dict(parts=[
        ("hair", "long bright red hair (#D6332A) in a high ponytail"),
        ("eyes", "golden eyes, always open"),
        ("skin", "fair skin"),
        ("top", "black armor with gold trims and red flame-shaped plates (#1E1A1C, #C8281E) and glowing ember cracks, red scarf, short red cape with a flame-patterned hem"),
        ("bottom", "black trousers with red armored thigh plates"),
        ("feet", "brown boots with gold trims"),
        ("weapon", "curved flame-patterned bow in the LEFT hand, quiver of arrows on the back"),
    ], never="no helmet, no sword, no brown hair"),
    "invocateur": dict(parts=[
        ("hair", "black hair (#15151C), medium length, messy bangs"),
        ("eyes", "violet eyes (#9B6BFF), always open"),
        ("skin", "pale skin"),
        ("top", "long black coat with violet trims (#7A3FD0) and silver clasps"),
        ("bottom", "black trousers"),
        ("feet", "black boots with silver buckles"),
        ("weapon", "spiked dark staff topped with a violet crystal, RIGHT hand; a dark grimoire floating at his left side"),
    ], never="no hood, no mask, no white hair"),
    "assassin": dict(parts=[
        ("hair", "spiky black hair (#121216)"),
        ("eyes", "violet glowing eyes (#B070FF), always visible above the mask"),
        ("face", "black cloth mask covering the nose and mouth"),
        ("top", "dark charcoal hooded armor (#2A2C33), hood DOWN, layered tattered silver-teal cloth panels (#8FC9C0), violet rune details"),
        ("bottom", "charcoal trousers with silver-teal cloth strips"),
        ("feet", "black soft boots"),
        ("weapon", "one curved dagger in EACH hand"),
    ], never="no horns, no helmet, no claws, no sword"),
    "artificier": dict(parts=[
        ("hair", "spiky brown hair (#6B3E1E)"),
        ("eyes", "green eyes, always open"),
        ("head", "brass goggles pushed up on the forehead"),
        ("top", "bronze and steel steampunk armor with small teal glowing gems (#2FE0C8)"),
        ("bottom", "brown trousers, tool belt with pouches"),
        ("feet", "heavy brown boots with brass caps"),
        ("weapon", "big gear-headed hammer, RIGHT hand"),
    ], never="no top hat, no gun, no cape"),
    # ---------------------------------------------------------------- boss
    "sylvestre": dict(parts=[
        ("body", "towering forest giant with a body of brown bark (#5A3E26) and green moss (#4F7A32)"),
        ("head", "great deer antlers covered in leaves, long beard of hanging moss, glowing green eyes"),
        ("weapon", "thorny wooden club set with a green crystal, RIGHT hand"),
    ], never="no armor, no metal"),
    "cimes": dict(parts=[
        ("body", "massive frost knight in dark steel armor (#2E3A4E) covered with ice crystals and white snow fur"),
        ("head", "closed crowned helm of ice spikes, glowing ice-blue eye slit"),
        ("weapon", "heavy rune hammer in the RIGHT hand, huge crystal-studded tower shield on the LEFT arm"),
    ], never="no visible face, no cape"),
    "sables": dict(parts=[
        ("body", "sand sovereign in ornate golden armor (#D4A63A) with sharp layered plates"),
        ("head", "crested golden helm, dark face shadow with glowing amber eyes"),
        ("weapon", "tall golden staff with a giant amber crystal, RIGHT hand"),
    ], never="no cape, no sword"),
    "cristaux": dict(parts=[
        ("body", "tall crystal sorcerer in a long robe of shattered pale crystal plates (#CFE4FF)"),
        ("head", "crown of ice-blue shards, pale face, glowing violet eyes"),
        ("weapon", "ornate crystal staff, RIGHT hand"),
    ], never="no hood, no beard"),
    "marees": dict(parts=[
        ("body", "sea queen in turquoise coral armor (#2BB8B0) with gold edges, flowing white sea-foam cape"),
        ("head", "crown of red coral branches, long deep-blue hair, blue eyes"),
        ("weapon", "golden trident, RIGHT hand"),
    ], never="no fish tail, no sword"),
    "vents": dict(parts=[
        ("body", "celestial lord in pale cyan feathered armor (#BDEFFF) with long flowing feather layers"),
        ("head", "crown of silver spikes, long white hair, pale blue eyes"),
        ("weapon", "tall silver staff with a wing-shaped crystal, RIGHT hand"),
    ], never="no helmet, no dark colors"),
    "brasier": dict(parts=[
        ("body", "flame warlord in black and crimson ember armor (#1E1418, #B0201A) with sharp plates and glowing cracks"),
        ("head", "burning orange hair like flames, golden eyes"),
        ("weapon", "great curved flame bow, LEFT hand"),
    ], never="no helmet, no sword"),
    "brumes": dict(parts=[
        ("body", "dark necromancer in black spiked armor with a violet tattered cloak (#5E3A8A)"),
        ("head", "spiked crown, gaunt pale face, glowing mint eyes"),
        ("weapon", "skull-topped staff surrounded by mint mist, RIGHT hand"),
    ], never="no hood, no sword"),
    "ombres": dict(parts=[
        ("body", "tall illusionist in black armor (#18181E) with spiky layers of silver-teal tattered cloth (#8FC9C0)"),
        ("head", "horned black mask-helm with a silver face plate, long white hair, glowing violet eyes"),
        ("weapon", "two long thin blades, one in each hand, violet mirror-like glints"),
    ], never="no shield, no staff"),
    "rouages": dict(parts=[
        ("body", "giant steam colossus of steel and brass (#B8873A) with two smoking chimneys on the back"),
        ("head", "riveted steel head with two glowing blue eyes"),
        ("details", "glowing blue core in the chest"),
        ("weapon", "huge gear hammer, RIGHT hand"),
    ], never="no wings, no human face"),
    # ---------------------------------------------------------------- ennemis des Vents (essai V38)
    "garde_aerien": dict(parts=[
        ("body", "small chibi sky guard, round body"),
        ("head", "round pale ice-blue helmet (#BFE6F0) with a short fin on top and two small white wings on the sides, a WHITE face mask with two big dark-red eyes (#8A1E1E)"),
        ("top", "pale ice-blue armor (#BFE6F0) with silver shoulder plates and a brown leather strap across the chest"),
        ("bottom", "pale ice-blue tabard over dark navy trousers (#2E3550)"),
        ("feet", "dark navy armored boots"),
        ("weapon", "halberd with a brown wooden shaft and a large silver axe blade, RIGHT hand"),
    ], never="no visor, no spear, no cape, no human face"),
    "aigle_celeste": dict(parts=[
        ("body", "large deep blue eagle (#1F4FA8) with lighter blue chest feathers"),
        ("head", "white-blue head, golden hooked beak, sharp yellow eyes"),
        ("details", "golden talons, wide spread wings"),
    ], never="no rider, no armor"),
    "harpie": dict(parts=[
        ("body", "harpy woman with green and gold feathered wings (#3E9A5A, #E0B040) instead of arms"),
        ("head", "wild green hair, yellow eyes"),
        ("bottom", "bird legs with yellow talons, short green feather skirt"),
    ], never="no human arms, no weapon"),
    "elementaire_de_vent": dict(parts=[
        ("body", "round pale blue cloud body (#CFEFFF) with swirling wind ribbons around it"),
        ("head", "two big friendly dark eyes on the cloud, no mouth"),
        ("details", "two small arms made of wind swirls, no legs"),
    ], never="no human body, no weapon"),
    # ---------------------------------------------------------------- ennemis des autres nations (V38)
    # Forêt
    "araknea": dict(parts=[
        ("body", "forest spider-beetle with six thin dark-brown legs (#3B2A1E) and a domed emerald armored carapace (#2FA060) with lighter green edges"),
        ("head", "two curved ivory horns, sharp brown mandibles, four small glowing amber eyes (#F2B233)"),
    ], never="no eight legs, no wings, no human body, no weapon"),
    "loup_forestier": dict(parts=[
        ("body", "sturdy four-legged wolf with dark moss-green fur (#3E5E34) and a lighter sage belly"),
        ("head", "mane of green leaves and brown twigs around the neck, amber eyes (#E0A030), black nose"),
        ("details", "bushy tail tipped with leaves"),
    ], never="no armor, no rider, no grey or brown fur, never standing on two legs"),
    "dryade": dict(parts=[
        ("body", "slim dryad woman whose body is made of light-brown branches (#8A6238) and green leaves (#5FAE48)"),
        ("head", "long hair made of green leaves with small pink flowers, glowing green eyes (#7CFF8A)"),
        ("weapon", "simple wooden bow in the LEFT hand, no quiver"),
    ], never="no clothes, no metal, no human skin"),
    "treant": dict(parts=[
        ("body", "walking tree-trunk brute of dark brown bark (#5A3E26) covered in green moss (#4F7A32)"),
        ("head", "no neck, a face carved in the trunk with two glowing green eyes (#7CFF8A) and a crooked mouth, leafy crown on top"),
        ("details", "two thick branch arms, root-like legs"),
    ], never="no weapon, no armor, no flowers"),
    # Montagne
    "guerrier_des_monts": dict(parts=[
        ("body", "stocky mountain warrior with rocky brown skin (#8A6A4A) cracked like stone"),
        ("head", "bald rocky head, small white eyes, short stone beard"),
        ("top", "fur vest of white snow fur with a leather belt"),
        ("bottom", "dark brown fur trousers, bare stone feet"),
        ("weapon", "crude grey stone gauntlets on both fists, no other weapon"),
    ], never="no helmet, no sword, no axe, no human skin"),
    "griffon_des_cimes": dict(parts=[
        ("body", "griffin with a tawny lion body (#C9A060) and four legs, front legs with eagle talons"),
        ("head", "white eagle head, yellow hooked beak, golden eyes"),
        ("details", "large blue-grey feathered wings (#7A8CA8), lion tail with a white tuft"),
    ], never="no rider, no saddle, no armor"),
    "garde_des_pics": dict(parts=[
        ("body", "peak guardian golem of smooth blue-grey stone blocks (#6E8296)"),
        ("head", "small square stone head with two glowing ice-blue eyes (#9FE3FF)"),
        ("details", "clusters of glowing ice-blue crystals (#9FE3FF) on both shoulders, big stone fists"),
    ], never="no weapon, no moss, no brown stone"),
    "rochebrute": dict(parts=[
        ("body", "hulking brute made of round brown boulders (#7A5A3A), huge hunched shoulders"),
        ("head", "small boulder head sunk between the shoulders, two small glowing orange eyes (#FF9A3A)"),
        ("details", "huge boulder fists, short stumpy legs"),
    ], never="no crystals, no weapon, no grey stone"),
    # Désert
    "bandit_des_dunes": dict(parts=[
        ("body", "small jackal-folk bandit standing on two legs, orange fur (#D9822B) with a cream muzzle"),
        ("head", "tall jackal ears, yellow eyes, sand-colored scarf (#E3CF9A) over the mouth"),
        ("top", "brown leather vest with a red sash"),
        ("bottom", "baggy sand-colored trousers, bare paws"),
        ("weapon", "one curved dagger in the RIGHT hand"),
    ], never="no bow, no sword, no hood, no human face"),
    "scarabee_geant": dict(parts=[
        ("body", "giant scarab beetle on six legs, glossy black shell (#1A1A1E) with gold edges and patterns (#E0B040)"),
        ("head", "big golden horn and two smaller golden horns, small red eyes"),
    ], never="no wings spread, no rider, no human body"),
    "genie_du_desert": dict(parts=[
        ("body", "golden-skinned sand djinn (#E0B050) with a muscular bare chest and arms, golden bracelets"),
        ("head", "bald head with a long black topknot, glowing amber eyes, pointed ears"),
        ("bottom", "no legs: lower body of swirling sand (#D9C08A)"),
    ], never="no weapon, no blue skin, no clothes on the torso"),
    "sphinx": dict(parts=[
        ("body", "golden lion sphinx on four legs (#D9A848) with a lion tail"),
        ("head", "human-like calm face, striped blue-and-gold pharaoh headdress (#2E56A8, #E0B040), kohl-lined amber eyes"),
        ("details", "small golden collar, no wings"),
    ], never="no wings, no weapon, standing on four legs only"),
    # Cristaux
    "araignee_de_cristal": dict(parts=[
        ("body", "spider with a round body made of violet amethyst crystals (#8A4FD8)"),
        ("head", "cluster of small glowing ice-blue eyes (#9FE3FF), crystal fangs"),
        ("details", "eight thin glowing ice-blue crystal legs (#9FE3FF)"),
    ], never="no fur, no green, no human body"),
    "mage_cristallin": dict(parts=[
        ("body", "slender crystal mage with a smooth pale blue body (#BFD8FF)"),
        ("head", "hair made of sharp violet crystal shards (#8A4FD8), glowing white eyes"),
        ("top", "short dark violet robe with silver trims"),
        ("weapon", "slim crystal staff with a violet crystal tip, RIGHT hand"),
    ], never="no human skin, no hat, no hood"),
    "golem_de_cristal": dict(parts=[
        ("body", "heavy golem made of violet (#8A4FD8) and blue (#4F7FE0) crystal clusters on a dark grey rock core"),
        ("head", "small head of crystal with two glowing white eyes"),
        ("details", "huge crystal fists"),
    ], never="no weapon, no green, no moss"),
    "elementaire_de_cristal": dict(parts=[
        ("body", "floating humanoid elemental made of sharp violet crystal shards (#8A4FD8), no legs, shards hovering apart at the joints"),
        ("head", "pointed crystal head with two glowing ice-blue eyes (#9FE3FF)"),
        ("details", "a glowing ice-blue core in the chest"),
    ], never="no feet on the ground, no weapon, no clothes"),
    # Marées
    "pirate_des_mers": dict(parts=[
        ("hair", "red bandana (#C8281E) over messy black hair, stubble"),
        ("eyes", "dark brown eyes, always open, one gold earring"),
        ("top", "blue coat (#2A4E8A) with gold buttons over a white shirt, crossed brown leather belts"),
        ("bottom", "dark brown trousers"),
        ("feet", "black boots"),
        ("weapon", "short cutlass in the RIGHT hand"),
    ], never="no hat, no eye patch, no wooden leg, no pistol, no parrot"),
    "requin": dict(parts=[
        ("body", "blue shark (#3A6EB8) with a white belly, standing upright in the air on its tail"),
        ("head", "wide toothy grin with white teeth, small black eyes"),
        ("details", "two pectoral fins used like small arms"),
    ], never="no legs, no weapon, no armor"),
    "nereide": dict(parts=[
        ("body", "water nymph whose body is made of opaque turquoise water (#3CC7C0) with lighter highlights"),
        ("head", "flowing hair of white-capped waves, glowing white eyes, small shell crown"),
        ("bottom", "lower body ends in a swirl of water, no legs"),
    ], never="no clothes, no weapon, no fish tail with scales"),
    "crabe_geant": dict(parts=[
        ("body", "giant crab with a blue shell (#2E62B0) striped with red (#D23A2A), six walking legs"),
        ("head", "two eyes on short stalks, small mouth"),
        ("details", "two huge pincers, the right one bigger"),
    ], never="no human body, no weapon"),
    # Brasier
    "lieutenant": dict(parts=[
        ("hair", "hood up, face in shadow with two glowing orange eyes (#FF8A2A)"),
        ("top", "orange and red layered cultist robes (#E06A1E, #B0201A) with a black belt"),
        ("bottom", "long robe to the ankles"),
        ("feet", "black boots"),
        ("weapon", "black staff topped with a burning flame, RIGHT hand"),
    ], never="no visible face, no armor, no sword"),
    "salamandre": dict(parts=[
        ("body", "chubby orange lava lizard (#E0701E) standing upright on two short hind legs with small front arms, darker orange back, cream belly"),
        ("head", "round head, big yellow eyes, small smile"),
        ("details", "glowing yellow cracks along the back, tail ending in a flame"),
    ], never="no wings, no armor, no weapon, no torch, no held object"),
    "devoreur_de_flammes": dict(parts=[
        ("body", "stocky upright fiery orange beast (#E05A1E) with a dark charcoal belly and two big curved dark horns"),
        ("head", "big jaw with fangs, glowing yellow eyes, mane of flames"),
        ("details", "big black claws, flaming tail tip"),
    ], never="no wings, no armor, no rider, no weapon, no torch, no held object"),
    "golem_de_lave": dict(parts=[
        ("body", "dark basalt golem (#2A2426) with bright orange lava cracks (#FF7A1E)"),
        ("head", "small head with two glowing orange eyes"),
        ("details", "molten glowing core in the chest, huge rock fists"),
    ], never="no weapon, no crystals, no moss"),
    # Brumes
    "brumeux": dict(parts=[
        ("body", "hulking mist beast with a fluffy lavender cloud body (#B8A8E0)"),
        ("head", "no visible neck, two small glowing mint eyes (#9FFFD8)"),
        ("details", "two thick cloud arms with small dark claws, no legs visible"),
    ], never="no weapon, no clothes, no teeth"),
    "gargouille": dict(parts=[
        ("body", "grey stone gargoyle (#7A7A82) crouching on two legs, cracked stone texture"),
        ("head", "small horns, pointed ears, fanged mouth, glowing mint eyes (#9FFFD8)"),
        ("details", "stone bat wings, long tail with an arrow tip"),
    ], never="no weapon, no color other than grey stone and mint eyes"),
    "liche_des_brumes": dict(parts=[
        ("body", "thin skeletal lich, bony grey hands"),
        ("head", "skull face with glowing mint eyes (#9FFFD8) under a tattered hood"),
        ("top", "tattered violet robes (#6A4A9A) with torn edges"),
        ("weapon", "crooked wooden staff, RIGHT hand"),
    ], never="no crown, no armor, no hair"),
    "fantome": dict(parts=[
        ("body", "pale blue ghost (#BFE3FF) with a round head-body and a wavy tail, no legs"),
        ("head", "mischievous face: big dark eyes, tongue out"),
        ("details", "two small rounded arms"),
    ], never="no sheet with holes, no chains, no weapon"),
    # Ombres (d'après les sprites Mistral intégrés en V37)
    "assassin_des_ombres": dict(parts=[
        ("body", "hunched four-legged shadow beast, black body (#141418) with charcoal armor straps and silver-teal cloth bands (#8FC9C0) on the legs"),
        ("head", "spiky purple mane (#8A3FD8) on head and back, glowing violet eyes (#B070FF)"),
        ("details", "long black claws, violet lightning glints"),
    ], never="no human face, no hood, no weapon in hand"),
    "ombre_infernale": dict(parts=[
        ("body", "humanoid of purple-black shadow (#1E1428) in dark armor with silver-teal cloth panels (#8FC9C0)"),
        ("head", "round head of swirling purple shadow with ONE glowing violet eye (#C080FF), no mouth"),
        ("details", "long black claws, small purple flame wisps around the hands"),
    ], never="no human face, no hair, no weapon"),
    "spectre": dict(parts=[
        ("body", "small hunched spectral figure, violet-grey skin (#5A4A78) wrapped in silver bandages"),
        ("head", "big bald round violet head, half-closed glowing lilac eyes (#C8A8FF)"),
        ("bottom", "silver-teal loincloth (#8FC9C0), lower body fading into dark shadow curls"),
        ("details", "long claw-like hands"),
    ], never="no hair, no hood, no weapon"),
    "liche": dict(parts=[
        ("body", "tall dark lich in a black and purple spiked robe (#1E1428, #5A2A8A) with silver-teal trims"),
        ("head", "purple skull (#4A3460) with glowing white-violet eyes and a crown of black spikes"),
        ("weapon", "dark staff topped with a violet crystal, RIGHT hand"),
    ], never="no hair, no hood, no flesh face"),
    # Rouages
    "drone_aerien": dict(parts=[
        ("body", "round bronze flying drone (#B8873A) with riveted plates"),
        ("head", "single glowing blue core eye (#3FC8FF) in the front"),
        ("details", "two small propellers on top, two jointed claw arms below"),
    ], never="no legs, no wings, no human parts"),
    "araignee_mecanique": dict(parts=[
        ("body", "bronze mechanical spider (#B8873A) with a riveted round body"),
        ("head", "single blue gem eye (#3FC8FF)"),
        ("details", "eight long jointed steel legs (#8A9098)"),
    ], never="no fur, no organic parts"),
    "roue_engrenee": dict(parts=[
        ("body", "rolling bronze cog-wheel creature (#B8873A) standing upright on its edge"),
        ("head", "single glowing blue gem eye (#3FC8FF) in the center of the wheel"),
        ("details", "two small jointed steel arms on the sides"),
    ], never="no legs, no face other than the gem eye"),
    "automate_de_combat": dict(parts=[
        ("body", "heavy combat automaton of riveted bronze (#B8873A) and grey stone plates"),
        ("head", "small dome head with a glowing blue visor slit (#3FC8FF)"),
        ("details", "huge fists, small smoking pipe on the back"),
    ], never="no human face, no weapon"),
    # ---------------------------------------------------------------- familiers / invocations (V38)
    "golem_de_pierre": dict(parts=[
        ("body", "grey stone golem (#7A7A82) with a broad body and big stone fists"),
        ("head", "small head with two glowing blue eyes"),
        ("details", "blue crystals (#5CC8FF) growing from the shoulders and back"),
    ], never="no weapon, no moss, no brown stone"),
    "loup_spectral": dict(parts=[
        ("body", "spectral violet wolf (#7A4FD8) on four legs with flame-like spiky fur"),
        ("head", "glowing white eyes, pointed ears"),
        ("details", "fur tips turning into opaque violet flame shapes with dark outlines"),
    ], never="no armor, no transparency, never on two legs"),
    "requin_des_marees": dict(parts=[
        ("body", "bright blue shark (#2E8CE0) with a white belly floating upright"),
        ("head", "friendly grin, small black eyes"),
        ("details", "pectoral fins like small arms"),
    ], never="no legs, no weapon"),
    "familier:elementaire_de_cristal": dict(parts=[
        ("body", "small floating elemental made of violet (#8A4FD8) and blue (#4F7FE0) crystals, round and cute"),
        ("head", "friendly glowing ice-blue eyes (#9FE3FF)"),
        ("details", "tiny crystal arms, no legs"),
    ], never="no weapon, no sharp menacing look"),
    "ombre": dict(parts=[
        ("body", "coiled purple shadow serpent (#4A2A7A) with darker stripes"),
        ("head", "dragon-like head with small horns and glowing violet eyes (#B070FF)"),
        ("details", "stylized opaque smoke curls with dark outlines along the body"),
    ], never="no legs, no wings, no transparency"),
    "esprit_de_la_foret": dict(parts=[
        ("body", "forest stag spirit on four legs, body of green leaves (#5FAE48) and moss"),
        ("head", "large branching wooden antlers with small leaves, glowing green eyes"),
        ("details", "small white flowers on the back"),
    ], never="no rider, no armor, never on two legs"),
    "archer_sylvestre": dict(parts=[
        ("body", "slim wooden archer made of light-brown branches (#8A6238) and green leaves"),
        ("head", "leafy crown, two glowing green eyes, no mouth"),
        ("weapon", "wooden bow in the LEFT hand, leaf quiver on the back"),
    ], never="no human skin, no metal"),
    "ent_de_combat": dict(parts=[
        ("body", "small wooden ent warrior of brown bark (#6B4A2B) covered in green leaves"),
        ("head", "face carved in the bark with glowing green eyes, leafy top"),
        ("details", "stubby branch arms, root feet"),
    ], never="no weapon, no metal"),
    "tronc": dict(parts=[
        ("body", "cute walking tree stump of brown bark (#7A5534)"),
        ("head", "round leafy green crown on top (#5FAE48), big round friendly eyes on the trunk"),
        ("details", "two small branch arms, little root feet"),
    ], never="no weapon, no angry face"),
    "sarriette": dict(parts=[
        ("body", "tiny leaf sprite girl with light green skin (#BFE8A8)"),
        ("head", "green leaf hood (#5FAE48) with two little horns, big dark eyes"),
        ("details", "a curly vine in the hand, leaf dress"),
    ], never="no wings, no weapon"),
    "ronce_agressive": dict(parts=[
        ("body", "angry dark-green bramble bulb (#3E6A2E) covered in sharp thorns"),
        ("head", "two angry red eyes (#E02A2A), jagged mouth"),
        ("details", "whipping thorny vines around it, rooted in the ground"),
    ], never="no legs, no flowers"),
    "sentinelle_de_gres": dict(parts=[
        ("body", "sandstone sentinel statue (#D9B07A) with carved armor"),
        ("head", "carved helmet-head with glowing amber eyes (#F2A93B)"),
        ("weapon", "carved stone spear, RIGHT hand"),
    ], never="no cloth, no skin"),
}


def card(ent_id, desc, who, nation):
    """Bloc « carte d'identité » à recopier en tête et en fin de prompt."""
    lines = ["CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:",
             f"- Name: {who} ({nation})"]
    ident = IDENT.get(ent_id)
    if ident is None:
        lines.append(f"- Look: {desc}")
        lines.append("- Every color, eye color, hairstyle, outfit piece and weapon named above is fixed; "
                     "do not add any piece of clothing, color or accessory that is not named.")
        return "\n".join(lines), ""
    for part, txt in ident["parts"]:
        lines.append(f"- {part.capitalize()}: {txt}")
    lines.append("- Nothing else: do not add clothing, colors or accessories that are not listed.")
    never = ident.get("never", "")
    if never:
        lines.append(f"- FORBIDDEN variations: {never}.")
    return "\n".join(lines), never
