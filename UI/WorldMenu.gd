extends Control


func refresh():
	get_node("VBoxContainer/ContinueButton").grab_focus()
	
func _ready():
	refresh()
