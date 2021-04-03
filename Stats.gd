extends Node

export(int) var max_health = 1

onready var health = max_health setget set_health

# Call down, signal up. Inherited nodes should signal up to their parent
# In this case, we signal when stats has no health
signal no_health


func set_health(value):
	# This funtion is called when the parent tries stats.health -= 1
	# The parent is calling down to stats, and we signal up when health <= 0
	health = value
	if health <= 0:
		emit_signal("no_health")
