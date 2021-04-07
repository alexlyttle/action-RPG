extends Node

const SPECIAL_KEYS = {
	FILENAME = "filename", 
	PARENT = "parent",
	POS_X = "pos_x",
	POS_Y = "pos_y",
	CHILDREN = "children"
}
const PASS = "test"

enum {
	CONTINUE,
	NEW
}

var state = NEW setget set_state

signal changed_state


func set_state(value):
	state = value
	emit_signal("changed_state", value)


func _add_child_nodes(parent, node_data):
	var new_node = load(node_data[SPECIAL_KEYS.FILENAME]).instance()
	parent.add_child(new_node)
	
	new_node.position = Vector2(node_data[SPECIAL_KEYS.POS_X], node_data[SPECIAL_KEYS.POS_Y])
	
	for key in node_data.keys():
		if not key in SPECIAL_KEYS.values():
			print(key)
			new_node.set(key, node_data[key])
			print(new_node.get(key))
	
	for child_node_data in node_data[SPECIAL_KEYS.CHILDREN]:
		_add_child_nodes(new_node, child_node_data)


func _add_nodes(node_data):
	print(node_data[SPECIAL_KEYS.PARENT])
	var parent = get_node(node_data[SPECIAL_KEYS.PARENT])
	_add_child_nodes(parent, node_data)


func load_game(path):
	var save_game = File.new()
	if not save_game.file_exists(path):
		return
	
	var save_nodes = get_tree().get_nodes_in_group("SaveParents")
	for node in save_nodes:
		node.queue_free()  # Make sure we free nodes to load
	yield(get_tree(), "idle_frame")  # Wait until idle frame to continue
	# This solves the issue of not freeing all save nodes
	
	var err = save_game.open_encrypted_with_pass(path, File.READ, PASS)
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
	save_game.open_encrypted_with_pass(path, File.WRITE, PASS)
	var save_nodes = get_tree().get_nodes_in_group("SaveParents")
	
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
