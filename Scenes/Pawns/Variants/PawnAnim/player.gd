extends Walker
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
	if $PlayerStateHelper: $PlayerStateHelper.loading_data.connect(_on_loading_data)
	DialogueManager.dialogue_started.connect(_on_dialogue_started)
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
	default_move_route = []
	
	print(manager.get_pawns_at(Utils.snapped_pos(position))[0].name)
	
func _on_loading_data(data: Dictionary):
	actor.set_anim_direction(cur_direction)
	change_coll_pos(coll_pos)
	move_to(coll_pos, false)
	if is_talking:
		await DialogueManager.dialogue_ended
		wait(0.1)
		is_talking = false
	is_moving = false
	
func _on_dialogue_started(_resource: DialogueResource):
	move_route = []
	is_talking = true

func _on_dialogue_ended(_resource: DialogueResource):
	await get_tree().create_timer(0.02).timeout
	is_talking = false
	
func get_ev_dialogue(ev: Array):
	if ev: 
		if ev[0].actor: ev[0].actor.set_anim_direction(-cur_direction)
		ev[0].trigger_dialogue()

func _tween_pos_done():
	super()
	var ev = manager.get_talkable_pawns_at(Utils.snapped_pos(position), 1)
	get_ev_dialogue(ev)

func _physics_process(_delta):
	input_priority()
	
	move_route = []
	
	if can_move():
		
		if Input.is_action_just_pressed("ui_cancel"):
			var pause = get_node(Constants.pause_path)
			pause.visible = true
			pause.get_node("PanelContainer/MarginContainer/VBoxContainer/resume").grab_focus()
			get_tree().paused = true
		elif Input.is_action_just_pressed("ui_accept"):
			var ev = manager.get_talkable_pawns_at(Utils.snapped_pos(position)+cur_direction, 0)
			get_ev_dialogue(ev)
		else:
			var input_direction: Vector2i = set_direction()
			if input_direction:
				cur_direction = input_direction
				actor.set_anim_direction(input_direction)
				if space_free(input_direction):
					move_route = [MoveBy.new(input_direction)]
	
	super(_delta)
	
	

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
