extends Control

var options = null

onready var menuContainer = $MenuContainer
onready var continueButton = $MenuContainer/VBoxContainer/ContinueButton
onready var animationPlayer = $AnimationPlayer


func refresh():
	menuContainer.show()
#	continueButton.grab_focus()
#	pass


func open():
	animationPlayer.play("FadeIn")
#	AudioManager.init_button_audio(menuContainer)
#	refresh()


func _ready():
#	refresh()  # Don't refresh as this will show the center container
	AudioManager.init_button_audio(menuContainer)


func _on_ContinueButton_pressed():
	animationPlayer.play("FadeOut")
#	hide()
	get_tree().paused = false
	


func _on_QuitButton_pressed():
	get_tree().change_scene("res://StartMenu.tscn")
	get_tree().paused = false


func _on_OptionsButton_pressed():
	options = load("res://Options/Options.tscn").instance()
	add_child(options)
	options.connect("back_button_pressed", self, "_close_options")
	menuContainer.hide()


func _close_options():
	options.queue_free()
	options = null
	refresh()


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "FadeIn":
		refresh()


func _on_SaveButton_pressed():
	SaveGame.save_game(SaveGame.SAVE_PATH)
