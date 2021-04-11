extends Node2D

const SAVE_PATH = "user://world.dat"

onready var playerStats = $Foreground/Player/Stats
onready var healthUI = $UI/HealthUI


func _ready():
#	load_game()
	
	var _err = playerStats.connect("health_changed", healthUI, "set_hearts")
	_err = playerStats.connect("max_health_changed", healthUI, "set_max_hearts")

	if SaveGame.state == SaveGame.CONTINUE:
		SaveGame.load_game(SAVE_PATH)
	else:
		randomize()

