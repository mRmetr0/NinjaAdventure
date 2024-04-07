extends CharacterBody2D

class_name Character

signal ChangeHealth(new_health : int)
signal ChangeWeapon (new_weapon : WeaponResource)

@export var max_health = 8
@onready var health = max_health
@export var moveSpeed = 40

@export var portrait : Texture		
@export var sprite_sheet : Texture2D
@export var update_sprite_sheet : bool

@export_multiline var default_text : String

var vertDir : float
var horiDir : float

@export var weapon : WeaponResource
var canAct = true

@onready var animator = get_node("AnimationPlayer")

func _ready():
	_set_weapon(weapon)

func _physics_process(_delta):	
	if Engine.is_editor_hint():
		return
	
	if canAct:
		_handle_movement(_delta)

func _handle_movement(_delta):	
	var moveDirection = Vector2(horiDir, vertDir)
	velocity = moveDirection.normalized() * moveSpeed * 100 * _delta 
	animator._set_walk_animation(moveDirection)
	move_and_slide()
	
func _set_weapon(newWeapon : WeaponResource):
	if newWeapon == null:
		emit_signal("ChangeWeapon", null)
		return
	weapon = newWeapon
	weapon.character = self
	var weapon_sprite = get_node ("WeaponArea2D/WeaponCollider/WeaponSprite")
	weapon_sprite.texture = weapon.weapon_sprite
	emit_signal("ChangeWeapon", weapon)
	
func _set_health(newHealth : int):
	health = newHealth
	health = clampi(health, 0, max_health)
	emit_signal("ChangeHealth", health)
	
func _take_damage(damage : int, stun_lock = 1.0):
	_set_health(health - damage)
	stun_lock = max(stun_lock, 0.3)
	canAct = false
	if (health > 0):
		animator.play("hurt", -1, stun_lock)
		await get_tree().create_timer(stun_lock).timeout
		canAct = true
	else:
		set_process(false)
		set_physics_process(false)
		var col = get_node("WalkingCollider")
		col.call_deferred("set_disabled", true)
		animator.play("die")

func _attack(direction : Vector2):
	if !canAct: 
		return
	canAct = false
	var duration = animator._set_attack(direction, weapon.heavy_weapon)
	await get_tree().create_timer(duration).timeout
	canAct = true
