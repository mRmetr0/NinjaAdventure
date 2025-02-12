extends Control

class_name GameUI

@onready var weapon_display : TextureRect = get_node("WeaponBackground/WeaponSprite")
@onready var item_display : TextureRect = get_node("ItemBackground/ItemSprite")
@onready var money_icon : TextureRect = get_node("MoneyIcon")
@onready var money_display : Label = get_node("MoneyIcon/MoneyCounter")

@onready var dialogue = get_node("Dialogue")
@onready var portrait_box = get_node("Dialogue/Portrait")
@onready var text_box = get_node("Dialogue/Text")

@onready var pause_menu = get_node("PauseScreen")

var heart_sprites : Array
var dialogue_count = 0

func _ready():	
	dialogue.hide()
	pause_menu.hide()
	set_process(false)
	# get all heart sprites
	var container = get_node("HealthContainer")
	for child in container.get_children():
		var sprite = child.get_child(0)
		heart_sprites.append(sprite)

func _update_health_ui(new_health : int):
	new_health = max(0, new_health)
	
	for sprite in heart_sprites:
		sprite.set_frame(4)
	
	for sprite in heart_sprites:
		if (new_health - 4 >= 0):
			sprite.set_frame(0)
			new_health -= 4
		else:
			sprite.set_frame(4-new_health)
			new_health = 0
			break
	if (new_health > 0):
		print("TOO MUCH HEALTH")

func update_money_ui(newValue: int, newSprite: Texture2D = null):
	money_display.text = str(newValue)
	if newSprite != null:
		money_icon.texture = newSprite
		
func _update_weapon_ui(newWeapon : WeaponResource):
	if newWeapon == null:
		weapon_display.get_parent().hide()
	else:
		weapon_display.get_parent().show()
		weapon_display.texture = newWeapon.icon

func _update_item_ui(newItem : ItemResource):
	if newItem == null || (newItem.expendable && newItem.expendable_amount <= 0):
		item_display.get_parent().hide()
	else:
		item_display.get_parent().show()
		item_display.texture = newItem.icon
	
func _set_text_box(portrait: Texture = null, text : String = "null"):
	if (portrait == null && text == "null"):
		return
		
	text_box.lines_skipped = 0
	get_tree().paused = true
	text_box.text = text
	portrait_box.texture = portrait
	dialogue.show()
	await get_tree().create_timer(0.1).timeout
	set_process(true)
	
func _get_next_line():
	dialogue_count += 1
	if dialogue_count * 3 >= text_box.get_line_count():
		dialogue.hide()
		get_tree().paused = false
		set_process(false)
		dialogue_count = 0
	else:
		text_box.lines_skipped = dialogue_count * 3

func _process(_delta):
	if (get_tree().paused):
		if Input.is_action_just_pressed("interact"):
			#_set_text_box()
			_get_next_line()
			
func _input(event):
	if Input.is_action_just_pressed("menu"):
		get_tree().paused = !get_tree().paused
		if get_tree().paused:
			pause_menu.on_show()
			pause_menu.show()
		else:
			pause_menu._apply_changes()
			pause_menu.hide()
