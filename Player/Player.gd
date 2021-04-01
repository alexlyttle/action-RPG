extends KinematicBody2D

const SPEED = 75
const ACCEL = 10
const FRICT = 10

var velocity = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	if input_vector != Vector2.ZERO:
#		velocity = input_vector / sqrt(pow(input_vector.x, 2) + pow(input_vector.y, 2))
#		velocity = SPEED * input_vector.normalized()  # Move at a constant speed
		velocity += ACCEL * delta * input_vector.normalized()  # Accelerate
		velocity = velocity.clamped(SPEED * delta)  # To some terminal velocity
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICT * delta)  # Decelerate to zero
	
	move_and_collide(velocity)
