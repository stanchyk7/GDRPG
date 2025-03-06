extends PawnAnim
class_name Player

const MOVEMENTS: Dictionary = {
	'ui_up': Vector2i.UP,
	'ui_left': Vector2i.LEFT,
	'ui_right': Vector2i.RIGHT,
	'ui_down': Vector2i.DOWN 
	}

# Movement Related (+ animation)
var input_history: Array[String] = []

func _ready() -> void:
	print(manager.get_pawns_at(Utils.snapped_pos(position))[0].name)
	
func get_ev_dialogue(ev: Array):
	if ev: 
		ev[0].trigger_dialogue()
		is_talking = true
		ev[0].is_talking = true
		await DialogueManager.dialogue_ended
		await get_tree().create_timer(0.01).timeout
		is_talking = false
		ev[0].is_talking = false

func _tween_pos_done():
	super()
	var ev = manager.get_talkable_pawns_at(Utils.snapped_pos(position), 1)
	get_ev_dialogue(ev)

func _process(_delta):
	input_priority()
	
	if can_move():
		
		if Input.is_action_just_pressed("ui_cancel"):
			$/root/Game/CanvasLayer/pause.visible = true
			$/root/Game/CanvasLayer/pause/VBoxContainer/resume.grab_focus()
			get_tree().paused = true
		elif Input.is_action_just_pressed("ui_accept"):
			var ev = manager.get_talkable_pawns_at(Utils.snapped_pos(position)+cur_direction, 0)
			get_ev_dialogue(ev)
		
		var input_direction: Vector2i = set_direction()
		if input_direction:
			cur_direction = input_direction
			set_anim_direction(cur_direction)
			move_by(cur_direction)

func input_priority():
	# Input prioritie system, prioritize the latest inputs
	for direction in MOVEMENTS.keys():
		if Input.is_action_just_released(direction):
			var index: int = input_history.find(direction)
			if index != -1:
				input_history.remove_at(index)
		
		if Input.is_action_just_pressed(direction):
			input_history.append(direction)

func set_direction() -> Vector2i:
	# Handles the movement direction depending on the inputs
	var direction: Vector2i = Vector2i()
	
	if input_history.size():
		for i in input_history:
			direction += MOVEMENTS[i]
		
		match(input_history.back()):
			'ui_right', 'ui_left': if direction.x != 0: direction.y = 0
			'ui_up', 'ui_down': if direction.y != 0: direction.x = 0
	
	return direction
