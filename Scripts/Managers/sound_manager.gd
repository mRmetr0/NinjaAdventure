extends AudioStreamPlayer

const PATH = "res://Sounds/SFX/"

const sound_paths = [
	# Sounds for characters
	"hurt_sound.wav", 
	"lose_sound.wav", 
	"light_attack_sound.wav", 
	"heavy_attack_sound.wav", 
	"use_healing.wav",
	# Misc sounds
	"door_sound.wav", 
	"pick_up_sound.wav", 
	"smoke_sound.wav",
	"parry_sound.wav",
	"break_bush_sound.wav"]

var sound_list = []

enum SOUND {
	# Sounds for characters
	HURT,
	DIE,
	L_ATTACK,
	H_ATTACK,
	HEAL,
	# Misc sounds
	DOOR,
	PICK_UP,
	SMOKE,
	PARRY,
	BREAK_BUSH,
	
	NULL,
}

func _ready():
	for sound_path in sound_paths:
		sound_list.append(load(PATH + sound_path))

func _get_sound(sound_name : SOUND):
	if sound_name == SOUND.NULL:
		return sound_list[0]
	return sound_list[sound_name]


func play_sound(sound_name : SOUND):
	if sound_name == SOUND.NULL:
		return
	stream = _get_sound(sound_name)
	play()
