extends Control
class_name Menu

var menu_container


func add_menu(name, path):
	var menu = get_node_or_null(name)
	if menu == null:
		menu = load(path).instance()
		menu.name = name
		menu.connect("hide", menu_container, "show")
		add_child(menu)
	else:
		menu.show()
	menu_container.hide()
