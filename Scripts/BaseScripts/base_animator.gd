extends AnimationPlayer

class_name BaseAnimator

@onready var sprite = get_parent().get_node("Sprite2D")

var walking_animations = ["walking_forward", "walking_backwards", "walking_left", "walking_right"]
var slow_attack_animations = ["slow_attack_forwards", "slow_attack_backwards", "slow_attack_left", "slow_attack_right"]
var attack_animations = ["attack_forwards", "attack_backwards", "attack_left", "attack_right"]
var lastIndex = 0;

func _ready():
	play("idle")
	
func _set_walk_animation (direction : Vector2):	
	var index = _get_clockwhise_direction(direction)
	if (index > -1):
		play(walking_animations[index])
		lastIndex = index
	else:
		stop(true)
		sprite.set_frame(lastIndex)

func _set_attack(direction : Vector2, slow_attack : bool) -> float:
	lastIndex = _get_clockwhise_direction(direction)
	if slow_attack:
		play (slow_attack_animations[lastIndex])
	else:
		play (attack_animations[lastIndex])
		
	return current_animation_length

func _set_special():
	stop(false)
	sprite.set_frame(27)
	
func _get_clockwhise_direction(direction : Vector2) -> float:	
	direction.y *= 0.9
	if abs(direction.x) < abs(direction.y): 
		if direction.y > 0:
			return 0
		else:
			return 1
	elif abs(direction.x) > abs(direction.y):	
		if direction.x < 0:
			return 2
		else:
			return 3
	else: 
		return -1
