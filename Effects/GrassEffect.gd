extends Node2D

onready var leaves = $Leaves

# Called when the node enters the scene tree for the first time.
func _ready():
	leaves.play("Animate")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Leaves_animation_finished():
	queue_free()
