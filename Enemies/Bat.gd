extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

export(int) var speed = 50
export(int) var acceleration = 500
export(int) var friction = 200
export(int) var knockback_rate = 120
export(int) var avoidence_rate = 400

enum {
	IDLE,
	WANDER,
	CHASE
}

var knockback = Vector2.ZERO
var velocity = Vector2.ZERO
var state = IDLE

onready var body = $Body
onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var hurtbox = $Hurtbox
onready var softCollision = $SoftCollision


func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE


func _process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, friction * delta)
	knockback = move_and_slide(knockback)

	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
			seek_player()

		WANDER:
			pass
		
		CHASE:
			if playerDetectionZone.can_see_player():
				var chase_vector = (playerDetectionZone.player.global_position - global_position).normalized()
				velocity = velocity.move_toward(speed * chase_vector, acceleration * delta)
				body.flip_h = velocity.x < 0  # Flip bat to face player
			else:
				state = IDLE
	
	if softCollision.is_colliding():
		velocity += avoidence_rate * softCollision.get_push_vector() * delta
	velocity = move_and_slide(velocity)


func _on_Hurtbox_area_entered(area):
	# Area is the hitbox which collided with the Bat
	if not hurtbox.invincible:
		stats.health -= area.damage  # Area has associated damage value
		knockback = area.knockback_vector * knockback_rate
		hurtbox.create_hit_effect()


func _on_Stats_no_health():
	# Call down signal up: stats sends no_health signal when health <= 0
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instance()
	enemyDeathEffect.global_position = global_position
	get_parent().add_child(enemyDeathEffect)
	
