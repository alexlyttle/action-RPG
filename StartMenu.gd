extends Control

const SAVE_PATH = "user://world.dat"  # Make this a directory for many worlds

var options = null  # track the previous scene

onready var menuContainer = $MenuContainer
onready var continueButton = $MenuContainer/VBoxContainer/VButtonContainer/ContinueButton
onready var newGameButton = $MenuContainer/VBoxContainer/VButtonContainer/NewGameButton
onready var menuMoveStreamPlayer = $MenuMoveStreamPlayer
onready var menuSelectStreamPlayer = $MenuSelectStreamPlayer


func refresh():
	menuContainer.show()
#	menuContainer.grab_focus()
	var save_game = File.new()
	if not save_game.file_exists(SAVE_PATH):
		continueButton.disabled = true


func init_button_audio(parent):
	for node in parent.get_children():
		if node is Button:
			node.connect("focus_entered", self, "_play_menu_move")
			node.connect("mouse_entered", self, "_play_menu_move")
			node.connect("pressed", self, "_play_menu_select")
		else:
			init_button_audio(node)


func _ready():
	refresh()
	AudioManager.init_button_audio(menuContainer)

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
	menuContainer.hide()


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


#func _play_menu_move():
#	menuMoveStreamPlayer.play()
#
#
#func _play_menu_select():
#	menuSelectStreamPlayer.play()
