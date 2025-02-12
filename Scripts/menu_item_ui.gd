extends Sprite2D

class_name MenuItemUI

@export var item : BaseResource
@export var can_quit : bool = false

@export var item_title : String
@export_multiline var item_desc : String

var item_icon : Texture
var item_text : Label
var lock_quit = false

func _ready():
	if can_quit:
		item_text = get_node("Label")
		return
		
	if item == null:
		queue_free()
	
	if item is WeaponResource:
		item_icon = item.icon
		
	elif item is SuitResource:
		item_icon = item.portrait
		
	elif item is ItemResource:
		item_icon = item.icon
	texture = item_icon
	
	item_title = item.item_name
	item_desc = item.descripton
	
func on_hover_quit(hovering = false):
	self_modulate = Color(0.2,0.2,0.2) if hovering else Color.WHITE
	if hovering:
		item_text.modulate = Color.WHITE
	else:
		lock_quit = false
		item_text.text = "QUIT"
		item_text.modulate = Color.BLACK 

func on_select_quit():
	if lock_quit:
		item_text.text = "SAVING"
		SaveManager.save_data(SaveManager.current_save_file)
		await get_tree().create_timer(0.1).timeout
		get_tree().quit()
		pass
	else:
		item_text.text = "SURE?"
		lock_quit = true
