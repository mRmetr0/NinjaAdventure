extends BasePickUp

@export var resource : Resource
@export var use_on_touch = false
var unlock_list_index = -1
@export var unlock_item_index = -1

func _ready():
	super._ready()
	sprite.texture = resource.icon

func _activate_pickup(body):
	var player = body as Player
	
	if resource is WeaponResource:
		player._set_weapon(resource)
		unlock_list_index = 0
	elif resource is SuitResource:
		unlock_item_index = 1
	elif resource is ItemResource:
		if use_on_touch:
			resource._use_item(player)
		else:
			player._set_item(resource)
			
	if unlock_list_index >= 0 && unlock_item_index >= 0:
		SaveManager.current_save_resource._unlock_item(unlock_list_index, unlock_item_index)
