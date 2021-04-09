extends CenterContainer

const FOCUS = [
	"ui_focus_left", "ui_focus_right", "ui_left", "ui_right", "ui_up", "ui_down"
]

var first_event_handled = false


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
	self.connect("draw", self, "_on_draw")


func _on_draw():
	first_event_handled = false
