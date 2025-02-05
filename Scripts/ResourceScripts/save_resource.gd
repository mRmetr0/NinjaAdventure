extends Resource

class_name SaveResource

var current_scene : String

var coins : int
#Collected weapons check:
var current_weapon_equip = -1
var has_sword = false
var has_whip = false
var has_axe = false
var has_great_sword = false
var has_god_tool = false
#Collected suits check:
var current_suit_equip = -1
var has_green_suit = false
var has_rage_suit = false;
var has_snow_suit = false

func apply_data():
	GameManager._change_scene(current_scene)
	GameManager.main_player.coins = coins

func convert_collection(list : Array):
	var string = ""
	for weapon in list:
		if weapon:
			string += "1"
		else:
			string +="0"

func _revert_collection(input : String, list : Array):
	if list == null:
		print("List is null")
		return
	var counter = 0
	for bit in input:
		list[0] = int(bit) == 0
		counter += 1
	
func _get_weapons():
	return [has_sword, has_whip, has_axe, has_great_sword, has_god_tool]
	
func _get_suits():
	return[has_great_sword, has_rage_suit, has_snow_suit]
