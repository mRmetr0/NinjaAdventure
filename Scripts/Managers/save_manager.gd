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
	
	var data = {
		"current_level": GameManager.get_current_level_name(),
		"player_data":{
			"coins": 5
		}
	}

func load_data():
	pass
