extends Control

const INPUT_MODES = ["keyboard_mouse", "keyboard_only", "gamepad"]
const INPUT_GAMEPLAY = ["attack", "roll", "camera_zoom_in", "camera_zoom_out", "move_up", "move_down", "move_left", "move_right"]
const INPUT_UI = ["ui_left", "ui_right", "ui_up", "ui_down", "ui_accept", "ui_cancel", "ui_start"]

const CANCEL_ACTION = "ui_cancel"

const INPUT_DESC = {
	"keyboard_mouse": "Use the mouse to control the direction of actions and the keyboard for movement.",
	"keyboard_only": "Use the keyboard to control the direction of actions and movement.",
	"gamepad": "Use the gamepad to control the direction of actions and movement."
}

var config = load("res://Options/Config.gd").new()

var action  # To register the action the UI is currently handling
var button  # Button node corresponding to the above action

onready var checkBoxContainer = $CenterContainer/VBoxContainer/HCheckBoxContainer
onready var description = $CenterContainer/VBoxContainer/Description
onready var gameplayBindings = $CenterContainer/VBoxContainer/bindings/HBoxContainer/Gameplay
onready var uiBindings = $CenterContainer/VBoxContainer/bindings/HBoxContainer/UserInterface
onready var popupPanel = $PopupPanel


func save_to_config(section, key, value):
	"""Helper function to redefine a parameter in the settings file"""
	var config_file = config.load_config()
	config_file.set_value(section, key, value)
	config_file.save(config.CONFIG_FILE)

# Input management

func wait_for_input(action_bind, binding_node):
	action = action_bind
	# See note at the beginning of the script
	button = binding_node.get_node(action).get_node("Button")
	get_node("CenterContainer/VBoxContainer/contextual_help").text = "Press a key to assign to the '" + action + "' action."
	set_process_input(true)


func display_help():
#	var cancel_event = InputMap.get_action_list(CANCEL_ACTION)[0]  # Assume first in list
#	var cancel_scancode = OS.get_scancode_string(cancel_event.scancode)
	get_node("CenterContainer/VBoxContainer/contextual_help").text = "Click a key binding to reassign it, or press Cancel to go back."


func process_input():
	get_tree().set_input_as_handled()
	set_process_input(false)
	display_help()


func update_inputmap(event):
	# Start by removing previously key binding(s)
	for old_event in InputMap.get_action_list(action):
		InputMap.action_erase_event(action, old_event)
	# Add the new key binding
	InputMap.action_add_event(action, event)


func axis_sign(axis_value):
	return "+" if axis_value > 1 else "-"


func _input(event):
	# Handle the first pressed key
	if not event is InputEventMouseMotion:
		process_input()
		if not event.is_action(CANCEL_ACTION):
			if event is InputEventKey:
				# Display the string corresponding to the pressed key
				var scancode = OS.get_scancode_string(event.scancode)
				button.text = scancode
				update_inputmap(event)
				save_to_config(checkBoxContainer.current_option, action, "KEY," + scancode)
			elif event is InputEventMouseButton:
				var button_index = str(event.button_index)
				button.text = "Mouse " + str(button_index)
				update_inputmap(event)
				save_to_config(checkBoxContainer.current_option, action, "MOUSE_BUTTON," + button_index)
			elif event is InputEventJoypadButton:
				var button_index = str(event.button_index)
				button.text = "Button " + button_index
				update_inputmap(event)
				save_to_config(checkBoxContainer.current_option, action, "JOY_BUTTON," + button_index)
			elif event is InputEventJoypadMotion:
				var axis = str(event.axis)
				var axis_value = sign(event.axis_value)
				button.text = "Axis " + axis + axis_sign(axis_value)
				event.axis_value = sign(axis_value)
				update_inputmap(event)
				save_to_config(checkBoxContainer.current_option, action, "JOY_AXIS," + axis + "," + str(axis_value))
			else:
				popupPanel.get_node("Label").text = "Input not recognised."
				popupPanel.popup_centered(Vector2.ZERO)


func init_button(action_name, binding_node, first_time):
	# We assume that the key binding that we want is the first one (0), if there are several
	var input_event = InputMap.get_action_list(action_name)[0]
	# See note at the beginning of the script
	var button = binding_node.get_node(action_name).get_node("Button")
	if input_event is InputEventKey:
		button.text = OS.get_scancode_string(input_event.scancode)
	elif input_event is InputEventMouseButton:
		button.text = "Mouse " + str(input_event.button_index)
	elif input_event is InputEventJoypadButton:
		button.text = "Button " + str(input_event.button_index)
	elif input_event is InputEventJoypadMotion:
		button.text = "Axis " + str(input_event.axis) + axis_sign(input_event.axis_value)
	if first_time:
		button.connect("pressed", self, "wait_for_input", [action_name, binding_node])


func update_buttons(first_time):
	for action_name in INPUT_GAMEPLAY:
		init_button(action_name, gameplayBindings, first_time)
	for action_name in INPUT_UI:
		init_button(action_name, uiBindings, first_time)


func _ready():
	# Load config if existing, if not it will be generated with default values
	checkBoxContainer.get_node("KeyboardMouseCheckBox").grab_focus()
	
	var config_file = config.load_config()
	var mode = config_file.get_value("mode", "name")
	checkBoxContainer.current_option = mode
	checkBoxContainer.options[mode].pressed = true  # Set current input mode option in check boxes
	
	# Initialise each button with the default key binding from InputMap
	update_buttons(true)
	
	display_help()
	# Do not start processing input until a button is pressed
	set_process_input(false)
	
	Input.connect("joy_connection_changed", self, "_on_joy_connection_changed")
	_on_joy_connection_changed(null, false)


func _on_joy_connection_changed(id, connected):
	var connected_joypads = Input.get_connected_joypads()
	if not connected and connected_joypads.size() == 0:
		checkBoxContainer.options["gamepad"].disabled = true
		if checkBoxContainer.options["gamepad"].pressed:
			checkBoxContainer.options["keyboard_mouse"].pressed = true
	else:
		checkBoxContainer.options["gamepad"].disabled = false


func _on_HCheckBoxContainer_option_changed(mode):
	description.text = INPUT_DESC[mode]

	var config_file = config.load_config()
	config_file.set_value("mode", "name", mode)
	config_file.save(config.CONFIG_FILE)

	config.update_bindings(mode, config_file)
	update_buttons(false)


func _on_BackButton_pressed():
	get_tree().change_scene("res://Options/Options.tscn")


func _on_ResetButton_pressed():
	var config_file = config.load_config()
	var defaults_file = config.load_defaults()
	var mode = checkBoxContainer.current_option

	config_file = config.set_mode_defaults(mode, config_file, defaults_file)
	config_file.save(config.CONFIG_FILE)
	
	config.update_bindings(mode, config_file)
	update_buttons(false)
