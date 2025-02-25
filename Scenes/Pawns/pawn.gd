extends Node2D
class_name Pawn

@export var collidable := false
@export var speed := 1.0

var move_tween: Tween
var is_moving: bool
var cur_direction: Vector2i = Vector2i.DOWN

@onready var manager: PawnManager = get_parent()

func can_move() -> bool:
	return not is_moving

func tween_pos(new_pos: Vector2):
	is_moving = true
	move_tween = create_tween()
	move_tween.tween_property(self,"position",new_pos,1.0/speed)
	move_tween.tween_callback(_tween_pos_done)
	move_tween.play()
	await move_tween.finished

func _tween_pos_done():
	move_tween.kill()
	is_moving = false
	
func space_free(dir: Vector2i):
	return manager.coll_manager.get_cell_source_id(Vector2i(floor(position/16.0))+dir) == -1 and manager.pawn_coll_manager.get_cell_source_id(manager.get_converted_pos(position)+dir) == -1
	
func move_by(dir: Vector2i):
	manager.pawn_coll_manager.set_cell(manager.get_converted_pos(position),-1,Vector2i.ZERO)
	manager.pawn_coll_manager.set_cell(manager.get_converted_pos(position)+dir,1,Vector2i.ZERO)
	tween_pos(position+Vector2(dir*16))

func check_and_move_by(dir: Vector2i):
	if space_free(dir):
		move_by(dir)

func move_to(where: Vector2i):
	manager.pawn_coll_manager.set_cell(manager.get_converted_pos(position),-1,Vector2i.ZERO)
	manager.pawn_coll_manager.set_cell(manager.get_converted_pos(where),1,Vector2i.ZERO)
	tween_pos(Vector2(where*16))
