extends Node

const SAVE_PATH = "user://world.dat"
const SPECIAL_KEYS = {
	NAME = "name",
	FILENAME = "filename", 
	PARENT = "parent",
	POS_X = "pos_x",
	POS_Y = "pos_y",
	CHILDREN = "children"
}  # All other keys are node variables to be set
const PASS = "test"

enum {
	CONTINUE,
	NEW
}

var state = NEW setget set_state  # Keep track of whether starting a new game or continuing

signal changed_state


func set_state(value):
	state = value
	emit_signal("changed_state", value)


func save_children(node):
	# Call save for all children of node in the SaveNode group
	var children = node.get_children()
	var save_array = []
	for child in children:
		if child.is_in_group("SaveNode"):
			save_array.append(child.save())
	return save_array


func _add_child_nodes(parent, node_data):
	# Add child nodes to the parent. Recursive if the child also has child nodes
	# to load.
	var node_name = node_data[SPECIAL_KEYS.NAME]
	var new_node = parent.get_node_or_null(node_name)

	if new_node == null:
		# If node does not exist, create a new one with the same name
		new_node = load(node_data[SPECIAL_KEYS.FILENAME]).instance()
		new_node.name = node_name
		parent.add_child(new_node)

	if SPECIAL_KEYS.POS_X in node_data.keys() and SPECIAL_KEYS.POS_X in node_data.keys():
		# If position keys available, modify the node's position
		new_node.position = Vector2(node_data[SPECIAL_KEYS.POS_X], node_data[SPECIAL_KEYS.POS_Y])
	
	for key in node_data.keys():
		# Loop through keys and set values to node
		if not key in SPECIAL_KEYS.values():
			new_node.set(key, node_data[key])
	
	for child_node_data in node_data[SPECIAL_KEYS.CHILDREN]:
		# Do the same as above for children of new_node
		_add_child_nodes(new_node, child_node_data)


func _add_nodes(node_data):
	var parent = get_node(node_data[SPECIAL_KEYS.PARENT])
	_add_child_nodes(parent, node_data)


func load_game(path):
	var save_game = File.new()
	if not save_game.file_exists(path):
		return
	
#	var save_nodes = get_tree().get_nodes_in_group("SaveParents")
#	for node in save_nodes:
#		node.queue_free()  # Make sure we free nodes to load
#	yield(get_tree(), "idle_frame")  # Wait until idle frame to continue
	# This solves the issue of not freeing all save nodes
	
	var err = save_game.open(path, File.READ)
	if err != OK:
		return
	
	while save_game.get_position() < save_game.get_len():
		# Loop through each line of the save to get node data
		var node_data = parse_json(save_game.get_line())
#		var keys = node_data.keys()
		_add_nodes(node_data)

	save_game.close()


func save_game(path):
	var save_game = File.new()
	save_game.open(path, File.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("SaveBranch")
	
	for node in save_nodes:
		# Check the node is an instanced scene so it can be instanced again during load.
		if node.filename.empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue
		
		# Check the node has a save function.
		if not node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue
		
		var save_dict = node.save()
		save_game.store_line(to_json(save_dict))
	save_game.close()
