extends RefCounted
class_name Quest

# Quest status enumeration
enum QuestStatus {
	NOT_STARTED,
	IN_PROGRESS,
	COMPLETED,
	FAILED
}

# Quest data
var id: String = ""
var title: String = ""
var description: String = ""
var status: QuestStatus = QuestStatus.NOT_STARTED

# Objectives: Array of dictionaries with type, target, and current progress
var objectives: Array = []

# Rewards: Dictionary with reward types and values
var rewards: Dictionary = {}

# Priority (for UI sorting)
var priority: int = 0

# ===== METHODS =====

# Initialize a new quest
func _init(quest_data: Dictionary):
	id = quest_data.get("id", "")
	title = quest_data.get("title", "")
	description = quest_data.get("description", "")
	objectives = quest_data.get("objectives", [])
	rewards = quest_data.get("rewards", {})
	priority = quest_data.get("priority", 0)
	status = QuestStatus.NOT_STARTED

# Update progress for a specific objective type
func update_progress(objective_type: String, amount: int = 1) -> bool:
	var updated = false
	for obj in objectives:
		if obj.get("type", "") == objective_type:
			var current = obj.get("current", 0)
			var required = obj.get("required", 1)
			obj["current"] = min(current + amount, required)
			updated = true
			print("[Quest] Progress updated for ", id, ": ", obj)
			if obj["current"] >= required:
				print("[Quest] Objective completed: ", obj.get("type", ""))
				if is_complete():
					status = QuestStatus.COMPLETED
					print("[Quest] Quest completed: ", title)
					return true
	return updated

# Check if all objectives are complete
func is_complete() -> bool:
	if status == QuestStatus.COMPLETED:
		return true
	
	for obj in objectives:
		var current = obj.get("current", 0)
		var required = obj.get("required", 1)
		if current < required:
			return false
	return true

# Get completion percentage (0-100)
func get_completion_percentage() -> float:
	if objectives.size() == 0:
		return 100.0 if status == QuestStatus.COMPLETED else 0.0
	
	var total_required = 0
	var total_current = 0
	
	for obj in objectives:
		total_required += obj.get("required", 1)
		total_current += obj.get("current", 0)
	
	if total_required == 0:
		return 100.0
	
	return min(100.0, (total_current / total_required) * 100.0)

# Get current progress for display
func get_progress_text() -> String:
	if objectives.size() == 0:
		return ""
	
	var parts: Array = []
	for obj in objectives:
		var current = obj.get("current", 0)
		var required = obj.get("required", 1)
		parts.append("%s: %d/%d" % [obj.get("type", ""), current, required])
	
	return " - ".join(parts)

# Apply rewards to player
func apply_rewards(player_data: Dictionary) -> void:
	for reward_type in rewards:
		var reward_value = rewards[reward_type]
		match reward_type:
			"xp":
				player_data["xp"] = player_data.get("xp", 0) + reward_value
			"berries":
				player_data["berries"] = player_data.get("berries", 0) + reward_value
			"water":
				player_data["water"] = player_data.get("water", 0) + reward_value
			"hunger":
				player_data["hunger"] = min(100, player_data.get("hunger", 100) + reward_value)
			"thirst":
				player_data["thirst"] = min(100, player_data.get("thirst", 100) + reward_value)
			_:
				print("[Quest] Unknown reward type: ", reward_type)

# Reset quest
func reset() -> void:
	status = QuestStatus.NOT_STARTED
	for obj in objectives:
		obj["current"] = 0