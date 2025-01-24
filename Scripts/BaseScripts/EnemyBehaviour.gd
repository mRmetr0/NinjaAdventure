extends Character

class_name EnemyBehaviour

@export var resetable : bool

@onready var player = get_parent().get_node("Player")
@onready var agent = get_node("NavigationAgent2D")
@onready var base_pos = position

func _physics_process(delta):	
	if position.distance_to(agent.get_final_position()) < 5:
		_on_timer_timeout()
	var direction = to_local(agent.get_next_path_position()).normalized()
	vertDir = direction.y
	horiDir = direction.x	
	
	var toPlayer = global_position - player.global_position
	if position.distance_to(player.position) < 20:
		_attack(toPlayer * -1)
	
	super._physics_process(delta)
	
func _on_timer_timeout():
	agent.target_position = player.position

func _reset():
	position = base_pos
	_set_health(max_health)
	set_process(true)
	set_physics_process(true)
	var col = get_node("WalkingCollider")
	col.call_deferred("set_disabled", false)
	canAct = true

func _on_screen():
	set_physics_process(true)

func _off_screen():
	if resetable:
		_reset()
	set_physics_process(false)
