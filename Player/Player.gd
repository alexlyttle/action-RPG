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
	
#	# Animation (alternative): player looks towards mouse position
#	var mouse_vector = get_local_mouse_position()
#	animationTree.set("parameters/Idle/blend_position", mouse_vector)
	
	if input_vector != Vector2.ZERO:
		# Normalise the input vector
		input_vector = input_vector.normalized()
		
		# Animation: player faces direction of travel
		# Update blend position only when moving to set animation direction
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationState.travel("Run")

#		# Animation (alternative): player looks towards mouse position
#		animationTree.set("parameters/Run/blend_position", mouse_vector)
#		# Update animation state
#		animationState.travel("Run")
		
		# Move at a constant speed
#		velocity = input_vector / sqrt(pow(input_vector.x, 2) + pow(input_vector.y, 2))
#		velocity = SPEED * input_vector.normalized()

		# Move towards maximum speed with acceleration
		velocity = velocity.move_toward(SPEED * input_vector, ACCEL * delta)
	else:
		animationState.travel("Idle")  # Reset state to idle
		
		# Decelerate to zero given some friction
		velocity = velocity.move_toward(Vector2.ZERO, FRICT * delta)
	
	velocity = move_and_slide(velocity)
