extends Area2D

var player = null


func can_see_player():
	return player != null

func _on_PlayerDetectionZone_body_entered(body):
	player = body  # We use collision layers to make sure its player


func _on_PlayerDetectionZone_body_exited(_body):
	player = null
