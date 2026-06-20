extends Node
## GameManager - Gère la logique globale du jeu WildZimut

const GRID_SIZE := 10
const CELL_SIZE := 64
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

var classes_data: Array = []
var spells_data: Array = []
var enemies_data: Array = []


func _ready():
    load_data()
    init_grid()
    init_entities()
    current_turn = 0
    turn_changed.emit(current_turn)


func load_data():
    classes_data = [
        {"Classe": "Tank", "Niveau": "10", "Vita (PV)": "120", "Force (CAC)": "20", "Intelligence (Magie)": "5", "Agilité (Vit. Atk)": "5", "Sagesse (Précision)": "10", "Défense": "30", "PA": "6", "PM": "3"},
        {"Classe": "Assassin", "Niveau": "10", "Vita (PV)": "80", "Force (CAC)": "15", "Intelligence (Magie)": "10", "Agilité (Vit. Atk)": "25", "Sagesse (Précision)": "20", "Défense": "10", "PA": "7", "PM": "4"},
        {"Classe": "Mage", "Niveau": "10", "Vita (PV)": "60", "Force (CAC)": "5", "Intelligence (Magie)": "25", "Agilité (Vit. Atk)": "10", "Sagesse (Précision)": "15", "Défense": "5", "PA": "8", "PM": "3"}
    ]
    
    spells_data = [
        {"Nom": "Coup puissant", "Classe": "Tank", "Coût PA": "1", "Coût PM": "0", "Portée": "1", "Effet": "25 dégâts", "Niveau requis": "1", "Type": "CAC"},
        {"Nom": "Bouclier", "Classe": "Tank", "Coût PA": "2", "Coût PM": "0", "Portée": "1", "Effet": "Réduit les dégâts de 50% pour 1 tour", "Niveau requis": "5", "Type": "Défense"},
        {"Nom": "Attaque furtive", "Classe": "Assassin", "Coût PA": "1", "Coût PM": "2", "Portée": "1", "Effet": "30 dégâts + ignore 50% défense", "Niveau requis": "1", "Type": "CAC"},
        {"Nom": "Poison", "Classe": "Assassin", "Coût PA": "2", "Coût PM": "0", "Portée": "3", "Effet": "15 dégâts + poison", "Niveau requis": "5", "Type": "Magie"},
        {"Nom": "Boule de feu", "Classe": "Mage", "Coût PA": "3", "Coût PM": "0", "Portée": "5", "Effet": "40 dégâts", "Niveau requis": "1", "Type": "Magie"},
        {"Nom": "Soin", "Classe": "Mage", "Coût PA": "2", "Coût PM": "0", "Portée": "4", "Effet": "Restaure 30 PV", "Niveau requis": "3", "Type": "Soin"}
    ]
    
    enemies_data = [
        {"Type": "Gobelin", "Niveau": "10", "PV": "60", "Attaque": "12", "Défense": "5", "PA": "5", "PM": "3", "Biome": "Forêt", "Effets spéciaux": ""},
        {"Type": "Squelette", "Niveau": "10", "PV": "50", "Attaque": "15", "Défense": "10", "PA": "4", "PM": "2", "Biome": "Donjon", "Effets spéciaux": ""},
        {"Type": "Loup", "Niveau": "10", "PV": "70", "Attaque": "10", "Défense": "3", "PA": "6", "PM": "4", "Biome": "Plaine", "Effets spéciaux": ""}
    ]


func init_grid():
    grid = []
    for y in range(GRID_SIZE):
        var row: Array = []
        for x in range(GRID_SIZE):
            row.append(null)
        grid.append(row)


func init_entities():
    var player_classes := ["Tank", "Assassin", "Mage"]
    var player_positions := [Vector2i(1, 1), Vector2i(1, 2), Vector2i(2, 1)]
    
    players = []
    
    for i in range(player_classes.size()):
        var classe := player_classes[i]
        var pos := player_positions[i]
        
        var class_info = null
        for data in classes_data:
            if data["Classe"] == classe and data["Niveau"] == "10":
                class_info = data
                break
        
        if class_info:
            var player = {
                "name": "%s Lv10" % classe,
                "entity_type": "Player",
                "classe": classe,
                "level": 10,
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
                if spell_info["Classe"] == classe and int(spell_info["Niveau requis"]) <= 10:
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
    
    var enemy_types := ["Gobelin", "Squelette", "Loup"]
    var enemy_positions := [Vector2i(8, 8), Vector2i(8, 7), Vector2i(7, 8)]
    
    enemies = []
    
    for i in range(enemy_types.size()):
        var enemy_type := enemy_types[i]
        var pos := enemy_positions[i]
        
        var enemy_info = null
        for data in enemies_data:
            if data["Type"] == enemy_type and data["Niveau"] == "10":
                enemy_info = data
                break
        
        if enemy_info:
            var enemy = {
                "name": "%s Lv10" % enemy_type,
                "entity_type": "Enemy",
                "classe": enemy_type,
                "level": 10,
                "max_pv": int(enemy_info["PV"]),
                "current_pv": int(enemy_info["PV"]),
                "force": int(enemy_info["Attaque"]),
                "intelligence": 0,
                "agility": int(enemy_info["Attaque"]) / 2,
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
    
    if not (0 <= x < GRID_SIZE and 0 <= y < GRID_SIZE):
        return
    
    selected_cell = cell_pos
    var entity := grid[y][x]
    
    if current_turn == 0:
        var current_player = players[current_player_index]
        
        if entity and entity["entity_type"] == "Player" and entity == current_player:
            selected_entity = entity
            show_spells = true
            for p in players:
                p["is_active"] = false
            current_player["is_active"] = true
            entity_selected.emit(current_player)
            return
        
        if selected_entity == current_player and entity == null and current_player["current_pm"] > 0:
            var dx := x - current_player["x"]
            var dy := y - current_player["y"]
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
            return
        
        if selected_entity == current_player:
            if entity and entity["current_pv"] > 0:
                if selected_spell != null:
                    var result = cast_spell(current_player, selected_spell, entity)
                    if result:
                        spell_casted.emit(current_player, selected_spell, entity, result)
                        if entity["current_pv"] <= 0 and entity["entity_type"] == "Enemy":
                            grid[entity["y"]][entity["x"]] = null
                            for j in range(enemies.size()):
                                if enemies[j] == entity:
                                    enemies.remove(j)
                                    break
                            check_game_over()
                    selected_spell = null
                    show_spells = false
                    selected_entity = null
                return
    
    selected_entity = null
    show_spells = false


func handle_spell_selected(spell: Dictionary):
    selected_spell = spell
    spell_selected.emit(spell)


func next_player():
    current_player_index = (current_player_index + 1) % players.size()
    selected_entity = null
    show_spells = false
    selected_cell = Vector2i(0, 0)
    player_changed.emit(current_player_index)
    
    if current_player_index == 0:
        enemy_turn()


func enemy_turn():
    current_turn = 1
    turn_changed.emit(current_turn)
    
    for enemy in enemies:
        if enemy["current_pv"] > 0:
            var result = enemy_ai_turn(enemy, players, grid)
            push_message(result)
            if not any(p["current_pv"] > 0) for p in players:
                break
    
    current_turn = 0
    turn_changed.emit(current_turn)
    
    for player in players:
        player["current_pa"] = player["max_pa"]
        player["current_pm"] = player["max_pm"]
    
    check_game_over()


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
    elif all_players_dead:
        victory = false
        game_over = true
        game_ended.emit(victory)


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


func push_message(message: String):
    print(message)


func cast_spell(caster: Dictionary, spell: Dictionary, target: Dictionary) -> String:
    if not can_cast_spell(caster, spell):
        return ""
    
    caster["current_pa"] -= spell["cost_pa"]
    caster["current_pm"] -= spell["cost_pm"]
    
    if "dégâts" in spell["effect"].to_lower():
        var damage_str = spell["effect"].split(" ")[0]
        var damage = int(damage_str) if damage_str.is_valid_int() else 10
        target["current_pv"] -= max(1, damage - target["defense"] / 2)
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


func enemy_ai_turn(enemy: Dictionary, players: Array, grid: Array) -> String:
    var alive_players := []
    for p in players:
        if p["current_pv"] > 0:
            alive_players.append(p)
    
    if alive_players.is_empty():
        return "%s ne peut pas agir." % enemy["name"]
    
    if randf() < 0.7 and enemy["current_pa"] >= 1:
        var target = alive_players[randi() % alive_players.size()]
        var damage = enemy["force"] + randi_range(-2, 2)
        var actual_damage = max(1, damage - target["defense"] / 2)
        target["current_pv"] -= actual_damage
        enemy["current_pa"] -= 1
        return "%s attaque %s : %d dégâts !" % [enemy["name"], target["name"], actual_damage]
    elif enemy["current_pm"] >= 1:
        var target = alive_players[randi() % alive_players.size()]
        var dx = 1 if target["x"] > enemy["x"] else -1 if target["x"] < enemy["x"] else 0
        var dy = 1 if target["y"] > enemy["y"] else -1 if target["y"] < enemy["y"] else 0
        if dx != 0 or dy != 0:
            var new_x = enemy["x"] + dx
            var new_y = enemy["y"] + dy
            if 0 <= new_x < GRID_SIZE and 0 <= new_y < GRID_SIZE and grid[new_y][new_x] == null:
                grid[enemy["y"]][enemy["x"]] = null
                enemy["x"] = new_x
                enemy["y"] = new_y
                grid[new_y][new_x] = enemy
                enemy["current_pm"] -= 1
                return "%s se déplace." % enemy["name"]
    return "%s ne fait rien." % enemy["name"]
