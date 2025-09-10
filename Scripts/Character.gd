extends CharacterBody2D

class_name Character

signal ChangeHealth(new_health : int)
signal ChangeWeapon (new_weapon : WeaponResource)
#Default variabels
@export var max_health : int = 8
@onready var health : int = max_health
@export var moveSpeed = 40
#Sprite variables
@export var portrait : Texture		
@export var sprite_sheet : Texture2D
@export var update_sprite_sheet : bool
var current_color_state = Color.WHITE

@export var weapon : WeaponResource
var canAct = true
@onready var animator : BaseAnimator = get_node("AnimationPlayer")
#status effects:
var raged = false;
var frozen = false;
@onready var rage_component : StatusComponent = get_node("RageComponent")

#Private variables
var vertDir : float
var horiDir : float

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
	var weapon_collider = get_node("WeaponArea2D/WeaponCollider")
	var weapon_sprite = get_node ("WeaponArea2D/WeaponCollider/WeaponSprite")
	weapon_sprite.texture = weapon.weapon_sprite
	var texture_size = Vector2(weapon_sprite.texture.get_width(), weapon_sprite.texture.get_height())
	weapon_collider.shape.extents = texture_size/2 + Vector2.ONE
	weapon_collider.position.y = -texture_size.y/2
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
		SoundManager.play_sound(SoundManager.SOUND.HURT)
		animator.play("hurt", -1, stun_lock)
		await get_tree().create_timer(stun_lock).timeout
		canAct = true
	else:
		SoundManager.play_sound(SoundManager.SOUND.DIE)
		set_process(false)
		set_physics_process(false)
		var col = get_node("WalkingCollider")
		col.call_deferred("set_disabled", true)
		animator.play("die")

func _attack(direction : Vector2):
	if !canAct: 
		return
	var attack_sound = SoundManager.SOUND.H_ATTACK if weapon.heavy_weapon else SoundManager.SOUND.L_ATTACK
	SoundManager.play_sound(attack_sound)
	canAct = false
	var duration = animator._set_attack(direction, weapon.heavy_weapon)
	await get_tree().create_timer(duration).timeout
	canAct = true

func _color_hurt():
	animator.sprite.modulate = Color.RED
	await get_tree().create_timer(0.3).timeout
	animator.sprite.modulate = current_color_state

func _handle_rage(apply : bool, duration = -1):
	rage_component._handle_status(apply, duration)


func _enable(extra_arg_0):
	pass # Replace with function body.
