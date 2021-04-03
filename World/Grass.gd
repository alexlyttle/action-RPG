extends Node2D

const GrassEffect = preload("res://Effects/GrassEffect.tscn")  # So we only need to load it once

func create_grass_effect():
	# GRASS EFFECT SCENE
	var grassEffect = GrassEffect.instance()  # Instance (node) of scene
	grassEffect.global_position = global_position  # Set effect to global position of grass
	get_parent().add_child(grassEffect)


func _ready():
	pass # Replace with function body.


func _on_Hurtbox_area_entered(area):
	create_grass_effect()
	queue_free()
