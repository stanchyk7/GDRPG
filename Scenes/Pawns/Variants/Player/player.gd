extends Pawn
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

func _tween_pos_done():
	super()
	print(manager.get_pawns_at(Utils.snapped_pos(position)))

func _process(_delta):
	input_priority()
	
	if can_move():
		
		if Input.is_action_just_pressed("ui_cancel"):
			$/root/Game/CanvasLayer/pause.visible = true
			get_tree().paused = true
		
		var input_direction: Vector2i = set_direction()
		if input_direction:
			cur_direction = input_direction
			check_and_move_by(cur_direction)

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
