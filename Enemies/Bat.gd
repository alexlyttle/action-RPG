extends KinematicBody2D

const FRICT = 200
const KNOCK = 120
const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

var knockback = Vector2.ZERO

onready var stats = $Stats


func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICT * delta)
	knockback = move_and_slide(knockback)


func _on_Hurtbox_area_entered(area):
	# Area is the hitbox which collided with the Bat
	stats.health -= area.damage  # Area has associated damage value
	knockback = area.knockback_vector * KNOCK


func _on_Stats_no_health():
	# Call down signal up: stats sends no_health signal when health <= 0
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instance()
	enemyDeathEffect.global_position = global_position
	get_parent().add_child(enemyDeathEffect)
	
