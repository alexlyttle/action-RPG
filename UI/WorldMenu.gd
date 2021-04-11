#extends Control
extends Menu

#var options = null

#onready var menuContainer = $MenuContainer
onready var continueButton = $MenuContainer/VBoxContainer/ContinueButton
onready var animationPlayer = $AnimationPlayer

#
#func refresh():
#	menu_container.show()
##	continueButton.grab_focus()
##	pass
#
#
#func open():
#	animationPlayer.play("FadeIn")
##	AudioManager.init_button_audio(menuContainer)
##	refresh()


func _ready():
#	refresh()  # Don't refresh as this will show the center container
#	AudioManager.init_button_audio(menuContainer)
	menu_container = $MenuContainer


func _on_ContinueButton_pressed():
	animationPlayer.play("FadeOut")
	get_tree().paused = false
	


func _on_QuitButton_pressed():
	get_tree().change_scene("res://StartMenu.tscn")
	get_tree().paused = false


func _on_OptionsButton_pressed():
#	options = load("res://Options/Options.tscn").instance()
#	add_child(options)
##	options.connect("back_button_pressed", self, "_close_options")
#	options.connect("tree_exited", self, "refresh")
#	menuContainer.hide()
	add_menu("Options", "res://Options/Options.tscn")

#
#func _close_options():
#	options.queue_free()
#	options = null
#	refresh()


func _on_AnimationPlayer_animation_finished(anim_name):
#	if anim_name == "FadeIn":
#		refresh()
	pass


func _on_SaveButton_pressed():
	SaveGame.save_game(SaveGame.SAVE_PATH)
