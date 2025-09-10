extends Sprite2D

class_name BasePickUp

@export_category("RESOURCE")
@export var resource : BaseResource
@export var use_resource_on_touch = false
var unlock_list_index = -1
@export var unlock_item_index = -1
@export_category("GENERAL")
@export var despawn_timer: float = -1.0
@export_category("MISC")
@export var coins_given = 0

@onready var timer : Timer = get_node("Timer")

func _ready():
	if resource != null:
		texture = resource.icon

	if despawn_timer > 0.0:
		timer.wait_time = despawn_timer
		timer.start()
	else:
		set_process(false)
		timer.queue_free()

func _process(_delta):
	# blink when the timer runs out:
	if timer.time_left > despawn_timer/2:
		return
	if fmod(timer.time_left, 1) < 0.5:
		self_modulate = Color.WHITE
	else:
		self_modulate = Color.TRANSPARENT

func _activate_pickup(_body):
	SoundManager.play_sound(SoundManager.SOUND.PICK_UP)
	_handle_resource(_body)
	_handle_coins(_body)
	queue_free()

func _on_timer_timeout():
	queue_free()
	
func _handle_coins(body):
	if coins_given <= 0:
		return
	var player = body as Player
	player.set_coins(coins_given, texture)

func _handle_resource(body):
	if resource == null:
		return
	var player = body as Player
	if resource is WeaponResource:
		player._set_weapon(resource)
		unlock_list_index = 0
	elif resource is SuitResource:
		unlock_item_index = 1
	elif resource is ItemResource:
		if use_resource_on_touch:
			resource._use_item(player)
		else:
			player._set_item(resource)
			
	if unlock_list_index >= 0 && unlock_item_index >= 0:
		SaveManager.current_save_resource._unlock_item(unlock_list_index, unlock_item_index)
