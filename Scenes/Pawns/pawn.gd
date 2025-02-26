extends Node2D
class_name Pawn

@export var collidable := false
@export var speed := 1.0

var move_tween: Tween
var is_moving: bool
var cur_direction: Vector2i = Vector2i.DOWN

@onready var manager: PawnManager = get_parent()
@onready var coll_pos: Vector2i = Utils.snapped_pos(position)

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
	return manager.coll_manager.get_cell_source_id(Utils.snapped_pos(position)+dir) == -1 and (manager.pawn_coll_manager.get_cell_source_id(Utils.snapped_pos(position)+dir) == -1 or not collidable)
	
func move_by(dir: Vector2i):
	var snapped_pos = Utils.snapped_pos(position)
	if collidable:
		manager.pawn_coll_manager.set_cell(snapped_pos,-1,Vector2i.ZERO)
		manager.pawn_coll_manager.set_cell(snapped_pos+dir,1,Vector2i.ZERO)
	coll_pos = snapped_pos+dir
	tween_pos(position+Vector2(dir*16))

func check_and_move_by(dir: Vector2i):
	if space_free(dir):
		move_by(dir)

func move_to(where: Vector2i):
	if collidable:
		manager.pawn_coll_manager.set_cell(Utils.snapped_pos(position),-1,Vector2i.ZERO)
		manager.pawn_coll_manager.set_cell(where,1,Vector2i.ZERO)
	coll_pos = where
	tween_pos(Utils.unsnapped_pos(where))
