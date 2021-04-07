extends Control


func _ready():
	get_node("CenterContainer/VBoxContainer/VButtonContainer/ControlsButton").grab_focus()


func _input(event):
	if event.is_action_pressed("ui_back"):
		_on_BackButton_pressed()


func _on_ControlsButton_pressed():
	get_tree().change_scene("res://Options/Options.tscn")


func _on_BackButton_pressed():
	get_tree().change_scene("res://StartMenu.tscn")
