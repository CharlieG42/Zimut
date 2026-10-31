class_name ClassInfo
extends RefCounted
## ClassInfo.gd — Fiches descriptives des classes (V47).
## Source unique pour l'écran d'équipe, le choix/déblocage de héros et la fiche perso.
## Chaque entrée : icon, role (court), description (paragraphe), strengths / weaknesses
## (listes courtes), tips (conseil de jeu), difficulty (1 facile … 3 exigeant).

const INFO := {
	"Tank": {
		"icon": "🛡️", "role": "Gardien · Encaisseur", "difficulty": 1,
		"description": "Le rempart de l'équipe. Il avance en première ligne, absorbe les coups et protège ses alliés avec des boucliers, des provocations et des attaques de zone au corps à corps. Il progresse vite : c'est le héros idéal pour apprendre à jouer.",
		"strengths": ["Très résistant (vie et défense élevées)", "Étourdit, immobilise et affaiblit les ennemis", "Monte en niveau plus vite que les autres"],
		"weaknesses": ["Portée très courte (corps à corps)", "Dégâts modestes à distance"],
		"tips": "Place-le devant pour que les ennemis le visent plutôt que tes soigneurs. Rempart et Garde haute rendent tout le groupe plus solide.",
	},
	"Assassin": {
		"icon": "🗡️", "role": "Duelliste · Dégâts explosifs", "difficulty": 3,
		"description": "Un tueur rapide qui frappe là où ça fait mal : dans le dos des ennemis. Ses coups sont critiques quand la cible tourne le dos, et il enchaîne des combos de lames, de poison et de saignement avant de s'éclipser grâce à l'invisibilité.",
		"strengths": ["Dégâts les plus explosifs sur une cible", "Critiques garantis dans le dos", "Mobile (PM supplémentaire au niveau 40)"],
		"weaknesses": ["Fragile s'il se fait cerner", "Demande de bien se positionner"],
		"tips": "Contourne l'ennemi avant de frapper. Lame fatale puis Estoc rapide déclenche l'enchaînement. Exécution achève les cibles sous 30 % de vie.",
	},
	"Chasseur": {
		"icon": "🏹", "role": "Tireur · Polyvalent", "difficulty": 2,
		"description": "Un archer polyvalent qui contrôle le terrain à longue portée : glyphes d'entrave, flèches empoisonnées, tirs explosifs en zone et salves sur tous les ennemis. Son cri de guerre renforce toute l'équipe.",
		"strengths": ["Grande portée (jusqu'à 8 cases)", "Dégâts en zone et sur la durée", "Ralentit et immobilise à distance"],
		"weaknesses": ["Peu de points de vie", "Exposé quand l'ennemi l'atteint"],
		"tips": "Reste derrière le Tank et pose un glyphe d'entrave sur le passage des ennemis. Les combos de ralentissement augmentent ses dégâts.",
	},
	"Mage": {
		"icon": "🔮", "role": "Artilleur · Magie dévastatrice", "difficulty": 2,
		"description": "Le maître des éléments : explosions, murs de flammes, nova de givre et sorts qui ignorent la défense. Il détruit les groupes d'ennemis à distance mais se protège mal. Son bouclier magique l'aide à tenir face aux sorciers adverses.",
		"strengths": ["Dégâts de zone les plus puissants", "Brûlure, gel et immobilisation", "Sorts qui ignorent une partie de la défense"],
		"weaknesses": ["Faible défense physique", "Dépend de ses points d'action (PA)"],
		"tips": "Cible les groupes serrés avec Explosion et Mur de flammes. Brûle d'abord, puis Rayon ardent profite du combo brûlure.",
	},
	"Druide": {
		"icon": "🌿", "role": "Guérisseur · Soutien nature", "difficulty": 1,
		"description": "Un soutien robuste qui soigne, protège et purifie. Il restaure les points de vie de ses alliés, retire les effets négatifs, renforce la défense de l'équipe et sait aussi frapper et empoisonner avec des épines.",
		"strengths": ["Soins puissants, y compris de groupe", "Purifie les malus et protège (barrières)", "Peut aussi attaquer au corps à corps"],
		"weaknesses": ["Dégâts limités", "Doit rester proche de ses alliés"],
		"tips": "Soigne avant que la vie ne soit critique. Éveil de la forêt soigne tout le groupe sur trois tours : parfait contre les combats longs.",
	},
	"Heal": {
		"icon": "❤️", "role": "Soigneur · Lumière", "difficulty": 1,
		"description": "Le spécialiste des soins et de la survie. Soins sur la durée, boucliers de lumière, zones de régénération et, quand il faut, des traits de lumière pour punir les ennemis. Il progresse vite comme le Tank.",
		"strengths": ["Meilleurs soins du jeu (sur la durée et en zone)", "Boucliers et sanctuaires pour l'équipe", "Monte rapidement en niveau"],
		"weaknesses": ["Peu de dégâts au début", "Cible prioritaire pour l'ennemi"],
		"tips": "Pose Bénédiction de vie en début de combat. Garde-le hors de portée des ennemis, derrière ton Tank.",
	},
	"Invocateur": {
		"icon": "🎭", "role": "Maître des familiers · Contrôle", "difficulty": 3,
		"description": "Il invoque des créatures spectrales ou marines qui combattent à ses côtés et héritent de son niveau. Il les renforce, les soigne par offrande et complète leurs assauts avec des sorts d'âme. Un style riche, qui multiplie les corps sur le terrain.",
		"strengths": ["Plusieurs unités contrôlables", "Les familiers héritent de son niveau", "Sorts d'âme puissants qui sautent d'une cible à l'autre"],
		"weaknesses": ["Gestion plus complexe (PA et PM des familiers)", "Faible tout seul"],
		"tips": "Invoque tôt : les familiers occupent l'ennemi. Lien d'âme et Frénésie du familier augmentent leurs dégâts.",
	},
	"Sylvain": {
		"icon": "🌳", "role": "Maître de la forêt · Poison et racines", "difficulty": 2,
		"description": "Un mage de la nature qui invoque la forêt : archers sylvestres, troncs protecteurs, ronces et spores empoisonnées. Il immobilise avec des racines, soigne par la sève et déclenche des combos dévastateurs sur les cibles entravées.",
		"strengths": ["Poison et dégâts sur la durée", "Racines : immobilise puis frappe fort", "Invocations et soins de la forêt"],
		"weaknesses": ["Efficacité qui dépend des combos", "Défense moyenne"],
		"tips": "Immobilise d'abord avec Racine, puis Racines étrangleuses profite du combo immobilisation (+60 %).",
	},
	"Géomancien": {
		"icon": "🪨", "role": "Maître du terrain · Contrôle", "difficulty": 3,
		"description": "Un mage de pierre et de sable qui façonne le champ de bataille : murailles qui bloquent passages et lignes de vue, glyphes qui renforcent l'équipe, failles et éboulements. Il protège autant qu'il bride l'ennemi.",
		"strengths": ["Bloque et isole les ennemis (murailles)", "Glyphes de défense et de dégâts pour l'équipe", "Immunité physique temporaire (Pierre vivante)"],
		"weaknesses": ["Dégâts directs plus faibles", "Demande de la préparation"],
		"tips": "Place une muraille pour couper la route aux ennemis et protéger tes tireurs. Les glyphes agissent tant que tes alliés restent dessus.",
	},
	"Artificier": {
		"icon": "💣", "role": "Mécanismes · Pièges et explosifs", "difficulty": 3,
		"description": "Un ingénieur qui pose bombes, mines, tourelles et glyphes, puis les déclenche au bon moment pour des explosions en chaîne. Ses bombes mûrissent : elles montent d'un niveau à chaque fin de tour (jusqu'au niveau 4, explosion ×2). Le Couplage relie deux mécanismes alignés par une barrière que les ennemis ne franchissent pas.",
		"strengths": ["Dégâts massifs en zone avec les mécanismes", "Bombes qui gagnent en puissance avec le temps", "Barrières de Couplage pour enfermer l'ennemi"],
		"weaknesses": ["Style exigeant (poser puis déclencher)", "Fragile en mêlée"],
		"tips": "Pose tes bombes tôt et laisse-les monter de niveau ; couple deux mécanismes alignés pour couper la route aux ennemis, puis déclenche tout quand ils sont pris au piège.",
	},
}

static func get_info(classe: String) -> Dictionary:
	return INFO.get(classe, {"icon": "❔", "role": "", "difficulty": 1, "description": "",
		"strengths": [], "weaknesses": [], "tips": ""})

static func icon(classe: String) -> String:
	return String(get_info(classe)["icon"])

static func stars(classe: String) -> String:
	var d: int = int(get_info(classe)["difficulty"])
	return "★".repeat(d) + "☆".repeat(3 - d)

## Points forts / faibles / conseil (BBCode).
static func details_text(classe: String) -> String:
	var i: Dictionary = get_info(classe)
	var s: String = ""
	if not (i["strengths"] as Array).is_empty():
		s += "[color=#8fe08f][b]Points forts[/b][/color]\n"
		for x in i["strengths"]:
			s += "• %s\n" % x
	if not (i["weaknesses"] as Array).is_empty():
		s += "\n[color=#f0a080][b]Points faibles[/b][/color]\n"
		for x in i["weaknesses"]:
			s += "• %s\n" % x
	if String(i["tips"]) != "":
		s += "\n[color=#ffd770][b]Conseil[/b][/color]\n%s" % i["tips"]
	return s

## Texte complet (RichText BBCode) pour la fiche d'un héros.
static func full_text(classe: String) -> String:
	var i: Dictionary = get_info(classe)
	return "[b]%s[/b]  —  difficulté %s\n%s\n\n%s" % [i["role"], stars(classe), i["description"], details_text(classe)]

## Version courte (une phrase de rôle + description) pour les listes.
static func short_text(classe: String) -> String:
	var i: Dictionary = get_info(classe)
	return "%s\n%s" % [i["role"], i["description"]]
