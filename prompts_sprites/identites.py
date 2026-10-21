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
        ("hair", "short brown hair (#7A4A28)"),
        ("eyes", "amber-brown eyes, always open"),
        ("skin", "light tan skin"),
        ("top", "layered sand-gold robe (#D9B26A) with terracotta panels (#B8562E) and small amber gems"),
        ("bottom", "sand-colored wrapped trousers"),
        ("feet", "brown sandals with cloth wraps"),
        ("weapon", "golden staff topped with a large faceted amber crystal (#F2A93B), RIGHT hand"),
    ], never="no hood, no turban, no blue or green clothes"),
    "mage": dict(parts=[
        ("hair", "dark navy-blue hair (#1E2C5A), medium length, side bangs"),
        ("eyes", "bright blue eyes (#3FA0FF), always open"),
        ("skin", "fair skin"),
        ("top", "long silver-white robe (#E8ECF4) with light-blue crystal patterns and sapphire trims (#2A5BD7)"),
        ("bottom", "the robe reaches the ankles, dark blue trousers visible below"),
        ("feet", "dark blue boots with silver tips"),
        ("weapon", "ornate silver staff topped with a glowing blue crystal (#5CC8FF), RIGHT hand"),
    ], never="no wizard hat, no white or silver hair, no beard"),
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
        ("top", "red and black armor with flame-shaped plates (#C8281E, #1E1A1C) and glowing ember cracks, red scarf"),
        ("bottom", "black trousers with red armored thigh plates"),
        ("feet", "black boots with red flame trims"),
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
