extends Node

var random = RandomNumberGenerator.new()

var current_level
var canvasLayer
var main_player : Player

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	current_level = get_tree().root.get_node("Main")
	canvasLayer = get_viewport().get_camera_2d().get_child(0)
	main_player = current_level.get_node("Player")

func _change_scene(next_scene : String, newPos : Vector2):	
	current_level.remove_child(main_player)
	#Make new scene
	var next_level = load("res://Scenes/Levels/" + next_scene+".tscn").instantiate()
	next_level.name = "Main"
	
	#Replace player in new scene with current player
	var scene_player =	next_level.get_node("Player")
	next_level.remove_child(scene_player)
	scene_player.queue_free()
	next_level.add_child(main_player)
	main_player.name = "Player"
	main_player.global_position = newPos

	get_tree().root.call_deferred("add_child", next_level)
	get_tree().root.call_deferred("remove_child", current_level)
	current_level.call_deferred("free")
	current_level = next_level
	await get_tree().create_timer(0.0001).timeout
	main_player.setup_ui()
	
func get_current_level_name():
	return current_level.name
