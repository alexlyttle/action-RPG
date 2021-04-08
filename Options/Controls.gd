extends Control

const INPUT_MODES = ["keyboard_mouse", "keyboard_only", "gamepad"]
const INPUT_GAMEPLAY = ["attack", "roll", "camera_zoom_in", "camera_zoom_out", "move_up", "move_down", "move_left", "move_right"]
const INPUT_UI = ["ui_left", "ui_right", "ui_up", "ui_down", "ui_accept", "ui_back", "ui_start"]

const CANCEL_ACTION = "ui_cancel"
	
const INPUT_DESC = {
	"keyboard_mouse": "Use the mouse to control the direction of actions and the keyboard for movement.",
	"keyboard_only": "Use the keyboard to control the direction of actions and movement.",
	"gamepad": "Use the gamepad to control the direction of actions and movement."
}

#var config = load("res://Options/Config.gd").new()

var action  # To register the action the UI is currently handling
var button  # Button node corresponding to the above action
var binding
var cancel_event = InputMap.get_action_list(CANCEL_ACTION)[0]  # Assume first in list
var cancel_scancode = OS.get_scancode_string(cancel_event.scancode)

onready var checkBoxContainer = $CenterContainer/VBoxContainer/HCheckBoxContainer
onready var description = $CenterContainer/VBoxContainer/Description
onready var gameplayBindings = $CenterContainer/VBoxContainer/bindings/HBoxContainer/Gameplay
onready var uiBindings = $CenterContainer/VBoxContainer/bindings/HBoxContainer/UserInterface
onready var popupPanel = $PopupPanel

signal back_button_pressed


func wait_for_input(action_bind, binding_node):
	action = action_bind
	# See note at the beginning of the script
	button = binding_node.get_node(action).get_node("Button")
	get_node("CenterContainer/VBoxContainer/contextual_help").text = "Press a key to assign to the '" + action + "' action."
#	set_process_input(true)
	binding = true


func display_help():
	get_node("CenterContainer/VBoxContainer/contextual_help").text = \
		"Click a key binding to reassign it, or press " + cancel_scancode + \
		" to cancel."


func process_input():
	get_tree().set_input_as_handled()
#	set_process_input(false)
	binding = false
	display_help()


func axis_sign(axis_value):
	return "+" if axis_value > 0 else "-"


func _input(event):
	# Handle the first pressed key
	if binding:
		if not event is InputEventMouseMotion:
			process_input()
			if not event.is_action(CANCEL_ACTION):
				if event is InputEventKey:
					# Display the string corresponding to the pressed key
					var scancode = OS.get_scancode_string(event.scancode)
					button.text = scancode
#					update_inputmap(event)
					InputConfig.update_inputmap(action, event)
					InputConfig.save(action, "KEY," + scancode)
				elif event is InputEventMouseButton:
					var button_index = str(event.button_index)
					button.text = "Mouse " + str(button_index)
#					update_inputmap(event)
					InputConfig.update_inputmap(action, event)
					InputConfig.save(action, "MOUSE_BUTTON," + button_index)
				elif event is InputEventJoypadButton:
					var button_index = str(event.button_index)
					button.text = "Button " + button_index
#					update_inputmap(event)
					InputConfig.update_inputmap(action, event)
					InputConfig.save(action, "JOY_BUTTON," + button_index)
				elif event is InputEventJoypadMotion:
					var axis = str(event.axis)
					var axis_value = sign(event.axis_value)
					button.text = "Axis " + axis + axis_sign(axis_value)
					event.axis_value = sign(axis_value)
#					update_inputmap(event)
					InputConfig.update_inputmap(action, event)
					InputConfig.save(action, "JOY_AXIS," + axis + "," + str(axis_value))
				else:
					popupPanel.get_node("Label").text = "Input not recognised."
					popupPanel.popup_centered(Vector2.ZERO)
	else:
		# When not binging, the ui_back action will take us back
#		if event.is_action_pressed("ui_back"):
#			_on_BackButton_pressed()
		pass


func init_button(action_name, binding_node, first_time):
	# We assume that the key binding that we want is the first one (0), if there are several
	var input_event = InputMap.get_action_list(action_name)[0]
	# See note at the beginning of the script
	var current_button = binding_node.get_node(action_name).get_node("Button")
	if input_event is InputEventKey:
		current_button.text = OS.get_scancode_string(input_event.scancode)
	elif input_event is InputEventMouseButton:
		current_button.text = "Mouse " + str(input_event.button_index)
	elif input_event is InputEventJoypadButton:
		current_button.text = "Button " + str(input_event.button_index)
	elif input_event is InputEventJoypadMotion:
		current_button.text = "Axis " + str(input_event.axis) + axis_sign(input_event.axis_value)
	if first_time:
		# Only connect button on first time - must be a better way to manage this?
		current_button.connect("pressed", self, "wait_for_input", [action_name, binding_node])


func update_buttons(first_time):
	for action_name in INPUT_GAMEPLAY:
		init_button(action_name, gameplayBindings, first_time)
	for action_name in INPUT_UI:
		init_button(action_name, uiBindings, first_time)


func _ready():
	# Load config if existing, if not it will be generated with default values
	binding = false  # Not currently binding
	checkBoxContainer.get_node("KeyboardMouseCheckBox").grab_focus()
	update_buttons(true)  # Update buttons for the first time
	display_help()

	InputConfig.connect("on_input_mode_changed", self, "_on_input_mode_changed")


func _on_BackButton_pressed():
#	get_tree().change_scene("res://Options/Options.tscn")
	emit_signal("back_button_pressed")


func _on_ResetButton_pressed():
	InputConfig.reset()
	update_buttons(false)


func _on_input_mode_changed(mode):
	description.text = INPUT_DESC[mode]
	update_buttons(false)
