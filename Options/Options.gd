extends Control

var controls = null

signal back_button_pressed


func refresh():
	get_node("CenterContainer/VBoxContainer/VButtonContainer/ControlsButton").grab_focus()


func _ready():
	refresh()


func _on_ControlsButton_pressed():
#	get_tree().change_scene("res://Options/Controls.tscn")
	controls = load("res://Options/Controls.tscn").instance()
	add_child(controls)
	controls.connect("back_button_pressed", self, "_close_controls")


func _on_BackButton_pressed():
#	get_tree().change_scene("res://StartMenu.tscn")
	emit_signal("back_button_pressed")


func _close_controls():
	controls.queue_free()
	controls = null
	refresh()
