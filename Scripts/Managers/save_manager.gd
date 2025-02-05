extends Node
class_name SaveManager

const SAVE_PATH = "user://saves/"
const SAVE_FILE_NAME = "save.json"
#const SECURITY_KEY = "0923874590"

var player_data

func _ready():
	verify_save_dir(SAVE_PATH)
	
func verify_save_dir(path : String):
	DirAccess.make_dir_absolute(path)

func save_data(path : String):
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

func load_data(path : String):
	if !FileAccess.file_exists(path):
		printerr("Cannot open non-existent file at %s" % [path])
		return
		
	var file = FileAccess.open(path, FileAccess.READ)
	if file == null:
		print(FileAccess.get_open_error())
		return
	var content = file.get_as_text()
	file.close()
	
	var data = JSON.parse_string(content)
	if data == null:
		printerr("Cannot parse %s as a json_string: (%s)" % [path, content])
		return
	
	#Load data:
	var save_resource = SaveResource.new()
	save_resource.current_scene = data.current_level
	save_resource.coins = data.player_data.coins
	#save_resource._revert_collection(data.player_data.weapons, save_resource._get_weapons())
	#save_resource._revert_collection(data.player_data.suits, save_resource._get_suits())
	save_resource.apply_data()
	
