extends BaseResource

class_name ItemResource

enum effects {
	HEAL_HEALTH,
	RESTORE_ENERGY,
	NULL
	}

@export var name : String
@export var icon : Texture2D
@export var expendable : bool
@export var expendable_amount : int
# on use data
@export var effect : effects
@export var value : int
@export var use_sound = SoundManager.SOUND.NULL

func _use_item(player):
	#if expendable_amount <= 0:
		#return
	
	SoundManager.play_sound(use_sound)
	
	match effect:
		effects.HEAL_HEALTH:
			player._set_health(player.health + value)
	if expendable:
		expendable_amount -= 1
		if expendable_amount <= 0:
			# REMOVE ITEM FROM PLAYER LIST
			player._set_item(null)
			pass
