extends Sprite2D

class_name MenuItemUI

@export var item : BaseResource

var item_icon : Texture

func _ready():
	if item == null:
		queue_free()
	
	if item is WeaponResource:
		item_icon = item.icon
		
	elif item is SuitResource:
		item_icon = item.portrait
		
	elif item is ItemResource:
		item_icon = item.icon
	texture = item_icon
