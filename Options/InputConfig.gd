extends Object
#class_name InputConfig

const CONFIG_FILE = "user://input.cfg"
const DEFAULTS_FILE = "res://Options/input.cfg"
const DELIMITER = ","

var active_mode = null setget set_mode

signal on_input_mode_changed
signal on_joy_availibility_changed


func set_mode(value):
	if value != active_mode:
		# Only do this if value changes
		active_mode = value
		var config = load_config()
		config.set_value("mode", "name", active_mode)
		config.save(CONFIG_FILE)
		update_bindings(active_mode, config)
		emit_signal("on_input_mode_changed", active_mode)


func update_inputmap(action, event):
	for old_event in InputMap.get_action_list(action):
		InputMap.action_erase_event(action, old_event)
	InputMap.action_add_event(action, event)


func update_bindings(mode, config):
	for action in config.get_section_keys(mode):
		# Get the key scancode corresponding to the saved human-readable string
		var string = config.get_value(mode, action)
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
		update_inputmap(action, event)


func set_mode_defaults(mode, config, defaults):
	for key in defaults.get_section_keys(mode):
		config.set_value(mode, key, defaults.get_value(mode, key))
	return config


func reset():
	# Resets bindings for the current mode
	var config = load_config()
	var defaults = load_defaults()

	config = InputConfig.set_mode_defaults(active_mode, config, defaults)
	config.save(CONFIG_FILE)
	update_bindings(active_mode, config)


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


func save(key, value):
	var config = load_config()
	config.set_value(active_mode, key, value)
	config.save(CONFIG_FILE)


func _ready():
	var config = InputConfig.load_config()
	self.active_mode = config.get_value("mode", "name")
	var connected_joypads = Input.get_connected_joypads()

	if active_mode == "gamepad" and connected_joypads.size() == 0:
		self.active_mode = "keyboard_mouse"
		config.set_value("mode", "name", active_mode)
		config.save(CONFIG_FILE)
	
	update_bindings(active_mode, config)

	var _err = Input.connect("joy_connection_changed", self, "_joy_connection_changed")


func _joy_connection_changed(_id, _connected):
	var connected_joypads = Input.get_connected_joypads()
	if connected_joypads.size() == 0:
		if active_mode == "gamepad":
			self.active_mode = "keyboard_mouse"
		emit_signal("on_joy_availibility_changed", false)
	else:
		emit_signal("on_joy_availibility_changed", true)
