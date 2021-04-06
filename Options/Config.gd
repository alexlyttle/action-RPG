extends Object
class_name Config

const CONFIG_FILE = "user://controls.cfg"
const DEFAULTS_FILE = "res://Options/controls_defaults.cfg"
const DELIMITER = ","


func update_bindings(mode, config):
	for action_name in config.get_section_keys(mode):
		# Get the key scancode corresponding to the saved human-readable string
		var string = config.get_value(mode, action_name)
		var string_array = string.split(DELIMITER, true, 0)
		var type = string_array[0]
		var value = string_array[1]
		var event = null

		if type == "KEY":
			var scancode = OS.find_scancode_from_string(value)
			# Create a new event object based on the saved scancode
			event = InputEventKey.new()
			event.scancode = scancode
		elif type == "MOUSE_BUTTON":
			event = InputEventMouseButton.new()
			event.button_index = int(value)
		elif type == "JOY_BUTTON":
			event = InputEventJoypadButton.new()
			event.button_index = int(value)
		elif type == "JOY_AXIS":
			event = InputEventJoypadMotion.new()
			event.axis = int(value)
			event.axis_value = float(string_array[2])
		else:
			return
		# Replace old action (key) events by the new one
		for old_event in InputMap.get_action_list(action_name):
			InputMap.action_erase_event(action_name, old_event)
		InputMap.action_add_event(action_name, event)


func set_mode_defaults(mode, config, defaults):
	for key in defaults.get_section_keys(mode):
		config.set_value(mode, key, defaults.get_value(mode, key))
	return config


func load_file(filename):
	var file = ConfigFile.new()
	var err = file.load(filename)
	if err:
		print("Error loading file " + filename + ": ", err)
	else:
		return file


func load_defaults():
	var defaults = load_file(DEFAULTS_FILE)
	return defaults


func set_defaults(config):
	var defaults = load_defaults()

	for section in defaults.get_sections():
		set_mode_defaults(section, config, defaults)

	return config


func load_config():
	var config = load_file(CONFIG_FILE)
	if config == null: # Assuming that file is missing, generate default config
		config = ConfigFile.new()
		config = set_defaults(config)
		config.save(CONFIG_FILE)

	return config
