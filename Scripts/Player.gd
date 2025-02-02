extends Character

class_name Player

@export var item : ItemResource
@export var suit : SuitResource

var smoke = preload("res://Scenes/Objects/FXPlayer.tscn")
var camouflaged = false
var parrying = false

signal Interact
signal ChangeItem

func _ready ():
	var hud = get_parent().get_node("Camera2D").get_child(0).get_child(0)
	if (hud != null):
		connect("ChangeWeapon", hud._update_weapon_ui)
		connect("ChangeHealth", hud._update_health_ui)
		connect("ChangeItem", hud._update_item_ui)
	else:
		print("NO HUD FOUND")
	
	if (GameManager.player_health == -1):
		GameManager.player_health = health
		GameManager.player_weapon = weapon
		GameManager.player_item = item
		GameManager.player_suit = suit
	else:
		health = GameManager.player_health
		weapon = GameManager.player_weapon
		item = GameManager.player_item
		suit = GameManager.player_suit
	_set_health(health)
	_set_weapon(weapon)
	_set_item(item)
	_set_suit(suit)

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
		
func _handle_item_used(): #TODO: REMOVE DAMAGE TAKEN AND IMPLEMENT ITEM USAGE
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
		
func reset_state():
	suit._reset_suit_ability()
	animator.stop()
	animator.play("RESET")
	animator.play("idle")
