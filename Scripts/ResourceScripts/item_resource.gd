extends BaseResource

class_name ItemResource

enum effects {
	HEAL_HEALTH,
	RESTORE_ENERGY,
	QUEST,
	NULL
}

@export var icon : Texture2D
@export var id : int = -1
@export var expendable : bool
@export var stay_in_menu : bool
# on use data
@export var effect : effects
@export var value : int
@export var use_sound = SoundManager.SOUND.NULL

func _use_item(player : Player):
	SoundManager.play_sound(use_sound)
	
	match effect:
		effects.HEAL_HEALTH:
			player._set_health(player.health + value)
		effects.QUEST:
			player.UseItemInteract.emit(self)
			print("USING ITEM: ", item_name)
	if expendable:
		var is_empty : bool = SaveManager.current_save_resource.lose_item(id) <= 0
		if is_empty:	# REMOVE ITEM FROM PLAYER LIST
			player._set_item(null)
