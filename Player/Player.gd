extends KinematicBody2D

const PlayerHurtSound = preload("res://Player/PlayerHurtSound.tscn")

export(int) var speed = 75
export(int) var acceleration = 500
export(int) var friction = 500
export(float) var roll_speed_multiplier = 1.2  # Roll speed multiplier

enum {
	MOVE,   # 0
	ROLL,   # 1
	ATTACK  # 2
}

var state = MOVE
var velocity = Vector2.ZERO
var roll_vector = Vector2.DOWN  # Matches defaults in AnimationTree
var stats = PlayerStats  # Accesses the global autoload singleton (alternatively, look into using Resourses or JSON files)
var mode = null
#var config = load("res://Options/Config.gd").new()

onready var animationPlayer = $AnimationPlayer  # Variable created when Player node is ready
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var swordHitbox = $HitboxPivot/SwordHitbox
onready var hurtbox = $Hurtbox
onready var flickerAnimationPlayer = $FlickerAnimationPlayer


func save_children():
	var children = get_children()
	var save_array = []
	for child in children:
		if child.is_in_group("Save"):
			save_array.append(child.save())
	return save_array


func save():
	var save_dict = {
		"filename": get_filename(),
		"parent": get_parent().get_path(),
		"children": save_children(),
		"pos_x" : position.x, # Vector2 is not supported by JSON
		"pos_y" : position.y
	}
	return save_dict


func get_input_vector():
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return input_vector


func move():
	velocity = move_and_slide(velocity)


func update_animation(direction_vector):
	animationTree.set("parameters/Idle/blend_position", direction_vector)
	animationTree.set("parameters/Attack/blend_position", direction_vector)
	animationTree.set("parameters/Roll/blend_position", direction_vector)
	animationTree.set("parameters/Run/blend_position", direction_vector)


func move_state(delta):
	# PLAYER MOVEMENT
#	var input_vector = Vector2.ZERO
#	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
#	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	var input_vector = get_input_vector()
	
	if InputConfig.active_mode == "keyboard_mouse":
		# ANIMATION (alternative): player looks towards mouse position
		var mouse_vector = get_local_mouse_position().normalized()
		update_animation(mouse_vector)

		# Input control (alternative)
		roll_vector = mouse_vector  
		swordHitbox.knockback_vector = mouse_vector

	if input_vector != Vector2.ZERO:
		input_vector = input_vector.normalized()
		
		if InputConfig.active_mode != "keyboard_mouse":
			# Input control
			roll_vector = input_vector
			swordHitbox.knockback_vector = input_vector

			# ANIMATION: player faces direction of travel
			# Update blend position only when moving to set animation direction
			update_animation(input_vector)

		animationState.travel("Run")  # Update animation state

		# Move towards maximum speed with acceleration
		velocity = velocity.move_toward(speed * input_vector, acceleration * delta)
	else:
		animationState.travel("Idle")  # Reset state to idle

		# Decelerate to zero given some friction
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)

	move()

	if Input.is_action_just_pressed("roll"):
		state = ROLL

	if Input.is_action_just_pressed("attack"):
		state = ATTACK


func attack_state():
	# PLAYER ATTACK
	animationState.travel("Attack")


func attack_animation_finished():
	velocity = Vector2.ZERO
	state = MOVE


func roll_state():
	# PLAYER ROLL
	velocity = roll_vector * speed * roll_speed_multiplier
	animationState.travel("Roll")
	move()


func roll_animation_finished():
	state = MOVE


func _ready():
	# Called when the node enters the scene tree for the first time.
	stats.connect("no_health", self, "queue_free")	
	animationTree.active = true
	swordHitbox.knockback_vector = roll_vector  # Starts facing left like roll_vector

#	var config_file = InputConfig.load_config()
#	mode = config_file.get_value("mode", "name")
#	InputConfig.update_bindings(mode, config_file)
#	var config = Config.load_config()

func _physics_process(delta):
	# Note: Use the _physics_process to access physics of the KinematicBody2D - e.g. move_and_slide
	match state:
		MOVE:
			move_state(delta)

		ROLL:
			roll_state()

		ATTACK:
			attack_state()


func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	hurtbox.start_invincibility(0.6)
	hurtbox.create_hit_effect()
	var playerHurtSound = PlayerHurtSound.instance()
	get_tree().current_scene.add_child(playerHurtSound)  # Add to scene not player
	# We add sound to scene so it persists when player dies


func _on_Hurtbox_invincibility_started():
	flickerAnimationPlayer.play("Start")


func _on_Hurtbox_invincibility_ended():
	flickerAnimationPlayer.play("Stop")
