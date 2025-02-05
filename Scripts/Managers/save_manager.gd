extends Node

var save_path = "user://variable.save"
var current_level

func save_data():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(variable1)
	
func load_data():
	pass
