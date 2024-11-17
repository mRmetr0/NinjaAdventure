extends Area2D

class_name BasePickUp

@export var despawn_timer: float = 10.0

@onready var timer = get_node("Timer") as Timer
@onready var sprite = get_node("Sprite2D")

func _ready():
	timer.wait_time = despawn_timer
	timer.start()
	
func _process(delta):
	# blink when the timer runs out:
	if timer.time_left > despawn_timer/2:
		return
	if fmod(timer.time_left, 1) < 0.5:
		sprite.show()
	else:
		sprite.hide()

func _on_body_entered(body):
	# play sound and run general code (specifies in subclasses)
	if body.name != "Player":
		return
	SoundManager.play_sound(SoundManager.SOUND.PICK_UP)
	_activate_pickup(body)
	queue_free()

func _activate_pickup(_body):
	pass

func _on_timer_timeout():
	queue_free()
