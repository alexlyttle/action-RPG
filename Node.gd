extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	var a = [1, 2, 3, 4]
	var s = a.size()
	for i in range(a.size()):
		print((i+1)%s)
