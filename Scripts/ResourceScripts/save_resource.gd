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
var has_rage_suit = false
var has_snow_suit = false
#Collected/visible items check:
#ITEMS WILL BE DISPLAYED IN QUANTITY, 
#	-1 MEANS HIDDEN FROM THE PLAYERS INVENTORY
#	0 MEANS VISIBLE BUT HAS NO QUANTITY AVAILABLE
#EACH ITEM'S SPOT IN THE LIST IS THE EQUIVALENT TO THE ITEMS ID.
var item_list : Array[int] = [
	-1, #0 Healing potion
	#FOOD: 
	-1, #1
	-1, #2
	-1, #3
	#COMBAT ITEMS:
	-1, #4
	-1, #5 Shurken
	-1, #6
	-1, #7
]
var quest_item_list : Array[int] = [
	-1, #0 Caring key
	-1, #1 Farmers key
	-1, #2 Warding key
]

func apply_data():
	GameManager._change_scene(current_scene)
	GameManager.main_player.coins = coins
	#TODO: Give player gear on save load
	#if current_weapon_equip == -1:
		#GameManager.main_player.

func unlock_gear(list_index : int, item_index : int):
	if list_index == 0:				# 0 if unlock weapon
		var list = _get_weapons()
		list[list_index] = true
		_set_weapons(list)
		list = _get_weapons()
	elif list_index == 1:			# 1 if unlock suit
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
	has_green_suit = _has_green
	has_rage_suit = _has_rage
	has_snow_suit = has_snow

func _set_suits(list):
	has_green_suit = list[0]
	has_rage_suit = list[1]
	has_snow_suit = list[2]

func set_items(list : Array):
	for i in list.size():
		item_list[i] = int(list[i])

func set_quest_items(list : Array):
	for i in list.size():
		quest_item_list[i] = int(list[i])

func _get_weapons():
	return [has_sword, has_whip, has_axe, has_great_sword]
	
func _get_suits():
	return[has_green_suit, has_rage_suit, has_snow_suit]

func aquire_item(index : int, amount : int):
	item_list[index] = max(0, item_list[index])
	item_list[index] += amount

func lose_item(index : int, lose_all : bool = false):
	if lose_all:
		item_list[index] = 0
		return false
	item_list[index] -= 1
	return item_list.size()

func aquire_quest_item(index : int):
	quest_item_list[index] = 1

func lose_quest_item(index : int):
	quest_item_list[index] = -1
