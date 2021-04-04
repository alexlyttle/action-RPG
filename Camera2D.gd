extends Camera2D

export(float) var zoom_min = 0.5
export(float) var zoom_max = 2.0
export(float) var zoom_step = 0.1

onready var topLeft = $Limits/TopLeft
onready var bottomRight = $Limits/BottomRight


func _ready():
	limit_top = topLeft.position.y
	limit_left = topLeft.position.x
	limit_bottom = bottomRight.position.y
	limit_right = bottomRight.position.x


func _process(delta):
	if Input.is_action_just_released("camera_zoom_in"):
		zoom = zoom.move_toward(zoom_min * Vector2.ONE, zoom_step)
	elif Input.is_action_just_released("camera_zoom_out"):
		zoom = zoom.move_toward(zoom_max * Vector2.ONE, zoom_step)
