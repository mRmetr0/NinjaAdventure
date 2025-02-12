extends Resource

class_name SaveResource

var save_file_name : String
var current_scene : String = "HomeScene"
var player_name : String = "Suki"

var coins : int
#Collected weapons check:
var current_weapon_equip = -1
var has_sword = false
var has_whip = false
var has_axe = false
var has_great_sword = false
#Collected suits check:
var current_suit_equip = -1
var has_green_suit = false
var has_rage_suit = false;
var has_snow_suit = false

func apply_data():
	GameManager._change_scene(current_scene)
	GameManager.main_player.coins = coins

func _unlock_item(list_index : int, item_index : int):
	if list_index == 0:
		var list = _get_weapons()
		list[list_index] = true
		_set_weapons(list)
		list = _get_weapons()
	elif list_index == 1:
		var list = _get_suits()
		list[item_index] = true
		_set_suits(list)

func set_weapons(_has_sword : bool, _has_whip : bool, _has_axe : bool, _has_g_sword : bool):
	has_sword = _has_sword
	has_whip = _has_whip
	has_axe = _has_axe
	has_great_sword = _has_g_sword

func _set_weapons(list):
	has_sword = list[0]
	has_whip = list[1]
	has_axe = list[2]
	has_great_sword = list[3]	

func set_suits(_has_green : bool, _has_rage : bool, has_snow : bool):
	has_great_sword = _has_green
	has_rage_suit = _has_rage
	has_snow_suit = has_snow

func _set_suits(list):
	has_great_sword = list[0]
	has_rage_suit = list[1]
	has_snow_suit = list[2]
	
func _get_weapons():
	return [has_sword, has_whip, has_axe, has_great_sword]
	
func _get_suits():
	return[has_great_sword, has_rage_suit, has_snow_suit]
