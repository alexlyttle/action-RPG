extends Menu


func _on_CheckButton_toggled(button_pressed):
	OS.window_fullscreen = button_pressed


func _on_BackButton_pressed():
#	queue_free()
	hide()
