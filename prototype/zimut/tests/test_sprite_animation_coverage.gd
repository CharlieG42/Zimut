extends SceneTree
## Inventorie les poses d'animation livrées et détecte les poses orphelines.
## Le test reste informatif sur la couverture : une animation manquante est un chantier,
## pas une erreur de build. Une pose dont le sprite de base manque est une erreur.

var animation_files: int = 0
var orphan_files: int = 0
var by_kind: Dictionary = {
	"walk": 0,
	"back_walk": 0,
	"idle": 0,
	"back_idle": 0,
	"attack": 0,
	"back_attack": 0,
	"cast": 0,
	"back_cast": 0,
}

const ANIMATION_SUFFIXES: Array[String] = [
	"_back_walk_9", "_back_walk_8", "_back_walk_7", "_back_walk_6", "_back_walk_5",
	"_back_walk_4", "_back_walk_3", "_back_walk_2", "_back_walk",
	"_back_idle_9", "_back_idle_8", "_back_idle_7", "_back_idle_6", "_back_idle_5",
	"_back_idle_4", "_back_idle_3", "_back_idle_2",
	"_back_attack_9", "_back_attack_8", "_back_attack_7", "_back_attack_6",
	"_back_attack_5", "_back_attack_4", "_back_attack_3", "_back_attack_2", "_back_attack",
	"_back_cast_9", "_back_cast_8", "_back_cast_7", "_back_cast_6",
	"_back_cast_5", "_back_cast_4", "_back_cast_3", "_back_cast_2", "_back_cast",
	"_walk_9", "_walk_8", "_walk_7", "_walk_6", "_walk_5", "_walk_4", "_walk_3", "_walk_2", "_walk",
	"_idle_9", "_idle_8", "_idle_7", "_idle_6", "_idle_5", "_idle_4", "_idle_3", "_idle_2",
	"_attack_9", "_attack_8", "_attack_7", "_attack_6", "_attack_5", "_attack_4", "_attack_3", "_attack_2", "_attack",
	"_cast_9", "_cast_8", "_cast_7", "_cast_6", "_cast_5", "_cast_4", "_cast_3", "_cast_2", "_cast",
]

func _init() -> void:
	_scan_dir("res://assets/sprites/nations")
	_scan_dir("res://assets/sprites/summons")
	print("=== Couverture des poses de sprites ===")
	for kind: String in by_kind:
		print("  %s : %d fichier(s)" % [kind, int(by_kind[kind])])
	print("  Total animations : %d" % animation_files)
	print("  Poses orphelines : %d" % orphan_files)
	quit(1 if orphan_files > 0 else 0)

func _scan_dir(path: String) -> void:
	var dir: DirAccess = DirAccess.open(path)
	if dir == null:
		return
	dir.list_dir_begin()
	var entry: String = dir.get_next()
	while entry != "":
		if dir.current_is_dir():
			if not entry.begins_with("."):
				_scan_dir(path.path_join(entry))
		elif entry.to_lower().ends_with(".png"):
			_check_png(path, entry)
		entry = dir.get_next()
	dir.list_dir_end()

func _check_png(folder: String, filename: String) -> void:
	var stem: String = filename.trim_suffix(".png")
	for suffix: String in ANIMATION_SUFFIXES:
		if not stem.ends_with(suffix):
			continue
		var kind: String = suffix.trim_prefix("_").split("_")[0]
		if suffix.begins_with("_back_"):
			kind = "back_" + suffix.trim_prefix("_back_").split("_")[0]
		if by_kind.has(kind):
			by_kind[kind] = int(by_kind[kind]) + 1
		animation_files += 1
		var base_stem: String = stem.left(stem.length() - suffix.length())
		var base_filename: String = base_stem + ".png"
		# Les planches de poses des héros sont rangées dans un sous-dossier "poses",
		# tandis que le sprite de référence reste dans le dossier parent.
		var base_in_folder: String = folder.path_join(base_filename)
		var base_in_parent: String = folder.get_base_dir().path_join(base_filename)
		if not FileAccess.file_exists(base_in_folder) and not FileAccess.file_exists(base_in_parent):
			push_error("Pose sans sprite de base (dossier courant ou parent) : %s" % folder.path_join(filename))
			orphan_files += 1
		return
