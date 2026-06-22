extends Node
## GameManager - Gère la logique globale du jeu WildZimut

const GRID_SIZE := 8
const CELL_SIZE := 80
const MARGIN := 20

const COLORS := {
    "Tank": Color(0, 0.4, 0.8),
    "Assassin": Color(0.8, 0, 0),
    "Chasseur": Color(0, 0.8, 0),
    "Mage": Color(0.6, 0, 0.8),
    "Support": Color(1, 0.8, 0),
    "Heal": Color(0, 0.8, 0.8),
    "Gobelin": Color(0.5, 0.8, 0.3),
    "Squelette": Color(0.8, 0.8, 0.8),
    "Loup": Color(0.6, 0.6, 0.4),
}

var grid: Array = []
var players: Array = []
var enemies: Array = []
var current_turn: int = 0
var current_player_index: int = 0
var selected_entity = null
var selected_spell = null
var selected_cell: Vector2i = Vector2i(0, 0)
var show_spells: bool = false
var game_over: bool = false
var victory: bool = false

signal turn_changed(turn: int)
signal player_changed(index: int)
signal entity_selected(entity)
signal spell_selected(spell)
signal game_ended(victory: bool)
signal entity_moved(entity, from_pos: Vector2i, to_pos: Vector2i)
signal entity_attacked(attacker, target, damage: int)
signal spell_casted(caster, spell, target, result: String)
signal message_requested(text: String)

var classes_data: Array = []
var spells_data: Array = []
var enemies_data: Array = []


func _ready():
    randomize()
    load_data()
    init_grid()
    init_entities()
    current_turn = 0
    turn_changed.emit(current_turn)
    player_changed.emit(current_player_index)


func load_data():
    classes_data = [
        {"Classe": "Tank", "Niveau": "30", "Vita (PV)": "120", "Force (CAC)": "20", "Intelligence (Magie)": "5", "Agilité (Vit. Atk)": "5", "Sagesse (Précision)": "10", "Défense": "30", "PA": "6", "PM": "3"},
        {"Classe": "Assassin", "Niveau": "30", "Vita (PV)": "80", "Force (CAC)": "15", "Intelligence (Magie)": "10", "Agilité (Vit. Atk)": "25", "Sagesse (Précision)": "20", "Défense": "10", "PA": "7", "PM": "4"},
        {"Classe": "Mage", "Niveau": "30", "Vita (PV)": "60", "Force (CAC)": "5", "Intelligence (Magie)": "25", "Agilité (Vit. Atk)": "10", "Sagesse (Précision)": "15", "Défense": "5", "PA": "8", "PM": "3"}
    ]
    spells_data = [
        {"Nom": "Coup puissant", "Classe": "Tank", "Coût PA": "1", "Coût PM": "0", "Portée": "10", "Effet": "25 dégâts", "Niveau requis": "1", "Type": "CAC"},
        {"Nom": "Bouclier", "Classe": "Tank", "Coût PA": "2", "Coût PM": "0", "Portée": "10", "Effet": "Réduit les dégâts de 50% pour 1 tour", "Niveau requis": "5", "Type": "Défense"},
        {"Nom": "Attaque furtive", "Classe": "Assassin", "Coût PA": "1", "Coût PM": "2", "Portée": "10", "Effet": "30 dégâts + ignore 50% défense", "Niveau requis": "1", "Type": "CAC"},
        {"Nom": "Poison", "Classe": "Assassin", "Coût PA": "2", "Coût PM": "0", "Portée": "10", "Effet": "15 dégâts + poison", "Niveau requis": "5", "Type": "Magie"},
        {"Nom": "Boule de feu", "Classe": "Mage", "Coût PA": "3", "Coût PM": "0", "Portée": "10", "Effet": "40 dégâts", "Niveau requis": "1", "Type": "Magie"},
        {"Nom": "Soin", "Classe": "Mage", "Coût PA": "2", "Coût PM": "0", "Portée": "10", "Effet": "Restaure 30 PV", "Niveau requis": "3", "Type": "Soin"}
    ]
    enemies_data = [
        {"Type": "Gobelin", "Niveau": "30", "PV": "60", "Attaque": "12", "Défense": "5", "PA": "5", "PM": "3", "Biome": "Forêt"},
        {"Type": "Squelette", "Niveau": "30", "PV": "50", "Attaque": "15", "Défense": "10", "PA": "4", "PM": "2", "Biome": "Donjon"},
        {"Type": "Loup", "Niveau": "30", "PV": "70", "Attaque": "10", "Défense": "3", "PA": "6", "PM": "4", "Biome": "Plaine"}
    ]


func init_grid():
    grid = []
    for y in range(GRID_SIZE):
        var row: Array = []
        for x in range(GRID_SIZE):
            row.append(null)
        grid.append(row)


func init_entities():
    var player_classes: Array[String] = ["Tank", "Assassin", "Mage"]
    var player_positions: Array[Vector2i] = [Vector2i(2, 2), Vector2i(2, 3), Vector2i(3, 2)]
    players = []
    for i in range(player_classes.size()):
        var classe := player_classes[i]
        var pos := player_positions[i]
        var class_info = null
        for data in classes_data:
            if data["Classe"] == classe and data["Niveau"] == "30":
                class_info = data
                break
        if class_info:
            var player = {
                "name": "%s Lv30" % classe,
                "entity_type": "Player",
                "classe": classe,
                "level": 30,
                "max_pv": int(class_info["Vita (PV)"]),
                "current_pv": int(class_info["Vita (PV)"]),
                "force": int(class_info["Force (CAC)"]),
                "intelligence": int(class_info["Intelligence (Magie)"]),
                "agility": int(class_info["Agilité (Vit. Atk)"]),
                "wisdom": int(class_info["Sagesse (Précision)"]),
                "defense": int(class_info["Défense"]),
                "max_pa": int(class_info["PA"]),
                "current_pa": int(class_info["PA"]),
                "max_pm": int(class_info["PM"]),
                "current_pm": int(class_info["PM"]),
                "x": pos.x,
                "y": pos.y,
                "spells": [],
                "is_active": false
            }
            for spell_info in spells_data:
                if spell_info["Classe"] == classe and int(spell_info["Niveau requis"]) <= 30:
                    player["spells"].append({
                        "name": spell_info["Nom"],
                        "classe": spell_info["Classe"],
                        "cost_pa": int(spell_info["Coût PA"]),
                        "cost_pm": int(spell_info["Coût PM"]),
                        "range": int(spell_info["Portée"]),
                        "effect": spell_info["Effet"],
                        "level_required": int(spell_info["Niveau requis"]),
                        "spell_type": spell_info["Type"]
                    })
            players.append(player)
            grid[pos.y][pos.x] = player
    var enemy_types: Array[String] = ["Gobelin", "Squelette", "Loup"]
    var enemy_positions: Array[Vector2i] = [Vector2i(5, 5), Vector2i(5, 4), Vector2i(4, 5)]
    enemies = []
    for i in range(enemy_types.size()):
        var enemy_type := enemy_types[i]
        var pos := enemy_positions[i]
        var enemy_info = null
        for data in enemies_data:
            if data["Type"] == enemy_type and data["Niveau"] == "30":
                enemy_info = data
                break
        if enemy_info:
            var enemy = {
                "name": "%s Lv30" % enemy_type,
                "entity_type": "Enemy",
                "classe": enemy_type,
                "level": 30,
                "max_pv": int(enemy_info["PV"]),
                "current_pv": int(enemy_info["PV"]),
                "force": int(enemy_info["Attaque"]),
                "intelligence": 0,
                "agility": float(enemy_info["Attaque"]) / 2.0,
                "wisdom": 0,
                "defense": int(enemy_info["Défense"]),
                "max_pa": int(enemy_info["PA"]),
                "current_pa": int(enemy_info["PA"]),
                "max_pm": int(enemy_info["PM"]),
                "current_pm": int(enemy_info["PM"]),
                "x": pos.x,
                "y": pos.y
            }
            enemies.append(enemy)
            grid[pos.y][pos.x] = enemy


func handle_cell_selected(cell_pos: Vector2i):
    var x := cell_pos.x
    var y := cell_pos.y
    if not (x >= 0 and x < GRID_SIZE and y >= 0 and y < GRID_SIZE):
        return
    selected_cell = cell_pos
    var entity = grid[y][x]
    if current_turn == 0:
        var current_player = players[current_player_index]
        if selected_spell != null:
            if entity and entity["current_pv"] > 0:
                var dx: int = abs(x - int(current_player["x"]))
                var dy: int = abs(y - int(current_player["y"]))
                var distance = dx + dy
                if distance <= selected_spell["range"]:
                    var spell_result = cast_spell(current_player, selected_spell, entity)
                    if spell_result:
                        spell_casted.emit(current_player, selected_spell, entity, spell_result)
                        message_requested.emit(spell_result)
                        if entity["current_pv"] <= 0 and entity["entity_type"] == "Enemy":
                            grid[entity["y"]][entity["x"]] = null
                            for j in range(enemies.size()):
                                if enemies[j] == entity:
                                    enemies.remove_at(j)
                                    break
                            check_game_over()
                    selected_spell = null
                    entity_selected.emit(null)
                    player_changed.emit(current_player_index)
                else:
                    message_requested.emit("Cible hors de portée ! (Portée: %d)" % selected_spell["range"])
            else:
                message_requested.emit("Pas de cible valide à cette position")
            return
        if entity and entity["entity_type"] == "Player" and entity == current_player:
            selected_entity = current_player
            show_spells = true
            for p in players:
                p["is_active"] = false
            current_player["is_active"] = true
            entity_selected.emit(current_player)
            player_changed.emit(current_player_index)
            return
        if selected_entity == current_player and entity == null and current_player["current_pm"] > 0:
            var dx: int = x - int(current_player["x"])
            var dy: int = y - int(current_player["y"])
            if abs(dx) + abs(dy) == 1:
                if grid[y][x] == null:
                    grid[current_player["y"]][current_player["x"]] = null
                    current_player["x"] = x
                    current_player["y"] = y
                    grid[y][x] = current_player
                    current_player["current_pm"] -= 1
                    entity_moved.emit(current_player, Vector2i(current_player["x"] - dx, current_player["y"] - dy), cell_pos)
                    selected_entity = null
                    show_spells = false
                    player_changed.emit(current_player_index)
            return
        if selected_entity == current_player and entity and entity["current_pv"] > 0:
            var dx: int = abs(x - int(current_player["x"]))
            var dy: int = abs(y - int(current_player["y"]))
            var distance = dx + dy
            if distance == 1:
                var damage = current_player["force"] + ((randi() % 5) - 2)
                var actual_damage = max(1, damage - entity["defense"] / 2.0)
                entity["current_pv"] -= actual_damage
                entity_attacked.emit(current_player, entity, actual_damage)
                current_player["current_pa"] -= 1
                message_requested.emit("%s attaque %s : %d dégâts !" % [current_player["name"], entity["name"], actual_damage])
                if entity["current_pv"] <= 0 and entity["entity_type"] == "Enemy":
                    grid[entity["y"]][entity["x"]] = null
                    for j in range(enemies.size()):
                        if enemies[j] == entity:
                            enemies.remove_at(j)
                            break
                    check_game_over()
                selected_entity = null
                show_spells = false
                player_changed.emit(current_player_index)
            return
    selected_entity = null
    show_spells = false


func handle_spell_selected(spell: Dictionary):
    var current_player = players[current_player_index]
    if can_cast_spell(current_player, spell):
        selected_spell = spell
        spell_selected.emit(spell)
        message_requested.emit("Sort sélectionné: %s (Portée: %d)" % [spell["name"], spell["range"]])
        player_changed.emit(current_player_index)
    else:
        message_requested.emit("Pas assez de PA/PM pour ce sort !")
        selected_spell = null


func next_player():
    current_player_index = (current_player_index + 1) % players.size()
    selected_entity = null
    selected_spell = null
    show_spells = false
    selected_cell = Vector2i(0, 0)
    player_changed.emit(current_player_index)
    message_requested.emit("Tour de %s" % players[current_player_index].get("name", "?"))
    if current_player_index == 0:
        enemy_turn()


func enemy_turn():
    current_turn = 1
    turn_changed.emit(current_turn)
    message_requested.emit("Tour des ennemis...")
    for enemy in enemies:
        if enemy["current_pv"] > 0:
            var ai_result = enemy_ai_turn(enemy, players, grid)
            message_requested.emit(ai_result)
            if not any_player_alive():
                break
    current_turn = 0
    turn_changed.emit(current_turn)
    message_requested.emit("Tour des joueurs")
    for player in players:
        player["current_pa"] = player["max_pa"]
        player["current_pm"] = player["max_pm"]
    check_game_over()


func any_player_alive() -> bool:
    for p in players:
        if p["current_pv"] > 0:
            return true
    return false


func check_game_over():
    var all_enemies_dead := true
    for enemy in enemies:
        if enemy["current_pv"] > 0:
            all_enemies_dead = false
            break
    var all_players_dead := true
    for player in players:
        if player["current_pv"] > 0:
            all_players_dead = false
            break
    if all_enemies_dead:
        victory = true
        game_over = true
        game_ended.emit(victory)
        message_requested.emit("VICTOIRE ! Tous les ennemis sont vaincus !")
    elif all_players_dead:
        victory = false
        game_over = true
        game_ended.emit(victory)
        message_requested.emit("DEFAITE... Tous les joueurs sont vaincus...")


func reset_game():
    init_grid()
    init_entities()
    current_turn = 0
    current_player_index = 0
    selected_entity = null
    selected_spell = null
    show_spells = false
    game_over = false
    victory = false
    selected_cell = Vector2i(0, 0)
    turn_changed.emit(current_turn)
    player_changed.emit(current_player_index)
    message_requested.emit("Nouvelle partie !")


func push_message(message: String):
    message_requested.emit(message)


func cast_spell(caster: Dictionary, spell: Dictionary, target: Dictionary) -> String:
    if not can_cast_spell(caster, spell):
        return ""
    caster["current_pa"] -= spell["cost_pa"]
    caster["current_pm"] -= spell["cost_pm"]
    if "dégâts" in spell["effect"].to_lower():
        var damage_str = spell["effect"].split(" ")[0]
        var damage = int(damage_str) if damage_str.is_valid_int() else 10
        target["current_pv"] -= max(1, damage - target["defense"] / 2.0)
        return "%s lance %s : %d dégâts !" % [caster["name"], spell["name"], damage]
    elif "restaure" in spell["effect"].to_lower() or "soin" in spell["effect"].to_lower():
        var heal_str = spell["effect"].split(" ")[1]
        var heal = int(heal_str) if heal_str.is_valid_int() else 15
        target["current_pv"] = min(target["max_pv"], target["current_pv"] + heal)
        return "%s lance %s : %d PV restaurés !" % [caster["name"], spell["name"], heal]
    else:
        return "%s lance %s !" % [caster["name"], spell["name"]]


func can_cast_spell(entity: Dictionary, spell: Dictionary) -> bool:
    return (entity["current_pa"] >= spell["cost_pa"] and 
            entity["current_pm"] >= spell["cost_pm"] and 
            entity["level"] >= spell["level_required"])


func enemy_ai_turn(p_enemy: Dictionary, p_players: Array, p_grid: Array) -> String:
    var alive_players := []
    for p in p_players:
        if p["current_pv"] > 0:
            alive_players.append(p)
    if alive_players.is_empty():
        return "%s ne peut pas agir." % p_enemy["name"]
    if randf() < 0.7 and p_enemy["current_pa"] >= 1:
        var target = alive_players[randi() % alive_players.size()]
        var damage = p_enemy["force"] + ((randi() % 5) - 2)
        var actual_damage = max(1, damage - target["defense"] / 2.0)
        target["current_pv"] -= actual_damage
        p_enemy["current_pa"] -= 1
        return "%s attaque %s : %d dégâts !" % [p_enemy["name"], target["name"], actual_damage]
    elif p_enemy["current_pm"] >= 1:
        var target = alive_players[randi() % alive_players.size()]
        var dx = 1 if target["x"] > p_enemy["x"] else -1 if target["x"] < p_enemy["x"] else 0
        var dy = 1 if target["y"] > p_enemy["y"] else -1 if target["y"] < p_enemy["y"] else 0
        if dx != 0 or dy != 0:
            var new_x = p_enemy["x"] + dx
            var new_y = p_enemy["y"] + dy
            if new_x >= 0 and new_x < GRID_SIZE and new_y >= 0 and new_y < GRID_SIZE and p_grid[new_y][new_x] == null:
                p_grid[p_enemy["y"]][p_enemy["x"]] = null
                p_enemy["x"] = new_x
                p_enemy["y"] = new_y
                p_grid[new_y][new_x] = p_enemy
                p_enemy["current_pm"] -= 1
                return "%s se déplace." % p_enemy["name"]
    return "%s ne fait rien." % p_enemy["name"]
