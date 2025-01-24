extends Node2D

class_name StatusComponent

enum Statusses{
	rage,
	frozen,
}

@export var status : Statusses
@export var duration : float
var elapsed = 0

@onready var character : Character = get_parent()

func _ready():
	set_process(false)

func _process(delta):
	if elapsed < duration:
		elapsed += delta
		return
	_handle_status(false)

func _handle_status(apply : bool):
	match status:
		Statusses.rage:
			character.raged = apply
		Statusses.frozen:
			character.frozen = apply
	set_process(apply)
