extends Node2D


func _ready():
	randomize()


func _input(event):
	if event.is_action("ui_start"):
		get_tree().change_scene("res://StartMenu.tscn")
