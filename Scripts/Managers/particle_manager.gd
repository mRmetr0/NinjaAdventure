extends Node

@onready var particle_obj = preload("res://Scenes/Objects/Effects/single_particle.tscn")
#Spritesheets:
@onready var smoke = preload("res://Assets/FX/Smoke/Smoke/SpriteSheet.png")
@onready var floor_smoke = preload("res://Assets/FX/Smoke/SmokeCircular/SpriteSheet.png")
@onready var parry_prepare = preload("res://Assets/FX/Elemental/Ice/SpriteSheet.png")
@onready var parry_counter = preload("res://Assets/FX/Elemental/Ice/SpriteSheetB.png")

func _play_particle(sprite_sheet : Texture2D, global_pos : Vector2, sheet_length : int, \
		particle_size : Vector2 = Vector2(1,1), anim_speed : float = 1):
	var new_particle = particle_obj.instantiate()
	new_particle.global_position = global_pos
	new_particle.play(sprite_sheet, sheet_length, particle_size, anim_speed)
	GameManager.current_level.add_child(new_particle)
