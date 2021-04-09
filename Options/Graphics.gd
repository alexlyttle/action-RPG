extends Control

onready var menuContainer = $MenuContainer


func _ready():
#	AudioManager.init_button_audio(menuContainer)
	pass
	# Move this audio manager stuff to the MenuContainer class


func _on_CheckButton_toggled(button_pressed):
	OS.window_fullscreen = button_pressed


func _on_BackButton_pressed():
	queue_free()
