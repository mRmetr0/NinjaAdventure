extends Resource

class_name WeaponResource

enum effects {
	NULL,
	PUSH, #PUSHES AWAY ENEMIES
	INTERACT, # CAN ACTIVATE OBJECTS BY HITTING THEM
	REFLECT, # IF WEAPON HITS A PROJECTILE, WILL REFLECT IT BACK TO SENDER
	}

@export var name : String
@export var icon : Texture2D
@export var weapon_sprite : Texture2D
## gamer
@export var damage : int
@export var stun_lock = 0.2
@export var heavy_weapon : bool
@export var effect : effects

var character

func _weapon_function(_body):
	match effect:
		effects.PUSH:
			pass
		effects.INTERACT:
			pass
