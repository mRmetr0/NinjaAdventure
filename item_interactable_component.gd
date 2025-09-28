extends InteractComponent

class_name ItemInteract

@export var possible_items : Array[ItemResource] = []

func _ready():
	player.connect("UseItemInteract", _on_player_item_interact)
	
func _on_player_item_interact(item : ItemResource):
	if !_get_player_close():
		return
	for pos_item in possible_items:
		if pos_item.item_name == item.item_name:
			OnInteract.emit()
			_trigger_interact()
			print("USED CORRECT ITEM")

