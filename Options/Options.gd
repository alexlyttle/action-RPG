extends Control

var controls = null

onready var centerContainer = $CenterContainer
onready var buttonContainer = $CenterContainer/VBoxContainer/VButtonContainer
onready var controlsButton = $CenterContainer/VBoxContainer/VButtonContainer/ControlsButton
onready var backButton = $CenterContainer/VBoxContainer/VButtonContainer/BackButton

signal back_button_pressed


func refresh():
	centerContainer.show()
	controlsButton.grab_focus()
#	backButton.shortcut.enable()


func _ready():
	refresh()


func _on_ControlsButton_pressed():
#	get_tree().change_scene("res://Options/Controls.tscn")
	controls = load("res://Options/Controls.tscn").instance()
	add_child(controls)
	controls.connect("back_button_pressed", self, "_close_controls")
#	backButton.shortcut.disable()
	centerContainer.hide()


func _on_BackButton_pressed():
#	get_tree().change_scene("res://StartMenu.tscn")
	emit_signal("back_button_pressed")


func _on_SoundButton_pressed():
	pass # Replace with function body.


func _close_controls():
	controls.queue_free()
	controls = null
	refresh()
