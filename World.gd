extends Node2D


func _ready():
	randomize()


func _input(event):
	if event.is_action_pressed("ui_start") or event.is_action_pressed("ui_cancel"):
		get_tree().change_scene("res://StartMenu.tscn")
