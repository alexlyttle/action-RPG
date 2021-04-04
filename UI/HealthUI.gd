extends Control

var hearts = 4 setget set_hearts
var max_hearts = 4 setget set_max_hearts

onready var heartFull = $HeartFull
onready var heartEmpty = $HeartEmpty


func set_hearts(value):
	hearts = value
	if heartFull != null:
		# Set the width of the hearts container as a multiple of texture width
		heartFull.rect_size.x = hearts * heartFull.texture.get_width()


func set_max_hearts(value):
	max_hearts = value
	if heartEmpty != null:
		heartEmpty.rect_size.x = max_hearts * heartEmpty.texture.get_width()


func _ready():
	self.max_hearts = PlayerStats.max_health
	self.hearts = PlayerStats.health
	var _err = PlayerStats.connect("health_changed", self, "set_hearts")
	_err = PlayerStats.connect("max_health_changed", self, "set_max_hearts")
