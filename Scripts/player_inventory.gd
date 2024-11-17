extends Node

var money : int

var weapons : Array[WeaponResource]
var items : Array[ItemResource]

func _add_money(value :int, last_coin_sprite : Texture2D = null):
	money += value
	var ui : GameUI = get_viewport().get_camera_2d().get_child(0).get_child(0)
	if ui != null:
		ui._update_money_ui(money, last_coin_sprite)
		
