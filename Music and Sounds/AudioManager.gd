extends Node

onready var menuMoveStreamPlayer = $MenuMoveStreamPlayer
onready var menuSelectStreamPlayer = $MenuSelectStreamPlayer


func init_button_audio(parent):
	for node in parent.get_children():
		if node is Button:
#			print(node.name)
			node.connect("focus_entered", self, "_play_menu_move")
			node.connect("mouse_entered", self, "_play_menu_move")
			node.connect("pressed", self, "_play_menu_select")
		else:
			init_button_audio(node)


func _play_menu_move():
#	print("move")
	menuMoveStreamPlayer.play()


func _play_menu_select():
#	print("select")
	menuSelectStreamPlayer.play()
