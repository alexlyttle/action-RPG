extends Control


func _on_ControlsButton_pressed():
	get_tree().change_scene("res://Options/Controls.tscn")


func _on_BackButton_pressed():
	get_tree().change_scene("res://StartMenu.tscn")
