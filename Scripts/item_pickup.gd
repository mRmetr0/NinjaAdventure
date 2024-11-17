extends BasePickUp

@export var resource : Resource
@export var use_on_touch = false

func _ready():
	super._ready()
	sprite.texture = resource.icon

func _activate_pickup(body):
	var player = body as Player
	
	if resource is WeaponResource:
		player._set_weapon(resource)
	elif resource is ItemResource:
		if use_on_touch:
			resource._use_item(player)
		else:
			player._set_item(resource)
