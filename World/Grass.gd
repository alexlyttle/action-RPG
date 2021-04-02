extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("attack"):
		# GRASS EFFECT SCENE
		var grassEffect = load("res://Effects/GrassEffect.tscn").instance()  # Instance (node) of scene
		grassEffect.global_position = global_position  # Set effect to global position of grass
		
		var world = get_tree().current_scene  # Gets first scene in root (here it is the World node)
		world.add_child(grassEffect)
		
		queue_free()  # Adds to queue to remove grass from game
