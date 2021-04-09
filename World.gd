extends Node2D

const SAVE_PATH = "user://world.dat"


onready var playerStats = $Foreground/Player/Stats
onready var healthUI = $UI/HealthUI

#func update_world(state):
#	if state == SaveGame.CONTINUE:
#		SaveGame.load_game(SAVE_PATH)
#

func _ready():
#	load_game()
	
	var _err = playerStats.connect("health_changed", healthUI, "set_hearts")
	_err = playerStats.connect("max_health_changed", healthUI, "set_max_hearts")

	if SaveGame.state == SaveGame.CONTINUE:
		SaveGame.load_game(SAVE_PATH)
	else:
		randomize()
	
#	var _err = playerStats.connect("health_changed", healthUI, "set_hearts")
#	_err = playerStats.connect("max_health_changed", healthUI, "set_max_hearts")
#


#func _input(event):
#	if event.is_action_pressed("ui_start") or event.is_action_pressed("ui_cancel"):
##		SaveGame.save_game(SAVE_PATH)
##		get_tree().change_scene("res://StartMenu.tscn")
##		emit_signal("pause_game")
#
#	if event.is_action_pressed("ui_home"):
#		SaveGame.load_game(SAVE_PATH)
