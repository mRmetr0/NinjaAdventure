extends BaseResource

class_name SuitResource

enum ABILITY{
	CAMOUFLAGE,
	RAGE,
	PARRY,
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
	
func _reset_suit_ability():
	match ability:
		ABILITY.CAMOUFLAGE:
			if !player.canAct:
				player.canAct = true
				player.camouflaged = false
				player.animator.sprite.modulate = Color("White")
			return
		ABILITY.RAGE:
			player._handle_rage(false)
			return
		ABILITY.PARRY:
			player.canAct = true
			return

func suit_ability():
	match ability:
		ABILITY.CAMOUFLAGE:
			_camouflage()
			return
		ABILITY.RAGE:
			player._take_damage(1)
			player._handle_rage(true, 10.0)
			ParticleManager._play_particle(ParticleManager.floor_smoke, \
				player.animator.sprite.global_position + Vector2(0, 6), \
				8, Vector2(0.8, 0.9), 1.3)
			return
		ABILITY.PARRY:
			_parry()
			return

func _camouflage():
	#Set mechanics
	player.canAct = !player.canAct
	player.camouflaged = !player.canAct
	#Set visuals
	player.animator.sprite.modulate = Color("Gray") if !player.canAct else Color("White")
	ParticleManager._play_particle(ParticleManager.smoke, \
		player.animator.sprite.global_position, 6, Vector2(0.9, 1.1), 2)
	#var inst = player.smoke.instantiate()
	#inst.global_position = player.animator.sprite.global_position
	#player.get_parent().add_child(inst)
	SoundManager.play_sound(SoundManager.SOUND.SMOKE)
	player.animator._set_special()
	
func _parry():
	if !player.canAct:
		return
	player.canAct = false
	player.parrying = true
	#visuals
	SoundManager.play_sound(SoundManager.SOUND.PARRY)
	player.animator._set_special()
	ParticleManager._play_particle(ParticleManager.parry_prepare, \
		player.animator.sprite.global_position, 10, Vector2(0.6, 0.7), 1.2)
		
	await player.get_tree().create_timer(1.0).timeout
	player.parrying = false
	await player.get_tree().create_timer(0.2).timeout
	player.canAct = true
