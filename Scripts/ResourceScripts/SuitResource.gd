extends Resource

class_name SuitResource

enum ABILITY{
	CAMOUFLAGE,
	RAGE,
	COUNTER,
	NULL,
}

@export var portrait : Texture2D
@export var sprite_sheet : Texture2D
@export var ability : ABILITY

var player : Player

func _set_suit(p_player : Player):
	player = p_player
	player.portrait = portrait
	player.sprite_sheet = sprite_sheet
	player.animator.sprite.texture = sprite_sheet
	
func suit_ability():
	match ability:
		ABILITY.CAMOUFLAGE:
			_camouflage()
			return
		ABILITY.RAGE:
			return
		ABILITY.COUNTER:
			return

func _camouflage():
	#Set mechanics
	player.canAct = !player.canAct
	player.camouflaged = !player.canAct
	#Set visuals
	player.animator.sprite.modulate = Color("Gray") if !player.canAct else Color("White")
	var inst = player.smoke.instantiate()
	inst.global_position = player.animator.sprite.global_position
	player.get_parent().add_child(inst)
	SoundManager.play_sound(SoundManager.SOUND.SMOKE)
	player.animator._set_special()
