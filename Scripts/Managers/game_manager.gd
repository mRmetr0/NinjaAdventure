extends Node

var random = RandomNumberGenerator.new()

var current_level
var canvasLayer
var current_level_name

#PLAYER DATA
var player_health = -1
var player_weapon = null
var player_item = null
var player_suit = null

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	current_level = get_tree().root.get_node("Main")
	canvasLayer = get_viewport().get_camera_2d().get_child(0)

func _change_scene(next_scene : String, newPos : Vector2):
	#Save old data
	var old_player = current_level.get_node("Player")
	player_health = old_player.health
	player_weapon = old_player.weapon
	player_item = old_player.item
	player_suit = old_player.suit
	
	#Make new scene
	var next_level = load("res://Scenes/Levels/" + next_scene+".tscn").instantiate()
	next_level.name = "Main"
	
	#Apply old data
	var new_player = next_level.get_node("Player")
	new_player.global_position = newPos

	get_tree().root.call_deferred("add_child", next_level)
	get_tree().root.call_deferred("remove_child", current_level)
	current_level.call_deferred("free")
	current_level = next_level
	
func get_current_level_name():
	return current_level.name
