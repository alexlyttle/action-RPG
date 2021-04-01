extends KinematicBody2D

const SPEED = 75
const ACCEL = 500
const FRICT = 500

enum {
	MOVE,   # 0
	ROLL,   # 1
	ATTACK  # 2
}

var state = MOVE
var velocity = Vector2.ZERO

onready var animationPlayer = $AnimationPlayer  # Variable created when Player node is ready
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

func animate_movement(vector):
	pass

func move_state(delta):
	# PLAYER MOVEMENT
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

#	# Animation (alternative): player looks towards mouse position
#	var mouse_vector = get_local_mouse_position()
#	animationTree.set("parameters/Idle/blend_position", mouse_vector)

	if input_vector != Vector2.ZERO:
		input_vector = input_vector.normalized()

		# Animation: player faces direction of travel
		# Update blend position only when moving to set animation direction
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)

#		# Animation (alternative): player looks towards mouse position
#		animationTree.set("parameters/Run/blend_position", mouse_vector)
#		animationTree.set("parameters/Attack/blend_position", mouse_vector)

		animationState.travel("Run")  # Update animation state

		# Move towards maximum speed with acceleration
		velocity = velocity.move_toward(SPEED * input_vector, ACCEL * delta)
	else:
		animationState.travel("Idle")  # Reset state to idle

		# Decelerate to zero given some friction
		velocity = velocity.move_toward(Vector2.ZERO, FRICT * delta)

	velocity = move_and_slide(velocity)

	if Input.is_action_just_pressed("attack"):
		state = ATTACK

func attack_state(delta):
	# PLAYER ATTACK
	animationState.travel("Attack")

func attack_animation_finished():
	velocity = Vector2.ZERO
	state = MOVE

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)

		ROLL:
			pass

		ATTACK:
			attack_state(delta)

func _ready():
	# Called when the node enters the scene tree for the first time.	
	animationTree.active = true
