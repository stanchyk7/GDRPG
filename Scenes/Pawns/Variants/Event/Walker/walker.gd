extends Event
class_name Walker

@export var default_move_route: Array[Movement] = [Wander.new()]
var move_route: Array[Movement] = []
@onready var max_moves = move_route.size()
var current_move = 0

func _ready() -> void:
	super()
	if $GameStateHelper: $GameStateHelper.loading_data.connect(_on_loading_data)
	
func _on_loading_data(data: Dictionary):
	if actor:
		actor.set_anim_direction(cur_direction)
		actor.animtree.set("parameters/TimeScale/scale", speed)
		actor.animtree["parameters/StateMachine/playback"].start("Walk1" if actor.switch_walk else "Walk0")
		actor.animtree.advance(0)
	if collidable:
		manager.pawn_coll_manager.set_cell(Utils.snapped_pos(position),-1,Vector2i.ZERO)
		manager.pawn_coll_manager.set_cell(coll_pos,1,Vector2i.ZERO)
	is_moving = true
	move_tween = create_tween()
	move_tween.tween_property(self,"position",Utils.unsnapped_pos(coll_pos),((actor.walk_anim_length/speed) if actor else (1.0/speed))*(position.distance_to(Utils.unsnapped_pos(coll_pos))/Constants.tile_size))
	move_tween.tween_callback(_tween_pos_done)
	move_tween.play()
	await move_tween.finished
	
func _physics_process(delta: float) -> void:
	if can_move():
		if move_route:
			
			match move_route[0].get_script().get_global_name():
				"MoveBy":
					var mv_val: Vector2i = move_route[0].dir
					if space_free(mv_val):
						
						if actor: 
							actor.set_anim_direction(mv_val)
							actor.force_move_by(mv_val)
						else: force_move_by(mv_val)
					else:
						return
				"Wander":
					var dir_h: int = randi_range(-1,1)
					var dir_v: int = randi_range(-1,1) if not dir_h else 0
					if not dir_h and not dir_v: wait()
					else: move_by(Vector2i(dir_h,dir_v))
			move_route.pop_front()
		else:
			move_route = default_move_route.duplicate(true)
