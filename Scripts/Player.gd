extends Character

class_name Player

@export var item : ItemResource
@export var suit : SuitResource
var coins : int = 0

var smoke = preload("res://Scenes/Objects/Effects/smoke_effect.tscn")
var counter = preload("res://Scenes/Objects/Effects/single_particle.tscn")
var camouflaged = false
var parrying = false
@onready var parry_hitbox : CollisionShape2D = get_node("ParryHitbox/CollisionShape2D")

signal Interact
signal ChangeItem
signal ChangeCoins

func _ready ():
	setup_ui()
	
func setup_ui(game_ui : GameUI = null):
	if game_ui == null:
		game_ui = get_parent().get_node("Camera2D").get_child(0).get_child(0)
	if (game_ui != null):
		connect("ChangeWeapon", game_ui._update_weapon_ui)
		connect("ChangeHealth", game_ui._update_health_ui)
		connect("ChangeItem", game_ui._update_item_ui)
		connect("ChangeCoins", game_ui.update_money_ui)
	else:
		print("NO HUD FOUND")
	_set_health(health)
	_set_weapon(weapon)
	_set_item(item)
	_set_suit(suit)
	set_coins(coins)

func _physics_process(delta):
	if (Input.is_action_just_pressed("interact")):
		emit_signal("Interact")
	if (Input.is_action_just_pressed("use_item")):
		_handle_item_used()
	if (Input.is_action_just_pressed("use_ability")):
		if suit != null:
			suit.suit_ability()

	_handle_movement_inputs(delta)
	_handle_attack_input()
	
func _take_damage(damage : int, stun_lock = 1.0):
	if parrying:
		SoundManager.play_sound(SoundManager.SOUND.H_ATTACK)
		ParticleManager._play_particle(ParticleManager.parry_counter, \
			animator.sprite.global_position + Vector2(0, 3), \
			9, Vector2(1.1, 1.2), 1.5)
		parry_hitbox.set_deferred("disabled", false)
		await get_tree().create_timer(0.2).timeout
		parry_hitbox.set_deferred("disabled", true)
		return
	super._take_damage(damage, stun_lock)
	
func _handle_movement_inputs(delta):
	vertDir = Input.get_axis("up", "down")
	horiDir = Input.get_axis("left", "right")
	super._physics_process(delta)
	
func _handle_attack_input():
	if (weapon == null):
		return
	var vertAct = Input.get_axis("act_up","act_down")
	var horiAct = Input.get_axis("act_left","act_right")
	var direction = Vector2(horiAct, vertAct)
	if direction.length() > 0:
		_attack (direction)
		
func _handle_item_used():
	_take_damage(1)
	if (item != null):
		item._use_item(self)

func _set_item(_item : ItemResource):
	item = _item
	emit_signal("ChangeItem", _item)
	
func _set_suit(_suit : SuitResource):
	if _suit != null:
		suit = _suit
		suit._set_suit(self)
		
func set_coins(value_change : int, new_text : Texture2D = null):
	coins += value_change
	emit_signal("ChangeCoins", coins)
		
func reset_state():
	suit._reset_suit_ability()
	animator.stop()
	animator.play("RESET")
	animator.play("idle")
