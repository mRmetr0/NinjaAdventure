extends AudioStreamPlayer

const PATH = "res://Sounds/SFX/"

#@onready var hurt = load(PATH + "door_sound.wav")
#@onready var lose_game = load(PATH + "lose_sound.wav")
#@onready var heavy_attack = load(PATH + "heavy_attack_sound.wav")
#@onready var light_attack = load(PATH + "light_attack_sound.wav")
#@onready var door = load(PATH + "door_sound.wav")
#@onready var pick_up = load(PATH + "pick_up_sound.wav")
#@onready var smoke = load(PATH + "smoke_sound.wav")
#@onready var break_bush = load(PATH + "break_bush_sound.wav")

const sound_paths = [
	"hurt_sound.wav", 
	"lose_sound.wav", 
	"light_attack_sound.wav", 
	"heavy_attack_sound.wav", 
	"door_sound.wav", 
	"pick_up_sound.wav", 
	"smoke_sound.wav",
	"break_bush_sound.wav"]

var sound_list = []

enum SOUND {
	# Sounds for characters
	HURT,
	DIE,
	L_ATTACK,
	H_ATTACK,
	# Misc sounds
	DOOR,
	PICK_UP,
	SMOKE,
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
	#match(sound_name):
		#SOUND.HURT:
			#return hurt
		#SOUND.DIE:
			#return lose_game
		#SOUND.L_ATTACK:
			#return light_attack
		#SOUND.H_ATTACK:
			#return heavy_attack
		#SOUND.DOOR:
			#return door
		#SOUND.PICK_UP:
			#return pick_up
		#SOUND.SMOKE:
			#return smoke
		#SOUND.BREAK_BUSH:
			#return break_bush


func play_sound(sound_name : SOUND):
	stream = _get_sound(sound_name)
	play()
