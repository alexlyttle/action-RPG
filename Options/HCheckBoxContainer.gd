extends HBoxContainer

onready var checkboxes = {
		"keyboard_mouse": $KeyboardMouseCheckBox,
		"keyboard_only": $KeyboardCheckBox,
		"gamepad": $GamepadCheckBox
	}


func uncheck_noncurrent_boxes(current_checkbox):
	for box in checkboxes.values():
		if box.pressed and box != current_checkbox:
			box.pressed = false


func toggle(new_mode):
	var current_checkbox = checkboxes[new_mode]
	if current_checkbox.pressed:
		InputConfig.active_mode = new_mode  # This handles updating bindings
		uncheck_noncurrent_boxes(current_checkbox)
	else:
		current_checkbox.pressed = true  # Ensure box remains pressed


func _ready():
	checkboxes[InputConfig.active_mode].pressed = true
	InputConfig.connect("on_joy_availibility_changed", self, "_on_joy_availibility_changed")
	InputConfig._joy_connection_changed(null, false)  # Disconnect null controller to check if any connected


func _on_KeyboardMouseCheckBox_pressed():
	toggle("keyboard_mouse")


func _on_KeyboardCheckBox_pressed():
	toggle("keyboard_only")


func _on_GamepadCheckBox_pressed():
	toggle("gamepad")


func _on_joy_availibility_changed(available):
	if available:
		checkboxes["gamepad"].disabled = false
	else:
		checkboxes["gamepad"].disabled = true
		checkboxes["gamepad"].pressed = false
