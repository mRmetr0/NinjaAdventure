extends Node
class_name DialogueManager

enum DiaState{
	TALKING,
	RESPONDING
}
var current_state : DiaState = DiaState.TALKING

@onready var ui : GameUI = get_viewport().get_camera_2d().get_child(0).get_child(0)
@onready var dialogue = ui.get_node("Dialogue")
@onready var portrait_box = ui.get_node("Dialogue/Portrait")
@onready var text_box = ui.get_node("Dialogue/Text")
@onready var response_container = ui.get_node("Dialogue/Responses")

@onready var current_dialogue : Dialogue = get_child(0)
var dialogue_count : int = 0
var highlighed_option : int = -1

func _ready():
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	set_process_input(false)

func _input(_event):
	match current_state:
		DiaState.TALKING:
			if Input.is_action_just_pressed("interact"):
				next_line()
		DiaState.RESPONDING:
			if Input.is_action_just_pressed("act_left"):
				choose_response(0)
			elif Input.is_action_just_pressed("act_down"):
				choose_response(1)
			elif Input.is_action_just_pressed("act_right"):
				choose_response(2)
			elif Input.is_action_just_pressed("act_up"):
				choose_response(3)

func start_dialogue(new_dialogue : Dialogue = null):
	if new_dialogue == null:
		current_dialogue = get_child(0)
	else:
		current_dialogue = new_dialogue
	get_tree().paused = true
	response_container.hide()
	
	current_state = DiaState.TALKING
	dialogue_count = 0
	text_box.lines_skipped = 0
	text_box.text = current_dialogue.dialogue
	portrait_box.texture = current_dialogue.portrait
	
	response_container.hide()
	dialogue.show()
	await get_tree().create_timer(0.1).timeout
	set_process_input(true)
	
func end_dialogue():
	dialogue.hide()
	get_tree().paused = false
	set_process(false)

func next_line():	
	dialogue_count += 1
	if dialogue_count * 3 >= text_box.get_line_count(): 
		#END OF DIALOGUE
		if current_dialogue.get_responses().size() == 0:
			end_dialogue()
		else:
			show_responses()
	else:
		#NEXT LINE
		text_box.lines_skipped = dialogue_count * 3
	
func show_responses():
	current_state = DiaState.RESPONDING
	highlighed_option = -1
	var responses = current_dialogue.get_responses()
	for i in response_container.get_child_count():
		var child = response_container.get_child(i)
		if i > responses.size()-1:
			child.hide()
			continue
		var text = child.get_child(0) as Label
		text.text = responses[i]
		child.modulate = Color.WHITE
		child.show()
	response_container.show()

func choose_response(index : int):
	if index < 0 || index > current_dialogue.get_responses().size():
		return
	if index == highlighed_option:
		current_dialogue.choose_response(index)
	else:
		var counter = 0
		highlighed_option = index
		for child in response_container.get_children():
			if index == counter:
				child.modulate = Color.GRAY
			else:
				child.modulate = Color.WHITE
			counter += 1
			
