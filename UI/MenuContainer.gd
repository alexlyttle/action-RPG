extends CenterContainer

const FOCUS = [
	"ui_focus_prev", "ui_focus_next", "ui_left", "ui_right", "ui_up", "ui_down"
]

var first_event_handled = false

onready var moveStreamPlayer = $MoveStreamPlayer
onready var selectStreamPlayer = $SelectStreamPlayer


func init_button_audio(parent):
	for node in parent.get_children():
		if node is Button:
#			print(node.name)
			node.connect("focus_entered", self, "_play_menu_move")
			node.connect("mouse_entered", self, "_play_menu_move")
			node.connect("pressed", self, "_play_menu_select")
		else:
			init_button_audio(node)


func _play_menu_move():
#	print("move")
	moveStreamPlayer.play()


func _play_menu_select():
#	print("select")
	selectStreamPlayer.play()


func get_first_button(parent):
	var button
	for node in parent.get_children():
		if node is Button:
			return node
		else:
			button = get_first_button(node)
			if button != null:
				return button


func _input(event):
	if first_event_handled:
		return

	var condition = []
	for f in FOCUS:
		condition.append(event.is_action_released(f))
	if true in condition:
		var button = get_first_button(self)
		if button != null:
			button.grab_focus()
			first_event_handled = true


func _ready():
	var _err = connect("visibility_changed", self, "_on_visibility_changed")
	init_button_audio(self)


func _on_visibility_changed():
	if visible:
		first_event_handled = false
