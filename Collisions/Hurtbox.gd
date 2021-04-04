extends Area2D

const HitEffect = preload("res://Effects/HitEffect.tscn")

var invincible = false setget set_invincible

onready var timer = $Timer
onready var collisionShape = $CollisionShape2D

signal invincibility_started
signal invincibility_ended


func set_invincible(value):
	invincible = value
	if invincible == true:
		emit_signal("invincibility_started")
	else:
		emit_signal("invincibility_ended")


func start_invincibility(duration):
	# Hurtbox does not take damage for duration after hit
	self.invincible = true
	timer.start(duration)


func create_hit_effect():
	var hitEffect = HitEffect.instance()
	hitEffect.global_position = global_position

	var main = get_tree().current_scene
	main.add_child(hitEffect)


func _on_Timer_timeout():
	self.invincible = false  # Setter only activated when prefixed with self


func _on_Hurtbox_invincibility_started():
	# This happens during physics process so set should be deferred
	collisionShape.set_deferred("disabled", true)
	set_deferred("monitorable", false)


func _on_Hurtbox_invincibility_ended():
	collisionShape.set_deferred("disabled", false)
	monitorable = true
