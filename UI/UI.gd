extends CanvasLayer

var options = null

onready var worldMenu = $WorldMenu


func _input(event):
	if event.is_action_released("ui_start") or event.is_action_released("ui_cancel"):
		get_tree().paused = true
#		worldMenu.show()
#		worldMenu.open()
		worldMenu.animationPlayer.play("FadeIn")

#
#func _on_ContinueButton_pressed():
#	worldMenu.hide()
#	get_tree().paused = false
#
#
#func _on_QuitButton_pressed():
#	get_tree().change_scene("res://StartMenu.tscn")
#	get_tree().paused = false
#
#
#func _on_OptionsButton_pressed():
#	options = load("res://Options/Options.tscn").instance()
#	add_child(options)
#	options.connect("back_button_pressed", self, "_close_options")
#
#
#
#func _close_options():
#	options.queue_free()
#	options = null
#	worldMenu.refresh()
