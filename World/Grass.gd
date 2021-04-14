extends Node2D

const Snake = preload("res://Enemies/Snake.tscn")
const GrassEffect = preload("res://Effects/GrassEffect.tscn")  # So we only need to load it once
const P_SNAKE = 0.1  # Probability of spawning a snake


func spawn_snake():
	var snake = Snake.instance()
	snake.position = position
	get_parent().add_child(snake)


func create_grass_effect():
	# GRASS EFFECT SCENE
	var grassEffect = GrassEffect.instance()  # Instance (node) of scene
	grassEffect.global_position = global_position  # Set effect to global position of grass
	get_parent().add_child(grassEffect)


func _ready():
	pass # Replace with function body.


func _on_Hurtbox_area_entered(_area):
	create_grass_effect()
	var rn = randf()
	if rn < P_SNAKE:
		spawn_snake()
	queue_free()
