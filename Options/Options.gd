extends Control

#var controls
#var graphics

onready var menuContainer = $MenuContainer
onready var buttonContainer = $MenuContainer/VBoxContainer/VButtonContainer
onready var controlsButton = $MenuContainer/VBoxContainer/VButtonContainer/ControlsButton
onready var backButton = $MenuContainer/VBoxContainer/VButtonContainer/BackButton

signal back_button_pressed


func refresh():
	menuContainer.show()
#	controlsButton.grab_focus()
#	backButton.shortcut.enable()


func _ready():
	refresh()
#	AudioManager.init_button_audio(menuContainer)


func _on_ControlsButton_pressed():
#	get_tree().change_scene("res://Options/Controls.tscn")
	var controls = load("res://Options/Controls.tscn").instance()
	add_child(controls)
	controls.connect("tree_exited", self, "refresh")
#	backButton.shortcut.disable()
	menuContainer.hide()


func _on_BackButton_pressed():
#	get_tree().change_scene("res://StartMenu.tscn")
	emit_signal("back_button_pressed")


func _on_SoundButton_pressed():
	pass # Replace with function body.


#func _close_controls():
#	controls.queue_free()
#	controls = null
#	refresh()


func _on_GraphicsButton_pressed():
	var graphics = load("res://Options/Graphics.tscn").instance()
	add_child(graphics)
	graphics.connect("tree_exited", self, "refresh")
	menuContainer.hide()
