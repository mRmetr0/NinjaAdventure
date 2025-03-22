extends Node2D

signal OnNotice
@export var wait_time : float
@export var route : Array[Vector2]
var progress = 0

@onready var character = get_parent() as Character
@onready var agent = character.get_node("NavigationAgent2D")
@onready var hud = GameManager.current_level.get_node("Camera2D").get_child(0).get_child(0)
@onready var ray = get_node("RayCast2D")
@onready var player = GameManager.main_player

func _ready():
	set_physics_process(false)
	if route.size() == 0:
		set_process(false)
		return
		
	agent.target_position = route[0]
	
	await get_tree().create_timer(wait_time).timeout
	set_physics_process(true)
	
func _process(_delta):
	ray.rotation = atan2(-character.horiDir, character.vertDir)
	if ray.get_collider() == player && !player.camouflaged:
		#hud._set_text_box(portrait, default_text)
		emit_signal("OnNotice", true)
		#set_process(false)
		# TODO: Make guards call out player before closing door

func _physics_process(delta):
	if character.global_position.distance_to(agent.get_final_position()) < 5:
		_get_new_route()
	var direction = to_local(agent.get_next_path_position()).normalized()
	character.vertDir = direction.y
	character.horiDir = direction.x	
	
func _get_new_route():
	set_physics_process(false)
	character.set_physics_process(false)
	progress += 1
	if progress >= route.size():
		progress = 0
	agent.target_position = route[progress]
	await get_tree().create_timer(wait_time).timeout
	set_physics_process(true)
	character.set_physics_process(true)
	
func _enable(_bool : bool):
	set_process(true)
