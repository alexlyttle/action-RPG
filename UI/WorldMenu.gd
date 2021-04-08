extends Control

var options = null

onready var centerContainer = $CenterContainer
onready var continueButton = $CenterContainer/VBoxContainer/ContinueButton


func refresh():
	centerContainer.show()
	continueButton.grab_focus()


func _ready():
	refresh()


func _on_ContinueButton_pressed():
	hide()
	get_tree().paused = false


func _on_QuitButton_pressed():
	get_tree().change_scene("res://StartMenu.tscn")
	get_tree().paused = false


func _on_OptionsButton_pressed():
	options = load("res://Options/Options.tscn").instance()
	add_child(options)
	options.connect("back_button_pressed", self, "_close_options")
	centerContainer.hide()


func _close_options():
	options.queue_free()
	options = null
	refresh()
