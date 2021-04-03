extends Node2D


func create_grass_effect():
	# GRASS EFFECT SCENE
	var grassEffect = load("res://Effects/GrassEffect.tscn").instance()  # Instance (node) of scene
	grassEffect.global_position = global_position  # Set effect to global position of grass
	
	var world = get_tree().current_scene  # Gets first scene in root (here it is the World node)
	world.add_child(grassEffect)


func _ready():
	pass # Replace with function body.


func _on_Hurtbox_area_entered(area):
	create_grass_effect()
	queue_free()
