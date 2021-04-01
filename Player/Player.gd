extends KinematicBody2D

const SPEED = 75
const ACCEL = 500
const FRICT = 500

var velocity = Vector2.ZERO

onready var animationPlayer = $AnimationPlayer  # Variable created when Player node is ready

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	

func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	if input_vector != Vector2.ZERO:
		# Animation
		animationPlayer.play("RunRight")
		
		# Move at a constant speed
#		velocity = input_vector / sqrt(pow(input_vector.x, 2) + pow(input_vector.y, 2))
#		velocity = SPEED * input_vector.normalized()

		# Move with acceleration
		velocity = velocity.move_toward(SPEED * input_vector.normalized(), ACCEL * delta)
	else:
		# Animation
		animationPlayer.play("IdleRight")
		
		velocity = velocity.move_toward(Vector2.ZERO, FRICT * delta)  # Decelerate to zero
	
	velocity = move_and_slide(velocity)
