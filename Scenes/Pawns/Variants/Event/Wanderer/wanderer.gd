extends Event
class_name Wanderer

func _ready() -> void:
	super()
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
		var dir_h: int = randi_range(-1,1)
		var dir_v: int = randi_range(-1,1) if not dir_h else 0
		if not dir_h and not dir_v: wait(1.0)
		else: move_by(Vector2i(dir_h,dir_v))
