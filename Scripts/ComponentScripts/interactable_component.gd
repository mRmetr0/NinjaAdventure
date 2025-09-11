extends Node2D

class_name InteractComponent

@onready var player : Player = GameManager.main_player
@onready var hud = GameManager.current_level.get_node("Camera2D").get_child(0).get_child(0)
@onready var prompt = get_node_or_null("KeyPrompt")

@export var interact_dist : float
@export_multiline var interact_text : String

var portrait : Texture

signal OnInteract

func _ready():
	player.connect("Interact", _on_player_interact)
	if get_parent() is Character:
		portrait = get_parent().portrait
	else:
		portrait = player.portrait
	
func _process(_delta):
	if !prompt:
		set_process(false)
		return
	prompt.visible = _get_player_close()

func _on_player_interact(override_distance : bool = false):
	if _get_player_close() || override_distance:
		hud._set_text_box(portrait, interact_text)
		OnInteract.emit()
		
func _get_player_close() -> bool:
	return global_position.distance_to(player.global_position) < interact_dist
