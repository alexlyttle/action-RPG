extends KinematicBody2D

export(int) var SPEED = 75
export(int) var ACCEL = 500
export(int) var FRICT = 500
export(float) var ROLLM = 1.2  # Roll speed multiplier

enum {
	MOVE,   # 0
	ROLL,   # 1
	ATTACK  # 2
}

var state = MOVE
var velocity = Vector2.ZERO
var roll_vector = Vector2.DOWN  # Matches defaults in AnimationTree

onready var animationPlayer = $AnimationPlayer  # Variable created when Player node is ready
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var swordHitbox = $HitboxPivot/SwordHitbox


func move():
	velocity = move_and_slide(velocity)


func move_state(delta):
	# PLAYER MOVEMENT
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")

#	# ANIMATION (alternative): player looks towards mouse position
#	var mouse_vector = get_local_mouse_position()
#	animationTree.set("parameters/Idle/blend_position", mouse_vector)

	if input_vector != Vector2.ZERO:
		input_vector = input_vector.normalized()
		roll_vector = input_vector
		swordHitbox.knockback_vector = input_vector

		# ANIMATION: player faces direction of travel
		# Update blend position only when moving to set animation direction
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position", input_vector)

#		# ANIMATION (alternative): player looks towards mouse position
#		animationTree.set("parameters/Run/blend_position", mouse_vector)
#		animationTree.set("parameters/Attack/blend_position", mouse_vector)
#		animationTree.set("parameters/Roll/blend_position", mouse_vector)

		animationState.travel("Run")  # Update animation state

		# Move towards maximum speed with acceleration
		velocity = velocity.move_toward(SPEED * input_vector, ACCEL * delta)
	else:
		animationState.travel("Idle")  # Reset state to idle

		# Decelerate to zero given some friction
		velocity = velocity.move_toward(Vector2.ZERO, FRICT * delta)

	move()

	if Input.is_action_just_pressed("roll"):
		state = ROLL

	if Input.is_action_just_pressed("attack"):
		state = ATTACK


func attack_state(delta):
	# PLAYER ATTACK
	animationState.travel("Attack")


func attack_animation_finished():
	velocity = Vector2.ZERO
	state = MOVE


func roll_state(delta):
	# PLAYER ROLL
	velocity = roll_vector * SPEED * ROLLM
	animationState.travel("Roll")
	move()


func roll_animation_finished():
	state = MOVE


func _physics_process(delta):
	# Note: Use the _physics_process to access physics of the KinematicBody2D - e.g. move_and_slide
	match state:
		MOVE:
			move_state(delta)

		ROLL:
			roll_state(delta)

		ATTACK:
			attack_state(delta)


func _ready():
	# Called when the node enters the scene tree for the first time.	
	animationTree.active = true
	swordHitbox.knockback_vector = roll_vector  # Starts facing left like roll_vector
