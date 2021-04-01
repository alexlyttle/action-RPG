extends KinematicBody2D

var speed = 1.5
var velocity = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	if input_vector != Vector2.ZERO:
		velocity = speed * input_vector / sqrt(pow(input_vector.x, 2) + pow(input_vector.y, 2))
	else:
		velocity = Vector2.ZERO
	
	move_and_collide(velocity)
