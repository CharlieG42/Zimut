extends Node
## Loc.gd — Langue du jeu (V18) : français (texte d'origine) ou anglais.
##
## Les textes du jeu sont écrits en français directement dans le code. Pour l'anglais,
## on enregistre auprès de TranslationServer une traduction « à la volée » (LocTranslation) :
## les Label / Button traduisent automatiquement leur texte (auto-translate de Godot),
## et chaque texte affiché est cherché dans data/i18n/en.txt :
##   1. correspondance exacte ;
##   2. modèle avec paramètres (« Niveau %d » reconnaît « Niveau 12 ») ;
##   3. à défaut, ligne par ligne puis segment par segment (« · »).
## Les noms propres non traduits restent en français.

const LANGS: Array[String] = ["fr", "en"]
const LANG_NAMES: Array[String] = ["Français", "English"]

var _tr: LocTranslation


func _ready() -> void:
	_tr = LocTranslation.new()
	_tr.locale = "en"
	_tr.load_table("res://data/i18n/en.txt")
	TranslationServer.add_translation(_tr)
	apply()


## Applique la langue choisie dans les Réglages.
func apply() -> void:
	var gs: Node = get_node_or_null("/root/GameSettings")
	var lang: String = String(gs.get("language")) if gs != null else "fr"
	TranslationServer.set_locale(lang if LANGS.has(lang) else "fr")


## Traduction explicite (pour le texte dessiné à la main, hors Label/Button).
func t(text: String) -> String:
	if TranslationServer.get_locale().begins_with("fr"):
		return text
	return String(_tr._get_message(StringName(text), StringName()))


class LocTranslation extends Translation:
	var exact: Dictionary = {}          # texte FR (sans espaces de bord) -> EN
	var patterns: Array = []            # [prefix, RegEx, template EN, nb de paramètres]
	var _cache: Dictionary = {}

	func load_table(path: String) -> void:
		var f := FileAccess.open(path, FileAccess.READ)
		if f == null:
			return
		while not f.eof_reached():
			var line: String = f.get_line()
			if line.strip_edges() == "" or line.begins_with("#"):
				continue
			var parts: PackedStringArray = line.split("\t")
			if parts.size() < 2:
				continue
			var fr: String = parts[0].replace("\\n", "\n").strip_edges()
			var en: String = parts[1].replace("\\n", "\n").strip_edges()
			if fr == "" or en == "":
				continue
			if _has_placeholder(fr):
				_add_pattern(fr, en)
			else:
				exact[fr] = en
		f.close()
		# les modèles les plus longs d'abord (plus spécifiques)
		patterns.sort_custom(func(a: Array, b: Array) -> bool: return String(a[4]).length() > String(b[4]).length())

	static func _has_placeholder(s: String) -> bool:
		var rx := RegEx.new()
		rx.compile("%[-+]?[0-9.]*[dsf]")
		return rx.search(s) != null

	func _add_pattern(fr: String, en: String) -> void:
		var rx_src: String = "^"
		var i: int = 0
		var n: int = 0
		var prefix: String = ""
		var seen_ph: bool = false
		var spec := RegEx.new()
		spec.compile("^%([-+]?)([0-9.]*)([dsf])")
		while i < fr.length():
			var ch: String = fr[i]
			if ch == "%":
				if i + 1 < fr.length() and fr[i + 1] == "%":
					rx_src += "%"
					if not seen_ph:
						prefix += "%"
					i += 2
					continue
				var m: RegExMatch = spec.search(fr.substr(i))
				if m != null:
					match m.get_string(3):
						"d":
							rx_src += "([-+]?\\d+)"
						"f":
							rx_src += "([-+]?[\\d.,]+)"
						_:
							rx_src += "(.*?)"
					n += 1
					seen_ph = true
					i += m.get_string(0).length()
					continue
			rx_src += _esc(ch)
			if not seen_ph:
				prefix += ch
			i += 1
		rx_src += "$"
		var rx := RegEx.new()
		if rx.compile(rx_src) != OK:
			return
		patterns.append([prefix, rx, en, n, fr])

	static func _esc(c: String) -> String:
		return "\\" + c if "\\^$.|?*+()[]{}".contains(c) else c

	func _get_message(src_message: StringName, _context: StringName) -> StringName:
		var src: String = String(src_message)
		if src == "":
			return src_message
		if _cache.has(src):
			return _cache[src]
		var out: String = _translate(src, 0)
		if _cache.size() > 4000:
			_cache.clear()
		_cache[src] = out
		return StringName(out)

	func _translate(src: String, depth: int) -> String:
		var core: String = src.strip_edges()
		if core == "":
			return src
		var lead: String = src.substr(0, src.find(core))
		var trail: String = src.substr(src.find(core) + core.length())
		var res: String = _translate_core(core, depth)
		return lead + res + trail

	func _translate_core(core: String, depth: int) -> String:
		if exact.has(core):
			return exact[core]
		for p: Array in patterns:
			if String(p[0]) != "" and not core.begins_with(String(p[0])):
				continue
			var m: RegExMatch = (p[1] as RegEx).search(core)
			if m == null:
				continue
			return _fill(String(p[2]), m, depth)
		if depth < 3:
			# symbole décoratif en tête (« ★ Mage », « ✦ Magie ») : on traduit la suite
			var sym := RegEx.new()
			sym.compile("^([^\\p{L}\\p{N}«(]+)(\\p{L}.*)$")
			var sm: RegExMatch = sym.search(core)
			if sm != null:
				var rest: String = _translate(sm.get_string(2), depth + 1)
				if rest != sm.get_string(2):
					return sm.get_string(1) + rest
			# nombre en fin (« Magie 12 », « Bois +5 ») : on traduit le début
			var num := RegEx.new()
			num.compile("^(.*\\D)\\s+([-+×x]?[\\d.,/ ]+%?)$")
			var nm: RegExMatch = num.search(core)
			if nm != null:
				var head: String = _translate(nm.get_string(1), depth + 1)
				if head != nm.get_string(1):
					return head + " " + nm.get_string(2)
			# nombre en tête (« 15 Cuir », « +2 Fer R2 ») : on traduit la suite
			var lead_n := RegEx.new()
			lead_n.compile("^([-+×x]?[\\d.,]+%?)\\s+(\\D.*)$")
			var lm: RegExMatch = lead_n.search(core)
			if lm != null:
				var tail_t: String = _translate(lm.get_string(2), depth + 1)
				if tail_t != lm.get_string(2):
					return lm.get_string(1) + " " + tail_t
			for sep: String in ["\n", "  ·  ", " · ", " — ", " : "]:
				if core.contains(sep):
					var bits: PackedStringArray = core.split(sep)
					var outb: PackedStringArray = []
					var changed: bool = false
					for b: String in bits:
						var tb: String = _translate(b, depth + 1)
						changed = changed or tb != b
						outb.append(tb)
					if changed:
						return sep.join(outb)
		return core

	func _fill(tpl: String, m: RegExMatch, depth: int) -> String:
		var out: String = ""
		var k: int = 1
		var i: int = 0
		var spec := RegEx.new()
		spec.compile("^%([-+]?)([0-9.]*)([dsf])")
		while i < tpl.length():
			if tpl[i] == "%":
				if i + 1 < tpl.length() and tpl[i + 1] == "%":
					out += "%"
					i += 2
					continue
				var sm: RegExMatch = spec.search(tpl.substr(i))
				if sm != null:
					var val: String = m.get_string(k) if k <= m.get_group_count() else ""
					if sm.get_string(3) == "s" and depth < 3:
						val = _translate(val, depth + 1)
					out += val
					k += 1
					i += sm.get_string(0).length()
					continue
			out += tpl[i]
			i += 1
		return out
