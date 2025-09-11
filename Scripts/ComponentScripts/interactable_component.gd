extends Node2D

class_name InteractComponent

@onready var player : Player = GameManager.main_player
@onready var prompt = get_node_or_null("KeyPrompt")

@export var interact_trigger : Node
@export var interact_dist : float

signal OnInteract

func _ready():
	player.connect("Interact", _on_player_interact)
	
func _process(_delta):
	if !prompt:
		set_process(false)
		return
	prompt.visible = _get_player_close()

func _on_player_interact(override_distance : bool = false):
	if _get_player_close() || override_distance:
		OnInteract.emit()
		_trigger_interact()
		
func _get_player_close() -> bool:
	return global_position.distance_to(player.global_position) < interact_dist
	
func _trigger_interact():
	if interact_trigger is DialogueManager:
		var dia_manager = interact_trigger as DialogueManager
		dia_manager.start_dialogue()
