extends Node2D

class_name EnemyBehaviour

@export var resetable : bool

@onready var enemy : Character = get_parent()
@onready var player : Character = GameManager.main_player
@onready var agent : NavigationAgent2D = enemy.get_node("NavigationAgent2D")
@onready var base_pos = enemy.position

func _ready():
	enemy.behaviours.append(self)

func _physics_process(_delta):	
	if enemy.position.distance_to(agent.get_final_position()) < 5:
		_on_timer_timeout()
	var direction = enemy.to_local(agent.get_next_path_position()).normalized()
	enemy.vertDir = direction.y
	enemy.horiDir = direction.x	
	
	var toPlayer = enemy.global_position - player.global_position
	if enemy.position.distance_to(player.position) < 20:
		enemy._attack(toPlayer * -1)

func _on_timer_timeout():
	agent.target_position = player.position

func _reset():
	enemy.position = base_pos
	enemy._set_health(enemy.max_health)
	enemy.set_process(true)
	enemy.set_physics_process(true)
	set_process(true)
	set_physics_process(true)
	var col = enemy.get_node("WalkingCollider")
	col.call_deferred("set_disabled", false)
	enemy.canAct = true

func _on_screen():
	set_physics_process(true)

func _off_screen():
	if resetable:
		await get_tree().create_timer(0.15).timeout
		_reset()
	set_physics_process(false)
