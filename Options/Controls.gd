# TODO:
# ACTIONS MUST BE SPLIT INTO KEY, BUTTON and JOYPAD DEPENDING ON MODE
extends Control

const INPUT_MODES = ["keyboard_mouse", "keyboard_only", "controller"]
const INPUT_ACTIONS = ["attack", "roll"]
const INPUT_MOVEMENT = ["move_up", "move_down", "move_left", "move_right"]
const CANCEL_ACTION = "ui_cancel"
	
const CONFIG_FILE = "user://controls.cfg"
const DEFAULTS_FILE = "res://Options/controls_defaults.cfg"
const INPUT_DESC = {
	"keyboard_mouse": "Use the mouse to control the direction of actions and the keyboard for movement.",
	"keyboard_only": "Use the keyboard to control the direction of actions and movement.",
	"controller": "Use the controller to control the direction of actions and movement."
}

enum {
	KEYBOARD_MOUSE,
	KEYBOARD_ONLY,
	CONTROLLER
}

var action # To register the action the UI is currently handling
var button # Button node corresponding to the above action

onready var checkBoxContainer = $CenterContainer/VBoxContainer/HCheckBoxContainer
onready var description = $CenterContainer/VBoxContainer/Description
onready var movementBindings = $CenterContainer/VBoxContainer/bindings/Movement
onready var actionsBindings = $CenterContainer/VBoxContainer/bindings/Actions


func set_defaults(config):
	var defaults = ConfigFile.new()
	var err = defaults.load(DEFAULTS_FILE)
	if err:
		print("Error loading defaults controls config file: ", err)
	else:
		config.set_value("mode", "name", defaults.get_value("mode", "name"))
		for mode in INPUT_MODES:
			for action_name in INPUT_MOVEMENT + INPUT_ACTIONS:
				config.set_value(mode, action_name, defaults.get_value(mode, action_name))

		return config


func update_bindings(mode):
	var config = ConfigFile.new()
	var err = config.load(CONFIG_FILE)
	if err:
		print("Error code when loading config file: ", err)
	else:
		for action_name in config.get_section_keys(mode):
			# Get the key scancode corresponding to the saved human-readable string
			var scancode = OS.find_scancode_from_string(config.get_value(mode, action_name))
			# Create a new event object based on the saved scancode
			var event = InputEventKey.new()
			event.scancode = scancode
			# Replace old action (key) events by the new one
			for old_event in InputMap.get_action_list(action_name):
				InputMap.action_erase_event(action_name, old_event)
			InputMap.action_add_event(action_name, event)


func load_config():
	var config = ConfigFile.new()
	var err = config.load(CONFIG_FILE)
	if err: # Assuming that file is missing, generate default config
		config = set_defaults(config)
		config.save(CONFIG_FILE)
#	else: # ConfigFile was properly loaded, initialize InputMap
#	for mode in INPUT_MODES:
#	var mode = config.get_value("mode", "name")
#	checkBoxContainer.current_option = mode  # Set current input mode option in check boxes
	var mode = config.get_value("mode", "name")
	checkBoxContainer.options[mode].pressed = true  # Set current input mode option in check boxes

#	for action_name in config.get_section_keys(mode):
#		# Get the key scancode corresponding to the saved human-readable string
#		var scancode = OS.find_scancode_from_string(config.get_value(mode, action_name))
#		# Create a new event object based on the saved scancode
#		var event = InputEventKey.new()
#		event.scancode = scancode
#		# Replace old action (key) events by the new one
#		for old_event in InputMap.get_action_list(action_name):
#			if old_event is InputEventKey:
#				InputMap.action_erase_event(action_name, old_event)
#		InputMap.action_add_event(action_name, event)


func save_to_config(section, key, value):
	"""Helper function to redefine a parameter in the settings file"""
	var config = ConfigFile.new()
	var err = config.load(CONFIG_FILE)
	if err:
		print("Error code when loading config file: ", err)
	else:
		config.set_value(section, key, value)
		config.save(CONFIG_FILE)

# Input management

func wait_for_input(action_bind, binding_node):
	action = action_bind
	# See note at the beginning of the script
	button = binding_node.get_node(action).get_node("Button")
	get_node("CenterContainer/VBoxContainer/contextual_help").text = "Press a key to assign to the '" + action + "' action."
	set_process_input(true)


func display_help():
	var cancel_event = InputMap.get_action_list(CANCEL_ACTION)[0]  # Assume first in list
	var cancel_scancode = OS.get_scancode_string(cancel_event.scancode)
	get_node("CenterContainer/VBoxContainer/contextual_help").text = "Click a key binding to reassign it, or press " + cancel_scancode + " to cancel."


func _input(event):
	# Handle the first pressed key
	if event is InputEventKey:
		# Register the event as handled and stop polling
		get_tree().set_input_as_handled()
		set_process_input(false)
		# Reinitialise the contextual help label
		display_help()
		if not event.is_action(CANCEL_ACTION):
			# Display the string corresponding to the pressed key
			var scancode = OS.get_scancode_string(event.scancode)
			button.text = scancode
			# Start by removing previously key binding(s)
			for old_event in InputMap.get_action_list(action):
				InputMap.action_erase_event(action, old_event)
			# Add the new key binding
			InputMap.action_add_event(action, event)
			save_to_config(checkBoxContainer.current_option, action, scancode)
	elif event in InputEventMouseButton:
		pass


func init_button(action_name, binding_node):
	# We assume that the key binding that we want is the first one (0), if there are several
	var input_event = InputMap.get_action_list(action_name)[0]
	# See note at the beginning of the script
	var button = binding_node.get_node(action_name).get_node("Button")
	button.text = OS.get_scancode_string(input_event.scancode)
	button.connect("pressed", self, "wait_for_input", [action_name, binding_node])


func update_buttons():
	for action_name in INPUT_MOVEMENT:
		init_button(action_name, movementBindings)
	for action_name in INPUT_ACTIONS:
		init_button(action_name, actionsBindings)


func _ready():
	# Load config if existing, if not it will be generated with default values
	load_config()
	
	# Initialise each button with the default key binding from InputMap
	update_buttons()
	
	display_help()
	# Do not start processing input until a button is pressed
	set_process_input(false)


func _on_HCheckBoxContainer_option_changed(option):
	description.text = INPUT_DESC[option]
	update_bindings(option)
	update_buttons()
