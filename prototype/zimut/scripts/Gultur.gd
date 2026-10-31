class_name Gultur
extends CanvasLayer
## Gultur.gd — Le guide du tutoriel (personnage dessiné en vectoriel, en attendant son sprite).
##
## Usage : Gultur.say(parent, "id_etape", ["ligne 1", "ligne 2"], cible_optionnelle, au_terme)
## - n'affiche rien si le tutoriel est désactivé ou si l'étape a déjà été vue ;
## - « Passer le tutoriel » désactive Gultur (GameSettings.skip_tutorial) ;
## - la relance se fait depuis Options (GameSettings.restart_tutorial).
## - le sprite final se branchera dans Gultur.PORTRAIT_PATH (s'il existe, il remplace le dessin).

signal finished

const PORTRAIT_PATH := "res://assets/sprites/npc/gultur.png"
const C_PANEL := Color(0.07, 0.09, 0.15, 0.96)
const C_GOLD := Color(1.0, 0.82, 0.35)

## Répliques du tutoriel (« {pseudo} » est remplacé par le pseudo du joueur ; « {e} » par « e » si le joueur a choisi « Femme »).
const INTRO := [
	"Bienvenue, [b]{pseudo}[/b] ! Je suis [b]Gultur[/b], gardien des Pierres, et je guide les voyageurs égarés depuis bien longtemps.",
	"Ici, c'est [b]Zimut[/b], un monde où chaque [b]Nation[/b] veille sur un élément : la forêt, la montagne, le désert, les ombres…",
	"Autrefois, les [b]Pierres Élémentaires[/b], une par Nation, maintenaient l'équilibre du monde. Un jour, elles ont disparu, dispersées aux quatre coins de Zimut.",
	"Depuis, les créatures se déchaînent, les routes sont coupées et l'harmonie entre les Nations se brise un peu plus chaque jour.",
	"Retrouver les Pierres est [b]indispensable[/b] pour rétablir l'ordre : tant qu'elles seront perdues, Zimut sombrera dans le chaos.",
	"Et prends garde : chaque Pierre confère à son possesseur des [b]pouvoirs incroyables[/b]. Entre de mauvaises mains, elle serait une arme terrible ; entre les tiennes, un espoir.",
	"Tu es venu{e} d'un autre monde, appelé par les Pierres elles-mêmes : [b]toi seul[/b] peux les retrouver, {pseudo}. Alors, es-tu prêt{e} ?",
]
## Fin du tutoriel : choix des 3 héros de départ (V48), puis premier combat.
const PICK := [
	"Avant de partir, {pseudo}, il te faut une [b]compagnie[/b]. Dix héros t'attendent à Zimut… mais au début, tu n'en emmèneras que [b]trois[/b].",
	"Chacun a son style : le [b]Tank[/b] encaisse, le [b]Chasseur[/b] tire de loin, le [b]Heal[/b] et le [b]Druide[/b] soignent, le [b]Mage[/b] et l'[b]Artificier[/b] font pleuvoir les dégâts, l'[b]Assassin[/b] frappe dans le dos, l'[b]Invocateur[/b] et le [b]Sylvain[/b] appellent des alliés, le [b]Géomancien[/b] façonne le terrain…",
	"Touche un héros pour lire sa [b]fiche[/b] : son rôle, ses points forts, ses points faibles et un conseil. Les étoiles ★ indiquent la [b]difficulté[/b] : une étoile, c'est facile à prendre en main ; trois, c'est pour les stratèges.",
	"Un bon trio mêle un [b]protecteur[/b], un [b]soutien[/b] et un [b]héros de dégâts[/b]. Mais tu fais comme tu veux : il n'y a pas de mauvais choix, seulement des styles différents !",
	"Les héros que tu ne choisis pas ne sont pas perdus : en gagnant des [b]niveaux de joueur[/b], tu en débloqueras d'autres, [b]un à la fois, et c'est toi qui décides[/b] lequel rejoint ta compagnie.",
	"À toi de jouer, {pseudo}. Choisis [b]trois héros[/b], puis valide.",
]
const AFTER_PICK := [
	"Excellent choix ! Voilà une compagnie qui a de l'allure.",
	"Maintenant, direction les [b]Combats Tactiques[/b] : c'est là que ton équipe apprendra à se battre et gagnera ses premiers niveaux. Touche le bouton en surbrillance !",
]
## Premier déblocage de héros disponible (écran d'équipe).
const UNLOCK := [
	"Regarde, {pseudo} : ton niveau de [b]joueur[/b] a grimpé, et un nouveau héros peut rejoindre ta compagnie !",
	"Touche [b]DÉBLOQUER UN HÉROS[/b] : tu verras tous ceux qui restent, avec leur fiche. [b]Tu choisis celui que tu veux.[/b]",
	"Ensuite, un nouveau héros t'attendra tous les [b]3 niveaux de joueur[/b]. Avec de la persévérance, ils seront tous à toi !",
]
## Explication du niveau du joueur (écran d'équipe, une fois).
const PLAYER := [
	"Ici, c'est ton [b]niveau de joueur[/b]. Il monte à chaque combat, et il compte double.",
	"D'abord, [b]aucun héros ne peut dépasser ton niveau[/b] : tu es le chef de la compagnie. Ensuite, c'est lui qui [b]débloque de nouveaux héros[/b].",
	"Garde les mêmes héros, et ton niveau restera proche du leur. Change d'équipe, et les nouveaux venus rattraperont vite leur retard.",
]
## Tous les héros sont débloqués.
const ALL_UNLOCKED := [
	"Incroyable, {pseudo} : [b]les dix héros[/b] sont à toi !",
	"À toi d'essayer toutes les combinaisons : certaines équipes forment des [b]synergies[/b] puissantes. Les Pierres Élémentaires n'ont qu'à bien se tenir !",
]
const TEAM := [
	"Voici la préparation de ton équipe. Tu emmènes [b]3 héros[/b] au combat : ils apparaissent dans le cadre doré « TON ÉQUIPE ».",
	"Touche un héros dans la liste pour voir sa fiche, puis [b]AJOUTER À L'ÉQUIPE[/b]. Un bon trio : un [b]Tank[/b] qui encaisse, un [b]soigneur[/b] et un héros de [b]dégâts[/b].",
	"Les héros marqués d'un [b]cadenas 🔒[/b] ne sont pas encore débloqués : tu pourras les consulter, mais pas les emmener au combat.",
	"Le bouton [b]★ EXPLORATEUR[/b] choisit le héros qui te représente sur la carte d'Aventure.",
	"Quand les 3 emplacements sont remplis, appuie sur [b]COMBATTRE[/b]. Je te souffle les premiers gestes pendant le combat !",
]
const EQUIP := [
	"Tu as trouvé de l'équipement ! Le bouton [b]ÉQUIPEMENT[/b] permet de le donner à tes héros : chaque pièce les rend plus solides.",
	"Dans la fiche d'un héros, un [b]▲ vert[/b] t'indique les objets conseillés (plus puissants que ceux portés).",
]
const LVL3 := [
	"Bravo, [b]{pseudo}[/b] ! [b]Toi[/b] qui viens d'atteindre le [b]niveau 3[/b] de joueur : le mode [b]Aventure[/b] s'ouvre à toi.",
	"Explore la carte : touche une case pour y marcher, le brouillard se lève. Des [b]groupes de monstres[/b] rôdent (vert = facile, rouge = dangereux).",
	"Au [b]camp[/b], prends un contrat. Les énigmes et les coffres cachent de précieuses récompenses… et peut-être la trace d'une Pierre.",
]
const LVL5 := [
	"Impressionnant, [b]{pseudo}[/b] ! Te voilà [b]niveau 5[/b] de joueur : le mode [b]Conquête[/b] est débloqué.",
	"Prends les cités une à une, nomme des [b]gouverneurs[/b], recrute des soldats et défends tes villes contre les raids.",
	"Les Nations gardent jalousement leurs Pierres dans leurs cités. Plus ton empire grandit, plus tu t'en approches !",
	"Chaque ville a sa [b]spécialité[/b], certaines s'obtiennent par [b]traité[/b], et quatre [b]généraux[/b] du Roi Squelette t'attendent. Je t'expliquerai tout sur la carte de Conquête.",
]

## V59 — Conquête : nouveautés présentées au fil du jeu (une seule fois chacune).
const CONQ_V59 := [
	"La Conquête s'est enrichie, [b]{pseudo}[/b] ! Chaque ville conquise produit désormais sa [b]spécialité[/b] : Magie des cristaux, Fer du givre, Cuir des ports… à chaque victoire.",
	"Quatre [b]généraux du Roi Squelette[/b] tiennent ses forteresses. Tant qu'ils vivent, leurs sièges sont plus durs et ils lancent des offensives. Affronte-les en personne à la [b]4e bataille[/b] de leur forteresse !",
	"Ne tarde pas trop : les villes adverses [b]renforcent leur garnison[/b] toutes les 3 victoires. Et pour un siège, prépare un [b]plan d'assaut[/b] : le blocus ou l'infiltration font sauter une vague sans combat.",
	"Le conseil a deux onglets : [b]⚑ VILLE[/b] pour agir, [b]✎ CHRONIQUE[/b] pour relire les nouvelles de l'empire.",
]
const CONQ_CARTE := [
	"Regarde la carte, [b]{pseudo}[/b] : elle vit ! Ton [b]territoire[/b] s'illumine, bordé d'or, et tes villes hissent ton [b]drapeau[/b].",
	"Les [b]flèches dorées en pointillés[/b] montrent les villes que tu peux attaquer. Les sentiers pâles mènent plus loin… quand tu auras avancé.",
	"Le [b]brouillard[/b] cache les terres que tu n'as pas encore explorées en Aventure. Un [b]crâne[/b] signale la forteresse d'un général, des [b]points rouges[/b] l'avancée d'un siège, la [b]fumée[/b] une ville pillée.",
	"Et si une [b]colonne ennemie[/b] marche sur une de tes villes, renforce-la vite !",
]
## V64 — Conquête : sortir du brouillard.
const CONQ_BROUILLARD := [
	"Ces villes marquées d'un [b]?[/b] sont dans le [b]brouillard[/b], [b]{pseudo}[/b]. Bonne nouvelle : toute ville reliée par une route à ton empire apparaît et devient [b]attaquable[/b] dès que tu as conquis sa voisine.",
	"Pour voir plus loin, il y a deux moyens. En [b]Aventure[/b], grimpe à un [b]belvédère[/b] (le losange bleu 👁) : il révèle les villes de la région. Ou envoie un [b]explorateur[/b] : une mission de [b]Cartographie[/b] depuis une de tes villes.",
	"Une ville révélée mais pas encore reliée à ton empire garde un [b]anneau pointillé[/b] et indique [b]« à N étapes »[/b] : c'est le nombre de villes à conquérir pour l'atteindre.",
]
const CONQ_EXPLORATEUR := [
	"Un [b]explorateur[/b], c'est un héros libre en mission de [b]Cartographie[/b]. Au bout de [b]3 batailles[/b], il revient avec le relevé de [b]2 villes[/b] cachées dans le brouillard.",
	"Choisis un héros qui n'est ni gouverneur ni dans l'équipe de combat : pendant sa mission, il ne peut rien faire d'autre. Et une expédition sur cinq tourne mal : elle coûte de l'or, sans rien révéler.",
	"Astuce : lance la Cartographie [b]avant[/b] d'attaquer une ville de la frontière. Quand ton empire s'agrandira, les nouvelles villes révélées seront déjà prêtes à être conquises.",
]
const CONQ_CIBLES_V64 := [
	"Du nouveau sur la carte, [b]{pseudo}[/b] ! L'onglet [b]⚔ CIBLES[/b] liste les villes que tu peux attaquer, de la plus facile à la plus dure, avec leur [b]butin[/b].",
	"Avant un siège, regarde l'avis du conseil : [b]à votre portée[/b], [b]risqué[/b] ou [b]trop fort[/b], selon le niveau moyen de ton équipe. Le détail de la ville se replie avec le bouton [b]▾ DÉTAILS[/b].",
]
const ADV_BELVEDERE := [
	"Un [b]belvédère[/b] ! Du haut, tu repères les villes de la région : elles apparaissent hors du [b]brouillard[/b] sur la carte de [b]Conquête[/b].",
	"Attention, les voir ne suffit pas à les attaquer : il faut d'abord les relier à ton empire en conquérant les villes qui y mènent. Un explorateur en [b]Cartographie[/b] révèle les autres.",
]
const INGENIEUR_V63 := [
	"L'Artificier devient l'[b]Ingénieur[/b], [b]{pseudo}[/b] ! Ses [b]bombes mûrissent[/b] : niveau 1 à la pose, +1 à chaque fin de son tour, jusqu'au niveau 4 (explosion ×2). L'étoile dorée affiche leur niveau.",
	"Nouveau sort [b]Couplage[/b] : couple deux mécanismes alignés et une [b]barrière électrique[/b] se tend entre eux. Elle reste franchissable, mais quiconque la traverse est [b]électrocuté[/b] : plein pot pour les ennemis, moitié moins pour tes alliés.",
]
const VILLE_V61 := [
	"Bienvenue dans ta ville, [b]{pseudo}[/b] ! Touche un bâtiment pour le gérer à droite.",
	"L'[b]Hôtel de ville[/b] fait grandir la ville jusqu'à la [b]Métropole[/b] : plus de soldats, plus d'[b]emplacements[/b] de construction et des bâtiments de plus haut niveau.",
	"Chaque bâtiment monte jusqu'au [b]niveau 3[/b] (les étoiles) et produit davantage à chaque niveau. Dès la [b]Cité[/b], bâtis la [b]Merveille[/b] de la Nation !",
]
const CONQ_DIPLOMATIE := [
	"Cette ville est [b]neutre[/b] : tu peux la gagner par les armes… ou par un [b]traité[/b] ! Le bouton [b]☮ NÉGOCIER[/b] l'annexe contre de l'or et sa ressource de spécialité.",
	"Plus la ville est grande, plus le traité coûte cher, et tes émissaires doivent se reposer [b]3 victoires[/b] entre deux négociations. Les forteresses ennemies, elles, ne négocient jamais.",
]
const CONQ_CHANCELIER := [
	"Ton [b]Chancelier[/b] demande audience ! Tous les 5 batailles, il propose un édit : un [b]impôt[/b] (de l'or tout de suite, mais tes garnisons perdent un soldat), des [b]manœuvres[/b] (+2 défense) ou l'[b]entretien des routes[/b] (Bois et Cuir).",
	"Rien ne t'oblige : tu peux le [b]congédier[/b], ou lui dire de revenir [b]plus tard[/b].",
]
const CONQ_MISSIONS := [
	"Un héros qui ne gouverne pas et ne combat pas peut partir en [b]mission[/b] pendant 3 batailles : escorter une caravane, cartographier des terres inconnues ou prospecter du minerai.",
	"Attention : un héros en mission ne peut ni combattre ni gouverner, et une expédition sur cinq tourne mal.",
]
const CONQ_RUINE := [
	"Cette ville a été [b]reprise à l'ennemi[/b], mais elle est en ruine : sa production est gelée quelques batailles.",
	"Tu peux attendre qu'elle se relève toute seule, ou payer sa [b]réparation[/b] pour la remettre en marche tout de suite.",
]
const CONQ_LEGENDE := [
	"Tu l'as fait, [b]{pseudo}[/b] ! Le Roi Squelette est tombé. Ta [b]Légende[/b] résume ta campagne : villes, développement, gouverneurs, Pierres retrouvées, traités…",
	"Ton style a décidé de ta fin : [b]Âge des Héros[/b], [b]Empire marchand[/b] ou [b]Bastion de Zimut[/b]. Le monde reste à toi : continue à le faire prospérer !",
]

const DONJON := [
	"Voici un [b]Donjon de Nation[/b]. Chaque Nation en cache un : [b]quatre salles[/b] de plus en plus dures, à enchaîner.",
	"Les trois premières salles opposent des groupes de monstres ; la dernière abrite le [b]Gardien[/b], le maître de la Nation.",
	"Le Gardien garde une [b]Pierre Élémentaire[/b]. La première fois que tu le vaincs, tu as [b]une chance sur deux[/b] de la gagner… puis seulement [b]une sur vingt[/b] à chaque victoire suivante.",
	"Bonne nouvelle : tu peux refaire un donjon [b]autant de fois que tu veux[/b], pour le butin comme pour la Pierre. Mais attention : une défaite, un combat abandonné ou l'arrêt du jeu te renvoient à l'entrée !",
]

var _lines: Array = []
var _idx: int = 0
var _id: String = ""
var _target: Control = null
var _root: Control
var _text: RichTextLabel
var _next: Button
var _skip: Button
var _tw: Tween
var _typing: bool = false
var _avatar: GulturAvatar
var _hl: Control


## Affiche une séquence de répliques. Retourne l'instance (ou null si rien à montrer).
static func say(parent: Node, id: String, lines: Array, target: Control = null, on_done: Callable = Callable()) -> Gultur:
	if parent == null or not should_show(id):
		if on_done.is_valid():
			on_done.call()
		return null
	var g := Gultur.new()
	g._id = id
	g._lines = lines.duplicate()
	var pseudo: String = ""
	var fem: String = ""
	if Engine.get_main_loop() is SceneTree:
		var gm: Node = (Engine.get_main_loop() as SceneTree).root.get_node_or_null("GameManager")
		if gm != null and not (gm.get("active_save") as Dictionary).is_empty():
			pseudo = String((gm.get("active_save") as Dictionary).get("name", ""))
			if String((gm.get("active_save") as Dictionary).get("gender", "m")) == "f":
				fem = "e"
	for i: int in range(g._lines.size()):
		g._lines[i] = String(g._lines[i]).replace("{pseudo}", pseudo if pseudo != "" else ("voyageuse" if fem == "e" else "voyageur")).replace("{e}", fem)
	g._target = target
	g.layer = 100
	if on_done.is_valid():
		g.finished.connect(on_done)
	parent.add_child(g)
	return g


static func should_show(id: String) -> bool:
	var gs: Node = Engine.get_main_loop().root.get_node_or_null("GameSettings") if Engine.get_main_loop() is SceneTree else null
	if gs == null:
		return false
	return bool(gs.get("tutorial_enabled")) and not (gs.get("tuto_seen") as Dictionary).has(id)


func _ready() -> void:
	_root = Control.new()
	add_child(_root)
	UiFit.apply(_root, 1.0, Vector2(1300, 760))
	var dim := ColorRect.new()
	dim.color = Color(0, 0, 0, 0.38)
	dim.set_anchors_preset(Control.PRESET_FULL_RECT)
	dim.mouse_filter = Control.MOUSE_FILTER_STOP
	_root.add_child(dim)
	# Surbrillance de la cible (cadre pulsant)
	_hl = Control.new()
	_hl.set_anchors_preset(Control.PRESET_FULL_RECT)
	_hl.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_hl.draw.connect(_draw_highlight)
	add_child(_hl)
	# Bandeau de dialogue, en bas
	# Le bandeau se place en haut si la cible surlignée est dans la moitié basse de l'écran.
	var at_top: bool = false
	if _target != null and is_instance_valid(_target):
		at_top = _target.get_global_rect().get_center().y > get_viewport().get_visible_rect().size.y * 0.5
	var box := PanelContainer.new()
	box.name = "GulturBox"
	if at_top:
		box.set_anchors_preset(Control.PRESET_TOP_WIDE)
		box.offset_left = 190.0
		box.offset_right = -24.0
		box.offset_top = 20.0
		box.offset_bottom = 270.0
	else:
		box.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
		box.offset_left = 190.0
		box.offset_right = -24.0
		box.offset_bottom = -20.0
		box.offset_top = -270.0
		box.grow_vertical = Control.GROW_DIRECTION_BEGIN
	var st := StyleBoxFlat.new()
	st.bg_color = C_PANEL
	st.border_color = C_GOLD
	st.set_border_width_all(3)
	st.set_corner_radius_all(16)
	st.content_margin_left = 20
	st.content_margin_right = 20
	st.content_margin_top = 12
	st.content_margin_bottom = 12
	box.add_theme_stylebox_override("panel", st)
	_root.add_child(box)
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 6)
	box.add_child(v)
	var name_l := Label.new()
	name_l.text = "Gultur · gardien des Pierres"
	name_l.add_theme_font_size_override("font_size", 20)
	name_l.add_theme_color_override("font_color", C_GOLD)
	v.add_child(name_l)
	_text = RichTextLabel.new()
	_text.bbcode_enabled = true
	_text.fit_content = false
	_text.scroll_active = false
	_text.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_text.custom_minimum_size = Vector2(0, 100)
	_text.add_theme_font_size_override("normal_font_size", 26)
	_text.add_theme_font_size_override("bold_font_size", 26)
	_text.add_theme_color_override("default_color", Color(1, 0.96, 0.86))
	_text.mouse_filter = Control.MOUSE_FILTER_IGNORE
	v.add_child(_text)
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 12)
	v.add_child(row)
	_skip = Button.new()
	_skip.name = "GulturSkip"
	_skip.text = "Passer le tutoriel"
	_skip.add_theme_font_size_override("font_size", 17)
	_skip.pressed.connect(_on_skip)
	row.add_child(_skip)
	var sp := Control.new()
	sp.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(sp)
	_next = Button.new()
	_next.name = "GulturNext"
	_next.custom_minimum_size = Vector2(220, 52)
	_next.add_theme_font_size_override("font_size", 22)
	_next.pressed.connect(_on_next)
	row.add_child(_next)
	# Gultur à gauche, qui dépasse du bandeau
	_avatar = GulturAvatar.new()
	_avatar.custom_minimum_size = Vector2(200, 270)
	_avatar.size = Vector2(200, 270)
	if at_top:
		_avatar.set_anchors_preset(Control.PRESET_TOP_LEFT)
		_avatar.offset_left = 4.0
		_avatar.offset_top = 6.0
		_avatar.offset_right = 204.0
		_avatar.offset_bottom = 276.0
	else:
		_avatar.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
		_avatar.offset_left = 4.0
		_avatar.offset_top = -290.0
		_avatar.offset_right = 204.0
		_avatar.offset_bottom = -12.0
		_avatar.grow_vertical = Control.GROW_DIRECTION_BEGIN
	_avatar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_root.add_child(_avatar)
	_show_line()


func _process(_d: float) -> void:
	if _hl != null:
		_hl.queue_redraw()


func _draw_highlight() -> void:
	if _target == null or not is_instance_valid(_target) or not _target.is_visible_in_tree():
		return
	var r: Rect2 = _target.get_global_rect().grow(6.0)
	var pulse: float = 0.5 + 0.5 * sin(Time.get_ticks_msec() / 1000.0 * 5.0)
	_hl.draw_rect(r, Color(1.0, 0.85, 0.3, 0.10 + 0.12 * pulse))
	_hl.draw_rect(r, Color(1.0, 0.85, 0.3, 0.7 + 0.3 * pulse), false, 4.0)


func _show_line() -> void:
	var last: bool = _idx >= _lines.size() - 1
	_next.text = "C'EST PARTI !" if last else "SUIVANT  ▶"
	_skip.visible = not last
	var raw: String = String(_lines[_idx])
	var loc: Node = get_node_or_null("/root/Loc")
	if loc != null:
		raw = String(loc.call("t", raw))
	_text.text = raw
	_text.visible_characters = 0
	_typing = true
	_avatar.talking = true
	if _tw != null:
		_tw.kill()
	var n: int = _text.get_total_character_count()
	_tw = create_tween()
	_tw.tween_property(_text, "visible_characters", n, maxf(0.2, float(n) * 0.018))
	_tw.tween_callback(_end_typing)


func _end_typing() -> void:
	_typing = false
	_text.visible_characters = -1
	_avatar.talking = false


func _on_next() -> void:
	if _typing:
		if _tw != null:
			_tw.kill()
		_end_typing()
		return
	_idx += 1
	if _idx >= _lines.size():
		_finish(false)
	else:
		_show_line()


func _on_skip() -> void:
	_finish(true)


func _finish(skipped: bool) -> void:
	var gs: Node = get_node_or_null("/root/GameSettings")
	if gs != null:
		if skipped:
			gs.call("skip_tutorial")
		else:
			gs.call("mark_tuto_seen", _id)
	finished.emit()
	queue_free()


## Dessin vectoriel de Gultur : vieux gardien à capuche verte, longue barbe blanche,
## bâton surmonté d'une pierre lumineuse.
class GulturAvatar extends Control:
	var talking: bool = false
	var _t: float = 0.0
	var _tex: Texture2D = null
	var _tex_checked: bool = false

	func _process(delta: float) -> void:
		_t += delta
		queue_redraw()

	func _draw() -> void:
		if _tex == null and not _tex_checked:
			_tex_checked = true
			if ResourceLoader.exists(Gultur.PORTRAIT_PATH):
				_tex = load(Gultur.PORTRAIT_PATH) as Texture2D
		if _tex != null:
			# Illustration (V30) : proportions conservées, calée en bas, légère respiration
			# (plus marquée quand il parle) et lueur pulsante sur la pierre du bâton.
			var tw: float = float(_tex.get_width())
			var th: float = float(_tex.get_height())
			var k: float = minf(size.x / tw, size.y / th)
			var breathe: float = sin(_t * (3.2 if talking else 1.6)) * (0.012 if talking else 0.006)
			var dw: float = tw * k
			var dh: float = th * k * (1.0 + breathe)
			var pos := Vector2((size.x - dw) * 0.5, size.y - dh)
			draw_set_transform(Vector2(size.x * 0.5, size.y - 2.0), 0.0, Vector2(1.0, 0.22))
			draw_circle(Vector2.ZERO, dw * 0.42, Color(0, 0, 0, 0.32))
			draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
			var gem: Vector2 = pos + Vector2(dw * 0.92, dh * 0.125)
			var glow: float = 0.5 + 0.5 * sin(_t * 3.0)
			draw_circle(gem, dw * 0.16, Color(0.45, 1.0, 0.85, 0.10 + 0.10 * glow))
			draw_texture_rect(_tex, Rect2(pos, Vector2(dw, dh)), false)
			draw_circle(gem, dw * 0.07, Color(0.6, 1.0, 0.9, 0.12 + 0.18 * glow))
			return
		var bob: float = sin(_t * 2.0) * 3.0
		var o := Vector2(size.x * 0.5 - 8.0, size.y - 8.0 + bob * 0.4)
		# ombre
		draw_set_transform(o + Vector2(0, 2), 0.0, Vector2(1.0, 0.25))
		draw_circle(Vector2.ZERO, 70.0, Color(0, 0, 0, 0.35))
		draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
		# bâton + pierre
		var sx: float = o.x + 66.0
		draw_line(Vector2(sx, o.y - 4), Vector2(sx - 4, o.y - 215 + bob), Color(0.42, 0.28, 0.14), 7.0, true)
		var glow: float = 0.55 + 0.45 * sin(_t * 3.0)
		var sc := Vector2(sx - 4, o.y - 226 + bob)
		draw_circle(sc, 30.0, Color(0.4, 1.0, 0.8, 0.10 + 0.10 * glow))
		draw_circle(sc, 20.0, Color(0.4, 1.0, 0.8, 0.18 + 0.12 * glow))
		draw_colored_polygon(PackedVector2Array([sc + Vector2(0, -15), sc + Vector2(11, 0), sc + Vector2(0, 15), sc + Vector2(-11, 0)]), Color(0.45, 0.98, 0.85))
		draw_colored_polygon(PackedVector2Array([sc + Vector2(0, -15), sc + Vector2(11, 0), sc + Vector2(0, 2)]), Color(0.8, 1.0, 0.95, 0.85))
		# robe
		var robe := Color(0.16, 0.38, 0.30)
		draw_colored_polygon(PackedVector2Array([o + Vector2(-52, 0), o + Vector2(-34, -118 + bob), o + Vector2(34, -118 + bob), o + Vector2(56, 0)]), robe.darkened(0.25))
		draw_colored_polygon(PackedVector2Array([o + Vector2(-46, 0), o + Vector2(-30, -116 + bob), o + Vector2(30, -116 + bob), o + Vector2(50, 0)]), robe)
		draw_line(o + Vector2(0, -112 + bob), o + Vector2(0, -2), robe.lightened(0.18), 3.0)
		# ceinture dorée
		draw_rect(Rect2(o + Vector2(-37, -58 + bob), Vector2(76, 8)), Color(0.88, 0.68, 0.22))
		draw_rect(Rect2(o + Vector2(-5, -60 + bob), Vector2(12, 12)), Color(1.0, 0.85, 0.35))
		# bras tenant le bâton
		draw_circle(o + Vector2(54, -92 + bob), 10.0, Color(0.93, 0.76, 0.6))
		draw_line(o + Vector2(32, -108 + bob), o + Vector2(54, -92 + bob), robe.darkened(0.1), 14.0, true)
		# capuche
		var hc := o + Vector2(0, -138 + bob)
		draw_circle(hc, 41.0, robe.darkened(0.2))
		draw_colored_polygon(PackedVector2Array([hc + Vector2(-30, -22), hc + Vector2(6, -76), hc + Vector2(34, -22)]), robe.darkened(0.2))
		# visage
		draw_circle(hc + Vector2(0, 4), 28.0, Color(0.95, 0.78, 0.62))
		# barbe
		var beard := Color(0.96, 0.96, 0.98)
		draw_colored_polygon(PackedVector2Array([hc + Vector2(-27, 8), hc + Vector2(-20, 46 + bob * 0.3), hc + Vector2(0, 74), hc + Vector2(20, 46 + bob * 0.3), hc + Vector2(27, 8), hc + Vector2(0, 22)]), beard)
		draw_polyline(PackedVector2Array([hc + Vector2(-12, 34), hc + Vector2(0, 58), hc + Vector2(12, 34)]), Color(0.8, 0.8, 0.88), 2.0)
		# moustache
		draw_colored_polygon(PackedVector2Array([hc + Vector2(-20, 12), hc + Vector2(0, 8), hc + Vector2(20, 12), hc + Vector2(10, 22), hc + Vector2(0, 16), hc + Vector2(-10, 22)]), beard)
		# nez
		draw_circle(hc + Vector2(0, 8), 6.0, Color(0.9, 0.65, 0.5))
		# bouche qui parle
		if talking:
			var mo: float = 3.0 + 4.0 * absf(sin(_t * 14.0))
			draw_circle(hc + Vector2(0, 26), mo, Color(0.35, 0.12, 0.12))
		# yeux + sourcils (clignement)
		var blink: bool = fmod(_t, 3.6) > 3.45
		for sgn: float in [-1.0, 1.0]:
			var ec := hc + Vector2(11.0 * sgn, -4)
			if blink:
				draw_line(ec + Vector2(-5, 0), ec + Vector2(5, 0), Color(0.2, 0.12, 0.08), 2.5)
			else:
				draw_circle(ec, 5.0, Color.WHITE)
				draw_circle(ec + Vector2(0, 0.5), 2.6, Color(0.15, 0.3, 0.2))
			draw_colored_polygon(PackedVector2Array([ec + Vector2(-9, -9), ec + Vector2(9, -12 if sgn > 0 else -9), ec + Vector2(9, -8), ec + Vector2(-9, -6)]), beard)
