class_name Typo
extends RefCounted
## Typo.gd — Typographie française pour les textes à retour à la ligne : espaces insécables
## avant « : ; ! ? % » et après « « », entre un nombre et son unité (or, Bois, bataille…),
## autour des tirets de liste. Le retour à la ligne ne coupe plus « 100 | % » ni « 12 | or ».

static var _num_unit: RegEx = null
static var _sign_num: RegEx = null


static func fr(t: String) -> String:
	if t == "":
		return t
	var nb: String = char(0x00A0)
	var thin: String = char(0x00A0)   # espace fine insécable absente de la police : espace insécable normale
	t = t.replace(" :", thin + ":").replace(" ;", thin + ";").replace(" !", thin + "!").replace(" ?", thin + "?")
	t = t.replace(" %", thin + "%").replace("« ", "«" + thin).replace(" »", thin + "»")
	if _num_unit == null:
		_num_unit = RegEx.new()
		_num_unit.compile("(\\d) (or|Bois|Fer|Cuir|Magie|Venin|bataille|batailles|bataille\\(s\\)|soldat|soldats|soldat\\(s\\)|villes?|victoires?|défense|niveaux?|PA|PM|PV|tours?|cases?)\\b")
		_sign_num = RegEx.new()
		_sign_num.compile("(Niveau|niveau|niv\\.|force|Force|défense|Défense|Siège|siège|conseillé) (\\d)")
	t = _num_unit.sub(t, "$1" + nb + "$2", true)
	t = _sign_num.sub(t, "$1" + nb + "$2", true)
	return t
