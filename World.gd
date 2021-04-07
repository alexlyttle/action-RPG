extends Node2D

const SAVE_PATH = "user://world.dat"
const SPECIAL_KEYS = {
	FILENAME = "filename", 
	PARENT = "parent",
	POS_X = "pos_x",
	POS_Y = "pos_y",
	CHILDREN = "children"
}


#func update_world(state):
#	if state == SaveGame.CONTINUE:
#		SaveGame.load_game(SAVE_PATH)
#

func _ready():
#	load_game()
	if SaveGame.state == SaveGame.CONTINUE:
		SaveGame.load_game(SAVE_PATH)
	else:
		randomize()


func _input(event):
	if event.is_action_pressed("ui_start") or event.is_action_pressed("ui_cancel"):
		SaveGame.save_game(SAVE_PATH)
		get_tree().change_scene("res://StartMenu.tscn")
#		emit_signal("pause_game")
	if event.is_action_pressed("ui_home"):
		SaveGame.load_game(SAVE_PATH)
