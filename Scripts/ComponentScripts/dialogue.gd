extends Node
class_name Dialogue

@export_multiline var dialogue : String
@export var portrait : Texture2D
@export_group("responses")
@export var response_1 : String = ""
@export var result_1 : Node
@export var response_2 : String = ""
@export var result_2 : Node
@export var response_3 : String = ""
@export var result_3 : Node
@export var response_4 : String = ""
@export var result_4 : Node

@onready var responses : Array[String] = [response_1, response_2, response_3, response_4]
@onready var results : Array[Node] = [result_1, result_2, result_3, result_4]

func _ready():
	if portrait == null:
		if get_parent().get_parent().get_parent() is Character:
			portrait = get_parent().get_parent().get_parent().portrait
		else:
			portrait = GameManager.main_player.portrait

func get_responses():
	var full_list : Array[String] = [response_1, response_2, response_3, response_4]
	var list : Array[String] = []
	for i in full_list:
		if !i.is_empty():
			list.append(i)
	return list

func choose_response(response_index : int):	
	var result : Node = results[response_index]
	if result == null:
		get_parent().end_dialogue()
		return
	if result is Dialogue:
		result = result as Dialogue
		get_parent().start_dialogue(result)
