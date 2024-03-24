extends Node

var current_level
var canvasLayer

#PLAYER DATA
var player_health = -1
var player_weapon = null
var player_item 

@onready var pause_screen = preload("res://Scenes/PauseScreen.tscn").instantiate()

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	current_level = get_tree().root.get_node("Main")
	canvasLayer = get_viewport().get_camera_2d().get_child(0)

func _change_scene(next_scene : String, newPos : Vector2):
	#Save old data
	var old_player = current_level.get_node("Player")
	player_health = old_player.health
	player_weapon = old_player.weapon
	
	#Make new scene
	var next_level = load("res://Scenes/Levels/" + next_scene+".tscn").instantiate()
	next_level.name = "Main"
		
	var new_player = next_level.get_node("Player")
	new_player.global_position = newPos

	get_tree().root.call_deferred("add_child", next_level)
	get_tree().root.call_deferred("remove_child", current_level)
	current_level.call_deferred("free")
	current_level = next_level
	
func _input(event):
	if event.is_action_pressed("menu"):
		get_tree().paused = !get_tree().paused
		canvasLayer = current_level.get_viewport().get_camera_2d().get_child(0)
		if get_tree().paused:
			canvasLayer.add_child(pause_screen)
		else:
			canvasLayer.remove_child(pause_screen)
			
	
