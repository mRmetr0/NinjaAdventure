extends Node

var random = RandomNumberGenerator.new()

var current_level
var main_player : Player
const AUTOLOAD_AMOUNT = 4

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	current_level = get_tree().root.get_child(AUTOLOAD_AMOUNT)
	main_player = current_level.get_node("Player")

func _change_scene(next_scene : String, newPos = null):
	current_level.remove_child(main_player)
	#Make new scene
	var next_level = load("res://Scenes/Levels/" + next_scene+".tscn").instantiate()
	
	#Replace player in new scene with current player
	var scene_player =	next_level.get_node("Player")
	var scene_player_pos = scene_player.global_position
	next_level.remove_child(scene_player)
	scene_player.queue_free()
	next_level.add_child(main_player)
	main_player.name = "Player"
	if newPos != null:
		main_player.global_position = newPos
	else:
		main_player.global_position = scene_player_pos

	get_tree().root.call_deferred("add_child", next_level)
	get_tree().root.call_deferred("remove_child", current_level)
	current_level.call_deferred("free")
	current_level = next_level
	await get_tree().create_timer(0.0001).timeout
	main_player.setup_ui()
	
func get_current_level_name():
	var level_name = current_level.name
	level_name = level_name.replace('"', "")
	level_name = level_name.replace("&", "")
	return level_name
	
#TEST INPUT:
func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_8:
			print("SAVING GAME")
			SaveManager.current_save_resource = SaveResource.new()
			SaveManager.save_data(SaveManager.SAVE_FILE_NAME)
		if event.keycode == KEY_9:
			print("LOADING GAME")
			SaveManager.load_data(SaveManager.SAVE_FILE_NAME)
	
