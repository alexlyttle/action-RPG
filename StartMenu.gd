extends Control

#var config = load("res://Options/Config.gd").new()


func _ready():
	get_node("CenterContainer/VBoxContainer/VButtonContainer/StartButton").grab_focus()
#	var config_file = InputConfig.load_config()
#	var mode = config_file.get_value("mode", "name")
#	var connected_joypads = Input.get_connected_joypads()
#
#	if mode == "gamepad" and connected_joypads.size() == 0:
#		mode = "keyboard_mouse"
#		config_file.set_value("mode", "name", mode)
#		config_file.save(InputConfig.CONFIG_FILE)
#
#	InputConfig.update_bindings(mode, config_file)


func _input(event):
	if event.is_action_pressed("ui_start"):
		_on_StartButton_pressed()
	if event.is_action_pressed("ui_back") or event.is_action_pressed("ui_cancel"):
		_on_QuitButton_pressed()


func _on_StartButton_pressed():
	get_tree().change_scene("res://World.tscn")


func _on_QuitButton_pressed():
	get_tree().quit()


func _on_OptionsButton_pressed():
	get_tree().change_scene("res://Options/Options.tscn")
