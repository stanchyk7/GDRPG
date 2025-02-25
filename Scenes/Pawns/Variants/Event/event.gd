extends Pawn
class_name Event

var dir = Vector2.RIGHT

func _ready() -> void:
	cur_direction = dir

func _physics_process(delta: float) -> void:
	if can_move():
		check_and_move_by(cur_direction)

func _tween_pos_done():
	super()
	if not space_free(dir): dir *= -1
	cur_direction = dir
