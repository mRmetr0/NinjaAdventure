extends Area2D

class_name BasePickUp

@export var use_on_touch = false

@onready var sprite = get_node("Sprite2D")

func _on_body_entered(body):
	if body.name != "Player":
		return
	SoundManager.play_sound(SoundManager.SOUND.PICK_UP)
	_activate_pickup(body)		
	queue_free()

func _activate_pickup(body):
	pass
