extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

export(int) var speed = 50
export(int) var acceleration = 500
export(int) var friction = 200
export(int) var knockback_rate = 120
export(int) var avoidence_rate = 400

enum {
	IDLE,
	STARTLED,
	WANDER,
	CHASE
}

var knockback = Vector2.ZERO
var velocity = Vector2.ZERO
var state = IDLE
var collision

onready var body = $Sprite
onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var hurtbox = $Hurtbox
onready var softCollision = $SoftCollision
onready var wanderController = $WanderController
#onready var flickerAnimationPlayer = $FlickerAnimationPlayer
onready var animationPlayer = $AnimationPlayer
onready var hitboxPivot = $HitboxPivot
onready var hitbox = $HitboxPivot/Hitbox
onready var hitboxCollisionShape = $HitboxPivot/Hitbox/CollisionShape2D
onready var startledTimer = $StartledTimer


func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE


func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()


func update_state():
	state = pick_random_state([IDLE, WANDER])
	wanderController.start_wander_timer(rand_range(1, 3))


func move_toward_position(target_position, delta):
	var move_vector = global_position.direction_to(target_position).normalized()
	velocity = velocity.move_toward(speed * move_vector, acceleration * delta)
	body.flip_h = velocity.x < 0  # Flip to face velocity
	hitboxPivot.rotation = float(velocity.x < 0) * PI


func startled():
	# TODO: Improve this with signals and setgets
	state = STARTLED
	startledTimer.start(1.0)
	animationPlayer.play("Startled")
	hurtbox.invincible = true
	hitbox.set_deferred("monitorable", false)
	hitboxCollisionShape.set_deferred("disabled", true)


func _ready():
#	update_state()
	startled()


func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, friction * delta)
	knockback = move_and_slide(knockback)

	match state:
		IDLE:
			if velocity == Vector2.ZERO:
				# Only play idle animation when velocity reaches zero
				animationPlayer.play("Idle")
			velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
			seek_player()
			if wanderController.get_time_left() == 0:
				update_state()
		
		STARTLED:
			velocity.move_toward(Vector2.ZERO, friction * delta)

		WANDER:
			animationPlayer.play("Move")
			seek_player()
			if wanderController.get_time_left() == 0 or \
				global_position.distance_to(wanderController.target_position) <= speed * delta:
				update_state()
			move_toward_position(wanderController.target_position, delta)

		CHASE:
			animationPlayer.play("Move")
			if playerDetectionZone.can_see_player():
				move_toward_position(playerDetectionZone.player.global_position, delta)
			else:
				state = IDLE

	if softCollision.is_colliding():
		velocity += avoidence_rate * softCollision.get_push_vector() * delta

	velocity = move_and_slide(velocity)


func _on_Hurtbox_area_entered(area):
	# Area is the hitbox which collided with the Bat
	stats.health -= area.damage  # Area has associated damage value
	knockback = area.knockback_vector * knockback_rate
	hurtbox.create_hit_effect()
	hurtbox.start_invincibility(0.4)


func _on_Stats_no_health():
	# Call down signal up: stats sends no_health signal when health <= 0
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instance()
	enemyDeathEffect.global_position = global_position
	get_parent().add_child(enemyDeathEffect)


#func _on_Hurtbox_invincibility_started():
#	flickerAnimationPlayer.play("Start")
#
#
#func _on_Hurtbox_invincibility_ended():
#	flickerAnimationPlayer.play("Stop")


func _on_StartledTimer_timeout():
	update_state()
	hurtbox.invincible = false
	hitbox.monitorable = true
	# Hacky but works
	hitboxCollisionShape.set_deferred("disabled", false)
