extends CenterContainer

const FOCUS = [
	"ui_focus_prev", "ui_focus_next", "ui_left", "ui_right", "ui_up", "ui_down"
]

var first_event_handled = false

onready var moveStreamPlayer = $MoveStreamPlayer

signal menu_audio_finished


func init_button_audio(parent):
	for node in parent.get_children():
		if node is Button:
#			print(node.name)
			node.connect("focus_entered", self, "_play_menu_move", [node])
			node.connect("mouse_entered", self, "_play_menu_move", [node])
			node.connect("pressed", self, "_play_menu_select", [node])
		else:
			init_button_audio(node)


func _play_menu_move(node):
#	print("move")
	print(node.pressed)
	if not node.disabled:
		moveStreamPlayer.play()


func _play_menu_select(node):
#	print("select")
	if not node.disabled:
		SelectStreamPlayer.play()


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
#	moveStreamPlayer.connect("finished", self, "_on_audio_finished")
#	selectStreamPlayer.connect("finished", self, "_on_audio_finished")

func _on_visibility_changed():
	if visible:
		first_event_handled = false

#
#func _on_audio_finished():
#	emit_signal("menu_audio_finished")
