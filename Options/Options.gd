#extends Control
extends Menu
#var controls
#var graphics

#onready var menuContainer = $MenuContainer
onready var buttonContainer = $MenuContainer/VBoxContainer/VButtonContainer
onready var controlsButton = $MenuContainer/VBoxContainer/VButtonContainer/ControlsButton
onready var backButton = $MenuContainer/VBoxContainer/VButtonContainer/BackButton

signal back_button_pressed


#func refresh():
#	menu_container.show()
##	controlsButton.grab_focus()
##	backButton.shortcut.enable()


func _ready():
	menu_container = $MenuContainer
#	refresh()
#	AudioManager.init_button_audio(menuContainer)


func _on_ControlsButton_pressed():
	add_menu("Controls", "res://Options/Controls.tscn")


func _on_BackButton_pressed():
	hide()


func _on_SoundButton_pressed():
	pass # Replace with function body.


func _on_GraphicsButton_pressed():
	add_menu("Graphics", "res://Options/Graphics.tscn")
