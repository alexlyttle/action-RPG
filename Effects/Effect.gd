extends AnimatedSprite

# Called when the node enters the scene tree for the first time.
func _ready():
	# Connect animation finished signal to function and then play
	var _err = connect("animation_finished", self, "_on_animation_finished")
	play("Animate")

func _on_animation_finished():
	queue_free()
