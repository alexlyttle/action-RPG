#extends Control
extends Menu

const SAVE_PATH = "user://world.dat"  # Make this a directory for many worlds

onready var continueButton = $MenuContainer/VBoxContainer/VButtonContainer/ContinueButton
onready var newGameButton = $MenuContainer/VBoxContainer/VButtonContainer/NewGameButton


func _ready():
	menu_container = $MenuContainer
	var save_game = File.new()
	if not save_game.file_exists(SAVE_PATH):
		continueButton.disabled = true


func _on_QuitButton_pressed():
	yield(get_tree().create_timer(0.1), "timeout")
	get_tree().quit()


func _on_OptionsButton_pressed():
	add_menu("Options", "res://Options/Options.tscn")


func _on_NewGameButton_pressed():
	SaveGame.state = SaveGame.NEW
	var _err = get_tree().change_scene("res://World.tscn")


func _on_ContinueButton_pressed():
	# Continue
	SaveGame.state = SaveGame.CONTINUE
	var _err = get_tree().change_scene("res://World.tscn")
