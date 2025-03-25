extends Node2D
class_name Pawn

@export var collidable := false
@export var speed := 1.0

var move_tween: Tween
var cur_direction: Vector2i = Vector2i.DOWN

var is_moving: bool = false
var is_talking: bool = false
var is_stopped: bool = false

@onready var manager: PawnManager = get_parent()
@onready var coll_pos: Vector2i = Utils.snapped_pos(position)
@onready var actor: PawnAnim = get_node_or_null("Actor")

func can_move() -> bool:
	return not is_moving and not is_talking and not is_stopped

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
	
func force_move_by(dir: Vector2i):
	var snapped_pos = Utils.snapped_pos(position)
	change_coll_pos(snapped_pos+dir)
	if actor: actor.tween_pos(position+Vector2(dir*16))
	else: 
		tween_pos(position+Vector2(dir*16))
		await move_tween.finished

func move_by(dir: Vector2i):
	if space_free(dir):
		if actor: 
			actor.force_move_by(dir) 
		else: 
			force_move_by(dir)
		await move_tween.finished
		
func change_coll_pos(where: Vector2i):
	if collidable:
		manager.pawn_coll_manager.set_cell(Utils.snapped_pos(position),-1,Vector2i.ZERO)
		manager.pawn_coll_manager.set_cell(where,1,Vector2i.ZERO)
	coll_pos = where

func move_to(where: Vector2i, tween: bool):
	change_coll_pos(where)
	if tween:
		if actor: 
			actor.tween_pos(Utils.unsnapped_pos(where))
		else: 
			tween_pos(Utils.unsnapped_pos(where))
	else:
		position = Utils.unsnapped_pos(where)
	
func wait(duration: float):
	is_stopped = true
	await get_tree().create_timer(duration).timeout
	is_stopped = false

func change_sprite(new_texture: String):
	if actor:
		$Actor/Sprite2D.texture = null if new_texture.is_empty() else load("res://Graphics/"+new_texture)
		return
		
	var spr: Sprite2D = get_node_or_null("./Sprite2D")
	if not spr:
		var new_spr := Sprite2D.new()
		add_child(new_spr)
	spr.texture = null if new_texture.is_empty() else load("res://Graphics/"+new_texture)
