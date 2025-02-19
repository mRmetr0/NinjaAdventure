extends Node2D

class_name InteractComponent

@onready var player : Player = GameManager.main_player
@onready var hud = get_parent().get_node("Camera2D").get_child(0).get_child(0)
@onready var prompt = get_node("KeyPrompt")

@export var interact_dist : float
@export_multiline var interact_text : String

signal OnInteract

func _ready():
	player.connect("Interact", _on_player_interact)
	
func _process(delta):
	prompt.visible = _get_player_close()

func _on_player_interact():
	if _get_player_close():
		hud._set_text_box(player.portrait, interact_text)
		OnInteract.emit()
		
func _get_player_close() -> bool:
	return position.distance_to(player.position) < interact_dist
