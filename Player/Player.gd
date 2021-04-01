extends KinematicBody2D

const SPEED = 75
const ACCEL = 500
const FRICT = 500

var velocity = Vector2.ZERO

onready var animationPlayer = $AnimationPlayer  # Variable created when Player node is ready
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	

func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		# Animation
		# Update blend position only when moving to set animation direction
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		# Update animation state
		animationState.travel("Run")
		
		# Move at a constant speed
#		velocity = input_vector / sqrt(pow(input_vector.x, 2) + pow(input_vector.y, 2))
#		velocity = SPEED * input_vector.normalized()

		# Move with acceleration
		velocity = velocity.move_toward(SPEED * input_vector, ACCEL * delta)
	else:
		# Animation
		animationState.travel("Idle")  # Reset state to idle
		
		velocity = velocity.move_toward(Vector2.ZERO, FRICT * delta)  # Decelerate to zero
	
	velocity = move_and_slide(velocity)
