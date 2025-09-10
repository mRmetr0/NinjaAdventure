extends Node

var random = RandomNumberGenerator.new()

var current_level
var main_player : Player
var main_hud : GameUI

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	current_level = get_tree().root.get_child(get_tree().root.get_child_count()-1)
	main_player = current_level.get_node("Player")
	if current_level.name != "StartScene":
		await get_tree().process_frame
		main_player.setup_ui()

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
			SaveManager.save_data(SaveManager.current_save_file)
		if event.keycode == KEY_9:
			print("LOADING GAME")
			var data = SaveManager.load_data(SaveManager.current_save_file)
			data.apply_data()
		if event.keycode == KEY_P:	#TODO: ADD GODMODE (for testing :)
			#GODMODE:
			var god_resource = SaveManager.current_save_resource
			god_resource.player_name = "GOD"
			god_resource.coins = 999
			god_resource.set_weapons(true, true, true, true)
			god_resource.set_suits(true, true, true)
			
			SaveManager.current_save_resource = god_resource
	
