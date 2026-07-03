extends Node
class_name QuestManager

# Signals
signal quest_started(quest_id: String)
signal quest_updated(quest_id: String, progress: float)
signal quest_completed(quest_id: String)

# Quest data storage
var available_quests: Dictionary = {}
var active_quests: Dictionary = {}
var completed_quests: Array = []

# Reference to player and world
var player_node: Node2D
var world_node: Node2D

# ===== INITIALIZATION =====

func _ready():
	_load_quests()
	print("[QuestManager] Loaded ", available_quests.size(), " available quests")

# Load quests from a configuration
func _load_quests() -> void:
	# Default quests for ZOE
	available_quests = {
		"find_berries": {
			"id": "find_berries",
			"title": "Cueillette de Baies",
			"description": "Trouve 5 baies pour restaurer ta vitalite",
			"priority": 1,
			"objectives": [
				{"type": "collect", "target": "berries", "required": 5, "current": 0}
			],
			"rewards": {"hunger": 50, "xp": 100}
		},
		"find_water": {
			"id": "find_water",
			"title": "Recherche d'Eau",
			"description": "Trouve 3 sources d'eau pour etancher ta soif",
			"priority": 2,
			"objectives": [
				{"type": "collect", "target": "water", "required": 3, "current": 0}
			],
			"rewards": {"thirst": 50, "xp": 100}
		}
	}

# ===== QUEST MANAGEMENT =====

# Start a quest by ID
func start_quest(quest_id: String) -> Quest:
	if not available_quests.has(quest_id):
		print("[QuestManager] Quest not found: ", quest_id)
		return null
	
	if active_quests.has(quest_id):
		print("[QuestManager] Quest already active: ", quest_id)
		return active_quests.get(quest_id, null)
	
	# Create quest instance
	var quest_data: Dictionary = available_quests.get(quest_id, {})
	var quest = Quest.new(quest_data)
	
	# Add to active quests
	active_quests[quest_id] = quest
	
	# Emit signal
	emit_signal("quest_started", quest_id)
	print("[QuestManager] Quest started: ", quest_id)
	
	return quest

# Start all available quests (or specific ones)
func start_all_quests() -> void:
	for quest_id in available_quests:
		start_quest(quest_id)

# Update quest progress
func update_quest(quest_id: String, objective_type: String, amount: int = 1) -> bool:
	if not active_quests.has(quest_id):
		return false
	
	var quest = active_quests.get(quest_id, null)
	var was_updated = quest.update_progress(objective_type, amount)
	
	if was_updated:
		var progress = quest.get_completion_percentage()
		emit_signal("quest_updated", quest_id, progress)
		
		if quest.is_complete():
			complete_quest(quest_id)
			return true
	
	return was_updated

# Complete a quest
func complete_quest(quest_id: String) -> void:
	if not active_quests.has(quest_id):
		return
	
	var quest = active_quests.get(quest_id, null)
	quest.status = 2  # COMPLETED
	
	# Apply rewards
	if world_node:
		var player_data: Dictionary = {"xp": 0, "berries": 0, "water": 0, "hunger": 0, "thirst": 0}
		quest.apply_rewards(player_data)
		
		# Apply rewards to player (hunger/thirst are on world_node, not player_node)
		if player_data.has("hunger"):
			var hunger_value = player_data.get("hunger", 0)
			world_node.hunger = min(100, world_node.hunger + hunger_value)
		if player_data.has("thirst"):
			var thirst_value = player_data.get("thirst", 0)
			world_node.thirst = min(100, world_node.thirst + thirst_value)
		# Note: berries and water rewards would need to be handled differently
		# as they are collectible items in the world
	
	# Move to completed
	completed_quests.append(quest_id)
	active_quests.erase(quest_id)
	
	emit_signal("quest_completed", quest_id)
	print("[QuestManager] Quest completed: ", quest_id)

# Get active quests
func get_active_quests() -> Array:
	return active_quests.values()

# Get quest by ID
func get_quest(quest_id: String) -> Quest:
	if active_quests.has(quest_id):
		return active_quests.get(quest_id, null)
	elif completed_quests.has(quest_id):
		# If we want to support accessing completed quests
		return null
	return null

# Check if a quest is active
func is_quest_active(quest_id: String) -> bool:
	return active_quests.has(quest_id)

# Check if a quest is completed
func is_quest_completed(quest_id: String) -> bool:
	return completed_quests.has(quest_id)

# ===== UTILITY FUNCTIONS =====

# Get quest progress summary for UI
func get_quest_summary() -> Array:
	var summaries: Array = []
	for quest_id in active_quests:
		var quest = active_quests.get(quest_id, null)
		summaries.append({
			"id": quest.id,
			"title": quest.title,
			"progress": quest.get_completion_percentage(),
			"progress_text": quest.get_progress_text()
		})
	return summaries