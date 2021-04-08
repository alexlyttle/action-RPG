extends Node

export(int) var max_health = 1 setget set_max_health

var health = max_health setget set_health

# Call down, signal up. Inherited nodes should signal up to their parent
# In this case, we signal when stats has no health
signal no_health
signal health_changed(value)  # Signal can take arguments
signal max_health_changed(value)


func save():
	var save_dict = {
		"name": get_name(),
		"filename": get_filename(),
		"parent": get_parent().get_path(),
		"children": [],
		"max_health": max_health,
		"health": health,
	}
	return save_dict


func set_health(value):
	# This funtion is called when the parent tries stats.health -= 1
	# The parent is calling down to stats, and we signal up when health <= 0
	health = clamp(value, 0, max_health)
	emit_signal("health_changed", health)
	print("emit signal")
	if health <= 0:
		emit_signal("no_health")


func set_max_health(value):
	max_health = max(value, 1)
	self.health = min(health, max_health)  # Health can never be larger than max health
	emit_signal("max_health_changed", max_health)


func _ready():
	self.health = max_health

