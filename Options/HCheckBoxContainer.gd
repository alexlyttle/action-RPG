extends HBoxContainer

var current_option = null setget set_current_option  # Keep track of current option

onready var options = {
		"keyboard_mouse": $KeyboardMouseCheckBox,
		"keyboard_only": $KeyboardCheckBox,
		"gamepad": $GamepadCheckBox
	}

signal option_changed(option)


func set_current_option(value):
	if value != null and value != current_option:
		emit_signal("option_changed", value)  # Emit option checked
	current_option = value


func uncheck_noncurrent_boxes(toggle_box):
	for box in options.values():
		if box.pressed and box != toggle_box:
			box.pressed = false


func toggle(toggle_option):
	var toggle_box = options[toggle_option]
	if toggle_box.pressed:
		self.current_option = toggle_option
		uncheck_noncurrent_boxes(toggle_box)
	else:
		toggle_box.pressed = true  # Ensure box remains pressed


func _on_KeyboardMouseCheckBox_pressed():
	toggle("keyboard_mouse")


func _on_KeyboardCheckBox_pressed():
	toggle("keyboard_only")


func _on_GamepadCheckBox_pressed():
	toggle("gamepad")
