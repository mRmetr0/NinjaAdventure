extends Node2D

class_name StatusComponent

enum Statusses{
	rage,
	frozen,
}

@export var status : Statusses
@export var duration : float = 5
var elapsed = 0

@onready var character : Character = get_parent()

func _ready():
	set_process(false)

func _process(delta):
	if elapsed < duration:
		elapsed += delta
		return
	elapsed = 0.0
	_handle_status(false)

func _handle_status(apply : bool, new_duration = -1):
	if apply and new_duration > 0:
		duration = new_duration
	match status:
		Statusses.rage:
			character.raged = apply
			var color = Color.ORANGE if apply else Color.WHITE
			character.animator.sprite.modulate = color
			character.current_color_state = color
		Statusses.frozen:
			character.frozen = apply
	set_process(apply)
