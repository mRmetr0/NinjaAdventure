extends Camera2D

@onready var player = get_parent().get_node("Player")
@onready var resolution = get_viewport().get_visible_rect().size

func _ready():
	var notiv = player.get_node("OnScreen")
	notiv.connect ("screen_exited", _on_screen_exit)
	_on_screen_exit()
	
func _on_screen_exit():
	var moveModX = floor(player.global_position.x / resolution.x)
	var moveModY = floor(player.global_position.y / resolution.y)
	global_position = Vector2(moveModX * resolution.x, moveModY * resolution.y)

func _old_cam_set():
	var direction = (player.global_position - (global_position + Vector2(resolution.x/2, resolution.y/2)))
	if (abs(direction.x) > abs(direction.y)):
		direction.y = 0
	else:
		direction.x = 0
	direction = direction.normalized()
	global_position += Vector2(direction.x * resolution.x, direction.y * resolution.y)
	
