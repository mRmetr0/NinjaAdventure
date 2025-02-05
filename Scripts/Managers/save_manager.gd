extends Node
class_name SaveManager

const SAVE_PATH = "user://saves/"
const GLOBAL_DATA_FILE_NAME = "global.json"
const SAVE_FILE_NAME = "save.json"
#const SECURITY_KEY = "0923874590"

func _ready():
	verify_save_dir(SAVE_PATH)
	
func verify_save_dir(path : String):
	DirAccess.make_dir_absolute(path)
	

func save_data(file_name : String):
	var path = SAVE_PATH + file_name
	var file = FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		print(FileAccess.get_open_error())
		return
	
	var save_resource = SaveResource.new()
	var data = {
		"current_level": GameManager.get_current_level_name(),
		"player_data":{
			"coins": save_resource.coins,
			#"weapons": save_resource.convert_collection(save_resource._get_weapons()),
			#"suits": save_resource.convert_collection(save_resource._get_suits())
		}
	}
	print(data)
	
	var json_string = JSON.stringify(data, "\t")
	file.store_string(json_string)
	file.close()

func load_data(file_name : String):
	var data = _load_file(file_name)
	print(data)
	if data == null:
		return
	#Load data:
	var save_resource = SaveResource.new()
	save_resource.current_scene = data.current_level
	save_resource.coins = data.player_data.coins
	#save_resource._revert_collection(data.player_data.weapons, save_resource._get_weapons())
	#save_resource._revert_collection(data.player_data.suits, save_resource._get_suits())
	save_resource.apply_data()

func _load_global_data():	
	var data = _load_file(GLOBAL_DATA_FILE_NAME)
	if data == null:
		return
	
func _load_file(file_name : String):
	var path = SAVE_PATH + file_name
	if !FileAccess.file_exists(path):
		printerr("Cannot open non-existent file at %s" % [path])
		return null

	var file = FileAccess.open(path, FileAccess.READ)
	if file == null:
		print(FileAccess.get_open_error())
		return null
	
	var content = file.get_as_text()
	file.close()
	
	var data = JSON.parse_string(content)
	if data == null:
		printerr("Cannot parse %s as a json_string: (%s)" % [path, content])
		return null
		
	return data
	
