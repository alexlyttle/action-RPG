extends Control

const SAVE_PATH = "user://world.dat"  # Make this a directory for many worlds

var options = null  # track the previous scene

onready var continueButton = $CenterContainer/VBoxContainer/VButtonContainer/ContinueButton
onready var newGameButton = $CenterContainer/VBoxContainer/VButtonContainer/NewGameButton


func refresh():
	var save_game = File.new()
	if save_game.file_exists(SAVE_PATH):
		continueButton.grab_focus()
	else:
		continueButton.disabled = true
		newGameButton.grab_focus()


func _ready():
	refresh()


#func _input(event):
#	if event.is_action_pressed("ui_back") or event.is_action_pressed("ui_cancel"):
#		if current_scene == self:
#			get_tree().quit()
#		current_scene.queue_free()


func _on_QuitButton_pressed():
	get_tree().quit()


func _on_OptionsButton_pressed():
#	get_tree().change_scene("res://Options/Options.tscn")
	options = load("res://Options/Options.tscn").instance()
	add_child(options)
	options.connect("back_button_pressed", self, "_close_options")


func _on_NewGameButton_pressed():
	SaveGame.state = SaveGame.NEW
	get_tree().change_scene("res://World.tscn")


func _on_ContinueButton_pressed():
	# Continue
	SaveGame.state = SaveGame.CONTINUE
	get_tree().change_scene("res://World.tscn")


func _close_options():
	options.queue_free()
	options = null
	refresh()
