extends RemoteTransform2D


func save():
	var save_dict = {
		"filename": get_filename(),
		"parent": get_parent().get_path(),
		"children": [],
		"pos_x" : position.x, # Vector2 is not supported by JSON
		"pos_y" : position.y,
		"remote_path": remote_path
	}
	return save_dict
