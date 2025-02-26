extends Pawn
class_name Event

@export var move_route: Array[Vector2i]
@onready var max_moves = move_route.size()
var current_move = 0

func _ready() -> void:
	if move_route: cur_direction = move_route[0]
	if $GameStateHelper: $GameStateHelper.loading_data.connect(_on_loading_data)
	
func _on_loading_data(data: Dictionary):
	if collidable:
		manager.pawn_coll_manager.set_cell(Utils.snapped_pos(position),-1,Vector2i.ZERO)
		manager.pawn_coll_manager.set_cell(coll_pos,1,Vector2i.ZERO)
	is_moving = true
	move_tween = create_tween()
	move_tween.tween_property(self,"position",Utils.unsnapped_pos(coll_pos),(1.0/speed)*(position.distance_to(Utils.unsnapped_pos(coll_pos))/Constants.tile_size))
	move_tween.tween_callback(_tween_pos_done)
	move_tween.play()
	await move_tween.finished
	
func _physics_process(delta: float) -> void:
	if can_move():
		if space_free(move_route[current_move]):
			move_by(move_route[current_move])
		else:
			return
		current_move += 1
		if current_move >= max_moves: current_move = 0

func _tween_pos_done():
	super()
	if space_free(move_route[current_move]):
		move_by(move_route[current_move])
	else:
		return
	current_move += 1
	if current_move >= max_moves: current_move = 0
