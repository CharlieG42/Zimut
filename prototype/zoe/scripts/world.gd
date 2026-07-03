extends Node2D

const GRID_SIZE := 8
const CELL_SIZE := 140
const PLAYER_START := Vector2i(0, 0)

@onready var player_node: Area2D
@onready var ui: Control
@onready var game_manager: Node
@onready var game_over_panel: CanvasLayer
@onready var quest_manager: QuestManager

var grid := []
var turn_count := 0
var hunger := 100
var thirst := 100
var game_over := false

func _ready():
\t_setup_grid()
\t_setup_player()
\t_setup_ui()
\t_setup_game_manager()
\t_setup_game_over_panel()
\t_setup_quest_manager()
\tprint("[World] pret. Node racine='", name, "'")

func _setup_grid():
\tfor y in range(GRID_SIZE):
\t\tgrid.append([])
\t\tfor x in range(GRID_SIZE):
\t\t\tgrid[y].append(_create_tile(Vector2i(x, y)))

func _create_tile(pos: Vector2i) -> Node2D:
\tvar tile := Node2D.new()
\ttile.name = "Tile_%d_%d" % [pos.x, pos.y]
\ttile.position = Vector2(float(pos.x) * CELL_SIZE, float(pos.y) * CELL_SIZE)
\tadd_child(tile)
\tvar sprite := Sprite2D.new()
\tsprite.texture = load("res://assets/sprites/elements/grass.png")
\tsprite.position = Vector2(CELL_SIZE / 2, CELL_SIZE / 2)
\ttile.add_child(sprite)
\tif pos != PLAYER_START:
\t\tif randf() < 0.1:
\t\t\t_add_obstacle(tile)
\t\telif randf() < 0.05:
\t\t\t_add_collectible(tile, "berries")
\t\telif randf() < 0.05:
\t\t\t_add_collectible(tile, "water")
\treturn tile

func _add_obstacle(tile: Node2D):
\tvar obstacle := Area2D.new()
\tobstacle.name = "Obstacle"
\tvar sprite := Sprite2D.new()
\tsprite.texture = load("res://assets/sprites/elements/rock.png")
\tsprite.position = Vector2(CELL_SIZE / 2, CELL_SIZE / 2)
\tobstacle.add_child(sprite)
\tvar collision := CollisionShape2D.new()
\tcollision.shape = RectangleShape2D.new()
\tcollision.shape.size = Vector2(CELL_SIZE, CELL_SIZE)
\tobstacle.add_child(collision)
\ttile.add_child(obstacle)

func _add_collectible(tile: Node2D, type: String):
\tvar collectible := Area2D.new()
\tcollectible.name = "Collectible_%s" % type
\tvar sprite := Sprite2D.new()
\tsprite.texture = load("res://assets/sprites/elements/%s.png" % type)
\tsprite.position = Vector2(CELL_SIZE / 2, CELL_SIZE / 2)
\tcollectible.add_child(sprite)
\tvar collision := CollisionShape2D.new()
\tcollision.shape = RectangleShape2D.new()
\tcollision.shape.size = Vector2(CELL_SIZE, CELL_SIZE)
\tcollectible.add_child(collision)
\tcollectible.set_meta("type", type)
\ttile.add_child(collectible)

func _setup_player():
\tplayer_node = Area2D.new()
\tplayer_node.name = "Player"
\tplayer_node.position = Vector2(PLAYER_START.x * CELL_SIZE, PLAYER_START.y * CELL_SIZE)
\tplayer_node.set_script(load("res://scripts/player.gd"))
\tadd_child(player_node)
\tplayer_node.move_request.connect(_on_player_move_request)
\tplayer_node.collect.connect(_on_player_collect)

func _setup_ui():
\tvar layer := CanvasLayer.new()
\tlayer.name = "UILayer"
\tadd_child(layer)
\tui = Control.new()
\tui.name = "UI"
\tui.mouse_filter = Control.MOUSE_FILTER_IGNORE
\tui.position = Vector2(10, get_viewport_rect().size.y - 250)
\tvar vbox := VBoxContainer.new()
\tvbox.name = "StatsContainer"
\tvbox.mouse_filter = Control.MOUSE_FILTER_IGNORE
\tvbox.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
\tui.add_child(vbox)
\tvar hunger_label := Label.new()
\thunger_label.name = "HungerLabel"
\thunger_label.text = "Hunger: %d" % hunger
\tvbox.add_child(hunger_label)
\tvar thirst_label := Label.new()
\tthirst_label.name = "ThirstLabel"
\tthirst_label.text = "Thirst: %d" % thirst
\tvbox.add_child(thirst_label)
\tvar turn_label := Label.new()
\tturn_label.name = "TurnLabel"
\tturn_label.text = "Turns: %d" % turn_count
\tvbox.add_child(turn_label)
\tvar quest_label := Label.new()
\tquest_label.name = "QuestLabel"
\tquest_label.text = "Quetes: -"
\tvbox.add_child(quest_label)
\tvar debug_label := Label.new()
\tdebug_label.name = "DebugLabel"
\tdebug_label.text = "Debug: -"
\tvbox.add_child(debug_label)
\tvar message_label := Label.new()
\tmessage_label.name = "MessageLabel"
\tmessage_label.visible = false
\tui.add_child(message_label)
\tvar restart_button := Button.new()
\trestart_button.text = "Restart"
\trestart_button.mouse_filter = Control.MOUSE_FILTER_STOP
\trestart_button.pressed.connect(_on_restart_pressed)
\tvbox.add_child(restart_button)
\tvar quit_button := Button.new()
\tquit_button.text = "Quit"
\tquit_button.mouse_filter = Control.MOUSE_FILTER_STOP
\tquit_button.pressed.connect(_on_quit_pressed)
\tvbox.add_child(quit_button)
\tlayer.add_child(ui)

func _setup_game_over_panel():
\tvar layer := CanvasLayer.new()
\tlayer.name = "GameOverLayer"
\tadd_child(layer)
\tvar background := ColorRect.new()
\tbackground.name = "GameOverBackground"
\tbackground.color = Color(0, 0, 0, 0.7)
\tbackground.anchor_right = 1.0
\tbackground.anchor_bottom = 1.0
\tbackground.size = get_viewport_rect().size
\tlayer.add_child(background)
\tvar panel := VBoxContainer.new()
\tpanel.name = "GameOverPanel"
\tpanel.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
\tpanel.size_flags_vertical = Control.SIZE_SHRINK_CENTER
\tbackground.add_child(panel)
\tvar title_label := Label.new()
\ttitle_label.name = "GameOverTitle"
\ttitle_label.text = "Game Over !"
\ttitle_label.add_theme_color_override("font_color", Color.RED)
\ttitle_label.add_theme_font_size_override("font_size", 32)
\tpanel.add_child(title_label)
\tvar message_label_go := Label.new()
\tmessage_label_go.name = "GameOverMessage"
\tmessage_label_go.text = "Faim ou soif a 0..."
\tmessage_label_go.add_theme_font_size_override("font_size", 24)
\tpanel.add_child(message_label_go)
\tvar restart_btn := Button.new()
\trestart_btn.name = "GameOverRestart"
\trestart_btn.text = "Recommencer"
\trestart_btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
\trestart_btn.pressed.connect(_on_restart_pressed)
\tpanel.add_child(restart_btn)
\tvar quit_btn := Button.new()
\tquit_btn.name = "GameOverQuit"
\tquit_btn.text = "Quitter"
\tquit_btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
\tquit_btn.pressed.connect(_on_quit_pressed)
\tpanel.add_child(quit_btn)
\tlayer.visible = false
\tgame_over_panel = layer

func _setup_quest_manager():
\tvar qm := Node.new()
\tqm.name = "QuestManager"
\tqm.set_script(load("res://scripts/QuestManager.gd"))
\tadd_child(qm)
\tquest_manager = qm
\tquest_manager.player_node = player_node
\tquest_manager.world_node = self
\tquest_manager.start_all_quests()

func update_ui():
\tui.get_node("StatsContainer/HungerLabel").text = "Hunger: %d" % hunger
\tui.get_node("StatsContainer/ThirstLabel").text = "Thirst: %d" % thirst
\tui.get_node("StatsContainer/TurnLabel").text = "Turns: %d" % turn_count
\tif quest_manager:
\t\tvar quest_summary := quest_manager.get_quest_summary()
\t\tif quest_summary.size() > 0:
\t\t\tvar quest_text := ""
\t\t\tfor i in range(quest_summary.size()):
\t\t\t\tvar q := quest_summary[i]
\t\t\t\tif i > 0:
\t\t\t\t\tquest_text += " | "
\t\t\t\tquest_text += "%s: %.0f%%" % [q["title"], q["progress"] * 100]
\t\t\tui.get_node("StatsContainer/QuestLabel").text = "Quetes: %s" % quest_text
\t\telse:
\t\t\tui.get_node("StatsContainer/QuestLabel").text = "Quetes: -"

func _set_debug(text: String):
\tif ui and ui.has_node("StatsContainer/DebugLabel"):
\t\tui.get_node("StatsContainer/DebugLabel").text = "Debug: %s" % text

func _setup_game_manager():
\tgame_manager = Node.new()
\tgame_manager.name = "GameManager"
\tgame_manager.set_script(load("res://scripts/game_manager.gd"))
\tadd_child(game_manager)
\tgame_manager.world = self

func show_game_over():
\tif game_over_panel:
\t\tgame_over_panel.visible = true

func hide_game_over():
\tif game_over_panel:
\t\tgame_over_panel.visible = false

func _on_player_collect(item_type: String):
\tif item_type == "berries":
\t\thunger = min(100, hunger + 20)
\t\tif quest_manager:
\t\t\tquest_manager.update_quest("find_berries", "collect", 1)
\telif item_type == "water":
\t\tthirst = min(100, thirst + 20)
\t\tif quest_manager:
\t\t\tquest_manager.update_quest("find_water", "collect", 1)
\tupdate_ui()

func _on_player_move_request(direction: Vector2i):
\tvar current_pos: Vector2i = player_node.position_grid
\tvar new_position: Vector2i = current_pos + direction
\tif new_position.x < 0 or new_position.x >= GRID_SIZE or new_position.y < 0 or new_position.y >= GRID_SIZE:
\t\t_set_debug("hors grille %s" % str(new_position))
\t\tplayer_node.can_move = true
\t\treturn
\tvar target_tile: Node2D = grid[new_position.y][new_position.x]
\tvar has_obstacle := false
\tfor child in target_tile.get_children():
\t\tif child.name == "Obstacle":
\t\t\thas_obstacle = true
\t\t\tbreak
\tif has_obstacle:
\t\tprint("[World] Mouvement bloque : rocher en ", new_position)
\t\t_set_debug("bloque par rocher en %s" % str(new_position))
\t\tplayer_node.can_move = true
\t\treturn
\tplayer_node.move_to_grid_position(new_position)
\t_set_debug("deplace vers %s" % str(new_position))
\tfor child in target_tile.get_children():
\t\tif child.name.begins_with("Collectible_") and child.has_meta("type"):
\t\t\tvar type: String = child.get_meta("type") as String
\t\t\tif type == "berries":
\t\t\t\thunger = min(100, hunger + 20)
\t\t\t\tif quest_manager:
\t\t\t\t\tquest_manager.update_quest("find_berries", "collect", 1)
\t\t\t\telif type == "water":
\t\t\t\t\tthirst = min(100, thirst + 20)
\t\t\t\t\tif quest_manager:
\t\t\t\t\t\tquest_manager.update_quest("find_water", "collect", 1)
\t\t\t\tchild.queue_free()
\tend_turn()

func _on_restart_pressed():
\thide_game_over()
\tget_tree().reload_current_scene()

func _on_quit_pressed():
\tget_tree().quit()

func end_turn():
\tturn_count += 1
\thunger = max(0, hunger - 5)
\tthirst = max(0, thirst - 5)
\tif hunger <= 0 or thirst <= 0:
\t\tgame_over = true
\t\tgame_manager.emit_signal("defeat")
\t\treturn
\tplayer_node.can_move = true
\tupdate_ui()

func _input(event):
\tif event is InputEventScreenTouch or event is InputEventMouseButton:
\t\tprint("[World] event tactile/souris recu: ", event)
\t\tvar pressed_pos := Vector2.ZERO
\t\tvar is_tap := false
\t\tif event is InputEventScreenTouch and event.pressed:
\t\t\tpressed_pos = event.position
\t\t\tis_tap = true
\t\telif event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
\t\t\tpressed_pos = event.position
\t\t\tis_tap = true
\t\tif not is_tap:
\t\t\treturn
\t\tvar world_pos: Vector2 = to_local(get_global_mouse_position())
\t\tvar target_x: int = int(floor(world_pos.x / CELL_SIZE))
\t\tvar target_y: int = int(floor(world_pos.y / CELL_SIZE))
\t\tprint("[World] tap ecran=", pressed_pos, " -> monde=", world_pos, " -> case=(", target_x, ",", target_y, ")")
\t\t_set_debug("tap case (%d,%d)" % [target_x, target_y])
\t\tif target_x < 0 or target_x >= GRID_SIZE or target_y < 0 or target_y >= GRID_SIZE:
\t\t\treturn
\t\tif not player_node.can_move or game_over:
\t\t\treturn
\t\tvar current_pos: Vector2i = player_node.position_grid
\t\tvar dx: int = target_x - current_pos.x
\t\tvar dy: int = target_y - current_pos.y
\t\tif abs(dx) + abs(dy) == 1:
\t\t\tplayer_node.can_move = false
\t\t\tplayer_node.move_request.emit(Vector2i(dx, dy))